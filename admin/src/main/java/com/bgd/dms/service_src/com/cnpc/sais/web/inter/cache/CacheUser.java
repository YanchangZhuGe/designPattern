package com.cnpc.sais.web.inter.cache;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.cfg.PropertyConfig;
import com.cnpc.sais.web.inter.util.MvcDaoFactory;

public class CacheUser implements ICacheUser {
//	public static IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();
	private static ICacheUser instance = new CacheUser();
	private static Properties localeMap;
	
	private CacheUser(){
//		List list = jdbcDao.queryRecords("select * from P_COM_INTERNATIONAL");
		loadCache();
		
	}
	
	public static ICacheUser getInstance(){
		return instance;
	}

	public void addOrUpdateCache(String entity_id) {
//		Map map = jdbcDao.queryRecordBySQL("select * from P_COM_INTERNATIONAL where entity_id='"+entity_id+"'");
//		CacheSingle.getInstance().storeObject(map.get("option_name").toString(), map);
		
		Connection conn = null;
		try{
			conn = MvcDaoFactory.getConnection();
			PreparedStatement ps = conn.prepareStatement("select * from P_COM_INTERNATIONAL where entity_id='"+entity_id+"'");
			ResultSet rs = ps.executeQuery();
			
			ResultSetMetaData rsmd = (ResultSetMetaData)rs.getMetaData();
			while(rs.next()){
				Map map = new HashMap();
				for(int i=1;i<=rsmd.getColumnCount();i++){
					map.put(rsmd.getColumnName(i).toLowerCase(), rs.getObject(rsmd.getColumnName(i)));
//					System.out.println(rsmd.getColumnName(i).toLowerCase() + " ***** "+ rs.getObject(rsmd.getColumnName(i)));
				}
				CacheSingle.getInstance().storeObject(map.get("option_name").toString(), map);
			}
			rs.close();
			ps.close();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}


	public void deleteFromCache(String key) {
		// TODO Auto-generated method stub
		CacheSingle.getInstance().reMoveObject(key);
	}

	public Map getCacheMapByKey(String key) {
		// TODO Auto-generated method stub
		return (Map)CacheSingle.getInstance().retrieveObject(key);
	}
	
	
	public String getLocaleValue(String locale){
		String result = null;
		if(localeMap == null){
			//加载locale.properties
			InputStream confs_is = PropertyConfig.class.getClassLoader().getResourceAsStream("locale.properties");
			localeMap = new Properties();
			
			try {
				localeMap.load(confs_is);
				confs_is.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		result = localeMap.getProperty(locale);
		if(StringUtils.isEmpty(result))
			result = "gb";
		return result;
	}

	public void loadCache(){
		Connection conn = null;
		try{
			conn = MvcDaoFactory.getConnection();
			PreparedStatement ps = conn.prepareStatement("select * from P_COM_INTERNATIONAL");
			ResultSet rs = ps.executeQuery();
			
			ResultSetMetaData rsmd = (ResultSetMetaData)rs.getMetaData();
			CacheSingle.getInstance().clear();
			while(rs.next()){
				Map map = new HashMap();
				for(int i=1;i<=rsmd.getColumnCount();i++){
					//将每条记录都放到map中
					map.put(rsmd.getColumnName(i).toLowerCase(), rs.getObject(rsmd.getColumnName(i)));
//					System.out.println(rsmd.getColumnName(i).toLowerCase() + " ***** "+ rs.getObject(rsmd.getColumnName(i)));
				}
				//字段名称：该记录值
				CacheSingle.getInstance().storeObject(map.get("option_name").toString(), map);
			}
			rs.close();
			ps.close();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	public static void main(String[] args){
		CacheUser.getInstance();
	}
	
	
}
