package com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.workload;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，2012-10-08
 * 
 * 描述：
 * 
 * 说明:
 */
public class WorkloadMCSBean {
	private ILog log;
	private RADJdbcDao radDao;
	
	private String[] propertys = {"project_info_no","project_object_id","planned_units","remaining_units","actual_this_period_units","actual_units","resource_name","modifi_date","updator","bsflag","creator_date","creator","activity_object_id","activity_name","resource_id","object_id"};
	private String[] type = {"String","Int","Double","Double","Double","Double","String","Time","String","String","Time","String","Int","String","String","String"};
	
	public WorkloadMCSBean(){
		
		log = LogFactory.getLogger(WorkloadMCSBean.class);
		radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	}
	
	/**
	 * 查询工作量分配表
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> queryWorkload(Map<String, Object> map) {
		Object object_id = map.get("object_id");
		Object project_info_no = map.get("project_info_no");
		Object activity_object_id = map.get("activity_object_id");
		Object activity_object_ids = map.get("activity_object_ids");
		Object last_update_date = map.get("last_update_date");
		Object resource_object_id = map.get("resource_object_id");
		Object produce_date = map.get("produce_date");
		
		String sql = "select * from bgp_p6_workload where bsflag = '0' ";
		
		if (activity_object_ids != null) {
			String[] activity_object_idss = (String[]) activity_object_ids;
			sql = sql + " and activity_object_id in (";
			for (int i = 0; i < activity_object_idss.length; i++) {
				sql = sql + "'" + activity_object_idss[i] + "',";
			}
			sql = sql.substring(0, sql.length()-1);
			sql = sql + ") ";
		} else {
			if (activity_object_id != null) {
				sql = sql + "and activity_object_id = '"+activity_object_id+"' ";
			}
		}
		if (object_id != null) {
			sql = sql +" and object_id = '"+object_id+"'";
		}
		if (last_update_date != null) {
			sql = sql +" and modifi_date >= to_date('"+last_update_date+"','yyyy-MM-dd hh24:mi:ss')";
		}
		
		if(produce_date != null){
			sql = sql + " and produce_date = to_date('"+produce_date+"','yyyy-MM-dd')";
		}
		
		sql = sql + " order by activity_object_id,object_id desc ";
		
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		
		return list;
	}
	public List<Map<String, Object>> queryWorkloadWt(Map<String, Object> map) {
		Object object_id = map.get("object_id");
		Object project_info_no = map.get("project_info_no");
		Object activity_object_id = map.get("activity_object_id");
		Object activity_object_ids = map.get("activity_object_ids");
		Object last_update_date = map.get("last_update_date");
		Object resource_object_id = map.get("resource_object_id");
		Object produce_date = map.get("produce_date");
		
		String sql ="SELECT DISTINCT c.*, a.actual_units_this,(c.planned_units-a.actual_units_this)REMAINING_UNITS_this FROM (SELECT d.*  FROM bgp_p6_workload d  WHERE d.bsflag = '0'"+
     "      AND d.activity_object_id = '"+activity_object_id+"'    AND d.project_info_no = '"+project_info_no+"'"+
         "  AND d.produce_date = to_date(' "+produce_date+"', 'yyyy-MM-dd')     ORDER BY d.activity_object_id, d.object_id DESC) c left join "+
      " (SELECT SUM(NVL(p.actual_this_period_units, 0)) AS actual_units_this,   p.resource_object_id FROM bgp_p6_workload p"+
      "   WHERE p.produce_date <= to_date(' "+produce_date+"', 'yyyy-MM-dd') AND p.project_info_no = '"+project_info_no+"'"+
      "     AND p.activity_object_id = '"+activity_object_id+"'  AND p.bsflag = '0' GROUP BY p.resource_object_id) a"+     
     " on a.RESOURCE_OBJECT_ID = c.RESOURCE_OBJECT_ID  order by activity_object_id,object_id desc ";
 
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		
		return list;
	}
	/**
	 * 查询工作量分配表
	 * @param map
	 * @return
	 */
	public PageModel queryWorkload(Map<String, Object> map, PageModel page){

		Object object_id = map.get("object_id");
		Object project_info_no = map.get("project_info_no");
		Object activity_object_id = map.get("activity_object_id");
		Object activity_object_ids = map.get("activity_object_ids");
		Object last_update_date = map.get("last_update_date");
		Object resource_object_id = map.get("resource_object_id");
		Object produce_date = map.get("produce_date");
		
		String sql = "select w.*,a.name as activity_name1 from bgp_p6_workload w join bgp_p6_activity a on w.activity_object_id = a.object_id and a.bsflag = '0' where w.bsflag = '0' ";
		
		if (activity_object_ids != null) {
			String[] activity_object_idss = (String[]) activity_object_ids;
			sql = sql + " and w.activity_object_id in (";
			for (int i = 0; i < activity_object_idss.length; i++) {
				sql = sql + "'" + activity_object_idss[i] + "',";
			}
			sql = sql.substring(0, sql.length()-1);
			sql = sql + ") ";
		} else {
			if (activity_object_id != null) {
				sql = sql + "and w.activity_object_id = '"+activity_object_id+"' ";
			}
		}
		
		if (object_id != null) {
			sql = sql +" and w.object_id = '"+object_id+"'";
		}
		if (resource_object_id != null) {
			sql = sql +" and w.resource_object_id = '"+resource_object_id+"'";
		}
		if (last_update_date != null) {
			sql = sql +" and w.modifi_date >= to_date('"+last_update_date+"','yyyy-MM-dd hh24:mi:ss')";
		}
		if(produce_date != null){
			sql = sql + " and w.produce_date = to_date('"+produce_date+"','yyyy-MM-dd')";
		} else {
			sql = sql + " and w.produce_date is null ";
		}
		
		sql = sql + " order by w.resource_id, w.activity_object_id,w.object_id desc ";
		
		return radDao.queryRecordsBySQL(sql, page);
	
	}
	
	/**
	 * 查询工作量表
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> queryWorkloadMapping(Map<String, Object> map) {
		Object object_id = map.get("object_id");
		
		String sql = "select * from bgp_p6_resource_workload where 1=1 ";
		
		if (object_id != null) {
			sql = sql +" and object_id = '"+object_id+"'";
		}
		
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		
		return list;
	}
	
	public void saveOrUpdateWorkloadToMCS(List<Map<String, Object>> workloads, UserToken user){
		List<Map<String, Object>> saveList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (workloads == null || workloads.size() == 0) {
			//为空
		} else {
			for (int i = 0; i < workloads.size(); i++) {
				map =  workloads.get(i);
				if(map.get("object_id") == null || "".equals((String) map.get("object_id"))){
					saveList.add(map);
					workloads.remove(i);
					i--;
				}
			}
		}
		
		updateList = workloads;
		
		this.saveWorkloadToMCS(saveList);
		this.updateWorkloadToMCS(updateList);
	}
	
	
	private void saveWorkladToMcs(final List<Map<String, Object>> list){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into bgp_p6_workload (");
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
			public int getBatchSize() {
				return list.size();
			}
			
			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map<String, Object> map = list.get(i);
				
				java.sql.Time date = null;
				SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				
				String dateString = null;
				
				for (int j = 0; j < propertys.length; j++) {
					try {
						
						if ("String".equals(type[j])) {
							ps.setString(j+1, (String) map.get(propertys[j]));
						} else if ("Int".equals(type[j])) {
							ps.setInt(j+1, Integer.parseInt((String)map.get(propertys[j])));
						} else if ("Double".equals(type[j])) {
							ps.setDouble(j+1, Double.parseDouble((String)map.get(propertys[j])));
						} else if ("Time".equals(type[j])) {
							dateString = f.format(new Date());
							if (dateString != null && !"".equals(dateString)) {
								date = new Time(f.parse(dateString).getTime());
								ps.setTime(j+1, date);
							} else {
								ps.setTime(j+1, null);
							}
						}
						
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	private void saveWorkloadToMCS(final List<Map<String, Object>> list){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		String[] propertys = {"project_info_no","project_object_id","planned_units","remaining_units","actual_this_period_units","actual_units","resource_name","modifi_date","updator","bsflag","creator_date","creator","activity_object_id","activity_name","resource_id","resource_object_id","produce_date","object_id"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into bgp_p6_workload (");
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
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map<String, Object> map = list.get(i);
				java.sql.Time date = null;
				SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				SimpleDateFormat ff=new SimpleDateFormat("yyyy-MM-dd");
				
				ps.setString(1, (String) map.get("project_info_no"));
				ps.setInt(2, changeToInt(map.get("project_object_id")));
				ps.setDouble(3, changeToDouble(map.get("planned_units")));
				ps.setDouble(4, changeToDouble(map.get("remaining_units")));
				ps.setDouble(5, changeToDouble(map.get("actual_this_period_units")));
				ps.setDouble(6, changeToDouble(map.get("actual_units")));
				ps.setString(7, (String) map.get("resource_name"));
				String dateString = null;
				try {
				dateString = f.format(new Date());
				if (dateString != null && !"".equals(dateString)) {
					date = new Time(f.parse(dateString).getTime());
					ps.setTime(8, date);
				} else {
					ps.setTime(8, null);
				}
				}catch(Exception e){
					e.printStackTrace();
				}
				
				ps.setString(9, (String)map.get("updator"));
				ps.setString(10, "0");

				try {
				dateString = f.format(new Date());
				if (dateString != null && !"".equals(dateString)) {
					date = new Time(f.parse(dateString).getTime());
					ps.setTime(11, date);
				} else {
					ps.setTime(11, null);
				}
				}catch(Exception e){
					e.printStackTrace();
				}
				
				ps.setString(12, (String)map.get("creator"));
				ps.setInt(13, changeToInt(map.get("activity_object_id")));
				ps.setString(14, (String)map.get("activity_name"));
				ps.setString(15, (String)map.get("resource_id"));
				ps.setInt(16, changeToInt(map.get("resource_object_id")));

				try {
					dateString = (String) map.get("produce_date");
				if (dateString != null && !"".equals(dateString)) {
					java.sql.Date d = new java.sql.Date(ff.parse(dateString).getTime());
					ps.setDate(17, d);
				} else {
					ps.setDate(17, null);
				}
				}catch(Exception e){
					e.printStackTrace();
				}
				
				ps.setString(18, radDao.generateUUID());
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
		
	}
	
	private void updateWorkloadToMCS(final List<Map<String, Object>> list){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		String[] propertys = {"project_info_no","project_object_id","planned_units","remaining_units","actual_this_period_units","actual_units","resource_name","modifi_date","updator","bsflag","activity_object_id","activity_name","resource_id","resource_object_id","produce_date","object_id"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("update bgp_p6_workload set ");
		for (int i = 0; i < propertys.length-1; i++) {
			sql.append(propertys[i]).append("=?,");//其他值
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map<String, Object> map = list.get(i);
				
				java.sql.Time date = null;
				SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				SimpleDateFormat ff=new SimpleDateFormat("yyyy-MM-dd");
				
				try {
					ps.setString(1, (String) map.get("project_info_no"));
					ps.setInt(2, changeToInt(map.get("project_object_id")));
					ps.setDouble(3, changeToDouble(map.get("planned_units")));
					ps.setDouble(4, changeToDouble(map.get("remaining_units")));
					ps.setDouble(5, changeToDouble(map.get("actual_this_period_units")));
					ps.setDouble(6, changeToDouble(map.get("actual_units")));
					ps.setString(7, (String) map.get("resource_name"));
					
					String dateString = f.format(new Date());
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(8, date);
					} else {
						ps.setTime(8, null);
					}
					
					ps.setString(9, (String)map.get("updator"));
					ps.setString(10, "0");
					ps.setInt(11, changeToInt(map.get("activity_object_id")));
					ps.setString(12, (String)map.get("activity_name"));
					ps.setString(13, (String)map.get("resource_id"));
					ps.setInt(14, changeToInt(map.get("resource_object_id")));
					
					try {
						dateString = (String) map.get("produce_date");
					if (dateString != null && !"".equals(dateString)) {
						java.sql.Date d = new java.sql.Date(ff.parse(dateString).getTime());
						ps.setDate(15, d);
					} else {
						ps.setDate(15, null);
					}
					}catch(Exception e){
						e.printStackTrace();
					}

					ps.setString(16, (String) map.get("object_id"));
					
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
		this.updateDailyWorkload(list);
	}
	
	//当工作量分配中的计划工作量被修改,日报录入中的计划工作量也跟着修改
	
	public void updateDailyWorkload(List<Map<String,Object>> workloadList){
		
		if(workloadList != null){
			Map<String, Object> map = null;
			String updatePlanUnitsSql = "";
			for(int i=0;i<workloadList.size();i++){
				map = workloadList.get(i);
				double planned_units = changeToDouble(map.get("planned_units"));
				int activity_object_id = changeToInt(map.get("activity_object_id"));
				String resource_id = map.get("resource_id").toString();
				int resource_object_id = changeToInt(map.get("resource_object_id"));
				String project_info_no = map.get("project_info_no").toString();
				
				updatePlanUnitsSql = "update bgp_p6_workload w set w.planned_units = "+planned_units+" where w.activity_object_id = "+activity_object_id+" and w.resource_id = '"+resource_id+"' and w.resource_object_id = "+resource_object_id+" and w.project_info_no = '"+project_info_no+"' and w.bsflag = '0' and w.produce_date is not null";
				radDao.executeUpdate(updatePlanUnitsSql);
				//this.updateDailyRemainUnits(activity_object_id, resource_id, resource_object_id, project_info_no);
			}
		}

	}
	//更新尚需的工作量
	public void updateDailyRemainUnits(int activity_object_id,String resource_id,int resource_object_id,String project_info_no){
		
		String getUpdateRemainUnitsSql = "select w.object_id,w.planned_units - w.actual_units as remain_units from bgp_p6_workload w where w.activity_object_id = "+activity_object_id+" and w.resource_id = '"+resource_id+"' and w.resource_object_id = "+resource_object_id+" and w.project_info_no = '"+project_info_no+"' and w.bsflag = '0'";
		List<Map> remainUnitsList = radDao.queryRecords(getUpdateRemainUnitsSql);
		if(remainUnitsList != null){
			Map remainUnitsMap = null;
			String updateSql = "";
			for(int i=0;i<remainUnitsList.size();i++){
				remainUnitsMap = remainUnitsList.get(i);
				double remain_units = changeToDouble(remainUnitsMap.get("remain_units"));
				String object_id = remainUnitsMap.get("object_id").toString();
				updateSql = "update bgp_p6_workload w set w.remaining_units = "+remain_units+" where w.object_id ='"+object_id+"'";
				radDao.executeUpdate(updateSql);
			}
		}
	}
	
	/**
	 * 检查勘探方法是否存在
	 * @param projectInfo
	 * @param taskId
	 * @return
	 */
	public boolean checkMethodExist(String projectInfo,String taskId){
		String sql = "select m.exploration_method from bgp_activity_method_mapping m where m.bsflag = '0' and m.project_info_no = '"+projectInfo+"' and m.activity_object_id = '"+taskId+"'";
		List<Map> list = radDao.queryRecords(sql);
		if(list != null && list.size() > 0){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 新增bgp_activity_method_mapping
	 * @param methodMap
	 */
	public void addTaskMethod(Map methodMap){
		radDao.saveOrUpdateEntity(methodMap, "BGP_ACTIVITY_METHOD_MAPPING");
	}
	
	/**
	 * 更新bgp_activity_method_mapping
	 * @param methodMap
	 * @return
	 */
	public boolean updateTaskMethod(Map methodMap){
		String updateSql = "update bgp_activity_method_mapping m set m.exploration_method = '"+methodMap.get("EXPLORATION_METHOD")+"' where m.project_info_no = '"+methodMap.get("PROJECT_INFO_NO")+"' and m.activity_object_id = '"+methodMap.get("ACTIVITY_OBJECT_ID")+"'";
		int flag = radDao.executeUpdate(updateSql);
		if(flag > 0){
			return true;
		}else{
			return false;
		}
	}
	
	private double changeToDouble(Object obj){
		if (obj != null) {
			if (obj.getClass().getName().endsWith("BigDecimal")) {
				BigDecimal temp = (BigDecimal) obj;
				return temp.doubleValue();
			}
			
			if (obj.getClass().getName().endsWith("Double")) {
				Double temp = (Double) obj;
				return temp.doubleValue();
			}
			
			if (obj.getClass().getName().endsWith("String")) {
				Double temp = Double.parseDouble((String)obj);
				return temp.doubleValue();
			}
			return 0.0;
		} else {
			return 0.0;
		}
	}
	
	private int changeToInt(Object obj){
		if (obj != null) {
			if (obj.getClass().getName().endsWith("BigDecimal")) {
				BigDecimal temp = (BigDecimal) obj;
				return temp.intValue();
			}
			
			if (obj.getClass().getName().endsWith("Integer")) {
				Integer temp = (Integer) obj;
				return temp.intValue();
			}
			
			if (obj.getClass().getName().endsWith("String")) {
				Integer temp = Integer.parseInt((String)obj);
				return temp.intValue();
			}
			return 0;
		} else {
			return 0;
		}
	}
	
}
