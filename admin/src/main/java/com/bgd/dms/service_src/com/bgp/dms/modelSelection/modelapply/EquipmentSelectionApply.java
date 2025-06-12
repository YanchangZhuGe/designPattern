
package com.bgp.dms.modelSelection.modelapply;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.cxf.binding.corba.wsdl.Array;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.check.CheckDevReady;
import com.bgp.dms.util.CommonConstants;
import com.bgp.dms.util.EquipmentStants;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;

public class EquipmentSelectionApply extends BaseService {

	public EquipmentSelectionApply() {
		log = LogFactory.getLogger(CheckDevReady.class);
	}
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	
	
	/**
	 * 供应商评价删除
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg delCompanyScore(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String score_id=isrvmsg.getValue("score_id");
		String deleteSql="delete from DMS_COMPANY_SCORE_DETAILED where score_id='"+score_id+"'";
		String deleteSql1="update  dms_selection_company_score set bsflag='1' where score_id='"+score_id+"'";
		jdbcDao.executeUpdate(deleteSql);
		jdbcDao.executeUpdate(deleteSql1);
		return responseDTO;
		}
	/**
	 * 供应商评价列表
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg getCompanyScoreInfoByScoreId(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String score_id=isrvmsg.getValue("score_id"); 
		String [] names={};
		String [] codings={};
		String [] companyids={};
		String applysql=" select s.*,i.org_name from dms_selection_company_score s, comm_org_information i where s.in_org_id=i.org_id and score_id = '"+score_id+"' ";
		Map apply=jdbcDao.queryRecordBySQL(applysql); 
		responseDTO.setValue("apply", apply);
		String sql="select wm_CONCAT(company_id) ids from(select * from (select distinct company_id from DMS_COMPANY_SCORE_DETAILED where score_id = '"+score_id+"' order by company_id desc) order by company_id) ";
		Map map=jdbcDao.queryRecordBySQL(sql); 
		responseDTO.setValue("ids", map.get("ids"));
		String namessql="select wm_concat(coding_name) names,wm_concat(coding_code_id) codings from(select coding_name,dd.coding_code_id from DMS_COMPANY_SCORE_DETAILED dd, comm_coding_sort_detail d where dd.coding_code_id = d.coding_code_id and score_id = '"+score_id+"' group by coding_name,dd.coding_code_id)";
		Map map_names=jdbcDao.queryRecordBySQL(namessql); 
		
		String company_name="select wm_concat(ENTERPRISE_NAME) names from(select * from (select ENTERPRISE_NAME,c.company_code from DMS_COMPANY_SCORE_DETAILED dd, dms_selection_company c where dd.company_id = c.company_code and score_id = '"+score_id+"' group by enterprise_name,company_code) order by company_code)  ";
		Map company_names=jdbcDao.queryRecordBySQL(company_name); 
		
		responseDTO.setValue("names", company_names.get("names"));
		names=map_names.get("names").toString().split(",");
		codings=map_names.get("codings").toString().split(",");
		companyids=map.get("ids").toString().split(",");
		String sql1=" select dd.*,d.coding_name from DMS_COMPANY_SCORE_DETAILED dd,comm_coding_sort_detail d where score_id='"+score_id+"' and d.coding_code_id=dd.coding_code_id";
		List<Map> list=jdbcDao.queryRecords(sql1);
		List<Map> newlist=new ArrayList<Map>();
		Map<String,Map> d_map=new HashMap();
		Map footer=new HashMap();//汇总分数
		footer.put("coding_name", "总分");
		for(String companyid:companyids){
			footer.put("aa"+companyid, 0);
		}
		for (int i=0;i<names.length;i++) {
			Map map2=new HashMap();
			map2.put("coding_name", names[i]);
			map2.put("coding_code_id", codings[i]);
			d_map.put(names[i], map2);
		
			 
		}
		for (Map d : list) {
			Map newmap= d_map.get(d.get("coding_name"));
			newmap.put("aa"+d.get("company_id"), d.get("score"));
			double temp=Double.parseDouble(footer.get("aa"+d.get("company_id")).toString());
			temp=temp+Double.parseDouble(d.get("score").toString());
			footer.put("aa"+d.get("company_id"), temp);
		}
		for (String name : names) {
			newlist.add(d_map.get(name));
		}
		List footers=new ArrayList();
		footers.add(footer);
		responseDTO.setValue("datas", newlist);
		responseDTO.setValue("footer", footers);
		return responseDTO;
		}
	/**
	 * 供应商评价列表
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg queryCompanyScore(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String orgSubId = isrvmsg.getValue("usesubid");
	 
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select s.*,i.org_name from dms_selection_company_score s left join comm_org_information i on i.org_id=in_org_id where s.bsflag='0'   ");
	 
		if(StringUtils.isNotBlank(orgSubId)){
			querySql.append(" and in_org_id like '"+orgSubId+"%' ");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder);
		}else{
			querySql.append(" order by  IN_ORG_ID,in_date desc");
		}
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
		}
	/**
	 * 新增/修改供应商打分
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg addCompanyScore(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
	 
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String score_id=isrvmsg.getValue("score_id");
		String in_date=isrvmsg.getValue("in_date");
		String orgid=isrvmsg.getValue("orgid");
		String jsonobj=isrvmsg.getValue("jsonobj");
	    String [] company_id=isrvmsg.getValue("company_id").split(",");
		JSONArray  jsonArray = JSONArray.fromObject(jsonobj);
		
		Map score=new HashMap();
		//更新
		if(StringUtils.isNotBlank(score_id)&&!"null".equals(score_id)){
			String scoresql="select * from dms_selection_company_score where score_id='"+score_id+"'";
			score=jdbcDao.queryRecordBySQL(scoresql);
			//保存之前删除数据
			String deleteSql="delete from DMS_COMPANY_SCORE_DETAILED where score_id='"+score_id+"'";
			String deleteSql1="update  dms_selection_company_score set bsflag='1' where score_id='"+score_id+"'";
			jdbcDao.executeUpdate(deleteSql);
			jdbcDao.executeUpdate(deleteSql1);
			score.put("modify_date", createdate);
			score.put("updatetor", user.getEmpId());
			score.remove("score_id");
		} else{//新增
			score.put("create_date", createdate);
			score.put("creater", user.getEmpId());
		}
		score.put("in_date", in_date);
		score.put("in_org_id", orgid);
		score.put("bsflag", "0");
		String id=jdbcDao.saveOrUpdateEntity(score, "dms_selection_company_score").toString();
		 
		List<String> sqllist=new ArrayList<String>(); 
		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject object=  (JSONObject) jsonArray.get(i) ;	
			 for (String aa : company_id) {
				if(StringUtils.isNotBlank(aa)){

					 String d_Sql=" insert into DMS_COMPANY_SCORE_DETAILED values('"+jdbcDao.generateUUID()+"','"+object.get("coding_code_id")+"','"+aa.trim()+"','"+object.get("aa"+aa.trim())+"','"+id.toString()+"')";
					sqllist.add(d_Sql); 
				}
			}
		}
		if(CollectionUtils.isNotEmpty(sqllist)){
			String str[]=new String[sqllist.size()];
			String strings[]=sqllist.toArray(str);
			//批处理操作保存打分明细
			jdbcTemplate.batchUpdate(strings);
		}
			 
		 
		return isrvmsg;

	}
	/**
	 * 新增/修改设备改造信息
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg addModelChange(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String change_id = isrvmsg.getValue("change_id");
		String project_name = isrvmsg.getValue("project_name");
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// 合同编号
		String cont_num = isrvmsg.getValue("cont_num").trim();
		// 申请单位
		String apply_unit=isrvmsg.getValue("apply_unit").trim();
		// 项目金额
		String cont_money = isrvmsg.getValue("cont_money").trim();
		// 完成时间
		String COMPLETE_DATE=isrvmsg.getValue("COMPLETE_DATE").trim();
		// 资金来源
		String MONEY_FROM = isrvmsg.getValue("MONEY_FROM").trim();
		// 实施单位
		String EXPLOITING_ENTITY = isrvmsg.getValue("EXPLOITING_ENTITY").trim();
		// 项目负责人
		String PROJECT_LEADER = isrvmsg.getValue("PROJECT_LEADER").trim();
		// 合同文本
		String cont_content = isrvmsg.getValue("cont_content").trim();
		//关联设备
		String dev_coding=isrvmsg.getValue("dev_coding").trim();
	  
		// 新增
		if (change_id.equals("null") || change_id.equals("") || change_id==null) {
		 
			strMap.put("project_name", project_name);
			strMap.put("cont_num", cont_num);
			strMap.put("apply_unit", apply_unit);
			strMap.put("cont_money", cont_money);
			strMap.put("COMPLETE_DATE", COMPLETE_DATE);
			strMap.put("MONEY_FROM", MONEY_FROM);
			strMap.put("cont_content", cont_content);
			strMap.put("EXPLOITING_ENTITY", EXPLOITING_ENTITY);
			strMap.put("apply_unit", apply_unit);
			strMap.put("PROJECT_LEADER", PROJECT_LEADER);
			strMap.put("dev_coding", dev_coding);
			strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			strMap.put("creator", user.getEmpId());
			strMap.put("create_date", createdate);
			change_id   =(String)jdbcDao.saveOrUpdateEntity(strMap, "dms_device_modelchange");
		}
		// 修改操作
		else {
			strMap.put("change_id", change_id);
			strMap.put("project_name", project_name);
			strMap.put("cont_num", cont_num);
			strMap.put("apply_unit", apply_unit);
			strMap.put("cont_money", cont_money);
			strMap.put("COMPLETE_DATE", COMPLETE_DATE);
			strMap.put("MONEY_FROM", MONEY_FROM);
			strMap.put("cont_content", cont_content);
			strMap.put("EXPLOITING_ENTITY", EXPLOITING_ENTITY);
			strMap.put("apply_unit", apply_unit);
			strMap.put("PROJECT_LEADER", PROJECT_LEADER);
			strMap.put("dev_coding", dev_coding);
			strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			strMap.put("updatetor", user.getEmpId());
			strMap.put("modify_date", createdate);
		 
			jdbcDao.saveOrUpdateEntity(strMap, "dms_device_modelchange");
		}

		// 附件上传
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		Map<String, Object> doc = new HashMap<String, Object>();
		MyUcm ucm = new MyUcm();
		String filename = "";
		String fileOrder = "";
		String ucmDocId = "";
		try {
			// 处理附件
			for (WSFile file : filesOther) {
				filename = file.getFilename();
				fileOrder = file.getKey().toString().split("__")[0];
				ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
				doc.put("ucm_id", ucmDocId);
				doc.put("is_file", "1");
				doc.put("relation_id", change_id);
				doc.put("file_type", fileOrder);
				doc.put("file_name", filename);
				doc.put("bsflag", EquipmentStants.BSFLAG_ZC);
				doc.put("creator_id", user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("UPLOAD_DATE", createdate);
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				// 附件表
				String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				// 日志表
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
						user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
			}

		} catch (Exception e) {
			System.out.println("插入附件异常");
		}

		return isrvmsg;

	}
	/**
	 * 新增/修改选型申请信息
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg addEquipmentSeleApp(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String select_model_id = isrvmsg.getValue("opi_id");
		String company_id = isrvmsg.getValue("company_id");
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// 获得产品名称型号
		String opi_name = isrvmsg.getValue("opi_name").trim();
		// 获得商标
		String brand = "";
		String last_year_yield = "";
		String main_user_object = "";
		if (isrvmsg.getValue("brand") != null) {
			brand = isrvmsg.getValue("brand").trim();
		} else {
			brand = isrvmsg.getValue("brand");
		}
		// 获得生产单位
		String production = isrvmsg.getValue("production").trim();
		// 获得上年产量
		if (isrvmsg.getValue("last_year_yield") != null) {
			last_year_yield = isrvmsg.getValue("last_year_yield").trim();
		} else {
			last_year_yield = isrvmsg.getValue("last_year_yield");
		}
		// 主要用户名称
		if (isrvmsg.getValue("main_user_object") != null) {
			main_user_object = isrvmsg.getValue("main_user_object").trim();
		} else {
			main_user_object = isrvmsg.getValue("main_user_object");
		}
		// 产品简介
		String product_info = isrvmsg.getValue("product_info").trim();
		// 申请状态
		String apply_state = isrvmsg.getValue("apply_state").trim();
		if (apply_state.equals("0")) {
			apply_state = EquipmentStants.BSFLAG_SCSQ;
		}
		if (apply_state.equals("1")) {
			apply_state = EquipmentStants.BSFLAG_ZQFC;
		}
		if (apply_state.equals("2")) {
			apply_state = EquipmentStants.BSFLAG_ZX;
		}
		// 申请单位
		String apply_unit = isrvmsg.getValue("apply_unit").trim();
		// 申请单位理由
		String apply_unit_reason = isrvmsg.getValue("apply_unit_reason").trim();
		// 负责人
		String principal = isrvmsg.getValue("principal").trim();
		// 批准时间
		String approve_date = isrvmsg.getValue("approve_date").trim();
		
		//评审表单
		// 专家组意见
		String panel_idea = isrvmsg.getValue("panel_idea").trim();
		// 专家组负责人
		String panel_principal = isrvmsg.getValue("panel_principal").trim();
		// 专家组评审日期
		String panel_review_date = isrvmsg.getValue("panel_review_date");
		// 设备物资处意见
		String equipment_idea = isrvmsg.getValue("equipment_idea").trim();
		// 设备物资处负责人
		String equipment_principal = isrvmsg.getValue("equipment_principal").trim();
		// 设备物资处评审日期
		String equipment_review_date = isrvmsg.getValue("equipment_review_date");
		// 设备物资处评审结果
		String review_result = isrvmsg.getValue("review_result");
			if (Integer.parseInt(review_result) == 0) {
					strMap.put("review_state", EquipmentStants.BSFLAG_TGZT);
					strMap.put("review_result", EquipmentStants.BSFLAG_TG);
				} else if (Integer.parseInt(review_result) == 1) {
					strMap.put("review_state", EquipmentStants.BSFLAG_WTGZT);
					strMap.put("review_result", EquipmentStants.BSFLAG_WTG);
			}
		
		// 新增
		String sqlEmp = "select case when max(p.no) is null then '0' else max(p.no) end as no from Dms_Selection_Opi p where p.bsflag='0' ";
		Map no = new HashMap();
		no = jdbcDao.queryRecordBySQL(sqlEmp);
		int nos = Integer.valueOf(no.get("no").toString()) + 1;
		if (select_model_id.equals("null") || select_model_id.equals("") || select_model_id==null) {
			strMap.put("no", nos);
			strMap.put("opi_name", opi_name);
			strMap.put("brand", brand);
			strMap.put("production", production);
			strMap.put("company_id", company_id);
			strMap.put("last_year_yield", last_year_yield);
			strMap.put("main_user_object", main_user_object);
			strMap.put("product_info", product_info);
			strMap.put("apply_state", apply_state);
			strMap.put("apply_unit", apply_unit);
			strMap.put("apply_unit_reason", apply_unit_reason);
			strMap.put("principal", principal);
			strMap.put("approve_date", approve_date);
			strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			strMap.put("apply_date", createdate);
			strMap.put("creator", user.getEmpId());
			strMap.put("create_date", createdate);
			strMap.put("review_state", EquipmentStants.BSFLAG_TGZT);
			
			strMap.put("panel_idea", panel_idea);
			strMap.put("panel_principal", panel_principal);
			strMap.put("panel_review_date", panel_review_date);
			strMap.put("equipment_idea", equipment_idea);
			strMap.put("equipment_principal", equipment_principal);
			strMap.put("equipment_review_date", equipment_review_date);
			Serializable ids =jdbcDao.saveOrUpdateEntity(strMap, "DMS_SELECTION_OPI");
			select_model_id = (String) ids;
		}
		// 修改操作
		else {
			strMap.put("opi_id", select_model_id);
			strMap.put("opi_name", opi_name);
			strMap.put("brand", brand);
			strMap.put("production", production);
			strMap.put("last_year_yield", last_year_yield);
			strMap.put("main_user_object", main_user_object);
			strMap.put("product_info", product_info);
			strMap.put("apply_state", apply_state);
			strMap.put("apply_unit", apply_unit);
			strMap.put("apply_unit_reason", apply_unit_reason);
			strMap.put("principal", principal);
			strMap.put("review_state", EquipmentStants.BSFLAG_TGZT);
			strMap.put("approve_date", approve_date);
			strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			strMap.put("updatetor", user.getEmpId());
			strMap.put("modify_date", createdate);
			strMap.put("panel_idea", panel_idea);
			strMap.put("panel_principal", panel_principal);
			strMap.put("panel_review_date", panel_review_date);
			strMap.put("equipment_idea", equipment_idea);
			strMap.put("equipment_principal", equipment_principal);
			strMap.put("equipment_review_date", equipment_review_date);
			jdbcDao.saveOrUpdateEntity(strMap, "DMS_SELECTION_OPI");
		}

		// 附件上传
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		Map<String, Object> doc = new HashMap<String, Object>();
		MyUcm ucm = new MyUcm();
		String filename = "";
		String fileOrder = "";
		String ucmDocId = "";
		try {
			// 处理附件
			for (WSFile file : filesOther) {
				filename = file.getFilename();
				fileOrder = file.getKey().toString().split("__")[0];
				ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
				doc.put("ucm_id", ucmDocId);
				doc.put("is_file", "1");
				doc.put("relation_id", select_model_id);
				doc.put("file_type", fileOrder);
				doc.put("file_name", filename);
				doc.put("bsflag", EquipmentStants.BSFLAG_ZC);
				doc.put("creator_id", user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("UPLOAD_DATE", createdate);
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				// 附件表
				String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				// 日志表
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
						user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
			}

		} catch (Exception e) {
			System.out.println("插入附件异常");
		}

		return isrvmsg;

	}

	/**
	 * 查询 是否可以修改
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getEquipmentUnit(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String select_model_id = isrvmsg.getValue("select_model_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append(" select d.opi_id,d.review_state from DMS_SELECTION_OPI d");
		// 选型申请  是否可以修改
		if (StringUtils.isNotBlank(select_model_id)) {
			queryScrapeInfoSql.append(" where d.opi_id  = '" + select_model_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if (deviceappMap != null) {
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 关联设备
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getDevInfoWithModelChange(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String change_id = isrvmsg.getValue("change_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("  select t.dev_coding from dms_device_modelchange t   where t.bsflag = '0'");
		// 选型申请  是否可以修改
		if (StringUtils.isNotBlank(change_id)) {
			queryScrapeInfoSql.append(" and t.change_id  = '" + change_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		
		if (deviceappMap != null) {
			String dev_coding=(String) deviceappMap.get("dev_coding");
			if(StringUtils.isNotBlank(dev_coding)){
				String sql="select acc.dev_coding,acc.dev_name,acc.dev_model,acc.asset_value,acc.net_value from gms_device_account acc where 1=1 and ( 1=2";
				String [] dev_codings=dev_coding.split(",");
				for (String string : dev_codings) {
					if(StringUtils.isNotBlank(string)){
						sql+= " or dev_coding='"+string+"'";
					}
				}
				sql+=" )";
				List<Map> deviceappMap1 = jdbcDao.queryRecords(sql);
				if (deviceappMap != null) {
					responseDTO.setValue("deviceappMap", deviceappMap1);
				}
			 
			}
		}
		return responseDTO;
	}

	/**
	 * 判断是否   可以提交评审信息
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg setReview(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String select_model_id = isrvmsg.getValue("select_model_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append(" select d.opi_id,d.review_state from DMS_SELECTION_OPI d");
		// 选型申请  是否可以修改
		if (StringUtils.isNotBlank(select_model_id)) {
			queryScrapeInfoSql.append(" where d.opi_id  = '" + select_model_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		responseDTO.setValue("deviceappMap", deviceappMap);
		return responseDTO;
	}
	/**
	 * 评审
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg setReviewPs(ISrvMsg isrvmsg) throws Exception {
		Map<String,Object> strMap = new HashMap<String,Object>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String select_model_id = isrvmsg.getValue("select_model_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		queryScrapeInfoSql.append(" select d.opi_id,d.review_state from DMS_SELECTION_OPI d");
		// 选型申请  是否可以修改
		if (StringUtils.isNotBlank(select_model_id)) {
			queryScrapeInfoSql.append(" where d.opi_id  = '" + select_model_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		deviceappMap.put("operationFlag", operationFlag);
		if(deviceappMap.get("review_state").equals("未提交")){
			strMap.put("opi_id", select_model_id);
			strMap.put("review_state", EquipmentStants.BSFLAG_NORMAL);
		}
		if (deviceappMap.get("review_state").equals("评审未通过")) {
			strMap.put("opi_id", select_model_id);
			strMap.put("review_state", EquipmentStants.BSFLAG_NORMAL);
		}
		try{
			jdbcDao.saveOrUpdateEntity(strMap, "DMS_SELECTION_OPI");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
			deviceappMap.put("operationFlag", operationFlag);
		}
		responseDTO.setValue("deviceappMap", deviceappMap);
		
		return responseDTO;
	}
	
	
	/**
	 * 选型申请 修改页面的数据
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getopiInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer queryopiInfoSql = new StringBuffer();
		String opi_id = isrvmsg.getValue("opi_id"); // 产品idID
		queryopiInfoSql.append("select t.* from dms_selection_opi t where t.bsflag='0'");
		// 申请单ID
		if (StringUtils.isNotBlank(opi_id)) {
			queryopiInfoSql.append(" and opi_id  = '" + opi_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryopiInfoSql.toString());
		if (deviceappMap != null) {
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		// 查询文件表
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ opi_id + "' and t.bsflag='0' and t.is_file='1' ";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// 文件数据
		responseDTO.setValue("fdataPublic", list2);// 选型申请表对应附件

		return responseDTO;

	}

	/**
	 * 删除
	 */

	public ISrvMsg deleteUpdate(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String deviceId = isrvmsg.getValue("updateids");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// 项目的ID
		mainMap.put("opi_id", deviceId);
		// 修改人
		mainMap.put("updatetor", user.getEmpId());
		// 修改时间
		mainMap.put("modify_date", createdate);
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		// 没有保存申请单的信息，先添加申请单的基本信息
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SELECTION_OPI");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;

	}
	/**
	 * 删除设备改造信息申请
	 */

	public ISrvMsg deleteModelChange(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String change_id = isrvmsg.getValue("change_id");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// 项目的ID
		mainMap.put("change_id", change_id);
		// 修改人
		mainMap.put("updatetor", user.getEmpId());
		// 修改时间
		mainMap.put("modify_date", createdate);
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		// 没有保存申请单的信息，先添加申请单的基本信息
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "dms_device_modelchange");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;

	}

	/**
	 * 删除主要人员
	 */

	public ISrvMsg deleteUpdatePeople(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String deviceId = isrvmsg.getValue("company_personnel_id");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// 主要人员的ID
		mainMap.put("company_personnel_id", deviceId);
		// 修改人
		mainMap.put("updatetor", user.getEmpId());
		// 修改时间
		mainMap.put("modify_date", createdate);
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		// 没有保存申请单的信息，先添加申请单的基本信息
		
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SELECTION_COMPANY_PER");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}

	/**
	 * 删除主要设备
	 */
	public ISrvMsg deleteUpdateEquipment(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String deviceId = isrvmsg.getValue("enterprise_equipment_id");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// 项目的ID
		mainMap.put("enterprise_equipment_id", deviceId);
		// 修改人
		mainMap.put("updatetor", user.getEmpId());
		// 修改时间
		mainMap.put("modify_date", createdate);
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		// 没有保存申请单的信息，先添加申请单的基本信息
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SELECTION_COMPANY_EQU");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}

	/**
	 * 添加企业
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg addEquipmentInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String company_id = isrvmsg.getValue("company_id");
		if(company_id.equals(""))
			company_id ="null";
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// 获得企业名称
		String enterprise_name = isrvmsg.getValue("enterprise_name").trim();
		String company_code=isrvmsg.getValue("companycode").trim();
		// 获得法定代表人
		String legal_person = isrvmsg.getValue("legal_person").trim();
		// 获得通讯地址						 
		String company_address = isrvmsg.getValue("company_address").trim();
		// 获得邮编
		String postalcode = isrvmsg.getValue("postalcode").trim();
		// 获得企业类型
		String company_type = isrvmsg.getValue("company_type").trim();
		// 获得注册资本
		String registered_capital = isrvmsg.getValue("registered_capital").trim();
		// 获得生产能力
		String production_capactity = isrvmsg.getValue("production_capactity").trim();
		// 获得职工总数
		String work_force = isrvmsg.getValue("work_force").trim();
		// 获得上年总产值
		String lastyear_total_value = isrvmsg.getValue("lastyear_total_value").trim();
		// 获得固定资产
		String fixed_assets = isrvmsg.getValue("fixed_assets").trim();
		// 获得联系人
		String linkman = isrvmsg.getValue("linkman").trim();
		// 获得联系电话
		String linkman_phone = isrvmsg.getValue("linkman_phone").trim();
		// 获得手机
		String cellphone = isrvmsg.getValue("cellphone").trim();
		// 获得体系管理认证标准、时间
		String sgs_date = isrvmsg.getValue("sgs_date").trim();
		// 获得企业简介
		String enterprise_info = isrvmsg.getValue("enterprise_info").trim();
		// 获得no的值
		String sqlEmp = "select case when max(p.no) is null then '0' else max(p.no) end as no from dms_selection_company p where p.bsflag='0' ";
		String flag= (String)isrvmsg.getValue("flag");
		System.out.println(flag);
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map map = isrvmsg.toMap();
		Map no = new HashMap();
		no = jdbcDao.queryRecordBySQL(sqlEmp);
		int nos = Integer.valueOf(no.get("no").toString()) + 1;
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if (company_id.equals("null") && "add".equals(flag)) {
				strMap.put("no", nos);
				strMap.put("enterprise_name", enterprise_name);
				strMap.put("legal_person", legal_person);
				strMap.put("company_address", company_address);
				strMap.put("postalcode", postalcode);
				strMap.put("company_type", company_type);
				strMap.put("registered_capital", registered_capital);
				strMap.put("production_capactity", production_capactity);
				strMap.put("work_force", work_force);
				strMap.put("lastyear_total_value", lastyear_total_value);
				strMap.put("fixed_assets", fixed_assets);
				strMap.put("linkman", linkman);
				strMap.put("linkman_phone", linkman_phone);
				strMap.put("cellphone", cellphone);
				strMap.put("sgs_date", sgs_date);
				strMap.put("enterprise_info", enterprise_info);
				strMap.put("creater", user.getEmpId());
				strMap.put("create_date", createdate);
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				strMap.put("company_code", company_code);
				Serializable dis_id = jdbcDao.saveOrUpdateEntity(strMap, "DMS_SELECTION_COMPANY");
				company_id =(String) dis_id;
			} else{
				strMap.put("no", nos);
				strMap.put("company_id", company_id);
				strMap.put("enterprise_name", enterprise_name);
				strMap.put("legal_person", legal_person);
				strMap.put("company_address", company_address);
				strMap.put("postalcode", postalcode);
				strMap.put("company_type", company_type);
				strMap.put("registered_capital", registered_capital);
				strMap.put("production_capactity", production_capactity);
				strMap.put("work_force", work_force);
				strMap.put("lastyear_total_value", lastyear_total_value);
				strMap.put("fixed_assets", fixed_assets);
				strMap.put("linkman", linkman);
				strMap.put("linkman_phone", linkman_phone);
				strMap.put("cellphone", cellphone);
				strMap.put("sgs_date", sgs_date);
				strMap.put("enterprise_info", enterprise_info);
				strMap.put("updatetor", user.getEmpId());
				strMap.put("modify_date", createdate);
				strMap.put("company_code", company_code);
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				jdbcDao.saveOrUpdateEntity(strMap, "DMS_SELECTION_COMPANY");
			}
			for (Object key : map.keySet()) {
				if(((String)key).startsWith("company_personnel_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//保存生成的sql，主键为空值，保存否则修改
					if("000".equals(map.get("company_personnel_id_"+indexStr)) || StringUtils.isBlank(map.get("company_personnel_id_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("company_personnel_id", iuuid);
						// 企业id
						aMap.put("company_id", company_id);
						// 姓名
						String name = isrvmsg.getValue("name_" + indexStr);
						aMap.put("name", name);
						// 性别
						String sex = isrvmsg.getValue("sex_" + indexStr);
						aMap.put("sex", sex);
						// 年龄
						String age = isrvmsg.getValue("age_" + indexStr);
						aMap.put("age", age);
						// 职务职称
						String job_title = isrvmsg.getValue("job_title_" + indexStr);
						aMap.put("job_title", job_title);
						// 学历
						String education = isrvmsg.getValue("education_" + indexStr);
						aMap.put("education", education);
						// 所学专业
						String major = isrvmsg.getValue("major_" + indexStr);
						aMap.put("major", major);
						// 固定/聘用 
						String job_type = isrvmsg.getValue("job_type_" + indexStr);
						aMap.put("job_type", job_type);
						aMap.put("creater", user.getEmpId());
						aMap.put("create_date","to_date('"+createdate+"','yyyy-MM-dd HH24:mi:ss')");
						aMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(aMap,"DMS_SELECTION_COMPANY_PER",new String[] {"create_date"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("company_personnel_id", (String)map.get("company_personnel_id_"+indexStr));
						uMap.put("company_id", company_id);
						uMap.put("name", isrvmsg.getValue("name_" + indexStr));
						uMap.put("sex", isrvmsg.getValue("sex_" + indexStr));
						uMap.put("age", isrvmsg.getValue("age_" + indexStr));
						uMap.put("job_title", isrvmsg.getValue("job_title_" + indexStr));
						uMap.put("education", isrvmsg.getValue("education_" + indexStr));
						uMap.put("major", isrvmsg.getValue("major_" + indexStr));
						uMap.put("job_type", isrvmsg.getValue("job_type_" + indexStr));
						uMap.put("updatetor", user.getEmpId());
						uMap.put("modify_date","to_date('"+createdate+"','yyyy-MM-dd HH24:mi:ss')");
						uMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(uMap,"DMS_SELECTION_COMPANY_PER",new String[] {"modify_date"},"update","company_personnel_id"));
					}
				}
				
				if(((String)key).startsWith("enterprise_equipment_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//保存生成的sql，主键为空值，保存否则修改
					if("000".equals(map.get("enterprise_equipment_id_"+indexStr)) || StringUtils.isBlank(map.get("enterprise_equipment_id_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("enterprise_equipment_id", iuuid);
						// 企业id
						aMap.put("company_id", company_id);
						// 设备名称
						String device_name = isrvmsg.getValue("device_name_" + indexStr);
						aMap.put("device_name", device_name);
						// 规格型号
						String model = isrvmsg.getValue("model_" + indexStr);
						aMap.put("model", model);
						// 生产厂家
						String vender = isrvmsg.getValue("vender_" + indexStr);
						aMap.put("vender", vender);
						// 运行状态
						String running_state = isrvmsg.getValue("running_state_" + indexStr);
						aMap.put("running_state", running_state);
						aMap.put("creater", user.getEmpId());
						aMap.put("create_date","to_date('"+createdate+"','yyyy-MM-dd HH24:mi:ss')");
						aMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(aMap,"DMS_SELECTION_COMPANY_EQU",new String[] {"create_date"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("enterprise_equipment_id", (String)map.get("enterprise_equipment_id_"+indexStr));
						// 企业id
						uMap.put("company_id", company_id);
						// 设备名称
						String device_name = isrvmsg.getValue("device_name_" + indexStr);
						uMap.put("device_name", device_name);
						// 规格型号
						String model = isrvmsg.getValue("model_" + indexStr);
						uMap.put("model", model);
						// 生产厂家
						String vender = isrvmsg.getValue("vender_" + indexStr);
						uMap.put("vender", vender);
						// 运行状态
						String running_state = isrvmsg.getValue("running_state_" + indexStr);
						uMap.put("running_state", running_state);
						uMap.put("updatetor", user.getEmpId());
						uMap.put("modify_date","to_date('"+createdate+"','yyyy-MM-dd HH24:mi:ss')");
						uMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(uMap,"DMS_SELECTION_COMPANY_EQU",new String[] {"modify_date"},"update","enterprise_equipment_id"));
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//批处理操作
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	

/**
 * 生成操作语句
 * @param data
 * @param tableName
 * @param arr
 * @param oFlag
 * @return
 */
@SuppressWarnings("rawtypes")
public String assembleSql(Map data,String tableName,String[] arr,String oFlag,String pkColumn){
	String tempSql="";
	if("add".equals(oFlag)){
		tempSql += "insert into "+ tableName +"(";
		String values = "";
		Object[] keys =  data.keySet().toArray();
		
		for(int i=0;i<keys.length;i++){
			tempSql+= keys[i].toString() + ",";
			boolean flag = false;
			if(null!=arr){
				for(int j=0;j<arr.length;j++){
					if(keys[i].toString().equals(arr[j])){
						flag = true;
						break;
					}
				}
			}
			if(null== data.get(keys[i].toString()) || StringUtils.isBlank( data.get(keys[i].toString()).toString())){
				values += "null,";
			}else{
				if(flag){
					values += data.get(keys[i].toString())+",";
				}else{
					values += "'"+data.get(keys[i].toString())+"',";
				}
			}
		}
		tempSql = tempSql.substring(0, tempSql.length()-1);
		values = values.substring(0, values.length()-1);
		tempSql+=") values ("+values+") ";
	}
	if("update".equals(oFlag)){
		tempSql += "update  "+ tableName +" set ";
		Object[] keys =  data.keySet().toArray();
		
		for(int i=0;i<keys.length;i++){
			tempSql+= keys[i].toString() + "=";
			boolean flag = false;
			if(null!=arr){
				for(int j=0;j<arr.length;j++){
					if(keys[i].toString().equals(arr[j])){
						flag = true;
						break;
					}
				}
			}
			if(null== data.get(keys[i].toString()) || StringUtils.isBlank( data.get(keys[i].toString()).toString())){
				tempSql += "null,";
			}else{
				if(flag){
					tempSql += data.get(keys[i].toString())+",";
				}else{
					tempSql += "'"+data.get(keys[i].toString())+"',";
				}
			}
		}
		tempSql = tempSql.substring(0, tempSql.length()-1);
		tempSql+=" where "+pkColumn+"='"+data.get(pkColumn).toString()+"'";
	}
	return tempSql;
}







	/**
	 * 查询企业设备明细
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getEquipmentInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//厂家详细信息
		String company_id=msg.getValue("company_id");
		StringBuffer queryAssetForDeviceSql = new StringBuffer();
		queryAssetForDeviceSql.append("select * from DMS_SELECTION_COMPANY d where");
		if (StringUtils.isNotBlank(company_id)) {
			queryAssetForDeviceSql.append(" d.company_id  = '"+company_id+"'");
		}		
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryAssetForDeviceSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	
	/**
	 * 删除企业
	 */

	public ISrvMsg deleteEnterprise(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String deviceId = isrvmsg.getValue("company_id");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// 项目的ID
		mainMap.put("company_id", deviceId);
		// 修改人
		mainMap.put("updatetor", user.getEmpId());
		// 修改时间
		mainMap.put("modify_date", createdate);
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		// 没有保存申请单的信息，先添加申请单的基本信息
		try {
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SELECTION_COMPANY");
		} catch (Exception e) {
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;

	}
	
	/**
	 * 企业  修改页面的回填数据
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getEnterpriseInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getEnterpriseInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer queryopiInfoSql = new StringBuffer();
		StringBuffer queryopiInfoSql2 = new StringBuffer();
		StringBuffer queryopiInfoSql3= new StringBuffer();
		String company_id = isrvmsg.getValue("company_id"); // 产品idID
		queryopiInfoSql.append("select * from DMS_SELECTION_COMPANY c where ");
		if (StringUtils.isNotBlank(company_id)) {
			queryopiInfoSql.append(" c.company_id  = '"+company_id+"'");
		}	
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryopiInfoSql.toString());
		
		// 人员表
		if (StringUtils.isNotBlank(company_id)) {
			queryopiInfoSql2.append("select * from DMS_SELECTION_COMPANY c  left join DMS_SELECTION_COMPANY_PER p on c.company_id=p.company_id where c.company_id  = '" + company_id + "' and  p.bsflag='0' ");
		}
		
		// 设备表
		if (StringUtils.isNotBlank(company_id)) {
			queryopiInfoSql3.append("select * from DMS_SELECTION_COMPANY c  left join DMS_SELECTION_COMPANY_EQU e on c.company_id=e.company_id where c.company_id  = '" + company_id + "' and  e.bsflag='0' ");
		}
		
		
		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMap);
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryopiInfoSql2.toString());
		if (list.size()>0) {
			responseDTO.setValue("deviceappMap", list);
		}
		List<Map> listarr = new ArrayList<Map>();
		listarr = jdbcDao.queryRecords(queryopiInfoSql3.toString());
		if (listarr.size()>0) {
			responseDTO.setValue("strMap", listarr);
		}
		
		return responseDTO;

	}
	/**
	 *  页面展示产品基本信息
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getModelChangeInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//厂家详细信息
		String change_id=msg.getValue("change_id");
		StringBuffer queryAssetForDeviceSql = new StringBuffer();
		queryAssetForDeviceSql.append("select * from dms_device_modelchange d where ");
		if (StringUtils.isNotBlank(change_id)) {
			queryAssetForDeviceSql.append(" d.change_id  = '"+change_id+"'");
		}		
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryAssetForDeviceSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		
		// 查询文件表
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ change_id + "' and t.bsflag='0' and t.is_file='1' ";
		// + "and order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// 文件数据
		responseDTO.setValue("fdataPublic", list2);// 选型申请表对应附件

		
		return responseDTO;
	}
	/**
	 *  页面展示产品基本信息
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getProductInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//厂家详细信息
		String opi_id=msg.getValue("opi_id");
		StringBuffer queryAssetForDeviceSql = new StringBuffer();
		queryAssetForDeviceSql.append("select * from DMS_SELECTION_OPI d where ");
		if (StringUtils.isNotBlank(opi_id)) {
			queryAssetForDeviceSql.append(" d.opi_id  = '"+opi_id+"'");
		}		
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryAssetForDeviceSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		
		// 查询文件表
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ opi_id + "' and t.bsflag='0' and t.is_file='1' ";
		// + "and order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// 文件数据
		responseDTO.setValue("fdataPublic", list2);// 选型申请表对应附件

		
		return responseDTO;
	}
	
	
	/**
	 * 获取企业基本信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg getCompanyProduct(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String opi_id = isrvmsg.getValue("opi_id");
		StringBuffer queryopiInfoSql = new StringBuffer();
		queryopiInfoSql.append("select * from DMS_SELECTION_OPI d left join DMS_SELECTION_COMPANY c on d.company_id=c.company_id where ");
		if (StringUtils.isNotBlank(opi_id)) {
			queryopiInfoSql.append(" d.opi_id  = '"+opi_id+"'");
		}	
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryopiInfoSql.toString());
		
		
		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMap);
		}
		return responseDTO;
	}
	
	/**
	 * 获取企业基本信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg getCompanyProEqu(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer queryopiInfoSql2 = new StringBuffer();
		StringBuffer queryopiInfoSql3= new StringBuffer();
		String company_id = isrvmsg.getValue("company_id"); // 产品idID
		// 人员表
		if (StringUtils.isNotBlank(company_id)) {
			queryopiInfoSql2.append("select * from DMS_SELECTION_COMPANY c  left join DMS_SELECTION_COMPANY_PER p on c.company_id=p.company_id where c.company_id  = '" + company_id + "' and  p.bsflag='0' ");
		}
		
		// 设备表						
		if (StringUtils.isNotBlank(company_id)) {
			queryopiInfoSql3.append("select * from DMS_SELECTION_COMPANY c  left join DMS_SELECTION_COMPANY_EQU e on c.company_id=e.company_id where c.company_id  = '" + company_id + "' and  e.bsflag='0' ");
		}
		
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryopiInfoSql2.toString());
		if (list.size()>0) {
			responseDTO.setValue("deviceappMap", list);
		}
		List<Map> listarr = new ArrayList<Map>();
		listarr = jdbcDao.queryRecords(queryopiInfoSql3.toString());
		if (listarr.size()>0) {
			responseDTO.setValue("strMap", listarr);
		}
		
		return responseDTO;
	}
	/**
	 * 获取评审信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getCompanyView(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String opi_id = isrvmsg.getValue("opi_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append(" select * from DMS_SELECTION_OPI d  ");
		// 主键id
		if (StringUtils.isNotBlank(opi_id)) {
			queryScrapeInfoSql.append(" where d.opi_id  = '" + opi_id + "'");
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryScrapeInfoSql.toString());
		
		responseDTO.setValue("deviceappMap", list);
		return responseDTO;
	}
	/**
	 * 评审
	 * 
	 * @param isrvmsg
	 *            页面传过来的值
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSelectionReview(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String opi_id = isrvmsg.getValue("opi_id"); // 评审信息ID
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// 专家组意见
		String panel_idea = isrvmsg.getValue("panel_idea").trim();
		// 专家组负责人
		String panel_principal = isrvmsg.getValue("panel_principal").trim();
		// 专家组评审日期
		String panel_review_date = isrvmsg.getValue("panel_review_date");
		// 设备物资处意见
		String equipment_idea = isrvmsg.getValue("equipment_idea").trim();
		// 设备物资处负责人
		String equipment_principal = isrvmsg.getValue("equipment_principal").trim();
		// 设备物资处评审日期
		String equipment_review_date = isrvmsg.getValue("equipment_review_date");
		// 设备物资处评审结果
		String review_result = isrvmsg.getValue("review_result");
		if (Integer.parseInt(review_result) == 0) {
			strMap.put("review_state", EquipmentStants.BSFLAG_TGZT);
			strMap.put("review_result", EquipmentStants.BSFLAG_TG);
		} else if (Integer.parseInt(review_result) == 1) {
			strMap.put("review_state", EquipmentStants.BSFLAG_WTGZT);
			strMap.put("review_result", EquipmentStants.BSFLAG_WTG);
		}
		strMap.put("opi_id", opi_id);
		strMap.put("panel_idea", panel_idea);
		strMap.put("panel_principal", panel_principal);
		strMap.put("panel_review_date", panel_review_date);
		strMap.put("equipment_idea", equipment_idea);
		strMap.put("equipment_principal", equipment_principal);
		strMap.put("equipment_review_date", equipment_review_date);
		strMap.put("creater", user.getEmpId());
		strMap.put("create_date", createdate);
		strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
		jdbcDao.saveOrUpdateEntity(strMap, "DMS_SELECTION_OPI");
		
		// 附件上传
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		Map<String, Object> doc = new HashMap<String, Object>();
		MyUcm ucm = new MyUcm();
		String filename = "";
		String fileOrder = "";
		String ucmDocId = "";
		try {
			// 处理附件
			for (WSFile file : filesOther) {
				filename = file.getFilename();
				fileOrder = file.getKey().toString().split("__")[0];// fileOrder.substring(1,5)+"__"+System.currentTimeMillis()
				ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
				doc.put("ucm_id", ucmDocId);
				doc.put("is_file", "1");
				doc.put("relation_id", opi_id);
				doc.put("file_type", fileOrder);
				doc.put("file_name", filename);
				doc.put("bsflag", EquipmentStants.BSFLAG_ZC);
				doc.put("creator_id", user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("UPLOAD_DATE", createdate);
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				// 附件表
				String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				// 日志表
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
						user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
			}

		} catch (Exception e) {
			System.out.println("插入附件异常");
		}

		return isrvmsg;
	}
	
	/**
	 * 评审信息  查看页面
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getReviewInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		StringBuffer queryopiInfoSql = new StringBuffer();
		String opi_id = isrvmsg.getValue("opi_id"); // 产品ID
		queryopiInfoSql.append("select t.* from dms_selection_opi t where t.bsflag='0'");
		// 申请单ID
		if (StringUtils.isNotBlank(opi_id)) {
			queryopiInfoSql.append(" and opi_id  = '" + opi_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryopiInfoSql.toString());
		if (deviceappMap != null) {
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		// 查询文件表
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ opi_id + "' and t.bsflag='0' and t.is_file='1' ";
		// + "and order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// 文件数据
		responseDTO.setValue("fdataPublic", list2);// 选型申请表对应附件

		return responseDTO;
	}
	/**
	 * 是否可以评审     是否可以修改
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg getReviewtUnit(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String opi_id = isrvmsg.getValue("opi_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append(" select d.opi_id,d.review_state from DMS_SELECTION_OPI d");
		// 选型申请  是否可以修改
		if (StringUtils.isNotBlank(opi_id)) {
			queryScrapeInfoSql.append(" where d.opi_id  = '" + opi_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if (deviceappMap != null) {
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	
	/**
	 * 处理多附件上传
	 */
	public ISrvMsg uploadFile(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		String opi_id = isrvmsg.getValue("opi_id"); // 评审信息ID
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		Map<String, Object> doc = new HashMap<String, Object>();
		MyUcm ucm = new MyUcm();
		String filename = "";
		String fileOrder = "";
		String ucmDocId = "";
		try {
			// 处理附件
			for (WSFile file : filesOther) {
				filename = file.getFilename();
				fileOrder = file.getKey().toString().split("__")[0];// fileOrder.substring(1,5)+"__"+System.currentTimeMillis()
				ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
				doc.put("ucm_id", ucmDocId);
				doc.put("is_file", "1");
				doc.put("relation_id", opi_id);
				doc.put("file_type", fileOrder);
				doc.put("file_name", filename);
				doc.put("bsflag", EquipmentStants.BSFLAG_ZC);
				doc.put("creator_id", user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("UPLOAD_DATE", createdate);
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				// 附件表
				String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				// 日志表
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
						user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
			}

		} catch (Exception e) {
			System.out.println("插入附件异常");
		}
		return mqMsgOther;
		
	}
	/**
	 * 是否可以评审     是否可以修改
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg getDevInfoByERP(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String dev_coding = isrvmsg.getValue("dev_coding");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append(" select acc.* from gms_device_account acc ");
		// 选型申请  是否可以修改
		if (StringUtils.isNotBlank(dev_coding)) {
			queryScrapeInfoSql.append(" where acc.dev_coding  = '" + dev_coding + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if (deviceappMap != null) {
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 添加转资
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addTransferFundsInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String zz_id = isrvmsg.getValue("zz_id");
		if(zz_id==null || zz_id.equals(""))
			zz_id ="null";
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyyMMdd");
		String Strdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd");
		// 获得转资台数
		String zz_num = isrvmsg.getValue("zz_num").trim();
		// 获得转资总金额
		String zz_money = isrvmsg.getValue("zz_money").trim();
		// 获得批次计划				 
		String batch_plan = isrvmsg.getValue("batch_plan").trim();
		// 获得供应商名称
		String lifnr_name = isrvmsg.getValue("lifnr_name").trim();
		// 获得采购编号
		String cg_order_num = isrvmsg.getValue("cg_order_num").trim();
		// 获得创建人
		//String creator = isrvmsg.getValue("creator").trim();
		//判读添加或者修改
		String flag= (String)isrvmsg.getValue("flag");
		System.out.println(flag);
		
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map map = isrvmsg.toMap();
		long nos = new Date().getTime();
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if (zz_id.equals("null") && "add".equals(flag)) {
				strMap.put("zz_no",nos);
				strMap.put("zz_num", zz_num);
				strMap.put("zz_money", zz_money);
				strMap.put("zz_state", "2");
				strMap.put("batch_plan", batch_plan);
				strMap.put("lifnr_name", lifnr_name);
				strMap.put("cg_order_num", cg_order_num);
				strMap.put("creator", user.getUserName());
				//strMap.put("creater", user.getEmpId());
				strMap.put("zz_date",createdate);
				strMap.put("create_date", createdate);
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				Serializable dis_id = jdbcDao.saveOrUpdateEntity(strMap, "DMS_ZZ_INFO_APPLY");
				zz_id =(String) dis_id;
			} else{
				strMap.put("zz_id", zz_id);
				strMap.put("zz_money", zz_money);
				strMap.put("batch_plan", batch_plan);
				strMap.put("lifnr_name", lifnr_name);
				strMap.put("cg_order_num", cg_order_num);
				strMap.put("modifier", user.getUserName());
				//strMap.put("updatetor", user.getEmpId());
				strMap.put("modify_date", createdate);
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				jdbcDao.saveOrUpdateEntity(strMap, "DMS_ZZ_INFO_APPLY");
			}
			for (Object key : map.keySet()) {
				if(((String)key).startsWith("zzd_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//保存生成的sql，主键为空值，保存否则修改
					if("000".equals(map.get("zzd_id_"+indexStr)) || StringUtils.isBlank(map.get("zzd_id_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("zzd_id", iuuid);
						//转资ID
						aMap.put("zz_id", zz_id);
						//设备名称
						String eqktx = isrvmsg.getValue("eqktx_" + indexStr);
						aMap.put("eqktx", eqktx);
						//规格型号
						String typbz = isrvmsg.getValue("typbz_" + indexStr);
						aMap.put("typbz", typbz);
						//ERP设备编号
						String dev_coding = isrvmsg.getValue("dev_coding_" + indexStr);
						aMap.put("dev_coding", dev_coding);
						//投产日期
						String inbdt = isrvmsg.getValue("inbdt_" + indexStr);
						aMap.put("inbdt", inbdt.replaceAll("-",""));
						//购置金额
						String answt = isrvmsg.getValue("answt_" + indexStr);
						aMap.put("answt", answt);
						//设备所属单位
						String org_name = isrvmsg.getValue("org_name_" + indexStr);
						aMap.put("org_name",org_name);
						
						
						aMap.put("creator",user.getUserName());
						aMap.put("CREATE_DATE","to_date('"+Strdate+"','yyyy-MM-dd')");
						aMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(aMap,"DMS_ZZ_DETAILED_APPLY",new String[] {"CREATE_DATE"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("zzd_id", (String)map.get("zzd_id_"+indexStr));
						uMap.put("zz_id", zz_id);
						uMap.put("eqktx", isrvmsg.getValue("eqktx_" + indexStr));
						uMap.put("typbz", isrvmsg.getValue("typbz_" + indexStr));
						uMap.put("dev_coding", isrvmsg.getValue("dev_coding_" + indexStr));
						uMap.put("inbdt", isrvmsg.getValue("inbdt_" + indexStr).replaceAll("-",""));
						uMap.put("answt", isrvmsg.getValue("answt_" + indexStr));
						uMap.put("org_name",isrvmsg.getValue("org_name_" + indexStr));
						uMap.put("MODIFI_DATE","to_date('"+Strdate+"','yyyy-MM-dd')");
						uMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(uMap,"DMS_ZZ_DETAILED_APPLY",new String[] {"MODIFI_DATE"},"update","zzd_id"));
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//批处理操作
				jdbcTemplate.batchUpdate(strings);
			}
			//存储附件操作
			MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
			List<WSFile> filesOther = mqMsgOther.getFiles();
			Map<String, Object> doc = new HashMap<String, Object>();
			MyUcm ucm = new MyUcm();
			String filename = "";
			String fileOrder = "";
			String ucmDocId = "";
			try {// 处理附件
				for (WSFile file : filesOther) {
					filename = file.getFilename();
					fileOrder = file.getKey().toString().split("__")[0];// fileOrder.substring(1,5)+"__"+System.currentTimeMillis()
					//先查询需要就修改的文件在附件表存不存在
//					String sqlFiles = "select t.file_id as fileId from bgp_doc_gms_file t where"
//							+ " t.relation_id='"+zz_id+"'and t.file_type='"+fileOrder+"' and t.bsflag='0' and t.is_file='1' ";
//					List<Map> list2 = new ArrayList<Map>();
//					list2 = jdbcDao.queryRecords(sqlFiles);
//					for (Map wsFile : list2) {
//						String ucm_id = wsFile.get("fileid").toString();
//						String updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+ucm_id+"'";
//						jdbcDao.executeUpdate(updateSql);
//					}

					ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", zz_id);
					doc.put("file_type", fileOrder);
					doc.put("file_name", filename);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("creator_id", user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					
					
					// 附件表
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					// 日志表
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
					user.getSubOrgIDofAffordOrg(), filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
					user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
				}
			} catch (Exception e) {
				System.out.println("附件未插入或修改");
			}
		} catch (Exception e) {
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	/**
	 * 转资信息  修改页面的回填数据
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getTransferFundsInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getTransferFundsInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer queryopiInfoSql = new StringBuffer();
		StringBuffer queryopiInfoSql2 = new StringBuffer();
		
		String zz_id = isrvmsg.getValue("zz_id"); // 转资ID
		queryopiInfoSql.append("select * from DMS_ZZ_INFO_APPLY c where ");
		if (StringUtils.isNotBlank(zz_id)) {
			queryopiInfoSql.append(" c.zz_id  = '"+zz_id+"'");
		}	
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryopiInfoSql.toString());
		
		// 详情表
		if (StringUtils.isNotBlank(zz_id)) {
			queryopiInfoSql2.append("select * from DMS_ZZ_DETAILED_APPLY c  where c.zz_id  = '" + zz_id + "' and  c.bsflag='0' ");
		}
		
		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMap);
		}
		List<Map> list = new ArrayList<Map>();
			list = jdbcDao.queryRecords(queryopiInfoSql2.toString());
		if (list.size()>0) {
			responseDTO.setValue("deviceappMap", list);
		}
		// 查询文件表
				String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
						+ zz_id + "' and t.bsflag='0' and t.is_file='1' ";
				List<Map> list2 = new ArrayList<Map>();
				list2 = jdbcDao.queryRecords(sqlFiles);
				//文件数据
		responseDTO.setValue("fdataPublic", list2);// 附件
		return responseDTO;

	}
	/**
	 * 删除转资单据主体
	 */

	public ISrvMsg deleteUpdateZzInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyyMMdd");
		String deviceId = isrvmsg.getValue("zz_id");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map<String, Object> mainMap = new HashMap<String, Object>();
		
		//ID
		mainMap.put("zz_id", deviceId);
		// 修改人
		mainMap.put("modifier", user.getEmpId());
		// 修改时间
		mainMap.put("modify_date",createdate);
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_ZZ_INFO_APPLY");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	/**
	 * 删除转资单据明细
	 */

	public ISrvMsg deleteUpdateZzDetauled(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String Strdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd");
		String deviceId = isrvmsg.getValue("zzd_id");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map<String, Object> mainMap = new HashMap<String, Object>();
		//ID
		mainMap.put("zzd_id", deviceId);
		// 修改人
		mainMap.put("modifier", user.getEmpId());
		// 修改时间
		mainMap.put("MODIFI_DATE","to_date('"+Strdate+"','yyyy-MM-dd')");
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_ZZ_DETAILED_APPLY");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	/**
	 * 添加增值
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addTransferAddedInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String zz_id = isrvmsg.getValue("zz_id");
		if(zz_id==null || zz_id.equals(""))
			zz_id ="null";
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyyMMdd");
		String Strdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd");
		// 获得增值内容
		String valueadd_content = isrvmsg.getValue("valueadd_content").trim();
		// 获得增值总金额
		String amount_money = isrvmsg.getValue("amount_money").trim();
		//判读添加或者修改
		String flag= (String)isrvmsg.getValue("flag");
		System.out.println(flag);
		
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map map = isrvmsg.toMap();
		long nos = new Date().getTime();
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if (zz_id.equals("null") && "add".equals(flag)) {
				strMap.put("valueadd_id",nos);
				strMap.put("valueadd_content", valueadd_content);
				strMap.put("amount_money", amount_money);
				strMap.put("creater", user.getUserName());
				strMap.put("create_date", createdate);
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				Serializable dis_id = jdbcDao.saveOrUpdateEntity(strMap, "DMS_EQUI_VALUEADD_INFO_APPLY");
				zz_id =(String) dis_id;
			} else{
				strMap.put("zz_info_id", zz_id);
				strMap.put("valueadd_content", valueadd_content);
				strMap.put("amount_money", amount_money);
				strMap.put("updatpr", user.getUserName());
				strMap.put("modify_date", createdate);
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				jdbcDao.saveOrUpdateEntity(strMap, "DMS_EQUI_VALUEADD_INFO_APPLY");
			}
			for (Object key : map.keySet()) {
				if(((String)key).startsWith("zz_detail_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//保存生成的sql，主键为空值，保存否则修改
					if("000".equals(map.get("zz_detail_id_"+indexStr)) || StringUtils.isBlank(map.get("zz_detail_id_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("zz_detail_id", iuuid);
						//转资ID
						aMap.put("zz_info_id", zz_id);
						
						//设备名称
						String dev_name = isrvmsg.getValue("dev_name_" + indexStr);
						aMap.put("dev_name", dev_name);
						//规格型号
						String typbz = isrvmsg.getValue("typbz_" + indexStr);
						aMap.put("typbz", typbz);
						//ERP设备编号
						String dev_coding = isrvmsg.getValue("dev_coding_" + indexStr);
						aMap.put("dev_coding", dev_coding);
						//增值金额
						String valueadd_money = isrvmsg.getValue("valueadd_money_" + indexStr);
						aMap.put("valueadd_money", valueadd_money);
						//采购订单号
						String cg_order_num = isrvmsg.getValue("cg_order_num_" + indexStr);
						aMap.put("cg_order_num", cg_order_num);
						//项目编号
						String zzzjitem = isrvmsg.getValue("zzzjitem_" + indexStr);
						aMap.put("zzzjitem",zzzjitem);

						aMap.put("creater",user.getUserName());
						aMap.put("CREATE_DATE",createdate);
						aMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(aMap,"DMS_EQUI_VALUEADD_DETAIL_APPLY",new String[] {"CREATE_DATE"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("zz_detail_id", (String)map.get("zz_detail_id_"+indexStr));
						uMap.put("zz_info_id", zz_id);
						uMap.put("dev_name", isrvmsg.getValue("dev_name_" + indexStr));
						uMap.put("typbz", isrvmsg.getValue("typbz_" + indexStr));
						uMap.put("dev_coding", isrvmsg.getValue("dev_coding_" + indexStr));
						uMap.put("valueadd_money", isrvmsg.getValue("valueadd_money_" + indexStr));
						uMap.put("cg_order_num", isrvmsg.getValue("cg_order_num_" + indexStr));
						uMap.put("zzzjitem",isrvmsg.getValue("zzzjitem_" + indexStr));
						uMap.put("MODIFI_DATE",createdate);
						uMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(uMap,"DMS_EQUI_VALUEADD_DETAIL_APPLY",new String[] {"MODIFI_DATE"},"update","zz_detail_id"));
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//批处理操作
				jdbcTemplate.batchUpdate(strings);
			}
			//存储附件操作
			MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
			List<WSFile> filesOther = mqMsgOther.getFiles();
			Map<String, Object> doc = new HashMap<String, Object>();
			MyUcm ucm = new MyUcm();
			String filename = "";
			String fileOrder = "";
			String ucmDocId = "";
			try {// 处理附件
				for (WSFile file : filesOther) {
					filename = file.getFilename();
					fileOrder = file.getKey().toString().split("__")[0];// fileOrder.substring(1,5)+"__"+System.currentTimeMillis()
					ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", zz_id);
					doc.put("file_type", fileOrder);
					doc.put("file_name", filename);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("creator_id", user.getUserId());
					doc.put("create_date","to_date('"+Strdate+"','yyyy-MM-dd')");
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					
					
					// 附件表
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					// 日志表
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
					user.getSubOrgIDofAffordOrg(), filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
					user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
				}
			} catch (Exception e) {
				System.out.println("附件未插入或修改");
			}
		} catch (Exception e) {
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	/**
	 * 增值信息  修改页面的回填数据
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getTransferAddedInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getTransferAddedInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer queryopiInfoSql = new StringBuffer();
		StringBuffer queryopiInfoSql2 = new StringBuffer();
		
		String zz_id = isrvmsg.getValue("zz_id"); // 转资ID
		queryopiInfoSql.append("select * from DMS_EQUI_VALUEADD_INFO_APPLY c where ");
		if (StringUtils.isNotBlank(zz_id)) {
			queryopiInfoSql.append(" c.zz_info_id  = '"+zz_id+"'");
		}	
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryopiInfoSql.toString());
		
		// 详情表
		if (StringUtils.isNotBlank(zz_id)) {
			queryopiInfoSql2.append("select * from DMS_EQUI_VALUEADD_DETAIL_APPLY c  where c.zz_info_id  = '" + zz_id + "' and  c.bsflag='0' ");
		}
		
		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMap);
		}
		List<Map> list = new ArrayList<Map>();
			list = jdbcDao.queryRecords(queryopiInfoSql2.toString());
		if (list.size()>0) {
			responseDTO.setValue("deviceappMap", list);
		}
		// 查询文件表
				String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
						+ zz_id + "' and t.bsflag='0' and t.is_file='1' ";
				List<Map> list2 = new ArrayList<Map>();
				list2 = jdbcDao.queryRecords(sqlFiles);
				//文件数据
		responseDTO.setValue("fdataPublic", list2);// 附件
		return responseDTO;

	}
	/**
	 * 删除增值单据明细
	 */

	public ISrvMsg deleteUpdateZengzDetauled(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyyMMdd");
		String deviceId = isrvmsg.getValue("zzd_id");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map<String, Object> mainMap = new HashMap<String, Object>();
		//ID
		mainMap.put("zz_detail_id", deviceId);
		// 修改人
		mainMap.put("modifier", user.getUserName());
		// 修改时间
		mainMap.put("MODIFI_DATE",createdate);
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_EQUI_VALUEADD_DETAIL_APPLY");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	/**
	 * 删除增值单据主体
	 */

	public ISrvMsg deleteUpdateZengzInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyyMMdd");
		String deviceId = isrvmsg.getValue("zz_id");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map<String, Object> mainMap = new HashMap<String, Object>();
		
		//ID
		mainMap.put("zz_info_id", deviceId);
		// 修改人
		mainMap.put("modifier", user.getEmpId());
		// 修改时间
		mainMap.put("modify_date",createdate);
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_EQUI_VALUEADD_INFO_APPLY");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	/**
	 * 添加消息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addmsgInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String msg_id = isrvmsg.getValue("msg_id");
		if(msg_id==null || msg_id.equals(""))
			msg_id ="null";
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyyMMdd");
		String Strdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd");
		// 获得消息内容
		String content = isrvmsg.getValue("content").trim();
		// 获得消息展示截止日期
		String show_date = isrvmsg.getValue("show_date").trim();
		//判读添加或者修改
		String flag= (String)isrvmsg.getValue("flag");
		System.out.println(flag);
		
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map map = isrvmsg.toMap();
		
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if (msg_id.equals("null") && "add".equals(flag)) {
				strMap.put("content", content);
				strMap.put("show_date",show_date);
				strMap.put("creater_name",user.getUserName());
				strMap.put("creater_id", user.getUserId());
				strMap.put("create_date","to_date('"+Strdate+"','yyyy-MM-dd')");
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				Serializable dis_id = jdbcDao.saveOrUpdateEntity(strMap, "DMS_MSG_INFO");
				msg_id =(String) dis_id;
			} else{
				strMap.put("msg_id", msg_id);
				strMap.put("content", content);
				strMap.put("show_date",show_date);
				strMap.put("modifier_name", user.getUserName());
				strMap.put("modifier_id", user.getUserId());
				strMap.put("modify_date","to_date('"+Strdate+"','yyyy-MM-dd')");
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				jdbcDao.saveOrUpdateEntity(strMap, "DMS_MSG_INFO");
			}
			//存储附件操作
			MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
			List<WSFile> filesOther = mqMsgOther.getFiles();
			Map<String, Object> doc = new HashMap<String, Object>();
			MyUcm ucm = new MyUcm();
			String filename = "";
			String fileOrder = "";
			String ucmDocId = "";
			try {// 处理附件
				for (WSFile file : filesOther) {
					filename = file.getFilename();
					fileOrder = file.getKey().toString().split("__")[0];// fileOrder.substring(1,5)+"__"+System.currentTimeMillis()
					ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", msg_id);
					doc.put("file_type", fileOrder);
					doc.put("file_name", filename);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("creator_id", user.getUserId());
					doc.put("create_date","to_date('"+Strdate+"','yyyy-MM-dd')");
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					// 附件表
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					// 日志表
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
					user.getSubOrgIDofAffordOrg(), filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
					user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
				}
			} catch (Exception e) {
				System.out.println("附件未插入或修改");
			}
		} catch (Exception e) {
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	/**
	 * 消息  修改页面的回填数据
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getMsgInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getMsgInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer queryopiInfoSql = new StringBuffer();
		
		String msg_id = isrvmsg.getValue("msg_id"); // 转资ID
		queryopiInfoSql.append("select * from DMS_MSG_INFO c where ");
		if (StringUtils.isNotBlank(msg_id)) {
			queryopiInfoSql.append(" c.msg_id  = '"+msg_id+"'");
		}	
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryopiInfoSql.toString());

		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMap);
		}
		// 查询文件表
				String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
						+ msg_id + "' and t.bsflag='0' and t.is_file='1'  and t.file_type = 'msg_purchase' ";
				List<Map> list2 = new ArrayList<Map>();
				list2 = jdbcDao.queryRecords(sqlFiles);
				//文件数据
		responseDTO.setValue("fdataPublic", list2);// 附件
		return responseDTO;
	}
	/**
	 * 删除转资单据主体
	 */

	public ISrvMsg deleteUpdateMsgInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String Strdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd");
		String msg_id = isrvmsg.getValue("msg_id");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map<String, Object> mainMap = new HashMap<String, Object>();
		
		//ID
		mainMap.put("msg_id", msg_id);
		mainMap.put("modifier_name", user.getUserName());
		mainMap.put("modifier_id", user.getUserId());
		mainMap.put("modify_date","to_date('"+Strdate+"','yyyy-MM-dd')");
		// 删除标记
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_MSG_INFO");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
}
