package com.bgp.mcs.service.pm.service.project;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class WsProjectMCSBean {
	
	private ILog log;
	private RADJdbcDao radDao;
	
	public WsProjectMCSBean() {
		this.log = LogFactory.getLogger(WsProjectMCSBean.class);
		this.radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	}
	
	/**
	 * 查询子项目
	 * @param map
	 * @param page
	 * @return
	 */
	public PageModel querySubProject(Map<String,Object> map, PageModel page){
		String projectFatherNo = map.get("projectFatherNo").toString();
		String projectInfoNo = map.get("projectInfoNo").toString();
		String orgSubjectionId = map.get("orgSubjectionId").toString();
		String sql = "";
		if(projectFatherNo!=null&&projectFatherNo.length()!=0){
			sql = " SELECT p.*,ccsd.coding_name as manage_org_name,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date " +
						 " FROM gp_task_project p " +
						 " JOIN gp_task_project_dynamic dy " +
						 " ON dy.project_info_no = p.project_info_no " +
						 " AND dy.bsflag = '0' " +
						 " AND p.bsflag='0' " +
						 " AND p.project_father_no='"+projectFatherNo+"' and dy.org_subjection_id like '%"+orgSubjectionId+"%'"+
						 " left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		}else{
			sql = " SELECT p.*,ccsd.coding_name as manage_org_name,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date " +
					 " FROM gp_task_project p " +
					 " JOIN gp_task_project_dynamic dy " +
					 " ON dy.project_info_no = p.project_info_no " +
					 " AND dy.bsflag = '0' " +
					 " AND p.bsflag='0' " +
					 " AND p.project_info_no='"+projectInfoNo+"' and dy.org_subjection_id like '%"+orgSubjectionId+"%'"+
					 " left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		}
		
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	/**
	 * 查询子项目  并且屏蔽未审核通过的子项目
	 * @param map
	 * @param page
	 * @return
	 */
	public PageModel querySubProjectWithValidate(Map<String,Object> map, PageModel page){
		String projectFatherNo = map.get("projectFatherNo").toString();
		String org_subjection_id = map.get("orgSubjectionId").toString();
		String sql = " SELECT p.*,ccsd.coding_name as manage_org_name,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date " +
				 " FROM gp_task_project p " +
				 " JOIN gp_task_project_dynamic dy " +
				 " ON dy.project_info_no = p.project_info_no " +
				 " AND dy.bsflag = '0' " +
				 " AND p.bsflag='0' " +
				 " AND p.project_father_no='"+projectFatherNo+"' and dy.org_subjection_id like '%"+org_subjection_id+"%'"+
				 " join common_busi_wf_middle wf on p.project_info_no = wf.business_id and wf.busi_table_name='gp_task_project' and wf.proc_status='3' "+
				 " left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		return radDao.queryRecordsBySQL(sql, page);
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
		Object projectFatherNo = map.get("projectFatherNo");
		Object viewType = map.get("viewType");
		Object obj = map.get("isSingle");
		String isSingle = "";
		if(obj!=null){
			isSingle = obj.toString();
		}
		
		
		String sql = "select p.*,ccsd.coding_name as manage_org_name,sap.prctr_name as prctr_name " +
				",ccsd1.coding_name as market_classify_name,p.design_end_date-p.design_start_date as duration_date,p6.object_id as project_object_id,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date"+
				",dy.org_id as org_id,dy.org_subjection_id as org_subjection_id, oi.org_abbreviation as team_name,dy.is_main_team as is_main_team"+
				" from gp_task_project p  ";
		sql += " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method ";
		
		if (orgSubjectionId != null) {
			sql += " and dy.org_subjection_id like '"+orgSubjectionId.toString()+"%'";
		}
		
		sql += " left join comm_org_information oi on dy.org_id = oi.org_id ";
		
		if (orgName != null&&orgName.toString().length()!=0) {
			sql += " and oi.org_name like '%"+orgName.toString()+"%'";
		}
		
		sql += " left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		
		sql += " left join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ";
		
		sql += " left join bgp_pm_sap_org sap on sap.prctr = p.prctr ";
		
		sql += " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0' ";
		
		sql += " where 1=1 and p.bsflag = '0' ";
		
		if (projectInfoNo != null&&projectInfoNo.toString().length()!=0) {
			sql += " and p.project_info_no = '"+projectInfoNo.toString()+"'";
		}
		
		if (projectName != null&&projectName.toString().length()!=0) {
			sql += " and p.project_name like '%"+projectName.toString()+"%'";
		}
		if (projectId != null&&projectId.toString().length()!=0) {
			sql = sql +" and p.project_id like '%"+projectId.toString()+"%'";
		}
		if (projectType != null&&projectType.toString().length()!=0) {
			sql = sql +" and p.project_type like '%"+projectType.toString()+"%'";
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
		if (projectFatherNo!=null&&projectFatherNo.toString().length()!=0) {
			sql = sql +" and p.project_father_no ='"+projectFatherNo.toString()+"'";
		}else if(isSingle.length()!=0){
			//如果该参数不为空 跳过project_father_no的验证
		}else{
			sql = sql +" and p.project_father_no is null";
		}
		if (viewType!=null&&viewType.toString().length()!=0) {
			sql = sql +" and p.view_type like '%"+viewType.toString()+"%'";
		}
		
		sql = sql + " order by p.modifi_date desc";
		
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	public PageModel quertProject(Map<String,Object> map, PageModel page,UserToken user,String functionCode){
		Object projectInfoNo = map.get("projectInfoNo");
		Object projectName = map.get("projectName");
		Object projectId = map.get("projectId");
		Object projectType = map.get("projectType");
		Object isMainProject = map.get("isMainProject");
		Object projectStatus = map.get("projectStatus");
		Object orgName = map.get("orgName");
		//Object orgSubjectionId = map.get("orgSubjectionId");
		Object explorationMethod = map.get("explorationMethod");
		Object projectFatherNo = map.get("projectFatherNo");
		Object viewType = map.get("viewType");
		//IDataPermProcessor dpProc = (IDataPermProcessor)BeanFactory.getBean("ICGDataPermProcessor"); 
		String sql = "select p.*,ccsd.coding_name as manage_org_name,sap.prctr_name as prctr_name " +
				",ccsd1.coding_name as market_classify_name,p.design_end_date-p.design_start_date as duration_date,p6.object_id as project_object_id,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date"+
				",dy.org_id as org_id,dy.org_subjection_id as org_subjection_id"+
				" from gp_task_project p  ";
		sql += " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method ";

		if (orgName != null) {
			sql += " left join comm_org_information oi on dy.org_id = oi.org_id and oi.org_name like '%"+orgName.toString()+"%'";
		}
		
		sql += "left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		
		sql += " left join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ";
		
		sql += " left join bgp_pm_sap_org sap on sap.prctr = p.prctr ";
		
		sql += " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0' ";
		
		sql += " where 1=1 and p.bsflag = '0' ";
		
		if (projectInfoNo != null&&projectInfoNo.toString().length()!=0) {
			sql += " and p.project_info_no = '"+projectInfoNo.toString()+"'";
		}
		
		if (projectName != null&&projectName.toString().length()!=0) {
			sql += " and p.project_name like '%"+projectName.toString()+"%'";
		}
		if (projectId != null&&projectId.toString().length()!=0) {
			sql = sql +" and p.project_id like '%"+projectId.toString()+"%'";
		}
		if (projectType != null&&projectType.toString().length()!=0) {
			sql = sql +" and p.project_type like '%"+projectType.toString()+"%'";
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
		if (projectFatherNo!=null&&projectFatherNo.toString().length()!=0){
			sql = sql +" and p.project_father_no ='"+projectFatherNo.toString()+"' ";
		}else{
			sql = sql +" and p.project_father_no is null ";
		}
		if (viewType!=null&&viewType.toString().length()!=0) {
			sql = sql +" and p.view_type like '%"+viewType.toString()+"%'";
		}
		
		sql = sql + " order by p.modifi_date desc";
		
		//获取多施工队伍的项目ID
		String projectInfoNos = proccessProjectOrg(user.getOrgId());
		
		if(projectInfoNos.equals("")){
			sql = " select distinct dataAuthView.* from (" + sql + ") dataAuthView ,  view_comm_org_information dataAuthOrg " +
					"WHERE dataAuthView.org_id = dataAuthOrg.ORG_ID   AND ( dataAuthOrg.ORG_CODE LIKE '"+user.getOrgCode()+"%' ) " ;
		
		} else {
			sql = " select distinct dataAuthView.* from (" + sql + ") dataAuthView ,  view_comm_org_information dataAuthOrg " +
					"WHERE dataAuthView.org_id = dataAuthOrg.ORG_ID   AND ( dataAuthOrg.ORG_CODE LIKE '"+user.getOrgCode()+"%' or   dataAuthView.project_info_no in ("+projectInfoNos+") ) " ;
		
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
		Object projectInfoNo = map.get("projectInfoNo");
		String sql = "select gp.well_no as well_no,gp.qualification_no as qualification_no,dy.*,oi.org_abbreviation as org_name from gp_task_project_dynamic dy ";
		sql += "  left join gp_task_project gp on gp.project_info_no = dy.project_info_no and gp.bsflag = '0' and dy.exploration_method = gp.exploration_method ";
		sql += "  left join comm_org_information oi on oi.org_id = substr(dy.org_id,0,14) and oi.bsflag = '0' ";
		sql += " where 1=1 and dy.bsflag = '0' ";
		if (projectInfoNo != null) {
			sql += " and gp.project_info_no = '"+projectInfoNo.toString()+"' ";
		}
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	
	public PageModel queryWork(Map<String,Object> map, PageModel page){
		Object projectInfoNo = map.get("projectInfoNo");
		String sql = "  ";
		
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	public PageModel quertBgpReport(Map<String,Object> map, PageModel page){
		Object projectInfoNo = map.get("project_info_no");
		String sql = "select * from gp_ops_bgp_report where 1=1 ";
		if (projectInfoNo != null) {
			sql += " and project_info_no = '"+projectInfoNo.toString()+"' ";
		}
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	
	/**
	 * 根据施工ID 查找施工队伍名称
	 * @param orgId  多值 ','
	 * @param page
	 * @return
	 */
	public PageModel getDynamicOrgNames(String orgId,PageModel page){
		String sql="select wm_concat(org_abbreviation) as org_name,wm_concat(org_id) as org_id from comm_org_information where org_id in('"+orgId+"') and bsflag = '0'";
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	
}