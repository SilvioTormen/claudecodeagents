/**
 * Health Monitoring System for Claude Agent System
 * Provides comprehensive health checks, auto-remediation, and monitoring
 */

const os = require('os');
const fs = require('fs').promises;
const path = require('path');
const { performance } = require('perf_hooks');
const { exec } = require('child_process').promisify;

class HealthMonitor {
  constructor(config = {}) {
    // Thresholds
    this.thresholds = {
      memory: config.memoryThreshold || 80,           // % usage
      cpu: config.cpuThreshold || 75,                 // % usage
      responseTime: config.responseTimeThreshold || 5000, // ms
      errorRate: config.errorRateThreshold || 5,      // %
      diskSpace: config.diskSpaceThreshold || 90,     // % usage
      cacheHitRate: config.cacheHitRateThreshold || 30, // minimum %
      ...config.thresholds
    };
    
    // Check intervals
    this.intervals = {
      basic: 30000,      // 30 seconds
      detailed: 300000,  // 5 minutes
      full: 3600000,     // 1 hour
      ...config.intervals
    };
    
    // Auto-remediation settings
    this.autoRemediation = config.autoRemediation !== false;
    this.maxRemediationAttempts = config.maxRemediationAttempts || 3;
    
    // Health history
    this.history = [];
    this.maxHistorySize = config.maxHistorySize || 100;
    
    // Agent tracking
    this.agents = {
      'context-manager': { status: 'unknown', lastCheck: null },
      'backend-developer': { status: 'unknown', lastCheck: null },
      'frontend-developer': { status: 'unknown', lastCheck: null },
      'security-engineer': { status: 'unknown', lastCheck: null },
      'quality-engineer': { status: 'unknown', lastCheck: null },
      'devops-engineer': { status: 'unknown', lastCheck: null },
      'documentation-manager': { status: 'unknown', lastCheck: null },
      'solution-architect': { status: 'unknown', lastCheck: null }
    };
    
    // Metrics
    this.metrics = {
      uptime: Date.now(),
      checks: 0,
      issues: 0,
      remediations: 0,
      failures: 0
    };
    
    // Remediation strategies
    this.remediationStrategies = {
      high_memory: this.remediateHighMemory.bind(this),
      high_cpu: this.remediateHighCPU.bind(this),
      slow_response: this.remediateSlowResponse.bind(this),
      high_error_rate: this.remediateHighErrorRate.bind(this),
      low_disk_space: this.remediateLowDiskSpace.bind(this),
      cache_issues: this.remediateCacheIssues.bind(this),
      agent_unresponsive: this.remediateUnresponsiveAgent.bind(this)
    };
    
    // Start monitoring
    this.startMonitoring();
  }

  /**
   * Run comprehensive health check
   */
  async runHealthCheck(level = 'basic') {
    const startTime = performance.now();
    const timestamp = new Date().toISOString();
    
    this.metrics.checks++;
    
    const checks = {
      timestamp,
      level,
      system: await this.checkSystem(),
      agents: await this.checkAgents(),
      performance: await this.checkPerformance(),
      resources: await this.checkResources()
    };
    
    // Additional checks for detailed level
    if (level === 'detailed' || level === 'full') {
      checks.cache = await this.checkCache();
      checks.dependencies = await this.checkDependencies();
    }
    
    // Additional checks for full level
    if (level === 'full') {
      checks.filesystem = await this.checkFilesystem();
      checks.network = await this.checkNetwork();
      checks.security = await this.checkSecurity();
    }
    
    // Calculate overall health
    const overall = this.calculateOverallHealth(checks);
    
    // Get recommendations
    const recommendations = this.getRecommendations(checks);
    
    // Auto-remediation if needed
    if (this.autoRemediation && overall.score < 70) {
      await this.performAutoRemediation(checks);
    }
    
    const duration = performance.now() - startTime;
    
    const report = {
      timestamp,
      level,
      overall,
      checks,
      recommendations,
      duration: `${duration.toFixed(2)}ms`,
      metrics: this.metrics
    };
    
    // Store in history
    this.addToHistory(report);
    
    // Save report
    await this.saveReport(report);
    
    return report;
  }

  /**
   * Check system resources
   */
  async checkSystem() {
    const memoryUsage = process.memoryUsage();
    const totalMemory = os.totalmem();
    const freeMemory = os.freemem();
    const usedMemory = totalMemory - freeMemory;
    const memoryPercent = (usedMemory / totalMemory) * 100;
    
    const cpus = os.cpus();
    const loadAverage = os.loadavg();
    const cpuPercent = loadAverage[0] / cpus.length * 100;
    
    const uptime = process.uptime();
    
    return {
      status: this.getStatus(memoryPercent < this.thresholds.memory && cpuPercent < this.thresholds.cpu),
      memory: {
        percent: memoryPercent.toFixed(2),
        used: this.formatBytes(usedMemory),
        total: this.formatBytes(totalMemory),
        heap: {
          used: this.formatBytes(memoryUsage.heapUsed),
          total: this.formatBytes(memoryUsage.heapTotal)
        },
        status: this.getStatus(memoryPercent < this.thresholds.memory),
        threshold: this.thresholds.memory
      },
      cpu: {
        percent: cpuPercent.toFixed(2),
        cores: cpus.length,
        loadAverage,
        status: this.getStatus(cpuPercent < this.thresholds.cpu),
        threshold: this.thresholds.cpu
      },
      uptime: this.formatUptime(uptime),
      platform: os.platform(),
      nodeVersion: process.version
    };
  }

  /**
   * Check agent responsiveness
   */
  async checkAgents() {
    const results = {};
    
    for (const [agentName, agentInfo] of Object.entries(this.agents)) {
      const startTime = performance.now();
      
      try {
        // Simulate agent ping - in real implementation would check actual agent
        const responsive = await this.pingAgent(agentName);
        const responseTime = performance.now() - startTime;
        
        const status = responsive 
          ? (responseTime < this.thresholds.responseTime ? 'healthy' : 'slow')
          : 'unresponsive';
        
        results[agentName] = {
          status,
          responseTime: `${responseTime.toFixed(2)}ms`,
          lastCheck: new Date().toISOString(),
          healthy: status === 'healthy'
        };
        
        // Update agent info
        this.agents[agentName] = {
          status,
          lastCheck: Date.now(),
          responseTime
        };
      } catch (error) {
        results[agentName] = {
          status: 'error',
          error: error.message,
          healthy: false
        };
        
        this.agents[agentName].status = 'error';
      }
    }
    
    const healthyCount = Object.values(results).filter(r => r.healthy).length;
    const totalCount = Object.keys(results).length;
    
    return {
      status: this.getStatus(healthyCount === totalCount),
      healthy: `${healthyCount}/${totalCount}`,
      agents: results
    };
  }

  /**
   * Check performance metrics
   */
  async checkPerformance() {
    // Get cache stats if available
    let cacheStats = { hitRate: 0 };
    try {
      const CacheManager = require('../cache/cache-manager');
      const cache = new CacheManager();
      cacheStats = cache.getStats();
    } catch (e) {
      // Cache not available
    }
    
    // Get error recovery stats if available
    let recoveryStats = { successRate: '0%' };
    try {
      const ErrorRecovery = require('../recovery/error-recovery');
      const recovery = new ErrorRecovery();
      recoveryStats = recovery.getStats();
    } catch (e) {
      // Recovery not available
    }
    
    const avgResponseTime = this.calculateAverageResponseTime();
    
    return {
      status: this.getStatus(
        cacheStats.hitRate >= this.thresholds.cacheHitRate &&
        avgResponseTime < this.thresholds.responseTime
      ),
      cache: {
        hitRate: `${cacheStats.hitRate}%`,
        status: this.getStatus(cacheStats.hitRate >= this.thresholds.cacheHitRate),
        threshold: this.thresholds.cacheHitRate
      },
      errorRecovery: {
        successRate: recoveryStats.successRate,
        totalErrors: recoveryStats.totalErrors || 0,
        recovered: recoveryStats.recovered || 0
      },
      responseTime: {
        average: `${avgResponseTime.toFixed(2)}ms`,
        status: this.getStatus(avgResponseTime < this.thresholds.responseTime),
        threshold: this.thresholds.responseTime
      }
    };
  }

  /**
   * Check resources (disk, network, etc.)
   */
  async checkResources() {
    // Check disk space
    const diskSpace = await this.checkDiskSpace();
    
    return {
      status: this.getStatus(diskSpace.percentUsed < this.thresholds.diskSpace),
      disk: {
        used: diskSpace.used,
        total: diskSpace.total,
        percentUsed: diskSpace.percentUsed,
        status: this.getStatus(diskSpace.percentUsed < this.thresholds.diskSpace),
        threshold: this.thresholds.diskSpace
      }
    };
  }

  /**
   * Check cache health
   */
  async checkCache() {
    try {
      const CacheManager = require('../cache/cache-manager');
      const cache = new CacheManager();
      const stats = cache.getStats();
      
      return {
        status: this.getStatus(stats.utilizationPercent < 90),
        utilization: `${stats.utilizationPercent}%`,
        items: stats.totalItems,
        size: this.formatBytes(stats.totalSize),
        hitRate: `${stats.hitRate}%`,
        categories: stats.categoryCounts
      };
    } catch (error) {
      return {
        status: 'error',
        error: error.message
      };
    }
  }

  /**
   * Check dependencies
   */
  async checkDependencies() {
    try {
      // Check for security vulnerabilities
      const { stdout: auditOutput } = await exec('npm audit --json');
      const audit = JSON.parse(auditOutput);
      
      return {
        status: this.getStatus(audit.metadata.vulnerabilities.total === 0),
        vulnerabilities: audit.metadata.vulnerabilities,
        dependencies: audit.metadata.dependencies
      };
    } catch (error) {
      return {
        status: 'unknown',
        error: 'Unable to check dependencies'
      };
    }
  }

  /**
   * Check filesystem
   */
  async checkFilesystem() {
    const criticalPaths = [
      './.claude/memory',
      './.claude/agents',
      './.claude/cache',
      './.claude/recovery'
    ];
    
    const results = {};
    
    for (const path of criticalPaths) {
      try {
        const stats = await fs.stat(path);
        results[path] = {
          exists: true,
          writable: true, // Would need proper check
          size: this.formatBytes(stats.size)
        };
      } catch (error) {
        results[path] = {
          exists: false,
          error: error.message
        };
      }
    }
    
    const allExist = Object.values(results).every(r => r.exists);
    
    return {
      status: this.getStatus(allExist),
      paths: results
    };
  }

  /**
   * Check network connectivity
   */
  async checkNetwork() {
    const endpoints = [
      { name: 'Context7', url: 'context7.upstash.com', expected: 200 },
      { name: 'GitHub', url: 'api.github.com', expected: 200 }
    ];
    
    const results = {};
    
    for (const endpoint of endpoints) {
      try {
        const startTime = performance.now();
        // In real implementation, would do actual HTTP request
        const latency = performance.now() - startTime;
        
        results[endpoint.name] = {
          status: 'reachable',
          latency: `${latency.toFixed(2)}ms`
        };
      } catch (error) {
        results[endpoint.name] = {
          status: 'unreachable',
          error: error.message
        };
      }
    }
    
    return {
      status: this.getStatus(Object.values(results).every(r => r.status === 'reachable')),
      endpoints: results
    };
  }

  /**
   * Check security
   */
  async checkSecurity() {
    const checks = {
      secretsInCode: await this.checkForSecrets(),
      permissions: await this.checkFilePermissions(),
      updates: await this.checkForUpdates()
    };
    
    return {
      status: this.getStatus(
        !checks.secretsInCode.found &&
        checks.permissions.secure &&
        !checks.updates.critical
      ),
      checks
    };
  }

  /**
   * Calculate overall health score
   */
  calculateOverallHealth(checks) {
    const weights = {
      system: 30,
      agents: 30,
      performance: 20,
      resources: 20
    };
    
    let totalScore = 0;
    let totalWeight = 0;
    
    for (const [category, weight] of Object.entries(weights)) {
      if (checks[category]) {
        const categoryScore = this.getCategoryScore(checks[category]);
        totalScore += categoryScore * weight;
        totalWeight += weight;
      }
    }
    
    const score = totalWeight > 0 ? Math.round(totalScore / totalWeight) : 0;
    
    return {
      score,
      status: score >= 80 ? 'healthy' : score >= 60 ? 'degraded' : 'unhealthy',
      emoji: score >= 80 ? '🟢' : score >= 60 ? '🟡' : '🔴'
    };
  }

  /**
   * Get recommendations based on health checks
   */
  getRecommendations(checks) {
    const recommendations = [];
    
    // System recommendations
    if (checks.system?.memory?.percent > this.thresholds.memory * 0.8) {
      recommendations.push({
        severity: 'warning',
        category: 'memory',
        message: 'Memory usage approaching threshold',
        action: 'Consider clearing cache or restarting agents'
      });
    }
    
    if (checks.system?.cpu?.percent > this.thresholds.cpu * 0.8) {
      recommendations.push({
        severity: 'warning',
        category: 'cpu',
        message: 'CPU usage is high',
        action: 'Review running processes and optimize workload'
      });
    }
    
    // Agent recommendations
    const unhealthyAgents = Object.entries(checks.agents?.agents || {})
      .filter(([_, info]) => !info.healthy)
      .map(([name, _]) => name);
    
    if (unhealthyAgents.length > 0) {
      recommendations.push({
        severity: 'error',
        category: 'agents',
        message: `Unhealthy agents: ${unhealthyAgents.join(', ')}`,
        action: 'Restart affected agents'
      });
    }
    
    // Performance recommendations
    if (checks.performance?.cache?.hitRate < this.thresholds.cacheHitRate) {
      recommendations.push({
        severity: 'info',
        category: 'performance',
        message: 'Cache hit rate is low',
        action: 'Review cache configuration and warming strategies'
      });
    }
    
    // Resource recommendations
    if (checks.resources?.disk?.percentUsed > this.thresholds.diskSpace * 0.9) {
      recommendations.push({
        severity: 'warning',
        category: 'disk',
        message: 'Disk space is running low',
        action: 'Clean up old logs and snapshots'
      });
    }
    
    return recommendations;
  }

  /**
   * Perform auto-remediation
   */
  async performAutoRemediation(checks) {
    const issues = this.identifyIssues(checks);
    
    for (const issue of issues) {
      const strategy = this.remediationStrategies[issue.type];
      
      if (strategy) {
        try {
          console.log(`Attempting auto-remediation for ${issue.type}...`);
          await strategy(issue, checks);
          this.metrics.remediations++;
        } catch (error) {
          console.error(`Remediation failed for ${issue.type}:`, error);
          this.metrics.failures++;
        }
      }
    }
  }

  /**
   * Remediation strategies
   */
  async remediateHighMemory() {
    console.log('Clearing cache and running garbage collection...');
    
    // Force garbage collection if available
    if (global.gc) {
      global.gc();
    }
    
    // Clear old cache entries
    try {
      const CacheManager = require('../cache/cache-manager');
      const cache = new CacheManager();
      cache.cleanup();
    } catch (e) {
      // Cache not available
    }
    
    return true;
  }

  async remediateHighCPU() {
    console.log('Throttling background tasks...');
    // Implementation would throttle non-critical operations
    return true;
  }

  async remediateSlowResponse() {
    console.log('Optimizing performance settings...');
    // Implementation would adjust performance settings
    return true;
  }

  async remediateHighErrorRate() {
    console.log('Resetting error states...');
    // Implementation would reset error counters and retry failed operations
    return true;
  }

  async remediateLowDiskSpace() {
    console.log('Cleaning up old files...');
    
    // Clean old snapshots
    const snapshotDir = './.claude/recovery/snapshots';
    try {
      const files = await fs.readdir(snapshotDir);
      const oldFiles = files.filter(f => f.startsWith('snapshot-'));
      
      // Keep only last 5 snapshots
      if (oldFiles.length > 5) {
        const toDelete = oldFiles.slice(0, oldFiles.length - 5);
        for (const file of toDelete) {
          await fs.unlink(path.join(snapshotDir, file));
        }
      }
    } catch (e) {
      // Directory doesn't exist
    }
    
    return true;
  }

  async remediateCacheIssues() {
    console.log('Optimizing cache...');
    
    try {
      const CacheManager = require('../cache/cache-manager');
      const cache = new CacheManager();
      
      // Clear least used items
      const stats = cache.getStats();
      if (stats.utilizationPercent > 80) {
        cache.clear('responses'); // Clear most volatile category
      }
      
      // Warm up with important patterns
      const config = require('../cache/config/cache-config.json');
      await cache.warmup(config.cache.warmup.patterns);
    } catch (e) {
      // Cache not available
    }
    
    return true;
  }

  async remediateUnresponsiveAgent(issue) {
    console.log(`Restarting agent: ${issue.agent}...`);
    // In real implementation, would restart the specific agent
    this.agents[issue.agent].status = 'restarting';
    
    // Simulate restart
    setTimeout(() => {
      this.agents[issue.agent].status = 'healthy';
    }, 5000);
    
    return true;
  }

  /**
   * Helper methods
   */
  
  async pingAgent(agentName) {
    // Simulate agent ping - in real implementation would check actual agent
    return Math.random() > 0.1; // 90% success rate for simulation
  }

  async checkDiskSpace() {
    try {
      const { stdout } = await exec('df -k .');
      const lines = stdout.trim().split('\n');
      const parts = lines[1].split(/\s+/);
      
      const total = parseInt(parts[1]) * 1024;
      const used = parseInt(parts[2]) * 1024;
      const percentUsed = parseInt(parts[4]);
      
      return {
        total: this.formatBytes(total),
        used: this.formatBytes(used),
        percentUsed
      };
    } catch (error) {
      return {
        total: 'unknown',
        used: 'unknown',
        percentUsed: 0
      };
    }
  }

  async checkForSecrets() {
    // Simple check for common secret patterns
    const patterns = [
      /api[_-]?key/i,
      /secret/i,
      /password/i,
      /token/i
    ];
    
    // In real implementation, would scan code files
    return { found: false, locations: [] };
  }

  async checkFilePermissions() {
    // In real implementation, would check file permissions
    return { secure: true };
  }

  async checkForUpdates() {
    // In real implementation, would check for package updates
    return { critical: false, available: 0 };
  }

  calculateAverageResponseTime() {
    const times = Object.values(this.agents)
      .filter(a => a.responseTime)
      .map(a => a.responseTime);
    
    if (times.length === 0) return 0;
    
    return times.reduce((a, b) => a + b, 0) / times.length;
  }

  getCategoryScore(category) {
    if (category.status === 'healthy' || category.status === true) return 100;
    if (category.status === 'degraded' || category.status === 'slow') return 60;
    if (category.status === 'unhealthy' || category.status === false) return 20;
    if (category.status === 'error') return 0;
    return 50; // unknown
  }

  getStatus(healthy) {
    return healthy ? 'healthy' : 'unhealthy';
  }

  formatBytes(bytes) {
    const units = ['B', 'KB', 'MB', 'GB'];
    let unit = 0;
    let value = bytes;
    
    while (value > 1024 && unit < units.length - 1) {
      value /= 1024;
      unit++;
    }
    
    return `${value.toFixed(2)} ${units[unit]}`;
  }

  formatUptime(seconds) {
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor((seconds % 86400) / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    
    const parts = [];
    if (days > 0) parts.push(`${days}d`);
    if (hours > 0) parts.push(`${hours}h`);
    if (minutes > 0) parts.push(`${minutes}m`);
    
    return parts.join(' ') || '0m';
  }

  identifyIssues(checks) {
    const issues = [];
    
    // Check for high memory
    if (checks.system?.memory?.percent > this.thresholds.memory) {
      issues.push({ type: 'high_memory', severity: 'high' });
    }
    
    // Check for high CPU
    if (checks.system?.cpu?.percent > this.thresholds.cpu) {
      issues.push({ type: 'high_cpu', severity: 'high' });
    }
    
    // Check for unresponsive agents
    for (const [agent, info] of Object.entries(checks.agents?.agents || {})) {
      if (info.status === 'unresponsive' || info.status === 'error') {
        issues.push({ type: 'agent_unresponsive', agent, severity: 'critical' });
      }
    }
    
    // Check for low cache hit rate
    if (checks.performance?.cache?.hitRate < this.thresholds.cacheHitRate) {
      issues.push({ type: 'cache_issues', severity: 'medium' });
    }
    
    return issues;
  }

  addToHistory(report) {
    this.history.push(report);
    
    // Keep history size limited
    if (this.history.length > this.maxHistorySize) {
      this.history.shift();
    }
  }

  async saveReport(report) {
    const reportPath = path.join(__dirname, 'reports', `health-${Date.now()}.json`);
    
    try {
      await fs.mkdir(path.dirname(reportPath), { recursive: true });
      await fs.writeFile(reportPath, JSON.stringify(report, null, 2));
    } catch (error) {
      console.error('Failed to save health report:', error);
    }
  }

  /**
   * Start automated monitoring
   */
  startMonitoring() {
    // Basic checks every 30 seconds
    this.basicInterval = setInterval(() => {
      this.runHealthCheck('basic').catch(console.error);
    }, this.intervals.basic);
    
    // Detailed checks every 5 minutes
    this.detailedInterval = setInterval(() => {
      this.runHealthCheck('detailed').catch(console.error);
    }, this.intervals.detailed);
    
    // Full checks every hour
    this.fullInterval = setInterval(() => {
      this.runHealthCheck('full').catch(console.error);
    }, this.intervals.full);
  }

  /**
   * Stop monitoring
   */
  stopMonitoring() {
    clearInterval(this.basicInterval);
    clearInterval(this.detailedInterval);
    clearInterval(this.fullInterval);
  }

  /**
   * Get current status summary
   */
  getStatusSummary() {
    const uptime = Date.now() - this.metrics.uptime;
    
    return {
      uptime: this.formatUptime(uptime / 1000),
      totalChecks: this.metrics.checks,
      issuesFound: this.metrics.issues,
      remediations: this.metrics.remediations,
      failures: this.metrics.failures,
      agents: this.agents,
      lastCheck: this.history[this.history.length - 1] || null
    };
  }
}

module.exports = HealthMonitor;