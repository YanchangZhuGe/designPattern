package com.bgp.mcs.service.pm.service.projectPlan;

import java.net.URLDecoder;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.pm.service.project.ProjectMCSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * （滩浅海）项目进度计划服务
 * @author 顾西炳
 * @version 1.0.0	2013-10-21
 */
public class TqhProjectPlanSrv extends BaseService {
	private ILog log;
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	private ProjectMCSBean projectMCSBean;
	
	public TqhProjectPlanSrv(){
		log = LogFactory.getLogger(TqhProjectPlanSrv.class);
		projectMCSBean = (ProjectMCSBean) BeanFactory.getBean("ProjectMCSBean");
	}
	
	public ISrvMsg getProjectPlan(ISrvMsg reqDTO) throws Exception{
		
		String project_info_no = reqDTO.getValue("project_info_no");
		
		//String object_id = reqDTO.getValue("object_id");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		PageModel page = new PageModel();
		
		//String sql = "select  p.*,temp.plan_num from bgp_tqh_project_plan p join ( select nvl(max(p1.base_plan_id),0)+1 as plan_num from bgp_tqh_project_plan p1 where p1.bsflag = '0' and p1.project_info_no = '"+project_info_no+"') temp on 1=1 where p.project_info_no = '"+project_info_no+"' and p.bsflag = '0' and p.base_plan_id is null ";
		//String sql = "select p.*, temp.plan_num,bp.object_id as PROJECT_PLAN_OBJECT_ID,bp.baseline_project_id as BASELINE_PLAN_OBJECT_ID "+
		//			 "from bgp_tqh_project_plan p join (select nvl(max(p1.base_plan_id), 0) + 1 as plan_num from bgp_tqh_project_plan p1 "+
		//			 "where p1.bsflag = '0' and p1.project_info_no = '"+project_info_no+"') temp on 1 = 1 left join bgp_p6_project bp on "+
		//			 "bp.project_info_no = p.project_info_no and bp.bsflag = '0' where p.project_info_no = '"+project_info_no+"'"+
		//			 "and p.bsflag = '0' and p.base_plan_id is null ";
		
//		String sql = "select p.object_id,p.project_info_no, p.project_name, p.design_line_num, p.design_object_workload, p.design_sp_num, p.exploration_method, "+
//					 "p.wa_method_no,p.start_date,p.end_date,p.duration_date,p.team_id,p.is_majorteam,p.team_leader,p.collect_leader,p.surface_monitor,p.powder_monitor, "+
//					 "p.instrument_monitor,p.dirll_leader,p.dirll_monitor,p.survey_leader,p.survey_monitor,p.geophysical_division,p.surface_leader,p.manage_org_name, "+
//					 "p.notes,p.acquire_leader,p.bsflag,p.updator_id,p.modifi_date,p.creator_id,p.create_date, p.update_date,p.org_id,p.org_subjection_id, "+
//					 "p.weather_delay,p.suface_leader,p.full_fold_workload,p.design_geophone_num, p.design_small_regraction_num,p.design_micro_measue_num, "+
//					 "p.design_drill_num,p.measure_km,p.design_sp_num_zy, p.design_geophone_area,p.design_execution_area,p.design_data_area,p.design_sp_area, "+
//					 "p.base_plan_id,temp.plan_num,bp.object_id as project_plan_object_id,bp.baseline_project_id as baseline_plan_object_id "+
//					 "from bgp_tqh_project_plan p join (select nvl(max(p1.base_plan_id), 0) + 1 as plan_num from bgp_tqh_project_plan p1 "+
//					 "where p1.bsflag = '0' and p1.project_info_no = '"+project_info_no+"') temp on 1 = 1 left join bgp_p6_project bp on "+
//					 "bp.project_info_no = p.project_info_no and bp.bsflag = '0' where p.project_info_no = '"+project_info_no+"'"+
//					 "and p.bsflag = '0' and p.base_plan_id is null ";
		String sql = " select p.*, temp.plan_num, bp.object_id as project_plan_object_id, bp.baseline_project_id as baseline_plan_object_id "+
					 " from bgp_tqh_project_plan p join ( select nvl(max(p1.base_plan_id), 0) + 1 as plan_num from bgp_qh_project_plan p1 "+
					 " where p1.bsflag = '0' and p1.project_info_no = '"+project_info_no+"') temp on 1 = 1 "+
					 " left join bgp_p6_project bp on bp.project_info_no = p.project_info_no and bp.bsflag = '0' "+
					 " where p.project_info_no = '"+project_info_no+"' and p.bsflag = '0' and p.base_plan_id is null " ;
		
		log.debug("查询sql:"+sql);
		page = radDao.queryRecordsBySQL(sql, page);
		
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			Map dateMap = projectMCSBean.getProjectDate(project_info_no);
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
		
		//map.put("project_name", "ceshi");
		//map.put("manage_org_name", "jaifangceshi");
		
		//msg.setValue("map", map);
		
		return msg;
	}
	
	public ISrvMsg getEditProjectPlan(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String project_info_no = reqDTO.getValue("project_info_no");
		
		String base_plan_id = reqDTO.getValue("base_plan_id");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		PageModel page = new PageModel();
		
		String sql = "select  * from bgp_tqh_project_plan p1 where p1.project_info_no = '"+project_info_no+"' and p1.bsflag = '0'";
		//String sql = "select p1.*,p2.object_id as PROJECT_PLAN_OBJECT_ID,p2.baseline_project_id as BASELINE_PLAN_OBJECT_ID from bgp_tqh_project_plan p1 "+
		//			 "left join bgp_p6_project p2 on p2.project_info_no = p1.project_info_no and p2.bsflag = '0' "+
		//			 "where p1.project_info_no = '"+project_info_no+"' and p1.bsflag = '0'";
		
		if(base_plan_id != null && base_plan_id != ""){
			sql += " and p1.base_plan_id = '"+base_plan_id+"'";
		}else{
			sql += " and p1.base_plan_id is null";
		}
		log.debug("查询sql:"+sql);
		page = radDao.queryRecordsBySQL(sql, page);
		
		List list = page.getData();
		
		//获取项目的目标项目Id
		//String getProjectBaselineIdSql = "select pp.object_id,pp.project_object_id from bgp_p6_project pp where pp.project_object_id = " +
		//								 " (select p.object_id from bgp_p6_project p where p.bsflag = '0' and p.project_object_id is null " +
		//								 " and p.project_info_no = '"+project_info_no+"') and pp.bsflag = '0'";
		
		//获取项目的目标项目id新
		String getProjectBaselineIdSql = "select pp.object_id as project_object_id,pp.baseline_project_id as object_id from bgp_p6_project pp where pp.bsflag = '0' " +
				                         "and pp.project_object_id is null and pp.project_info_no = '"+project_info_no+"'"; 
		
		Map projectBaselineIdMap = radDao.queryRecordBySQL(getProjectBaselineIdSql);
		if(projectBaselineIdMap != null){
			String projectBaselineId = projectBaselineIdMap.get("object_id").toString();
			String projectObjectId = projectBaselineIdMap.get("project_object_id").toString();
			msg.setValue("projectBaselineId", projectBaselineId);
			msg.setValue("projectObjectId", projectObjectId);
		}
		
		
		
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
			Map dateMap = projectMCSBean.getProjectDate(project_info_no);
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
		
		//map.put("project_name", "ceshi");
		//map.put("manage_org_name", "jaifangceshi");
		
		//msg.setValue("map", map);
		
		return msg;
	}
	
	public ISrvMsg getProjectPlanList(ISrvMsg reqDTO) throws Exception{
		
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String projectName = reqDTO.getValue("projectName");
		
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
		
		String sql = "select  * from bgp_tqh_project_plan where 1=1 and bsflag = '0' and base_plan_id is null";
		
		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			sql += " and project_info_no = '"+projectInfoNo+"' ";
		}
		
		if (orgSubjectionId != null && !"".equals(orgSubjectionId)) {
			sql += " and org_subjection_id like '%"+orgSubjectionId+"%' ";
		}
		
		if (projectName != null && !"".equals(projectName)) {
			sql += " and project_name like '%"+projectName+"%' ";
		}
		
		log.debug("查询sql:"+sql);
		page = radDao.queryRecordsBySQL(sql, page);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		return msg;
	}
	
	public ISrvMsg saveProjectPlan(ISrvMsg reqDTO) throws Exception{
		
		Map map = reqDTO.toMap();
		
		String[] key = {"project_name","manage_org_name","notes"};
		
		String temp = "";
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String projectInfoNo = map.get("project_info_no").toString();
		String object_id = reqDTO.getValue("object_id");
		//如果前台传过来的object_id 是空,判断添加重复
		if(object_id == null || object_id == ""){
			//如果已经存在初始计划,则不能再保存
			String checkSql = "select t.object_id from bgp_tqh_project_plan t where t.bsflag = '0' and t.base_plan_id is null and t.project_info_no = '"+projectInfoNo+"'";
			Map projectPlanMap = radDao.queryRecordBySQL(checkSql);
			
			if(projectPlanMap != null){
				msg.setValue("message", "alreadysaved");
			}else{
				for (int i = 0; i < key.length; i++) {
					temp = (String) map.get(key[i]);
					if (temp != null && !"".equals(temp)) {
						map.put(key[i], URLDecoder.decode(temp,"UTF-8"));
					}
				}
				
				UserToken user = reqDTO.getUserToken();
				map.put("bsflag", "0");
				map.put("updator_id", user.getEmpId());
				map.put("modifi_date", new Date());
				
				
				if (object_id == null || "".equals(object_id)) {
					//如果为空 则添加创建人
					map.put("creator_id", user.getEmpId());
					map.put("create_date", new Date());
				}
				
				String baseline_plan_object_id = (String) map.get("baseline_plan_object_id");
				if (baseline_plan_object_id != null || "".equals(baseline_plan_object_id)) {
					map.put("update_date", new Date());
				}
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_tqh_project_plan");
				
				final List<Map> list = new ArrayList<Map>();
				Set set = map.keySet();
				for (Iterator i = set.iterator(); i.hasNext();) {
					String keyName = (String) i.next();
					if (keyName.contains("obs_name_")) {
						Map map1 = new HashMap();
						map1.put("obs_name", map.get(keyName));
						
						keyName = keyName.replace("obs_name_", "");
						map1.put("object_id", keyName);
						list.add(map1);
					}
				}
				
				if (list != null && list.size() != 0) {
					JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
					//批量保存obs_name
					String sql = "update bgp_p6_project_wbs set obs_name = ? where object_id = ?";
					BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i) throws SQLException {
							Map activity = list.get(i);
							ps.setString(1, (String) activity.get("obs_name"));
							ps.setInt(2, Integer.parseInt((String) activity.get("object_id")));
						}
						
						@Override
						public int getBatchSize() {
							return list.size();
						}
					};
					
					jdbcTemplate.batchUpdate(sql.toString(), setter);
					
				}
					msg.setValue("message", "success");
			}
		}else {
			//直接进行修改操作
			for (int i = 0; i < key.length; i++) {
				temp = (String) map.get(key[i]);
				if (temp != null && !"".equals(temp)) {
					map.put(key[i], URLDecoder.decode(temp,"UTF-8"));
				}
			}
			
			UserToken user = reqDTO.getUserToken();
			map.put("bsflag", "0");
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			
			
			if (object_id == null || "".equals(object_id)) {
				//如果为空 则添加创建人
				map.put("creator_id", user.getEmpId());
				map.put("create_date", new Date());
			}
			
			String baseline_plan_object_id = (String) map.get("baseline_plan_object_id");
			if (baseline_plan_object_id != null || "".equals(baseline_plan_object_id)) {
				map.put("update_date", new Date());
			}
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_tqh_project_plan");
			
			final List<Map> list = new ArrayList<Map>();
			Set set = map.keySet();
			for (Iterator i = set.iterator(); i.hasNext();) {
				String keyName = (String) i.next();
				if (keyName.contains("obs_name_")) {
					Map map1 = new HashMap();
					map1.put("obs_name", map.get(keyName));
					
					keyName = keyName.replace("obs_name_", "");
					map1.put("object_id", keyName);
					list.add(map1);
				}
			}
			
			if (list != null && list.size() != 0) {
				JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
				//批量保存obs_name
				String sql = "update bgp_p6_project_wbs set obs_name = ? where object_id = ?";
				BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						Map activity = list.get(i);
						ps.setString(1, (String) activity.get("obs_name"));
						ps.setInt(2, Integer.parseInt((String) activity.get("object_id")));
					}
					
					@Override
					public int getBatchSize() {
						return list.size();
					}
				};
				
				jdbcTemplate.batchUpdate(sql.toString(), setter);
				
			}
				msg.setValue("message", "success");
		}
		return msg;
	}
	
	public ISrvMsg getTeamInfo(ISrvMsg reqDTO) throws Exception{
		
		String project_info_no = reqDTO.getValue("projectInfoNo");
		
		PageModel page = new PageModel();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		Map<String, Object> temp = null;
		
		String sql = "select  * from bgp_tqh_project_plan where project_info_no = '"+project_info_no+"' and bsflag = '0' ";
		log.debug("查询sql:"+sql);
		page = radDao.queryRecordsBySQL(sql, page);
		
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (list != null && list.size() != 0) {
			map = (Map) list.get(0);
		}
		
		sql = "select ot.team_id as team_id,gp.vsp_team_leader as team_leader from comm_org_team ot join gp_task_project_dynamic dy " +
				" on dy.project_info_no = '"+project_info_no+"' and dy.bsflag = '0' " +
				" and ot.org_id = dy.org_id " +
				" join gp_task_project gp on gp.project_info_no = dy.project_info_no and gp.bsflag = '0' "+
				"where ot.bsflag = '0' ";
		
		page = new PageModel();
		
		page = radDao.queryRecordsBySQL(sql, page);
		
		list = page.getData();
		
		if (list != null && list.size() != 0) {
			temp = (Map) list.get(0);
			map.putAll(temp);
		}
		
		sql = "select t2.coding_name||'级' as is_majorteam,dy.org_id as org_id from comm_int_qual_org_team t0 " +
				" join gp_task_project_dynamic dy on t0.org_id_a7 = dy.org_id and dy.bsflag = '0'" +
				" join comm_int_qual_teamqual_change t1 on t0.org_id=t1.team_id" +
				" join comm_coding_sort_detail t2 on t1.qual_level = t2.coding_code_id" +
				" where dy.project_info_no = '"+project_info_no+"' order by t1.change_date desc";
		
		page = new PageModel();
		
		page = radDao.queryRecordsBySQL(sql, page);
		
		list = page.getData();
		
		if (list != null && list.size() != 0) {
			temp = (Map) list.get(0);
			map.putAll(temp);
		}
		
		msg.setValue("map", map);
		
		return msg;
	}
	
	public ISrvMsg getOrgInfo(ISrvMsg reqDTO) throws Exception{
		
		String project_info_no = reqDTO.getValue("projectInfoNo");
		
		String sql = "select info.*,nvl(e.employee_name,l.employee_name) as employee_name from (" +
				" select d.employee_id, e.employee_gz,d.team, d.work_post, p.project_info_no " +
				" from bgp_human_prepare_human_detail d " +
				" left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0'" +
				" left join comm_human_employee_hr e on d.employee_id = e.employee_id and e.bsflag = '0' " +
				" where d.actual_start_date is not null " +
				" and d.bsflag = '0'" +
				" union all " +
				" select d.labor_id employee_id,l.if_engineer employee_gz,de.apply_team team,de.post work_post,d.project_info_no " +
				" from bgp_comm_human_labor_deploy d" +
				" left join bgp_comm_human_deploy_detail de on d.labor_deploy_id = de.labor_deploy_id and de.bsflag = '0' " +
				" left join bgp_comm_human_labor l on d.labor_id = l.labor_id and l.bsflag = '0' " +
				" where d.bsflag = '0' and project_info_no = '"+project_info_no+"' ) info" +
				" left join comm_human_employee e on e.employee_id = info.employee_id and e.bsflag = '0' " +
				" left join bgp_comm_human_labor l on l.labor_id = info.employee_id and l.bsflag = '0' " +
				" where 1=1";
		
		List infos = new ArrayList();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> infoMap = new HashMap<String, Object>();
		//队经理 0110000001000001220
		map.put("key", "team_leader");
		map.put("value", "0110000001000001220");
		infoMap.put("team_leader", "");
		infos.add(map);
		
		//采集分管副经理
		infoMap.put("collect_leader", "");
		
		//放线班长 0110000001000000108
		map = new HashMap<String, Object>();
		map.put("key", "surface_monitor");
		map.put("value", "0110000001000000108");
		infoMap.put("surface_monitor", "");
		infos.add(map);
		
		//爆炸班长 0110000001000000110
		map = new HashMap<String, Object>();
		map.put("key", "powder_monitor");
		map.put("value", "0110000001000000110");
		infoMap.put("powder_monitor", "");
		infos.add(map);
		
		//仪器组长 0110000001000000118
		map = new HashMap<String, Object>();
		map.put("key", "instrument_monitor");
		map.put("value", "0110000001000000118");
		infoMap.put("instrument_monitor", "");
		infos.add(map);
		
		//震源组长 0110000001000000411
		map = new HashMap<String, Object>();
		map.put("key", "acquire_leader");
		map.put("value", "0110000001000000411");
		infoMap.put("acquire_leader", "");
		infos.add(map);
		
		//钻井分管副经理
		infoMap.put("dirll_leader", "");
		
		//钻井组长
		infoMap.put("dirll_monitor", "");
		
		//测量分管副经理
		infoMap.put("survey_leader", "");
		
		//测量项目长 0110000001000000101
		map = new HashMap<String, Object>();
		map.put("key", "survey_monitor");
		map.put("value", "0110000001000000101");
		infoMap.put("survey_monitor", "");
		infos.add(map);
		
		//地球物理师 0110000001000000320
		map = new HashMap<String, Object>();
		map.put("key", "geophysical_division");
		map.put("value", "0110000001000000320");
		infoMap.put("geophysical_division", "");
		infos.add(map);
		
		//表层调查组组长 0110000001000000304
		map = new HashMap<String, Object>();
		map.put("key", "suface_leader");
		map.put("value", "0110000001000000304");
		infoMap.put("suface_leader", "");
		infos.add(map);
		
		PageModel page = new PageModel();
		
		page.setPageSize(100);
		
		page = radDao.queryRecordsBySQL(sql, page);
		
		Map<String, Object> temp = null;
		
		List list = page.getData();
		
		for (int i = 0; i < list.size(); i++) {
			temp = (Map) list.get(i);
			String temp_projectno = (String)temp.get("project_info_no");
			if(project_info_no.equals(temp_projectno) || project_info_no == temp_projectno){
				for (int j = 0; j < infos.size(); j++) {
					map  = (Map) infos.get(j);
					if ((String)temp.get("work_post") == (String)map.get("value") || ((String)map.get("value")).equals((String)temp.get("work_post")) ) {
						infoMap.put((String)map.get("key"), temp.get("employee_name"));
						infos.remove(j);
						j--;
						break;
					}
				}
			}
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("map", infoMap);
		
		return msg;
	}
	
	public ISrvMsg getActivity(ISrvMsg reqDTO) throws Exception{
		
		String object_id = reqDTO.getValue("objectId");//计划项目的主键
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String[] measure2Type = {"G02003","G02004"};
		String[] measure3Type = {"G2003","G2004"};
		
		String[] drill2Type = {"G05001"};
		String[] drill3Type = {"G5001"};
		
		String[] coll2Type = {"G07001","G07003","G07005"};
		String[] coll3Type = {"G7001","G7003","G7005"};
		
		String[] surface2Type = {"G04001","G04002"};
		String[] surface3Type = {"G4001","G4002"};
		
		PageModel page = new PageModel();
		
		page.setPageSize(1000);
		
		String sql = "select exploration_method from gp_task_project  where project_info_no = '"+projectInfoNo+"' and bsflag = '0'";
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String exploration_method = null;
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			exploration_method = (String) map.get("exploration_method");
		} else {
			return msg;
		}
		
		String sqlTemp = null;
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			//表层
			for (int i = 0; i < surface2Type.length; i++) {
				sqlTemp = sqlTemp + surface2Type[i] + "','";
			}
			
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			
			//表层
			for (int i = 0; i < surface3Type.length; i++) {
				sqlTemp = sqlTemp + surface3Type[i] + "','";
			}
			
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		}
		
		sql = "select wbs.object_id,wbs.name from bgp_p6_project_wbs wbs " +
				" join bgp_p6_project p on p.object_id = '"+object_id+"' " +
						"and wbs.project_object_id = p.object_id " +
						"and wbs.parent_object_id = p.wbs_object_id" +
				" where wbs.bsflag = '0' order by sequence_number";
		
		page = radDao.queryRecordsBySQL(sql, page);
		
		list = page.getData();
		List temp = null;
		List list1 = new ArrayList();
		
		for (int i = 0; i < list.size(); i++) {
			Map map = (Map) list.get(i);
			List temp1 = new ArrayList();
			//得到wbs排序 然后根据wbs查询任务 再排序
			//wbs分层层内排序
			sql = "select object_id from bgp_p6_project_wbs where bsflag = '0' start with object_id = '"+map.get("object_id")+"' connect by prior object_id = parent_object_id order siblings by sequence_number";
			page = radDao.queryRecordsBySQL(sql, page);
			List tempList = page.getData();
			int listSize = 0;
			if (tempList != null && tempList.size() != 0) {
				for (int j = 0; j < tempList.size(); j++) {
					Map tempMap = (Map) tempList.get(j);
					sql = "select distinct a.id,a.wbs_name,a.name,a.wbs_code,a.wbs_object_id,a.planned_start_date,a.planned_finish_date,a.planned_duration,sum(nvl(p.planned_units, 0)) over(partition by a1.object_id) as planned_units,wbs.obs_name " +
							" from bgp_p6_activity a,bgp_p6_project gp,bgp_p6_project_wbs wbs,bgp_p6_activity a1 " +
							" left join bgp_p6_workload p " +
							" on p.activity_object_id = a1.object_id" +
							" and p.bsflag = '0' and p.produce_date is null" +
							sqlTemp +
							" where a.bsflag = '0' " +
							" and gp.object_id = a.project_object_id " +
							" and gp.project_object_id = a1.project_object_id " +
							" and a1.id = a.id " +
							" and a1.bsflag = '0' "+
							" and a.wbs_object_id = wbs.object_id " +
							" and a.wbs_object_id = '"+tempMap.get("object_id")+"' " +
							" and wbs.bsflag = '0' "+
							" order by a.id ";
					page = radDao.queryRecordsBySQL(sql, page);
					temp = page.getData();
					listSize += temp.size();
					
					temp1.addAll(temp);
				}
			}
			map.put("listSize", listSize);
			temp1.add(0, map);
			list1.addAll(temp1);
		}
		
		msg.setValue("datas", list1);
		
		return msg;
	}
	
	public ISrvMsg getBackupActivity(ISrvMsg reqDTO) throws Exception{
		
		String object_id = reqDTO.getValue("objectId");//计划项目的主键
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String plan_num = reqDTO.getValue("basePlanId");
		
		String[] measure2Type = {"G02003","G02004"};
		String[] measure3Type = {"G2003","G2004"};
		
		String[] drill2Type = {"G05001"};
		String[] drill3Type = {"G5001"};
		
		String[] coll2Type = {"G07001","G07003","G07005"};
		String[] coll3Type = {"G7001","G7003","G7005"};
		
		String[] surface2Type = {"G04001","G04002"};
		String[] surface3Type = {"G4001","G4002"};
		
		PageModel page = new PageModel();
		
		page.setPageSize(1000);
		
		String sql = "select exploration_method from gp_task_project  where project_info_no = '"+projectInfoNo+"' and bsflag = '0'";
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String exploration_method = null;
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			exploration_method = (String) map.get("exploration_method");
		} else {
			return msg;
		}
		
		String sqlTemp = null;
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			//表层
			for (int i = 0; i < surface2Type.length; i++) {
				sqlTemp = sqlTemp + surface2Type[i] + "','";
			}
			
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			//表层
			for (int i = 0; i < surface3Type.length; i++) {
				sqlTemp = sqlTemp + surface3Type[i] + "','";
			}
			
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		}
		
		sql = "select wbs.object_id,wbs.name from bgp_p6_project_wbs_backup wbs " +
				" join bgp_p6_project p on p.object_id = '"+object_id+"' " +
						"and wbs.project_object_id = p.object_id " +
						"and wbs.parent_object_id = p.wbs_object_id" +
				" where wbs.bsflag = '0' and wbs.plan_num = '"+plan_num+"' order by sequence_number";
		
		page = radDao.queryRecordsBySQL(sql, page);
		
		list = page.getData();
		List temp = null;
		List list1 = new ArrayList();
		
		for (int i = 0; i < list.size(); i++) {
			Map map = (Map) list.get(i);
			List temp1 = new ArrayList();
			//得到wbs排序 然后根据wbs查询任务 再排序
			//wbs分层层内排序
			sql = "select object_id from bgp_p6_project_wbs_backup where bsflag = '0' and plan_num = '"+plan_num+"' start with object_id = '"+map.get("object_id")+"' connect by prior object_id = parent_object_id order siblings by sequence_number";
			page = radDao.queryRecordsBySQL(sql, page);
			List tempList = page.getData();
			int listSize = 0;
			if (tempList != null && tempList.size() != 0) {
				for (int j = 0; j < tempList.size(); j++) {
					Map tempMap = (Map) tempList.get(j);
					sql = "select distinct a.id,a.wbs_name,a.name,a.wbs_code,a.wbs_object_id,a.planned_start_date,a.planned_finish_date,a.planned_duration,sum(nvl(p.planned_units, 0)) over(partition by a1.object_id) as planned_units,wbs.obs_name " +
							" from bgp_p6_activity_backup a,bgp_p6_project gp,bgp_p6_project_wbs_backup wbs,bgp_p6_activity a1 " +
							" left join bgp_p6_workload p " +
							" on p.activity_object_id = a1.object_id" +
							" and p.bsflag = '0' and p.produce_date is null" +
							sqlTemp +
							" where a.bsflag = '0' " +
							" and a.plan_num = '"+plan_num+"'" +
							" and gp.object_id = a.project_object_id " +
							" and gp.project_object_id = a1.project_object_id " +
							" and a1.id = a.id " +
							" and a1.bsflag = '0' "+
							" and a.wbs_object_id = wbs.object_id " +
							" and a.wbs_object_id = '"+tempMap.get("object_id")+"' " +
							" and wbs.bsflag = '0' "+
							" order by a.id ";
					page = radDao.queryRecordsBySQL(sql, page);
					temp = page.getData();
					listSize += temp.size();
					
					temp1.addAll(temp);
				}
			}
			map.put("listSize", listSize);
			temp1.add(0, map);
			list1.addAll(temp1);
		}
		
		msg.setValue("datas", list1);
		
		return msg;
	}
	
	public ISrvMsg getWorkLoad(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String sql = "select p.activity_name,sum(nvl(p.planned_units,0)) as planned_units,p.resource_id,p.resource_name,sum(a.planned_duration) as  planned_duration,round(sum(nvl(p.planned_units,0))/sum(a.planned_duration),2) as average_units "+
				",min(a.planned_start_date) as planned_start_date,max(a.planned_finish_date) as planned_finish_date "+
				" from bgp_p6_workload p " +
				" join bgp_p6_activity a "+
				" on a.object_id = p.activity_object_id "+
				" and a.bsflag = '0' "+
				"where p.project_info_no = '"+projectInfoNo+"' and p.bsflag = '0' "+ 
				" group by p.activity_object_id,p.activity_name,p.resource_id,p.resource_name "+
				" order by p.activity_object_id";
		
		PageModel page = new PageModel();
		
		page.setPageSize(99999);
		
		page = radDao.queryRecordsBySQL(sql, page);
		
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", list);
		
		return msg;
	}
	
	/**
	 * 获取项目计划列表,包括基本计划和修改的计划
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllPlanList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String getAllPlanListSql = "";
		
		if(projectInfoNo != null && projectInfoNo != ""){
			//单项目
			String checkPlanSaved = "select t.object_id from bgp_tqh_project_plan t where t.bsflag = '0' and t.base_plan_id is null and t.project_info_no = '"+projectInfoNo+"'";
			//判断该项目的项目计划是否被保存
			if(radDao.queryRecordBySQL(checkPlanSaved) != null){
					getAllPlanListSql = "select p.object_id,p.project_info_no,p.project_name,p.baseline_plan_object_id, " +
										" t.proc_status as proc_status_value,decode(t.proc_status, '1', '待审批', '3', '审批通过','4','审批不通过','未提交') proc_status, "+
				                        " (case nvl(p.base_plan_id, 0) when '0' then '初始计划' else '变更计划'||p.base_plan_id end) as plan_name,"+
				                        " p.team_id,p.create_date,p.base_plan_id from bgp_tqh_project_plan p left outer join common_busi_wf_middle t on p.object_id = t.business_id and t.bsflag = '0' where p.bsflag = '0' "+
						                " and p.project_info_no = '"+projectInfoNo+"' order by p.modifi_date desc";
			}else{
					getAllPlanListSql = "select '' as object_id,p.project_id,p.project_info_no,p.project_name,oi.org_name as team_id,'' as proc_status,'0' as proc_status_value,'未保存' as plan_name,'' as create_date,'' as base_plan_id,'0' as add_flag "+
										" from gp_task_project p join gp_task_project_dynamic d on p.project_info_no = d.project_info_no "+
										" and d.bsflag = '0' join comm_org_information oi on d.org_id = oi.org_id "+
										" where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"' order by p.modifi_date desc";
			}
		}else{
			//多项目
					getAllPlanListSql = "select p.object_id,p.project_info_no,p.project_name,p.baseline_plan_object_id, " +
									    " t.proc_status as proc_status_value,decode(t.proc_status, '1', '待审批', '3', '审批通过','4','审批不通过','未提交') proc_status, "+
						                " (case nvl(p.base_plan_id, 0) when '0' then '初始计划' else '变更计划'||p.base_plan_id end) as plan_name,"+
						                " p.team_id,p.create_date,p.base_plan_id from bgp_tqh_project_plan p left outer join common_busi_wf_middle t on p.object_id = t.business_id and t.bsflag = '0' where p.bsflag = '0' order by p.modifi_date desc";			
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
		
		page = radDao.queryRecordsBySQL(getAllPlanListSql, page);
		List list = page.getData();
		
		msg.setValue("datas", list);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	
	/**
	 * 保存变更计划的信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveProjectBackUpPlan(ISrvMsg reqDTO) throws Exception{
		
		Map map = reqDTO.toMap();
		
		String[] key = {"project_name","manage_org_name","notes"};
		
		String temp = "";
		
		for (int i = 0; i < key.length; i++) {
			temp = (String) map.get(key[i]);
			if (temp != null && !"".equals(temp)) {
				map.put(key[i], URLDecoder.decode(temp,"UTF-8"));
			}
		}
		
		UserToken user = reqDTO.getUserToken();
		
		map.put("bsflag", "0");
		map.put("updator_id", user.getEmpId());
		map.put("modifi_date", new Date());
		//变更计划的版本存放在BASE_PLAN_ID中
		map.put("base_plan_id",map.get("plan_num_value"));
		
		String object_id = reqDTO.getValue("object_id");
		String baseline_plan_object_id = (String) map.get("baseline_plan_object_id");
		String project_info_no = (String) map.get("project_info_no");
		
		if (object_id == null || "".equals(object_id)) {
			//如果为空 则添加创建人
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
			
			if (baseline_plan_object_id != null || "".equals(baseline_plan_object_id)) {
				map.put("update_date", new Date());
				//获取目标计划的信息,并复制到备份表里
				String insertProjectWbs = "insert into bgp_p6_project_wbs_backup (backup_object_id,object_id,project_id,name,code,"+
										  " sequence_number,obs_name,obs_id,parent_object_id,modifi_date,bsflag,creator_id,create_date,updator_id,project_object_id,obs_object_id,plan_num)"+ 
										  " select sys_guid(),w.object_id,w.project_id,w.name,w.code,w.sequence_number,w.obs_name,"+
										  " w.obs_id,w.parent_object_id,w.modifi_date,'0',w.creator_id,w.create_date,w.updator_id,w.project_object_id,w.obs_object_id,'"+map.get("plan_num_value")+"' from"+
										  " bgp_p6_project_wbs w where w.bsflag = '0' and w.project_object_id = "+baseline_plan_object_id;
				/**
				 * TODO
				 */
				radDao.executeUpdate(insertProjectWbs);
				String insertProjectActivity = "insert into bgp_p6_activity_backup (backup_object_id,actual_finish_date,actual_start_date,id,name,planned_finish_date,planned_start_date,project_id,"+
												" project_name,project_object_id,status,wbs_code,wbs_name,wbs_object_id,suspend_date,resume_date,notes_to_resources,"+
												" object_id,expected_finish_date,planned_duration,finish_date,start_date,modifi_date,updator_id,remaining_duration,"+
												" bsflag,calendar_name,calendar_object_id,submit_flag,creator_id,create_date,percent_complete,plan_num)"+
												" select sys_guid(),w.actual_finish_date,w.actual_start_date,w.id,w.name,w.planned_finish_date,w.planned_start_date,w.project_id,"+
												" w.project_name,w.project_object_id,w.status,w.wbs_code,w.wbs_name,w.wbs_object_id,w.suspend_date,w.resume_date,w.notes_to_resources,"+
												" w.object_id,w.expected_finish_date,w.planned_duration,w.finish_date,w.start_date,w.modifi_date,w.updator_id,w.remaining_duration,"+
												" w.bsflag,w.calendar_name,w.calendar_object_id,w.submit_flag,w.creator_id,w.create_date,w.percent_complete,'"+map.get("plan_num_value")+"'"+
												" from bgp_p6_activity w where w.bsflag = '0' and w.project_object_id = "+baseline_plan_object_id; 
				radDao.executeUpdate(insertProjectActivity);
			}
		}else{
			if(map.get("plan_num_value") != null && map.get("plan_num_value") != ""){
				//是变更计划. 重新给变更计划选择了目标计划,如果该目标计划是第一次分配,则写入到数据库中
				String checkProjectExist = "select w.object_id from bgp_tqh_project_plan w where w.bsflag = '0' and w.project_info_no = '"+project_info_no+"' and w.base_plan_id = '"+map.get("plan_num_value")+"'";
				List<Map> list = radDao.queryRecords(checkProjectExist);
				if(list.size() == 0){
					String checkWbsExist = "select w.object_id from bgp_p6_project_wbs_backup w where w.bsflag = '0' and w.project_object_id = '"+baseline_plan_object_id+"' and w.plan_num = '"+map.get("plan_num_value")+"'";
					List<Map> wbsList = radDao.queryRecords(checkWbsExist);
					if(wbsList.size() == 0){
						//写入数据
						map.put("creator_id", user.getEmpId());
						map.put("create_date", new Date());
						
						if (baseline_plan_object_id != null || "".equals(baseline_plan_object_id)) {
							map.put("update_date", new Date());
							//获取目标计划的信息,并复制到备份表里
							String insertProjectWbs = "insert into bgp_p6_project_wbs_backup (backup_object_id,object_id,project_id,name,code,"+
													  " sequence_number,obs_name,obs_id,parent_object_id,modifi_date,bsflag,creator_id,create_date,updator_id,project_object_id,obs_object_id,plan_num)"+ 
													  " select sys_guid(),w.object_id,w.project_id,w.name,w.code,w.sequence_number,w.obs_name,"+
													  " w.obs_id,w.parent_object_id,w.modifi_date,'0',w.creator_id,w.create_date,w.updator_id,w.project_object_id,w.obs_object_id,'"+map.get("plan_num_value")+"' from"+
													  " bgp_p6_project_wbs w where w.bsflag = '0' and w.project_object_id = "+baseline_plan_object_id;
							/**
							 * TODO
							 */
							radDao.executeUpdate(insertProjectWbs);
							String insertProjectActivity = "insert into bgp_p6_activity_backup (backup_object_id,actual_finish_date,actual_start_date,id,name,planned_finish_date,planned_start_date,project_id,"+
															" project_name,project_object_id,status,wbs_code,wbs_name,wbs_object_id,suspend_date,resume_date,notes_to_resources,"+
															" object_id,expected_finish_date,planned_duration,finish_date,start_date,modifi_date,updator_id,remaining_duration,"+
															" bsflag,calendar_name,calendar_object_id,submit_flag,creator_id,create_date,percent_complete,plan_num)"+
															" select sys_guid(),w.actual_finish_date,w.actual_start_date,w.id,w.name,w.planned_finish_date,w.planned_start_date,w.project_id,"+
															" w.project_name,w.project_object_id,w.status,w.wbs_code,w.wbs_name,w.wbs_object_id,w.suspend_date,w.resume_date,w.notes_to_resources,"+
															" w.object_id,w.expected_finish_date,w.planned_duration,w.finish_date,w.start_date,w.modifi_date,w.updator_id,w.remaining_duration,"+
															" w.bsflag,w.calendar_name,w.calendar_object_id,w.submit_flag,w.creator_id,w.create_date,w.percent_complete,'"+map.get("plan_num_value")+"'"+
															" from bgp_p6_activity w where w.bsflag = '0' and w.project_object_id = "+baseline_plan_object_id; 
							radDao.executeUpdate(insertProjectActivity);
						}
					}
				}
			}
		}
		
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_tqh_project_plan");
		
		final List<Map> list = new ArrayList<Map>();
		Set set = map.keySet();
		for (Iterator i = set.iterator(); i.hasNext();) {
			String keyName = (String) i.next();
			if (keyName.contains("obs_name_")) {
				Map map1 = new HashMap();
				map1.put("obs_name", map.get(keyName));
				
				keyName = keyName.replace("obs_name_", "");
				map1.put("object_id", keyName);
				list.add(map1);
			}
		}
		
		if (list != null && list.size() != 0) {
			JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
			//批量保存obs_name
			String sql = "update bgp_p6_project_wbs_backup set obs_name = ? where object_id = ?";
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i) throws SQLException {
					Map activity = list.get(i);
					ps.setString(1, (String) activity.get("obs_name"));
					ps.setInt(2, Integer.parseInt((String) activity.get("object_id")));
				}
				
				@Override
				public int getBatchSize() {
					return list.size();
				}
			};
			
			jdbcTemplate.batchUpdate(sql.toString(), setter);
			
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("message", "success");
		
		return msg;
	}
	
	/**
	 * 获取项目变更计划信息 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectBackUpActivity(ISrvMsg reqDTO) throws Exception{
		
		String object_id = reqDTO.getValue("objectId");//计划项目的主键
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String[] measure2Type = {"G02003","G02004"};
		String[] measure3Type = {"G2003","G2004"};
		
		String[] drill2Type = {"G05001"};
		String[] drill3Type = {"G5001"};
		
		String[] coll2Type = {"G07001","G07003","G07005"};
		String[] coll3Type = {"G7001","G7003","G7005"};
		
		PageModel page = new PageModel();
		
		page.setPageSize(1000);
		
		String sql = "select exploration_method from gp_task_project  where project_info_no = '"+projectInfoNo+"' and bsflag = '0'";
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String exploration_method = null;
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			exploration_method = (String) map.get("exploration_method");
		} else {
			return msg;
		}
		
		String sqlTemp = null;
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		}
		
		sql = "select wbs.* from bgp_p6_project_wbs_backup wbs " +
				" join bgp_p6_project p on p.object_id = '"+object_id+"' " +
						"and wbs.project_object_id = p.object_id " +
						"and wbs.parent_object_id = p.wbs_object_id" +
				" where wbs.bsflag = '0' order by sequence_number";
		
		page = radDao.queryRecordsBySQL(sql, page);
		
		list = page.getData();
		List temp = null;
		List list1 = new ArrayList();
		
		for (int i = 0; i < list.size(); i++) {
			Map map = (Map) list.get(i);
			List temp1 = new ArrayList();
			//得到wbs排序 然后根据wbs查询任务 再排序
			//wbs分层层内排序
			sql = "select * from bgp_p6_project_wbs_backup where bsflag = '0' start with object_id = '"+map.get("object_id")+"' connect by prior object_id = parent_object_id order siblings by sequence_number";
			page = radDao.queryRecordsBySQL(sql, page);
			List tempList = page.getData();
			int listSize = 0;
			if (tempList != null && tempList.size() != 0) {
				for (int j = 0; j < tempList.size(); j++) {
					Map tempMap = (Map) tempList.get(j);
					sql = "select distinct a.*,sum(nvl(p.planned_units, 0)) over(partition by a1.object_id) as planned_units,wbs.obs_name " +
							" from bgp_p6_activity_backup a,bgp_p6_project gp,bgp_p6_project_wbs_backup wbs,bgp_p6_activity_backup a1 " +
							" left join bgp_p6_workload p " +
							" on p.activity_object_id = a1.object_id" +
							" and p.bsflag = '0' and p.produce_date is null" +
							sqlTemp +
							" where a.bsflag = '0' " +
							" and gp.object_id = a.project_object_id " +
							" and gp.project_object_id = a1.project_object_id " +
							" and a1.id = a.id " +
							" and a1.bsflag = '0' "+
							" and a.wbs_object_id = wbs.object_id " +
							" and a.wbs_object_id = '"+tempMap.get("object_id")+"' " +
							" and wbs.bsflag = '0' "+
							" order by a.id ";
					page = radDao.queryRecordsBySQL(sql, page);
					temp = page.getData();
					listSize += temp.size();
					
					temp1.addAll(temp);
				}
			}
			map.put("listSize", listSize);
			temp1.add(0, map);
			list1.addAll(temp1);
		}
		
		msg.setValue("datas", list1);
		
		return msg;
	}
	
	/**
	 * 删除项目计划
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteProjectPlan(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String returnMsg = "fail";
		String object_id = reqDTO.getValue("objectId");
		String project_info_no = reqDTO.getValue("projectInfoNo");
		String base_plan_id = reqDTO.getValue("basePlanId");
		String baseline_plan_object_id = reqDTO.getValue("baselinePlanObjectId");
		String delProjectPlanSql = "update bgp_tqh_project_plan p set p.bsflag = '1' where p.object_id = '"+object_id+"'";
		if(radDao.executeUpdate(delProjectPlanSql)>0){
			returnMsg = "delplan";
			//String delBackupWbsSql = "update bgp_p6_project_wbs_backup w set w.bsflag = '1' where w.project_object_id = '"+baseline_plan_object_id+"' and w.plan_num = '"+base_plan_id+"'";
			String delBackupWbsSql = "delete from bgp_p6_project_wbs_backup w where w.project_object_id = '"+baseline_plan_object_id+"' and w.plan_num = '"+base_plan_id+"'";
			
			if(radDao.executeUpdate(delBackupWbsSql)>0){
				returnMsg = "delwbs";
				//String delBackupActivitySql = "update bgp_p6_activity_backup a set a.bsflag = '1' where a.project_object_id = '"+baseline_plan_object_id+"' and a.plan_num = '"+base_plan_id+"'";
				String delBackupActivitySql = "delete from bgp_p6_activity_backup a where a.project_object_id = '"+baseline_plan_object_id+"' and a.plan_num = '"+base_plan_id+"'";

				if(radDao.executeUpdate(delBackupActivitySql)>0){
					returnMsg = "ok";
				}
			}
		}
		msg.setValue("actionStatus", returnMsg);
		return msg;
	}
}
