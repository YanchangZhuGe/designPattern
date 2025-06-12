package com.cnpc.sais.web.inter.resource;

import com.cnpc.sais.web.inter.filter.RegularConstant;
import com.cnpc.sais.web.inter.util.RegularReplace;

public class ResourceInternational {
	//private static ICacheUser cache = CacheUser.getInstance();
	/**
	 * ͼƬ��Դ���ʻ�
	 * @author maxiaofeng
	 * @param htmlStr ����Ҫ���ʻ���ҳ��html
	 * @return ���ع��ʻ����htmlҳ��
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
		str = ResourceInternational.jsRI(str, RegularConstant.TEXT_REGULAR, "�½�");
		System.out.println(str);
	}
}
