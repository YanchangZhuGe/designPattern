package com.bgp.mcs.service.pm.service.project;

import java.net.URLDecoder;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityMCSBean;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityWSBean;
import com.bgp.mcs.service.pm.service.p6.activity.relationship.RelationshipWSBean;
import com.bgp.mcs.service.pm.service.p6.job.JobWSBean;
import com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean;
import com.bgp.mcs.service.pm.service.p6.project.baselineproject.BaselineProjectMCSBean;
import com.bgp.mcs.service.pm.service.p6.project.baselineproject.BaselineProjectWSBean;
import com.bgp.mcs.service.pm.service.p6.util.SynUtils;
import com.bgp.mcs.service.pm.service.p6.wbs.WbsMCSBean;
import com.bgp.mcs.service.pm.service.p6.wbs.WbsWSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.primavera.ws.p6.activity.Activity;
import com.primavera.ws.p6.activity.ActivityExtends;
import com.primavera.ws.p6.baselineproject.BaselineProject;
import com.primavera.ws.p6.project.Project;
import com.primavera.ws.p6.relationship.Relationship;
import com.primavera.ws.p6.wbs.WBS;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：赵学良，Oct 15, 2013
 * 
 * 描述：
 * 
 * 说明：
 */
public class P6ProjectPlanSrv extends BaseService{
	
	private ILog log;
	private ActivityWSBean activityWSBean;
	private ActivityMCSBean activityMCSBean;
	private RelationshipWSBean relationshipWSBean;
	private WbsWSBean wbsWSBean;
	private WbsMCSBean wbsMcsBean;
	private BaselineProjectWSBean baselineProjectWSBean;
	private BaselineProjectMCSBean baselineProjectMCSBean;
	private JobWSBean jobWsBean;
	private ProjectWSBean projectWSBean;
	private static IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao radDao;
	
	private org.apache.commons.logging.Log p6log ;
	public P6ProjectPlanSrv() {
		log = LogFactory.getLogger(P6ProjectPlanSrv.class);		
		p6log = org.apache.commons.logging.LogFactory.getLog("p6syn");

		baselineProjectWSBean=(BaselineProjectWSBean)BeanFactory.getBean("P6BaselineProjectWSBean");
		baselineProjectMCSBean=(BaselineProjectMCSBean)BeanFactory.getBean("P6BaselineProjectMCSBean");

		activityWSBean = (ActivityWSBean) BeanFactory.getBean("P6ActivityWSBean");
		activityMCSBean = (ActivityMCSBean) BeanFactory.getBean("P6ActivityMCSBean");
		relationshipWSBean = (RelationshipWSBean) BeanFactory.getBean("P6RelationshipWSBean");
		projectWSBean = (ProjectWSBean) BeanFactory.getBean("P6ProjectWSBean");
		wbsWSBean = (WbsWSBean) BeanFactory.getBean("P6WbsWSBean");
		wbsMcsBean = (WbsMCSBean) BeanFactory.getBean("P6WbsMCSBean");
		jobWsBean = (JobWSBean) BeanFactory.getBean("P6JobWSBean");
		radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	}
	public P6ProjectPlanSrv(String wsName) {
		relationshipWSBean = (RelationshipWSBean) BeanFactory.getBean(wsName);
	}
	
	/**
	 * 增加目标计划
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addBaseLineProject(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		SynUtils synUtils = new SynUtils();
		String projectId = reqDTO.getValue("p6_object_id");
		boolean flag= projectWSBean.copyProjectAsBaseline(projectId);
		if(flag){
			List<String> p6List = new ArrayList<String>();
			
			List<BaselineProject>  list2 = baselineProjectWSBean.getBaselineProjectFromP6(null, "OriginalProjectObjectId="+projectId, null);
			if(list2!=null){
				for(int f=0;f<list2.size();f++){
					BaselineProject r = list2.get(f);
					int object_id = r.getObjectId();
					p6List.add(object_id+"");
				}
			}
			
			String getgmsAll = "select OBJECT_ID from BGP_P6_PROJECT where BSFLAG='0' and PROJECT_OBJECT_ID='"+projectId+"'";
			List<Map> gmsAllProject = radDao.queryRecords(getgmsAll);
			if(gmsAllProject!=null){
				for(int g=0;g<gmsAllProject.size();g++){
					Map temp1 = gmsAllProject.get(g);
					String objectId = (String)temp1.get("object_id");
					for(int e=0;e<p6List.size();e++){
						String p6Id = p6List.get(e);
						if(p6Id.equals(objectId)){
							p6List.remove(e);
							e--;
							continue;
						}
					}

				}
			}
			int size = p6List.size();
			String newObjectId = p6List.get(0);

			synUtils.synBaselineProject(projectId);//目标项目同步
			//ProjectId
			//List<WBS> list=wbsWSBean.getWbsFromP6(null, "ProjectObjectId="+newObjectId, "ObjectId desc");

			
			synUtils.synWbsP6toGMS("ProjectObjectId="+newObjectId); //同步wbs
			
			String getOldWbsHeadSql="select  w1.OBJECT_ID,w3.WBSHEAD  from BGP_P6_PROJECT_WBS w1"
							+" left join (select  w2.OBJECT_ID, w2.NAME, w2.wbshead, w2.code from BGP_P6_PROJECT_WBS w2 where w2.PROJECT_OBJECT_ID='"+projectId+"' and w2.BSFLAG='0') w3"
						    +" on w3.name=w1.name and w1.code=w3.code where w1.PROJECT_OBJECT_ID='"+newObjectId+"' and w1.BSFLAG='0' ";
			List<Map> oldWBSHeadList = radDao.queryRecords(getOldWbsHeadSql);
			if(oldWBSHeadList!=null){
				for(int j=0;j<oldWBSHeadList.size();j++){
					Map temp = oldWBSHeadList.get(j);
					String tempObjectId = (String)temp.get("object_id");
					String tempwbshead = (String)temp.get("wbshead");
					String updateSql = "update BGP_P6_PROJECT_WBS set wbshead='"+tempwbshead+"' where object_id='"+tempObjectId+"' and BSFLAG='0'";
					radDao.executeUpdate(updateSql);
				}
				
			}
		}
		
		msg.setValue("message", flag);
		return msg;
	}
	
	public Map<String ,Object> getProjectDate(String projectInfoNo) throws Exception{
		String sql = "SELECT PROJ_ID,PLAN_START_DATE, LAST_RECALC_DATE FROM PROJECT@p6db where PROJ_ID=(select OBJECT_ID from BGP_P6_PROJECT where PROJECT_INFO_NO='"+projectInfoNo+"' and BSFLAG='0')";
		Map map = jdbcDao.queryRecordBySQL(sql);
		return map;
	}	
	
	public ISrvMsg updateProjectDate(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String plan_start_date =  reqDTO.getValue("plan_start_date");
		String last_recalc_date =  reqDTO.getValue("last_recalc_date");
		String proj_id =  reqDTO.getValue("proj_id");
		String sql="update PROJECT@p6db set PLAN_START_DATE=to_date('"+plan_start_date+"','yyyy-MM-dd'), LAST_RECALC_DATE=to_date('"+last_recalc_date+"','yyyy-MM-dd') where PROJ_ID='"+proj_id+"'";
		int tempp6 = radDao.executeUpdate(sql);
		msg.setValue("message", "success");
		return msg;
	}
	
	public ISrvMsg selectProjectAsBaseline(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		SynUtils synUtils = new SynUtils();
		String projectId = reqDTO.getValue("p6_object_id");
		String baseline = reqDTO.getValue("baseLine");
		String sql="update BGP_P6_PROJECT set BASELINE_PROJECT_ID='"+baseline+"' where OBJECT_ID='"+projectId+"'";
		int temp = radDao.executeUpdate(sql);
		String p6sql="update PROJECT@p6db set SUM_BASE_PROJ_ID='"+baseline+"' where PROJ_ID='"+projectId+"'";
		int tempp6 = radDao.executeUpdate(p6sql);

		msg.setValue("message", true);
		return msg;
	}

	public ISrvMsg deleteBaseLineProject(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		SynUtils synUtils = new SynUtils();
		List<Integer> projectIds = new ArrayList<Integer>();
		String projectIdsTemp = reqDTO.getValue("p6_object_ids");
		String[] idTemp = projectIdsTemp.split(",");
		for(int i=0;i<idTemp.length;i++){
			projectIds.add(Integer.parseInt(idTemp[i]));
		}
		boolean flag = baselineProjectWSBean.deleteBaseLineProject(null,projectIds);
		if(flag){
			baselineProjectMCSBean.deleteBaselineProjectToMCS(projectIds);//目标项目同步

		}
		msg.setValue("message", flag);

		return msg;
	}

	/**
	 * 增加wbs
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addWBS(ISrvMsg reqDTO) throws Exception{
		
		//首先往P6中写人,返回主键值,再网本地数据库中写人
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken mcsUser = reqDTO.getUserToken();
		if(mcsUser == null){
			mcsUser = new UserToken();
			mcsUser.setEmpId("0211038948");
		}
		String projectInfoNo = reqDTO.getValue("project_info_no");
		if(projectInfoNo == null || "".equals(projectInfoNo)){
			projectInfoNo = mcsUser.getProjectInfoNo();
		}
		String projectObjectId = (getProjectP6ObjectId(projectInfoNo).get("objectId")).toString();
		String parenWbsObjectId = reqDTO.getValue("parent_wbs_object_id");
		String WBSName = reqDTO.getValue("wbs_name");
		String WBSCode = reqDTO.getValue("wbs_code");
		
		String WBSHead = reqDTO.getValue("wbs_head");

		String ordercode = reqDTO.getValue("ordercode");
		WBS wbs = new WBS();
		wbs.setSequenceNumber(Integer.parseInt(ordercode));
		wbs.setCode(WBSCode);
		wbs.setName(WBSName);
		wbs.setProjectObjectId(Integer.parseInt(projectObjectId));
		
		wbs.setParentObjectId(P6TypeConvert.convertInteger("ParentObjectId", parenWbsObjectId));
		List<WBS> wbsList = new ArrayList<WBS>();
		wbsList.add(wbs);
		int wbsObjectId = wbsWSBean.addWbs(null, wbsList);
		
		List<Map> mcsWbsMapList = new ArrayList<Map>();
		Map<String,Object> mcsWbsMap = new HashMap<String,Object>();
		mcsWbsMap.put("project_object_id", Integer.parseInt(projectObjectId));
		mcsWbsMap.put("object_id", wbsObjectId);
		mcsWbsMap.put("parent_object_id", Integer.parseInt(parenWbsObjectId));
		mcsWbsMap.put("name", WBSName);
		mcsWbsMap.put("code", WBSCode);
		mcsWbsMap.put("ordercode", ordercode);
		mcsWbsMap.put("wbshead", WBSHead);
		String updateAcitHead = "update BGP_P6_ACTIVITY set ACTIVITYHEAD='"+WBSHead+"' where BSFLAG='0' and WBS_OBJECT_ID='"+wbsObjectId+"'";
		radDao.executeUpdate(updateAcitHead);
		
		mcsWbsMapList.add(mcsWbsMap);
		try {
			this.insertP6WbsToMCS(mcsWbsMapList, mcsUser); 
			msg.setValue("message", "success");
			msg.setValue("wbsObjectId", wbsObjectId);
		} catch (Exception e) {
			List<Integer> paramList = new ArrayList<Integer>();
			paramList.add(wbsObjectId);
			wbsWSBean.deleteWbs(null, paramList);
			paramList = null;
			msg.setValue("message", "success");
		}
		
		return msg;
	}
	
	public Date getp6Project(String projectInfoNo) throws ParseException{
		String sql="select CREATE_DATE from BGP_P6_PROJECT where BSFLAG='0' and PROJECT_INFO_NO='"+projectInfoNo+"'";
		Map map = radDao.queryRecordBySQL(sql);
		String StrDate = (String) map.get("create_date");
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		return df.parse(StrDate);
	}
	public ISrvMsg updateCALENDAR(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		Map<String,Object> map = reqDTO.toMap();
		String projectId = (String)map.get("probjectId");
		String clndrName = (String)map.get("clndrName");
		String sql="update PROJECT@p6db set CLNDR_ID='"+clndrName+"' where PROJ_ID='"+projectId+"'";
		radDao.executeUpdate(sql);
		msg.setValue("message", "success");
		return msg;

	}
	/**
	 * 修改wbs
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateWBS(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();

		if(user == null){
			user = new UserToken();
			user.setEmpId("0211038948");
		}
		Map<String,Object> map = reqDTO.toMap();
		
		String temp = (String) map.get("wbs_name");
		map.put("wbs_name", URLDecoder.decode(temp,"UTF-8"));
		List<WBS> wbsList = new ArrayList<WBS>();
		WBS wbs = new WBS();
		wbs.setName(map.get("wbs_name").toString());
		wbs.setObjectId(Integer.parseInt(map.get("wbs_object_id").toString()));
		wbs.setCode(map.get("wbs_code").toString());
		wbsList.add(wbs);
		if(wbsWSBean.updateWbs(null, wbsList)){
			//更新gms中的wbs
			List<Map> mcsWbsMapList = new ArrayList<Map>();
			String wbs_name = map.get("wbs_name").toString();
			String wbs_code = map.get("wbs_code").toString();
			String wbs_head = map.get("wbs_head").toString();
			
			Map<String,Object> mcsWbsMap = new HashMap<String,Object>();
			mcsWbsMap.put("object_id", map.get("wbs_object_id").toString());
			mcsWbsMap.put("name", wbs_name);
			mcsWbsMap.put("code", wbs_code);
			mcsWbsMap.put("wbshead", wbs_head);

			mcsWbsMapList.add(mcsWbsMap);
			this.updateP6WbsToMCS(mcsWbsMapList, user);
			//修改作业的责任人
			String updateAcitHead = "update BGP_P6_ACTIVITY set ACTIVITYHEAD='"+map.get("wbs_head").toString()+"' where BSFLAG='0' and WBS_OBJECT_ID='"+map.get("wbs_object_id").toString()+"'";
			radDao.executeUpdate(updateAcitHead);
			//修改目标计划责任人
			if(!"".equals(wbs_name)&&!"".equals(wbs_code)){
				String updateBaseProjectWbsHead="update BGP_P6_PROJECT_WBS wbs set wbs.WBSHEAD='"+wbs_head+"'  where wbs.BSFLAG='0' and wbs.PROJECT_OBJECT_ID="
					+"(select p.BASELINE_PROJECT_ID from BGP_P6_PROJECT p where p.BSFLAG='0' and p.PROJECT_INFO_NO='"+projectInfoNo+"') and wbs.CODE = '"+wbs_code+"' and wbs.NAME='"+wbs_name+"'";
				radDao.executeUpdate(updateBaseProjectWbsHead);

			}
			msg.setValue("message", "success");
		}else{
			msg.setValue("message", "fail");
		}
		
		return msg;
	}
	
	/**
	 * 删除wbs
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteWBS(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		if(user == null){
			user = new UserToken();
			user.setEmpId("0211038948");
		}
		String wbsObjectId = reqDTO.getValue("wbsObjectId");
		if(wbsObjectId != null && !"".equals(wbsObjectId)){
			List<Integer> wbsObjectIdList = new ArrayList<Integer>();
			wbsObjectIdList.add(new Integer(wbsObjectId));
			if(wbsWSBean.deleteWbs(null, wbsObjectIdList)){
				//删除gms中wbs
				if(this.deleteWBSFromGMS(wbsObjectId)){
					//删除wbs下的作业
					if(this.deleteActivityInWbs(wbsObjectId)){
						log.info("删除wbs下面的作业成功");
					}else{
						log.info("删除wbs下面的作业失败!");
					}
					msg.setValue("message", "success");
				}else{
					msg.setValue("message", "fail");
				}
			}else{
				msg.setValue("message", "fail");
			}
		}else{
			msg.setValue("message", "fail");
		}
		return msg;
	}
	
	/**
	 * 删除现有计划
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delPlan(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken mcsUser = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("project_info_no");
		if(projectInfoNo == null || "".equals(projectInfoNo)){
			projectInfoNo = mcsUser.getProjectInfoNo();
		}
		//通过项目主键获取对应P6主键和wbs主键
		Map<String,Object> projectMap = getProjectP6ObjectId(projectInfoNo);
		
		//当前项目主键
		String projectObjectId = projectMap.get("objectId").toString();
		if(this.deletePlanInfo(projectObjectId)){
			msg.setValue("message", "success");
		}else{
			msg.setValue("message", "fail");
		}
		return msg;
	}
	
	/**
	 * 增加作业
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addTask(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken mcsUser = reqDTO.getUserToken();
		if(mcsUser == null){
			mcsUser = new UserToken();
			mcsUser.setEmpId("0211038948");
		}
		String projectInfoNo = reqDTO.getValue("project_info_no");
		if(projectInfoNo == null || "".equals(projectInfoNo)){
			projectInfoNo = mcsUser.getProjectInfoNo();
		}
		String projectObjectId = (getProjectP6ObjectId(projectInfoNo).get("objectId")).toString();
		String wbsObjectId = reqDTO.getValue("wbs_object_id");
		String activityName = URLDecoder.decode(reqDTO.getValue("activity_name"),"UTF-8");
		String activityId = reqDTO.getValue("activity_id");
		String planStartDate = reqDTO.getValue("plan_start_date");
		String planEndDate = reqDTO.getValue("plan_end_date");
		String activityWbsName = reqDTO.getValue("wbs_name");
		String activityhead = reqDTO.getValue("activity_head");
		String type = reqDTO.getValue("type").replace("+", " ");
		String plannedDuration = reqDTO.getValue("plannedDuration");

		
		Activity aty = new Activity();
		aty.setProjectObjectId(new Integer(projectObjectId));
		aty.setWBSObjectId(P6TypeConvert.convertInteger("WBSObjectId", wbsObjectId));
		aty.setName(activityName);
		aty.setWBSName(activityWbsName);
		aty.setId(activityId);
		aty.setPlannedStartDate(P6TypeConvert.convert(planStartDate,"yyyy-MM-dd"));
		aty.setPlannedFinishDate(P6TypeConvert.convert(planEndDate,"yyyy-MM-dd"));
		aty.setType(type);
		if(!"".equals(plannedDuration)){
			aty.setPlannedDuration(Double.valueOf(plannedDuration)*8);
		}else{
			aty.setPlannedDuration(0.0);

		}

		List<Activity> atyList = new ArrayList<Activity>();
		atyList.add(aty);
		int activityObjectId = activityWSBean.addActivity(null, atyList);
		
		List<Map> mcsActivityMapList = new ArrayList<Map>();
		Map<String,Object> mcsActivityMap = new HashMap<String,Object>();
		mcsActivityMap.put("object_id", activityObjectId);
		mcsActivityMap.put("project_object_id", Integer.parseInt(projectObjectId));
		mcsActivityMap.put("wbs_object_id", wbsObjectId);
		mcsActivityMap.put("wbs_name", activityWbsName);
		mcsActivityMap.put("name", activityName);
		mcsActivityMap.put("id", activityId);
		mcsActivityMap.put("planned_start_date", planStartDate);
		mcsActivityMap.put("planned_finish_date", planEndDate);
		mcsActivityMap.put("activityhead", activityhead);
		mcsActivityMap.put("type", type);
		if(!"".equals(plannedDuration)){
			mcsActivityMap.put("PLANNED_DURATION", Integer.parseInt(plannedDuration)*8);
		}else{
			mcsActivityMap.put("PLANNED_DURATION", 0);

		}


		  
		mcsActivityMapList.add(mcsActivityMap);
		try {
			this.insertP6ActivityToMCS(mcsActivityMapList, mcsUser);
			msg.setValue("message", "success");
			msg.setValue("activityObjectId", activityObjectId);
		} catch (Exception e) {
			//如果写入本地数据库失败,删除P6中的对应数据,保证数据一致性
			List<Integer> paramList = new ArrayList<Integer>();
			paramList.add(activityObjectId);
			activityWSBean.deleteActivity(null, paramList);
			paramList = null;
			msg.setValue("message", "fail");
		}
		
		return msg;
	}
	
	/**
	 * 修改作业
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateTask(ISrvMsg reqDTO) throws Exception{
		String namespace = "http://xmlns.oracle.com/Primavera/P6/WS/Activity/V1";

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken mcsUser = reqDTO.getUserToken();
		if(mcsUser == null){
			mcsUser = new UserToken();
			mcsUser.setEmpId("0211038948");
		}
		
		Map<String,Object> map = reqDTO.toMap();
		String temp = (String) map.get("task_name");
		map.put("task_name", URLDecoder.decode(temp,"UTF-8"));
		
		Activity aty = new Activity();
		aty.setObjectId(new Integer(map.get("task_object_id").toString()));
		aty.setName(map.get("task_name").toString());
		aty.setType(map.get("type").toString());
		aty.setId(map.get("task_id").toString());
		aty.setPlannedStartDate(P6TypeConvert.convert(map.get("plan_start_date").toString(),"yyyy-MM-dd"));
		aty.setPlannedFinishDate(P6TypeConvert.convert(map.get("plan_end_date").toString(),"yyyy-MM-dd"));
		
		aty.setPlannedDuration(Double.valueOf((map.get("plannedDuration")).toString())*8);

		aty.setPrimaryConstraintType(map.get("Primary_Constraint_Type").toString());
		aty.setPrimaryConstraintDate(P6TypeConvert.convertXMLGregorianCalendar("PrimaryConstraintDate", namespace, (map.get("Primary_Constraint_Date")).toString(), "yyyy-MM-dd"));
		aty.setSecondaryConstraintType(map.get("Secondary_Constraint_Type").toString());
		aty.setSecondaryConstraintDate(P6TypeConvert.convertXMLGregorianCalendar("SecondaryConstraintDate", namespace, (map.get("Secondary_Constraint_Date")).toString(), "yyyy-MM-dd"));

		
		
		List<Activity> activityList = new ArrayList<Activity>();
		activityList.add(aty);
		if(activityWSBean.updateActivityToP6(null, activityList)){
			//更新gms中的activity
			List<Map> mcsActivityMapList = new ArrayList<Map>();
			Map<String,Object> mcsActivityMap = new HashMap<String,Object>();
			mcsActivityMap.put("object_id", map.get("task_object_id").toString());
			mcsActivityMap.put("activityhead", map.get("activityhead").toString());
			mcsActivityMap.put("type", map.get("type").toString());
			mcsActivityMap.put("name", map.get("task_name").toString());
			mcsActivityMap.put("id", map.get("task_id").toString());
			mcsActivityMap.put("planned_start_date", map.get("plan_start_date").toString());
			mcsActivityMap.put("planned_finish_date", map.get("plan_end_date").toString());
			
			mcsActivityMap.put("PLANNED_DURATION", Integer.parseInt(map.get("plannedDuration").toString())*8);
			mcsActivityMap.put("Primary_Constraint_Type", map.get("Primary_Constraint_Type").toString());
			mcsActivityMap.put("Primary_Constraint_Date", map.get("Primary_Constraint_Date").toString());
			mcsActivityMap.put("Secondary_Constraint_Type", map.get("Secondary_Constraint_Type").toString());
			mcsActivityMap.put("Secondary_Constraint_Date", map.get("Secondary_Constraint_Date").toString());

			
			mcsActivityMapList.add(mcsActivityMap);
			this.updateP6ActivityToMCS(mcsActivityMapList, mcsUser);
			msg.setValue("message", "success");
		}else{
			msg.setValue("message", "fail");
		}
		
		return msg;
	}
	
	/**
	 * 删除作业
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTask(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String p6ObjectIds = reqDTO.getValue("p6_object_ids");
		String gmsObjectIds = reqDTO.getValue("gms_object_ids");
		String[] ids = p6ObjectIds.split(",");
		List<Integer> activityObjectIdList = new ArrayList<Integer>();
		for(int i=0;i<ids.length;i++){
			activityObjectIdList.add(new Integer(ids[i]));
		}
		
		if(activityWSBean.deleteActivity(null, activityObjectIdList)){
			//删除gms中的作业
			if(this.deleteActivityFromGMS(gmsObjectIds)){
				msg.setValue("message", "success");
			}
		}
		
		return msg;
	}
	
	/**
	 * 删除单条作业
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteOneTask(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String objectId = reqDTO.getValue("object_id");
		List<Integer> activityObjectIdList = new ArrayList<Integer>();
		activityObjectIdList.add(new Integer(objectId));
		
		if(activityWSBean.deleteActivity(null, activityObjectIdList)){
			//删除gms中的作业
			if(this.deleteOneActivityFromGMS(objectId)){
				msg.setValue("message", "success");
			}
		}
		
		return msg;
	}
	
	/**
	 * 增加作业关系
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addTaskRelationShip(ISrvMsg reqDTO) throws Exception{
		String namespace = "http://xmlns.oracle.com/Primavera/P6/WS/Activity/V1";

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String typeFlag = reqDTO.getValue("type_flag");//区分前继还是后续
		String activityObjectId = reqDTO.getValue("activity_object_id");
		
		List<Relationship> updaterelationshipList = new ArrayList<Relationship>();
		List<Map> relationshipIds = new ArrayList<Map>();
		
		if("predecessor".equals(typeFlag)){
			//前继作业
			String predecessorObjectIds = reqDTO.getValue("predecessor_object_ids");
			//关联的作业主键
			String[] ids = predecessorObjectIds.split(","); 
			for(int i = 0;i<ids.length;i++){
				String addorUpdate = reqDTO.getValue("predecessorAddorUpdate"+(i+1));
				if("update".equals(addorUpdate)){
					Relationship updaters = new Relationship();	
					String type=reqDTO.getValue("predecessor_type"+(i+1)).replace("+", " ");
					String relationObjectId=reqDTO.getValue("predecessorRelationObjectId"+(i+1));
					updaters.setObjectId(new Integer(relationObjectId));
					updaters.setType(type);
					int tempPredecessororLag = Integer.parseInt(reqDTO.getValue("PredecessororLag"+(i+1)))*8;
					updaters.setLag(P6TypeConvert.convertDouble("Lag",namespace,tempPredecessororLag+""));
					updaterelationshipList.add(updaters);
				}else{
					List<Relationship> addrelationshipList = new ArrayList<Relationship>();

					Relationship addrs = new Relationship();
					String type=reqDTO.getValue("predecessor_type"+(i+1)).replace("+", " ");
					int tempPredecessororLag = Integer.parseInt(reqDTO.getValue("PredecessororLag"+(i+1)))*8;
					
					addrs.setPredecessorActivityObjectId(new Integer(ids[i]));
					addrs.setSuccessorActivityObjectId(new Integer(activityObjectId));
					addrs.setLag(P6TypeConvert.convertDouble("Lag",namespace,tempPredecessororLag+""));
					addrs.setType(type);
					
					addrelationshipList.add(addrs);
					
					HashMap<String,Integer> tempMap = new HashMap<String, Integer>();
					int relationshipCount = relationshipWSBean.addRelationship(null, addrelationshipList);
					tempMap.put("index", i+1);
					tempMap.put("value", relationshipCount);

					relationshipIds.add(tempMap);
					
				}
			}
		}else if("successor".equals(typeFlag)){
			//后继作业
			String successorObjectIds = reqDTO.getValue("successor_object_ids");
			//关联的作业主键
			String[] ids = successorObjectIds.split(",");
			for(int i = 0;i<ids.length;i++){
				
				String addorUpdate = reqDTO.getValue("successorAddorUpdate"+(i+1));
				
				if("update".equals(addorUpdate)){
					Relationship updaters = new Relationship();	
					String type=reqDTO.getValue("successor_type"+(i+1)).replace("+", " ");
					String relationObjectId=reqDTO.getValue("successorRelationObjectId"+(i+1));
					updaters.setObjectId(new Integer(relationObjectId));
					updaters.setType(type);
					int tempPredecessororLag = Integer.parseInt(reqDTO.getValue("SuccessorLag"+(i+1)))*8;
					updaters.setLag(P6TypeConvert.convertDouble("Lag",namespace,tempPredecessororLag+""));
					updaterelationshipList.add(updaters);
				}else{
					
					List<Relationship> addrelationshipList = new ArrayList<Relationship>();

					Relationship addrs = new Relationship();
					String type=reqDTO.getValue("successor_type"+(i+1)).replace("+", " ");
					int tempSuccessorLag = Integer.parseInt(reqDTO.getValue("SuccessorLag"+(i+1)))*8;
					
					addrs.setPredecessorActivityObjectId(new Integer(activityObjectId));
					addrs.setSuccessorActivityObjectId(new Integer(ids[i]));
					addrs.setLag(P6TypeConvert.convertDouble("Lag",namespace,tempSuccessorLag+""));
					addrs.setType(type);
					
					addrelationshipList.add(addrs);
					
					
					HashMap<String,Integer> tempMap = new HashMap<String, Integer>();
					int relationshipCount = relationshipWSBean.addRelationship(null, addrelationshipList);
					tempMap.put("index", i+1);
					tempMap.put("value", relationshipCount);

					relationshipIds.add(tempMap);
				}
				
				
				//rs.setSuccessorActivityObjectId(new Integer(ids[i]));
				//rs.setPredecessorActivityObjectId(new Integer(activityObjectId));
				//String type=msg.getValue("type"+ids[i]);
				//rs.setType(type);
				//rs.setLag(P6TypeConvert.convertDouble("LAG",namespace,( msg.getValue("SuccessorLag"+ids[i])).toString()));
				//relationshipList.add(rs);
			}
		}
		boolean updateflag = true;
		//int relationshipCount =0;
		if(updaterelationshipList.size()>0){
			 updateflag= relationshipWSBean.updateRelationship(null,updaterelationshipList);
			msg.setValue("message", "success");

		}
	//	if(addrelationshipList.size()>0){
			
	//		 relationshipCount = relationshipWSBean.addRelationship(null, addrelationshipList);
	//	}
		
		
		//int relationshipCount = relationshipWSBean.addRelationship(null, relationshipList);
		if( relationshipIds.size()>0&&updateflag==true){
			msg.setValue("message", "success");
			msg.setValue("relationshipIds", relationshipIds);
		}
		//log.info("添加了:"+relationshipCount+"条关系");
		return msg;
	}
	
	/**
	 * 修改作业关系
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateTaskRelationShip(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	/**
	 * 删除作业关系
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTaskRelationShip(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String relationObjectId = reqDTO.getValue("relation_object_id");
		
		List<Integer> relationObjectIds = new ArrayList<Integer>();
		
		relationObjectIds.add(new Integer(relationObjectId));
		
		if(relationshipWSBean.deleteRelationship(null, relationObjectIds)){
			msg.setValue("message", "success");
		}else{
			msg.setValue("message", "fail");
		}
		return msg;
	}
	
	/**
	 * 调用P6的项目进度计算
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg scheduleP6Project(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken mcsUser = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("project_info_no");
		if(projectInfoNo == null || "".equals(projectInfoNo)){
			projectInfoNo = mcsUser.getProjectInfoNo();
		}
		String dataDate = reqDTO.getValue("data_date");
		if(dataDate != null && dataDate != ""){
			String projectObjectId = (getProjectP6ObjectId(projectInfoNo).get("objectId")).toString();
			try {
				jobWsBean.scheduleProject(null,new Integer(projectObjectId),dataDate);
				//进度计算后,将最新的作业再同步到gms一次
				synActivityP6toGMSByProjectObjectId(projectObjectId,mcsUser);
				msg.setValue("message", "success");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setValue("message", "invalidDate");
			}
		}else{
			msg.setValue("message", "fail");
			log.info("计算日期为空");
		}

		return msg;
	}
	
	
	
	
	
	/**
	 * 选择项目,导入计划模版
	 * @param projectInfoNo
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg importPlanTemplate(ISrvMsg reqDTO) throws Exception{

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken mcsUser = reqDTO.getUserToken();
	//	String projectInfoNo = reqDTO.getValue("project_info_no");
	//	if(projectInfoNo == null || "".equals(projectInfoNo)){
	//		projectInfoNo = mcsUser.getProjectInfoNo();
	//	}
		
		String templateProjectObjectId = reqDTO.getValue("template_project_objctId");
		String templateWBSObjectId = reqDTO.getValue("template_project_wbsId");
		
		
	//	Map<String,Object> projectMap = getProjectP6ObjectId(projectInfoNo);
		String sql = "select t.object_id, t.wbs_object_id,t.project_id,t.project_name,t.obs_object_id,t.obs_name  from bgp_p6_project t where t.bsflag = '0' and t.OBJECT_ID='"+templateProjectObjectId+"'";
		Map<String,Object> projectMap = jdbcDao.queryRecordBySQL(sql);

		String projectObjectId = projectMap.get("objectId").toString();
		String projectWbsObjectId = projectMap.get("wbsObjectId").toString();
		String projectId = projectMap.get("projectId").toString();
		String obsObjectId = projectMap.get("obsObjectId").toString();
		//当前项目的obsName
		String obsName = projectMap.get("obsName").toString();

		List<BaselineProject> list = baselineProjectWSBean.getBaselineProjectFromP6(null, "OriginalProjectObjectId = "+templateProjectObjectId, null);
		if(list.size()==0||list==null){
			//删除作业关系
			
			//删除作业
			
			//删除wbs
			deletePlanInfo(projectObjectId);

						
			String getMaxWBSLevel = "SELECT max(LEVEL)  maxlevel  FROM BGP_P6_PROJECT_WBS  where PROJECT_OBJECT_ID='"+templateProjectObjectId+"'  CONNECT BY PRIOR OBJECT_ID = PARENT_OBJECT_ID  START WITH PARENT_OBJECT_ID ='"+templateWBSObjectId+"'";
			//获取模板项目的所有WBS
			String getWbsTreeSql = "select CONNECT_BY_ROOT(OBJECT_ID) px,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf ,"
			+"sys_connect_by_path(CODE, '.') path,OBJECT_ID as id , code,OBJECT_ID as wbsobjectid, NAME,SEQUENCE_NUMBER as ORDER_CODE,CREATE_DATE ,PROJECT_ID,PARENT_OBJECT_ID as pwbsobjectid"
			+" from BGP_P6_PROJECT_WBS where PROJECT_OBJECT_ID='"+templateProjectObjectId+"' and BSFLAG='0' "
			+"start with PARENT_OBJECT_ID ='"+templateWBSObjectId+"'  connect by prior OBJECT_ID = PARENT_OBJECT_ID and BSFLAG='0' order by PARENT_OBJECT_ID ,SEQUENCE_NUMBER asc ";
			
			List<Map> templateWbsList = radDao.queryRecords(getWbsTreeSql);   //获取最大级别
			Map templateMaxWbsMap = radDao.queryRecordBySQL(getMaxWBSLevel);  //获取所有wbs
			


			Map<String,Integer> wbsOldtoNewId = new HashMap<String, Integer>();
			wbsOldtoNewId.put("old_"+templateWBSObjectId, Integer.parseInt(projectWbsObjectId));

			Map<String,Integer> activityOldtoNewId = new HashMap<String, Integer>();
			//添加wbs
			if(templateMaxWbsMap!=null){
				int maxlevel = Integer.parseInt((String)templateMaxWbsMap.get("maxlevel"));
				for(int j=0;j<maxlevel;j++){
					int indexlevel = j+1;
					for(int i=0;i<templateWbsList.size();i++){
						Map templateWbsObjMap = templateWbsList.get(i);
						int level = Integer.parseInt((String)templateWbsObjMap.get("level"));		
						if(indexlevel==level){
							String templateWbscode = (String)templateWbsObjMap.get("code");
							String templateWbsname = (String)templateWbsObjMap.get("name");
							String templateWbsObjectId = (String)templateWbsObjMap.get("wbsobjectid");
							String templateWbsOrderCode = (String)templateWbsObjMap.get("order_code");
							String templatePwbsPobjectId = (String)templateWbsObjMap.get("pwbsobjectid");
							
							WBS wbs = new WBS();
							wbs.setCode(templateWbscode);
							wbs.setName(templateWbsname);
							wbs.setProjectId(projectId);
							wbs.setSequenceNumber(Integer.parseInt(templateWbsOrderCode));
							wbs.setProjectObjectId(Integer.parseInt(projectObjectId));
							if(level==1){
								wbs.setParentObjectId(P6TypeConvert.convertInteger("ParentObjectId", projectWbsObjectId));
							}else{
								//去Map集合里的
								int newWbsObjectId = wbsOldtoNewId.get("old_"+templatePwbsPobjectId);
								wbs.setParentObjectId(P6TypeConvert.convertInteger("ParentObjectId", newWbsObjectId+""));
							}
							List<WBS> wbsList = new ArrayList<WBS>();
							wbsList.add(wbs);
							int newWbsObjectId = wbsWSBean.addWbs(null, wbsList);
							wbsOldtoNewId.put("old_"+templateWbsObjectId, newWbsObjectId);
							
						}
					}
				}
			} //向p6添加wbs结束
			
			//添加activity
			String getactivity = "select * from bgp_p6_activity  where bsflag = '0' and project_object_id = '"+templateProjectObjectId+"'";
			List<Map> templateActivityObjList =  radDao.queryRecords(getactivity);
			if(templateActivityObjList!=null){
				for(int x=0;x<templateActivityObjList.size();x++){
					Map templateActivityMap = templateActivityObjList.get(x);
					String templateActivityName = (String)templateActivityMap.get("name");
					String templateActivityId = (String)templateActivityMap.get("id");
					String OldtemplateActivityObjectId = (String)templateActivityMap.get("object_id");
					String templateActivityCalendarName = (String)templateActivityMap.get("calendar_name");
					String templateActivityCalendarObjectId = (String)templateActivityMap.get("calendar_object_id");
					String templateActivityPercentComplete = (String)templateActivityMap.get("percent_complete");
					String templateActivitytype = (String)templateActivityMap.get("type");
					String OldtemplateActivityWbsObjectId = (String)templateActivityMap.get("wbs_object_id");
					String templateActivityWbsName = (String)templateActivityMap.get("wbs_name");
					String templateActivityWbsCode = (String)templateActivityMap.get("wbs_code");
					
					
					Activity aty = new Activity();
					aty.setName(templateActivityName);
					aty.setId(templateActivityId);
					aty.setCalendarName(templateActivityCalendarName);
					aty.setCalendarObjectId(Integer.parseInt(templateActivityCalendarObjectId));
					//aty.setPercentComplete(value);
					if(templateActivitytype!=null&&!"".equals(templateActivitytype)){
						aty.setType(templateActivitytype);

					}
					aty.setWBSName(templateActivityWbsName);
				//	aty.setWBSCode(templateActivityWbsCode);
					
					int newWbsObjectId = wbsOldtoNewId.get("old_"+OldtemplateActivityWbsObjectId);
					aty.setWBSObjectId(P6TypeConvert.convertInteger("WBSObjectId", newWbsObjectId+""));
					
					List<Activity> activityList = new ArrayList<Activity>();
					activityList.add(aty);
					int newActivityObjectId = activityWSBean.addActivity(null, activityList);
					activityList=null;
					activityOldtoNewId.put("old_"+OldtemplateActivityObjectId, newActivityObjectId);

				}
			}
			
			//作业关系
			if(templateActivityObjList!=null){
			
				for(int n=0;n<templateActivityObjList.size();n++){
					Map templateActivityMap = templateActivityObjList.get(n);
					String templateActivityObjectId = (String)templateActivityMap.get("object_id");
					//前继
					List<Relationship> PredecessorRelationShipList = relationshipWSBean.getRelationshipFromP6(null, "SuccessorActivityObjectId = "+new Integer(templateActivityObjectId), null);
					List<Map<String ,Object>> PredecessorRelationInfoList = new ArrayList<Map<String ,Object>>();
						for(int k=0;k<PredecessorRelationShipList.size();k++){
							Map<String ,Object> relationMap = new HashMap<String, Object>();
							
							Relationship relationship = PredecessorRelationShipList.get(k);			 
							Relationship addPred = new Relationship();
							addPred.setLag(relationship.getLag());
							addPred.setType(relationship.getType());
							int oldPerd = relationship.getPredecessorActivityObjectId();
							int newperd = activityOldtoNewId.get("old_"+oldPerd);
							addPred.setPredecessorActivityObjectId(newperd);
							
							//int oldsucc = relationship.getSuccessorActivityObjectId();
							int newsucc = activityOldtoNewId.get("old_"+templateActivityObjectId);
							addPred.setSuccessorActivityObjectId(newsucc);
							
							List<Relationship> addrelationshipList = new ArrayList<Relationship>();
							addrelationshipList.add(addPred);
							int relationshipCount = relationshipWSBean.addRelationship(null, addrelationshipList);

		
						}
						/*
				//后继
				List<Relationship> SuccessorRelationShipList = relationshipWSBean.getRelationshipFromP6(null, "PredecessorActivityObjectId = "+new Integer(templateActivityObjectId), null);
				List<Map<String ,Object>> SuccessorRelationInfoList = new ArrayList<Map<String ,Object>>();
					for(int p=0;p<SuccessorRelationShipList.size();p++){
						Map<String ,Object> relationMap = new HashMap<String, Object>();
						Relationship relationship = SuccessorRelationShipList.get(p);
						
						Relationship addsucc = new Relationship();
	
						int newpred = activityOldtoNewId.get("old_"+templateActivityObjectId);
						addsucc.setPredecessorActivityObjectId(newpred);
						
						int oldsucc = relationship.getSuccessorActivityObjectId();
						int newperd = activityOldtoNewId.get("old_"+oldsucc);
						addsucc.setSuccessorActivityObjectId(newperd);
						
						addsucc.setLag(relationship.getLag());
						addsucc.setType(relationship.getType());
						
						
						List<Relationship> addrelationshipList = new ArrayList<Relationship>();
						addrelationshipList.add(addsucc);
						int relationshipCount = relationshipWSBean.addRelationship(null, addrelationshipList);
					}	
					*/
				}
				//添加作业关系
				//int relationshipCount = relationshipWSBean.addRelationship(null, addrelationshipList);

			}
			SynUtils synUtils = new SynUtils();
			synUtils.synWbsP6toGMS("ProjectObjectId="+projectObjectId);
			synUtils.synActivityP6toGMS("ProjectObjectId="+projectObjectId);

			msg.setValue("message", "success");
		}else{
			
			msg.setValue("message", "该项目存在目标计划，不可导入！");
		}

		
		
		return msg;
	}
	
	
	/**
	 * 获取下一个wbscode
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public synchronized ISrvMsg getNextWbsCode(ISrvMsg reqDTO) throws Exception{
		log.info("getNextWbsCode......");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken mcsUser = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("project_info_no");
		if(projectInfoNo == null || "".equals(projectInfoNo)){
			projectInfoNo = mcsUser.getProjectInfoNo();
		}
		String parentWbsObjectId = reqDTO.getValue("parent_wbs_object_id");
		
		String sql = "select max(nvl(w.code,0))+1 as wbs_object_id ,max(w.SEQUENCE_NUMBER)+1 as ordercode from bgp_p6_project_wbs w join bgp_p6_project p on w.project_object_id = p.object_id "+ 
					 "and p.bsflag = '0' join gp_task_project gp on p.project_info_no = gp.project_info_no and gp.bsflag = '0' where w.bsflag = '0' "+
					 "and gp.project_info_no = '"+projectInfoNo+"' and w.parent_object_id = '"+parentWbsObjectId+"'";
		Map<String,Object> wbsMap = jdbcDao.queryRecordBySQL(sql);
		if(wbsMap != null){
			String wbsObjectId = wbsMap.get("wbsObjectId").toString();
			String ordercode = wbsMap.get("ordercode").toString();

			
			if(wbsObjectId != null && !"".equals(wbsObjectId)){
				msg.setValue("wbsObjectId", wbsObjectId);
				msg.setValue("ordercode", ordercode);

				
			}else{
				msg.setValue("wbsObjectId", "1");
				msg.setValue("ordercode", "0");

			}
		}
		return msg;
	}
	
	/**
	 * 获取下一个作业编号,递增单位为10
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public synchronized ISrvMsg getNextActivityCode(ISrvMsg reqDTO) throws Exception{
		log.info("getNextActivityCode......");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken mcsUser = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("project_info_no");
		if(projectInfoNo == null || "".equals(projectInfoNo)){
			projectInfoNo = mcsUser.getProjectInfoNo();
		}
		
		String sql = "select max(nvl(substr(a.id,2),0))+10 as next_task_id,substr(max(a.id),1,1) as id_prefix "+
					 "from bgp_p6_activity a join bgp_p6_project p on a.project_object_id = p.object_id and p.bsflag = '0' "+
					 "join gp_task_project gp on p.project_info_no = gp.project_info_no and gp.bsflag = '0' "+
					 "where a.bsflag = '0' and gp.project_info_no = '"+projectInfoNo+"'";
		Map<String,Object> wbsMap = jdbcDao.queryRecordBySQL(sql);
		if(wbsMap != null){
			String nextTaskId = wbsMap.get("nextTaskId").toString();
			String taskPrefix = wbsMap.get("idPrefix").toString(); 
			if(nextTaskId != null && !"".equals(nextTaskId)){
				if(taskPrefix != null && !"".equals(taskPrefix)){
					msg.setValue("nextTaskId", taskPrefix+nextTaskId);
				}else{
					msg.setValue("nextTaskId", "A"+nextTaskId);
				}
				
			}else{
				msg.setValue("nextTaskId", "A1000");
			}
		}
		return msg;
	}
	
	/**
	 * 获取上一次进度计算的日期
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDataDate(ISrvMsg reqDTO) throws Exception{
		log.info("getDataDate......");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("project_info_no");
		Map<String,Object> map = getProjectP6ObjectId(projectInfoNo);
		if(map != null){
			String projectObjectId = (String) map.get("objectId");
			String filter = "ObjectId = "+projectObjectId;
			List<com.primavera.ws.p6.project.Project> projectList = projectWSBean.getProjectFromP6(null,filter, null);
			if(projectList != null & projectList.size() > 0){
				com.primavera.ws.p6.project.Project p = projectList.get(0);
				if(p != null){
					String dataDate = P6TypeConvert.convert(projectList.get(0).getDataDate(), "yyyy-MM-dd");
					if(dataDate != null && dataDate != ""){
						msg.setValue("message", "success");
						msg.setValue("dataDate", dataDate);
					}else{
						msg.setValue("message", "nodatadate");
					}
				}
			}else{
				msg.setValue("message", "noproject");
			}
		}
		return msg;
	}
	
	/**
	 * 获取模板列表
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanTemplateList(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		String projectInfoNo = reqDTO.getValue("project_info_no");
		String projectName = reqDTO.getValue("project_name");
		if(projectInfoNo == null || "".equals(projectInfoNo)){
			projectInfoNo = user.getProjectInfoNo();
		}
		String orgSubjectionId = user.getOrgSubjectionId();
		
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
		
//		String sql = "select p.create_date, p.project_name, p.project_id, p.object_id, p.wbs_object_id, "+
//					 "'' as org_name, '' as project_year, '' org_subjection_id, '' as project_info_no "+
//					 "from bgp_p6_project p where p.bsflag = '0' and p.obs_name = '项目模板'"+
//					 "union "+
//		 			 "select p.create_date,p.project_name,p.project_id,p.object_id,p.wbs_object_id,oi1.org_abbreviation as org_name,gp.project_year,d.org_subjection_id,'"+projectInfoNo+"' as project_info_no "+
//					 "from bgp_p6_project p join gp_task_project_dynamic d on p.project_info_no =d.project_info_no and d.bsflag = '0' "+
//					 "join gp_task_project gp on p.project_info_no = gp.project_info_no and gp.bsflag = '0' "+
//					 "join comm_org_information oi1 on oi1.org_id = d.org_id and oi1.bsflag = '0' "+
//					 "join (select count(w.object_id) as wbs_count,p.project_info_no from bgp_p6_project_wbs w join bgp_p6_project p on "+
//					 "w.project_object_id = p.object_id and p.bsflag = '0' join gp_task_project gp "+
//					 "on gp.project_info_no = p.project_info_no and gp.bsflag = '0' where w.bsflag = '0' " +
//					 "group by p.project_info_no) temp1 on p.project_info_no = temp1.project_info_no "+
//					 "join (select count(w.object_id) as wbs_count,p.project_info_no from bgp_p6_activity w " +
//					 "join bgp_p6_project p on w.project_object_id = p.object_id and p.bsflag = '0' join gp_task_project gp "+
//					 "on gp.project_info_no = p.project_info_no and gp.bsflag = '0' where w.bsflag = '0' group by p.project_info_no) " +
//					 "temp2 on p.project_info_no = temp2.project_info_no "+
//					 "where p.bsflag = '0' and p.project_info_no <> '"+projectInfoNo+"' and d.org_subjection_id like '"+orgSubjectionId+"%' ";
		
		String sql = "select p.create_date, p.project_name, p.project_id, p.object_id, p.wbs_object_id, "+
		 "'' as org_name, '' as project_year, '' org_subjection_id, '' as project_info_no "+
		 "from bgp_p6_project p where p.bsflag = '0' and p.obs_name = '项目模板'";
		
		if(projectName != null && projectName != ""){
			sql += " and p.project_name like '%"+projectName+"%'";
		}
		sql += "order by create_date desc";
//		String sql = "select p.project_name,p.project_id,p.object_id,p.wbs_object_id, d.org_subjection_id,p.project_info_no "+
//					 "from bgp_p6_project p join gp_task_project_dynamic d on p.project_info_no = "+
//			         "d.project_info_no and d.bsflag = '0' where p.bsflag = '0' and d.org_subjection_id like '"+orgSubjectionId+"%'";

		page = pureJdbcDao.queryRecordsBySQL(sql, page);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		return msg;
	}	
	
	/**
	 * 通过项目编号获取对应的P6编号
	 * @param projectInfoNo
	 * @return
	 */
	private static Map<String,Object> getProjectP6ObjectId(String projectInfoNo){
		String sql = "select t.object_id, t.wbs_object_id,t.project_id,t.project_name,t.obs_object_id,t.obs_name" +
					 " from bgp_p6_project t where t.bsflag = '0' " +
					 " and t.project_object_id is null and t.project_info_no is " +
					 " not null and t.project_info_no = '"+projectInfoNo+"'";
		Map<String,Object> objectIdMap = jdbcDao.queryRecordBySQL(sql);
		return objectIdMap;
	}
	
	/**
	 * 获取某个wbs下面包含的wbs
	 * @param projectInfoNo
	 * @return
	 */
	private static List<Map> getSubWbs(String wbsOjbectId,String projectObjectId){
		String sql = "select w.object_id,w.name,w.code,w.parent_object_id,w1.name as parent_wbs_name,w.sequence_number as seqnumber from bgp_p6_project_wbs w left join bgp_p6_project_wbs w1 on w.parent_object_id = w1.object_id and w1.bsflag = '0' " +
				     " where w.bsflag = '0' and w.project_object_id = '"+projectObjectId+"' start with w.parent_object_id = '"+wbsOjbectId+"' connect by prior w.object_id = w.parent_object_id order by w.sequence_number asc";
		List<Map> wbsInfoList = jdbcDao.queryRecords(sql);
		return wbsInfoList;
	}
	
	/**
	 * 获取wbsObjectId
	 * @return
	 */
	private static String getWbsObjectIdByName(String projectObjectId,String wbsName){
		String sql = "select w.object_id as wbs_object_id from bgp_p6_project_wbs w where w.bsflag = '0' and w.project_object_id = '"+projectObjectId+"' and w.name = '"+wbsName+"'";
		Map wbsMap = jdbcDao.queryRecordBySQL(sql);
		if(wbsMap != null){
			return wbsMap.get("wbsObjectId").toString();
		}else{
			return null;
		}
	}
	
	/**
	 * 通过wbs名称查询wbs下的作业
	 * @return
	 */
	public static List<Map> getActivityInWbs(int templateProjectOjbectId,String templateWbsName){
		String sql = "select a.object_id from bgp_p6_activity a where a.bsflag = '0' and a.project_object_id = '"+templateProjectOjbectId+"' and a.wbs_name = '"+templateWbsName+"'";
		List<Map> activityList = jdbcDao.queryRecords(sql);
		return activityList;
	}
	
	/**
	 * 通过wbs主键查询wbs下的作业
	 * @return
	 */
	public static List<Map> getActivityInWbsByObjectId(int templateProjectOjbectId,int templateWbsObjectId){
		String sql = "select a.object_id from bgp_p6_activity a where a.bsflag = '0' and a.project_object_id = '"+templateProjectOjbectId+"' and a.wbs_object_id = '"+templateWbsObjectId+"'";
		List<Map> activityList = jdbcDao.queryRecords(sql);
		return activityList;
	}
	
	/**
	 * 向GMS中写入WBS
	 * @param wbss
	 * @param user
	 * @throws Exception 
	 */
	private void insertP6WbsToMCS(final List<Map> wbsList,final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"PROJECT_ID","NAME","CODE","SEQUENCE_NUMBER","OBS_NAME","PARENT_OBJECT_ID","MODIFI_DATE",
				              "BSFLAG","CREATOR_ID","CREATE_DATE","UPDATOR_ID","PROJECT_OBJECT_ID","OBS_OBJECT_ID","OBJECT_ID","WBSHEAD"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into bgp_p6_project_wbs (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append(propertys[i]).append(",");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(") values (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					Map wbs= wbsList.get(i);
					ps.setString(1, "project_id");
					ps.setString(2, wbs.get("name").toString());
					ps.setString(3, wbs.get("code").toString());
					ps.setInt(4, Integer.parseInt((String)wbs.get("ordercode")));
					ps.setString(5, "obs_name");
					ps.setInt(6, Integer.parseInt(wbs.get("parent_object_id").toString()));

					Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					String todayString = f.format(new Date());
					if (todayString != null && !"".equals(todayString)) {
						date = new Time(f.parse(todayString).getTime());
						ps.setTime(7, date);
					} else {
						ps.setTime(7, null);
					}
					ps.setString(8, "0");
					ps.setString(9, user.getEmpId());
					if (todayString != null && !"".equals(todayString)) {
						date = new Time(f.parse(todayString).getTime());
						ps.setTime(10, date);
					} else {
						ps.setTime(10, null);
					}
					ps.setString(11, user.getEmpId());
					ps.setInt(12, Integer.parseInt(wbs.get("project_object_id").toString()));
					ps.setInt(13, 2);
					ps.setInt(14, Integer.parseInt(wbs.get("object_id").toString()));
					ps.setString(15, wbs.get("wbshead").toString());

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			@Override
			public int getBatchSize() {
				return wbsList.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 套用模版方法中向GMS中写入WBS,不需要parent_object_id
	 * @param wbss
	 * @param user
	 * @throws Exception 
	 */
	private void insertTemplateP6WbsToMCS(final List<Map> wbsList,final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"PROJECT_ID","NAME","CODE","SEQUENCE_NUMBER","OBS_NAME","MODIFI_DATE",
				              "BSFLAG","CREATOR_ID","CREATE_DATE","UPDATOR_ID","PROJECT_OBJECT_ID","OBS_OBJECT_ID","OBJECT_ID"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into bgp_p6_project_wbs (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append(propertys[i]).append(",");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(") values (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					Map wbs= wbsList.get(i);
					ps.setString(1, wbs.get("project_id").toString());
					ps.setString(2, wbs.get("name").toString());
					ps.setString(3, wbs.get("code").toString());
					ps.setInt(4, Integer.parseInt(wbs.get("sequence_number").toString()));
					ps.setString(5, wbs.get("obs_name").toString());

					Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					String todayString = f.format(new Date());
					if (todayString != null && !"".equals(todayString)) {
						date = new Time(f.parse(todayString).getTime());
						ps.setTime(6, date);
					} else {
						ps.setTime(6, null);
					}
					ps.setString(7, "0");
					ps.setString(8, user.getEmpId());
					if (todayString != null && !"".equals(todayString)) {
						date = new Time(f.parse(todayString).getTime());
						ps.setTime(9, date);
					} else {
						ps.setTime(9, null);
					}
					ps.setString(10, user.getEmpId());
					ps.setInt(11, Integer.parseInt(wbs.get("project_object_id").toString()));
					ps.setInt(12, Integer.parseInt(wbs.get("obs_object_id").toString()));
					ps.setInt(13, Integer.parseInt(wbs.get("object_id").toString()));
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			@Override
			public int getBatchSize() {
				return wbsList.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 修改GMS中的WBS
	 * @param wbss
	 * @param user
	 * @throws Exception
	 */
	private void updateP6WbsToMCS(final List<Map> wbsList,final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
//		String[] propertys = {"PROJECT_ID","NAME","CODE","SEQUENCE_NUMBER","OBS_NAME","BSFLAG",
//				              "UPDATOR_ID","OBS_OBJECT_ID","OBJECT_ID"};
		
		String[] propertys = {"NAME","CODE","UPDATOR_ID","WBSHEAD","OBJECT_ID"};
		
		StringBuffer sql = new StringBuffer();
		
		sql.append("update bgp_p6_project_wbs set MODIFI_DATE = sysdate, ");
		for (int i = 0; i < propertys.length-1; i++) {
			sql.append(propertys[i]).append("=?,");//其他值
		}
		
		sql.deleteCharAt(sql.length()-1);
		sql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					Map wbs= wbsList.get(i);
				//	ps.setString(1, wbs.get"project_id");
					ps.setString(1, wbs.get("name").toString());
					ps.setString(2, wbs.get("code").toString());
					ps.setString(3, user.getEmpId());
					ps.setString(4, wbs.get("wbshead").toString());



					//ps.setInt(4, 0);
					//ps.setString(5, "obs_name");
					//ps.setString(6, "0");
					//ps.setInt(8, 2);
					ps.setInt(5, Integer.parseInt(wbs.get("object_id").toString()));

				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return wbsList.size();
			}
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 向GMS中写入作业
	 * @param activitys
	 * @param user
	 * @throws Exception
	 */
	private void insertP6ActivityToMCS(final List<Map> activityList, final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"ACTUAL_FINISH_DATE","ACTUAL_START_DATE","ID","NAME",
				"PLANNED_FINISH_DATE","PLANNED_START_DATE","PROJECT_ID","PROJECT_NAME",
				"PROJECT_OBJECT_ID","STATUS","WBS_CODE","WBS_NAME","WBS_OBJECT_ID","SUSPEND_DATE",
				"RESUME_DATE","NOTES_TO_RESOURCES","OBJECT_ID","EXPECTED_FINISH_DATE","PLANNED_DURATION",
				"FINISH_DATE","START_DATE","MODIFI_DATE","UPDATOR_ID","REMAINING_DURATION","BSFLAG","CALENDAR_NAME",
				"CALENDAR_OBJECT_ID","SUBMIT_FLAG","CREATOR_ID","CREATE_DATE","PERCENT_COMPLETE","type","activityhead"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into bgp_p6_activity (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append(propertys[i]).append(",");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(") values (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					Map activityMap = activityList.get(i);
					ps.setTime(1, null);
					ps.setTime(2, null);
					
					ps.setString(3, activityMap.get("id").toString());
					ps.setString(4, activityMap.get("name").toString());

					Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
					String todayString = f.format(new Date());
					
					String dateString = activityMap.get("planned_finish_date").toString();
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(5, date);
					} else {
						ps.setTime(5, null);
					}
					
					dateString = activityMap.get("planned_start_date").toString();
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(6, date);
					} else {
						ps.setTime(6, null);
					}
					
					ps.setString(7, activityMap.get("project_id")!= null?activityMap.get("project_id").toString():"");
					ps.setString(8, activityMap.get("project_name")!= null?activityMap.get("project_name").toString():"");
					ps.setInt(9, Integer.parseInt(activityMap.get("project_object_id").toString()));
					//ps.setString(10, activityMap.get("status")!=null?activityMap.get("status").toString():"");
					ps.setString(10,"Not Started");
					ps.setString(11, activityMap.get("wbs_code")!=null?activityMap.get("wbs_code").toString():"");
					ps.setString(12, activityMap.get("wbs_name")!=null?activityMap.get("wbs_name").toString():"");
					ps.setInt(13, Integer.parseInt(activityMap.get("wbs_object_id").toString()));
					
					dateString = activityMap.get("suspend_date")!= null?activityMap.get("suspend_date").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(14, date);
					} else {
						ps.setTime(14, null);
					}
					
					dateString = activityMap.get("resume_date")!= null?activityMap.get("resume_date").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(15, date);
					} else {
						ps.setTime(15, null);
					}
					//NOTES_TO_RESOURCES
					ps.setString(16,activityMap.get("notes_to_resources") != null ? activityMap.get("notes_to_resources").toString():"");
					ps.setInt(17, Integer.parseInt(activityMap.get("object_id").toString()));

					dateString = activityMap.get("EXPECTED_FINISH_DATE")!= null?activityMap.get("EXPECTED_FINISH_DATE").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(18, date);
					} else {
						ps.setTime(18, null);
					}
					
					ps.setDouble(19, Double.parseDouble(activityMap.get("PLANNED_DURATION")!=null?activityMap.get("PLANNED_DURATION").toString():"0"));

					dateString = activityMap.get("FINISH_DATE")!= null?activityMap.get("FINISH_DATE").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(20, date);
					} else {
						ps.setTime(20, null);
					}
					
					dateString = activityMap.get("START_DATE")!= null?activityMap.get("START_DATE").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(21, date);
					} else {
						ps.setTime(21, null);
					}
					
					if (todayString != null && !"".equals(todayString)) {
						date = new Time(f.parse(todayString).getTime());
						ps.setTime(22, date);
					} else {
						ps.setTime(22, null);
					}
					
					ps.setString(23, user.getEmpId());
					ps.setDouble(24, Double.parseDouble(activityMap.get("REMAINING_DURATION")!=null?activityMap.get("REMAINING_DURATION").toString():"0"));
					ps.setString(25, "0");
					
					//ps.setString(26, activityMap.get("CALENDAR_NAME").toString());
					//ps.setInt(27, activityMap.get("CALENDAR_OBJECT_ID").toString());
					
					ps.setString(26, "标准7天工作制");
					ps.setInt(27, 638);

					ps.setString(28, "5");

					ps.setString(29, user.getEmpId());
					
					if (todayString != null && !"".equals(todayString)) {
						date = new Time(f.parse(todayString).getTime());
						ps.setTime(30, date);
					} else {
						ps.setTime(30, null);
					}
					
					ps.setDouble(31, Double.parseDouble(activityMap.get("PERCENT_COMPLETE")!=null?activityMap.get("PERCENT_COMPLETE").toString():"0"));
					ps.setString(32, activityMap.get("type").toString());
					ps.setString(33, activityMap.get("activityhead").toString());

					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return activityList.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 更细GMS中的作业
	 * @param activitys
	 * @param user
	 * @throws Exception
	 */
	private void updateP6ActivityToMCS(final List<Map> activityList, final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"ACTUAL_FINISH_DATE","ACTUAL_START_DATE","ID","NAME",
				"PLANNED_FINISH_DATE","PLANNED_START_DATE","SUSPEND_DATE",
				"RESUME_DATE","NOTES_TO_RESOURCES","EXPECTED_FINISH_DATE","PLANNED_DURATION",
				"FINISH_DATE","START_DATE","UPDATOR_ID","REMAINING_DURATION","BSFLAG"
				,"SUBMIT_FLAG","PERCENT_COMPLETE","type","activityhead","PRIMARY_CONSTRAINT_TYPE","PRIMARY_CONSTRAINT_DATE",
				"SECONDARY_CONSTRAINT_TYPE","SECONDARY_CONSTRAINT_DATE","OBJECT_ID"};
		


		
		StringBuffer sql = new StringBuffer();
		sql.append("update bgp_p6_activity set MODIFI_DATE = sysdate, ");
		for (int i = 0; i < propertys.length-1; i++) {
				sql.append(propertys[i]).append("=?,");//其他值
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					Map activityMap = activityList.get(i);
					ps.setTime(1, null);
					ps.setTime(2, null);
					
					ps.setString(3, activityMap.get("id").toString());
					ps.setString(4, activityMap.get("name").toString());

					Time date = null;
					SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
					
					String dateString = activityMap.get("planned_finish_date") != null ? activityMap.get("planned_finish_date").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(5, date);
					} else {
						ps.setTime(5, null);
					}
					
					dateString = activityMap.get("planned_start_date") != null ? activityMap.get("planned_start_date").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(6, date);
					} else {
						ps.setTime(6, null);
					}
					
					//ps.setString(7, activityMap.get("status") != null ? activityMap.get("status").toString():"");
					//ps.setString(7, "Not Started");
					dateString = activityMap.get("suspend_date") != null ? activityMap.get("suspend_date").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(7, date);
					} else {
						ps.setTime(7, null);
					}
					
					dateString = activityMap.get("resume_date") != null ? activityMap.get("resume_date").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(8, date);
					} else {
						ps.setTime(8, null);
					}
					//NOTES_TO_RESOURCES
					ps.setString(9,activityMap.get("notes_to_resources")!=null?activityMap.get("notes_to_resources").toString():"");

					dateString = activityMap.get("EXPECTED_FINISH_DATE") != null ? activityMap.get("EXPECTED_FINISH_DATE").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(10, date);
					} else {
						ps.setTime(10, null);
					}
					
					ps.setDouble(11, Double.parseDouble(activityMap.get("PLANNED_DURATION")!=null?activityMap.get("PLANNED_DURATION").toString():"0"));

					dateString = activityMap.get("FINISH_DATE") != null ? activityMap.get("FINISH_DATE").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(12, date);
					} else {
						ps.setTime(12, null);
					}
					
					dateString = activityMap.get("START_DATE") != null ? activityMap.get("START_DATE").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(13, date);
					} else {
						ps.setTime(13, null);
					}
					
					ps.setString(14, user.getEmpId());
					ps.setDouble(15, Double.parseDouble(activityMap.get("REMAINING_DURATION") != null ? activityMap.get("REMAINING_DURATION").toString():"0"));
					ps.setString(16, "0");

					ps.setString(17, "5");
					
					ps.setDouble(18, Double.parseDouble(activityMap.get("PERCENT_COMPLETE")!=null?activityMap.get("PERCENT_COMPLETE").toString():"0"));
					ps.setString(19, activityMap.get("type").toString());
					ps.setString(20, activityMap.get("activityhead").toString());
					
					ps.setString(21, activityMap.get("Primary_Constraint_Type").toString());
					dateString = activityMap.get("Primary_Constraint_Date") != null ? activityMap.get("Primary_Constraint_Date").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(22, date);
					} else {
						ps.setTime(22, null);
					}
					
					ps.setString(23, activityMap.get("Secondary_Constraint_Type").toString());
					dateString = activityMap.get("Secondary_Constraint_Date") != null ? activityMap.get("Secondary_Constraint_Date").toString():"";
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(sdf.parse(dateString).getTime());
						ps.setTime(24, date);
					} else {
						ps.setTime(24, null);
					}
					
					
					ps.setInt(25, Integer.parseInt(activityMap.get("object_id").toString()));

					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return activityList.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 从GMS中删除WBS
	 * @param objectId
	 * @return
	 */
	private boolean deleteWBSFromGMS(String objectId){
		String sql = "delete from bgp_p6_project_wbs a where a.object_id = "+objectId;
		return radDao.executeUpdate(sql) > 0 ? true : false;
	}
	
	/**
	 * 从GMS中删除作业
	 * @param objectId
	 * @return
	 */
	private boolean deleteActivityFromGMS(String objectId){
		String sql = "delete from bgp_p6_activity w where w.object_id in ("+objectId+")";
		return radDao.executeUpdate(sql) > 0 ? true : false;
	}
	
	/**
	 * 从GMS中删除一条作业
	 * @param objectId
	 * @return
	 */
	private boolean deleteOneActivityFromGMS(String objectId){
		String sql = "delete from bgp_p6_activity w where w.object_id = "+objectId;
		return radDao.executeUpdate(sql) > 0 ? true : false;
	}
	
	/**
	 * 删除wbs下作业
	 * @param wbsObjectId
	 * @return
	 */
	private boolean deleteActivityInWbs(String wbsObjectId){
		String sql = "delete from bgp_p6_activity w where w.wbs_object_id = '"+wbsObjectId+"'";
		return radDao.executeUpdate(sql) > 0 ? true : false;
	}
	
	/**
	 * 获取某一作业的前导作业
	 * @param OjbectId
	 * @return
	 * @throws Exception
	 */
	public List<Map<String ,Object>> getPredecessorRelations(String OjbectId) throws Exception{
		
		List<Relationship> PredecessorRelationShipList = relationshipWSBean.getRelationshipFromP6(null, "SuccessorActivityObjectId = "+new Integer(OjbectId), null);
		List<Map<String ,Object>> PredecessorRelationInfoList = new ArrayList<Map<String ,Object>>();
		String PredecessorRelationType = "";
		
		String getActivityAll="select OBJECT_ID,WBS_NAME from BGP_P6_ACTIVITY where BSFLAG='0'";
		List<Map> activityLists = jdbcDao.queryRecords(getActivityAll);
		for(int i=0;i<PredecessorRelationShipList.size();i++){
			Map<String ,Object> relationMap = new HashMap<String, Object>();
			Relationship relationship = PredecessorRelationShipList.get(i);
			
			String type = relationship.getType();
			PredecessorRelationType=type;

			//前导
			String predecessorActivityWBSName="";
			String predecessorActivityId = relationship.getPredecessorActivityId();			
			String predecessorProjectId = relationship.getPredecessorProjectId();
			Integer predecessorActivityObjectId = relationship.getPredecessorActivityObjectId();
			if(activityLists!=null){
				for(int j=0;j<activityLists.size();j++){
					Map activityMap = activityLists.get(j);
					String objectIdTemp = (String)activityMap.get("objectId");
					if(objectIdTemp.equals(predecessorActivityObjectId+"")){
						predecessorActivityWBSName = (String)activityMap.get("wbsName");
						continue;
					}
				}
			}
			String predecessorActivityName = relationship.getPredecessorActivityName();
			String predecessorActivityType = relationship.getPredecessorActivityType();
			Integer predecessorProjectObjectId =relationship.getPredecessorProjectObjectId().getValue();
			Double tempPredecessororLag = relationship.getLag() != null?relationship.getLag().getValue():0.00;
			String s = String.valueOf(tempPredecessororLag);
			String PredecessororLag = s.substring(0,s.indexOf("."));
			
			Integer relationObjectId = relationship.getObjectId();

			//获取项目名称和编号
//			String project_id = "";
//			String project_name = "";
//			String getProjInfoSql = "select t.project_id,t.project_name from bgp_p6_project t where t.bsflag = '0' and t.object_id = "+predecessorProjectObjectId;
//			Map projectMap = jdbcDao.queryRecordBySQL(getProjInfoSql);
//			if(projectMap != null){
//				project_id = projectMap.get("projectId").toString();
//				project_name = projectMap.get("projectName").toString();
//			}
			relationMap.put("PredecessorRelationType", PredecessorRelationType);
//			relationMap.put("project_id", project_id);
//			relationMap.put("project_name", project_name);
			relationMap.put("predecessorActivityId", predecessorActivityId);
			relationMap.put("predecessorActivityObjectId", predecessorActivityObjectId);
			relationMap.put("predecessorActivityName", predecessorActivityName);
			relationMap.put("predecessorActivityType", predecessorActivityType);
			relationMap.put("predecessorProjectObjectId", predecessorProjectObjectId);
			relationMap.put("relationObjectId", relationObjectId);
			relationMap.put("predecessorProjectId", predecessorProjectId);
			
			relationMap.put("predecessorActivityWBSName", predecessorActivityWBSName);
			

			relationMap.put("PredecessororLag", Integer.parseInt(PredecessororLag)/8); //默认每天8小时工作

			
			PredecessorRelationInfoList.add(relationMap);
		}
		return PredecessorRelationInfoList;
	}
	
	/**
	 * 获取某一作业的后继作业
	 * @param OjbectId
	 * @return
	 * @throws Exception
	 */
	public List<Map<String ,Object>> getSuccessorRelations(String OjbectId) throws Exception{
		List<Relationship> SuccessorRelationShipList = relationshipWSBean.getRelationshipFromP6(null, "PredecessorActivityObjectId = "+new Integer(OjbectId), null);
		List<Map<String ,Object>> SuccessorRelationInfoList = new ArrayList<Map<String ,Object>>();
		String SuccessorRelationType = "";
		
		String getActivityAll="select OBJECT_ID,WBS_NAME from BGP_P6_ACTIVITY where BSFLAG='0'";
		List<Map> activityLists = jdbcDao.queryRecords(getActivityAll);
		for(int i=0;i<SuccessorRelationShipList.size();i++){
			Map<String ,Object> relationMap = new HashMap<String, Object>();
			Relationship relationship = SuccessorRelationShipList.get(i);
			
			String type = relationship.getType();
			SuccessorRelationType=type;

			//后继
			String successorActivityWBSName="";
			String successorActivityId = relationship.getSuccessorActivityId();
			String successorProjectId = relationship.getSuccessorProjectId();
			Integer successorActivityObjectId =relationship.getSuccessorActivityObjectId();
			if(activityLists!=null){
				for(int j=0;j<activityLists.size();j++){
					Map activityMap = activityLists.get(j);
					String objectIdTemp = (String)activityMap.get("objectId");
					if(objectIdTemp.equals(successorActivityObjectId+"")){
						successorActivityWBSName = (String)activityMap.get("wbsName");
						continue;
					}
				}
			}
			String successorActivityName = relationship.getSuccessorActivityName();
			String successorActivityType = relationship.getSuccessorActivityType();
			Integer successorProjectObjectId =relationship.getSuccessorProjectObjectId().getValue();
			Double tempSuccessorLag = relationship.getLag() != null?relationship.getLag().getValue():0.00;
			String s = String.valueOf(tempSuccessorLag);
			String SuccessorLag = s.substring(0,s.indexOf("."));
			
			Integer relationObjectId = relationship.getObjectId();
			
			//获取项目名称和编号
//			String project_id = "";
//			String project_name = "";
//			String getProjInfoSql = "select t.project_id,gp.project_name from bgp_p6_project t join gp_task_project gp on t.project_info_no = gp.project_info_no and gp.bsflag = '0' where t.bsflag = '0' and t.object_id = "+successorProjectObjectId;
//			Map projectMap = jdbcDao.queryRecordBySQL(getProjInfoSql);
//			if(projectMap != null){
//				project_id = projectMap.get("projectId").toString();
//				project_name = projectMap.get("projectName").toString();
//			}
			relationMap.put("SuccessorRelationType", SuccessorRelationType);
//			relationMap.put("project_id", project_id);
//			relationMap.put("project_name", project_name);
			relationMap.put("successorActivityId", successorActivityId);
			relationMap.put("successorActivityObjectId", successorActivityObjectId);
			relationMap.put("successorActivityName", successorActivityName);
			relationMap.put("successorActivityType", successorActivityType);
			relationMap.put("successorProjectObjectId", successorProjectObjectId);
			relationMap.put("relationObjectId", relationObjectId);
			relationMap.put("SuccessorLag", Integer.parseInt(SuccessorLag)/8); //默认每天8小时工作
			
			relationMap.put("successorActivityWBSName", successorActivityWBSName);

			relationMap.put("successorProjectId", successorProjectId);

			
			SuccessorRelationInfoList.add(relationMap);
		}
		return SuccessorRelationInfoList;
	}
	
	/**
	 * 通过项目Id同步项目作业
	 * @param projectObjectId
	 * @param user
	 * @throws Exception
	 */
	public void synActivityP6toGMSByProjectObjectId(String projectObjectId,UserToken user) throws Exception{
		String namespace = "http://xmlns.oracle.com/Primavera/P6/WS/Activity/V1";
		String filter = "ProjectObjectId = "+projectObjectId;
		log.info("enter synActivityP6toGMSByProjectObjectId("+filter+")...");
		p6log.info("enter synActivityP6toGMSByProjectObjectId("+filter+")...");

		ActivityWSBean activityWSBean = new ActivityWSBean();
		List<Activity> list = activityWSBean.getActivityFromP6(null, filter, "ObjectId desc");
		log.info("获得Activity的数量为:"+list.size());
		p6log.info("获得Activity的数量为:"+list.size());

		//修改P6中作业的状态和计划开始计划结束时间
		
		ActivityMCSBean activityMCSBean = new ActivityMCSBean();
		List<ActivityExtends> list2 = new ArrayList<ActivityExtends>();
		List<Activity> list3=new ArrayList<Activity>();
		for (int i = 0; i < list.size(); i++) {
			Activity aty = list.get(i);
			if("Completed".equals(aty.getStatus()) || "In Progress".equals(aty.getStatus())){
				aty.setStatus("Not Started");
				aty.setActualStartDate(null);
				aty.setActualFinishDate(null);
				aty.setPercentComplete(P6TypeConvert.convertDouble("PercentComplete",namespace,"0"));
				list3.add(aty);
			}
			ActivityExtends a = new ActivityExtends(aty,"6");
			list2.add(a);
		}
		activityWSBean.updateActivityToP6(null, list3);
		activityMCSBean.saveOrUpdateP6ActivityToMCS(list2, user);
		log.info("exit synActivityP6toGMSByProjectObjectId("+filter+")");
		p6log.info("exit synActivityP6toGMSByProjectObjectId("+filter+")");
	}
	
	/**
	 * 通过项目Id同步wbs
	 * @param filter
	 * @throws Exception
	 */
	public void synWbsP6toGMS(String projectObjectId,UserToken user) throws Exception{
		String filter = "ProjectObjectId = "+projectObjectId;
		WbsWSBean wbsWS=new WbsWSBean();
		List<WBS> list=wbsWS.getWbsFromP6(null, filter, "ObjectId desc");
		log.info("获得WBS的数量为:"+list.size());
		WbsMCSBean wbsMCS = new WbsMCSBean();
		wbsMCS.saveOrUpdateP6WbsToMCS(list, user);
    	log.info("exit synWbsP6toGMS()");
	}
	
	/**
	 * 删除项目的wbs和作业信息
	 * @param projectObjectId
	 * @return
	 * @throws Exception
	 */
	public boolean deletePlanInfo(String projectObjectId) throws Exception{
		boolean flag = true;
		String deleteWbsSql = "delete from bgp_p6_project_wbs w where w.project_object_id = '"+projectObjectId+"'";
		radDao.executeUpdate(deleteWbsSql);
		String deleteActivitySql = "delete from bgp_p6_activity a where a.project_object_id = '"+projectObjectId+"'";
		radDao.executeUpdate(deleteActivitySql);
		
		List<Integer> wbsObjectIds = new ArrayList<Integer>();
		List<WBS> wbsList = wbsWSBean.getWbsFromP6(null, "ProjectObjectId="+projectObjectId, null);
		if(wbsList!=null && wbsList.size()>0){
			for(int i=0;i<wbsList.size();i++){
				WBS w = wbsList.get(i);
				wbsObjectIds.add(w.getObjectId());
			}
		}
		
		if(wbsWSBean.deleteWbs(null, wbsObjectIds)){
			List<Integer> activityObjectIds = new ArrayList<Integer>();
			List<Activity> activityList = activityWSBean.getActivityFromP6(null, "ProjectObjectId="+projectObjectId, null);
			if(activityList != null && activityList.size() > 0){
				for(int k=0;k<activityList.size();k++){
					Activity aty = activityList.get(k);
					activityObjectIds.add(aty.getObjectId());
				}
			}
			if(!activityWSBean.deleteActivity(null, activityObjectIds)){
				flag = false;
				p6log.info("从p6删除作业失败");
				log.info("从p6删除作业失败");
			}
		}else{
			flag = false;
			p6log.info("从p6删除wbs失败");
			log.info("从p6删除wbs失败");
		}
		return flag;
	}
	
	/**
	 * 检查项目是否已经存在项目
	 * @param projectObjectId
	 * @return
	 */
	public boolean checkPlanExist(String projectObjectId){
		String getWbsObjectIdsSql = "select w.object_id from bgp_p6_project_wbs w where w.bsflag = '0' and w.project_object_id = '"+projectObjectId+"'";
		List<Map> wbsObjectMaps = jdbcDao.queryRecords(getWbsObjectIdsSql);
		if(wbsObjectMaps != null && wbsObjectMaps.size() >0){
			String getActivityObjectIdsSql = "select w.object_id from bgp_p6_activity w where w.bsflag = '0' and w.project_object_id = '"+projectObjectId+"'";
			List<Map> activityObjectMaps = jdbcDao.queryRecords(getActivityObjectIdsSql);
			if(activityObjectMaps != null && activityObjectMaps.size() >0){
				return true;
			}else{
				p6log.info("checkPlanExist：不存在activity");
				log.info("checkPlanExist：不存在activity");

				return false;
			}
		}else{
			log.info("checkPlanExist：不存在wbs");
			p6log.info("checkPlanExist：不存在activity");

			return false;
		}
	}


}