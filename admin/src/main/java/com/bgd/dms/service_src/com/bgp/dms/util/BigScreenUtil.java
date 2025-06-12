package com.bgp.dms.util;

import java.util.HashMap;
import java.util.Map;

public class BigScreenUtil {
	/**
	 * 大屏字体微软雅黑
	 */
	public static final String BIG_SCREEN_FONT_FAMILY="Microsoft YaHei";
	/**
	 * 大屏字体大小20
	 */
	public static final String BIG_SCREEN_FONT_SIZE = "20";
	/**
	 * 大屏显示单位简称
	 */
	public static Map<String, String> BIG_SCREEN_ORG_ABBREVIATION=new HashMap<String,String>();
	
	static{
		BIG_SCREEN_ORG_ABBREVIATION.put("C105002","国际部");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105001005","塔里木");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105001002","新疆");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105001003","吐哈");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105001004","青海");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105005004","长庆");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105005000","华北");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105005001","新兴");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105007","大港");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105063","辽河");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105086","深海");
		BIG_SCREEN_ORG_ABBREVIATION.put("C105006","装备");
    }
}
