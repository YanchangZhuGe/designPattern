package com.bgp.mcs.service.pm.service.eps;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.util.OPCommonUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class EpsCodeManager  extends BaseService {
	private ILog log;
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	
	/**
	 * 获取所有企业编码信息
	 * @throws Exception
	 */
	public ISrvMsg getEpsCodes(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select connect_by_root(object_id) as root,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf , object_id as nodeid , eps_id as epsid ,eps_name as epsname,(select org_name from comm_org_information o where o.org_id = e.org_id) as orgname,e.org_id  as orgid,parent_object_id as parentid,order_num  as ordernum from bgp_eps_code e where bsflag='0' start with parent_object_id = '0' connect by prior object_id = parent_object_id order by order_num");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List list = jdbcDAO.queryRecords(sql.toString());
		
		Map map = new HashMap();
		map.put("nodeid", "0");
		map.put("parentid", "0");
		map.put("epsid", "");
		map.put("epsname", "东方地球物理公司");
		map.put("expanded", "true");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "nodeid", "parentid", map);
		
		JSONArray retJson = JSONArray.fromObject(jsonMap.get("children"));
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		msg.setValue("json", json);
		
		return msg;
	}
	
	/**
	 * 获取指定ID企业编码信息
	 * @throws Exception
	 */
	public ISrvMsg getEpsCodeById(ISrvMsg reqDTO) throws Exception {
		String objectid = reqDTO.getValue("objectid");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select eps_id,eps_name,org_id,(select org_name from comm_org_information o where o.org_id = e.org_id) as org_name from bgp_eps_code e where bsflag='0' and object_id ='"+objectid+"'");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		Map epscode = jdbcDAO.queryRecordBySQL(sql.toString());
		responseMsg.setValue("epscode", epscode);
		return responseMsg;
	}
	
	/**
	 * 新增企业编码信息
	 * @throws Exception
	 */
	public ISrvMsg addEpsCode(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String epsid = reqDTO.getValue("epsid");
		String epsname = reqDTO.getValue("epsname");
		String orgid = reqDTO.getValue("orgid");
		String parentid = reqDTO.getValue("parentid");
		String	objectId= jdbcDao.generateUUID();
		int orderNum = getOrderNum(parentid);
		
		StringBuffer sbInsert = new StringBuffer("insert into bgp_eps_code(object_id,eps_id,eps_name,org_id,parent_object_id,order_num,create_date,creator_id,modifi_date,updator_id,bsflag)");
		sbInsert.append(" values('").append(objectId).append("'");
		sbInsert.append(" ,'").append(epsid).append("'");
		sbInsert.append(" ,'").append(epsname).append("'");
		sbInsert.append(" ,'").append(orgid).append("'");
		sbInsert.append(" ,'").append(parentid).append("'");
		sbInsert.append(" ,'").append(orderNum).append("'");
		sbInsert.append(" ,sysdate,'").append(user.getEmpId()).append("'");
		sbInsert.append(" ,sysdate,'").append(user.getEmpId()).append("'");
		sbInsert.append(" ,'0'").append(")");
		
		jdbcTemplate.execute(sbInsert.toString());
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	/**
	 * 修改企业编码信息
	 * @throws Exception
	 */
	public ISrvMsg updateEpsCode(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String epsid = reqDTO.getValue("epsid");
		String epsname = reqDTO.getValue("epsname");
		String orgid = reqDTO.getValue("orgid");
		String	objectId= reqDTO.getValue("nodeid");
		
		StringBuffer sbInsert = new StringBuffer("update bgp_eps_code ");
		sbInsert.append(" set eps_id='").append(epsid).append("'");
		sbInsert.append(" ,eps_name='").append(epsname).append("'");
		sbInsert.append(" ,org_id='").append(orgid).append("'");
		sbInsert.append(" ,modifi_date=sysdate");
		sbInsert.append(" ,updator_id='").append(user.getEmpId()).append("'");
		sbInsert.append("  where bsflag='0' and object_id='").append(objectId).append("'");
		
		jdbcTemplate.execute(sbInsert.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	/**
	 * 获取指定父节点下子节点的最大排序值
	 * @throws Exception
	 */
	private int getOrderNum(String parentObjectId){
		IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
		String sql = "select nvl(max(order_num)+1,1) as orderNum from bgp_eps_code where bsflag='0' and parent_object_id = '"+parentObjectId+"' ";
		Map map = jdbcDao.queryRecordBySQL(sql);
		String orderNum = (String) map.get("ordernum");
		int order = Integer.parseInt(orderNum);
	
		return order;
	}
	
	/**
	 * 调整企业编码信息的顺序
	 * @throws Exception
	 */	
	public ISrvMsg updateCodeOrder(ISrvMsg reqDTO) throws Exception {
		String sourceNodeId = reqDTO.getValue("sourceNodeId");
		String targetNodePId = reqDTO.getValue("targetNodePId");
		String targetNodeIndex = reqDTO.getValue("targetNodeIndex");
		String beforeOrAfter = reqDTO.getValue("beforeOrAfter");
		int index = Integer.parseInt(targetNodeIndex);
		if ("after".equals(beforeOrAfter)) {
			index += 1;
		}
		
		String sqlUpdateOthers = "update bgp_eps_code set order_num = order_num+1 where bsflag='0' and parent_object_id='" + targetNodePId + "' and order_num>="
				+ index;
		String sqlUpdateSource = "update bgp_eps_code set parent_object_id = '" + targetNodePId + "',order_num = " + index + " where  object_id ='" + sourceNodeId + "'";
	
		jdbcTemplate.execute(sqlUpdateOthers);
		jdbcTemplate.execute(sqlUpdateSource);
	
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
}
