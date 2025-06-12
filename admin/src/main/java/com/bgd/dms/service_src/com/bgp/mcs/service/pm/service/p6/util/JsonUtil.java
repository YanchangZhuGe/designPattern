package com.bgp.mcs.service.pm.service.p6.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityWSBean;
import com.bgp.mcs.service.pm.service.p6.activity.relationship.RelationshipWSBean;
import com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean;
import com.bgp.mcs.service.pm.service.p6.wbs.WbsWSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.primavera.ws.p6.activity.Activity;
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
 * 作者：李俊强，2012 5 18
 * 
 * 描述：用于操作TaskJson对象
 * 
 * 说明:
 */

public class JsonUtil {
	
	private RADJdbcDao radDao;
	
	public static final java.text.SimpleDateFormat sdf = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");
	public static final java.text.SimpleDateFormat sdfd = new SimpleDateFormat(
			"yyyy-MM-dd");
	public static final SimpleDateFormat format = new SimpleDateFormat(
			"MM/dd/yyyy HH:mm");
	public static final SimpleDateFormat sdfjs = new SimpleDateFormat(
			"MM/dd/yyyy");
	
	public JsonUtil() {
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	}
	
	/**
	 * 根据传入的wbsObjectId 得到下属wbs以及任务
	 * @return
	 * @throws Exception 
	 */
	public List<Task> getObjectList(Integer wbsObjectId) throws Exception{
		
		ActivityWSBean activityWSBean = new ActivityWSBean();
		
		WbsWSBean wbsWSBean = new WbsWSBean();
		
		List<WBS> wbss = wbsWSBean.getWbsFromP6(null, "ParentObjectId='"+wbsObjectId+"'", null); 
		
		List<Activity> activitys = activityWSBean.getActivityFromP6(null, "WBSObjectId='"+wbsObjectId+"'", null);
		//List<Activity> activitys1 = activityWSBean.getActivityFromP6(null, "WBSObjectId='"+wbsObjectId+"'", "EndDate");
		
		if ((wbss == null || wbss.size() == 0) && (activitys == null || activitys.size() == 0)) {
			return null;
		}
		List<Task> list = new ArrayList<Task>();
		Task task = null;
		WBS wbs = null;
		Activity a = null;
		for (int i = 0; i < wbss.size(); i++) {
			task = new Task();
			wbs = wbss.get(i);
			task.setId(wbs.getObjectId());
			task.setTaskId(wbs.getCode());
			
			//汇总某个wbs下的任务时间
			List<Activity> activitys1 = activityWSBean.getActivityFromP6(null, "WBSObjectId='"+wbs.getObjectId()+"'", null);
			
			Date startDate = null;
			Date endDate = null;
			
//			Date baesStartDate = null;
//			Date baseEndDate = null;
			if (activitys1 != null && activitys1.size() != 0) {
				a = activitys1.get(0);
				startDate = P6TypeConvert.convert(a.getStartDate());
				endDate = P6TypeConvert.convert(a.getFinishDate());
//				baesStartDate = P6TypeConvert.convert(a.getBaselineStartDate());
//				baseEndDate = P6TypeConvert.convert(a.getBaselineStartDate());
			}
			
			Date temp = null;
			for (int j = 0; j < activitys1.size(); j++) {
				a = activitys1.get(j);
				temp = P6TypeConvert.convert(a.getStartDate());
				if (startDate.after(temp)) {
					startDate = temp;
					endDate = temp;
				}
				
				temp = P6TypeConvert.convert(a.getFinishDate());
				if (endDate.before(temp)) {
					endDate = temp;
				}
				
//				temp = P6TypeConvert.convert(a.getBaselineStartDate());
//				if (baesStartDate.after(temp)) {
//					baesStartDate = temp;
//					baseEndDate = temp;
//				}
//				
//				temp = P6TypeConvert.convert(a.getBaselineFinishDate());
//				if (baseEndDate.before(temp)) {
//					baseEndDate = temp;
//				}
			}
			
			try {
				task.setStartDate(new Timestamp(startDate.getTime()));
				task.setEndDate(new Timestamp(endDate.getTime()));
//				task.setBaselineStartDate(new Timestamp(baesStartDate.getTime()));
//				task.setBaselineEndDate(new Timestamp(baseEndDate.getTime()));
			} catch (Exception e) {
				task.setStartDate(null);
				task.setEndDate(null);
				task.setBaselineStartDate(null);
				task.setBaselineEndDate(null);
			}
			
			task.setPercentDone(0);//完成百分比
			task.setName(wbs.getName());
			task.setPriority(0);//优先级?
			task.setParentId(wbs.getParentObjectId().getValue());//上级wbsObjectId
			task.setDuration(0.0);//工期
			task.setDurationUnit("");//工期单位?
			task.setOtherField(wbs.getObjectId().toString());//备用字段
			
			task.setIsWbs("true");
			
			list.add(task);
		}
		
		
		for (int i = 0; i < activitys.size(); i++) {
			a = activitys.get(i);
			task = new Task();
			
			task.setId(Integer.valueOf(a.getObjectId().toString()+a.getProjectObjectId().toString()));//保证跟wbs主键不冲突
			task.setTaskId(a.getId());
			task.setStartDate(new Timestamp(P6TypeConvert.convert(a.getStartDate()).getTime()));
			task.setEndDate(new Timestamp(P6TypeConvert.convert(a.getFinishDate()).getTime()));
			task.setPercentDone(Double.valueOf(a.getPercentComplete().getValue()*100).intValue());//完成百分比
			task.setName(a.getName());
			task.setPriority(0);//优先级?
//			task.setBaselineStartDate(new Timestamp(P6TypeConvert.convert(a.getBaselineStartDate()).getTime()));
//			task.setBaselineEndDate(new Timestamp(P6TypeConvert.convert(a.getBaselineFinishDate()).getTime()));
			task.setParentId(a.getWBSObjectId().getValue());
			task.setDuration(a.getPlannedDuration());
			task.setDurationUnit("");
			task.setOtherField(a.getObjectId().toString());
			
			task.setIsWbs("false");
			
			list.add(task);
		}
		
		return list;
	}
	
	
	/**
	 * 递归查询子节点
	 * @param node
	 * @return
	 * @throws Exception
	 */
	public List setNodeChildren(Task node) throws Exception {

		List childrenList = null;
		List list = this.getObjectList(node.getId());
		if (list != null && list.iterator().hasNext()) {
			childrenList = new ArrayList();
			Iterator ite = list.iterator();
			while (ite.hasNext()) {
				Task task = (Task) ite.next();

				Map<String, Object> map = new HashMap<String, Object>();

				map.put("Id", task.getId());
				map.put("TaskId", task.getTaskId());
				map.put("Name", task.getName());
				try {
					map.put("StartDate", sdfd.format(task.getStartDate()));
					map.put("EndDate", sdfd.format(task.getEndDate()));
					//map.put("BaselineEndDate", sdfd.format(task.getBaselineEndDate()));
					//map.put("BaselineStartDate", sdfd.format(task.getBaselineStartDate()));
				} catch (Exception e) {
					map.put("StartDate", null);
					map.put("EndDate", null);
					//map.put("BaselineEndDate", null);
					//map.put("BaselineStartDate", null);
				}
				map.put("parentId", task.getParentId());
				map.put("PercentDone", task.getPercentDone());
				map.put("Priority", task.getPriority());
				map.put("other1", task.getOtherField());
				
				
				List ja = null;
				if (task.getIsWbs() == "true" || "true".equals(task.getIsWbs())) {
					ja = this.setNodeChildren(task);
				}
				if (ja != null && ja.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(ja);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", true);
				} else {
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
				}

				childrenList.add(map);
			}

		}

		return childrenList;
	}
	
	/**
	 * 生成任务列表
	 * @param wbsObjectId
	 * @return
	 * @throws Exception
	 */
	public String list(Integer wbsObjectId) throws Exception  {
		List list = getObjectList(wbsObjectId);

		JSONArray json = null;
		if (list != null && list.iterator().hasNext()) {
			Iterator ite = list.iterator();
			List jsList = new ArrayList();
			while (ite.hasNext()) {
				Task task = (Task) ite.next();
				Map<String, Object> map = new HashMap<String, Object>();

				map.put("Id", task.getId());
				map.put("TaskId", task.getTaskId());
				map.put("Name", task.getName());
				try {
					map.put("StartDate", sdfd.format(task.getStartDate()));
					map.put("EndDate", sdfd.format(task.getEndDate()));
					//map.put("BaselineEndDate", sdfd.format(task.getBaselineEndDate()));
					//map.put("BaselineStartDate", sdfd.format(task.getBaselineStartDate()));
				} catch (Exception e) {
					map.put("StartDate", null);
					map.put("EndDate", null);
					//map.put("BaselineEndDate", null);
					//map.put("BaselineStartDate", null);
				}
				map.put("parentId", task.getParentId());
				map.put("PercentDone", task.getPercentDone());
				map.put("Priority", task.getPriority());
				map.put("other1", task.getOtherField());


				List ja = null;
				if (task.getIsWbs() == "true" || "true".equals(task.getIsWbs())) {
					ja = this.setNodeChildren(task);
				}
				if (ja != null && ja.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(ja);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", true);
				} else {
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
				}

				jsList.add(map);

			}

			json = JSONArray.fromObject(jsList);

		}

		if (json != null) {
			//System.out.println(json);
			return json.toString();
		} else {
			return "[]";
		}

	}
	
	
	/**
	 * 生成依赖列表
	 * @param projectObjectId
	 * @return
	 * @throws Exception
	 */
	public String listDependency(Integer projectObjectId) throws Exception  {
		
		RelationshipWSBean rr = new RelationshipWSBean();
		List<Relationship> list = rr.getRelationshipFromP6(null, "PredecessorProjectObjectId = '"+projectObjectId+"'", null);
		if (list != null && list.iterator().hasNext()) {
			List<Map<String, Object>> ls = new ArrayList<Map<String, Object>>();
			for (int i = 0; i < list.size(); i++) {
				Relationship r = list.get(i);
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("Id", r.getObjectId());
				map.put("From", Integer.valueOf(r.getPredecessorActivityObjectId().toString()+r.getPredecessorProjectObjectId().getValue().toString()));
				map.put("To", Integer.valueOf(r.getSuccessorActivityObjectId().toString()+r.getSuccessorProjectObjectId().getValue().toString()));
				if ("Finish to Start".equals(r.getType())) {
					map.put("Type", 2);
				} else if ("Start to Finish".equals(r.getType())) {
					map.put("Type", 1);
				} else if ("Finish to Finish".equals(r.getType())) {
					map.put("Type", 3);
				} else if ("Start to Start".equals(r.getType())) {
					map.put("Type", 0);
				}
				
				ls.add(map);
			}
			
			JSONArray ja = JSONArray.fromObject(ls);

			return ja.toString();
		} else {
			return "[]";
		}
	}
	
	/**
	 * 生成依赖列表
	 * @param projectObjectId
	 * @return
	 * @throws Exception
	 */
	public String listDependency(List projectObjectIds) throws Exception  {
		
		RelationshipWSBean rr = new RelationshipWSBean();
		List<Map<String, Object>> ls = null;
		for (int j = 0; j < projectObjectIds.size(); j++) {
			Object projectObjectId = projectObjectIds.get(j);
			List<Relationship> list = rr.getRelationshipFromP6(null, "PredecessorProjectObjectId = '"+projectObjectId+"'", null);
			if (list != null && list.iterator().hasNext()) {
				ls = new ArrayList<Map<String, Object>>();
				for (int i = 0; i < list.size(); i++) {
					Relationship r = list.get(i);
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("Id", r.getObjectId());
					map.put("From", Integer.valueOf(r.getPredecessorActivityObjectId().toString()+r.getPredecessorProjectObjectId().getValue().toString()));
					map.put("To", Integer.valueOf(r.getSuccessorActivityObjectId().toString()+r.getSuccessorProjectObjectId().getValue().toString()));
					if ("Finish to Start".equals(r.getType())) {
						map.put("Type", 2);
					} else if ("Start to Finish".equals(r.getType())) {
						map.put("Type", 1);
					} else if ("Finish to Finish".equals(r.getType())) {
						map.put("Type", 3);
					} else if ("Start to Start".equals(r.getType())) {
						map.put("Type", 0);
					}
					
					ls.add(map);
				}
			}
		}
		
		JSONArray ja = JSONArray.fromObject(ls);

		return ja.toString();
	}
	
	/**
	 * sql版本的 暂时不用
	 * @param wbsObjectId
	 * @return
	 */
	public List<Task> getObjectListUseSql(Integer wbsObjectId){
		String sql = "select "+
				" to_number(t1.task_id||t1.proj_id) as id"+
				" ,t2.startdate as startDate"+
				" ,t2.finishdate as endDate"+
				" ,t2.baselinestartdate as baselineStartDate"+
				" ,t2.baselinefinishdate as baselineEndDate"+
				" ,t1.task_name as name"+
				" ,t1.wbs_id as parenId"+
				" ,t2.percentcomplete as percentDone"+
				" from task@p6db t1"+
				" join taskx@p6db t2"+
				" on t1.task_id = t2.task_id"+
				" where t1.wbs_id = '"+wbsObjectId+"'"+
				" union all"+
				" select "+
				" t3.wbs_id as id"+
				" ,t4.startdate as startDate"+
				" ,t4.finishdate as endDate"+
				" ,t4.sumbaselinestartdate as baselineStartDate"+
				" ,t4.sumbaselinefinishdate as baselineEndDate"+
				" ,t3.wbs_name as name"+
				" ,t3.parent_wbs_id as parenId"+
				" ,0 as percentDone"+
				" from projwbs@p6db t3"+
				" join projwbsx@p6db t4"+
				" on t3.wbs_id = t4.wbs_id"+
				" where t3.parent_wbs_id = '"+wbsObjectId+"'";
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		if (list == null || list.size() == 0) {
			return null;
		}
		List<Task> tasks = new ArrayList<Task>();
		for (int i = 0; i < list.size(); i++) {
			Task t = new Task();
			Map<String, Object> map = list.get(i);
			t.setId((Integer)map.get("ID"));
			t.setParentId((Integer)map.get("PARENID"));
			t.setName(map.get("NAME").toString());
			t.setStartDate(new Timestamp(((Date)map.get("STARTDATE")).getTime()));
			t.setEndDate(new Timestamp(((Date)map.get("ENDDATE")).getTime()));
			t.setBaselineStartDate(new Timestamp(((Date)map.get("BASELINESTARTDATE")).getTime()));
			t.setBaselineEndDate(new Timestamp(((Date)map.get("BASELINEENDDATE")).getTime()));
			t.setPercentDone((Integer)map.get("PERCENTDONE"));
			
			tasks.add(t);
		}
		return tasks;
	}

	
	/**
	 * 根据传入的wbsObjectId从list中找到该wbs下属的所有的task
	 * @param tasks
	 * @param wbsObjectId
	 * @return
	 */
	public List<Task> searchFromList(List<Task> tasks, Integer wbsObjectId){
		if (tasks != null && tasks.size() != 0) {
			List<Task> list = new ArrayList<Task>();
			for (int i = 0; i < tasks.size(); i++) {
				Task t = tasks.get(i);
				if (t.getParentId().intValue() == wbsObjectId.intValue()) {
					list.add(t);
					tasks.remove(i);
					i--;
					continue;
				}
			}
			return list;	
		} else {
			return null;
		}
	}
	
	/**
	 * 根据传入的项目的projectObjectId 得到下属的所有的wbs以及任务的列表
	 * @return
	 * @throws Exception 
	 */
	public List<Task> getObjectListAll(Integer projectObjectId) throws Exception{
		
		ActivityWSBean activityWSBean = new ActivityWSBean();
		
		WbsWSBean wbsWSBean = new WbsWSBean();
		
		List<WBS> wbss = wbsWSBean.getWbsFromP6(null, "ProjectObjectId='"+projectObjectId+"'", null); 
		
		List<Activity> activitys = activityWSBean.getActivityFromP6(null, "ProjectObjectId='"+projectObjectId+"'", null);
		//List<Activity> activitys1 = activityWSBean.getActivityFromP6(null, "WBSObjectId='"+wbsObjectId+"'", "EndDate");
		
		if ((wbss == null || wbss.size() == 0) && (activitys == null || activitys.size() == 0)) {
			return null;
		}
		List<Task> list = new ArrayList<Task>();
		Task task = null;
		WBS wbs = null;
		Activity a = null;
		for (int i = 0; i < wbss.size(); i++) {
			task = new Task();
			wbs = wbss.get(i);
			task.setId(wbs.getObjectId());
			task.setTaskId(wbs.getCode());
			
			//汇总某个wbs下的任务时间
			List<Activity> activitys1 = activityWSBean.getActivityFromP6(null, "WBSObjectId='"+wbs.getObjectId()+"'", null);
			
			Date startDate = null;
			Date endDate = null;
			
			//Date baesStartDate = null;
			//Date baseEndDate = null;
			if (activitys1 != null && activitys1.size() != 0) {
				a = activitys1.get(0);
				startDate = P6TypeConvert.convert(a.getStartDate());
				endDate = P6TypeConvert.convert(a.getFinishDate());
				//baesStartDate = P6TypeConvert.convert(a.getBaselineStartDate());
				//baseEndDate = P6TypeConvert.convert(a.getBaselineStartDate());
			}
			
			Date temp = null;
			for (int j = 0; j < activitys1.size(); j++) {
				a = activitys1.get(j);
				temp = P6TypeConvert.convert(a.getStartDate());
				if (startDate.after(temp)) {
					startDate = temp;
					endDate = temp;
				}
				
				temp = P6TypeConvert.convert(a.getFinishDate());
				if (endDate.before(temp)) {
					endDate = temp;
				}
				
//				temp = P6TypeConvert.convert(a.getBaselineStartDate());
//				if (baesStartDate.after(temp)) {
//					baesStartDate = temp;
//					baseEndDate = temp;
//				}
				
//				temp = P6TypeConvert.convert(a.getBaselineFinishDate());
//				if (baseEndDate.before(temp)) {
//					baseEndDate = temp;
//				}
			}
			
			try {
				task.setStartDate(new Timestamp(startDate.getTime()));
				task.setEndDate(new Timestamp(endDate.getTime()));
				//task.setBaselineStartDate(new Timestamp(baesStartDate.getTime()));
				//task.setBaselineEndDate(new Timestamp(baseEndDate.getTime()));
			} catch (Exception e) {
				task.setStartDate(null);
				task.setEndDate(null);
				//task.setBaselineStartDate(null);
				//task.setBaselineEndDate(null);
			}
			
			task.setPercentDone(0);//完成百分比
			task.setName(wbs.getName());
			task.setPriority(0);//是否关键路径
			task.setParentId(wbs.getParentObjectId().getValue());//上级wbsObjectId
			task.setDuration(0.0);//工期
			task.setDurationUnit("");//工期单位?
			task.setOtherField(wbs.getObjectId().toString());//备用字段
			
			task.setIsWbs("true");
			
			list.add(task);
		}
		
		
		for (int i = 0; i < activitys.size(); i++) {
			a = activitys.get(i);
			task = new Task();
			
			task.setId(Integer.valueOf(a.getObjectId().toString()+a.getProjectObjectId().toString()));//保证跟wbs主键不冲突
			task.setTaskId(a.getId());
			task.setStartDate(new Timestamp(P6TypeConvert.convert(a.getStartDate()).getTime()));
			task.setEndDate(new Timestamp(P6TypeConvert.convert(a.getFinishDate()).getTime()));
			task.setPercentDone(Double.valueOf(a.getPercentComplete().getValue()*100).intValue());//完成百分比
			task.setName(a.getName());
			task.setPriority(0);//是否关键路径
			//task.setBaselineStartDate(new Timestamp(P6TypeConvert.convert(a.getBaselineStartDate()).getTime()));
			//task.setBaselineEndDate(new Timestamp(P6TypeConvert.convert(a.getBaselineFinishDate()).getTime()));
			task.setParentId(a.getWBSObjectId().getValue());
			task.setDuration(a.getPlannedDuration());
			task.setDurationUnit("");
			task.setOtherField(a.getObjectId().toString());
			
			task.setPlannedStartDate(new Timestamp(P6TypeConvert.convert(a.getPlannedStartDate()).getTime()));
			task.setPlannedEndDate(new Timestamp(P6TypeConvert.convert(a.getPlannedFinishDate()).getTime()));
			
			task.setIsWbs("false");
			
			list.add(task);
		}
		
		return list;
	}
	
	/**
	 * 根据传入的项目的projectObjectId 得到下属的所有的wbs以及任务的列表
	 * 不计算wbs时间
	 * @return
	 * @throws Exception 
	 */
	public List<Task> getObjectListAllWithoutWbsDate(Integer projectObjectId, boolean checked) throws Exception{
		
		ActivityWSBean activityWSBean = new ActivityWSBean();
		
		WbsWSBean wbsWSBean = new WbsWSBean();
		
		ProjectWSBean projectWSBean = new ProjectWSBean();
		
		List<Project> projects = projectWSBean.getProjectFromP6(null, "ObjectId='"+projectObjectId+"'", null);
		
		List<WBS> wbss = wbsWSBean.getWbsFromP6(null, "ProjectObjectId='"+projectObjectId+"'", null); 
		
		List<Activity> activitys = activityWSBean.getActivityFromP6(null, "ProjectObjectId='"+projectObjectId+"'", null);
		//List<Activity> activitys1 = activityWSBean.getActivityFromP6(null, "WBSObjectId='"+wbsObjectId+"'", "EndDate");
		
		if ((projects == null || projects.size() == 0) || (wbss == null || wbss.size() == 0) && (activitys == null || activitys.size() == 0)) {
			return null;
		}
		List<Task> list = new ArrayList<Task>();
		Task task = null;
		Project p = null;
		WBS wbs = null;
		Activity a = null;
		
		p = projects.get(0);
		task = new Task();
		task.setId(p.getWBSObjectId().getValue());
		task.setName(p.getName());
		task.setTaskId(p.getId());
		task.setStartDate(null);
		task.setEndDate(null);
		task.setParentId(0);
		
		task.setIsWbs("true");
		task.setIsRoot("true");
		if (checked) {
			task.setChecked("false");
		}
		task.setOtherField(p.getObjectId().toString());
		
		list.add(task);
		
		for (int i = 0; i < wbss.size(); i++) {
			task = new Task();
			wbs = wbss.get(i);
			task.setId(wbs.getObjectId());
			task.setTaskId(wbs.getCode());
			task.setStartDate(null);
			task.setEndDate(null);
			
			task.setPercentDone(0);//完成百分比
			task.setName(wbs.getName());
			task.setPriority(0);//是否关键路径
			task.setParentId(wbs.getParentObjectId().getValue());//上级wbsObjectId
			task.setDuration(0.0);//工期
			task.setDurationUnit("");//工期单位?
			task.setOtherField(wbs.getObjectId().toString());//备用字段
			
			task.setIsWbs("true");
			task.setIsRoot("false");
			if (checked) {
				task.setChecked("true");
			}
			
			list.add(task);
		}
		
		
		for (int i = 0; i < activitys.size(); i++) {
			a = activitys.get(i);
			task = new Task();
			
			task.setId(Integer.valueOf(a.getObjectId().toString()+a.getProjectObjectId().toString()));//保证跟wbs主键不冲突
			task.setTaskId(a.getId());
			task.setStartDate(new Timestamp(P6TypeConvert.convert(a.getStartDate()).getTime()));
			task.setEndDate(new Timestamp(P6TypeConvert.convert(a.getFinishDate()).getTime()));
			task.setPercentDone(Double.valueOf(a.getPercentComplete().getValue()*100).intValue());//完成百分比
			task.setName(a.getName());
			task.setPriority(0);//是否关键路径
			//task.setBaselineStartDate(new Timestamp(P6TypeConvert.convert(a.getBaselineStartDate()).getTime()));
			//task.setBaselineEndDate(new Timestamp(P6TypeConvert.convert(a.getBaselineFinishDate()).getTime()));
			task.setParentId(a.getWBSObjectId().getValue());
			task.setDuration(a.getPlannedDuration());
			task.setDurationUnit("");
			task.setOtherField(a.getObjectId().toString());
			
			task.setPlannedStartDate(new Timestamp(P6TypeConvert.convert(a.getPlannedStartDate()).getTime()));
			task.setPlannedEndDate(new Timestamp(P6TypeConvert.convert(a.getPlannedFinishDate()).getTime()));
			
			task.setIsWbs("false");
			task.setIsRoot("false");
			
			if (checked) {
				task.setChecked("true");
			}
			
			list.add(task);
		}
		
		return list;
	}
	
	
	/**
	 * 生成任务列表 使用list遍历方式递归
	 * @param wbsObjectId
	 * @return
	 * @throws Exception
	 */
	public String list(Integer projectObjectId, Integer wbsObjectId) throws Exception  {
		List<Task> tasks = getObjectListAll(projectObjectId);//得到该项目下所有的任务 包含wbs以及activtiy
		//tasks = getObjectListUseSql(wbsObjectId);//使用sql查询的版本
		List<Task> list = searchFromList(tasks, wbsObjectId);
		
		JSONArray json = null;
		if (list != null && list.iterator().hasNext()) {
			Iterator<Task> ite = list.iterator();
			List<Map<String, Object>> jsList = new ArrayList<Map<String, Object>>();
			while (ite.hasNext()) {
				Task task = ite.next();
				Map<String, Object> map = new HashMap<String, Object>();

				map.put("Id", task.getId());
				map.put("TaskId", task.getTaskId());
				map.put("Name", task.getName());
				try {
					map.put("StartDate", sdfd.format(task.getStartDate()));
				} catch (Exception e) {
					map.put("StartDate", null);
				}
				try {
					map.put("EndDate", sdfd.format(task.getEndDate()));
				} catch (Exception e) {
					map.put("EndDate", null);
				}
				try {
					map.put("BaselineEndDate", sdfd.format(task.getBaselineEndDate()));
				} catch (Exception e) {
					map.put("BaselineEndDate", null);
				}
				try {
					map.put("BaselineStartDate", sdfd.format(task.getBaselineStartDate()));
				} catch (Exception e) {
					map.put("BaselineStartDate", null);
				}
				try {
					map.put("PlannedEndDate", sdfd.format(task.getPlannedEndDate()));
				} catch (Exception e) {
					map.put("PlannedEndDate", null);
				}
				try {
					map.put("PlannedStartDate", sdfd.format(task.getPlannedStartDate()));
				} catch (Exception e) {
					map.put("PlannedStartDate", null);
				}
				map.put("parentId", task.getParentId());
				map.put("PercentDone", task.getPercentDone());
				map.put("Priority", task.getPriority());
				map.put("other1", task.getOtherField());
				
				map.put("isWbs", task.getIsWbs());
				map.put("isRoot", task.getIsRoot());


				List<Map<String, Object>> ja = null;
				if (task.getIsWbs() == "true" || "true".equals(task.getIsWbs())) {
					ja = this.setNodeChildren(task, tasks);
				}
				if (ja != null && ja.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(ja);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", true);
				} else {
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
				}

				jsList.add(map);

			}

			json = JSONArray.fromObject(jsList);

		}

		if (json != null) {
			//System.out.println(json);
			return json.toString();
		} else {
			return "[]";
		}

	}
	
	/**
	 * 生成任务列表 使用list遍历方式递归
	 * @param wbsObjectId
	 * @return
	 * @throws Exception
	 */
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private String project_info_no = "";
	private List noteList = new ArrayList();
	public String listWithOutWbsDate(Integer projectObjectId, Integer wbsObjectId, boolean checked) throws Exception  {
		List<Task> tasks = getObjectListAllWithoutWbsDate(projectObjectId, checked);//得到该项目下所有的任务 包含wbs以及activtiy
		//tasks = getObjectListUseSql(wbsObjectId);//使用sql查询的版本
		List<Task> list = searchFromList(tasks, 0);
		/*夏秋雨   查找project_info_no、获得note列表    开始*/
		StringBuffer sb = new StringBuffer();
		sb.append(" select t.project_info_no from bgp_p6_project t")
		.append(" where t.object_id='").append(projectObjectId).append("'")
		.append(" and t.bsflag ='0'");
		Map projectMap = jdbcDao.queryRecordBySQL(sb.toString());
		if(projectMap!=null){
			this.project_info_no = (String)projectMap.get("project_info_no");
			this.project_info_no = "8ad8b31b2d4f8e97012d4f9146d10002";      //暂时
		}
		sb = new StringBuffer();
		sb.append(" select t.notes ,t.object_id from bgp_qua_plan t ")
		.append(" where  t.project_info_no='").append(this.project_info_no).append("'");
		noteList = jdbcDao.queryRecords(sb.toString());
		/*夏秋雨  查找project_info_no、获得note列表    结束*/

		JSONArray json = null;
		if (list != null && list.iterator().hasNext()) {
			Iterator<Task> ite = list.iterator();
			List<Map<String, Object>> jsList = new ArrayList<Map<String, Object>>();
			while (ite.hasNext()) {
				Task task = ite.next();
				Map<String, Object> map = new HashMap<String, Object>();

				map.put("Id", task.getId());
				map.put("TaskId", task.getTaskId());
				map.put("Name", task.getName());
				try {
					map.put("StartDate", sdfd.format(task.getStartDate()));
				} catch (Exception e) {
					map.put("StartDate", null);
				}
				try {
					map.put("EndDate", sdfd.format(task.getEndDate()));
				} catch (Exception e) {
					map.put("EndDate", null);
				}
				try {
					map.put("BaselineEndDate", sdfd.format(task.getBaselineEndDate()));
				} catch (Exception e) {
					map.put("BaselineEndDate", null);
				}
				try {
					map.put("BaselineStartDate", sdfd.format(task.getBaselineStartDate()));
				} catch (Exception e) {
					map.put("BaselineStartDate", null);
				}
				try {
					map.put("PlannedEndDate", sdfd.format(task.getPlannedEndDate()));
				} catch (Exception e) {
					map.put("PlannedEndDate", null);
				}
				try {
					map.put("PlannedStartDate", sdfd.format(task.getPlannedStartDate()));
				} catch (Exception e) {
					map.put("PlannedStartDate", null);
				}
				map.put("parentId", task.getParentId());
				map.put("PercentDone", task.getPercentDone());
				map.put("Priority", task.getPriority());
				map.put("other1", task.getOtherField());
				
				map.put("isWbs", task.getIsWbs());
				map.put("isRoot", task.getIsRoot());
				List<Map<String, Object>> ja = null;
				if (task.getIsWbs() == "true" || "true".equals(task.getIsWbs())) {
					ja = this.setNodeChildren(task, tasks);
				}
				if (ja != null && ja.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(ja);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", true);
				} else {
					
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
				}
				if (checked) {
					if ("true".equals((String) task.getChecked())) {
						map.put("checked", false);
					}
				}
				jsList.add(map);

			}

			json = JSONArray.fromObject(jsList);

		}

		if (json != null) {
			//System.out.println(json);
			return json.toString();
		} else {
			return "[]";
		}

	}
	
	/**
	 * 生成任务列表 使用list遍历方式递归
	 * @param wbsObjectId
	 * @return
	 * @throws Exception
	 */
	public String listWithBaseline(Integer projectObjectId, Integer wbsObjectId, Integer targetProjectObjectId, Integer targetWbsObjectId) throws Exception  {
		List<Task> tasks = this.getObjectListAllWithBaseline(projectObjectId, targetProjectObjectId);//得到该项目下所有的任务 包含wbs以及activtiy
		//tasks = getObjectListUseSql(wbsObjectId);//使用sql查询的版本
		List<Task> list = searchFromList(tasks, wbsObjectId);
		
		JSONArray json = null;
		if (list != null && list.iterator().hasNext()) {
			Iterator<Task> ite = list.iterator();
			List<Map<String, Object>> jsList = new ArrayList<Map<String, Object>>();
			while (ite.hasNext()) {
				Task task = ite.next();
				Map<String, Object> map = new HashMap<String, Object>();

				map.put("Id", task.getId());
				map.put("TaskId", task.getTaskId());
				map.put("Name", task.getName());
				try {
					map.put("StartDate", sdfd.format(task.getStartDate()));
				} catch (Exception e) {
					map.put("StartDate", null);
				}
				try {
					map.put("EndDate", sdfd.format(task.getEndDate()));
				} catch (Exception e) {
					map.put("EndDate", null);
				}
				try {
					map.put("BaselineEndDate", sdfd.format(task.getBaselineEndDate()));
				} catch (Exception e) {
					map.put("BaselineEndDate", null);
				}
				try {
					map.put("BaselineStartDate", sdfd.format(task.getBaselineStartDate()));
				} catch (Exception e) {
					map.put("BaselineStartDate", null);
				}
				try {
					map.put("PlannedEndDate", sdfd.format(task.getPlannedEndDate()));
				} catch (Exception e) {
					map.put("PlannedEndDate", null);
				}
				try {
					map.put("PlannedStartDate", sdfd.format(task.getPlannedStartDate()));
				} catch (Exception e) {
					map.put("PlannedStartDate", null);
				}
				map.put("parentId", task.getParentId());
				map.put("PercentDone", task.getPercentDone());
				map.put("Priority", task.getPriority());
				map.put("other1", task.getOtherField());
				
				map.put("isWbs", task.getIsWbs());


				List<Map<String, Object>> ja = null;
				if (task.getIsWbs() == "true" || "true".equals(task.getIsWbs())) {
					ja = this.setNodeChildren(task, tasks);
				}
				if (ja != null && ja.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(ja);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", true);
				} else {
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
				}

				jsList.add(map);

			}

			json = JSONArray.fromObject(jsList);

		}

		if (json != null) {
			//System.out.println(json);
			return json.toString();
		} else {
			return "[]";
		}

	}
	
	
	/**
	 * 递归查询子节点 采用循环list方式
	 * @param node
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> setNodeChildren(Task node, List<Task> tasks) throws Exception {

		List<Map<String, Object>> childrenList = null;
		List<Task> list = this.searchFromList(tasks, node.getId());//从list中取数
		if (list != null && list.iterator().hasNext()) {
			childrenList = new ArrayList<Map<String, Object>>();
			Iterator<Task> ite = list.iterator();
			while (ite.hasNext()) {
				Task task = ite.next();

				Map<String, Object> map = new HashMap<String, Object>();

				map.put("Id", task.getId());
				map.put("TaskId", task.getTaskId());
				map.put("Name", task.getName());
				try {
					map.put("StartDate", sdfd.format(task.getStartDate()));
				} catch (Exception e) {
					map.put("StartDate", null);
				}
				try {
					map.put("EndDate", sdfd.format(task.getEndDate()));
				} catch (Exception e) {
					map.put("EndDate", null);
				}
				try {
					map.put("BaselineEndDate", sdfd.format(task.getBaselineEndDate()));
				} catch (Exception e) {
					map.put("BaselineEndDate", null);
				}
				try {
					map.put("BaselineStartDate", sdfd.format(task.getBaselineStartDate()));
				} catch (Exception e) {
					map.put("BaselineStartDate", null);
				}
				try {
					map.put("PlannedEndDate", sdfd.format(task.getPlannedEndDate()));
				} catch (Exception e) {
					map.put("PlannedEndDate", null);
				}
				try {
					map.put("PlannedStartDate", sdfd.format(task.getPlannedStartDate()));
				} catch (Exception e) {
					map.put("PlannedStartDate", null);
				}
				map.put("parentId", task.getParentId());
				map.put("PercentDone", task.getPercentDone());
				map.put("Priority", task.getPriority());
				map.put("other1", task.getOtherField());
				
				map.put("isWbs", task.getIsWbs());
				
				if (task.getIsWbs() != "true" && !"true".equals(task.getIsWbs())) {
					String note = "";
					for(int i =0; noteList!=null && noteList.size()>0 && i<noteList.size();i++){
						Map noteMap = (Map)noteList.get(i);
						if(noteMap!=null && noteMap.size()>0){
							String taskId = (String)noteMap.get("object_id");
							if(taskId.equals(task.getTaskId()) && task.getTaskId().equals(taskId)){
								note = (String)noteMap.get("notes");
								noteList.remove(i);
								break;
							}
						}
					}
					map.put("note", note);
				}
				
				List<Map<String, Object>> ja = null;
				if (task.getIsWbs() == "true" || "true".equals(task.getIsWbs())) {
					ja = this.setNodeChildren(task, tasks);
				}
				if (ja != null && ja.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(ja);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", true);
				} else {
					
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
				}
				if ("true".equals((String) task.getChecked())) {
					map.put("checked", false);
				}
				childrenList.add(map);
			}

		}

		return childrenList;
	}
	
	public String getDate(Integer projectObjectId, boolean isMax) throws Exception{
		Date tempStart = null;
		Date tempEnd = null;
		Date startDate = null;
		Date endDate = null;
		ActivityWSBean activityWSBean = new ActivityWSBean();
		List<Activity> activitys = activityWSBean.getActivityFromP6(null, "ProjectObjectId='"+projectObjectId+"'", null);
		
		Activity a = null;
		if (activitys != null && activitys.size() != 0) {
			a = activitys.get(0);
			tempStart = P6TypeConvert.convert(a.getStartDate());
			tempEnd = P6TypeConvert.convert(a.getFinishDate());
			startDate = P6TypeConvert.convert(a.getStartDate());
			endDate = P6TypeConvert.convert(a.getFinishDate());
			
			for (int i = 0; i < activitys.size(); i++) {
				a = activitys.get(i);
				tempStart = P6TypeConvert.convert(a.getStartDate());
				if (startDate.after(tempStart)) {
					startDate = tempStart;
				}
				if (endDate.before(tempEnd)) {
					endDate = tempEnd;
				}
			}
			
			if (isMax) {
				//返回最大值
				return sdfd.format(endDate);
			} else {
				//返回最小值
				return sdfd.format(startDate);
			}
		} else {
			//如果为空则返回当前日期
			return sdfd.format(new Date());
		}
	}
	
	
	/**
	 * 根据传入的目标项目的projectObjectId 和项目targetProjectObjectId得到下属的所有的wbs以及任务的列表
	 * @return
	 * @throws Exception 
	 */
	public List<Task> getObjectListAllWithBaseline(Integer projectObjectId, Integer targetProjectObjectId) throws Exception{
		
		ActivityWSBean activityWSBean = new ActivityWSBean();
		
		WbsWSBean wbsWSBean = new WbsWSBean();
		
		List<WBS> wbss = wbsWSBean.getWbsFromP6(null, "ProjectObjectId='"+projectObjectId+"'", null); //项目的所有的wbs
		
		//List<WBS> wbss1 = wbsWSBean.getWbsFromP6(null, "ProjectObjectId='"+targetProjectObjectId+"'", null);//目标项目所有的wbs
		
		List<Activity> activitys = activityWSBean.getActivityFromP6(null, "ProjectObjectId='"+projectObjectId+"'", "Id");//项目的任务

		List<Activity> activitys2 = activityWSBean.getActivityFromP6(null, "ProjectObjectId='"+targetProjectObjectId+"'", "Id");//目标项目的任务
		
		if ((wbss == null || wbss.size() == 0) && (activitys == null || activitys.size() == 0)) {
			return null;
		}
		List<Task> list = new ArrayList<Task>();
		Task task = null;
		WBS wbs = null;
		Activity a = null;
		for (int i = 0; i < wbss.size(); i++) {
			task = new Task();
			wbs = wbss.get(i);
			task.setId(wbs.getObjectId());
			task.setTaskId(wbs.getCode());
			
			//汇总某个wbs下的任务时间
			List<Activity> activitys1 = activityWSBean.getActivityFromP6(null, "WBSObjectId='"+wbs.getObjectId()+"'", null);
			
			Date startDate = null;
			Date endDate = null;
			
			//Date baesStartDate = null;
			//Date baseEndDate = null;
			if (activitys1 != null && activitys1.size() != 0) {
				a = activitys1.get(0);
				startDate = P6TypeConvert.convert(a.getStartDate());
				endDate = P6TypeConvert.convert(a.getFinishDate());
				//baesStartDate = P6TypeConvert.convert(a.getBaselineStartDate());
				//baseEndDate = P6TypeConvert.convert(a.getBaselineStartDate());
			}
			
			Date temp = null;
			for (int j = 0; j < activitys1.size(); j++) {
				a = activitys1.get(j);
				temp = P6TypeConvert.convert(a.getStartDate());
				if (startDate.after(temp)) {
					startDate = temp;
					endDate = temp;
				}
				
				temp = P6TypeConvert.convert(a.getFinishDate());
				if (endDate.before(temp)) {
					endDate = temp;
				}
				
//				temp = P6TypeConvert.convert(a.getBaselineStartDate());
//				if (baesStartDate.after(temp)) {
//					baesStartDate = temp;
//					baseEndDate = temp;
//				}
				
//				temp = P6TypeConvert.convert(a.getBaselineFinishDate());
//				if (baseEndDate.before(temp)) {
//					baseEndDate = temp;
//				}
			}
			
			try {
				task.setStartDate(new Timestamp(startDate.getTime()));
				task.setEndDate(new Timestamp(endDate.getTime()));
				//task.setBaselineStartDate(new Timestamp(baesStartDate.getTime()));
				//task.setBaselineEndDate(new Timestamp(baseEndDate.getTime()));
			} catch (Exception e) {
				task.setStartDate(null);
				task.setEndDate(null);
				//task.setBaselineStartDate(null);
				//task.setBaselineEndDate(null);
			}
			
			task.setPercentDone(0);//完成百分比
			task.setName(wbs.getName());
			task.setPriority(0);//是否关键路径
			task.setParentId(wbs.getParentObjectId().getValue());//上级wbsObjectId
			task.setDuration(0.0);//工期
			task.setDurationUnit("");//工期单位?
			task.setOtherField(wbs.getObjectId().toString());//备用字段
			
			task.setIsWbs("true");
			
			list.add(task);
		}
		
		
		for (int i = 0; i < activitys.size(); i++) {
			a = activitys.get(i);
			task = new Task();
			
			Activity temp = searchActivitys(activitys2, a.getId());
			
			task.setId(Integer.valueOf(a.getObjectId().toString()+a.getProjectObjectId().toString()));//保证跟wbs主键不冲突
			task.setTaskId(a.getId());
			task.setStartDate(new Timestamp(P6TypeConvert.convert(a.getStartDate()).getTime()));
			task.setEndDate(new Timestamp(P6TypeConvert.convert(a.getFinishDate()).getTime()));
			task.setPercentDone(Double.valueOf(a.getPercentComplete().getValue()*100).intValue());//完成百分比
			task.setName(a.getName());
			task.setPriority(0);//是否关键路径
			task.setBaselineStartDate(new Timestamp(P6TypeConvert.convert(temp.getBaselineStartDate()).getTime()));
			task.setBaselineEndDate(new Timestamp(P6TypeConvert.convert(temp.getBaselineFinishDate()).getTime()));
			task.setParentId(a.getWBSObjectId().getValue());
			task.setDuration(a.getPlannedDuration());
			task.setDurationUnit("");
			task.setOtherField(a.getObjectId().toString());
			
			task.setIsWbs("false");
			
			list.add(task);
		}
		
		return list;
	}
	
	public Activity searchActivitys(List<Activity> list, String id){
		if (list != null && list.size() != 0) {
			Activity a = null;
			for (int i = 0; i < list.size(); i++) {
				a = list.get(i);
				if (id == a.getId() || id.equals(a.getId())) {
					list.remove(i);
					i--;
					return a;
				}
			}
		}
		return null;
	}
	
	/*
	 * 用于将一个list 转换为tree List，便于	前台树的生成
	 */
	public static Map convertListTreeToJson(List list, String idName,
			String parentIdName, Map rootMap) {
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);
			String id = (String) map.get(idName);
			List subList = new ArrayList();
			for (int j = 0; list != null && j < list.size(); j++) {
				Map subMap = (Map) list.get(j);
				if (id.equals(subMap.get(parentIdName))) {
					subList.add(subMap);
				}
			}
			map.put("children", subList);
		}
		List rootSubList = new ArrayList();
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);
			if (map.get(parentIdName).equals(rootMap.get(idName))) {
				rootSubList.add(rootSubList);
			}
		}
		rootMap.put("children", rootSubList);
		return rootMap;
	}

	public static void main(String[] args) throws Exception {
		JsonUtil j = new JsonUtil();
		j.list(6793);
	}
}

