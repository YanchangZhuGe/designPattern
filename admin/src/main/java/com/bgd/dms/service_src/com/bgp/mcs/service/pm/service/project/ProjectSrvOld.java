package com.bgp.mcs.service.pm.service.project;

import java.io.Serializable;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 三期迁移的ProjectSrv类  修改名字为 ProjectSrvOld
 * @author bianshen
 *
 */
public class ProjectSrvOld extends BaseService {
	
	private ILog log;
	private ProjectMCSBean projectMCSBean;
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao updateDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	public ProjectSrvOld(){
		log = LogFactory.getLogger(ProjectSrvOld.class);
		projectMCSBean = (ProjectMCSBean) BeanFactory.getBean("ProjectMCSBean");
	}
	
	public ISrvMsg queryProject(ISrvMsg reqDTO) throws Exception{
		
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectName = reqDTO.getValue("projectName");
		String projectId = reqDTO.getValue("projectId");
		String projectType = reqDTO.getValue("projectType");
		String projectYear = reqDTO.getValue("projectYear");
		String isMainProject = reqDTO.getValue("isMainProject");
		String projectStatus = reqDTO.getValue("projectStatus");
		String orgName = reqDTO.getValue("orgName");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String explorationMethod = reqDTO.getValue("explorationMethod");
		String projectArea = reqDTO.getValue("projectArea");
		
		String funcCode = reqDTO.getValue("funcCode");
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo ="";
		String userOrgsubjectionId = "";
		if(user!=null){
			projectInfoNo = user.getProjectInfoNo();
			userOrgsubjectionId = user.getOrgSubjectionId();
		}
		
		
		String isSingle = reqDTO.getValue("isSingle");
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (isSingle != null && !"".equals(isSingle)) {
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				return SrvMsgUtil.createResponseMsg(reqDTO);
			} else {
				map.put("projectInfoNo", projectInfoNo);
			}
		}
		
		Map map1 = reqDTO.toMap();
		
		
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
		
		
		map.put("projectName", projectName);
		map.put("projectId", projectId);
		map.put("projectType", projectType);
		map.put("projectYear", projectYear);
		map.put("isMainProject", isMainProject);
		map.put("projectStatus", projectStatus);
		map.put("orgName", orgName);
		map.put("orgSubjectionId", orgSubjectionId);
		map.put("explorationMethod", explorationMethod);
		map.put("projectArea", projectArea);
		map.put("projectManId",user.getUserId());
		//如果funcode不为空,则执行过滤查询
		if(funcCode != "" && funcCode != null){
			page = projectMCSBean.quertProject(map, page,user,funcCode);
		}else{
			page = projectMCSBean.quertProject(map, page);
		}
		List<Map> list = page.getData();
		
		String empId = user.getEmpId();
		
		String rolesql = " SELECT usro.* FROM  p_auth_user us"
				+ " JOIN P_auth_user_role usro "
				+ " ON us.USER_ID = usro.USER_ID "
				+ " AND us.bsflag='0' "
				+ " AND us.EMP_ID='"+empId+"' ";
		
		List<Map> roleList = jdbcDao.queryRecords(rolesql);
		if(roleList!=null&&roleList.size()!=0){
			for(int r=0;r<roleList.size();r++){
				String roleId =  roleList.get(r).get("roleId").toString();
				if(roleId.equals("8ad882714a93a29b014a951b72310520")||roleId.equals("8ad882714c680632014c685c2731038b")||roleId.equals("8ad882714c680632014c685c5d1d038c")){
					//人员调配 信息主任 信息录入
					if(list!=null&&list.size()!=0){
						List listRet = new ArrayList();
						for(int i=0;i<list.size();i++){
							String org_name = "";
							Map map22 = list.get(i);
							String org_id_arr = map22.get("org_id22").toString();
							String[] orgArr = org_id_arr.split(",");
							for(int ii=0;ii<orgArr.length;ii++){
								String org_id = orgArr[ii];
								String sql_in_for = " select * from COMM_ORG_INFORMATION where ORG_ID='"+org_id+"' and bsflag='0' ";
								Map map_in_for = jdbcDao.queryRecordBySQL(sql_in_for);
								String org_name_in_for = map_in_for.get("orgAbbreviation").toString();
								org_name+=org_name_in_for+",";
							}
							map22.put("org_name", org_name);
							
							String businessType = map22.get("project_business_type").toString();
							if(!businessType.equals("5000100011000000001@")){//采集项目需要过滤掉
								listRet.add(map22);
							}
						}
						
						page.setData(listRet);
						msg.setValue("datas", page.getData());
						msg.setValue("totalRows", page.getTotalRow());
						msg.setValue("pageSize", pageSize);
					}
				}else if(roleId.equals("8ad882714cd99a1a014cdb620fd5205d")){
					//处理解释岗
					if(list!=null&&list.size()!=0){
						List listRet = new ArrayList();
						for(int i=0;i<list.size();i++){
							String org_name = "";
							Map map22 = list.get(i);
							String org_id_arr = map22.get("org_id22").toString();
							String[] orgArr = org_id_arr.split(",");
							for(int ii=0;ii<orgArr.length;ii++){
								String org_id = orgArr[ii];
								String sql_in_for = " select * from COMM_ORG_INFORMATION where ORG_ID='"+org_id+"' and bsflag='0' ";
								Map map_in_for = jdbcDao.queryRecordBySQL(sql_in_for);
								String org_name_in_for = map_in_for.get("orgAbbreviation").toString();
								org_name+=org_name_in_for+",";
							}
							map22.put("org_name", org_name);
							
							
							String sqltt = " SELECT * FROM gp_ops_prointe_projperson_wt wt "
									+ " JOIN gp_task_project gp "
									+ " ON gp.project_info_no=wt.project_info_no "
									+ " AND wt.PERSONNEL_ID='"+empId+"' "
									+ " AND wt.bsflag='0' AND gp.bsflag='0' ";
							List<Map> listtt = jdbcDao.queryRecords(sqltt);
							
							String project_info_no1 = map22.get("project_info_no").toString();
							for(int t=0;t<listtt.size();t++){
								String project_info_no2 = listtt.get(t).get("projectInfoNo").toString();
								if(project_info_no2.equals(project_info_no1)){
									listRet.add(map22);
								}
							}
						}
						
						page.setData(listRet);
						msg.setValue("datas", page.getData());
						msg.setValue("totalRows", page.getTotalRow());
						msg.setValue("pageSize", pageSize);
					}
				}else{
					if(list!=null&&list.size()!=0){
						List listRet = new ArrayList();
						for(int i=0;i<list.size();i++){
							String org_name = "";
							Map map22 = list.get(i);
							String org_id_arr = map22.get("org_id22").toString();
							String[] orgArr = org_id_arr.split(",");
							for(int ii=0;ii<orgArr.length;ii++){
								String org_id = orgArr[ii];
								String sql_in_for = " select * from COMM_ORG_INFORMATION where ORG_ID='"+org_id+"' and bsflag='0' ";
								Map map_in_for = jdbcDao.queryRecordBySQL(sql_in_for);
								String org_name_in_for = map_in_for.get("orgAbbreviation").toString();
								org_name+=org_name_in_for+",";
							}
							map22.put("org_name", org_name);
							listRet.add(map22);
						}
						
						page.setData(listRet);
						msg.setValue("datas", page.getData());
						msg.setValue("totalRows", page.getTotalRow());
						msg.setValue("pageSize", pageSize);
					}
				}
			}
		}
		return msg;
	}
	
	public ISrvMsg getProjectInfo(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("projectInfoNo", projectInfoNo);
		
		PageModel page = new PageModel();
		page = projectMCSBean.quertProject(map, page);
		
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			Map dateMap = projectMCSBean.getProjectDate(projectInfoNo);
			if(dateMap != null){
				String start_date = dateMap.get("project_plan_start_date") != null ? dateMap.get("project_plan_start_date").toString() : "";
				String end_date = dateMap.get("project_plan_finish_date") != null ? dateMap.get("project_plan_finish_date").toString() : "";

				map.put("project_design_start_date", start_date);
				map.put("project_design_end_date", end_date);
				long days = 0;
				if(start_date != "" && end_date != ""){
					days = DateOperation.diffDaysOfDate(end_date,start_date);
				}
				map.put("project_duration_date", days);
			}
			
			msg.setValue("map", map);
		}
		
		map = new HashMap<String, Object>();
		
		map.put("projectInfoNo", projectInfoNo);
		
		page = projectMCSBean.quertProjectDynamic(map, page);
		list = page.getData();
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			msg.setValue("dynamicMap", map);
		}
		
		page = projectMCSBean.quertBgpReport(map, page);
		list = page.getData();
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			msg.setValue("bgpMap", map);
		}
		
		List<Map> list_log = jdbcDao.queryRecords("select * from comm_task_log_info where bill_id='"+projectInfoNo+"' and bsflag='0'");
		if(list_log!=null&&list_log.size()!=0){
			String taskLogId = list_log.get(0).get("taskLogId").toString();
			msg.setValue("task_log_id", taskLogId);
		}
		return msg;
	}
	
	public ISrvMsg addProject(ISrvMsg reqDTO) throws Exception{
		
		Map map = reqDTO.toMap();
		
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		
		String[] key = {"project_name","notes","processing_unit","vsp_team_leader"};
		
		String temp = "";
		
		for (int i = 0; i < key.length; i++) {
			temp = (String) map.get(key[i]);
			if (temp != null && !"".equals(temp)) {
				map.put(key[i], URLDecoder.decode(temp,"UTF-8"));
			}
		}
		
		String projectInfoNo = reqDTO.getValue("project_info_no");
		boolean flag = false;
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			//如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
			
			//Random r = new Random();
			//map.put("project_id", "newProj_"+r.nextInt());//先随机给个id 从erp获取后再更新过去
			
			flag = true;
		}
		
		String org_id = (String) map.get("org_id");
		List list = jdbcDao.queryRecords("select org_subjection_id from comm_org_subjection where org_id = '"+org_id+"' and bsflag = '0' ");
		if (list != null && list.size() != 0) {
			Map map1 = (Map) list.get(0);
			map.put("org_subjection_id", map1.get("orgSubjectionId"));
		}
		
		Serializable project_info_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT");
		reqDTO.setValue("project_info_no", project_info_no);
		String notes = (String) map.get("notes");
		String exploration_method = (String) map.get("exploration_method");
		
		map.put("project_info_no", project_info_no.toString());
		map.put("notes", null);
		
		String workload = (String) map.get("workload");
		if ("2".equals(workload)) {
			map.put("design_object_workload", map.get("design_workload2"));
		} else {
			map.put("design_object_workload", map.get("design_workload1"));
		}
		
		if ("0300100012000000002".equals(exploration_method)) {
			//2维
			map.put("line_num", map.get("design_line_num"));
			map.put("total_len", map.get("design_object_workload"));//设计工作量
			map.put("full_fold_len", map.get("full_fold_workload"));//设计试验炮
			
			list = jdbcDao.queryRecords("select wa2d_no from gp_ops_2dwa_design_basic_data where project_info_no = '"+project_info_no.toString()+"' and bsflag = '0' ");
			if (list != null && list.size() != 0) {
				Map map1 = (Map) list.get(0);
				map.put("wa2d_no", map1.get("wa2dNo"));
			}
			map.put("create_date", new Date());
			map.put("creator", user.getUserId());
			map.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_2dwa_design_basic_data");
			
		} else {
			map.put("line_group_num", map.get("design_line_num"));
			map.put("actual_fullfold_area", map.get("design_object_workload"));//设计工作量
			map.put("design_fullfold_area", map.get("full_fold_workload"));//设计试验炮
			map.put("design_shot_num", map.get("design_sp_num"));
			map.put("receiveing_point_num", map.get("design_geophone_num"));
			
			list = jdbcDao.queryRecords("select wa3d_no from gp_ops_3dwa_design_data where project_info_no = '"+project_info_no.toString()+"' and bsflag = '0' ");
			if (list != null && list.size() != 0) {
				Map map1 = (Map) list.get(0);
				map.put("wa3d_no", map1.get("wa3dNo"));
			}
			map.put("create_date", new Date());
			map.put("creator", user.getUserId());
			map.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_3dwa_design_data");
		}
		
		
		Serializable project_dynamic_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT_DYNAMIC");
		reqDTO.setValue("project_dynamic_no", project_dynamic_no);
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_bgp_report");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		//if (flag) {
			//com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean pp = new com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean();
			//改为审批通过以后再同步至P6
			//pp.createProjectByTemp(map, (String) map.get("org_subjection_id"), user);
		//} else {
			//com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean pp = new com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean();
			//pp.saveOrUpdateP6ProjectToMCS(projects, user);
		//}
		
		if (flag) {
			//创建项目的文档结构
			MyUcm m = new MyUcm();
			m.createProjectFolderNew(project_info_no.toString(), (String)map.get("project_name"), user.getUserId(), user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg());
		}
		
		//赵学良添加  更新项目信息的同时更新项目进度计划表里的数据
		
		if(projectInfoNo != null && projectInfoNo != ""){
			StringBuilder updateProjectPlanSql = new StringBuilder("update bgp_pm_project_plan p set");
			if("0300100012000000002".equals(exploration_method)){
						if(map.get("line_num") != null && map.get("line_num") != "")
						{
							updateProjectPlanSql.append(" p.design_line_num = to_number("+map.get("line_num")+"),");
						}
						if(map.get("total_len") != null && map.get("total_len") != "")
						{
							updateProjectPlanSql.append(" p.design_object_workload = to_number("+map.get("total_len")+"),");
						}
						if(map.get("design_sp_num") != null && map.get("design_sp_num") != "")
						{
							updateProjectPlanSql.append(" p.design_sp_num = to_number("+map.get("design_sp_num")+"),");
						}
						if(map.get("design_geophone_num") != null && map.get("design_geophone_num") != "")
						{
							updateProjectPlanSql.append(" p.design_geophone_num = to_number("+map.get("design_geophone_num")+") ,");
						}
						if(map.get("design_small_regraction_num") != null && map.get("design_small_regraction_num") != "")
						{
							updateProjectPlanSql.append(" p.design_small_regraction_num = to_number("+map.get("design_small_regraction_num")+"), ");
						}
						if(map.get("design_micro_measue_num") != null && map.get("design_micro_measue_num") != "")
						{
							updateProjectPlanSql.append(" p.design_micro_measue_num = to_number("+map.get("design_micro_measue_num")+"),");
						}
						if(map.get("design_drill_num") != null && map.get("design_drill_num") != "")
						{
							updateProjectPlanSql.append(" p.design_drill_num = to_number("+map.get("design_drill_num")+"),");
						}
						if(map.get("design_sp_num_zy") != null && map.get("design_sp_num_zy") != "")
						{
							updateProjectPlanSql.append(" p.design_sp_num_zy = to_number("+map.get("design_sp_num_zy")+"),");
						}
						if(map.get("design_geophone_area") != null && map.get("design_geophone_area") != "")
						{
							updateProjectPlanSql.append(" p.design_geophone_area = to_number("+map.get("design_geophone_area")+"),");
						}
						if(map.get("design_execution_area") != null && map.get("design_execution_area") != "")
						{
							updateProjectPlanSql.append(" p.design_execution_area = to_number("+map.get("design_execution_area")+"),");
						}
						if(map.get("design_data_area") != null && map.get("design_data_area") != "")
						{
							updateProjectPlanSql.append(" p.design_data_area = to_number("+map.get("design_data_area")+"),");
						}
						if(map.get("design_sp_area") != null && map.get("design_sp_area") != "")
						{
							updateProjectPlanSql.append(" p.design_sp_area = to_number("+map.get("design_sp_area")+"),");
						}
						updateProjectPlanSql.append(" p.notes = '" +notes+"'");
						updateProjectPlanSql.append(" where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'");
				}else{
						if(map.get("line_group_num") != null && map.get("line_group_num") != "")
						{
							updateProjectPlanSql.append(" p.design_line_num = to_number("+map.get("line_group_num")+"),");
						}
						if(map.get("actual_fullfold_area") != null && map.get("actual_fullfold_area") != "")
						{
							updateProjectPlanSql.append(" p.design_object_workload = to_number("+map.get("actual_fullfold_area")+"),");
						}
						if(map.get("design_shot_num") != null && map.get("design_shot_num") != "")
						{
							updateProjectPlanSql.append(" p.design_sp_num = to_number("+map.get("design_shot_num")+"),");
						}
						if(map.get("design_geophone_num") != null && map.get("design_geophone_num") != "")
						{
							updateProjectPlanSql.append(" p.design_geophone_num = to_number("+map.get("design_geophone_num")+") ,");
						}
						if(map.get("design_small_regraction_num") != null && map.get("design_small_regraction_num") != "")
						{
							updateProjectPlanSql.append(" p.design_small_regraction_num = to_number("+map.get("design_small_regraction_num")+"), ");
						}
						if(map.get("design_micro_measue_num") != null && map.get("design_micro_measue_num") != "")
						{
							updateProjectPlanSql.append(" p.design_micro_measue_num = to_number("+map.get("design_micro_measue_num")+"),");
						}
						if(map.get("design_drill_num") != null && map.get("design_drill_num") != "")
						{
							updateProjectPlanSql.append(" p.design_drill_num = to_number("+map.get("design_drill_num")+"),");
						}
						if(map.get("design_sp_num_zy") != null && map.get("design_sp_num_zy") != "")
						{
							updateProjectPlanSql.append(" p.design_sp_num_zy = to_number("+map.get("design_sp_num_zy")+"),");
						}
						if(map.get("design_geophone_area") != null && map.get("design_geophone_area") != "")
						{
							updateProjectPlanSql.append(" p.design_geophone_area = to_number("+map.get("design_geophone_area")+"),");
						}
						if(map.get("design_execution_area") != null && map.get("design_execution_area") != "")
						{
							updateProjectPlanSql.append(" p.design_execution_area = to_number("+map.get("design_execution_area")+"),");
						}
						if(map.get("design_data_area") != null && map.get("design_data_area") != "")
						{
							updateProjectPlanSql.append(" p.design_data_area = to_number("+map.get("design_data_area")+"),");
						}
						if(map.get("design_sp_area") != null && map.get("design_sp_area") != "")
						{
							updateProjectPlanSql.append(" p.design_sp_area = to_number("+map.get("design_sp_area")+"),");
						}
						updateProjectPlanSql.append(" p.notes = '" +notes+"'");
						updateProjectPlanSql.append(" where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'");
			}
			updateDao.executeUpdate(updateProjectPlanSql.toString());
		}
		//更新项目信息的时候检查是否需要更新rpt_gp_daily表里面的 采集开始时间和采集结束时间
		if(projectInfoNo != null && projectInfoNo != ""){
			String countSql = " select * from rpt_gp_daily where project_info_no ='"+projectInfoNo+"'";
			List<Map> list_rpt = jdbcDao.queryRecords(countSql);
			if(list_rpt!=null&&list_rpt.size()!=0){
				String updateSql = " update rpt_gp_daily set acquire_start_time = to_date('"+map.get("acquire_start_time").toString()+"','yyyy-MM-dd'),"
						+ " acquire_end_time = to_date('"+map.get("acquire_end_time").toString()+"','yyyy-MM-dd')"
						+ " where project_info_no ='"+projectInfoNo+"' and bsflag='0' ";
				updateDao.executeUpdate(updateSql);
			}
		}
		this.saveLog(reqDTO);
		msg.setValue("message", "success");
		
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg selectProject(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String userId = user.getUserId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("projectInfoNo", projectInfoNo);
		
		PageModel page = new PageModel();
		page = projectMCSBean.quertProject(map, page);
		
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			msg.setValue("projectInfoNo", (String) map.get("project_info_no"));
			msg.setValue("projectName", (String) map.get("project_name"));
			msg.setValue("explorationMethod", (String) map.get("exploration_method"));
			msg.setValue("projectId", (String) map.get("project_id"));
			msg.setValue("projectObjectId", (String) map.get("project_object_id"));
			//吴海军添加项目类型
			msg.setValue("projectType", (String) map.get("project_type"));
			
			//查询是否已有选择的项目
			String checkChoosenProject = "select cp.bgp_pm_choosen_project_id,cp.project_info_no from BGP_PM_CHOOSEN_PROJECT cp where cp.bsflag = '0' and cp.user_id = '"+userId+"'";
			Map choosenProjectMap = jdbcDao.queryRecordBySQL(checkChoosenProject);
			//已有选择的项目
			if(choosenProjectMap != null){
				String choosenProjectInfoNo = choosenProjectMap.get("projectInfoNo").toString();
				if(choosenProjectInfoNo != "" && !choosenProjectInfoNo.equals(projectInfoNo)){
					//选择了不同的项目,获取主键,更新数据
					String choosen_id = choosenProjectMap.get("bgpPmChoosenProjectId").toString();
					Map updateChoosenProject = new HashMap();
					updateChoosenProject.put("bgp_pm_choosen_project_id", choosen_id);
					updateChoosenProject.put("project_info_no", projectInfoNo);
					updateChoosenProject.put("user_id", user.getUserId());
					updateChoosenProject.put("bsflag", "0");
					updateChoosenProject.put("create_date", new Date());
					updateChoosenProject.put("modifi_date", new Date());
					updateChoosenProject.put("creator_id", user.getUserId());
					updateChoosenProject.put("updator_id", user.getUserId());
					updateChoosenProject.put("org_id", user.getCodeAffordOrgID());
					updateChoosenProject.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(updateChoosenProject,"bgp_pm_choosen_project");
				}
			}
			//没有选择的项目,插入数据
			else{
				Map addChoosenProject = new HashMap();
				addChoosenProject.put("project_info_no", projectInfoNo);
				addChoosenProject.put("user_id", user.getUserId());
				addChoosenProject.put("bsflag", "0");
				addChoosenProject.put("create_date", new Date());
				addChoosenProject.put("modifi_date", new Date());
				addChoosenProject.put("creator_id", user.getUserId());
				addChoosenProject.put("updator_id", user.getUserId());
				addChoosenProject.put("org_id", user.getCodeAffordOrgID());
				addChoosenProject.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(addChoosenProject,"bgp_pm_choosen_project");
			}
			
		}

		return msg;
	}
	
	public ISrvMsg deleteProject(ISrvMsg reqDTO) throws Exception{
		
		String ids = reqDTO.getValue("projectInfoNos");
		String[] projectInfoNos = ids.split(",");
		//删除gp_task_project表数据
		String sql = "update gp_task_project set bsflag = '1', modifi_date = sysdate where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		
		jdbcTemplate.execute(sql);
		
		//删除gp_task_project_dy表数据
		String dy_sql = "update gp_task_project_dynamic set bsflag = '1', modifi_date = sysdate where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			dy_sql += "'"+projectInfoNos[i] +"',";
		}
		dy_sql = dy_sql.substring(0, dy_sql.lastIndexOf(","));
		dy_sql += ")";
		
		jdbcTemplate.execute(dy_sql);
		
		//删除bgp_doc_gms_file表数据
		String doc_sql = "update bgp_doc_gms_file set bsflag = '1' where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			doc_sql += "'"+projectInfoNos[i] +"',";
		}
		doc_sql = doc_sql.substring(0, doc_sql.lastIndexOf(","));
		doc_sql += ")";
		
		jdbcTemplate.execute(doc_sql);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		return msg;
	}
	
	public ISrvMsg getQuality(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String sql = "select * from bgp_pm_quality_index where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ";
		
		Map map = jdbcDao.queryRecordBySQL(sql);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("qualityMap", map);
		
		return msg;
	}

	public ISrvMsg saveOrUpdateQuality(ISrvMsg reqDTO) throws Exception{
		
		Map map = reqDTO.toMap();
		
		//String projectInfoNo = reqDTO.getValue("project_info_no2");
		
		//map.put("project_info_no", projectInfoNo);
		
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator_id", user.getEmpId());
		map.put("modifi_date", new Date());
		
		String orbject_id = reqDTO.getValue("object_id");
		if (orbject_id == null || "".equals(orbject_id)) {
			//如果为空 则添加创建人
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
		}
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_PM_QUALITY_INDEX");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("message", "success");
		
		return msg;
	}
	
	/**
	 * 查询甲方单位
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getManageOrgName(ISrvMsg reqDTO) throws Exception{
		
		String manageOrgName = reqDTO.getValue("manageOrgName");
		
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
		
		page = this.queryManageOrgName(manageOrgName, page);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		return msg;
	}
	
	public PageModel queryManageOrgName(String orgName, PageModel page){
		
		String sql = "select d.coding_code_id as org_id,d.coding_name as org_name,d1.coding_name as parent_org_name from comm_coding_sort_detail d " +
	     " join comm_coding_sort_detail d1 on d.superior_code_id = d1.coding_code_id and d1.bsflag = '0' " +
	     " where d.bsflag = '0' and d.coding_sort_id = '0100100014'";		
		if(orgName != "" && orgName != null){
			sql += " and d.coding_name like '%"+orgName+"%'";
		}else{
			sql += " and d.coding_name like ''";
		}
		
		log.debug("查询sql:"+sql);
		return jdbcDao.queryRecordsBySQL(sql, page);
	}
	
	/**
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg countTable(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql_temp = " select project_info_no from gp_task_project where project_status in('5000100001000000002','5000100001000000001') and bsflag='0' ";
		List list = jdbcDao.queryRecords(sql_temp);
		if(list!=null&&list.size()!=0){
			List listAdd = new ArrayList();
			for(int u=0;u<list.size();u++){
				Map mapCount = new HashMap();
				Map map_temp = (Map)list.get(u);
				String project_info_no = map_temp.get("projectInfoNo").toString();
				String sql_info = "  select  gp.project_name,dy.org_id,dy.org_subjection_id,wtc.org_abbreviation from " +
						" gp_task_project gp join gp_task_project_dynamic dy on gp.project_info_no=dy.project_info_no " +
						" and dy.org_id is not null and dy.org_subjection_id is not null join bgp_comm_org_wtc wtc on dy.org_subjection_id like '%'||wtc.org_subjection_id||'%' " +
						" where gp.project_info_no='" +project_info_no+"'";
				Map map_info = jdbcDao.queryRecordBySQL(sql_info);
				if(map_info==null||map_info.size()==0){
					continue;
				}
				mapCount.put("projectName", map_info.get("projectName").toString());
				mapCount.put("orgAbbreviation", map_info.get("orgAbbreviation").toString());
				String[] tableNames = new String[4];
				tableNames[0]="gp_task_project";
				tableNames[1]="gp_task_project_dynamic";
				tableNames[2]="gp_ops_2dwa_design_basic_data";
				tableNames[3]="gp_ops_3dwa_design_data";
				
				mapCount.put("total1", 0);
				mapCount.put("total2", 0);
				for(int i=0;i<tableNames.length;i++){
					String sql = " select * from "+tableNames[i]+" where project_info_no='"+project_info_no+"' and bsflag='0'";
					Map map = jdbcDao.queryRecordBySQL(sql);
					if(map==null||map.size()==0){//如果map为空 则根据条件查询不到数据  直接跳出循环下一个表
						continue;
					}
					mapCount.put("total1", Integer.parseInt(mapCount.get("total1").toString())+map.size());
					Object[] arry = map.keySet().toArray();
					for(int j=0;j<arry.length;j++){
						String key = arry[j].toString();
						Object val = map.get(key);
						if(val==null||((String)val).length()==0){
							map.remove(key);
						}
					}
					mapCount.put("total2", Integer.parseInt(mapCount.get("total2").toString())+map.size());
				}
				listAdd.add(mapCount);
			}
			msg.setValue("datas",listAdd);
		}
		
		return msg;
	}
	
	
	
	
	public ISrvMsg saveLog(ISrvMsg reqDTO) throws Exception{
		String project_dynamic_no = reqDTO.getValue("project_dynamic_no");
		String project_info_no = reqDTO.getValue("project_info_no");
		String del = reqDTO.getValue("del");
		List<Map> list_log = jdbcDao.queryRecords("select * from comm_task_log_info where bill_id ='"+project_info_no+"'");
		if(del!=null&&del.length()!=0){//如果是删除操作 需要逻辑删除
			if(list_log!=null&&list_log.size()!=0){
				Map map_log = list_log.get(0);
				if(map_log!=null&&map_log.size()!=0){
					String taskLogId = map_log.get("taskLogId").toString();
					Map map_tem = new HashMap();
					map_tem.put("task_log_id", taskLogId);
					map_tem.put("bsflag", "1");
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map_tem,"COMM_TASK_LOG_INFO");
				}
			}
		}else{
			if(list_log!=null&&list_log.size()!=0){
				Map map_log = list_log.get(0);
				if(map_log.size()!=0){
					String task_log_id = map_log.get("taskLogId").toString();
					String del_sql = " delete from comm_task_log_info where task_log_id='"+task_log_id+"'";
					jdbcTemplate.execute(del_sql);
				}
			}
		}
		
		List<Map> list_dy = jdbcDao.queryRecords("select * from gp_task_project_dynamic where project_dynamic_no ='"+project_dynamic_no+"' and bsflag='0'");
		List<Map> list_gp = jdbcDao.queryRecords("select * from gp_task_project where project_info_no ='"+project_info_no+"' and bsflag='0'");
		if(list_dy!=null&&list_dy.size()!=0&&list_gp!=null&&list_gp.size()!=0){
			Map dynamic = list_dy.get(0);
			Map project = list_gp.get(0);
			Map map_comm = new HashMap();
			map_comm.put("task_id", dynamic.get("projectDynamicNo").toString());
			map_comm.put("bill_id", dynamic.get("projectInfoNo").toString());
			map_comm.put("task_object_sort_id", "0100100016000000002");
			map_comm.put("task_object_name", project.get("projectName").toString());
			map_comm.put("object_id", project.get("projectId").toString());
			
			if(project.get("explorationMethod")==null){
				map_comm.put("task_code", null);
			}else if(project.get("explorationMethod").toString().equals("0300100012000000002")){
				map_comm.put("task_code", "0100100018000000012");
			}else{
				map_comm.put("task_code", "0100100018000000011");
			}
			
			if(project.get("projectStatus").toString()==null){
				map_comm.put("task_status", null);
			}else if(project.get("projectStatus").toString().equals("5000100001000000001")||project.get("projectStatus").toString().equals("5000100001000000002")||project.get("projectStatus").toString().equals("5000100001000000004")||project.get("projectStatus").toString().equals("5000100001000000005")){
				map_comm.put("task_status", "0100500005000000004");
			}else{
				map_comm.put("task_status", "0100500005000000006");
			}
			
			map_comm.put("market_classify", project.get("marketClassify").toString());
			
			String workarea_no = project.get("workareaNo").toString();
			if(workarea_no==null||workarea_no.length()==0){
				workarea_no = reqDTO.getValue("workarea_no");
			}
			if(workarea_no!=null&&workarea_no.length()!=0){
				List<Map> list_wn = jdbcDao.queryRecords(" select * from gp_workarea_diviede where workarea_no ='"+workarea_no+"' and bsflag='0' ");
				
				map_comm.put("block", list_wn.get(0).get("block").toString());
			}else{
				map_comm.put("block", null);
			}
			map_comm.put("real_start_date", project.get("acquireStartTime").toString());
			map_comm.put("real_end_date", project.get("acquireEndTime").toString());
			map_comm.put("org_id", dynamic.get("orgId").toString());
			if(dynamic.get("orgId")!=null&&dynamic.get("orgId").toString().length()!=0){
				String org_id_sql = dynamic.get("orgId").toString();
				List<Map> list_org = jdbcDao.queryRecords(" select * from comm_org_information where org_id ='"+org_id_sql+"' and bsflag='0' ");
				if(list_org!=null&&list_org.size()!=0){
					map_comm.put("execute_org_name", list_org.get(0).get("orgName").toString());
				}
			}
			map_comm.put("org_subjection_id", dynamic.get("orgSubjectionId").toString());
			Calendar cal = Calendar.getInstance();
			Date createDate = cal.getTime();
			map_comm.put("modifi_date", createDate);
			map_comm.put("bsflag", "0");
			map_comm.put("send_indicate", "0100100005000000004");
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map_comm,"COMM_TASK_LOG_INFO");
		}
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		responseMsg.setValue("message", "success");
		
		return responseMsg;
	}
	
	/**
	 * 判断是否可以修改项目状态
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg validateProjectSta(ISrvMsg reqDTO) throws Exception{
		String project_info_no = reqDTO.getValue("project_info_no");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "SELECT rpt.DAILY_NO,rpt.PROJECT_INFO_NO,sit.COLLECT_PROCESS_STATUS,sit.IF_BUILD FROM gp_ops_daily_report rpt JOIN GP_OPS_DAILY_PRODUCE_SIT sit"
				+ " ON  rpt.DAILY_NO=sit.DAILY_NO AND rpt.bsflag='0' AND sit.bsflag='0' AND sit.IF_BUILD='9' "
				+ " and PROJECT_INFO_NO='"+project_info_no+"' ";
		List<Map> list_dy = jdbcDao.queryRecords(sql);
		if(list_dy.size()>0){
			responseMsg.setValue("message", "y");			
		}else{
			responseMsg.setValue("message", "n");			
		}
		return responseMsg;
	}
}
