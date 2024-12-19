import { Config } from './config';
import { CacheState, CacheIndex } from './interfaces';

export class Cacher {

  // The index is used to count keep track of when items entered into
  // the cache. We're basically making a kill-ring.
  protected cacheIndex: CacheIndex = new Set<string>();
  protected state: CacheState<string> = new Map<string, string>();
  protected config: Config;

  constructor(config: Config){
    this.config = config;
  }

  /**
   * Fetch a VAL by KEY
   * @param {string} key
   * @returns String | null
   */
  public fetch(key: string): string | null {
    let cacheObject = this.state.get(key);
    if(!cacheObject) { return null; }
    return cacheObject;
  }

  /**
   * Add a KEY and VAL to the cache
   * @param {string} key
   * @param {string} val
   * @returns Boolean
   */
  public add(key: string, val: string): Boolean {
    if (this.cacheIndex.size >= this.config.cacheSizeMax!) {
      this.trimCache();
    }

    this.state.set(key, val);
    this.cacheIndex.add(key);

    return true;
  }

  /**
   * Remove a VAL by KEY
   * @param {string} key
   * @returns Boolean
   */
  public remove(key: string): boolean {
    // This is O(1):
    // https://adrianmejia.com/data-structures-time-complexity-for-beginners-arrays-hashmaps-linked-lists-stacks-queues-tutorial/#Set-Operations-runtime
    this.cacheIndex.delete(key);

    // This is O(1):
    return this.state.delete(key);
  }

  /**
   * Return basic info about the state of the cache.
   * @returns Object
   */
  public stats() {
    return {
      index: this.cacheIndex,
      cache: this.state,
      config: this.config
    };
  }
  
  /**
   * Trim the cache by removing the oldest item in the index.
   * @returns void
   */
  private trimCache() {
    // Get the first element in the set
    let idx: string = this.cacheIndex.values().next().value!;
    if (!idx) { return true; }

    // Delete the state by key
    this.remove(idx);
  }
}
