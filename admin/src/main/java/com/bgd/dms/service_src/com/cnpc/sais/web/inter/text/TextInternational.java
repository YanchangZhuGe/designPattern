package com.cnpc.sais.web.inter.text;

import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.sais.web.inter.cache.CacheUser;
import com.cnpc.sais.web.inter.cache.ICacheUser;
import com.cnpc.sais.web.inter.util.RegularReplace;

public class TextInternational {
	public static IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();
	/**
	 * 文字资源国际化
	 * @author maxiaofeng
	 * @param htmlStr 输入要国际化的页面html
	 * @return 返回国际化后的html页面
	 */
	public static String textRI(String htmlStrH,String[] regular,String local){
		for(int i = 0; i < regular.length; i++){
			htmlStrH = replaceResource(htmlStrH,regular[i],local);
		}
		return htmlStrH;
	}
	
	private static String replaceResource(String htmlStr,String regular,String local){
		 RegularReplace rr=new RegularReplace(htmlStr,regular); 
		 ICacheUser cache = CacheUser.getInstance();
	     while(rr.find()){ 
	        String plStr = rr.getGroup(1);
	        Map map = cache.getCacheMapByKey(plStr);
	        try{
	        rr.setGroup(1, map.get(local.toLowerCase()));
	        }catch(Exception e){
	        	if(map==null){
	        		rr.setGroup(1, plStr);
	        	}
	        }
	        rr.replace(); 
	     } 
	     return rr.getResult();
	}
}
