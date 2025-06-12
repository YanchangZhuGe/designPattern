package com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentExtends;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Dec 27, 2011
 * 
 * 描述：
 * 
 * 说明:
 */
public class ResourceAssignmentMCSBean {
	
	private ILog log;
	private RADJdbcDao radDao;
	
	public ResourceAssignmentMCSBean() {
		
		log = LogFactory.getLogger(ResourceAssignmentMCSBean.class);
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		
	}
	
	/**
	 * 查询资源分配表
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> queryResourceAssignment(Map<String,Object> map){
		Object object_id = map.get("object_id");
		Object activity_object_id = map.get("activity_object_id");
		Object submit_flag = map.get("submit_flag");
		Object last_update_date = map.get("last_update_date");
		Object resource_type = map.get("resource_type");
		Object resource_object_id = map.get("resource_object_id");
		
		String sql = "select am.*,pc.hours_per_day,udf.text_value,udf1.double_value from bgp_p6_assign_mapping am left join bgp_p6_calendar pc " +
				"on pc.object_id = am.calendar_object_id " +
				"left join bgp_p6_udf_value udf "+
				"on am.object_id = udf.foreign_object_id "+
				"and udf.udf_type_object_id = '128' "+//128资源备注
				"left join bgp_p6_udf_value udf1 "+
				"on am.object_id = udf1.foreign_object_id "+
				"and udf1.udf_type_object_id = '129' "+//129计划数量
				" where 1=1 and am.bsflag = '0' ";
		if (activity_object_id != null) {
			sql = sql +" and am.activity_object_id = '"+activity_object_id+"'";
		}
		if (object_id != null) {
			sql = sql +" and am.object_id = '"+object_id+"'";
		}
		if (submit_flag != null) {
			sql = sql +" and am.submit_flag = '"+submit_flag+"'";
		}
		if (resource_object_id != null) {
			sql = sql +" and am.resource_object_id = '"+resource_object_id+"'";
		}
		if (resource_type != null) {
			sql = sql +" and am.resource_type = '"+resource_type+"'";
		}
		if (last_update_date != null) {
			sql = sql +" and am.modifi_date >= to_date('"+last_update_date+"','yyyy-MM-dd hh24:mi:ss')";
		}
		sql = sql + " order by resource_id,am.object_id desc ";
		//log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	
	/**
	 * 保存资源分配信息到MCS
	 * @param resourceAssignments List<ResourceAssignment>
	 * @throws Exception
	 */
	@Deprecated
	public void saveP6ResourceAssignmentToMCS(List<ResourceAssignmentExtends> ResourceAssignmentExtendss) throws Exception {
		String insertSql = "insert into bgp_p6_assign_mapping values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'0')";
		String updateSql = "update bgp_p6_assign_mapping " +
				"set project_id = ?,project_object_id = ?,activity_id = ?,activity_name = ?,resource_name = ?,resource_id = ?,resource_type = ?,"+
				"planned_start = ?,planned_finish = ?,planned_duration = ?,actual_start = ?,actual_finish = ?," +
				"actual_this_period_units = ?,actual_units = ?,remaining_units = ?,modifi_date = ?,last_update_user = ?,"+
				"activity_object_id = ?,resource_object_id = ?,CALENDAR_NAME = ?,CALENDAR_OBJECT_ID = ?,START_DATE = ?,FINISH_DATE = ?,ORG_ID = ?,ORG_SUBJECTION_ID = ?,SUBMIT_FLAG = ?," +
				"PLANNED_UNITS = ?,bsflag = '0',budgeted_units = ? where object_id = ?";
		
		int[] types = new int[]{Types.VARCHAR,Types.INTEGER,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,
				Types.TIMESTAMP,Types.TIMESTAMP,Types.DOUBLE,Types.TIMESTAMP,Types.TIMESTAMP,
				Types.DOUBLE,Types.DOUBLE,Types.DOUBLE,Types.TIMESTAMP,Types.VARCHAR,
				Types.INTEGER,Types.INTEGER,Types.VARCHAR,Types.INTEGER,Types.TIMESTAMP,Types.TIMESTAMP,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,
				Types.DOUBLE,Types.DOUBLE,Types.INTEGER,};
		
		for (int i = 0; i < ResourceAssignmentExtendss.size(); i++) {
			ResourceAssignmentExtends ResourceAssignmentExtends = ResourceAssignmentExtendss.get(i);
			Map map = null;
			try {
				Object[] params = new Object[]{ResourceAssignmentExtends.getResourceAssignment().getProjectId(),ResourceAssignmentExtends.getResourceAssignment().getProjectObjectId(),ResourceAssignmentExtends.getOrgId(),ResourceAssignmentExtends.getOrgSubjectionId(),ResourceAssignmentExtends.getResourceAssignment().getActivityId(),ResourceAssignmentExtends.getResourceAssignment().getActivityName(),ResourceAssignmentExtends.getResourceAssignment().getResourceName(),ResourceAssignmentExtends.getResourceAssignment().getResourceId(),
						P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getPlannedStartDate()),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getPlannedFinishDate()),ResourceAssignmentExtends.getResourceAssignment().getPlannedDuration().getValue(),ResourceAssignmentExtends.getBudgetedUnits(),
						P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getActualStartDate().getValue()),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getActualFinishDate().getValue()),ResourceAssignmentExtends.getResourceAssignment().getActualThisPeriodUnits().getValue(),ResourceAssignmentExtends.getResourceAssignment().getActualUnits().getValue(),ResourceAssignmentExtends.getResourceAssignment().getRemainingUnits().getValue(),
						ResourceAssignmentExtends.getSubmitFlag(),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getLastUpdateDate().getValue()),ResourceAssignmentExtends.getResourceAssignment().getLastUpdateUser(),ResourceAssignmentExtends.getResourceAssignment().getObjectId(),ResourceAssignmentExtends.getResourceAssignment().getActivityObjectId(),ResourceAssignmentExtends.getResourceAssignment().getResourceObjectId().getValue(),ResourceAssignmentExtends.getResourceAssignment().getResourceType(),
						ResourceAssignmentExtends.getResourceAssignment().getCalendarName(),ResourceAssignmentExtends.getResourceAssignment().getCalendarObjectId().getValue(),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getStartDate().getValue()),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getFinishDate().getValue()),
						ResourceAssignmentExtends.getResourceAssignment().getPlannedUnits().getValue()};
				radDao.getJdbcTemplate().update(insertSql, params);
			} catch (Exception e) {
				Object[] params = new Object[]{ResourceAssignmentExtends.getResourceAssignment().getProjectId(),ResourceAssignmentExtends.getResourceAssignment().getProjectObjectId(),ResourceAssignmentExtends.getResourceAssignment().getActivityId(),ResourceAssignmentExtends.getResourceAssignment().getActivityName(),ResourceAssignmentExtends.getResourceAssignment().getResourceName(),ResourceAssignmentExtends.getResourceAssignment().getResourceId(),ResourceAssignmentExtends.getResourceAssignment().getResourceType(),
						P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getPlannedStartDate()),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getPlannedFinishDate()),ResourceAssignmentExtends.getResourceAssignment().getPlannedDuration().getValue(),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getActualStartDate()),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getActualFinishDate()),
						ResourceAssignmentExtends.getResourceAssignment().getActualThisPeriodUnits().getValue(),ResourceAssignmentExtends.getResourceAssignment().getActualUnits().getValue(),ResourceAssignmentExtends.getResourceAssignment().getRemainingUnits().getValue(),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getLastUpdateDate().getValue()),ResourceAssignmentExtends.getResourceAssignment().getLastUpdateUser(),
						ResourceAssignmentExtends.getResourceAssignment().getActivityObjectId(),ResourceAssignmentExtends.getResourceAssignment().getResourceObjectId().getValue(),ResourceAssignmentExtends.getResourceAssignment().getCalendarName(),ResourceAssignmentExtends.getResourceAssignment().getCalendarObjectId().getValue(),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getStartDate().getValue()),P6TypeConvert.convert(ResourceAssignmentExtends.getResourceAssignment().getFinishDate().getValue()),ResourceAssignmentExtends.getOrgId(),ResourceAssignmentExtends.getOrgSubjectionId(),ResourceAssignmentExtends.getSubmitFlag(),
						ResourceAssignmentExtends.getResourceAssignment().getPlannedUnits().getValue(),ResourceAssignmentExtends.getBudgetedUnits(),ResourceAssignmentExtends.getResourceAssignment().getObjectId()};
				radDao.getJdbcTemplate().update(updateSql, params,types);
			}
		}
	}
	
	@Deprecated
	public void saveP6ResourceAssignmentToMCS(List<ResourceAssignmentExtends> ResourceAssignmentExtendss, UserToken user) throws Exception {
		Map<String, Object> map = null;
		
		for (int i = 0; i < ResourceAssignmentExtendss.size(); i++) {
			ResourceAssignmentExtends r = ResourceAssignmentExtendss.get(i);
			Field[] fields = r.getResourceAssignment().getClass().getDeclaredFields();
			map = new HashMap<String, Object>();
			
			map.put("budgeted_units", r.getBudgetedUnits());
			map.put("submint_flag", r.getSubmitFlag());
			map.put("org_id", r.getOrgId());
			map.put("org_subjection_id", r.getOrgSubjectionId());
			
			for (int j = 0; j < fields.length; j++) {
				try {
					map.put(P6TypeConvert.propertyToField(fields[j].getName()), P6TypeConvert.convert(r.getResourceAssignment().getClass().getMethod(P6TypeConvert.getMethodName(fields[j].getName()), new Class[]{}).invoke(r.getResourceAssignment(), new Object[]{})));
				} catch (Exception e) {
					continue;
				}
			}
			
			map.put("bsflag", "0");
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_P6_ASSIGN_MAPPING");
		}
	}
	
	/**
	 * 保存资源分配到MCS
	 * @param ResourceAssignmentExtendss
	 * @param user
	 * @throws Exception
	 */
	public void saveOrUpdateP6ResourceAssignmentToMCS(List<ResourceAssignmentExtends> ResourceAssignmentExtendss, UserToken user) throws Exception {
		List<ResourceAssignmentExtends> saveList = new ArrayList<ResourceAssignmentExtends>();
		List<ResourceAssignmentExtends> updateList = new ArrayList<ResourceAssignmentExtends>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> allResourceAssignments = this.queryResourceAssignment(map);
		
		for (int i = 0; i < allResourceAssignments.size(); i++) {
			map = allResourceAssignments.get(i);
			int objectId = ((BigDecimal)map.get("object_id")).intValue();
			for (int j = 0; j < ResourceAssignmentExtendss.size(); j++) {
				ResourceAssignmentExtends r = ResourceAssignmentExtendss.get(j);
				int object_id = r.getResourceAssignment().getObjectId().intValue();
				
				if (object_id == objectId) {
					updateList.add(r);
					ResourceAssignmentExtendss.remove(j);
					j--;
					continue;
				}
			}
			
			if (ResourceAssignmentExtendss == null || ResourceAssignmentExtendss.size() == 0) {
				break;
			}
		}
		
		saveList = ResourceAssignmentExtendss;
		this.insertP6P6ResourceAssignmentToMCS(saveList, user);
		this.updateP6P6ResourceAssignmentToMCS(updateList, user);
	}
	
	/**
	 * 保存资源分配到MCS
	 * @param ResourceAssignmentExtendss
	 * @param user
	 * @throws Exception
	 */
	public void saveOrUpdateP6ResourceAssignmentToMCS(List<ResourceAssignmentExtends> ResourceAssignmentExtendss, UserToken user, String activity_object_id) throws Exception {
		List<ResourceAssignmentExtends> saveList = new ArrayList<ResourceAssignmentExtends>();
		List<ResourceAssignmentExtends> updateList = new ArrayList<ResourceAssignmentExtends>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("activity_object_id", activity_object_id);
		List<Map<String, Object>> allResourceAssignments = this.queryResourceAssignment(map);
		
		for (int i = 0; i < allResourceAssignments.size(); i++) {
			map = allResourceAssignments.get(i);
			int objectId = ((BigDecimal)map.get("object_id")).intValue();
			for (int j = 0; j < ResourceAssignmentExtendss.size(); j++) {
				ResourceAssignmentExtends r = ResourceAssignmentExtendss.get(j);
				int object_id = r.getResourceAssignment().getObjectId().intValue();
				
				if (object_id == objectId) {
					updateList.add(r);
					ResourceAssignmentExtendss.remove(j);
					j--;
					continue;
				}
			}
			
			if (ResourceAssignmentExtendss == null || ResourceAssignmentExtendss.size() == 0) {
				break;
			}
		}
		
		saveList = ResourceAssignmentExtendss;
		this.insertP6P6ResourceAssignmentToMCS(saveList, user);
		this.updateP6P6ResourceAssignmentToMCS(updateList, user);
	}
	
	private void insertP6P6ResourceAssignmentToMCS(final List<ResourceAssignmentExtends> ResourceAssignmentExtendss, final UserToken user) throws Exception {
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"PROJECT_ID","PROJECT_OBJECT_ID","ORG_ID","ORG_SUBJECTION_ID","ACTIVITY_ID","ACTIVITY_NAME","RESOURCE_NAME","RESOURCE_ID","PLANNED_START_DATE","PLANNED_FINISH_DATE","PLANNED_DURATION","BUDGETED_UNITS",
				"ACTUAL_START_DATE","ACTUAL_FINISH_DATE","ACTUAL_THIS_PERIOD_UNITS","ACTUAL_UNITS","REMAINING_UNITS","SUBMIT_FLAG","MODIFI_DATE","UPDATOR_ID","ACTIVITY_OBJECT_ID","RESOURCE_OBJECT_ID","RESOURCE_TYPE","CALENDAR_NAME",
				"CALENDAR_OBJECT_ID","START_DATE","FINISH_DATE","PLANNED_UNITS","BSFLAG","CREATOR_ID","CREATE_DATE","OBJECT_ID"};
		StringBuffer sql = new StringBuffer();
		sql.append("insert into bgp_p6_assign_mapping (");
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
					ResourceAssignmentExtends r = ResourceAssignmentExtendss.get(i);
					
					ps.setString(1, r.getResourceAssignment().getProjectId());
					ps.setInt(2, r.getResourceAssignment().getProjectObjectId().intValue());
					ps.setString(3, r.getOrgId());
					ps.setString(4, r.getOrgSubjectionId());
					ps.setString(5, r.getResourceAssignment().getActivityId());
					ps.setString(6, r.getResourceAssignment().getActivityName());
					ps.setString(7, r.getResourceAssignment().getResourceName());
					ps.setString(8, r.getResourceAssignment().getResourceId());
					
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					
					Time date = null;
					String dateString = P6TypeConvert.convert(r.getResourceAssignment().getPlannedStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(9, date);
					} else {
						ps.setTime(9, null);
					}
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getPlannedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(10, date);
					} else {
						ps.setTime(10, null);
					}
					
					ps.setDouble(11, r.getResourceAssignment().getPlannedDuration().getValue().doubleValue());
					ps.setDouble(12, r.getBudgetedUnits().doubleValue());
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getActualStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(13, date);
					} else {
						ps.setTime(13, null);
					}
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getActualFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(14, date);
					} else {
						ps.setTime(14, null);
					}
					
					ps.setDouble(15, r.getResourceAssignment().getActualThisPeriodUnits().getValue().doubleValue());
					ps.setDouble(16, r.getResourceAssignment().getActualUnits().getValue().doubleValue());
					ps.setDouble(17, r.getResourceAssignment().getRemainingDuration().getValue().doubleValue());
					ps.setString(18, r.getSubmitFlag());

					dateString = P6TypeConvert.convert(r.getResourceAssignment().getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(19, date);
					} else {
						ps.setTime(19, null);
					}
					
					ps.setString(20, r.getResourceAssignment().getLastUpdateUser());
					ps.setInt(21, r.getResourceAssignment().getActivityObjectId().intValue());
					ps.setInt(22, r.getResourceAssignment().getResourceObjectId().getValue().intValue());
					ps.setString(23, r.getResourceAssignment().getResourceType());
					ps.setString(24, r.getResourceAssignment().getCalendarName());
					ps.setInt(25, r.getResourceAssignment().getCalendarObjectId().getValue().intValue());
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(26, date);
					} else {
						ps.setTime(26, null);
					}
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(27, date);
					} else {
						ps.setTime(27, null);
					}
					
					ps.setDouble(28, r.getResourceAssignment().getPlannedUnits().getValue().doubleValue());
					ps.setString(29, "0");
					ps.setString(30, r.getResourceAssignment().getCreateUser());
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(31, date);
					} else {
						ps.setTime(31, null);
					}
					
					ps.setInt(32, r.getResourceAssignment().getObjectId().intValue());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			@Override
			public int getBatchSize() {
				return ResourceAssignmentExtendss.size();
			}
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	private void updateP6P6ResourceAssignmentToMCS(final List<ResourceAssignmentExtends> ResourceAssignmentExtendss, final UserToken user) throws Exception {
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"PROJECT_ID","PROJECT_OBJECT_ID","ORG_ID","ORG_SUBJECTION_ID","ACTIVITY_ID","ACTIVITY_NAME","RESOURCE_NAME","RESOURCE_ID","PLANNED_START_DATE","PLANNED_FINISH_DATE","PLANNED_DURATION","BUDGETED_UNITS",
				"ACTUAL_START_DATE","ACTUAL_FINISH_DATE","ACTUAL_THIS_PERIOD_UNITS","ACTUAL_UNITS","REMAINING_UNITS","SUBMIT_FLAG","MODIFI_DATE","UPDATOR_ID","ACTIVITY_OBJECT_ID","RESOURCE_OBJECT_ID","RESOURCE_TYPE","CALENDAR_NAME",
				"CALENDAR_OBJECT_ID","START_DATE","FINISH_DATE","PLANNED_UNITS","BSFLAG","CREATOR_ID","CREATE_DATE","OBJECT_ID"};

		StringBuffer sql = new StringBuffer();
		sql.append("update bgp_p6_assign_mapping set ");
		for (int i = 0; i < propertys.length-1; i++) {
			sql.append(propertys[i]).append("=?,");//其他值
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			
			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					ResourceAssignmentExtends r = ResourceAssignmentExtendss.get(i);
					
					ps.setString(1, r.getResourceAssignment().getProjectId());
					ps.setInt(2, r.getResourceAssignment().getProjectObjectId().intValue());
					ps.setString(3, r.getOrgId());
					ps.setString(4, r.getOrgSubjectionId());
					ps.setString(5, r.getResourceAssignment().getActivityId());
					ps.setString(6, r.getResourceAssignment().getActivityName());
					ps.setString(7, r.getResourceAssignment().getResourceName());
					ps.setString(8, r.getResourceAssignment().getResourceId());
					
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					Time date = null;
					String dateString = P6TypeConvert.convert(r.getResourceAssignment().getPlannedStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(9, date);
					} else {
						ps.setTime(9, null);
					}
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getPlannedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(10, date);
					} else {
						ps.setTime(10, null);
					}
					
					ps.setDouble(11, r.getResourceAssignment().getPlannedDuration().getValue().doubleValue());
					ps.setDouble(12, r.getBudgetedUnits().doubleValue());
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getActualStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(13, date);
					} else {
						ps.setTime(13, null);
					}
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getActualFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(14, date);
					} else {
						ps.setTime(14, null);
					}
					
					ps.setDouble(15, r.getResourceAssignment().getActualThisPeriodUnits().getValue().doubleValue());
					ps.setDouble(16, r.getResourceAssignment().getActualUnits().getValue().doubleValue());
					ps.setDouble(17, P6TypeConvert.convertDouble(r.getResourceAssignment().getRemainingUnits()));
					ps.setString(18, r.getSubmitFlag());

					dateString = P6TypeConvert.convert(r.getResourceAssignment().getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(19, date);
					} else {
						ps.setTime(19, null);
					}
					
					ps.setString(20, r.getResourceAssignment().getLastUpdateUser());
					ps.setInt(21, r.getResourceAssignment().getActivityObjectId().intValue());
					ps.setInt(22, r.getResourceAssignment().getResourceObjectId().getValue().intValue());
					ps.setString(23, r.getResourceAssignment().getResourceType());
					ps.setString(24, r.getResourceAssignment().getCalendarName());
					ps.setInt(25, r.getResourceAssignment().getCalendarObjectId().getValue().intValue());
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(26, date);
					} else {
						ps.setTime(26, null);
					}
					
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(27, date);
					} else {
						ps.setTime(27, null);
					}
					
					ps.setDouble(28, r.getResourceAssignment().getPlannedUnits().getValue().doubleValue());
					ps.setString(29, "0");
					ps.setString(30, r.getResourceAssignment().getCreateUser());
					dateString = P6TypeConvert.convert(r.getResourceAssignment().getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(31, date);
					} else {
						ps.setTime(31, null);
					}
					
					ps.setInt(32, r.getResourceAssignment().getObjectId().intValue());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			@Override
			public int getBatchSize() {
				return ResourceAssignmentExtendss.size();
			}
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 删除传入的资源分配信息
	 * @param ResourceAssignmentExtendss List<ResourceAssignmentExtends>
	 */
	public void deleteResourceAssignmentExtends(List<ResourceAssignmentExtends> ResourceAssignmentExtendss){
		String deleteSql = "delete from bgp_p6_assign_mapping where object_id = ?";
		
		deleteSql = "update bgp_p6_assign_mapping set bsflag = '1' where object_id = ?";
		
		for (int i = 0; i < ResourceAssignmentExtendss.size(); i++) {
			ResourceAssignmentExtends ResourceAssignmentExtends = ResourceAssignmentExtendss.get(i);
			radDao.getJdbcTemplate().update(deleteSql,new Object[ResourceAssignmentExtends.getResourceAssignment().getObjectId()]);
		}
	}
	
	public void submitDailyReport(Map<String,Object> map){
		Object projectInfoNo = map.get("projectInfoNo");
		//Object orgId = map.get("orgId");
		Object produceDate = map.get("produceDate");
		
		String update = "update bgp_p6_assign_mapping set submit_flag = '1',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"+projectInfoNo+"')  and bsflag = '0'";
		
		radDao.getJdbcTemplate().update(update);
		
		update = "update gp_ops_daily_report set audit_status = '1',submit_status = '2' where project_info_no = '"+projectInfoNo+"' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') and bsflag = '0'";
		
		radDao.getJdbcTemplate().update(update);
	}
	
	public void auditDailyReport(Map<String,Object> map){
		Object projectInfoNo = map.get("projectInfoNo");
		//Object orgId = map.get("orgId");
		Object produceDate = map.get("produceDate");
		Object audit_status = map.get("auditStatus");
		
		String update = "update gp_ops_daily_report set audit_status = '"+audit_status+"',submit_status = '2',last_update_date = sysdate where project_info_no = '"+projectInfoNo+"' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') and bsflag = '0'";
		update = "update bgp_p6_assign_mapping set submit_flag = '"+audit_status+"',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"+projectInfoNo+"') and bsflag = '0'";
		
		radDao.getJdbcTemplate().update(update);
		
		if("3" == audit_status || "3".equals(audit_status)){
			update = "update bgp_p6_activity set submit_flag = '"+audit_status+"',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"+projectInfoNo+"') and bsflag = '0' ";
			
			radDao.getJdbcTemplate().update(update);
		}

	}
	
	public List<Map<String,Object>> getMethodName(String id){
		
		String sql = "select * from bgp_p6_resource_mapping where RESOURCE_ID = '"+id+"'";
		
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		
		return list;
	}
	
	
	
	public static void main(String[] args) throws Exception {
		ResourceAssignmentExtends r = new ResourceAssignmentExtends();
		Field[] fields = r.getResourceAssignment().getClass().getDeclaredFields();
		for (int i = 0; i < fields.length; i++) {
			try {
				System.out.println(P6TypeConvert.propertyToField(fields[i].getName())+
						"   "+P6TypeConvert.getMethodName(fields[i].getName())+
						"   "+r.getResourceAssignment().getClass().getMethod(P6TypeConvert.getMethodName(fields[i].getName()), new Class[]{}).invoke(r.getResourceAssignment(), new Object[]{})+
						"   ");
			} catch (Exception e) {
				continue;
			}
		}
	}
	
}
