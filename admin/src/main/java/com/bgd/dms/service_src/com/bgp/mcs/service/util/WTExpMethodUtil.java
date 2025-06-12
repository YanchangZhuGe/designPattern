package com.bgp.mcs.service.util;

import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;

/**   
 * @Title: WTExplorationMethodUtil.java
 * @Package com.bgp.mcs.service.util
 * @Description: 为综合物化探的项目勘探方法查询
 * @author wuhj 
 * @date 2014-8-22 上午9:00:26
 * @version V1.0   
 */
public class WTExpMethodUtil
{
	private static IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	
	public static String queryExplMethodForProject(String projectInfoNo){
		
		String sql = "select t.exploration_method expMethods from gp_task_project t where t.project_info_no = '"+projectInfoNo+"'";
		
		Map map = jdbcDao.queryRecordBySQL(sql);
		
		Object expMethod = map.get("expMethods");
		
		StringBuffer sb = new StringBuffer("");
		
		if(expMethod!=null){
			
			String exp_method[] = expMethod.toString().split(",");
			
			for(int i=0; i<exp_method.length; i++){
				if(sb.toString().equals("")){
					sb.append("'"+exp_method[i]+"'");
				} else {
					sb.append(",'"+exp_method[i]+"'");
				}
			}
			
			return sb.toString();
		} else {
			return null;
		}
		
	}

}
