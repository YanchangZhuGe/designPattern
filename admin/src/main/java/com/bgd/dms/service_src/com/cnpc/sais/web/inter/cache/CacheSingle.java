package com.cnpc.sais.web.inter.cache;

import com.whirlycott.cache.Cache;
import com.whirlycott.cache.CacheException;
import com.whirlycott.cache.CacheManager;

public class CacheSingle {
	private Cache cache;
	// 创建一个单例
	static private CacheSingle instance = new CacheSingle();

	// 构造函数
	private  CacheSingle() {
		try {
			// 初始化缓存对象
			cache = CacheManager.getInstance().getCache();
		} catch (CacheException ex) {
		} catch (LinkageError e) {
		}
	}
	public static CacheSingle getInstance() {
		return instance;
	}

	public void storeObject(String key, Object obj) {
		cache.store(key, obj);
	}

	public Object retrieveObject(String key) {
		return cache.retrieve(key);
	}
	
	public void reMoveObject(String key){
		cache.remove(key);
	}
	public void clear() {
		if (cache != null) {
			cache.clear();
		}
	}

	public int size() {
		return this.cache.size();
	}
}
