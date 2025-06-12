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
	 * ������Դ���ʻ�
	 * @author maxiaofeng
	 * @param htmlStr ����Ҫ���ʻ���ҳ��html
	 * @return ���ع��ʻ����htmlҳ��
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
