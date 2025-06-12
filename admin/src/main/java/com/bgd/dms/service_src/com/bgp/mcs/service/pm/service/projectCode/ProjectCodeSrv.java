package com.bgp.mcs.service.pm.service.projectCode;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import net.sf.json.JSONArray;

import com.bgp.gms.service.op.util.OPCommonUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class ProjectCodeSrv extends BaseService {
	private ILog log;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	public ProjectCodeSrv(){
		log = LogFactory.getLogger(ProjectCodeSrv.class);
	}
	
	public ISrvMsg getProjectCodes(ISrvMsg reqDTO) throws Exception {
		
		String owner = reqDTO.getValue("owner");//所属系统
		
		StringBuffer sql = new StringBuffer("select connect_by_root(node_id) root, ");
		sql.append("level, decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, ");
		sql.append("sys_connect_by_path(node_id, '/') path,node_name,node_desc,owner,node_id,parent_id, parent_id as zip,order_code ");
		sql.append("from (select object_id as node_id,name as node_name,'' as node_desc,owner,'root' as parent_id,0 as order_code ");
		sql.append("from bgp_p6_code_type where bsflag = '0' ");
		sql.append("union ");
		sql.append("select c.object_id as node_id, c.name as node_name, c.note as node_desc, 0 as owner, c.parent_object_id as parent_id, c.order_num as order_code ");
		sql.append("from bgp_p6_code c  where c.bsflag = '0') ");
		sql.append("start with owner = '"+owner+"' ");
		sql.append("connect by prior node_id = parent_id ");
		sql.append("order by order_code asc,node_name ");
		
		List list = jdbcDao.queryRecords(sql.toString());
		
		Map map = new HashMap();
		map.put("nodeId", "root");
		map.put("parentId", "root");
		map.put("nodeName", "东方地球物理公司");
		map.put("nodeDesc", "");
		map.put("expanded", "true");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "nodeId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap.get("children"));
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json", json);
		
		return msg;
	}
	
	public ISrvMsg saveProjectCode(ISrvMsg reqDTO) throws Exception {
		
		Map map = reqDTO.toMap();
		
		int order = this.getOrderNum((String) map.get("parent_object_id"));
		
		UserToken user = reqDTO.getUserToken();
		
		map.put("order_num", order);
		map.put("creator_id", user.getEmpId());
		map.put("create_date", new Date());
		map.put("updator_id", user.getEmpId());
		map.put("modifi_date", new Date());
		
		pureDao.saveOrUpdateEntity(map, "BGP_P6_CODE");
				
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	public ISrvMsg saveProjectCodeType(ISrvMsg reqDTO) throws Exception {
		
		Map map = reqDTO.toMap();
		
		UserToken user = reqDTO.getUserToken();
		
		map.put("creator_id", user.getEmpId());
		map.put("create_date", new Date());
		map.put("updator_id", user.getEmpId());
		map.put("modifi_date", new Date());
		
		pureDao.saveOrUpdateEntity(map, "BGP_P6_CODE_TYPE");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
		
	}
	
	public ISrvMsg saveProjectCodeOrder(ISrvMsg reqDTO) throws Exception {
		
		String sourceNodeId = reqDTO.getValue("sourceNodeId");
		String targetNodeZip = reqDTO.getValue("targetNodeZip");
		String targetNodeIndex = reqDTO.getValue("targetNodeIndex");
		String beforeOrAfter = reqDTO.getValue("beforeOrAfter");
		int index = Integer.parseInt(targetNodeIndex);
		if ("after".equals(beforeOrAfter)) {
			index += 1;
		}
		
		String sqlUpdateOthers = "update bgp_p6_code set order_num = order_num+1 where parent_object_id='" + targetNodeZip + "' and order_num>="
				+ index;
		String sqlUpdateSource = "update bgp_p6_code set parent_object_id = '" + targetNodeZip + "',order_num = " + index + " where  object_id ='" + sourceNodeId + "'";
		jdbcTemplate.execute(sqlUpdateOthers);
		jdbcTemplate.execute(sqlUpdateSource);
	
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	
	private int getOrderNum(String parentObjectId){
		String sql = "select nvl(max(order_num)+1,1) as orderNum from bgp_p6_code where parent_object_id = '"+parentObjectId+"' ";
		
		Map map = jdbcDao.queryRecordBySQL(sql);
		
		String orderNum = (String) map.get("ordernum");
		
		int order = Integer.parseInt(orderNum);
		
		return order;
	}
	
	public ISrvMsg getCodeAssignment(ISrvMsg reqDTO) throws Exception {
		
		String relation_id = reqDTO.getValue("relationId");
		String owner = reqDTO.getValue("owner");
		String code_name = reqDTO.getValue("code_name");
		String code_type_name = reqDTO.getValue("code_type_name");
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String sql = "select * from  bgp_p6_code_assignment where bsflag = '0' ";
		if (relation_id != null && !"".equals(relation_id)) {
			sql += " and foreign_object_id = '"+relation_id+"' ";
		}
		if (owner != null && !"".equals(owner)) {
			sql += " and owner = '"+owner+"' ";
		}
		if (code_name != null && !"".equals(code_name)) {
			sql += " and foreign_code_name like '%"+code_name+"%' ";
		}
		if (code_type_name != null && !"".equals(code_type_name)) {
			sql += " and foreign_code_type_name like '%"+code_type_name+"%' ";
		}
		sql += "order by modifi_date desc ";
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
	
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		List list = page.getData();
		msg.setValue("datas", list);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		return msg;
	}
	
	public ISrvMsg saveProjectCodeAssignment(ISrvMsg reqDTO) throws Exception {
		
		String relationId = reqDTO.getValue("relationId");//业务表主键
		String codeObjectId = reqDTO.getValue("codeObjectId");//分类码主键
		
		String sql = "select ct.object_id as foreign_code_type_object_id, ct.name as foreign_code_type_name, ct.owner as owner" +
				" ,c.name as foreign_code_name,c.object_id as foreign_code_object_id " +
				" from bgp_p6_code c,bgp_p6_code_type ct where c.code_type_object_id = ct.object_id " +
				" and c.object_id = '"+codeObjectId+"' and c.bsflag = '0' and ct.bsflag = '0' ";
		
		List list = radDao.queryRecords(sql);
		
		Map map = (Map) list.get(0);
		map.put("foreign_object_id", relationId);
		
		UserToken user = reqDTO.getUserToken();
		
		map.put("creator_id", user.getEmpId());
		map.put("create_date", new Date());
		map.put("updator_id", user.getEmpId());
		map.put("modifi_date", new Date());
		map.put("bsflag", "0");
		
		pureDao.saveOrUpdateEntity(map, "BGP_P6_CODE_ASSIGNMENT");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		return msg;
	}
	
	public ISrvMsg deleteCodeAssignment(ISrvMsg reqDTO) throws Exception {
		
		String objectId = reqDTO.getValue("objectId");//业务表主键
		
		String[] objectIds = objectId.split(",");
		
		String sql = null;
		
		if (objectIds.length >1) {
			//复选多个分类码
			sql = "update bgp_p6_code_assignment set bsflag = '1' where object_id in (";
			
			for (int i = 0; i < objectIds.length; i++) {
				sql += "'"+objectIds[i]+"',";
			}
			sql = sql.substring(0, sql.lastIndexOf(","));
			sql += ")";
		} else {
			sql = "update bgp_p6_code_assignment set bsflag = '1' where object_id = '"+objectId+"' ";
		}
		
		jdbcTemplate.execute(sql);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		return msg;
	}
	
	
}
