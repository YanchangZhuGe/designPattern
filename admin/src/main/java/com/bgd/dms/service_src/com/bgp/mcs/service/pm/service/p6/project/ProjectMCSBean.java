package com.bgp.mcs.service.pm.service.p6.project;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.primavera.ws.p6.project.ProjectExtends;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：姜增辉 2011-Nov-29
 *       
 * 描述：查询GMS系统中十分钟内的项目变动
 */

public class ProjectMCSBean {
	IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao radDao;
	private long minute = 10; //检查间隔，单位 分钟。
	ILog log;
	public ProjectMCSBean(){
		log = LogFactory.getLogger(ProjectMCSBean.class);
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	}
	
	/**
	 * 查询项目信息
	 * @param map
	 * @return
	 */
	public PageModel quertProject(Map<String,Object> map, PageModel page){
		
		Object projectInfoNo = map.get("projectInfoNo");
		Object objectId = map.get("objectId");
		Object projectId = map.get("projectId");//wbs中的id
		Object projectName = map.get("projectName");
		Object orgSubjectionId = map.get("orgSubjectionId");
		Object isMainProjects = map.get("isMainProject");
		Object projectStatus = map.get("projectStatus");
		Object projectType = map.get("projectType");
		Object projectFatherNo = map.get("projectFatherNo");
		String sql = "select t.*,tp.project_status,"
				+ "tp.project_name as tp_project_name,"
				+ "oi.org_abbreviation as org_name,"
				+ "tp.project_type,"
				+ "ccsd.coding_name as manage_org_name,"
				+ "nvl(tp.project_start_time,tp.acquire_start_time) as acquire_start_time,"
				+ "nvl(tp.project_end_time,tp.acquire_end_time) as acquire_end_time,"
				+ "p.heath_info_id,"
				+ "p.pm_info,"
				+ "p.qm_info,"
				+ "p.hse_info from bgp_p6_project t "
				+ "left outer join "
				+ "bgp_pm_project_heath_info p on t.project_info_no = p.project_info_no "
				+ "left outer join gp_task_project tp "
				+ "on t.project_info_no = tp.project_info_no ";
				if(projectFatherNo!=null){
					sql+= "and tp.PROJECT_FATHER_NO='"+projectFatherNo.toString()+"'";
				}
				sql+= "left outer join comm_coding_sort_detail ccsd on tp.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		sql += " join gp_task_project_dynamic dy on tp.project_info_no = dy.project_info_no and dy.bsflag = '0' and dy.exploration_method = tp.exploration_method ";
		if (orgSubjectionId != null && !("null").equals(orgSubjectionId)) {
			sql = sql +" and dy.org_subjection_id like '%"+orgSubjectionId.toString()+"%'";
		}
		
		sql += " join comm_org_information oi on oi.org_id = dy.org_id and oi.bsflag = '0' ";
		
		sql += " join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0' ";
		
		sql += " where 1=1  and  t.bsflag = '0' and t.project_info_no is not null  ";
		//if(("5000100004000000008").equals(projectType)||("5000100004000000006").equals(projectType)){
		if(!("").equals(projectType)){
			String[] str=projectType.toString().split(",");
			String ids="";
			for(int i=0;i<str.length;i++){
				ids+="'"+str[i]+"'";
				if(i!=(str.length)-1) ids+=",";
			}
			sql +="	and tp.project_type in ("+projectType+")";
		}
		 
		if (projectInfoNo != null) {
			sql += " and t.project_info_no = '"+projectInfoNo.toString()+"'";
		}
		if (objectId != null) {
			sql = sql +" and t.object_id = '"+objectId.toString()+"'";
		}
		if (projectId != null) {
			sql = sql +" and t.project_id like '%"+projectId.toString()+"%'";
		}
		if (projectName != null) {
			sql = sql +" and t.project_name like '%"+projectName.toString()+"%'";
		}
		if (isMainProjects != null) {
			String[] isMainProjectss = isMainProjects.toString().split(",");
			if (isMainProjectss.length > 1) {
				String str = "(";
				for (int i = 0; i < isMainProjectss.length; i++) {
					str += "'" + isMainProjectss[i] + "',";
				}
				str = str.substring(0, str.length() - 1);
				str += ")";
				sql = sql + "and tp.is_main_project in " + str;
			} else {
				sql = sql +" and tp.is_main_project like '%"+isMainProjects.toString()+"%'";
			}
		}
		if (projectStatus != null) {
			sql = sql + " and tp.project_status = '"+projectStatus+"' ";
		}
		
		sql = sql + " order by tp.project_status";
		log.debug("查询sql:"+sql);
		
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	/**
	 * 查询项目信息
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> quertProject(Map<String,Object> map){
		Object projectInfoNo = map.get("projectInfoNo");
		Object objectId = map.get("objectId");
		Object projectId = map.get("projectId");//wbs中的id
		Object projectName = map.get("projectName");
		
		String sql = "select t.*,tp.exploration_method,p.heath_info_id,p.pm_info,p.qm_info,p.hse_info from bgp_p6_project t join gp_task_project tp on t.project_info_no = tp.project_info_no and tp.bsflag = '0'  " +
					 "left outer join bgp_pm_project_heath_info p on t.project_info_no = p.project_info_no where 1=1 and t.bsflag = '0' and t.project_info_no is not null ";
		if (projectInfoNo != null) {
			sql += " and t.project_info_no = '"+projectInfoNo.toString()+"'";
		}
		if (objectId != null) {
			sql = sql +" and t.object_id = '"+objectId.toString()+"'";
		}
		if (projectId != null) {
			sql = sql +" and t.project_id like '%"+projectId.toString()+"%'";
		}
		if (projectName != null) {
			sql = sql +" and t.project_name like '%"+projectName.toString()+"%'";
		}
		
		log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		
		return list;
	}
	
	/**
	 * 获取项目的勘探方法
	 * @param map
	 * @return
	 */
	public List<Map> quertProjectMethod(String methodIds){
		
		String sql = "Select t.coding_code_id, t.coding_name "+
					 "FROM comm_coding_sort_detail t "+
					 "WHERE t.coding_sort_id = '5110000056' "+
					 "and t.bsflag = '0' "+
					 "and t.coding_code_id in"+methodIds;
		
		log.debug("查询sql:"+sql);
		List<Map> list = radDao.queryRecords(sql);
		
		return list;
	}
	
	public void saveP6ProjectToMCS(List<ProjectExtends> projects, UserToken user) throws Exception {
		Map<String, Object> map = null;
		
		for (int i = 0; i < projects.size(); i++) {
			ProjectExtends p = projects.get(i);
			map = new HashMap<String, Object>();
			map.put("object_id", p.getProject().getObjectId());
			map.put("project_id", p.getProject().getId());
			map.put("project_name", p.getProject().getName());
			map.put("obs_object_id", p.getProject().getOBSObjectId());
			map.put("obs_name", p.getProject().getOBSName());
			map.put("status", p.getProject().getStatus());
			map.put("wbs_object_id", p.getProject().getWBSObjectId().getValue());
			map.put("start_date", P6TypeConvert.convert(p.getProject().getStartDate()));
			map.put("finish_date",P6TypeConvert.convert(p.getProject().getFinishDate()));
			map.put("project_info_no", p.getProjectInfoNo());

			map.put("bsflag", "0");
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_P6_PROJECT");
		}
	}
	
	public void saveOrUpdateP6ProjectToMCS(List<ProjectExtends> projects, UserToken user) throws Exception {
		Map<String, Object> map = null;
		
		for (int i = 0; i < projects.size(); i++) {
			ProjectExtends p = projects.get(i);
			map = new HashMap<String, Object>();
			map.put("object_id", p.getProject().getObjectId());
			map.put("project_id", p.getProject().getId());
			map.put("project_name", p.getProject().getName());
			map.put("obs_object_id", p.getProject().getOBSObjectId());
			map.put("obs_name", p.getProject().getOBSName());
			map.put("status", p.getProject().getStatus());
			map.put("wbs_object_id", p.getProject().getWBSObjectId().getValue());
			map.put("start_date", P6TypeConvert.convert(p.getProject().getStartDate()));
			map.put("finish_date",P6TypeConvert.convert(p.getProject().getFinishDate()));
			map.put("project_info_no", p.getProjectInfoNo());

			map.put("bsflag", "0");
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_P6_PROJECT");
		}
	}
	
	
	/**
	 * 获取GMS中的update项目信息
	 * @return
	 */
	public List<Map<String,Object>> getUpdateProjects(){
		String sql = "select distinct p.project_info_no,d.org_subjection_id,p6.object_id " +
				" from Gp_task_project p left join gp_task_project_dynamic d on p.project_info_no=d.project_info_no  "
				+ "left join bgp_p6_project p6 on p.project_info_no=p6.project_info_no and p6.bsflag = '0' "
				+ " where p.bsflag='0' and p.modifi_date>(sysdate-"
				+ minute + "/(24*60))";
		List<Map> list = jdbcDao.queryRecords(sql);
		//GeDAOExtense ext = (GeDAOExtense) DAOFactory.getDAO("GeDAOExtense");
		com.bgp.mcs.service.pm.service.project.ProjectMCSBean mcsBean = new com.bgp.mcs.service.pm.service.project.ProjectMCSBean();
		List<Map<String,Object>> res_list=new ArrayList<Map<String,Object>>();
		PageModel page = new PageModel();
		Map map = new HashMap();
		
		for(int i=0;i<list.size();i++){
			Map m=list.get(i);
			String p_info_no=(String)m.get("project_info_no");
			//GpTaskProject tmp=ext.findGpTaskProjectInfo(p_info_no);
			map.put("projectInfoNo", p_info_no);
			page = mcsBean.quertProject(m, page);
			List list2 = page.getData();
			if (list2 != null && list2.size() != 0) {
				map = (Map) list2.get(0);
			}
			
			Map<String,Object> res_m=new HashMap<String,Object>();
			res_m.put("gp_project", map);
			res_m.put("org_subjection_id", m.get("org_subjection_id"));
			res_m.put("object_id", m.get("object_id"));
			res_list.add(res_m);
		}
		return res_list;
	}
	
	/**
	 * 获取GMS中的删除的项目
	 * @return
	 */
	public List<Map> getDeleteProjects(){
		String sql = "select distinct p.project_info_no,d.org_subjection_id,p6.object_id " +
				"from Gp_task_project p left join gp_task_project_dynamic d on p.project_info_no=d.project_info_no  "
				+ "left join bgp_p6_project p6 on p.project_info_no=p6.project_info_no and p6.bsflag = '0' "
				+ " where p.bsflag='1' and p.modifi_date>(sysdate-"
				+ minute + "/(24*60)) ";
		List<Map> list = jdbcDao.queryRecords(sql);
		return list;
	}
	
	public List<Map> getInsertProjects(){
		String sql = "select p.*,dy.org_subjection_id from gp_task_project p " +
				" join common_busi_wf_middle t on p.project_info_no = t.business_id and t.bsflag = '0' and t.proc_status = '3'  " +
				" left join bgp_p6_project p6 on p6.project_info_no=p.project_info_no and p6.bsflag = '0'  " +
				" join gp_task_project_dynamic dy on dy.project_info_no=p.project_info_no and dy.bsflag = '0' and dy.exploration_method = p.exploration_method  " +
				" where p.bsflag = '0' and  p6.object_id is null ";
		PageModel page = new PageModel();
		page.setPageSize(99999);
		
		page = radDao.queryRecordsBySQL(sql, page);
		return page.getData();
	}
	
	/**
	 * 从bgp_p6_proj_code_mapping中查询固定的ProjectCodeTypeObjectId
	 * @param gms_code
	 * @return
	 */
	@SuppressWarnings("finally")
	public int getP6ProjectCodeTypeObjectId(String gms_code){
		int p6_code_type=0;
		try{
			String sql="select distinct t.project_code_type_object_id from bgp_p6_proj_code_mapping t where t.coding_code_id='"+gms_code+"'";
			Map m = jdbcDao.queryRecordBySQL(sql);
			String str_code_type=(String)m.get("project_code_type_object_id");
			if(m==null||m.isEmpty()||str_code_type.equals("")){
				p6_code_type=0;//查不到，返回0
			}else{
				p6_code_type=Integer.parseInt(str_code_type);
			}
		}catch(Exception e){
			log.info("getP6ProjectCodeTypeObjectId() p6_code_type返回为空！");
		}finally{
			return p6_code_type;
		}
	}
	
	/**
	 * 从bgp_p6_proj_code_mapping表中查询固定的ProjectCodeObjectId
	 * @param gms_code
	 * @param p6_code_type
	 * @return
	 */
	@SuppressWarnings("finally")
	public int getP6ProjectCodeObjectId(String gms_code,int p6_code_type){
		int p6_code=0;
		try{
			String sql="select distinct t.project_code_object_id from bgp_p6_proj_code_mapping t where t.coding_code_id='"+gms_code+"' and t.project_code_type_object_id='"+p6_code_type+"'";
			Map m = jdbcDao.queryRecordBySQL(sql);
			String tmp_code=(String)m.get("project_code_object_id");
			if(m==null||m.isEmpty()||tmp_code.equals("")){
				p6_code=0;//查不到，返回0
			}else{
				p6_code=Integer.parseInt(tmp_code);
			}
		}catch(Exception e){
			log.info("getP6ProjectCodeTypeObjectId()----- p6_code_type返回为空！");
		}finally{
			return p6_code;
		}
	}
	
	/**
	 * 通过对应表bgp_p6_org_mapping，获取OBS编码
	 * @param orgSudId
	 * @return
	 */
	public int getObs(String orgSudId){
		String sql = "select distinct d.org_subjection_id,o.gms_org_sub_id,o.p6_obs_id from gp_task_project_dynamic d left join bgp_p6_org_mapping o on d.org_subjection_id like o.gms_org_sub_id||'%' where o.gms_org_sub_id!='C105' and d.org_subjection_id ='"
				+ orgSudId + "' order by gms_org_sub_id desc";
		Map m = jdbcDao.queryRecordBySQL(sql);
		String gms_org_sub_id = (String) m.get("gms_org_sub_id");
		String p6_obs_id = (String) m.get("p6_obs_id");
		log.debug("int the ProjectMSCBean.getObs -----------  p6_obs_id="+p6_obs_id+"; gms_org_sub_id="+gms_org_sub_id);
		return Integer.parseInt(p6_obs_id);
	}
	/**
	 * 通过对应表bgp_p6_eps_mapping,获取EPS编码
	 * @param orgSudId
	 * @return
	 */
	public int getEps(String orgSudId){
		String sql = "select distinct d.org_subjection_id,o.gms_org_sub_id,o.p6_eps_id from gp_task_project_dynamic d left join bgp_p6_eps_mapping o on d.org_subjection_id like o.gms_org_sub_id||'%' where o.gms_org_sub_id!='C105' and d.org_subjection_id ='"
				+ orgSudId + "'";
		Map m = jdbcDao.queryRecordBySQL(sql);
		String gms_org_sub_id = (String) m.get("gms_org_sub_id");
		String p6_eps_id = (String) m.get("p6_eps_id");
		
		log.debug("in the ProjectMSCBean.getEps ---------- p6_eps_id="+p6_eps_id+"; gms_org_sub_id="+gms_org_sub_id);
		return Integer.parseInt(p6_eps_id);
	}
	
	public void synProjectPlanBaselineProject(List<Map> projectPlanList,UserToken user) throws Exception{
		this.updatePlanBaselineProject(projectPlanList, user);
	}
	
	/**
	 * 从p6中查询项目进度计划中对应项目的目标项目
	 * @return
	 * @throws Exception
	 */
	public List<Map> getBaselineProjectFromP6() throws Exception{
		String sql = "select p.proj_id as PROJECT_PLAN_OBJECT_ID,p.sum_base_proj_id as BASELINE_PLAN_OBJECT_ID from project@p6db p where p.proj_id in ( "+
					  "select bp.project_plan_object_id from bgp_pm_project_plan bp "+
					  "left outer join common_busi_wf_middle t on bp.object_id = t.business_id and t.bsflag = '0' and t.proc_status is null "+
					  "where bp.bsflag = '0' and bp.base_plan_id is null and bp.project_plan_object_id is not null "+
					  "union "+
					  "select bp.project_plan_object_id from bgp_pm_project_plan bp "+
					  "join common_busi_wf_middle t on bp.object_id = t.business_id and t.bsflag = '0' and t.proc_status = '4' "+
					  "where bp.bsflag = '0' and bp.base_plan_id is null and bp.project_plan_object_id is not null ) "+
					  "and p.proj_id is not null and p.sum_base_proj_id is not null";
		
		List<Map> list;
		try {
			list = radDao.queryRecords(sql);
			return list;
		} catch (Exception e) {
			log.info("有异常,可能dblink出问题");
			e.printStackTrace();
			return null;
		}
		
	}
	
	/**
	 * 更新项目进度计划中的目标项目 
	 * @param projectPlanList
	 * @param user
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	private void updatePlanBaselineProject(final List<Map> projectPlanList,final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"UPDATOR_ID","BASELINE_PLAN_OBJECT_ID","PROJECT_PLAN_OBJECT_ID"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("update bgp_pm_project_plan set MODIFI_DATE = sysdate, ");
		for (int i = 0; i < propertys.length-1; i++) {
				sql.append(propertys[i]).append("=?,");//其他值
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
		sql.append(" and base_plan_id is null");

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					Map m = projectPlanList.get(i);
					ps.setString(1,user.getEmpId());
					ps.setInt(2, Integer.parseInt(m.get("baseline_plan_object_id").toString()));
					ps.setInt(3, Integer.parseInt(m.get("project_plan_object_id").toString()));
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return projectPlanList.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 同步项目的目标项目
	 * @param projectPlanList
	 * @param user
	 * @throws Exception
	 */
	public void synProjectBaselineProject(List<Map> projectPlanList,UserToken user) throws Exception{
		this.updateBaselineProject(projectPlanList, user);
	}
	
	/**
	 * 同步项目的目标项目
	 * @param projectPlanList
	 * @param user
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	private void updateBaselineProject(final List<Map> projectPlanList,final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		final SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd");
		
		String[] propertys = {"UPDATOR_ID","PROJECT_DATA_DATE","BASELINE_PROJECT_ID","OBJECT_ID"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("update bgp_p6_project set MODIFI_DATE = sysdate, ");
		for (int i = 0; i < propertys.length-1; i++) {
				sql.append(propertys[i]).append("=?,");//其他值
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
		sql.append(" and project_object_id is null");
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					Map m = projectPlanList.get(i);
					ps.setString(1,user.getEmpId());
					if(m.get("project_data_date") != null && m.get("project_data_date") != "" && !"".equals(m.get("project_data_date"))){
						Time data_date = new Time(f.parse(m.get("project_data_date").toString()).getTime());;
						ps.setTime(2, data_date);
					}else{
						ps.setTime(2, null);
					}
					ps.setInt(3, Integer.parseInt(m.get("baseline_object_id").toString()));
					ps.setInt(4, Integer.parseInt(m.get("project_object_id").toString()));
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return projectPlanList.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	
	/**
	 * 查询综合物化探项目信息
	 * @param map
	 * @return
	 */
	public PageModel quertWtProject(Map<String,Object> map, PageModel page){
		Object projectInfoNo = map.get("projectInfoNo");
		Object objectId = map.get("objectId");
		Object projectId = map.get("projectId");//wbs中的id
		Object projectName = map.get("projectName");
		Object orgSubjectionId = map.get("orgSubjectionId");
		Object isMainProjects = map.get("isMainProject");
		Object projectStatus = map.get("projectStatus");
		Object projectType = map.get("projectType");
		
		String sql = "select t.object_id,    t.wbs_object_id,    t.project_info_no, tp.project_status,t.obs_name as org_name," +
				"tp.project_name as project_name,tp.project_type,ccsd.coding_name as manage_org_name,  min(zb.produce_date) as acquire_start_time, " +
				" max(zb.produce_date) as acquire_end_time,p.heath_info_id,p.pm_info,p.qm_info,p.hse_info from bgp_p6_project t " +
				"left outer join bgp_pm_project_heath_info p on t.project_info_no = p.project_info_no left outer " +
				"join gp_task_project tp on t.project_info_no = tp.project_info_no join comm_coding_sort_detail" +
				" ccsd on tp.manage_org = ccsd.coding_code_id ";
		sql += "   join gp_ops_daily_report_wt zb  on tp.project_info_no=zb.project_info_no"+
    " and zb.bsflag='0'join gp_task_project_dynamic dy on tp.project_info_no = dy.project_info_no and dy.bsflag = '0' and dy.exploration_method = tp.exploration_method ";
		if (orgSubjectionId != null && !("null").equals(orgSubjectionId)) {
			sql = sql +" and dy.org_subjection_id like '%"+orgSubjectionId.toString()+"%'";
		}
		
		//sql += " join comm_org_information oi on oi.org_id = dy.org_id and oi.bsflag = '0' ";
		
		sql += " join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0' ";
		
		sql += " where 1=1  and  t.bsflag = '0' and t.project_info_no is not null and ccsd.bsflag = '0' ";
		if(!("").equals(projectType)){
			String[] str=projectType.toString().split(",");
			String ids="";
			for(int i=0;i<str.length;i++){
				ids+="'"+str[i]+"'";
				if(i!=(str.length)-1) ids+=",";
			}
			sql +="	and tp.project_type in ("+projectType+")";
		}
		 
		if (projectInfoNo != null) {
			sql += " and t.project_info_no = '"+projectInfoNo.toString()+"'";
		}
		if (objectId != null) {
			sql = sql +" and t.object_id = '"+objectId.toString()+"'";
		}
		if (projectId != null) {
			sql = sql +" and t.project_id like '%"+projectId.toString()+"%'";
		}
		if (projectName != null) {
			sql = sql +" and t.project_name like '%"+projectName.toString()+"%'";
		}
		if (isMainProjects != null) {
			String[] isMainProjectss = isMainProjects.toString().split(",");
			if (isMainProjectss.length > 1) {
				String str = "(";
				for (int i = 0; i < isMainProjectss.length; i++) {
					str += "'" + isMainProjectss[i] + "',";
				}
				str = str.substring(0, str.length() - 1);
				str += ")";
				sql = sql + "and tp.is_main_project in " + str;
			} else {
				sql = sql +" and tp.is_main_project like '%"+isMainProjects.toString()+"%'";
			}
		}
		if (projectStatus != null) {
			sql = sql + " and tp.project_status = '"+projectStatus+"' ";
		}
		
		sql = sql + "group by t.object_id,   t.wbs_object_id, t.project_info_no,   tp.project_status, tp.project_name  ,  tp.project_type,   ccsd.coding_name ,"+
		"p.heath_info_id,  p.pm_info,  p.qm_info,   p.hse_info,t.obs_name "+
 " order by tp.project_status";
		log.debug("查询sql:"+sql);
		
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	
	
	/**
	 * 查询综合物化探项目信息
	 * @param map
	 * @return
	 */
	public PageModel quertWtProject2(Map<String,Object> map, PageModel page){
		
		Object projectInfoNo = map.get("projectInfoNo");

		Object projectName = map.get("projectName");
		Object orgSubjectionId = map.get("orgSubjectionId");
		
		String sql = " select gp.project_info_no, gp.project_id, gp.PROJECT_NAME, gp.PROJECT_STATUS, heath.PM_INFO,heath.QM_INFO,heath.HSE_INFO FROM gp_task_project gp JOIN "
				    +" bgp_pm_project_heath_info heath on gp.PROJECT_INFO_NO = heath.PROJECT_INFO_NO"
				    +" AND gp.bsflag='0' AND heath.BSFLAG='0' "
				    + " join gp_task_project_dynamic dy on gp.project_info_no = dy.project_info_no "
				    + " and dy.bsflag='0' ";
				    if(projectInfoNo!=null&&projectInfoNo.toString().length()!=0){
				    	sql+=" and gp.project_info_no= '"+projectInfoNo+"' ";
				    }
				    if(projectName!=null&&projectName.toString().length()!=0){
				    	sql+=" and gp.project_name like '%"+projectName+"%'";
				    }
				    if(orgSubjectionId!=null&&orgSubjectionId.toString().length()!=0&&!orgSubjectionId.equals("null")){
				    	sql+=" and dy.org_Subjection_Id like '%"+orgSubjectionId+"%' ";
				    }
		log.debug("查询sql:"+sql);
		
		return radDao.queryRecordsBySQL(sql, page);
	}
}
