/**
 * Agent Integration Module
 * Integrates cache, health monitoring, and error recovery into agents
 */

const fs = require('fs').promises;
const path = require('path');

class AgentIntegration {
  constructor() {
    this.cacheManager = null;
    this.healthMonitor = null;
    this.errorRecovery = null;
    this.initialized = false;
  }

  /**
   * Initialize all systems
   */
  async initialize() {
    if (this.initialized) return;
    
    try {
      // Load Cache Manager
      const CacheManager = require('../cache/cache-manager');
      this.cacheManager = new CacheManager();
      console.log('✓ Cache Manager initialized');
      
      // Load Health Monitor
      const HealthMonitor = require('../health/health-monitor');
      this.healthMonitor = new HealthMonitor();
      console.log('✓ Health Monitor initialized');
      
      // Load Error Recovery
      const ErrorRecovery = require('../recovery/error-recovery');
      this.errorRecovery = new ErrorRecovery();
      console.log('✓ Error Recovery initialized');
      
      // Load configuration
      await this.loadConfiguration();
      
      // Warm up cache
      await this.warmupCache();
      
      this.initialized = true;
      console.log('✓ Agent Integration initialized successfully');
    } catch (error) {
      console.error('Failed to initialize agent integration:', error);
      throw error;
    }
  }

  /**
   * Load configuration
   */
  async loadConfiguration() {
    try {
      const configPath = path.join(__dirname, '../cache/config/cache-config.json');
      const config = JSON.parse(await fs.readFile(configPath, 'utf8'));
      
      // Apply configuration
      if (config.cache.warmupOnStart && config.cache.warmup) {
        this.warmupPatterns = config.cache.warmup.patterns;
        this.warmupLibraries = config.cache.warmup.libraries;
      }
    } catch (error) {
      console.warn('Could not load configuration:', error.message);
    }
  }

  /**
   * Warm up cache with frequently used patterns
   */
  async warmupCache() {
    if (!this.cacheManager || !this.warmupPatterns) return;
    
    console.log('Warming up cache...');
    await this.cacheManager.warmup(this.warmupPatterns);
    console.log('✓ Cache warmed up');
  }

  /**
   * Execute agent task with all integrations
   */
  async executeAgentTask(agentName, task, context = {}) {
    // Check cache first
    const cacheKey = this.cacheManager?.generateKey({ agent: agentName, task }, 'agent-task');
    const cached = this.cacheManager?.get(cacheKey, 'responses');
    
    if (cached) {
      console.log(`Cache hit for ${agentName}`);
      return cached;
    }
    
    // Execute with error recovery
    const result = await this.errorRecovery?.executeWithRecovery(
      async () => {
        // Record agent activity for health monitoring
        if (this.healthMonitor) {
          this.healthMonitor.agents[agentName] = {
            status: 'active',
            lastCheck: Date.now()
          };
        }
        
        // Execute actual agent task
        const response = await this.performAgentTask(agentName, task, context);
        
        // Cache successful result
        if (this.cacheManager) {
          await this.cacheManager.cacheAgentResponse(agentName, task, response);
        }
        
        // Update health status
        if (this.healthMonitor) {
          this.healthMonitor.agents[agentName].status = 'healthy';
        }
        
        return response;
      },
      {
        agent: agentName,
        task,
        ...context
      }
    ) || await this.performAgentTask(agentName, task, context);
    
    return result;
  }

  /**
   * Perform actual agent task (to be implemented by specific agents)
   */
  async performAgentTask(agentName, task, context) {
    // This would be implemented by specific agent implementations
    // For now, simulate agent task execution
    console.log(`Executing task for ${agentName}: ${task}`);
    
    return {
      agent: agentName,
      task,
      result: `Task completed by ${agentName}`,
      timestamp: new Date().toISOString()
    };
  }

  /**
   * Get agent health status
   */
  async getAgentHealth(agentName) {
    if (!this.healthMonitor) {
      return { status: 'unknown', message: 'Health monitor not available' };
    }
    
    const agentInfo = this.healthMonitor.agents[agentName];
    if (!agentInfo) {
      return { status: 'unknown', message: 'Agent not registered' };
    }
    
    return {
      status: agentInfo.status,
      lastCheck: new Date(agentInfo.lastCheck).toISOString(),
      responseTime: agentInfo.responseTime
    };
  }

  /**
   * Get cache statistics for agent
   */
  getCacheStats(agentName) {
    if (!this.cacheManager) {
      return { available: false };
    }
    
    const stats = this.cacheManager.getStats();
    
    // Filter for agent-specific stats
    const agentItems = Array.from(this.cacheManager.cache.values())
      .filter(item => item.metadata?.agent === agentName);
    
    return {
      available: true,
      totalItems: agentItems.length,
      hitRate: stats.hitRate,
      cacheSize: stats.totalSize
    };
  }

  /**
   * Clear agent-specific cache
   */
  clearAgentCache(agentName) {
    if (!this.cacheManager) return;
    
    // Clear agent-specific cached items
    for (const [key, item] of this.cacheManager.cache.entries()) {
      if (item.metadata?.agent === agentName) {
        this.cacheManager.cache.delete(key);
        this.cacheManager.currentSize -= item.size;
      }
    }
  }

  /**
   * Run health check for specific agent
   */
  async checkAgentHealth(agentName) {
    if (!this.healthMonitor) {
      return { healthy: false, reason: 'Health monitor not available' };
    }
    
    try {
      // Simulate agent ping
      const startTime = Date.now();
      const available = await this.pingAgent(agentName);
      const responseTime = Date.now() - startTime;
      
      const healthy = available && responseTime < 1000;
      
      // Update health monitor
      this.healthMonitor.agents[agentName] = {
        status: healthy ? 'healthy' : 'unhealthy',
        lastCheck: Date.now(),
        responseTime
      };
      
      return {
        healthy,
        responseTime,
        status: healthy ? 'operational' : 'degraded'
      };
    } catch (error) {
      return {
        healthy: false,
        error: error.message
      };
    }
  }

  /**
   * Ping agent to check availability
   */
  async pingAgent(agentName) {
    // Check if agent file exists
    const agentPaths = [
      path.join(__dirname, '../../agents/generic', `${agentName}.md`),
      path.join(__dirname, '../../agents/specialized', `${agentName}.md`),
      path.join(__dirname, '../../agents/framework', `${agentName}.md`)
    ];
    
    for (const agentPath of agentPaths) {
      try {
        await fs.access(agentPath);
        return true;
      } catch {
        // Continue checking other paths
      }
    }
    
    return false;
  }

  /**
   * Get integration status
   */
  getStatus() {
    return {
      initialized: this.initialized,
      cache: this.cacheManager ? 'active' : 'inactive',
      health: this.healthMonitor ? 'active' : 'inactive',
      recovery: this.errorRecovery ? 'active' : 'inactive',
      stats: {
        cache: this.cacheManager?.getStats() || {},
        health: this.healthMonitor?.getStatusSummary() || {},
        recovery: this.errorRecovery?.getStats() || {}
      }
    };
  }

  /**
   * Shutdown integration
   */
  async shutdown() {
    console.log('Shutting down agent integration...');
    
    // Stop health monitoring
    if (this.healthMonitor) {
      this.healthMonitor.stopMonitoring();
    }
    
    // Persist cache
    if (this.cacheManager) {
      await this.cacheManager.persistCache();
      this.cacheManager.stopAutoPersist();
    }
    
    console.log('✓ Agent integration shutdown complete');
  }
}

// Singleton instance
let integrationInstance = null;

/**
 * Get or create integration instance
 */
function getIntegration() {
  if (!integrationInstance) {
    integrationInstance = new AgentIntegration();
  }
  return integrationInstance;
}

// Export for use in agents
module.exports = {
  AgentIntegration,
  getIntegration,
  
  // Convenience methods for agents
  async executeTask(agentName, task, context) {
    const integration = getIntegration();
    await integration.initialize();
    return integration.executeAgentTask(agentName, task, context);
  },
  
  async getHealth(agentName) {
    const integration = getIntegration();
    await integration.initialize();
    return integration.getAgentHealth(agentName);
  },
  
  async getCacheStats(agentName) {
    const integration = getIntegration();
    await integration.initialize();
    return integration.getCacheStats(agentName);
  }
};

// CLI interface if run directly
if (require.main === module) {
  const integration = getIntegration();
  
  async function main() {
    await integration.initialize();
    
    console.log('\n📊 Integration Status:');
    console.log(JSON.stringify(integration.getStatus(), null, 2));
    
    // Example agent task
    console.log('\n🤖 Testing agent task execution...');
    const result = await integration.executeAgentTask(
      'backend-developer',
      'Create REST API endpoint',
      { project: 'test' }
    );
    console.log('Result:', result);
    
    // Cleanup
    await integration.shutdown();
  }
  
  main().catch(console.error);
}