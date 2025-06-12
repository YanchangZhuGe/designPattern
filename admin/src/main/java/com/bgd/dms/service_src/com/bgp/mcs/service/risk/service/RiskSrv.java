package com.bgp.mcs.service.risk.service;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import net.sf.json.JSONArray;

import com.bgp.gms.service.op.util.OPCommonUtil;
import com.bgp.mcs.service.pm.service.projectCode.ProjectCodeSrv;
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

public class RiskSrv extends BaseService {
	
	private ILog log;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	public RiskSrv(){
		log = LogFactory.getLogger(RiskSrv.class);
	}

	/**
	 * 获取全部风险评价基础
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRiskBasics(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRiskBasics");
		StringBuffer sql = new StringBuffer("select level, decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, t.*,(case t.risk_level when '1' then '1-2低度' when '2' then '3-4较低' when '3' then '5-10中度' when '4' then '11-20高度' when '5' then '21-25极高' else '' end ) as the_risk_level,r.risk_type_name" +
				" from bgp_risk_evaluate_base t left outer join bgp_risk_type r on t.risk_type = r.risk_type_id where t.bsflag = '0' start with t.parent_risk_id = 'root' connect by prior t.risk_id = t.parent_risk_id order by t.order_num");
		
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		
		Map map = new HashMap();
		map.put("riskId", "root");
		map.put("parentRiskId", "root");
		map.put("riskName", "东方地球物理公司");
		map.put("riskDesc", "");
		map.put("expanded", "true");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "riskId", "parentRiskId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
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
	
	
	/**
	 * 获取风险评价基础的详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg getRiskInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getRiskInfo !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		String risk_id = isrvmsg.getValue("riskID");	
        
		Map riskInfoMap = new HashMap();
		
        String query_risk_sql="select r.risk_id,r.risk_name,r.risk_desc,r.risk_type,r.create_date,r.risk_level,r.order_num,r.is_node,r.risk_possibility,(case r.risk_possibility when '1' then '几乎不可能' when '2' then '不太可能' when '3' then '可能' when '4' then '很可能' when '5' then '基本确定' else '' end ) as risk_happen_possibility,(case r.risk_level when '1' then '1-2低度' when '2' then '3-4较低' when '3' then '5-10中度' when '4' then '11-20高度' when '5' then '21-25极高' else '' end ) as the_risk_level,u.user_name,t.risk_type_name from bgp_risk_evaluate_base r left outer join p_auth_user u on r.creator_id = u.user_id left outer join bgp_risk_type t on r.risk_type = t.risk_type_id where r.bsflag = '0' and r.risk_id = '"+risk_id+"'";
        Map map=jdbcDao.queryRecordBySQL(query_risk_sql);
        if(map!=null){
        	riskInfoMap.put("risk_id",map.get("riskId").toString());
        	riskInfoMap.put("risk_name",map.get("riskName").toString());
        	riskInfoMap.put("risk_desc",map.get("riskDesc").toString());
        	riskInfoMap.put("create_date",map.get("createDate").toString());
        	riskInfoMap.put("creator_name",map.get("userName").toString());
        	riskInfoMap.put("risk_level",map.get("riskLevel").toString());
        	riskInfoMap.put("risk_type",map.get("riskTypeName").toString());
        	riskInfoMap.put("risk_type_id",map.get("riskType").toString());
        	riskInfoMap.put("order_num",map.get("orderNum").toString());
        	riskInfoMap.put("is_node",map.get("isNode").toString());
        	riskInfoMap.put("the_risk_level",map.get("theRiskLevel").toString());
        	riskInfoMap.put("risk_possibility",map.get("riskPossibility").toString());
        	riskInfoMap.put("risk_happen_possibility",map.get("riskHappenPossibility").toString());
        }
		responseDTO.setValue("riskInfoMap", riskInfoMap); 
		return responseDTO;

	}
	/**
	 * 新增风险评价基础
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg addRisk(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addRisk !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map addRiskMap = new HashMap();
		String add_type = isrvmsg.getValue("add_type");
		String parent_risk_id = isrvmsg.getValue("parent_risk_id");
		System.out.println("add type is:"+add_type);
		if(add_type.equals("1")){
			//增加的是节点
			String risk_name = isrvmsg.getValue("risk_name")!=null?isrvmsg.getValue("risk_name"):"";	
			addRiskMap.put("risk_name", risk_name);
			addRiskMap.put("parent_risk_id", parent_risk_id);
			addRiskMap.put("order_num", 1000);
			addRiskMap.put("is_node", "1");
			addRiskMap.put("bsflag", "0");
			addRiskMap.put("create_date", new Date());			
			addRiskMap.put("creator_id", user.getUserId());
			addRiskMap.put("modifi_date", new Date());
			addRiskMap.put("updator_id", user.getUserId());
			addRiskMap.put("org_id", user.getCodeAffordOrgID());
			addRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		}else if(add_type.equals("0")){
			//增加的是数据
			String risk_name = isrvmsg.getValue("risk_name")!=null?isrvmsg.getValue("risk_name"):"";		
			String risk_level = isrvmsg.getValue("risk_level")!=null?isrvmsg.getValue("risk_level"):"";
			String risk_type = isrvmsg.getValue("risk_type")!=null?isrvmsg.getValue("risk_type"):"";
			String risk_desc = isrvmsg.getValue("risk_desc")!=null?isrvmsg.getValue("risk_desc"):"";
			String risk_possibility = isrvmsg.getValue("risk_possibility")!=null?isrvmsg.getValue("risk_possibility"):"";
			addRiskMap.put("risk_name", risk_name);
			addRiskMap.put("risk_level", risk_level);
			addRiskMap.put("risk_type", risk_type);
			addRiskMap.put("order_num", 1000);
			addRiskMap.put("risk_desc", risk_desc);
			addRiskMap.put("risk_possibility", risk_possibility);
			addRiskMap.put("parent_risk_id", parent_risk_id);
			addRiskMap.put("is_node", "0");
			addRiskMap.put("bsflag", "0");
			addRiskMap.put("create_date", new Date());			
			addRiskMap.put("creator_id", user.getUserId());
			addRiskMap.put("modifi_date", new Date());
			addRiskMap.put("updator_id", user.getUserId());
			addRiskMap.put("org_id", user.getCodeAffordOrgID());
			addRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		}
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(addRiskMap, "bgp_risk_evaluate_base");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 编辑风险评价基础
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg editRisk(ISrvMsg isrvmsg) throws Exception {
		System.out.println("editRisk !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map editRiskMap = new HashMap();
		String edit_type = isrvmsg.getValue("editType");
		String edit_risk_id = isrvmsg.getValue("edit_risk_id")!=null?isrvmsg.getValue("edit_risk_id"):"";
		if(edit_type.equals("1")){
			//修改的是节点
			String risk_name = isrvmsg.getValue("risk_name")!=null?isrvmsg.getValue("risk_name"):"";	
			editRiskMap.put("risk_id", edit_risk_id);
			editRiskMap.put("risk_name", risk_name);
			//editRiskMap.put("is_node", "1");
			editRiskMap.put("modifi_date", new Date());
			editRiskMap.put("updator_id", user.getUserId());
			editRiskMap.put("org_id", user.getCodeAffordOrgID());
			editRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		}else if(edit_type.equals("0")){
			//修改的是数据
			String risk_name = isrvmsg.getValue("risk_name")!=null?isrvmsg.getValue("risk_name"):"";		
			String risk_level = isrvmsg.getValue("risk_level")!=null?isrvmsg.getValue("risk_level"):"";
			String risk_type = isrvmsg.getValue("risk_type")!=null?isrvmsg.getValue("risk_type"):"";
			String order_num = isrvmsg.getValue("order_num")!=null?isrvmsg.getValue("order_num"):"";
			String risk_desc = isrvmsg.getValue("risk_desc")!=null?isrvmsg.getValue("risk_desc"):"";
			String risk_possibility = isrvmsg.getValue("risk_possibility")!=null?isrvmsg.getValue("risk_possibility"):"";
			editRiskMap.put("risk_id", edit_risk_id);
			editRiskMap.put("risk_name", risk_name);
			editRiskMap.put("risk_level", risk_level);
			editRiskMap.put("risk_type", risk_type);
			editRiskMap.put("order_num", order_num);
			editRiskMap.put("risk_desc", risk_desc);
			editRiskMap.put("risk_possibility", risk_possibility);
			editRiskMap.put("modifi_date", new Date());
			editRiskMap.put("updator_id", user.getUserId());
			editRiskMap.put("org_id", user.getCodeAffordOrgID());
			editRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		}
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(editRiskMap, "bgp_risk_evaluate_base");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 获取所有的风险识别
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskIdentify(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllRiskIdentify");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String project_info_no = user.getProjectInfoNo() != null?user.getProjectInfoNo():"";
		String risk_confirm = isrvmsg.getValue("riskConfirm") != null?isrvmsg.getValue("riskConfirm"):"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		String is_flow = isrvmsg.getValue("isflow") != null?isrvmsg.getValue("isflow"):"";
		String project_name = isrvmsg.getValue("projectName") != null?isrvmsg.getValue("projectName"):"";
		String project_number = isrvmsg.getValue("projectNumber") != null?isrvmsg.getValue("projectNumber"):"";
		String project_info_nos = "";
		
		System.out.println("is flow is:"+is_flow);
		StringBuffer querySql = new StringBuffer("select t.risk_type_name,i.risk_identify_id,i.risk_number,i.risk_bear_level,i.risk_level,i.evaluate_base_id,i.project_info_no,i.risk_measure,i.create_date,b.risk_db_id,i.risk_identify_name,i.risk_desc,i.influence_level,i.risk_probability,b.risk_type,u.user_name,i.risk_confirm,(case i.risk_confirm when '0' then '否' when '1' then '是' else '' end) as is_risk,t1.project_name from bgp_risk_identify i left outer join bgp_risk_database b on i.evaluate_base_id = b.risk_db_id left outer join p_auth_user u on i.creator_id=u.user_id left outer join bgp_risk_type t on t.risk_type_id = i.risk_type_id left outer join gp_task_project t1 on i.project_info_no = t1.project_info_no where i.bsflag = '0'");
		if(is_multi != "" && is_multi != null){
			if(project_name != ""){
				//根据项目名称从项目表中获取项目主键
				project_info_nos = radDao.queryRecordBySQL("select wm_concat(''''||t.project_info_no||'''') as projectinfonos from gp_task_project t where t.bsflag = '0' and t.project_name like '%"+project_name+"%'").get("projectinfonos").toString();
				if(project_info_nos != ""){
					querySql.append(" and i.project_info_no in ("+project_info_nos+")");
				}else{
					querySql.append(" and i.project_info_no in ('')");
				}
				
			}else if(project_number != ""){
				//根据项目编号从项目表中获取项目主键
				project_info_nos = radDao.queryRecordBySQL("select wm_concat(''''||t.project_info_no||'''') as projectinfonos from gp_task_project t where t.bsflag = '0' and t.project_id like '%"+project_number+"%'").get("projectinfonos").toString();
				if(project_info_nos != ""){
					querySql.append(" and i.project_info_no in ("+project_info_nos+")");
				}else{
					querySql.append(" and i.project_info_no in ('')");
				}
				
			}else{
				querySql.append(" and i.project_info_no is null");
			}
			
		}else{
			if(project_info_no != null&& project_info_no != ""){
				querySql.append(" and t1.bsflag = '0'");
				querySql.append(" and i.project_info_no='"+project_info_no+"'");
			}
		}
		if(risk_confirm != null&& risk_confirm != ""){
			querySql.append(" and i.risk_confirm='"+risk_confirm+"'");
		}
		if(is_flow != ""&& is_flow != null){
			if(is_flow.equals("1")){
				querySql.append(" and i.is_flow_risk='1'");
			}else if(is_flow.equals("0")){
				querySql.append(" and i.is_flow_risk='0'");
			}
		}else{
			querySql.append(" and i.is_flow_risk='0'");
		}
		querySql.append(" order by i.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	/**
	 * 新增风险识别
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg addRiskIdentify(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addRiskIdentify !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map addRiskMap = new HashMap();
		//风险识别这里的都是非流程风险。流程风险直接在流程控制中创建。
		String risk_number = isrvmsg.getValue("risk_number")!=null?isrvmsg.getValue("risk_number"):"";		
		String risk_bear_level = isrvmsg.getValue("risk_bear_level")!=null?isrvmsg.getValue("risk_bear_level"):"";	
		String risk_id = isrvmsg.getValue("risk_id")!=null?isrvmsg.getValue("risk_id"):"";
		String risk_name = isrvmsg.getValue("risk_name")!=null?isrvmsg.getValue("risk_name"):"";
		String risk_type_id = isrvmsg.getValue("risk_type_id")!=null?isrvmsg.getValue("risk_type_id"):"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		String add_type = isrvmsg.getValue("addType") != null?isrvmsg.getValue("addType"):"";
		String risk_level = isrvmsg.getValue("risk_level") != null?isrvmsg.getValue("risk_level"):"";
		String risk_desc = isrvmsg.getValue("risk_desc") != null?isrvmsg.getValue("risk_desc"):"";
		String risk_confirm = isrvmsg.getValue("risk_confirm") != null?isrvmsg.getValue("risk_confirm"):"";
		String influence_level = isrvmsg.getValue("influence_level") != null?isrvmsg.getValue("influence_level"):"";
		String risk_probability = isrvmsg.getValue("risk_probability") != null?isrvmsg.getValue("risk_probability"):"";
		
		addRiskMap.put("risk_number", risk_number);
		addRiskMap.put("risk_identify_name", risk_name);
		addRiskMap.put("risk_bear_level", risk_bear_level);
		addRiskMap.put("evaluate_base_id", risk_id);
		addRiskMap.put("risk_type_id", risk_type_id);
		addRiskMap.put("risk_level", risk_level);
		addRiskMap.put("risk_desc", risk_desc);
		addRiskMap.put("influence_level", influence_level);
		addRiskMap.put("risk_probability", risk_probability);
		addRiskMap.put("bsflag", "0");
		
		if(add_type != "" && add_type != null){
			//流程风险
			addRiskMap.put("is_flow_risk", "1");
			addRiskMap.put("risk_confirm", "1");
		}else{
			//非流程风险
			addRiskMap.put("is_flow_risk", "0");
			if(risk_confirm != ""&& risk_confirm != null){
				addRiskMap.put("risk_confirm", "1");
			}
		}
		
		if(is_multi == "" || is_multi == null){
			addRiskMap.put("project_info_no", user.getProjectInfoNo());
		}
		addRiskMap.put("create_date", new Date());			
		addRiskMap.put("creator_id", user.getUserId());
		addRiskMap.put("modifi_date", new Date());
		addRiskMap.put("updator_id", user.getUserId());
		addRiskMap.put("org_id", user.getCodeAffordOrgID());
		addRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(addRiskMap, "bgp_risk_identify");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 编辑风险识别
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg editRiskIdentify(ISrvMsg isrvmsg) throws Exception {
		System.out.println("editRiskIdentify !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map editRiskMap = new HashMap();
		String risk_number = isrvmsg.getValue("risk_number")!=null?isrvmsg.getValue("risk_number"):"";	
		String risk_bear_level = isrvmsg.getValue("risk_bear_level")!=null?isrvmsg.getValue("risk_bear_level"):"";	
		String eidt_identify_id = isrvmsg.getValue("risk_identify_id")!=null?isrvmsg.getValue("risk_identify_id"):"";
		String risk_level = isrvmsg.getValue("risk_level") != null?isrvmsg.getValue("risk_level"):"";
		
		String risk_id = isrvmsg.getValue("risk_id")!=null?isrvmsg.getValue("risk_id"):"";		
		String risk_name = isrvmsg.getValue("risk_name")!=null?isrvmsg.getValue("risk_name"):"";
		String risk_type_id = isrvmsg.getValue("risk_type_id")!=null?isrvmsg.getValue("risk_type_id"):"";
		String risk_desc = isrvmsg.getValue("risk_desc") != null?isrvmsg.getValue("risk_desc"):"";
		String influence_level = isrvmsg.getValue("influence_level") != null?isrvmsg.getValue("influence_level"):"";
		String risk_probability = isrvmsg.getValue("risk_probability") != null?isrvmsg.getValue("risk_probability"):"";
		
		editRiskMap.put("risk_number", risk_number);
		editRiskMap.put("risk_bear_level", risk_bear_level);
		editRiskMap.put("risk_identify_id", eidt_identify_id);
		editRiskMap.put("evaluate_base_id", risk_id);
		editRiskMap.put("risk_identify_name", risk_name);
		editRiskMap.put("risk_bear_level", risk_bear_level);
		editRiskMap.put("influence_level", influence_level);
		editRiskMap.put("risk_probability", risk_probability);
		editRiskMap.put("risk_type_id", risk_type_id);
		editRiskMap.put("risk_desc", risk_desc);
		editRiskMap.put("risk_level", risk_level);
		editRiskMap.put("modifi_date", new Date());
		editRiskMap.put("updator_id", user.getUserId());
		editRiskMap.put("org_id", user.getCodeAffordOrgID());
		editRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());		
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(editRiskMap, "bgp_risk_identify");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 增加措施
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addRiskMeasure(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addRiskMeasure !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map editRiskMap = new HashMap();
		String eidt_identify_id = isrvmsg.getValue("risk_identify_id")!=null?isrvmsg.getValue("risk_identify_id"):"";
		String risk_measure = isrvmsg.getValue("risk_measure_value")!=null?isrvmsg.getValue("risk_measure_value"):"";	
		
		editRiskMap.put("risk_identify_id", eidt_identify_id);
		editRiskMap.put("risk_measure", risk_measure);
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(editRiskMap, "bgp_risk_identify");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("riskMeasure", risk_measure);
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 获取风险识别的详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRiskIdenfityInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getRiskIdenfityInfo !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String risk_identify_id = isrvmsg.getValue("riskIdentifyID");	
        
		Map riskInfoMap = new HashMap();
		
        //获取文档表主键
        String query_risk_sql="select t.risk_type_name,i.risk_identify_id,i.risk_number,i.risk_bear_level,i.risk_level,i.evaluate_base_id,i.project_info_no,i.risk_measure,i.create_date,b.risk_db_id,i.risk_identify_name,i.risk_desc,i.risk_type_id,i.influence_level,i.risk_probability,u.user_name,i.risk_confirm,(case i.risk_confirm when '0' then '否' when '1' then '是' else '' end) as is_risk from bgp_risk_identify i left outer join bgp_risk_database b on i.evaluate_base_id = b.risk_db_id left outer join p_auth_user u on i.creator_id=u.user_id left outer join bgp_risk_type t on t.risk_type_id = i.risk_type_id where i.bsflag = '0' and i.risk_identify_id = '"+risk_identify_id+"'";
        Map map=jdbcDao.queryRecordBySQL(query_risk_sql);
        if(map!=null){
        	riskInfoMap.put("risk_identify_id",map.get("riskIdentifyId").toString());
        	riskInfoMap.put("evaluate_base_id",map.get("evaluateBaseId").toString());
        	riskInfoMap.put("risk_number",map.get("riskNumber").toString());
        	riskInfoMap.put("risk_bear_level",map.get("riskBearLevel").toString());
        	riskInfoMap.put("risk_measure",map.get("riskMeasure").toString());
        	riskInfoMap.put("risk_id",map.get("riskDbId").toString());
        	riskInfoMap.put("risk_level",map.get("riskLevel").toString());
        	riskInfoMap.put("risk_db_name",map.get("riskIdentifyName").toString());
        	riskInfoMap.put("risk_desc",map.get("riskDesc").toString());
        	riskInfoMap.put("risk_type",map.get("riskTypeId").toString());
        	riskInfoMap.put("risk_type_name",map.get("riskTypeName").toString());
        	riskInfoMap.put("creator_name",map.get("userName").toString());
        	riskInfoMap.put("create_date",map.get("createDate").toString());
        	riskInfoMap.put("influence_level",map.get("influenceLevel").toString());
        	riskInfoMap.put("risk_probability",map.get("riskProbability").toString());
        }
		responseDTO.setValue("riskInfoMap", riskInfoMap); 
		return responseDTO;

	}
	
	/**
	 * 删除风险识别
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRiskIdentify(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteRiskIdentify !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_identify_id = isrvmsg.getValue("riskIdentifyId");		
		String[] params = risk_identify_id.split(",");	
		String updateSql = "";
		if(risk_identify_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_identify g set g.bsflag='1' where g.risk_identify_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
		}
		return responseDTO;

	}
	
	/**
	 * 确定风险
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg confirmRisk(ISrvMsg isrvmsg) throws Exception {
		System.out.println("confirmRisk !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_identify_id = isrvmsg.getValue("riskIdentifyId");
		String[] params = risk_identify_id.split(",");	
		String updateSql = "";
		
		if(risk_identify_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_identify g set g.risk_confirm='1' where g.risk_identify_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
		}
		return responseDTO;
	}
	/**
	 * 取消风险
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg cancelRisk(ISrvMsg isrvmsg) throws Exception {
		System.out.println("cancelRisk !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();				

		String risk_identify_id = isrvmsg.getValue("riskIdentifyId");
		String[] params = risk_identify_id.split(",");	
		String updateSql = "";
		if(risk_identify_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_identify g set g.risk_confirm='0' where g.risk_identify_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		return responseDTO;
	}
	
	/**
	 * 获取所有的风险应对
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskDeals(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllRiskDeals");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String project_info_no = user.getProjectInfoNo() != null?user.getProjectInfoNo():"";
		String relation_id = isrvmsg.getValue("relationId") != null?isrvmsg.getValue("relationId"):"";

		StringBuffer querySql = new StringBuffer("select d.risk_deal_id,d.risk_deal_method,d.risk_deal_step,(case d.risk_deal_step when 'before' then '事前控制' when 'now' then '事中控制' when 'after' then '事后控制' else '' end) as step,d.create_date,u.user_name from bgp_risk_deals d left outer join p_auth_user u on d.creator_id=u.user_id where d.bsflag = '0'");
		if(relation_id != null&& relation_id != ""){
			querySql.append(" and d.relation_id ='"+relation_id+"'");
		}
		querySql.append(" order by d.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 删除风险应对
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRiskDeal(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteRiskDeal !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_deal_id = isrvmsg.getValue("riskDealId");
		String[] params = risk_deal_id.split(",");	
		String updateSql = "";
		if(risk_deal_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_deals g set g.bsflag='1' where g.risk_deal_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		radDao.executeUpdate(updateSql);
		return responseDTO;
	}
	
	/**
	 * 检查风险类型的根节点是否存在	
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkTypeRootExist(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkTypeRootExist !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String project_info_no = user.getProjectInfoNo();

			Map folderInfoMap = new HashMap();
			String checkSql = "select count(t.risk_type_id) as typecount from bgp_risk_type t where t.bsflag = '0'";
			if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkSql).get("typecount").toString())== 0){
				//BGP不存在，需要插入
				System.out.println("TypeRoot不存在");
				folderInfoMap.put("risk_type_name", "风险分类");
				folderInfoMap.put("bsflag", "0");
				folderInfoMap.put("create_date", new Date());
				folderInfoMap.put("creator_id", user.getUserId());
				folderInfoMap.put("modifi_date", new Date());
				folderInfoMap.put("updator_id", user.getUserId());
				folderInfoMap.put("org_id", user.getCodeAffordOrgID());
				folderInfoMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				radDao.saveOrUpdateEntity(folderInfoMap, "bgp_risk_type");
			}else{
				System.out.println("TypeRoot已存在");
			}
		return responseDTO;

	}
	/**
	 * 获取所有风险目标
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskTargets(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllRiskTargets ");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String project_info_no = user.getProjectInfoNo() != null?user.getProjectInfoNo():"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";

		StringBuffer querySql = new StringBuffer("select t.target_id,t.risk_type,r.risk_type_name,t.target_name,t.target_desc,t.create_date,t.risk_bear_level from bgp_risk_target t left outer join bgp_risk_type r on t.risk_type = r.risk_type_id where t.bsflag = '0' and t.is_target_break = '0'");
		if(is_multi != "" && is_multi != null){
			querySql.append(" and t.project_info_no is null");
		}else{
			if(project_info_no != null&& project_info_no != ""){
				querySql.append(" and t.project_info_no='"+project_info_no+"'");
			}
		}
		querySql.append(" order by t.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 获取风险目标详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRiskTargetInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getRiskTargetInfo !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String risk_target_id = isrvmsg.getValue("targetId");	
        
		Map riskInfoMap = new HashMap();
		
        //获取文档表主键
        StringBuffer query_risk_sql= new StringBuffer("select t.target_id,t.risk_type,r.risk_type_name,t.target_name,t.target_desc,t.create_date,t.risk_bear_level from bgp_risk_target t left outer join bgp_risk_type r on t.risk_type = r.risk_type_id where t.bsflag = '0' and t.is_target_break = '0'");
        if(risk_target_id != null&&risk_target_id != ""){
        	query_risk_sql.append(" and t.target_id = '"+risk_target_id+"'");
        }
        Map map=jdbcDao.queryRecordBySQL(query_risk_sql.toString());
        if(map!=null){
        	riskInfoMap.put("target_id",map.get("targetId").toString());
        	riskInfoMap.put("risk_type_id",map.get("riskType").toString());
        	riskInfoMap.put("risk_type_name",map.get("riskTypeName").toString());
        	riskInfoMap.put("target_name",map.get("targetName").toString());
        	riskInfoMap.put("target_desc",map.get("targetDesc").toString());
        	riskInfoMap.put("create_date",map.get("createDate").toString());
        	riskInfoMap.put("risk_bear_level",map.get("riskBearLevel").toString());
        }
		responseDTO.setValue("riskInfoMap", riskInfoMap); 
		return responseDTO;

	}
	/**
	 * 新增风险目标
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addRiskTarget(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addRiskTarget !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map addRiskMap = new HashMap();
		//增加的是数据
			
		String risk_type = isrvmsg.getValue("risk_type_id")!=null?isrvmsg.getValue("risk_type_id"):"";		
		String target_name = isrvmsg.getValue("target_name")!=null?isrvmsg.getValue("target_name"):"";	
		String risk_bear_level = isrvmsg.getValue("risk_bear_level")!=null?isrvmsg.getValue("risk_bear_level"):"";	
		String target_desc = isrvmsg.getValue("target_desc")!=null?isrvmsg.getValue("target_desc"):"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		addRiskMap.put("risk_type", risk_type);
		addRiskMap.put("target_name", target_name);
		addRiskMap.put("target_desc", target_desc);
		addRiskMap.put("risk_bear_level", risk_bear_level);
		addRiskMap.put("bsflag", "0");
		addRiskMap.put("is_target_break", "0");
		if(is_multi == "" || is_multi == null){
			addRiskMap.put("project_info_no", user.getProjectInfoNo());
		}
		addRiskMap.put("create_date", new Date());			
		addRiskMap.put("creator_id", user.getUserId());
		addRiskMap.put("modifi_date", new Date());
		addRiskMap.put("updator_id", user.getUserId());
		addRiskMap.put("org_id", user.getCodeAffordOrgID());
		addRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(addRiskMap, "bgp_risk_target");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	/**
	 * 编辑风险目标
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg editRiskTarget(ISrvMsg isrvmsg) throws Exception {
		System.out.println("editRiskTarget !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map editRiskMap = new HashMap();
		String target_id = isrvmsg.getValue("target_id")!=null?isrvmsg.getValue("target_id"):"";
		String risk_type = isrvmsg.getValue("risk_type_id")!=null?isrvmsg.getValue("risk_type_id"):"";		
		String target_name = isrvmsg.getValue("target_name")!=null?isrvmsg.getValue("target_name"):"";	
		String target_desc = isrvmsg.getValue("target_desc")!=null?isrvmsg.getValue("target_desc"):"";
		String risk_bear_level = isrvmsg.getValue("risk_bear_level")!=null?isrvmsg.getValue("risk_bear_level"):"";	
		//修改的是数据
		editRiskMap.put("target_id", target_id);
		editRiskMap.put("risk_type", risk_type);
		editRiskMap.put("target_name", target_name);
		editRiskMap.put("target_desc", target_desc);	
		editRiskMap.put("risk_bear_level", risk_bear_level);
		editRiskMap.put("modifi_date", new Date());
		editRiskMap.put("updator_id", user.getUserId());
		editRiskMap.put("org_id", user.getCodeAffordOrgID());
		editRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());		
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(editRiskMap, "bgp_risk_target");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	/**
	 * 删除风险目标
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRiskTarget(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteRiskTarget !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_target_id = isrvmsg.getValue("riskTargetId");
		String[] params = risk_target_id.split(",");	
		String updateSql = "";
		if(risk_target_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_target g set g.bsflag='1' where g.target_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		radDao.executeUpdate(updateSql);
		return responseDTO;
	}
	/**
	 * 获取所有目标分解
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllTargetBreaks(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllTargetBreaks");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String project_info_no = user.getProjectInfoNo() != null?user.getProjectInfoNo():"";
		String relation_id = isrvmsg.getValue("relationId") != null?isrvmsg.getValue("relationId"):"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		
		StringBuffer querySql = new StringBuffer("select t.target_id,t.target_break_name,t.target_break_desc,t.target_break_remark,t.create_date from bgp_risk_target t where t.bsflag = '0' and t.is_target_break = '1'");
		if(relation_id != null&& relation_id != ""){
			querySql.append(" and t.relation_id ='"+relation_id+"'");
		}

		if(is_multi != "" && is_multi != null){
			querySql.append(" and t.project_info_no is null");
		}else{
			if(project_info_no != null&& project_info_no != ""){
				querySql.append(" and t.project_info_no='"+project_info_no+"'");
			}
		}
		
		querySql.append(" order by t.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 删除目标分解
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTargetBreaks(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteTargetBreaks !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_deal_id = isrvmsg.getValue("targetId");
		String[] params = risk_deal_id.split(",");	
		String updateSql = "";
		if(risk_deal_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_target g set g.bsflag='1' where g.target_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		radDao.executeUpdate(updateSql);
		return responseDTO;
	}
	
	
	/**
	 * 获取所有风险事件
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskEvent(ISrvMsg isrvmsg) throws Exception {
		
		System.out.println("getAllRiskEvent ");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String project_info_no = user.getProjectInfoNo() != null?user.getProjectInfoNo():"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		String emergency_confirm = isrvmsg.getValue("emergencyConfirm") != null?isrvmsg.getValue("emergencyConfirm"):"";
		String project_name = isrvmsg.getValue("projectName") != null?isrvmsg.getValue("projectName"):"";
		String project_number = isrvmsg.getValue("projectNumber") != null?isrvmsg.getValue("projectNumber"):"";
		String project_info_nos = "";

		StringBuffer querySql = new StringBuffer("select o.org_abbreviation,u.user_name,t.emergency_id,t.emergency_status,t.emergency_problem,t.res_person,t.create_date,t.is_emergency,(case t.is_emergency when '0' then '否' when '1' then '是' else '' end) as emergency_flag,t.emergency_process,t.emergency_reason,t1.project_name,t.happen_date from bgp_risk_emergency t left outer join comm_org_information o on t.org_id = o.org_id left outer join p_auth_user u on t.creator_id = u.user_id left outer join gp_task_project t1 on t.project_info_no = t1.project_info_no where t.bsflag = '0' and t1.bsflag = '0'");
		//is_multi 不为空是多项目
		if(is_multi != "" && is_multi != null){
			if(project_name != ""){
				
				//根据项目名称从项目表中获取项目主键
				
				project_info_nos = radDao.queryRecordBySQL("select wm_concat(''''||t.project_info_no||'''') as projectinfonos from gp_task_project t where t.bsflag = '0' and t.project_name like '%"+project_name+"%'").get("projectinfonos").toString();
				
				System.out.println("project info nums is:"+project_info_nos);
				if(project_info_nos != ""){
					querySql.append(" and t.project_info_no in ("+project_info_nos+")");
				}else{
					querySql.append(" and t.project_info_no in ('')");
				}
								
			}else if(project_number != ""){
				
				//根据项目编号从项目表中获取项目主键
				project_info_nos = radDao.queryRecordBySQL("select wm_concat(''''||t.project_info_no||'''') as projectinfonos from gp_task_project t where t.bsflag = '0' and t.project_id like '%"+project_number+"%'").get("projectinfonos").toString();
				if(project_info_nos != ""){
					querySql.append(" and t.project_info_no in ("+project_info_nos+")");
				}else{
					querySql.append(" and t.project_info_no in ('')");
				}
				
			}else{
				querySql.append(" and t.project_info_no is not null");
			}
			
		}else{
			if(project_info_no != null&& project_info_no != ""){
				querySql.append(" and t.project_info_no='"+project_info_no+"'");
			}
		}
		if(emergency_confirm != "" && emergency_confirm != null){
			querySql.append(" and t.is_emergency='"+emergency_confirm+"'");
		}

		querySql.append(" order by t.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 确认是应急事件
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg confirmEmergency(ISrvMsg isrvmsg) throws Exception {
		System.out.println("confirmEmergency !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_identify_id = isrvmsg.getValue("riskEmergencyId");
		String[] params = risk_identify_id.split(",");	
		String updateSql = "";
		
		if(risk_identify_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_emergency g set g.is_emergency='1' where g.emergency_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
		}
		return responseDTO;
	}
	/**
	 * 取消应急事件
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg cancelEmergency(ISrvMsg isrvmsg) throws Exception {
		System.out.println("cancelEmergency !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();				

		String risk_identify_id = isrvmsg.getValue("riskEmergencyId");
		String[] params = risk_identify_id.split(",");	
		String updateSql = "";
		if(risk_identify_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_emergency g set g.is_emergency='0' where g.emergency_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		return responseDTO;
	}
	
	
	/**
	 * 获取所有应急
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskEmergency(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllEmergency ");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String project_info_no = user.getProjectInfoNo() != null?user.getProjectInfoNo():"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		String project_name = isrvmsg.getValue("projectName") != null?isrvmsg.getValue("projectName"):"";
		String project_number = isrvmsg.getValue("projectNumber") != null?isrvmsg.getValue("projectNumber"):"";
		String project_info_nos = "";

		StringBuffer querySql = new StringBuffer("select o.org_abbreviation,u.user_name,t.emergency_id,t.emergency_status,t.emergency_problem,t.res_person,t.create_date,t.is_emergency,(case t.is_emergency when '0' then '否' when '1' then '是' else '' end) as emergency_flag,t.emergency_process,t.emergency_reason,t1.project_name,t.happen_date from bgp_risk_emergency t left outer join comm_org_information o on t.org_id = o.org_id left outer join p_auth_user u on t.creator_id = u.user_id left outer join gp_task_project t1 on t.project_info_no = t1.project_info_no where t.bsflag = '0' and t1.bsflag = '0' and t.is_emergency = '1'");
		
		if(is_multi != "" && is_multi != null){
			if(project_name != ""){
				
				//根据项目名称从项目表中获取项目主键
				
				project_info_nos = radDao.queryRecordBySQL("select wm_concat(''''||t.project_info_no||'''') as projectinfonos from gp_task_project t where t.bsflag = '0' and t.project_name like '%"+project_name+"%'").get("projectinfonos").toString();
				
				System.out.println("project info nums is:"+project_info_nos);
				if(project_info_nos != ""){
					querySql.append(" and t.project_info_no in ("+project_info_nos+")");
				}else{
					querySql.append(" and t.project_info_no in ('')");
				}
								
			}else if(project_number != ""){
				
				//根据项目编号从项目表中获取项目主键
				project_info_nos = radDao.queryRecordBySQL("select wm_concat(''''||t.project_info_no||'''') as projectinfonos from gp_task_project t where t.bsflag = '0' and t.project_id like '%"+project_number+"%'").get("projectinfonos").toString();
				if(project_info_nos != ""){
					querySql.append(" and t.project_info_no in ("+project_info_nos+")");
				}else{
					querySql.append(" and t.project_info_no in ('')");
				}
				
			}else{
				querySql.append(" and t.project_info_no is not null");
			}
			
		}else{
			if(project_info_no != null&& project_info_no != ""){
				querySql.append(" and t.project_info_no='"+project_info_no+"'");
			}
		}
		
		querySql.append(" order by t.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 获取应急管理信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRiskEmergencyInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getRiskEmergencyInfo  !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String risk_emergency_id = isrvmsg.getValue("emergencyId")!=null?isrvmsg.getValue("emergencyId"):"";	
        
		Map riskInfoMap = new HashMap();
		
        StringBuffer query_emergency_sql= new StringBuffer("select t.emergency_id,t.emergency_status,t.emergency_problem,t.emergency_measure,t.res_person,t.res_org,t.risk_id,t.create_date,t.project_info_no,t.creator_id,t.emergency_process,t.emergency_reason,t.happen_date");
        query_emergency_sql.append(" from bgp_risk_emergency t where t.bsflag = '0' and t.emergency_id = '"+risk_emergency_id+"'");
        
        Map map=jdbcDao.queryRecordBySQL(query_emergency_sql.toString());
        if(map!=null){
        	String personIds = "";
        	String personNames = "";
        	String orgIds = "";
        	String orgNames = "";
        	String riskNames = "";
        	
        	String res_person_ids = map.get("resPerson").toString();
        	String res_org_ids = map.get("resOrg").toString();
        	String risk_ids  = map.get("riskId").toString();
        	if(res_person_ids!=""&&res_person_ids!=null){
        		String[] person_ids = res_person_ids.split(",");
        		for(String person_id : person_ids){
        			System.out.println("person id is:"+person_id);
        			String person_name = radDao.queryRecordBySQL("select e.employee_name from comm_human_employee e where e.employee_id = '"+person_id+"'").get("employee_name").toString();
        			personNames = personNames +","+person_name;
        		}
        	}
        	if(res_org_ids!=""&&res_org_ids!=null){
        		String[] org_ids = res_org_ids.split(",");
        		for(String org_id : org_ids){
        			System.out.println("org id is:"+org_id);
        			String org_name = radDao.queryRecordBySQL("select o.org_abbreviation from comm_org_information o where o.org_id = '"+org_id+"'").get("org_abbreviation").toString();
        			orgNames = orgNames +","+org_name;
        		}    		
        	}
        	
        	if(risk_ids!=""&&risk_ids!=null){
        		String[] the_risk_ids = risk_ids.split(",");
        		for(String risk_id : the_risk_ids){
        			String risk_name = radDao.queryRecordBySQL("select b.risk_name from bgp_risk_identify i left outer join bgp_risk_evaluate_base b on i.evaluate_base_id = b.risk_id where i.risk_identify_id = '"+risk_id+"'").get("risk_name").toString();
        			riskNames = riskNames +","+risk_name;
        		}    		
        	}
        	if(personNames != ""){
        		System.out.println("the personids is:"+personNames.substring(1));
        	}else{
        		System.out.println("the personids is:"+personNames);
        	}
        	
        	
        	riskInfoMap.put("emergency_id",map.get("emergencyId").toString());
        	riskInfoMap.put("emergency_status",map.get("emergencyStatus").toString());
        	riskInfoMap.put("emergency_problem",map.get("emergencyProblem").toString());
        	riskInfoMap.put("emergency_measure",map.get("emergencyMeasure").toString());
        	riskInfoMap.put("emergency_reason",map.get("emergencyReason").toString());
        	riskInfoMap.put("emergency_process",map.get("emergencyProcess").toString());
        	riskInfoMap.put("res_person_ids",res_person_ids);
        	if(personNames != ""){
        		riskInfoMap.put("res_person_names",personNames.substring(1));
        	}else{
        		riskInfoMap.put("res_person_names",personNames);
        	}
        	
        	riskInfoMap.put("res_org_ids",res_org_ids);
        	if(orgNames != ""){
        		riskInfoMap.put("res_org_names",orgNames.substring(1));
        	}else{
        		riskInfoMap.put("res_org_names",orgNames);
        	}
        	
        	riskInfoMap.put("risk_ids",risk_ids);
        	if(riskNames != ""){
        		riskInfoMap.put("risk_names",riskNames.substring(1));
        	}else{
        		riskInfoMap.put("risk_names",riskNames);
        	}
        	
        	riskInfoMap.put("create_date",map.get("createDate").toString());       	
        	riskInfoMap.put("creator_id",map.get("creatorId").toString());
        	riskInfoMap.put("happen_date",map.get("happenDate").toString());
        	
        }
		responseDTO.setValue("riskInfoMap", riskInfoMap); 
		return responseDTO;

	}
	
	/**
	 * 新增风险应急
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addRiskEmergency(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addRiskEmergency !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map addRiskMap = new HashMap();
		Map addResInfo = new HashMap();
		//增加的是数据
			
		String risk_id = isrvmsg.getValue("risk_id")!=null?isrvmsg.getValue("risk_id"):"";		
		String emergency_problem = isrvmsg.getValue("emergency_problem")!=null?isrvmsg.getValue("emergency_problem"):"";	
		String emergency_status = isrvmsg.getValue("emergency_status")!=null?isrvmsg.getValue("emergency_status"):"";
		String res_person_id = isrvmsg.getValue("res_person_id")!=null?isrvmsg.getValue("res_person_id"):"";	
		String res_org_id = isrvmsg.getValue("res_org_id")!=null?isrvmsg.getValue("res_org_id"):"";
		String happen_date = isrvmsg.getValue("create_date")!=null?isrvmsg.getValue("create_date"):"";
		String emergency_reason = isrvmsg.getValue("emergency_reason")!=null?isrvmsg.getValue("emergency_reason"):"";	
		String emergency_process = isrvmsg.getValue("res_org_id")!=null?isrvmsg.getValue("emergency_process"):"";
		
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		addRiskMap.put("risk_id", risk_id);
		addRiskMap.put("emergency_status", emergency_status);
		addRiskMap.put("emergency_problem", emergency_problem);
		addRiskMap.put("emergency_reason", emergency_reason);
		addRiskMap.put("emergency_process", emergency_process);
		addRiskMap.put("res_person", res_person_id);
		addRiskMap.put("res_org", res_org_id);
		addRiskMap.put("bsflag", "0");
		if(is_multi == ""||is_multi == null){
			addRiskMap.put("project_info_no", user.getProjectInfoNo());
		}
		addRiskMap.put("create_date", new Date());			
		addRiskMap.put("creator_id", user.getUserId());
		addRiskMap.put("modifi_date", new Date());
		addRiskMap.put("updator_id", user.getUserId());
		addRiskMap.put("org_id", user.getCodeAffordOrgID());
		addRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		if(happen_date != null){
			addRiskMap.put("happen_date", happen_date);
		}
		
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(addRiskMap, "bgp_risk_emergency");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	/**
	 * 编辑风险目标
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg editRiskEmergency(ISrvMsg isrvmsg) throws Exception {
		System.out.println("editRiskEmergency !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map editRiskMap = new HashMap();
		String risk_emergency_id = isrvmsg.getValue("risk_emergency_id")!=null?isrvmsg.getValue("risk_emergency_id"):"";
		String emergency_problem = isrvmsg.getValue("emergency_problem")!=null?isrvmsg.getValue("emergency_problem"):"";	
		String emergency_status = isrvmsg.getValue("emergency_status")!=null?isrvmsg.getValue("emergency_status"):"";
		String res_person_id = isrvmsg.getValue("res_person_id")!=null?isrvmsg.getValue("res_person_id"):"";	
		String res_org_id = isrvmsg.getValue("res_org_id")!=null?isrvmsg.getValue("res_org_id"):"";
		String risk_id = isrvmsg.getValue("risk_id")!=null?isrvmsg.getValue("risk_id"):"";		
		String emergency_reason = isrvmsg.getValue("emergency_reason")!=null?isrvmsg.getValue("emergency_reason"):"";	
		String emergency_process = isrvmsg.getValue("res_org_id")!=null?isrvmsg.getValue("emergency_process"):"";
		
		String happen_date = isrvmsg.getValue("create_date")!=null?isrvmsg.getValue("create_date"):"";
		
		//修改的是数据
		editRiskMap.put("emergency_id", risk_emergency_id);
		editRiskMap.put("risk_id", risk_id);
		editRiskMap.put("emergency_status", emergency_status);
		editRiskMap.put("emergency_problem", emergency_problem);
		editRiskMap.put("emergency_reason", emergency_reason);
		editRiskMap.put("emergency_process", emergency_process);
		editRiskMap.put("res_person", res_person_id);
		editRiskMap.put("res_org", res_org_id);		
		editRiskMap.put("modifi_date", new Date());
		editRiskMap.put("updator_id", user.getUserId());
		editRiskMap.put("org_id", user.getCodeAffordOrgID());
		editRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());		
		if(happen_date != null){
			editRiskMap.put("happen_date", happen_date);
		}
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(editRiskMap, "bgp_risk_emergency");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 删除应急管理
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRiskEmergency(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteRiskEmergency !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_deal_id = isrvmsg.getValue("emergencyId");
		String[] params = risk_deal_id.split(",");	
		String updateSql = "";
		if(risk_deal_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_emergency g set g.bsflag='1' where g.emergency_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		radDao.executeUpdate(updateSql);
		return responseDTO;
	}
	
	/**
	 * 增加应急措施
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addEmergencyMeasure(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addEmergencyMeasure !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map editRiskMap = new HashMap();
		String emergency_id = isrvmsg.getValue("emergencyId")!=null?isrvmsg.getValue("emergencyId"):"";
		String emergency_measure = isrvmsg.getValue("emergencyMeasureValue")!=null?isrvmsg.getValue("emergencyMeasureValue"):"";	
		
		editRiskMap.put("EMERGENCY_ID", emergency_id);
		editRiskMap.put("EMERGENCY_MEASURE", emergency_measure);
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(editRiskMap, "bgp_risk_emergency");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("emergencyMeasure", emergency_measure);
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	
	/**
	 * 获取所有的风险库
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskBase(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllRiskBase !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		StringBuffer querySql = new StringBuffer("select t.risk_db_id,t.risk_db_name,t.risk_db_definition,t.risk_db_behave,t.risk_db_reason,t.risk_type,t.create_date,t.involved_org,o.org_abbreviation,t1.risk_type_name from bgp_risk_database t left outer join comm_org_information o on t.involved_org = o.org_id left outer join bgp_risk_type t1 on t.risk_type = t1.risk_type_id where t.bsflag = '0'");
		querySql.append(" order by t.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	/**
	 * 新增风险库
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg addRiskBase(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addRiskBase !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map addRiskMap = new HashMap();
		//增加的是数据
		String risk_db_name = isrvmsg.getValue("risk_db_name")!=null?isrvmsg.getValue("risk_db_name"):"";		
		String risk_type_id = isrvmsg.getValue("risk_type_id")!=null?isrvmsg.getValue("risk_type_id"):"";	
		String org_id = isrvmsg.getValue("org_id")!=null?isrvmsg.getValue("org_id"):"";
		String risk_db_definition = isrvmsg.getValue("risk_db_definition") != null?isrvmsg.getValue("risk_db_definition"):"";
		String risk_db_behave = isrvmsg.getValue("risk_db_behave") != null?isrvmsg.getValue("risk_db_behave"):"";
		String risk_db_reason = isrvmsg.getValue("risk_db_reason") != null?isrvmsg.getValue("risk_db_reason"):"";
		
		addRiskMap.put("risk_db_name", risk_db_name);
		addRiskMap.put("risk_type", risk_type_id);
		addRiskMap.put("involved_org", org_id);
		addRiskMap.put("risk_db_definition", risk_db_definition);
		addRiskMap.put("risk_db_behave", risk_db_behave);
		addRiskMap.put("risk_db_reason", risk_db_reason);
			
		addRiskMap.put("bsflag", "0");
		addRiskMap.put("create_date", new Date());			
		addRiskMap.put("creator_id", user.getUserId());
		addRiskMap.put("modifi_date", new Date());
		addRiskMap.put("updator_id", user.getUserId());
		addRiskMap.put("org_id", user.getCodeAffordOrgID());
		addRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(addRiskMap, "bgp_risk_database");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 编辑风险库
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg editRiskBase(ISrvMsg isrvmsg) throws Exception {
		System.out.println("editRiskBase !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map editRiskMap = new HashMap();
		
		String risk_base_id = isrvmsg.getValue("risk_base_id")!=null?isrvmsg.getValue("risk_base_id"):"";	
		String risk_db_name = isrvmsg.getValue("risk_db_name")!=null?isrvmsg.getValue("risk_db_name"):"";		
		String risk_type_id = isrvmsg.getValue("risk_type_id")!=null?isrvmsg.getValue("risk_type_id"):"";	
		String org_id = isrvmsg.getValue("org_id")!=null?isrvmsg.getValue("org_id"):"";
		String risk_db_definition = isrvmsg.getValue("risk_db_definition") != null?isrvmsg.getValue("risk_db_definition"):"";
		String risk_db_behave = isrvmsg.getValue("risk_db_behave") != null?isrvmsg.getValue("risk_db_behave"):"";
		String risk_db_reason = isrvmsg.getValue("risk_db_reason") != null?isrvmsg.getValue("risk_db_reason"):"";
		
		editRiskMap.put("risk_db_id", risk_base_id);
		editRiskMap.put("risk_db_name", risk_db_name);
		editRiskMap.put("risk_type", risk_type_id);
		editRiskMap.put("involved_org", org_id);
		editRiskMap.put("risk_db_definition", risk_db_definition);
		editRiskMap.put("risk_db_behave", risk_db_behave);
		editRiskMap.put("risk_db_reason", risk_db_reason);
		editRiskMap.put("modifi_date", new Date());
		editRiskMap.put("updator_id", user.getUserId());
		editRiskMap.put("org_id", user.getCodeAffordOrgID());
		editRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());		
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(editRiskMap, "bgp_risk_database");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 获取某条风险库的详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRiskBaseInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getRiskBaseInfo !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String risk_base_id = isrvmsg.getValue("riskBaseId")!=null?isrvmsg.getValue("riskBaseId"):"";
		String orgNames = "";
        
		Map riskInfoMap = new HashMap();
		
        //获取文档表主键
		StringBuffer querySql = new StringBuffer("select t.risk_db_id,t.risk_db_name,t.risk_db_definition,t.risk_db_behave,t.risk_db_reason,t.risk_type,t.create_date,t.involved_org,o.org_abbreviation,t1.risk_type_name from bgp_risk_database t left outer join comm_org_information o on t.involved_org = o.org_id left outer join bgp_risk_type t1 on t.risk_type = t1.risk_type_id where t.bsflag = '0'");
		querySql.append(" and t.risk_db_id = '"+risk_base_id+"'");
        Map map=jdbcDao.queryRecordBySQL(querySql.toString());
        if(map!=null){
        	riskInfoMap.put("risk_db_name",map.get("riskDbName").toString());
        	riskInfoMap.put("risk_type_id",map.get("riskType").toString());
        	riskInfoMap.put("risk_type_name",map.get("riskTypeName").toString());
        	riskInfoMap.put("org_id",map.get("involvedOrg").toString());
        	String[] org_ids = map.get("involvedOrg").toString().split(",");
        	for(String orgId:org_ids){
    			String org_name = radDao.queryRecordBySQL("select o.org_abbreviation from comm_org_information o where o.org_id = '"+orgId+"'").get("org_abbreviation").toString();
    			orgNames = orgNames +","+org_name;
        	}
        	if(orgNames != ""){
        		riskInfoMap.put("org_names",orgNames.substring(1));
        	}else{
        		riskInfoMap.put("org_names",orgNames);
        	}
        	System.out.println("org names is:"+orgNames);
        	riskInfoMap.put("org_name",map.get("orgAbbreviation").toString());
        	riskInfoMap.put("risk_db_definition",map.get("riskDbDefinition").toString());
        	riskInfoMap.put("risk_db_behave",map.get("riskDbBehave").toString());
        	riskInfoMap.put("risk_db_reason",map.get("riskDbReason").toString());
        }
		responseDTO.setValue("riskInfoMap", riskInfoMap); 
		return responseDTO;

	}
	
	/**
	 * 删除风险库
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRiskBase(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteRiskBase !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_identify_id = isrvmsg.getValue("riskBaseIds");		
		String[] params = risk_identify_id.split(",");	
		String updateSql = "";
		if(risk_identify_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_database g set g.bsflag='1' where g.risk_db_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
		}
		return responseDTO;

	}
	
	/**
	 * 获取所有的风险检查
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskCheck(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllRiskCheck");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String relation_id = isrvmsg.getValue("relationId") != null?isrvmsg.getValue("relationId"):"";

		StringBuffer querySql = new StringBuffer("select t.risk_check_id,t.check_user_id,t.check_org_id,t.check_result,t.relation_id,t.check_date,e.employee_name,o.org_abbreviation from bgp_risk_check t left outer join comm_human_employee e on t.check_user_id = e.employee_id left outer join comm_org_information o on t.check_org_id = o.org_id where t.bsflag = '0'");
		if(relation_id != null&& relation_id != ""){
			querySql.append(" and t.relation_id ='"+relation_id+"'");
		}
		querySql.append(" order by t.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 删除风险检查
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRiskCheck(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteRiskCheck !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_deal_id = isrvmsg.getValue("riskCheckId");
		String[] params = risk_deal_id.split(",");	
		String updateSql = "";
		if(risk_deal_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_check g set g.bsflag='1' where g.risk_check_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		radDao.executeUpdate(updateSql);
		return responseDTO;
	}
	
	/**
	 * 获取所有的风险整改
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskImprove(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllRiskImprove");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String relation_id = isrvmsg.getValue("relationId") != null?isrvmsg.getValue("relationId"):"";

		StringBuffer querySql = new StringBuffer("select t.risk_improve_id,t.improve_user_id,t.improve_org_id,t.improve_result,t.improve_measure,t.improve_date,e.employee_name,o.org_abbreviation from bgp_risk_improve t left outer join comm_human_employee e on t.improve_user_id = e.employee_id left outer join comm_org_information o on t.improve_org_id = o.org_id where t.bsflag = '0'");
		if(relation_id != null&& relation_id != ""){
			querySql.append(" and t.relation_id ='"+relation_id+"'");
		}
		querySql.append(" order by t.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 删除风险整改
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRiskImprove(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteRiskImprove !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_deal_id = isrvmsg.getValue("riskImproveId");
		String[] params = risk_deal_id.split(",");	
		String updateSql = "";
		if(risk_deal_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_improve g set g.bsflag='1' where g.risk_improve_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		radDao.executeUpdate(updateSql);
		return responseDTO;
	}
	
	/**
	 * 获取属于某一风险库的所有风险
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskOfBase(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllRiskOfBase");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String project_info_no = user.getProjectInfoNo() != null?user.getProjectInfoNo():"";
		String risk_confirm = isrvmsg.getValue("riskConfirm") != null?isrvmsg.getValue("riskConfirm"):"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		String is_flow = isrvmsg.getValue("isflow") != null?isrvmsg.getValue("isflow"):"";
		String relation_id = isrvmsg.getValue("relationId") != null?isrvmsg.getValue("relationId"):"";
		StringBuffer querySql = new StringBuffer("select t.risk_type_name,i.risk_identify_id,i.risk_number,i.risk_bear_level,i.evaluate_base_id,i.project_info_no,i.risk_measure,i.create_date,b.risk_db_id,b.risk_db_name,b.risk_db_definition,b.risk_type,u.user_name,i.risk_confirm,(case i.risk_confirm when '0' then '否' when '1' then '是' else '' end) as is_risk from bgp_risk_identify i left outer join bgp_risk_database b on i.evaluate_base_id = b.risk_db_id left outer join p_auth_user u on i.creator_id=u.user_id left outer join bgp_risk_type t on b.risk_type = t.risk_type_id where i.bsflag = '0'");
		if(is_multi != "" && is_multi != null){
			querySql.append(" and i.project_info_no is null");
		}else{
			if(project_info_no != null&& project_info_no != ""){
				querySql.append(" and i.project_info_no='"+project_info_no+"'");
			}
		}
		if(risk_confirm != null&& risk_confirm != ""){
			querySql.append(" and i.risk_confirm='"+risk_confirm+"'");
		}
		if(is_flow != ""&& is_flow != null){
			if(is_flow.equals("1")){
				querySql.append(" and i.is_flow_risk='1'");
			}else if(is_flow.equals("0")){
				querySql.append(" and i.is_flow_risk='0'");
			}
		}
		if(relation_id != ""&&relation_id != null){
			querySql.append(" and i.evaluate_base_id='"+relation_id+"'");
		}
		querySql.append(" order by i.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	
	
	
	/**
	 * 获取风险事件对应到所有风险
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllEventRisks(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllEventRisks");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String relation_id = isrvmsg.getValue("relationId") != null?isrvmsg.getValue("relationId"):"";
		
		StringBuffer querySql = new StringBuffer("select r.event_risk_id,i.risk_identify_id,i.risk_identify_name,i.evaluate_base_id,t.risk_type_name,i.risk_level,i.risk_desc from bgp_risk_identify i left outer join bgp_risk_event_relation r on i.risk_identify_id = r.risk_id left outer join bgp_risk_type t on i.risk_type_id = t.risk_type_id where i.bsflag = '0'");
		if(relation_id != null&& relation_id != ""){
			querySql.append(" and r.event_id ='"+relation_id+"'");
		}
		querySql.append(" order by i.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 给风险事件增加风险
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addEventRisks(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addEventRisks !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map addRiskMap = new HashMap();
		//增加的是数据
		String risk_ids = isrvmsg.getValue("riskIds")!=null?isrvmsg.getValue("riskIds"):"";		
		String event_id = isrvmsg.getValue("eventId")!=null?isrvmsg.getValue("eventId"):"";	
		if(risk_ids != ""&&risk_ids != null){
			String[] params = risk_ids.split(","); 
			for(String risk_id : params){
				if(event_id != ""&& event_id != null){
					addRiskMap.put("event_id", event_id);
				}
				addRiskMap.put("risk_id", risk_id);
				addRiskMap.put("bsflag", "0");
				addRiskMap.put("create_date", new Date());			
				addRiskMap.put("creator_id", user.getUserId());
				addRiskMap.put("modifi_date", new Date());
				addRiskMap.put("updator_id", user.getUserId());
				addRiskMap.put("org_id", user.getCodeAffordOrgID());
				addRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				radDao.saveOrUpdateEntity(addRiskMap, "bgp_risk_event_relation");
			}
		}
		return responseDTO;
	}
	
	/**
	 * 列出某一风险事件可以选择的风险
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskIdentifyOfEvent(ISrvMsg isrvmsg) throws Exception {
		
		System.out.println("getAllRiskIdentifyOfEvent");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String project_info_no = user.getProjectInfoNo() != null?user.getProjectInfoNo():"";
		String risk_confirm = isrvmsg.getValue("riskConfirm") != null?isrvmsg.getValue("riskConfirm"):"";
		String is_multi = isrvmsg.getValue("isMulti") != null?isrvmsg.getValue("isMulti"):"";
		String is_flow = isrvmsg.getValue("isflow") != null?isrvmsg.getValue("isflow"):"";
		
		String selected_risk_ids = "";
		String relation_id = isrvmsg.getValue("relationId") != null?isrvmsg.getValue("relationId"):"";
		String selected_risks_sql = "select r.risk_id from bgp_risk_event_relation r where r.event_id = '"+relation_id+"'";
		List<Map> risk_maps = radDao.queryRecords(selected_risks_sql);
		for(Map risk_map : risk_maps){
			String risk_id = risk_map.get("risk_id").toString();
			selected_risk_ids = selected_risk_ids +",'"+risk_id+"'";
		}
		
		System.out.println("the selected risk ids is:"+selected_risk_ids);
		
		StringBuffer querySql = new StringBuffer("select t.risk_type_name,i.risk_identify_id,i.risk_number,i.risk_bear_level,i.risk_level,i.evaluate_base_id,i.project_info_no,i.risk_measure,i.create_date,b.risk_db_id,i.risk_identify_name,i.risk_desc,b.risk_type,u.user_name,i.risk_confirm,(case i.risk_confirm when '0' then '否' when '1' then '是' else '' end) as is_risk from bgp_risk_identify i left outer join bgp_risk_database b on i.evaluate_base_id = b.risk_db_id left outer join p_auth_user u on i.creator_id=u.user_id left outer join bgp_risk_type t on t.risk_type_id = i.risk_type_id where i.bsflag = '0'");
		if(is_multi != "" && is_multi != null){
			querySql.append(" and i.project_info_no is null");
		}else{
			if(project_info_no != null&& project_info_no != ""){
				querySql.append(" and i.project_info_no='"+project_info_no+"'");
			}
		}
		if(risk_confirm != null&& risk_confirm != ""){
			querySql.append(" and i.risk_confirm='"+risk_confirm+"'");
		}
		if(is_flow != ""&& is_flow != null){
			if(is_flow.equals("1")){
				querySql.append(" and i.is_flow_risk='1'");
			}else if(is_flow.equals("0")){
				querySql.append(" and i.is_flow_risk='0'");
			}
		}else{
			querySql.append(" and i.is_flow_risk='0'");
		}
		if(selected_risk_ids != ""&&selected_risk_ids != null){
			querySql.append(" and i.risk_identify_id not in ("+selected_risk_ids.substring(1)+")");
		}
		querySql.append(" order by i.create_date desc");

		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	
	/**
	 * 删除风险事件中的风险
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteEventRisk(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteEventRisk !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_deal_id = isrvmsg.getValue("eventRiskId");
		String[] params = risk_deal_id.split(",");	
		String updateSql = "";
		if(risk_deal_id != null){
			for(String id : params){
				updateSql = "delete from bgp_risk_event_relation g where g.event_risk_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		radDao.executeUpdate(updateSql);
		return responseDTO;
	}
	
	
	
	/**
	 * 获取所有的风险控制
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllRiskSupervise(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getAllRiskSupervise !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		StringBuffer querySql = new StringBuffer("select t.supervise_id,t.risk_type,p.risk_type_name,t.second_risk_type,t.risk_norm,t.provide_data_norm,t.res_org_id,t.res_org_name,t.res_person_id,t.res_person_name,t.data_way,t.remark,t.create_date,t.report_rate,(case t.report_rate when '1' then '月度' when '2' then '季度' when '3' then '年度' else '' end) as the_report_rate,t.use_area,(case t.use_area when '1' then '管理' when '2' then '项目' when '3' then '管理/项目' else '' end) as the_use_area");
		querySql.append(" from bgp_risk_supervise t left outer join bgp_risk_type p on t.risk_type = p.risk_type_id where t.bsflag = '0'");
		querySql.append(" order by t.create_date desc");
		page = radDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	/**
	 * 新增风险控制
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg addRiskSupervise(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addRiskSupervise !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map addRiskMap = new HashMap();
		//增加的是数据
				
		String risk_type_id = isrvmsg.getValue("risk_type_id")!=null?isrvmsg.getValue("risk_type_id"):"";	
		String risk_type_name = isrvmsg.getValue("risk_type_name")!=null?isrvmsg.getValue("risk_type_name"):"";
		
		String second_risk_type = isrvmsg.getValue("second_risk_type")!=null?isrvmsg.getValue("second_risk_type"):"";
		String risk_norm = isrvmsg.getValue("risk_norm")!=null?isrvmsg.getValue("risk_norm"):"";
		String provide_data_norm = isrvmsg.getValue("provide_data_norm")!=null?isrvmsg.getValue("provide_data_norm"):"";
		String use_area = isrvmsg.getValue("use_area")!=null?isrvmsg.getValue("use_area"):"";
		String res_org_name = isrvmsg.getValue("res_org_name")!=null?isrvmsg.getValue("res_org_name"):"";
		String res_org_id = isrvmsg.getValue("res_org_id")!=null?isrvmsg.getValue("res_org_id"):"";
		String res_person_name = isrvmsg.getValue("res_person_name")!=null?isrvmsg.getValue("res_person_name"):"";
		String res_person_id = isrvmsg.getValue("res_person_id")!=null?isrvmsg.getValue("res_person_id"):"";
		
		String report_rate = isrvmsg.getValue("report_rate") != null?isrvmsg.getValue("report_rate"):"";
		String data_way = isrvmsg.getValue("data_way") != null?isrvmsg.getValue("data_way"):"";
		String remark = isrvmsg.getValue("remark") != null?isrvmsg.getValue("remark"):"";
		
		addRiskMap.put("risk_type", risk_type_id);
		addRiskMap.put("second_risk_type", second_risk_type);
		addRiskMap.put("risk_norm", risk_norm);
		addRiskMap.put("provide_data_norm", provide_data_norm);
		addRiskMap.put("use_area", use_area);
		addRiskMap.put("res_org_name", res_org_name);
		addRiskMap.put("res_org_id", res_org_id);
		addRiskMap.put("res_person_name", res_person_name);
		addRiskMap.put("res_person_id", res_person_id);
		addRiskMap.put("report_rate", report_rate);
		addRiskMap.put("data_way", data_way);
		addRiskMap.put("remark", remark);
			
		addRiskMap.put("bsflag", "0");
		addRiskMap.put("create_date", new Date());			
		addRiskMap.put("creator_id", user.getUserId());
		addRiskMap.put("modifi_date", new Date());
		addRiskMap.put("updator_id", user.getUserId());
		addRiskMap.put("org_id", user.getCodeAffordOrgID());
		addRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(addRiskMap, "bgp_risk_supervise");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 编辑风险控制
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg editRiskSupervise(ISrvMsg isrvmsg) throws Exception {
		System.out.println("editRiskSupervise !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		Map editRiskMap = new HashMap();
		
		String risk_supervise_id = isrvmsg.getValue("risk_supervise_id")!=null?isrvmsg.getValue("risk_supervise_id"):"";
		String risk_type_id = isrvmsg.getValue("risk_type_id")!=null?isrvmsg.getValue("risk_type_id"):"";	
		String risk_type_name = isrvmsg.getValue("risk_type_name")!=null?isrvmsg.getValue("risk_type_name"):"";
		
		String second_risk_type = isrvmsg.getValue("second_risk_type")!=null?isrvmsg.getValue("second_risk_type"):"";
		String risk_norm = isrvmsg.getValue("risk_norm")!=null?isrvmsg.getValue("risk_norm"):"";
		String provide_data_norm = isrvmsg.getValue("provide_data_norm")!=null?isrvmsg.getValue("provide_data_norm"):"";
		String use_area = isrvmsg.getValue("use_area")!=null?isrvmsg.getValue("use_area"):"";
		String res_org_name = isrvmsg.getValue("res_org_name")!=null?isrvmsg.getValue("res_org_name"):"";
		String res_org_id = isrvmsg.getValue("res_org_id")!=null?isrvmsg.getValue("res_org_id"):"";
		String res_person_name = isrvmsg.getValue("res_person_name")!=null?isrvmsg.getValue("res_person_name"):"";
		String res_person_id = isrvmsg.getValue("res_person_id")!=null?isrvmsg.getValue("res_person_id"):"";
		
		String report_rate = isrvmsg.getValue("report_rate") != null?isrvmsg.getValue("report_rate"):"";
		String data_way = isrvmsg.getValue("data_way") != null?isrvmsg.getValue("data_way"):"";
		String remark = isrvmsg.getValue("remark") != null?isrvmsg.getValue("remark"):"";
		
		editRiskMap.put("supervise_id", risk_supervise_id);
		editRiskMap.put("risk_type", risk_type_id);
		editRiskMap.put("second_risk_type", second_risk_type);
		editRiskMap.put("risk_norm", risk_norm);
		editRiskMap.put("provide_data_norm", provide_data_norm);
		editRiskMap.put("use_area", use_area);
		editRiskMap.put("res_org_name", res_org_name);
		editRiskMap.put("res_org_id", res_org_id);
		editRiskMap.put("res_person_name", res_person_name);
		editRiskMap.put("res_person_id", res_person_id);
		editRiskMap.put("report_rate", report_rate);
		editRiskMap.put("data_way", data_way);
		editRiskMap.put("remark", remark);
		
		editRiskMap.put("modifi_date", new Date());
		editRiskMap.put("updator_id", user.getUserId());
		editRiskMap.put("org_id", user.getCodeAffordOrgID());
		editRiskMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());		
		String operationFlag = "success";
		try {
			radDao.saveOrUpdateEntity(editRiskMap, "bgp_risk_supervise");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 获取某条风险控制的详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRiskSuperviseInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getRiskSuperviseInfo !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String risk_supervise_id = isrvmsg.getValue("riskSuperviseId")!=null?isrvmsg.getValue("riskSuperviseId"):"";
		
		Map riskInfoMap = new HashMap();
		
        //获取文档表主键
		StringBuffer querySql = new StringBuffer("select t.supervise_id,t.risk_type,p.risk_type_name,t.second_risk_type,t.risk_norm,t.provide_data_norm,t.res_org_id,t.res_org_name,t.res_person_id,t.res_person_name,t.data_way,t.remark,t.create_date,t.report_rate,(case t.report_rate when '1' then '月度' when '2' then '季度' when '3' then '年度' else '' end) as the_report_rate,t.use_area,(case t.use_area when '1' then '管理' when '2' then '项目' when '3' then '管理/项目' else '' end) as the_use_area");
		querySql.append(" from bgp_risk_supervise t left outer join bgp_risk_type p on t.risk_type = p.risk_type_id where t.bsflag = '0'");
		if(risk_supervise_id != ""&&risk_supervise_id != null){
			querySql.append(" and t.supervise_id = '"+risk_supervise_id+"'");
		}
		querySql.append(" order by t.create_date desc");
	
        Map map=jdbcDao.queryRecordBySQL(querySql.toString());
        if(map!=null){
        	riskInfoMap.put("supervise_id",map.get("superviseId").toString());
        	riskInfoMap.put("risk_type",map.get("riskType").toString());
        	riskInfoMap.put("risk_type_name",map.get("riskTypeName").toString());
        	
        	riskInfoMap.put("second_risk_type",map.get("secondRiskType").toString());
        	riskInfoMap.put("risk_norm",map.get("riskNorm").toString());
        	riskInfoMap.put("provide_data_norm",map.get("provideDataNorm").toString());
        	
        	riskInfoMap.put("res_org_id",map.get("resOrgId").toString());
        	riskInfoMap.put("res_org_name",map.get("resOrgName").toString());
        	riskInfoMap.put("res_person_id",map.get("resPersonId").toString());        	
        	riskInfoMap.put("res_person_name",map.get("resPersonName").toString());
        	
        	riskInfoMap.put("data_way",map.get("dataWay").toString());
        	riskInfoMap.put("use_area",map.get("useArea").toString());
        	riskInfoMap.put("remark",map.get("remark").toString());
        	riskInfoMap.put("create_date",map.get("createDate").toString());        	
        	riskInfoMap.put("report_rate",map.get("reportRate").toString());
        	
        	riskInfoMap.put("the_report_rate",map.get("theReportRate").toString());
        	riskInfoMap.put("the_use_area",map.get("theUseArea").toString());

        }
		responseDTO.setValue("riskInfoMap", riskInfoMap); 
		return responseDTO;

	}
	
	/**
	 * 删除风险控制
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRiskSupervise(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteRiskSupervise !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String risk_supervise_id = isrvmsg.getValue("riskSuperviseIds");		
		String[] params = risk_supervise_id.split(",");	
		String updateSql = "";
		if(risk_supervise_id != null){
			for(String id : params){
				updateSql = "update bgp_risk_supervise g set g.bsflag='1' where g.supervise_id='"+id+"'";
				radDao.executeUpdate(updateSql);
			}
		}
		return responseDTO;

	}
	
	
	
	//以下都是各个工具方法
	
	/**
	 * 获取排序编号
	 * @param parentObjectId
	 * @return
	 */
	private int getOrderNum(String parentObjectId){
		String sql = "select nvl(max(order_num)+1,1) as orderNum from bgp_p6_code where parent_object_id = '"+parentObjectId+"' ";
		
		Map map = jdbcDao.queryRecordBySQL(sql);
		
		String orderNum = (String) map.get("ordernum");
		
		int order = Integer.parseInt(orderNum);
		
		return order;
	}
	
	
	/*
	 * 保存费用模板拖拽顺序数据
	 */
	public ISrvMsg saveRiskOrder(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		setOrderOfTreeDragDrop("bgp_risk_evaluate_base", "risk_id", reqDTO);
		return responseDTO;
	}

	
	/*
	 * 多列树多拽时设置树node的order
	 */
	public  void setOrderOfTreeDragDrop(String tableName,String tableKeyName, ISrvMsg reqDTO) throws Exception {
		
		String sourceNodeZip = reqDTO.getValue("sourceNodeZip");
		String sourceNodeId = reqDTO.getValue("sourceNodeId");
		String targetNodeZip = reqDTO.getValue("targetNodeZip");
		String targetNodeId = reqDTO.getValue("targetNodeId");
		
		String targetNodeIndex = reqDTO.getValue("targetNodeIndex");
		String beforeOrAfter = reqDTO.getValue("beforeOrAfter");
		int index = Integer.parseInt(targetNodeIndex);
		if ("after".equals(beforeOrAfter)) {
			index += 1;
		}
		
		if(!"root".equals(targetNodeZip)){
			String sqlUpdateOthers = "update " + tableName
			+ " set order_num=order_num+1 where parent_risk_id='"
			+ targetNodeZip + "' and order_num>=" + index;
			String sqlUpdateSource = "update " + tableName + " set parent_risk_id = '"
			+ targetNodeZip + "',order_num= " + index + " where "
			+ tableKeyName + "='" + sourceNodeId + "'";
			jdbcTemplate.execute(sqlUpdateOthers);
			jdbcTemplate.execute(sqlUpdateSource);
		}
		

	}
	
	/**
	 * 拖动改变顺序
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg moveTreeNodePosition(ISrvMsg isrvmsg) throws Exception {
		 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
 
		String pkValue = isrvmsg.getValue("pkValue");               
		int index = Integer.parseInt(isrvmsg.getValue("index"));    //拖动的顺序 
		String oldParentId = isrvmsg.getValue("oldParentId");
		
		//根据  org_hr_id查询   orderNum  
		StringBuffer subsqla = new StringBuffer("select t1.risk_type_id,t1.risk_type_name from bgp_risk_type t1 where t1.parent_id='");
		subsqla.append(oldParentId).append("' order by t1.order_num");
	 
		List orgs =BeanFactory.getQueryJdbcDAO().queryRecords(subsqla.toString());
		for(int i=0;i<orgs.size();i++){
			// 移动位置
			Map org = (Map)orgs.get(i);
			String risk_type_id = (String)org.get("riskTypeId");
			//将选中的节点从其父节点的列表中移除，并记录该节点的信息
			if(pkValue.equals(risk_type_id)){
				orgs.remove(i);
				orgs.add(index, org);
				break;
			}
		}
		// 写入新位置到数据库
		saveNewPosition(orgs);
		
		return respMsg;
	}
	/**
	 * 写入新位置到数据库
	 * @param orgs
	 */
	private void saveNewPosition(final List orgs){

		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update bgp_risk_type set order_num=? where risk_type_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = null;
				try {
					data = (Map)orgs.get(i);
				} catch (Exception e) {
					
				}
				ps.setString(1, String.valueOf(1000+i));
				System.out.println("order num is:"+String.valueOf(1000+i));

				ps.setString(2, (String)data.get("riskTypeId"));
				System.out.println("risk type id is:"+(String)data.get("riskTypeId"));
			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
}
