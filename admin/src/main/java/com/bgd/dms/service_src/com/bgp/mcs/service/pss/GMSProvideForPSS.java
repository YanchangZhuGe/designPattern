package com.bgp.mcs.service.pss;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFCommonBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soaf.util.Operation;

/**   
 * @Title: GMSProvideForPSS.java
 * @Package com.bgp.mcs.service.pss
 * @Description: 为生产监控提供服务
 * @author wuhj 
 * @date 2014-6-3 下午3:12:07
 * @version V1.0   
 */
@Service("GMSProvideForPSS")
public class GMSProvideForPSS extends   BaseService 
{
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private WFCommonBean wfBean = (WFCommonBean) BeanFactory.getBean("WFCommonBean");
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Operation(input="loginId", output="examineInfos")
	public ISrvMsg gainProjectInfos(ISrvMsg reqDTO) throws Exception
	{

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		//用户登录ID
		String loginId = reqDTO.getValue("loginId");
		//获取用户id
		String userSQL = "select r.user_id from p_auth_user r where r.login_id = '"+loginId+"'";
		Map mapUser = jdbcDao.queryRecordBySQL(userSQL);
		
		if(mapUser ==null || mapUser.isEmpty()){
			responseDTO.setValue("examineInfos", "用户不存在！");
			
			return responseDTO;
		}
		
		String userId = (String)mapUser.get("user_id");
		
		/*//获取用户审批信息
		String examineSQL="select  t1.entity_id UNIQUEID , t.proc_name BUSSINESSNAME  ,t1.examine_user_name CREATER_NAME ,t1.examine_start_date CREATE_DATE ,nd.node_name CURRENTTASK ,t.proc_name WORKFLOWNAME, l.coding_name WF_TYPE, lw.business_id BUSSINESS_ID ,lw.busi_table_name  BUSSINESS_TABLE" +
				" from wf_r_examineinst t1 ,wf_d_node nd , common_busi_wf_middle lw , WF_R_PROCINST t,comm_coding_sort_detail l" +
				" where  lw.proc_id=t1.proc_id and lw.proc_inst_id = t1.procinst_id and t1.node_id=nd.entity_id   and t.entity_id = lw.proc_inst_id and  t1.state=1 and lw.proc_status=1  and t1.proc_type = l.coding_code_id"+
				" and t1.examine_user_id='"+userId+"'";
		
		List examineInfos =  jdbcDao.queryRecords(examineSQL);*/
		
		String isDone = "0";
		UserToken user = new UserToken();
		user.setUserId(userId);
		List list = wfBean.getWFProcessList(null, user, isDone);
		List listNew= new ArrayList();
		
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);

			if ("1".equals(isDone)) {
				map.put("procinstId", map.get("procinstid"));
			}

			StringBuffer sql = null;

			if ("1".equals(isDone)) {
				sql = new StringBuffer("SELECT t1.entity_id, t1.proc_name, substr(t1.create_date, 0, 16) create_date, t4.node_name, ");
				sql.append(" decode(t2.examine_user_id, NULL, wmsys.wm_concat(p1.user_id), decode(wmsys.wm_concat(p1.user_id),  NULL, t2.examine_user_id, ");
				sql.append("  t2.examine_user_id || ',' || wmsys.wm_concat(p1.user_id))), ");
				sql.append(" t4.entity_id node_id,t2.entity_id examine_inst_id ");
				sql.append(" FROM wf_r_procinst t1 ");
				sql.append(" INNER JOIN wf_r_examineinst t2 ON t1.entity_id = t2.procinst_id ");
				sql.append(" INNER JOIN wf_r_taskinst t3 ON t2.taskinst_id = t3.entity_id ");
				sql.append(" INNER JOIN wf_d_node t4 ON t4.entity_id = t3.node_id ");
				sql.append(" LEFT OUTER JOIN P_AUTH_USER_ROLE_DMS p1 ON t2.examine_role_id = p1.role_id ");
				sql.append(" WHERE t1.entity_id = '");
				sql.append("1".equals(isDone) ? map.get("procinstid"): map.get("procinstId")).append("'");
				sql.append(" GROUP BY t1.entity_id, t1.proc_name, t1.create_date, t2.examine_user_id, t2.examine_role_id, t4.node_name, t4.entity_id, t2.entity_id ");
			} else {
				sql = new StringBuffer("select t1.entity_id, t1.proc_name, substr(t1.create_date, 0, 16) create_date,");
				sql.append("t4.node_name,t4.entity_id node_id,t5.entity_id examine_inst_id from wf_r_procinst t1 inner ");
				sql.append(" join wf_r_examineinst t5 on t1.entity_id = t5.procinst_id ");
				sql.append(" inner join wf_d_node t4 on t4.entity_id = t5.node_id  and t5.state = '1' ");
				sql.append(" where t1.entity_id='").append("1".equals(isDone) ? map.get("procinstid"): map.get("procinstId")).append("'");
			}

			Map mapNew = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql.toString());
			//map.put("currentRowNum", String.valueOf(start + 1));
			map.put("currentProcName", mapNew.get("procName"));
			if ("1".equals(isDone)) {
				map.put("entityId", mapNew.get("examineInstId"));
			}
			map.put("currentcreateDate", mapNew.get("createDate"));
			map.put("currentNode", mapNew.get("nodeName"));
			map.put("examineInstId", mapNew.get("examineInstId"));

			// 获取页面审批地址
			Map mapNodeConfig = wfBean.getWFNodeConfigId((String) map.get("procinstId"),(String) map.get("entityId"));
			String nodeLinkType = (String) mapNodeConfig.get("nodeLinkType");
			String nodeLink = (String) mapNodeConfig.get("nodeLink");
			String nodeLinkParam = (String) mapNodeConfig.get("nodeLinkParam");
			if ("1".equals(nodeLinkType)) {
				nodeLink += "?a=1";
				String[] nodeLinkParams = nodeLinkParam.split(",");
				for (String param : nodeLinkParams) {
					nodeLink = nodeLink + "&" + param + "=" + map.get("wfVar_" + param);
				}
			}
			map.put("nodeLinkType", nodeLinkType);
			map.put("nodeLink", nodeLink);
			listNew.add(map);
		}
		
		responseDTO.setValue("examineInfos", listNew);
		
		return responseDTO;

	}

}
