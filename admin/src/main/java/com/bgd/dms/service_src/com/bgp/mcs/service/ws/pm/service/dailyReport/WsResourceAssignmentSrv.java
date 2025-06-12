package com.bgp.mcs.service.ws.pm.service.dailyReport;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.JAXBElement;
import javax.xml.datatype.XMLGregorianCalendar;

import net.sf.json.JSONArray;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.dailyReport.DailyReportSrv;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityMCSBean;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityWSBean;
import com.bgp.mcs.service.pm.service.p6.activity.activitycodeassignment.ActivityCodeAssignmentWSBean;
import com.bgp.mcs.service.pm.service.p6.activity.relationship.RelationshipWSBean;
import com.bgp.mcs.service.pm.service.p6.code.UDFValueWSBean;
import com.bgp.mcs.service.pm.service.p6.global.Calendar.CalendarWSBean;
import com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean;
import com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean;
import com.bgp.mcs.service.pm.service.p6.project.baselineproject.BaselineProjectWSBean;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.ResourceAssignmentMCSBean;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.ResourceAssignmentWSBean;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.workload.WorkloadMCSBean;
import com.bgp.mcs.service.pm.service.p6.util.JsonUtil;
import com.bgp.mcs.service.pm.service.p6.wbs.WbsWSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.primavera.ws.p6.activity.Activity;
import com.primavera.ws.p6.activity.ActivityExtends;
import com.primavera.ws.p6.activitycodeassignment.ActivityCodeAssignment;
import com.primavera.ws.p6.baselineproject.BaselineProject;
import com.primavera.ws.p6.project.Project;
import com.primavera.ws.p6.relationship.Relationship;
import com.primavera.ws.p6.resourceassignment.ResourceAssignment;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentExtends;
import com.primavera.ws.p6.udfvalue.UDFValue;
import com.primavera.ws.p6.wbs.WBS;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Jan 5, 2012
 * 
 * 描述：
 * 
 * 说明：
 */
public class WsResourceAssignmentSrv extends BaseService{
	
	private ILog log;
	private ActivityWSBean activityWSBean;
	private ActivityMCSBean activityMCSBean;
	private ResourceAssignmentMCSBean resourceAssignmentMCSBean;
	private WorkloadMCSBean workloadMCSBean;
	private CalendarWSBean calendarWSBean;
	private ActivityCodeAssignmentWSBean activityCodeAssignmentWSBean;
	private RelationshipWSBean relationshipWSBean;
	private ResourceAssignmentWSBean resourceAssignmentWSBean;
	private UDFValueWSBean udfValueWSBean;
	private BaselineProjectWSBean baselineProjectWSBean;
	private ProjectWSBean projectWSBean;
	private WbsWSBean wbsWSBean;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	
	public WsResourceAssignmentSrv() {
		log = LogFactory.getLogger(WsResourceAssignmentSrv.class);
		activityWSBean = (ActivityWSBean) BeanFactory.getBean("P6ActivityWSBean");
		activityMCSBean = (ActivityMCSBean) BeanFactory.getBean("P6ActivityMCSBean");
		resourceAssignmentMCSBean = (ResourceAssignmentMCSBean) BeanFactory.getBean("P6ResourceAssignmentMCSBean");
		calendarWSBean = (CalendarWSBean) BeanFactory.getBean("P6CalendarWSBean");
		workloadMCSBean = (WorkloadMCSBean) BeanFactory.getBean("P6WorkloadMCSBean");
		activityCodeAssignmentWSBean = (ActivityCodeAssignmentWSBean) BeanFactory.getBean("P6ActivityCodeAssignmentWSBean");
		relationshipWSBean = (RelationshipWSBean) BeanFactory.getBean("P6RelationshipWSBean");
		resourceAssignmentWSBean = (ResourceAssignmentWSBean) BeanFactory.getBean("P6ResourceAssignmentWSBean");
		udfValueWSBean = (UDFValueWSBean) BeanFactory.getBean("P6UDFValueWSBean");
		baselineProjectWSBean = (BaselineProjectWSBean) BeanFactory.getBean("P6BaselineProjectWSBean");
		projectWSBean =  (ProjectWSBean) BeanFactory.getBean("P6ProjectWSBean");
		wbsWSBean = (WbsWSBean) BeanFactory.getBean("P6WbsWSBean");
	}
	
	
	
	/**
	 * 获得项目下所有任务的依赖关系,并转化成json字符串
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@Deprecated
	public ISrvMsg getDependencies(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String objectId = null;
		
		String wbsObjectId = null;
		
		String epsObjectId = reqDTO.getValue("epsObjectId");
		
		if (epsObjectId != null && !"null".equals(epsObjectId)) {
			
			String sql = "select gp.object_id from "+
					" bgp_p6_project gp "+
					" join gp_task_project_dynamic dy "+
					" on dy.project_info_no = gp.project_info_no "+
					" and dy.bsflag = '0' "+
					" join comm_org_subjection os "+
					" on dy.org_subjection_id like os.org_subjection_id||'%' "+
					" join bgp_eps_code c "+
					" on c.org_id = os.org_id "+
					" and c.bsflag = '0' "+
					" and c.object_id = '"+epsObjectId+"' "+
					" where gp.bsflag = '0'";
			
			List list = jdbcDao.queryRecords(sql.toString());
			
			List projectObjectIds = new ArrayList();
			
			for (int i = 0; i < list.size(); i++) {
				projectObjectIds.add(((Map)list.get(i)).get("objectId"));
			}
			
			JsonUtil json = new JsonUtil();
			String js = json.listDependency(projectObjectIds);
			
			ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
			
			msg.setValue("json", js);
			
			return msg;
			
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				objectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				wbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			} else {
				objectId = reqDTO.getValue("projectObjectId");
				wbsObjectId = reqDTO.getValue("wbsObjectId");
			}
			
			JsonUtil json = new JsonUtil();
			String js = json.listDependency(Integer.parseInt(objectId));
			
			ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
			
			msg.setValue("json", js);
			return msg;
		}
		
	}
	
	/**
	 * 获得项目下所有的wbs与任务,并转化成json格式字符串
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@Deprecated
	public ISrvMsg getTasks(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String objectId = null;
		
		String wbsObjectId = null;
		
		if (projectInfoNo == null || "".equals(projectInfoNo) || "null".equals(projectInfoNo)) {
			objectId = reqDTO.getValue("projectObjectId");
			wbsObjectId = reqDTO.getValue("wbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				objectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				wbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		
		
		JsonUtil json = new JsonUtil();
		String js = json.list(Integer.parseInt(objectId), Integer.parseInt(wbsObjectId));
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("json", js);
		
		return msg;
	}
	
	/**
	 * 获得项目下所有的wbs与任务,并转化成json格式字符串
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryResourceAssignmentTree(ISrvMsg reqDTO) throws Exception {
		
		String objectId = reqDTO.getValue("taskObjectId");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String taskName = reqDTO.getValue("taskName");
		String taskNameValue = "";
		if(taskName != null && taskName != ""){
			taskNameValue = taskName.substring(0,taskName.indexOf("("));
		}
		
		if (objectId == null || "".equals(objectId)) {
			return null;
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		int object_id = Integer.parseInt(objectId);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("object_id", objectId);
		List<Map<String, Object>> list = activityMCSBean.queryActivityFromMCS(map);

		Map map1 = new HashMap();
		map1.put("activity_object_id", object_id);
		map1.put("object_id", null);
		
		String produceDate = reqDTO.getValue("produceDate");
		map1.put("produce_date", produceDate);
		
		List<Map<String,Object>> WorkLoadLlist = workloadMCSBean.queryWorkload(map1);//工作量
		msg.setValue("WorkLoadLlist", WorkLoadLlist);		
		msg.setValue("list", list);
		msg.setValue("map", list.get(0));
		msg.setValue("taskname",taskNameValue);
		
		double time = 0.0;//尚需天数
		
		if (time == 0) {
			time = ((BigDecimal) list.get(0).get("REMAINING_DURATION")).doubleValue()/((BigDecimal)list.get(0).get("HOURS_PER_DAY")).doubleValue();//预算小时数/日历
		}
		
		Double temp = Double.valueOf(time);
		if (temp.intValue() < time) {
			msg.setValue("remainingDuration", String.valueOf(temp.intValue() +1));
		} else {
			msg.setValue("remainingDuration", String.valueOf(temp.intValue()));
		}
		
		
		map1.clear();
		map1.put("projectInfoNo", projectInfoNo);
		map1.put("produceDate", produceDate);
		
		WsDailyReportSrv dailyReportSrv = new WsDailyReportSrv();
		Map daily = dailyReportSrv.getDailyReport(map1);
		
		String flag = null;
		if (daily != null) {
			if (daily.get("auditStatus") == "1" || "1".equals(daily.get("auditStatus"))) {
				flag = "Submited";
			} else if (daily.get("auditStatus") == "3" || "3".equals(daily.get("auditStatus"))) {
				flag = "Passed";
			} else if (daily.get("auditStatus") == "4" || "4".equals(daily.get("auditStatus"))) {
				flag = "notPassed";
			} else if (daily.get("auditStatus") == "0" || "0".equals(daily.get("auditStatus"))) {
				flag = "Saved";
			} else {
				flag = "notSaved";
			}
		}
		msg.setValue("flag", flag);
		
		return msg;
	}
	
public ISrvMsg getTaskTreeAjax(ISrvMsg reqDTO) throws Exception{
		
		String node = reqDTO.getValue("node");
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String objectId = null;
		
		String checked = reqDTO.getValue("checked");
		
		String wbsOnly = reqDTO.getValue("wbsOnly");
		
		
		String epsObjectId = reqDTO.getValue("epsObjectId");
		
		if (projectInfoNo == null || "".equals(projectInfoNo) || "null".equals(projectInfoNo)) {
			objectId = reqDTO.getValue("projectObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				objectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
			}
		}
		
		if (epsObjectId != null && !"null".equals(epsObjectId)) {
			//根节点展示eps
			
			if (node == null || "".equals(node) || "root".equals(node)) {//点击的节点id
				//点击eps
				StringBuffer sql = new StringBuffer("select 0 as id"); 
				sql.append(",c.eps_id as task_id");
				sql.append(",c.object_id as other1");
				sql.append(",'' as start_date");
				sql.append(",'' as end_date");
				sql.append(",c.eps_name as name");
				sql.append(",'' as paren_id");
				sql.append(",0 as percent_done");
				sql.append(",'false' as is_wbs");
				sql.append(",'false' as is_root");
				sql.append(",'fasle' as is_task"); 
				sql.append(" from bgp_eps_code c ");
				sql.append(" where c.bsflag = '0' ");
				sql.append(" and c.object_id = '"+epsObjectId+"'");
				List list = jdbcDao.queryRecords(sql.toString());
				
				for (int i = 0; i < list.size(); i++) {
					Map map = (Map) list.get(i);
					map.put("Id", map.get("id"));
					map.put("TaskId", map.get("taskId"));
					map.put("Name", map.get("name"));
				}
				JSONArray jsonArray = JSONArray.fromObject(list);
				
				ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
				
				if (jsonArray == null) {
					msg.setValue("json", "[]");
				} else {
					msg.setValue("json", jsonArray.toString());
				}
				//yyy
				return msg;
			} else {
				//判断是否是点击的项目一层
				if (node == "0" ||"0".equals(node)) {
					StringBuffer sql = new StringBuffer("select wbs_object_id as id");
							sql.append(",project_id as task_id");
							sql.append(",object_id as other1");
							sql.append(",'' as start_date");
							sql.append(",'' as end_date");
							sql.append(",tp.project_name as name");
							sql.append(",'' as paren_id");
							sql.append(",99 as percent_done");
							sql.append(",'true' as is_wbs");
							sql.append(",'true' as is_root");
							sql.append(",'fasle' as is_task");
							sql.append(" from bgp_p6_project gp ");
							sql.append(" join gp_task_project_dynamic dy ");
							sql.append(" on dy.project_info_no = gp.project_info_no ");
							sql.append(" and dy.bsflag = '0' ");
							sql.append(" join gp_task_project tp ");
							sql.append(" on tp.project_info_no = gp.project_info_no ");
							sql.append(" and tp.bsflag = '0' ");
							sql.append(" join comm_org_subjection os ");
							sql.append(" on dy.org_subjection_id like os.org_subjection_id||'%' ");
							sql.append(" join bgp_eps_code c ");
							sql.append(" on c.org_id = os.org_id ");
							sql.append(" and c.bsflag = '0' ");
							sql.append(" and c.object_id = '"+epsObjectId+"' ");
							sql.append(" where gp.bsflag = '0' ");
					List list = jdbcDao.queryRecords(sql.toString());			
					for (int i = 0; i < list.size(); i++) {
						Map map = (Map) list.get(i);
						map.put("Id", map.get("id"));
						map.put("TaskId", map.get("taskId"));
						map.put("Name", map.get("name"));
					}
					JSONArray jsonArray = JSONArray.fromObject(list);
					
					ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
					
					if (jsonArray == null) {
						msg.setValue("json", "[]");
					} else {
						msg.setValue("json", jsonArray.toString());
					}
					
					return msg;
				} else {
					StringBuffer sql = new StringBuffer("select w.object_id as id");
							sql.append(",w.code as task_id");
							sql.append(",w.name as name");
							sql.append(",temp1.start_date as start_date");
							sql.append(",temp1.finish_date as end_date" );
							sql.append(",temp1.planned_start_date as planned_start_date");
							sql.append(",temp1.planned_finish_date as planned_end_date");
							sql.append(",w.parent_object_id as parent_id");
							sql.append(",98 as percent_done");
							sql.append(",w.object_id as other1");
							sql.append(",'false' as leaf");
							sql.append(",'true' as is_wbs");
							sql.append(",'false' as is_root");
							sql.append(" from bgp_p6_project_wbs w ");
							sql.append(" join (select min(a.start_date) as start_date, ");
							sql.append(" max(a.finish_date) as finish_date, ");
							sql.append(" min(a.planned_start_date) as planned_start_date, ");
							sql.append(" max(a.planned_finish_date) as planned_finish_date  ");
							sql.append(" from bgp_p6_project_wbs wbs ");
							sql.append(" left join bgp_p6_activity a on a.wbs_object_id = wbs.object_id and a.bsflag = '0' ");
							sql.append(" start with wbs.parent_object_id = '"+node+"' and wbs.bsflag = '0' ");
							sql.append(" connect by prior wbs.object_id = wbs.parent_object_id ) temp1 " );
							sql.append(" on 1=1 " );
							sql.append(" where w.parent_object_id = '"+node+"' and w.bsflag = '0' ");
					if (wbsOnly == "true" || "true".equals(wbsOnly)) {
						
					} else {
						sql.append(" union all " );
						sql.append(" select to_number(to_char(a.object_id)||to_char(a.project_object_id)) as id" );
						sql.append(",a.id as task_id");
						sql.append(",a.name || ' (' || case status when 'Not Started' then '未开始' when 'In Progress' then '正在施工' else '完成' end || ')'as name" );
						sql.append(",a.start_date as start_date");
						sql.append(",a.finish_date as end_date" );
						sql.append(",a.planned_start_date as planned_start_date");
						sql.append(",a.planned_finish_date as planned_end_date");
						sql.append(",a.wbs_object_id as parent_id");
						sql.append(",a.percent_complete*100 as percent_done");
						sql.append(",a.object_id as other1");
						sql.append(",'true' as leaf");
						sql.append(",'false' as is_wbs");
						sql.append(",'false' as is_root");
						sql.append(" from bgp_p6_activity a ");
						sql.append(" where a.wbs_object_id = '"+node+"' and a.bsflag = '0' ");
						
					}
					sql.append( "  order by task_id");
					List list = jdbcDao.queryRecords(sql.toString());
					
					for (int i = 0; i < list.size(); i++) {
						Map map = (Map) list.get(i);
						
						map.put("Id", map.get("id"));
						map.put("TaskId", map.get("taskId"));
						map.put("Name", map.get("name"));
						map.put("PercentDone", map.get("percentDone"));
						map.put("StartDate", map.get("startDate"));
						map.put("EndDate", map.get("endDate"));					
						map.put("PlannedStartDate", map.get("plannedStartDate"));
						map.put("PlannedEndDate", map.get("plannedEndDate"));
						if (checked != null && "true".equals(checked)) {
							if ("true".equals((String)map.get("leaf"))) {
								map.put("checked", false);
							}
						}
					}
					
					JSONArray retJson = JSONArray.fromObject(list);
					
					ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
					
					if (retJson == null) {
						msg.setValue("json", "[]");
					} else {
						msg.setValue("json", retJson.toString());
					}
					
					return msg;
				}
			}
		} else {
			//展示单个项目的wbs和任务
			
			if (node == null || "".equals(node) || "root".equals(node)) {//点击的节点id
				//第一次进入
				//项目根节点
				StringBuffer sql = new StringBuffer("select bp.wbs_object_id as id");
				sql.append(",bp.project_id as task_id");
				sql.append(",bp.object_id as other1");
				sql.append(",'' as start_date" );
				sql.append(",'' as end_date" );
				sql.append(",tp.project_name as name" );
				sql.append(",'' as paren_id" );
				sql.append(",'' as percent_done" );
				sql.append(",'true' as is_wbs" );
				sql.append(",'true' as is_root" );
				sql.append(",'fasle' as is_task" );
				sql.append(",temp.project_actual_start_date as project_actual_start_date");
				sql.append(",temp3.project_actual_finish_date as project_actual_finish_date");
				sql.append(",temp.project_planned_start_date as project_planned_start_date");
				sql.append(",temp.project_planned_finish_date as project_planned_finish_date");
				sql.append(",0 as project_planned_duration");
				sql.append(",0 as project_remaining_duration");
				sql.append(" from bgp_p6_project bp");
				sql.append(" join gp_task_project tp ");
				sql.append(" on bp.project_info_no = tp.project_info_no ");
				sql.append(" and tp.bsflag = '0' ");
				sql.append(" join (select min(a.actual_start_date) as project_actual_start_date, ");
				sql.append(" min(a.planned_start_date) as project_planned_start_date, ");
				sql.append(" max(a.planned_finish_date) as project_planned_finish_date, ");					
				sql.append(" ROUND(TO_NUMBER(max(a.planned_finish_date) - min(a.planned_start_date)))+1 as project_planned_duration ");				
				sql.append(" from bgp_p6_activity a where a.project_object_id ='"+objectId+"' and a.bsflag = '0') temp ");
				sql.append(" on 1=1 ");		
				
				sql.append(" join (select (case max(temp4.count1) when 0 then max(pa.actual_finish_date) else to_date('','yyyy-MM-dd') end) ");
				sql.append(" as project_actual_finish_date from bgp_p6_activity pa join (select count(a.id) as count1 from bgp_p6_activity a ");
				sql.append(" where a.bsflag = '0' and a.project_object_id = '"+objectId+"' and a.status in ('In Progress','Not Started')) temp4 on 1=1 ");
				sql.append(" where pa.bsflag = '0' and pa.project_object_id = '"+objectId+"') temp3");					
				sql.append(" on 4=4 ");

				sql.append(" where bp.object_id = '"+objectId+"' and bp.bsflag = '0' ");
				System.out.println("sql"+sql);
				List list = jdbcDao.queryRecords(sql.toString());
				
				Map map = (Map) list.get(0);
				
				Integer ObjectId = Integer.valueOf(map.get("other1").toString());
				String projectActualStartDate = map.get("projectActualStartDate").toString();
				String projectActualFinishDate = map.get("projectActualFinishDate").toString();
				String projectPlannedStartDate = map.get("projectPlannedStartDate").toString();
				String projectPlannedFinishDate = map.get("projectPlannedFinishDate").toString();

				map.put("Id", map.get("id"));
				map.put("TaskId", map.get("taskId"));
				map.put("Name", map.get("name"));
				
				map.put("actualStartDate", projectActualStartDate);
				map.put("actualEndDate", projectActualFinishDate);
				map.put("plannedStartDate", projectPlannedStartDate);
				map.put("plannedEndDate", projectPlannedFinishDate);
				map.put("PercentDone", map.get("percentDone"));
				JSONArray jsonArray = JSONArray.fromObject(map);
				
				ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
				
				if (jsonArray == null) {
					msg.setValue("json", "[]");
				} else {
					msg.setValue("json", jsonArray.toString());
				}
				
				return msg;
			} else {
				//分级加载
				//根据传入的nodeid得到下一级的wbs以及任务
				StringBuffer sql = new StringBuffer("select w.object_id as id");
				sql.append(",w.sequence_number as order_id");
				sql.append(",w.code as task_id");
				sql.append(",w.name as name");
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as start_date" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as end_date" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as planned_start_date" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as planned_end_date" );
				sql.append(",w.parent_object_id as parent_id" );
				sql.append(",0 as percent_done" );
				sql.append(",w.object_id as other1");
				sql.append(",'false' as leaf");
				sql.append(",'true' as is_wbs" );
				sql.append(",'false' as is_root" );
				sql.append(",'fasle' as is_task" );
				sql.append(",0 as planned_duration" );
				sql.append(",0 as remaining_duration" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as actual_start_date" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as actual_end_date" );
				sql.append(" from bgp_p6_project_wbs w " );
				sql.append(" where w.parent_object_id = '"+node+"' and w.bsflag = '0'");
				if (wbsOnly == "true" || "true".equals(wbsOnly)) {
					
				} else {
					sql.append(" union all " );
					sql.append(" select to_number(to_char(a.object_id)||to_char(a.project_object_id)) as id" );
					sql.append(",to_number(substr(a.id,2)) as order_id");
					sql.append(",a.id as task_id");						
					sql.append(",a.name || ' (' || case status when 'Not Started' then '未开始' when 'In Progress' then '正在施工' else '完成' end || ')'as name" );
					sql.append(",a.start_date as start_date" );
					sql.append(",a.finish_date as end_date" );
					sql.append(",a.planned_start_date as planned_start_date" );
					sql.append(",a.planned_finish_date as planned_end_date" );
					sql.append(",a.wbs_object_id as parent_id" );
					sql.append(",a.percent_complete*100 as percent_done" );
					sql.append(",a.object_id as other1" );
					sql.append(",'true' as leaf");
					sql.append(",'false' as is_wbs" );
					sql.append(",'false' as is_root" );
					sql.append(",'true' as is_task" );
					sql.append(",a.planned_duration as planned_duration" );
					sql.append(",a.remaining_duration as remaining_duration" );
					sql.append(",a.actual_start_date as actual_start_date" );
					sql.append(",a.actual_finish_date as actual_end_date" );
					sql.append(" from bgp_p6_activity a ");
					sql.append(" where a.wbs_object_id = '"+node+"' and a.bsflag = '0'");
					
				}
				sql.append("  order by order_id,is_wbs");
				List list = jdbcDao.queryRecords(sql.toString());
				
				String checkHaveWbsSql  = "";
				String getFinishFlag = "";
				String getChildWbs = "";
				for (int i = 0; i < list.size(); i++) {
					Map map = (Map) list.get(i);
					map.put("Id", map.get("id"));
					map.put("TaskId", map.get("taskId"));
					map.put("orderId", map.get("orderId"));
					map.put("Name", map.get("name"));
					map.put("PercentDone", map.get("percentDone"));
					map.put("StartDate", map.get("actualStartDate"));
					map.put("EndDate", map.get("actualEndDate"));

					if (checked != null && "true".equals(checked)) {
						if ("true".equals((String)map.get("leaf"))) {
							map.put("checked", false);
						}
					}
				}
				
				JSONArray retJson = JSONArray.fromObject(list);
				
				ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
				
				if (retJson == null) {
					msg.setValue("json", "[]");
				} else {
					msg.setValue("json", retJson.toString());
				}
				
				return msg;
			}
		}
		
	}
	public ISrvMsg getTasksAjax(ISrvMsg reqDTO) throws Exception{
		     
		String node = reqDTO.getValue("node");
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String objectId = null;
		
		String checked = reqDTO.getValue("checked");
		
		String wbsOnly = reqDTO.getValue("wbsOnly");
		
		String wbsObjectId = null;
		
		String epsObjectId = reqDTO.getValue("epsObjectId");
		
		if (projectInfoNo == null || "".equals(projectInfoNo) || "null".equals(projectInfoNo)) {
			objectId = reqDTO.getValue("projectObjectId");
			wbsObjectId = reqDTO.getValue("wbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				objectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				wbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		String data_date = "";
		String baseLineProjectId = "";
		
		if(objectId != null){
			List<Project> projectInfoList = projectWSBean.getProjectFromP6(null, "ObjectId = "+objectId, null); 
			if(projectInfoList != null && projectInfoList.size() != 0){
				Project projectInfo = projectInfoList.get(0);
				data_date = P6TypeConvert.convert(projectInfo.getDataDate(),"yyyy-MM-dd HH:mm:ss");
				if(projectInfo.getCurrentBaselineProjectObjectId().getValue() != null){
					baseLineProjectId = projectInfo.getCurrentBaselineProjectObjectId().getValue().toString();
				}
			}
		}
		
		System.out.println("The data date is:"+data_date);
		System.out.println("The baseLineProjectId is:"+baseLineProjectId);
		
		if (epsObjectId != null && !"null".equals(epsObjectId)) {
			//根节点展示eps
			
			if (node == null || "".equals(node) || "root".equals(node)) {//点击的节点id
				//点击eps
				StringBuffer sql = new StringBuffer("select 0 as id"); 
				sql.append(",c.eps_id as task_id");
				sql.append(",c.object_id as other1");
				sql.append(",'' as start_date");
				sql.append(",'' as end_date");
				sql.append(",c.eps_name as name");
				sql.append(",'' as paren_id");
				sql.append(",0 as percent_done");
				sql.append(",'false' as is_wbs");
				sql.append(",'false' as is_root");
				sql.append(",'fasle' as is_task"); 
				sql.append(" from bgp_eps_code c ");
				sql.append(" where c.bsflag = '0' ");
				sql.append(" and c.object_id = '"+epsObjectId+"'");
				List list = jdbcDao.queryRecords(sql.toString());
				
				for (int i = 0; i < list.size(); i++) {
					Map map = (Map) list.get(i);
					map.put("Id", map.get("id"));
					map.put("TaskId", map.get("taskId"));
					map.put("Name", map.get("name"));
				}
				JSONArray jsonArray = JSONArray.fromObject(list);
				
				ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
				
				if (jsonArray == null) {
					msg.setValue("json", "[]");
				} else {
					msg.setValue("json", jsonArray.toString());
				}
				//yyy
				return msg;
			} else {
				//判断是否是点击的项目一层
				if (node == "0" ||"0".equals(node)) {
					StringBuffer sql = new StringBuffer("select wbs_object_id as id");
							sql.append(",project_id as task_id");
							sql.append(",object_id as other1");
							sql.append(",'' as start_date");
							sql.append(",'' as end_date");
							sql.append(",tp.project_name as name");
							sql.append(",'' as paren_id");
							sql.append(",99 as percent_done");
							sql.append(",'true' as is_wbs");
							sql.append(",'true' as is_root");
							sql.append(",'fasle' as is_task");
							sql.append(" from bgp_p6_project gp ");
							sql.append(" join gp_task_project_dynamic dy ");
							sql.append(" on dy.project_info_no = gp.project_info_no ");
							sql.append(" and dy.bsflag = '0' ");
							sql.append(" join gp_task_project tp ");
							sql.append(" on tp.project_info_no = gp.project_info_no ");
							sql.append(" and tp.bsflag = '0' ");
							sql.append(" join comm_org_subjection os ");
							sql.append(" on dy.org_subjection_id like os.org_subjection_id||'%' ");
							sql.append(" join bgp_eps_code c ");
							sql.append(" on c.org_id = os.org_id ");
							sql.append(" and c.bsflag = '0' ");
							sql.append(" and c.object_id = '"+epsObjectId+"' ");
							sql.append(" where gp.bsflag = '0' ");
					List list = jdbcDao.queryRecords(sql.toString());			
					for (int i = 0; i < list.size(); i++) {
						Map map = (Map) list.get(i);
						map.put("Id", map.get("id"));
						map.put("TaskId", map.get("taskId"));
						map.put("Name", map.get("name"));
					}
					JSONArray jsonArray = JSONArray.fromObject(list);
					
					ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
					
					if (jsonArray == null) {
						msg.setValue("json", "[]");
					} else {
						msg.setValue("json", jsonArray.toString());
					}
					
					return msg;
				} else {
					StringBuffer sql = new StringBuffer("select w.object_id as id");
							sql.append(",w.code as task_id");
							sql.append(",w.name as name");
							sql.append(",temp1.start_date as start_date");
							sql.append(",temp1.finish_date as end_date" );
							sql.append(",temp1.planned_start_date as planned_start_date");
							sql.append(",temp1.planned_finish_date as planned_end_date");
							sql.append(",w.parent_object_id as parent_id");
							sql.append(",98 as percent_done");
							sql.append(",w.object_id as other1");
							sql.append(",'false' as leaf");
							sql.append(",'true' as is_wbs");
							sql.append(",'false' as is_root");
							sql.append(" from bgp_p6_project_wbs w ");
							sql.append(" join (select min(a.start_date) as start_date, ");
							sql.append(" max(a.finish_date) as finish_date, ");
							sql.append(" min(a.planned_start_date) as planned_start_date, ");
							sql.append(" max(a.planned_finish_date) as planned_finish_date  ");
							sql.append(" from bgp_p6_project_wbs wbs ");
							sql.append(" left join bgp_p6_activity a on a.wbs_object_id = wbs.object_id and a.bsflag = '0' ");
							sql.append(" start with wbs.parent_object_id = '"+node+"' and wbs.bsflag = '0' ");
							sql.append(" connect by prior wbs.object_id = wbs.parent_object_id ) temp1 " );
							sql.append(" on 1=1 " );
							sql.append(" where w.parent_object_id = '"+node+"' and w.bsflag = '0' ");
					if (wbsOnly == "true" || "true".equals(wbsOnly)) {
						
					} else {
						sql.append(" union all " );
						sql.append(" select to_number(to_char(a.object_id)||to_char(a.project_object_id)) as id" );
						sql.append(",a.id as task_id");
						sql.append(",a.name || ' (' || case status when 'Not Started' then '未开始' when 'In Progress' then '正在施工' else '完成' end || ')'as name" );
						sql.append(",a.start_date as start_date");
						sql.append(",a.finish_date as end_date" );
						sql.append(",a.planned_start_date as planned_start_date");
						sql.append(",a.planned_finish_date as planned_end_date");
						sql.append(",a.wbs_object_id as parent_id");
						sql.append(",a.percent_complete*100 as percent_done");
						sql.append(",a.object_id as other1");
						sql.append(",'true' as leaf");
						sql.append(",'false' as is_wbs");
						sql.append(",'false' as is_root");
						sql.append(" from bgp_p6_activity a ");
						sql.append(" where a.wbs_object_id = '"+node+"' and a.bsflag = '0' ");
						
					}
					sql.append( "  order by task_id");
					List list = jdbcDao.queryRecords(sql.toString());
					
					for (int i = 0; i < list.size(); i++) {
						Map map = (Map) list.get(i);
						
						map.put("Id", map.get("id"));
						map.put("TaskId", map.get("taskId"));
						map.put("Name", map.get("name"));
						map.put("PercentDone", map.get("percentDone"));
						map.put("StartDate", map.get("startDate"));
						map.put("EndDate", map.get("endDate"));
//						map.put("StartDate", map.get("plannedStartDate"));
//						map.put("EndDate", map.get("plannedEndDate"));						
						map.put("PlannedStartDate", map.get("plannedStartDate"));
						map.put("PlannedEndDate", map.get("plannedEndDate"));
						if (checked != null && "true".equals(checked)) {
							if ("true".equals((String)map.get("leaf"))) {
								map.put("checked", false);
							}
						}
					}
					
					JSONArray retJson = JSONArray.fromObject(list);
					
					ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
					
					if (retJson == null) {
						msg.setValue("json", "[]");
					} else {
						msg.setValue("json", retJson.toString());
					}
					
					return msg;
				}
			}
		} else {
			//展示单个项目的wbs和任务
			
			if (node == null || "".equals(node) || "root".equals(node)) {//点击的节点id
				//第一次进入
				//项目根节点
				StringBuffer sql = new StringBuffer("select bp.wbs_object_id as id");
				sql.append(",bp.project_id as task_id");
				sql.append(",bp.object_id as other1");
				sql.append(",'' as start_date" );
				sql.append(",'' as end_date" );
				sql.append(",tp.project_name as name" );
				sql.append(",'' as paren_id" );
				sql.append(",trunc((nvl(temp.project_planned_duration,0) - nvl(temp1.project_remaining_duration,0)) / nvl(temp.project_planned_duration,100000),2) * 100 as percent_done" );
				sql.append(",'true' as is_wbs" );
				sql.append(",'true' as is_root" );
				sql.append(",'fasle' as is_task" );
				sql.append(",temp2.baseline_start_date as baseline_start_date" );
				sql.append(",temp2.baseline_finish_date as baseline_finish_date" );
				sql.append(",temp.project_actual_start_date as project_actual_start_date");
				sql.append(",temp3.project_actual_finish_date as project_actual_finish_date");
				sql.append(",temp.project_planned_start_date as project_planned_start_date");
				sql.append(",temp.project_planned_finish_date as project_planned_finish_date");
				sql.append(",nvl(temp.project_planned_duration,0) as project_planned_duration");
				sql.append(",nvl(temp1.project_remaining_duration,0) as project_remaining_duration");
				sql.append(" from bgp_p6_project bp");
				sql.append(" join gp_task_project tp ");
				sql.append(" on bp.project_info_no = tp.project_info_no ");
				sql.append(" and tp.bsflag = '0' ");
				sql.append(" join (select min(a.actual_start_date) as project_actual_start_date, ");
				sql.append(" min(a.planned_start_date) as project_planned_start_date, ");
				sql.append(" max(a.planned_finish_date) as project_planned_finish_date, ");					
				sql.append(" ROUND(TO_NUMBER(max(a.planned_finish_date) - min(a.planned_start_date)))+1 as project_planned_duration ");				
				sql.append(" from bgp_p6_activity a where a.project_object_id ='"+objectId+"' and a.bsflag = '0') temp ");
				sql.append(" on 1=1 ");		
				
				sql.append(" join (select (case max(temp4.count1) when 0 then max(pa.actual_finish_date) else to_date('','yyyy-MM-dd') end) ");
				sql.append(" as project_actual_finish_date from bgp_p6_activity pa join (select count(a.id) as count1 from bgp_p6_activity a ");
				sql.append(" where a.bsflag = '0' and a.project_object_id = '"+objectId+"' and a.status in ('In Progress','Not Started')) temp4 on 1=1 ");
				sql.append(" where pa.bsflag = '0' and pa.project_object_id = '"+objectId+"') temp3");					
				sql.append(" on 4=4 ");
				
				sql.append(" join (select ROUND(TO_NUMBER(max(a.planned_finish_date) - to_date('"+data_date+"','yyyy-mm-dd hh24:mi:ss')))+1 as project_remaining_duration ");
				sql.append(" from bgp_p6_activity a where a.project_object_id ='"+objectId+"' and a.status <> 'Completed' and a.bsflag = '0') temp1 ");
				sql.append(" on 2=2 ");
				sql.append(" left join (select min(a.planned_start_date) as baseline_start_date, ");
				sql.append(" max(a.planned_finish_date) as baseline_finish_date ");
				sql.append(" from bgp_p6_activity a where a.project_object_id = '"+baseLineProjectId+"' and a.bsflag = '0') temp2 ");
				sql.append(" on 3=3 ");
				sql.append(" where bp.object_id = '"+objectId+"' and bp.bsflag = '0' ");
				System.out.println("sql"+sql);
				List list = jdbcDao.queryRecords(sql.toString());
				
				Map map = (Map) list.get(0);
				
				Integer ObjectId = Integer.valueOf(map.get("other1").toString());
				String projectActualStartDate = map.get("projectActualStartDate").toString();
				String projectActualFinishDate = map.get("projectActualFinishDate").toString();
				String projectPlannedStartDate = map.get("projectPlannedStartDate").toString();
				String projectPlannedFinishDate = map.get("projectPlannedFinishDate").toString();

				//如果数据库中查询不到目标项目的开始和结束时间,则通过webservice查询目标项目的信息								
				String baseLineProjectStartDate = map.get("baselineStartDate").toString();
				String baseLineProjectFinishDate = map.get("baselineFinishDate").toString();
				if(baseLineProjectStartDate == "" || baseLineProjectStartDate == null){
					String baseLineProjectObejctId = "";
					//String getBaseLineProjInfo = baseLineProjectId;
					//String getBaseLineProjInfo = "select p.object_id,p.project_name from bgp_p6_project p where p.bsflag = '0' and p.project_info_no is null and p.status = 'Active' and p.project_object_id = "+ObjectId;
					//Map baseLineProjectMap = jdbcDao.queryRecordBySQL(getBaseLineProjInfo);
					//System.out.println("&&&&&******the base line project map is:*****"+baseLineProjectMap);
					if(baseLineProjectId != ""){
						//baseLineProjectObejctId = Integer.valueOf(baseLineProjectMap.get("objectId").toString());
						baseLineProjectObejctId = baseLineProjectId;
						System.out.println("******the base line project id is:*****"+baseLineProjectObejctId);
						//baseLineProjectName = baseLineProjectMap.get("projectName").toString();
						List<BaselineProject> baseLineProjectList = baselineProjectWSBean.getBaselineProjectFromP6(null, "ObjectId = "+baseLineProjectObejctId+",Status = 'Active'", null);
	
						if(baseLineProjectList != null){
							BaselineProject baseLineProject = baseLineProjectList.get(0);
							//String projectName = baseLineProject.getName();
							//String projectStatus = baseLineProject.getStatus();
							if(baseLineProject.getStartDate().getValue()!=null){
								baseLineProjectStartDate = baseLineProject.getStartDate().getValue().getYear()+"-"+baseLineProject.getStartDate().getValue().getMonth()+"-"+baseLineProject.getStartDate().getValue().getDay();
							}
							if(baseLineProject.getFinishDate().getValue()!=null){
								baseLineProjectFinishDate = baseLineProject.getFinishDate().getValue().getYear()+"-"+baseLineProject.getFinishDate().getValue().getMonth()+"-"+baseLineProject.getFinishDate().getValue().getDay();
							}
						}
					}
				}
				
				float percentDone = 0;
				float plannedDurationValue = Float.parseFloat(map.get("projectPlannedDuration").toString()!="" ? map.get("projectPlannedDuration").toString():"0");
				float remainingDurationValue = Float.parseFloat(map.get("projectRemainingDuration").toString()!="" ? map.get("projectRemainingDuration").toString():"0");
				if(plannedDurationValue != 0){
					percentDone = ((plannedDurationValue - remainingDurationValue)/plannedDurationValue);
				}
				
				map.put("Id", map.get("id"));
				map.put("TaskId", map.get("taskId"));
				map.put("Name", map.get("name"));
//				map.put("BaselineStartDate", baseLineProjectStartDate);
//				map.put("BaselineEndDate", baseLineProjectFinishDate);
				//map.put("BaselineStartDate", projectActualStartDate);
				//map.put("BaselineEndDate", projectActualFinishDate);
				
				map.put("showBaselineStartDate", baseLineProjectStartDate);
				map.put("showBaselineEndDate", baseLineProjectFinishDate);
				map.put("actualStartDate", projectActualStartDate);
				map.put("actualEndDate", projectActualFinishDate);
				map.put("plannedStartDate", projectPlannedStartDate);
				map.put("plannedEndDate", projectPlannedFinishDate);
				map.put("PlannedDuration", map.get("projectPlannedDuration") != "" ? map.get("projectPlannedDuration")+" days":"0"+" days");
				map.put("RemainingDuration", map.get("projectRemainingDuration") != "" ? map.get("projectRemainingDuration")+" days":"0"+" days");
				map.put("PercentDone", map.get("percentDone"));
				JSONArray jsonArray = JSONArray.fromObject(map);
				
				ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
				
				if (jsonArray == null) {
					msg.setValue("json", "[]");
				} else {
					msg.setValue("json", jsonArray.toString());
				}
				
				return msg;
			} else {
				
				StringBuffer baseprojectsql = new StringBuffer("select wbs1.object_id from bgp_p6_project_wbs wbs1 ");
				baseprojectsql.append("join bgp_p6_project_wbs wbs2 ");
				baseprojectsql.append("on wbs2.code = wbs1.code and wbs2.object_id = '"+node+"' and wbs2.bsflag = '0' ");
				baseprojectsql.append("where wbs1.project_object_id = '"+baseLineProjectId+"'");
				System.out.println("The sql is:"+baseprojectsql);
				
				String targetNode = "0";
				
				List baselist = jdbcDao.queryRecords(baseprojectsql.toString());
		
				if (baselist != null && baselist.size() != 0) {
					Map map = (Map) baselist.get(0);
					targetNode = (String) map.get("objectId");
				}
				//分级加载
				//根据传入的nodeid得到下一级的wbs以及任务
				StringBuffer sql = new StringBuffer("select w.object_id as id");
				sql.append(",w.sequence_number as order_id");
						//",to_number(w.code) as order_id"+
				sql.append(",w.code as task_id");
				sql.append(",w.name as name");
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as start_date" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as end_date" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as planned_start_date" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as planned_end_date" );
				sql.append(",w.parent_object_id as parent_id" );
				sql.append(",0 as percent_done" );
				sql.append(",w.object_id as other1");
				sql.append(",'false' as leaf");
				sql.append(",'true' as is_wbs" );
				sql.append(",'false' as is_root" );
				sql.append(",'fasle' as is_task" );
				sql.append(",0 as planned_duration" );
				sql.append(",0 as remaining_duration" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as actual_start_date" );
				sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as actual_end_date" );
				sql.append(" from bgp_p6_project_wbs w " );
				sql.append(" where w.parent_object_id = '"+node+"' and w.bsflag = '0'");
				if (wbsOnly == "true" || "true".equals(wbsOnly)) {
					
				} else {
					sql.append(" union all " );
					sql.append(" select to_number(to_char(a.object_id)||to_char(a.project_object_id)) as id" );
					sql.append(",to_number(substr(a.id,2)) as order_id");
					sql.append(",a.id as task_id");						
					sql.append(",a.name || ' (' || case status when 'Not Started' then '未开始' when 'In Progress' then '正在施工' else '完成' end || ')'as name" );
					sql.append(",a.start_date as start_date" );
					sql.append(",a.finish_date as end_date" );
					sql.append(",a.planned_start_date as planned_start_date" );
					sql.append(",a.planned_finish_date as planned_end_date" );
					sql.append(",a.wbs_object_id as parent_id" );
					sql.append(",a.percent_complete*100 as percent_done" );
					sql.append(",a.object_id as other1" );
					sql.append(",'true' as leaf");
					sql.append(",'false' as is_wbs" );
					sql.append(",'false' as is_root" );
					sql.append(",'true' as is_task" );
					sql.append(",a.planned_duration as planned_duration" );
					sql.append(",a.remaining_duration as remaining_duration" );
					sql.append(",a.actual_start_date as actual_start_date" );
					sql.append(",a.actual_finish_date as actual_end_date" );
					sql.append(" from bgp_p6_activity a ");
					sql.append(" where a.wbs_object_id = '"+node+"' and a.bsflag = '0'");
					
				}
				sql.append("  order by order_id,is_wbs");
				List list = jdbcDao.queryRecords(sql.toString());
				
				String checkHaveWbsSql  = "";
				String getFinishFlag = "";
				String getChildWbs = "";
				for (int i = 0; i < list.size(); i++) {
					String baselineStartDate = "";
					String baselineEndDate = "";
					Map map = (Map) list.get(i);
					if(map.get("other1") != null){
						Integer ObjectId = Integer.valueOf(map.get("other1").toString());
						if("true".equals(map.get("isWbs").toString())){
							boolean endDateEmpty = true;
							//获取wbs中wbs的目标项目时间以及作业的目标项目时间
							StringBuffer wbsSql = new StringBuffer();
							checkHaveWbsSql = "select count(w.object_id) as wbs_count from bgp_p6_project_wbs w where w.bsflag = '0' and w.parent_object_id = "+ObjectId;
							Integer wbsObjectIdValue = Integer.valueOf(map.get("id").toString());
							//wbs下面还有wbs,获取当前wbsid,递归查询出有没有作业是进行状态的，如果有则对应的wbs不显示结束时间
							if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkHaveWbsSql).get("wbsCount").toString()) != 0){
								System.out.println("has wbs");
								
								
								//List<Map> wbsList = jdbcDao.queryRecords(getChildWbs);
								//判断这个wbs下面是否还有wbs
									List<Map> wbsList = this.getWbs(ObjectId);
									if(wbsList.size() !=0 && wbsList != null){
										for(int m=0;m<wbsList.size();m++){
											Map wbsMap = wbsList.get(m);
											List<Map> activityList = this.getActivity(Integer.parseInt(wbsMap.get("objectId").toString()));
											if(activityList.size() == 0 || activityList == null){
												endDateEmpty = false;
												break;
											}
										}
									}

								
								 wbsSql.append("select ");								 
								 wbsSql.append("(case when min(a.start_date)<=min(temp1.start_date) then min(a.start_date) else min(temp1.start_date) end) as start_date,");
								 wbsSql.append("(case when max(a.finish_date)>=max(temp1.finish_date) then max(a.finish_date) else max(temp1.finish_date) end) as finish_date,");								 
								 wbsSql.append("min(temp9.baseline_start_date) as baseline_start_date,");
								 wbsSql.append("max(temp9.baseline_finish_date) as baseline_finish_date,");
								 wbsSql.append("trunc((ROUND((TO_NUMBER((case when max(a.planned_finish_date)>=max(temp1.planned_finish_date) then max(a.planned_finish_date) else max(temp1.planned_finish_date) end) - (case when min(a.planned_start_date)<=min(temp1.planned_start_date) then min(a.planned_start_date) else min(temp1.planned_start_date) end))) + 1) - max(nvl((temp.wbs_remaining_duration), 0))) /");
								 wbsSql.append("(ROUND(TO_NUMBER((case when max(a.planned_finish_date)>=max(temp1.planned_finish_date) then max(a.planned_finish_date) else max(temp1.planned_finish_date) end) - (case when min(a.planned_start_date)<=min(temp1.planned_start_date) then min(a.planned_start_date) else min(temp1.planned_start_date) end))) + 1),2) *100 as percent_done," );
												//"TO_NUMBER('') as percent_done,"+
								 wbsSql.append("(case when min(a.planned_start_date)<=min(temp1.planned_start_date) then min(a.planned_start_date) else min(temp1.planned_start_date) end) as planned_start_date,");
								 wbsSql.append("(case when max(a.planned_finish_date)>=max(temp1.planned_finish_date) then max(a.planned_finish_date) else max(temp1.planned_finish_date) end) as planned_finish_date,");
								 wbsSql.append("(case when min(a.actual_start_date)<=min(temp1.actual_start_date) then min(a.actual_start_date) else min(temp1.actual_start_date) end) as actual_start_date,");
								 wbsSql.append("(case when max(a.actual_finish_date)>=max(temp1.actual_finish_date) then max(a.actual_finish_date) else max(temp1.actual_finish_date) end) as actual_finish_date, ");
								 wbsSql.append("ROUND(TO_NUMBER((case when max(a.planned_finish_date)>=max(temp1.planned_finish_date) then max(a.planned_finish_date) else max(temp1.planned_finish_date) end) - (case when min(a.planned_start_date)<=min(temp1.planned_start_date) then min(a.planned_start_date) else min(temp1.planned_start_date) end)))+1 as wbs_planned_duration,");
								 wbsSql.append("max(nvl((temp.wbs_remaining_duration),0)) as wbs_remaining_duration ");
								 wbsSql.append("from bgp_p6_project_wbs wbs ");
								 wbsSql.append(" join (select ROUND(TO_NUMBER((case when max(a.planned_finish_date)>=max(temp2.planned_finish_date) then max(a.planned_finish_date) else max(temp2.planned_finish_date) end) - to_date('"+data_date+"','yyyy-mm-dd hh24:mi:ss')))+1 as wbs_remaining_duration");
								 wbsSql.append(" from bgp_p6_project_wbs wbs ");
								 wbsSql.append(" join (select min(a.actual_start_date) as actual_start_date,");
								 wbsSql.append(" max(a.actual_finish_date) as actual_finish_date," );
								 wbsSql.append(" min(a.planned_start_date) as planned_start_date," );
								 wbsSql.append(" max(a.planned_finish_date) as planned_finish_date " );
								 wbsSql.append(" from bgp_p6_activity a where a.bsflag = '0' and a.status <> 'Completed'" );
								 wbsSql.append(" and a.wbs_object_id = '"+ObjectId+"') temp2 ");
								 wbsSql.append(" on 3=3");
								 wbsSql.append(" left join bgp_p6_activity a on a.wbs_object_id = wbs.object_id and a.bsflag = '0' and a.status <> 'Completed'");
								 wbsSql.append(" start with wbs.parent_object_id = '"+ObjectId+"' ");
								 wbsSql.append(" and wbs.bsflag = '0' ");
								 wbsSql.append(" connect by prior wbs.object_id = wbs.parent_object_id) temp");
								 wbsSql.append(" on 1=1");						       				
								 wbsSql.append(" join (select min(a.actual_start_date) as actual_start_date,");
								 wbsSql.append(" max(a.actual_finish_date) as actual_finish_date," );
								 wbsSql.append(" min(a.planned_start_date) as planned_start_date," );
								 wbsSql.append(" max(a.planned_finish_date) as planned_finish_date, " );
								 wbsSql.append(" min(a.start_date) as start_date," );
								 wbsSql.append(" max(a.finish_date) as finish_date " );								 
								 wbsSql.append(" from bgp_p6_activity a where a.bsflag = '0' " );
								 wbsSql.append(" and a.wbs_object_id = '"+ObjectId+"') temp1 ");
								 wbsSql.append(" on 2=2");		
								 wbsSql.append(" join (select (case when temp8.planned_finish_date2 >=temp6.planned_finish_date1 then temp8.planned_finish_date2 else temp6.planned_finish_date1 end) as baseline_finish_date,");
								 wbsSql.append(" (case when temp8.planned_start_date2 <= temp6.planned_start_date1 then temp8.planned_start_date2 else temp6.planned_start_date1 end) as baseline_start_date");
								 wbsSql.append(" from (select min(a.planned_start_date) as planned_start_date1,max(a.planned_finish_date) as planned_finish_date1 from bgp_p6_activity a where a.bsflag = '0' and a.wbs_object_id = '"+targetNode+"') temp6");
								 wbsSql.append(" join (select min(a.planned_start_date) as planned_start_date2,max(a.planned_finish_date) as planned_finish_date2 from bgp_p6_project_wbs wbs left join bgp_p6_activity a on a.wbs_object_id = wbs.object_id");
								 wbsSql.append(" and a.bsflag = '0' start with wbs.parent_object_id = '"+targetNode+"' and wbs.bsflag = '0' connect by prior wbs.object_id = wbs.parent_object_id) temp8 on 3 = 3) temp9"); 
								 wbsSql.append(" on 5=5");
								 wbsSql.append(" left join bgp_p6_activity a on a.wbs_object_id = wbs.object_id and a.bsflag = '0' ");
								 wbsSql.append(" start with wbs.parent_object_id = '"+ObjectId+"' ");
								 wbsSql.append(" and wbs.bsflag = '0' ");
								 wbsSql.append(" connect by prior wbs.object_id = wbs.parent_object_id");
								 System.out.println("sql is:"+wbsSql);

								 
							}else{
								System.out.println("not have wbs");
								//wbs下面只有作业,没有wbs了
								getFinishFlag = "select count(a.id) as finish_flag from bgp_p6_activity a where a.bsflag = '0' "+ 
												"and a.status in ('In Progress','Not Started') and a.wbs_object_id = "+wbsObjectIdValue;
								
								wbsSql.append("select min(a.start_date) as start_date,");
								wbsSql.append(" max(a.finish_date) as finish_date,");
								wbsSql.append(" min(a.planned_start_date) as planned_start_date,");
								wbsSql.append(" max(a.planned_finish_date) as planned_finish_date,");
								wbsSql.append(" min(a.actual_start_date) as actual_start_date,");
								wbsSql.append(" max(a.actual_finish_date) as actual_finish_date,");
								wbsSql.append(" ROUND(TO_NUMBER(max(a.planned_finish_date) - min(a.planned_start_date))) + 1 as wbs_planned_duration,");
								wbsSql.append(" max(a.remaining_duration)/max(c.hours_per_day) as wbs_remaining_duration,");
								wbsSql.append(" trunc(decode(sum(a.planned_duration),0,0,(sum(a.planned_duration) - sum(a.remaining_duration))/sum(a.planned_duration)),2)*100 as percent_done");
								wbsSql.append(" from bgp_p6_activity a join bgp_p6_calendar c on a.calendar_object_id = c.object_id where a.bsflag = '0' ");
								wbsSql.append(" and a.wbs_object_id = "+ObjectId);
								//如果存在未完成的作业,则把结束时间为空
								if(Integer.parseInt(jdbcDao.queryRecordBySQL(getFinishFlag).get("finishFlag").toString()) > 0){
									//map.put("actualEndDate", "");
									endDateEmpty = true;
								}else{
									endDateEmpty = false;
								}
							}

							Map wbsInfoMap = jdbcDao.queryRecordBySQL(wbsSql.toString());
//							String planned_start_date = wbsInfoMap.get("plannedStartDate").toString();
//							String planned_finish_date = wbsInfoMap.get("plannedFinishDate").toString();
//							String actual_start_date = wbsInfoMap.get("actualStartDate").toString();
							String actual_finish_date = wbsInfoMap.get("actualFinishDate").toString();
//							String wbs_remaining_duration = wbsInfoMap.get("wbsRemainingDuration").toString()+" days";
//							String wbs_planned_duration = wbsInfoMap.get("wbsPlannedDuration").toString()+" days";
//							String percent_done_wbs = wbsInfoMap.get("percentDone").toString();

							map.put("actualStartDate", wbsInfoMap.get("actualStartDate")!=null?wbsInfoMap.get("actualStartDate"):"");
							
							 if(endDateEmpty){
								 map.put("actualEndDate", "");
							 }else{
								 map.put("actualEndDate", wbsInfoMap.get("actualFinishDate")!=null?wbsInfoMap.get("actualFinishDate"):"");
							 }
							
							map.put("plannedStartDate", wbsInfoMap.get("plannedStartDate")!=null?wbsInfoMap.get("plannedStartDate"):"");
							map.put("PlannedStartDate",wbsInfoMap.get("plannedStartDate")!=null?wbsInfoMap.get("plannedStartDate"):"");
							map.put("plannedEndDate", wbsInfoMap.get("plannedFinishDate")!=null?wbsInfoMap.get("plannedFinishDate"):"");
							map.put("PlannedEndDate", wbsInfoMap.get("plannedFinishDate")!=null?wbsInfoMap.get("plannedFinishDate"):"");
							
							//map.put("BaselineStartDate", wbsInfoMap.get("baselineStartDate")!=null?wbsInfoMap.get("baselineStartDate"):"");
							//map.put("BaselineEndDate", wbsInfoMap.get("baselineFinishDate")!=null?wbsInfoMap.get("baselineFinishDate"):"");
							
							//map.put("BaselineStartDate", wbsInfoMap.get("actualStartDate")!=null?wbsInfoMap.get("actualStartDate"):"");
							//map.put("BaselineEndDate", wbsInfoMap.get("actualFinishDate")!=null?wbsInfoMap.get("actualFinishDate"):"");
							
							map.put("showBaselineStartDate", wbsInfoMap.get("baselineStartDate")!=null?wbsInfoMap.get("baselineStartDate"):"");
							map.put("showBaselineEndDate", wbsInfoMap.get("baselineFinishDate")!=null?wbsInfoMap.get("baselineFinishDate"):"");
							map.put("PlannedDuration", wbsInfoMap.get("wbsPlannedDuration")!=null?wbsInfoMap.get("wbsPlannedDuration")+" days":" days");
							map.put("RemainingDuration", wbsInfoMap.get("wbsRemainingDuration")!=null?wbsInfoMap.get("wbsRemainingDuration")+" days":" days");
							map.put("percentDone", wbsInfoMap.get("percentDone")!=null?wbsInfoMap.get("percentDone"):"");
							

						}
						//读取作业的时间
						else if("false".equals(map.get("isWbs").toString())){
							//获取日历中每天工作天数
							System.out.println("******** not wbs ,object id is:"+ObjectId);
							String get_hours_per_day = "select pc.hours_per_day from bgp_p6_activity pa join bgp_p6_calendar pc on pa.calendar_object_id = pc.object_id where pa.bsflag = '0' and pa.object_id = "+ObjectId;
							Integer hours_per_day = Integer.valueOf(jdbcDao.queryRecordBySQL(get_hours_per_day).get("hoursPerDay").toString());
							
							StringBuffer get_baseline_activity = new StringBuffer("select pa.start_date as baseline_start_date,pa.finish_date as baseline_finish_date ");
							get_baseline_activity.append(" from bgp_p6_activity pa where pa.object_id = ");
							get_baseline_activity.append(" (select a1.object_id from bgp_p6_activity a1");
							get_baseline_activity.append(" join bgp_p6_activity a2");
							get_baseline_activity.append(" on a2.id = a1.id and a2.object_id = '"+ObjectId+"' and a2.bsflag = '0'");
							get_baseline_activity.append(" where a1.project_object_id = '"+baseLineProjectId+"')");
							
							Map baseLineMap = jdbcDao.queryRecordBySQL(get_baseline_activity.toString());
							//数据库里有数据，从数据库查
							if(baseLineMap != null){
								log.debug("from database");
								baselineStartDate = baseLineMap.get("baselineStartDate").toString();
								baselineEndDate = baseLineMap.get("baselineFinishDate").toString();
							}
							//数据库没有，从webservice查
							else{
								log.debug("from p6");
								List<Activity> activityInfo = activityWSBean.getActivityFromP6(null, "ObjectId = "+ObjectId, null); 
								if(activityInfo != null && activityInfo.size() != 0){
									if(activityInfo.get(0).getBaselineStartDate().getValue() != null){
										baselineStartDate = P6TypeConvert.convert(activityInfo.get(0).getBaselineStartDate(),"yyyy-MM-dd");
										System.out.println("baselineStartDatebaselineStartDate"+baselineStartDate);
									}
									if(activityInfo.get(0).getBaselineFinishDate().getValue() != null){
										baselineEndDate = P6TypeConvert.convert(activityInfo.get(0).getBaselineFinishDate(),"yyyy-MM-dd");
										System.out.println("baselineEndDatebaselineEndDate"+baselineEndDate);
									}
								}
							}
							
							
//							List<Activity> activityInfo = activityWSBean.getActivityFromP6(null, "ObjectId = "+ObjectId, null); 
//							if(activityInfo != null){
//								if(activityInfo.get(0).getBaselineStartDate().getValue() != null){
//									baselineStartDate = activityInfo.get(0).getBaselineStartDate().getValue().toString().substring(0, 10);
//								}
//								if(activityInfo.get(0).getBaselineFinishDate().getValue() != null){
//									baselineEndDate = activityInfo.get(0).getBaselineFinishDate().getValue().toString().substring(0, 10);
//								}
//							}
							
							//map.put("ActualStartDate", map.get("actualStartDate"));
							//map.put("ActualEndDate", map.get("actualEndDate"));
							//map.put("PlannedStartDate", map.get("plannedStartDate"));
							//map.put("PlannedEndDate", map.get("plannedEndDate"));
//							map.put("BaselineStartDate", baselineStartDate);
//							map.put("BaselineEndDate", baselineEndDate);
							
							map.put("BaselineStartDate", map.get("plannedStartDate"));
							map.put("BaselineEndDate", map.get("plannedEndDate"));	
							
							map.put("showBaselineStartDate", baselineStartDate);
							map.put("showBaselineEndDate", baselineEndDate);
							map.put("PlannedDuration", Integer.parseInt((String) map.get("plannedDuration"))/hours_per_day+" days");
							map.put("RemainingDuration", Integer.parseInt((String) map.get("remainingDuration"))/hours_per_day+" days");
						}
						//activityWSBean.getActivityFromP6(mcsUser, filter, order)
					}
					
					map.put("Id", map.get("id"));
					map.put("TaskId", map.get("taskId"));
					map.put("orderId", map.get("orderId"));
					map.put("Name", map.get("name"));
					map.put("PercentDone", map.get("percentDone"));
//					map.put("StartDate", map.get("startDate"));
//					map.put("EndDate", map.get("endDate"));
//					map.put("startDate", map.get("startDate"));
//					map.put("endDate", map.get("endDate"));
//					map.put("StartDate", map.get("actualStartDate"));
//					map.put("EndDate", map.get("actualEndDate"));
					map.put("StartDate", map.get("actualStartDate"));
					map.put("EndDate", map.get("actualEndDate"));

					if (checked != null && "true".equals(checked)) {
						if ("true".equals((String)map.get("leaf"))) {
							map.put("checked", false);
						}
					}
				}
				
				JSONArray retJson = JSONArray.fromObject(list);
				
				ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
				
				if (retJson == null) {
					msg.setValue("json", "[]");
				} else {
					msg.setValue("json", retJson.toString());
				}
				
				return msg;
			}
		}
		
	}
	
	/**
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTasksWithBaselineAjax(ISrvMsg reqDTO) throws Exception{
	
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String targetProjectInfoNo = reqDTO.getValue("targetProjectInfoNo");
		
		String checked = reqDTO.getValue("checked");
		
		String objectId = null;
		
		String wbsObjectId = null;
		
		String targetProjectObjectId = null;
		String targetWbsObjectId = null;
		
		if (projectInfoNo == null || "".equals(projectInfoNo) || "null".equals(projectInfoNo)) {
			objectId = reqDTO.getValue("projectObjectId");
			wbsObjectId = reqDTO.getValue("wbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				objectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				wbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		
		if (targetProjectInfoNo == null || "".equals(targetProjectInfoNo) || "null".equals(targetProjectInfoNo)) {
			targetProjectObjectId = reqDTO.getValue("targetProjectObjectId");
			targetWbsObjectId = reqDTO.getValue("targetWbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", targetProjectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				targetProjectObjectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				targetWbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		
		String data_date = "";
		String baseLineProjectId = "";
		List<Project> projectInfoList = projectWSBean.getProjectFromP6(null, "ObjectId = "+objectId, null); 
		if(projectInfoList != null){
			Project projectInfo = projectInfoList.get(0);
			data_date = P6TypeConvert.convert(projectInfo.getDataDate(),"yyyy-MM-dd HH:mm:ss");
			if(projectInfo.getCurrentBaselineProjectObjectId().getValue() != null){
				baseLineProjectId = projectInfo.getCurrentBaselineProjectObjectId().getValue().toString();
			}
		}
		
		String node = reqDTO.getValue("node");
		
		System.out.println("The node value is:"+node);
		
		
		if (node == null || "".equals(node) || "root".equals(node)) {//点击的节点id
			//第一次进入
			//项目根节点
			StringBuffer sql = new StringBuffer("select wbs_object_id as id");
			sql.append(",project_id as task_id");
			sql.append(",object_id as other1");
			sql.append(",temp.project_start_date as start_date" );
			sql.append(",temp.project_finish_date as end_date" );
			sql.append(",project_name as name" );
			sql.append(",'' as paren_id" );
			sql.append(",trunc((nvl(temp.project_planned_duration,0) - nvl(temp1.project_remaining_duration,0)) / nvl(temp.project_planned_duration,100000),2) * 100 as percent_done" );
			sql.append(",'true' as is_wbs" );
			sql.append(",'true' as is_root" );
			sql.append(",'fasle' as is_task" );
			sql.append(",temp2.baseline_start_date as baseline_start_date" );
			sql.append(",temp2.baseline_finish_date as baseline_finish_date" );
			sql.append(",temp.project_actual_start_date as project_actual_start_date" );
			sql.append(",temp.project_actual_finish_date as project_actual_finish_date" );
			sql.append(",temp.project_planned_start_date as project_planned_start_date" );
			sql.append(",temp.project_planned_finish_date as project_planned_finish_date" );
			sql.append(",nvl(temp.project_planned_duration,0) as project_planned_duration" );
			sql.append(",nvl(temp1.project_remaining_duration,0) as project_remaining_duration" );
			sql.append(" from bgp_p6_project " );
			sql.append(" join (select min(a.actual_start_date) as project_actual_start_date, ");
			sql.append(" max(a.actual_finish_date) as project_actual_finish_date, ");
			sql.append(" min(a.planned_start_date) as project_planned_start_date, ");
			sql.append(" max(a.planned_finish_date) as project_planned_finish_date, ");	
			sql.append(" min(a.start_date) as project_start_date, ");
			sql.append(" max(a.finish_date) as project_finish_date, ");
			sql.append(" ROUND(TO_NUMBER(max(a.planned_finish_date) - min(a.planned_start_date)))+1 as project_planned_duration ");					
			sql.append(" from bgp_p6_activity a where a.project_object_id ='"+objectId+"' and a.bsflag = '0') temp ");
			sql.append(" on 1=1 ");				
			sql.append(" join (select ROUND(TO_NUMBER(max(a.planned_finish_date) - to_date('"+data_date+"','yyyy-mm-dd hh24:mi:ss')))+1 as project_remaining_duration ");
			sql.append(" from bgp_p6_activity a where a.project_object_id ='"+objectId+"' and a.status <> 'Completed' and a.bsflag = '0') temp1 ");
			sql.append(" on 2=2 ");			
			sql.append(" left join (select min(a.planned_start_date) as baseline_start_date, ");
			sql.append(" max(a.planned_finish_date) as baseline_finish_date ");
			sql.append(" from bgp_p6_activity a where a.project_object_id ='"+targetProjectObjectId+"' and a.bsflag = '0') temp2 ");
			sql.append(" on 3=3 ");			
			sql.append(" where object_id = '"+objectId+"' and bsflag = '0' ");
			System.out.println("The sql is:"+sql);
			
			List list = jdbcDao.queryRecords(sql.toString());
			Map map = (Map) list.get(0);
			
			Integer ObjectId = Integer.valueOf(map.get("other1").toString());
			
			String projectActualStartDate = map.get("projectActualStartDate").toString();
			String projectActualFinishDate = map.get("projectActualFinishDate").toString();
			String projectPlannedStartDate = map.get("projectPlannedStartDate").toString();
			String projectPlannedFinishDate = map.get("projectPlannedFinishDate").toString();
			//String baseLineProjectStartDate = map.get("baselineStartDate").toString();
			//String baseLineProjectFinishDate = map.get("baselineFinishDate").toString();
			
			//System.out.println("String baseLineProjectStartDate is:"+baseLineProjectStartDate);
			
			//System.out.println("String baseLineProjectFinishDate is:"+baseLineProjectFinishDate);
			
			
			
			float percentDone = 0;
			float plannedDurationValue = Float.parseFloat(map.get("projectPlannedDuration").toString()!="" ? map.get("projectPlannedDuration").toString():"0");
			float remainingDurationValue = Float.parseFloat(map.get("projectRemainingDuration").toString()!="" ? map.get("projectRemainingDuration").toString():"0");
			if(plannedDurationValue != 0){
				percentDone = ((plannedDurationValue - remainingDurationValue)/plannedDurationValue);
			}
			
			map.put("Id", map.get("id"));
			map.put("TaskId", map.get("taskId"));
			map.put("Name", map.get("name"));
			map.put("StartDate", map.get("startDate")!=null?map.get("startDate"):"");
			map.put("EndDate", map.get("endDate")!=null?map.get("endDate"):"");
			map.put("BaselineStartDate", map.get("baselineStartDate")!=null?map.get("baselineStartDate"):"");
			map.put("BaselineEndDate", map.get("baselineFinishDate")!=null?map.get("baselineFinishDate"):"");
			map.put("showBaselineStartDate", map.get("baselineStartDate")!=null?map.get("baselineStartDate"):"");
			map.put("showBaselineEndDate", map.get("baselineFinishDate")!=null?map.get("baselineFinishDate"):"");
			map.put("actualStartDate", projectActualStartDate);
			map.put("actualEndDate", projectActualFinishDate);
			map.put("plannedStartDate", projectPlannedStartDate);
			map.put("plannedEndDate", projectPlannedFinishDate);
			map.put("PlannedDuration", map.get("projectPlannedDuration") != "" ? map.get("projectPlannedDuration")+" days":"0"+" days");
			map.put("RemainingDuration", map.get("projectRemainingDuration") != "" ? map.get("projectRemainingDuration")+" days":"0"+" days");
			map.put("parenId", map.get("parenid"));
			map.put("percentDone", map.get("percentdone"));
			JSONArray jsonArray = JSONArray.fromObject(map);
			//444
			ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
			
			if (jsonArray == null) {
				msg.setValue("json", "[]");
			} else {
				msg.setValue("json", jsonArray.toString());
			}
			
			return msg;
			
		} else {
			//分级加载
			
			//根据wbs主键得到wbs编号
			//再根据查询出来的wbs编号得到基线项目对应的主键
			StringBuffer baseprojectsql = new StringBuffer("select wbs1.object_id from bgp_p6_project_wbs wbs1 ");
			baseprojectsql.append("join bgp_p6_project_wbs wbs2 ");
			baseprojectsql.append("on wbs2.code = wbs1.code and wbs2.object_id = '"+node+"' and wbs2.bsflag = '0' ");
			baseprojectsql.append("where wbs1.project_object_id = '"+baseLineProjectId+"' ");
			System.out.println("base line The sql is:"+baseprojectsql);
			
			String targetNode = "0";
			
			List baselist = jdbcDao.queryRecords(baseprojectsql.toString());
			
			if (baselist != null && baselist.size() != 0) {
				Map map = (Map) baselist.get(0);
				targetNode = (String) map.get("objectId");
				System.out.println("###### The target node is:"+targetNode);
			}else{
				System.out.println("###### no baseline project");
			}
			//根据传入的nodeid得到下一级的wbs以及任务
			
			StringBuffer sql = new StringBuffer("select w.object_id as id");
						//",to_number(w.code) as order_id"+
			sql.append(",w.code as task_id");
			sql.append(",w.sequence_number as order_id");
			sql.append(",w.name as name");
			sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as start_date" );
			sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as end_date" );
			sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as planned_start_date" );
			sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as planned_end_date" );
			sql.append(",w.parent_object_id as parent_id" );
			sql.append(",0 as percent_done" );
			sql.append(",w.object_id as other1");
			sql.append(",'false' as leaf");
			sql.append(",'true' as is_wbs" );
			sql.append(",'false' as is_root" );
			sql.append(",'fasle' as is_task" );
			sql.append(",0 as planned_duration" );
			sql.append(",0 as remaining_duration" );
			sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as actual_start_date" );
			sql.append(",to_date('','yyyy-mm-dd hh24:mi:ss') as actual_end_date" );
			sql.append(" from bgp_p6_project_wbs w " );
			sql.append(" where w.parent_object_id = '"+node+"' and w.bsflag = '0' ");
			sql.append(" union all " );
			sql.append(" select to_number(to_char(a.object_id)||to_char(a.project_object_id)) as id" );
			sql.append(",a.id as task_id");
			sql.append(",to_number(substr(a.id,2)) as order_id");
			sql.append(",a.name || ' (' || case status when 'Not Started' then '未开始' when 'In Progress' then '正在施工' else '完成' end || ')'as name" );
			sql.append(",a.start_date as start_date" );
			sql.append(",a.finish_date as end_date" );
			sql.append(",a.planned_start_date as planned_start_date" );
			sql.append(",a.planned_finish_date as planned_end_date" );
			sql.append(",a.wbs_object_id as parent_id" );
			sql.append(",a.percent_complete*100 as percent_done" );
			sql.append(",a.object_id as other1" );
			sql.append(",'true' as leaf");
			sql.append(",'false' as is_wbs" );
			sql.append(",'false' as is_root" );
			sql.append(",'true' as is_task" );
			sql.append(",a.planned_duration as planned_duration" );
			sql.append(",a.remaining_duration as remaining_duration" );
			sql.append(",a.actual_start_date as actual_start_date" );
			sql.append(",a.actual_finish_date as actual_end_date" );
			sql.append(" from bgp_p6_activity a ");
			sql.append(" where a.wbs_object_id = '"+node+"' and a.bsflag = '0' order by order_id,is_wbs");
		List list = jdbcDao.queryRecords(sql.toString());
		
		String checkHaveWbsSql  = "";
		for (int i = 0; i < list.size(); i++) {
			
			Map map = (Map) list.get(i);
			if(map.get("other1") != null){
				Integer ObjectId = Integer.valueOf(map.get("other1").toString());
				String Name = map.get("name").toString();
				//Integer ParentObjectId = Integer.valueOf(map.get("parentId").toString());
				//读取wbs的时间
				if("true".equals(map.get("isWbs").toString())){
					//获取wbs中wbs的目标项目时间以及作业的目标项目时间
					StringBuffer wbsSql = new StringBuffer();
					checkHaveWbsSql = "select count(w.object_id) as wbs_count from bgp_p6_project_wbs w where w.bsflag = '0' and w.parent_object_id = "+ObjectId;

					if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkHaveWbsSql).get("wbsCount").toString()) != 0){
						//wbs下面还有wbs
						wbsSql.append("select ");						
						wbsSql.append("(case when min(a.start_date)<=min(temp1.start_date) then min(a.start_date) else min(temp1.start_date) end) as start_date,");
						wbsSql.append("(case when max(a.finish_date)>=max(temp1.finish_date) then max(a.finish_date) else max(temp1.finish_date) end) as finish_date,");						
						wbsSql.append("min(temp9.baseline_start_date) as baseline_start_date,");
						wbsSql.append("max(temp9.baseline_finish_date) as baseline_finish_date,");
						wbsSql.append("trunc((ROUND((TO_NUMBER((case when max(a.planned_finish_date)>=max(temp1.planned_finish_date) then max(a.planned_finish_date) else max(temp1.planned_finish_date) end) - (case when min(a.planned_start_date)<=min(temp1.planned_start_date) then min(a.planned_start_date) else min(temp1.planned_start_date) end))) + 1) - max(nvl((temp.wbs_remaining_duration), 0))) /" );
						wbsSql.append("(ROUND(TO_NUMBER((case when max(a.planned_finish_date)>=max(temp1.planned_finish_date) then max(a.planned_finish_date) else max(temp1.planned_finish_date) end) - (case when min(a.planned_start_date)<=min(temp1.planned_start_date) then min(a.planned_start_date) else min(temp1.planned_start_date) end))) + 1),2) *100 as percent_done,");
										//"TO_NUMBER('') as percent_done,"+
						wbsSql.append("(case when min(a.planned_start_date)<=min(temp1.planned_start_date) then min(a.planned_start_date) else min(temp1.planned_start_date) end) as planned_start_date,");
						wbsSql.append("(case when max(a.planned_finish_date)>=max(temp1.planned_finish_date) then max(a.planned_finish_date) else max(temp1.planned_finish_date) end) as planned_finish_date,");
						wbsSql.append("(case when min(a.actual_start_date)<=min(temp1.actual_start_date) then min(a.actual_start_date) else min(temp1.actual_start_date) end) as actual_start_date,");
						wbsSql.append("(case when max(a.actual_finish_date)>=max(temp1.actual_finish_date) then max(a.actual_finish_date) else max(temp1.actual_finish_date) end) as actual_finish_date, ");
						wbsSql.append("ROUND(TO_NUMBER((case when max(a.planned_finish_date)>=max(temp1.planned_finish_date) then max(a.planned_finish_date) else max(temp1.planned_finish_date) end) - (case when min(a.planned_start_date)<=min(temp1.planned_start_date) then min(a.planned_start_date) else min(temp1.planned_start_date) end)))+1 as wbs_planned_duration,");
						wbsSql.append("max(nvl((temp.wbs_remaining_duration),0)) as wbs_remaining_duration ");
						wbsSql.append("from bgp_p6_project_wbs wbs ");
						wbsSql.append(" join (select ROUND(TO_NUMBER((case when max(a.planned_finish_date)>=max(temp2.planned_finish_date) then max(a.planned_finish_date) else max(temp2.planned_finish_date) end) - to_date('"+data_date+"','yyyy-mm-dd hh24:mi:ss')))+1 as wbs_remaining_duration");
						wbsSql.append(" from bgp_p6_project_wbs wbs ");						
						wbsSql.append(" join (select min(a.actual_start_date) as actual_start_date,");
						wbsSql.append(" max(a.actual_finish_date) as actual_finish_date," );
						wbsSql.append(" min(a.planned_start_date) as planned_start_date," );
						wbsSql.append(" max(a.planned_finish_date) as planned_finish_date " );
						wbsSql.append(" from bgp_p6_activity a where a.bsflag = '0' and a.status <> 'Completed'" );
						wbsSql.append(" and a.wbs_object_id = '"+ObjectId+"') temp2 ");
						wbsSql.append(" on 3=3");
						wbsSql.append(" left join bgp_p6_activity a on a.wbs_object_id = wbs.object_id and a.bsflag = '0' and a.status <> 'Completed'");
						wbsSql.append(" start with wbs.parent_object_id = '"+ObjectId+"' ");
						wbsSql.append(" and wbs.bsflag = '0' ");
						wbsSql.append(" connect by prior wbs.object_id = wbs.parent_object_id) temp");
						wbsSql.append(" on 1=1");						       				
						wbsSql.append(" join (select min(a.actual_start_date) as actual_start_date,");
						wbsSql.append(" max(a.actual_finish_date) as actual_finish_date," );
						wbsSql.append(" min(a.planned_start_date) as planned_start_date," );
						wbsSql.append(" max(a.planned_finish_date) as planned_finish_date, " );
						wbsSql.append(" min(a.start_date) as start_date," );
						wbsSql.append(" max(a.finish_date) as finish_date " );
						wbsSql.append(" from bgp_p6_activity a where a.bsflag = '0' " );
						wbsSql.append(" and a.wbs_object_id = '"+ObjectId+"') temp1 ");
						wbsSql.append(" on 2=2");
						wbsSql.append(" join (select min(a.planned_start_date) as planned_start_date, " );
						wbsSql.append(" max(a.planned_finish_date) as planned_finish_date " );
						wbsSql.append(" from bgp_p6_activity a where a.wbs_object_id = '"+targetNode+"' " );
						wbsSql.append(" and a.bsflag = '0') temp3 " );
						wbsSql.append(" on 4=4" );												
						wbsSql.append(" join (select (case when temp8.planned_finish_date2 >=temp6.planned_finish_date1 then temp8.planned_finish_date2 else temp6.planned_finish_date1 end) as baseline_finish_date,");
						wbsSql.append(" (case when temp8.planned_start_date2 <= temp6.planned_start_date1 then temp8.planned_start_date2 else temp6.planned_start_date1 end) as baseline_start_date");
						wbsSql.append(" from (select min(a.planned_start_date) as planned_start_date1,max(a.planned_finish_date) as planned_finish_date1 from bgp_p6_activity a where a.bsflag = '0' and a.wbs_object_id = '"+targetNode+"') temp6");
						wbsSql.append(" join (select min(a.planned_start_date) as planned_start_date2,max(a.planned_finish_date) as planned_finish_date2 from bgp_p6_project_wbs wbs left join bgp_p6_activity a on a.wbs_object_id = wbs.object_id");
						wbsSql.append(" and a.bsflag = '0' start with wbs.parent_object_id = '"+targetNode+"' and wbs.bsflag = '0' connect by prior wbs.object_id = wbs.parent_object_id) temp8 on 3 = 3) temp9"); 
						wbsSql.append(" on 5=5");		
						wbsSql.append(" left join bgp_p6_activity a on a.wbs_object_id = wbs.object_id and a.bsflag = '0' ");
						wbsSql.append(" start with wbs.parent_object_id = '"+ObjectId+"' ");
						wbsSql.append(" and wbs.bsflag = '0' ");
						wbsSql.append(" connect by prior wbs.object_id = wbs.parent_object_id");
						System.out.println("()()()()( sql is:"+wbsSql);
					}else{
						wbsSql.append("select min(a.planned_start_date) as planned_start_date,");
						wbsSql.append(" max(a.planned_finish_date) as planned_finish_date,");
						wbsSql.append(" min(a.actual_start_date) as actual_start_date,");
						wbsSql.append(" max(a.actual_finish_date) as actual_finish_date,");
						wbsSql.append(" min(a.start_date) as start_date,");
						wbsSql.append(" max(a.finish_date) as end_date,");
						wbsSql.append(" ROUND(TO_NUMBER(max(a.planned_finish_date) - min(a.planned_start_date))) + 1 as wbs_planned_duration,");
						wbsSql.append(" max(a.remaining_duration)/max(c.hours_per_day) as wbs_remaining_duration,");
						wbsSql.append(" trunc(decode(sum(a.planned_duration),0,0,(sum(a.planned_duration) - sum(a.remaining_duration))/sum(a.planned_duration)),2)*100 as percent_done");
						wbsSql.append(" from bgp_p6_activity a join bgp_p6_calendar c on a.calendar_object_id = c.object_id where a.bsflag = '0' ");
						wbsSql.append(" and a.wbs_object_id = "+ObjectId);
					}
					//List<WBS> wbsInfo = wbsWSBean.getWbsFromP6(null, "ObjectId = "+ObjectId, null);
					//List<WBS> wbsInfo = wbsWSBean.getWbsFromP6(null, ObjectId, "ParentObjectId = "+ParentObjectId, null);
	
					Map wbsInfoMap = jdbcDao.queryRecordBySQL(wbsSql.toString());
					String planned_start_date = wbsInfoMap.get("plannedStartDate").toString();
					String planned_finish_date = wbsInfoMap.get("plannedFinishDate").toString();
					String actual_start_date = wbsInfoMap.get("actualStartDate").toString();
					String actual_finish_date = wbsInfoMap.get("actualFinishDate").toString();
					String wbs_remaining_duration = wbsInfoMap.get("wbsRemainingDuration").toString()+" days";
					String wbs_planned_duration = wbsInfoMap.get("wbsPlannedDuration").toString()+" days";
					//String baseline_start_date = wbsInfoMap.get("baselineStartDate") != null?wbsInfoMap.get("baselineStartDate").toString():"";
					//String baseline_finish_date = wbsInfoMap.get("baselineFinishDate") !=null?wbsInfoMap.get("baselineFinishDate").toString():"";
					
					//System.out.println("!!!!!baselineStartDatebaselineStartDate"+baseline_start_date);
					//System.out.println("!!!!!baseline_finish_datebaseline_finish_date"+baseline_finish_date);
					String percent_done_wbs = wbsInfoMap.get("percentDone").toString();
					
	//				map.put("ActualStartDate",wbsActualStartDate);
	//				map.put("ActualEndDate", wbsActualEndDate);
					
					map.put("actualStartDate", actual_start_date);
					map.put("actualEndDate", actual_finish_date);
					map.put("plannedStartDate",planned_start_date);
					map.put("plannedEndDate", planned_finish_date);
					map.put("PlannedStartDate",planned_start_date);
					map.put("PlannedEndDate", planned_finish_date);
					map.put("BaselineStartDate", wbsInfoMap.get("baselineStartDate")!=null?wbsInfoMap.get("baselineStartDate"):"");
					map.put("showBaselineStartDate", wbsInfoMap.get("baselineStartDate")!=null?wbsInfoMap.get("baselineStartDate"):"");
					map.put("BaselineEndDate", wbsInfoMap.get("baselineFinishDate")!=null?wbsInfoMap.get("baselineFinishDate"):"");
					map.put("showBaselineEndDate", wbsInfoMap.get("baselineFinishDate")!=null?wbsInfoMap.get("baselineFinishDate"):"");

					
//					map.put("actualStartDate", actual_start_date);
//					map.put("actualEndDate", actual_finish_date);
//					map.put("plannedStartDate",planned_start_date);
//					map.put("plannedEndDate", planned_finish_date);
//					map.put("PlannedStartDate",planned_start_date);
//					map.put("PlannedEndDate", planned_finish_date);
//					map.put("BaselineStartDate", wbsInfoMap.get("baselineStartDate") != null?wbsInfoMap.get("baselineStartDate").toString():"");
//					map.put("BaselineEndDate", wbsInfoMap.get("baselineFinishDate") !=null?wbsInfoMap.get("baselineFinishDate").toString():"");
//					map.put("showBaselineStartDate", wbsInfoMap.get("baselineStartDate") != null?wbsInfoMap.get("baselineStartDate").toString():"");
//					map.put("showBaselineEndDate", wbsInfoMap.get("baselineFinishDate") !=null?wbsInfoMap.get("baselineFinishDate").toString():"");
					map.put("PlannedDuration", wbs_planned_duration);
					map.put("RemainingDuration", wbs_remaining_duration);
					map.put("percentDone", percent_done_wbs);
				}
				//读取作业的时间
				else if("false".equals(map.get("isWbs").toString())){
					System.out.println("activity+++++:"+Name+":::"+i);
					System.out.println("********baseline not wbs ,object id is:"+ObjectId);
					//获取日历中每天工作天数
					String get_hours_per_day = "select pc.hours_per_day from bgp_p6_activity pa join bgp_p6_calendar pc on pa.calendar_object_id = pc.object_id where pa.bsflag = '0' and pa.object_id = "+ObjectId;
					Integer hours_per_day = Integer.valueOf(jdbcDao.queryRecordBySQL(get_hours_per_day).get("hoursPerDay").toString());

					String baselineStartDate= "";
					String baselineEndDate = "";
					
					StringBuffer get_baseline_activity = new StringBuffer("select pa.start_date as baseline_start_date,pa.finish_date as baseline_finish_date ");
					get_baseline_activity.append(" from bgp_p6_activity pa where pa.object_id = ");
					get_baseline_activity.append(" (select a1.object_id from bgp_p6_activity a1");
					get_baseline_activity.append(" join bgp_p6_activity a2");
					get_baseline_activity.append(" on a2.id = a1.id and a2.object_id = '"+ObjectId+"' and a2.bsflag = '0'");
					get_baseline_activity.append(" where a1.project_object_id = '"+baseLineProjectId+"')");
					
					Map baseLineMap = jdbcDao.queryRecordBySQL(get_baseline_activity.toString());
					//数据库里有数据，从数据库查
					if(baseLineMap != null){
						log.debug("from database");
						baselineStartDate = baseLineMap.get("baselineStartDate").toString();
						baselineEndDate = baseLineMap.get("baselineFinishDate").toString();
					}
					//数据库没有，从webservice查
					else{
						log.debug("from p6");
						List<Activity> activityInfo = activityWSBean.getActivityFromP6(null, "ObjectId = "+ObjectId, null); 
						if(activityInfo != null){
							if(activityInfo.get(0).getBaselineStartDate().getValue() != null){
								baselineStartDate = P6TypeConvert.convert(activityInfo.get(0).getBaselineStartDate(),"yyyy-MM-dd");
								System.out.println("baselineStartDatebaselineStartDate"+baselineStartDate);
							}
							if(activityInfo.get(0).getBaselineFinishDate().getValue() != null){
								baselineEndDate = P6TypeConvert.convert(activityInfo.get(0).getBaselineFinishDate(),"yyyy-MM-dd");
								System.out.println("baselineEndDatebaselineEndDate"+baselineEndDate);
							}
						}
					}

					
					//map.put("ActualStartDate", map.get("actualStartDate"));
					//map.put("ActualEndDate", map.get("actualEndDate"));
					//map.put("PlannedStartDate", map.get("plannedStartDate"));
					//map.put("PlannedEndDate", map.get("plannedEndDate"));
					//map.put("BaselineStartDate", baselineStartDate);
					map.put("BaselineEndDate", baselineEndDate);
					map.put("BaselineStartDate", baselineStartDate);
					map.put("showBaselineEndDate", baselineEndDate);
					map.put("showBaselineStartDate", baselineStartDate);

					map.put("PlannedDuration", Integer.parseInt((String) map.get("plannedDuration"))/hours_per_day+" days");
					map.put("RemainingDuration", Integer.parseInt((String) map.get("remainingDuration"))/hours_per_day+" days");
				}
			}
				//activityWSBean.getActivityFromP6(mcsUser, filter, order)
			
			map.put("Id", map.get("id"));
			map.put("TaskId", map.get("taskId"));
			map.put("Name", map.get("name"));
			map.put("PercentDone", map.get("percentDone"));
			map.put("StartDate", map.get("startDate"));
			map.put("EndDate", map.get("endDate"));
			
			if (checked != null && "true".equals(checked)) {
				if ("true".equals((String)map.get("leaf"))) {
					map.put("checked", false);
				}
			}
		}
			
			JSONArray retJson = JSONArray.fromObject(list);
			
			ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
			
			if (retJson == null) {
				msg.setValue("json", "[]");
			} else {
				msg.setValue("json", retJson.toString());
			}
			
			return msg;
		}
	}
	
	/**
	 * 获得项目下所有的wbs与任务,并转化成json格式字符串
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@Deprecated
	public ISrvMsg getTasksWithBaseline(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String targetProjectInfoNo = reqDTO.getValue("targetProjectInfoNo");
		
		String objectId = null;
		
		String wbsObjectId = null;
		
		String targetProjectObjectId = null;
		String targetWbsObjectId = null;
		
		if (projectInfoNo == null || "".equals(projectInfoNo) || "null".equals(projectInfoNo)) {
			objectId = reqDTO.getValue("projectObjectId");
			wbsObjectId = reqDTO.getValue("wbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				objectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				wbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		
		if (targetProjectInfoNo == null || "".equals(targetProjectInfoNo) || "null".equals(targetProjectInfoNo)) {
			targetProjectObjectId = reqDTO.getValue("targetProjectObjectId");
			targetWbsObjectId = reqDTO.getValue("targetWbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", targetProjectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				targetProjectObjectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				targetWbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		
		
		JsonUtil json = new JsonUtil();
		String js = json.listWithBaseline(Integer.parseInt(objectId), Integer.parseInt(wbsObjectId), Integer.parseInt(targetProjectObjectId), Integer.parseInt(targetWbsObjectId));
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("json", js);
		
		return msg;
	}
	
	/**
	 * 获得项目下所有的wbs与任务,并转化成json格式字符串
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@Deprecated
	public ISrvMsg getTasksWithoutWbsDate(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String objectId = null;
		
		String wbsObjectId = null;
		
		boolean checked = false;
		
		String checkedString = reqDTO.getValue("checked");
		
		if (checkedString != null && !"".equals(checkedString)) {
			if (checkedString == "true" || "true".equals(checkedString)) {
				checked = true;
			}
		}
		
		if (projectInfoNo == null || "".equals(projectInfoNo) || "null".equals(projectInfoNo)) {
			objectId = reqDTO.getValue("projectObjectId");
			wbsObjectId = reqDTO.getValue("wbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				objectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				wbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		
		
		JsonUtil json = new JsonUtil();
		String js = json.listWithOutWbsDate(Integer.parseInt(objectId), Integer.parseInt(wbsObjectId), checked);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("json", js);
		
		return msg;
	}
	
	
	public ISrvMsg showGantt(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String targetProjectInfoNo = reqDTO.getValue("targetProjectInfoNo");

		String projectObjectId = reqDTO.getValue("projectObjectId");
		String wbsObjectId = reqDTO.getValue("wbsObjectId");

		System.out.println("showGantt projectObjectId:"+projectObjectId);
		System.out.println("showGantt wbsObjectId:"+wbsObjectId);
		
		String targetProjectObjectId = null;
		String targetWbsObjectId = null;
		
		String wbsBackUrl = reqDTO.getValue("wbsBackUrl");
		String taskBackUrl = reqDTO.getValue("taskBackUrl");
		
		String startDate = reqDTO.getValue("startDate");
		String endDate = reqDTO.getValue("endDate");
		
		String showBaseline = reqDTO.getValue("showBaseline");
		//String showBaseline = "";
		
		String customKey = reqDTO.getValue("customKey");
		String customValue = reqDTO.getValue("customValue");
		
		String epsObjectId = reqDTO.getValue("epsObjectId");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectObjectId = reqDTO.getValue("projectObjectId");
			wbsObjectId = reqDTO.getValue("wbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				projectObjectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				wbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		//查询目标项目id
		if(showBaseline != null && showBaseline != ""){
			String baseLineProjectId = "";
			List<Project> projectInfoList = projectWSBean.getProjectFromP6(null, "ObjectId = "+projectObjectId, null); 
			if(projectInfoList != null){
				Project projectInfo = projectInfoList.get(0);
				if(projectInfo.getCurrentBaselineProjectObjectId().getValue() != null){
					baseLineProjectId = projectInfo.getCurrentBaselineProjectObjectId().getValue().toString();
					targetProjectObjectId = baseLineProjectId;
				}
			}		  
			//查询目标项目对应的wbs
			if(baseLineProjectId != ""&& baseLineProjectId!= null){
				showBaseline = "true";
				String baseprojectsql = "select wbs1.object_id from bgp_p6_project_wbs wbs1 "+
				"join bgp_p6_project_wbs wbs2 "+
				"on wbs2.code = wbs1.code and wbs2.object_id = '"+wbsObjectId+"' and wbs2.bsflag = '0' "+
				"where wbs1.project_object_id = '"+baseLineProjectId+"'";
				System.out.println("The sql is:"+baseprojectsql);
				
				String targetNode = "0";
				
				List baselist = jdbcDao.queryRecords(baseprojectsql.toString());

				if (baselist != null && baselist.size() != 0) {
					Map map = (Map) baselist.get(0);
					targetNode = (String) map.get("objectId");
					targetWbsObjectId = targetNode;
				}
			}
		}


		
//		if (targetProjectInfoNo == null || "".equals(targetProjectInfoNo) || "null".equals(targetProjectInfoNo)) {
//			targetProjectObjectId = reqDTO.getValue("targetProjectObjectId");
//			targetWbsObjectId = reqDTO.getValue("targetWbsObjectId");
//		} else {
//			ProjectMCSBean p = new ProjectMCSBean();
//			
//			Map<String,Object> map = new HashMap<String,Object>();
//			
//			map.put("projectInfoNo", targetProjectInfoNo);
//			
//			List<Map<String,Object>> list = p.quertProject(map);
//			
//			//查询项目的wbsObjectId
//			if (list != null && list.size() > 0) {
//				map = list.get(0);
//				targetProjectObjectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
//				targetWbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
//			}
//		}
		
		if (startDate == null || "".equals(startDate)) {
			JsonUtil json = new JsonUtil();
			startDate = json.getDate(Integer.valueOf(projectObjectId), false);
		}
		
		if (endDate == null || "".equals(endDate)) {
			JsonUtil json = new JsonUtil();
			endDate = json.getDate(Integer.valueOf(projectObjectId), true);
		}
		
		log.debug("startDate:"+startDate);
		log.debug("endDate:"+endDate);
		
		msg.setValue("projectInfoNo", projectInfoNo);
		msg.setValue("projectObjectId", projectObjectId);
		msg.setValue("wbsObjectId", wbsObjectId);
		
		msg.setValue("targetProjectInfoNo", targetProjectInfoNo);
		msg.setValue("targetProjectObjectId", targetProjectObjectId);
		msg.setValue("targetWbsObjectId", targetWbsObjectId);
		
		msg.setValue("wbsBackUrl", wbsBackUrl);
		msg.setValue("taskBackUrl", taskBackUrl);
		
		msg.setValue("startDate", startDate);
		msg.setValue("endDate", endDate);
		
		msg.setValue("customKey", customKey);
		msg.setValue("customValue", customValue);
		
		msg.setValue("epsObjectId", epsObjectId);
		
		msg.setValue("showBaseline", showBaseline);
		
		return msg;
	}
	
	public ISrvMsg queryResourceAssignment(ISrvMsg reqDTO) throws Exception {
		
		String objectId = reqDTO.getValue("taskObjectId");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String taskName = reqDTO.getValue("taskName");
		String taskNameValue = "";
		if(taskName != null && taskName != ""){
			taskNameValue = taskName.substring(0,taskName.indexOf("("));
		}
		
		if (objectId == null || "".equals(objectId)) {
			return null;
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		int object_id = Integer.parseInt(objectId);
		
		System.out.println("The object id is:"+object_id);
		
		//获取日历中每天工作天数
		String get_hours_per_day = "select pc.hours_per_day from bgp_p6_activity pa join bgp_p6_calendar pc on pa.calendar_object_id = pc.object_id where pa.bsflag = '0' and pa.object_id = "+object_id;
		Integer hours_per_day = Integer.valueOf(jdbcDao.queryRecordBySQL(get_hours_per_day).get("hoursPerDay").toString());
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("object_id", objectId);
		
		//作业分类码
		List<ActivityCodeAssignment> CodeAssignList = activityCodeAssignmentWSBean.getActivityCodeAssignmentFromP6(null, "ActivityObjectId = "+object_id, null);
		List<Map<String ,Object>> CodeInfoList = new ArrayList<Map<String ,Object>>();
		for(int i=0;i<CodeAssignList.size();i++){
			Map<String ,Object> codeAssignMap = new HashMap<String, Object>();
			ActivityCodeAssignment activityCodeAssignment = CodeAssignList.get(i);
			String codeTypeName = activityCodeAssignment.getActivityCodeTypeName();
			String codeValue = activityCodeAssignment.getActivityCodeValue();
			String codeDescription = activityCodeAssignment.getActivityCodeDescription();
			codeAssignMap.put("codeTypeName", codeTypeName);
			codeAssignMap.put("codeValue", codeValue);
			codeAssignMap.put("codeDescription", codeDescription);
			CodeInfoList.add(codeAssignMap);
		}
		
		//后续作业
		List<Relationship> SuccessorRelationShipList = relationshipWSBean.getRelationshipFromP6(null, "PredecessorActivityObjectId = "+object_id, null);
		List<Map<String ,Object>> SuccessorRelationInfoList = new ArrayList<Map<String ,Object>>();
		String SuccessorRelationType = "";
		for(int i=0;i<SuccessorRelationShipList.size();i++){
			Map<String ,Object> relationMap = new HashMap<String, Object>();
			Relationship relationship = SuccessorRelationShipList.get(i);
			
			String type = relationship.getType();
			if(type.equals("Finish to Start")){
				SuccessorRelationType = "完成-开始";
			}else if(type.equals("Finish to Finish")){
				SuccessorRelationType = "完成-完成";
			}else if(type.equals("Start to Start")){
				SuccessorRelationType = "开始-开始";
			}else if(type.equals("Start to Finish")){
				SuccessorRelationType = "开始-完成";
			}
				
			//后继
			String successorActivityId = relationship.getSuccessorActivityId();
			Integer successorActivityObjectId =relationship.getSuccessorActivityObjectId();
			String successorActivityName = relationship.getSuccessorActivityName();
			String successorActivityType = relationship.getSuccessorActivityType();
			Integer successorProjectObjectId =relationship.getSuccessorProjectObjectId().getValue();
			Double SuccessorLag = relationship.getLag().getValue() != null?relationship.getLag().getValue():0.00;

			
			//获取项目名称和编号
			String project_id = "";
			String project_name = "";
			String getProjInfoSql = "select t.project_id,gp.project_name from bgp_p6_project t join gp_task_project gp on t.project_info_no = gp.project_info_no and gp.bsflag = '0' where t.bsflag = '0' and t.object_id = "+successorProjectObjectId;
			Map projectMap = jdbcDao.queryRecordBySQL(getProjInfoSql);
			if(projectMap != null){
				project_id = projectMap.get("projectId").toString();
				project_name = projectMap.get("projectName").toString();
			}
			relationMap.put("SuccessorRelationType", SuccessorRelationType);
			relationMap.put("project_id", project_id);
			relationMap.put("project_name", project_name);
			relationMap.put("successorActivityId", successorActivityId);
			relationMap.put("successorActivityObjectId", successorActivityObjectId);
			relationMap.put("successorActivityName", successorActivityName);
			relationMap.put("successorActivityType", successorActivityType);
			relationMap.put("successorProjectObjectId", successorProjectObjectId);
			relationMap.put("SuccessorLag", SuccessorLag/hours_per_day);
			
			SuccessorRelationInfoList.add(relationMap);
		}
		
		
		//前导作业
		List<Relationship> PredecessorRelationShipList = relationshipWSBean.getRelationshipFromP6(null, "SuccessorActivityObjectId = "+object_id, null);
		List<Map<String ,Object>> PredecessorRelationInfoList = new ArrayList<Map<String ,Object>>();
		String PredecessorRelationType = "";
		for(int i=0;i<PredecessorRelationShipList.size();i++){
			Map<String ,Object> relationMap = new HashMap<String, Object>();
			Relationship relationship = PredecessorRelationShipList.get(i);
			
			String type = relationship.getType();
			if(type.equals("Finish to Start")){
				PredecessorRelationType = "完成-开始";
			}else if(type.equals("Finish to Finish")){
				PredecessorRelationType = "完成-完成";
			}else if(type.equals("Start to Start")){
				PredecessorRelationType = "开始-开始";
			}else if(type.equals("Start to Finish")){
				PredecessorRelationType = "开始-完成";
			}
			//前导
			String predecessorActivityId = relationship.getPredecessorActivityId();
			Integer predecessorActivityObjectId = relationship.getPredecessorActivityObjectId();
			String predecessorActivityName = relationship.getPredecessorActivityName();
			String predecessorActivityType = relationship.getPredecessorActivityType();
			Integer predecessorProjectObjectId =relationship.getPredecessorProjectObjectId().getValue();
			Double PredecessororLag = relationship.getLag().getValue() != null?relationship.getLag().getValue():0.00;
			
			//获取项目名称和编号
			String project_id = "";
			String project_name = "";
			String getProjInfoSql = "select t.project_id,t.project_name from bgp_p6_project t where t.bsflag = '0' and t.object_id = "+predecessorProjectObjectId;
			Map projectMap = jdbcDao.queryRecordBySQL(getProjInfoSql);
			if(projectMap != null){
				project_id = projectMap.get("projectId").toString();
				project_name = projectMap.get("projectName").toString();
			}
			relationMap.put("PredecessorRelationType", PredecessorRelationType);
			relationMap.put("project_id", project_id);
			relationMap.put("project_name", project_name);
			relationMap.put("predecessorActivityId", predecessorActivityId);
			relationMap.put("predecessorActivityObjectId", predecessorActivityObjectId);
			relationMap.put("predecessorActivityName", predecessorActivityName);
			relationMap.put("predecessorActivityType", predecessorActivityType);
			relationMap.put("predecessorProjectObjectId", predecessorProjectObjectId);
			relationMap.put("PredecessororLag", PredecessororLag/hours_per_day);
			
			PredecessorRelationInfoList.add(relationMap);
		}
		
		//List<Activity> list = activityWSBean.getActivityFromP6(null, "ObjectId = "+object_id, null);
		List<Map<String, Object>> list = activityMCSBean.queryActivityFromMCS(map);
//		for (int i = 0; i < list.size(); i++) {
//			Activity a = list.get(i);
//			System.out.println(a.getCalendarObjectId());
//			List<Calendar> list1 = calendarWSBean.getCalendarFromP6(null, "ObjectId="+a.getCalendarObjectId(), null);
//			map.put("STATUS", a.getStatus());
//			map.put("ACTIVITY_ID", a.getId());
//			map.put("NAME", a.getName());
//			map.put("PLANNED_DURATION", a.getPlannedDuration());
//			map.put("HOURS_PER_DAY", list1.get(0).getHoursPerDay());
//			map.put("START_DATE", P6TypeConvert.convert(a.getStartDate(), "yyyy-MM-dd"));
//			map.put("FINISH_DATE", P6TypeConvert.convert(a.getFinishDate(), "yyyy-MM-dd"));
//			map.put("planned_start_date", P6TypeConvert.convert(a.getPlannedStartDate(), "yyyy-MM-dd"));
//			map.put("PLANNED_FINISH_DATE", P6TypeConvert.convert(a.getPlannedFinishDate(), "yyyy-MM-dd"));
//		}
		//直接从P6中读取资源信息
		
		List<ResourceAssignmentExtends> ResourceAssignList = resourceAssignmentWSBean.getResourceAssignmentFromP6(null, "ActivityObjectId = "+object_id, null);
		List<Map<String ,Object>> ResourceInfoList = new ArrayList<Map<String ,Object>>();
		String budgetValue = "";
		for(int i=0;i<ResourceAssignList.size();i++){
			Map<String ,Object> resourceAssignMap = new HashMap<String, Object>();
			ResourceAssignmentExtends resourceAssignmentExtends = ResourceAssignList.get(i);
			Integer theObjectId = resourceAssignmentExtends.getResourceAssignment().getObjectId();
			
			List<UDFValue> udfList = udfValueWSBean.getUDFValueFromP6(null, "ForeignObjectId = "+theObjectId+",UDFTypeObjectId = 129", null);
			if(udfList != null){
				for(int j=0;j<udfList.size();j++){
					UDFValue udfValue = udfList.get(j);
					if(udfValue.getDouble() != null){
						budgetValue = udfValue.getDouble().getValue().toString();
					}
				}
			}
			
			String resourceId = resourceAssignmentExtends.getResourceAssignment().getResourceId();
			String resourceName = resourceAssignmentExtends.getResourceAssignment().getResourceName();
			String plannedUnits = resourceAssignmentExtends.getResourceAssignment().getPlannedUnits().getValue().toString();
			String actualThisPeriodUnits = resourceAssignmentExtends.getResourceAssignment().getActualThisPeriodUnits().getValue().toString();
			String actualUnits = resourceAssignmentExtends.getResourceAssignment().getActualUnits().getValue().toString();
			String remainingUnits = resourceAssignmentExtends.getResourceAssignment().getRemainingUnits().getValue().toString();
			String atCompletionUnits = resourceAssignmentExtends.getResourceAssignment().getAtCompletionUnits().getValue().toString();
			String resourceType = resourceAssignmentExtends.getResourceAssignment().getResourceType();
			resourceAssignMap.put("resourceId", resourceId);
			resourceAssignMap.put("resourceName", resourceName);
			resourceAssignMap.put("plannedUnits", plannedUnits);
			resourceAssignMap.put("budgetValue", budgetValue);
			resourceAssignMap.put("actualThisPeriodUnits", actualThisPeriodUnits);
			resourceAssignMap.put("actualUnits", actualUnits);
			resourceAssignMap.put("remainingUnits", remainingUnits);
			resourceAssignMap.put("atCompletionUnits", atCompletionUnits);
			if("Labor".equals(resourceType)){
				resourceAssignMap.put("resourceType", "人工");
			}else if("Nonlabor".equals(resourceType)){
				resourceAssignMap.put("resourceType", "非人工");
			}else if("Material".equals(resourceType)){
				resourceAssignMap.put("resourceType", "材料");
			}
			
			ResourceInfoList.add(resourceAssignMap);
		}
		

		Map map1 = new HashMap();
		
		map1.put("activity_object_id", object_id);
		map1.put("object_id", null);
		
		map1.put("resource_type", "Labor");
		List<Map<String,Object>> LaborList = resourceAssignmentMCSBean.queryResourceAssignment(map1);//人工
		
		map1.put("resource_type", "Nonlabor");
		List<Map<String,Object>> NonlaborList = resourceAssignmentMCSBean.queryResourceAssignment(map1);//非人工
		
		map1.put("resource_type", "Material");
		List<Map<String,Object>> MaterialLlist = resourceAssignmentMCSBean.queryResourceAssignment(map1);//材料
		
		String produceDate = reqDTO.getValue("produceDate");
		map1.put("produce_date", produceDate);
		
		List<Map<String,Object>> WorkLoadLlist = workloadMCSBean.queryWorkload(map1);//工作量
		
		msg.setValue("CodeInfoList",CodeInfoList);
		msg.setValue("CodeAssignList", CodeAssignList);
		msg.setValue("SuccessorRelationInfoList", SuccessorRelationInfoList);
		msg.setValue("PredecessorRelationInfoList", PredecessorRelationInfoList);
		msg.setValue("LaborList", LaborList);
		msg.setValue("NonlaborList", NonlaborList);
		msg.setValue("MaterialLlist", MaterialLlist);
		msg.setValue("WorkLoadLlist", WorkLoadLlist);
		msg.setValue("ResourceInfoList", ResourceInfoList);
		
		msg.setValue("list", list);
		msg.setValue("map", list.get(0));
		msg.setValue("taskname",taskNameValue);
		
		double time = 0.0;//尚需天数
		
		if (time == 0) {
			time = ((BigDecimal) list.get(0).get("REMAINING_DURATION")).doubleValue()/((BigDecimal)list.get(0).get("HOURS_PER_DAY")).doubleValue();//预算小时数/日历
		}
		
		Double temp = Double.valueOf(time);
		if (temp.intValue() < time) {
			msg.setValue("remainingDuration", String.valueOf(temp.intValue() +1));
		} else {
			msg.setValue("remainingDuration", String.valueOf(temp.intValue()));
		}
		
		
		map1.clear();
		map1.put("projectInfoNo", projectInfoNo);
		map1.put("produceDate", produceDate);
		
		WsDailyReportSrv dailyReportSrv = new WsDailyReportSrv();
		Map daily = dailyReportSrv.getDailyReport(map1);
		String flag = null;
		if (daily != null) {
			if (daily.get("auditStatus") == "1" || "1".equals(daily.get("auditStatus"))) {
				flag = "Submited";
			} else if (daily.get("auditStatus") == "3" || "3".equals(daily.get("auditStatus"))) {
				flag = "Passed";
			} else if (daily.get("auditStatus") == "4" || "4".equals(daily.get("auditStatus"))) {
				flag = "notPassed";
			} else if (daily.get("auditStatus") == "0" || "0".equals(daily.get("auditStatus"))) {
				flag = "Saved";
			} else {
				flag = "notSaved";
			}
		}
		msg.setValue("flag", flag);
		return msg;
	}
	public ISrvMsg showTree(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectObjectId = reqDTO.getValue("projectObjectId");
		String wbsObjectId = reqDTO.getValue("wbsObjectId");
		
		String wbsBackUrl = reqDTO.getValue("wbsBackUrl");
		String taskBackUrl = reqDTO.getValue("taskBackUrl");
		
		String checked = reqDTO.getValue("checked");
		
		String wbsOnly = reqDTO.getValue("wbsOnly");
		if (wbsOnly == null || "".equals(wbsOnly)) {
			wbsOnly = "false";
		}
		
		String customKey = reqDTO.getValue("customKey");
		String customValue = reqDTO.getValue("customValue");
		
		String epsObjectId = reqDTO.getValue("epsObjectId");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectObjectId = reqDTO.getValue("projectObjectId");
			wbsObjectId = reqDTO.getValue("wbsObjectId");
		} else {
			ProjectMCSBean p = new ProjectMCSBean();
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("projectInfoNo", projectInfoNo);
			
			List<Map<String,Object>> list = p.quertProject(map);
			
			//查询项目的wbsObjectId
			if (list != null && list.size() > 0) {
				map = list.get(0);
				projectObjectId = ((BigDecimal)map.get("OBJECT_ID")).toEngineeringString();
				wbsObjectId = ((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString();
			}
		}
		
		msg.setValue("checked", checked);
		msg.setValue("wbsOnly", wbsOnly);
		
		msg.setValue("projectInfoNo", projectInfoNo);
		msg.setValue("projectObjectId", projectObjectId);
		msg.setValue("wbsObjectId", wbsObjectId);
		
		msg.setValue("wbsBackUrl", wbsBackUrl);
		msg.setValue("taskBackUrl", taskBackUrl);
		
		msg.setValue("customKey", customKey);
		msg.setValue("customValue", customValue);
		
		msg.setValue("epsObjectId", epsObjectId);
		
		return msg;
	}
	
	
	public ISrvMsg saveOrUpdateResourceAssignment(ISrvMsg reqDTO) throws Exception {
		System.out.println("“saveOrUpdateRe”");
		UserToken user = reqDTO.getUserToken();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String produceDate = reqDTO.getValue("produceDate");

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String orgId = reqDTO.getValue("orgId");
		String flag = reqDTO.getValue("flag");
		String status = reqDTO.getValue("status");
		System.out.println("”produceDate“"+produceDate+"“projectInfoNo”"+"“orgId”"+"“flag”"+"“status”");
		String projectObjectId = "";
		String activityObjectId = "";
		
		int activity_object_id = Integer.parseInt(reqDTO.getValue("activity_object_id"));
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("activity_object_id", activity_object_id);
		map.put("produce_date", produceDate);
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		
		List<Map<String,Object>> list = resourceAssignmentMCSBean.queryResourceAssignment(map);
		page = workloadMCSBean.queryWorkload(map,page);
		List<Map<String, Object>> workLoadList = page.getData();
		
		Map<String,Object> map1 = null;
		ResourceAssignmentExtends r = null;
		
		//修改该资源反馈对应的任务信息
		ActivityMCSBean activityMCSBean = new ActivityMCSBean();
		map.put("object_id", activity_object_id);
		List<Map<String,Object>> list2 = activityMCSBean.queryActivityFromMCS(map);
		
		List<ResourceAssignmentExtends> resourceAssignments = new ArrayList<ResourceAssignmentExtends>();
		List<ActivityExtends> list3 = new ArrayList<ActivityExtends>();
		
		for (int i = 0; i < list.size(); i++) {
			map1 = list.get(i);
			
			String value = reqDTO.getValue("actual_this_period_units"+map1.get("OBJECT_ID").toString());//页面值
			//System.out.println(map1.get("object_id").toString());
			//System.out.println(map1.get("OBJECT_ID").toString());
			//System.out.println(map1.get("ACTUAL_THIS_PERIOD_UNITS"));
			double value1 = ((BigDecimal) map1.get("ACTUAL_THIS_PERIOD_UNITS")).doubleValue();//数据库中的值(要被覆盖的值)
			//double value1 = 0.0;
			if (value == null || "".equals(value) || value == "0" || "0".equals(value)) {
				//资源本期反馈值为0
				if (value1 != 0) {
					//数据库里面有值 (修改数据库的值为0)
				} else {
					//数据里的值为0 页面的值为0 不反馈当期资源
					continue;
				}
			}
			//尚需
			String remainingUnit = reqDTO.getValue("remaining_units"+map1.get("OBJECT_ID").toString());//页面值
			
			//实际人数/实际设备台数
			String budgeted_units = reqDTO.getValue("budgeted_units"+map1.get("OBJECT_ID").toString());//页面值
			
			if (((String) map1.get("RESOURCE_TYPE")) == "Material" || "Material".equals((String) map1.get("RESOURCE_TYPE"))) {
				//材料 反馈数量
			} else {
				//人工 非人工 反馈天数 需要把天数×日历中的每日小时数
				value = String.valueOf(((BigDecimal)map1.get("HOURS_PER_DAY")).doubleValue() * Double.parseDouble(value));
				remainingUnit = String.valueOf(((BigDecimal)map1.get("HOURS_PER_DAY")).doubleValue() * Double.parseDouble(remainingUnit));
				budgeted_units = String.valueOf(((BigDecimal)map1.get("HOURS_PER_DAY")).doubleValue() * Double.parseDouble(budgeted_units));
				//value1 = value1 * ((BigDecimal)map1.get("HOURS_PER_DAY")).doubleValue();
			}
			
			String namespace = "http://xmlns.oracle.com/Primavera/P6/WS/ResourceAssignment/V1";
			r = new ResourceAssignmentExtends();
			r.getResourceAssignment().setProjectId(map1.get("PROJECT_ID").toString());
			r.getResourceAssignment().setProjectObjectId(((BigDecimal)map1.get("PROJECT_OBJECT_ID")).intValue());
			r.setOrgId(user.getOrgId());
			r.setOrgSubjectionId(user.getOrgSubjectionId());
			r.getResourceAssignment().setActivityId((String) map1.get("ACTIVITY_ID"));
			r.getResourceAssignment().setActivityName((String) map1.get("ACTIVITY_NAME"));
			r.getResourceAssignment().setResourceName((String) map1.get("RESOURCE_NAME"));
			r.getResourceAssignment().setResourceId((String) map1.get("RESOURCE_ID"));
			r.getResourceAssignment().setActivityObjectId(((BigDecimal)map1.get("ACTIVITY_OBJECT_ID")).intValue());
			r.getResourceAssignment().setPlannedStartDate(P6TypeConvert.convert(((Timestamp) map1.get("PLANNED_START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
			r.getResourceAssignment().setPlannedFinishDate(P6TypeConvert.convert(((Timestamp) map1.get("PLANNED_FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
			r.getResourceAssignment().setPlannedDuration(P6TypeConvert.convertDouble("PlannedDuration",namespace,((BigDecimal)map1.get("PLANNED_DURATION")).toEngineeringString()));
			
			if (map1.get("ACTUAL_START_DATE")!=null) {
				r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,((Timestamp)map1.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				r.getResourceAssignment().setStartDate(P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,((Timestamp) map1.get("START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
			} else {
				//实际开始为空 取日报日期
				r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,produceDate.substring(0, 10) + " 08:00:00", "yyyy-MM-dd HH:mm:ss"));
				r.getResourceAssignment().setStartDate((P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,produceDate.substring(0, 10) + " 08:00:00", "yyyy-MM-dd HH:mm:ss")));
			}
			
			if (status == "In Progress" || "In Progress".equals(status)) {
				if (map1.get("ACTUAL_START_DATE")!=null) {
					r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,((Timestamp)map1.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
					r.getResourceAssignment().setStartDate(P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,((Timestamp) map1.get("START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				} else {
					//实际开始为空 取日报日期
					r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,produceDate.substring(0, 10) + " 08:00:00", "yyyy-MM-dd HH:mm:ss"));
					r.getResourceAssignment().setStartDate((P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,produceDate.substring(0, 10) + " 08:00:00", "yyyy-MM-dd HH:mm:ss")));
				}
				r.getResourceAssignment().setFinishDate(P6TypeConvert.convertXMLGregorianCalendar("FinshDate",namespace,((Timestamp) map1.get("FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				
				if (map1.get("ACTUAL_FINISH_DATE")!=null) {
					r.getResourceAssignment().setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate",namespace,((Timestamp)map1.get("ACTUAL_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				}
			} else if (status == "Completed" || "Completed".equals(status)) {
				r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,((Timestamp)map1.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				r.getResourceAssignment().setStartDate(P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,((Timestamp) map1.get("START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				
				r.getResourceAssignment().setFinishDate(P6TypeConvert.convertXMLGregorianCalendar("FinshDate",namespace,produceDate.substring(0, 10) + " 18:00:00", "yyyy-MM-dd HH:mm:ss"));
				r.getResourceAssignment().setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate",namespace,produceDate.substring(0, 10) + " 18:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
				
			
			r.getResourceAssignment().setActualThisPeriodUnits(P6TypeConvert.convertDouble("ActualThisPeriodUnits",namespace,value));//该资源对应的本期反馈值
			
			double actualUnits = ((BigDecimal) map1.get("ACTUAL_UNITS")).doubleValue() + Double.parseDouble(value) - value1;//更新累计数量
			
			r.getResourceAssignment().setActualUnits(P6TypeConvert.convertDouble("ActualUnits",namespace,String.valueOf(actualUnits)));//累计数量
			
			double plannedUnits = Double.parseDouble(((BigDecimal)map1.get("PLANNED_UNITS")).toEngineeringString());
			
			r.getResourceAssignment().setPlannedUnits(P6TypeConvert.convertDouble("PlannedUnits",namespace,String.valueOf(plannedUnits)));//预计数量
			
			r.getResourceAssignment().setRemainingUnits(P6TypeConvert.convertDouble("RemainingUnits",namespace,remainingUnit));//页面值
			
			r.setBudgetedUnits(Double.parseDouble(budgeted_units));
			
			r.setSubmitFlag("0");//0保存 1提交 3通过 4未通过
			r.getResourceAssignment().setLastUpdateDate(P6TypeConvert.convertXMLGregorianCalendar("LastUpdateDate",namespace,new Date()));
			r.getResourceAssignment().setLastUpdateUser(user.getEmpId());
			r.getResourceAssignment().setObjectId(((BigDecimal)map1.get("OBJECT_ID")).intValue());
			r.getResourceAssignment().setResourceObjectId(P6TypeConvert.convertInteger("ResourceObjectId",namespace,((BigDecimal)map1.get("RESOURCE_OBJECT_ID")).toEngineeringString()));
			r.getResourceAssignment().setResourceType((String) map1.get("RESOURCE_TYPE"));
			r.getResourceAssignment().setCalendarName((String) map1.get("CALENDAR_NAME"));
			r.getResourceAssignment().setCalendarObjectId(P6TypeConvert.convertInteger("CalendarObjectId",namespace,((BigDecimal)map1.get("CALENDAR_OBJECT_ID")).toEngineeringString()));
			
			resourceAssignments.add(r);
			
			//this.saveDailyReport(r.getResourceAssignment(), produceDate, projectInfoNo, orgId, user, value1);
		}
		
		List<Map<String, Object>> workList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < workLoadList.size(); i++) {
			Map<String, Object> workload = workLoadList.get(i);
			workload.put("produce_date", produceDate);

			String value = reqDTO.getValue("actual_this_period_units"+workload.get("object_id").toString());//页面值
			double value1 = Double.parseDouble((String)workload.get("actual_this_period_units"));//数据库中的值(要被覆盖的值)
			
			if (value == null || "".equals(value) || value == "0" || "0".equals(value)) {
				//资源本期反馈值为0
				if (value1 != 0) {
					//数据库里面有值 (修改数据库的值为0)
				} else {
					//数据里的值为0 页面的值为0 不反馈当期资源
					continue;
				}
			}
			
			//尚需
			String remainingUnit = reqDTO.getValue("remaining_units"+workload.get("object_id").toString());//页面值
			workload.put("remaining_units", remainingUnit);
			
//			r.getResourceAssignment().setActualThisPeriodUnits(P6TypeConvert.convertDouble("ActualThisPeriodUnits",namespace,value));
			
			double actualUnits = Double.parseDouble((String)workload.get("actual_units")) + Double.parseDouble(value) - value1;//更新累计数量
			
			DecimalFormat d = new DecimalFormat("#.##");
			
//			r.getResourceAssignment().setActualUnits(P6TypeConvert.convertDouble("ActualUnits",namespace,String.valueOf(actualUnits)));//累计数量
			workload.put("actual_units", d.format(actualUnits));//累计数量
			
			workload.put("actual_this_period_units", value);//该资源对应的本期反馈值
			
//			double plannedUnits = Double.parseDouble(((BigDecimal)map1.get("PLANNED_UNITS")).toEngineeringString());
			
//			r.getResourceAssignment().setPlannedUnits(P6TypeConvert.convertDouble("PlannedUnits",namespace,String.valueOf(plannedUnits)));//预计数量
			
//			r.getResourceAssignment().setRemainingUnits(P6TypeConvert.convertDouble("RemainingUnits",namespace,remainingUnit));//页面值
			
//			r.setBudgetedUnits(Double.parseDouble(budgeted_units));
			
			workList.add(workload);
			this.saveDailyReport(workload, produceDate, projectInfoNo, orgId, user, value1);
		}
		
		workloadMCSBean.saveOrUpdateWorkloadToMCS(workList, user);
		
		if (list2 != null && list2.size() > 0) {
			Map<String,Object> map2 = list2.get(0);
			
			Activity a = new Activity();
//			DateFormat df = DateFormat.getDateInstance();
//			Date date = df.parse(((Timestamp)map2.get("START_DATE")).toString());
//			Calendar cal1 = Calendar.getInstance();
//			cal1.setTime(date);//任务的开始时间
//			Calendar cal2 = Calendar.getInstance();
//			cal2.setTime(P6TypeConvert.convert(P6TypeConvert.convert(produceDate,"yyyy-MM-dd")));//资源的实际开始时间 也就是当天的资源反馈日期
//			if(cal1.before(cal2)){
//				//任务的开始时间晚于资源反馈的实际开始时间
//				a.setStartDate(P6TypeConvert.convert(produceDate,"yyyy-MM-dd"));//开始日期
//				a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, produceDate, "yyyy-MM-dd"));//实际开始日期
//				
//				Long long1 = cal2.getTimeInMillis()-cal1.getTimeInMillis();//得出延后开始多少时间
//				cal2.setTimeInMillis(((Timestamp)map2.get("FINISH_DATE")).getTime()+long1);//获得任务结束时间并往后延迟
//
//				a.setFinishDate(P6TypeConvert.convert(cal2.getTime()));//保存新的结束时间
//				
//			} else {
//				//开始日期跟实际开始日期往前提,结束时间不变
//				a.setStartDate(P6TypeConvert.convert(produceDate,"yyyy-MM-dd"));//开始日期
//				a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, produceDate, "yyyy-MM-dd"));//实际开始日期
//				
//				a.setFinishDate(P6TypeConvert.convert(((Timestamp)map2.get("FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//结束时间
//			}
			
			if (status == null) {
				//状态页面无值 则不变
				a.setStatus((String)map2.get("STATUS"));
				a.setStartDate(P6TypeConvert.convert(((Timestamp) map2.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//开始日期
				if (map2.get("ACTUAL_START_DATE")!=null) {
					a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, ((Timestamp)map2.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//实际开始日期
				}
				a.setFinishDate(P6TypeConvert.convert(((Timestamp)map2.get("FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//结束时间
				if (map2.get("ACTUAL_FINISH_DATE")!=null) {
					a.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate", null, ((Timestamp)map2.get("ACTUAL_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//实际结束
				}
			} else if (status == "In Progress" || "In Progress".equals(status)) {
				a.setStatus("In Progress");
				String startDate = reqDTO.getValue("start_date");
				if (startDate != null && !"".equals(startDate)) {
					a.setStartDate(P6TypeConvert.convert(startDate.substring(0, 10)+" 08:00:00","yyyy-MM-dd HH:mm:ss"));//开始日期
					a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, startDate.substring(0, 10)+" 08:00:00", "yyyy-MM-dd HH:mm:ss"));//实际开始日期
				} else {
					a.setStartDate(P6TypeConvert.convert(((Timestamp) map2.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//开始日期
					if (map2.get("ACTUAL_START_DATE")!=null) {
						a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, ((Timestamp)map2.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//实际开始日期
					}
				}
				String finishDate = reqDTO.getValue("finish_date");
				if (finishDate != null && !"".equals(finishDate)) {
					a.setFinishDate(P6TypeConvert.convert(finishDate.substring(0, 10)+" 18:00:00","yyyy-MM-dd HH:mm:ss"));//结束时间
				} else {
					a.setFinishDate(P6TypeConvert.convert(((Timestamp)map2.get("FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//结束时间
				}
				if (map2.get("ACTUAL_FINISH_DATE")!=null) {
					a.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate", null, ((Timestamp)map2.get("ACTUAL_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//实际结束
				}
				
			} else if (status == "Completed" || "Completed".equals(status)) {
				a.setStatus("Completed");
				String startDate = reqDTO.getValue("start_date");
				if (startDate != null && !"".equals(startDate)) {
					a.setStartDate(P6TypeConvert.convert(startDate.substring(0, 10)+" 08:00:00","yyyy-MM-dd HH:mm:ss"));//开始日期
					a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, startDate.substring(0, 10)+" 08:00:00", "yyyy-MM-dd HH:mm:ss"));//实际开始日期
				} else {
					a.setStartDate(P6TypeConvert.convert(((Timestamp) map2.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//开始日期
					if (map2.get("ACTUAL_START_DATE")!=null) {
						a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, ((Timestamp)map2.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//实际开始日期
					}
				}
				String finishDate = reqDTO.getValue("finish_date");
				a.setFinishDate(P6TypeConvert.convert(finishDate.substring(0, 10)+" 18:00:00","yyyy-MM-dd HH:mm:ss"));//结束时间
				a.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate", null, finishDate.substring(0, 10)+" 18:00:00", "yyyy-MM-dd HH:mm:ss"));//实际结束日期
			} else {
				a.setStatus((String)map2.get("STATUS"));
				a.setStartDate(P6TypeConvert.convert(((Timestamp) map2.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//开始日期
				if (map2.get("ACTUAL_START_DATE")!=null) {
					a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, ((Timestamp)map2.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//实际开始日期
				}
				a.setFinishDate(P6TypeConvert.convert(((Timestamp)map2.get("FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//结束时间
				if (map2.get("ACTUAL_FINISH_DATE")!=null) {
					a.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate", null, ((Timestamp)map2.get("ACTUAL_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//实际结束
				}
			}
			
			//a.setStartDate(value)
			
			a.setPlannedStartDate(P6TypeConvert.convert(((Timestamp)map2.get("PLANNED_START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
			a.setPlannedFinishDate(P6TypeConvert.convert(((Timestamp)map2.get("PLANNED_FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
			
			a.setId((String)map2.get("ID"));
			a.setName((String)map2.get("NAME"));
			a.setProjectId((String)map2.get("PROJECT_ID"));
			a.setProjectName((String)map2.get("PROJECT_NAME"));
			a.setProjectObjectId(((BigDecimal)map2.get("PROJECT_OBJECT_ID")).intValue());
//			if ((String)map2.get("STATUS") == "Not Started" || "Not Started".equals((String)map2.get("STATUS"))) {
//				a.setStatus("In Progress");//开始//Completed
//			} else {
//				a.setStatus((String)map2.get("STATUS"));
//			}
			a.setWBSCode((String)map2.get("WBS_CODE"));
			a.setWBSName((String)map2.get("WBS_NAME"));
			a.setWBSObjectId(P6TypeConvert.convertInteger("WBSObjectId",((BigDecimal)map2.get("WBS_OBJECT_ID")).toEngineeringString()));
			a.setObjectId(((BigDecimal)map2.get("OBJECT_ID")).intValue());
			if (map2.get("SUSPEND_DATE")!=null) {
				a.setSuspendDate(P6TypeConvert.convertXMLGregorianCalendar("SuspendDate", null, ((Timestamp)map2.get("SUSPEND_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
			}
			if (map2.get("RESUME_DATE")!=null) {
				a.setResumeDate(P6TypeConvert.convertXMLGregorianCalendar("ResumeDate", null, ((Timestamp)map2.get("RESUME_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
			}
			a.setNotesToResources((String)map2.get("NOTES_TO_RESOURCES"));
			if (map2.get("EXPECTED_FINISH_DATE")!=null) {
				a.setExpectedFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ResumeDate", null, ((Timestamp)map2.get("EXPECTED_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
			}
			a.setPlannedDuration(Double.valueOf(((BigDecimal)map2.get("PLANNED_DURATION")).toEngineeringString()));
			a.setLastUpdateDate(P6TypeConvert.convertXMLGregorianCalendar("LastUpdateDate", null, new Date()));
			a.setLastUpdateUser(user.getUserName());
			
			//尚需工期=页面值*日历小时数
			String remaining_units = reqDTO.getValue("remaining_duration"+activity_object_id);//任务尚需工期
			double d = ((BigDecimal)map2.get("HOURS_PER_DAY")).doubleValue()*Double.parseDouble(remaining_units);
			a.setRemainingDuration(P6TypeConvert.convertDouble("RemainingDuration",null,String.valueOf(d)));
			
			a.setCalendarName((String) map2.get("CALENDAR_NAME"));
			a.setCalendarObjectId(((BigDecimal)map2.get("CALENDAR_OBJECT_ID")).intValue());

			ActivityExtends aa = new ActivityExtends(a);
			aa.setSubmitFlag("0");
			list3.add(aa);
			
			projectObjectId = a.getProjectObjectId().toString();
			activityObjectId = a.getObjectId().toString();
		}
		
		//activityMCSBean.saveP6ActivityToMCS(list3);
		activityMCSBean.saveOrUpdateP6ActivityToMCS(list3, user, projectObjectId);
		//resourceAssignmentMCSBean.saveP6ResourceAssignmentToMCS(resourceAssignments);//将反馈录入中间表
		resourceAssignmentMCSBean.saveOrUpdateP6ResourceAssignmentToMCS(resourceAssignments, user, activityObjectId);
		
		
		msg.setValue("list", list);
		
		msg.setValue("produceDate", produceDate);
		msg.setValue("projectInfoNo", projectInfoNo);
		msg.setValue("orgId", orgId);
		msg.setValue("objectId", String.valueOf(activity_object_id));
		msg.setValue("flag", flag);
		
		return msg;
	}


	public void  saveDailyReport(Map<String, Object> workload, String produceDate, String projectInfoNo, String orgId, UserToken user, Double value) throws Exception {
		System.out.println("“saveDailyReport”");
		Map<String,Object> mapDaily= new HashMap<String, Object>();
		mapDaily.put("produceDate", produceDate);
		mapDaily.put("projectInfoNo", projectInfoNo);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("produceDate", produceDate);
		map.put("projectInfoNo", projectInfoNo);
		map.put("orgId", orgId);

		
		if (workload.get("resource_name") == null || "".equals((String)workload.get("resource_name"))) {
			return;
		}
		
		List<Map<String,Object>> list1 = resourceAssignmentMCSBean.getMethodName((String)workload.get("resource_id"));
	
		if (list1 != null && list1.size() != 0) {
			
		} else {
			return;
		}
		Map<String,Object> map1 = list1.get(0); 
		map.put("explorationMethod", map1.get("EXPLORATION_METHOD"));
		
		WsDailyReportSrv wsDailyReportSrv = new WsDailyReportSrv();
		Map daily = wsDailyReportSrv.getDailyReportNew(map);
		
		if (daily == null) {
			return;
		}
		
		Map survey = null;
		Map surface = null;
		Map drill = null;
		Map acquire = null;
		 System.out.println("name+"+map1.get("TABLE_NAME"));
		WsDailyReportSrv dao = new WsDailyReportSrv();
	Map noMap=dao.getDailyReportBy(mapDaily);
	 if ((String)map1.get("TABLE_NAME") == "GpOpsDailyReportWs" || "GpOpsDailyReportWs".equals((String)map1.get("TABLE_NAME"))) {
			//日报主表
		 System.out.println("name+"+map1.get("TABLE_NAME"));
			if ((String)map1.get("OBJECT_TYPE") == "long" || "long".equals((String)map1.get("OBJECT_TYPE"))) {
				Object object = daily.get(map1.get("OBJECT_NAME"));
				if (object == null) {
					long longValue = 0L;
					
					longValue = longValue + Long.parseLong((String)workload.get("actual_this_period_units"));
					
					daily.put(map1.get("OBJECT_NAME"), longValue);
				} else {
					long longValue = P6TypeConvert.convertLong(daily.get(map1.get("OBJECT_NAME")));
					
					longValue = longValue + Long.parseLong((String)workload.get("actual_this_period_units"));
					
					daily.put(map1.get("OBJECT_NAME"), longValue);
				}
				
			} else if ((String)map1.get("OBJECT_TYPE") == "double" || "double".equals((String)map1.get("OBJECT_TYPE"))) {
				Object object = daily.get(map1.get("OBJECT_NAME"));
				if (object == null) {
					double doubleValue = 0.0;
					
					doubleValue = doubleValue + Double.parseDouble((String)workload.get("actual_this_period_units")) ;
					
					daily.put(map1.get("OBJECT_NAME"), doubleValue);
				} else {
					double doubleValue = P6TypeConvert.convertDouble(daily.get(map1.get("OBJECT_NAME")));
					
					doubleValue = doubleValue + Double.parseDouble((String)workload.get("actual_this_period_units")) ;
					
					daily.put(map1.get("OBJECT_NAME"), doubleValue);
				}
			}
			daily.put("daily_no_ws", noMap.get("dailyNoWs"));
			daily.put("SUBMIT_STATUS", "2");

			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(daily,"gp_ops_daily_report_ws");
			
		}
		
	}
	
	
	/**
	 * 将String格式转换为Long格式
	 * 
	 * @param string  String  转换前的数据 
	 * @return long  Long  转换后的数据
	 * @throws 无
	 */
	public static Long convertToLong(String string) {
		if (string == null || string.equals("")) {
			return null;
		} else {
			try{
				return new Long(string);
			} catch (Exception e){
				e.printStackTrace();
				return new Long(0);
			}			
		}
	}
	/**
	 * 将String格式转换为Double格式
	 * 
	 * @param string   String  转换前的数据
	 * @return double  Double  转换后的数据
	 * @throws 无
	 */
	public static Double convertToDouble(String string) {
		if (string == null || string.equals("") ) {
			return null;
		} else {
			try{
				return new Double(string);
			} catch (Exception e){
				e.printStackTrace();
				return new Double(0);
			}			
		}
	}
	
	public boolean hasWbs(int wbsObjectId){
		boolean flag = false;
		String checkHaveWbsSql = "select count(w.object_id) as wbs_count from bgp_p6_project_wbs w where w.bsflag = '0' and w.parent_object_id = "+wbsObjectId;
		if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkHaveWbsSql).get("wbsCount").toString()) > 0){
			flag = true;
		}
		return flag;
	}
	
	public List<Map> getWbs(int wbsObjectId){
		String sql = "select w.object_id from bgp_p6_project_wbs w where w.bsflag = '0' and w.parent_object_id = "+wbsObjectId;
		return jdbcDao.queryRecords(sql);
	}
	
	public List<Map> getActivity(int wbsObjectId){
		String sql = "select w.object_id from bgp_p6_activity w where w.bsflag = '0' and w.status in ('In Progress','Not Started') and w.wbs_object_id = "+wbsObjectId;
		return jdbcDao.queryRecords(sql);
	}
}
