package com.bgp.mcs.service.pm.service.project;

import java.io.Serializable;
import java.net.URLDecoder;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.srv.OPAutoUtil;
import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.util.ColumnDesp;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

public class ProjectSrv extends BaseService {
	
	private ILog log;
	private ProjectMCSBean projectMCSBean;
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	
	public ProjectSrv(){
		log = LogFactory.getLogger(ProjectSrv.class);
		projectMCSBean = (ProjectMCSBean) BeanFactory.getBean("ProjectMCSBean");
	}
	
	public ISrvMsg queryProject(ISrvMsg reqDTO) throws Exception{
	 
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
		String projectInfoNo = user.getProjectInfoNo();
		
		String isSingle = reqDTO.getValue("isSingle");
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (isSingle != null && !"".equals(isSingle)) {
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				return SrvMsgUtil.createResponseMsg(reqDTO);
			} else {
				map.put("projectInfoNo", projectInfoNo);
			}
		}
		String orgCode = user.getOrgCode();
		
		
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

		//如果funcode不为空,则执行过滤查询
		if(funcCode != "" && funcCode != null){
			page = projectMCSBean.quertProject(map, page,user,funcCode);
		}else{
			page = projectMCSBean.quertProject(map, page);
		}
		
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		if(page.getTotalRow()==0&&user.getOrgSubjectionId().startsWith("C105005001")){//处理新兴物探处
			msg.setValue("message", "noproject");
		}else{
			msg.setValue("message", "hasproject");
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
				//map.put("project_duration_date", days);
				map.put("project_duration_date", (days+1));//计算天数 fixed
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
		return msg;
	}
	
	public ISrvMsg addProject(ISrvMsg reqDTO) throws Exception{
		Map map = reqDTO.toMap();

		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		map.put("spare2", map.get("pro_id"));

		
		String[] key = {"project_name","notes","processing_unit"};
		
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
			
//			Random r = new Random();
//			map.put("project_id", "newProj_"+r.nextInt());//先随机给个id 从erp获取后再更新过去
//			
			flag = true; 
		}
		
		String org_id = (String) map.get("org_id");
		List list = jdbcDao.queryRecords("select org_subjection_id from comm_org_subjection where org_id = '"+org_id+"' and bsflag = '0' ");
		if (list != null && list.size() != 0) {
			Map map1 = (Map) list.get(0);
			map.put("org_subjection_id", map1.get("orgSubjectionId"));
		}
		
		Serializable project_info_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT");
		
		String exploration_method = (String) map.get("exploration_method");
		
		map.put("project_info_no", project_info_no.toString());
 
		
		String workload = (String) map.get("workload");
		if ("2".equals(workload)) {
			map.put("design_object_workload", map.get("design_workload2"));
	 
		} else {
			map.put("design_object_workload", map.get("design_workload1"));
		}
		
		if ("0300100012000000002".equals(exploration_method)) {
			//2维
			map.put("line_num", map.get("design_line_num"));
			map.put("total_len", map.get("design_workload2"));//设计工作量
			map.put("full_fold_len", map.get("design_workload1"));//设计试验炮
			map.put("design_shot_num", map.get("design_sp_num"));
			map.put("notes", map.get("notes"));
			list = jdbcDao.queryRecords("select wa2d_no from gp_ops_2dwa_design_basic_data where project_info_no = '"+project_info_no.toString()+"' and bsflag = '0' ");
			if (list != null && list.size() != 0) {
				Map map1 = (Map) list.get(0);
				map.put("wa2d_no", map1.get("wa2dNo"));
			}
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_2dwa_design_basic_data");
			
		} else {
			map.put("line_group_num", map.get("design_line_num"));
			map.put("actual_fullfold_area", map.get("design_workload2"));//设计工作量
			map.put("design_fullfold_area", map.get("design_workload1"));//设计试验炮
			map.put("design_shot_num", map.get("design_sp_num"));
			map.put("receiveing_point_num", map.get("design_geophone_num"));
			map.put("notes", map.get("notes"));
			list = jdbcDao.queryRecords("select wa3d_no from gp_ops_3dwa_design_data where project_info_no = '"+project_info_no.toString()+"' and bsflag = '0' ");
			if (list != null && list.size() != 0) {
				Map map1 = (Map) list.get(0);
				map.put("wa3d_no", map1.get("wa3dNo"));
			}
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_3dwa_design_data");
		}
		
		
		Serializable project_dynamic_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT_DYNAMIC");
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_bgp_report");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		/*if (flag) {
			//scom.bgp.mcs.service.pm.service.p6.project.ProjectWSBean pp = new com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean();
			//改为审批通过以后再同步至P6
			//pp.createProjectByTemp(map, (String) map.get("org_subjection_id"), user);
		} else {
			//com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean pp = new com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean();
			//pp.saveOrUpdateP6ProjectToMCS(projects, user);
		}*/
		
		if (flag) {
			//创建项目的文档结构
			MyUcm m = new MyUcm();
			m.createProjectFolderNew(project_info_no.toString(), (String)map.get("project_name"), user.getUserId(), user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(),(String)map.get("project_type"));
		}
		
		
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
			//吴海军 添加项目施工队伍
			msg.setValue("teamOrgId", (String) map.get("org_id"));
			//吴海军 添加项目常规和非常规信息
			msg.setValue("projectCommon", (String) map.get("project_common"));
			
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
		String sql = "update gp_task_project set bsflag = '1' where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		
		jdbcTemplate.execute(sql);
		
		//删除gp_task_project_dy表数据
		String dy_sql = "update gp_task_project_dynamic set bsflag = '1' where project_info_no in ( ";
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
	 * 滩浅海项目信息保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addTqhProject(ISrvMsg reqDTO) throws Exception{
		Map map = reqDTO.toMap();
		
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		
		String[] key = {"project_name","notes","processing_unit"};
		
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
//			Random r = new Random();
//			map.put("project_id", "newProj_"+r.nextInt());//先随机给个id 从erp获取后再更新过去
			flag = true;
		}
		
		String org_id = (String) map.get("org_id");
		List list = jdbcDao.queryRecords("select org_subjection_id from comm_org_subjection where org_id = '"+org_id+"' and bsflag = '0' ");
		if (list != null && list.size() != 0) {
			Map map1 = (Map) list.get(0);
			map.put("org_subjection_id", map1.get("orgSubjectionId"));
		}
		
		Serializable project_info_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT");
		
		String exploration_method = (String) map.get("exploration_method");
		
		map.put("project_info_no", project_info_no.toString());
		map.put("notes", null);
		if ("0300100012000000002".equals(exploration_method)) {//2维
			map.put("line_num", map.get("design_line_num"));
			map.put("total_len", map.get("design_object_workload"));//设计工作量
			map.put("full_fold_len", map.get("full_fold_workload2"));//设计试验炮
			list = jdbcDao.queryRecords("select wa2d_no from gp_ops_2dwa_design_basic_data where project_info_no = '"+project_info_no.toString()+"' and bsflag = '0' ");
			if (list != null && list.size() != 0) {
				Map map1 = (Map) list.get(0);
				map.put("wa2d_no", map1.get("wa2dNo"));
			}
			map.remove("exploration_method");
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_2dwa_design_basic_data");
			map.put("exploration_method", "0300100012000000002");
		}
		if ("0300100012000000003".equals(exploration_method)){//3维
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
			map.remove("exploration_method");
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_3dwa_design_data");
			map.put("exploration_method", "0300100012000000003");
		}
		
		Serializable project_dynamic_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT_DYNAMIC");
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_bgp_report");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (flag) {
			//创建项目的文档结构 
			MyUcm m = new MyUcm();
			m.createProjectFolderNew(project_info_no.toString(), (String)map.get("project_name"), user.getUserId(), user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(),(String)map.get("project_type"));
		}
		
		msg.setValue("message", "success");
		return msg;
	}
	
	/**
	 * 验证项目下面是否有子项目
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg validateProject(ISrvMsg reqDTO) throws Exception{
		String project_info_no = reqDTO.getValue("project_info_no");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		List list = jdbcDao.queryRecords("select * from gp_task_project where project_father_no = '"+project_info_no+"' and bsflag = '0' ");
		msg.setValue("num", list.size());
		return msg;
	}
	
}
