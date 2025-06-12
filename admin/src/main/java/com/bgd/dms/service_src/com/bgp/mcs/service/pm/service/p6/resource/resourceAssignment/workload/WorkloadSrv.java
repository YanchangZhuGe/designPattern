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
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，2012-10-11
 * 
 * 描述：
 * 
 * 说明:
 */
public class WorkloadSrv extends BaseService {
	
	private WorkloadMCSBean workloadMCSBean;
	private ActivityMCSBean activityMCSBean;
	private RADJdbcDao radDao;
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	private static Map<String,String> parentName;//key 工作量元数据类别Id , value 工作量元数据类别名称
	static {
		parentName = new HashMap<String,String>();
		parentName.put("G6601", "测量");
		parentName.put("G6602", "重力");
		parentName.put("G6603", "磁力");
		parentName.put("G6604", "人工场源电法");
		parentName.put("G6605", "天然场源电法");
		parentName.put("G6606", "化学勘探");
		parentName.put("G6607", "工程");
	}
	
	public WorkloadSrv(){
		workloadMCSBean = (WorkloadMCSBean) BeanFactory.getBean("P6WorkloadMCSBean");
		activityMCSBean = (ActivityMCSBean) BeanFactory.getBean("P6ActivityMCSBean");
		radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	}
	
	/**
	 *  查询工作量分配
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
	//保存工作量
	public ISrvMsg saveWorkload(ISrvMsg reqDTO) throws Exception {
	
		

		
		//选择的工作量Id
		String resourceObjectIds = reqDTO.getValue("resourceObjectIds");
		//选择的任务(p6中建立的任务)
		String activityObjectIds = reqDTO.getValue("activityObjectIds");
		
		//无选择的任务工作量 返回
		if(resourceObjectIds.equals("")||activityObjectIds.equals("")){
			return SrvMsgUtil.createResponseMsg(reqDTO); 
		}
		
		
		String[] activityObjectId = activityObjectIds.split(",");
		String[] resourceObjectId = resourceObjectIds.split(",");
		UserToken user = reqDTO.getUserToken();
		Map<String, Object> query = new HashMap<String, Object>();
		
		
		//start 综合物化探添加 影响所有类型的项目 根据 project_info_no 	activity_object_id   resource_object_id 判断不可重复添加工作量 
		
		//综合物化探 根据project_info_no 	activity_object_id 查询已经添加的工作量 用来判断重复
		String existsql = "select t.* from bgp_p6_workload t where t.project_info_no='"+user.getProjectInfoNo()+"' and t.activity_object_id in ("+activityObjectIds+") and t.bsflag='0' ";
		List<Map<String,Object>> existList = radDao.getJdbcTemplate().queryForList(existsql);
		Set<String> tempExistWorkload = new HashSet<String>();//判断重复用

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
		//一条数据
			//循环任务保存工作量分配
			query.put("object_id", activityObjectId[i]);
			
			Object activity_name = null;
			//根据任务id 查询任务  获得任务名
			List a = activityMCSBean.queryActivityFromMCS(query);
			Map temp = null;
			if (a != null && a.size() != 0) {
				temp = (Map) a.get(0);
				activity_name = temp.get("NAME");
			} else {
				continue;
			}
			
			//为一条任务添加工作量
			for (int j = 0; j < resourceObjectId.length; j++) {
				
				//获得工作量名称
				query.put("object_id", resourceObjectId[j]);//工作量id
				//查询工作量元数据表 bgp_p6_resource_workload 工作量名 工作量id
				List w = workloadMCSBean.queryWorkloadMapping(query);
				if (w != null && w.size() != 0) {
					temp = (Map) w.get(0);
				} else {
					continue;
				}
				

				//综合物化探 过滤重复添加的工作量 对所有项目类型都起作用
				if(tempExistWorkload.contains(user.getProjectInfoNo()+activityObjectId[i]+resourceObjectId[j])){
					//已存在要添加的工作量 添加到提示信息
					saveResult.append("[");
					saveResult.append(activity_name);
					saveResult.append("  ");
					saveResult.append((parentName.get(((String)temp.get("ID")).substring(0, 5))==null?"":parentName.get(((String)temp.get("ID")).substring(0, 5))+" ")+temp.get("NAME"));
					saveResult.append("]\r\n");
					
				}else{
					//不存在 可添加 
					
					map = new HashMap<String, Object>();
					map.put("activity_name", activity_name);//任务名
					
					
					map.put("activity_object_id", activityObjectId[i]);
					map.put("resource_object_id", resourceObjectId[j]);
					map.put("project_info_no", user.getProjectInfoNo());
					map.put("project_object_id", user.getProjectObjectId().toString());
					//综合物化探保存上级菜单名
					map.put("resource_name", (parentName.get(((String)temp.get("ID")).substring(0, 5))==null?"":parentName.get(((String)temp.get("ID")).substring(0, 5))+" ")+temp.get("NAME"));//工作量名   取父级名称
					map.put("resource_id", temp.get("ID"));//工作量id 编码
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
		//保存添加的工作量
		workloadMCSBean.saveOrUpdateWorkloadToMCS(list, user);
		
		if(!saveResult.toString().equals("")){
			saveResult.append("已存在,不能重复添加!");
		}
		msg.setValue("saveResult", saveResult.toString());
		return msg;
		
	}
	
	
	//保存工作量数值
	public ISrvMsg updateWorkload(ISrvMsg reqDTO) throws Exception {
		Map mm = reqDTO.toMap();
		UserToken user = reqDTO.getUserToken();
		
		String activityObjectIds = reqDTO.getValue("activityObjectIds");
		String taskName = reqDTO.getValue("taskNames");
		
		//勘探方法的操作
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
		//通过项目和作业判断是否有勘探方法,有更新,没有新增
		if(method != null && method != ""){
			if(workloadMCSBean.checkMethodExist(projectInfoNo, taskId)){
				//存着更新操作
				workloadMCSBean.updateTaskMethod(methodMap);
			}else{
				//不存在新增
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
				map.put("planned_units", planned_units);//预算数量
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
		
		//删除日报录入中对应的工作量分配
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
	 * 获取作业分配的勘探方法
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
