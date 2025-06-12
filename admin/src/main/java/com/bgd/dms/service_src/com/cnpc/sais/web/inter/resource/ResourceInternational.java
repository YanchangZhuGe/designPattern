package com.cnpc.sais.web.inter.resource;

import com.cnpc.sais.web.inter.filter.RegularConstant;
import com.cnpc.sais.web.inter.util.RegularReplace;

public class ResourceInternational {
	//private static ICacheUser cache = CacheUser.getInstance();
	/**
	 * 图片资源国际化
	 * @author maxiaofeng
	 * @param htmlStr 输入要国际化的页面html
	 * @return 返回国际化后的html页面
	 */
	public static String pictureRI(String htmlStrP,String[] regular,String replaceStr){
		for(int i = 0 ; i < regular.length ; i++){
			htmlStrP = replaceResource(htmlStrP,regular[i],replaceStr);
		}
		return htmlStrP;
	}
	
	public static String cssRI(String htmlStrC,String[] regular,String replaceStr){
		for(int i = 0 ; i < regular.length ; i++){
			htmlStrC = replaceResource(htmlStrC,regular[i],replaceStr);
		}
		return htmlStrC;
	}
		
	public static String jsRI(String htmlStrC,String[] regular,String replaceStr){
		for(int i = 0 ; i < regular.length ; i++){
			htmlStrC = replaceResource(htmlStrC,regular[i],replaceStr);
		}
		return htmlStrC;
	}
	
	private static String replaceResource(String htmlStr,String regular,String reStr){
		 RegularReplace rr=new RegularReplace(htmlStr,regular); 
	        while(rr.find()) 
	        { 
	            rr.setGroup(1, reStr); 
	            rr.replace(); 
	        } 
	        return rr.getResult();
	}
	
	public static void main(String[] args){
		String str = "JCDP_alert_choose_first!";
		str = ResourceInternational.jsRI(str, RegularConstant.TEXT_REGULAR, "新建");
		System.out.println(str);
	}
}
