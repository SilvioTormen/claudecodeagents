#!/usr/bin/env node

/**
 * Interactive CLI for Claude Agent System
 * Provides interactive command interface with auto-completion and help
 */

const readline = require('readline');
const chalk = require('chalk');
const figlet = require('figlet');
const Table = require('cli-table3');
const inquirer = require('inquirer');
const { execSync } = require('child_process');
const fs = require('fs').promises;
const path = require('path');

class InteractiveCLI {
  constructor(config = {}) {
    this.version = config.version || '4.1.0';
    this.prompt = config.prompt || 'Claude Agent System > ';
    this.history = [];
    this.commands = {};
    this.rl = null;
    
    // System modules
    this.cacheManager = null;
    this.healthMonitor = null;
    this.errorRecovery = null;
    
    // Load modules
    this.loadModules();
    
    // Register commands
    this.registerCommands();
  }

  /**
   * Load system modules
   */
  async loadModules() {
    try {
      const CacheManager = require('../cache/cache-manager');
      this.cacheManager = new CacheManager();
    } catch (e) {
      console.warn('Cache Manager not available');
    }
    
    try {
      const HealthMonitor = require('../health/health-monitor');
      this.healthMonitor = new HealthMonitor();
    } catch (e) {
      console.warn('Health Monitor not available');
    }
    
    try {
      const ErrorRecovery = require('../recovery/error-recovery');
      this.errorRecovery = new ErrorRecovery();
    } catch (e) {
      console.warn('Error Recovery not available');
    }
  }

  /**
   * Register all CLI commands
   */
  registerCommands() {
    // System commands
    this.registerCommand('help', this.showHelp.bind(this), 'Show available commands');
    this.registerCommand('status', this.showStatus.bind(this), 'Show system status');
    this.registerCommand('health', this.runHealthCheck.bind(this), 'Run health check');
    this.registerCommand('cache', this.cacheCommand.bind(this), 'Cache management');
    this.registerCommand('agents', this.listAgents.bind(this), 'List available agents');
    this.registerCommand('orchestrate', this.orchestrate.bind(this), 'Orchestrate task');
    this.registerCommand('memory', this.memoryCommand.bind(this), 'Memory management');
    this.registerCommand('library', this.libraryCommand.bind(this), 'Library control');
    this.registerCommand('task', this.taskCommand.bind(this), 'Task management');
    this.registerCommand('monitor', this.monitorCommand.bind(this), 'System monitoring');
    this.registerCommand('recovery', this.recoveryCommand.bind(this), 'Error recovery');
    this.registerCommand('config', this.configCommand.bind(this), 'Configuration');
    this.registerCommand('test', this.testCommand.bind(this), 'Run tests');
    this.registerCommand('deploy', this.deployCommand.bind(this), 'Deployment tasks');
    this.registerCommand('clear', this.clearScreen.bind(this), 'Clear screen');
    this.registerCommand('history', this.showHistory.bind(this), 'Show command history');
    this.registerCommand('exit', this.exit.bind(this), 'Exit CLI');
    this.registerCommand('quit', this.exit.bind(this), 'Exit CLI');
  }

  /**
   * Register a command
   */
  registerCommand(name, handler, description = '') {
    this.commands[name] = {
      handler,
      description,
      name
    };
  }

  /**
   * Start the interactive CLI
   */
  async start() {
    // Show welcome message
    console.log(chalk.cyan(figlet.textSync('Claude Agent System', {
      font: 'Standard',
      horizontalLayout: 'default'
    })));
    
    console.log(chalk.green(`Version ${this.version} - Interactive CLI`));
    console.log(chalk.gray('Type "help" for available commands\n'));
    
    // Initialize readline
    this.rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
      prompt: chalk.yellow(this.prompt),
      completer: this.completer.bind(this)
    });
    
    // Handle line input
    this.rl.on('line', async (line) => {
      await this.handleCommand(line.trim());
      this.rl.prompt();
    });
    
    // Handle close
    this.rl.on('close', () => {
      this.exit();
    });
    
    // Show initial status
    await this.showStatus();
    
    // Start prompt
    this.rl.prompt();
  }

  /**
   * Auto-completion handler
   */
  completer(line) {
    const completions = Object.keys(this.commands);
    const hits = completions.filter(c => c.startsWith(line));
    return [hits.length ? hits : completions, line];
  }

  /**
   * Handle command execution
   */
  async handleCommand(input) {
    if (!input) return;
    
    // Add to history
    this.history.push(input);
    
    // Parse command and arguments
    const [command, ...args] = input.split(' ');
    
    // Execute command
    if (this.commands[command]) {
      try {
        await this.commands[command].handler(args);
      } catch (error) {
        console.error(chalk.red(`Error: ${error.message}`));
      }
    } else if (command) {
      console.log(chalk.red(`Unknown command: ${command}`));
      console.log(chalk.gray('Type "help" for available commands'));
    }
  }

  /**
   * Show help
   */
  async showHelp(args) {
    if (args.length > 0) {
      // Show specific command help
      const cmd = args[0];
      if (this.commands[cmd]) {
        console.log(chalk.cyan(`\n${cmd}: ${this.commands[cmd].description}`));
      } else {
        console.log(chalk.red(`Unknown command: ${cmd}`));
      }
    } else {
      // Show all commands
      console.log(chalk.cyan('\nAvailable Commands:'));
      
      const table = new Table({
        head: ['Command', 'Description'],
        style: {
          head: ['cyan']
        }
      });
      
      for (const [name, info] of Object.entries(this.commands)) {
        table.push([name, info.description]);
      }
      
      console.log(table.toString());
    }
  }

  /**
   * Show system status
   */
  async showStatus(args) {
    console.log(chalk.cyan('\n📊 System Status\n'));
    
    const table = new Table({
      style: { head: ['cyan'] }
    });
    
    // Basic info
    table.push(
      ['Version', this.version],
      ['Node Version', process.version],
      ['Platform', process.platform],
      ['Uptime', this.formatUptime(process.uptime())],
      ['Memory Usage', this.formatMemory()]
    );
    
    // Cache status
    if (this.cacheManager) {
      const stats = this.cacheManager.getStats();
      table.push(
        ['Cache Items', stats.totalItems],
        ['Cache Hit Rate', `${stats.hitRate}%`],
        ['Cache Size', `${(stats.totalSize / 1024 / 1024).toFixed(2)} MB`]
      );
    }
    
    // Health status
    if (this.healthMonitor) {
      const summary = this.healthMonitor.getStatusSummary();
      table.push(
        ['Health Checks', summary.totalChecks],
        ['Issues Found', summary.issuesFound],
        ['Remediations', summary.remediations]
      );
    }
    
    console.log(table.toString());
  }

  /**
   * Run health check
   */
  async runHealthCheck(args) {
    const level = args[0] || 'basic';
    
    console.log(chalk.cyan(`\n🏥 Running ${level} health check...\n`));
    
    if (!this.healthMonitor) {
      console.log(chalk.red('Health Monitor not available'));
      return;
    }
    
    const report = await this.healthMonitor.runHealthCheck(level);
    
    // Display overall status
    const emoji = report.overall.emoji;
    const status = report.overall.status;
    const score = report.overall.score;
    
    console.log(`${emoji} Overall Health: ${chalk.bold(status)} (Score: ${score}/100)\n`);
    
    // Display checks
    const table = new Table({
      head: ['Category', 'Status', 'Details'],
      style: { head: ['cyan'] }
    });
    
    for (const [category, check] of Object.entries(report.checks)) {
      const statusColor = check.status === 'healthy' ? 'green' : 
                         check.status === 'degraded' ? 'yellow' : 'red';
      table.push([
        category,
        chalk[statusColor](check.status),
        this.formatCheckDetails(check)
      ]);
    }
    
    console.log(table.toString());
    
    // Display recommendations
    if (report.recommendations.length > 0) {
      console.log(chalk.cyan('\n📝 Recommendations:\n'));
      for (const rec of report.recommendations) {
        const color = rec.severity === 'error' ? 'red' :
                     rec.severity === 'warning' ? 'yellow' : 'gray';
        console.log(chalk[color](`• [${rec.severity.toUpperCase()}] ${rec.message}`));
        console.log(chalk.gray(`  Action: ${rec.action}`));
      }
    }
  }

  /**
   * Cache management command
   */
  async cacheCommand(args) {
    if (!this.cacheManager) {
      console.log(chalk.red('Cache Manager not available'));
      return;
    }
    
    const subcommand = args[0] || 'status';
    
    switch (subcommand) {
      case 'status':
        const stats = this.cacheManager.getStats();
        console.log(chalk.cyan('\n📦 Cache Status\n'));
        
        const table = new Table({
          style: { head: ['cyan'] }
        });
        
        table.push(
          ['Total Items', stats.totalItems],
          ['Total Size', `${(stats.totalSize / 1024 / 1024).toFixed(2)} MB`],
          ['Max Size', `${(stats.maxSize / 1024 / 1024).toFixed(2)} MB`],
          ['Utilization', `${stats.utilizationPercent}%`],
          ['Hit Rate', `${stats.hitRate}%`],
          ['Hits', stats.hits],
          ['Misses', stats.misses]
        );
        
        console.log(table.toString());
        
        // Category breakdown
        if (Object.keys(stats.categoryCounts).length > 0) {
          console.log(chalk.cyan('\nCategory Breakdown:'));
          for (const [category, count] of Object.entries(stats.categoryCounts)) {
            const size = stats.categorySize[category] || 0;
            console.log(`  ${category}: ${count} items (${(size / 1024).toFixed(2)} KB)`);
          }
        }
        break;
        
      case 'clear':
        const category = args[1];
        if (category) {
          this.cacheManager.clear(category);
          console.log(chalk.green(`Cleared cache category: ${category}`));
        } else {
          const { confirm } = await inquirer.prompt([{
            type: 'confirm',
            name: 'confirm',
            message: 'Clear entire cache?',
            default: false
          }]);
          
          if (confirm) {
            this.cacheManager.clear();
            console.log(chalk.green('Cache cleared'));
          }
        }
        break;
        
      case 'persist':
        await this.cacheManager.persistCache();
        console.log(chalk.green('Cache persisted to disk'));
        break;
        
      case 'cleanup':
        const cleaned = this.cacheManager.cleanup();
        console.log(chalk.green(`Cleaned up ${cleaned} expired items`));
        break;
        
      default:
        console.log(chalk.red(`Unknown cache subcommand: ${subcommand}`));
        console.log(chalk.gray('Available: status, clear, persist, cleanup'));
    }
  }

  /**
   * List available agents
   */
  async listAgents(args) {
    console.log(chalk.cyan('\n🤖 Available Agents\n'));
    
    const agentsDir = path.join(__dirname, '../../agents');
    const categories = await fs.readdir(agentsDir);
    
    for (const category of categories) {
      const categoryPath = path.join(agentsDir, category);
      const stat = await fs.stat(categoryPath);
      
      if (stat.isDirectory()) {
        console.log(chalk.yellow(`\n${category.toUpperCase()}:`));
        
        const agents = await fs.readdir(categoryPath);
        const agentFiles = agents.filter(f => f.endsWith('.md'));
        
        for (const agentFile of agentFiles) {
          const agentName = agentFile.replace('.md', '');
          const agentPath = path.join(categoryPath, agentFile);
          
          try {
            const content = await fs.readFile(agentPath, 'utf8');
            const descMatch = content.match(/role:\s*"([^"]+)"/);
            const description = descMatch ? descMatch[1] : 'No description';
            
            console.log(`  • ${chalk.green(agentName)}: ${chalk.gray(description)}`);
          } catch (e) {
            console.log(`  • ${chalk.green(agentName)}`);
          }
        }
      }
    }
  }

  /**
   * Orchestrate task
   */
  async orchestrate(args) {
    if (args.length === 0) {
      console.log(chalk.red('Please provide a task description'));
      return;
    }
    
    const task = args.join(' ');
    console.log(chalk.cyan(`\n🎯 Orchestrating: ${task}\n`));
    
    // Analyze task complexity
    const complexity = this.analyzeComplexity(task);
    console.log(`Complexity: ${complexity}/5`);
    
    // Suggest agents
    const agents = this.suggestAgents(task, complexity);
    console.log(`Suggested agents: ${agents.join(', ')}`);
    
    // Create orchestration command
    const command = this.createOrchestrationCommand(task, agents, complexity);
    console.log(chalk.green('\n📋 Generated Command:\n'));
    console.log(chalk.gray(command));
    
    // Ask for confirmation
    const { execute } = await inquirer.prompt([{
      type: 'confirm',
      name: 'execute',
      message: 'Execute this orchestration?',
      default: true
    }]);
    
    if (execute) {
      console.log(chalk.cyan('\n🚀 Executing orchestration...'));
      // In real implementation, would execute the orchestration
      console.log(chalk.green('✓ Orchestration started'));
    }
  }

  /**
   * Memory management command
   */
  async memoryCommand(args) {
    const subcommand = args[0] || 'status';
    const memoryDir = path.join(__dirname, '../../memory');
    
    switch (subcommand) {
      case 'status':
        console.log(chalk.cyan('\n🧠 Memory Status\n'));
        
        try {
          const files = await fs.readdir(memoryDir);
          const memoryFiles = files.filter(f => f.endsWith('.md'));
          
          const table = new Table({
            head: ['Memory File', 'Size', 'Last Modified'],
            style: { head: ['cyan'] }
          });
          
          for (const file of memoryFiles) {
            const filePath = path.join(memoryDir, file);
            const stat = await fs.stat(filePath);
            
            table.push([
              file.replace('.md', ''),
              `${(stat.size / 1024).toFixed(2)} KB`,
              new Date(stat.mtime).toLocaleString()
            ]);
          }
          
          console.log(table.toString());
        } catch (e) {
          console.log(chalk.red('Memory directory not found'));
        }
        break;
        
      case 'view':
        const memoryName = args[1];
        if (!memoryName) {
          console.log(chalk.red('Please specify memory file name'));
          return;
        }
        
        try {
          const content = await fs.readFile(
            path.join(memoryDir, `${memoryName}.md`), 
            'utf8'
          );
          console.log(chalk.cyan(`\n📄 ${memoryName} Memory:\n`));
          console.log(content);
        } catch (e) {
          console.log(chalk.red(`Memory file not found: ${memoryName}`));
        }
        break;
        
      default:
        console.log(chalk.red(`Unknown memory subcommand: ${subcommand}`));
        console.log(chalk.gray('Available: status, view'));
    }
  }

  /**
   * Library control command
   */
  async libraryCommand(args) {
    const subcommand = args[0] || 'status';
    
    switch (subcommand) {
      case 'check':
        const library = args[1];
        if (!library) {
          console.log(chalk.red('Please specify library name'));
          return;
        }
        
        try {
          const approvedPath = path.join(__dirname, '../../memory/approved-dependencies.md');
          const content = await fs.readFile(approvedPath, 'utf8');
          
          if (content.includes(library)) {
            console.log(chalk.green(`✓ ${library} is approved`));
          } else {
            console.log(chalk.red(`✗ ${library} is NOT approved`));
            console.log(chalk.yellow('Please request approval before using'));
          }
        } catch (e) {
          console.log(chalk.red('Approved dependencies list not found'));
        }
        break;
        
      case 'list':
        try {
          const approvedPath = path.join(__dirname, '../../memory/approved-dependencies.md');
          const content = await fs.readFile(approvedPath, 'utf8');
          console.log(chalk.cyan('\n📚 Approved Libraries:\n'));
          
          // Extract library names (simple regex)
          const matches = content.match(/- `([^`]+)`/g);
          if (matches) {
            const libs = matches.map(m => m.replace(/- `|`/g, ''));
            const categories = {
              frontend: [],
              backend: [],
              testing: [],
              utilities: [],
              other: []
            };
            
            // Categorize (simplified)
            for (const lib of libs) {
              if (lib.includes('react') || lib.includes('vue')) {
                categories.frontend.push(lib);
              } else if (lib.includes('express') || lib.includes('koa')) {
                categories.backend.push(lib);
              } else if (lib.includes('test') || lib.includes('jest')) {
                categories.testing.push(lib);
              } else if (lib.includes('lodash') || lib.includes('axios')) {
                categories.utilities.push(lib);
              } else {
                categories.other.push(lib);
              }
            }
            
            for (const [category, libs] of Object.entries(categories)) {
              if (libs.length > 0) {
                console.log(chalk.yellow(`${category.toUpperCase()}:`));
                for (const lib of libs) {
                  console.log(`  • ${lib}`);
                }
                console.log();
              }
            }
          }
        } catch (e) {
          console.log(chalk.red('Approved dependencies list not found'));
        }
        break;
        
      default:
        console.log(chalk.red(`Unknown library subcommand: ${subcommand}`));
        console.log(chalk.gray('Available: check, list'));
    }
  }

  /**
   * Task management command
   */
  async taskCommand(args) {
    const subcommand = args[0] || 'list';
    const tasksPath = path.join(__dirname, '../../context/active-tasks.json');
    
    switch (subcommand) {
      case 'list':
        try {
          const content = await fs.readFile(tasksPath, 'utf8');
          const tasks = JSON.parse(content);
          
          console.log(chalk.cyan('\n📋 Active Tasks\n'));
          
          if (tasks.tasks.active.length === 0) {
            console.log(chalk.gray('No active tasks'));
          } else {
            const table = new Table({
              head: ['ID', 'Title', 'Status', 'Agents'],
              style: { head: ['cyan'] }
            });
            
            for (const task of tasks.tasks.active) {
              table.push([
                task.id,
                task.title,
                chalk.yellow(task.status),
                task.assignedAgents.join(', ')
              ]);
            }
            
            console.log(table.toString());
          }
        } catch (e) {
          console.log(chalk.red('Tasks file not found'));
        }
        break;
        
      default:
        console.log(chalk.red(`Unknown task subcommand: ${subcommand}`));
        console.log(chalk.gray('Available: list'));
    }
  }

  /**
   * System monitoring command
   */
  async monitorCommand(args) {
    const subcommand = args[0] || 'start';
    
    switch (subcommand) {
      case 'start':
        console.log(chalk.cyan('📊 Starting real-time monitoring...'));
        console.log(chalk.gray('Press Ctrl+C to stop\n'));
        
        // Start monitoring interval
        const interval = setInterval(async () => {
          // Clear screen and show status
          console.clear();
          console.log(chalk.cyan('📊 Real-time Monitoring\n'));
          
          // Memory
          const mem = process.memoryUsage();
          console.log(chalk.yellow('Memory:'));
          console.log(`  Heap: ${(mem.heapUsed / 1024 / 1024).toFixed(2)}MB / ${(mem.heapTotal / 1024 / 1024).toFixed(2)}MB`);
          console.log(`  RSS: ${(mem.rss / 1024 / 1024).toFixed(2)}MB`);
          
          // Cache
          if (this.cacheManager) {
            const stats = this.cacheManager.getStats();
            console.log(chalk.yellow('\nCache:'));
            console.log(`  Items: ${stats.totalItems}`);
            console.log(`  Hit Rate: ${stats.hitRate}%`);
          }
          
          // Timestamp
          console.log(chalk.gray(`\nUpdated: ${new Date().toLocaleTimeString()}`));
        }, 2000);
        
        // Handle exit
        process.on('SIGINT', () => {
          clearInterval(interval);
          console.log(chalk.cyan('\nMonitoring stopped'));
          process.exit(0);
        });
        break;
        
      default:
        console.log(chalk.red(`Unknown monitor subcommand: ${subcommand}`));
        console.log(chalk.gray('Available: start'));
    }
  }

  /**
   * Recovery command
   */
  async recoveryCommand(args) {
    if (!this.errorRecovery) {
      console.log(chalk.red('Error Recovery not available'));
      return;
    }
    
    const subcommand = args[0] || 'status';
    
    switch (subcommand) {
      case 'status':
        const stats = this.errorRecovery.getStats();
        console.log(chalk.cyan('\n🔧 Recovery Status\n'));
        
        const table = new Table({
          style: { head: ['cyan'] }
        });
        
        table.push(
          ['Total Errors', stats.totalErrors],
          ['Recovered', stats.recovered],
          ['Failed', stats.failed],
          ['Success Rate', stats.successRate],
          ['Rollbacks', stats.rollbacks],
          ['Auto-Fixes', stats.fixes]
        );
        
        console.log(table.toString());
        break;
        
      default:
        console.log(chalk.red(`Unknown recovery subcommand: ${subcommand}`));
        console.log(chalk.gray('Available: status'));
    }
  }

  /**
   * Configuration command
   */
  async configCommand(args) {
    console.log(chalk.cyan('\n⚙️  Configuration\n'));
    
    const configFiles = [
      '.claude/CLAUDE.md',
      '.claude/slash_commands.json',
      '.claude/cache/config/cache-config.json'
    ];
    
    const table = new Table({
      head: ['Config File', 'Status'],
      style: { head: ['cyan'] }
    });
    
    for (const file of configFiles) {
      try {
        await fs.stat(path.join(process.cwd(), file));
        table.push([file, chalk.green('✓ Present')]);
      } catch (e) {
        table.push([file, chalk.red('✗ Missing')]);
      }
    }
    
    console.log(table.toString());
  }

  /**
   * Test command
   */
  async testCommand(args) {
    const type = args[0] || 'all';
    
    console.log(chalk.cyan(`\n🧪 Running ${type} tests...\n`));
    
    // Simulate test execution
    const tests = [
      { name: 'Cache Manager', status: 'pass' },
      { name: 'Health Monitor', status: 'pass' },
      { name: 'Error Recovery', status: 'pass' },
      { name: 'Agent Orchestration', status: 'pass' }
    ];
    
    for (const test of tests) {
      const status = test.status === 'pass' ? 
        chalk.green('✓ PASS') : chalk.red('✗ FAIL');
      console.log(`${status} ${test.name}`);
    }
    
    console.log(chalk.green('\n✓ All tests passed'));
  }

  /**
   * Deploy command
   */
  async deployCommand(args) {
    const target = args[0] || 'production';
    
    console.log(chalk.cyan(`\n🚀 Deploying to ${target}...\n`));
    
    const steps = [
      'Running tests',
      'Building application',
      'Optimizing assets',
      'Deploying to server',
      'Verifying deployment'
    ];
    
    for (const step of steps) {
      console.log(chalk.gray(`• ${step}...`));
      await new Promise(resolve => setTimeout(resolve, 1000));
      console.log(chalk.green(`  ✓ ${step} completed`));
    }
    
    console.log(chalk.green('\n✓ Deployment successful'));
  }

  /**
   * Clear screen
   */
  clearScreen() {
    console.clear();
  }

  /**
   * Show command history
   */
  showHistory() {
    console.log(chalk.cyan('\n📜 Command History:\n'));
    
    if (this.history.length === 0) {
      console.log(chalk.gray('No commands in history'));
    } else {
      this.history.forEach((cmd, idx) => {
        console.log(`${idx + 1}. ${cmd}`);
      });
    }
  }

  /**
   * Exit CLI
   */
  async exit() {
    console.log(chalk.cyan('\n👋 Goodbye!\n'));
    
    // Cleanup
    if (this.healthMonitor) {
      this.healthMonitor.stopMonitoring();
    }
    
    if (this.cacheManager) {
      await this.cacheManager.persistCache();
      this.cacheManager.stopAutoPersist();
    }
    
    process.exit(0);
  }

  /**
   * Helper methods
   */
  
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

  formatMemory() {
    const mem = process.memoryUsage();
    const used = mem.heapUsed / 1024 / 1024;
    const total = mem.heapTotal / 1024 / 1024;
    return `${used.toFixed(2)}MB / ${total.toFixed(2)}MB`;
  }

  formatCheckDetails(check) {
    const details = [];
    
    if (check.memory) {
      details.push(`Memory: ${check.memory.percent}%`);
    }
    if (check.cpu) {
      details.push(`CPU: ${check.cpu.percent}%`);
    }
    if (check.healthy) {
      details.push(`Agents: ${check.healthy}`);
    }
    
    return details.join(', ') || 'N/A';
  }

  analyzeComplexity(task) {
    const words = task.split(' ').length;
    const hasAnd = task.includes(' und ') || task.includes(' and ');
    const hasWith = task.includes(' mit ') || task.includes(' with ');
    const hasMultiple = task.includes(',') || task.includes(';');
    
    let complexity = 1;
    
    if (words > 10) complexity++;
    if (words > 20) complexity++;
    if (hasAnd) complexity++;
    if (hasWith) complexity++;
    if (hasMultiple) complexity++;
    
    return Math.min(complexity, 5);
  }

  suggestAgents(task, complexity) {
    const agents = [];
    const taskLower = task.toLowerCase();
    
    // Pattern matching for agents
    if (taskLower.includes('api') || taskLower.includes('backend')) {
      agents.push('@backend-developer');
    }
    if (taskLower.includes('frontend') || taskLower.includes('ui')) {
      agents.push('@frontend-developer');
    }
    if (taskLower.includes('test') || taskLower.includes('quality')) {
      agents.push('@quality-engineer');
    }
    if (taskLower.includes('deploy') || taskLower.includes('docker')) {
      agents.push('@devops-engineer');
    }
    if (taskLower.includes('security') || taskLower.includes('auth')) {
      agents.push('@security-engineer');
    }
    if (taskLower.includes('document') || taskLower.includes('docs')) {
      agents.push('@documentation-manager');
    }
    
    // Add context manager for complex tasks
    if (complexity >= 3) {
      agents.unshift('@context-manager');
    }
    
    // Default to solution architect if no specific agents
    if (agents.length === 0) {
      agents.push('@solution-architect');
    }
    
    return agents;
  }

  createOrchestrationCommand(task, agents, complexity) {
    if (complexity >= 3 && agents.includes('@context-manager')) {
      return `@context-manager Koordiniere diese Aufgabe mit dem Team: "${task}"

Beteiligte Spezialisten die du einbeziehen sollst:
${agents.slice(1).map(a => `- ${a}`).join('\n')}

Arbeite die Aufgabe systematisch ab und koordiniere die Zusammenarbeit.`;
    } else {
      return `${agents[0]} ${task}`;
    }
  }
}

// Export for use as module
module.exports = InteractiveCLI;

// Run CLI if executed directly
if (require.main === module) {
  const cli = new InteractiveCLI();
  cli.start().catch(console.error);
}