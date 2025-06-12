package com.bgp.dms.charts.cache;

import java.util.HashMap;
import java.util.Map;
/**
 * »º´æ
 * @author Administrator
 *
 */
public class SelfCacheUtil {
	private static Map<String, Object> chartsCache = new HashMap<String, Object>();
	public static void addCache(String key,Object obj){
		if(chartsCache.get(key)!=null){
			chartsCache.put(key, obj);
		}
	}
	public static void updateCache(String key,Object obj){
		if(chartsCache.get(key)!=null){
			chartsCache.put(key, obj);
		}
	}
	public static void clearCache(String key,Object obj){
		if(chartsCache.get(key)!=null){
			chartsCache.remove(key);
		}
	}
	public static Object getCache(String key){
		return chartsCache.get(key);
	}
}
