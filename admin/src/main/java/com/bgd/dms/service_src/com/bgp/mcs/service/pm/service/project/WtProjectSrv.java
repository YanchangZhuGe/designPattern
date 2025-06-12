package com.bgp.mcs.service.pm.service.project;

import java.io.Serializable;
import java.net.URLDecoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.xml.soap.SOAPException;

import org.springframework.jdbc.core.JdbcTemplate;

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
 * 综合物化探项目
 * @author zs
 *
 */
public class WtProjectSrv extends BaseService {
	private ILog log;
	private WtProjectMCSBean projectMCSBean;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	
	public WtProjectSrv(){
		log = LogFactory.getLogger(WtProjectMCSBean.class);
		projectMCSBean = (WtProjectMCSBean) BeanFactory.getBean("WtProjectMCSBean");
	}
	
	/**
	 * 查找项目列表信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
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
		String funcCode = reqDTO.getValue("funcCode");
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String projectFatherNo = reqDTO.getValue("projectFatherNo");
		String isSingle = reqDTO.getValue("isSingle");
		String viewType = reqDTO.getValue("viewType");
		String businessType = reqDTO.getValue("businessType");
		String secondMainProject = reqDTO.getValue("secondMainProject");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (isSingle != null && !"".equals(isSingle)) {
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				return SrvMsgUtil.createResponseMsg(reqDTO);
			} else {
				map.put("projectInfoNo", projectInfoNo);
			}
		}
		
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
		map.put("projectFatherNo",projectFatherNo);
		map.put("viewType",viewType);
		map.put("businessType",businessType);
		map.put("secondMainProject",secondMainProject);

		
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
		return msg;
	}
	
	/**
	 * 得到一条项目信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectInfo(ISrvMsg reqDTO) throws Exception{
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectFatherNo = reqDTO.getValue("projectFatherNo");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectInfoNo", projectInfoNo);
		map.put("projectFatherNo", projectFatherNo);
		PageModel page = new PageModel();
		page = projectMCSBean.quertProject(map, page);
		List list = page.getData();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			msg.setValue("map", map);
		}
		map = new HashMap<String, Object>();
		map.put("projectInfoNo", projectInfoNo);
		page = projectMCSBean.quertProjectDynamic(map, page);
		list = page.getData();
		String methodIds="";
		
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			if(null!=map.get("exploration_method")&&""!=map.get("exploration_method")){
				String[] methodId=map.get("exploration_method").toString().split(",");
				
				for(int i=0;i<methodId.length;i++){
					if(i==(methodId.length)-1){
						methodIds+="'"+methodId[i]+"'";
					}else{
						methodIds+="'"+methodId[i]+"',";
					}
				}
				//查找勘探方法名称methodIds可为多值，用','隔开 '0300100014000000017','0300100014000000018'。返回XXXXX,XXXXXXXX
				page = projectMCSBean.getExplorationMethodNames(methodIds,page);
				list = page.getData();
				if (list != null && list.size() != 0) {
					Map map1 =(Map)list.get(0);
					map.put("exploration_method_name",map1.get("coding_name"));
				}
			}
			
			if(null!=map.get("org_id")&&""!=map.get("org_id")){
				String[] orgId=map.get("org_id").toString().split(",");
				String orgIds="";
				for(int i=0;i<orgId.length;i++){
					if(i==(orgId.length)-1){
						orgIds+="'"+orgId[i]+"'";
					}else{
						orgIds+="'"+orgId[i]+"',";
					}
				}
				//查找施工队伍名称 orgIds可为多值，用','隔开 'C6000000007066','C6000000000014','C6000000000008'。返回XXXXX,XXXXX,XXXXXXX
				page = projectMCSBean.getDynamicOrgNames(orgIds,page);
				list = page.getData();
				if (list != null && list.size() != 0) {
					Map map1 =(Map)list.get(0);
					map.put("org_name",map1.get("org_name"));
				}
				msg.setValue("dynamicMap", map);
			}
		}
		
		page = projectMCSBean.quertBgpReport(map, page);
		list = page.getData();
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			msg.setValue("bgpMap", map);
		}
		page = projectMCSBean.quertWorkLoad(map, page,methodIds);//查找工作量信息
		list = page.getData();
		msg.setValue("workloadMap",list);
		page = projectMCSBean.quertQuality(map, page,methodIds);//查找质量指标信息
		list = page.getData();
		msg.setValue("qualityMap",list);
		page = projectMCSBean.quertDegree(map, page,methodIds); //项目以往勘探程度
		list = page.getData();
		msg.setValue("degreeMap",list);
		return msg;
	}
	
	/**
	 * 删除项目信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteProject(ISrvMsg reqDTO) throws Exception{
		String ids = reqDTO.getValue("projectInfoNos");
		String[] projectInfoNos = ids.split(",");
		//删除项目信息
		String sql = "update gp_task_project set bsflag = '1' where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		jdbcTemplate.execute(sql);
		
		sql = "update gp_task_project_dynamic set bsflag = '1' where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		jdbcTemplate.execute(sql);
		
		
		//删除周报 年报信息
		sql = "update bgp_ws_daily_report set bsflag = '1' where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		jdbcTemplate.execute(sql);
		
		
		//删除立项审批流信息
		sql = " delete from wf_r_examineinst where procinst_id in (select proc_inst_id from common_busi_wf_middle where business_id in  ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ") and busi_table_name ='gp_task_project' and bsflag='0' and business_type='5110000004100001003' )";
		jdbcTemplate.execute(sql);
		
		sql = " update common_busi_wf_middle set  bsflag = '1' where business_id in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ") and busi_table_name ='gp_task_project' and bsflag='0' and business_type='5110000004100001003'  ";
		jdbcTemplate.execute(sql);
		
		
		//删除文档审批流信息
		
		sql = " delete from wf_r_examineinst where procinst_id in( select proc_inst_id  from common_busi_wf_middle where business_id in ( select  file_id ";
		sql += "  from  bgp_doc_gms_file where project_info_no in (";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ") and bsflag='0' and busi_table_name='BGP_DOC_GMS_FILE'))";
		
		jdbcTemplate.execute(sql);
		
		sql = " update common_busi_wf_middle set  bsflag = '1' where business_id in ( select  file_id from  bgp_doc_gms_file where project_info_no in (";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ") and busi_table_name ='gp_task_project' and bsflag='0' and business_type='5110000004100001003'  )";
		jdbcTemplate.execute(sql);
		
		//删除文档上传信息
		sql = " update bgp_doc_gms_file set  bsflag = '1' where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		jdbcTemplate.execute(sql);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		return msg;
	}
	
	/**
	 * 综合物化探项目保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addProject(ISrvMsg reqDTO) throws Exception{
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
//				Random r = new Random();
//				map.put("project_id", "newProj_"+r.nextInt());//先随机给个id 从erp获取后再更新过去
				
				flag = true;
			}
			//施工队伍
			String org_id = (String) map.get("org_id");
			if(null!=org_id&&""!=org_id){
				String []orgs=org_id.split(",");
				String osid="";
				if(orgs.length>0){
					for(int i=0;i<orgs.length;i++){
						List list = jdbcDao.queryRecords("select org_subjection_id from comm_org_subjection where org_id = '"+orgs[i]+"' and bsflag = '0' ");
						if (list != null && list.size() != 0) {
							Map map1 = (Map) list.get(0);
							if(i==(orgs.length)-1){
								osid+= map1.get("orgSubjectionId");
							}else{
								osid+= map1.get("orgSubjectionId")+",";
							}
							
						}
					}
				}
				map.put("org_subjection_id",osid);
			}
			Serializable project_info_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT");
			map.put("project_info_no", project_info_no.toString());
			map.put("notes", null);
			
			String workload = (String) map.get("workload");
			if ("2".equals(workload)) {
				map.put("design_object_workload", map.get("design_workload2"));
			} else {
				map.put("design_object_workload", map.get("design_workload1"));
			}
			//map.put("line_group_num", map.get("design_line_num"));
			//map.put("actual_fullfold_area", map.get("design_object_workload"));//设计工作量
			//map.put("design_fullfold_area", map.get("full_fold_workload"));//设计试验炮
//			map.put("design_shot_num", map.get("design_sp_num"));
//			map.put("receiveing_point_num", map.get("design_geophone_num"));
			
			Serializable project_dynamic_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT_DYNAMIC");
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_bgp_report");
			
			ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
			
			if (flag) {
				com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean pp = new com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean();
				//改为审批通过以后再同步至P6
				//pp.createProjectByTemp(map, (String) map.get("org_subjection_id"), user);
			} else {
				com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean pp = new com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean();
				//pp.saveOrUpdateP6ProjectToMCS(projects, user);
			}
			
			if (flag) {
				//创建项目的文档结构
				MyUcm m = new MyUcm();
				m.createProjectFolderNew(project_info_no.toString(), (String)map.get("project_name"), user.getUserId(), user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(),(String)map.get("project_type"));
			}
			
			msg.setValue("message", "success");
			return msg;
		}
	
	/**
	 * 工作量信息保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addProjectWorkLoad(ISrvMsg reqDTO) throws Exception{
		Map<String,Object> map = reqDTO.toMap();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		map.put("exploration_method",reqDTO.getValue("exploration_method_cl"));
		
		String workLoadId = reqDTO.getValue("workload_id");
		if (workLoadId == null || "".equals(workLoadId)) {
			//如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}
		//测量保存
		Serializable workload_idCL = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_WT_WORKLOAD");
		msg.setValue("workload_id",workload_idCL);
		map.clear();
		
		
		int num = reqDTO.getValue("num")==null?0:Integer.parseInt(reqDTO.getValue("num"));
		for(int i=1;i<=num;i++){
			if (reqDTO.getValue("workload_id"+i)== null || "".equals(reqDTO.getValue("workload_id"+i))) {
				//如果为空 则添加创建人
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
			}
			map.put("bsflag", "0");
			map.put("updator", user.getEmpId());
			map.put("modifi_date", new Date());
			map.put("workload_id",reqDTO.getValue("workload_id_"+i));
			map.put("project_info_no",reqDTO.getValue("project_info_no"));
			map.put("exploration_method",reqDTO.getValue("exploration_method_"+i));
			map.put("line_num",reqDTO.getValue("line_num_"+i));
			map.put("line_length",reqDTO.getValue("line_length_"+i));
			map.put("line_unit",reqDTO.getValue("line_unit_"+i));
			map.put("location_point",reqDTO.getValue("location_point_"+i));
			map.put("repeat_point",reqDTO.getValue("repeat_point_"+i));
			map.put("point_distance",reqDTO.getValue("point_distance_"+i));
			map.put("line_distance",reqDTO.getValue("line_distance_"+i));
			map.put("base_length",reqDTO.getValue("base_length_"+i));
			map.put("gravity_point",reqDTO.getValue("gravity_point_"+i));
			map.put("check_point",reqDTO.getValue("check_point_"+i));
			map.put("physics_point",reqDTO.getValue("physics_point_"+i));
			map.put("well_point",reqDTO.getValue("well_point_"+i));
			Serializable workload_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_WT_WORKLOAD");
			msg.setValue("workload_id_"+i,workload_id);
		}
		
		msg.setValue("message", "success");
		return msg;
	}
	
	
	/**
	 * 质量指标信息保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateQuality(ISrvMsg reqDTO) throws Exception{
		Map<String,Object> map = reqDTO.toMap();
		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		int num = reqDTO.getValue("num_q")==null?0:Integer.parseInt(reqDTO.getValue("num_q"));
		for(int i=1;i<=num;i++){
			if (reqDTO.getValue("object_id"+i)== null || "".equals(reqDTO.getValue("object_id"+i))) {
				//如果为空 则添加创建人
				map.put("creator_id", user.getEmpId());
				map.put("create_date", new Date());
			}
			map.put("bsflag", "0");
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			map.put("object_id",reqDTO.getValue("object_id_"+i));
			map.put("project_info_no",reqDTO.getValue("project_info_no"));
			map.put("exploration_method",reqDTO.getValue("exploration_method_q_"+i));
			map.put("firstlevel_radio",reqDTO.getValue("firstlevel_radio_"+i));
			map.put("qualified_radio",reqDTO.getValue("qualified_radio_"+i));
			map.put("waster_radio",reqDTO.getValue("waster_radio_"+i));
			map.put("miss_radio",reqDTO.getValue("miss_radio_"+i));
			Serializable object_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_PM_QUALITY_INDEX");
			msg.setValue("object_id_"+i,object_id);
		}
		msg.setValue("message", "success");
		return msg;
	}
	
	
	/**
	 * 保存项目以往勘探程度信息
	 * @param 
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateDegree(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String project_info_no = (String) map.get("project_info_no");
		String ucmDocId = "";
		
	    UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		
		String explorationDegreeId = reqDTO.getValue("exploration_degree_id");
		if (explorationDegreeId == null || "".equals(explorationDegreeId)) {
			//如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}
		
		//保存文件
		String docName = reqDTO.getValue("doc_name") != null?reqDTO.getValue("doc_name"):"";
		String docType = reqDTO.getValue("doc_type") != null?reqDTO.getValue("doc_type"):"";
		//如果不选择文件，则不执行上传文档到ucm的操作	to_date('"+today+"','YYYY-MM-DD HH24-mi-ss'
		//从本地服务器获取文档
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		byte[] fileBytes = null;
		String uploadFileName = reqDTO.getValue("upload_file_name") != null?reqDTO.getValue("upload_file_name"):"";
		String oldUcmId = reqDTO.getValue("oldUcmId") != null?reqDTO.getValue("oldUcmId"):"";
		if(uploadFileName != ""){
			fileBytes = MyUcm.getFileBytes(uploadFileName, user);
		}
		if(fileBytes != null && fileBytes.length > 0){
			ucmDocId = myUcm.uploadFile(uploadFileName, fileBytes);
			// 删除旧的文件记录
			if(""!=oldUcmId){
				myUcm.deleteFile(oldUcmId);
				String sql = "update bgp_doc_gms_file set bsflag = '1' where ucm_id = '" + oldUcmId + "'";
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				jdbcTemplate.execute(sql);
			}
		}
		
		//保存项目以往勘探程度表
		map.put("ucm_id",ucmDocId);
		Serializable exploration_degree_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_WT_EXPLORATION_DEGREE");
		
		//文件成功上传到UCM中后,才向数据库里写入相应数据
		if(ucmDocId != "" && ucmDocId != null){
			String FileId = jdbcDao.generateUUID();	
			StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,file_type,ucm_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id)");
			sbSql.append(" values('"+FileId+"','"+docName+"','"+docType+"','"+ucmDocId+"','"+project_info_no+"','0',"); 
			sbSql.append("sysdate,'"+user.getUserId()+"',sysdate,'"+user.getUserId()+"','1','"+user.getCodeAffordOrgID()+"','"+user.getSubOrgIDofAffordOrg()+"')");
			jdbcTemplate.execute(sbSql.toString());
			
			myUcm.docVersion(FileId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),docName);
			myUcm.docLog(FileId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),docName);
		}
		
		responseMsg.setValue("ucmDocId", ucmDocId);
		responseMsg.setValue("exploration_degree_id",exploration_degree_id);
		responseMsg.setValue("uploadFileName",uploadFileName);
		responseMsg.setValue("message", "success");
		return responseMsg;
	}
	
	/**
	 * 获得勘探方法
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectExploration(ISrvMsg reqDTO) throws Exception{
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectInfoNo", projectInfoNo);
		PageModel page = new PageModel();
		page = projectMCSBean.quertProject(map, page);
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String methodIds="";
		
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			if(null!=map.get("exploration_method")&&""!=map.get("exploration_method")){
				String[] methodId=map.get("exploration_method").toString().split(",");
				
				for(int i=0;i<methodId.length;i++){
					if(i==(methodId.length)-1){
						methodIds+="'"+methodId[i]+"'";
					}else{
						methodIds+="'"+methodId[i]+"',";
					}
				}
				//查找勘探方法名称methodIds可为多值，用','隔开 '0300100014000000017','0300100014000000018'。返回XXXXX,XXXXXXXX
				page = projectMCSBean.getExplorationMethodNames(methodIds,page);
				list = page.getData();
				if (list != null && list.size() != 0) {
					Map map1 =(Map)list.get(0);
					map.put("exploration_method",map1.get("coding_code_id"));
					map.put("exploration_method_name",map1.get("coding_name"));
					map.put("exploration_method_super",map1.get("superior_code_id"));
				}
				msg.setValue("explorationMap", map);
			}
		}
		return msg;
	}
	
	
	
	/**
	 * 获得施工队伍名称
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectOrgNames(ISrvMsg reqDTO) throws Exception{
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectInfoNo", projectInfoNo);
		PageModel page = new PageModel();
		page = projectMCSBean.quertProject(map, page);
		List list = page.getData();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			if(null!=map.get("org_id")&&""!=map.get("org_id")){
				String[] orgId=map.get("org_id").toString().split(",");
				String orgIds="";
				for(int i=0;i<orgId.length;i++){
					if(i==(orgId.length)-1){
						orgIds+="'"+orgId[i]+"'";
					}else{
						orgIds+="'"+orgId[i]+"',";
					}
				}
				//查找施工队伍名称 orgIds可为多值，用','隔开 'C6000000007066','C6000000000014','C6000000000008'。返回XXXXX,XXXXX,XXXXXXX
				page = projectMCSBean.getDynamicOrgNames(orgIds,page);
				list = page.getData();
				if (list != null && list.size() != 0) {
					Map map1 =(Map)list.get(0);
					map.put("org_name",map1.get("org_name"));
					map.put("org_id",map1.get("org_id"));
				}
				msg.setValue("orgNameMap", map);
			}
		}
		return msg;
	}
	
	
	public ISrvMsg getOrgNameById(ISrvMsg reqDTO) throws SOAPException{
		Map map = new HashMap();
		String org_id = reqDTO.getValue("org_id");
		PageModel page = new PageModel();
		page = projectMCSBean.getDynamicOrgNames(org_id,page);
		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map map1 =(Map)list.get(0);
			map.put("org_name",map1.get("org_name"));
			map.put("org_id",map1.get("org_id"));
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("orgNameMap", map);
		return msg;
	}
	
	/**
	 * 测量测算
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMeasureList(ISrvMsg isrvmsg) throws Exception {
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String projectInfoNo = isrvmsg.getValue("projectInfoNo");
		String action = isrvmsg.getValue("action");
		String measureType = isrvmsg.getValue("measureType");
		String view_measurement = isrvmsg.getValue("viewmeasurement"); //判断是否只是查看
		DecimalFormat numFormat = new DecimalFormat("##0.00"); 
		String projectName = dao.queryRecordBySQL("select p.project_name from gp_task_project p where p.bsflag='0' and p.project_info_no ='"+projectInfoNo+"'").get("project_name").toString();
		
		StringBuffer querySql = new StringBuffer("select t.terrain_measure_id,t.project_info_no,t.jb_gy_one,t.jb_gy_two,t.jb_gy_three,t.jb_gy_four,");
		querySql.append("t.jb_mountain_one,t.jb_mountain_two,t.jb_zz_one,t.jb_zz_two,t.jb_zz_three,t.jb_zz_four,t.jb_desert_one,t.jb_desert_two,t.jb_desert_three,");
		querySql.append("t.jb_py_one,t.jb_py_two,t.jb_cy_one,t.jb_cy_two,t.jb_hty_one,t.jb_hty_two,t.jb_hty_three,t.jb_gy_one,t.jb_gy_two,t.jb_gy_three, jb_gy_four ");
		querySql.append("from bgp_pm_terrain_measure t where t.bsflag = '0' and t.measure_confirm = '"+measureType+"' and t.project_info_no = '"+projectInfoNo+"' ");
		querySql.append("order by t.create_date desc");
		
		List<Map> measureList = dao.queryRecords(querySql.toString());
		List<Map<String,Object>> showWtMeasureList = new ArrayList<Map<String,Object>>();
		float total_jb_gy_one =0;
		float total_jb_gy_two =0;
		float total_jb_gy_three =0;
		float total_jb_gy_four =0;
		float total_jb_mountain_one=0;
		float total_jb_mountain_two=0;
		float total_jb_zz_one=0;
		float total_jb_zz_two=0;
		float total_jb_zz_three=0;
		float total_jb_zz_four=0;
		float total_jb_desert_one =0;
		float total_jb_desert_two =0;
		float total_jb_desert_three =0;
		float total_jb_hty_one =0;
		float total_jb_hty_two =0;
		float total_jb_cy_one =0;
		float total_jb_cy_two =0;
		float total_jb_py_one =0;
		float total_jb_py_two =0;
		for(int i=0;i<measureList.size();i++){
			Map<String,Object> measureMap = new HashMap<String, Object>();
			measureMap.put("terrain_measure_id", measureList.get(i).get("terrain_measure_id"));
			measureMap.put("jb_gy_one", measureList.get(i).get("jb_gy_one")!=null?measureList.get(i).get("jb_gy_one"):"");
			measureMap.put("jb_gy_two", measureList.get(i).get("jb_gy_two")!=null?measureList.get(i).get("jb_gy_two"):"");	
			measureMap.put("jb_gy_three", measureList.get(i).get("jb_gy_three")!=null?measureList.get(i).get("jb_gy_three"):"");
			measureMap.put("jb_gy_four", measureList.get(i).get("jb_gy_four")!=null?measureList.get(i).get("jb_gy_four"):"");
			
			measureMap.put("jb_mountain_one", measureList.get(i).get("jb_mountain_one")!=null?measureList.get(i).get("jb_mountain_one"):"");
			measureMap.put("jb_mountain_two", measureList.get(i).get("jb_mountain_two")!=null?measureList.get(i).get("jb_mountain_two"):"");
			
			measureMap.put("jb_zz_one", measureList.get(i).get("jb_zz_one")!=null?measureList.get(i).get("jb_zz_one"):"");
			measureMap.put("jb_zz_two", measureList.get(i).get("jb_zz_two")!=null?measureList.get(i).get("jb_zz_two"):"");	
			measureMap.put("jb_zz_three", measureList.get(i).get("jb_zz_three")!=null?measureList.get(i).get("jb_zz_three"):"");
			measureMap.put("jb_zz_four", measureList.get(i).get("jb_zz_four")!=null?measureList.get(i).get("jb_zz_four"):"");
			
			measureMap.put("jb_desert_one", measureList.get(i).get("jb_desert_one")!=null?measureList.get(i).get("jb_desert_one"):"");
			measureMap.put("jb_desert_two", measureList.get(i).get("jb_desert_two")!=null?measureList.get(i).get("jb_desert_two"):"");	
			measureMap.put("jb_desert_three", measureList.get(i).get("jb_desert_three")!=null?measureList.get(i).get("jb_desert_three"):"");
			
			measureMap.put("jb_hty_one", measureList.get(i).get("jb_hty_one")!=null?measureList.get(i).get("jb_hty_one"):"");
			measureMap.put("jb_hty_two", measureList.get(i).get("jb_hty_two")!=null?measureList.get(i).get("jb_hty_two"):"");	
			
			measureMap.put("jb_cy_one", measureList.get(i).get("jb_cy_one")!=null?measureList.get(i).get("jb_cy_one"):"");
			measureMap.put("jb_cy_two", measureList.get(i).get("jb_cy_two")!=null?measureList.get(i).get("jb_cy_two"):"");	
			
			measureMap.put("jb_py_one", measureList.get(i).get("jb_py_one")!=null?measureList.get(i).get("jb_py_one"):"");
			measureMap.put("jb_py_two", measureList.get(i).get("jb_py_two")!=null?measureList.get(i).get("jb_py_two"):"");	
			showWtMeasureList.add(measureMap);
			
			
			if(measureList.get(i).get("jb_gy_one").toString() != "" && measureList.get(i).get("jb_gy_one").toString() != null){
				total_jb_gy_one += Float.parseFloat(measureList.get(i).get("jb_gy_one").toString());
			}
			if(measureList.get(i).get("jb_gy_two").toString() != "" && measureList.get(i).get("jb_gy_two").toString() != null){
				total_jb_gy_two += Float.parseFloat(measureList.get(i).get("jb_gy_two").toString());
			}
			if(measureList.get(i).get("jb_gy_three").toString() != "" && measureList.get(i).get("jb_gy_three").toString() != null){
				total_jb_gy_three += Float.parseFloat(measureList.get(i).get("jb_gy_three").toString());
			}
			if(measureList.get(i).get("jb_gy_four").toString() != "" && measureList.get(i).get("jb_gy_four").toString() != null){
				total_jb_gy_four += Float.parseFloat(measureList.get(i).get("jb_gy_four").toString());
			}
			
			if(measureList.get(i).get("jb_mountain_one").toString() != "" && measureList.get(i).get("jb_mountain_one").toString() != null){
				total_jb_mountain_one += Float.parseFloat(measureList.get(i).get("jb_mountain_one").toString());
			}
			if(measureList.get(i).get("jb_mountain_two").toString() != "" && measureList.get(i).get("jb_mountain_two").toString() != null){
				total_jb_mountain_two += Float.parseFloat(measureList.get(i).get("jb_mountain_two").toString());
			}
			
			if(measureList.get(i).get("jb_zz_one").toString() != "" && measureList.get(i).get("jb_zz_one").toString() != null){
				total_jb_zz_one += Float.parseFloat(measureList.get(i).get("jb_zz_one").toString());
			}
			if(measureList.get(i).get("jb_zz_two").toString() != "" && measureList.get(i).get("jb_zz_two").toString() != null){
				total_jb_zz_two += Float.parseFloat(measureList.get(i).get("jb_zz_two").toString());
			}
			if(measureList.get(i).get("jb_zz_three").toString() != "" && measureList.get(i).get("jb_zz_three").toString() != null){
				total_jb_zz_three += Float.parseFloat(measureList.get(i).get("jb_zz_three").toString());
			}
			if(measureList.get(i).get("jb_zz_four").toString() != "" && measureList.get(i).get("jb_zz_four").toString() != null){
				total_jb_zz_four += Float.parseFloat(measureList.get(i).get("jb_zz_four").toString());
			}
			
			if(measureList.get(i).get("jb_desert_one").toString() != "" && measureList.get(i).get("jb_desert_one").toString() != null){
				total_jb_desert_one += Float.parseFloat(measureList.get(i).get("jb_desert_one").toString());
			}
			if(measureList.get(i).get("jb_desert_two").toString() != "" && measureList.get(i).get("jb_desert_two").toString() != null){
				total_jb_desert_two += Float.parseFloat(measureList.get(i).get("jb_desert_two").toString());
			}
			if(measureList.get(i).get("jb_desert_three").toString() != "" && measureList.get(i).get("jb_desert_three").toString() != null){
				total_jb_desert_three += Float.parseFloat(measureList.get(i).get("jb_desert_three").toString());
			}
			
			if(measureList.get(i).get("jb_hty_one").toString() != "" && measureList.get(i).get("jb_hty_one").toString() != null){
				total_jb_hty_one += Float.parseFloat(measureList.get(i).get("jb_hty_one").toString());
			}
			if(measureList.get(i).get("jb_hty_two").toString() != "" && measureList.get(i).get("jb_hty_two").toString() != null){
				total_jb_hty_two += Float.parseFloat(measureList.get(i).get("jb_hty_two").toString());
			}
			
			if(measureList.get(i).get("jb_cy_one").toString() != "" && measureList.get(i).get("jb_cy_one").toString() != null){
				total_jb_cy_one += Float.parseFloat(measureList.get(i).get("jb_cy_one").toString());
			}
			if(measureList.get(i).get("jb_cy_two").toString() != "" && measureList.get(i).get("jb_cy_two").toString() != null){
				total_jb_cy_two += Float.parseFloat(measureList.get(i).get("jb_cy_two").toString());
			}
			
			if(measureList.get(i).get("jb_py_one").toString() != "" && measureList.get(i).get("jb_py_one").toString() != null){
				total_jb_py_one += Float.parseFloat(measureList.get(i).get("jb_py_one").toString());
			}
			if(measureList.get(i).get("jb_py_two").toString() != "" && measureList.get(i).get("jb_py_two").toString() != null){
				total_jb_py_two += Float.parseFloat(measureList.get(i).get("jb_py_two").toString());
			}
			
		}
		responseDTO.setValue("showWtMeasureList", showWtMeasureList);
		responseDTO.setValue("total_jb_gy_one", numFormat.format(total_jb_gy_one));
		responseDTO.setValue("total_jb_gy_two", numFormat.format(total_jb_gy_two));
		responseDTO.setValue("total_jb_gy_three", numFormat.format(total_jb_gy_three));
		responseDTO.setValue("total_jb_gy_four", numFormat.format(total_jb_gy_four));
		
		responseDTO.setValue("total_jb_mountain_one", numFormat.format(total_jb_mountain_one));
		responseDTO.setValue("total_jb_mountain_two", numFormat.format(total_jb_mountain_two));
		
		responseDTO.setValue("total_jb_zz_one", numFormat.format(total_jb_zz_one));
		responseDTO.setValue("total_jb_zz_two", numFormat.format(total_jb_zz_two));
		responseDTO.setValue("total_jb_zz_three", numFormat.format(total_jb_zz_three));
		responseDTO.setValue("total_jb_zz_four", numFormat.format(total_jb_zz_four));
		
		responseDTO.setValue("total_jb_desert_one", numFormat.format(total_jb_desert_one));
		responseDTO.setValue("total_jb_desert_two", numFormat.format(total_jb_desert_two));
		responseDTO.setValue("total_jb_desert_three", numFormat.format(total_jb_desert_three));
		
		responseDTO.setValue("total_jb_hty_one", numFormat.format(total_jb_hty_one));
		responseDTO.setValue("total_jb_hty_two", numFormat.format(total_jb_hty_two));
		
		responseDTO.setValue("total_jb_cy_one", numFormat.format(total_jb_cy_one));
		responseDTO.setValue("total_jb_cy_two", numFormat.format(total_jb_cy_two));
		
		responseDTO.setValue("total_jb_py_one", numFormat.format(total_jb_py_one));
		responseDTO.setValue("total_jb_py_two", numFormat.format(total_jb_py_two));
		responseDTO.setValue("projectName", projectName);
		responseDTO.setValue("measureType", measureType);
		responseDTO.setValue("viewmeasurement", view_measurement);
		responseDTO.setValue("action", action);
		
		return responseDTO;
	}
	
	
	/**
	 * 项目资源配置信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectResourcesInfo(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		//String resourcesId = reqDTO.getValue("resourcesId");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		Map<String,Object> map = reqDTO.toMap();
		map.put("projectInfoNo", projectInfoNo);
		PageModel page = new PageModel();
		
		page = projectMCSBean.quertProjectResources(map,page);
		List list = page.getData();
		
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			msg.setValue("map", map);
			if(null!=map.get("org_id")&&""!=map.get("org_id")){
				String[] orgId=map.get("org_id").toString().split(",");
				String orgIds="";
				for(int i=0;i<orgId.length;i++){
					if(i==(orgId.length)-1){
						orgIds+="'"+orgId[i]+"'";
					}else{
						orgIds+="'"+orgId[i]+"',";
					}
				}
				//查找施工队伍名称 orgIds可为多值，用','隔开 'C6000000007066','C6000000000014','C6000000000008'。返回XXXXX,XXXXX,XXXXXXX
				page = projectMCSBean.getDynamicOrgNames(orgIds,page);
				list = page.getData();
				if (list != null && list.size() != 0) {
					Map map1 =(Map)list.get(0);
					map.put("org_name",map1.get("org_name"));
				}
				msg.setValue("orgMap", map);
			}
		}
		return msg;
	}
	
	
	/**
	 * 项目资源配置信息保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveProjectResources(ISrvMsg reqDTO) throws Exception{
		Map<String,Object> map = reqDTO.toMap();
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		
		String resourcesId = reqDTO.getValue("resources_id");
		if (resourcesId == null || "".equals(resourcesId)) {
			//如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
			map.put("create_unit",user.getProjectInfoNo());
		}
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_PROJECT_RESOURCES");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		return msg;
	}
	
	
	/**
	 * 项目资源配置 人力 设备中间表保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMiddleResources(ISrvMsg reqDTO) throws Exception{
		Map<String,Object> map = reqDTO.toMap();
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("project_info_no");
		map.put("bsflag", "0");
		map.put("creator", user.getEmpId());
		map.put("create_date", new Date());
		Serializable mid=BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_MIDDLE_RESOURCES");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		msg.setValue("mid", mid);
		return msg;
	}
	
	
	/**
	 * 项目资源补充配置删除
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteMiddleResources(ISrvMsg reqDTO) throws Exception{
		String mid = reqDTO.getValue("mid")==null?"":reqDTO.getValue("mid");
		String human_id = reqDTO.getValue("humanId")==null?"":reqDTO.getValue("humanId");
		String dev_id = reqDTO.getValue("devId")==null?"":reqDTO.getValue("devId");
		//删除中间表
		String sql ="update gp_middle_resources set bsflag = '1' where mid='"+mid+"'";
		jdbcTemplate.execute(sql);
		//删除人力
		sql="update bgp_comm_human_plan set bsflag = '1' where plan_id='"+human_id+"'";
		jdbcTemplate.execute(sql);
		sql="update bgp_comm_human_plan_detail set bsflag = '1' where spare1='"+human_id+"'";
		jdbcTemplate.execute(sql);
		//删除设备
		sql="update gms_device_allapp_add set bsflag = '1' where device_addapp_id='"+dev_id+"'";
		jdbcTemplate.execute(sql);
		sql="update gms_device_allapp_detail set bsflag = '1' where device_addapp_id='"+dev_id+"'";
		jdbcTemplate.execute(sql);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		return msg;
	}
	
	/**
	 * 获取项目的项目部
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectDep(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String sql = " select * from gp_task_project where project_info_no ='"+projectInfoNo+"'";
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<Map> list = dao.queryRecords(sql);
		if(list!=null&&list.size()!=0){
			Map map = list.get(0);
			if(map!=null&&map.size()!=0){
				String project_dep = list.get(0).get("project_department").toString();
				msg.setValue("project_department", project_dep);
			}
		}
		return msg;
	}
	
	/**
	 * 
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg  getOrgNameByOrgId(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		String sql = " select org_abbreviation from COMM_ORG_INFORMATION where ORG_ID ='"+orgId+"'";
		
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<Map> list = dao.queryRecords(sql);
		if(list!=null&&list.size()!=0){
			Map map = list.get(0);
			if(map!=null&&map.size()!=0){
				String org_abbreviation = list.get(0).get("org_abbreviation").toString();
				msg.setValue("org_abbreviation", org_abbreviation);
			}
		}
		
		return msg;
	}
	
	/**
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjectPlans(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		
		String sql = " select gp.project_id, gp.project_name, gp.project_status, gp.project_type, ccsd.coding_name from "
				   + " gp_task_project gp join gp_task_project_dynamic dy on gp.project_info_no = dy.project_info_no "
				   + " and gp.bsflag='0' and dy.bsflag='0' and gp.project_type = '5000100004000000009' "
				   + " join comm_coding_sort_detail ccsd on ccsd.coding_code_id = gp.manage_org "
				   + " and ccsd.bsflag='0' ";
		
		List<Map> list = jdbcDao.queryRecords(sql);
		List<Map> list_new = new ArrayList();
		if(list!=null&&list.size()!=0){
			for(int i=0;i<list.size();i++){
				Map map = list.get(i);
				
				String projectId = map.get("projectId").toString();
				String sql_ = " select max(planned_start_date)  as planned_start_date,min(planned_finish_date) as planned_finish_date "
						    + " from bgp_p6_activity where project_id = '"+projectId+"' and wbs_object_id in("
						    + " select  object_id from bgp_p6_project_wbs where parent_object_id = (select object_id "
						    + " from bgp_p6_project_wbs where PROJECT_ID = '"+projectId+"' AND NAME = '运行阶段' AND PROJECT_OBJECT_ID =("
						    + " select object_id  from bgp_p6_project  where project_id = '"+projectId+"' AND bsflag='0'))) ";
				List<Map> list_ = jdbcDao.queryRecords(sql_);
				Map map_ =  list_.get(0);
				map.put("plannedStartDate", map_.get("plannedStartDate"));
				map.put("plannedFinishDate", map_.get("plannedFinishDate"));
				list_new.add(map);
			}
		}
		
		
		msg.setValue("datas", list_new);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
}
