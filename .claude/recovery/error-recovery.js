/**
 * Error Recovery System for Claude Agent System
 * Provides automatic error recovery, snapshots, and rollback capabilities
 */

const fs = require('fs').promises;
const path = require('path');
const { exec } = require('child_process').promisify;
const crypto = require('crypto');

class ErrorRecovery {
  constructor(config = {}) {
    this.maxRetries = config.maxRetries || 3;
    this.backoffMs = config.backoffMs || [1000, 3000, 9000];
    this.snapshotDir = config.snapshotDir || path.join(__dirname, 'snapshots');
    this.errorPatternsFile = config.errorPatternsFile || path.join(__dirname, 'error-patterns.json');
    this.recoveryLogFile = config.recoveryLogFile || path.join(__dirname, 'logs', 'recovery.log');
    
    // Recovery strategies
    this.strategies = {
      retry: this.retryStrategy.bind(this),
      rollback: this.rollbackStrategy.bind(this),
      fix: this.fixStrategy.bind(this),
      skip: this.skipStrategy.bind(this),
      manual: this.manualStrategy.bind(this)
    };
    
    // Load error patterns
    this.loadErrorPatterns();
    
    // Recovery statistics
    this.stats = {
      totalErrors: 0,
      recovered: 0,
      failed: 0,
      rollbacks: 0,
      fixes: 0
    };
  }

  /**
   * Execute function with automatic recovery
   */
  async executeWithRecovery(fn, context = {}) {
    const startTime = Date.now();
    const snapshotId = await this.createSnapshot(context);
    
    try {
      // Try to execute the function
      const result = await this.tryExecute(fn, context);
      
      // Success - clean up snapshot if not needed
      if (context.keepSnapshot !== true) {
        await this.cleanupSnapshot(snapshotId);
      }
      
      return result;
    } catch (error) {
      // Log error
      await this.logError(error, context);
      this.stats.totalErrors++;
      
      // Try recovery
      const recovered = await this.attemptRecovery(error, fn, context, snapshotId);
      
      if (recovered.success) {
        this.stats.recovered++;
        return recovered.result;
      } else {
        this.stats.failed++;
        
        // Rollback if recovery failed
        if (context.autoRollback !== false) {
          await this.rollback(snapshotId);
        }
        
        throw new Error(`Recovery failed: ${error.message}`);
      }
    } finally {
      const duration = Date.now() - startTime;
      await this.logRecovery(context, duration);
    }
  }

  /**
   * Try to execute function with retries
   */
  async tryExecute(fn, context) {
    let lastError;
    
    for (let attempt = 0; attempt < this.maxRetries; attempt++) {
      try {
        return await fn();
      } catch (error) {
        lastError = error;
        
        // Check if error is retryable
        if (!this.isRetryable(error)) {
          throw error;
        }
        
        // Wait before retry (exponential backoff)
        if (attempt < this.maxRetries - 1) {
          await this.wait(this.backoffMs[attempt] || this.backoffMs[this.backoffMs.length - 1]);
          console.log(`Retry attempt ${attempt + 1}/${this.maxRetries}...`);
        }
      }
    }
    
    throw lastError;
  }

  /**
   * Attempt to recover from error
   */
  async attemptRecovery(error, fn, context, snapshotId) {
    // Find matching error pattern
    const pattern = await this.findErrorPattern(error);
    
    if (!pattern) {
      return { success: false };
    }
    
    // Get recovery strategy
    const strategy = this.strategies[pattern.strategy] || this.strategies.retry;
    
    try {
      const result = await strategy(error, fn, context, pattern, snapshotId);
      return { success: true, result };
    } catch (recoveryError) {
      console.error('Recovery strategy failed:', recoveryError);
      return { success: false };
    }
  }

  /**
   * Retry strategy
   */
  async retryStrategy(error, fn, context, pattern) {
    console.log('Applying retry strategy...');
    await this.wait(pattern.waitMs || 2000);
    return await fn();
  }

  /**
   * Rollback strategy
   */
  async rollbackStrategy(error, fn, context, pattern, snapshotId) {
    console.log('Applying rollback strategy...');
    await this.rollback(snapshotId);
    this.stats.rollbacks++;
    
    // Try again after rollback
    return await fn();
  }

  /**
   * Fix strategy - apply automatic fix
   */
  async fixStrategy(error, fn, context, pattern) {
    console.log('Applying fix strategy...');
    
    if (pattern.fix) {
      await this.applyFix(pattern.fix, context);
      this.stats.fixes++;
    }
    
    // Retry after fix
    return await fn();
  }

  /**
   * Skip strategy - skip failing operation
   */
  async skipStrategy(error, fn, context, pattern) {
    console.log('Skipping failing operation...');
    return pattern.defaultValue || null;
  }

  /**
   * Manual strategy - require user intervention
   */
  async manualStrategy(error, fn, context, pattern) {
    console.log('Manual intervention required...');
    
    // In a real implementation, this would notify the user
    throw new Error(`Manual intervention required: ${pattern.message || error.message}`);
  }

  /**
   * Create snapshot before operation
   */
  async createSnapshot(context) {
    const snapshotId = crypto.randomBytes(8).toString('hex');
    const timestamp = new Date().toISOString();
    const snapshotPath = path.join(this.snapshotDir, `snapshot-${snapshotId}.json`);
    
    const snapshot = {
      id: snapshotId,
      timestamp,
      context,
      gitStatus: await this.getGitStatus(),
      files: await this.captureFiles(context.files || []),
      environment: process.env
    };
    
    await fs.mkdir(this.snapshotDir, { recursive: true });
    await fs.writeFile(snapshotPath, JSON.stringify(snapshot, null, 2));
    
    // Also create git stash if in git repo
    try {
      await exec('git stash push -m "auto-snapshot-' + snapshotId + '"');
    } catch (e) {
      // Not a git repo or no changes to stash
    }
    
    return snapshotId;
  }

  /**
   * Rollback to snapshot
   */
  async rollback(snapshotId) {
    console.log(`Rolling back to snapshot ${snapshotId}...`);
    
    const snapshotPath = path.join(this.snapshotDir, `snapshot-${snapshotId}.json`);
    
    try {
      const snapshot = JSON.parse(await fs.readFile(snapshotPath, 'utf8'));
      
      // Restore git state if available
      try {
        await exec('git stash pop');
      } catch (e) {
        // No stash to pop
      }
      
      // Restore captured files
      for (const file of snapshot.files || []) {
        if (file.content !== undefined) {
          await fs.writeFile(file.path, file.content);
        }
      }
      
      console.log('Rollback completed successfully');
      return true;
    } catch (error) {
      console.error('Rollback failed:', error);
      return false;
    }
  }

  /**
   * Load error patterns from file
   */
  async loadErrorPatterns() {
    try {
      const data = await fs.readFile(this.errorPatternsFile, 'utf8');
      this.errorPatterns = JSON.parse(data).patterns || [];
    } catch (error) {
      // Default error patterns
      this.errorPatterns = [
        {
          pattern: "ENOENT.*package\\.json",
          category: "missing_file",
          strategy: "fix",
          fix: {
            action: "create_file",
            file: "package.json",
            content: '{"name": "project", "version": "1.0.0"}'
          }
        },
        {
          pattern: "npm.*E404",
          category: "package_not_found",
          strategy: "skip",
          message: "Package not found in registry"
        },
        {
          pattern: "SyntaxError",
          category: "syntax_error",
          strategy: "rollback",
          message: "Syntax error in code"
        },
        {
          pattern: "ECONNREFUSED",
          category: "connection_error",
          strategy: "retry",
          waitMs: 5000,
          message: "Connection refused, will retry"
        },
        {
          pattern: "ETIMEDOUT",
          category: "timeout",
          strategy: "retry",
          waitMs: 3000,
          message: "Operation timed out"
        },
        {
          pattern: "ENOMEM",
          category: "memory_error",
          strategy: "manual",
          message: "Out of memory"
        }
      ];
      
      // Save default patterns
      await this.saveErrorPatterns();
    }
  }

  /**
   * Save error patterns to file
   */
  async saveErrorPatterns() {
    await fs.mkdir(path.dirname(this.errorPatternsFile), { recursive: true });
    await fs.writeFile(
      this.errorPatternsFile,
      JSON.stringify({ patterns: this.errorPatterns }, null, 2)
    );
  }

  /**
   * Find matching error pattern
   */
  async findErrorPattern(error) {
    const errorString = error.toString();
    
    for (const pattern of this.errorPatterns) {
      const regex = new RegExp(pattern.pattern, 'i');
      if (regex.test(errorString)) {
        return pattern;
      }
    }
    
    return null;
  }

  /**
   * Apply automatic fix
   */
  async applyFix(fix, context) {
    switch (fix.action) {
      case 'create_file':
        await fs.mkdir(path.dirname(fix.file), { recursive: true });
        await fs.writeFile(fix.file, fix.content || '');
        break;
        
      case 'delete_file':
        try {
          await fs.unlink(fix.file);
        } catch (e) {
          // File doesn't exist
        }
        break;
        
      case 'run_command':
        await exec(fix.command);
        break;
        
      case 'modify_file':
        const content = await fs.readFile(fix.file, 'utf8');
        const modified = content.replace(
          new RegExp(fix.search, 'g'),
          fix.replace
        );
        await fs.writeFile(fix.file, modified);
        break;
        
      default:
        console.warn(`Unknown fix action: ${fix.action}`);
    }
  }

  /**
   * Check if error is retryable
   */
  isRetryable(error) {
    const nonRetryable = [
      'SyntaxError',
      'TypeError',
      'ReferenceError'
    ];
    
    return !nonRetryable.includes(error.name);
  }

  /**
   * Get current git status
   */
  async getGitStatus() {
    try {
      const { stdout } = await exec('git status --short');
      return stdout;
    } catch (error) {
      return null;
    }
  }

  /**
   * Capture file contents
   */
  async captureFiles(files) {
    const captured = [];
    
    for (const file of files) {
      try {
        const content = await fs.readFile(file, 'utf8');
        captured.push({ path: file, content });
      } catch (error) {
        captured.push({ path: file, error: error.message });
      }
    }
    
    return captured;
  }

  /**
   * Clean up old snapshot
   */
  async cleanupSnapshot(snapshotId) {
    const snapshotPath = path.join(this.snapshotDir, `snapshot-${snapshotId}.json`);
    
    try {
      await fs.unlink(snapshotPath);
    } catch (error) {
      // Snapshot doesn't exist or already cleaned
    }
  }

  /**
   * Log error to file
   */
  async logError(error, context) {
    const logEntry = {
      timestamp: new Date().toISOString(),
      error: {
        message: error.message,
        stack: error.stack,
        name: error.name
      },
      context
    };
    
    await fs.mkdir(path.dirname(this.recoveryLogFile), { recursive: true });
    await fs.appendFile(
      this.recoveryLogFile,
      JSON.stringify(logEntry) + '\n'
    );
  }

  /**
   * Log recovery attempt
   */
  async logRecovery(context, duration) {
    const logEntry = {
      timestamp: new Date().toISOString(),
      context,
      duration,
      stats: this.stats
    };
    
    await fs.appendFile(
      this.recoveryLogFile,
      JSON.stringify(logEntry) + '\n'
    );
  }

  /**
   * Wait for specified milliseconds
   */
  wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  /**
   * Get recovery statistics
   */
  getStats() {
    return {
      ...this.stats,
      successRate: this.stats.totalErrors > 0
        ? (this.stats.recovered / this.stats.totalErrors * 100).toFixed(2) + '%'
        : '100%'
    };
  }

  /**
   * Add new error pattern
   */
  async addErrorPattern(pattern) {
    this.errorPatterns.push(pattern);
    await this.saveErrorPatterns();
  }
}

module.exports = ErrorRecovery;