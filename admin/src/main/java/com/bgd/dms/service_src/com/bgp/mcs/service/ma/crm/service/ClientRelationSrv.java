package com.bgp.mcs.service.ma.crm.service;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import net.sf.json.JSONArray;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class ClientRelationSrv extends BaseService {
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	/**
	 * 公共 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveClientRelation(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sqls = reqDTO.getValue("sql");
		System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
		return msg;
	}
	/**
	 * 公共 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveCRMByMap(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String hse_evaluation_id = reqDTO.getValue("hse_evaluation_id");
		String tableName = reqDTO.getValue("tableName");
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		if (hse_evaluation_id == null || hse_evaluation_id.trim().equals("")) {// 新增操作
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,tableName);
		msg.setValue("id", id);
		return msg;
	}
	/**
	 * 油公司类别树 --> 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getCompanyTypeTree(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		String divisory_type = reqDTO.getValue("divisory_type");
		if(divisory_type==null || divisory_type.equals("")){
			divisory_type ="1";
		}
		String key_id = reqDTO.getValue("key_id");
		String type_id ="";
		if(type_id !=null && node!=null && node.equals("root")){
			type_id = user.getOrgId();
		}else{
			type_id = node;
		}
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("root")){
			sb  = new StringBuffer();
			sb.append("select t.type_id id ,t.type_name name,t.type_short_name short_name")
			.append(" from bgp_market_company_type t ")
			.append(" where t.bsflag='0' and t.divisory_type='").append(divisory_type).append("'");
			if(key_id!=null && !key_id.equals("")){
				sb.append(" and t.type_id='").append(key_id).append("'");
			}else{
				sb.append(" and (t.parent_type_id is null or t.parent_type_id='root')");
			}
			List root = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
		}else{
			list = getCompanyTypeChild(type_id);
			json = JSONArray.fromObject(list);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	public List getCompanyTypeChild(String type_id) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select t.type_id id,t.type_name name,t.type_short_name short_name")
		.append(" from bgp_market_company_type t ")
		.append(" where t.bsflag='0' and t.parent_type_id ='").append(type_id).append("'");
		list = pureJdbcDao.queryRecords(sb.toString());
		return list;
	}
	/**
	 * 油公司类别树 --> 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getOilCompanyTree(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		String divisory_type = reqDTO.getValue("divisory_type");
		if(divisory_type==null || divisory_type.equals("")){
			divisory_type ="2";
		}
		String key_id = reqDTO.getValue("key_id");
		String type_id ="";
		if(type_id !=null && node!=null && node.equals("root")){
			type_id = user.getOrgId();
		}else{
			type_id = node;
		}
		System.out.println(node+"***");
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("root")){
			sb  = new StringBuffer();
			sb.append("select t.type_id id ,t.type_name name,t.type_short_name short_name ,'false' is_company")
			.append(" from bgp_market_company_type t ")
			.append(" where t.bsflag='0' and t.divisory_type='").append(divisory_type).append("'");
			if(key_id!=null && !key_id.equals("")){
				sb.append(" and t.type_id='").append(key_id).append("'");
			}else{
				sb.append(" and t.parent_type_id is null");
			}
			List root = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
		}else{
			list = getOilCompanyChild(type_id);
			json = JSONArray.fromObject(list);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	public List getOilCompanyChild(String type_id) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append(" select t.type_id id ,t.type_name name,t.type_short_name short_name ,'false' is_company")
		.append(" from bgp_market_company_type t")
		.append(" where t.bsflag='0' and t.parent_type_id ='").append(type_id).append("' union")
		.append(" select o.company_id id ,o.company_name name ,o.company_short_name short_name ,'true' is_company")
		.append(" from bgp_market_oil_company o")
		.append(" where o.bsflag ='0' and o.company_type ='1' and o.company_place ='").append(type_id).append("'");
		list = pureJdbcDao.queryRecords(sb.toString());
		return list;
	}
	/**
	 * 油公司类别树 --> 搜索功能
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	String parent_id = "";
	public ISrvMsg search(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String name = reqDTO.getValue("name");
		String type = reqDTO.getValue("type");
		if(type==null || type.equals("")){
			type ="1";
		}
		String ids = "";
		StringBuffer sb  = new StringBuffer();
		sb.append("select distinct t.type_id from bgp_market_company_type t where t.bsflag='0' ")
		.append("and t.divisory_type ='").append(type).append("' and t.type_name like'%")
		.append(name).append("%' or t.type_short_name like'%").append(name).append("%'");
		List list = pureJdbcDao.queryRecords(sb.toString());
		for(int i = 0;list!=null && i<list.size();i++){
			Map map = (Map)list.get(i);
			if(map !=null){
				if(map.get("type_id")!=null && !map.get("type_id").toString().equals("")){
					String type_id = (String)map.get("type_id");
					parent_id = "";
					search(type_id);
					ids = ids + parent_id +"/"+type_id+";";
				}
			}
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("ids", ids);
		return msg;
	}
	
	public String search(String type_id) throws Exception{
		StringBuffer sb  = new StringBuffer();
		sb.append("select t.parent_type_id id from bgp_market_company_type t where t.bsflag='0' and t.type_id ='").append(type_id).append("'");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			if(map.get("id")!=null && !map.get("id").toString().equals("")){
				String parent_type_id = (String)map.get("id");
				parent_id = "/"+parent_type_id + parent_id;
				search(parent_type_id);
			}else{
				parent_id = "/root" +parent_id;
			}
			
		}
		return "";
	}
}

