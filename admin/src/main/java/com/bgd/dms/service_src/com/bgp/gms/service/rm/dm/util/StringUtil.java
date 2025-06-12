package com.bgp.gms.service.rm.dm.util;

import org.apache.commons.lang.StringUtils;

public class StringUtil {

	public static String wrapString(String...params){
		StringBuilder sb = new StringBuilder();
		for (String s : params) {
			sb.append(s);
		}
		return sb.toString();
	}
	public static void main(String[] args) {
		System.out.println(StringUtil.wrapString("ss","dddd"));
	}
	/**
	 * 获取in查询字符串
	 * @param formatStr 如：a,b,c
	 * @return
	 */
	public static String getInSelectStr(String formatStr){
		String inSelectStr="";
		if(null !=formatStr && StringUtils.isNotBlank(formatStr)){
			if (formatStr.indexOf(",") > 0) {
				String[] arr=formatStr.split(",");
				inSelectStr="(";
				for(String str :arr){
					inSelectStr+="'"+str+"',";
				}
				inSelectStr=inSelectStr.substring(0,inSelectStr.length()-1);
				inSelectStr+=")";
			}else{
				inSelectStr="('"+formatStr+"')";
			}
		}
		return inSelectStr;
	}
}
