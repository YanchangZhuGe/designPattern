package com.bgp.mcs.service.pm.service.project;

import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.DataPermission;
import com.cnpc.jcdp.common.IDataPermProcessor;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class ProjectMCSBean {
	
	private ILog log;
	private RADJdbcDao radDao;
	private IBaseDao baseDao;
	
	public ProjectMCSBean() {
		this.log = LogFactory.getLogger(ProjectMCSBean.class);
		this.radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		this.baseDao = BeanFactory.getBaseDao();
	}
	
	public Map getProjectDate(String projectInfoNo){
		String sql = "select min(a.planned_start_date) as project_plan_start_date,max(a.planned_finish_date) as project_plan_finish_date from bgp_p6_activity a join bgp_p6_project p on a.project_object_id = p.object_id and p.bsflag = '0'"+ 
					 "where a.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'";
		return radDao.queryRecordBySQL(sql);
	}
	
	public PageModel quertProject(Map<String,Object> map, PageModel page){
		Object projectInfoNo = map.get("projectInfoNo");
		Object projectName = map.get("projectName");
		Object projectId = map.get("projectId");
		Object projectType = map.get("projectType");
		Object isMainProject = map.get("isMainProject");
		Object projectStatus = map.get("projectStatus");
		Object orgName = map.get("orgName");
		Object orgSubjectionId = map.get("orgSubjectionId");
		Object explorationMethod = map.get("explorationMethod");
		Object projectArea = map.get("projectArea");
		Object viewType = map.get("viewType");
		
		 
		//原sql
//		String sql = "select p.*,ccsd.coding_name as manage_org_name,sap.prctr_name as prctr_name " +
//				",ccsd1.coding_name as market_classify_name,p.design_end_date-p.design_start_date as duration_date,p6.object_id as project_object_id,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date"+
//				",dy.org_id "+
//				" from gp_task_project p  ";
		 //新sql 添加了项目名称全称
		 String sql = "select p.*,(select t.coding_name  from comm_coding_sort_detail t  where t.coding_code_id =(select superior_code_id from comm_coding_sort_detail where coding_code_id = p.manage_org)) || ' ' || ccsd.coding_name as manage_org_name,sap.prctr_name as prctr_name,ct.project_name as pro_name " +
			",ccsd1.coding_name as market_classify_name,p.design_end_date-p.design_start_date as duration_date,p6.object_id as project_object_id,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date"+
			",dy.org_id "+
			" from gp_task_project p  ";
		 
		sql += " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method ";
		
		if (orgSubjectionId != null) {
			sql += " and dy.org_subjection_id like '"+orgSubjectionId.toString()+"%'";
		}

		if (orgName != null) {
			sql += " left join comm_org_information oi on dy.org_id = oi.org_id and oi.org_name like '%"+orgName.toString()+"%'";
		}
		
		sql += " left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		
		sql += " left join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ";
		
		sql += " left join bgp_pm_sap_org sap on sap.prctr = p.prctr ";
		
		sql += " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0' ";
		
		sql += " left join gp_workarea_diviede wd on wd.workarea_no = p.workarea_no  and wd.bsflag = '0' ";
		sql += "  left join gp_ops_epg_task_project ct on ct.project_info_no=p.spare2 ";

		sql += " where 1=1 and p.bsflag = '0' ";
		
		if (projectInfoNo != null) {
			sql += " and p.project_info_no = '"+projectInfoNo.toString()+"'";
		}
		
		if (projectName != null) {
			sql += " and p.project_name like '%"+projectName.toString()+"%'";
		}
		if (projectId != null) {
			sql = sql +" and p.project_id like '%"+projectId.toString()+"%'";
		}
		
		if (projectType != null&&projectType.toString().length()!=0) {
			String types[]=projectType.toString().split(",");
			String type="";
			for(int i=0;i<types.length;i++){
				type+="'"+types[i]+"'";
				if(i!=(types.length)-1) type+=",";
			}
			sql = sql +" and p.project_type in ("+type+")";
		}

		if (isMainProject != null && !("").equals(isMainProject)) {
			sql = sql +" and p.is_main_project like '%"+isMainProject.toString()+"%'";
		}
		if (projectStatus != null && !("").equals(isMainProject)) {
			sql = sql +" and p.project_status like '%"+projectStatus.toString()+"%'";
		}
		if (explorationMethod != null) {
			sql = sql +" and p.exploration_method like '%"+explorationMethod.toString()+"%'";
		}
		if (projectArea != null && projectArea != "") {
			sql = sql +" and wd.region_name like '%"+projectArea.toString()+"%'";
		}
		
		sql = sql + " order by p.project_status ,p.project_info_no desc";
		
		log.debug("查询sql:"+sql);
		//List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return radDao.queryRecordsBySQL(sql, page);
//		List list = page.getData();
//		
//		return list;
	}
	
	@SuppressWarnings("unchecked")
	public PageModel quertProject(Map<String,Object> map, PageModel page,UserToken user,String functionCode){
		Object projectInfoNo = map.get("projectInfoNo");
		Object projectName = map.get("projectName");
		Object projectId = map.get("projectId");
		Object projectType = map.get("projectType");
		Object isMainProject = map.get("isMainProject");
		Object projectStatus = map.get("projectStatus");
		Object orgName = map.get("orgName");
		Object orgSubjectionId = map.get("orgSubjectionId");
		Object explorationMethod = map.get("explorationMethod");
		Object projectArea = map.get("projectArea");
		Object viewType = map.get("viewType");
		IDataPermProcessor dpProc = (IDataPermProcessor)BeanFactory.getBean("ICGDataPermProcessor"); 
		
		String sql = "select p.*,ccsd.coding_name as manage_org_name,sap.prctr_name as prctr_name " +
				",ccsd1.coding_name as market_classify_name,p.design_end_date-p.design_start_date as duration_date,p6.object_id as project_object_id,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date"+
				",substr(dy.org_id,0,14) as org_id"+
				" from gp_task_project p  ";
		sql += " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method ";

		if (orgName != null&&orgName.toString().length()!=0) {
			sql += " left join comm_org_information oi on dy.org_id = oi.org_id and oi.org_name like '%"+orgName.toString()+"%'";
		}
		
		sql += "left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		
		sql += "left join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ";
		
		sql += " left join bgp_pm_sap_org sap on sap.prctr = p.prctr ";
		
		sql += " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0' ";
		
		sql += " left join gp_workarea_diviede wd on wd.workarea_no = p.workarea_no  and wd.bsflag = '0' ";
		
		sql += " where 1=1 and p.bsflag = '0' and p.project_father_no is null";
		
		if (projectInfoNo != null&&projectInfoNo.toString().length()!=0) {
			sql += " and p.project_info_no = '"+projectInfoNo.toString()+"'";
		}
		
		if (projectName != null&&projectName.toString().length()!=0) {
			sql += " and p.project_name like '%"+projectName.toString()+"%'";
		}
		if (projectId != null&&projectId.toString().length()!=0) {
			sql = sql +" and p.project_id like '%"+projectId.toString()+"%'";
		}
		if (projectType != null&&projectType.toString().length()!=0&&!"null".equals(projectType)) {
			String types[]=projectType.toString().split(",");
			String type="";
			for(int i=0;i<types.length;i++){
				type+="'"+types[i]+"'";
				if(i!=(types.length)-1) type+=",";
			}
			sql = sql +" and p.project_type in ("+type+")";
		}
		if (isMainProject != null&&isMainProject.toString().length()!=0) {
			sql = sql +" and p.is_main_project like '%"+isMainProject.toString()+"%'";
		}
		if (projectStatus != null&&projectStatus.toString().length()!=0) {
			sql = sql +" and p.project_status like '%"+projectStatus.toString()+"%'";
		}
		if (explorationMethod != null&&explorationMethod.toString().length()!=0) {
			sql = sql +" and p.exploration_method like '%"+explorationMethod.toString()+"%'";
		}
		if (projectArea != null&&projectArea.toString().length()!=0) {
			sql = sql +" and wd.region_name like '%"+projectArea.toString()+"%'";
		}
		if (null!=viewType&&viewType.toString().length()!=0) {
			sql = sql +" and p.view_type like '%"+viewType.toString()+"%'";
		}
		
		sql = sql + " order by p.project_status ,p.project_info_no desc ";
		
//		DataPermission dp = dpProc.getDataPermission(user, functionCode, sql);
//		
//		sql = dp.getFilteredSql();
		
//		//从p_auth_filter_scope获取权限范围
//		
//		String getScopeIdSql = "select f.org_id,s.org_subjection_id from p_auth_filter_scope f join comm_org_subjection s on f.org_id = s.org_id and s.bsflag = '0' where f.user_id = '"+user.getUserId()+"'";
//		Map<String,Object> scopeIdMap = radDao.queryRecordBySQL(getScopeIdSql);
//		if(scopeIdMap != null){
//			String tempSql = sql.substring(0, sql.length()-1);
//			sql = tempSql + " or dataAuthOrg.ORG_CODE like '"+scopeIdMap.get("org_subjection_id").toString()+"%')";
//		}
		// 获取多施工队伍的项目ID 吴海军添加
		String projectInfoNos = proccessProjectOrg(user.getOrgId());

		String orgCode = user.getOrgCode();
		
		//wuhj 为大港各个中心人员的项目选择
		String dgOrgCode = "C105007001,C105007002,C105007089,C105007010,C105007011,C105007012,C105007013";
		
		if(dgOrgCode.indexOf(orgCode) !=-1 && orgCode.length()==10){
			orgCode = "C105007";
		}
		
		if (projectInfoNos.equals(""))
		{
			sql = " select distinct dataAuthView.* from ("
					+ sql
					+ ") dataAuthView ,  view_comm_org_information dataAuthOrg "
					+ "WHERE dataAuthView.org_id = dataAuthOrg.ORG_ID   AND ( dataAuthOrg.ORG_CODE LIKE '"
					+ orgCode + "%' ) ";

		} else
		{
			sql = " select distinct dataAuthView.* from ("
					+ sql
					+ ") dataAuthView ,  view_comm_org_information dataAuthOrg "
					+ "WHERE dataAuthView.org_id = dataAuthOrg.ORG_ID   AND ( dataAuthOrg.ORG_CODE LIKE '"
					+ user.getOrgCode()
					+ "%' or   dataAuthView.project_info_no in ("
					+ projectInfoNos + ") ) ";

		}

		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	/**
	 * 
	* @Title: proccessProjectOrg
	* @Description: 根据项目查询
	* @param @param projectInfoNo
	* @param @return    设定文件
	* @return List    返回类型
	* @throws
	 */
	private String proccessProjectOrg(String orgId)
	{
		//根据组织机构ID查询项目ID
		String proSQL = "select t1.project_info_no projectInfoNo from gp_task_project t1 , gp_task_project_dynamic t2 where t1.project_info_no = t2.project_info_no and length(t2.org_id) >14 and substr( t2.org_id ,16) like '%"+orgId+"%'";
 	
		List<Map> projectList = radDao.queryRecords(proSQL);
		//所有项目ID
		StringBuffer sb = new StringBuffer("");

		for(int i=0; i<projectList.size(); i++){
			Map map = projectList.get(i);
			if(i==0){
				sb.append("'"+map.get("projectinfono").toString().trim()+"'");
			} else {
				sb.append(",'"+map.get("projectinfono").toString().trim()+"'");
			}
		}
		
		return sb.toString();
	}
	public PageModel quertProjectDynamic(Map<String,Object> map, PageModel page){
		Object projectInfoNo = map.get("projectInfoNo");//请不要修改  get的参数 用到这个方法的请重写一个  不要公共 add by bianshen
		String sql = "select dy.*,oi.org_abbreviation as org_name from gp_task_project_dynamic dy ";
		sql += " join gp_task_project gp on gp.project_info_no = dy.project_info_no and gp.bsflag = '0' and dy.exploration_method = gp.exploration_method ";
		sql += " join comm_org_information oi on dy.org_id  like  '%'|| oi.org_id ||'%' and oi.bsflag = '0' ";
		sql += " where 1=1 and dy.bsflag = '0' ";
		if (projectInfoNo != null) {
			sql += " and gp.project_info_no = '"+projectInfoNo.toString()+"' ";
		}
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	public PageModel quertBgpReport(Map<String,Object> map, PageModel page){
		//Object projectInfoNo = map.get("projectInfoNo");
		Object projectInfoNo = map.get("project_info_no");
		String sql = "select * from gp_ops_bgp_report where 1=1 ";
		if (projectInfoNo != null) {
			sql += " and project_info_no = '"+projectInfoNo.toString()+"' ";
		}
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	
}