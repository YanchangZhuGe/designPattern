package com.bgp.mcs.service.pm.service.p6.wbs;

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
import com.primavera.ws.p6.wbs.WBS;

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
public class WbsMCSBean {
	
	private ILog log;
	private RADJdbcDao radDao;
	
	public WbsMCSBean() {
		log = LogFactory.getLogger(WbsMCSBean.class);
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	}
	
	/**
	 * 从MCS系统中间表中查询wbs数据
	 * @param 
	 * @return
	 */
	public List<Map<String, Object>> queryWbsFromMCS(Map map){
		Object bsflag = map.get("bsflag");
		String sql = "select * from bgp_p6_project_wbs where 1=1 ";
		
		if (bsflag != null) {
			sql = sql + " and bsflag = '"+bsflag+"' ";
		}
		
		sql = sql + " order by object_id desc ";
		List list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	
	/**
	 * 把wbs保存到MCS系统当中
	 * @param wbss List<WBS>
	 * @throws Exception 
	 */
	@Deprecated
	public void saveP6WbsToMcs(List<WBS> wbss) throws Exception{
		
		String insertSql = "insert into bgp_p6_project_wbs (project_id,wbs_name,wbs_short_name,sequence_number,obs_name,obs_id,parent_wbs_id,modifi_date,object_id,bsflag) values (?,?,?,?,?,?,?,?,?,'0')";
		String updateSql = "update bgp_p6_project_wbs set project_id=?,wbs_name=?,wbs_short_name=?,sequence_number=?,obs_name=?,obs_id=?,parent_wbs_id=?,modifi_date=?,bsflag = '0' where object_id = ?";
		
		int[] types = new int[]{Types.INTEGER,Types.VARCHAR,Types.VARCHAR,Types.INTEGER,Types.VARCHAR,Types.INTEGER,Types.INTEGER,Types.DATE,Types.INTEGER};
		
		for (int i = 0; i < wbss.size(); i++) {
			WBS wbs = wbss.get(i);
			Object[] params = new Object[]{wbs.getProjectObjectId(),wbs.getName(),wbs.getCode(),wbs.getSequenceNumber(),wbs.getOBSName(),wbs.getOBSObjectId(),wbs.getParentObjectId().getValue(),P6TypeConvert.convert(wbs.getLastUpdateDate()),wbs.getObjectId()};
			try{
				radDao.getJdbcTemplate().update(insertSql, params, types);
			}catch(DataAccessException e){
				radDao.getJdbcTemplate().update(updateSql, params, types);
			}
		}
	}
	
	@Deprecated
	public void saveP6WbsToMcs(List<WBS> wbss, UserToken user) throws Exception{
		
		Map<String, Object> map = null;
		
		for (int i = 0; i < wbss.size(); i++) {
			WBS w = wbss.get(i);
			Field[] fields = w.getClass().getDeclaredFields();
			map = new HashMap<String, Object>();
			
			for (int j = 0; j < fields.length; j++) {
				map.put(P6TypeConvert.propertyToField(fields[j].getName()), w.getClass().getMethod(P6TypeConvert.getMethodName(fields[j].getName()), new Class[]{}).invoke(w, new Object[]{}));
			}
			
			map.put("bsflag", "0");
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_P6_PROJECT_WBS");
		}
	}
	
	/**
	 * 保存wbs到MCS中
	 * @param wbss
	 * @param user
	 * @throws Exception
	 */
	public void saveOrUpdateP6WbsToMCS(List<WBS> wbss, UserToken user) throws Exception{
		List<WBS> saveList = new ArrayList<WBS>();
		List<WBS> updateList = new ArrayList<WBS>();
		
		List<Map<String, Object>> allWbsList = queryWbsFromMCS(new HashMap());
		Map<String, Object> map = null;
		
		for (int i = 0; i < allWbsList.size(); i++) {
			map = allWbsList.get(i);
			int objectId = ((BigDecimal)map.get("object_id")).intValue();
			for (int j = 0; j < wbss.size(); j++) {
				WBS w = wbss.get(j);
				int object_id = w.getObjectId().intValue();
				
				if (object_id == objectId) {
					updateList.add(w);
					wbss.remove(j);
					break;
				}
			}
			
			if (wbss == null || wbss.size() == 0) {
				break;
			}
		}
		
		saveList = wbss;
		this.insertP6WbsToMCS(saveList, user);
		this.updateP6WbsToMCS(updateList, user);
		
	}
	
	private void updateP6WbsToMCS(final List<WBS> wbss, final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"PROJECT_ID","NAME","CODE","SEQUENCE_NUMBER","OBS_NAME","PARENT_OBJECT_ID","MODIFI_DATE","BSFLAG","CREATOR_ID","CREATE_DATE","UPDATOR_ID","PROJECT_OBJECT_ID","OBS_OBJECT_ID","OBJECT_ID"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("update bgp_p6_project_wbs set ");
		for (int i = 0; i < propertys.length-1; i++) {
			sql.append(propertys[i]).append("=?,");//其他值
		}
		
		sql.deleteCharAt(sql.length()-1);
		sql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				try {
					WBS w= wbss.get(i);
					ps.setString(1, w.getProjectId());
					ps.setString(2, w.getName());
					ps.setString(3, w.getCode());
					ps.setInt(4, w.getSequenceNumber().intValue());
					ps.setString(5, w.getOBSName());
					ps.setInt(6, w.getParentObjectId().getValue().intValue());

					Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					String dateString = P6TypeConvert.convert(w.getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(7, date);
					} else {
						ps.setTime(7, null);
					}
					
					ps.setString(8, "0");
					ps.setString(9, w.getCreateUser());
					dateString = P6TypeConvert.convert(w.getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(10, date);
					} else {
						ps.setTime(10, null);
					}
					ps.setString(11, w.getLastUpdateUser());
					ps.setInt(12, w.getProjectObjectId().intValue());
					ps.setInt(13, w.getOBSObjectId().intValue());
					ps.setInt(14, w.getObjectId().intValue());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			
			@Override
			public int getBatchSize() {
				return wbss.size();
			}
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	private void insertP6WbsToMCS(final List<WBS> wbss, final UserToken user) throws Exception{
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"PROJECT_ID","NAME","CODE","SEQUENCE_NUMBER","OBS_NAME","PARENT_OBJECT_ID","MODIFI_DATE","BSFLAG","CREATOR_ID","CREATE_DATE","UPDATOR_ID","PROJECT_OBJECT_ID","OBS_OBJECT_ID","OBJECT_ID"};
		
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
					WBS w= wbss.get(i);
					ps.setString(1, w.getProjectId());
					ps.setString(2, w.getName());
					ps.setString(3, w.getCode());
					ps.setInt(4, w.getSequenceNumber().intValue());
					ps.setString(5, w.getOBSName());
					ps.setInt(6, w.getParentObjectId().getValue().intValue());

					Time date = null;
					SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					String dateString = P6TypeConvert.convert(w.getLastUpdateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(7, date);
					} else {
						ps.setTime(7, null);
					}
					
					ps.setString(8, "0");
					ps.setString(9, w.getCreateUser());
					dateString = P6TypeConvert.convert(w.getCreateDate(), "yyyy-MM-dd HH:mm:ss");
					if (dateString != null && !"".equals(dateString)) {
						date = new Time(f.parse(dateString).getTime());
						ps.setTime(10, date);
					} else {
						ps.setTime(10, null);
					}
					ps.setString(11, w.getLastUpdateUser());
					ps.setInt(12, w.getProjectObjectId().intValue());
					ps.setInt(13, w.getOBSObjectId().intValue());
					ps.setInt(14, w.getObjectId().intValue());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			@Override
			public int getBatchSize() {
				return wbss.size();
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	
	
	/**
	 * 删除传入的wbs
	 * @param wbss List<WBS>
	 */
	public void deleteWbs(List<WBS> wbss){
		String deleteSql = "delete from bgp_p6_project_wbs where object_id = ?";
		
		deleteSql = "update bgp_p6_project_wbs set bsflag = '1' where object_id = ?";
		
		for (int i = 0; i < wbss.size(); i++) {
			WBS wbs = wbss.get(i);
			radDao.getJdbcTemplate().update(deleteSql,wbs.getObjectId());
		}
	}
	
	public static void main(String[] args) {
//		WBS w = new WBS();
//		Field[] fields = w.getClass().getDeclaredFields();
//		for (int i = 0; i < fields.length; i++) {
//			System.out.println(fields[i].getName());
//		}
//		WbsMCSBean w = new WbsMCSBean();
	}	
}