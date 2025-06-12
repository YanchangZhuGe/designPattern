package com.cnpc.sais.ibp.auth2.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

/**
 * 
* @ClassName: SelectRolesUtils
* @Description: 根据登录管理员id，区别管理员具有的角色分类
* @author wuhj
* @date 2013-9-25 下午2:37:42
*
 */
public class SelectRolesUtils {
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	private static List<String> wtcList = new ArrayList<String>();
	private static List<String> zbcList = new ArrayList<String>();
	//装备处
	private static String zbcCoding = "'5110000045000000046','5110000045000000052','5110000045000000053'";
	//物探处
	private static String wtcCoding = "'5110000045000000002'";
	//功能权限
	private static String gnCoding = "'5110000045000000041'";
	//地震队
	private static String dzdCoding = "'5110000045000000003'";

	private static String sql = "select tail.coding_code_id from comm_coding_sort_detail tail where tail.superior_code_id in (#CODING#)";
	
	private static String CODE = "#CODING#";
	
	static {
		//物探处管理员帐号
		wtcList.add("tlmwtc");
		wtcList.add("bjjlb_m");
		wtcList.add("thjlb_m");
		wtcList.add("dhjlb_m");
		wtcList.add("cq_manager");
		wtcList.add("hsktsyb_m");
		wtcList.add("lh_gpeadmin");
		wtcList.add("hbwtc_m");
		wtcList.add("xxwtkfc_m");
		wtcList.add("cjjszcb_m");
		//装配处管理员
		zbcList.add("zbsyb_m");
	}

	public  String gainSystemManagerCategory(String longid){
		
		StringBuffer sb = new StringBuffer();
		
		//物探处
		if(wtcList.contains(longid)){
//			sb.append(dzdCoding);

			String wtcsql= sql.replace(CODE, wtcCoding +","+gnCoding);
			
			return processSQL(wtcsql,longid);
		}
		if(zbcList.contains(longid)){

			String zbcsql= sql.replace(CODE, zbcCoding +","+gnCoding);
			
			return processSQL(zbcsql,longid);
		}
		
		return " like '5%'";
	}
	
	private String processSQL(String sql,String longid){
		
		StringBuffer sb = new StringBuffer();
		
		List<Map> zbcLs =jdbcDao.queryRecords(sql);
		
		for(Map map:zbcLs){
			sb.append("'"+map.get("coding_code_id")+"',");
		}
		if(wtcList.contains(longid)){
			sb.append(dzdCoding+",");
		}
		
		String wSQL = sb.toString();
		wSQL = wSQL.substring(0, wSQL.length()-1);
		
		return "in ("+wSQL+")";
	}
	
	public static void main(String args[]){
		
		String  s = "sdfsd,";
		System.out.println(s.subSequence(0, s.length()-1));
//		SelectRolesUtils sl = new SelectRolesUtils();
//		sl.gainSystemManagerCategory("tlmwtc");
	}

}
