package com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.workload;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.pm.service.p6.activity.ActivityMCSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 
 * ���⣺��ʯ�ͼ��Ź�˾��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾: �������
 * 
 * ���ߣ��ǿ��2012-10-11
 * 
 * ������
 * 
 * ˵��:
 */
public class WorkloadSrv extends BaseService {
	
	private WorkloadMCSBean workloadMCSBean;
	private ActivityMCSBean activityMCSBean;
	private RADJdbcDao radDao;
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	private static Map<String,String> parentName;//key ������Ԫ�������Id , value ������Ԫ�����������
	static {
		parentName = new HashMap<String,String>();
		parentName.put("G6601", "����");
		parentName.put("G6602", "����");
		parentName.put("G6603", "����");
		parentName.put("G6604", "�˹���Դ�編");
		parentName.put("G6605", "��Ȼ��Դ�編");
		parentName.put("G6606", "��ѧ��̽");
		parentName.put("G6607", "����");
	}
	
	public WorkloadSrv(){
		workloadMCSBean = (WorkloadMCSBean) BeanFactory.getBean("P6WorkloadMCSBean");
		activityMCSBean = (ActivityMCSBean) BeanFactory.getBean("P6ActivityMCSBean");
		radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	}
	
	/**
	 *  ��ѯ����������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryWorkload(ISrvMsg reqDTO) throws Exception {
		
		String activity_object_ids = reqDTO.getValue("activity_object_id");
		String taskNames = reqDTO.getValue("taskNames");
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (activity_object_ids != null) {
			String[] activity_object_idss = activity_object_ids.split(",");
			if (activity_object_idss.length > 1) {
				map.put("activity_object_ids", activity_object_idss);
			} else {
				map.put("activity_object_id", activity_object_ids);
			}
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
		
		page = workloadMCSBean.queryWorkload(map, page);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		
		return msg;
	}
	//���湤����
	public ISrvMsg saveWorkload(ISrvMsg reqDTO) throws Exception {
	
		

		
		//ѡ��Ĺ�����Id
		String resourceObjectIds = reqDTO.getValue("resourceObjectIds");
		//ѡ�������(p6�н���������)
		String activityObjectIds = reqDTO.getValue("activityObjectIds");
		
		//��ѡ����������� ����
		if(resourceObjectIds.equals("")||activityObjectIds.equals("")){
			return SrvMsgUtil.createResponseMsg(reqDTO); 
		}
		
		
		String[] activityObjectId = activityObjectIds.split(",");
		String[] resourceObjectId = resourceObjectIds.split(",");
		UserToken user = reqDTO.getUserToken();
		Map<String, Object> query = new HashMap<String, Object>();
		
		
		//start �ۺ��ﻯ̽��� Ӱ���������͵���Ŀ ���� project_info_no 	activity_object_id   resource_object_id �жϲ����ظ���ӹ����� 
		
		//�ۺ��ﻯ̽ ����project_info_no 	activity_object_id ��ѯ�Ѿ���ӵĹ����� �����ж��ظ�
		String existsql = "select t.* from bgp_p6_workload t where t.project_info_no='"+user.getProjectInfoNo()+"' and t.activity_object_id in ("+activityObjectIds+") and t.bsflag='0' ";
		List<Map<String,Object>> existList = radDao.getJdbcTemplate().queryForList(existsql);
		Set<String> tempExistWorkload = new HashSet<String>();//�ж��ظ���

		String temps = null;
		if (existList != null && existList.size() != 0) {
			for (Map<String, Object> map : existList) {
				
				tempExistWorkload.add(((String)map.get("project_info_no")+map.get("activity_object_id").toString()+map.get("resource_object_id").toString()));
				
			}
			
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer saveResult = new StringBuffer();
		
		//end

	
		
		
		
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = null;
		for (int i = 0; i < activityObjectId.length; i++) {
		//һ������
			//ѭ�����񱣴湤��������
			query.put("object_id", activityObjectId[i]);
			
			Object activity_name = null;
			//��������id ��ѯ����  ���������
			List a = activityMCSBean.queryActivityFromMCS(query);
			Map temp = null;
			if (a != null && a.size() != 0) {
				temp = (Map) a.get(0);
				activity_name = temp.get("NAME");
			} else {
				continue;
			}
			
			//Ϊһ��������ӹ�����
			for (int j = 0; j < resourceObjectId.length; j++) {
				
				//��ù���������
				query.put("object_id", resourceObjectId[j]);//������id
				//��ѯ������Ԫ���ݱ� bgp_p6_resource_workload �������� ������id
				List w = workloadMCSBean.queryWorkloadMapping(query);
				if (w != null && w.size() != 0) {
					temp = (Map) w.get(0);
				} else {
					continue;
				}
				

				//�ۺ��ﻯ̽ �����ظ���ӵĹ����� ��������Ŀ���Ͷ�������
				if(tempExistWorkload.contains(user.getProjectInfoNo()+activityObjectId[i]+resourceObjectId[j])){
					//�Ѵ���Ҫ��ӵĹ����� ��ӵ���ʾ��Ϣ
					saveResult.append("[");
					saveResult.append(activity_name);
					saveResult.append("  ");
					saveResult.append((parentName.get(((String)temp.get("ID")).substring(0, 5))==null?"":parentName.get(((String)temp.get("ID")).substring(0, 5))+" ")+temp.get("NAME"));
					saveResult.append("]\r\n");
					
				}else{
					//������ ����� 
					
					map = new HashMap<String, Object>();
					map.put("activity_name", activity_name);//������
					
					
					map.put("activity_object_id", activityObjectId[i]);
					map.put("resource_object_id", resourceObjectId[j]);
					map.put("project_info_no", user.getProjectInfoNo());
					map.put("project_object_id", user.getProjectObjectId().toString());
					//�ۺ��ﻯ̽�����ϼ��˵���
					map.put("resource_name", (parentName.get(((String)temp.get("ID")).substring(0, 5))==null?"":parentName.get(((String)temp.get("ID")).substring(0, 5))+" ")+temp.get("NAME"));//��������   ȡ��������
					map.put("resource_id", temp.get("ID"));//������id ����
					map.put("updator", user.getEmpId());
					map.put("creator", user.getEmpId());
					
					map.put("planned_units", "0");
					map.put("remaining_units", "0");
					map.put("actual_this_period_units", "0");
					map.put("actual_units", "0");
					list.add(map);
				}
				
				
			}
		}
		//������ӵĹ�����
		workloadMCSBean.saveOrUpdateWorkloadToMCS(list, user);
		
		if(!saveResult.toString().equals("")){
			saveResult.append("�Ѵ���,�����ظ����!");
		}
		msg.setValue("saveResult", saveResult.toString());
		return msg;
		
	}
	
	
	//���湤������ֵ
	public ISrvMsg updateWorkload(ISrvMsg reqDTO) throws Exception {
		Map mm = reqDTO.toMap();
		UserToken user = reqDTO.getUserToken();
		
		String activityObjectIds = reqDTO.getValue("activityObjectIds");
		String taskName = reqDTO.getValue("taskNames");
		
		//��̽�����Ĳ���
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String taskId = reqDTO.getValue("taskId");
		String method = reqDTO.getValue("method");
		Map<Object,Object> methodMap = new HashMap<Object,Object>();
		methodMap.put("PROJECT_INFO_NO", projectInfoNo);
		methodMap.put("ACTIVITY_OBJECT_ID", taskId);
		methodMap.put("EXPLORATION_METHOD", method);
		methodMap.put("BSFLAG", "0");
		methodMap.put("UPDATOR", user.getEmpId());
		methodMap.put("CREATOR_DATE", new Date());
		methodMap.put("CREATOR", user.getEmpId());
		methodMap.put("MODIFI_DATE", new Date());
		//ͨ����Ŀ����ҵ�ж��Ƿ��п�̽����,�и���,û������
		if(method != null && method != ""){
			if(workloadMCSBean.checkMethodExist(projectInfoNo, taskId)){
				//���Ÿ��²���
				workloadMCSBean.updateTaskMethod(methodMap);
			}else{
				//����������
				workloadMCSBean.addTaskMethod(methodMap);
			}
		}
		
		PageModel page = new PageModel();
		
		Map map = new HashMap();
		
		if (activityObjectIds != null) {
			String[] activity_object_idss = activityObjectIds.split(",");
			if (activity_object_idss.length > 1) {
				map.put("activity_object_ids", activity_object_idss);
			} else {
				map.put("activity_object_id", activityObjectIds);
			}
		}
		page.setPageSize(100);
		page = workloadMCSBean.queryWorkload(map,page);
		
		List list = page.getData();
		List newlist = new ArrayList();
		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				map = (Map) list.get(i);
				
				String planned_units = reqDTO.getValue("planned_units_"+map.get("object_id"));
				//if(planned_units!=null&&!planned_units.equals("")&&!planned_units.equals("0")){
				if(planned_units!=null){
					if(planned_units.equals("")){
						planned_units="0";
					}
					newlist.add(map);
				
				}
				map.put("planned_units", planned_units);//Ԥ������
			}
		}
		workloadMCSBean.saveOrUpdateWorkloadToMCS(newlist, user);
		//workloadMCSBean.saveOrUpdateWorkloadToMCS(list, user);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("taskObjectId", activityObjectIds);
		msg.setValue("taskName", taskName);
		return msg;
	}
	
	public ISrvMsg deleteWorkload(ISrvMsg reqDTO) throws Exception {
		String ids = reqDTO.getValue("objectIds");
		String[] objectIds = ids.split(",");
		
		String sql = "update bgp_p6_workload set bsflag = '1' where object_id in ( ";
		for (int i = 0; i < objectIds.length; i++) {
			sql += "'"+objectIds[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		
		jdbcTemplate.execute(sql);
		
		//ɾ���ձ�¼���ж�Ӧ�Ĺ���������
		if(objectIds.length != 0){
			Map<String,Object> wokloadMap = null;
			String getWorkloadInfoSql = "";
			String deleteDailyWorkload = "";
			for(int i=0;i<objectIds.length;i++){
				getWorkloadInfoSql = "select w.project_info_no,w.activity_object_id,w.resource_id,w.resource_object_id from bgp_p6_workload w where w.object_id = '"+objectIds[i]+"'";
				wokloadMap = radDao.queryRecordBySQL(getWorkloadInfoSql);
				int activity_object_id = Integer.parseInt((wokloadMap.get("activity_object_id")).toString());
				String resource_id = wokloadMap.get("resource_id").toString();
				int resource_object_id = Integer.parseInt((wokloadMap.get("resource_object_id")).toString());
				String project_info_no = wokloadMap.get("project_info_no").toString();
				deleteDailyWorkload = "update bgp_p6_workload w set w.bsflag = '1',w.modifi_date = sysdate where w.activity_object_id = "+activity_object_id+" and w.resource_id = '"+resource_id+"' and w.resource_object_id = "+resource_object_id+" and w.project_info_no = '"+project_info_no+"' and w.produce_date is not null";
				radDao.executeUpdate(deleteDailyWorkload);
			}
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		return msg;
	}
	
	/**
	 * ��ȡ��ҵ����Ŀ�̽����
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMethodsByActivity(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("project_info_no");
		String activityObjectId = reqDTO.getValue("activity_object_id");
		
		String getActivityMethodSql = "select m.mapping_id,m.exploration_method,m.project_info_no,m.activity_object_id from " +
									  "bgp_activity_method_mapping m where m.bsflag = '0' and m.project_info_no = '"+projectInfoNo+"' and m.activity_object_id = '"+activityObjectId+"'";
		Map acitivyMethodMap = radDao.queryRecordBySQL(getActivityMethodSql);
		if(acitivyMethodMap != null){
			msg.setValue("flag", "1");
			msg.setValue("method", acitivyMethodMap.get("exploration_method"));
		}else{
			msg.setValue("flag", "0");
		}
		return msg;
	}
}
