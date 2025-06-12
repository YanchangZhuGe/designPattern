package com.bgp.mcs.service.qua.service;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import net.sf.json.JSONArray;

import oracle.stellent.ridc.model.DataResultSet;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;
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

public class QualitySrv extends BaseService {

	private static RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private static JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private static IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	/**
	 * 公共 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveQualityBySql(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sqls = reqDTO.getValue("sql");
		System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
		return msg;
	}
	public void saveQualityBySql(String sqls) throws Exception {
		//System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
	}
	public ISrvMsg deleteCheckPlanWs(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String param = reqDTO.getValue("param");
		String[] params = param.split(",");
		for(int i=0;i<params.length;i++){
			String plansql = "update BGP_QUA_CHECK_PLAN_WS set BSFLAG='1' where QUA_PLAN_ID='"+params[i]+"'";
			jdbcTemplate.execute(plansql);
		}

		msg.setValue("returnCode","0");
		return msg;

	}
	
	
	
	public ISrvMsg getFileinfo(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String ucmdocid = reqDTO.getValue("ucmdocid");

		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
		String filePath = myUcm.getDocUrl(ucmdocid);
		//DataResultSet fd = myUcm.
		msg.setValue("filePath",filePath);
		return msg;

	}

	public ISrvMsg saveOrUpdateCheckPlanWs(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String qua_plan_id = reqDTO.getValue("qua_plan_id");
		String project_info_no = reqDTO.getValue("project_info_no");
		String planStartDate = reqDTO.getValue("planStartDate");
		String planEndDate = reqDTO.getValue("planEndDate");
		String responsibility = reqDTO.getValue("responsibility");
		String checkPerson = reqDTO.getValue("checkPerson");	
		String file_id_old = reqDTO.getValue("file_id");

		String folder_id = reqDTO.getValue("folder_id");
		
		String ucmDocId = "";
		String uploadFileName="";
		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	//	String uploadFileName = reqDTO.getValue("upload_file_name") != null?reqDTO.getValue("upload_file_name"):"";

		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList.size()!=0){
			for(int i=0;i<fileList.size();i++){
				WSFile uploadFile = fileList.get(i);
				uploadFileName=uploadFile.getFilename();
				byte[] uploadData = uploadFile.getFileData();
				ucmDocId = myUcm.uploadFile(uploadFileName, uploadData);
			}
		}
		if(ucmDocId!=""){
			String org_id = user.getOrgId();
			String org_subjection_id = user.getOrgSubjectionId();
			String user_id = user.getUserId();
			String qc_id = jdbcDao.generateUUID();
			String file_id = jdbcDao.generateUUID();
			StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id ,parent_file_id,file_number)");
			sbSql.append("values('").append(file_id).append("','").append(uploadFileName).append("','").append(ucmDocId).append("','").append(qc_id).append("','").append(project_info_no).append("','0',sysdate,'")
			.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append(org_id).append("','").append(org_subjection_id).append("','").append(folder_id).append("','')");
			
			jdbcTemplate.execute(sbSql.toString());
			myUcm.docVersion(file_id, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
			myUcm.docLog(file_id, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
			//删除旧的
			String deleteFile ="update bgp_doc_gms_file set bsflag='1' where file_id='"+file_id_old+"'";
			jdbcTemplate.execute(deleteFile);

			file_id_old = file_id;
		}		
		
		Map<String,Object> map =  new HashMap<String, Object>();
		if(qua_plan_id!=null&&!"".equals(qua_plan_id)){
			map.put("qua_plan_id", qua_plan_id);
		}else{
			map.put("create_date", new Date());

		}
		map.put("project_info_no", project_info_no);
		map.put("project_name", user.getProjectName());

		if(uploadFileName!=""){
			map.put("fileName", uploadFileName);
		}
		map.put("file_id", file_id_old);
		map.put("planStartDate", planStartDate);
		map.put("planEndDate", planEndDate);
		map.put("responsibility", responsibility);
		map.put("checkPerson", checkPerson);
		map.put("bsflag", "0");
		map.put("creator_id", user.getUserId());
		map.put("modifi_date", new Date());
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_QUA_CHECK_PLAN_WS");
		return msg;
	
	}

	
	
	/**
	 * 公共 --> 保存(map)
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg saveQualityByMap(ISrvMsg reqDTO) throws Exception{
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
	 * 公共 --> 获得项目的WBS树
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getProjectWbsOnly(ISrvMsg reqDTO) throws Exception{
		//UserToken user = reqDTO.getUserToken();
		//String node = reqDTO.getValue("node");
		String project_type = reqDTO.getValue("project_type");
		String object_name = getSetting(project_type);
		
		Map map = new HashMap();
		String project_info_no = reqDTO.getValue("project_info_no");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.* from bgp_p6_project t where 1=1 and t.bsflag = '0' and t.project_info_no is not null and t.project_info_no ='").append(project_info_no).append("'");
		map = pureJdbcDao.queryRecordBySQL(sb.toString());
		String project_object_id ="";
		if(map!=null && map.get("object_id")!=null && !map.get("object_id").toString().equals("")){
			project_object_id = (String)map.get("object_id");
		}
		List list = new ArrayList();
		sb = new StringBuffer();
		sb.append("select wbs_object_id as id ,project_id as task_id ,object_id as other1 ,'' as start_date ,'' as end_date ,")
		.append(" project_name as name ,'' as paren_id ,0 as percent_done ,'true' as is_wbs ,'true' as is_root ,'fasle' as is_task")
		.append(" from bgp_p6_project where bsflag = '0' and object_id = '").append(project_object_id).append("'");
		list = pureJdbcDao.queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i =0;list!=null && i<list.size();i++){
			Map root = (Map)list.get(i);
			if(root.get("id")!=null && !root.get("id").equals("")){
				sb = new StringBuffer();
				sb.append("select t.object_id id ,t.object_id task_id ,t.object_id other1 ,temp1.start_date as start_date ,temp1.finish_date as end_date ,")
				.append(" temp1.planned_start_date ,temp1.planned_finish_date as planned_end_date ,t.name name ,t.parent_object_id as parent_id ,")
				.append(" 0 as percent_done ,'true' as leaf ,'true' as is_wbs ,'false' as is_root ,'fasle' as is_task ,p.duty_person duty_name, ")
				.append(" p.check_person,t.name wbs_name from bgp_p6_project_wbs t")
				.append(" join (select  min(a.start_date) as start_date ,max(a.finish_date) as finish_date,a.wbs_object_id ,")
				.append(" min(a.planned_start_date) as planned_start_date ,max(a.planned_finish_date) as planned_finish_date  ")
				.append(" from bgp_p6_activity a where a.bsflag='0' and a.project_object_id ='").append(project_object_id).append("'")
				.append(" group by a.wbs_object_id) temp1 on t.object_id = temp1.wbs_object_id")
				.append(" left join bgp_qua_plan p on t.object_id = p.object_id and p.bsflag='0' and p.project_info_no ='").append(project_info_no).append("'")
				.append(" where t.name in (").append(object_name).append(") order by task_id");
				List<Map> tList = pureJdbcDao.queryRecords(sb.toString());
				if(project_type!=null && project_type.trim().equals("5000100004000000009")){
					String wbs_object_ids = "";
					for(Map m : tList){
						String wbs_object_id = m.get("id")==null?"":(String)m.get("id");
						wbs_object_ids = wbs_object_ids + "\'"+wbs_object_id+"\',";
					}
					wbs_object_ids += "''";
					sb = new StringBuffer();
					sb.append(" select t.object_id task_id ,t.name ,t.start_date ,t.finish_date end_date, t.planned_start_date ,t.planned_finish_date planned_end_date,")
					.append(" 'true' as is_wbs ,'false' as is_root ,'fasle' as is_task, p.duty_person duty_name,p.check_person,p.notes,'true' leaf ,")
					.append(" (select wbs.name from bgp_p6_project_wbs wbs where wbs.bsflag ='0' and wbs.object_id = t.wbs_object_id) wbs_name")
					.append(" from bgp_p6_activity t left join bgp_qua_plan p on t.object_id = p.object_id and p.bsflag ='0' and p.project_info_no ='"+project_info_no+"'")
					.append(" where t.bsflag ='0' and t.project_object_id ='"+project_object_id+"' and t.wbs_object_id in ("+wbs_object_ids+") order by t.wbs_object_id");
					tList = pureJdbcDao.queryRecords(sb.toString());
				}
				if (tList != null && tList.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(tList);
					root.put("children", jsonarray);
					root.put("leaf", false);
					root.put("expanded", true);
				} else {
					root.put("children", null);
					root.put("leaf", true);
					root.put("expanded", true);
				}
				jsList.add(root);
			}
		}

		JSONArray json = JSONArray.fromObject(jsList);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json",json.toString());
		
		return msg;
	}
	/**
	 * 公共 --> 获得项目的WBS树、作业
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getProjectActivity(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		String checked = reqDTO.getValue("checked");
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null || project_info_no.trim().equals("")){
			project_info_no = user.getProjectInfoNo();
		}
		String project_type = reqDTO.getValue("project_type");
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("root")){
			sb  = new StringBuffer();
			sb.append(" select t.object_id id ,t.object_id task_id ,t.name ,'' as parent_id ,")
			.append(" case when temp1.start_date is not null then to_char(temp1.start_date,'yyyy-MM-dd') else '' end start_date ,")
			.append(" case when temp1.finish_date is not null then to_char(temp1.finish_date,'yyyy-MM-dd') else '' end end_date ,")
			.append(" case when temp1.planned_start_date is not null then to_char(temp1.planned_start_date,'yyyy-MM-dd') else '' end planned_start_date ,")
			.append(" case when temp1.planned_finish_date is not null then to_char(temp1.planned_finish_date,'yyyy-MM-dd') else '' end planned_end_date ,")
			.append(" 0 as percent_done ,'false' as leaf ,'true' as is_wbs ,'false' as is_root ,'fasle' as is_task ")
			.append(" from bgp_p6_project_wbs t")
			.append(" join (select  min(a.start_date) as start_date ,max(a.finish_date) as finish_date,a.wbs_object_id ,")
			.append(" min(a.planned_start_date) as planned_start_date ,max(a.planned_finish_date) as planned_finish_date   ")
			.append(" from bgp_p6_activity a where a.bsflag='0' and a.project_object_id = (select t.object_id from bgp_p6_project t ")
			.append(" where t.bsflag='0'and t.project_info_no ='").append(project_info_no).append("')")
			.append(" group by a.wbs_object_id) temp1 on t.object_id = temp1.wbs_object_id")
			.append(" where t.name in (select t.coding_sort_name from comm_coding_sort t where t.coding_sort_id like'50001001%'")
			.append(" and t.coding_sort_id !='5000100100' and t.spare2 ='"+project_type+"')")
			.append(" and t.project_object_id =(select t.object_id from bgp_p6_project t where t.bsflag='0'and t.project_info_no ='").append(project_info_no).append("')")
			.append(" order by task_id");

			List root = pureJdbcDao.queryRecords(sb.toString());
			List list = new ArrayList();
			if(checked!=null && checked.trim().equals("true")){
				for(int i =0;i<root.size() ;i++){
					Map map = (Map)root.get(i);
					map.put("checked" ,false);
					list.add(map);
				}
			}
			json = JSONArray.fromObject(list);
		}else{
			sb  = new StringBuffer();
			sb.append(" select t.id, t.id task_id ,concat(t.name,case t.status when 'Not Started' then '(未开始)' when 'In Progress' then '(正在施工)' else '(完成)' end) name ,'' as parent_id,")
			.append(" t.wbs_object_id parent_id ,t.start_date ,t.finish_date ,t.planned_start_date ,t.planned_finish_date planned_end_date ,0 as percent_done ,'true' as leaf ,")
			.append(" 'false' as is_wbs ,'false' as is_root ,'true' as is_task ")
			.append(" from bgp_p6_activity t")
			.append(" where t.bsflag='0'and t.wbs_object_id ='").append(node).append("'")
			.append(" and t.project_object_id =(select t.object_id from bgp_p6_project t where t.bsflag='0'and t.project_info_no ='").append(project_info_no).append("')")
			.append(" order by task_id");

			List root = pureJdbcDao.queryRecords(sb.toString());
			List list = new ArrayList();
			if(checked!=null && checked.trim().equals("true")){
				for(int i =0;i<root.size() ;i++){
					Map map = (Map)root.get(i);
					map.put("checked" ,false);
					list.add(map);
				}
			}
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
	/**
	 * 公共 --> 获得设置的工序名称
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 */
	public String getSetting(String project_type) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		if(project_type!=null && project_type.trim().equals("5000100004000000001")){
			sb.append("select '放线' object_name from dual union select t.coding_sort_name object_name from comm_coding_sort t where t.bsflag='0' ")
			.append(" and t.coding_sort_id like'50001001%' and t.coding_sort_id !='5000100100' and t.spare2 ='"+project_type+"'");
		}else{
			sb.append("select t.coding_sort_name object_name from comm_coding_sort t where t.bsflag='0' and t.coding_sort_id like'50001001%'")
			.append(" and t.coding_sort_id !='5000100100' and t.spare2 ='"+project_type+"'");
		}
		
		list = pureJdbcDao.queryRecords(sb.toString());
		String object_name = "";
		for(int i=0;list!=null && i<list.size();i++){
			Map map = (Map)list.get(i);
			if(map!=null && map.get("object_name")!=null && !map.get("object_name").toString().equals("")){
				String name = (String)map.get("object_name");
				if(object_name.trim().equals("")){
					object_name = "\'"+name+"\'";
				}else{
					object_name = object_name +",\'"+name+"\'";
				}
				
			}
		}
		System.out.println(object_name);
		return object_name;
	}
	
	/**
	 * 质量分析会 ---> 会议记录
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateMeetingRecord(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		UserToken user = reqDTO.getUserToken();
		Map<String,Object> map = new HashMap<String,Object>();

		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String  record_id = reqDTO.getValue("record_id");
		if(record_id!=null&&!"".equals(record_id)){
			map.put("record_id",record_id);			
		}
		//String project_info_no = reqDTO.getValue("project_info_no");
		String project_info_no = user.getProjectInfoNo();
		map.put("record_code", reqDTO.getValue("record_code"));
		map.put("record_num", reqDTO.getValue("record_num"));
		map.put("record_date", reqDTO.getValue("record_date"));
		map.put("title", reqDTO.getValue("title"));
		map.put("record_place", reqDTO.getValue("record_place"));
		map.put("record_master", reqDTO.getValue("record_master"));
		map.put("record_content", reqDTO.getValue("record_content"));
		map.put("project_info_no", project_info_no);
		map.put("recorder", reqDTO.getValue("recorder"));
		map.put("org_id", org_id);
		map.put("org_subjection_id", org_subjection_id);
		map.put("bsflag", "0");
		map.put("creator_id", user_id);
		map.put("create_date", new Date());
		map.put("modifi_date", new Date());
		map.put("updator_id", user_id);
		

		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;

		List<WSFile> fileList = mqMsg.getFiles();
		//如果不选择文件，则不执行上传文档到ucm的操作	to_date('"+today+"','YYYY-MM-DD HH24-mi-ss')
		String ucmDocId = "";
		String uploadFileName = "";

		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] uploadData = uploadFile.getFileData();
			uploadFileName = uploadFile.getFilename();
			ucmDocId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
			map.put("upload_file_name", uploadFileName);
			map.put("ucm_id", ucmDocId);

		}

		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_meeting_record");

		return msg;
	}
	/**
	 * 质量分析会--->质量分析报告
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateQualityanalysisreport(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		UserToken user = reqDTO.getUserToken();
		Map<String,Object> map = new HashMap<String,Object>();
		String  report_id = reqDTO.getValue("report_id");
		if(report_id!=null&&!"".equals(report_id)){
			map.put("report_id",report_id);			
		}
		map.put("report_code", reqDTO.getValue("report_code"));
		map.put("report_num", reqDTO.getValue("report_num"));
		map.put("report_date", reqDTO.getValue("report_date"));
		map.put("work_area", reqDTO.getValue("work_area"));
		map.put("line_num", reqDTO.getValue("line_num"));
		map.put("master_id", reqDTO.getValue("master_id"));
		map.put("record_id", reqDTO.getValue("record_id"));
		map.put("design_work", reqDTO.getValue("design_work"));
		map.put("complete_work", reqDTO.getValue("complete_work"));
		map.put("surface", reqDTO.getValue("surface"));
		map.put("stimulate", reqDTO.getValue("stimulate"));
		map.put("technology", reqDTO.getValue("technology"));
		map.put("manage_step", reqDTO.getValue("manage_step"));
		map.put("original_data", reqDTO.getValue("original_data"));
		map.put("sections", reqDTO.getValue("sections"));
		map.put("proplem", reqDTO.getValue("proplem"));
		map.put("next_step", reqDTO.getValue("next_step"));
		map.put("note", reqDTO.getValue("note"));
		map.put("supervise", reqDTO.getValue("supervise"));

		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String  record_id = reqDTO.getValue("record_id");
		if(record_id!=null&&!"".equals(record_id)){
			map.put("record_id",record_id);			
		}
		String project_info_no = user.getProjectInfoNo();
		map.put("project_info_no", project_info_no);
		map.put("org_subjection_id", org_subjection_id);
		map.put("org_id", org_id);
		map.put("bsflag", "0");
		map.put("creator_id", user_id);
		map.put("updator_id", user_id);
		map.put("modifi_date", new Date());
		map.put("create_date", new Date());

		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;

		List<WSFile> fileList = mqMsg.getFiles();
		//如果不选择文件，则不执行上传文档到ucm的操作	to_date('"+today+"','YYYY-MM-DD HH24-mi-ss')
		String ucmDocId = "";
		String uploadFileName = "";

		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] uploadData = uploadFile.getFileData();
			uploadFileName = uploadFile.getFilename();
			ucmDocId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
			map.put("upload_file_name", uploadFileName);
			map.put("ucm_id", ucmDocId);

		}

		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_meeting_report");

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
	public ISrvMsg getRecordList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String objectName = reqDTO.getValue("objectName");
		String task_id = reqDTO.getValue("task_id");
		if(task_id == null || task_id.equals("")){
			task_id = "null";
		}
		String project_type = reqDTO.getValue("project_type");
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		StringBuffer sb = new StringBuffer();
		sb.append(" select s.detail_name record_name ,'0' record_num from bgp_qua_coding_sort s where s.bsflag ='0' and s.sort_id like '50001001%' ")
		.append(" and s.project_info_no='"+project_info_no+"' and s.sort_name like '%").append(objectName).append("%'");
		List typeList = pureJdbcDao.queryRecords(sb.toString());
		if(typeList==null || typeList.size()<=0){
			sb = new StringBuffer();
			sb.append("select d.coding_name record_name from comm_coding_sort t ")
			.append(" left join comm_coding_sort_detail d on t.coding_sort_id = d.coding_sort_id ")
			.append(" where t.bsflag = '0' and d.bsflag ='0' and t.spare2 ='"+project_type+"'")
			.append("  and  t.coding_sort_name like '%").append(objectName).append("%'")
			.append("  order by d.coding_name asc");
			typeList = pureJdbcDao.queryRecords(sb.toString());
		}
		msg.setValue("typeList", typeList);
		Map qualityMap = getQualityMap(objectName ,task_id ,project_info_no);
		msg.setValue("qualityMap", qualityMap);
		int index = task_id.indexOf(",");
		sb = new StringBuffer();
		sb.append("select r.record_name ,r.record_num ,(select substr(max(case when e.unit_id is null then sys_connect_by_path(e.unit_id,' ') else sys_connect_by_path(e.unit_id,';') end),2)")
		.append(" from(select d.* ,lead(d.rn) over(partition by d.record_name order  by d.rn) rn1")
		.append(" from(select t.record_name ,t.record_num ,t.unit_id ,row_number() over(order by t.record_name ,t.unit_id asc) rn")
		.append(" from bgp_qua_record_summary t where t.bsflag='0' and t.object_name like'%").append(objectName).append("%'")
		.append(" and t.task_id in('").append(task_id).append("') and t.project_info_no ='").append(project_info_no).append("')d ) e")
		.append(" start with e.record_name = r.record_name and e.rn1 is null connect by e.rn1 = prior e.rn and e.record_name = prior e.record_name) unit_id,")
		.append(" (select substr(max(case when e.notes is null then sys_connect_by_path(e.notes,' ') else sys_connect_by_path(e.notes,';') end),2) from(select d.* ,lead(d.rn) over(partition by d.record_name order  by d.rn) rn1")
		.append(" from(select t.record_name ,t.record_num ,t.notes ,row_number() over(order by t.record_name ,t.notes asc) rn")
		.append(" from bgp_qua_record_summary t where t.bsflag='0' and t.object_name like'%").append(objectName).append("%'")
		.append(" and t.task_id in('").append(task_id).append("') and t.project_info_no ='").append(project_info_no).append("')d ) e")
		.append(" start with e.record_name = r.record_name and e.rn1 is null connect by e.rn1 = prior e.rn and e.record_name = prior e.record_name) notes")
		.append(" from (select distinct s.record_name , sum(s.record_num) record_num from bgp_qua_record_summary s")
		.append(" left join bgp_qua_summary_history h on s.summary_history_id = h.summary_history_id and h.bsflag='0'")
		.append(" where s.bsflag='0' and s.object_name like'%").append(objectName).append("%'")
		.append(" and s.task_id in('").append(task_id).append("') and s.project_info_no ='").append(project_info_no).append("'")
		.append(" group by s.record_name)r order by r.record_name");
		List recordList = pureJdbcDao.queryRecords(sb.toString());
		List list = recordList ;
		for(int i=0;i<typeList.size();i++){
			Map typeMap = (Map)typeList.get(i);
			String recordName = "";
			if(typeMap!=null){
				recordName = (String)typeMap.get("record_name");
			}
			int j =0;
			for(j=0;j<recordList.size();j++){
				Map map = (Map)recordList.get(j);
				String name = "";
				if(map!=null){
					name = (String)map.get("record_name");
				}
				if(recordName!=null&& !recordName.trim().equals("") && name!=null && !name.trim().equals("")){
					if(recordName.equals(name) && name.equals(recordName)){
						break;
					}
				}
			}
			if(j==recordList.size()){
				typeMap.put("record_num", "0");
				typeMap.put("unit_id", "");
				typeMap.put("notes", "");
				list.add(typeMap);
			}
		}
		msg.setValue("recordList", list);
		return msg;
	}
	
	public Map getQualityMap(String objectName ,String task_id ,String project_info_no){
		StringBuffer sb = new StringBuffer();
		sb.append("select distinct t.summary_history_id ,h.check_date ,")
		.append(" h.summarier ,h.summary_date ,h.quality_num ,h.summary_num ")
		.append(" from bgp_qua_record_summary t ")
		.append(" join bgp_qua_summary_history h on t.summary_history_id = h.summary_history_id and h.bsflag='0'")
		.append("where t.bsflag='0' and t.object_name like'%").append(objectName).append("'")
		.append(" and t.task_id in('").append(task_id).append("')")
		.append(" and t.project_info_no ='").append(project_info_no).append("'");
		List quality = pureJdbcDao.queryRecords(sb.toString());
		Map qualityMap = new HashMap();
		if(quality!=null && quality.size()>0){
			if(quality.size()==1){
				Map map = (Map)quality.get(0);
				if(map!=null){
					
					String checker = "";
					if(map.get("checker_name")!=null && !map.get("checker_name").toString().trim().equals("")){
						checker = (String)map.get("checker_name");
					}
					String check_date = "";
					if(map.get("check_date")!=null && !map.get("check_date").toString().trim().equals("")){
						check_date = (String)map.get("check_date");
					}
					String summarier = "";
					if(map.get("summarier")!=null && !map.get("summarier").toString().trim().equals("")){
						summarier = (String)map.get("summarier");
					}
					String summary_date = "";
					if(map.get("summary_date")!=null && !map.get("summary_date").toString().trim().equals("")){
						summary_date = (String)map.get("summary_date");
					}
					String quality_num = "";
					if(map.get("quality_num")!=null && !map.get("quality_num").toString().trim().equals("")){
						quality_num = (String)map.get("quality_num");
					}
					String summary_num = "";
					if(map.get("summary_num")!=null && !map.get("summary_num").toString().trim().equals("")){
						summary_num = (String)map.get("summary_num");
					}
					qualityMap.put("checker", checker);
					qualityMap.put("check_date", check_date);
					qualityMap.put("summarier", summarier);
					qualityMap.put("summary_date", summary_date);
					qualityMap.put("quality_num", quality_num);
					qualityMap.put("summary_num", summary_num);
				}else{
					qualityMap.put("checker", "");
					qualityMap.put("check_date", "");
					qualityMap.put("summarier", "");
					qualityMap.put("summary_date", "");
					qualityMap.put("quality_num", "");
					qualityMap.put("summary_num", "");
				}
			}else{
				int quality_num = 0;
				int summary_num = 0;
				String checker ="";
				String check_date ="1900-01-01";
				String summarier ="";
				String summary_date ="1900-01-01";
				for(int i=0;i<quality.size();i++){
					Map map = (Map)quality.get(i);
					if(map.get("checker_name")!=null && !map.get("checker_name").toString().trim().equals("")){
						String temp = (String)map.get("checker_name") +";" + checker;
						if(checker!=null && temp!=null && !temp.trim().equals("")){
							if(checker.indexOf(temp)==-1){
								checker = temp +";" + checker;
							}
						}
					}
					if(map.get("check_date")!=null && !map.get("check_date").toString().trim().equals("")){
						String temp = (String)map.get("check_date") ;
						SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
						if(check_date!=null && temp!=null ){
							try {
								int b = df.parse(temp).compareTo(df.parse(check_date));
								if(b>0){
									check_date = temp ;
								}
							} catch (ParseException e) {
								e.printStackTrace();
							}
						}
					}
					if(map.get("summarier")!=null && !map.get("summarier").toString().trim().equals("")){
						String temp = (String)map.get("summarier") ;
						if(summarier!=null && temp!=null && !temp.trim().equals("")){
							if(summarier.indexOf(temp)==-1){
								summarier = temp +";" + summarier;
							}
						}
					}
					if(map.get("summary_date")!=null && !map.get("summary_date").toString().trim().equals("")){
						String temp = (String)map.get("summary_date") ;
						SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
						if(summary_date!=null && temp!=null ){
							try {
								int b = df.parse(temp).compareTo(df.parse(summary_date));
								if(b>0){
									summary_date = temp ;
								}
							} catch (ParseException e) {
								e.printStackTrace();
							}
						}
					}
					if(map.get("quality_num")!=null && !map.get("quality_num").toString().trim().equals("")){
						
						if(map.get("quality_num")!=null && !map.get("quality_num").toString().equals("")){
							quality_num = Integer.valueOf((String)map.get("quality_num")) -(-quality_num);
						}
					}
					if(map.get("summary_num")!=null && !map.get("summary_num").toString().trim().equals("")){
						summary_num =summary_num + Integer.valueOf((String)map.get("summary_num"));
					}
				}
				qualityMap.put("checker", checker);
				qualityMap.put("check_date", check_date);
				qualityMap.put("summarier", summarier);
				qualityMap.put("summary_date", summary_date);
				qualityMap.put("quality_num", quality_num);
				qualityMap.put("summary_num", summary_num);
			}
		}
		return qualityMap;
	}
	/**
	 * 单炮评价汇总  --> 汇总列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ISrvMsg getShotList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String objectName = reqDTO.getValue("objectName");
		String task_id = reqDTO.getValue("task_id");
		if(task_id == null || task_id.equals("")){
			task_id = "null";
		}
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String project_type = user.getProjectType();
		StringBuffer sb = new StringBuffer();
		sb.append("select d.coding_name record_name from comm_coding_sort t ")
		.append(" left join comm_coding_sort_detail d on t.coding_sort_id = d.coding_sort_id ")
		.append(" where t.bsflag = '0' and d.bsflag ='0' and t.coding_sort_id ='5000100100'")
		.append(" and d.coding_mnemonic_id='"+project_type+"' order by d.coding_code_id asc");
		List  typeList= pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("typeList", typeList);
		Map shotMap = getShotMap(objectName ,task_id ,project_info_no);
		msg.setValue("shotMap", shotMap);
		sb = new StringBuffer();
		sb.append("select r.record_name ,r.record_num ,(select substr(max(sys_connect_by_path(e.notes,';')),2)")
		.append(" from(select d.* ,lead(d.rn) over(partition by d.record_name order  by d.rn) rn1")
		.append(" from(select t.record_name ,t.record_num ,t.notes ,row_number() over(order by t.record_name ,t.notes asc) rn")
		.append(" from bgp_qua_record_summary t where t.bsflag='0' and t.object_name like'%").append(objectName).append("%'")
		.append(" and t.task_id in('").append(task_id).append("') and t.project_info_no ='").append(project_info_no).append("')d ) e")
		.append(" start with e.record_name = r.record_name and e.rn1 is null connect by e.rn1 = prior e.rn and e.record_name = prior e.record_name) notes")
		.append(" from (select distinct s.record_name , sum(s.record_num) record_num from bgp_qua_record_summary s")
		.append(" left join bgp_qua_summary_history h on s.summary_history_id = h.summary_history_id and h.bsflag='0'")
		.append(" where s.bsflag='0' and s.object_name like'%").append(objectName).append("%'")
		.append(" and s.task_id in('").append(task_id).append("') and s.project_info_no ='").append(project_info_no).append("'")
		.append(" group by s.record_name)r");
		List shotList = pureJdbcDao.queryRecords(sb.toString());
		List list = shotList ;
		for(int i=0;i<typeList.size();i++){
			Map typeMap = (Map)typeList.get(i);
			String recordName = "";
			if(typeMap!=null && typeMap.get("record_name")!=null){
				recordName = (String)typeMap.get("record_name");
			}
			int j =0;
			for(j=0;j<shotList.size();j++){
				Map map = (Map)shotList.get(j);
				String name = "";
				if(map!=null){
					name = (String)map.get("record_name");
				}
				if(recordName!=null&& !recordName.trim().equals("") && name!=null && !name.trim().equals("")){
					if(recordName.equals(name) && name.equals(recordName)){
						break;
					}
				}
			}
			if(j==shotList.size()){
				typeMap.put("record_num", "0");
				typeMap.put("notes", "");
				list.add(typeMap);
			}
		}
		msg.setValue("shotList", list);
		return msg;
	}
	@SuppressWarnings("unchecked")
	public Map getShotMap(String objectName ,String task_id ,String project_info_no){
		StringBuffer sb = new StringBuffer();
		sb.append(" select (case when sum(t.collect_2_class) is null then 0 else sum(t.collect_2_class) end) second_num ,(case when sum(t.collect_waster_num) is null then 0 else sum(t.collect_waster_num) end) waster ,(case when sum(t.daily_acquire_firstlevel_num) is null then 0 else sum(t.daily_acquire_firstlevel_num) end) first ,")
		.append(" (case when sum(t.daily_acquire_sp_num) is null then 0 else sum(t.daily_acquire_sp_num) end) - (-(case when sum(t.daily_jp_acquire_shot_num) is null then 0 else sum(t.daily_jp_acquire_shot_num) end)) - (-(case when sum(t.daily_qq_acquire_shot_num) is null then 0 else sum(t.daily_qq_acquire_shot_num) end)) total ,")
		.append(" sum(t.collect_miss_num) miss from gp_ops_daily_report t")
		.append(" where t.bsflag='0' and t.project_info_no ='").append(project_info_no).append("'");
		List shot = pureJdbcDao.queryRecords(sb.toString());
		Map shotMap = new HashMap();
		if(shot!=null && shot.size()>0){
			for(int i=0;i<shot.size();i++){
				Map map = (Map)shot.get(i);
				if(map!=null){
					if(map.get("total")!=null && !map.get("total").toString().trim().equals("")){
						shotMap.put("shot_num", (String)map.get("total"));
					}else{
						shotMap.put("shot_num", "0");
					}
					if(map.get("first")!=null && !map.get("first").toString().trim().equals("")){
						shotMap.put("first_num", (String)map.get("first"));
					}else{
						shotMap.put("first_num", "0");
					}
					if(map.get("second_num")!=null && !map.get("second_num").toString().trim().equals("")){
						shotMap.put("second_num", (String)map.get("second_num"));
					}else{
						shotMap.put("second_num", "0");
					}
					if(map.get("waster")!=null && !map.get("waster").toString().trim().equals("")){
						shotMap.put("abandon_num", (String)map.get("waster"));
					}else{
						shotMap.put("abandon_num", "0");
					}
				}
			}
		}else{
			shotMap.put("shot_num", "0");
			shotMap.put("first_num", "0");
			shotMap.put("second_num", "0");
			shotMap.put("abandon_num", "0");
		}
		sb = new StringBuffer();
		sb.append("select distinct t.summary_history_id ,h.checker checker_name,h.check_date ,")
		.append(" h.summarier summarier_name ,h.summary_date ,h.quality_num ,h.summary_num ")
		.append(" from bgp_qua_record_summary t ")
		.append(" join bgp_qua_summary_history h on t.summary_history_id = h.summary_history_id and h.bsflag='0'")
		.append("where t.bsflag='0' and t.object_name like'%").append(objectName).append("'")
		.append(" and t.task_id in('").append(task_id).append("')")
		.append(" and t.project_info_no ='").append(project_info_no).append("'");
		List quality = pureJdbcDao.queryRecords(sb.toString());
		if(quality!=null && quality.size()>0){
			if(quality.size()==1){
				Map map = (Map)quality.get(0);
				if(map!=null){
					String checker = "";
					if(map.get("checker_name")!=null && !map.get("checker_name").toString().trim().equals("")){
						checker = (String)map.get("checker_name");
					}
					String check_date = "";
					if(map.get("check_date")!=null && !map.get("check_date").toString().trim().equals("")){
						check_date = (String)map.get("check_date");
					}
					String summarier = "";
					if(map.get("summarier_name")!=null && !map.get("summarier_name").toString().trim().equals("")){
						summarier = (String)map.get("summarier_name");
					}
					String summary_date = "";
					if(map.get("summary_date")!=null && !map.get("summary_date").toString().trim().equals("")){
						summary_date = (String)map.get("summary_date");
					}
					shotMap.put("checker", checker);
					shotMap.put("check_date", check_date);
					shotMap.put("summarier", summarier);
					shotMap.put("summary_date", summary_date);
				}else{
					shotMap.put("checker", "");
					shotMap.put("check_date", "");
					shotMap.put("summarier", "");
					shotMap.put("summary_date", "");
				}
			}else{
				String checker ="";
				String check_date ="1900-01-01";
				String summarier ="";
				String summary_date ="1900-01-01";
				for(int i=0;i<quality.size();i++){
					Map map = (Map)quality.get(i);
					if(map.get("checker_name")!=null && !map.get("checker_name").toString().trim().equals("")){
						String temp = (String)map.get("checker_name") ;
						if(checker!=null && temp!=null && !temp.trim().equals("")){
							if(checker.indexOf(temp)==-1){
								checker = temp +";" + checker;
							}
						}
					}
					if(map.get("check_date")!=null && !map.get("check_date").toString().trim().equals("")){
						String temp = (String)map.get("check_date") ;
						SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
						if(check_date!=null && temp!=null ){
							try {
								int b = df.parse(temp).compareTo(df.parse(check_date));
								if(b>0){
									check_date = temp ;
								}
							} catch (ParseException e) {
								e.printStackTrace();
							}
						}
					}
					if(map.get("summarier_name")!=null && !map.get("summarier_name").toString().trim().equals("")){
						String temp = (String)map.get("summarier_name") ;
						if(summarier!=null && temp!=null && !temp.trim().equals("")){
							if(summarier.indexOf(temp)==-1){
								summarier = temp +";" + summarier;
							}
						}
					}
					if(map.get("summary_date")!=null && !map.get("summary_date").toString().trim().equals("")){
						String temp = (String)map.get("summary_date") ;
						SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
						if(summary_date!=null && temp!=null ){
							try {
								int b = df.parse(temp).compareTo(df.parse(summary_date));
								if(b>0){
									summary_date = temp ;
								}
							} catch (ParseException e) {
								e.printStackTrace();
							}
						}
					}
				}
				shotMap.put("checker", checker);
				shotMap.put("check_date", check_date);
				shotMap.put("summarier", summarier);
				shotMap.put("summary_date", summary_date);
			}
		}else{
			shotMap.put("checker", "");
			shotMap.put("check_date", "");
			shotMap.put("summarier", "");
			shotMap.put("summary_date", "");
		}
		return shotMap;
	}
	
	/**
	 * 上传文档到ucm
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	static WFCommonBean wfBean = (WFCommonBean) BeanFactory.getBean("WFCommonBean");
	public ISrvMsg uploadFileCommon(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String project_info_no = user.getProjectInfoNo();
		String doc_number = reqDTO.getValue("doc_number");
		if(doc_number==null && doc_number.trim().equals("")){
			doc_number = "";
		}
		String file_name = reqDTO.getValue("file_name");
		if(file_name==null && file_name.trim().equals("")){
			file_name = "";
		}
		String relation_id = reqDTO.getValue("relation_id");
		if(relation_id==null && relation_id.trim().equals("")){
			relation_id = "";
		}
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		List<WSFile> fileList = mqMsg.getFiles();
		//如果不选择文件，则不执行上传文档到ucm的操作	to_date('"+today+"','YYYY-MM-DD HH24-mi-ss')
		String ucmDocId = "";
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] uploadData = uploadFile.getFileData();
			ucmDocId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
		}
		String file_id = jdbcDao.generateUUID();	
		StringBuffer sb = new StringBuffer();
		
		String folder_id = reqDTO.getValue("folder_id");
		
		StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
		sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(project_info_no).append("','0',sysdate,'")
		.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append(org_id).append("','").append(org_subjection_id).append("','"+folder_id+"','"+doc_number+"')");
		
		jdbcTemplate.execute(sbSql.toString());
		
		myUcm.docVersion(file_id, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),file_name);
		myUcm.docLog(file_id, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),file_name);

		String index = reqDTO.getValue("index");
		if(index==null || index.trim().equals("")){
			index = "";
		}
		responseDTO.setValue("index", index);
		
		return responseDTO;

	}
	public ISrvMsg uploadFile(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String project_info_no = user.getProjectInfoNo();
		String qc_title = reqDTO.getValue("qc_title");
		if(qc_title==null || qc_title.trim().equals("")){
			qc_title = "";
		}
		String note = reqDTO.getValue("note");
		if(note==null || note.trim().equals("")){
			note = "";
		}
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		List<WSFile> fileList = mqMsg.getFiles();
		//如果不选择文件，则不执行上传文档到ucm的操作	to_date('"+today+"','YYYY-MM-DD HH24-mi-ss')
		String ucmDocId = "";
		String uploadFileName="";
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] uploadData = uploadFile.getFileData();
			uploadFileName = uploadFile.getFilename();
			ucmDocId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
		}
		String qc_id = jdbcDao.generateUUID();
		String file_id = jdbcDao.generateUUID();	
		StringBuffer sb = new StringBuffer();
		sb.append("insert into bgp_qua_qc(qc_id ,project_info_no ,qc_title ,notes ,org_id ,org_subjection_id ,bsflag ,creator_id ,create_date ,updator_id ,modifi_date ,file_id)")
		.append("values('").append(qc_id).append("','").append(project_info_no).append("','").append(qc_title).append("','").append(note).append("','")
		.append(org_id).append("','").append(org_subjection_id).append("','0','").append(user_id).append("',sysdate,'").append(user_id).append("',sysdate,'").append(file_id).append("')");
		jdbcTemplate.execute(sb.toString());
		
		//String file_name = reqDTO.getValue("file_name");
		String folder_id = reqDTO.getValue("folder_id");
		String doc_number = reqDTO.getValue("doc_number");
		StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id ,parent_file_id,file_number)");
		sbSql.append("values('").append(file_id).append("','").append(uploadFileName).append("','").append(ucmDocId).append("','").append(qc_id).append("','").append(project_info_no).append("','0',sysdate,'")
		.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append(org_id).append("','").append(org_subjection_id).append("','"+folder_id+"','"+doc_number+"')");
		
		jdbcTemplate.execute(sbSql.toString());
		
		myUcm.docVersion(file_id, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
		myUcm.docLog(file_id, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);

		responseDTO.setValue("ucmDocId", ucmDocId);
		
		
		String businessId = qc_id;
		String businessTableName = "bgp_qua_qc";
		String projectType = user.getProjectType();
		String businessType = "5110000004100000002";
		String businessInfo = "QC活动注册";
		if("5000100004000000008".equals(projectType)){
			 businessType = "5110000004100001078";
			 businessInfo = "井中QC活动注册";			
		}


		String projectName = user.getProjectName();
		String applicantDate = df.format(new Date());
		Map map = new HashMap();
		
		map.put("wfVar_projectName", projectName);
		map.put("wfVar_qc_id", qc_id);
		WFVarBean wfVar = new WFVarBean(businessId, businessTableName,
				businessType, businessInfo, 
				wfBean.copyMapFromStartMap(map, "wfVar_"),
				projectName, user ,applicantDate);
		String procinstId = wfBean.startWFProcess(wfVar);
		String forwardUrl = reqDTO.getValue("forwardUrl");
		responseDTO.setValue("forwardUrl", forwardUrl);
		responseDTO.setValue("procinstId", procinstId);
		
		return responseDTO;
	}
	public ISrvMsg importExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String project_info_no = user.getProjectInfoNo();
		String message = "";
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		List<WSFile> fileList = mqMsg.getFiles();
		//如果不选择文件，则不执行上传文档到ucm的操作	to_date('"+today+"','YYYY-MM-DD HH24-mi-ss')
		String ucmDocId = "";
		StringBuffer sb = new StringBuffer();
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] uploadData = uploadFile.getFileData();
			String file_name = uploadFile.getFilename();
			String sort_id = "";
        	String unite_code = "";
        	String sort_code = "";
        	String equip_name = "";
        	String model_code = "";
        	String measure = "";
        	String accurate = "";
        	String producor = "";
        	String ident_code = "";
        	String depart = "";
        	String facilities = "";
        	String status = "";
        	String detect_depart = "";
        	String detect_cycle = "";
        	String detect_date = "";
        	String valid_date = "";
        	String detect_result = "";
        	String abc = "";
        	String spare1 = "";
        	String notes = "";
			String type = file_name.substring(file_name.indexOf(".")+1);
			Workbook wb = null;
			Sheet sheet = null;
			if(type!=null && type.equals("xls")){
				wb = new HSSFWorkbook(	new POIFSFileSystem(new ByteArrayInputStream(uploadFile.getFileData())));
		        sheet = wb.getSheetAt(0); 
			}else if(type!=null && type.equals("xlsx")){
				wb = new XSSFWorkbook(	new ByteArrayInputStream(uploadFile.getFileData()));
		        sheet = wb.getSheetAt(0);
			}
			int rowIndex = sheet.getPhysicalNumberOfRows();
	        for(int i = 3;i<rowIndex;i++ ){
	        	Row row = sheet.getRow(i);
	        	Cell cell = row.getCell((short)3);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘名称’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		equip_name = cell.getStringCellValue();
	        		if(equip_name==null ){
	        			message = message + "第"+(i+1)+"行‘名称’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)4);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘型号’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		model_code = cell.getStringCellValue();
	        		if(model_code==null || model_code.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘型号’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)9);
	        	if(cell==null){
	        		message = message + "第"+(i+1)+"行‘使用部门’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		depart = cell.getStringCellValue();
	        		if(depart==null || depart.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘使用部门’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)0);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		sort_id = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)1);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		unite_code = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)2);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		sort_code = cell.getStringCellValue();
	        	}
	        	
	        	cell = row.getCell((short)5);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		measure = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)6);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		accurate = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)7);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		producor = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)8);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		ident_code = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)10);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		facilities = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)11);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		status = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)12);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		detect_depart = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)13);
	        	if(cell!=null){
	        		cell.setCellType(1);
	        		detect_cycle = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)14);
	        	if(cell!=null){
	        		if(cell.getCellType()==0){
	        			detect_date = new SimpleDateFormat("yyyy-MM-dd").format(cell.getDateCellValue());
	        		}else{
	        			detect_date = cell.getStringCellValue();
	        			detect_date = detect_date.replace("/", "-");
	        			detect_date = detect_date.replace(".", "-");
	        			if(detect_date.indexOf("-")==-1){
	        				message = message + "第"+(i+1)+"行‘检定日期’格式不正确!;";
	        			}
	        		}
	        		
	        	}
	        	cell = row.getCell((short)15);
	        	if(cell!=null){
	        		if(cell.getCellType()==0){
	        			valid_date = new SimpleDateFormat("yyyy-MM-dd").format(cell.getDateCellValue());
	        		}else{
	        			valid_date = cell.getStringCellValue();
	        			valid_date = valid_date.replace("/", "-");
	        			valid_date = valid_date.replace(".", "-");
	        			if(valid_date.indexOf("-")==-1){
	        				message = message + "第"+(i+1)+"行‘有效日期’格式不正确!;";
	        			}
	        		}
	        	}
	        	cell = row.getCell((short)16);
	        	if(cell!=null){
	        		detect_result = cell.getStringCellValue();
	        		if(detect_result!=null && detect_result.equals("合格")){
	        			detect_result = "1";
	        		}else if(detect_result!=null && detect_result.equals("不合格")){
	        			detect_result = "0";
	        		}else{
	        			detect_result = "";
	        		}
	        	}
	        	cell = row.getCell((short)17);
	        	if(cell!=null){
	        		abc = cell.getStringCellValue();
	        	}
	        	cell = row.getCell((short)18);
	        	if(cell!=null){
	        		if(cell.getCellType()==0){
	        			spare1 = new SimpleDateFormat("yyyy-MM-dd").format(cell.getDateCellValue());
	        		}else{
	        			spare1 = cell.getStringCellValue();
	        			spare1 = spare1.replace("/", "-");
	        			spare1 = spare1.replace(".", "-");
	        			if(spare1.indexOf("-")==-1){
	        				message = message + "第"+(i+1)+"行‘到队日期’格式不正确!;";
	        			}
	        		}
	        	}
	        	cell = row.getCell((short)19);
	        	if(cell!=null){
	        		notes = cell.getStringCellValue();
	        	}
    			sb.append("insert into bgp_qua_monitor_equipment(monitor_id ,sort_id ,unite_code ,sort_code ,equip_name, model_code ,measure ,accurate ,")
    			.append("producor ,ident_code ,depart ,facilities ,status ,detect_depart ,detect_cycle ,detect_date ,valid_date ,detect_result ,")
    			.append("abc ,spare1 ,notes ,project_info_no ,org_id ,org_subjection_id ,bsflag ,creator_id ,create_date ,updator_id ,modifi_date)") 
    			.append("values((select lower(sys_guid()) from dual),'").append(sort_id).append("' ,'").append(unite_code).append("' ,")
    			.append("'").append(sort_code).append("','").append(equip_name).append("','").append(model_code).append("','").append(measure).append("',")
    			.append("'").append(accurate).append("','").append(producor).append("','").append(ident_code).append("','").append(depart).append("',")
    			.append("'").append(facilities).append("','").append(status).append("','").append(detect_depart).append("','").append(detect_cycle).append("',")
    			.append(" to_date('").append(detect_date).append("','yyyy-MM-dd'),to_date('").append(valid_date).append("','yyyy-MM-dd'),'").append(detect_result).append("',")
    			.append("'").append(abc).append("','").append(spare1).append("','").append(notes).append("','").append(project_info_no).append("',")
    			.append("'").append(org_id).append("','").append(org_subjection_id).append("','0','").append(user_id).append("',")
    			.append("sysdate,'").append(user_id).append("',sysdate);");
	        }
		}
		String file_id = jdbcDao.generateUUID();
		if(message!=null && message.trim().equals("")){
			message = "导入成功!";
			saveQualityBySql(sb.toString());
		}
		responseDTO.setValue("message", message);
		return responseDTO;

	}
	
	public static Map getOrgName(String org_id) throws Exception{
		StringBuffer sb = new StringBuffer();
		sb.append("select org_abbreviation org_name  from comm_org_information t where t.bsflag ='0' and t.org_id='"+org_id+"'");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		return map;
	}
}
