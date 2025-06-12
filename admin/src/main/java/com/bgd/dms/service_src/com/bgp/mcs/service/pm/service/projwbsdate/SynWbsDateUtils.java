package com.bgp.mcs.service.pm.service.projwbsdate;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bgp.mcs.service.pm.service.p6.util.SynUtils;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class SynWbsDateUtils {

	private RADJdbcDao radDao;
	private ILog log;
	
	public SynWbsDateUtils(){
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		log = LogFactory.getLogger(SynUtils.class);
	}
	
	public void synWbsDates(){
		Map<String,Object> updateParamMap = new HashMap();
		Map<String,Object> insertParamMap = new HashMap();
		Map<String,Object> firstInsertParamMap = new HashMap();
		Map<String,Object> datesMap = null;
		//�����ݽ����޸Ļ����
		if(this.getProjectListFromWbsDates().size() != 0){
			List<Map> projectsInP6Project = this.getProjectListFromP6project();
			if(projectsInP6Project != null){
				for(int i=0;i<projectsInP6Project.size();i++){
					//��ȡһ��p6project����Ŀ,��projectdates�������ݶԱ�,�������޸Ļ�ɾ��(����bsflag),������������
					Map<String,Object> projectInP6Map = projectsInP6Project.get(i);
					if(projectInP6Map != null){
						datesMap = this.getProjectWbsDates(projectInP6Map.get("object_id").toString());
						//����Ŀ�Ѿ�����dates����,ִ���޸Ļ�ɾ������
						if(this.whetherInWbsDates(projectInP6Map.get("object_id").toString()) != null){
							System.out.println("���²���");
							//�ж�projectinp6��bsflag
							if("0".equals(projectInP6Map.get("bsflag").toString()) || "0" == projectInP6Map.get("bsflag").toString()){
								//���²���
								updateParamMap.put("PROJECT_WBS_DATES_ID", whetherInWbsDates(projectInP6Map.get("object_id").toString()));
								updateParamMap.put("PLAN_SURVEY_START_DATE", datesMap.get("surveyPlanStartDate"));
								updateParamMap.put("PLAN_SURVEY_END_DATE", datesMap.get("surveyPlanFinishDate"));
								updateParamMap.put("PLAN_SURFACE_START_DATE", datesMap.get("surfacePlanStartDate"));
								updateParamMap.put("PLAN_SURFACE_END_DATE", datesMap.get("surfacePlanFinishDate"));
								updateParamMap.put("PLAN_DRILL_START_DATE", datesMap.get("drillPlanStartDate"));
								updateParamMap.put("PLAN_DRILL_END_DATE", datesMap.get("drillPlanFinishDate"));
								updateParamMap.put("PLAN_ACQUIRE_START_DATE", datesMap.get("acquirePlanStartDate"));
								updateParamMap.put("PLAN_ACQUIRE_END_DATE", datesMap.get("acquirePlanFinishDate"));
								updateParamMap.put("PLAN_EXPLORATION_START_DATE", datesMap.get("explorationStartDate"));
								updateParamMap.put("PLAN_EXPLORATION_END_DATE", datesMap.get("explorationPlanFinishDate"));
								updateParamMap.put("PLAN_RELEASE_START_DATE", datesMap.get("releasePlanStartDate"));
								updateParamMap.put("PLAN_RELEASE_END_DATE", datesMap.get("releasePlanFinishDate"));
								updateParamMap.put("ACTUAL_SURVEY_START_DATE", datesMap.get("surveyActualStartDate"));
								updateParamMap.put("ACTUAL_SURVEY_END_DATE", datesMap.get("surveyActualFinishDate"));
								updateParamMap.put("ACTUAL_SURFACE_START_DATE", datesMap.get("surfaceActualStartDate"));
								updateParamMap.put("ACTUAL_SURFACE_END_DATE", datesMap.get("surfaceActualFinishDate"));
								updateParamMap.put("ACTUAL_DRILL_START_DATE", datesMap.get("drillActualStartDate"));
								updateParamMap.put("ACTUAL_DRILL_END_DATE", datesMap.get("drillActualFinishDate"));
								updateParamMap.put("ACTUAL_ACQUIRE_START_DATE", datesMap.get("acquireActualStartDate"));
								updateParamMap.put("ACTUAL_ACQUIRE_END_DATE", datesMap.get("acquireActualFinishDate"));
								updateParamMap.put("ACTUAL_EXPLORATION_START_DATE", datesMap.get("explorationActualStartDate"));
								updateParamMap.put("ACTUAL_EXPLORATION_END_DATE", datesMap.get("explorationActualFinishDate"));
								updateParamMap.put("ACTUAL_RELEASE_START_DATE", datesMap.get("releaseActualStartDate"));
								updateParamMap.put("ACTUAL_RELEASE_END_DATE", datesMap.get("releaseActualFinishDate"));
								updateParamMap.put("MODIFI_DATE", new Date());
								
								radDao.saveOrUpdateEntity(updateParamMap, "project_wbs_dates");
							}else if("1".equals(projectInP6Map.get("bsflag").toString()) || "1" == projectInP6Map.get("bsflag").toString()){
								//ɾ������
								String updateSql = "update project_wbs_dates d set d.bsflag = '1' where d.project_id = '"+projectInP6Map.get("object_id").toString()+"'";
								radDao.executeUpdate(updateSql);
							}
						}
						//����Ŀ����dates����,ִ�в������
						else if(this.whetherInWbsDates(projectInP6Map.get("object_id").toString()) == null && "0".equals(projectInP6Map.get("bsflag").toString())){
							System.out.println("�������");
							insertParamMap.put("PROJECT_ID", projectInP6Map.get("object_id").toString());
							insertParamMap.put("PROJECT_INFO_NO", projectInP6Map.get("project_info_no").toString());
							insertParamMap.put("PROJECT_NAME", projectInP6Map.get("project_name").toString());
							insertParamMap.put("PLAN_SURVEY_START_DATE", datesMap.get("surveyPlanStartDate"));
							insertParamMap.put("PLAN_SURVEY_END_DATE", datesMap.get("surveyPlanFinishDate"));
							insertParamMap.put("PLAN_SURFACE_START_DATE", datesMap.get("surfacePlanStartDate"));
							insertParamMap.put("PLAN_SURFACE_END_DATE", datesMap.get("surfacePlanFinishDate"));
							insertParamMap.put("PLAN_DRILL_START_DATE", datesMap.get("drillPlanStartDate"));
							insertParamMap.put("PLAN_DRILL_END_DATE", datesMap.get("drillPlanFinishDate"));
							insertParamMap.put("PLAN_ACQUIRE_START_DATE", datesMap.get("acquirePlanStartDate"));
							insertParamMap.put("PLAN_ACQUIRE_END_DATE", datesMap.get("acquirePlanFinishDate"));
							insertParamMap.put("PLAN_EXPLORATION_START_DATE", datesMap.get("explorationStartDate"));
							insertParamMap.put("PLAN_EXPLORATION_END_DATE", datesMap.get("explorationPlanFinishDate"));
							insertParamMap.put("PLAN_RELEASE_START_DATE", datesMap.get("releasePlanStartDate"));
							insertParamMap.put("PLAN_RELEASE_END_DATE", datesMap.get("releasePlanFinishDate"));
							insertParamMap.put("ACTUAL_SURVEY_START_DATE", datesMap.get("surveyActualStartDate"));
							insertParamMap.put("ACTUAL_SURVEY_END_DATE", datesMap.get("surveyActualFinishDate"));
							insertParamMap.put("ACTUAL_SURFACE_START_DATE", datesMap.get("surfaceActualStartDate"));
							insertParamMap.put("ACTUAL_SURFACE_END_DATE", datesMap.get("surfaceActualFinishDate"));
							insertParamMap.put("ACTUAL_DRILL_START_DATE", datesMap.get("drillActualStartDate"));
							insertParamMap.put("ACTUAL_DRILL_END_DATE", datesMap.get("drillActualFinishDate"));
							insertParamMap.put("ACTUAL_ACQUIRE_START_DATE", datesMap.get("acquireActualStartDate"));
							insertParamMap.put("ACTUAL_ACQUIRE_END_DATE", datesMap.get("acquireActualFinishDate"));
							insertParamMap.put("ACTUAL_EXPLORATION_START_DATE", datesMap.get("explorationActualStartDate"));
							insertParamMap.put("ACTUAL_EXPLORATION_END_DATE", datesMap.get("explorationActualFinishDate"));
							insertParamMap.put("ACTUAL_RELEASE_START_DATE", datesMap.get("releaseActualStartDate"));
							insertParamMap.put("ACTUAL_RELEASE_END_DATE", datesMap.get("releaseActualFinishDate"));
							insertParamMap.put("BSFLAG", "0");
							insertParamMap.put("CREATE_DATE", new Date());
							insertParamMap.put("MODIFI_DATE", new Date());
							
							radDao.saveOrUpdateEntity(insertParamMap, "project_wbs_dates");
						}
					}
				}
			}
		}
		//���û��������ִ�в������(��һ��û������,ִ�в������)
		else{
			if(this.getProjectListFromP6project().size() != 0){
				List<Map> projectListInP6 = this.getFirstInsertProjects();
				for(int i=0;i<projectListInP6.size();i++){
					Map<String,Object> projectMap = projectListInP6.get(i);
					if(projectMap != null){
						datesMap = this.getProjectWbsDates(projectMap.get("object_id").toString());
						if(datesMap != null){
							firstInsertParamMap.put("PROJECT_ID", projectMap.get("object_id").toString());
							firstInsertParamMap.put("PROJECT_INFO_NO", projectMap.get("project_info_no").toString());
							firstInsertParamMap.put("PROJECT_NAME", projectMap.get("project_name").toString());
							firstInsertParamMap.put("PLAN_SURVEY_START_DATE", datesMap.get("surveyPlanStartDate"));
							firstInsertParamMap.put("PLAN_SURVEY_END_DATE", datesMap.get("surveyPlanFinishDate"));
							firstInsertParamMap.put("PLAN_SURFACE_START_DATE", datesMap.get("surfacePlanStartDate"));
							firstInsertParamMap.put("PLAN_SURFACE_END_DATE", datesMap.get("surfacePlanFinishDate"));
							firstInsertParamMap.put("PLAN_DRILL_START_DATE", datesMap.get("drillPlanStartDate"));
							firstInsertParamMap.put("PLAN_DRILL_END_DATE", datesMap.get("drillPlanFinishDate"));
							firstInsertParamMap.put("PLAN_ACQUIRE_START_DATE", datesMap.get("acquirePlanStartDate"));
							firstInsertParamMap.put("PLAN_ACQUIRE_END_DATE", datesMap.get("acquirePlanFinishDate"));
							firstInsertParamMap.put("PLAN_EXPLORATION_START_DATE", datesMap.get("explorationStartDate"));
							firstInsertParamMap.put("PLAN_EXPLORATION_END_DATE", datesMap.get("explorationPlanFinishDate"));
							firstInsertParamMap.put("PLAN_RELEASE_START_DATE", datesMap.get("releasePlanStartDate"));
							firstInsertParamMap.put("PLAN_RELEASE_END_DATE", datesMap.get("releasePlanFinishDate"));
							firstInsertParamMap.put("ACTUAL_SURVEY_START_DATE", datesMap.get("surveyActualStartDate"));
							firstInsertParamMap.put("ACTUAL_SURVEY_END_DATE", datesMap.get("surveyActualFinishDate"));
							firstInsertParamMap.put("ACTUAL_SURFACE_START_DATE", datesMap.get("surfaceActualStartDate"));
							firstInsertParamMap.put("ACTUAL_SURFACE_END_DATE", datesMap.get("surfaceActualFinishDate"));
							firstInsertParamMap.put("ACTUAL_DRILL_START_DATE", datesMap.get("drillActualStartDate"));
							firstInsertParamMap.put("ACTUAL_DRILL_END_DATE", datesMap.get("drillActualFinishDate"));
							firstInsertParamMap.put("ACTUAL_ACQUIRE_START_DATE", datesMap.get("acquireActualStartDate"));
							firstInsertParamMap.put("ACTUAL_ACQUIRE_END_DATE", datesMap.get("acquireActualFinishDate"));
							firstInsertParamMap.put("ACTUAL_EXPLORATION_START_DATE", datesMap.get("explorationActualStartDate"));
							firstInsertParamMap.put("ACTUAL_EXPLORATION_END_DATE", datesMap.get("explorationActualFinishDate"));
							firstInsertParamMap.put("ACTUAL_RELEASE_START_DATE", datesMap.get("releaseActualStartDate"));
							firstInsertParamMap.put("ACTUAL_RELEASE_END_DATE", datesMap.get("releaseActualFinishDate"));
							firstInsertParamMap.put("BSFLAG", "0");
							firstInsertParamMap.put("CREATE_DATE", new Date());
							firstInsertParamMap.put("MODIFI_DATE", new Date());
							
							radDao.saveOrUpdateEntity(firstInsertParamMap, "project_wbs_dates");
						}
					}
				}
				
			}
		}
	}
	
	
	public List<Map> getProjectListFromP6project(){
		//��ѯ���е���Ŀ���ٸ�
		String get_project_sql = "select p.object_id,p.project_name,p.project_info_no,p.bsflag from bgp_p6_project p where p.project_object_id is null";
		System.out.println("size is:"+radDao.queryRecords(get_project_sql).size());
		return radDao.queryRecords(get_project_sql);
	}
	//��һ�β�����ѯ�����е���Ŀ,Ȼ�����
	public List<Map> getFirstInsertProjects(){
		String get_project_sql = "select p.object_id,p.project_name,p.project_info_no from bgp_p6_project p where p.bsflag = '0' and p.project_object_id is null";
		System.out.println("size is:"+radDao.queryRecords(get_project_sql).size());
		return radDao.queryRecords(get_project_sql);
	}
	
	public List<Map> getProjectListFromWbsDates(){
		//��ѯwbsdate���ж��ٸ���Ŀ
		String get_project_sql = "select * from project_wbs_dates t where t.bsflag = '0'";
		System.out.println("size is:"+radDao.queryRecords(get_project_sql).size());
		return radDao.queryRecords(get_project_sql);
	}
	
	public String whetherInWbsDates(String projectID){
		String get_project_sql = "select t.project_wbs_dates_id from project_wbs_dates t where t.bsflag = '0' and t.project_id = '"+projectID+"'";
		if(radDao.queryRecordBySQL(get_project_sql)!=null){
			return radDao.queryRecordBySQL(get_project_sql).get("project_wbs_dates_id").toString();
		}else{
			return null;
		}
	}
	
	//��ȡĳ����ĿһЩʱ���
	public Map<String,Object> getProjectWbsDates(String projectID){
		Map<String,Object> dateMap = null;
		Map<String,Object> returnDateMap = new HashMap();
		String getDatesSql = "select a.wbs_name,min(a.planned_start_date) as plan_start_date,max(a.planned_finish_date) as plan_finish_date,min(a.actual_start_date) as actual_start_date,max(a.actual_finish_date) as actual_finish_date from bgp_p6_activity a join bgp_p6_project p on a.project_object_id = p.object_id and p.bsflag = '0' where a.bsflag = '0' and a.project_object_id = '"+projectID+"' and a.wbs_name in ('����','������','�꾮','�ɼ�','����̤��','��Դǲɢ') group by a.wbs_name";
		List<Map> listDatesMap = radDao.queryRecords(getDatesSql);
		if(listDatesMap != null){
			for(int i=0;i<listDatesMap.size();i++){
				dateMap = listDatesMap.get(i);
				//String wbsName = dateMap.get("wbs_name").toString();
				if("����".equals(dateMap.get("wbs_name"))){
					//���û��δ��ʼ�����ڽ��е���ҵ,˵����������ɵ�
					if(this.getActivityCount(projectID, dateMap.get("wbs_name").toString()) == 0){
						returnDateMap.put("surveyPlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("surveyPlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("surveyActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("surveyActualFinishDate", dateMap.get("actual_finish_date"));
					}else{
						returnDateMap.put("surveyPlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("surveyPlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("surveyActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("surveyActualFinishDate", "");
					}

					continue;
				}
				if("����̤��".equals(dateMap.get("wbs_name"))){
					if(this.getActivityCount(projectID, dateMap.get("wbs_name").toString()) == 0){
						returnDateMap.put("explorationStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("explorationPlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("explorationActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("explorationActualFinishDate", dateMap.get("actual_finish_date"));
					}else{
						returnDateMap.put("explorationStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("explorationPlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("explorationActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("explorationActualFinishDate", "");
					}

					continue;
				}
				if("�꾮".equals(dateMap.get("wbs_name"))){
					if(this.getActivityCount(projectID, dateMap.get("wbs_name").toString()) == 0){
						returnDateMap.put("drillPlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("drillPlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("drillActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("drillActualFinishDate", dateMap.get("actual_finish_date"));
					}else{
						returnDateMap.put("drillPlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("drillPlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("drillActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("drillActualFinishDate", "");
					}

					continue;
				}
				if("�ɼ�".equals(dateMap.get("wbs_name"))){
					if(this.getActivityCount(projectID, dateMap.get("wbs_name").toString()) == 0){
						returnDateMap.put("acquirePlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("acquirePlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("acquireActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("acquireActualFinishDate", dateMap.get("actual_finish_date"));
					}else{
						returnDateMap.put("acquirePlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("acquirePlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("acquireActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("acquireActualFinishDate", "");
					}

					continue;
				} 
				if("������".equals(dateMap.get("wbs_name"))){
					if(this.getActivityCount(projectID, dateMap.get("wbs_name").toString()) == 0){
						returnDateMap.put("surfacePlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("surfacePlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("surfaceActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("surfaceActualFinishDate", dateMap.get("actual_finish_date"));
					}else{
						returnDateMap.put("surfacePlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("surfacePlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("surfaceActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("surfaceActualFinishDate", "");
					}

					continue;
				}
				if("��Դǲɢ".equals(dateMap.get("wbs_name"))){
					if(this.getActivityCount(projectID, dateMap.get("wbs_name").toString()) == 0){
						returnDateMap.put("releasePlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("releasePlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("releaseActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("releaseActualFinishDate", dateMap.get("actual_finish_date"));
					}else{
						returnDateMap.put("releasePlanStartDate", dateMap.get("plan_start_date"));
						returnDateMap.put("releasePlanFinishDate", dateMap.get("plan_finish_date"));
						returnDateMap.put("releaseActualStartDate", dateMap.get("actual_start_date"));
						returnDateMap.put("releaseActualFinishDate", "");
					}
					continue;
				}

			}

		}
		return returnDateMap;
	}
	
	//��ȡĳ��wbs��δ��ɵ���ҵ����
	public int getActivityCount(String projectObjectId,String wbsName){
		String sql = "select count(t.id) as count1 from bgp_p6_activity t where t.bsflag = '0' and t.status in ('In Progress','Not Started') and t.project_object_id = '"+projectObjectId+"' and t.wbs_name = '"+wbsName+"'";		
		return Integer.parseInt(radDao.queryRecordBySQL(sql).get("count1").toString());
	}
}
