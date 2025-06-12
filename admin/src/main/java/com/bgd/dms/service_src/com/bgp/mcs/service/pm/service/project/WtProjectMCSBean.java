package com.bgp.mcs.service.pm.service.project;

import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.DataPermission;
import com.cnpc.jcdp.common.IDataPermProcessor;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

/**
 * 综合物化探项目信息操作类
 * @author zs
 *
 */
public class WtProjectMCSBean {
	private ILog log;
	private RADJdbcDao radDao;
	
	public WtProjectMCSBean() {
		this.log = LogFactory.getLogger(WtProjectMCSBean.class);
		this.radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	}
	
	public PageModel quertProject(Map<String,Object> map, PageModel page,UserToken user,String functionCode){
		Object projectInfoNo = map.get("projectInfoNo");
		Object projectName = map.get("projectName");
		Object projectId = map.get("projectId");
		Object projectType = map.get("projectType");
		Object isMainProject = map.get("isMainProject");
		Object projectStatus = map.get("projectStatus");
		Object orgName = map.get("orgName");
		Object explorationMethod = map.get("explorationMethod");
		Object viewType = map.get("viewType");
		IDataPermProcessor dpProc = (IDataPermProcessor)BeanFactory.getBean("ICGDataPermProcessor"); 
		String sql = "select p.*,sap.prctr_name as prctr_name " +
				",ccsd1.coding_name as market_classify_name,p.design_end_date-p.design_start_date as duration_date,p6.object_id as project_object_id,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date,"+
				//甲方单位 上级+''+本级
				"(select t.coding_name from comm_coding_sort_detail t "+
				"where t.coding_code_id=(select superior_code_id from comm_coding_sort_detail where coding_code_id=p.manage_org)"+
				")||' '||ccsd.coding_name as manage_org_name,"+
				"dy.org_id "+
				" from gp_task_project p  ";
		sql += " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method ";
		if (""!=orgName&&null!=orgName) {
			sql += " join comm_org_information oi on dy.org_id = oi.org_id and oi.org_name like '%"+orgName.toString()+"%'";
		}
		sql += "left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		sql += " join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ";
		sql += " left join bgp_pm_sap_org sap on sap.prctr = p.prctr ";
		sql += " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0' ";
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
		if (projectType != null) {
			sql = sql +" and p.project_type ='"+projectType.toString()+"'";
		}
		if (isMainProject != null) {
			sql = sql +" and p.is_main_project like '%"+isMainProject.toString()+"%'";
		}
		if (projectStatus != null) {
			sql = sql +" and p.project_status like '%"+projectStatus.toString()+"%'";
		}
		if (explorationMethod != null) {
			sql = sql +" and p.exploration_method like '%"+explorationMethod.toString()+"%'";
		}
		if (""!=viewType&&null!=viewType) {
			sql = sql +" and p.view_type like '%"+viewType.toString()+"%'";
		}
		sql = sql + " order by p.modifi_date desc";
		
		DataPermission dp = dpProc.getDataPermission_WT(user, functionCode, sql);
		
		sql = dp.getFilteredSql();
		log.debug("查询sql:"+sql);
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
		Object viewType = map.get("viewType");
		Object businessType = map.get("businessType");
		Object secondMainProject = map.get("secondMainProject");
		
		String sql = "select p.*,sap.prctr_name as prctr_name, " +
		//甲方单位 上级+''+本级
		"(select t.coding_name from comm_coding_sort_detail t "+
		"where t.coding_code_id=(select superior_code_id from comm_coding_sort_detail where coding_code_id=p.manage_org)"+
		")||' '||ccsd.coding_name as manage_org_name,"+
				"ccsd1.coding_name as market_classify_name,p.design_end_date-p.design_start_date as duration_date,p6.object_id as project_object_id,nvl(p.project_start_time,p.acquire_start_time) as start_date,nvl(p.project_end_time,p.acquire_end_time) as end_date"+
				",dy.org_id,te.proc_status "+
				"from gp_task_project p left join common_busi_wf_middle te on te.business_id = p.project_info_no and te.bsflag = '0' and te.business_type = '"+businessType+"' ";
		sql += " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method ";
		if (orgSubjectionId != null) {
			sql += " and dy.org_subjection_id like '"+orgSubjectionId.toString()+"%'";
		}
		if (""!=orgName&&null!=orgName) {
			sql += " join comm_org_information oi on dy.org_id = oi.org_id and oi.org_name like '%"+orgName.toString()+"%'";
		}
		sql += "left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ";
		sql += " join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ";
		sql += " left join bgp_pm_sap_org sap on sap.prctr = p.prctr ";
		sql += " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0' ";
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
		if (projectType != null) {
			sql = sql +" and p.project_type ='"+projectType.toString()+"'";
		}
		if (isMainProject != null) {
			sql = sql +" and p.is_main_project like '%"+isMainProject.toString()+"%'";
		}
		if (null!=secondMainProject&&""!=secondMainProject) {
			sql = sql +" and p.second_main_project like '%"+secondMainProject.toString()+"%'";
		}
		if (projectStatus != null) {
			sql = sql +" and p.project_status like '%"+projectStatus.toString()+"%'";
		}
		if (explorationMethod != null) {
			sql = sql +" and p.exploration_method like '%"+explorationMethod.toString()+"%'";
		}
		if (""!=viewType&&null!=viewType) {
			sql = sql +" and p.view_type like '%"+viewType.toString()+"%'";
		}
		sql = sql + " order by p.modifi_date desc";
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql, page);
	}
	
	public PageModel quertProjectDynamic(Map<String,Object> map, PageModel page){
		Object projectInfoNo = map.get("projectInfoNo");
		StringBuffer sb=new StringBuffer("select dy.* from gp_task_project_dynamic dy join gp_task_project gp "+
				"on gp.project_info_no = dy.project_info_no and gp.bsflag = '0' and dy.exploration_method = gp.exploration_method");
		if (""!=projectInfoNo&&null!=projectInfoNo) {
			sb.append(" and gp.project_info_no = '"+projectInfoNo.toString()+"' ");
		}
		log.debug("查询sql:"+sb.toString());
		return radDao.queryRecordsBySQL(sb.toString(), page);
	}
	
	/**
	 * 根据勘探方法ID 查找勘探方法名称
	 * @param methodIds  多值 ','
	 * @param page
	 * @return
	 */
	public PageModel getExplorationMethodNames(String codeIds,PageModel page){
		String sql="select wm_concat(coding_code_id) as coding_code_id," +
				   	"wm_concat(coding_name) as coding_name,"+
				   	//化学勘探特别处理
				   	"wm_concat(decode(coding_code_id,'5110000056000000005','5110000056000000005',superior_code_id)) as superior_code_id " +
				   "from comm_coding_sort_detail where coding_code_id in("+codeIds+") and bsflag = '0'";
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
		String sql="select wm_concat(org_abbreviation) as org_name,wm_concat(org_id) as org_id from comm_org_information where org_id in("+orgId+") and bsflag = '0'";
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
	 * 根据project_info_no查找工作量信息
	 * @param map
	 * @param page
	 * @return
	 */
	public PageModel quertWorkLoad(Map<String,Object> map,PageModel page,String methodIds){
		Object projectInfoNo = map.get("project_info_no");
		StringBuffer sb=new StringBuffer("select a.coding_code_id as exploration_method,a.coding_name as exploration_method_name,a.superior_code_id,"+
				"b.workload_id,b.line_num,b.line_length,b.line_unit,b.location_point,b.repeat_point,b.point_distance,b.line_distance,b.base_length,b.gravity_point,b.check_point,b.physics_point,b.well_point,b.project_info_no "+
				"from comm_coding_sort_detail a left join gp_wt_workload b on a.coding_code_id=b.exploration_method ");
		if (""!=projectInfoNo&&null!=projectInfoNo) {
			sb.append( " and b.project_info_no = '"+projectInfoNo.toString()+"' ");
		}
		if (""!=methodIds&&null!=methodIds) {
			sb.append( " where a.coding_code_id in ('5110000056000000045',"+methodIds+")");
		}else{
			sb.append( " where a.coding_code_id in ('5110000056000000045')");
		}
		log.debug("查询sql:"+sb.toString());
		return radDao.queryRecordsBySQL(sb.toString(),page);
	}
	
	/**
	 * 根据project_info_no查找质量指标信息
	 * @param map
	 * @param page
	 * @return
	 */
	public PageModel quertQuality(Map<String,Object> map,PageModel page,String methodIds){
		Object projectInfoNo = map.get("project_info_no");
		StringBuffer sb=new StringBuffer("select a.coding_code_id as exploration_method,a.coding_name as exploration_method_name,a.superior_code_id,"+
				"b.object_id,b.project_info_no,b.firstlevel_radio,b.qualified_radio,b.waster_radio,b.miss_radio "+
				"from comm_coding_sort_detail a left join bgp_pm_quality_index b on a.coding_code_id=b.exploration_method ");
		if (""!=projectInfoNo&&null!=projectInfoNo) {
			sb.append( " and b.project_info_no = '"+projectInfoNo.toString()+"' ");
		}
		if (""!=methodIds&&null!=methodIds) {
			sb.append( " where a.coding_code_id in ("+methodIds+")");
		}
		
		log.debug("查询sql:"+sb.toString());
		return radDao.queryRecordsBySQL(sb.toString(),page);
	}
	
	/**
	 * 根据project_info_no查找项目以往勘探程度
	 * @param map
	 * @param page
	 * @return
	 */
	public PageModel quertDegree(Map<String,Object> map,PageModel page,String methodIds){
		Object projectInfoNo = map.get("project_info_no");
		StringBuffer sb=new StringBuffer("select f.file_name,a.exploration_degree_id,a.de_org_name,a.de_exploration_method,a.de_view_type,a.de_instrument,a.de_scale,a.de_point_distance,a.de_line_distance,a.ucm_id "+
				"from gp_wt_exploration_degree a left join bgp_doc_gms_file f on a.ucm_id=f.ucm_id where a.bsflag = '0'");
		if (""!=projectInfoNo&&null!=projectInfoNo) {
			sb.append( " and a.project_info_no = '"+projectInfoNo.toString()+"' ");
		}
		
		log.debug("查询sql:"+sb.toString());
		return radDao.queryRecordsBySQL(sb.toString(),page);
	}
	
	/**
	 * 查找项目资源配置信息
	 * @param map
	 * @param page
	 * @return
	 */
	public PageModel quertProjectResources(Map<String,Object> map, PageModel page){
		Object projectInfoNo = map.get("projectInfoNo");
		//Object resourcesId = map.get("resourcesId");
		StringBuffer sql=new StringBuffer();
		sql.append("select p.project_info_no,p.project_department,p.project_name,dy.org_id,r.resources_id,r.working_group,r.team_manager,r.team_manager_f,r.instructor,r.time_limit,r.work_load,r.landform,r.create_date,e.employee_name,p1.project_name as create_unit " +
				"from gp_project_resources r left join gp_task_project p on r.project_info_no = p.project_info_no and p.bsflag='0' " +
				"left join gp_task_project_dynamic dy on p.project_info_no = dy.project_info_no and dy.bsflag='0' " +
				"left join comm_human_employee e on r.creator=e.employee_id " +
				"left join gp_task_project p1 on r.create_unit=p1.project_info_no "+
				"where r.bsflag='0'");
		if(null!=projectInfoNo&&""!=projectInfoNo){
			sql.append(" and r.project_info_no='"+projectInfoNo+"'");
		}
		//if(null!=resourcesId&&""!=resourcesId){
		//	sql.append(" and r.resources_id='"+resourcesId+"' ");
		//}
		log.debug("查询sql:"+sql);
		return radDao.queryRecordsBySQL(sql.toString(), page);
	}
}
