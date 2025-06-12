package com.bgp.mcs.service.pm.service.project;

import java.io.Serializable;
import java.net.URLDecoder;
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
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 井中项目
 * 
 * @author zs
 * 
 */
public class WsProjectSrv extends BaseService {
	private ILog log;
	private WsProjectMCSBean projectMCSBean;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");

	public WsProjectSrv() {
		log = LogFactory.getLogger(WsProjectSrv.class);
		projectMCSBean = (WsProjectMCSBean) BeanFactory
				.getBean("WsProjectMCSBean");
	}


	/**
	 * 井中项目管理 单项目 查看 年度项目
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProject4Single(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		if("null".equals(projectInfoNo)){
			projectInfoNo="";
		}
		String org_id = user.getOrgId();
		String org_sub_id = user.getOrgSubjectionId();
		String projectType = user.getProjectType();
		if("null".equals(projectType)){
			projectType="";
		}
		String sql = "";
		if(projectInfoNo!=null&&projectInfoNo.length()!=0){//如果项目号存在 就查询该项目
			sql = " select  p.*, oi.org_abbreviation as team_name from  gp_task_project p join gp_task_project_dynamic dy on" +
						 " dy.project_info_no = p.project_info_no and dy.bsflag = '0' and p.bsflag = '0' " +
						 " and p.project_info_no='"+projectInfoNo+"' " +
						 "and p.project_type='"+projectType+"'"+
						 " and dy.org_id='"+org_id+"' and dy.org_subjection_id='"+org_sub_id+"'"+
						 " left join comm_org_information oi on dy.org_id = oi.org_id "+
						 " and p.project_father_no is null ";
		}else{//如果没有项目号 查询该小队所有的项目
			sql = " select  p.*, oi.org_abbreviation as team_name from  gp_task_project p join gp_task_project_dynamic dy on" +
					 " dy.project_info_no = p.project_info_no and dy.bsflag = '0' and p.bsflag = '0' " +
					 " and p.project_type='5000100004000000008'"+
					 " and dy.org_id='"+org_id+"' " +
					 " and dy.org_subjection_id='"+org_sub_id+"'"+
					 " left join comm_org_information oi on dy.org_id = oi.org_id "+
					 " and p.project_father_no is null ";
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
		page = radDao.queryRecordsBySQL(sql, page);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		
		return msg;
	}
	
	
	public ISrvMsg getProject4Single(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if(projectInfoNo==null||"null".equals(projectInfoNo)){
			projectInfoNo="";
		}
		UserToken user = reqDTO.getUserToken();
		String org_id = user.getOrgId();
		String org_sub_id = user.getOrgSubjectionId();
		String project_type= user.getProjectType();
		String sql_tmp = " and p.project_info_no like '%"+projectInfoNo+"%' and dy.org_id like '%"+org_id+"%' and p.project_type like '%"+project_type+"%' and p.project_father_no is null";
		String sql = " select  p.*,ccsd.coding_name as market_classify_name, oi.org_abbreviation as team_name from  gp_task_project p join gp_task_project_dynamic dy on" +
				" dy.project_info_no = p.project_info_no and dy.bsflag = '0' and p.bsflag = '0' " +
				 sql_tmp+
				" left join comm_org_information oi on dy.org_id = oi.org_id " +
				" left join comm_coding_sort_detail ccsd on p.market_classify = ccsd.coding_code_id and ccsd.bsflag = '0'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("map", map);
		sql = " select * from gp_task_project_dynamic where project_info_no='"+projectInfoNo+"' ";
		Map dynamicMap = jdbcDao.queryRecordBySQL(sql);
		msg.setValue("dynamicMap", dynamicMap);
		String sql_temp = " select * from bgp_comm_org_wtc t where  '"+org_sub_id+"' like t.org_subjection_id ||'%'";
		Map teamMap = jdbcDao.queryRecordBySQL(sql_temp);
		msg.setValue("teamMap", teamMap);
		return msg;
	}
	
	
	public ISrvMsg querySubProject(ISrvMsg reqDTO)throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if(projectInfoNo==null||projectInfoNo.length()==0){
			projectInfoNo = user.getProjectInfoNo();
		}
		String validate = reqDTO.getValue("validate");
		String projectFatherNo = reqDTO.getValue("projectFatherNo");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		if(orgSubjectionId==null){
			orgSubjectionId = user.getSubOrgIDofAffordOrg();
		}
		Map map = new HashMap();
		map.put("projectFatherNo", projectFatherNo);
		map.put("projectInfoNo", projectInfoNo);
		map.put("orgSubjectionId", orgSubjectionId);
		
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
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if(validate!=null&&validate.equals("true")){
			page = projectMCSBean.querySubProjectWithValidate(map, page);
		}else{
			page = projectMCSBean.querySubProject(map, page);
		}
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		return msg;
	}
	
	public ISrvMsg queryProject(ISrvMsg reqDTO) throws Exception {
		
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
		// String userOrgsubjectionId = user.getOrgSubjectionId();
		String projectFatherNo = reqDTO.getValue("projectFatherNo");
		String isSingle = reqDTO.getValue("isSingle");
		String viewType = reqDTO.getValue("viewType");

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
		map.put("projectFatherNo", projectFatherNo);
		map.put("viewType", viewType);
		map.put("isSingle", isSingle);

		// 如果funcode不为空,则执行过滤查询
		if (funcCode != null && funcCode.toString().length() != 0) {
			page = projectMCSBean.quertProject(map, page, user, funcCode);
		} else {
			page = projectMCSBean.quertProject(map, page);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);

		return msg;
	}

	public ISrvMsg getProjectInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String org_sub_id = user.getOrgSubjectionId();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectFatherNo = reqDTO.getValue("projectFatherNo");
		String isSingle = reqDTO.getValue("isSingle");
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("projectInfoNo", projectInfoNo);
		map.put("projectFatherNo", projectFatherNo);
		map.put("isSingle", isSingle);

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
		if (list != null && list.size() != 0) {
			Map map_for = (Map) list.get(0);
			String is_main_team = map_for.get("is_main_team").toString();
			if(is_main_team.equals("1")){
				map_for.put("org_id", map_for.get("org_id").toString());
				map_for.put("org_name", map_for.get("org_name").toString());
			}
			msg.setValue("dynamicMap", map_for);
		}
			
		

		page = projectMCSBean.quertBgpReport(map, page);
		list = page.getData();
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			msg.setValue("bgpMap", map);
		}
		
		String sql_temp = " select * from bgp_comm_org_wtc t where  '"+org_sub_id+"' like t.org_subjection_id ||'%'";
		Map teamMap = jdbcDao.queryRecordBySQL(sql_temp);
		msg.setValue("teamMap", teamMap);
		return msg;
	}

	/**
	 * 多项目 添加非常规子项目
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addSubProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String build_type_val = map.get("build_type").toString();
		String build_type = build_type_val.split("@")[0];
		map.put("build_type", build_type);
		String source_version = build_type_val.split("@")[1];
		map.put("build_type_version", source_version);
		String source_num = build_type_val.split("@")[2];
		map.put("build_type_num", source_num);
		String org_id =  map.get("org_id").toString();
		String project_year = map.get("project_year").toString();
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		
		String[] key = { "project_name", "notes", "processing_unit" };

		String temp = "";

		for (int i = 0; i < key.length; i++) {
			temp = (String) map.get(key[i]);
			if (temp != null && !"".equals(temp)) {
				map.put(key[i], URLDecoder.decode(temp, "UTF-8"));
			}
		}
		
		String projectInfoNo = reqDTO.getValue("project_info_no");
		boolean flag = false;
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			// 如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
//			Random r = new Random();
//			map.put("project_id", "newProj_" + r.nextInt());// 先随机给个id
			flag = true;
		}
		
		map.put("is_main_team", 1);//处理org_id 为主施工队伍
		List list = jdbcDao.queryRecords("select org_subjection_id from comm_org_subjection where org_id = '"+ org_id + "' and bsflag = '0' ");
		if (list != null && list.size() != 0) {
			Map map1 = (Map) list.get(0);
			map.put("org_subjection_id", map1.get("orgSubjectionId"));
		}
		
		Serializable project_info_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_TASK_PROJECT");
		map.put("project_info_no", project_info_no.toString());
		map.put("notes", null);

		String workload = (String) map.get("workload");
		if ("2".equals(workload)) {
			map.put("design_object_workload", map.get("design_workload2"));
		} else {
			map.put("design_object_workload", map.get("design_workload1"));
		}
		
		String exploration_method = (String) map.get("exploration_method");
		if(exploration_method!=null){
			if ("0300100012000000002".equals(exploration_method)) {
				// 2维
				map.put("line_num", map.get("design_line_num"));
				map.put("total_len", map.get("design_object_workload"));// 设计工作量
				map.put("full_fold_len", map.get("full_fold_workload"));// 设计试验炮

				list = jdbcDao.queryRecords("select wa2d_no from gp_ops_2dwa_design_basic_data where project_info_no = '"+ project_info_no.toString()+ "' and bsflag = '0' ");
				if (list != null && list.size() != 0) {
					Map map1 = (Map) list.get(0);
					map.put("wa2d_no", map1.get("wa2dNo"));
				}
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_2dwa_design_basic_data");

			} else {
				map.put("line_group_num", map.get("design_line_num"));
				map.put("actual_fullfold_area", map.get("design_object_workload"));// 设计工作量
				map.put("design_fullfold_area", map.get("full_fold_workload"));// 设计试验炮
				map.put("design_shot_num", map.get("design_sp_num"));
				map.put("receiveing_point_num", map.get("design_geophone_num"));

				list = jdbcDao.queryRecords("select wa3d_no from gp_ops_3dwa_design_data where project_info_no = '"+ project_info_no.toString()+ "' and bsflag = '0' ");
				if (list != null && list.size() != 0) {
					Map map1 = (Map) list.get(0);
					map.put("wa3d_no", map1.get("wa3dNo"));
				}
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_3dwa_design_data");
			}
		}
		
		//首先查询GP_TASK_PROJECT_DYNAMIC 如果有主键就放在map里面做更新
		List listdy = jdbcDao.queryRecords("select project_dynamic_no from GP_TASK_PROJECT_DYNAMIC where PROJECT_INFO_NO='"+ project_info_no + "' and bsflag = '0' and IS_MAIN_TEAM='1'");
		if (listdy != null && listdy.size() != 0) {
			Map map1 = (Map) listdy.get(0);
			if(map1.containsKey("projectDynamicNo")){
				map.put("project_dynamic_no", map1.get("projectDynamicNo"));
			}
		}
		

		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_TASK_PROJECT_DYNAMIC");

		if(map.containsKey("other_org_id")){
			//查询 协作队伍信息 先删除 在插入
			List list_dy = jdbcDao.queryRecords("select project_dynamic_no from GP_TASK_PROJECT_DYNAMIC where PROJECT_INFO_NO='"+ project_info_no + "' and bsflag = '0' and is_main_team='0'");
			if(list_dy!=null&&list_dy.size()!=0){
				for(int i=0;i<list_dy.size();i++){
					Map map_temp = (Map)list_dy.get(i);
					map_temp.put("project_dynamic_no", map_temp.get("projectDynamicNo"));
					map_temp.put("bsflag", 1);
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map_temp, "GP_TASK_PROJECT_DYNAMIC");
				}
			}
			String other_org_id = map.get("other_org_id").toString();
			if(other_org_id!=null&&other_org_id.length()!=0){
				String[] orgArr = other_org_id.split(",");
				for(int i=0;i<orgArr.length;i++){
					map.put("org_id", orgArr[i]);
					List list_temp = jdbcDao.queryRecords("select org_subjection_id from comm_org_subjection where org_id = '"+ orgArr[i] + "' and bsflag = '0' ");
					if (list_temp != null && list_temp.size() != 0) {
						Map map_temp = (Map) list_temp.get(0);
						map.put("org_subjection_id", map_temp.get("orgSubjectionId"));
					}
					map.put("is_main_team", 0);
					if(map.containsKey("project_dynamic_no")){
						map.remove("project_dynamic_no");
					}
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_TASK_PROJECT_DYNAMIC");
				}
			}
		}
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_bgp_report");

		if (flag) {
			// 创建项目的文档结构
			MyUcm m = new MyUcm();
			m.createProjectFolderNew(project_info_no.toString(),
					(String) map.get("project_name"), user.getUserId(),
					user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(),(String)map.get("project_type"));
		}
		
		msg.setValue("message", "success");

		return msg;
	}
	
	
	public ISrvMsg addProject(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String  org_id = "";
		if(map.get("org_id")!=null&&map.get("org_id").toString().length()!=0){
			org_id =  map.get("org_id").toString();
		}
		String project_year = "";
		if(map.get("project_year")!=null&&map.get("project_year").toString().length()!=0){
			project_year = map.get("project_year").toString();
		}
		
		
		String project_info_no_map = "";
		if(map.containsKey("project_info_no")){//如果是修改的时候 需要按照project_info_no进行查询
			project_info_no_map = map.get("project_info_no").toString();
		}
		if(!map.containsKey("project_father_no")&&project_info_no_map.length()==0){
			String sql_count =" select count(*) as num from gp_task_project p join  gp_task_project_dynamic dy " +
					" on p.project_info_no = dy.project_info_no " +
					" and p.project_year ='"+project_year+"' and dy.org_id='"+org_id+"' " +
					" and p.bsflag='0' and dy.bsflag='0' and p.project_father_no is null ";
			log.info("查询sql："+sql_count);
			List list_count = jdbcDao.queryRecords(sql_count);
			String num = ((Map)list_count.get(0)).get("num").toString();
			if(!num.equals("0")){
				msg.setValue("message", "exist");
				return msg;
			}
		}
		
		
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());

		String[] key = { "project_name", "notes", "processing_unit" };

		String temp = "";

		for (int i = 0; i < key.length; i++) {
			temp = (String) map.get(key[i]);
			if (temp != null && !"".equals(temp)) {
				map.put(key[i], URLDecoder.decode(temp, "UTF-8"));
			}
		}

		String projectInfoNo = reqDTO.getValue("project_info_no");
		boolean flag = false;
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			// 如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());

//			Random r = new Random();
//			map.put("project_id", "newProj_" + r.nextInt());// 先随机给个id
															// 从erp获取后再更新过去

			flag = true;
		}

		
		map.put("is_main_team", 1);//处理org_id 为主施工队伍
		List list = jdbcDao
				.queryRecords("select org_subjection_id from comm_org_subjection where org_id = '"
						+ org_id + "' and bsflag = '0' ");
		if (list != null && list.size() != 0) {
			Map map1 = (Map) list.get(0);
			map.put("org_subjection_id", map1.get("orgSubjectionId"));
		}

		Serializable project_info_no = BeanFactory.getPureJdbcDAO()
				.saveOrUpdateEntity(map, "GP_TASK_PROJECT");
		
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
			// 2维
			map.put("line_num", map.get("design_line_num"));
			map.put("total_len", map.get("design_object_workload"));// 设计工作量
			map.put("full_fold_len", map.get("full_fold_workload"));// 设计试验炮

			list = jdbcDao.queryRecords("select wa2d_no from gp_ops_2dwa_design_basic_data where project_info_no = '"+ project_info_no.toString()+ "' and bsflag = '0' ");
			if (list != null && list.size() != 0) {
				Map map1 = (Map) list.get(0);
				map.put("wa2d_no", map1.get("wa2dNo"));
			}
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_2dwa_design_basic_data");

		} else {
			map.put("line_group_num", map.get("design_line_num"));
			map.put("actual_fullfold_area", map.get("design_object_workload"));// 设计工作量
			map.put("design_fullfold_area", map.get("full_fold_workload"));// 设计试验炮
			map.put("design_shot_num", map.get("design_sp_num"));
			map.put("receiveing_point_num", map.get("design_geophone_num"));

			list = jdbcDao
					.queryRecords("select wa3d_no from gp_ops_3dwa_design_data where project_info_no = '"
							+ project_info_no.toString()
							+ "' and bsflag = '0' ");
			if (list != null && list.size() != 0) {
				Map map1 = (Map) list.get(0);
				map.put("wa3d_no", map1.get("wa3dNo"));
			}
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_3dwa_design_data");
		}
		//井中年度项目必须保证GP_TASK_PROJECT_DYNAMIC中只有一条记录 和GP_TASK_PROJECT 对应
		//所以更新的时候必须把GP_TASK_PROJECT_DYNAMIC的主键查询出来放在map里面
		List listdy = jdbcDao
				.queryRecords("select project_dynamic_no from GP_TASK_PROJECT_DYNAMIC where PROJECT_INFO_NO='"
						+ project_info_no + "' and bsflag = '0' and is_main_team='1'");
		if (listdy != null && listdy.size() != 0) {
			Map map1 = (Map) listdy.get(0);
			if(map1.containsKey("projectDynamicNo")){
				map.put("project_dynamic_no", map1.get("projectDynamicNo"));
			}
		}
		

		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_TASK_PROJECT_DYNAMIC");

		if(map.containsKey("other_org_id")){
			//查询 协作队伍信息 先删除 在插入
			List list_dy = jdbcDao.queryRecords("select project_dynamic_no from GP_TASK_PROJECT_DYNAMIC where PROJECT_INFO_NO='"+ project_info_no + "' and bsflag = '0' and is_main_team='0'");
			if(list_dy!=null&&list_dy.size()!=0){
				for(int i=0;i<list_dy.size();i++){
					Map map_temp = (Map)list_dy.get(i);
					map_temp.put("project_dynamic_no", map_temp.get("projectDynamicNo"));
					map_temp.put("bsflag", 1);
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map_temp, "GP_TASK_PROJECT_DYNAMIC");
				}
			}
			String other_org_id = map.get("other_org_id").toString();
			if(other_org_id!=null&&other_org_id.length()!=0){
				String[] orgArr = other_org_id.split(",");
				for(int i=0;i<orgArr.length;i++){
					map.put("org_id", orgArr[i]);
					List list_temp = jdbcDao.queryRecords("select org_subjection_id from comm_org_subjection where org_id = '"+ orgArr[i] + "' and bsflag = '0' ");
					if (list_temp != null && list_temp.size() != 0) {
						Map map_temp = (Map) list_temp.get(0);
						map.put("org_subjection_id", map_temp.get("orgSubjectionId"));
					}
					map.put("is_main_team", 0);
					if(map.containsKey("project_dynamic_no")){
						map.remove("project_dynamic_no");
					}
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_TASK_PROJECT_DYNAMIC");
				}
			}
		}
		
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_bgp_report");

		

		/*if (flag) {
			//com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean pp = new com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean();
			// 改为审批通过以后再同步至P6
			// pp.createProjectByTemp(map, (String)
			// map.get("org_subjection_id"), user);
		} else {
			//com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean pp = new com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean();
			// pp.saveOrUpdateP6ProjectToMCS(projects, user);
		}*/

		if (flag) {
			// 创建项目的文档结构
			MyUcm m = new MyUcm();
			m.createProjectFolderNew(project_info_no.toString(),
					(String) map.get("project_name"), user.getUserId(),
					user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(),(String)map.get("project_type"));
		}

		msg.setValue("message", "success");

		return msg;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg selectProject(ISrvMsg reqDTO) throws Exception {

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
			msg.setValue("explorationMethod",
					(String) map.get("exploration_method"));
			msg.setValue("projectId", (String) map.get("project_id"));
			msg.setValue("projectObjectId",
					(String) map.get("project_object_id"));

			// 查询是否已有选择的项目
			String checkChoosenProject = "select cp.bgp_pm_choosen_project_id,cp.project_info_no from BGP_PM_CHOOSEN_PROJECT cp where cp.bsflag = '0' and cp.user_id = '"
					+ userId + "'";
			Map choosenProjectMap = jdbcDao
					.queryRecordBySQL(checkChoosenProject);
			// 已有选择的项目
			if (choosenProjectMap != null) {
				String choosenProjectInfoNo = choosenProjectMap.get(
						"projectInfoNo").toString();
				if (choosenProjectInfoNo != ""
						&& !choosenProjectInfoNo.equals(projectInfoNo)) {
					// 选择了不同的项目,获取主键,更新数据
					String choosen_id = choosenProjectMap.get(
							"bgpPmChoosenProjectId").toString();
					Map updateChoosenProject = new HashMap();
					updateChoosenProject.put("bgp_pm_choosen_project_id",
							choosen_id);
					updateChoosenProject.put("project_info_no", projectInfoNo);
					updateChoosenProject.put("user_id", user.getUserId());
					updateChoosenProject.put("bsflag", "0");
					updateChoosenProject.put("create_date", new Date());
					updateChoosenProject.put("modifi_date", new Date());
					updateChoosenProject.put("creator_id", user.getUserId());
					updateChoosenProject.put("updator_id", user.getUserId());
					updateChoosenProject.put("org_id",
							user.getCodeAffordOrgID());
					updateChoosenProject.put("org_subjection_id",
							user.getSubOrgIDofAffordOrg());
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
							updateChoosenProject, "bgp_pm_choosen_project");
				}
			}
			// 没有选择的项目,插入数据
			else {
				Map addChoosenProject = new HashMap();
				addChoosenProject.put("project_info_no", projectInfoNo);
				addChoosenProject.put("user_id", user.getUserId());
				addChoosenProject.put("bsflag", "0");
				addChoosenProject.put("create_date", new Date());
				addChoosenProject.put("modifi_date", new Date());
				addChoosenProject.put("creator_id", user.getUserId());
				addChoosenProject.put("updator_id", user.getUserId());
				addChoosenProject.put("org_id", user.getCodeAffordOrgID());
				addChoosenProject.put("org_subjection_id",
						user.getSubOrgIDofAffordOrg());
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
						addChoosenProject, "bgp_pm_choosen_project");
			}

		}

		return msg;
	}

	public ISrvMsg getQuality(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String sql = "select * from bgp_pm_quality_index where project_info_no = '"
				+ projectInfoNo + "' and bsflag = '0' ";
		Map map = jdbcDao.queryRecordBySQL(sql);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("qualityMap", map);
		return msg;
	}

	public ISrvMsg saveOrUpdateQuality(ISrvMsg reqDTO) throws Exception {
		Map map = reqDTO.toMap();
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator_id", user.getEmpId());
		map.put("modifi_date", new Date());

		String orbject_id = reqDTO.getValue("object_id");
		if (orbject_id == null || "".equals(orbject_id)) {
			// 如果为空 则添加创建人
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
		}
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
				"BGP_PM_QUALITY_INDEX");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		return msg;
	}

	/**
	 * 保存或更新井筒信息
	 * 
	 * @param well_no
	 *            ,project_info_no
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateWellhole(ISrvMsg reqDTO) throws Exception {
		Map map = reqDTO.toMap();
		String projectInfoNo = "";
		if(map.containsKey("projectInfoNo")){
			projectInfoNo = map.get("projectInfoNo").toString();
		}
		
		String projectFatherNo = "";
		
		if(map.containsKey("projectFatherNo")){
			projectFatherNo = map.get("projectFatherNo").toString();
		}
		
		String projectFatherName = "";
		if(map.containsKey("projectFatherName")){
			projectFatherName = map.get("projectFatherName").toString();
		}
		
		String orgSubjectionId = "";
		if(map.containsKey("orgSubjectionId")){
			projectFatherName = map.get("orgSubjectionId").toString();
		}
		
		
		String projectType = "";
		if(map.containsKey("projectType")){
			projectFatherName = map.get("projectType").toString();
		}
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());

		String wellNo = reqDTO.getValue("well_no");
		if (wellNo == null || "".equals(wellNo)) {
			// 如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}

		// 保存文件
		String fileName = "";
		String fileUcmId = "";
		String fileType = "";
		String oldUcmId1 = reqDTO.getValue("oldUcmId1") != null ? reqDTO.getValue("oldUcmId1") : "";
		String oldUcmId2 = reqDTO.getValue("oldUcmId2") != null ? reqDTO.getValue("oldUcmId2") : "";
		String fieldName = "";

		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList.size() != 0) {
			for (int i = 0; i < fileList.size(); i++) {
				WSFile uploadFile = fileList.get(i);
				fileName = uploadFile.getFilename();
				fileType = uploadFile.getType();
				fieldName = uploadFile.getKey();
				byte[] uploadData = uploadFile.getFileData();
				fileUcmId = myUcm.uploadFile(uploadFile.getFilename(),uploadData);
				map.put("ucm_id" + fieldName, fileUcmId);
				this.saveOrUpdateFile(fieldName, oldUcmId1, oldUcmId2,fileName, fileUcmId, fileType, projectInfoNo, user);
			}
		}

		Serializable well_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_WS_WELLHOLE");

		map.clear();
		map.put("well_no", well_no);
		map.put("project_info_no", projectInfoNo);
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_TASK_PROJECT");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		responseMsg.setValue("message", "success");
		responseMsg.setValue("projectInfoNo", projectInfoNo);
		responseMsg.setValue("projectFatherNo", projectFatherNo);
		responseMsg.setValue("projectFatherName", projectFatherName);
		responseMsg.setValue("orgSubjectionId", orgSubjectionId);
		responseMsg.setValue("projectType", projectType);
		return responseMsg;
	}

	/**
	 * 保存或更新附件信息
	 * 
	 * @param this
	 * @throws Exception
	 */
	public void saveOrUpdateFile(String fieldName, String oldUcmId1,
			String oldUcmId2, String fileName, String fileUcmId,
			String fileType, String project_info_no, UserToken user)
			throws Exception {
		if (!"".equals(fieldName)) {
			String oldUcmId = "";
			if ("1".equals(fieldName)) {
				oldUcmId = oldUcmId1;
			} else if ("2".equals(fieldName)) {
				oldUcmId = oldUcmId2;
			}
			if (!"".equals(oldUcmId)) {
				// 删除旧的文件记录
				myUcm.deleteFile(oldUcmId);
				String sql = "update bgp_doc_gms_file set bsflag = '1' where ucm_id = '"
						+ oldUcmId + "'";
				RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory
						.getBean("radJdbcDao");
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				jdbcTemplate.execute(sql);
			}
		}

		Map fileMap = new HashMap();
		fileMap.put("file_name", fileName);
		fileMap.put("ucm_id", fileUcmId);
		fileMap.put("file_type", fileType);
		// fileMap.put("parent_file_id", folder_id);

		fileMap.put("project_info_no", project_info_no);
		fileMap.put("bsflag", "0");
		fileMap.put("is_file", "1");
		fileMap.put("creator_id", user.getEmpId());
		fileMap.put("create_date", new Date());

		String doc_pk_id = BeanFactory.getPureJdbcDAO()
				.saveOrUpdateEntity(fileMap, "bgp_doc_gms_file").toString();
		myUcm.docVersion(doc_pk_id, "1.0", fileUcmId, user.getUserId(),
				user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),
				fileName);
		myUcm.docLog(doc_pk_id, "1.0", 1, fileUcmId, user.getUserId(),
				user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),
				fileName);
	}

	/**
	 * 获取井筒信息
	 * 
	 * @throws Exception
	 */
	public ISrvMsg getWellhole(ISrvMsg reqDTO) throws Exception {
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Map map = reqDTO.toMap();
		String welNo = (String) map.get("welNo");
		StringBuffer sb = new StringBuffer(
				"select f1.file_name as file_name1,f2.file_name as file_name2,gw.well_no,gw.well_category,gw.well_type,gw.well_start_time,gw.well_end_time,gw.core_high,gw.location_structure,gw.line_location,gw.land_x,gw.land_y,gw.land_high,gw.casing_structure,gw.barefoot_interval,gw.mud_weight,gw.mud_viscosity,gw.design_well_depth,gw.drilling_well_depth,gw.artificial_hole,gw.bottom_temperature,gw.target_stratum,gw.drilling_stratum,gw.bsflag,gw.ucm_id1,gw.ucm_id2,gw.inst_decent_depth,gw.well_use from gp_ws_wellhole gw left join bgp_doc_gms_file f1 on gw.ucm_id1=f1.ucm_id left join bgp_doc_gms_file f2 on gw.ucm_id2=f2.ucm_id   where gw.bsflag = '0'");
		if (null != welNo && !"".equals(welNo)) {
			sb.append(" and gw.well_no='").append(welNo).append("'");
		}

		Map wellMap = new HashMap();
		wellMap = jdbcDAO.queryRecordBySQL(sb.toString());
		if (wellMap != null) {
			responseMsg.setValue("wellMap", wellMap);
		}
		return responseMsg;
	}

	/**
	 * 保存或更新队伍信息
	 * 
	 * @param qualification_no
	 *            ,project_info_no
	 * @throws Exception
	 */
	public ISrvMsg saveQualification(ISrvMsg reqDTO) throws Exception {
		Map map = reqDTO.toMap();
		String projectInfoNo = "";
		if(map.containsKey("projectInfoNo")){
			projectInfoNo =  map.get("projectInfoNo").toString();
		}
		
		String projectFatherNo = "";
		if(map.containsKey("projectFatherNo")){
			projectFatherNo =  map.get("projectFatherNo").toString();
		}
		
		String projectFatherName = "";
		if(map.containsKey("projectFatherName")){
			projectFatherName =  map.get("projectFatherName").toString();
		}
		
		
		String orgSubjectionId = "";
		if(map.containsKey("orgSubjectionId")){
			orgSubjectionId =  map.get("orgSubjectionId").toString();
		}
		
		String projectType = "";
		if(map.containsKey("projectType")){
			projectType =  map.get("projectType").toString();
		}
		
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());

		String qualificationNo = reqDTO.getValue("qualification_no");
		if (qualificationNo == null || "".equals(qualificationNo)) {
			// 如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}

		// 保存文件
		String fileName = "";
		String fileUcmId = "";
		String fileType = "";
		String oldZZ1 = reqDTO.getValue("oldZZ1") != null ? reqDTO.getValue("oldZZ1") : "";
		String oldZZ2 = reqDTO.getValue("oldZZ2") != null ? reqDTO.getValue("oldZZ2") : "";
		boolean fileExist = false;
		String fieldName = "";

		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList.size() != 0) {
			for (int i = 0; i < fileList.size(); i++) {
				WSFile uploadFile = fileList.get(i);
				fileName = uploadFile.getFilename();
				fileType = uploadFile.getType();
				fieldName = uploadFile.getKey();
				byte[] uploadData = uploadFile.getFileData();
				fileUcmId = myUcm.uploadFile(uploadFile.getFilename(),
						uploadData);
				if ("zz1".equals(fieldName)) {
					map.put("ucm_id1", fileUcmId);
				} else if ("zz2".equals(fieldName)) {
					map.put("ucm_id2", fileUcmId);
				}
				this.saveOrUpdateQualificationFile(fieldName, oldZZ1, oldZZ2,fileName, fileUcmId, fileType, projectInfoNo, user);
			}
		}

		Serializable qualification_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_WS_QUALIFICATION");

		map.clear();
		map.put("qualification_no", qualification_no);
		map.put("project_info_no", projectInfoNo);
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "GP_TASK_PROJECT");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		responseMsg.setValue("message", "success");
		responseMsg.setValue("projectFatherNo", projectFatherNo);
		responseMsg.setValue("projectFatherName", projectFatherName);
		responseMsg.setValue("orgSubjectionId", orgSubjectionId);
		responseMsg.setValue("projectType", projectType);
		return responseMsg;
	}

	/**
	 * 保存或更新附件信息
	 * 
	 * @param this
	 * @throws Exception
	 */
	public void saveOrUpdateQualificationFile(String fieldName, String oldZZ1,
			String oldZZ2, String fileName, String fileUcmId, String fileType,
			String project_info_no, UserToken user) throws Exception {
		if (!"".equals(fieldName)) {
			String oldUcmId = "";
			if ("zz1".equals(fieldName)) {
				oldUcmId = oldZZ1;
			} else if ("zz2".equals(fieldName)) {
				oldUcmId = oldZZ2;
			}
			if (!"".equals(oldUcmId)) {
				// 删除旧的文件记录
				myUcm.deleteFile(oldUcmId);
				String sql = "update bgp_doc_gms_file set bsflag = '1' where ucm_id = '"
						+ oldUcmId + "'";
				RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory
						.getBean("radJdbcDao");
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				jdbcTemplate.execute(sql);
			}
		}

		Map fileMap = new HashMap();
		fileMap.put("file_name", fileName);
		fileMap.put("ucm_id", fileUcmId);
		fileMap.put("file_type", fileType);
		// fileMap.put("parent_file_id", folder_id);

		fileMap.put("project_info_no", project_info_no);
		fileMap.put("bsflag", "0");
		fileMap.put("is_file", "1");
		fileMap.put("creator_id", user.getEmpId());
		fileMap.put("create_date", new Date());

		String doc_pk_id = BeanFactory.getPureJdbcDAO()
				.saveOrUpdateEntity(fileMap, "bgp_doc_gms_file").toString();
		myUcm.docVersion(doc_pk_id, "1.0", fileUcmId, user.getUserId(),
				user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),
				fileName);
		myUcm.docLog(doc_pk_id, "1.0", 1, fileUcmId, user.getUserId(),
				user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),
				fileName);
	}

	/**
	 * 获取队伍信息
	 * 
	 * @throws Exception
	 */
	public ISrvMsg getQualification(ISrvMsg reqDTO) throws Exception {
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String qualificationNo = (String) map.get("qualificationNo");
		StringBuffer sb = new StringBuffer("select f1.file_name as file_name1,f2.file_name as file_name2,gw.qualification_no,gw.unit,gw.team_no,gw.ucm_id1,gw.ucm_id2, gw.experience,gw.bsflag from gp_ws_qualification gw left join  bgp_doc_gms_file f1 on gw.ucm_id1=f1.ucm_id left join bgp_doc_gms_file f2 on gw.ucm_id2=f2.ucm_id where gw.bsflag = '0'");
		sb.append(" and gw.qualification_no='").append(qualificationNo).append("'");
		Map qualMap = new HashMap();
		qualMap = jdbcDAO.queryRecordBySQL(sb.toString());
		if (qualMap != null) {
			responseMsg.setValue("qualMap", qualMap);
		}
		return responseMsg;
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
	 * 删除项目信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteProject(ISrvMsg reqDTO) throws Exception{
		String ids = reqDTO.getValue("projectInfoNos");
		String[] projectInfoNos = ids.split(",");
		String sql = "update gp_task_project set bsflag = '1' where project_info_no in ( ";
		for (int i = 0; i < projectInfoNos.length; i++) {
			sql += "'"+projectInfoNos[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		jdbcTemplate.execute(sql);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		return msg;
	}
	
	/**
	 * 获取年度项目的年份
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFatherProjectYear(ISrvMsg reqDTO) throws Exception{
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String sql = " select project_year from gp_task_project where project_info_no = '"+projectInfoNo+"'";
		Map map = jdbcDAO.queryRecordBySQL(sql);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("project_year", map.get("project_year").toString());
		return msg;
	}
	
	/*-------------------------------------------3.25 重新开发代码-------------------------------------------------*/
	
	
	/**
	 * 井中项目多项目查询项目列表方法
	 * 请不要修改 借用自己copy一份
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjects(ISrvMsg reqDTO) throws Exception {
		
		String projectType = reqDTO.getValue("projectType");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String sql = " select p.*," +
					 " ccsd.coding_name as manage_org_name," +
					 " sap.prctr_name as prctr_name," +
					 " ccsd1.coding_name as market_classify_name," +
					 " p.design_end_date-p.design_start_date as duration_date," +
					 " p6.object_id as project_object_id," +
					 " nvl(p.project_start_time,p.acquire_start_time) as start_date," +
					 " nvl(p.project_end_time,p.acquire_end_time) as end_date,"+
					 " substr(dy.org_id,0,14) as org_id," +
					 " oi.org_abbreviation as team_name," +
					 " dy.is_main_team as is_main_team"+
					 " from gp_task_project p join gp_task_project_dynamic dy " +
					 " on dy.project_info_no = p.project_info_no " +
					 " and dy.bsflag = '0'  " +
					 " and dy.exploration_method = p.exploration_method "+
					 " and p.project_father_no is null ";
			if(projectInfoNo!=null&&projectInfoNo.length()!=0){
				sql+=" and p.project_info_no = '"+projectInfoNo+"'";
			}else{
				if (orgSubjectionId != null) {
					sql += " and dy.org_subjection_id like '"+orgSubjectionId+"%'";
				}
				if (projectType != null&&projectType.length()!=0) {
					sql += " and p.project_type like '%"+projectType+"%'";
				}
			}
		sql += " left join comm_org_information oi on dy.org_id = oi.org_id ";
		sql += " left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		sql += " left join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ";
		sql += " left join bgp_pm_sap_org sap on sap.prctr = p.prctr ";
		sql += " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0' ";
		sql += " where p.bsflag = '0' ";

		sql = sql + " order by p.create_date desc";
		
		log.debug("查询sql:"+sql);
		
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
		page = radDao.queryRecordsBySQL(sql, page);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	
	
	
	/**
	 * 井中多项目点击事件方法获取项目详细信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectDetail(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String orgSubId = reqDTO.getValue("orgSubjectionId");
		String isson = reqDTO.getValue("isson");//判断是否为子项目
		String sql = "select p.*," +
					 "ccsd.coding_name as manage_org_name," +
					 "sap.prctr_name as prctr_name," +
					 "ccsd1.coding_name as market_classify_name," +
					 "p.design_end_date-p.design_start_date as duration_date," +
					 "p6.object_id as project_object_id," +
					 "nvl(p.project_start_time,p.acquire_start_time) as start_date," +
					 "nvl(p.project_end_time,p.acquire_end_time) as end_date,"+
					 "substr(dy.org_id,0,14) as org_id ," +
					 "oi.org_abbreviation as team_name," +
					 "dy.is_main_team as is_main_team"+
					 " from gp_task_project p  ";
		sql += " join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no and dy.bsflag = '0'";
		sql += " left join comm_org_information oi on dy.org_id = oi.org_id ";
		sql += " left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		sql += " left join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ";
		sql += " left join bgp_pm_sap_org sap on sap.prctr = p.prctr ";
		sql += " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0' ";
		sql += " where 1=1 and p.bsflag = '0' ";
		if (projectInfoNo != null&&projectInfoNo.toString().length()!=0) {
			sql += " and p.project_info_no = '"+projectInfoNo.toString()+"'";
		}
		if(isson==null||isson.length()==0){
			sql += " and p.project_father_no is null ";
		}
		
		sql += "order by p.modifi_date desc";
		
		log.debug("查询sql:"+sql);
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
		page = radDao.queryRecordsBySQL(sql, page);
		List list = page.getData();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			msg.setValue("map", map);
		}
		String sql_dy = "select gp.well_no as well_no,gp.qualification_no as qualification_no,dy.*,oi.org_abbreviation as org_name from gp_task_project_dynamic dy ";
		sql_dy += "  left join gp_task_project gp on gp.project_info_no = dy.project_info_no and gp.bsflag = '0' and dy.exploration_method = gp.exploration_method ";
		sql_dy += "  left join comm_org_information oi on oi.org_id = substr(dy.org_id,0,14) and oi.bsflag = '0' ";
		sql_dy += " where 1=1 and dy.bsflag = '0' ";
		if (projectInfoNo != null) {
			sql_dy += " and gp.project_info_no = '"+projectInfoNo.toString()+"' ";
		}
		log.debug("查询sql:"+sql_dy);
		page = radDao.queryRecordsBySQL(sql_dy, page);
		
		list = page.getData();
		if (list != null && list.size() != 0) {
			StringBuffer other_org_id = new StringBuffer();
			StringBuffer other_org_name = new StringBuffer();
			StringBuffer org_id = new StringBuffer();
			StringBuffer org_name = new StringBuffer();
			Map map_for = new HashMap();
			for(int i=0;i<list.size();i++){
				map_for = (Map) list.get(i);
				String is_main_team = map_for.get("is_main_team").toString();
				if(is_main_team.equals("1")){
					org_id.append(map_for.get("org_id").toString());
					org_name.append(map_for.get("org_name").toString());
				}else{
					if (i == list.size() - 1) {
						other_org_id.append(map_for.get("org_id").toString());
						other_org_name.append(map_for.get("org_name").toString());
					} else {
						other_org_id.append(map_for.get("org_id") + ",");
						other_org_name.append(map_for.get("org_name")+ ",");
					}
					
				}
			}
			map_for.put("org_id", org_id.toString());
			map_for.put("org_name", org_name.toString());
			map_for.put("other_org_id", other_org_id.toString());
			map_for.put("other_org_name", other_org_name.toString());
			msg.setValue("dynamicMap", map_for);
		}
		
		String sql_temp = " select * from bgp_comm_org_wtc t where  '"+orgSubId+"' like t.org_subjection_id ||'%'";
		Map teamMap = jdbcDao.queryRecordBySQL(sql_temp);
		msg.setValue("teamMap", teamMap);
		return msg;
	}
	
	/**
	 * 多项目查询子项目列表
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySubProjects(ISrvMsg reqDTO) throws Exception {
		String isSingle = reqDTO.getValue("isSingle");
		String projectType = reqDTO.getValue("projectType");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectFatherNo = reqDTO.getValue("projectFatherNo");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String projectYear = reqDTO.getValue("projectYear");
		String orgId = reqDTO.getValue("orgId");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		//查询小队作为主施工队伍的项目信息
		String sql = " select " +
					" p.project_info_no  AS project_info_no, " +
					" p.project_name     AS project_name," +
					" p.project_common   AS project_common," +
					" p.project_status   AS project_status," +
					" ccsd.coding_name   AS manage_org_name," +
					" DECODE(rpt.start_date,NULL,TO_CHAR(p.start_time,'yyyy-MM-dd'),TO_CHAR(rpt.start_date,'yyyy-MM-dd')) AS start_date, " +
					" DECODE(rpt.end_date,NULL,TO_CHAR(p.end_time,'yyyy-MM-dd'),TO_CHAR(rpt.end_date,'yyyy-MM-dd')) AS end_date, " +
					" oi.org_abbreviation      AS team_name," +
					" dy.is_main_team          AS is_main_team" +
					" from " +
					" gp_task_project p " +
					" join " +
					" gp_task_project_dynamic dy " +
					" on " +
					" dy.project_info_no = p.project_info_no and dy.bsflag = '0' and p.bsflag='0' ";
		if(projectFatherNo!=null&&projectFatherNo.length()!=0){
			sql += " and p.project_father_no ='"+projectFatherNo+"'";
		}else{
			sql += " and p.project_info_no ='"+projectInfoNo+"'";
		}
		if(orgSubjectionId!=null&&orgSubjectionId.length()!=0){
			sql += " and dy.org_Subjection_Id like '%"+orgSubjectionId+"%'";
		}
		if(projectType!=null&&projectType.length()!=0){
			sql += " and p.project_type='"+projectType+"'";
		}
		sql += " and dy.is_main_team ='1' ";
		sql += " left join comm_org_information oi on dy.org_id = oi.org_id ";
		sql += " left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		sql += " LEFT JOIN ( SELECT DISTINCT rpt.project_info_no,rpt.start_date,rpt.end_date FROM bgp_ws_daily_report rpt JOIN COMMON_BUSI_WF_MIDDLE wf ";
		sql += " ON wf.BUSINESS_ID=rpt.PROJECT_INFO_NO AND wf.bsflag='0' AND rpt.bsflag='0' AND wf.BUSI_TABLE_NAME='bgp_ws_daily_report' AND wf.PROC_STATUS='3' ) rpt ";
		sql += " ON rpt.project_info_no=p.project_info_no  ORDER BY p.CREATE_DATE DESC";
		//查询小队作为协作队伍的项目信息
		/*sql += " union all " +
			   " select " +
			   " p.project_info_no                              as project_info_no," +
			   " p.project_name||'(协作)'                       as project_name, " +
			   " p.project_common                               as project_common, " +
			   " p.project_status                               AS project_status," +
			   " ccsd.coding_name                               AS manage_org_name," +
			   " p.start_time," +
			   " p.end_time, " +
			   " oi.org_abbreviation                            AS team_name," +
			   " dy.is_main_team                                AS is_main_team " +
			   " from " +
			   " gp_task_project p JOIN gp_task_project_dynamic dy " +
			   " on " +
			   " dy.project_info_no = p.project_info_no ";
				if(isSingle==null){
					sql += " and p.project_year='" +projectYear+"'";
				}
			   sql += " and dy.bsflag = '0' and p.bsflag='0' and dy.org_Id like '%"+orgId+"%' ";
			   if(isSingle!=null&&isSingle.equals("true")){
				   sql += " and p.project_info_no= '"+projectInfoNo+"'";
			   }
			   if(projectType!=null&&projectType.length()!=0){
				   sql += " and p.project_type='5000100004000000008' ";
			   }
			   
			   sql += " and dy.is_main_team ='0' " +
			   " left join " +
			   " comm_org_information oi " +
			   " on " +
			   " dy.org_id = oi.org_id " +
			   " left join " +
			   " comm_coding_sort_detail ccsd " +
			   " on " +
			   " p.manage_org = ccsd.coding_code_id " +
			   " and ccsd.bsflag = '0' ";*/
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
		
		page = radDao.queryRecordsBySQL(sql, page);
		log.info("查询sql："+sql);
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	
	
	public ISrvMsg queryViewType(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String sql = " select * from bgp_ws_view_type where project_info_no ='"+projectInfoNo+"' and bsflag='0' order by seqno,view_type_id";
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals("")){
			currentPage = "1";
		}
			
		String pageSize = "1000000";
		
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		page = radDao.queryRecordsBySQL(sql, page);
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	
	public ISrvMsg saveViewType(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String sql = " delete from bgp_ws_view_type where project_info_no ='"+projectInfoNo+"'";
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		jdbcTemplate.execute(sql);
		
		String parms = reqDTO.getValue("parms");
		if(parms==null||parms.toString().length()==0){
			msg.setValue("message", "success");
			return msg;
		}
		String project_info_no = reqDTO.getValue("projectInfoNo");
		String[] tables = parms.split("\\|");
		
		for(int i=0;i<tables.length;i++){
			String[] rows = tables[i].split("@");
			Map map = new HashMap();
			map.put("project_info_no", projectInfoNo);
			map.put("view_type_code", rows[0]);
			if(rows[0].equals("5110000053000000009")||rows[0].equals("5110000053000000010")||rows[0].equals("5110000053000000011")){
				
			}else{
				map.put("view_well", rows[1]);
				map.put("view_point", rows[2]);
				map.put("acquire_level", rows[3]);
				map.put("note", rows[4]);
			}
			map.put("seqno", rows[5]);
			
			map.put("bsflag", "0");
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_ws_view_type");
		}
		msg.setValue("message", "success");
		return msg;
	}
	
}
