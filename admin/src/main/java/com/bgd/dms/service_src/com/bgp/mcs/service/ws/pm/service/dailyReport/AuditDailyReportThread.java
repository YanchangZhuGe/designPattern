package com.bgp.mcs.service.ws.pm.service.dailyReport;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.common.DateOperation;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class AuditDailyReportThread extends Thread {
	
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	/**
	 * 审批人的组织机构编号
	 */
	//String orgId = null;
	
	/**
	 * 日报日期
	 */
	String produceDate = null;
	
	/**
	 * 项目主键
	 */
	String projectInfoNo = null;
	
	/**
	 * 审批用户employee_id
	 */
	String userId = null;
	
	/**
	 * 审批用户employee_name
	 */
	String userName = null;

	public void run(){
		auditDailyReport();
	}
	
	public AuditDailyReportThread(Map map){
		//this.orgId = (String) map.get("orgId");
		this.produceDate = (String) map.get("produceDate");
		this.projectInfoNo = (String) map.get("projectInfoNo");
		this.userId = (String) map.get("userId");
		this.userName = (String) map.get("userName");
	}
	
	private void auditDailyReport(){
		insertRptDaily();
	}
	
	/**
	 * 审批通过后 新增集团日报
	 */
	private void insertRptDaily(){
		Map r = new HashMap();
		String sql = "";
		
		sql = "select * from rpt_gp_daily where project_info_no = '"+projectInfoNo+"' and bsflag = '0'  and send_date = to_date('"+produceDate+"','yyyy-MM-dd')";
		Map rr = jdbcDao.queryRecordBySQL(sql);
		
		if (rr != null) {
			r.put("gp_daily_id", rr.get("gpDailyId"));
		}
		
		//项目计息
		sql = "select * from gp_task_project where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ";
		Map project = jdbcDao.queryRecordBySQL(sql);
		
		//工区信息
		sql = "select * from gp_workarea_diviede where workarea_no = '"+project.get("workareaNo")+"' and bsflag = '0' ";
		Map workarea = jdbcDao.queryRecordBySQL(sql);
		
		//日报信息
		sql = "select * from gp_ops_daily_report where project_info_no = '"+project.get("projectInfoNo")+"' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') and bsflag = '0' and exploration_method = '"+project.get("explorationMethod")+"'";
		Map daily = jdbcDao.queryRecordBySQL(sql);
		
		//日报sit表
		sql = "select * from gp_ops_daily_produce_sit where daily_no = '"+daily.get("dailyNo")+"' and bsflag = '0' ";
		Map sit = jdbcDao.queryRecordBySQL(sql);
		
		//项目动态表
		sql = "select * from gp_task_project_dynamic where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and exploration_method = '"+project.get("explorationMethod")+"' ";
		Map dy = jdbcDao.queryRecordBySQL(sql);
		
		//编码表
		sql = "select * from comm_coding_sort_detail where coding_code_id = '"+project.get("manageOrg")+"' ";
		Map code = jdbcDao.queryRecordBySQL(sql);
		
		//组织机构隶属
		sql = "select * from comm_org_subjection where org_id = '"+dy.get("orgId")+"' and bsflag = '0' ";
		Map sub = jdbcDao.queryRecordBySQL(sql);
		
		//组织机构表
		sql = "select * from comm_org_information where org_id = '"+dy.get("orgId")+"' and bsflag = '0' ";
		Map info = jdbcDao.queryRecordBySQL(sql);

		r.put("send_date", produceDate);
		r.put("project_id", project.get("projectId"));
		r.put("is_main_project", project.get("isMainProject"));
		if (workarea != null) {
			r.put("surface_type", workarea.get("surfaceType"));
			r.put("workarea_name", workarea.get("workarea"));
			r.put("workarea_no", workarea.get("workareaNo"));
			r.put("basin", workarea.get("basin"));
			r.put("block", workarea.get("block"));
			r.put("area_scale", workarea.get("regionName"));
		}
		String ifBuild = (String) sit.get("ifBuild");
		if( ifBuild == null ) {
			ifBuild = "";
		} else if(ifBuild.equals("1")) { 
			ifBuild = "动迁";
		} else if(ifBuild.equals("2")) {
			ifBuild = "踏勘";
		} else if(ifBuild.equals("3")) {
			ifBuild = "试验";
		} else if(ifBuild.equals("4")) {
			ifBuild = "测量";
		} else if(ifBuild.equals("5")) {
			ifBuild = "钻井";
		} else if(ifBuild.equals("6")) {
			ifBuild = "采集";
		} else if(ifBuild.equals("7")) {
			ifBuild = "停工";
		} else if(ifBuild.equals("8")) {
			ifBuild = "暂停（人员设备撤离）";
		} else if(ifBuild.equals("9")) {
			ifBuild = "结束";
		} else if(ifBuild.equals("e")) {
			ifBuild = "月检";
		}
		r.put("work_status", ifBuild);
		r.put("point_num", convertToLong(daily.get("dailySmallRefractionNum")) + convertToLong(daily.get("dailyMicroMeasuePointNum")));
		r.put("shot_num", convertToLong(daily.get("dailySurveyShotNum")) + convertToLong(daily.get("dailySurveyGeophoneNum")));
		r.put("daily_total_shot", daily.get("dailyDrillSpNum"));
		r.put("finished_total_point", "");
		r.put("total_point_num", "");
		r.put("total_shot", "");
		r.put("object_workload", "");
		r.put("design_shot", convertToLong(dy.get("designGeophoneNum"))+convertToLong(dy.get("designSpNum")));
		r.put("design_total_point", convertToLong(dy.get("designSmallRegractionNum"))+convertToLong(dy.get("designMicroMeasueNum")));
		r.put("project_org_name", info.get("orgName"));
		r.put("project_info_no", projectInfoNo);
		r.put("project_status", project.get("projectStatus"));
		r.put("org_subjection_id", dy.get("orgSubjectionId"));
		r.put("org_id", dy.get("orgId"));
		r.put("project_name", project.get("projectName"));
		r.put("market_classify", project.get("marketClassify"));
		r.put("exploration_method", project.get("explorationMethod"));
		r.put("hire_org", project.get("manageOrg"));//甲方单位编码
		//r.put("send_date", project.get("sendDate"));
		
		String explorationMethod = (String) project.get("explorationMethod");
		if ("0300100012000000002".equals(explorationMethod) || explorationMethod == "0300100012000000002") {
			//2维
			r.put("daily_finishing_sp", convertToLong(daily.get("dailyAcquireSpNum"))+convertToLong(daily.get("dailyJpAcquireShotNum"))+convertToLong(daily.get("dailyQqAcquireShotNum")));
			r.put("finish_2d_workload", convertToDouble(daily.get("dailyAcquireWorkload"))+convertToDouble(daily.get("dailyJpAcquireWorkload"))+convertToDouble(daily.get("dailyQqAcquireWorkload")));
			
			r.put("miss_2d_sp", convertToLong(daily.get("collectMissNum")));
			r.put("shot_2d_workload", convertToDouble(daily.get("surveyInceptWorkload")) + convertToDouble(daily.get("surveyShotWorkload")));
		} else {
			//3维
			r.put("daily_finishing_sp", convertToLong(daily.get("dailyAcquireSpNum"))+convertToLong(daily.get("dailyJpAcquireShotNum"))+convertToLong(daily.get("dailyQqAcquireShotNum")));
			r.put("finish_3d_workload", convertToDouble(daily.get("dailyAcquireWorkload"))+convertToDouble(daily.get("dailyJpAcquireWorkload"))+convertToDouble(daily.get("dailyQqAcquireWorkload")));
			
			r.put("miss_3d_sp", convertToLong(daily.get("collectMissNum")));
			r.put("shot_3d_workload", convertToDouble(daily.get("surveyInceptWorkload")) + convertToDouble(daily.get("surveyShotWorkload")));
		}
		
		r.put("design_sp", dy.get("designSpNum"));
		if ("0300100012000000002".equals(explorationMethod) || explorationMethod == "0300100012000000002") {
			r.put("design_2d_workload", dy.get("designObjectWorkload"));
		} else {
			r.put("design_3d_workload", dy.get("designObjectWorkload"));
		}
		
		r.put("bsflag", "0");
		r.put("modifi_date", new Date());
		r.put("create_date", new Date());
		r.put("creator_id", userId);
		r.put("creator", userName);
		r.put("manage_org", code.get("codingName"));//甲方单位汉字
		r.put("exploration_type", project.get("exploreType"));
		
		if (workarea != null) {
			sql = "select * from comm_coding_sort_detail where coding_code_id = '"+workarea.get("country")+"' ";
			code = jdbcDao.queryRecordBySQL(sql);
			
			r.put("country", code.get("codingName"));
		}
		r.put("project_business_type", project.get("projectBusinessType"));
		r.put("team_leader", project.get("vspTeamLeader"));
		r.put("project_start_time", project.get("projectStartTime"));
		r.put("project_end_time", project.get("projectEndTime"));
		sql = "select * from gp_ops_bgp_report where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ";
		Map bgp = jdbcDao.queryRecordBySQL(sql);
		if (bgp != null) {
			r.put("processing_unit", bgp.get("processingUnit"));
		} else {
			r.put("processing_unit", "");
		}
		r.put("acquire_start_time", project.get("acquireStartTime"));
		r.put("acquire_end_time", project.get("acquireEndTime"));
		r.put("design_start_date", project.get("designStartDate"));
		r.put("design_end_date", project.get("designEndDate"));

		r.put("daily_acquire_qualfied_num", daily.get("dailyAcquireQualifiedNum"));
		r.put("daily_acquire_firstlevel_num", daily.get("dailyAcquireFirstlevelNum"));
		r.put("collect_waster_num", daily.get("collectWasterNum"));
		
		if ("0300100012000000002".equals(explorationMethod) || explorationMethod == "0300100012000000002") {
			r.put("daily_finishing_2d_sp", convertToLong(daily.get("dailyAcquireSpNum"))+convertToLong(daily.get("dailyJpAcquireShotNum"))+convertToLong(daily.get("dailyQqAcquireShotNum")));
			r.put("design_2d_sp", dy.get("designSpNum"));
			r.put("daily_2d_acquire_qualified_num", daily.get("dailyAcquireQualifiedNum"));
			r.put("daily_2d_acquire_1level_num", daily.get("dailyAcquireFirstlevelNum"));
			r.put("collect_2d_waster_num", daily.get("collectWasterNum"));
			r.put("shot_2d_num", convertToLong(daily.get("dailySurveyShotNum")) + convertToLong(daily.get("dailySurveyGeophoneNum")));
			r.put("point_2d_num", convertToLong(daily.get("dailySmallRefractionNum")) + convertToLong(daily.get("dailyMicroMeasuePointNum")));
			r.put("daily_2d_total_shot", daily.get("dailyDrillSpNum"));
			r.put("design_2d_shot", convertToLong(dy.get("designGeophoneNum"))+convertToLong(dy.get("designSpNum")));
			r.put("design_2d_total_point", convertToLong(dy.get("designSmallRegractionNum"))+convertToLong(dy.get("designMicroMeasueNum")));
			r.put("collect_2d_2_class", daily.get("collect2Class"));
		} else {
			r.put("daily_finishing_3d_sp", convertToLong(daily.get("dailyAcquireSpNum"))+convertToLong(daily.get("dailyJpAcquireShotNum"))+convertToLong(daily.get("dailyQqAcquireShotNum")));
			r.put("design_3d_sp", dy.get("designSpNum"));
			r.put("daily_3d_acquire_qualified_num", daily.get("dailyAcquireQualifiedNum"));
			r.put("daily_3d_acquire_1level_num", daily.get("dailyAcquireFirstlevelNum"));
			r.put("collect_3d_waster_num", daily.get("collectWasterNum"));
			r.put("shot_3d_num", convertToLong(daily.get("dailySurveyShotNum")) + convertToLong(daily.get("dailySurveyGeophoneNum")));
			r.put("point_3d_num", convertToLong(daily.get("dailySmallRefractionNum")) + convertToLong(daily.get("dailyMicroMeasuePointNum")));
			r.put("daily_3d_total_shot", daily.get("dailyDrillSpNum"));
			r.put("design_3d_shot", convertToLong(dy.get("designGeophoneNum"))+convertToLong(dy.get("designSpNum")));
			r.put("design_3d_total_point", convertToLong(dy.get("designSmallRegractionNum"))+convertToLong(dy.get("designMicroMeasueNum")));
			r.put("collect_3d_2_class", daily.get("collect2Class"));
		}
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(r,"rpt_gp_daily");
		
		String orgSubjectionId = this.findOrgSubjectionId((String) dy.get("orgId"));
		
		if (orgSubjectionId != null && orgSubjectionId.indexOf("C105005") != -1) {
			//东部事业部删除 但是原隶属东部的经理部隶属主键没有修改 三个经理部认为是处级
			orgSubjectionId = orgSubjectionId.substring(0, 10);

		} else if(orgSubjectionId!=null && orgSubjectionId.length()>7){
			orgSubjectionId = orgSubjectionId.substring(0, 7);
		}
		
		 //队伍对应的处级组织机构编号
        String orgIdCJ = findCurOrgId(orgSubjectionId);
        
        //查询该处级单位的兄弟单位
        List infos = findOrgIdByXml(orgIdCJ);
        
        for (int j = 0; j < infos.size(); j++) {
        	//审批一个单位 把另几个处级单位的局日报也插入进来
        	orgIdCJ = (String) infos.get(j);
        	orgSubjectionId = findOrgSubj(orgIdCJ);
        	
        	//根据甲方单位、日期和组织机构来统计工作量
        	List staDailyReport = findRptGpDailyTotals(produceDate, orgIdCJ);
        	
        	//根据甲方单位、日期和组织机构来统计队伍动态
        	List staTeam = findRptGpDailyTotalTeams(produceDate, orgIdCJ);
        	
        	if( staDailyReport != null && staDailyReport.size() > 0 ) {

        		for( int i = 0; i < staDailyReport.size(); i++ ) {

        			Map rptGpDailyTotal = (Map) staDailyReport.get(i);

        			//rptGpDailyTotal.setSendDate(DateOperation.parseToUtilDate(produceDate));
        			rptGpDailyTotal.put("send_date", produceDate);

//        			rptGpDailyTotal.setBsflag("0");
//        			rptGpDailyTotal.setCreateDate(new Date());
//        			rptGpDailyTotal.setModifiDate(new Date());
//        			rptGpDailyTotal.setCreator(userName);
//        			rptGpDailyTotal.setCreatorId(userId);
//        			rptGpDailyTotal.setOrgId(orgIdCJ);
//        			rptGpDailyTotal.setOrgSubjectionId(orgSubjectionId);
        			rptGpDailyTotal.put("bsflag", "0");
        			rptGpDailyTotal.put("create_date", new Date());
        			rptGpDailyTotal.put("modifi_date", new Date());
        			rptGpDailyTotal.put("creator", userName);
        			rptGpDailyTotal.put("creator_id", userId);
        			rptGpDailyTotal.put("org_id", orgIdCJ);
        			rptGpDailyTotal.put("org_subjection_id", orgSubjectionId);
        			
        			//BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(rptGpDailyTotal,"rpt_gp_daily_total");

        		}
        		
        		saveOrUpdateTotal(staDailyReport);
        	}
        	
        	if( staTeam != null && staTeam.size() > 0 ) {

        		for( int i = 0; i < staTeam.size(); i++ ) {

        			Map rptGpDailyTotalTeam = (Map)staTeam.get(i);

        			//rptGpDailyTotalTeam.setSendDate(DateOperation.parseToUtilDate(produceDate));
        			rptGpDailyTotalTeam.put("send_date", produceDate);

//        			rptGpDailyTotalTeam.setBsflag("0");
//        			rptGpDailyTotalTeam.setCreateDate(new Date());
//        			rptGpDailyTotalTeam.setModifiDate(new Date());
//        			rptGpDailyTotalTeam.setCreator(userName);
//        			rptGpDailyTotalTeam.setCreatorId(userId);
//        			rptGpDailyTotalTeam.setOrgId(orgIdCJ);
//        			rptGpDailyTotalTeam.setOrgSubjectionId(orgSubjectionId);
        			
        			rptGpDailyTotalTeam.put("bsflag", "0");
        			rptGpDailyTotalTeam.put("create_date", new Date());
        			rptGpDailyTotalTeam.put("modifi_date", new Date());
        			rptGpDailyTotalTeam.put("creator", userName);
        			rptGpDailyTotalTeam.put("creator_id", userId);
        			rptGpDailyTotalTeam.put("org_id", orgIdCJ);
        			rptGpDailyTotalTeam.put("org_subjection_id", orgSubjectionId);

        			saveOrUpdateTotalTeam(rptGpDailyTotalTeam);

        		}
        	}
        	
        }
        
	}
	
	private void saveOrUpdateTotalTeam(final Map totalTeam){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"ORG_SUBJECTION_ID","ORG_ID","MARKET_CLASSIFY","SEND_DATE","BLOCK","SEISMIC_TOTAL_TEAM","NON_SEISMIC_TOTAL_TEAM",
				"VSP_TOTAL_TEAM","TOTAL_2D_USE_TEAM","TOTAL_3D_USE_TEAM","TOTAL_4D_USE_TEAM","GRAVITY_USE_TEAM","MAGNATIC_USE_TEAM","ELECTRIC_USE_TEAM",
				"GEOCHEMICAL_USE_TEAM","VSP_USE_TEAM","BSFLAG","MODIFI_DATE","CREATE_DATE","CREATOR_ID","CREATOR","PROJECT_ORG_NAME","TOTAL_USE_TEAM",
				"OTHER_USE_TEAM","OTHER_TOTAL_TEAM","GP_DAILY_ID"};
		
		if (totalTeam.get("gp_daily_id") == null || "".equals((String) totalTeam.get("gp_daily_id")) || "null".equals((String) totalTeam.get("gp_daily_id")) || (String) totalTeam.get("gp_daily_id") == "null") {
			StringBuffer insertSql = new StringBuffer();
			insertSql.append("insert into rpt_gp_daily_total_team (");
			for (int i = 0; i < propertys.length; i++) {
				insertSql.append(propertys[i]).append(",");
			}
			insertSql.deleteCharAt(insertSql.length()-1);
			insertSql.append(") values (");
			for (int i = 0; i < propertys.length; i++) {
				insertSql.append("?,");
			}
			insertSql.deleteCharAt(insertSql.length()-1);
			insertSql.append(")");
			
			BatchPreparedStatementSetter saveSetter = new BatchPreparedStatementSetter() {
				
				@Override
				public void setValues(PreparedStatement ps, int i) throws SQLException {
					Map map = totalTeam;
					ps.setString(1, (String) map.get("org_subjection_id"));
					ps.setString(2, (String) map.get("org_id"));
					ps.setString(3, (String) map.get("market_classify"));
					
					SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
					java.sql.Date date;
					try {
						date = new java.sql.Date(f.parse(produceDate).getTime());
						ps.setDate(4, date);
					} catch (Exception e) {
						ps.setDate(4, null);
					}
					
					ps.setString(5, (String) map.get("block"));
					
					ps.setInt(6, Integer.parseInt((String)map.get("seismic_total_team")));
					ps.setInt(7, Integer.parseInt((String)map.get("non_seismic_total_team")));
					ps.setInt(8, Integer.parseInt((String)map.get("vsp_total_team")));
					ps.setInt(9, Integer.parseInt((String)map.get("total_2d_use_team")));
					ps.setInt(10, Integer.parseInt((String)map.get("total_3d_use_team")));
					ps.setInt(11, Integer.parseInt((String)map.get("total_4d_use_team")));
					ps.setInt(12, Integer.parseInt((String)map.get("gravity_use_team")));
					ps.setInt(13, Integer.parseInt((String)map.get("magnatic_use_team")));
					ps.setInt(14, Integer.parseInt((String)map.get("electric_use_team")));
					ps.setInt(15, Integer.parseInt((String)map.get("geochemical_use_team")));
					ps.setInt(16, Integer.parseInt((String)map.get("vsp_use_team")));
					ps.setString(17, "0");
					ps.setDate(18, new java.sql.Date(new Date().getTime()));//modifi_date
					ps.setDate(19, new java.sql.Date(new Date().getTime()));//create_date
					ps.setString(20, (String) map.get("creator_id"));
					ps.setString(21, (String) map.get("creator"));
					ps.setString(22, "");
					ps.setInt(23, Integer.parseInt((String)map.get("total_use_team")));
					ps.setInt(24, Integer.parseInt((String)map.get("other_use_team")));
					ps.setInt(25, Integer.parseInt((String)map.get("other_total_team")));
					ps.setString(26, radDao.generateUUID());
				}
				
				@Override
				public int getBatchSize() {
					return 1;
				}
				
			};
			
			jdbcTemplate.batchUpdate(insertSql.toString(), saveSetter);

		} else {
			StringBuffer updateSql = new StringBuffer();
			updateSql.append("update rpt_gp_daily_total_team set ");
			for (int i = 0; i < propertys.length-1; i++) {
				updateSql.append(propertys[i]).append("=?,");//其他值
			}
			updateSql.deleteCharAt(updateSql.length()-1);
			updateSql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
			
			BatchPreparedStatementSetter updateSetter = new BatchPreparedStatementSetter() {
				
				@Override
				public void setValues(PreparedStatement ps, int i) throws SQLException {
					Map map = totalTeam;
					ps.setString(1, (String) map.get("org_subjection_id"));
					ps.setString(2, (String) map.get("org_id"));
					ps.setString(3, (String) map.get("market_classify"));
					
					SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
					java.sql.Date date;
					try {
						date = new java.sql.Date(f.parse(produceDate).getTime());
						ps.setDate(4, date);
					} catch (Exception e) {
						ps.setDate(4, null);
					}
					
					ps.setString(5, (String) map.get("block"));
					
					ps.setInt(6, Integer.parseInt((String)map.get("seismic_total_team")));
					ps.setInt(7, Integer.parseInt((String)map.get("non_seismic_total_team")));
					ps.setInt(8, Integer.parseInt((String)map.get("vsp_total_team")));
					ps.setInt(9, Integer.parseInt((String)map.get("total_2d_use_team")));
					ps.setInt(10, Integer.parseInt((String)map.get("total_3d_use_team")));
					ps.setInt(11, Integer.parseInt((String)map.get("total_4d_use_team")));
					ps.setInt(12, Integer.parseInt((String)map.get("gravity_use_team")));
					ps.setInt(13, Integer.parseInt((String)map.get("magnatic_use_team")));
					ps.setInt(14, Integer.parseInt((String)map.get("electric_use_team")));
					ps.setInt(15, Integer.parseInt((String)map.get("geochemical_use_team")));
					ps.setInt(16, Integer.parseInt((String)map.get("vsp_use_team")));
					ps.setString(17, "0");
					ps.setDate(18, new java.sql.Date(new Date().getTime()));//modifi_date
					ps.setDate(19, new java.sql.Date(new Date().getTime()));//create_date
					ps.setString(20, (String) map.get("creator_id"));
					ps.setString(21, (String) map.get("creator"));
					ps.setString(22, "");
					ps.setInt(23, Integer.parseInt((String)map.get("total_use_team")));
					ps.setInt(24, Integer.parseInt((String)map.get("other_use_team")));
					ps.setInt(25, Integer.parseInt((String)map.get("other_total_team")));
					ps.setString(26, radDao.generateUUID());
				}
				
				@Override
				public int getBatchSize() {
					return 1;
				}
				
			};
			
			jdbcTemplate.batchUpdate(updateSql.toString(), updateSetter);
			
		}
		
		
	}
	
	private void saveOrUpdateTotal(List total){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"ORG_SUBJECTION_ID","ORG_ID","MARKET_CLASSIFY","BLOCK","SEND_DATE","COUNT_METHOD","TOTAL_2D_SP","TOTAL_3D_SP",
				"TOTAL_4D_SP","TOTAL_2D_WORKLOAD","TOTAL_3D_WORKLOAD","TOTAL_4D_WORKLOAD","GRAVITY_WORKLOAD","MAGNETIC_WORKLOAD",
				"ELECTRIC_WORKLOAD","GEOCHEMICAL","VSP","BSFLAG","MODIFI_DATE","CREATE_DATE","CREATOR_ID","CREATOR","PROJECT_ORG_NAME","GP_DAILY_ID"};
		
		final List save = new ArrayList();
		final List update = new ArrayList();
		
		for (int i = 0; i < total.size(); i++) {
			Map temp = (Map) total.get(i);
			if (temp.get("gp_daily_id") == null || "".equals((String) temp.get("gp_daily_id")) || "null".equals((String) temp.get("gp_daily_id")) || (String) temp.get("gp_daily_id") == "null") {
				//System.out.println(temp.get("gp_daily_id"));
				save.add(temp);
			} else {
				//System.out.println(temp.get("gp_daily_id"));
				update.add(temp);
			}
		}
		
		if (update != null && update.size() != 0) {
			
			StringBuffer updateSql = new StringBuffer();
			updateSql.append("update rpt_gp_daily_total set ");
			for (int i = 0; i < propertys.length-1; i++) {
				updateSql.append(propertys[i]).append("=?,");//其他值
			}
			updateSql.deleteCharAt(updateSql.length()-1);
			updateSql.append(" where ").append(propertys[propertys.length-1]).append("=?");//主键
			
			BatchPreparedStatementSetter updateSetter = new BatchPreparedStatementSetter() {
				
				@Override
				public void setValues(PreparedStatement ps, int i) throws SQLException {
					Map map = (Map) update.get(i);
					ps.setString(1, (String) map.get("org_subjection_id"));
					ps.setString(2, (String) map.get("org_id"));
					ps.setString(3, (String) map.get("market_classify"));
					ps.setString(4, (String) map.get("block"));
					
					SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
					java.sql.Date date;
					try {
						date = new java.sql.Date(f.parse(produceDate).getTime());
						ps.setDate(5, date);
					} catch (Exception e) {
						ps.setDate(5, null);
					}
					
					ps.setInt(6, Integer.parseInt((String)map.get("count_method")));
					ps.setInt(7, Integer.parseInt((String)map.get("total_2d_sp")));
					ps.setInt(8, Integer.parseInt((String)map.get("total_3d_sp")));
					ps.setInt(9, Integer.parseInt((String)map.get("total_4d_sp")));
					ps.setDouble(10, Double.parseDouble((String)map.get("total_2d_workload")));
					ps.setDouble(11, Double.parseDouble((String)map.get("total_3d_workload")));
					ps.setDouble(12, Double.parseDouble((String)map.get("total_4d_workload")));
					ps.setInt(13, Integer.parseInt((String)map.get("gravity_workload")));
					ps.setInt(14, Integer.parseInt((String)map.get("magnetic_workload")));
					ps.setInt(15, Integer.parseInt((String)map.get("electric_workload")));
					ps.setInt(16, Integer.parseInt((String)map.get("geochemical")));
					ps.setInt(17, Integer.parseInt((String)map.get("vsp")));
					ps.setString(18, "0");
					ps.setDate(19, new java.sql.Date(new Date().getTime()));//modifi_date
					ps.setDate(20, new java.sql.Date(new Date().getTime()));//create_date
					ps.setString(21, (String) map.get("creator_id"));
					ps.setString(22, (String) map.get("creator"));
					ps.setString(23, "");
					
					ps.setString(24, (String) map.get("gp_daily_id"));
				}
				
				@Override
				public int getBatchSize() {
					return update.size();
				}
				
			};
			
			jdbcTemplate.batchUpdate(updateSql.toString(), updateSetter);
		}
		
		if (save != null && save.size() != 0) {
			
			StringBuffer insertSql = new StringBuffer();
			insertSql.append("insert into rpt_gp_daily_total (");
			for (int i = 0; i < propertys.length; i++) {
				insertSql.append(propertys[i]).append(",");
			}
			insertSql.deleteCharAt(insertSql.length()-1);
			insertSql.append(") values (");
			for (int i = 0; i < propertys.length; i++) {
				insertSql.append("?,");
			}
			insertSql.deleteCharAt(insertSql.length()-1);
			insertSql.append(")");
			
			BatchPreparedStatementSetter saveSetter = new BatchPreparedStatementSetter() {
				
				@Override
				public void setValues(PreparedStatement ps, int i) throws SQLException {
					Map map = (Map) save.get(i);
					ps.setString(1, (String) map.get("org_subjection_id"));
					ps.setString(2, (String) map.get("org_id"));
					ps.setString(3, (String) map.get("market_classify"));
					ps.setString(4, (String) map.get("block"));
					
					SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					java.sql.Date date;
					try {
						date = new java.sql.Date(f.parse(produceDate).getTime());
						ps.setDate(5, date);
					} catch (Exception e) {
						ps.setDate(5, null);
					}
					
					ps.setInt(6, Integer.parseInt((String)map.get("count_method")));
					ps.setInt(7, Integer.parseInt((String)map.get("total_2d_sp")));
					ps.setInt(8, Integer.parseInt((String)map.get("total_3d_sp")));
					ps.setInt(9, Integer.parseInt((String)map.get("total_4d_sp")));
					ps.setDouble(10, Double.parseDouble((String)map.get("total_2d_workload")));
					ps.setDouble(11, Double.parseDouble((String)map.get("total_3d_workload")));
					ps.setDouble(12, Double.parseDouble((String)map.get("total_4d_workload")));
					ps.setInt(13, Integer.parseInt((String)map.get("gravity_workload")));
					ps.setInt(14, Integer.parseInt((String)map.get("magnetic_workload")));
					ps.setInt(15, Integer.parseInt((String)map.get("electric_workload")));
					ps.setInt(16, Integer.parseInt((String)map.get("geochemical")));
					ps.setInt(17, Integer.parseInt((String)map.get("vsp")));
					ps.setString(18, "0");
					ps.setDate(19, new java.sql.Date(new Date().getTime()));//modifi_date
					ps.setDate(20, new java.sql.Date(new Date().getTime()));//create_date
					ps.setString(21, (String) map.get("creator_id"));
					ps.setString(22, (String) map.get("creator"));
					ps.setString(23, "");
					
					ps.setString(24, radDao.generateUUID());
				}
				
				@Override
				public int getBatchSize() {
					return save.size();
				}
				
			};
			
			jdbcTemplate.batchUpdate(insertSql.toString(), saveSetter);
		}
		
		
	}
	
	public static Long convertToLong(Object string) {
		if (string == null) {
			return null;
		} else {
			try{
				return new Long((String) string);
			} catch (Exception e){
				//e.printStackTrace();
				return new Long(0);
			}			
		}
	}
	
	public static Double convertToDouble(Object string) {
		if (string == null) {
			return null;
		} else {
			try{
				return new Double((String)string);
			} catch (Exception e){
				//e.printStackTrace();
				return new Double(0);
			}			
		}
	}
	
	/**
	 * 根据orgId查找对应管理单位的orgSubjectionId
	 * 
	 * @param orgId  String  组织机构编号 
	 * @return orgSubjectionId  String  管理单位的组织机构隶属关系编号
	 * @throws 无
	 */
	public String findOrgSubjectionId(String orgId){
		
		if( orgId == null ){			
			orgId = "";
		}
		
		String orgSubjectionId = "";
		
		String sql = "select  t3.org_subjection_id,t1.org_id,t3.code_afford_org_id " +
				" from comm_org_information t1,comm_org_subjection t2,comm_org_subjection t3 " +
				" where t1.org_id = t2.code_afford_org_id and t2.org_id = '"+orgId+"' " +
				" and t1.org_id = t3.org_id and t1.bsflag = '0' and t2.bsflag ='0' and t3.bsflag = '0' "; 
		
		Map info = jdbcDao.queryRecordBySQL(sql);
		if (info == null || info.isEmpty()) {
			return "";
		}
		
		orgSubjectionId = (String) info.get("orgSubjectionId");
		String fartherOrgId = (String) info.get("orgId");
		String codeAffordOrgId = (String) info.get("codeAffordOrgId");
		
		if(!fartherOrgId.equals(codeAffordOrgId)){
			
			orgSubjectionId = findOrgSubjectionId(codeAffordOrgId);
		}
		
		return orgSubjectionId;
	}
	
	/**
	 * 根据orgSubId查找对应的orgId
	 * 
	 * @param orgId  String  组织机构编号 
	 * @return orgId  String  管理单位的组织机构编号
	 * @throws 无
	 */
	public String findCurOrgId(String orgSubId){
		
		if( orgSubId == null ){			
			orgSubId = "";
		}
		
		String orgId = "";
		
		String sql = "select t1.org_id" 
			+ " from comm_org_information t1,comm_org_subjection t2 where t1.org_id=t2.org_id and t2.org_subjection_id = '"
			+ orgSubId
			+ "' and t1.bsflag = '0' and t2.bsflag = '0'";
			
		Map info = jdbcDao.queryRecordBySQL(sql);
		
		//没有符合条件的纪录
		if (info == null || info.isEmpty()) {
			
			return "";		
		} 
		
		orgId = (String) info.get("orgId");
			
		return orgId;		
	}
	
	/**
	 * 根据orgId查找对应的orgSubjectionId
	 * 
	 * @param orgId  String  组织机构编号 
	 * @return commOrgSubjection  CommOrgSubjection  隶属关系对象
	 * @throws 无
	 */
	public String findOrgSubj(String orgId){
		
		if( orgId == null ){			
			orgId = "";
		}
		
		String sub = null;
		
		String sql = "select org_subjection_id from Comm_org_subjection sub"
			+ " where sub.org_id = '"+orgId+"'"
			+ " and sub.bsflag = '0'";
			
		Map info = jdbcDao.queryRecordBySQL(sql);
		
		//没有符合条件的纪录
		if (info == null || info.isEmpty()) {
			
			return "";		
		}  else {
			sub = (String) info.get("orgSubjectionId");
		}
			
		return sub;		
	}
	
	/**
	 * 读取orgTree.xml文件中的组织机构关系
	 * 根据传入的orgId查询兄弟机构
	 * @param orgId	查询的OrgId
	 * @return orgIds List跟查询的orgId平级的组织机构
	 */
	public List findOrgIdByXml(String orgId){
		List list = new ArrayList();
		try {
			SAXReader reader = new SAXReader();
			Document doc = reader.read(AuditDailyReportThread.class.getClassLoader().getResourceAsStream("orgTree.xml"));
			
			//根节点
			Element root = doc.getRootElement();
			
			recursion(list, root, orgId);
			
			System.out.println(list);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	private void recursion(List list, Element obj, String orgId) {
		Iterator i = obj.elementIterator("node");
		Iterator i1 = obj.elementIterator("node");
		while (i.hasNext()) {
			obj = (Element) i.next();
			System.out.println("orgSubId:"+obj.elementText("orgSubId")+"  orgId:"+obj.elementText("orgId"));
			if (orgId.equals(obj.elementText("orgId"))) {
				while (i1.hasNext()) {
					obj = (Element) i1.next();
					if ("1".equals(obj.elementText("flag"))) {
						continue;
					}
					list.add(obj.elementText("orgId"));
				}
				return;
			}
			if (!(obj.elementText("child") == null || "".equals(obj.elementText("child")))) {
				recursion(list, obj.element("child"), orgId);
			}
		}
		
	}
	
	/**
     * 获得月累统计开始时间
     * 
     * @param sendDate String 统计截止时间 
     * @return dateTemp String 当月开始时间
	 * @throws 无
     */
    public String getMonthStartDate(String sendDate) {
    	
        Date date1 = DateOperation.parseToUtilDate(sendDate);
        
        int day = date1.getDate();
        int month = date1.getMonth()+1;
        int year = date1.getYear()+1900;
        
        String dateTemp = "";
        
        dateTemp = String.valueOf(year) + "-" + String.valueOf(month) + "-" + String.valueOf(1);
        
        if(month == 1) {
        	
            dateTemp = String.valueOf(year-1) + "-" + String.valueOf(12) + "-"  + String.valueOf(31);
        }
            
        if(month == 12 && day == 31) {
        	
            dateTemp =  String.valueOf(year) + "-" + String.valueOf(month) + "-" + String.valueOf(day);
        }
        
        return dateTemp;
    }
    
    /**
     * 获得年累统计开始时间
     * 
     * @param sendDate String 统计截止时间 
     * @return dateTemp String 当年开始时间
	 * @throws 无
     */
    public String getYearStartDate(String sendDate) {
    	
        Date date1 = DateOperation.parseToUtilDate(sendDate);
        
        int day = date1.getDate();
        int month = date1.getMonth()+1;
        int year = date1.getYear()+1900;
        
        String dateTemp = "";
        
        if(month == 12 && day == 31) {
            dateTemp = String.valueOf( year ) + "-" + String.valueOf( month) + "-" + String.valueOf( day );
        } else {
            dateTemp =  String.valueOf( year-1 ) + "-" + String.valueOf( 12 ) + "-" + String.valueOf( 31 );
        }
        
        return dateTemp;
    }
    
    /**
     * 根据勘探方法，开始日期，结束日期、组织机构ID及codingCode统计数据(按甲方单位进行统计)
     * 
     * @param explorationMethod String 勘探方法
     * @param startDate String 开始日期
     * @param endDate String 结束日期
     * @param orgId String 组织机构Id
     * @param codingCode String  
     * @return list List 区外数据对象列表
     * @throws 无
     */
    public List staDailyReportOut( String explorationMethod, String startDate, String endDate, String orgId, String codingCode ) {

        String orgSubjectionId = findOrgSubj(orgId);
        
        String hql = "";
        
        if( explorationMethod.equals( "0300100012000000003" ) )//加多波后将多波数据加在了此处，2010-05-12
        	hql = "select sum(nvl(t1.daily_finishing_sp,0)) totalSp,sum(nvl(t1.finish_2d_workload,0)) total2dWorkload ,sum(nvl(t1.finish_3d_workload,0)) total3dWorkload from Rpt_Gp_Daily t1,Comm_Coding_Sort_Detail t2"
                + " where t1.bsflag='0'"
                + " and (t1.exploration_Method='0300100012000000003' or t1.exploration_Method='0300100012000000028') and t1.org_Subjection_Id like'"
                + orgSubjectionId
                + "%' and t1.send_Date <= to_date('"
                + endDate
                + "','yyyy-mm-dd') "
                + " and t1.send_Date >= to_date('"
                + startDate
                + "','yyyy-mm-dd') "
                + " and t1.hire_Org = t2.coding_Code_Id and t2.coding_Code like '"
                + codingCode + "%'";
        else 
            hql = "select sum(nvl(t1.daily_finishing_sp,0)) totalSp,sum(nvl(t1.finish_2d_workload,0)) total2dWorkload ,sum(nvl(t1.finish_3d_workload,0)) total3dWorkload from Rpt_Gp_Daily t1,Comm_Coding_Sort_Detail t2"
                + " where t1.bsflag='0'"
                + " and t1.exploration_Method= '"
                + explorationMethod
                + "' and t1.org_Subjection_Id like'"
                + orgSubjectionId
                + "%' and t1.send_Date <= to_date('"
                + endDate
                + "','yyyy-mm-dd') "
                + " and t1.send_Date >= to_date('"
                + startDate
                + "','yyyy-mm-dd') "
                + " and t1.hire_Org = t2.coding_Code_Id and t2.coding_Code like '"
                + codingCode + "%'";
        return jdbcDao.queryRecords(hql);
    }

	
	
	 /**
     * 通过日期和组织机构和甲方单位来汇总出局级日报工作量
     * 
     * @param sendDate 施工日期
     * @param orgId 组织机构
     * @return  list List 工作量对象列表
	 * @throws 无
     */
    public List findRptGpDailyTotals(String sendDate,String orgId) {
    	
    	//月统计开始日期
        String monthStartDate = getMonthStartDate(sendDate);        
        
        //年统计开始日期
        String yearStartDate = getYearStartDate(sendDate);    

        //存放统计完的日完成/月累/年累
        List listSta = new ArrayList();

        //所有工作量汇总数据列表
        List listTotal = new ArrayList();
        
        String total2dSp = "";//二维炮数
        String total3dSp = "";//三维炮数
        String total4dSp = "";//四维炮数
        String total2dWorkload = "";//二维工作量
        String total3dWorkload = ""; //三维工作量
        String total4dWorkload = ""; //四维工作量
        
        /*
         * 1、局日报日完成数据
         */
        Map r = new HashMap();

        //无法统计出的数据，默认置为０
        r.put("gravity_workload", "0");
        r.put("magnetic_workload", "0");
        r.put("electric_workload", "0");
        r.put("geochemical", "0");
        r.put("vsp", "0");
        
        Map map1 = jdbcDao.queryRecordBySQL("select * from rpt_gp_daily_total where send_date = to_date('"+sendDate+"','yyyy-MM-dd') and count_method = '1' and org_id = '"+orgId+"' ");
        if (map1 != null && !map1.isEmpty()) {
			//有值 更新现有的
        	r.put("gp_daily_id", r.get("gpDailyId"));
		}
        
        String codingCode = "";
        
      //获得某一甲方单位二维日完成炮数和二维日完成工作量
        listSta = staDailyReportOut( "0300100012000000002", sendDate, sendDate, orgId, codingCode );
        if( listSta != null && !listSta.isEmpty() ) {
            Map map = (Map) listSta.get(0);
            if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
                total2dSp = (String) map.get("totalsp");
            else
                total2dSp = "0";
            if( map != null && map.get("total2dworkload") != null && !"".equals((String) map.get("total2dworkload")))
                total2dWorkload = (String) map.get("total2dworkload");
            else
                total2dWorkload = "0";
        }
        
        //获得某一甲方单位三维日完成炮数和三维日完成工作量
        listSta = staDailyReportOut( "0300100012000000003", sendDate, sendDate, orgId, codingCode );
        if( listSta != null && !listSta.isEmpty() ) {
            Map map = (Map) listSta.get(0);
            if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
            	total3dSp = (String) map.get("totalsp");
            else
                total3dSp = "0";
            if( map != null && map.get("total3dworkload") != null && !"".equals((String) map.get("total3dworkload")))
                total3dWorkload = (String) map.get("total3dworkload");
            else
                total3dWorkload = "0";
        }
        
        //获得某一甲方单位四维日完成炮数和四维日完成工作量
        listSta = staDailyReportOut( "0300100012000000023", sendDate, sendDate, orgId, codingCode );
        if( listSta != null && !listSta.isEmpty() ) {
        	Map map = (Map) listSta.get(0);
        	if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
            	total4dSp = (String) map.get("totalsp");
            else
                total4dSp = "0";
        	if( map != null && map.get("total3dworkload") != null && !"".equals((String) map.get("total3dworkload")))
                total4dWorkload = (String) map.get("total3dworkload");
            else
                total4dWorkload = "0";
        }
        
        r.put("total_2d_sp", total2dSp);
        r.put("total_3d_sp", total3dSp);
        r.put("total_4d_sp", total4dSp);
        r.put("total_2d_workload", total2dWorkload);
        r.put("total_3d_workload", total3dWorkload);
        r.put("total_4d_workload", total4dWorkload);
        
        r.put("count_method", "1");//置统计方式，1标识日统计，2标识月统计，3标识年统计
        
        listTotal.add(r);
        
        r = new HashMap();
        
        map1 = jdbcDao.queryRecordBySQL("select * from rpt_gp_daily_total where send_date = to_date('"+sendDate+"','yyyy-MM-dd') and count_method = '2' and org_id = '"+orgId+"' ");
        if (map1 != null && !map1.isEmpty()) {
			//有值 更新现有的
        	r.put("gp_daily_id", r.get("gpDailyId"));
		}
        
      //无法统计出的数据，默认置为０
        r.put("gravity_workload", "0");
        r.put("magnetic_workload", "0");
        r.put("electric_workload", "0");
        r.put("geochemical", "0");
        r.put("vsp", "0");
        
      //获得某一甲方单位二维月完成炮数和二维月完成工作量
        listSta = staDailyReportOut( "0300100012000000002", monthStartDate, sendDate, orgId, codingCode );
        if( listSta != null && !listSta.isEmpty() ) {
            Map map = (Map) listSta.get(0);
            if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
                total2dSp = (String) map.get("totalsp");
            else
                total2dSp = "0";
            if( map != null && map.get("total2dworkload") != null && !"".equals((String) map.get("total2dworkload")))
                total2dWorkload = (String) map.get("total2dworkload");
            else
                total2dWorkload = "0";
        }
        
        //获得某一甲方单位三维月完成炮数和三维月完成工作量
        listSta = staDailyReportOut( "0300100012000000003", monthStartDate, sendDate, orgId, codingCode );
        if( listSta != null && !listSta.isEmpty() ) {
            Map map = (Map) listSta.get(0);
            if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
            	total3dSp = (String) map.get("totalsp");
            else
                total3dSp = "0";
            if( map != null && map.get("total3dworkload") != null && !"".equals((String) map.get("total3dworkload")))
                total3dWorkload = (String) map.get("total3dworkload");
            else
                total3dWorkload = "0";
        }
        
        //获得某一甲方单位四维月完成炮数和四维月完成工作量
        listSta = staDailyReportOut( "0300100012000000023", monthStartDate, sendDate, orgId, codingCode );
        if( listSta != null && !listSta.isEmpty() ) {
        	Map map = (Map) listSta.get(0);
        	if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
            	total4dSp = (String) map.get("totalsp");
            else
                total4dSp = "0";
        	if( map != null && map.get("total3dworkload") != null && !"".equals((String) map.get("total3dworkload")))
                total4dWorkload = (String) map.get("total3dworkload");
            else
                total4dWorkload = "0";
        }
        
        r.put("total_2d_sp", total2dSp);
        r.put("total_3d_sp", total3dSp);
        r.put("total_4d_sp", total4dSp);
        r.put("total_2d_workload", total2dWorkload);
        r.put("total_3d_workload", total3dWorkload);
        r.put("total_4d_workload", total4dWorkload);
        
        r.put("count_method", "2");//置统计方式，1标识日统计，2标识月统计，3标识年统计
        
        listTotal.add(r);
        
        r = new HashMap();
        
        map1 = jdbcDao.queryRecordBySQL("select * from rpt_gp_daily_total where send_date = to_date('"+sendDate+"','yyyy-MM-dd') and count_method = '3' and org_id = '"+orgId+"' ");
        if (map1 != null && !map1.isEmpty()) {
			//有值 更新现有的
        	r.put("gp_daily_id", r.get("gpDailyId"));
		}
        
        //无法统计出的数据，默认置为０
          r.put("gravity_workload", "0");
          r.put("magnetic_workload", "0");
          r.put("electric_workload", "0");
          r.put("geochemical", "0");
          r.put("vsp", "0");
          
        //获得某一甲方单位二维年完成炮数和二维年完成工作量
          listSta = staDailyReportOut( "0300100012000000002", yearStartDate, sendDate, orgId, codingCode );
          if( listSta != null && !listSta.isEmpty() ) {
              Map map = (Map) listSta.get(0);
              if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
                  total2dSp = (String) map.get("totalsp");
              else
                  total2dSp = "0";
              if( map != null && map.get("total2dworkload") != null && !"".equals((String) map.get("total2dworkload")))
                  total2dWorkload = (String) map.get("total2dworkload");
              else
                  total2dWorkload = "0";
          }
          
          //获得某一甲方单位三维年完成炮数和三维年完成工作量
          listSta = staDailyReportOut( "0300100012000000003", yearStartDate, sendDate, orgId, codingCode );
          if( listSta != null && !listSta.isEmpty() ) {
              Map map = (Map) listSta.get(0);
              if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
              	total3dSp = (String) map.get("totalsp");
              else
                  total3dSp = "0";
              if( map != null && map.get("total3dworkload") != null && !"".equals((String) map.get("total3dworkload")))
                  total3dWorkload = (String) map.get("total3dworkload");
              else
                  total3dWorkload = "0";
          }
          
          //获得某一甲方单位四维年完成炮数和四维年完成工作量
          listSta = staDailyReportOut( "0300100012000000023", yearStartDate, sendDate, orgId, codingCode );
          if( listSta != null && !listSta.isEmpty() ) {
          	Map map = (Map) listSta.get(0);
          	if( map != null && map.get("totalsp") != null && !"".equals((String) map.get("totalsp")))
              	total4dSp = (String) map.get("totalsp");
              else
                  total4dSp = "0";
          	if( map != null && map.get("total3dworkload") != null && !"".equals((String) map.get("total3dworkload")))
                  total4dWorkload = (String) map.get("total3dworkload");
              else
                  total4dWorkload = "0";
          }
          
          r.put("total_2d_sp", total2dSp);
          r.put("total_3d_sp", total3dSp);
          r.put("total_4d_sp", total4dSp);
          r.put("total_2d_workload", total2dWorkload);
          r.put("total_3d_workload", total3dWorkload);
          r.put("total_4d_workload", total4dWorkload);
          
          r.put("count_method", "3");//置统计方式，1标识日统计，2标识月统计，3标识年统计
          
          listTotal.add(r);
    	
    	return listTotal;
    }
    
    /**
     * 查询物探公司下的小队总数（包括地震队，非地震队，VSP队数）
     * 
     * @param orgId String 物探公司的orgId
     * @return map Map 表单参数
     * @throws 无
     */
    public List loadTotalTeam(String orgId) {
    	
    	//根据orgId查询其subjectionId
    	String subjectionId = this.findOrgSubj(orgId);
    	
    	List list = new ArrayList();
    	
    	Map map = null;
    	
    	Map num = new HashMap();
    	
    	String codingCode = null;
    	
    	int seismicTotalTeam = 0;
    	
		//查询地震队数的hql
		String hql1 = "select count(distinct t3.team_name) from Comm_Org_Team t3,Comm_Org_Subjection t4,Comm_Coding_Sort_Detail t5,Comm_Org_Information t1"
			+ " where t4.father_Org_Id like '"
			+ subjectionId
			+ "%' and t4.org_id = t3.org_Id"
			+ " and t3.team_Specialty = t5.coding_Code_Id"
			+ " and t5.coding_Name = '地震队'"
			+ " and t1.org_Id = t3.org_Id"
			+ " and t1.authorized_Org_If != '0'"//屏蔽虚拟组织机构
			+ " and t1.bsflag = '0'"
			+ " and t3.bsflag = '0'"
			+ " and t4.bsflag = '0'"
			+ " and t5.bsflag = '0'";
		
		//修改为局级首页一致
		hql1="select count(a.org_Id) as totalCount from Comm_Org_Team a,Comm_Org_Subjection b "
			+" where a.org_Id=b.org_Id "
			+" and b.father_Org_Id like '"+subjectionId
			+"%' and a.team_Specialty='0100100015000000017'" //地震队
			+" and a.if_Registered='1'" // 已注册，表示有资质的
			+" and a.bsflag='0'"
			+" and b.bsflag='0'";
		Map listEarthTotal = jdbcDao.queryRecordBySQL(hql1);
		
		num.put("seismic_total_team", listEarthTotal.get("totalcount"));
		
		//查询非地震队（综合物化探）数的hql
		String hql2 = "select count(distinct t3.teamName) from CommOrgTeam t3,CommOrgSubjection t4,CommCodingSortDetail t5,CommOrgInformation t1"
			+ " where t4.fatherOrgId like '"
			+ subjectionId
			+ "%' and t4.commOrgInformation = t3.orgId"
			+ " and t3.teamSpecialty = t5.codingCodeId"
			+ " and t5.codingName = '综合物化探队'"
			+ " and t1.orgId = t3.orgId"
			+ " and t1.authorizedOrgIf != '0'"//屏蔽虚拟组织机构
			+ " and t1.bsflag = '0'"
			+ " and t3.bsflag = '0'"
			+ " and t4.bsflag = '0'"
			+ " and t5.bsflag = '0'";
		
		//修改为局级首页一致
		hql2="select count(a.org_Id) as totalCount from Comm_Org_Team a,Comm_Org_Subjection b "
			+" where a.org_Id=b.org_Id "
			+" and b.father_Org_Id like '"+subjectionId
			+"%' and a.team_Specialty='0100100015000000014'" //非地震队
			+" and a.if_Registered='1'" // 已注册，表示有资质的
			+" and a.bsflag='0'"
			+" and b.bsflag='0'";
		
		Map listNoEarthTotal = jdbcDao.queryRecordBySQL(hql2);
		
		num.put("non_seismic_total_team",listNoEarthTotal.get("totalcount"));
		
		//查询VSP队数的hql
		String hql3 = "select count(distinct t3.teamName) from CommOrgTeam t3,CommOrgSubjection t4,CommCodingSortDetail t5,CommOrgInformation t1"
			+ " where t4.fatherOrgId like '"
			+ subjectionId
			+ "%' and t4.commOrgInformation = t3.orgId"
			+ " and t3.teamSpecialty = t5.codingCodeId"
			+ " and t5.codingName = 'VSP队'"
			+ " and t1.org_Id = t3.org_Id"
			+ " and t1.authorizedOrgIf != '0'"//屏蔽虚拟组织机构
			+ " and t1.bsflag = '0'"
			+ " and t3.bsflag = '0'"
			+ " and t4.bsflag = '0'"
			+ " and t5.bsflag = '0'";
		
		//修改为局级首页一致
		hql3="select count(a.org_Id) as totalCount from Comm_Org_Team a,Comm_Org_Subjection b "
			+" where a.org_Id=b.org_Id "
			+" and b.father_Org_Id like '"+subjectionId
			+"%' and a.team_Specialty='0100100015000000018'" //VSP队
			+" and a.if_Registered='1'" // 已注册，表示有资质的
			+" and a.bsflag='0'"
			+" and b.bsflag='0'";
		
		Map listVSPTotal = jdbcDao.queryRecordBySQL(hql3);
		
		num.put("vsp_total_team",listVSPTotal.get("totalcount"));
		
		hql3="select count(a.org_Id) as totalCount from Comm_Org_Team a,Comm_Org_Subjection b "
				+" where a.org_Id=b.org_Id "
				+" and b.father_Org_Id like '"+subjectionId
				+"%' and a.team_Specialty='0100100015000000033'" //其他
				+" and a.if_Registered='1'" // 已注册，表示有资质的
				+" and a.bsflag='0'"
				+" and b.bsflag='0'";
		
		Map listOtherTotal = jdbcDao.queryRecordBySQL(hql3);
		
		num.put("other_total_team",listOtherTotal.get("totalcount"));
		
		list.add(num);

        return list;
    }
    
    /**
     * 根据勘探方法、施工日期、组织机构ID及codingCode统计队伍动态数据(按甲方单位进行统计)
     * 
     * @param explorationMethod String 勘探方法
     * @param sendDate String 施工日期
     * @param orgId String 组织机构Id
     * @param codingCode String 
     * @return list List 队伍动态数据
     * @throws 无
     */
    public List staDailyReportTeamOut(String explorationMethod, String sendDate, String orgId) {

        String hql = "";
        
        //根据orgId查询其subjectionId
    	String subjectionId = this.findOrgSubj( orgId );
    	
    	if (explorationMethod == null || "".equals(explorationMethod)) {
			hql = "select count(distinct t1.project_Org_Name) from Rpt_Gp_Daily t1"
				+ " where t1.bsflag = '0' and t1.send_Date = to_date('"
				+ sendDate
				+ "','yyyy-MM-dd')"
				+ " and t1.project_Status = '5000100001000000002'";
		} else if( explorationMethod.equals( "0300100012000000003" ) ){//加多波后将多波数据加在了此处，2010-05-12
            hql = "select count(distinct t1.project_Org_Name) from Rpt_Gp_Daily t1"
                + " where t1.bsflag='0' and t1.send_Date = to_date('"
                + sendDate
                + "','yyyy-MM-dd')"
                + " and (t1.exploration_Method='0300100012000000003' or t1.exploration_Method='0300100012000000028') "
                + " and t1.project_Status = '5000100001000000002'";  
		}else {
        	hql = "select count(distinct t1.project_Org_Name) from Rpt_Gp_Daily t1"
                + " where t1.bsflag='0' and t1.send_Date = to_date('"
                + sendDate
                + "','yyyy-MM-dd')"
                + " and t1.exploration_Method = '"
                + explorationMethod
                + "' and t1.project_Status = '5000100001000000002'";  
		}
    	
    	
    	if (explorationMethod == null || "".equals(explorationMethod)) {
			hql = " select count(distinct t5.team_Id) num"
				+ " from Gp_Task_Project t1,Gp_Task_Project_Dynamic t2,Gp_Ops_Daily_Report t3,Gp_Ops_Daily_Produce_Sit t4,Comm_Org_Team t5 "
				+ " where t1.project_Info_No = t2.project_Info_No "
				+ " and t1.bsflag = '0' and t2.bsflag = '0' and t4.bsflag = '0'"
				+ " and (t2.exploration_Method = t1.exploration_Method or t2.exploration_Method is null)"
				+ " and t1.project_Info_No = t3.project_Info_No"
				+ " and (t3.exploration_Method = t1.exploration_Method or t3.exploration_Method is null)"
				+ " and t4.daily_No = t3.daily_No"
				+ " and t3.audit_Status = '3'"
				+ " and t5.org_Id = t3.org_Id"
				+ " and to_char(t3.produce_Date,'yyyy-MM-dd') = '"+sendDate+"'"
				+ " and t4.if_Build not in('9')"
				+ " and t2.org_Subjection_Id like '"+subjectionId+"%'";
		} else if (explorationMethod.equals( "0300100012000000003" )) {
			hql = " select count(distinct t5.team_Id) num"
				+ " from Gp_Task_Project t1,Gp_Task_Project_Dynamic t2,Gp_Ops_Daily_Report t3,Gp_Ops_Daily_Produce_Sit t4,Comm_Org_Team t5 "
				+ " where t1.project_Info_No = t2.project_Info_No "
				+ " and t1.bsflag = '0' and t2.bsflag = '0' and t4.bsflag = '0'"
				+ " and (t2.exploration_Method = t1.exploration_Method or t2.exploration_Method is null)"
				+ " and t1.project_Info_No = t3.project_Info_No"
				+ " and (t3.exploration_Method = t1.exploration_Method or t3.exploration_Method is null)"
				+ " and t4.daily_No = t3.daily_No"
				+ " and t3.audit_Status = '3'"
				+ " and t5.org_Id = t3.org_Id"
				+ " and to_char(t3.produce_Date,'yyyy-MM-dd') = '"+sendDate+"'"
				+ " and t4.if_Build not in('9')"
				+ " and t2.org_Subjection_Id like '"+subjectionId+"%'"
				+ " and t1.exploration_Method = '"+explorationMethod+"'";
		} else {
			hql = " select count(distinct t5.team_Id) num"
				+ " from Gp_Task_Project t1,Gp_Task_Project_Dynamic t2,Gp_Ops_Daily_Report t3,Gp_Ops_Daily_Produce_Sit t4,Comm_Org_Team t5 "
				+ " where t1.project_Info_No = t2.project_Info_No "
				+ " and t1.bsflag = '0' and t2.bsflag = '0' and t4.bsflag = '0'"
				+ " and (t2.exploration_Method = t1.exploration_Method or t2.exploration_Method is null)"
				+ " and t1.project_Info_No = t3.project_Info_No"
				+ " and (t3.exploration_Method = t1.exploration_Method or t3.exploration_Method is null)"
				+ " and t4.daily_No = t3.daily_No"
				+ " and t3.audit_Status = '3'"
				+ " and t5.org_Id = t3.org_Id"
				+ " and to_char(t3.produce_Date,'yyyy-MM-dd') = '"+sendDate+"'"
				+ " and t4.if_Build not in('9')"
				+ " and t2.org_Subjection_Id like '"+subjectionId+"%'"
				+ " and t1.exploration_Method = '"+explorationMethod+"'";
		}

        return jdbcDao.queryRecords(hql);
    }
    
    /**
     * 通过日期和组织机构统计出队伍动态
     * 
     * @param sendDate String 施工日期
     * @param orgId String 组织机构Id
     * @return list List 队伍动态数据
     * @throws 无
     */
    public List findRptGpDailyTotalTeams(String sendDate,String orgId) {
    	
    	//获得地震队总数，非地震队总数和VSP队总数
        List mapTeamTotal = loadTotalTeam(orgId);
        
        Map totalTeam = null;

        //listTeamTotal存队伍动态
        List listTeamTotal = new ArrayList();
        
        Long total2dUseTeam = new Long( "0" );//二维动用队数
        Long total3dUseTeam = new Long( "0" );//三维动用队数
        Long total4dUseTeam = new Long( "0" );//四维动用队数
        Long totalUseTeam = new Long( "0" );//总动用队数
        
        Map r = new HashMap();
        
        Map map1 = jdbcDao.queryRecordBySQL("select * from rpt_gp_daily_total_team where send_date = to_date('"+sendDate+"','yyyy-MM-dd') and org_id = '"+orgId+"' and bsflag = '0' ");
        if (map1 != null && !map1.isEmpty()) {
			//有值 更新现有的
        	r.put("gp_daily_id", map1.get("gpDailyId"));
		}

        totalTeam = (Map) mapTeamTotal.get(0);
        
        r.putAll(totalTeam);
        
        List listbyCode = new ArrayList();

        //获得二维动用队数
        listbyCode = staDailyReportTeamOut( "0300100012000000002", sendDate, orgId );
        
        if( listbyCode != null && listbyCode.size() > 0 )
        	r.put("total_2d_use_team", ((Map) listbyCode.get(0)).get("num"));
        
      //获得三维动用队数
        listbyCode = staDailyReportTeamOut( "0300100012000000003", sendDate, orgId );
        
        if( listbyCode != null && listbyCode.size() > 0 )
        	r.put("total_3d_use_team", ((Map) listbyCode.get(0)).get("num"));
        
      //获得四维动用队数
        listbyCode = staDailyReportTeamOut( "0300100012000000023", sendDate, orgId );
        
        if( listbyCode != null && listbyCode.size() > 0 )
        	r.put("total_4d_use_team", ((Map) listbyCode.get(0)).get("num"));
        
        listbyCode = staDailyReportTeamOut( null, sendDate, orgId );
        
        if( listbyCode != null && listbyCode.size() > 0 )
        	r.put("total_use_team", ((Map) listbyCode.get(0)).get("num"));
        
        r.put("other_use_team", "0");
        r.put("other_total_team", "0");
        r.put("gravity_use_team", "0");
        r.put("magnatic_use_team", "0");
        r.put("electric_use_team", "0");
        r.put("geochemical_use_team", "0");
        r.put("vsp_use_team", "0");
        
        listTeamTotal.add(r);
        
        return listTeamTotal;
    }
	
	
}
