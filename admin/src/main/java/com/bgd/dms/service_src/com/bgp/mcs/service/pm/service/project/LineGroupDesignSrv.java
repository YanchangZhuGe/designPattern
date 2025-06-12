package com.bgp.mcs.service.pm.service.project;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class LineGroupDesignSrv  extends BaseService {
	RADJdbcDao radJdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	JdbcTemplate jdbcTemplate = radJdbcDao.getJdbcTemplate();

	public ISrvMsg saveLineGroupDesign(ISrvMsg reqDTO) throws Exception{
		Map map = reqDTO.toMap();
		UserToken user = reqDTO.getUserToken();
		
		String groupDesignNo = reqDTO.getValue("group_design_no");
		if(groupDesignNo == null || "".equals(groupDesignNo)){
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		Serializable wa3d_design_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_3dwa_group_design");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	/**
	 * 获取线束设计信息
	 * @throws Exception
	 */
	public ISrvMsg getLineGroupDesignById(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("projectInfoNo");
		String group_design_no = reqDTO.getValue("groupDesignNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select * from gp_ops_3dwa_group_design");
		sb.append(" where group_design_no='").append(group_design_no).append("'");
		
		Map lineGroupDesgin = new HashMap();
		lineGroupDesgin = jdbcDAO.queryRecordBySQL(sb.toString());
		
		if (lineGroupDesgin != null) {
			responseMsg.setValue("lineGroupDesgin", lineGroupDesgin);
		}
		return responseMsg;
	}
	
	/**
	 * 获取二维测线数据
	 * @throws Exception
	 */
	public ISrvMsg queryWa2dLineDesign(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select * from gp_ops_2dwa_line_design ");
		sb.append(" where bsflag='0' and project_info_no='").append(project_info_no).append("'");
		sb.append(" order by order_num");
		List<Map> lineDesignList = jdbcDAO.queryRecords(sb.toString());
		if (lineDesignList != null) {
			responseMsg.setValue("lineDesignList", lineDesignList);
		}
		return responseMsg;
	}
	/**
	 * 获取二维完成测线数据
	 * @throws Exception
	 */
	public ISrvMsg queryWa2dLineComplete(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select * from gp_ops_2dwa_line_complete ");
		sb.append(" where bsflag='0' and project_info_no='").append(project_info_no).append("'");
		sb.append(" order by order_num");
		List<Map> lineDesignList = jdbcDAO.queryRecords(sb.toString());
		if (lineDesignList != null) {
			responseMsg.setValue("lineDesignList", lineDesignList);
		}
		return responseMsg;
	}
	
	/**
	 * 技术指标完成数据
	 * @throws Exception
	 */
	public ISrvMsg queryTechnologyComplete(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select * from gp_ops_technology_complete ");
		sb.append(" where bsflag='0' and project_info_no='").append(project_info_no).append("'");
		sb.append(" order by order_num");
		List<Map> lineDesignList = jdbcDAO.queryRecords(sb.toString());
		if (lineDesignList != null) {
			responseMsg.setValue("lineDesignList", lineDesignList);
		}
		return responseMsg;
	}
	/**
	 * 获取三维线束数据
	 * @throws Exception
	 */
	public ISrvMsg queryWa3dLineDesign(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select * from gp_ops_3dwa_group_design ");
		sb.append(" where bsflag='0' and project_info_no='").append(project_info_no).append("'");
		sb.append(" order by order_num");
		List<Map> lineDesignList = jdbcDAO.queryRecords(sb.toString());
		if (lineDesignList != null) {
			responseMsg.setValue("lineDesignList", lineDesignList);
		}
		return responseMsg;
	}
	
	/**
	 * 删除指定编号的三维线束设计信息
	 * @throws Exception
	 */
	public ISrvMsg deleteLineGroupDesign(ISrvMsg reqDTO) throws Exception {
		//RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		//JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		String ids = reqDTO.getValue("groupDesignNo");
		String[] objectIds = ids.split(",");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "update gp_ops_3dwa_group_design set bsflag = '1' where group_design_no in(";
		for(int i=0; i < objectIds.length; i++){
			String objectId = objectIds[i];
			sql += "'"+ objectId + "',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		
		System.out.println("sql:"+sql);
		jdbcTemplate.execute(sql);
		responseMsg.setValue("actionStatus", "ok");
		return responseMsg;
	}
	
	/**
	 * 删除指定编号的二维线束设计信息
	 * @throws Exception
	 */
	public ISrvMsg deleteWa2dLineDesign(ISrvMsg reqDTO) throws Exception {
		//RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		//JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		String ids = reqDTO.getValue("objectId");
		String[] objectIds = ids.split(",");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "update gp_ops_2dwa_line_design set bsflag = '1' where object_id in(";
		for(int i=0; i < objectIds.length; i++){
			String objectId = objectIds[i];
			sql += "'"+ objectId + "',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		
		jdbcTemplate.execute(sql);
		responseMsg.setValue("actionStatus", "ok");
		return responseMsg;
	}
	
	
}
