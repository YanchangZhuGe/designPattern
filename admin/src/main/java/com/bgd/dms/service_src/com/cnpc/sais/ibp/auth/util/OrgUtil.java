package com.cnpc.sais.ibp.auth.util;


import java.util.Hashtable;
import java.util.Map;

import com.cnpc.sais.ibp.auth.pojo.PAuthOrg;




/**
 * Project：CNLC OMS(Service)
 * 
 * Creator：rechete
 * 
 * Creator Time:2008-4-28 上午10:17:47
 * 
 * Description：System auth org Management Util
 * 
 * Revision history：
 * 
 * 
 * 
 */

public class OrgUtil {
	/**
	 * cache所有的org对象
	 */
	private static Map<String,PAuthOrg> orgs = new Hashtable();
	
	/**
	 * 根据orgId返回Org对象
	 * @param orgId
	 * @return
	 */
	public static PAuthOrg getOrg(String orgId){
		return orgs.get(orgId);		
	}
	
	public static String getSpecialityId(String s){
		String ret = null;
		if("T".equals(s)) ret = "8a84981219c2333d0119c237d285000c";
		else if("W".equals(s)) ret = "8a84981219c2333d0119c237d285000b";
		else if("M".equals(s)) ret = "8a84981219c2333d0119c237d285000d";
		else if("G".equals(s)) ret = "8a84981219c2333d0119c237d285000e";
	    return ret;
	}	
}
