package com.bgp.dms.util;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider;
import com.cnpc.jcdp.util.AppCrypt;

/**
 * 
 * @author dushuai
 *
 */
public  class ServiceUtils {

	/**
	 * @Title: setCommFields 
	 * @Description: 设置公共字段
	 * @param @param data
	 * @param @param pkField
	 * @param @param user    设定文件 
	 * @return void    返回类型 
	 * @throws
	 */
	@SuppressWarnings("unchecked")
	public static void setCommFields(Map data, String pkField, UserToken user){
		Date date = new Date();
        String userId = user==null ? "" : user.getUserId();
		String pkValue = (String)data.get(pkField);
		if(StringUtils.isBlank(pkValue)){// 不包含主键，判断为insert操作
			data.put("bsflag", "0");
			
			data.put("create_date", date);
			data.put("update_date", date);
			data.put("modify_date", date);
			
			data.put("creater", userId);
			data.put("updater", userId);
			data.put("creator", userId);
			data.put("updator", userId);
			
		}else{ //包含主键，判断为update操作

			data.put("update_date", date);
			data.put("modify_date", date);	
			data.put("updater", userId);
			data.put("updator", userId);
		}
	}
	private static String getString(String id,List<String> list){
		StringBuffer sb=new StringBuffer();
		String returnString="";
		if(list.size()==0||null==list){
		returnString=sb.append(id).append("=''").toString();
		} 
		for(int i=0;i<list.size();i++){
		if(i==0){
		sb.append(id);
		sb.append(" in (");
		}
		sb.append("'");
		sb.append(list.get(i).toString());
		sb.append("'");
		if(i>=900&&i<list.size()-1){
		if(i%900==0){
		sb.append(") or ");
		sb.append(id);
		sb.append(" in (");
		}else{
		sb.append(",");
		}
		}else{
		if(i<list.size()-1){
		sb.append(",");
		}
		}
		if(i==list.size()-1){
		sb.append(")");
		}
		}
		returnString=sb.toString();
		return returnString;
		}
	public static void main(String[] args) {
		String t=AppCrypt.decrypt("E4751A694727A678A2F44950ACCCD284").toString();
		System.out.println(t);
		 
	}
}
