package com.bgp.mcs.service.pm.bpm.workFlow.srv;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.commons.collections.MapUtils;

//import com.bgp.gms.comm.mail.ExamineSendMails;
import com.bgp.gms.service.op.util.OPCommonUtil;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.util.ColumnDesp;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class WFCommonSrv extends BaseService {

	private WFCommonBean wfBean;
	

	private IJdbcDao  jdbcDao = BeanFactory.getQueryJdbcDAO();


	public WFCommonSrv() {
		wfBean = (WFCommonBean) BeanFactory.getBean("WFCommonBean");
	}

	/*
	 * 发起审批
	 */

	public ISrvMsg startWFProcess(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String businessId = reqDTO.getValue("businessId");
		String businessTableName = reqDTO.getValue("businessTableName");
		String businessType = reqDTO.getValue("businessType");
		String projectName = reqDTO.getValue("projectName");
		String applicantDate = reqDTO.getValue("applicantDate");
		String businessInfo = reqDTO.getValue("businessInfo");

		WFVarBean wfVar = new WFVarBean(businessId, businessTableName,
				businessType, businessInfo, wfBean.copyMapFromStartMap(
						reqDTO.toMap(), "wfVar_"), projectName, user,
				applicantDate);
		String procinstId = wfBean.startWFProcess(wfVar);
		String forwardUrl = reqDTO.getValue("forwardUrl");
		msg.setValue("forwardUrl", forwardUrl);
		msg.setValue("procinstId", procinstId);
		return msg;
	}

	/*
	 * 获取定制化信息
	 */
	public ISrvMsg getCustomConfigInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String businessType = reqDTO.getValue("businessType");
		String projectInfoNo=reqDTO.getValue("projectInfoNo");
		String isDone=reqDTO.getValue("isDone");
		String sBusinessType=businessType;
		/**监测系统传递页面参数添加代码 开始**/
		Map p = reqDTO.toMap();
		if(MapUtils.isNotEmpty(p)){
			Iterator ite = p.keySet().iterator();
			while(ite.hasNext()){
				String k = (String) ite.next();
				msg.setValue(k, p.get(k));
			}
		}
		
		
		//查询流程模版类型
		String sql ="select l.coding_code_id,l.coding_name from comm_coding_sort_detail l where l.coding_sort_id='5110000181' and l.superior_code_id='0'  order by l.coding_code_id asc";
		
		List<Map> list =jdbcDao.queryRecords(sql);
		msg.setValue("processTypes", list);
		
		
		/**监测系统传递页面参数添加代码 结束**/
		
		// 获取定制化查询条件及列表项
		if(businessType!=null&&businessType.contains(",")){
			sBusinessType=businessType.split(",")[0];
		}
		Map mapCustom = wfBean.getCustomQueryListInfo(sBusinessType);
		wfBean.copyMapToDTO(mapCustom, msg);
		msg.setValue("b", "1");
		msg.setValue("businessType", businessType);
		msg.setValue("isDone", isDone);
		msg.setValue("projectInfoNo", projectInfoNo);
		return msg;
	}
	
	/*
	 * 大港获取定制化信息
	 */
	public ISrvMsg getCustomConfigInfoDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String businessType = reqDTO.getValue("businessType");
		System.out.println("businessType111 == "+businessType);
		String projectInfoNo=reqDTO.getValue("projectInfoNo");
		String isDone=reqDTO.getValue("isDone");
		String sBusinessType=businessType;
		// 获取定制化查询条件及列表项
		if(businessType!=null&&businessType.contains(",")){
			sBusinessType=businessType.split(",")[0];
		}
		Map mapCustom = wfBean.getCustomQueryListInfo(sBusinessType);
		wfBean.copyMapToDTO(mapCustom, msg);
		msg.setValue("b", "1");
		msg.setValue("businessType", businessType);
		msg.setValue("isDone", isDone);
		msg.setValue("projectInfoNo", projectInfoNo);
		return msg;
	}

	/*
	 * 保存流程文档信息
	 */
	
	public ISrvMsg saveWFDocInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> files = mqMsg.getFiles();
		String id = reqDTO.getValue("id");
		if (files != null && files.size() > 0 && id != null) {
			WSFile file = files.get(0);
			MyUcm ucm = new MyUcm();
			String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
			String updateSql = "update common_busi_wf_extension set file_id = '" + ucmDocId + "' where extension_id='" + id + "'";
			((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate().execute(updateSql);
			
		}
		return  responseDTO;
	}
	/*
	 * 获取审批列表信息
	 */

	public ISrvMsg getWFProcessList(ISrvMsg reqDTO) throws Exception {
	
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isDone = reqDTO.getValue("isDone");
		UserToken user = reqDTO.getUserToken();
		String businessType = reqDTO.getValue("businessType");
		//是否根据父节点查找子节点
		String nodeType = reqDTO.getValue("nodeType");
		
		if("undefined".equals(businessType))
			businessType = null;

		// businessType分为2种情况：
		// 若有值 则根据此值布过滤流程 及获取定制化信息
		// 若无值则取当前用户所有的待审批信息，流程列表页面采用公共页面 不附加任何自定义字段

		// 获取审批列表信息(待审批/已审批) businessType为null或者""则不进行过滤
//		List list = wfBean.getWFProcessList(businessType, user, isDone);

		List listNew = new ArrayList();

		// 流程过滤信息
		String[] paramName = new String[0];
		String[] paramValue = new String[0];

		if (businessType != null && !"".equals(businessType)&&!"null".equals(businessType)) {
			// 获取定制化查询条件及列表项
			String sBusinessType=businessType;
			if(businessType.contains(",")){
				sBusinessType=businessType.split(",")[0];
			}
			Map mapCustom = wfBean.getCustomQueryListInfo(sBusinessType);

			if(mapCustom!=null){
				msg.setValue("queryBuilder", (String) mapCustom.get("queryBuilder"));
				msg.setValue("queryBuilderMean",
						(String) mapCustom.get("queryBuilderMean"));
				msg.setValue("listBuilder", (String) mapCustom.get("listBuilder"));
				msg.setValue("listBuilderMean",
						(String) mapCustom.get("listBuilderMean"));
	
				// 定制化查询条件
				String params = (String) mapCustom.get("queryBuilder");
	
				if (params != null && !params.equals("")) {
					paramName = params.split(",");
					paramValue = new String[paramName.length];
					for (int i = 0; i < paramName.length; i++) {
						paramValue[i] = reqDTO.getValue(paramName[i]);
						if (paramValue[i] == null)
							paramValue[i] = "";
					}
				}
			}
		}

		// 过滤流程信息
		// 列表分页显示代码部分
		String currentPageStr = reqDTO.getValue("currentPage");
		if (currentPageStr == null || currentPageStr.trim().equals(""))
			currentPageStr = "1";
		String pageSizeStr = reqDTO.getValue("pageSize");
		if (pageSizeStr == null || pageSizeStr.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSizeStr = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		int currentPage = Integer.parseInt(currentPageStr);
		int pageSize = Integer.parseInt(pageSizeStr);
		
		//2013年8月14  吴海军 工作流分页
		PageModel page = new PageModel();
		page.setCurrPage(currentPage);
		page.setPageSize(pageSize);
		
		//2014年9月3日 根据父节点查询子节点的流程类型
		if(nodeType!=null && nodeType.equals("1")){
			String sqlBusinessType ="SELECT wm_concat(l.coding_code_id)  businessTypes from comm_coding_sort_detail l where  l.end_if=1 " +
					" START WITH l.superior_code_id = '5110000004100000108'  CONNECT BY PRIOR l.coding_code_id = l.superior_code_id";
			Map map = jdbcDao.queryRecordBySQL(sqlBusinessType);
			businessType = (String)map.get("businesstypes");
		}
		
		//不需要用户过滤流程
		String noFilter = reqDTO.getValue("noFilter");
		page = wfBean.getWFProcessListForPage(businessType, user, isDone,page,noFilter);
		//结束
		
		
		List list = page.getData();
		
		int start = (currentPage - 1) * pageSize;
//		int end = currentPage * pageSize;
//		int total = 0;
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);

			if ("1".equals(isDone)) {
				map.put("procinstId", map.get("procinstid"));
			}

			// 是否符合条件
			if (!wfBean.check(map, paramName, paramValue))
				continue;

//			total++;

//			if (start >= total || start >= end)
//				continue;
			StringBuffer sql = null;

			if ("1".equals(isDone)) {
				sql = new StringBuffer(
						"SELECT t1.entity_id, t1.proc_name, substr(t1.create_date, 0, 16) create_date, t4.node_name, ")
						.append(" decode(t2.examine_user_id, NULL, wmsys.wm_concat(p1.user_id), decode(wmsys.wm_concat(p1.user_id),  NULL, t2.examine_user_id, ")
						.append("  t2.examine_user_id || ',' || wmsys.wm_concat(p1.user_id))), ")
						.append(" t4.entity_id node_id,t2.entity_id examine_inst_id ")
						.append(" FROM wf_r_procinst t1 ")
						.append(" INNER JOIN wf_r_examineinst t2 ON t1.entity_id = t2.procinst_id ")
						.append(" INNER JOIN wf_r_taskinst t3 ON t2.taskinst_id = t3.entity_id ")
						.append(" INNER JOIN wf_d_node t4 ON t4.entity_id = t3.node_id ")
						.append(" LEFT OUTER JOIN P_AUTH_USER_ROLE_DMS p1 ON t2.examine_role_id = p1.role_id ")
						.append(" WHERE t2.examine_user_id='"+user.getUserId()+"' and t1.entity_id = '")
						.append("1".equals(isDone) ? map.get("procinstid")
								: map.get("procinstId"))
						.append("'")
						.append(" GROUP BY t1.entity_id, t1.proc_name, t1.create_date, t2.examine_user_id, t2.examine_role_id, t4.node_name, t4.entity_id, t2.entity_id ");

			} else {
				sql = new StringBuffer(
						"select t1.entity_id, t1.proc_name, substr(t1.create_date, 0, 16) create_date, t4.node_name from wf_r_procinst t1 inner join wf_r_examineinst t5 on t1.entity_id = t5.procinst_id inner join wf_d_node t4 on t4.entity_id = t5.node_id  and t5.state = '1' ")
						.append(" where t1.entity_id='")
						.append("1".equals(isDone) ? map.get("procinstid")
								: map.get("procinstId")).append("'");
			}

			Map mapNew = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
					sql.toString());
			map.put("currentRowNum", String.valueOf(start + 1));
			map.put("currentProcName", mapNew.get("procName"));
			if ("1".equals(isDone)) {
				map.put("entityId", mapNew.get("examineInstId"));
			}
			map.put("currentcreateDate", mapNew.get("createDate"));
			map.put("currentNode", mapNew.get("nodeName"));

			// 获取页面审批地址
			Map mapNodeConfig = wfBean.getWFNodeConfigId(
					(String) map.get("procinstId"),
					(String) map.get("entityId"));
			String nodeLinkType = (String) mapNodeConfig.get("nodeLinkType");
			String nodeLink = (String) mapNodeConfig.get("nodeLink");
			String nodeLinkParam = (String) mapNodeConfig.get("nodeLinkParam");
			if ("1".equals(nodeLinkType)) {
				nodeLink += "?a=1";
				String[] nodeLinkParams = nodeLinkParam.split(",");
				for (String param : nodeLinkParams) {
					nodeLink = nodeLink + "&" + param + "="
							+ map.get("wfVar_" + param);
				}
			}
			map.put("nodeLinkType", nodeLinkType);
			map.put("nodeLink", nodeLink);
			listNew.add(map);

			start++;
		}
		msg.setValue("datas", listNew);

		msg.setValue("totalRows", page.getTotalRow());

//		int pageCount = total / pageSize;
//		pageCount += ((total % pageSize) == 0 ? 0 : 1);

		msg.setValue("pageCount", page.getPageCount());
		msg.setValue("pageSize", pageSize);
		msg.setValue("currentPage", currentPage);

		return msg;
	}
	
	/*
	 * 获取大港副科审批列表信息
	 */

	public ISrvMsg getWFProcessListDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isDone = reqDTO.getValue("isDone");
		UserToken user = reqDTO.getUserToken();
		String businessType = reqDTO.getValue("businessType"); 
		
		if(businessType.equals("undefined"))
			businessType = null;

		// businessType分为2种情况：
		// 若有值 则根据此值布过滤流程 及获取定制化信息
		// 若无值则取当前用户所有的待审批信息，流程列表页面采用公共页面 不附加任何自定义字段

		// 获取审批列表信息(待审批/已审批) businessType为null或者""则不进行过滤
//		List list = wfBean.getWFProcessList(businessType, user, isDone);

		List listNew = new ArrayList();

		// 流程过滤信息
		String[] paramName = new String[0];
		String[] paramValue = new String[0];

//		if (businessType != null && !"".equals(businessType)&&!"null".equals(businessType)) {
//			// 获取定制化查询条件及列表项
//			String sBusinessType=businessType;
//			if(businessType.contains(",")){
//				sBusinessType=businessType.split(",")[0];
//			}
//			Map mapCustom = wfBean.getCustomQueryListInfo(sBusinessType);
//
//			if(mapCustom!=null){
//				msg.setValue("queryBuilder", (String) mapCustom.get("queryBuilder"));
//				msg.setValue("queryBuilderMean",
//						(String) mapCustom.get("queryBuilderMean"));
//				msg.setValue("listBuilder", (String) mapCustom.get("listBuilder"));
//				msg.setValue("listBuilderMean",
//						(String) mapCustom.get("listBuilderMean"));
//	
//				// 定制化查询条件
//				String params = (String) mapCustom.get("queryBuilder");
//	
//				if (params != null && !params.equals("")) {
//					paramName = params.split(",");
//					paramValue = new String[paramName.length];
//					for (int i = 0; i < paramName.length; i++) {
//						paramValue[i] = reqDTO.getValue(paramName[i]);
//						if (paramValue[i] == null)
//							paramValue[i] = "";
//					}
//				}
//			}
//		}

		// 过滤流程信息
		// 列表分页显示代码部分
		String currentPageStr = reqDTO.getValue("currentPage");
		if (currentPageStr == null || currentPageStr.trim().equals(""))
			currentPageStr = "1";
		String pageSizeStr = reqDTO.getValue("pageSize");
		if (pageSizeStr == null || pageSizeStr.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSizeStr = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		int currentPage = Integer.parseInt(currentPageStr);
		int pageSize = Integer.parseInt(pageSizeStr);
		
		//2013年8月14  吴海军 工作流分页
		PageModel page = new PageModel();
		page.setCurrPage(currentPage);
		page.setPageSize(pageSize);
		

		//不需要用户过滤流程
		String noFilter = reqDTO.getValue("noFilter");
		page = wfBean.getWFProcessListForPage(businessType, user, isDone,page,noFilter);
		//结束
		
		
		List list = page.getData();
		
		int start = (currentPage - 1) * pageSize;
//		int end = currentPage * pageSize;
//		int total = 0;
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);

			if ("1".equals(isDone)) {
				map.put("procinstId", map.get("procinstid"));
			}

			// 是否符合条件
			if (!wfBean.check(map, paramName, paramValue))
				continue;

//			total++;

//			if (start >= total || start >= end)
//				continue;
			StringBuffer sql = null;

			if ("1".equals(isDone)) {
				sql = new StringBuffer(
						"SELECT t1.entity_id, t1.proc_name, substr(t1.create_date, 0, 16) create_date, t4.node_name, ")
						.append(" decode(t2.examine_user_id, NULL, wmsys.wm_concat(p1.user_id), decode(wmsys.wm_concat(p1.user_id),  NULL, t2.examine_user_id, ")
						.append("  t2.examine_user_id || ',' || wmsys.wm_concat(p1.user_id))), ")
						.append(" t4.entity_id node_id,t2.entity_id examine_inst_id ")
						.append(" FROM wf_r_procinst t1 ")
						.append(" INNER JOIN wf_r_examineinst t2 ON t1.entity_id = t2.procinst_id ")
						.append(" INNER JOIN wf_r_taskinst t3 ON t2.taskinst_id = t3.entity_id ")
						.append(" INNER JOIN wf_d_node t4 ON t4.entity_id = t3.node_id ")
						.append(" LEFT OUTER JOIN P_AUTH_USER_ROLE_DMS p1 ON t2.examine_role_id = p1.role_id ")
						.append(" WHERE t1.entity_id = '")
						.append("1".equals(isDone) ? map.get("procinstid")
								: map.get("procinstId"))
						.append("'")
						.append(" GROUP BY t1.entity_id, t1.proc_name, t1.create_date, t2.examine_user_id, t2.examine_role_id, t4.node_name, t4.entity_id, t2.entity_id ");

			} else {
				sql = new StringBuffer(
						"select t1.entity_id, t1.proc_name, substr(t1.create_date, 0, 16) create_date, t4.node_name from wf_r_procinst t1 inner join wf_r_examineinst t5 on t1.entity_id = t5.procinst_id inner join wf_d_node t4 on t4.entity_id = t5.node_id  and t5.state = '1' ")
						.append(" where t1.entity_id='")
						.append("1".equals(isDone) ? map.get("procinstid")
								: map.get("procinstId")).append("'");
			}

			Map mapNew = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
					sql.toString());
			map.put("currentRowNum", String.valueOf(start + 1));
			map.put("currentProcName", mapNew.get("procName"));
			if ("1".equals(isDone)) {
				map.put("entityId", mapNew.get("examineInstId"));
			}
			map.put("currentcreateDate", mapNew.get("createDate"));
			map.put("currentNode", mapNew.get("nodeName"));

			// 获取页面审批地址
			Map mapNodeConfig = wfBean.getWFNodeConfigId(
					(String) map.get("procinstId"),
					(String) map.get("entityId"));
			String nodeLinkType = (String) mapNodeConfig.get("nodeLinkType");
			String nodeLink = (String) mapNodeConfig.get("nodeLink");
			String nodeLinkParam = (String) mapNodeConfig.get("nodeLinkParam");
			if ("1".equals(nodeLinkType)) {
				nodeLink += "?a=1";
				String[] nodeLinkParams = nodeLinkParam.split(",");
				for (String param : nodeLinkParams) {
					nodeLink = nodeLink + "&" + param + "="
							+ map.get("wfVar_" + param);
				}
			}
			map.put("nodeLinkType", nodeLinkType);
			map.put("nodeLink", nodeLink);
			listNew.add(map);

			start++;
		}
		
		List neList =new ArrayList();
		for(int i=0;i<listNew.size();i++){
			Map mapNew=(Map)list.get(i);
			if(mapNew!=null){
				if("1".equals(isDone)){
					String sql1="select * from Wf_R_Examineinst where entity_id='"+mapNew.get("entityId")+"' and state='2'";
					Map map1 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql1.toString());
					if(map1!=null){
						String sql="select t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo,t.plan_invoice_type from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'  inner join common_busi_wf_middle wf on t.plan_invoice_id=wf.business_id  where t.plan_invoice_id='"+mapNew.get("wfVar_planInvoiceId")+"'";
						Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql.toString());
						if(map!=null){
							mapNew.put("state", "已审批");
							mapNew.put("planName", map.get("planName"));
							mapNew.put("totalMoney", map.get("totalMoney"));
							mapNew.put("submiteNumber", map.get("submiteNumber"));
							mapNew.put("username", map.get("userName"));
							mapNew.put("plan_invoice_type", map.get("planInvoiceType"));
							neList.add(mapNew);
						}
					}
				}else{
					mapNew.put("state", mapNew.get("state")==null?"审批通过":mapNew.get("state").equals("1")?"待审批":mapNew.get("state").equals("4")?"审批不通过":"审批通过");
					String sql = "select t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo,t.plan_invoice_type from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' where t.plan_invoice_id='"+mapNew.get("wfVar_planInvoiceId")+"'";
					Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql.toString());
					mapNew.put("planName", map.get("planName"));
					mapNew.put("totalMoney", map.get("totalMoney"));
					mapNew.put("submiteNumber", map.get("submiteNumber"));
					mapNew.put("username", map.get("userName"));
					mapNew.put("plan_invoice_type", map.get("planInvoiceType"));
					
					
				}
			
			}
		}
		if("1".equals(isDone)){
			if(page.getCurrPage()==1){
				page.setTotalRow(neList.size());
				page.setPageCount(neList.size()/page.getPageSize()+1);
			}
			msg.setValue("datas", neList);
		}else{
			msg.setValue("datas", listNew);
		}
		
		

		msg.setValue("totalRows", page.getTotalRow());

//		int pageCount = total / pageSize;
//		pageCount += ((total % pageSize) == 0 ? 0 : 1);

		msg.setValue("pageCount", page.getPageCount());
		msg.setValue("pageSize", pageSize);
		msg.setValue("currentPage", currentPage);

		return msg;
	}
	
	/*
	 * 获取大港自有设备审批列表信息
	 */

	public ISrvMsg getWFProcessListDevDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isDone = reqDTO.getValue("isDone");
		UserToken user = reqDTO.getUserToken();
		String businessType = reqDTO.getValue("businessType");
		System.out.println(reqDTO.toMap());
		System.out.println("businessType == "+businessType);

		// businessType分为2种情况：
		// 若有值 则根据此值布过滤流程 及获取定制化信息
		// 若无值则取当前用户所有的待审批信息，流程列表页面采用公共页面 不附加任何自定义字段

		// 获取审批列表信息(待审批/已审批) businessType为null或者""则不进行过滤
//		List list = wfBean.getWFProcessList(businessType, user, isDone);

		List listNew = new ArrayList();

		// 流程过滤信息
		String[] paramName = new String[0];
		String[] paramValue = new String[0];

		if (businessType != null && !"".equals(businessType)&&!"null".equals(businessType)) {
			// 获取定制化查询条件及列表项
			String sBusinessType=businessType;
			if(businessType.contains(",")){
				sBusinessType=businessType.split(",")[0];
			}
			Map mapCustom = wfBean.getCustomQueryListInfo(sBusinessType);

			if(mapCustom!=null){
				msg.setValue("queryBuilder", (String) mapCustom.get("queryBuilder"));
				msg.setValue("queryBuilderMean",
						(String) mapCustom.get("queryBuilderMean"));
				msg.setValue("listBuilder", (String) mapCustom.get("listBuilder"));
				msg.setValue("listBuilderMean",
						(String) mapCustom.get("listBuilderMean"));
	
				// 定制化查询条件
				String params = (String) mapCustom.get("queryBuilder");
	
				if (params != null && !params.equals("")) {
					paramName = params.split(",");
					paramValue = new String[paramName.length];
					for (int i = 0; i < paramName.length; i++) {
						paramValue[i] = reqDTO.getValue(paramName[i]);
						if (paramValue[i] == null)
							paramValue[i] = "";
					}
				}
			}
		}

		// 过滤流程信息
		// 列表分页显示代码部分
		String currentPageStr = reqDTO.getValue("currentPage");
		if (currentPageStr == null || currentPageStr.trim().equals(""))
			currentPageStr = "1";
		String pageSizeStr = reqDTO.getValue("pageSize");
		if (pageSizeStr == null || pageSizeStr.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSizeStr = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		int currentPage = Integer.parseInt(currentPageStr);
		int pageSize = Integer.parseInt(pageSizeStr);
		
		//2013年8月14  吴海军 工作流分页
		PageModel page = new PageModel();
		page.setCurrPage(currentPage);
		page.setPageSize(pageSize);
		

		//不需要用户过滤流程
		String noFilter = reqDTO.getValue("noFilter");
		page = wfBean.getWFProcessListForPage(businessType, user, isDone,page,noFilter);
		//结束
		
		
		List list = page.getData();
		
		int start = (currentPage - 1) * pageSize;

		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);

			if ("1".equals(isDone)) {
				map.put("procinstId", map.get("procinstid"));
			}

			// 是否符合条件
			if (!wfBean.check(map, paramName, paramValue))
				continue;

			StringBuffer sql = null;

			if ("1".equals(isDone)) {
				sql = new StringBuffer(
						"SELECT t1.entity_id, t1.proc_name, substr(t1.create_date, 0, 16) create_date, t4.node_name, ")
						.append(" decode(t2.examine_user_id, NULL, wmsys.wm_concat(p1.user_id), decode(wmsys.wm_concat(p1.user_id),  NULL, t2.examine_user_id, ")
						.append("  t2.examine_user_id || ',' || wmsys.wm_concat(p1.user_id))), ")
						.append(" t4.entity_id node_id,t2.entity_id examine_inst_id ")
						.append(" FROM wf_r_procinst t1 ")
						.append(" INNER JOIN wf_r_examineinst t2 ON t1.entity_id = t2.procinst_id ")
						.append(" INNER JOIN wf_r_taskinst t3 ON t2.taskinst_id = t3.entity_id ")
						.append(" INNER JOIN wf_d_node t4 ON t4.entity_id = t3.node_id ")
						.append(" LEFT OUTER JOIN P_AUTH_USER_ROLE_DMS p1 ON t2.examine_role_id = p1.role_id ")
						.append(" WHERE t1.entity_id = '")
						.append("1".equals(isDone) ? map.get("procinstid")
								: map.get("procinstId"))
						.append("'")
						.append(" GROUP BY t1.entity_id, t1.proc_name, t1.create_date, t2.examine_user_id, t2.examine_role_id, t4.node_name, t4.entity_id, t2.entity_id ");
				System.out.println("sql11 == "+sql);

			} else {
				sql = new StringBuffer(
						"select t1.entity_id, t1.proc_name, substr(t1.create_date, 0, 16) create_date, t4.node_name from wf_r_procinst t1 inner join wf_r_examineinst t5 on t1.entity_id = t5.procinst_id inner join wf_d_node t4 on t4.entity_id = t5.node_id  and t5.state = '1' ")
						.append(" where t1.entity_id='")
						.append("1".equals(isDone) ? map.get("procinstid")
								: map.get("procinstId")).append("'");
				System.out.println("sql == "+sql);
			}

			Map mapNew = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
					sql.toString());
			map.put("currentRowNum", String.valueOf(start + 1));
			map.put("currentProcName", mapNew.get("procName"));
			if ("1".equals(isDone)) {
				map.put("entityId", mapNew.get("examineInstId"));
			}
			map.put("currentcreateDate", mapNew.get("createDate"));
			map.put("currentNode", mapNew.get("nodeName"));

			// 获取页面审批地址
			Map mapNodeConfig = wfBean.getWFNodeConfigId(
					(String) map.get("procinstId"),
					(String) map.get("entityId"));
			String nodeLinkType = (String) mapNodeConfig.get("nodeLinkType");
			String nodeLink = (String) mapNodeConfig.get("nodeLink");
			String nodeLinkParam = (String) mapNodeConfig.get("nodeLinkParam");
			if ("1".equals(nodeLinkType)) {
				nodeLink += "?a=1";
				String[] nodeLinkParams = nodeLinkParam.split(",");
				for (String param : nodeLinkParams) {
					nodeLink = nodeLink + "&" + param + "="
							+ map.get("wfVar_" + param);
				}
			}
			map.put("nodeLinkType", nodeLinkType);
			map.put("nodeLink", nodeLink);
			listNew.add(map);

			start++;
		}
				
		for(int i=0;i<listNew.size();i++){
			Map mapNew=(Map)list.get(i);
			if(mapNew!=null){
			mapNew.put("state", mapNew.get("state")==null?"审批通过":mapNew.get("state").equals("1")?"待审批":mapNew.get("state").equals("4")?"审批不通过":"审批通过");
			//String sql = "select t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' where t.plan_invoice_id='"+mapNew.get("wfVar_planInvoiceId")+"'";
			
			StringBuffer sql = new StringBuffer(
					"select case devapp.allapp_type when 'S1404' then '专业化测量' when 'S1405' then '专业化仪器' when 'S0623' then '专业化震源' end as allapptype ,pro.project_name,devapp.device_allapp_id,devapp.device_allapp_no,devapp.device_allapp_name,devapp.project_info_no,")
			.append(" devapp.org_id,devapp.employee_id,devapp.appdate,devapp.create_date,devapp.modifi_date,")
			.append(" case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,")
			.append(" org.org_abbreviation as org_name,emp.employee_name ")
			.append(" from gms_device_allapp devapp ")
			.append(" left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id and wfmiddle.bsflag='0' ")
			.append(" left join comm_org_information org on devapp.org_id = org.org_id ")
			.append(" left join comm_human_employee emp on devapp.employee_id = emp.employee_id ")
			.append(" left join gp_task_project pro on devapp.project_info_no=pro.project_info_no and pro.bsflag = '0' ")
			.append(" where devapp.bsflag = '0' and devapp.project_info_no='"+mapNew.get("wfVar_projectInfoNo")+"' ")
			.append(" and devapp.device_allapp_id='"+mapNew.get("wfVar_deviceallappid")+"' ");
						
			Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql.toString());
			
			if(map != null){
				mapNew.put("project_info_no", map.get("projectInfoNo"));
				mapNew.put("project_name", map.get("projectName"));
				mapNew.put("device_allapp_no", map.get("deviceAllappNo"));
				mapNew.put("device_allapp_id", map.get("deviceAllappId"));
				mapNew.put("device_allapp_name", map.get("deviceAllappName"));
				mapNew.put("org_name", map.get("orgName"));
				mapNew.put("appdate", map.get("appdate"));
				mapNew.put("state", map.get("state"));
				mapNew.put("state_desc", map.get("stateDesc"));
				mapNew.put("allapp_type", map.get("allapptype"));
			}			
		  }
		}
		msg.setValue("datas", listNew);

		msg.setValue("totalRows", page.getTotalRow());

		msg.setValue("pageCount", page.getPageCount());
		msg.setValue("pageSize", pageSize);
		msg.setValue("currentPage", currentPage);

		return msg;
	}

	/*
	 * 获取审批信息
	 */
	public ISrvMsg getWFProcessInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String businessType = reqDTO.getValue("businessType");
		String procinstId = reqDTO.getValue("procinstID");
		String examineinstId = reqDTO.getValue("examineinstID");
		String businessId = reqDTO.getValue("businessId");
		msg.setValue("businessId", businessId);
		msg.setValue("businessType", businessType);
		msg.setValue("examineinstId", examineinstId);
		msg.setValue("procinstId", procinstId);
		Map map = wfBean.getWFProcessInfo(reqDTO.getUserToken(), businessType,
				procinstId, examineinstId);
		wfBean.copyMapToDTO(map, msg);

		// 获取审批历史信息
		List listExamine = wfBean.getProcHistory(procinstId);
		msg.setValue("examineInfoList", listExamine);

		// 获取流程变量信息
		Map mapVarialble = wfBean.getProcessVarInfo(procinstId);
		wfBean.copyMapToDTO(mapVarialble, msg);

		// 获取页面审批地址
		Map mapNodeConfig = wfBean.getWFNodeConfigId(procinstId, examineinstId);
		String nodeLinkType = (String) mapNodeConfig.get("nodeLinkType");
		String nodeLink = (String) mapNodeConfig.get("nodeLink");
		String nodeLinkParam = (String) mapNodeConfig.get("nodeLinkParam");
		nodeLink += "?a=1";
		String[] nodeLinkParams = nodeLinkParam.split(",");
		for (String param : nodeLinkParams) {
			nodeLink = nodeLink + "&" + param + "="
					+ mapVarialble.get("wfVar_" + param);
		}
		msg.setValue("nodeLinkType", nodeLinkType);
		msg.setValue("nodeLink", nodeLink);
		return msg;
	}
	
	

	/*
	 * 审批操作
	 */
	public ISrvMsg doWfProcess(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		String nextNodeId = reqDTO.getValue("nextNodeID");
		String examineInfo = reqDTO.getValue("examineInfo");
		String isPassstr = reqDTO.getValue("isPass");
		String examineinstId = reqDTO.getValue("examineinstID");
		String procinstId = reqDTO.getValue("procinstID");
		String taskinstId = reqDTO.getValue("taskinstId");
		String moveNodeId = reqDTO.getValue("moveNodeId");
		String businessType = reqDTO.getValue("businessType");
		String businessId = reqDTO.getValue("businessId");
		//System.out.println("-----------------------"+moveNodeId);
		String procStatus = wfBean.doWfProcess(reqDTO.getUserToken(),
				nextNodeId, examineInfo, isPassstr, examineinstId, procinstId,
				taskinstId, moveNodeId, businessId);
		msg.setValue("procStatus", procStatus);
		msg.setValue("businessType", businessType);
		// 获取业务表单地址
		String formUrl = wfBean.getCustomBusinessForm(businessType);
		msg.setValue("formUrl", formUrl);
		
		//--------------------------------
		//井中立项修改  by bianshen 
		//如果流程编号为5110000004100000162 并且 isPassstr 的值为 pass 直接修改项目立项状态为项目启动5000100001000000001
		if(businessType!=null&&businessType.equals("5110000004100001002")&&isPassstr!=null&&isPassstr.equals("pass")){
			String sql = " update gp_task_project set project_status='5000100001000000001' where project_info_no ='"+businessId+"'";
			((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate().execute(sql);
		}
		//井中项目周报审核通过以后修改项目状态为施工结束
		if(businessType!=null&&businessType.equals("5110000004100000218")&&isPassstr!=null&&isPassstr.equals("pass")){
			String sql = " update gp_task_project set project_status='5000100001000000005' where project_info_no ='"+businessId+"'";
			((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate().execute(sql);
		}
		
		return msg;
	}

	/*
	 * 
	 */

	public ISrvMsg getWfProcessHistoryInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String businessTableName, businessType, businessId;
		businessTableName = reqDTO.getValue("businessTableName");
		businessType = reqDTO.getValue("businessType");
		businessId = reqDTO.getValue("businessId");
		String sql = "select proc_id,proc_inst_id from common_busi_wf_middle ";
		if(businessTableName==null||"".equals(businessTableName)){
			sql+="where  business_type='"
					+ businessType
					+ "' and business_id='" + businessId + "' and bsflag='0' order by PROC_STATUS asc";
		}else{
			sql+="where busi_table_name = '"+businessTableName
					+ "' and business_type='"
					+ businessType
					+ "' and business_id='" + businessId + "' and bsflag='0'  order by proc_status asc";
		}
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if (map != null) {
			String procInstId = (String) map.get("procInstId");
			if (procInstId != null && !"".equals(procInstId)) {
				List list = wfBean.getProcHistory(procInstId);
				msg.setValue("datas", list);
			}
		}
		// 获取流程审批状态
		String sqlStatus = "select  proc_status,proc_inst_id from common_busi_wf_middle where busi_table_name = '"
				+ businessTableName
				+ "' and business_id = '"
				+ businessId
				+ "' and business_type='" + businessType + "' and bsflag='0'  order by proc_status asc";
		Map mapStatus=BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlStatus);
		if(mapStatus!=null){
			String procStatus=(String) mapStatus.get("procStatus");
			String procInstId=(String) mapStatus.get("procInstId");
			if (procStatus != null && !"".equals(procStatus)) {
				msg.setValue("procStatus", procStatus);
			}
			if (procInstId != null && !"".equals(procInstId)) {
				msg.setValue("procInstId", procInstId);
			}
		}
		return msg;
	}

	/*
	 * 
	 */
	public ISrvMsg toViewExamineInfowfpg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String id = reqDTO.getValue("id");
		String sql = "select pv.*, he.employee_name from bgp_op_cost_project_schema pv left outer join comm_human_employee he on pv.creator = he.employee_id"
				+ " where pv.bsflag = '0' and pv.cost_project_schema_id='"
				+ id
				+ "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		msg.setValue("data", map);
		return msg;
	}
	public ISrvMsg getWfProcessDocInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String businessType = reqDTO.getValue("businessType");
		String sql = "select file_id ucmid from wf_d_procdefine proc  left outer join common_busi_wf_extension we on proc.proc_e_name=we.proc_e_name where proc.proc_type ='"+businessType+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		msg.setValue("ucmId", map==null?"":map.get("ucmid"));
		return msg;
	}

	/*
	 * 
	 */
	public ISrvMsg toDoExamineInfowfpa(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		System.out.println("do something");
		return msg;
	}
	
	/*
	 * 获取流程类型
	 */
	public ISrvMsg getProcTypeTree(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sqlBuffer = new StringBuffer(" select connect_by_root(sd.coding_code_id) root,level, ");
		sqlBuffer.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(coding_code_id, '/') path,sd.coding_name, ");
		sqlBuffer.append(" sd.coding_code_id,sd.superior_code_id parent_id,sd.superior_code_id zip,wc.config_id ");
		sqlBuffer.append(" from comm_coding_sort_detail sd " );
		sqlBuffer.append(" left outer join common_busi_wf_config wc on sd.coding_code_id = wc.business_type and wc.bsflag='0' " );
		sqlBuffer.append(" where sd.bsflag='0' start with sd.superior_code_id = '0' and sd.coding_sort_id = '5110000181'");
		sqlBuffer.append(" connect by prior sd.coding_code_id = sd.superior_code_id ");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("codingCodeId", "0");
		map.put("parentId", "root");
		map.put("codingName", "流程类型");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "codingCodeId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}
}
