package com.bgp.mcs.service.pm.service.project;

import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class DBDataService extends BaseService {

	public ISrvMsg queryTableDatas(ISrvMsg reqDTO) throws Exception {
		String tableName = reqDTO.getValue("tableName");
		String filterOption = reqDTO.getValue("option");
		String order = reqDTO.getValue("order");
		
		StringBuffer message = new StringBuffer();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select * from ");
		sql.append(tableName);
		if(filterOption != null){
			sql.append(" where ");
			sql.append(filterOption);
		}
		if(order != null){
			sql.append(" order by ");
			sql.append(order).append(" asc");
		}
		System.out.println("sql="+sql.toString());
		List<Map> datas = null;
		try{
			datas = jdbcDAO.queryRecords(sql.toString());
		}catch(Exception e){
			message.append("表名或查询条件字段不存在!");
		}
		responseMsg.setValue("datas", datas);
		responseMsg.setValue("message", message.toString());
		return responseMsg;
	}
	/**
	 * 
	* @Title: getOrganization1
	* @Description: 查询生产的物探处
	* @param @param orgSubId
	* @param @return    设定文件
	* @return List<Map>    返回类型
	* @throws
	 */
	public List<Map> getOrganization1(String orgSubId)
	{

		String sql = "select org_subjection_id as org_sub_id,org_short_name as org_name,org_id from bgp_comm_org_wtc where bsflag = '0' and org_subjection_id like '%"
				+ orgSubId
				+ "%'  and org_subjection_id not in ('C105006', 'C105079001', 'C105003', 'C105017', 'C105078','C105013') order by order_num";

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		return jdbcDAO.queryRecords(sql);
	}
	
	public List<Map> getOrganization(String orgSubId){
//		List orgList = new ArrayList();
//		
//		Map map = new HashMap();
//		map.put("org_name", "国际部");
//		map.put("org_sub_id", "C105002");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "塔里木");
//		map.put("org_sub_id", "C105001005");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "新疆");
//		map.put("org_sub_id", "C105001002");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "吐哈");
//		map.put("org_sub_id", "C105001003");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "青海");
//		map.put("org_sub_id", "C105001004");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "长庆");
//		map.put("org_sub_id", "C105005004");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "大港");
//		map.put("org_sub_id", "C105007");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "辽河");
//		map.put("org_sub_id", "C105063");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "华北");
//		map.put("org_sub_id", "C105005000");
//		orgList.add(map);
//		
//		map = new HashMap();
//		map.put("org_name", "新兴");
//		map.put("org_sub_id", "C105005001");
//		orgList.add(map);
		
//		String org_id = "C6000000000001";//中石油东方地球物理勘探公司 编码
//		StringBuffer message = new StringBuffer();
//		StringBuffer sql = new StringBuffer("select eps_name as org_name,os.org_subjection_id as org_sub_id, eps.org_id from bgp_eps_code eps ");
//		sql.append(" join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0' ");
//		sql.append(" where eps.parent_object_id in(");
//		sql.append(" select object_id as parent_object_id from bgp_eps_code where org_id = '").append(org_id).append("')");
//		if(orgSubId !=null && !"".equals(orgSubId)){
//			sql.append(" and os.org_subjection_id like'").append(orgSubId).append("%'");
//		}
//		sql.append(" order by order_num");
//		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
//		List<Map> resultList = null;
//		try{
//			resultList = jdbcDAO.queryRecords(sql.toString());
//		}catch(Exception e){
//			message.append("表名或查询条件字段不存在!");
//		}
		
		String sql = "select org_subjection_id as org_sub_id,org_short_name as org_name,org_id from bgp_comm_org_wtc where bsflag = '0' and org_subjection_id like '%"+orgSubId+"%'  and org_subjection_id not in ('C105008','C105006') order by order_num";
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				
		return jdbcDAO.queryRecords(sql);
	}
	
	public ISrvMsg getJsonCode(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String selectSql = "select coding_name ,coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000031'";
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try{
			resultList = jdbcDAO.queryRecords(selectSql);
		}catch(Exception e){
		}
		StringBuffer resultJson = new StringBuffer("{root:[");
		if(resultList !=null ){
			for(int i=0; i< resultList.size(); i++){
				Map map = resultList.get(i);
				String coding_name = "" + map.get("coding_name");
				String coding_code_id = "" + map.get("coding_code_id");
				if(i > 0){
					resultJson.append(",");
				}
				resultJson.append("{node_type:'").append(coding_name).append("',node_type_id:'").append(coding_code_id).append("'}");
			}
		}
		resultJson.append("]}");
		responseMsg.setValue("json",resultJson.toString());
		return responseMsg;
	}
	public List mapsToBatchInsertSql(List<Map> list, String tableName){
		List sqlList = new ArrayList();
		if(list != null){
			String insertPre = " insert into " + tableName +"(";
			for(int i=0; i<list.size(); i++){
				StringBuffer insertSql = new StringBuffer();
				StringBuffer columns = new StringBuffer();
				StringBuffer values = new StringBuffer();
				
				Map map = list.get(i);
				Set<String> key = map.keySet();
		        for (Iterator it = key.iterator(); it.hasNext();) {
		            String column = (String) it.next();
		            if(!column.equals("line_num")){
		            	  columns.append(",").append(column);
		            if(column.contains("date")){
		            	//construct_begin_end_date特殊情况 
		            	if("construct_begin_end_date".equals(column)){
		            		values.append(",'").append(map.get(column)).append("'");
		            	}else{
		            		values.append(",").append("sysdate");
		            	}
		            }else{
		            	values.append(",'").append(map.get(column)).append("'");
		            }
		            }
		        }
		        if(columns.length() > 0){
		        	columns.deleteCharAt(0);
		        	values.deleteCharAt(0);
		        	insertSql.append(insertPre).append(columns).append(")").append(" values(").append(values).append(")");
		        	sqlList.add(insertSql);
		        }
			}
		}
		return sqlList;
	}
	public List weekReportInsertSql(List<Map> list, String tableName){
		List sqlList = new ArrayList();
		if(list != null){
			String insertPre = " insert into " + tableName +"(";
			for(int i=0; i<list.size(); i++){
				StringBuffer insertSql = new StringBuffer();
				StringBuffer columns = new StringBuffer();
				StringBuffer values = new StringBuffer();
				
				Map map = list.get(i);
				Set<String> key = map.keySet();
		        for (Iterator it = key.iterator(); it.hasNext();) {
		            String column = (String) it.next();
		            columns.append(",").append(column);
		            if(column.contains("date")){
		            	//construct_begin_end_date特殊情况 
		            	if("start_date".equals(column)||("end_date").equals(column)||("pass_date").equals(column)){
		            		values.append(",to_date('").append(map.get(column)+"','yyyy/mm/dd')") ;
		            	}else{
		            		values.append(",").append("sysdate");
		            	}
		            }else{
		            	values.append(",'").append(map.get(column)).append("'");
		            }
		        }
		        if(columns.length() > 0){
		        	columns.deleteCharAt(0);
		        	values.deleteCharAt(0);
		        	insertSql.append(insertPre).append(columns).append(")").append(" values(").append(values).append(")");
		        	sqlList.add(insertSql);
		        }
			}
		}
		return sqlList;
	}
	
	public int executeBatchSql(List strList){
		int executeResult = 0;
		RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		try{
			Connection conn = jdbcDao.getDataSource().getConnection();
			Statement statement = conn.createStatement();
			for(int i=0; i< strList.size(); i++){
				statement.addBatch("" + strList.get(i));
			}
			statement.executeBatch();
			statement.close();
			conn.close();
			conn = null;
		}catch(Exception e){
			//e.printStackTrace();
			executeResult = -1;
		}
		return executeResult;
	}
	
}
