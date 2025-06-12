package com.cnpc.sais.web.inter.cache;

import java.util.Map;

public interface ICacheUser {
	public void addOrUpdateCache(String entity_id);
	/**
	 * 
	 * @param key option_name
	 */
	public void deleteFromCache(String entity_id);
	/**
	 * 
	 * @param key option_name
	 * @return
	 */
	public Map getCacheMapByKey(String key);
	public String getLocaleValue(String lowerCase);
	
	public void loadCache();
}
