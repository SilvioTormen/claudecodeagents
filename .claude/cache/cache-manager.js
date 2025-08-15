/**
 * Cache Manager for Claude Agent System
 * Implements LRU cache with TTL for improved performance
 */

const fs = require('fs').promises;
const path = require('path');
const crypto = require('crypto');

class CacheManager {
  constructor(config = {}) {
    this.cache = new Map();
    this.maxSize = config.maxSize || 100 * 1024 * 1024; // 100MB default
    this.currentSize = 0;
    this.hits = 0;
    this.misses = 0;
    
    // TTL settings in milliseconds
    this.ttl = {
      responses: config.ttl?.responses || 3600000,    // 1 hour
      docs: config.ttl?.docs || 86400000,             // 24 hours
      patterns: config.ttl?.patterns || 7200000,      // 2 hours
      memory: config.ttl?.memory || 1800000,          // 30 minutes
      ...config.ttl
    };
    
    // Persistence settings
    this.persistPath = config.persistPath || path.join(__dirname, 'persistent-cache.json');
    this.autoPersist = config.autoPersist !== false;
    this.persistInterval = config.persistInterval || 300000; // 5 minutes
    
    // Start auto-persist if enabled
    if (this.autoPersist) {
      this.startAutoPersist();
    }
    
    // Load persistent cache on startup
    this.loadPersistentCache();
  }

  /**
   * Generate cache key from input
   */
  generateKey(input, namespace = 'default') {
    const hash = crypto.createHash('sha256');
    hash.update(`${namespace}:${JSON.stringify(input)}`);
    return hash.digest('hex');
  }

  /**
   * Get item from cache
   */
  get(key, category = 'responses') {
    const item = this.cache.get(key);
    
    if (!item) {
      this.misses++;
      return null;
    }
    
    // Check TTL
    const ttl = this.ttl[category] || this.ttl.responses;
    if (Date.now() - item.timestamp > ttl) {
      this.cache.delete(key);
      this.currentSize -= item.size;
      this.misses++;
      return null;
    }
    
    // Update LRU - move to end
    this.cache.delete(key);
    this.cache.set(key, item);
    
    this.hits++;
    item.accessCount++;
    item.lastAccessed = Date.now();
    
    return item.data;
  }

  /**
   * Set item in cache
   */
  set(key, data, category = 'responses', metadata = {}) {
    const serialized = JSON.stringify(data);
    const size = Buffer.byteLength(serialized);
    
    // Check if item would exceed max size
    if (size > this.maxSize) {
      console.warn(`Cache item too large: ${size} bytes`);
      return false;
    }
    
    // Evict items if necessary
    while (this.currentSize + size > this.maxSize && this.cache.size > 0) {
      this.evictOldest();
    }
    
    // Remove old version if exists
    if (this.cache.has(key)) {
      const oldItem = this.cache.get(key);
      this.currentSize -= oldItem.size;
    }
    
    // Add new item
    const cacheItem = {
      data,
      category,
      timestamp: Date.now(),
      lastAccessed: Date.now(),
      size,
      accessCount: 0,
      metadata,
      key
    };
    
    this.cache.set(key, cacheItem);
    this.currentSize += size;
    
    return true;
  }

  /**
   * Evict oldest item (LRU)
   */
  evictOldest() {
    const firstKey = this.cache.keys().next().value;
    if (firstKey) {
      const item = this.cache.get(firstKey);
      this.currentSize -= item.size;
      this.cache.delete(firstKey);
    }
  }

  /**
   * Clear entire cache or specific category
   */
  clear(category = null) {
    if (!category) {
      this.cache.clear();
      this.currentSize = 0;
      this.hits = 0;
      this.misses = 0;
    } else {
      for (const [key, item] of this.cache.entries()) {
        if (item.category === category) {
          this.currentSize -= item.size;
          this.cache.delete(key);
        }
      }
    }
  }

  /**
   * Get cache statistics
   */
  getStats() {
    const items = Array.from(this.cache.values());
    const categoryCounts = {};
    const categorySize = {};
    
    for (const item of items) {
      categoryCounts[item.category] = (categoryCounts[item.category] || 0) + 1;
      categorySize[item.category] = (categorySize[item.category] || 0) + item.size;
    }
    
    return {
      totalItems: this.cache.size,
      totalSize: this.currentSize,
      maxSize: this.maxSize,
      utilizationPercent: ((this.currentSize / this.maxSize) * 100).toFixed(2),
      hits: this.hits,
      misses: this.misses,
      hitRate: this.hits + this.misses > 0 
        ? ((this.hits / (this.hits + this.misses)) * 100).toFixed(2) 
        : 0,
      categoryCounts,
      categorySize,
      oldestItem: items.length > 0 ? new Date(items[0].timestamp) : null,
      newestItem: items.length > 0 ? new Date(items[items.length - 1].timestamp) : null
    };
  }

  /**
   * Cache frequently used patterns
   */
  async cachePattern(pattern, agents, complexity, successRate) {
    const key = this.generateKey(pattern, 'pattern');
    return this.set(key, {
      pattern,
      agents,
      complexity,
      successRate,
      cached: true
    }, 'patterns');
  }

  /**
   * Cache library documentation
   */
  async cacheLibraryDoc(library, version, documentation) {
    const key = this.generateKey({ library, version }, 'docs');
    return this.set(key, documentation, 'docs', { library, version });
  }

  /**
   * Get cached library documentation
   */
  getLibraryDoc(library, version) {
    const key = this.generateKey({ library, version }, 'docs');
    return this.get(key, 'docs');
  }

  /**
   * Cache agent response
   */
  async cacheAgentResponse(agent, task, response) {
    const key = this.generateKey({ agent, task }, 'agent-response');
    return this.set(key, response, 'responses', { agent, task });
  }

  /**
   * Get cached agent response
   */
  getAgentResponse(agent, task) {
    const key = this.generateKey({ agent, task }, 'agent-response');
    return this.get(key, 'responses');
  }

  /**
   * Persist cache to disk
   */
  async persistCache() {
    try {
      const persistData = {
        cache: Array.from(this.cache.entries()),
        stats: {
          hits: this.hits,
          misses: this.misses,
          currentSize: this.currentSize
        },
        timestamp: Date.now()
      };
      
      await fs.writeFile(
        this.persistPath, 
        JSON.stringify(persistData, null, 2)
      );
      
      return true;
    } catch (error) {
      console.error('Failed to persist cache:', error);
      return false;
    }
  }

  /**
   * Load cache from disk
   */
  async loadPersistentCache() {
    try {
      const data = await fs.readFile(this.persistPath, 'utf8');
      const persistData = JSON.parse(data);
      
      // Restore cache entries that haven't expired
      for (const [key, item] of persistData.cache) {
        const ttl = this.ttl[item.category] || this.ttl.responses;
        if (Date.now() - item.timestamp < ttl) {
          this.cache.set(key, item);
          this.currentSize += item.size;
        }
      }
      
      // Restore stats
      this.hits = persistData.stats.hits || 0;
      this.misses = persistData.stats.misses || 0;
      
      console.log(`Loaded ${this.cache.size} items from persistent cache`);
      return true;
    } catch (error) {
      // File doesn't exist or is corrupted - start fresh
      return false;
    }
  }

  /**
   * Start auto-persist interval
   */
  startAutoPersist() {
    this.persistTimer = setInterval(() => {
      this.persistCache();
    }, this.persistInterval);
  }

  /**
   * Stop auto-persist
   */
  stopAutoPersist() {
    if (this.persistTimer) {
      clearInterval(this.persistTimer);
      this.persistTimer = null;
    }
  }

  /**
   * Cleanup expired items
   */
  cleanup() {
    let cleaned = 0;
    for (const [key, item] of this.cache.entries()) {
      const ttl = this.ttl[item.category] || this.ttl.responses;
      if (Date.now() - item.timestamp > ttl) {
        this.currentSize -= item.size;
        this.cache.delete(key);
        cleaned++;
      }
    }
    return cleaned;
  }

  /**
   * Warm up cache with frequently used items
   */
  async warmup(items) {
    for (const item of items) {
      if (item.type === 'pattern') {
        await this.cachePattern(item.pattern, item.agents, item.complexity, item.successRate);
      } else if (item.type === 'doc') {
        await this.cacheLibraryDoc(item.library, item.version, item.documentation);
      }
    }
  }
}

// Export for use in other modules
module.exports = CacheManager;

// CLI interface if run directly
if (require.main === module) {
  const cache = new CacheManager();
  
  // Example usage
  console.log('Cache Manager CLI');
  console.log('Stats:', cache.getStats());
  
  // Cleanup on exit
  process.on('SIGINT', async () => {
    console.log('\nPersisting cache before exit...');
    await cache.persistCache();
    process.exit(0);
  });
}