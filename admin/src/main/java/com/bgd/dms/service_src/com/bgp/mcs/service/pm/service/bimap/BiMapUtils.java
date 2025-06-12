package com.bgp.mcs.service.pm.service.bimap;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.bgp.mcs.service.pm.service.p6.util.SynUtils;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class BiMapUtils {

	private RADJdbcDao radDao;
	private ILog log;
	
	
	public BiMapUtils() {
		radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		log = LogFactory.getLogger(SynUtils.class);
	}
	
	
	
	/**
	 * 同步地图信息到BI的数据库中
	 */
	
	public void synMapInfoGMStoBI() {
		String databaseFlag = this.getDatabaseFlag();
		// 从gms库中查询项目信息，进行新增或修改
		StringBuffer recentModifyProjectsSql = new StringBuffer(
				"select '3' as bgp_code_type,gp.project_info_no as bgp_code_id,gp.project_name as name,");
		recentModifyProjectsSql
				.append("wd.focus_y as focus_y,wd.focus_x as focus_x,");
		recentModifyProjectsSql
				.append("decode(gp.project_status,'5000100001000000001','2','5000100001000000002','1','5000100001000000003','3','5000100001000000004','1','5000100001000000005','1','0') as project_status,");
		recentModifyProjectsSql
				.append("(case when ph.pm_info in('green','gray','yellow') and ph.qm_info in ('green','gray','yellow') and ph.hse_info in('green','gray','yellow') then '1' else '0' end) as project_health,");
		recentModifyProjectsSql
				.append("substr(gpd.org_subjection_id,0,length(trim(gpd.org_subjection_id))-3) as org_subjection_id,gp.bsflag as bsflag");
		recentModifyProjectsSql.append(" from gp_task_project gp ");
		recentModifyProjectsSql
				.append(" join gp_workarea_diviede wd on gp.workarea_no = wd.workarea_no ");
		recentModifyProjectsSql
				.append(" join gp_task_project_dynamic gpd on gp.project_info_no = gpd.project_info_no");
		recentModifyProjectsSql
				.append(" join bgp_pm_project_heath_info ph on gp.project_info_no = ph.project_info_no");
		recentModifyProjectsSql.append(" where gp.bsflag = '0'");//目前没有删除项目操作，都取bsflag = 0
		
		if("synMapInfoGMStoBI".equals(databaseFlag) || "synMapInfoGMStoBI" == databaseFlag){
			//正式库
			recentModifyProjectsSql.append(" and gp.modifi_date >= "+this.getLastUpdateDate());
		}else if("synMapInfoGMStoBITrain".equals(databaseFlag) || "synMapInfoGMStoBITrain" == databaseFlag){
			//培训库
			recentModifyProjectsSql.append(" and gp.modifi_date >= "+this.getLastUpdateDateTrain());
		}
		
		
		List<Map> modifyProjectList = radDao.queryRecords(recentModifyProjectsSql.toString());
		if (modifyProjectList != null && modifyProjectList.size() != 0) {
				Statement biStatement = null;
				ResultSet biResultSet = null;
				Connection biConenction = null;
				
				if("synMapInfoGMStoBI".equals(databaseFlag) || "synMapInfoGMStoBI" == databaseFlag){
					//连接正式库
					biConenction = GetBIDatabaseConnection.getConnection("synMapInfoGMStoBI");
				}else if("synMapInfoGMStoBITrain".equals(databaseFlag) || "synMapInfoGMStoBITrain" == databaseFlag){
					//连接培训库
					biConenction = GetBIDatabaseConnection.getConnection("synMapInfoGMStoBITrain");
				}
				
				for (int i = 0; i < modifyProjectList.size(); i++) {
					try{
						Map gmsProjectMap = modifyProjectList.get(i);
						if (gmsProjectMap != null&&gmsProjectMap.get("focus_y").toString().length()!=0&&gmsProjectMap.get("focus_x").toString().length()!=0) {
							biStatement = biConenction.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
							String gmsProjectInfoNo = gmsProjectMap.get("bgp_code_id").toString();
							String bsFlag = gmsProjectMap.get("bsflag").toString();
							String checkProject = "select pm.bgp_code_id from dm_dss.f_bgp_project_info_map pm where pm.bgp_code_type = '3' and pm.bgp_code_id ='"+ gmsProjectInfoNo + "'";
							// 如果能在bi的数据库中查到该条数据,bsfalg=0修改,bsflag=1删除(删除暂时无法实现，待讨论)
							biResultSet = biStatement.executeQuery(checkProject);
							biResultSet.last();
							if (biResultSet.getRow() > 0) {
								if ("0" == bsFlag || "0".equals(bsFlag)) {
									String updateSql = "update dm_dss.f_bgp_project_info_map pm set pm.name = '"
											+ gmsProjectMap.get("name")
											+ "',pm.focus_x ="
											+ gmsProjectMap.get("focus_x")
											+ " ,pm.focus_y = "
											+ gmsProjectMap.get("focus_y")
											+ ", pm.project_status = '"
											+ gmsProjectMap.get("project_status")
											+ "',pm.project_health = '"
											+ gmsProjectMap.get("project_health")
											+ "',pm.org_subjection_id = '"
											+ gmsProjectMap
													.get("org_subjection_id")
											+ "' where pm.bgp_code_id ='"
											+ gmsProjectInfoNo + "'";
									log.info(updateSql);
									if (biStatement.executeUpdate(updateSql) > 0) {
										biConenction.commit();
									}
								}
							}else if(biResultSet.getRow() == 0){
								//
								// 如果查不到,bsflag=0，插入
								if ("0" == bsFlag || "0".equals(bsFlag)) {
									if(gmsProjectMap.get("focus_y").toString().length()!=0&&gmsProjectMap.get("focus_x").toString().length()!=0){
										String insertSql = "insert into dm_dss.f_bgp_project_info_map(bgp_code_type,bgp_code_id,name,focus_x,focus_y,project_status,project_health,org_subjection_id) values('3','"
												+ gmsProjectMap.get("bgp_code_id")
												+ "','"
												+ gmsProjectMap.get("name")
												+ "',"
												+ gmsProjectMap.get("focus_x")
												+ ","
												+ gmsProjectMap.get("focus_y")
												+ ",'"
												+ gmsProjectMap
														.get("project_status")
												+ "','"
												+ gmsProjectMap
														.get("project_health")
												+ "','"
												+ gmsProjectMap
														.get("org_subjection_id")
												+ "')";
										log.info(insertSql);
										if (biStatement.executeUpdate(insertSql) > 0) {
											biConenction.commit();
											String insertMapMaker = "insert into metabase.imap_marker(marker_id,marker_class_id,name) values ((select max(mk.marker_id)+1 from metabase.imap_marker mk) ,161,'"+ gmsProjectMap.get("name")+ "')";
											if (biStatement.executeUpdate(insertMapMaker) > 0) {
												biConenction.commit();
											}
										}
									}
									
								}
							}
						}
					
					}catch(Exception e){
						e.printStackTrace();
						continue;
					}
				}
		}

	}

	public String getLastUpdateDate() {
		log.info("enter getLastUpdateDate");
		String sql = "select exec_date from bgp_inter_manage where inter_id='synMapInfoGMStoBI'";
		String tmp = radDao.getJdbcTemplate().queryForObject(sql, String.class);
		log.info("exit getLastUpdateDate) par = "
				+ tmp.substring(0, tmp.length() - 2) + "");
		return "to_date('" + tmp.substring(0, tmp.length() - 2)
				+ "','yyyy-MM-dd hh24:mi:ss')";
	}
	
	public String getLastUpdateDateTrain() {
		log.info("enter getLastUpdateDateTrain");
		String sql = "select exec_date from bgp_inter_manage where inter_id='synMapInfoGMStoBITrain'";
		String tmp = radDao.getJdbcTemplate().queryForObject(sql, String.class);
		log.info("exit getLastUpdateDateTrain) par = "
				+ tmp.substring(0, tmp.length() - 2) + "");
		return "to_date('" + tmp.substring(0, tmp.length() - 2)
				+ "','yyyy-MM-dd hh24:mi:ss')";
	}
	
	public String getDatabaseFlag(){
		log.info("enter getDatabaseFlag");
		String sql = "select exec_date from bgp_inter_manage where inter_id='synMapInfoGMStoBI'";
		Map dbflagMap = radDao.queryRecordBySQL(sql);
		String tmp = "";
		if(dbflagMap != null){
			tmp = "synMapInfoGMStoBI";
		}else{
			sql = "select exec_date from bgp_inter_manage where inter_id='synMapInfoGMStoBITrain'";
			dbflagMap = radDao.queryRecordBySQL(sql);
			if(dbflagMap != null){
				tmp = "synMapInfoGMStoBITrain";
			}
		}
		return tmp;
	}

	public void setUpdateDate() {
		log.info("更新时间");
		String databaseFlag = this.getDatabaseFlag();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String sql = "";
		if("synMapInfoGMStoBI".equals(databaseFlag) || "synMapInfoGMStoBI" == databaseFlag){
			//连接正式库
			sql = "update bgp_inter_manage set exec_date= to_date('"+format.format(new Date())+"','YYYY-MM-DD HH24-mi-ss') where inter_id='synMapInfoGMStoBI'";
		}else if("synMapInfoGMStoBITrain".equals(databaseFlag) || "synMapInfoGMStoBITrain" == databaseFlag){
			//连接培训库
			sql = "update bgp_inter_manage set exec_date= to_date('"+format.format(new Date())+"','YYYY-MM-DD HH24-mi-ss') where inter_id='synMapInfoGMStoBITrain'";
		}
		
		radDao.getJdbcTemplate().execute(sql);
	}

}
