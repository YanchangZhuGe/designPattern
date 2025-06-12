/**
 * 
 */
package com.bgp.mcs.service.pm.service.p6.util;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementSetter;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityMCSBean;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityWSBean;
import com.bgp.mcs.service.pm.service.p6.project.ProjectMCSBean;
import com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean;
import com.bgp.mcs.service.pm.service.p6.project.baselineproject.BaselineProjectMCSBean;
import com.bgp.mcs.service.pm.service.p6.project.baselineproject.BaselineProjectWSBean;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.ResourceAssignmentMCSBean;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.ResourceAssignmentWSBean;
import com.bgp.mcs.service.pm.service.p6.wbs.WbsMCSBean;
import com.bgp.mcs.service.pm.service.p6.wbs.WbsWSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.primavera.ws.p6.activity.Activity;
import com.primavera.ws.p6.activity.ActivityExtends;
import com.primavera.ws.p6.baselineproject.BaselineProject;
import com.primavera.ws.p6.resourceassignment.ResourceAssignment;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentExtends;
import com.primavera.ws.p6.wbs.WBS;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：姜增辉 2012-Jan-10
 *       
 * 描述：存放同步需要调用的方法
 */

public class SynUtils {
	private RADJdbcDao radDao;
	private ILog log;
	private UserToken user = null;
	
	public SynUtils(){
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		log = LogFactory.getLogger(SynUtils.class);
		user = new UserToken();
		user.setEmpId("0211038948");//0211038948 superadmin的id
	}
	
	public String getFilter(String function_name){
		log.info("enter getFilter("+function_name+")....");
		String sql="select exec_date from bgp_inter_manage where inter_id='"+function_name+"'";
		String tmp=radDao.getJdbcTemplate().queryForObject(sql, String.class);
		log.info("exit getFilter("+function_name+") par = "+tmp.substring(0, tmp.length()-2)+"");
		return "LastUpdateDate >= to_date('"+tmp.substring(0, tmp.length()-2)+"','yyyy-MM-dd hh24:mi:ss')";
	}
	
	public void setUpdateDate(String function_name){
		//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String sql = "update bgp_inter_manage set exec_date=sysdate where inter_id='"+function_name+"'";
		//String sql = "update bgp_inter_manage set exec_date= to_date('"+format.format(new Date())+"','YYYY-MM-DD HH24-mi-ss') where inter_id='"+function_name+"'";
		radDao.getJdbcTemplate().execute(sql);
	}
	
	public void synActivityP6toGMS(String filter) throws Exception{
		log.info("enter synActivityP6toGMS("+filter+")...");
		ActivityWSBean activityWSBean = new ActivityWSBean();
		List<Activity> list = activityWSBean.getActivityFromP6(null, filter, "ObjectId desc");
		log.info("获得Activity的数量为:"+list.size());
		ActivityMCSBean activityMCSBean = new ActivityMCSBean();
		List<ActivityExtends> list2 = new ArrayList<ActivityExtends>();
		for (int i = 0; i < list.size(); i++) {
			ActivityExtends a = new ActivityExtends(list.get(i),"6");
			list2.add(a);
		}
		//activityMCSBean.saveP6ActivityToMCS(list2);
		//activityMCSBean.saveP6ActivityToMCS(list2, user);
		activityMCSBean.saveOrUpdateP6ActivityToMCS(list2, user);
		log.info("exit synActivityP6toGMS("+filter+")");
	}
	
//	public void synActivityCodeP6toGMS(String filter) throws Exception{
//		log.info("enter synActivityCodeP6toGMS("+filter+")");
//		ActivityCodeWSBean acWS=new ActivityCodeWSBean();
//		List<ActivityCode> list=acWS.getActivityCodeFromP6(null, filter, null);
//		log.info("获得ActivityCode的数量为:"+list.size());
//		ActivityCodeMCSBean acMCS = new ActivityCodeMCSBean();
//		acMCS.saveP6ActivityCodeToMCS(list);
//		log.info("exit synActivityCodeP6toGMS()");
//	}
	
//	public void synActivityCodeTypeP6toGMS(String filter) throws Exception{
//		log.info("enter synActivityCodeTypeP6toGMS("+filter+")");
//		ActivityCodeTypeWSBean actWS=new ActivityCodeTypeWSBean();
//		List<ActivityCodeType> list=actWS.getActivityCodeTypeFromP6(null, filter, null);
//		log.info("获得ActivityCodeType的数量为:"+list.size());
//		ActivityCodeTypeMCSBean actMCS = new ActivityCodeTypeMCSBean();
//		actMCS.saveP6ActivityCodeTypeToMCS(list);
//		log.info("exit synActivityCodeTypeP6toGMS()");
//	}
	
	public void synWbsP6toGMS(String filter) throws Exception{
		log.info("enter synWbsP6toGMS("+filter+")");
		WbsWSBean wbsWS=new WbsWSBean();
		List<WBS> list=wbsWS.getWbsFromP6(null, filter, "ObjectId desc");
		log.info("获得WBS的数量为:"+list.size());
		WbsMCSBean wbsMCS = new WbsMCSBean();
//    	wbsMCS.saveP6WbsToMcs(list);
//    	wbsMCS.saveP6WbsToMcs(list, user);
		wbsMCS.saveOrUpdateP6WbsToMCS(list, user);
    	log.info("exit synWbsP6toGMS()");
	}
	
//	public void synResourceP6toGMS(String filter) throws Exception{
//		log.info("enter synResourceP6toGMS("+filter+")");
//		ResourceWSBean resourceWS=new ResourceWSBean();
//		List<Resource> list=resourceWS.getP6Resource(null, filter);
//		log.info("获得Resource的数量为:"+list.size());
//		ResourceMCSBean resourceMCS=new ResourceMCSBean();
//		resourceMCS.saveP6Resources(list);
//		log.info("exit synResourceP6toGMS()");
//	}
	
//	public void synResourceAssignmentP6toGMS(String filter) throws Exception{
//		log.info("enter synResourceAssignmentP6toGMS("+filter+")");
//		ResourceAssignmentWSBean raWS=new ResourceAssignmentWSBean();
//		List<ResourceAssignmentExtends> list=raWS.getResourceAssignmentFromP6(null, filter, "ObjectId desc");
//		log.info("获得ResourceAssignment的数量为:"+list.size());
//		ResourceAssignmentMCSBean raMCS=new ResourceAssignmentMCSBean();
		
//以下代码无用
//		List<ResourceAssignmentExtends> list2 = new ArrayList<ResourceAssignmentExtends>();
//		for (int i = 0; i < list.size(); i++) {
//			ResourceAssignmentExtends r = new ResourceAssignmentExtends(list.get(i));
//			list2.add(r);
//		}
//		raMCS.saveP6ResourceAssignmentToMCS(list);
//		raMCS.saveP6ResourceAssignmentToMCS(list, user);
//以上代码无用		
//		raMCS.saveOrUpdateP6ResourceAssignmentToMCS(list, user);
//		log.info("exit synResourceAssignmentP6toGMS()");
//	}
	
//	public void synResourceCodeP6toGMS(String filter) throws Exception{
//		log.info("enter synResourceCodeP6toGMS("+filter+")");
//		ResourceCodeWSBean rcWS=new ResourceCodeWSBean();
//		List<ResourceCode> list=rcWS.getResourceCodeFromP6(null, filter, null);
//		log.info("获得ResourceCode的数量为:"+list.size());
//		ResourceCodeMCSBean rcMCS=new ResourceCodeMCSBean();
//		rcMCS.saveP6ResourceCodeToMCS(list);
//		log.info("exit synResourceCodeP6toGMS()");
//	}
	
//	public void synResourceCodeTypeP6toGMS(String filter) throws Exception{
//		log.info("enter synResourceCodeTypeP6toGMS("+filter+")");
//		ResourceCodeTypeWSBean rctWS=new ResourceCodeTypeWSBean();
//		List<ResourceCodeType> list=rctWS.getResourceCodeTypeFromP6(null, filter, null);
//		log.info("获得ResourceCodeType的数量为:"+list.size());
//		ResourceCodeTypeMCSBean rctMCS=new ResourceCodeTypeMCSBean();
//		rctMCS.saveP6ResourceCodeTypeToMCS(list);
//		log.info("exit synResourceCodeTypeP6toGMS()");
//	}
	
	/**
	 * 从GMS到P6同步，项目的删除与更新。新增在GMS创建项目时调用，位于com.cnpc.oms.service.gpe.blh.GpTaskPrjBLH
	 * 中的insertElseProjectInfo(ISvrMsg)和insertCommTaskPrj(ISvrMsg)
	 */
	public void synProject(){
		ProjectWSBean wsb = new ProjectWSBean();
		ProjectMCSBean pmb=new ProjectMCSBean();
		List<Map<String,Object>> list_edit = pmb.getUpdateProjects();
		List<Map> list_del = pmb.getDeleteProjects();
		List<Map> list_insert = pmb.getInsertProjects();
		log.info("GMS与P6项目同步开始");
		log.info("========符合条件的项目个数为："+(list_edit.size()+list_del.size()+list_insert.size()));
		
		try {
			//新增
			if(list_insert.size()>0){
				if(wsb.insertProject(list_insert, user)){
					log.info("Insert projects success, the number is "+list_insert.size());
				}else{
					log.info("Insert is failed!!");
				}
			}
			//删除
			if(list_del.size()>0){
				if(wsb.deleteProject(list_del)){
					log.info("Delete projects success, the number is "+list_del.size());
				}else{
					log.info("Delete is failed!!");
				}
			}
			//编辑
			if(list_edit.size()>0){
				if(wsb.updateProject(list_edit, user)){
					log.info("Update projects success, the number is "+list_edit.size());
				}else{
					log.info("Update is failed!!");
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		log.info("GMS与P6项目同步结束");
	}
	
	public void synBaselineProject() throws Exception{
		ProjectMCSBean mcsBean = new ProjectMCSBean();
		BaselineProjectWSBean wsBean = new BaselineProjectWSBean();
		BaselineProjectMCSBean baseMcsBean = new BaselineProjectMCSBean();
		
		Map<String,Object> map = new HashMap<String,Object>();
		List<Map<String,Object>> list = mcsBean.quertProject(map);
		
		List<BaselineProject> projectList = new ArrayList<BaselineProject>();
		
		for (int i = 0; i < list.size(); i++) {
			map = list.get(i);
			List<BaselineProject>  list2 = wsBean.getBaselineProjectFromP6(null, "OriginalProjectObjectId="+map.get("OBJECT_ID"), null);
			if (list2 != null && list2.size() != 0) {
				projectList.addAll(list2);
			}
		}
		
		baseMcsBean.saveOrUpdateBaselineProjectToMCS(projectList, user, null);
		
	}
	public void synBaselineProject(String projectObjId) throws Exception{
		ProjectMCSBean mcsBean = new ProjectMCSBean();
		BaselineProjectWSBean wsBean = new BaselineProjectWSBean();
		BaselineProjectMCSBean baseMcsBean = new BaselineProjectMCSBean();
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("objectId", projectObjId);
		List<Map<String,Object>> list = mcsBean.quertProject(map);
		
		List<BaselineProject> projectList = new ArrayList<BaselineProject>();
		
		for (int i = 0; i < list.size(); i++) {
			map = list.get(i);
			List<BaselineProject>  list2 = wsBean.getBaselineProjectFromP6(null, "OriginalProjectObjectId="+map.get("OBJECT_ID"), null);
			if (list2 != null && list2.size() != 0) {
				projectList.addAll(list2);
			}
		}
		
		baseMcsBean.saveOrUpdateBaselineProjectToMCS(projectList, user, projectObjId);
		
	}
	
/*	public void synResourceAssignmentGMStoP6(String filter) throws Exception{
		log.info("enter synResourceAssignmentGMStoP6("+filter+");");
		ResourceAssignmentMCSBean resourceAssignmentMCSBean = new ResourceAssignmentMCSBean();
		String last_update_date=filter.split("'")[1].replace("/", "-");
		Map map = new HashMap();
		map.put("last_update_date", last_update_date);
		List<Map<String,Object>> list4 = resourceAssignmentMCSBean.queryResourceAssignment(map);
		ResourceAssignment r = null;
		Map map1 = null;
		ResourceAssignmentWSBean resourceAssignmentWSBean= new ResourceAssignmentWSBean();
		log.info("查询得到ResourceAssignment总数为:"+list4.size());
		double num = list4.size()/900.0;
		num = Math.ceil(num);
		int num1 = Double.valueOf(num).intValue();
		log.info("分次往p6推送数据  一共分"+num1+"次推送数据");
		for (int i = 1; i <= num1; i++) {
		
		List<ResourceAssignment> resourceAssignments = new ArrayList<ResourceAssignment>();
			for (int j = (i - 1) * 900; j>=(i - 1)*900 && j < i*900 && j < list4.size(); j++) {
				map1 = list4.get(j);
		
				String namespace = "http://xmlns.oracle.com/Primavera/P6/WS/ResourceAssignment/V1";
				 
				namespace = null;
				r = new ResourceAssignment();
				r.setProjectId(map1.get("PROJECT_ID").toString());
				r.setProjectObjectId(((BigDecimal)map1.get("PROJECT_OBJECT_ID")).intValue());
				r.setActivityId((String) map1.get("ACTIVITY_ID"));
				r.setActivityName((String) map1.get("ACTIVITY_NAME"));
				r.setResourceName((String) map1.get("RESOURCE_NAME"));
				r.setResourceId((String) map1.get("RESOURCE_ID"));
				r.setPlannedStartDate(P6TypeConvert.convert(((Timestamp) map1.get("PLANNED_START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
				r.setPlannedFinishDate(P6TypeConvert.convert(((Timestamp) map1.get("PLANNED_FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
				r.setPlannedDuration(P6TypeConvert.convertDouble("PlannedDuration",namespace,((BigDecimal)map1.get("PLANNED_DURATION")).toEngineeringString()));
				if (map1.get("ACTUAL_START")!=null) {
					r.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,((Timestamp)map1.get("ACTUAL_START")).toString(), "yyyy-MM-dd HH:mm:ss"));
				}
				if (map1.get("ACTUAL_FINISH")!=null) {
					r.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate",namespace,((Timestamp)map1.get("ACTUAL_FINISH")).toString(), "yyyy-MM-dd HH:mm:ss"));
				}
				
				r.setActualThisPeriodUnits(P6TypeConvert.convertDouble("ActualThisPeriodUnits",namespace,((BigDecimal)map1.get("ACTUAL_THIS_PERIOD_UNITS")).toEngineeringString()));//该资源对应的本期反馈值
				
				r.setActualUnits(P6TypeConvert.convertDouble("ActualUnits",namespace,((BigDecimal) map1.get("ACTUAL_UNITS")).toEngineeringString()));//累计数量
				
				r.setRemainingUnits(P6TypeConvert.convertDouble("RemainingUnits",namespace,((BigDecimal)map1.get("REMAINING_UNITS")).toEngineeringString()));//还剩数量
				r.setPlannedUnits(P6TypeConvert.convertDouble("PlannedUnits",namespace,((BigDecimal)map1.get("PLANNED_UNITS")).toEngineeringString()));//预计数量
				
				r.setLastUpdateDate(P6TypeConvert.convertXMLGregorianCalendar("LastUpdateDate",namespace,((Timestamp) map1.get("MODIFI_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				r.setLastUpdateUser((String) map1.get("LAST_UPDATE_USER"));
				r.setObjectId(((BigDecimal)map1.get("OBJECT_ID")).intValue());
				r.setActivityObjectId(((BigDecimal)map1.get("ACTIVITY_OBJECT_ID")).intValue());
				r.setResourceObjectId(P6TypeConvert.convertInteger("ResourceObjectId",namespace,((BigDecimal)map1.get("RESOURCE_OBJECT_ID")).toEngineeringString()));
				r.setResourceType((String) map1.get("RESOURCE_TYPE"));
				r.setCalendarName((String) map1.get("CALENDAR_NAME"));
				r.setCalendarObjectId(P6TypeConvert.convertInteger("CalendarObjectId",namespace,((BigDecimal)map1.get("CALENDAR_OBJECT_ID")).toEngineeringString()));
				r.setStartDate(P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,((Timestamp) map1.get("START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				r.setFinishDate(P6TypeConvert.convertXMLGregorianCalendar("FinshDate",namespace,((Timestamp) map1.get("FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
				
				resourceAssignments.add(r);
			}
			log.info("开始第"+num1+"次往p6写入数据...");
			resourceAssignmentWSBean.updateResourceAssignmentToP6(null, resourceAssignments);
			log.info("第"+num1+"次写入完成...");
		}
		log.info("推送完成...");
		log.info("exit synResourceAssignmentGMStoP6()");
		
	}*/
	
	
	public void synActivityGMStoP6(String filter) throws Exception{
		log.info("enter synActivityGMStoP6("+filter+")");
		ActivityMCSBean activityMCSBean = new ActivityMCSBean();
		String last_update_date=filter.split("'")[1].replace("/", "-");
		Map<String, Object> map1 = new HashMap<String, Object>();
		//map1.put("last_update_date", last_update_date);
		//submit_flag =3 表示在gms中修改的作业,只能同步到P6,不能被P6同步
		map1.put("submit_flag", "3");
		
		//按项目进行数据传输
		String getProjectListSql = "select p.project_status,pp.object_id from bgp_p6_project pp join gp_task_project p on pp.project_info_no = p.project_info_no and p.bsflag = '0' and p.project_status <> '5000100001000000005' where pp.bsflag = '0' and pp.project_object_id is null";
		List<Map> projectMapList = radDao.queryRecords(getProjectListSql);
		ActivityWSBean activityWSBean = new ActivityWSBean();
		if(projectMapList != null){
			for(int k=0;k<projectMapList.size();k++){
				Map projectMap = projectMapList.get(k);
				map1.put("project_id", projectMap.get("object_id"));
				//执行
				List<Map<String,Object>> list = activityMCSBean.queryActivityFromMCS(map1);
				log.info("查询得到Activity的数据为 :"+list.size());
				//如果获取的activity数量大于0,则执行同步
				if(list.size() > 0){
					Activity a = null;
					ActivityExtends aa = null;
					Map<String, Object> map = null;
					String namespace = "http://xmlns.oracle.com/Primavera/P6/WS/Activity/V1";
					//int num2 = 900;//每次推送多少条数据
					//double num = list.size()*1.0/num2;
					//num = Math.ceil(num);
					//int num1 = Double.valueOf(num).intValue();
					//log.info("分次往p6推送数据  一共分"+num1+"次推送数据");
					//for (int i = 1; i <= num1; i++) {
					List<Activity> activitys = new ArrayList<Activity>();
					List<ActivityExtends> listUpdate = new ArrayList<ActivityExtends>(); 
					for (int j = 0; j < list.size(); j++) {
						
						//for (int j = (i - 1) * num2; j>=(i - 1)*num2 && j < i*num2 && j < list.size(); j++) {
							map = list.get(j);
							a = new Activity();
							aa = new ActivityExtends();
							
							a.setPlannedStartDate(P6TypeConvert.convert(((Timestamp)map.get("PLANNED_START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
							a.setPlannedFinishDate(P6TypeConvert.convert(((Timestamp)map.get("PLANNED_FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
							
							if (map.get("START_DATE")!=null) {
								a.setStartDate(P6TypeConvert.convert(((Timestamp)map.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//结束时间
							}
							
							if (map.get("FINISH_DATE")!=null) {
								a.setFinishDate(P6TypeConvert.convert(((Timestamp)map.get("FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//结束时间
							}
							
							if (map.get("ACTUAL_START_DATE")!=null) {
								a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", namespace, ((Timestamp)map.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
							}
							
							if (map.get("ACTUAL_FINISH_DATE")!=null) {
								a.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate", namespace, ((Timestamp)map.get("ACTUAL_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
							}
							
							a.setId((String)map.get("Id"));
							a.setName((String)map.get("NAME"));
							a.setProjectId((String)map.get("PROJECT_ID"));
							a.setProjectName((String)map.get("PROJECT_NAME"));
							a.setProjectObjectId(((BigDecimal)map.get("PROJECT_OBJECT_ID")).intValue());
							a.setStatus((String)map.get("STATUS"));//开始//Completed
							a.setWBSCode((String)map.get("WBS_CODE"));
							a.setWBSName((String)map.get("WBS_NAME"));
							//设置CALENDAR信息
							a.setCalendarName((String)map.get("CALENDAR_NAME"));
							a.setCalendarObjectId(Integer.valueOf(((BigDecimal)map.get("CALENDAR_OBJECT_ID")).toEngineeringString()));
							a.setWBSObjectId(P6TypeConvert.convertInteger("WBSObjectId",((BigDecimal)map.get("WBS_OBJECT_ID")).toEngineeringString()));
							a.setObjectId(((BigDecimal)map.get("OBJECT_ID")).intValue());
							//System.out.println("objectId="+a.getObjectId());
							if (map.get("SUSPEND_DATE")!=null) {
								a.setSuspendDate(P6TypeConvert.convertXMLGregorianCalendar("SuspendDate", namespace, ((Timestamp)map.get("SUSPEND_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
							}
							if (map.get("RESUME_DATE")!=null) {
								a.setResumeDate(P6TypeConvert.convertXMLGregorianCalendar("ResumeDate", namespace, ((Timestamp)map.get("RESUME_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
							}
							a.setNotesToResources((String)map.get("NOTES_TO_RESOURCES"));
							if (map.get("EXPECTED_FINISH_DATE")!=null) {
								a.setExpectedFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ResumeDate", namespace, ((Timestamp)map.get("EXPECTED_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
							}
							a.setPlannedDuration(Double.valueOf(((BigDecimal)map.get("PLANNED_DURATION")).toEngineeringString()));
							a.setLastUpdateDate(P6TypeConvert.convertXMLGregorianCalendar("LastUpdateDate", namespace, ((Timestamp)map.get("MODIFI_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
							a.setLastUpdateUser((String)map.get("LAST_UPDATE_USER"));
							
							a.setRemainingDuration(P6TypeConvert.convertDouble("RemainingDuration",namespace,((BigDecimal) map.get("REMAINING_DURATION")).toEngineeringString()));
							
							aa.setActivity(a);
							aa.setSubmitFlag("5");//把状态修改为可同步状态
							
							activitys.add(a);
							listUpdate.add(aa);
						//}

					}
					log.info("开始将项目"+projectMap.get("object_id").toString()+"数据写入P6...");
					//log.info("开始第"+i+"次往p6写入数据...");
					try {
						activityWSBean.updateActivityToP6(null, activitys);
						activityMCSBean.saveOrUpdateP6ActivityToMCSByProjectId(listUpdate, projectMap.get("object_id").toString(),user);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						log.info("项目id:"+projectMap.get("object_id").toString()+",数据同步时发生错误");
						continue;
					}
					//log.info("第"+i+"次写入完成...");
					log.info("完成将项目"+projectMap.get("object_id").toString()+"数据写入P6...");
				}
			}
		}
		log.info("推送完成...");
		log.info("exit synActivityGMStoP6()");
	}
	
	/**
	 * 同步P6删除的数据
	 */
	public void syncP6DeletedDatas() throws Exception{
		
		// 获取上次同步的时间
		Timestamp t = getInterExecDate("P6_Common.syncP6DeletedDatas", "C6000000000001");
		
		t.setTime(t.getTime() - 60*60*1000);// 向前提一个小时，避免应用服务器和数据库服务器的时间差 
		
		Timestamp newT = new Timestamp(System.currentTimeMillis());

		log.debug("开始执行同步P6删除的数据到GMS的接口，上次执行时间为："+t);
		
		String[] sqls = new String[]{
				"delete from  bgp_p6_project t where t.object_id in (select proj_id from project@p6db where delete_date>to_date(?,'yyyy-MM-dd hh24:mi:ss'))"
				,"delete from bgp_p6_project_wbs t  where t.object_id in (select wbs.object_id from bgp_p6_project_wbs wbs left join projwbs@p6db p6wbs on wbs.object_id = p6wbs.wbs_id where p6wbs.wbs_id is null and wbs.bsflag = '0')"
				,"delete from  bgp_p6_activity t where t.object_id in (select task_id from task@p6db where delete_date>to_date(?,'yyyy-MM-dd hh24:mi:ss'))"
				,"delete from bgp_p6_activity t  where t.object_id in (select ttt.object_id from bgp_p6_activity ttt left join task@p6db tt on ttt.object_id = tt.task_id and tt.delete_date is null where tt.task_id is null and ttt.bsflag = '0')"
				,"delete from  bgp_p6_assign_mapping t where t.object_id in (select ttt.object_id from bgp_p6_assign_mapping ttt left join taskrsrc@p6db tt on ttt.object_id = tt.taskrsrc_id and tt.delete_date is null where tt.taskrsrc_id is null and ttt.bsflag = '0')"
				,"delete from  bgp_p6_resource t where t.object_id in (select rsrc_id from rsrc@p6db where delete_date>to_date(?,'yyyy-MM-dd hh24:mi:ss'))"
				,"delete from  p_assign_mapping t where t.p_code in (select rsrc_short_name from rsrc@p6db where  delete_date>to_date(?,'yyyy-MM-dd hh24:mi:ss'))"
		};
		
		RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		
		final String tStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(t);
		
		PreparedStatementSetter pss = new PreparedStatementSetter(){
			public void setValues(PreparedStatement ps){
				try {
					ps.setString(1, tStr);
				} catch (Exception e) {
					log.error(e);
					return;
				}
				
			}
		};
		
		for(int i=0;i<sqls.length;i++){
			try{
				int index = sqls[i].indexOf("?");
				int rows = 0;
				if(index>=0){
					rows = radDao.getJdbcTemplate().update(sqls[i], pss);
				}else{
					rows = radDao.getJdbcTemplate().update(sqls[i]);
				}
				
				log.debug("条数："+rows);
			} catch (Exception e) {
				log.error(e);
				return;
			}
		}
		
		setInterExecDate("P6_Common.syncP6DeletedDatas", "C6000000000001", newT);

		log.debug("同步P6删除的数据到GMS的接口执行成功，设置执行时间为："+newT);
		
	}
	
	/**
     * 获取接口的最后执行时间
     * @return
     */
    public Timestamp getInterExecDate(String interId, String orgId){

    	List list = radDao.getJdbcTemplate().queryForList("select exec_date from bgp_inter_manage where inter_id='"+interId+"' and exec_org_id='"+orgId+"'");
    	
    	if(list!=null && list.size()>0){

        	Map map = (Map)list.get(0);
        	
    		return (Timestamp)map.get("exec_date");
    	}else {
    		return new Timestamp(0);
    	}
    }

    /**
     * 设置接口的最后执行时间
     * @return
     */
    public void setInterExecDate(String interId, String orgId, Timestamp t){

    	int i = radDao.getJdbcTemplate().update("update bgp_inter_manage set exec_date=? where inter_id=? and exec_org_id=?", new Object[]{t, interId, orgId}, new int[]{Types.TIMESTAMP, Types.VARCHAR, Types.VARCHAR});
    	
    	if(i==0){ // no update
    		radDao.getJdbcTemplate().update("insert into bgp_inter_manage (exec_date, inter_id, exec_org_id) values(?,?,?)", new Object[]{t, interId, orgId}, new int[]{Types.TIMESTAMP, Types.VARCHAR, Types.VARCHAR});
    	}
    }
	
	
//	public void synUDFValueP6toGMS(String filter) throws Exception{
//		log.info("enter synUDFValueP6toGMS("+filter+")");
//		UDFValueWSBean udfValueWS=new UDFValueWSBean();
//		List<UDFValue> list=udfValueWS.getUDFValueFromP6(null, filter, null);
//		UDFValueMCSBean udfValueMCS=new UDFValueMCSBean();
//		udfValueMCS.saveP6UDFValueToMCS(list);
//		log.info("exit synUDFValueP6toGMS()");
//	}
    
    /**
     * 同步项目进度计划中的目标项目
     */
	public void synProjectPlanBaselineProject() throws Exception{
		log.info("开始同步项目进度计划中的目标项目");
		ProjectMCSBean mcsBean = new ProjectMCSBean();
		List<Map> planMapList = mcsBean.getBaselineProjectFromP6();
		if(planMapList != null && planMapList.size() > 0){
			mcsBean.synProjectPlanBaselineProject(planMapList, user);
		}else{
			log.info("没有需要同步的项目进度计划");
		}
		log.info("结束同步项目进度计划中的目标项目");
	}
	
	/**
	 * 同步项目的目标项目ID和数据统计时间
	 * @throws Exception
	 */
	public void syncBaseProjectId() throws Exception{
		
		// 获取上次同步的时间
		Timestamp t = getInterExecDate("P6_Common.syncBaseProjectId", "C6000000000001");
		ProjectMCSBean mcsBean = new ProjectMCSBean();
		
		t.setTime(t.getTime() - 30*60*1000);// 向前提半个小时，避免应用服务器和数据库服务器的时间差 
		
		Timestamp newT = new Timestamp(System.currentTimeMillis());

		log.debug("开始执行同步目标项目ID接口，上次执行时间为："+t);
		
		final String tStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(t);
		String sss = "w";
		
		//查询出需要同步的项目
		String sql = "select p.proj_id as PROJECT_OBJECT_ID,p.sum_base_proj_id as BASELINE_OBJECT_ID,p.last_recalc_date as project_data_date from project@p6db p where p.sum_base_proj_id is not null and p.delete_date is null and p.proj_id in "+
					 "(select bp.object_id from bgp_p6_project bp where bp.bsflag = '0' and bp.project_object_id is null) and p.update_date >= to_date('"+tStr+"','yyyy-MM-dd hh24:mi:ss')";
		
		List<Map> list;
		try {
			list = radDao.queryRecords(sql);
			mcsBean.synProjectBaselineProject(list, user);
			setInterExecDate("P6_Common.syncBaseProjectId", "C6000000000001", newT);
			log.debug("完成执行同步目标项目ID接口，一共"+list.size()+"条数据。设置执行时间为："+newT);
		} catch (Exception e) {
			log.info("有异常,可能dblink出问题");
			e.printStackTrace();
		}
		
	}
	
	public static void main(String[] args) throws Exception {
		//SynUtils synUtils = new SynUtils();
		//synUtils.synActivityP6toGMS("ObjectId = '28195'");
		//synUtils.synActivityGMStoP6("2013/1/14 9:55:29");
		//System.out.println("完成");
	}
}
