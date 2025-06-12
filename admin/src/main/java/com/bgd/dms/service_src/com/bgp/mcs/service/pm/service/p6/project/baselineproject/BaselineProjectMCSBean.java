package com.bgp.mcs.service.pm.service.p6.project.baselineproject;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.primavera.ws.p6.baselineproject.BaselineProject;

public class BaselineProjectMCSBean {
	
	IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao radDao;
	ILog log;
	
	public BaselineProjectMCSBean(){
		log = LogFactory.getLogger(BaselineProjectMCSBean.class);
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	}
	
	public List<Map<String, Object>> queryBaslineProject(Map<String, Object> map){
		
		Object object_id = map.get("object_id");//主键
		Object project_object_id = map.get("project_object_id");//对应的项目的主键
		
		String sql = "select t.* from bgp_p6_project t join gp_task_project tp ON t.PROJECT_INFO_NO=tp.PROJECT_INFO_NO AND tp.bsflag='0' and t.bsflag='0' AND tp.project_type<>'5000100004000000008' ";
		if (object_id != null) {
			sql = sql +" and t.object_id = '"+object_id.toString()+"'";
		}
		if (project_object_id != null) {
			sql = sql +" and t.project_object_id = '"+project_object_id.toString()+"'";
		}
		
		log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		
		return list;
	}
	
	public void saveOrUpdateBaselineProjectToMCS(List<BaselineProject> list, UserToken user, String projectObjectId){
		List<BaselineProject> saveList = new ArrayList<BaselineProject>();
		List<BaselineProject> updateList = new ArrayList<BaselineProject>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("project_object_id", projectObjectId);
		
		List<Map<String, Object>> allProject = this.queryBaslineProject(map);
		
		for (int i = 0; i < allProject.size(); i++) {
			map = allProject.get(i);
			int objectId = ((BigDecimal)map.get("object_id")).intValue();
			for (int j = 0; j < list.size(); j++) {
				BaselineProject r = list.get(j);
				int object_id = r.getObjectId();
				
				if (object_id == objectId) {
					updateList.add(r);
					list.remove(j);
					j--;
					continue;
				}
			}
			
			if (list == null || list.size() == 0) {
				break;
			}
			
		}
		
		saveList = list;
		this.insertBaselineProjectToMCS(saveList, user);
		this.updateBaselineProjectToMCS(updateList, user);
	}
	
	public boolean deleteBaselineProjectToMCS(List<Integer> baseLineProjectIds){
		boolean flag = false;
		StringBuffer sql = new StringBuffer();
		sql.append("delete from bgp_p6_project where OBJECT_ID in(");
		for(int i=0;i<baseLineProjectIds.size();i++){
			int objectId =baseLineProjectIds.get(i);
			sql.append(objectId);
			if(i<baseLineProjectIds.size()-1){		
				sql.append(",");
			}

		}
		sql.append(")");
		int result = radDao.executeUpdate(sql.toString());
			if(result==0){
				flag=true;
			}
		return flag;
	}
	private void insertBaselineProjectToMCS(final List<BaselineProject> list, final UserToken user){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"project_id","project_name","obs_object_id","obs_name","status","wbs_object_id","state_date","finish_date","project_info_no","bsflag","modifi_date","creator_id","create_date","updator_id","project_object_id","object_id"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into bgp_p6_project (");
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
				BaselineProject b = list.get(i);
				try {
					ps.setString(1, b.getId());
					ps.setString(2, b.getName());
					ps.setInt(3, b.getOBSObjectId().intValue());
					ps.setString(4, b.getOBSName());
					ps.setString(5, b.getStatus());
					ps.setInt(6, b.getWBSObjectId().getValue());
					ps.setDate(7, null);
					ps.setDate(8, null);
					ps.setString(9, null);//目标项目无gms中的项目主键
					ps.setString(10, "0");
					
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					
					Time date = null;
					String dateString;
					dateString = P6TypeConvert.convert(b.getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(11, date);
					} else {
						ps.setTime(11, null);
					}
					
					ps.setString(12, user.getEmpId());
					
					dateString = P6TypeConvert.convert(b.getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(13, date);
					} else {
						ps.setTime(13, null);
					}
					
					ps.setString(14, user.getEmpId());
					ps.setInt(15, b.getOriginalProjectObjectId().getValue());
					ps.setInt(16, b.getObjectId());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	private void updateBaselineProjectToMCS(final List<BaselineProject> list, final UserToken user){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"project_id","project_name","obs_object_id","obs_name","status","wbs_object_id","state_date","finish_date","project_info_no","bsflag","modifi_date","creator_id","create_date","updator_id","project_object_id","object_id"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("update bgp_p6_project set ");
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
				BaselineProject b = list.get(i);
				try {
					ps.setString(1, b.getId());
					ps.setString(2, b.getName());
					ps.setInt(3, b.getOBSObjectId().intValue());
					ps.setString(4, b.getOBSName());
					ps.setString(5, b.getStatus());
					ps.setInt(6, b.getWBSObjectId().getValue());
					ps.setDate(7, null);
					ps.setDate(8, null);
					ps.setString(9, null);//目标项目无gms中的项目主键
					ps.setString(10, "0");
					
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					
					Time date = null;
					String dateString;
						dateString = P6TypeConvert.convert(b.getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(11, date);
					} else {
						ps.setTime(11, null);
					}
					
					ps.setString(12, user.getEmpId());
					
					dateString = P6TypeConvert.convert(b.getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(13, date);
					} else {
						ps.setTime(13, null);
					}
					
					ps.setString(14, user.getEmpId());
					ps.setInt(15, b.getOriginalProjectObjectId().getValue());
					ps.setInt(16, b.getObjectId());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
		
	}
}
