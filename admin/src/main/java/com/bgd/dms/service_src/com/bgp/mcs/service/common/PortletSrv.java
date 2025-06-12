package com.bgp.mcs.service.common;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFCommonBean;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFVarBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class PortletSrv extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	/**
	 * 公共 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savePortletBySql(ISrvMsg reqDTO) throws Exception {
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
	 * 公共 --> 保存(map)
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg savePortletByMap(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		Map map = reqDTO.toMap();
		System.out.println(map);
		String table_name = (String)map.get("table_name");
		String table_id = (String)map.get("table_id");
		String infoKeyValue = "";
		if (table_id == null || table_id.trim().equals("")) {// 新增操作
			map.put("project_info_no", project_info_no);
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("bsflag", "0");
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getUserId());
			map.put("modifi_date", new Date());
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,table_name);
			table_id = id.toString();
		} else {// 修改或审核操作
			map.put("bsflag", "0");
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("updator_id", user.getUserId());
			map.put("modifi_date", new Date());
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,table_name);
			table_id = id.toString();
		}
		msg.setValue("table_id", table_id);
		return msg;
	}
	/**
	 * 
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getCategory(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("root")){
			sb  = new StringBuffer();
			sb.append("select t.category_id id ,t.category_name name ,t.order_num from bgp_comm_portlet_category_dms t where t.category_id ='ROOT'");
			List root = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
		}else{
			sb  = new StringBuffer();
			sb.append("select t.category_id id ,t.category_name name ,t.order_num from bgp_comm_portlet_category_dms t ")
			.append(" where t.parent_category_id ='").append(node).append("' order by t.order_num asc,t.category_name asc");
			List root = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	/**
	 * 检查项汇总 --> 汇总列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	String category_ids = "";
	public ISrvMsg getCategoryIds(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String category_id = reqDTO.getValue("category_id");
		if(category_id!=null && !category_id.trim().equals("")){
			category_ids = "'"+category_id+"'";
		}
		getChildren(category_id);
		System.out.println(category_ids);
		UserToken user = reqDTO.getUserToken();
		StringBuffer sb = new StringBuffer();
		sb = new StringBuffer();
		sb.append("");
		//List recordList = pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("category_ids", category_ids);
		return msg;
	}
	/**
	 * 公共 --> 获得设置的工序名称
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 */
	public String getChildren(String category_id) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select t.category_id from bgp_comm_portlet_category_dms t where t.parent_category_id ='").append(category_id).append("'");
		list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size() ==0){
			return category_ids;
		}else{
			for(int i=0;list!=null && i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null && map.get("category_id")!=null && !map.get("category_id").toString().equals("")){
					String id = (String)map.get("category_id");
					if(category_ids.trim().equals("")){
						category_ids = "\'"+id+"\'";
					}else{
						category_ids = category_ids +",\'"+id+"\'";
					}
					getChildren(id);
				}
			}
		}
		return category_ids;
	}
	
}
