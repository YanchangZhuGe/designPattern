package com.bgp.mcs.service.util;

import java.util.Calendar;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class CacheUtil {

	private static JedisPool pool = null;
	private static boolean disabled = true;
	
	static{
		ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
		String enable = cfgHd.getSingleNodeValue("//external_url/redis/enable");
		if("1".equals(enable)){
			
			disabled = false;
			
			String host = cfgHd.getSingleNodeValue("//external_url/redis/host");
			String port = cfgHd.getSingleNodeValue("//external_url/redis/port");
			
			JedisPoolConfig config = new JedisPoolConfig();
			config.setMaxActive(200);
			config.setMaxIdle(100);
			
			pool = new JedisPool(config, host, Integer.parseInt(port));
		}
	}
	
	/**
	 * 根据多个字段，生成key
	 * @param params
	 * @return
	 */
	public static Object genKey(String ... params){
		
		StringBuilder sb = new StringBuilder();
		
		for( String param : params ){
			sb.append("_").append(param); 
		}
		
		return sb.toString();
	}

	/**
	 * 保存到缓存
	 * @return
	 */
	public static void set(Object key, Object value){
		
		if(disabled) return;
		
		Jedis jedis = pool.getResource();
		
		byte[] rkey = key.toString().getBytes();
		
		jedis.set(rkey, SerializeUtil.serialize(value));
		
		Calendar c = Calendar.getInstance();
		
		c.add(Calendar.DAY_OF_MONTH, 1);
		c.set(Calendar.HOUR_OF_DAY, 1);
		
		//System.out.println(c.getTime().toString());
		
		long d = c.getTimeInMillis()/1000;
		
		//System.out.println(d);
		
		jedis.expireAt(rkey, d);
		
		pool.returnBrokenResource(jedis);
	}

	/**
	 * 从缓存读取
	 * @return
	 */
	public static Object get(Object key){
		
		if(disabled) return null;
		
		Jedis jedis = pool.getResource();
		
		byte[] data = jedis.get(key.toString().getBytes());

		pool.returnBrokenResource(jedis);
		
		if(data==null){
			return null;
		}
		
		return SerializeUtil.unserialize(data);
	}
	
	public static void main(String[] args) {

		//CacheUtil.set("ddd", "bbb");
		
		System.out.println( CacheUtil.get("ddd") );
		
		
	}
	
}
