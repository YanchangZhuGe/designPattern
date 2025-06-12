package com.bgp.mcs.service.pm.service.p6.activity;

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

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.primavera.ws.p6.activity.ActivityExtends;

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
public class ActivityMCSBean {
	
	private ILog log;
	private RADJdbcDao radDao;
	
	public ActivityMCSBean() {
		log = LogFactory.getLogger(ActivityMCSBean.class);
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	}
	
	/**
	 * 查询所有任务
	 * @return List<Map<String,Object>>
	 */
	public List<Map<String,Object>> queryActivityFromMCS(Map<String,Object> map){
		Object object_id = map.get("object_id");
		Object project_object_id = map.get("project_id");
		Object last_update_date = map.get("last_update_date");
		Object submit_flag = map.get("submit_flag");
		String sql = "select distinct pa.*,pc.hours_per_day,case status when 'Not Started' then '未开始' when 'In Progress' then '运行' when 'Completed' then '结束' else '' end as status_name " +
				"from bgp_p6_activity pa left join bgp_p6_calendar pc " +
				"on pc.object_id = pa.calendar_object_id " +
				"where 1=1 and pa.bsflag = '0' ";
		if (project_object_id != null) {
			sql = sql +" and pa.project_object_id = '"+project_object_id+"'";
		}
		if (submit_flag != null) {
			sql = sql +" and pa.submit_flag = '"+submit_flag+"'";
		}
		if (object_id != null) {
			sql = sql +" and pa.object_id = '"+object_id+"'";
		}
		if (last_update_date != null) {
			//从GMS同步到P6 记录个时间为a 从P6同步到GMS 记录个时间为b 然后将GMS中受影响的修改时间设置为b 然后每隔10分钟 查询GMS中修改时间大于时间a的记录然后继续同步到P6中,这样会造成
			//GMS与P6来回同步，进而造成P6数据还原，未想到良好解决办法，暂时让时间点b比较时候默认加1分钟
			sql = sql +" and pa.modifi_date >= (to_date('"+last_update_date+"','yyyy-MM-dd hh24:mi:ss')+1/24/60)";
		}
		sql += " order by pa.object_id desc";
		System.out.println("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	public List<Map<String,Object>> queryActivityFrom(Map<String,Object> map){
		Object object_id = map.get("object_id");
		Object project_object_id = map.get("project_id");
		Object last_update_date = map.get("last_update_date");
		Object submit_flag = map.get("submit_flag");
		String sql = "select distinct pa.*,pc.hours_per_day,case status when 'Not Started' then '未开始' when 'In Progress' then '运行' when 'Completed' then '结束' else '' end as status_name " +
				"from bgp_p6_activity pa left join bgp_p6_calendar pc " +
				"on pc.object_id = pa.calendar_object_id " +
				"where 1=1 and pa.bsflag = '0' ";
		if (project_object_id != null) {
			sql = sql +" and pa.project_id= '"+project_object_id+"'";
		}
		if (submit_flag != null) {
			sql = sql +" and pa.submit_flag = '"+submit_flag+"'";
		}
		if (object_id != null) {
			sql = sql +" and pa.object_id = '"+object_id+"'";
		}
		if (last_update_date != null) {
			//从GMS同步到P6 记录个时间为a 从P6同步到GMS 记录个时间为b 然后将GMS中受影响的修改时间设置为b 然后每隔10分钟 查询GMS中修改时间大于时间a的记录然后继续同步到P6中,这样会造成
			//GMS与P6来回同步，进而造成P6数据还原，未想到良好解决办法，暂时让时间点b比较时候默认加1分钟
			sql = sql +" and pa.modifi_date >= (to_date('"+last_update_date+"','yyyy-MM-dd hh24:mi:ss')+1/24/60)";
		}
		sql += " order by pa.object_id desc";
		System.out.println("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	
	
	
	/**
	 * 保存作业到MCS中 方法不能保证大批量数据 因此放弃
	 * @param activitys
	 * @param user
	 * @throws Exception
	 */
	@Deprecated
	public void saveP6ActivityToMCS(List<ActivityExtends> activitys, UserToken user) throws Exception{
		Map<String, Object> map = null;
		
		for (int i = 0; i < activitys.size(); i++) {
			ActivityExtends a = activitys.get(i);
			map = new HashMap<String, Object>();
			
			Field[] fields = a.getActivity().getClass().getDeclaredFields();
			map.put("submit_flag", a.getSubmitFlag());
			
			for (int j = 0; j < fields.length; j++) {
				try {
					map.put(P6TypeConvert.propertyToField(fields[j].getName()), P6TypeConvert.convert(a.getActivity().getClass().getMethod(P6TypeConvert.getMethodName(fields[j].getName()), new Class[]{}).invoke(a.getActivity(), new Object[]{})));
				} catch (Exception e) {
					continue;
				}
			}
			
			//a.getActivity().getPercentComplete();
			map.put("bsflag", "0");
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_P6_ACTIVITY");
		}
	}
	
	private void insertP6ActivityToMCS(final List<ActivityExtends> activitys, final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"ACTUAL_FINISH_DATE","ACTUAL_START_DATE","ID","NAME",
				"PLANNED_FINISH_DATE","PLANNED_START_DATE","PROJECT_ID","PROJECT_NAME",
				"PROJECT_OBJECT_ID","STATUS","WBS_CODE","WBS_NAME","WBS_OBJECT_ID","SUSPEND_DATE",
				"RESUME_DATE","NOTES_TO_RESOURCES","OBJECT_ID","EXPECTED_FINISH_DATE","PLANNED_DURATION",
				"FINISH_DATE","START_DATE","MODIFI_DATE","UPDATOR_ID","REMAINING_DURATION","BSFLAG","CALENDAR_NAME",
				"CALENDAR_OBJECT_ID","SUBMIT_FLAG","CREATOR_ID","CREATE_DATE","PERCENT_COMPLETE"};
		
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
					ActivityExtends a = activitys.get(i);
					java.sql.Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					String dateString = P6TypeConvert.convert(a.getActivity().getActualFinishDate(), "yyyy-MM-dd hh:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(1, date);
					} else {
						ps.setTime(1, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getActualStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(2, date);
					} else {
						ps.setTime(2, null);
					}
					
					ps.setString(3, a.getActivity().getId());
					ps.setString(4, a.getActivity().getName());

					dateString = P6TypeConvert.convert(a.getActivity().getPlannedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(5, date);
					} else {
						ps.setTime(5, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getPlannedStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(6, date);
					} else {
						ps.setTime(6, null);
					}
					
					ps.setString(7, a.getActivity().getProjectId());
					ps.setString(8, a.getActivity().getProjectName());
					ps.setInt(9, a.getActivity().getProjectObjectId().intValue());
					ps.setString(10, a.getActivity().getStatus());
					ps.setString(11, a.getActivity().getWBSCode());
					ps.setString(12, a.getActivity().getWBSName());
					ps.setInt(13, a.getActivity().getWBSObjectId().getValue().intValue());
					
					dateString = P6TypeConvert.convert(a.getActivity().getSuspendDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(14, date);
					} else {
						ps.setTime(14, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getResumeDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(15, date);
					} else {
						ps.setTime(15, null);
					}
					
					ps.setString(16, a.getActivity().getNotesToResources());
					ps.setInt(17, a.getActivity().getObjectId().intValue());

					dateString = P6TypeConvert.convert(a.getActivity().getExpectedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(18, date);
					} else {
						ps.setTime(18, null);
					}
					
					ps.setDouble(19, a.getActivity().getPlannedDuration().doubleValue());

					dateString = P6TypeConvert.convert(a.getActivity().getFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(20, date);
					} else {
						ps.setTime(20, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(21, date);
					} else {
						ps.setTime(21, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(22, date);
					} else {
						ps.setTime(22, null);
					}
					
					ps.setString(23, user.getEmpId());
					ps.setDouble(24, a.getActivity().getRemainingDuration().getValue().doubleValue());
					ps.setString(25, "0");
					ps.setString(26, a.getActivity().getCalendarName());
					ps.setInt(27, a.getActivity().getCalendarObjectId().intValue());
					if (a.getSubmitFlag() != null || "".equals(a.getSubmitFlag())) {
						if(a.getSubmitFlag() == "6" || "6".equals(a.getSubmitFlag())){
							ps.setString(28, "5");
						}else{
							ps.setString(28, a.getSubmitFlag());
						}
					} else {
						ps.setString(28, "0");
					}
					ps.setString(29, user.getEmpId());
					
					dateString = P6TypeConvert.convert(a.getActivity().getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(30, date);
					} else {
						ps.setTime(30, null);
					}
					
					ps.setDouble(31, a.getActivity().getPercentComplete().getValue().doubleValue());
					
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return activitys.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	private void updateP6ActivityToMCS(final List<ActivityExtends> activitys, final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"ACTUAL_FINISH_DATE","ACTUAL_START_DATE","ID","NAME",
				"PLANNED_FINISH_DATE","PLANNED_START_DATE","PROJECT_ID","PROJECT_NAME",
				"PROJECT_OBJECT_ID","STATUS","WBS_CODE","WBS_NAME","WBS_OBJECT_ID","SUSPEND_DATE",
				"RESUME_DATE","NOTES_TO_RESOURCES","EXPECTED_FINISH_DATE","PLANNED_DURATION",
				"FINISH_DATE","START_DATE","UPDATOR_ID","REMAINING_DURATION","BSFLAG","CALENDAR_NAME",
				"CALENDAR_OBJECT_ID","SUBMIT_FLAG","CREATOR_ID","CREATE_DATE","PERCENT_COMPLETE","OBJECT_ID"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("update bgp_p6_activity set MODIFI_DATE = sysdate, ");
		for (int i = 0; i < propertys.length-1; i++) {
				sql.append(propertys[i]).append("=?,");//其他值
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
		log.info("in updateP6ActivityToMCS @ 353 ------------sql:"+sql);
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					ActivityExtends a = activitys.get(i);
					java.sql.Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					String dateString = P6TypeConvert.convert(a.getActivity().getActualFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(1, date);
						log.info("1--"+dateString);
					} else {
						ps.setTime(1, null);
						log.info("1--null");
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getActualStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(2, date);
						log.info("2--"+dateString);
					} else {
						ps.setTime(2, null);
						log.info("2--null");
					}
					
					ps.setString(3, a.getActivity().getId());
					log.info("3--"+a.getActivity().getId());
					ps.setString(4, a.getActivity().getName());
					log.info("4--"+a.getActivity().getName());
					dateString = P6TypeConvert.convert(a.getActivity().getPlannedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(5, date);
						log.info("5--"+dateString);
					} else {
						ps.setTime(5, null);
						log.info("5--null");
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getPlannedStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(6, date);
						log.info("6--"+dateString);
					} else {
						ps.setTime(6, null);
						log.info("6--null");
					}
					
					ps.setString(7, a.getActivity().getProjectId());
					log.info("7--"+a.getActivity().getProjectId());
					ps.setString(8, a.getActivity().getProjectName());
					log.info("8--"+a.getActivity().getProjectName());
					ps.setInt(9, a.getActivity().getProjectObjectId().intValue());
					log.info("9--"+a.getActivity().getProjectObjectId().intValue());
					ps.setString(10, a.getActivity().getStatus());
					log.info("10--"+a.getActivity().getStatus());
					ps.setString(11, a.getActivity().getWBSCode());
					log.info("11--"+a.getActivity().getWBSCode());
					ps.setString(12, a.getActivity().getWBSName());
					log.info("12--"+a.getActivity().getWBSName());
					ps.setInt(13, a.getActivity().getWBSObjectId().getValue().intValue());
					log.info("13--"+a.getActivity().getWBSObjectId().getValue().intValue());
					dateString = P6TypeConvert.convert(a.getActivity().getSuspendDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(14, date);
						log.info("14--"+dateString);
					} else {
						ps.setTime(14, null);
						log.info("14--null");
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getResumeDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(15, date);
						log.info("15--"+dateString);
					} else {
						ps.setTime(15, null);
						log.info("15--null");
					}
					
					ps.setString(16, a.getActivity().getNotesToResources());
					log.info("16--"+a.getActivity().getNotesToResources());
					dateString = P6TypeConvert.convert(a.getActivity().getExpectedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(17, date);
						log.info("17--"+dateString);
					} else {
						ps.setTime(17, null);
						log.info("17--null");
					}
					
					ps.setDouble(18, a.getActivity().getPlannedDuration().doubleValue());
					log.info("18--"+ a.getActivity().getPlannedDuration().doubleValue());
					dateString = P6TypeConvert.convert(a.getActivity().getFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(19, date);
						log.info("19--"+dateString);
					} else {
						ps.setTime(19, null);
						log.info("19--null)");
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(20, date);
						log.info("20--"+dateString);
					} else {
						ps.setTime(20, null);
						log.info("20--null");
					}
					
//					dateString = P6TypeConvert.convert(a.getActivity().getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
//					if (dateString != null && !"".equals(dateString)) {
//						date = new Time(f.parse(dateString).getTime());
//						ps.setTime(21, date);
//					} else {
//						ps.setTime(21, null);
//					}
					
					ps.setString(21, user.getEmpId());
					log.info("21--"+user.getEmpId());
					ps.setDouble(22, a.getActivity().getRemainingDuration().getValue().doubleValue());
					log.info("22--"+a.getActivity().getRemainingDuration().getValue().doubleValue());
					ps.setString(23, "0");
					log.info("23--0)");
					ps.setString(24, a.getActivity().getCalendarName());
					log.info("24--"+a.getActivity().getCalendarName());
					ps.setInt(25, a.getActivity().getCalendarObjectId().intValue());
					log.info("25--"+a.getActivity().getCalendarObjectId().intValue());
					if (a.getSubmitFlag() != null || "".equals(a.getSubmitFlag())) {
						if(a.getSubmitFlag() == "6" || "6".equals(a.getSubmitFlag())){
							ps.setString(26, "5");
							log.info("26--5");
						}else{
							ps.setString(26, a.getSubmitFlag());
							log.info("26--"+a.getSubmitFlag());
						}
					} else {
						ps.setString(26, "0");
						log.info("26--0");
					}
					ps.setString(27, user.getEmpId());
					log.info("27--"+user.getEmpId());
					dateString = P6TypeConvert.convert(a.getActivity().getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(28, date);
						log.info("28--"+dateString);
					} else {
						ps.setTime(28, null);
						log.info("28--null");
					}
					
					ps.setDouble(29, P6TypeConvert.convertDouble(a.getActivity().getPercentComplete()));
					log.info("29--"+P6TypeConvert.convertDouble(a.getActivity().getPercentComplete()));
					ps.setInt(30, a.getActivity().getObjectId().intValue());
					log.info("30--"+a.getActivity().getObjectId().intValue());
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return activitys.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 保存作业到MCS中
	 * @param activitys
	 * @param user
	 * @throws Exception
	 */
	public void saveOrUpdateP6ActivityToMCS(List<ActivityExtends> activitys, UserToken user) throws Exception{
		
		List<ActivityExtends> saveList = new ArrayList<ActivityExtends>();
		List<ActivityExtends> updateList = new ArrayList<ActivityExtends>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		if (activitys == null || activitys.size() == 0) {
			
		} else {
			List<Map<String, Object>> Allactivity = this.queryActivityFromMCS(new HashMap());
			for (int i = 0; i < Allactivity.size(); i++) {
				map = Allactivity.get(i);
				int objectId = ((BigDecimal)map.get("object_id")).intValue();
				String submit_flag = (String) map.get("submit_flag");
				
				for (int j = 0; j < activitys.size(); j++) {
					ActivityExtends a = activitys.get(j);
					int object_id = a.getActivity().getObjectId().intValue();
					
					if (object_id == objectId) { 
						// 如果某条作业从p6传过来，在gms中找到其对应数据，如果gms中的该条作业状态为5，则可以被重写.
						if(a.getSubmitFlag() == "6" || "6".equals(a.getSubmitFlag())){
							//submit_flag = 6 表示从p6传来的数据
							if (submit_flag == "5" || "5".equals(submit_flag)) {
								//5为可被p6同步状态
								updateList.add(a);
							}
						}else {
							//如果该任务状态不为5 则不修改
						}
						
						/*20130807备份 
						 * if (submit_flag == "5" || "5".equals(submit_flag)) {
							//5为可被p6同步状态
							updateList.add(a);
						}else if(a.getSubmitFlag() == "6" || "6".equals(a.getSubmitFlag())||submit_flag == "6" ||"6".equals(submit_flag)){
							//submit_flag = 6 表示从p6传来的数据
							updateList.add(a);
						}						
						else {
							//如果该任务状态不为5 则不修改
						}
						*/
						activitys.remove(j);
						j--;
						continue;
					}
				}
				
				if (activitys == null || activitys.size() == 0) {
					break;
				}
				
			}
		}
		
		saveList = activitys;
		this.insertP6ActivityToMCS(saveList, user);
		this.updateP6ActivityToMCS(updateList, user);
	}
	
	
	/**
	 * 保存作业到MCS中
	 * @param activitys
	 * @param user
	 * @throws Exception
	 */
	public void saveOrUpdateP6ActivityToMCSByProjectId(List<ActivityExtends> activitys,String projectObjectId, UserToken user) throws Exception{
		
		List<ActivityExtends> saveList = new ArrayList<ActivityExtends>();
		List<ActivityExtends> updateList = new ArrayList<ActivityExtends>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("project_object_id", projectObjectId);
		if (activitys == null || activitys.size() == 0) {
			
		} else {
			List<Map<String, Object>> Allactivity = this.queryActivityFromMCS(map);
			for (int i = 0; i < Allactivity.size(); i++) {
				map = Allactivity.get(i);
				int objectId = ((BigDecimal)map.get("object_id")).intValue();
				String submit_flag = (String) map.get("submit_flag");
				
				for (int j = 0; j < activitys.size(); j++) {
					ActivityExtends a = activitys.get(j);
					int object_id = a.getActivity().getObjectId().intValue();
					
					if (object_id == objectId) { 
						if (a.getSubmitFlag() == "5" || "5".equals(a.getSubmitFlag()) || submit_flag == "5" || "5".equals(submit_flag)) {
							//5为可被p6同步状态
							updateList.add(a);
						}						
						else {
							//如果该任务状态不为5 则不修改
						}
						activitys.remove(j);
						j--;
						continue;
					}
				}
				
				if (activitys == null || activitys.size() == 0) {
					break;
				}
				
			}
		}
		
		saveList = activitys;
		this.insertP6ActivityToMCS(saveList, user);
		this.updateP6ActivityToMCS(updateList, user);
	}
	
	/**
	 * 保存作业到MCS中
	 * @param activitys
	 * @param user
	 * @throws Exception
	 */
	public void saveOrUpdateP6ActivityToMCS(List<ActivityExtends> activitys, UserToken user, String projectObjectId) throws Exception{
		
		List<ActivityExtends> saveList = new ArrayList<ActivityExtends>();
		List<ActivityExtends> updateList = new ArrayList<ActivityExtends>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("project_id", projectObjectId);
		List<Map<String, Object>> Allactivity = this.queryActivityFromMCS(map);
		for (int i = 0; i < Allactivity.size(); i++) {
			map = Allactivity.get(i);
			int objectId = ((BigDecimal)map.get("object_id")).intValue();
			for (int j = 0; j < activitys.size(); j++) {
				ActivityExtends a = activitys.get(j);
				int object_id = a.getActivity().getObjectId().intValue();
				
				if (object_id == objectId) {
					updateList.add(a);
					activitys.remove(j);
					j--;
					continue;
				}
			}
			
			if (activitys == null || activitys.size() == 0) {
				break;
			}
			
		}
		
		saveList = activitys;
		//this.insertP6ActivityToMCS(saveList, user);
		//this.updateP6ActivityToMCS(updateList, user);
		//保存作业的同时也修改状态submit_flag=3 不能被p6同步,只能同步到P6中
		this.insertP6ActivityToMCSwithFlag(saveList, user);
		this.updateP6ActivityToMCSwithFlag(updateList, user);
	}
public void saveOrUpdateP6Activity(List<ActivityExtends> activitys, UserToken user, String projectObjectId) throws Exception{
		
		List<ActivityExtends> saveList = new ArrayList<ActivityExtends>();
		List<ActivityExtends> updateList = new ArrayList<ActivityExtends>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("project_id", projectObjectId);
		List<Map<String, Object>> Allactivity = this.queryActivityFrom(map);
		for (int i = 0; i < Allactivity.size(); i++) {
			map = Allactivity.get(i);
			int objectId = ((BigDecimal)map.get("object_id")).intValue();
			for (int j = 0; j < activitys.size(); j++) {
				ActivityExtends a = activitys.get(j);
				int object_id = a.getActivity().getObjectId().intValue();
				
				if (object_id == objectId) {
					updateList.add(a);
					activitys.remove(j);
					j--;
					continue;
				}
			}
			
			if (activitys == null || activitys.size() == 0) {
				break;
			}
			
		}
		
		saveList = activitys;
		//this.insertP6ActivityToMCS(saveList, user);
		//this.updateP6ActivityToMCS(updateList, user);
		//保存作业的同时也修改状态submit_flag=3 不能被p6同步,只能同步到P6中
		this.insertP6ActivityToMCSwithFlag(saveList, user);
		this.updateP6ActivityToMCSwithFlag(updateList, user);
	}
	/**
	 * 删除传入的作业
	 * @param activitys List<Activity>
	 */
	public void deleteActivity(List<ActivityExtends> activitys){
		String deleteSql = "delete from bgp_p6_activity where object_id = ?";
		
		deleteSql = "update bgp_p6_activity set bsflag = '1' where object_id = ?";
		
		for (int i = 0; i < activitys.size(); i++) {
			ActivityExtends activity = activitys.get(i);
			radDao.getJdbcTemplate().update(deleteSql,activity.getActivity().getObjectId());
		}
	}
	
	/**
	 * 保存作业到MCS中并修改submit_flag
	 * @param activitys
	 * @param user
	 * @throws Exception
	 */
	private void insertP6ActivityToMCSwithFlag(final List<ActivityExtends> activitys, final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"ACTUAL_FINISH_DATE","ACTUAL_START_DATE","ID","NAME",
				"PLANNED_FINISH_DATE","PLANNED_START_DATE","PROJECT_ID","PROJECT_NAME",
				"PROJECT_OBJECT_ID","STATUS","WBS_CODE","WBS_NAME","WBS_OBJECT_ID","SUSPEND_DATE",
				"RESUME_DATE","NOTES_TO_RESOURCES","OBJECT_ID","EXPECTED_FINISH_DATE","PLANNED_DURATION",
				"FINISH_DATE","START_DATE","MODIFI_DATE","UPDATOR_ID","REMAINING_DURATION","BSFLAG","CALENDAR_NAME",
				"CALENDAR_OBJECT_ID","SUBMIT_FLAG","CREATOR_ID","CREATE_DATE","PERCENT_COMPLETE"};
		
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
					ActivityExtends a = activitys.get(i);
					java.sql.Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					String dateString = P6TypeConvert.convert(a.getActivity().getActualFinishDate(), "yyyy-MM-dd hh:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(1, date);
					} else {
						ps.setTime(1, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getActualStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(2, date);
					} else {
						ps.setTime(2, null);
					}
					
					ps.setString(3, a.getActivity().getId());
					ps.setString(4, a.getActivity().getName());

					dateString = P6TypeConvert.convert(a.getActivity().getPlannedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(5, date);
					} else {
						ps.setTime(5, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getPlannedStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(6, date);
					} else {
						ps.setTime(6, null);
					}
					
					ps.setString(7, a.getActivity().getProjectId());
					ps.setString(8, a.getActivity().getProjectName());
					ps.setInt(9, a.getActivity().getProjectObjectId().intValue());
					ps.setString(10, a.getActivity().getStatus());
					ps.setString(11, a.getActivity().getWBSCode());
					ps.setString(12, a.getActivity().getWBSName());
					ps.setInt(13, a.getActivity().getWBSObjectId().getValue().intValue());
					
					dateString = P6TypeConvert.convert(a.getActivity().getSuspendDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(14, date);
					} else {
						ps.setTime(14, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getResumeDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(15, date);
					} else {
						ps.setTime(15, null);
					}
					
					ps.setString(16, a.getActivity().getNotesToResources());
					ps.setInt(17, a.getActivity().getObjectId().intValue());

					dateString = P6TypeConvert.convert(a.getActivity().getExpectedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(18, date);
					} else {
						ps.setTime(18, null);
					}
					
					ps.setDouble(19, a.getActivity().getPlannedDuration().doubleValue());

					dateString = P6TypeConvert.convert(a.getActivity().getFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(20, date);
					} else {
						ps.setTime(20, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(21, date);
					} else {
						ps.setTime(21, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(22, date);
					} else {
						ps.setTime(22, null);
					}
					
					ps.setString(23, user.getEmpId());
					ps.setDouble(24, a.getActivity().getRemainingDuration().getValue().doubleValue());
					ps.setString(25, "0");
					ps.setString(26, a.getActivity().getCalendarName());
					ps.setInt(27, a.getActivity().getCalendarObjectId().intValue());
					ps.setString(28, "3");
					ps.setString(29, user.getEmpId());
					
					dateString = P6TypeConvert.convert(a.getActivity().getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(30, date);
					} else {
						ps.setTime(30, null);
					}
					
					ps.setDouble(31, a.getActivity().getPercentComplete().getValue().doubleValue());
					
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return activitys.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 修改作业到MCS中并修改submit_flag
	 * @param activitys
	 * @param user
	 * @throws Exception
	 */
	private void updateP6ActivityToMCSwithFlag(final List<ActivityExtends> activitys, final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"ACTUAL_FINISH_DATE","ACTUAL_START_DATE","ID","NAME",
				"PLANNED_FINISH_DATE","PLANNED_START_DATE","PROJECT_ID","PROJECT_NAME",
				"PROJECT_OBJECT_ID","STATUS","WBS_CODE","WBS_NAME","WBS_OBJECT_ID","SUSPEND_DATE",
				"RESUME_DATE","NOTES_TO_RESOURCES","EXPECTED_FINISH_DATE","PLANNED_DURATION",
				"FINISH_DATE","START_DATE","UPDATOR_ID","REMAINING_DURATION","BSFLAG","CALENDAR_NAME",
				"CALENDAR_OBJECT_ID","SUBMIT_FLAG","CREATOR_ID","CREATE_DATE","PERCENT_COMPLETE","OBJECT_ID"};
		
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
					ActivityExtends a = activitys.get(i);
					java.sql.Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					String dateString = P6TypeConvert.convert(a.getActivity().getActualFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(1, date);
					} else {
						ps.setTime(1, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getActualStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(2, date);
					} else {
						ps.setTime(2, null);
					}
					
					ps.setString(3, a.getActivity().getId());
					ps.setString(4, a.getActivity().getName());

					dateString = P6TypeConvert.convert(a.getActivity().getPlannedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(5, date);
					} else {
						ps.setTime(5, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getPlannedStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(6, date);
					} else {
						ps.setTime(6, null);
					}
					
					ps.setString(7, a.getActivity().getProjectId());
					ps.setString(8, a.getActivity().getProjectName());
					ps.setInt(9, a.getActivity().getProjectObjectId().intValue());
					ps.setString(10, a.getActivity().getStatus());
					ps.setString(11, a.getActivity().getWBSCode());
					ps.setString(12, a.getActivity().getWBSName());
					ps.setInt(13, a.getActivity().getWBSObjectId().getValue().intValue());
					
					dateString = P6TypeConvert.convert(a.getActivity().getSuspendDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(14, date);
					} else {
						ps.setTime(14, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getResumeDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(15, date);
					} else {
						ps.setTime(15, null);
					}
					
					ps.setString(16, a.getActivity().getNotesToResources());

					dateString = P6TypeConvert.convert(a.getActivity().getExpectedFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(17, date);
					} else {
						ps.setTime(17, null);
					}
					
					ps.setDouble(18, a.getActivity().getPlannedDuration().doubleValue());

					dateString = P6TypeConvert.convert(a.getActivity().getFinishDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(19, date);
					} else {
						ps.setTime(19, null);
					}
					
					dateString = P6TypeConvert.convert(a.getActivity().getStartDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(20, date);
					} else {
						ps.setTime(20, null);
					}
					
					ps.setString(21, user.getEmpId());
					ps.setDouble(22, a.getActivity().getRemainingDuration().getValue().doubleValue());
					ps.setString(23, "0");
					ps.setString(24, a.getActivity().getCalendarName());
					ps.setInt(25, a.getActivity().getCalendarObjectId().intValue());
					ps.setString(26, "3");					
					ps.setString(27, user.getEmpId());
					
					dateString = P6TypeConvert.convert(a.getActivity().getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(28, date);
					} else {
						ps.setTime(28, null);
					}
					
					ps.setDouble(29, P6TypeConvert.convertDouble(a.getActivity().getPercentComplete()));
					ps.setInt(30, a.getActivity().getObjectId().intValue());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return activitys.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	public static void main(String[] args) {
//		ActivityMCSBean a = new ActivityMCSBean(); 
//		Map map = new HashMap();
//		map.put("submit_flag", "3");
//		map.put("last_update_date", "2012-03-01 00:00:00");
//		a.queryActivityFromMCS(map);
		
		ActivityExtends a = new ActivityExtends();
		Field[] fields = a.getActivity().getClass().getDeclaredFields();
		
		for (int i = 0; i < fields.length; i++) {
			try {
				System.out.println(P6TypeConvert.propertyToField(fields[i].getName())+
						"   "+P6TypeConvert.getMethodName(fields[i].getName())+
						"   ");
			} catch (Exception e) {
				continue;
			}
		}
	}
}
