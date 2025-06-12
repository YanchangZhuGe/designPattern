package com.bgp.mcs.service.ws.pm.service.dailyReport;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.workload.WorkloadMCSBean;
import com.bgp.mcs.service.pm.service.project.DailyReportProcessRatePOJO;
import com.bgp.mcs.service.pm.service.project.ProjectMCSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class WsDailyReportPlanSrv extends BaseService {
	
	private ILog log;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	
	public WsDailyReportPlanSrv() {
		log = LogFactory.getLogger(WsDailyReportPlanSrv.class);
	}
	
	java.text.DecimalFormat df_1 =new java.text.DecimalFormat("#.000"); 
	
	public ISrvMsg queryDailyReport(ISrvMsg reqDTO) throws Exception{
		
		String org_subjection_id = (String) reqDTO.getValue("orgSubjectionId");
		
		String project_name = (String) reqDTO.getValue("projectName");
		
		String[] projectNames = project_name.split("");//分解成单字符
		
		project_name = "%";
		
		for (int i = 0; i < projectNames.length; i++) {
			project_name += projectNames[i]+"%";
		}
		
		String org_name = (String) reqDTO.getValue("orgName");
		
		String[] orgNames = org_name.split("");
		
		org_name = "%";
		
		for (int i = 0; i < orgNames.length; i++) {
			org_name += orgNames[i]+"%";
		}
		
		String audit_status = (String) reqDTO.getValue("auditStatus");
		
		String project_status = (String) reqDTO.getValue("projectStatus");
		
		String project_type = (String) reqDTO.getValue("projectType");
		
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
		
		String sql = "select * from (select row_number() over (partition  by r.project_info_no order by r.produce_date desc) as row_num,r.*,gp.project_name,oi.org_abbreviation as org_name,r.org_id as report_org_id,gp.project_type as gp_project_type,gp.exploration_method as gp_exploration_method,gp.project_start_time as gp_start_time,gp.project_end_time as gp_end_time " +
				" from gp_ops_daily_report r " +
				" join gp_task_project gp on gp.project_info_no = r.project_info_no and gp.project_name like '"+project_name+"' and gp.bsflag = '0' and gp.project_status like '%"+project_status+"%' and project_type like '%"+project_type+"%' "+
				" join comm_org_information oi on oi.org_id = r.org_id and oi.org_name like '"+org_name+"' and oi.bsflag = '0' "+
				" where r.bsflag = '0' and r.org_subjection_id like '"+org_subjection_id+"%' " +
				" and r.audit_status like '%"+audit_status+"%' "+
				" ) where row_num = 1 ";
		
		//Map map = jdbcDao.queryRecordBySQL(sql);
		
		page = radDao.queryRecordsBySQL(sql, page);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		return msg;
		
	}
	
	public ISrvMsg getAuditInfo(ISrvMsg reqDTO) throws Exception{
		
		
		String daily_no = reqDTO.getValue("dailyNo");
		
		String sql = "select r.*,h.employee_name,adm.*  from gp_ops_daily_report r" +
				" left join gp_adm_data_examine adm on r.daily_no = adm.data_no and adm.bsflag = '0' " +
				" left join comm_human_employee h on h.employee_id = r.ratifier and h.bsflag = '0' " +
				" where daily_no = '"+daily_no+"' ";
		
		Map map = jdbcDao.queryRecordBySQL(sql);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("auditMap", map);
		
		return msg;
	}
	
	@Deprecated 
	public Map getDailyReport(Map map){
		
		String dailyNo = (String) map.get("dailyNo");
		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");
		
		if (dailyNo == null || "".equals(dailyNo)) {
			dailyNo = (String) map.get("daily_no");
		}
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map.get("produce_date");
		}
		
		String sql = "";
		
		if (produceDate != null && !"".equals(produceDate) && produceDate != "null" && !"null".equals(produceDate)) {
			sql = "select * from gp_ops_daily_report r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' " +
					" join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) " +
					" where r.project_info_no = '"+projectInfoNo+"'  and r.bsflag = '0' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') ";
		} else {
			sql = "select * from gp_ops_daily_report r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' " +
					" join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) " +
					" where r.daily_no = '"+dailyNo+"'  and r.bsflag = '0' ";
		}
		
		Map dailyReport = jdbcDao.queryRecordBySQL(sql);
		
		sql = "select sum(nvl(r.DAILY_SURVEY_SHOT_NUM,0)) as project_survey_shot_num " +
				",sum(nvl(r.DAILY_SURVEY_GEOPHONE_NUM,0)) as project_survey_geophone_num "+
				",sum(nvl(r.survey_incept_workload,0)) as project_survey_incept_workload "+
				",sum(nvl(r.survey_shot_workload,0)) as project_survey_shot_workload "+
				",sum(nvl(r.daily_micro_measue_point_num,0)) as project_micro_measue_num"+
				",sum(nvl(r.daily_small_refraction_num,0)) as project_small_refraction_num"+
				",sum(nvl(r.daily_drill_sp_num,0)) as project_drill_sp_num"+
				",sum(nvl(r.daily_drill_well_num,0)) as project_drill_well_num"+
				",sum(nvl(r.daily_drill_footage_num,0)) as project_drill_footage_num"+
				",sum(nvl(r.daily_acquire_sp_num,0)+nvl(r.daily_jp_acquire_shot_num,0)+nvl(r.daily_qq_acquire_shot_num,0)) as project_acquire_sp_num"+
				",sum(nvl(r.daily_acquire_workload,0)+nvl(r.daily_jp_acquire_workload,0)+nvl(r.daily_qq_acquire_workload,0)) as project_acquire_workload"+
				",sum(nvl(r.daily_acquire_qualified_num,0)) as project_qualified_sp_num"+
				",sum(nvl(r.daily_acquire_firstlevel_num,0)) as project_firstlevel_sp_num"+
				",sum(nvl(r.collect_2_class,0)) as project_collect_2_class"+
				",sum(nvl(r.collect_waster_num,0)) as project_collect_waster_num"+
				",sum(nvl(r.collect_miss_num,0)) as project_collect_miss_num"+
				",sum(nvl(r.daily_test_sp_num,0)) as project_test_sp_num"+
				",sum(nvl(r.daily_test_qualified_sp_num,0)) as project_qualified_test_sp_num"+
				" from gp_ops_daily_report r where project_info_no = '"+projectInfoNo+"' ";
		
		if (produceDate != null && !"".equals(produceDate) && produceDate != "null" && !"null".equals(produceDate)) {
			sql += " and produce_date <= to_date('"+produceDate+"','yyyy-MM-dd') ";
		}
		
		Map map1 = jdbcDao.queryRecordBySQL(sql);
		
		try {
			dailyReport.putAll(map1);
		} catch (NullPointerException e) {
			//map为空
			dailyReport = map1;
			dailyReport.put("produceDate", produceDate);
		}
		
		DecimalFormat df = new DecimalFormat();
		String style = "0.00%";
		
		df.applyPattern(style);
		
		//测量日完成总点
		if (dailyReport.get("dailySurveyShotNum") == null || "".equals(dailyReport.get("dailySurveyShotNum"))) {
			dailyReport.put("dailySurveyShotNum", "0");
		}
		if (dailyReport.get("dailySurveyGeophoneNum") == null || "".equals(dailyReport.get("dailySurveyGeophoneNum"))) {
			dailyReport.put("dailySurveyGeophoneNum", "0");
		}
		dailyReport.put("dailySurveyTotalNum", P6TypeConvert.convertLong(dailyReport.get("dailySurveyShotNum"))+P6TypeConvert.convertLong(dailyReport.get("dailySurveyGeophoneNum")) );
		
		//各种比率
		double designNum = 0.0;
		double actualNum = 0.0;
		
		//测量完成
		if (dailyReport.get("designSpNum") == null || "".equals(dailyReport.get("designSpNum"))) {
			dailyReport.put("designSpNum", "0");
		}
		if (dailyReport.get("designGeophoneNum") == null || "".equals(dailyReport.get("designGeophoneNum"))) {
			dailyReport.put("designGeophoneNum", "0");
		}
		if (dailyReport.get("projectSurveyShotNum") == null || "".equals(dailyReport.get("projectSurveyShotNum"))) {
			dailyReport.put("projectSurveyShotNum", "0");
		}
		if (dailyReport.get("projectSurveyGeophoneNum") == null || "".equals(dailyReport.get("projectSurveyGeophoneNum"))) {
			dailyReport.put("projectSurveyGeophoneNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("designSpNum"))+P6TypeConvert.convertDouble(dailyReport.get("designGeophoneNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectSurveyRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectSurveyShotNum"))+P6TypeConvert.convertDouble(dailyReport.get("projectSurveyGeophoneNum"));
			dailyReport.put("projectSurveyRatio", df.format((actualNum/designNum)));
		}
		
		//钻井炮点
		if (dailyReport.get("designDrillNum") == null || "".equals(dailyReport.get("designDrillNum"))) {
			dailyReport.put("designDrillNum", "0");
		}
		if (dailyReport.get("projectDrillSpNum") == null || "".equals(dailyReport.get("projectDrillSpNum"))) {
			dailyReport.put("projectDrillSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("designDrillNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectDrillSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectDrillSpNum"));
			dailyReport.put("projectDrillSpRatio", df.format((actualNum/designNum)));
		}
		
		//钻井 检波点
		if (dailyReport.get("designGeophoneNum") == null || "".equals(dailyReport.get("designGeophoneNum"))) {
			dailyReport.put("designGeophoneNum", "0");
		}
		if (dailyReport.get("projectSurveyGeophoneNum") == null || "".equals(dailyReport.get("projectSurveyGeophoneNum"))) {
			dailyReport.put("projectSurveyGeophoneNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("designGeophoneNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectSurveyRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectSurveyGeophoneNum"));
			dailyReport.put("projectSurveyRatio", df.format((actualNum/designNum)));
		}
		
		//采集 炮点
		if (dailyReport.get("designSpNum") == null || "".equals(dailyReport.get("designSpNum"))) {
			dailyReport.put("designSpNum", "0");
		}
		if (dailyReport.get("projectAcquireSpNum") == null || "".equals(dailyReport.get("projectAcquireSpNum"))) {
			dailyReport.put("projectAcquireSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("designSpNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectAcquireSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
			dailyReport.put("projectAcquireSpRatio", df.format((actualNum/designNum)));
		}
		
		//采集 工作量
		if (dailyReport.get("fullFoldWorkload") == null || "".equals(dailyReport.get("fullFoldWorkload"))) {
			dailyReport.put("fullFoldWorkload", "0");
		}
		if (dailyReport.get("projectAcquireWorkload") == null || "".equals(dailyReport.get("projectAcquireWorkload"))) {
			dailyReport.put("projectAcquireWorkload", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("fullFoldWorkload"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectAcquireWorkRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireWorkload"));
			dailyReport.put("projectAcquireWorkRatio", df.format((actualNum/designNum)));
		}
		
		//采集 合格炮
		if (dailyReport.get("projectAcquireSpNum") == null || "".equals(dailyReport.get("projectAcquireSpNum"))) {
			dailyReport.put("projectAcquireSpNum", "0");
		}
		if (dailyReport.get("projectQualifiedSpNum") == null || "".equals(dailyReport.get("projectQualifiedSpNum"))) {
			dailyReport.put("projectQualifiedSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectQualifiedSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectQualifiedSpNum"));
			dailyReport.put("projectQualifiedSpRatio", df.format((actualNum/designNum)));
		}
		
		//采集 一级炮
		if (dailyReport.get("projectFirstlevelSpNum") == null || "".equals(dailyReport.get("projectFirstlevelSpNum"))) {
			dailyReport.put("projectFirstlevelSpNum", "0");
		}
		//designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectFirstlevelSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectFirstlevelSpNum"));
			dailyReport.put("projectFirstlevelSpRatio", df.format((actualNum/designNum)));
		}
		
		//采集 二级炮
		if (dailyReport.get("projectCollect2Class") == null || "".equals(dailyReport.get("projectCollect2Class"))) {
			dailyReport.put("projectCollect2Class", "0");
		}
		//designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectCollect2ClassRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectCollect2Class"));
			dailyReport.put("projectCollect2ClassRatio", df.format((actualNum/designNum)));
		}
		
		//采集 废炮
		if (dailyReport.get("projectCollectWasterNum") == null || "".equals(dailyReport.get("projectCollectWasterNum"))) {
			dailyReport.put("projectCollectWasterNum", "0");
		}
		//designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectCollectWasterNumRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectCollectWasterNum"));
			dailyReport.put("projectCollectWasterNumRatio", df.format((actualNum/designNum)));
		}
		
		//采集 空炮
		if (dailyReport.get("projectCollectMissNum") == null || "".equals(dailyReport.get("projectCollectMissNum"))) {
			dailyReport.put("projectCollectMissNum", "0");
		}
		//designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
		
		if (designNum == 0.0) {
			dailyReport.put("projectCollectMissNumRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport.get("projectCollectMissNum"));
			dailyReport.put("projectCollectMissNumRatio", df.format((actualNum/designNum)));
		}
		
		return dailyReport;
	}
	
	public Map getDailyReportNew(Map map){
		
		String dailyNo = (String) map.get("dailyNo");
		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");
		
		if (dailyNo == null || "".equals(dailyNo)) {
			dailyNo = (String) map.get("daily_no");
		}
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map.get("produce_date");
		}
		
		String sql = "";
		
		if (produceDate != null && !"".equals(produceDate) && produceDate != "null" && !"null".equals(produceDate)) {
			sql = "select * from gp_ops_daily_report r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' " +
					" join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) " +
					" where r.project_info_no = '"+projectInfoNo+"'  and r.bsflag = '0' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') ";
		} else {
			sql = "select * from gp_ops_daily_report r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' " +
					" join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) " +
					" where r.daily_no = '"+dailyNo+"'  and r.bsflag = '0' ";
		}
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		
		Map dailyReport = new HashMap();
		if(list != null){
			if (list.size() != 0) {
				dailyReport = (Map) list.get(0);
				produceDate = ((Timestamp) dailyReport.get("PRODUCE_DATE")).toString().substring(0, 10);
				projectInfoNo = (String) dailyReport.get("PROJECT_INFO_NO");
			
			
			sql = "select sum(nvl(r.DAILY_SURVEY_SHOT_NUM,0)) as project_survey_shot_num " +
					",sum(nvl(r.DAILY_SURVEY_GEOPHONE_NUM,0)) as project_survey_geophone_num "+
					",sum(nvl(r.survey_incept_workload,0)) as project_survey_incept_workload "+
					",sum(nvl(r.survey_shot_workload,0)) as project_survey_shot_workload "+
					",sum(nvl(r.survey_shot_workload,0))+sum(nvl(r.survey_incept_workload,0)) as project_survey_total_workload "+
					",sum(nvl(r.daily_micro_measue_point_num,0)) as project_micro_measue_num"+
					",sum(nvl(r.daily_small_refraction_num,0)) as project_small_refraction_num"+
					",sum(nvl(r.daily_drill_sp_num,0)) as project_drill_sp_num"+
					",sum(nvl(r.daily_drill_well_num,0)) as project_drill_well_num"+
					",sum(nvl(r.daily_drill_footage_num,0)) as project_drill_footage_num"+
					",sum(nvl(r.daily_acquire_sp_num,0)+nvl(r.daily_jp_acquire_shot_num,0)+nvl(r.daily_qq_acquire_shot_num,0)) as project_acquire_sp_num"+
					",sum(nvl(r.daily_acquire_workload,0)+nvl(r.daily_jp_acquire_workload,0)+nvl(r.daily_qq_acquire_workload,0)) as project_acquire_workload"+
					",sum(nvl(r.daily_acquire_qualified_num,0)) as project_qualified_sp_num"+
					",sum(nvl(r.daily_acquire_firstlevel_num,0)) as project_firstlevel_sp_num"+
					",sum(nvl(r.collect_2_class,0)) as project_collect_2_class"+
					",sum(nvl(r.collect_waster_num,0)) as project_collect_waster_num"+
					",sum(nvl(r.collect_miss_num,0)) as project_collect_miss_num"+
					",sum(nvl(r.daily_test_sp_num,0)) as project_test_sp_num"+
					",sum(nvl(r.daily_test_qualified_sp_num,0)) as project_qualified_test_sp_num"+
					" from gp_ops_daily_report r where r.audit_status = '3' and r.project_info_no = '"+projectInfoNo+"' and r.bsflag = '0'";
			
			if (produceDate != null && !"".equals(produceDate) && produceDate != "null" && !"null".equals(produceDate)) {
				sql += " and produce_date <= to_date('"+produceDate+"','yyyy-MM-dd') ";
			}
			
			dailyReport.put("PRODUCE_DATE", produceDate);
			
			list = radDao.getJdbcTemplate().queryForList(sql);
			
			if (list != null && list.size() != 0) {
				dailyReport.putAll(list.get(0));
			}
			
			for (Iterator i = dailyReport.entrySet().iterator(); i.hasNext();) {
				Map.Entry entry1=(Map.Entry)i.next();
				if (entry1.getValue() == "" || "".equals(entry1.getValue()) || entry1.getValue() == "null" || "null".equals(entry1.getValue()) || entry1.getValue() == null) {
					dailyReport.put(entry1.getKey(), "0");
				}
			}
			
			DecimalFormat df = new DecimalFormat();
			String style = "0.00%";
			
			df.applyPattern(style);
			
			//测量日完成总点
			if (dailyReport.get("DAILY_SURVEY_SHOT_NUM") == null || "".equals(dailyReport.get("DAILY_SURVEY_SHOT_NUM"))) {
				dailyReport.put("DAILY_SURVEY_SHOT_NUM", "0");
			}
			if (dailyReport.get("PROJECT_SURVEY_SHOT_NUM") == null || "".equals(dailyReport.get("PROJECT_SURVEY_SHOT_NUM"))) {
				dailyReport.put("PROJECT_SURVEY_SHOT_NUM", "0");
			}
			dailyReport.put("DAILY_SURVEY_TOTAL_NUM", P6TypeConvert.convertLong(dailyReport.get("DAILY_SURVEY_SHOT_NUM"))+P6TypeConvert.convertLong(dailyReport.get("PROJECT_SURVEY_SHOT_NUM")) );
			
			//各种比率
			double designNum = 0.0;
			double actualNum = 0.0;
			
			//测量完成
			if (dailyReport.get("DESIGN_SP_NUM") == null || "".equals(dailyReport.get("DESIGN_SP_NUM"))) {
				dailyReport.put("DESIGN_SP_NUM", "0");
			}
			if (dailyReport.get("DESIGN_GEOPHONE_NUM") == null || "".equals(dailyReport.get("DESIGN_GEOPHONE_NUM"))) {
				dailyReport.put("DESIGN_GEOPHONE_NUM", "0");
			}
			if (dailyReport.get("PROJECT_SURVEY_SHOT_NUM") == null || "".equals(dailyReport.get("PROJECT_SURVEY_SHOT_NUM"))) {
				dailyReport.put("PROJECT_SURVEY_SHOT_NUM", "0");
			}
			if (dailyReport.get("PROJECT_SURVEY_GEOPHONE_NUM") == null || "".equals(dailyReport.get("PROJECT_SURVEY_GEOPHONE_NUM"))) {
				dailyReport.put("PROJECT_SURVEY_GEOPHONE_NUM", "0");
			}
			designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_SP_NUM"))+P6TypeConvert.convertDouble(dailyReport.get("DESIGN_GEOPHONE_NUM"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_SURVEY_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_SURVEY_SHOT_NUM"))+P6TypeConvert.convertDouble(dailyReport.get("PROJECT_SURVEY_GEOPHONE_NUM"));
				dailyReport.put("PROJECT_SURVEY_RATIO", df.format((actualNum/designNum)));
			}
			
			//测量公里完成%
			designNum = P6TypeConvert.convertDouble(dailyReport.get("MEASURE_KM"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_SURVEY_KM_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_SURVEY_INCEPT_WORKLOAD"))+P6TypeConvert.convertDouble(dailyReport.get("PROJECT_SURVEY_SHOT_WORKLOAD"));
				dailyReport.put("PROJECT_SURVEY_KM_RATIO", df.format((actualNum/designNum)));
			}
			
			//钻井炮点
			if (dailyReport.get("DESIGN_DRILL_NUM") == null || "".equals(dailyReport.get("DESIGN_DRILL_NUM"))) {
				dailyReport.put("DESIGN_DRILL_NUM", "0");
			}
			if (dailyReport.get("PROJECT_DRILL_SP_NUM") == null || "".equals(dailyReport.get("PROJECT_DRILL_SP_NUM"))) {
				dailyReport.put("PROJECT_DRILL_SP_NUM", "0");
			}
			designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_DRILL_NUM"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_DRILL_SP_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_DRILL_SP_NUM"));
				dailyReport.put("PROJECT_DRILL_SP_RATIO", df.format((actualNum/designNum)));
			}
			
			//钻井 检波点
			if (dailyReport.get("DESIGN_GEOPHONE_NUM") == null || "".equals(dailyReport.get("DESIGN_GEOPHONE_NUM"))) {
				dailyReport.put("DESIGN_GEOPHONE_NUM", "0");
			}
			if (dailyReport.get("PROJECT_SURVEY_GEOPHONE_NUM") == null || "".equals(dailyReport.get("PROJECT_SURVEY_GEOPHONE_NUM"))) {
				dailyReport.put("PROJECT_SURVEY_GEOPHONE_NUM", "0");
			}
			designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_GEOPHONE_NUM"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_SURVEY_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_SURVEY_GEOPHONE_NUM"));
				dailyReport.put("PROJECT_SURVEY_RATIO", df.format((actualNum/designNum)));
			}
			
			//采集 炮点
			if (dailyReport.get("DESIGN_SP_NUM") == null || "".equals(dailyReport.get("DESIGN_SP_NUM"))) {
				dailyReport.put("DESIGN_SP_NUM", "0");
			}
			if (dailyReport.get("PROJECT_ACQUIRE_SP_NUM") == null || "".equals(dailyReport.get("PROJECT_ACQUIRE_SP_NUM"))) {
				dailyReport.put("PROJECT_ACQUIRE_SP_NUM", "0");
			}
			designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_SP_NUM"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_ACQUIRE_SP_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_ACQUIRE_SP_NUM"));
				dailyReport.put("PROJECT_ACQUIRE_SP_RATIO", df.format((actualNum/designNum)));
			}
			
			//采集 工作量
			if (dailyReport.get("DESIGN_OBJECT_WORKLOAD") == null || "".equals(dailyReport.get("DESIGN_OBJECT_WORKLOAD"))) {
				dailyReport.put("DESIGN_OBJECT_WORKLOAD", "0");
			}
			if (dailyReport.get("PROJECT_ACQUIRE_WORKLOAD") == null || "".equals(dailyReport.get("PROJECT_ACQUIRE_WORKLOAD"))) {
				dailyReport.put("PROJECT_ACQUIRE_WORKLOAD", "0");
			}
			designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_OBJECT_WORKLOAD"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_ACQUIRE_WORK_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_ACQUIRE_WORKLOAD"));
				dailyReport.put("PROJECT_ACQUIRE_WORK_RATIO", df.format((actualNum/designNum)));
			}
			
			//采集 合格炮
			if (dailyReport.get("PROJECT_ACQUIRE_SP_NUM") == null || "".equals(dailyReport.get("PROJECT_ACQUIRE_SP_NUM"))) {
				dailyReport.put("PROJECT_ACQUIRE_SP_NUM", "0");
			}
			if (dailyReport.get("PROJECT_QUALIFIED_SP_NUM") == null || "".equals(dailyReport.get("PROJECT_QUALIFIED_SP_NUM"))) {
				dailyReport.put("PROJECT_QUALIFIED_SP_NUM", "0");
			}
			designNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_ACQUIRE_SP_NUM"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_QUALIFIED_SP_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_QUALIFIED_SP_NUM"));
				dailyReport.put("PROJECT_QUALIFIED_SP_RATIO", df.format((actualNum/designNum)));
			}
			
			//采集 一级炮
			if (dailyReport.get("PROJECT_FIRSTLEVEL_SP_NUM") == null || "".equals(dailyReport.get("PROJECT_FIRSTLEVEL_SP_NUM"))) {
				dailyReport.put("PROJECT_FIRSTLEVEL_SP_NUM", "0");
			}
			//designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_FIRSTLEVEL_SP_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_FIRSTLEVEL_SP_NUM"));
				dailyReport.put("PROJECT_FIRSTLEVEL_SP_RATIO", df.format((actualNum/designNum)));
			}
			
			//采集 二级炮
			if (dailyReport.get("PROJECT_COLLECT_2_CLASS") == null || "".equals(dailyReport.get("PROJECT_COLLECT_2_CLASS"))) {
				dailyReport.put("PROJECT_COLLECT_2_CLASS", "0");
			}
			//designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_COLLECT_2_CLASS_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_COLLECT_2_CLASS"));
				dailyReport.put("PROJECT_COLLECT_2_CLASS_RATIO", df.format((actualNum/designNum)));
			}
			
			//采集 废炮
			if (dailyReport.get("PROJECT_COLLECT_WASTER_NUM") == null || "".equals(dailyReport.get("PROJECT_COLLECT_WASTER_NUM"))) {
				dailyReport.put("PROJECT_COLLECT_WASTER_NUM", "0");
			}
			//designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_COLLECT_WASTER_NUM_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_COLLECT_WASTER_NUM"));
				dailyReport.put("PROJECT_COLLECT_WASTER_NUM_RATIO", df.format((actualNum/designNum)));
			}
			
			//采集 空炮
			if (dailyReport.get("PROJECT_COLLECT_MISS_NUM") == null || "".equals(dailyReport.get("PROJECT_COLLECT_MISS_NUM"))) {
				dailyReport.put("PROJECT_COLLECT_MISS_NUM", "0");
			}
			//designNum = P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_COLLECT_MISS_NUM_RATIO", "-");
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_COLLECT_MISS_NUM"));
				dailyReport.put("PROJECT_COLLECT_MISS_NUM_RATIO", df.format((actualNum/designNum)));
			}
			
			//试验 炮数
			if (dailyReport.get("PROJECT_DAILY_TEST_SP_NUM") == null || "".equals(dailyReport.get("PROJECT_DAILY_TEST_SP_NUM"))) {
				dailyReport.put("PROJECT_DAILY_TEST_SP_NUM", "0");
			}
			
			//试验 合格炮
			if (dailyReport.get("PROJECT_QUALIFIED_TEST_SP_NUM") == null || "".equals(dailyReport.get("PROJECT_QUALIFIED_TEST_SP_NUM"))) {
				dailyReport.put("PROJECT_QUALIFIED_TEST_SP_NUM", "0");
			}
			
//			for (Iterator i = dailyReport.entrySet().iterator(); i.hasNext();) {
//				Map.Entry entry1=(Map.Entry)i.next();
//				System.out.println(entry1.getKey()+"=="+entry1.getValue());
//			}
			}
		}

		return dailyReport;
	}
	
	public ISrvMsg getDailyReportInfo(ISrvMsg reqDTO) throws Exception{
		
		String dailyNo = (String) reqDTO.getValue("dailyNo");
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String produceDate = (String) reqDTO.getValue("produceDate");
		Map temp = reqDTO.toMap();
		
		Map map = new HashMap();
		map.put("produceDate", produceDate);
		map.put("dailyNo", dailyNo);
		map.put("projectInfoNo", projectInfoNo);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		Map dailyReport = getDailyReportNew(map);
		if(dailyReport.size() > 0){
			dailyReport.put("noRecord", "0");
			String if_build = dailyReport.get("if_build").toString();
			String survey_process_status = (String) dailyReport.get("SURVEY_PROCESS_STATUS");
			String surface_process_status = (String) dailyReport.get("SURFACE_PROCESS_STATUS");
			String drill_process_status = (String) dailyReport.get("DRILL_PROCESS_STATUS");
			String collect_process_status = (String) dailyReport.get("COLLECT_PROCESS_STATUS");
			
			if (surface_process_status == "0" || "0".equals(surface_process_status)) {
				map.put("difference", 1);
				Map map1 = getDailyReportProduceSit(map);
				if (map1 != null) {
					dailyReport.put("SURVEY_PROCESS_STATUS", map1.get("surveyProcessStatus"));
					dailyReport.put("SURFACE_PROCESS_STATUS", map1.get("surfaceProcessStatus"));
					dailyReport.put("DRILL_PROCESS_STATUS", map1.get("drillProcessStatus"));
					if("9".equals(if_build) || "9" == if_build){
						dailyReport.put("COLLECT_PROCESS_STATUS", "3");
					}else{
						dailyReport.put("COLLECT_PROCESS_STATUS", map1.get("collectProcessStatus"));
					}
				}else if(map1 == null){
					Map map2 = this.getNextDailyReportStatus(map);
					if(map2 == null){
						dailyReport.put("SURVEY_PROCESS_STATUS", "1");
						dailyReport.put("SURFACE_PROCESS_STATUS", "1");
						dailyReport.put("DRILL_PROCESS_STATUS", "1");
						dailyReport.put("COLLECT_PROCESS_STATUS", "1");
					}else if(map2 != null){
						map.put("difference", 0);
						Map map3 = this.getNextDailyReportStatus(map);
						dailyReport.put("SURVEY_PROCESS_STATUS", map3.get("surveyProcessStatus"));
						dailyReport.put("SURFACE_PROCESS_STATUS", map3.get("surfaceProcessStatus"));
						dailyReport.put("DRILL_PROCESS_STATUS", map3.get("drillProcessStatus"));
						if("9".equals(if_build) || "9" == if_build){
							dailyReport.put("COLLECT_PROCESS_STATUS", "3");
						}else{
							dailyReport.put("COLLECT_PROCESS_STATUS", map3.get("collectProcessStatus"));
						}
					}
				}
			}
			
			map.put("dailyNo", dailyReport.get("DAILY_NO"));
			map.put("lineGroupId", "");
			map.put("line_group_id", "");
			
			map.put("tableName", "gp_ops_daily_survey");
			List surveyList = findGpOpsDaily(map);
			
			map.put("tableName", "gp_ops_daily_surface");
			List surfaceList = findGpOpsDaily(map);
			
			map.put("tableName", "gp_ops_daily_drill");
			List drillList = findGpOpsDaily(map);
			
			map.put("tableName", "gp_ops_daily_acquire");
			List acquireList = findGpOpsDaily(map);
			
			msg.setValue("dailyMap", dailyReport);
			
			msg.setValue("surveyList", surveyList);
			msg.setValue("surfaceList", surfaceList);
			msg.setValue("drillList", drillList);
			msg.setValue("acquireList", acquireList);
		}else if(dailyReport.size() == 0){
			dailyReport.put("noRecord", "1");
			msg.setValue("dailyMap", dailyReport);
		}
		return msg;
	}
	
	public Map getDailyReportProduceSit(Map map){
		
		Object daily_no = map.get("dailyNo");
		Object project_info_no = map.get("projectInfoNo");
		Object produce_date = map.get("produceDate");
		Object difference = map.get("difference");
		
		if (difference == null || "".equals(difference)) {
			difference = "0";
		}
		
		String sql = null;
		
		if (produce_date != null && !"".equals(produce_date) && produce_date != "null" && !"null".equals(produce_date)) {
			sql = "select sit.* from gp_ops_daily_produce_sit sit join gp_ops_daily_report r on r.daily_no = sit.daily_no and r.project_info_no = '"+project_info_no+"' and produce_date = to_date('"+produce_date+"','yyyy-MM-dd')-"+difference+" " +
					" and r.bsflag = '0'  where sit.bsflag = '0' ";
		} else {
			sql = "select * from gp_ops_daily_produce_sit where bsflag = '0'  and daily_no = '"+daily_no+"'";
		}
		
		
		Map report = jdbcDao.queryRecordBySQL(sql);
		return report;
	}
	
	
	public Map getNextDailyReportStatus(Map map){
		
		Object daily_no = map.get("dailyNo");
		Object project_info_no = map.get("projectInfoNo");
		Object produce_date = map.get("produceDate");
		Object difference = map.get("difference");
		
		if (difference == null || "".equals(difference)) {
			difference = "0";
		}
		
		String sql = null;
		
		if (produce_date != null && !"".equals(produce_date) && produce_date != "null" && !"null".equals(produce_date)) {
			sql = "select sit.* from gp_ops_daily_produce_sit sit join gp_ops_daily_report r on r.daily_no = sit.daily_no and r.project_info_no = '"+project_info_no+"' and produce_date = to_date('"+produce_date+"','yyyy-MM-dd')+"+difference+" " +
					" and r.bsflag = '0'  where sit.bsflag = '0' ";
		} else {
			sql = "select * from gp_ops_daily_produce_sit where bsflag = '0'  and daily_no = '"+daily_no+"'";
		}
		
		
		Map report = jdbcDao.queryRecordBySQL(sql);
		return report;
	}
	
	public ISrvMsg queryDailyReportList(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String multi_flag = reqDTO.getValue("multi") != null ? reqDTO.getValue("multi"):"";
		if("1" == multi_flag || "1".equals(multi_flag)){
			//多项目的日报列表,项目编号从前台传,查询需要审批的数据
			String projectInfoNo = reqDTO.getValue("projectInfoNo") != null ? reqDTO.getValue("projectInfoNo"):"";
			
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				msg.setValue("totalRows", 0);
				return msg;
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
			
			  
			String sql =  "select nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0) as sp, "+
			 		"(case t.audit_status when '3' then  sum(nvl(t.daily_acquire_sp_num, 0) +  nvl(t.daily_qq_acquire_shot_num, 0) +  nvl(t.daily_jp_acquire_shot_num, 0))  over(partition by t.project_info_no order by t.produce_date asc) - "+
					"nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "+
					"and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else  sum(nvl(t.daily_acquire_sp_num, 0) +  nvl(t.daily_qq_acquire_shot_num, 0) +  nvl(t.daily_jp_acquire_shot_num, 0)) "+
					"over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_sp, (case t.audit_status "+
					"when '3' then round(case nvl(dy.design_sp_num, 0) when 0 then 0 else (sum(nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0)) "+
					"over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) else round(case nvl(dy.design_sp_num, 0) when 0 then "+
					"0 else (sum(nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0)) over(partition by t.project_info_no order by  t.produce_date asc) - nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + "+
					"nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "+
					"and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) end) total_sp_radio, nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0) as survey, (case t.audit_status when '3' then sum(nvl(t.survey_incept_workload, 0) + "+
					"nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
					"nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
					"end) as total_survey, (case t.audit_status when '3' then round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
					"nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 "+
					"end, 2) else round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + "+
					"nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 end, 2) end) as total_survey_radio, "+
					"nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0) as measue, (case t.audit_status when '3' then sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
					"nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
					"else sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) "+
					"from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_measue, (case t.audit_status when '3' then round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "+
					"when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) else round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "+
					"when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) end) as total_measue_radio, nvl(t.daily_drill_sp_num, 0) as drill, "+
					"(case t.audit_status when '3' then sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
					"else sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_drill, "+
					"(case t.audit_status when '3' then round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "+
					"and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) else round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "+ 
					"and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) end) as total_drill_radio, "+
			        "t.produce_date, gp.project_name, gp.build_method, oi.org_abbreviation as org_name, t.audit_status, t.daily_no, t.project_info_no "+
					"from gp_ops_daily_report t join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0'  and t.exploration_method = gp.exploration_method " +
					" join comm_org_information oi on oi.org_id = t.org_id and oi.bsflag = '0' " +
					" join gp_task_project_dynamic dy "+
				    " on dy.project_info_no = t.project_info_no "+
				    " and dy.exploration_method = t.exploration_method"+
					" where t.bsflag = '0' and (t.audit_status = '1' or t.audit_status = '3') and t.project_info_no = '"+projectInfoNo+"' order by produce_date desc";
			
			page = radDao.queryRecordsBySQL(sql, page);
			

			msg.setValue("datas", page.getData());
			msg.setValue("totalRows", page.getTotalRow());
			msg.setValue("pageSize", pageSize);
			
		}else{
			//单项目的日报列表
			String projectInfoNo = user.getProjectInfoNo();
			
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				msg.setValue("totalRows", 0);
				return msg;
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
			
			  
			String sql =  "select nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0) as sp, "+
			 		"(case t.audit_status when '3' then  sum(nvl(t.daily_acquire_sp_num, 0) +  nvl(t.daily_qq_acquire_shot_num, 0) +  nvl(t.daily_jp_acquire_shot_num, 0))  over(partition by t.project_info_no order by t.produce_date asc) - "+
					"nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "+
					"and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else  sum(nvl(t.daily_acquire_sp_num, 0) +  nvl(t.daily_qq_acquire_shot_num, 0) +  nvl(t.daily_jp_acquire_shot_num, 0)) "+
					"over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_sp, (case t.audit_status "+
					"when '3' then round(case nvl(dy.design_sp_num, 0) when 0 then 0 else (sum(nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0)) "+
					"over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) else round(case nvl(dy.design_sp_num, 0) when 0 then "+
					"0 else (sum(nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0)) over(partition by t.project_info_no order by  t.produce_date asc) - nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + "+
					"nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "+
					"and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) end) total_sp_radio, nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0) as survey, (case t.audit_status when '3' then sum(nvl(t.survey_incept_workload, 0) + "+
					"nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
					"nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
					"end) as total_survey, (case t.audit_status when '3' then round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
					"nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 "+
					"end, 2) else round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + "+
					"nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 end, 2) end) as total_survey_radio, "+
					"nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0) as measue, (case t.audit_status when '3' then sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
					"nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
					"else sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) "+
					"from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_measue, (case t.audit_status when '3' then round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "+
					"when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) else round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "+
					"when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r "+
					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) end) as total_measue_radio, nvl(t.daily_drill_sp_num, 0) as drill, "+
					"(case t.audit_status when '3' then sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
					"else sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_drill, "+
					"(case t.audit_status when '3' then round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "+
					"and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) else round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "+ 
					"and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) end) as total_drill_radio, "+
			        "t.produce_date, gp.project_name, gp.build_method, oi.org_abbreviation as org_name, t.audit_status, t.daily_no, t.project_info_no "+
					"from gp_ops_daily_report t join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0'  and t.exploration_method = gp.exploration_method " +
					" join comm_org_information oi on oi.org_id = t.org_id and oi.bsflag = '0' " +
					" join gp_task_project_dynamic dy "+
				    " on dy.project_info_no = t.project_info_no "+
				    " and dy.exploration_method = t.exploration_method"+
					" where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"' order by produce_date desc";
			
			page = radDao.queryRecordsBySQL(sql, page);
			

			msg.setValue("datas", page.getData());
			msg.setValue("totalRows", page.getTotalRow());
			msg.setValue("pageSize", pageSize);
		}
		return msg;
	}
	
	public String getBuildMethod(String projectInfoNo) throws Exception{
		
		String build_method = "";
		String get_build_method = "select p.build_method from gp_task_project p where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'";
		if(jdbcDao.queryRecordBySQL(get_build_method)!=null){
			build_method = jdbcDao.queryRecordBySQL(get_build_method).get("buildMethod").toString();
		}
		return build_method;
	}
	
	public ISrvMsg submitDailyReport(ISrvMsg reqDTO) throws Exception{
		
		String dailyNo = reqDTO.getValue("dailyNo");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String produceDate = reqDTO.getValue("produceDate");
		
		if (dailyNo == null || "".equals(dailyNo) || dailyNo == "null" || "null".equals(dailyNo)) {
			
			Map map = new HashMap();
			map.put("projectInfoNo", projectInfoNo);
			map.put("produceDate", produceDate);
			Map daily = this.getDailyReport(map);
			dailyNo = (String) daily.get("dailyNo");
		}
		
		UserToken user = reqDTO.getUserToken();
		
		Map map = reqDTO.toMap();
		map.put("updator", user.getUserName());
		map.put("modifi_date", new Date());
		map.put("submit_status", "2");
		map.put("audit_status", "1");
		map.put("daily_no", dailyNo);
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report");
		
		map.put("survey_process_status", reqDTO.getValue("survey_process_status"));
		map.put("surface_process_status", reqDTO.getValue("surface_process_status"));
		map.put("drill_process_status", reqDTO.getValue("drill_process_status"));
		map.put("collect_process_status", reqDTO.getValue("collect_process_status"));
		
		String update = "update gp_ops_daily_produce_sit set survey_process_status = '"+reqDTO.getValue("survey_process_status")+"',surface_process_status = '"+reqDTO.getValue("surface_process_status")+"',drill_process_status = '"+reqDTO.getValue("drill_process_status")+"',collect_process_status = '"+reqDTO.getValue("collect_process_status")+"' where daily_no = '"+dailyNo+"' ";
		radDao.getJdbcTemplate().update(update);
		
		update = "update bgp_p6_assign_mapping set submit_flag = '1',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"+projectInfoNo+"') and bsflag = '0'";
		
		radDao.getJdbcTemplate().update(update);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		return msg;
	}
	
	public ISrvMsg auditDailyReport(ISrvMsg reqDTO) throws Exception{
		String dailyNo = reqDTO.getValue("dailyNo");
		String auditStatus = reqDTO.getValue("audit_status");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String audit_opinion = reqDTO.getValue("audit_opinion");
		//String orgId = reqDTO.getValue("orgId");
		
		String sql = "select * from gp_task_project where project_info_no = '"+projectInfoNo+"' ";
		
		Map project = jdbcDao.queryRecordBySQL(sql);
		
		UserToken user = reqDTO.getUserToken();
		
		Map map = reqDTO.toMap();
		map.put("updator", user.getEmpId());
		map.put("audit_date", new Date());
		map.put("daily_no", dailyNo);
		//map.put("org_id", orgId);
		map.put("modifi_date", new Date());
		map.put("audit_status", auditStatus);
		map.put("ratifier", user.getEmpId());
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report");
		
		if (audit_opinion != null && !"".equals(audit_opinion)) {
			sql = "select * from gp_adm_data_examine where data_no = '"+dailyNo+"'  and bsflag = '0' ";
			
			Map temp = new HashMap();
			Map examine = jdbcDao.queryRecordBySQL(sql);
			if (examine != null) {
				temp.put("data_examine_no", examine.get("dataExamineNo"));
				temp.put("project_info_no", projectInfoNo);
				temp.put("data_no", dailyNo);
				temp.put("audit_date", new Date());
				temp.put("audit_opinion", audit_opinion);
				temp.put("bsflag", "0");
			} else {
				temp.put("project_info_no", projectInfoNo);
				temp.put("data_no", dailyNo);
				temp.put("audit_date", new Date());
				temp.put("audit_opinion", audit_opinion);
				temp.put("bsflag", "0");
			}
			
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(temp,"gp_adm_data_examine");
		}
		
		
		//审批通过 根据日报状态修改项目状态
		if (auditStatus != null && auditStatus.equals("3")) {
			if (map.get("if_build") != null && "4".equals((String) map.get("if_build"))) {
				if ("5000100001000000001".equals((String)project.get("projectStatus"))){
					//测量 改成项目启动
					map.put("project_status", "5000100001000000002");
					map.put("project_info_no", projectInfoNo);
					map.put("modifi_date", new Date());
					
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}
			} else if (map.get("if_build") != null && "6".equals((String) map.get("if_build"))) {
				//采集
				map.put("ifBuild", "6");
				map.put("flag", "min");
				
				Map report = this.getDailyReportByStatus(map);
				if (report != null) {
					map.put("project_start_time", report.get("produceDate"));
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}
			} else if (map.get("if_build") != null && "9".equals((String) map.get("if_build"))) {
				//结束
				map.put("ifBuild", "9");
				map.put("flag", "max");
				
				Map report = this.getDailyReportByStatus(map);
				if (report != null) {
					map.put("project_end_time", report.get("produceDate"));
					map.put("project_status", "5000100001000000005");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}
			} else if (map.get("if_build") != null && "8".equals((String) map.get("if_build"))) {
				//暂停
				map.put("project_status", "5000100001000000004");
				map.put("modifi_date", new Date());
				map.put("project_info_no", projectInfoNo);
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
			}
			map.clear();
			//map.put("produceDate", value)
			map.put("userId", user.getEmpId());
			map.put("userName", user.getUserName());
			
			sql = "select * from gp_ops_daily_report where daily_no = '"+dailyNo+"' ";
			
			Map daily = jdbcDao.queryRecordBySQL(sql);
			
			map.put("projectInfoNo", projectInfoNo);
			map.put("produceDate", daily.get("produceDate"));
			
			//审批通过以后把工作量分配表的本期值置空
			String update = "update bgp_p6_workload set actual_this_period_units = '0',modifi_date = sysdate where project_info_no = '"+projectInfoNo+"' and bsflag = '0'";
			//radDao.getJdbcTemplate().update(update);
			
			//日报允许打回操作 不置空本期值 审批通过时更新每日的工作量分配记录的累计值
			update = "select p.project_object_id,sum(nvl(p.actual_this_period_units,0)) as actual_this_period_units,p.activity_object_id,p.resource_object_id from bgp_p6_workload p join gp_ops_daily_report r  on r.project_info_no = p.project_info_no and r.produce_date = p.produce_date " +
					"and r.produce_date <= to_date('"+daily.get("produceDate")+"','yyyy-MM-dd') and r.project_info_no = '"+projectInfoNo+"' and r.bsflag = '0' where p.bsflag = '0' group by p.project_object_id,p.activity_object_id,p.resource_object_id ";
			
			List<Map> list = jdbcDao.queryRecords(update);
			if (list != null && list.size() != 0) {
				for (int i = 0; i < list.size(); i++) {
					Map temp = list.get(i);
					update = "update bgp_p6_workload set actual_units = '"+temp.get("actualThisPeriodUnits")+"' where project_info_no = '"+projectInfoNo+"' and activity_object_id = '"+temp.get("activityObjectId")+"' and resource_object_id = '"+temp.get("resourceObjectId")+"'  and produce_date is null ";
					radDao.getJdbcTemplate().update(update);
				}
			}
			
			update = "update bgp_p6_assign_mapping set submit_flag = '"+auditStatus+"',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"+projectInfoNo+"') and bsflag = '0'";
			radDao.getJdbcTemplate().update(update);
			
			update = "update bgp_p6_activity set submit_flag = '"+auditStatus+"',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"+projectInfoNo+"') and bsflag = '0' ";
			
			radDao.getJdbcTemplate().update(update);
			
			
			//AuditDailyReportThread thread = new AuditDailyReportThread(map);
			//thread.start();
		}
		
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("dailyNo", dailyNo);
		msg.setValue("projectInfoNo", projectInfoNo);
		
		return msg;
	}
	
	public Map getDailyReportByStatus(Map map){
		String ifBuild = (String) map.get("ifBuild");
		String flag = (String) map.get("flag");
		String projectInfoNo = (String) map.get("projectInfoNo");
		String orgId = (String) map.get("orgId");
		
		String sql = "select * from gp_ops_daily_report t,gp_ops_daily_produce_sit sit where t.project_info_no = '"+projectInfoNo+"' and sit.daily_no = t.daily_no and sit.if_build = '"+ifBuild+"' " +
				" and t.audit_status = '3'  and t.bsflag = '0'";
		
		if (orgId != null && !"".equals(orgId)) {
			sql += " and t.rog_id = '"+orgId+"' ";
		}
		
		sql += " order by t.produce_date ";
		
		if (flag == "max" || "max".equals(flag)) {
			sql += "desc";
		}
		
		Map report = jdbcDao.queryRecordBySQL(sql);
		
		return report;
	}
	
	public ISrvMsg saveOrUpdateDailyReport(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		
		String flag = reqDTO.getValue("flag");
		String edit_flag = reqDTO.getValue("edit_flag");
		String project_info_no = reqDTO.getValue("project_info_no");
		String produceDate = reqDTO.getValue("produce_date");
		
		String org_id = null;
		String org_subjection_id = null;
		
		boolean flag1 = false;
		
		ProjectMCSBean projectMCSBean = (ProjectMCSBean) BeanFactory.getBean("ProjectMCSBean");
		
		PageModel page = new PageModel();
		
		Map map = reqDTO.toMap();
		map.put("projectInfoNo", map.get("project_info_no"));
		
		page = projectMCSBean.quertProject(map, page);

		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map project = (Map) list.get(0);
			map.put("workarea_no", project.get("workarea_no"));
			map.put("exploration_method", project.get("exploration_method"));
		}
		
		page = projectMCSBean.quertProjectDynamic(map, page);

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map dy = (Map) list.get(0);
			
			org_id = (String) dy.get("org_id");
			map.put("org_id", dy.get("org_id"));
			
			org_subjection_id = (String) dy.get("org_subjection_id");
			map.put("org_subjection_id", dy.get("org_subjection_id"));
		}
		
		if(flag.equals("notSaved")){
			//新增
			map.put("creator", user.getUserName());
			map.put("create_date", new Date());
			
			map.put("updator", user.getUserName());
			map.put("modifi_date", new Date());
			
			map.put("bsflag", "0");
			map.put("submit", "1");
			map.put("audit_status", "0");
			
			Serializable dailyNo = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report");

			map.put("daily_no", dailyNo);
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_produce_sit");
			
			flag1 = true;
			
			JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
			
			String sql = "select * from bgp_p6_workload where bsflag = '0' and project_info_no = '"+project_info_no+"' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') ";
			
			List<Map<String,Object>> temp = radDao.getJdbcTemplate().queryForList(sql);
			if (temp == null || temp.size() == 0) {
				//本日没有记录
				sql = "select * from bgp_p6_workload where bsflag = '0' and produce_date is null and project_info_no = '"+project_info_no+"' ";
				List<Map<String,Object>> tempList = radDao.getJdbcTemplate().queryForList(sql);
				//创建本日记录
				for (int i = 0; i < tempList.size(); i++) {
					Map<String, Object> mapTemp = tempList.get(i);
					
					mapTemp.put("produce_date", produceDate);
					mapTemp.put("object_id", null);
					
					mapTemp.put("actual_this_period_units", "0");
					
					mapTemp.put("create_date", new Date());
					mapTemp.put("creator", user.getUserId());
					mapTemp.put("modifi_date", new Date());
					mapTemp.put("updator", user.getUserId());
				}
				
				WorkloadMCSBean w = new WorkloadMCSBean();
				w.saveOrUpdateWorkloadToMCS(tempList, user);
			}
			
			
			
		} else if(edit_flag.equals("yes")&&(flag.equals("notPassed")||flag.equals("notSubmited"))){
			//修改
			Map daily = this.getDailyReport(map);
			map.put("daily_no", daily.get("dailyNo"));
			
			map.put("updator", user.getUserName());
			map.put("modifi_date", new Date());
			
			map.put("bsflag", "0");
			map.put("submit", "1");
			map.put("audit_status", "0");
			
			Serializable dailyNo = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report");
			
			//查询出daily_sit_no进行更新
			String getsitDailyNo = "select s.daily_sit_no from gp_ops_daily_produce_sit s where s.bsflag = '0' and s.daily_no = '"+dailyNo+"'";
			
			if(radDao.queryRecordBySQL(getsitDailyNo.toString()) != null){
				map.put("daily_sit_no", radDao.queryRecordBySQL(getsitDailyNo.toString()).get("daily_sit_no"));
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_produce_sit");
			}
			
			flag1 = true;
		}
		
		if (flag1) {
			String deleteId = reqDTO.getValue("deleteId");
			Map map1 = reqDTO.toMap();
			String[] deleteIds = deleteId.split(",");
			List<String> list1 = new ArrayList<String>();
			if (deleteIds != null && deleteIds.length > 1) {
				for (int i = 1; i < deleteIds.length; i++) {
					list1.add(deleteIds[i]);
				}
				this.deleteQuestion(list1);
			}
			
			List<String> listOrders = reqDTO.getValues("order");
			String order = reqDTO.getValue("order");
			
			if (listOrders == null && order != null) {
				listOrders = new ArrayList<String>();
				listOrders.add(order);
			}
			
			
			List saveList = new ArrayList();
			List updateList = new ArrayList();
			
			String j = null;
			
			String question_id = null;
			
			String bug_code = null;
			String q_description = null;
			String resolvent = null;
			
			if (listOrders != null && listOrders.size() !=0) {
				
				for (int i = 0; i < listOrders.size(); i++) {
					j = listOrders.get(i);
					
					question_id = reqDTO.getValue("question_id_"+j);
					bug_code = reqDTO.getValue("bug_code_"+j);
					q_description = reqDTO.getValue("q_description_"+j);
					resolvent = reqDTO.getValue("resolvent_"+j);
					if (question_id == null || "".equals(question_id)) {
						//新增
						map = new HashMap();
						
						map.put("creator", user.getEmpId());
						map.put("create_date", new Date());
						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());
						
						map.put("bsflag", "0");
						map.put("bug_code", bug_code);
						map.put("q_description", q_description);
						map.put("resolvent", resolvent);
						map.put("project_info_no", project_info_no);
						map.put("org_id", org_id);
						map.put("org_subjection_id", org_subjection_id);
						map.put("produce_date", produceDate);
						
						saveList.add(map);
					} else {
						//修改
						map = new HashMap();
						
						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());
						
						map.put("bsflag", "0");
						map.put("bug_code", bug_code);
						map.put("q_description", q_description);
						map.put("resolvent", resolvent);
						map.put("project_info_no", project_info_no);
						map.put("org_id", org_id);
						map.put("org_subjection_id", org_subjection_id);
						map.put("produce_date", produceDate);
						
						map.put("question_id", question_id);
						
						updateList.add(map);
					}
					
				}
			}
			
			this.saveDailyQuestion(saveList);
			this.updateDailyQuestion(updateList);
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("flag", flag);
		msg.setValue("projectInfoNo", project_info_no);

		
		msg.setValue("customKey", "edit_flag,produceDate");
		msg.setValue("customValue", edit_flag+","+produceDate);
		msg.setValue("taskBackUrl", "/pm/dailyReport/queryResourceAssignment.srq");
		return msg;
	}
	
	private void deleteQuestion(final List<String> ids){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String sql = "update gp_ops_daily_question set bsflag = '1' where question_id = ?" ;
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return ids.size();
			}
			
			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				ps.setString(1, ids.get(i));
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	/**
	 * 查询日报附属表 
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> findGpOpsDaily(Map map){
		
		String dailyNo = (String) map.get("dailyNo");
		String lineGroupId = (String) map.get("lineGroupId");
		String tableName = (String) map.get("tableName");
		
		if (dailyNo == null || "".equals(dailyNo)) {
			dailyNo = (String) map.get("daily_no");
		}
		if (lineGroupId == null || "".equals(lineGroupId)) {
			lineGroupId = (String) map.get("line_group_id");
		}
		if (tableName == null || "".equals(tableName)) {
			tableName = (String) map.get("table_name");
		}
		
		String customKey = (String) map.get("customKey");
		String customValue = (String) map.get("customValue");
		
		if (customKey == null || "".equals(customKey)) {
			customKey = (String) map.get("custom_key");
		}
		if (customValue == null || "".equals(customValue)) {
			customValue = (String) map.get("custom_value");
		}
		
		String sql = "select * from "+tableName+" where daily_no = '"+dailyNo+"' and bsflag = '0'  ";
		
		if (lineGroupId != null && !"".equals(lineGroupId)) {
			sql += " and line_group_id = '"+lineGroupId+"' ";
		}
		
		if (customKey != null && !"".equals(customKey)) {
			String[] temp = customKey.split(",");
			String[] temp1 = customValue.split(",");
			
			for (int i = 0; i < temp.length; i++) {
				sql += " and " + temp[i] + "= '"+temp1[i]+"' ";
			}
		}
		
		
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		
		return list;
	}
	
	/**
	 * 综合物化探计划日效 保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateWtDailyPlan(ISrvMsg reqDTO) throws Exception{
		
		
		
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		
		Map map = reqDTO.toMap();
		Set entryset = map.entrySet();
		Iterator entryit = entryset.iterator();
		Set<Map.Entry<String,String>> set = map.entrySet();  
		List rslist = new ArrayList();//结果
		Map rs = null;
		Map<String,String> beizhurs = new HashMap<String,String>();//备注结果
		Map.Entry<String,String> entry = null;
		String value = null;
		String key = null;
		String a[] = null;
		String mdate =null;
		String mid = null;
		String wtypeid = null;
		String wid = null;
		//取得所有记录
		for(Iterator<Map.Entry<String,String>> v = entryset.iterator();v.hasNext();) {    
			entry = v.next();    
			rs = new HashMap();//一条记录
			
			//GP_PROJ_PRODUCT_PLAN_WT
			
			value = entry.getValue();
		//	if(value!=null&&!value.equals("")&&!value.trim().equals("0")){
			if(value!=null&&!value.equals("")){
				key = entry.getKey();
				if(key.startsWith("d_")){
					//String a = "d_2013-01-01_mid_11_G6601_02";
					a = key.split("_");
					mdate =a[1] ;
					mid = a[3];
					wtypeid = a[4];
					wid = a[5];
					
				
					
					rs.put("project_info_no", project_info_no);
					rs.put("value", value);
				    rs.put("mdate", mdate);
					rs.put("mid", mid);
					rs.put("wtypeid", wtypeid);
					rs.put("wid", wid);
					
					rslist.add(rs);
				}else if(key.startsWith("b_")){
					
					beizhurs.put(key.split("_")[1], value);
					
				}
			
			}
			
		}
		
		this.saveWtDailyPlan(rslist,beizhurs,project_info_no);//批量保存

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);	
		msg.setValue("message", "已保存");
		return msg;
	}
	/**
	 * 保存物探计划日效
	 * @param list
	 */
	private void saveWtDailyPlan(final List list,final Map<String,String> beizhurs,String project_info_no){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		//1先删除所有
		jdbcTemplate.execute("delete from gp_proj_product_plan_wt t where t.project_info_no='"+project_info_no+"'");
		
		//2在全部保存
		
		String[] propertys = {"project_info_no","value","mdate","mid","wtypeid","wid","id","dremark"};
		StringBuffer sql = new StringBuffer();
		sql.append("insert into gp_proj_product_plan_wt (");
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
				Map map = (Map) list.get(i);
				
				ps.setString(1, (String) map.get("project_info_no"));
				ps.setString(2, (String) map.get("value"));
				ps.setString(3, (String) map.get("mdate"));
				ps.setString(4, (String) map.get("mid"));
				ps.setString(5, (String) map.get("wtypeid"));
				ps.setString(6, (String) map.get("wid"));
				ps.setString(7, radDao.generateUUID());
				
				
				String dremark = beizhurs.get((String) map.get("mdate"));//备注
				//if(dremark!=null&&!dremark.equals("")){
				ps.setString(8, dremark);
				//}
			}
			
		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	
	
	public ISrvMsg saveOrUpdateDailyPlan(ISrvMsg reqDTO) throws Exception{
		
		String deleteId = reqDTO.getValue("deleteId");
		Map map1 = reqDTO.toMap();
		String[] deleteIds = deleteId.split(",");
		List<String> list = new ArrayList<String>();
		if (deleteIds != null && deleteIds.length > 1) {
			for (int i = 1; i < deleteIds.length; i++) {
				list.add(deleteIds[i]);
			}
			this.deleteDailyPlan(list);
		}
		
		List<String> listOrders = reqDTO.getValues("order");
		String order = reqDTO.getValue("order");
		
		if (listOrders == null && order != null) {
			listOrders = new ArrayList<String>();
			listOrders.add(order);
		}
		
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no == null || "".equals(project_info_no)){
			project_info_no = user.getProjectInfoNo();
		}
		
		
		List saveList = new ArrayList();
		List updateList = new ArrayList();
		
		String j = null;
		String pro_plan_id = null;
		String value = null;
		String record_month = null;
		Map map = null;
		
		String[] valueName = {"measure_","drill_","collect_"};
		String[] valueKey = {"workload_num","workload","workload"};
		String[] proValue = {"measure_pro_plan_id_","drill_pro_plan_id_","coll_pro_plan_id_"};
		String[] planType = {"measuredailylist","drilldailylist","colldailylist"};
		
		if(listOrders != null){
			for (int i = 0; i < listOrders.size(); i++) {
				j = listOrders.get(i);
				
				for (int k = 0; k < valueName.length; k++) {
					
					value = reqDTO.getValue(valueName[k]+j);
					pro_plan_id = reqDTO.getValue(proValue[k]+j);
					record_month = reqDTO.getValue("record_month_"+j);
					if (value == null) {
						//无值 跳过
					} else {
						if (pro_plan_id == null || "".equals(pro_plan_id) || "undefined".equals(pro_plan_id)) {
							//新增
							map = new HashMap();
							map.put("bsflag", "0");
							//map.put("pro_plan_id", pro_plan_id);
							map.put("record_month", record_month);
							map.put("oper_plan_type", planType[k]);
							map.put(valueKey[k], value);
							map.put("project_info_no", project_info_no);
							
							saveList.add(map);
						} else {
							//修改
							map = new HashMap();
							map.put("bsflag", "0");
							map.put("pro_plan_id", pro_plan_id);
							map.put("record_month", record_month);
							map.put("oper_plan_type", planType[k]);
							map.put(valueKey[k], value);
							map.put("project_info_no", project_info_no);
							
							updateList.add(map);
						}
					}
					
				}
				
				
			}
			
			this.saveDailyPlan(saveList);
			this.updateDailyPlan(updateList);
		}else{
			String updateAll = "update gp_proj_product_plan p set p.bsflag = '1' where p.project_info_no = '"+project_info_no+"'";
			radDao.executeUpdate(updateAll);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	
	/**
	 * 查询井中工作量分配
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg queryDailyPlan(ISrvMsg reqDTO) throws Exception{
		
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String[] planType = {"measuredailylist","drilldailylist","colldailylist"};
		
		StringBuffer sql = new StringBuffer();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		sql.append("select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"'  and oper_plan_type in(");
		
		for (int i = 0; i < planType.length; i++) {
			sql.append("'"+planType[i]+"',");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(") and bsflag ='0' order by to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') ");
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		List list = page.getData();
		if(list != null && list.size() != 0){
			
			//gp_proj_product_plan 计划日效 存在project_info_no项目的oper_plan_type in  {"measuredailylist","drilldailylist","colldailylist"}的记录
			
			msg.setValue("hasSaved", "1");
			msg.setValue("allList", list);
			
			for (int i = 0; i < planType.length; i++) {
				sql = new StringBuffer();
				sql.append("select pro_plan_id,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,workload_num,workload from gp_proj_product_plan where bsflag = '0' and project_info_no = '"+projectInfoNo+"'  and oper_plan_type = '"+planType[i]+"'  order by to_char(to_date(" +
						"record_month,'yyyy-MM-dd'),'yyyy-MM-dd')");
				page = radDao.queryRecordsBySQL(sql.toString(), page);
				msg.setValue(planType[i], page.getData());
			}
		}else if(list == null || list.size() == 0) {
			//gp_proj_product_plan 无计划日效记录
			
			msg.setValue("hasSaved", "0");
			list = countDailyPlanWs(projectInfoNo);//根据projectInfoNo 从bgp_p6_workload表中取工作量
			
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		
		return msg;
	}
	
	/**
	 * 查询深海工作量分配
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryShDailyPlan(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String getProjectInfo = "select p.project_name,p.exploration_method,p.build_method from gp_task_project p where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'";
		
		Map projectInfoMap = radDao.queryRecordBySQL(getProjectInfo);
		if(projectInfoMap != null){
			msg.setValue("projectName",projectInfoMap.get("project_name"));
			msg.setValue("ExpMethod",projectInfoMap.get("exploration_method"));
			msg.setValue("buildMethod",projectInfoMap.get("build_method"));
		}
		
		String[] planType = {"measuredailylist","drilldailylist","colldailylist"};
		
		StringBuffer sql = new StringBuffer();
		
		sql.append("select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"'  and oper_plan_type in(");
		
		for (int i = 0; i < planType.length; i++) {
			sql.append("'"+planType[i]+"',");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(") and bsflag ='0' order by to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') ");
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		List list = page.getData();
		if(list != null && list.size() != 0){
			msg.setValue("hasSaved", "1");
			msg.setValue("allList", list);
			
			for (int i = 0; i < planType.length; i++) {
				sql = new StringBuffer();
				sql.append("select pro_plan_id,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,workload_num,workload from gp_proj_product_plan where bsflag = '0' and project_info_no = '"+projectInfoNo+"'  and oper_plan_type = '"+planType[i]+"'  order by to_char(to_date(" +
						"record_month,'yyyy-MM-dd'),'yyyy-MM-dd')");
				page = radDao.queryRecordsBySQL(sql.toString(), page);
				msg.setValue(planType[i], page.getData());
			}
		}else if(list == null || list.size() == 0) {
			msg.setValue("hasSaved", "0");
			list = countDailyPlanSh(projectInfoNo);
			
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		
		return msg;
	}
	private List countDailyPlanSh(String projectInfoNo){
		//根据projectInfoNo 从bgp_p6_workload表中取工作量
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		
		List AllList = new ArrayList();
		List measuredailylist = new ArrayList();
		List drilldailylist = new ArrayList();
		List colldailylist = new ArrayList();
		
		
		//String[] measureType = {"G9001"};//测量
		//String[] drillType = {"GS7001","GS7001"};//钻井 炮点数
		String[] collType = {"GS7001","GS7002"};//采集  炮点数
		 
		
		String sqlTemp = null;
		String sql = null;
		//总的

		sqlTemp = " and resource_id in ('GS7001','GS7002')";
		
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		String max_finish_date = null;
		String min_start_date = null;
		
		Date start_date = null;
		Date end_date = null;
		
		int day = 0;
		
		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		Date temp = start_date;
		String dateTemp = null;
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			temp.setTime(temp.getTime()+86400000L);
			AllList.add(map);
		}
		
		

		/////////////////////////////////////////////////////////////钻井
//		sqlTemp = " and resource_id in ('G10001')";
//		
//		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
//				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
//				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
//		
//		sql += sqlTemp;
//		
//		page = radDao.queryRecordsBySQL(sql.toString(), page);
//		
//		max_finish_date = null;
//		min_start_date = null;
//		
//		start_date = null;
//		end_date = null;
//		
//		day = 0;//钻井开始到结束之间的总天数
//		
//		list = page.getData();
//		if (list != null && list.size() != 0) {
//			Map map = (Map) list.get(0);
//			min_start_date = (String) map.get("min_start_date");
//			max_finish_date = (String) map.get("max_finish_date");
//			
//			try {
//				start_date = DateOperation.parseToUtilDate(min_start_date);
//				end_date = DateOperation.parseToUtilDate(max_finish_date);
//			} catch (Exception e) {
//			}
//			if (start_date == null || end_date == null) {
//				day = 0;
//			} else {
//				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
//			}
//		}
//		
//		//---------------------------
//		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else floor(w.planned_units * 8 / a.planned_duration) end) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
//				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
//				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
//		
//		
//		sql += sqlTemp;
//
//		page = radDao.queryRecordsBySQL(sql.toString(), page);
//		list = page.getData();
//
//		temp = new Date();
//		dateTemp = null;
//
//		int total_workload_num = 0;// 钻井炮点总数
//
//		for (int j = 0; j < list.size(); j++) {
//			Map tempMap = (Map) list.get(j);
//			total_workload_num += Double.parseDouble((String) tempMap
//					.get("planned_units"));
//		}
//
//		int total_workload_num_bak = total_workload_num;// 钻井炮点总数
//
//		// ------------------求剩余工作量
//		for (int i = 0; i < day; i++) {
//			temp.setTime(start_date.getTime() + 86400000L * i);
//			dateTemp = DateOperation.formatDate(temp);
//			int workload_num = 0;
//			for (int j = 0; j < list.size(); j++) {
//				Map tempMap = (Map) list.get(j);
//				String s = (String) tempMap.get("start_date");
//				String e = (String) tempMap.get("finish_date");
//
//				if (DateOperation.dateBetween(s, e, dateTemp)) {
//					workload_num += Integer.parseInt((String) tempMap
//							.get("average_units"));
//				}
//
//			}
//
//			// 计算剩余
//			total_workload_num_bak = total_workload_num_bak - workload_num;
//
//		}
//
//		// ------------------平均分配工作量 把剩余工作量分到这一天
//		for (int i = 0; i < day; i++) {
//			Map map = new HashMap();
//			temp.setTime(start_date.getTime() + 86400000L * i);
//			dateTemp = DateOperation.formatDate(temp);
//			map.put("record_month", DateOperation
//					.formatDate(temp, "yyyy-MM-dd"));
//
//			int workload_num = 0;
//			boolean isday = false;// 是否包含当天
//			for (int j = 0; j < list.size(); j++) {
//				Map tempMap = (Map) list.get(j);
//				String s = (String) tempMap.get("start_date");
//				String e = (String) tempMap.get("finish_date");
//
//				if (DateOperation.dateBetween(s, e, dateTemp)) {
//					workload_num += Integer.parseInt((String) tempMap
//							.get("average_units"));
//					if (isday == false) {
//						isday = true;
//					}
//				}
//
//			}
//
//			if (isday) {
//				if (total_workload_num_bak > 0) {
//					workload_num++;
//					total_workload_num_bak--;
//				}
//			}
//
//			map.put("workload", df_1.format(workload_num));
//			drilldailylist.add(map);
//		}
		
		////////////////////////////////////////////////////////////////////////采集
		
		sqlTemp = " and resource_id in ('GS7001','GS7002')";
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		max_finish_date = null;
		min_start_date = null;
		
		start_date = null;
		end_date = null;
		
		day = 0;
		
		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		

		
		//---------------------------
		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration) end) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		int total_workload_num = 0;// 钻井炮点总数

		for (int j = 0; j < list.size(); j++) {
			Map tempMap = (Map) list.get(j);
			total_workload_num += Double.parseDouble((String) tempMap
					.get("planned_units"));
		}

		int total_workload_num_bak = total_workload_num;// 钻井炮点总数

		// ------------------求剩余工作量
		for (int i = 0; i < day; i++) {
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			int workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Integer.parseInt((String) tempMap
							.get("average_units"));
				}

			}

			// 计算剩余
			total_workload_num_bak = total_workload_num_bak - workload_num;

		}

		// ------------------平均分配工作量 把剩余工作量分到这一天
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation
					.formatDate(temp, "yyyy-MM-dd"));

			int workload_num = 0;
			boolean isday = false;// 是否包含当天
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Integer.parseInt((String) tempMap
							.get("average_units"));
					if (isday == false) {
						isday = true;
					}
				}

			}

			if (isday) {
				if (total_workload_num_bak > 0) {
					workload_num++;
					total_workload_num_bak--;
				}
			}

			map.put("workload", df_1.format(workload_num));
			colldailylist.add(map);
		}
		
		//-----------------------------------------
		
		List list2 = new ArrayList();
		list2.add(AllList);
		list2.add(measuredailylist);
		list2.add(drilldailylist);
		list2.add(colldailylist);
		return list2;
	}
	
	
	/**
	 * 查询物化探计划日效
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg queryWtDailyPlan(ISrvMsg reqDTO) throws Exception{
		
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		
		StringBuffer sql = new StringBuffer();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		sql.append("select count(*) as rn from gp_proj_product_plan_wt where project_info_no = '"+projectInfoNo+"'");
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		List list = page.getData();
		String rn = (String)((Map)list.get(0)).get("rn");
		
		
		if(Integer.valueOf(rn).intValue()!=0){
			
			//gp_proj_product_plan_wt 计划日效 存在project_info_no项目的日效
			
			msg.setValue("hasSaved", "1");
			//msg.setValue("allList", list);
			
			Map rsMap = getWtDailyPlanFromPlan(projectInfoNo);//根据projectInfoNo 从gp_proj_product_plan_wt表中取工作量
			msg.setValue("allList", rsMap.get("allList"));
			msg.setValue("allMission", rsMap.get("allMission"));
			msg.setValue("allWorkloadType", rsMap.get("allWorkloadType"));
			msg.setValue("dayWorkload", rsMap.get("dayWorkload"));
			msg.setValue("dremarkMap", rsMap.get("dremarkMap"));
			
			
		}else {
			//gp_proj_product_plan_wt 无计划日效记录 从bgp_p6_workload表中生成工作量
			
			msg.setValue("hasSaved", "0");
			//String wtWorkMethod = getWtWorkMethod(projectInfoNo);//取项目已选择的勘探方法（如 陆地重力 水底重力）
			Map rsMap = getWtDailyPlanFromWorkload(projectInfoNo);//根据projectInfoNo 从bgp_p6_workload表中取工作量
			msg.setValue("allList", rsMap.get("allList"));
			msg.setValue("allMission", rsMap.get("allMission"));
			msg.setValue("allWorkloadType", rsMap.get("allWorkloadType"));
			msg.setValue("dayWorkload", rsMap.get("dayWorkload"));
			//*******************************************************************************
//			//任务 
//			List allMission = new ArrayList();//list中存放每一个任务的Map 有顺序
//			Map oneMission = new HashMap();//每一个任务
//			oneMission.put("name", "任务1");
//			oneMission.put("id", "11");
//			//任务下工作量类型
//			Map allWorkloadType = new HashMap();//所有任务的工作量类型 依据 key   任务id  来取此任务包含的工作量类型
//			allWorkloadType.put("mid_11", "G6601,G6602");//如
//			allWorkloadType.put("mid_22", "G6601");
//			
//			//具体的工作量
////			Map allWorkload = new HashMap();;//所有任务的工作量  依据 key  任务id+类型id+具体工作量编码 (工作量,坐标点) 来取此工作量值
////			allWorkload.put("mid_11_G6601_01","2013-01-01:10,2013-01-02:10");//平均分配到每一天上的工作量
////			allWorkload.put("mid_11_G6601_02","200");
//			
//			//带日期的工作量 
//			Map dayWorkload = new HashMap();//所有任务的工作量  依据 key  日期+任务id+工作量类型id+具体工作量编码 (工作量,坐标点) 来取此工作量值
//			dayWorkload.put("d_2013-01-01_mid_11_G6601_01", "1");
//			dayWorkload.put("d_2013-01-01_mid_11_G6601_02", "3");
//			
//			
//			msg.setValue("aaaa", dayWorkload);
			//*********************************************************************************

		}
		
		//获得工作量单位Map
		Map workloadUnit = getWorkloadUnit(projectInfoNo);
		msg.setValue("workloadUnit", workloadUnit);
		
		return msg;
	}
	//从bgp_p6_workload表中取工作量
	private Map getWtDailyPlanFromWorkload(String projectInfoNo){
		//根据projectInfoNo 从bgp_p6_workload表中取工作量
	
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		
		
		String sqlTemp = null;
		String sql = null;
		
		Date start_date = null;
		Date end_date = null;
		
		String max_finish_date = null;
		String min_start_date = null;
		
		int day = 0;
		
		List list = null;
		
		Date temp = new Date();
		String dateTemp = null;
		//取项目选择的勘探方法 每种勘探方法对应不同的工作量参数
		/**
		重力方法
		5110000056000000007 陆地重力测量
		5110000056000000008 水底重力测量
		5110000056000000009 海洋重力测量
		5110000056000000010 航空重力测量
		5110000056000000011 微重力测量
		磁力
		5110000056000000012 陆地磁力测量
		5110000056000000013 海洋磁力测量
		5110000056000000014 航空磁力测量
		5110000056000000015 微磁测量
		天然场源电磁法
		5110000056000000016 大地电磁测深（MT）
		5110000056000000017 连续电磁剖面法（CEMP）
		5110000056000000018 自然电位法（SP）
		5110000056000000019 高频电磁法（HFEM）
		5110000056000000020 声频大地电磁法（AMT）
		人工场源电磁法
		5110000056000000021 固定源建场测深法（LOTEM）
		5110000056000000022 可控源声频大地电磁法（CSAMT）
		5110000056000000023 大功率井地电法 （BSEM）
		5110000056000000024 复电阻率法（CR）
		5110000056000000025 激发极化法（IP）
		5110000056000000026 时频电磁法（TFEM）
		5110000056000000027 垂向电测深法（VES）
		工程勘探
		5110000056000000028 大地电场法
		。。。。
		5110000056000000043 浅层地震勘探
		化探
		5110000056000000044 化探
		**/

		/**
		测量 G6601 (不统计)
		G660101 GPS控制点 
		G660102  坐标点 
	
		 重力 
		G660205 物理点  
  		G660201 工作量 
  		
  		磁力 
		G660305 物理点   
		G660301 工作量 
		
		 人工场源电法
		G660404 物理点   
		G660401 工作量  
		
		天然场源电法
		G660505  物理点  
		G660501  工作量  
		
		化学勘探
		G660604  物理点  
		G660601 工作量  
		
		工程
		G660707  物理点    
		G660701  工作量  
**/
		Set workloadcodeSet = new HashSet();//工作量编码集合   用来格式化工作量数值 为小数
		workloadcodeSet.add("G660201");
		workloadcodeSet.add("G660301");
		workloadcodeSet.add("G660401");
		workloadcodeSet.add("G660501");
		workloadcodeSet.add("G660601");
		workloadcodeSet.add("G660701");
		
		String workloadUsed = "'G660201','G660205','G660301','G660305','G660401','G660404','G660501','G660505','G660601','G660604','G660701','G660707'";//计算所有包含要统计的 计划日效 的 任务消耗的时间的并级
		String activityObjectId = "";//包含指定工作量的任务的id
		//*********************************************1 取任务id*****************************************************
		sql = "select w.activity_object_id from bgp_p6_workload w "+
		" where w.project_info_no = '"+projectInfoNo+"'"+
		" and w.bsflag = '0' and w.produce_date is null and w.resource_id in ("+workloadUsed+") group by w.activity_object_id";
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();
		for(Object aoiMap:list ){
			activityObjectId+="'"+((Map)aoiMap).get("activity_object_id")+"',";
		}
		activityObjectId=activityObjectId.substring(0, activityObjectId.length()-1);
		
		
		//*********************************************2 总的任务天数并级*****************************************************
		List allList = new ArrayList();
		
	    sql ="select to_char(min(a.planned_start_date), 'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date), 'yyyy-MM-dd') as max_finish_date "+
		" from bgp_p6_activity a where a.bsflag = '0' and a.object_id in "+
		"("+activityObjectId+")";
	    //获得任务开始结束中的天数
	    Map rs = null;//天数的结果 key ：day ，start_date
	    rs = getDayRs(sql);
	   
	    //##########结果
	    day = ((Integer)rs.get("day"));
		temp = (Date)rs.get("start_date");//开始日期
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			temp.setTime(temp.getTime()+86400000L);
			allList.add(map);//将日期放入allList
		}

		//*************************************************3 计算任务工作量结果数据****************************************************************
		
		List allMission = new ArrayList();//任务  list中存放每一个任务的Map 有顺序
		Map allWorkloadType = new HashMap();//任务下工作量类型  所有任务的工作量类型 依据 key   任务id  来取此任务包含的工作量类型 allWorkloadType.put("mid_11", "G6601,G6602");allWorkloadType.put("mid_22", "G6601");
		Map dayWorkload = new HashMap();///带日期的工作量   所有任务的工作量  依据 key  日期+任务id+工作量类型id+具体工作量编码 (工作量,坐标点) 来取此工作量值 dayWorkload.put("d_2013-01-01_mid_11_G6601_01", "1");dayWorkload.put("d_2013-01-01_mid_11_G6601_02", "3");
		
		
		
		
		String[] activityObjectIds = activityObjectId.split(",");
		List rsList = new ArrayList();
		for(int i=0;i<activityObjectIds.length;i++){
		//@@@@@一个任务	
			
			Map oneMission = new HashMap();//每一个任务
			
			oneMission.put("id", activityObjectIds[i].replaceAll("'", ""));//任务id
			allMission.add(oneMission);
			
			
			String activityObjectIdTemp = activityObjectIds[i];//任务id
			//1根据id取任务的工作量 所有类别 "'G660201','G660205','G660301','G660305','G660401','G660404','G660501','G660502','G660601','G660602','G660701','G660705'"
			sql = "select * from bgp_p6_workload w "+
			" where w.project_info_no = '"+projectInfoNo+"'"+
			" and w.bsflag = '0' and w.produce_date is null and w.resource_id in ("+workloadUsed+") "+
			" and w.activity_object_id="+activityObjectIdTemp;
			page = radDao.queryRecordsBySQL(sql.toString(), page);
			list = page.getData();
			
			//2取任务的天数
			day = 0;//任务的天数
			sql ="select ''||a.name as name,to_char(a.planned_start_date, 'yyyy-MM-dd') as min_start_date,to_char(a.planned_finish_date, 'yyyy-MM-dd') as max_finish_date "+
			" from bgp_p6_activity a where a.bsflag = '0' and a.object_id = "+activityObjectIds[i];
			rs = null;//天数的结果 key ：day ，start_date
			rs = getDayRs(sql);
			day = (Integer)rs.get("day");//天数
			temp = (Date)rs.get("start_date");//开始日期
			String mname = (String)rs.get("name");
			
			//3对结果进行工作量类别的分类
			Set<String> set = new HashSet<String>();
			StringBuilder workloadType= new StringBuilder();
			for(int a=0;a<list.size();a++){
			//@@@@@@@一个任务下的所有已添加的工作量数值
				Map dt = (Map)list.get(a);
				
				//oneMission.put("name", (String)dt.get("activity_name"));//任务名称放入任务结果map
				oneMission.put("name", mname);
				
				
				String temprid = (String)dt.get("resource_id");//工作量所属的类别
				String newtemprid = temprid.substring(0, temprid.length()-2);//G660101-> G6601
				if(set.add(newtemprid)){//此任务工作量类型不存在
					workloadType.append(newtemprid).append(",");
				}
				
				//通过天数来计算每一天的工作量
				long dayworknum = 0;
				long yudayworknum = 0;//剩余的工作量加到最后一天上
				System.out.println(temprid);
				long day_1 = 0;//剩余天数减去平均天数
				long day_2 = 0;//平均摊到最后每一天
				if (day != 0)
				{
					if (workloadcodeSet.contains(temprid))
					{
						// 为工作量 为小数
						dayworknum = (long) (Float.valueOf(
								((String) dt.get("planned_units")))
								.floatValue() * 100 / day);
						yudayworknum = (long) (Float.valueOf(
								((String) dt.get("planned_units")))
								.floatValue() * 100 % day);
					} else
					{
						// 为整数
						dayworknum = Long.valueOf(
								((String) dt.get("planned_units"))).longValue()
								/ day;
						yudayworknum = Long.valueOf(
								((String) dt.get("planned_units"))).longValue()
								% day; 
						//
						if (yudayworknum > 0)
						{
							day_2 = day - yudayworknum;
						}
					}
				}
				
				Date tt = new Date();//一个工作量 的日期
				tt.setTime(temp.getTime());
				for(int d=0;d<day;d++){
					
				
					if(d == (day_2)){
						dayworknum = dayworknum+1;//剩余的工作量加到最后一天上
					}
					
					//格式化数字 保留两位小数
					
			        //System.out.println(df.format(dayworknum));
					String dayworknumStr = "";
					if(workloadcodeSet.contains(temprid)){
						//为工作量 为小数
						DecimalFormat df = new DecimalFormat("#.##");
						dayworknumStr = df.format((float)dayworknum/100);
					}else{
						//为整数
						dayworknumStr = String.valueOf(dayworknum);
					}
					
					///带日期的工作量   所有任务的工作量  依据 key  日期+任务id+工作量类型id+具体工作量编码 (工作量,坐标点) 来取此工作量值
					dayWorkload.put("d_"+DateOperation.formatDate(tt, "yyyy-MM-dd")+"_mid_"+activityObjectIds[i].replaceAll("'", "")+"_"+temprid.substring(0, temprid.length()-2)+"_"+temprid.substring(temprid.length()-2, temprid.length()), dayworknumStr);
					tt.setTime(tt.getTime()+86400000L);
					//dayWorkload.put("d_2013-01-01_mid_11_G6601_02", "3");
				}
				
			}
			//@@@@@@@@@@一个任务下包含的工作量类型（重力 磁力）
			allWorkloadType.put("mid_"+activityObjectIds[i].replaceAll("'", ""), workloadType.substring(0, workloadType.length()-1));//一个任务下的工作量分类
		}

		
		Map rsMap = new HashMap();
		rsMap.put("allMission", allMission);
		rsMap.put("allWorkloadType", allWorkloadType);
		rsMap.put("dayWorkload", dayWorkload);
		rsMap.put("allList", allList);
		
		return rsMap;
	}
	
	
	 private Map getDayRs(String sql){
    	PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		Map rs = new HashMap();
		//根据projectInfoNo，resource_id(工作量编码)  查 bgp_p6_workload 工作量分配表  获得此工作量的任务id （activity_object_id） 根据此id 查询表bgp_p6_activity，获得任务的开始 min 结束日期max
	    page = radDao.queryRecordsBySQL(sql.toString(), page);
		List list = page.getData();
		int day = 0;
		if (list != null && list.size() != 0) {
			//计算 开始日期 结束日期 中共经过多少天
			//只有一条数据 
			Map map = (Map) list.get(0);
			String min_start_date = (String) map.get("min_start_date");
			String max_finish_date = (String) map.get("max_finish_date");
			Date start_date = null;
			Date end_date = null;
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
				e.printStackTrace();
			}
			rs.put("start_date", start_date);
			if (start_date == null || end_date == null) {
				//bgp_p6_workload 未分配工作量（resource_id）不包含指定编码
				day = 0;
			} else {
				//****分配工作量  计算天数
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
			rs.put("day", Integer.valueOf(day));
			rs.put("name", map.get("name"));
		}
		return rs;
			
	}
	 
	//从gp_proj_product_plan_wt表中取工作量
	private Map getWtDailyPlanFromPlan(String projectInfoNo){
			//根据projectInfoNo 从gp_proj_product_plan_wt表中取工作量
		
			PageModel page = new PageModel();
			page.setCurrPage(1);
			page.setPageSize(99999);
			
			
			String sqlTemp = null;
			String sql = null;
			
			Date start_date = null;
			Date end_date = null;
			
			String max_finish_date = null;
			String min_start_date = null;
			
			int day = 0;
			
			List list = null;
			
			Date temp = new Date();
			String dateTemp = null;
			//取项目选择的勘探方法 每种勘探方法对应不同的工作量参数

			
			String workloadUsed = "'G660201','G660203','G660301','G660303','G660401','G660402','G660501','G660502','G660601','G660602','G660701','G660705'";//计算所有包含要统计的 计划日效 的 任务消耗的时间的并级
			String activityObjectId = "";//包含指定工作量的任务的id
			//*********************************************1 取任务id*****************************************************
			 sql ="select distinct t.mid as id from gp_proj_product_plan_wt t where t.project_info_no='"+projectInfoNo+"' order by t.mid ";
			 sql ="select distinct t.mid as id,''||a.name as name from gp_proj_product_plan_wt t,bgp_p6_activity a where a.object_id=t.mid and t.project_info_no='"+projectInfoNo+"' order by t.mid ";
			 page = radDao.queryRecordsBySQL(sql.toString(), page);
			 List allMission = page.getData();//任务  list中存放每一个任务的Map 有顺序
			 			//oneMission.put("name", (String)dt.get("activity_name"));//任务名称放入任务结果map
			
			//*********************************************2 总的任务天数*****************************************************
		    sql ="select distinct t.mdate as record_month  from gp_proj_product_plan_wt t where t.project_info_no='"+projectInfoNo+"' order by t.mdate ";
		    page = radDao.queryRecordsBySQL(sql.toString(), page);
		    List allList = page.getData();
		   
		    
			//*************************************************3 工作量类型   工作量****************************************************************
		    
		    Map allWorkloadType = new HashMap();//任务下工作量类型  所有任务的工作量类型 依据 key   任务id  来取此任务包含的工作量类型 allWorkloadType.put("mid_11", "G6601,G6602");allWorkloadType.put("mid_22", "G6601");
			Map dayWorkload = new HashMap();///带日期的工作量   所有任务的工作量  依据 key  日期+任务id+工作量类型id+具体工作量编码 (工作量,坐标点) 来取此工作量值 dayWorkload.put("d_2013-01-01_mid_11_G6601_01", "1");dayWorkload.put("d_2013-01-01_mid_11_G6601_02", "3");
			Map dremarkMap = new HashMap();//备注
		    
		    sql ="select * from gp_proj_product_plan_wt t where t.project_info_no='"+projectInfoNo+"' order by t.wtypeid ";
			page = radDao.queryRecordsBySQL(sql.toString(), page);
			List rslist= page.getData();
			Map<String,String> rsMap = null;
			String midkey = null;
			String workloadtype = null;
			for (int j = 0; j < rslist.size(); j++) {
				rsMap = (Map)rslist.get(j);
				//allWorkloadType.put("mid_11", "G6601,G6602")
				midkey = "mid_"+rsMap.get("mid");
				if(allWorkloadType.get(midkey)==null){
					allWorkloadType.put(midkey, rsMap.get("wtypeid"));
				}else{
					workloadtype = (String)allWorkloadType.get(midkey);
					if(workloadtype.indexOf(rsMap.get("wtypeid"))==-1){
						allWorkloadType.put(midkey,workloadtype+","+rsMap.get("wtypeid"));
					}
				}
				
				 ///带日期的工作量   所有任务的工作量  依据 key  日期+任务id+工作量类型id+具体工作量编码 (工作量,坐标点) 来取此工作量值
				dayWorkload.put("d_"+rsMap.get("mdate")+"_mid_"+rsMap.get("mid")+"_"+rsMap.get("wtypeid")+"_"+rsMap.get("wid"), rsMap.get("value"));
				dremarkMap.put("b_"+rsMap.get("mdate"), rsMap.get("dremark"));//****************************备注****************************
			}

			
			Map rsm = new HashMap();
			rsm.put("allMission", allMission);
			rsm.put("allWorkloadType", allWorkloadType);
			rsm.put("dayWorkload", dayWorkload);
			rsm.put("allList", allList);
			rsm.put("dremarkMap", dremarkMap);
			
			
			
			return rsm;
		}
	
	/**
	 * 获得工作量类型单位
	 * 
	 * @return key 工作量类型（重力 ，磁力。。。。） ，value 类型的单位 km km2 。。
	 * 
	 */
	private Map<String,String> getWorkloadUnit(String projectInfoNo) {
		//根据施工方法编码获得施工方法对应的工作量类型 的单位
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		
		
		String sqlTemp = null;
		String sql = null;
		
		Date start_date = null;
		Date end_date = null;
		
		String max_finish_date = null;
		String min_start_date = null;
		
		int day = 0;
		
		List list = null;
		
		Date temp = new Date();
		String dateTemp = null;
		
		Map<String,String> workloadUnitMap = new HashMap();
		
	    sql ="select p.ACTIVITY_OBJECT_ID, t.EXPLORATION_METHOD,t.LINE_UNIT from gp_wt_workload t ,bgp_activity_method_mapping p where t.EXPLORATION_METHOD=p.EXPLORATION_METHOD and p.PROJECT_INFO_NO='"+projectInfoNo+"' and t.PROJECT_INFO_NO='"+projectInfoNo+"'";
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		List rslist= page.getData();
		Map<String,String> rsMap = null;
		
		for (int j = 0; j < rslist.size(); j++) {
			rsMap = (Map)rslist.get(j);
			if(rsMap.get("line_unit")!=null&&!"".equals(rsMap.get("line_unit"))){
				workloadUnitMap.put("_"+rsMap.get("activity_object_id"), rsMap.get("line_unit"));
			}
			
		}


		return workloadUnitMap;
		
	}
	
	
	private Map<String,String> getDesignTotal(String projectInfoNo){
		Map totalUnitsMap = new HashMap();
		String[] measure2Type = {"G02003","G02004"};
		String[] measure3Type = {"G2003","G2004"};
		
		String[] drill2Type = {"G05001"};
		String[] drill3Type = {"G5001"};
		
		String[] coll2Type = {"G07001","G07003","G07005"};
		String[] coll3Type = {"G7001","G7003","G7005"};
		
		String method_sql = "select exploration_method from gp_task_project  where project_info_no = '"+projectInfoNo+"' and bsflag = '0'";
		Map totalMap = radDao.queryRecordBySQL(method_sql);
		
		
		String exploration_method = null;
		if (totalMap != null) {
			exploration_method = (String) totalMap.get("exploration_method");
		} 
		
		//测量
		String measureSqlTemp = "";
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			measureSqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				measureSqlTemp = measureSqlTemp + measure2Type[i] + "','";
			}
			measureSqlTemp = measureSqlTemp.substring(0, measureSqlTemp.length()-2);
			measureSqlTemp += ") order by a.planned_start_date";
		} else {
			measureSqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				measureSqlTemp = measureSqlTemp + measure3Type[i] + "','";
			}
			measureSqlTemp = measureSqlTemp.substring(0, measureSqlTemp.length()-2);
			measureSqlTemp += ") order by a.planned_start_date";
		}

		String measureSql =  "select nvl(sum(w.planned_units),0) as measure_plan_units from bgp_p6_workload w " +
							 " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
							 " where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' ";
		measureSql += measureSqlTemp;
		String totalMeasure = "";
		if(radDao.queryRecordBySQL(measureSql)!=null){
			 totalMeasure = radDao.queryRecordBySQL(measureSql).get("measure_plan_units").toString();
		}
		totalUnitsMap.put("totalMeasure", totalMeasure);
		
		
		//钻井
		String drillSqlTemp = "";
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			drillSqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill2Type.length; i++) {
				drillSqlTemp = drillSqlTemp + drill2Type[i] + "','";
			}
			drillSqlTemp = drillSqlTemp.substring(0, drillSqlTemp.length()-2);
			drillSqlTemp += ")";
		} else {
			drillSqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill3Type.length; i++) {
				drillSqlTemp = drillSqlTemp + drill3Type[i] + "','";
			}
			drillSqlTemp = drillSqlTemp.substring(0, drillSqlTemp.length()-2);
			drillSqlTemp += ")";
		}
		
		String drillSql = "select nvl(sum(w.planned_units),0) as drill_planned_units from bgp_p6_workload w " +
						  " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
						  " where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' ";

		drillSql += drillSqlTemp;
		String totalDrill = "";
		if(radDao.queryRecordBySQL(drillSql)!=null){
			totalDrill = radDao.queryRecordBySQL(drillSql).get("drill_planned_units").toString();
		}
		totalUnitsMap.put("totalDrill", totalDrill);
		
		//采集
		String collSqlTemp = "";
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			collSqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll2Type.length; i++) {
				collSqlTemp = collSqlTemp + coll2Type[i] + "','";
			}
			collSqlTemp = collSqlTemp.substring(0, collSqlTemp.length()-2);
			collSqlTemp += ")";
		} else {
			collSqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll3Type.length; i++) {
				collSqlTemp = collSqlTemp + coll3Type[i] + "','";
			}
			collSqlTemp = collSqlTemp.substring(0, collSqlTemp.length()-2);
			collSqlTemp += ")";
		}
		
		String collSql = "select nvl(sum(w.planned_units),0) as coll_planned_units from bgp_p6_workload w " +
						 " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
						 " where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' ";

		collSql += collSqlTemp;
		String totalColl = "";
		if(radDao.queryRecordBySQL(collSql)!=null){
			totalColl = radDao.queryRecordBySQL(collSql).get("coll_planned_units").toString();
		}
		totalUnitsMap.put("totalColl", totalColl);
		
		return totalUnitsMap;
	}
	
	
	
	private void deleteDailyPlan(final List<String> ids){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String sql = "update gp_proj_product_plan set bsflag = '1' where pro_plan_id = ?" ;
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return ids.size();
			}
			
			@Override
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				ps.setString(1, ids.get(i));
			}
			
		};
		
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	private void saveDailyPlan(final List list){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"RECORD_MONTH","WORKLOAD","WORKLOAD_NUM","PROJECT_INFO_NO","OPER_PLAN_TYPE","BSFLAG","PRO_PLAN_ID"};
		StringBuffer sql = new StringBuffer();
		sql.append("insert into gp_proj_product_plan (");
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
				Map map = (Map) list.get(i);
				
				ps.setString(1, (String) map.get("record_month"));
				ps.setString(2, (String) map.get("workload"));
				ps.setString(3, (String) map.get("workload_num"));
				ps.setString(4, (String) map.get("project_info_no"));
				ps.setString(5, (String) map.get("oper_plan_type"));
				ps.setString(6, "0");
				ps.setString(7, radDao.generateUUID());
			}
			
		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	
	private List countDailyPlan(String projectInfoNo){
		//根据projectInfoNo 从bgp_p6_workload表中取工作量
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		
		List AllList = new ArrayList();
		List measuredailylist = new ArrayList();
		List drilldailylist = new ArrayList();
		List colldailylist = new ArrayList();
		
		/**
		 * 
		
		String[] measure2Type = {"G02003","G02004"};
		String[] measure3Type = {"G2003","G2004"};
		
		String[] drill2Type = {"G05001"};
		String[] drill3Type = {"G5001"};
		
		String[] coll2Type = {"G07001","G07003","G07005"};
		String[] coll3Type = {"G7001","G7003","G7005"};
		 */
		String[] measureType = {"G9001"};//测量
		String[] drillType = {"G10001"};//钻井
		String[] collType = {"G1301"};//采集
		 
		
		 
		/**
		 * 
		 
		String sql = "select exploration_method from gp_task_project  where project_info_no = '"+projectInfoNo+"' and bsflag = '0'";
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		List list = page.getData();
		
		String exploration_method = null;
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			exploration_method = (String) map.get("exploration_method");
		} else {
			return null;
		}
		*/
		
		String sqlTemp = null;
		String sql = null;
		//总的
		/**
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		}
		*/

		sqlTemp = " and resource_id in ('G9001','G10001','G1301')";
		
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		String max_finish_date = null;
		String min_start_date = null;
		
		Date start_date = null;
		Date end_date = null;
		
		int day = 0;
		
		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		Date temp = start_date;
		String dateTemp = null;
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			temp.setTime(temp.getTime()+86400000L);
			AllList.add(map);
		}
		
		
		//测量
		/**
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ") order by a.planned_start_date";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ") order by a.planned_start_date";
		}
		*/
		sqlTemp = " and resource_id in ('G9001') order by a.planned_start_date";
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		max_finish_date = null;
		min_start_date = null;
		
		start_date = null;
		end_date = null;
		
		day = 0;
		
		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		
		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration, 3) end) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();
		
		temp = new Date();
		dateTemp = null;
		
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime()+86400000L*i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			
			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");
				
				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String)tempMap.get("average_units"));
				}
			}
			map.put("workload_num", df_1.format(workload_num));
			measuredailylist.add(map);
		}
		
	/**	
//		String startDate = null;
//		String endDate = null;
//		
//		Date sd = null;
//		Date ed = null;
//		Date tempDate = null;
//		
//		for (int i = 0; i < list.size(); i++) {
//			Map tempMap = (Map) list.get(i);
//			startDate = (String) tempMap.get("start_date");//每个作业的开始时间
//			endDate = (String) tempMap.get("finish_date");//每个作业的结束时间
//			
//			tempDate = DateOperation.parseToUtilDate(startDate);//用于比较
//			
//			if (sd == null || ed == null) {
//				//如果sd为null 该记录为第一条作业
//				sd = tempDate;
//				ed = DateOperation.parseToUtilDate(endDate);
//			} else if(DateOperation.getDateSkip(endDate,DateOperation.formatDate(sd)) > 0) {
//				//如果endDate > sd
//				
//			} else {
//				//如果endDate <= sd
//				
//			}
//			
//		}
	*/	
		//钻井
		/**
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		}
		*/
		sqlTemp = " and resource_id in ('G10001')";
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		max_finish_date = null;
		min_start_date = null;
		
		start_date = null;
		end_date = null;
		
		day = 0;
		
		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		
		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration, 3) end) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();
		
		temp = new Date();
		dateTemp = null;
		
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime()+86400000L*i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			
			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");
				
				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String)tempMap.get("average_units"));
				}
			}
			map.put("workload",df_1.format(workload_num));
			drilldailylist.add(map);
		}
		
		//采集
		/**
		if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
			sqlTemp += ")";
		}
		*/
		sqlTemp = " and resource_id in ('G1301')";
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		max_finish_date = null;
		min_start_date = null;
		
		start_date = null;
		end_date = null;
		
		day = 0;
		
		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		
		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration, 3) end) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();
		
		temp = new Date();
		dateTemp = null;
		
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime()+86400000L*i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			
			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");
				
				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String)tempMap.get("average_units"));
				}
			}
			map.put("workload", df_1.format(workload_num));
			colldailylist.add(map);
		}
		
		List list2 = new ArrayList();
		list2.add(AllList);
		list2.add(measuredailylist);
		list2.add(drilldailylist);
		list2.add(colldailylist);
		return list2;
	}
	
	private void updateDailyPlan(final List list){
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"RECORD_MONTH","WORKLOAD","WORKLOAD_NUM","PROJECT_INFO_NO","OPER_PLAN_TYPE","BSFLAG","PRO_PLAN_ID"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("update gp_proj_product_plan set ");
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
				Map map = (Map) list.get(i);
				
				ps.setString(1, (String) map.get("record_month"));
				ps.setString(2, (String) map.get("workload"));
				ps.setString(3, (String) map.get("workload_num"));
				ps.setString(4, (String) map.get("project_info_no"));
				ps.setString(5, (String) map.get("oper_plan_type"));
				ps.setString(6, "0");
				ps.setString(7, (String) map.get("pro_plan_id"));
			}
			
		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	
	public ISrvMsg queryDailyQuestion(ISrvMsg reqDTO) throws Exception{
		
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);
		
		String produceDate = reqDTO.getValue("produceDate");//问题日期
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String bugCode = reqDTO.getValue("bugCode");//问题分类
		
		UserToken user = reqDTO.getUserToken();
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}
		
		String sql = "select * from gp_ops_daily_question where bsflag = '0' ";
		
		if (projectInfoNo != null) {
			sql = sql + " and project_info_no = '"+projectInfoNo+"' ";
		}
		if (produceDate != null) {
			sql = sql + " and produce_date = to_date('"+produceDate+"','yyyy-MM-dd')";
		}
		if (bugCode != null) {
			sql = sql + " and bug_code = '"+bugCode+"' ";
		}
		
		page = radDao.queryRecordsBySQL(sql, page);
		List list = page.getData();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("questionList", list);
		
		
		return msg;
	}
	
	public ISrvMsg queryDailyQuestionList(ISrvMsg reqDTO) throws Exception{
		
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
		
		String produceDate = reqDTO.getValue("produceDate");//问题日期
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String bugCode = reqDTO.getValue("bugCode");//问题分类
		
		UserToken user = reqDTO.getUserToken();
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}
		
		String sql = "select * from gp_ops_daily_question where bsflag = '0' ";
		
		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			sql = sql + " and project_info_no = '"+projectInfoNo+"' ";
		}
		if (produceDate != null && !"".equals(produceDate) && !"null".equals(produceDate)) {
			sql = sql + " and produce_date = to_date('"+produceDate+"','yyyy-MM-dd')";
		}
		if (bugCode != null && !"".equals(bugCode)) {
			sql = sql + " and bug_code = '"+bugCode+"' ";
		}
		
		page = radDao.queryRecordsBySQL(sql, page);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		
		return msg;
	}
	
	private void saveDailyQuestion(final List list) throws Exception{
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"project_info_no","org_id","org_subjection_id","bug_code","bug_name","resolvent","q_description","produce_date","creator","create_date","updator","modifi_date","bsflag","question_id"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into gp_ops_daily_question (");
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
				Map map = (Map) list.get(i);
				
				ps.setString(1, (String) map.get("project_info_no"));
				ps.setString(2, (String) map.get("org_id"));
				ps.setString(3, (String) map.get("org_subjection_id"));
				ps.setString(4, (String) map.get("bug_code"));
				ps.setString(5, (String) map.get("bug_name"));
				ps.setString(6, (String) map.get("resolvent"));
				ps.setString(7, (String) map.get("q_description"));
				
				SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
				java.sql.Date date;
				try {
					date = new java.sql.Date(f.parse((String) map.get("produce_date")).getTime());
					ps.setDate(8, date);
				} catch (Exception e) {
					ps.setDate(8, null);
				}
				
				ps.setString(9, (String) map.get("creator"));
				ps.setDate(10, new java.sql.Date(new Date().getTime()));
				
				ps.setString(11, (String) map.get("updator"));
				ps.setDate(12, new java.sql.Date(new Date().getTime()));
				
				ps.setString(13, "0");
				
				ps.setString(14, radDao.generateUUID());
			}
			
		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
		
	}
	
	private void updateDailyQuestion(final List list) throws Exception{
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		
		String[] propertys = {"project_info_no","org_id","org_subjection_id","bug_code","bug_name","resolvent","q_description","produce_date","updator","modifi_date","bsflag","question_id"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("update gp_ops_daily_question set ");
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
				Map map = (Map) list.get(i);
				
				ps.setString(1, (String) map.get("project_info_no"));
				ps.setString(2, (String) map.get("org_id"));
				ps.setString(3, (String) map.get("org_subjection_id"));
				ps.setString(4, (String) map.get("bug_code"));
				ps.setString(5, (String) map.get("bug_name"));
				ps.setString(6, (String) map.get("resolvent"));
				ps.setString(7, (String) map.get("q_description"));
				
				SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
				java.sql.Date date;
				try {
					date = new java.sql.Date(f.parse((String) map.get("produce_date")).getTime());
					ps.setDate(8, date);
				} catch (Exception e) {
					ps.setDate(8, null);
				}
				
				ps.setString(9, (String) map.get("updator"));
				ps.setDate(10, new java.sql.Date(new Date().getTime()));
				
				ps.setString(11, "0");
				
				ps.setString(12, (String) map.get("question_id"));
			}
			
		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
		
	}
	
	/**
	 * 查询项目进度信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg queryDailyReportProcess(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		//String produceDate = reqDTO.getValue("produceTime");
		String startDate = reqDTO.getValue("startTime");
		String endDate = reqDTO.getValue("endTime");
		String orgId = reqDTO.getValue("orgId");
		String projectType = reqDTO.getValue("projectType");
		String explorationMethod = reqDTO.getValue("explorationMethod");
		
        Map<String, String> paramMap = new HashMap<String, String>();

        paramMap.put("projectInfoNo", projectInfoNo);
        //paramMap.put("produceDate", produceDate);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate", endDate);   
        paramMap.put("orgId", orgId);
        paramMap.put("projectType", projectType);
        paramMap.put("explorationMethod", explorationMethod);
        
        //获得当前页
        String currentPage = reqDTO.getValue("cur");
        
        String cur = null;
        String pageSize1 = "20";
        if (currentPage == null) {
            cur = "1";
        } else {
            cur = currentPage;
        }
        
        log.debug("the currentPage is:"+currentPage);
        
        String totalRows = null;
        List<Map> produceDateList = loadAllProduceDate(paramMap);
        //处理记录总数
        if(produceDateList != null && produceDateList.size()>0) {
        	
            totalRows = String.valueOf(produceDateList.size());
        } else {
        	
            totalRows = "0";  
        }
        
        //分页后的的日报生产日期列表
        List<Map> dateList = new ArrayList();

		if (produceDateList != null && !produceDateList.isEmpty()) {

			int currPage = new Integer(cur);
			int totalRow = new Integer(totalRows);
			int pageSize = new Integer(pageSize1);
			int reCount = 0;
			if (totalRow < pageSize)
				reCount = totalRow;
			else {
				if (totalRow - (currPage - 1) * pageSize > pageSize)
					reCount = pageSize;
				else{
					if(currPage==1)
						reCount = pageSize;
					else 
						reCount = totalRow -(currPage-1) * pageSize;
				}
					
			}
			for (int i = (currPage - 1) * pageSize; i < (currPage - 1) * pageSize+reCount; i++) {
				dateList.add(produceDateList.get(i));
			}
		}
        
        
        
        //获取符合条件的生产日期
        //List<Map> dateMaps = loadAllProduceDate(paramMap);
        List<DailyReportProcessRatePOJO> totalList = new ArrayList<DailyReportProcessRatePOJO>();
        if(dateList != null && dateList.size() != 0){
        	for(int i=0;i<dateList.size();i++){
        		Map dateMap = dateList.get(i);
        		String produce_date = dateMap.get("produceDate").toString();

        		paramMap.put("produceDate", produce_date);
        		DailyReportProcessRatePOJO dailyReportProcessRate = findDailyReportProcessByProject(paramMap);
        		totalList.add(dailyReportProcessRate);       		
        	}
        }
        
        msg.setValue("pageSize", pageSize1);//页面记录条数        
        msg.setValue("cur", cur);//当前页码        
        msg.setValue("totalRows", totalRows);//记录总数2        
        msg.setValue("totalList", totalList );//日报进度信息列表2
        msg.setValue("projectInfoNo", projectInfoNo);//项目编号
        msg.setValue("projectType", projectType );//项目类型
        msg.setValue("explorationMethod", explorationMethod );//勘探类型
        msg.setValue("startDate", startDate );//生产日期开始时间
        msg.setValue("endDate", endDate );//生产日期结束时间
        
		return msg;
	}
	
    /**
     * 查找所有符合条件的不重复的的生产日期
	 * 
	 * @param  map  Map  表单参数
	 * @return list List 日报生产日期列表
	 * @throws 无
	 */
	public List loadAllProduceDate(Map map) {

	    	String projectInfoNo = (String)map.get("projectInfoNo");
	    	String produceDate = (String)map.get("produceDate");
	    	String startDate = (String)map.get("startDate");
	        String endDate = (String)map.get("endDate");
	        String explorationMethod = (String)map.get("explorationMethod");
	        
	        //如果为空，说明是按项目；如果不为空，说明是按项目的施工队伍
	        String orgId = (String)map.get("orgId");
	        
	        if(projectInfoNo == null) {
	        	projectInfoNo = "";
	        }
	        if(produceDate == null) {
	        	produceDate = "";
	        }
	        if(startDate == null) {
	        	startDate = "";
	        }
	        if(endDate == null) {
	        	endDate = "";
	        }
	        if(orgId == null) {
	        	orgId = "";
	        } 
	        if(explorationMethod == null) {
	        	explorationMethod = "";
	        } 
	        
	        String sqlDates = "select distinct t1.produce_date from gp_ops_daily_report t1 left outer join gp_task_project gp on t1.project_info_no = gp.project_info_no where t1.audit_status = '3' and t1.bsflag = '0' and gp.bsflag = '0'";
	        
	        if(!orgId.equals("")) {
	        	
	        	sqlDates = sqlDates + " and t1.org_id = '"+orgId+"'";
	        }
	        if(!projectInfoNo.equals("")) {
	        	
	        	sqlDates = sqlDates + " and t1.project_info_no = '"+projectInfoNo+"'";
	        }        
	        if(!startDate.equals("")) {
	        	
	        	sqlDates = sqlDates + " and t1.produce_date >= to_date('" + startDate + "','yyyy-mm-dd')";
	        }
	        
	        if(!endDate.equals("")) {
	        	
	        	sqlDates = sqlDates + " and TO_CHAR(t1.produce_date,'YYYY-MM-DD') <= '" + endDate + "'";
	        }
	        if(!explorationMethod.equals("")) {
	        	
	        	sqlDates = sqlDates + " and t1.exploration_method= '" + explorationMethod + "'";
	        }

	        sqlDates = sqlDates + "order by t1.produce_date desc";

	        log.debug("the sql is:"+sqlDates);
	        
	        List list = jdbcDao.queryRecords(sqlDates);
	        
	        return list;
	    }
	/**
	 * 如果Long格式为空，转换为０
	 * 
	 * @param par  Long  转换前的数据 
	 * @return par  Long  转换后的数据
	 * @throws 无
	 */
	public static Long nullToLong(Long par) {
		if (par == null ) {
			return new Long(0);
		} else {
			try{
				return par;
			} catch (Exception e){
				e.printStackTrace();
				return new Long(0);
			}			
		}
	}
	
	/**
	 * 按项目查找日报进度信息
	 * 
	 * @param  map  Map  表单参数
	 * @return dailyReportProcessRatePOJO DailyReportProcessRatePOJO 日报进度信息对象
	 * @throws 无
	 */
	public DailyReportProcessRatePOJO findDailyReportProcessByProject(Map map){
		
		log.debug("进入 GpOpsDailyReportDAO 的 findDailyReportProcessByProject 方法.....");
		log.debug("The map is:"+map);
		
    	String projectInfoNo = (String)map.get("projectInfoNo");
    	String projectType = (String)map.get("projectType");
    	String produceDate = (String)map.get("produceDate");
    	String explorationMethod = (String)map.get("explorationMethod");
    	String explorationMethod1 = "";
    	if (explorationMethod1 != null) {
    		explorationMethod1 = explorationMethod;
    		if (explorationMethod1 == "2" || "2".equals(explorationMethod1)) {
    			explorationMethod1 = "0300100012000000002";
			} else {
				explorationMethod1 = "0300100012000000003";
			}
		}
    	
        if(produceDate == null) {
        	produceDate = "";
        }
        if(projectInfoNo == null) {
        	projectInfoNo = "";
        }
        
        DailyReportProcessRatePOJO dpProcess = new DailyReportProcessRatePOJO();

        //生产日期
        dpProcess.setProductDate(produceDate);
        
        //查询已提交的日报主表信息
        String sqlReport = " select dr.* from gp_ops_daily_report dr left outer join gp_task_project gp on dr.project_info_no = gp.project_info_no where dr.bsflag = '0' and gp.bsflag = '0' and dr.audit_status = '3'";
        if(projectInfoNo != ""){
        	sqlReport = sqlReport + " and dr.project_info_no = '"+projectInfoNo+"'";
        }
        if(produceDate != ""){
        	sqlReport = sqlReport + " and dr.produce_date =  TO_DATE('"+ produceDate+ "','YYYY-MM-DD')";
        }

        List<Map> listReport = jdbcDao.queryRecords(sqlReport);

        if(listReport == null || listReport.isEmpty()){
			
			log.debug("离开 GpOpsDailyReportDAO 的 findDailyReportProcessByProject 方法.....");
			
			return dpProcess;	
        }

        long acquireShot = (long) 0;//采集日完成点数震源炮点数+井炮炮点数+气枪炮点数
        long drillShot = (long) 0;//钻井日完成点数
        long surfaceShot = (long) 0;//表层日完成点数=小折射日完成点数+微测井日完成点数
        long surveyShotNum = (long) 0;//测量日完成炮点数
        long surveyGeophoneNum = (long) 0;//测量日完成检波点数
        
        for (int j = 0; j < listReport.size(); j++) {
        	
        	//GpOpsDailyReport dailyReport = (GpOpsDailyReport)listReport.get(j);
        	Map dailyReport = listReport.get(j);
        	acquireShot = acquireShot + nullToLong(Long.valueOf(dailyReport.get("dailyAcquireSpNum").toString()!=""?dailyReport.get("dailyAcquireSpNum").toString():"0")) + nullToLong(Long.valueOf(dailyReport.get("dailyJpAcquireShotNum").toString()!=""?dailyReport.get("dailyJpAcquireShotNum").toString():"0")) + nullToLong(Long.valueOf(dailyReport.get("dailyQqAcquireShotNum").toString()!=""?dailyReport.get("dailyQqAcquireShotNum").toString():"0"));            	
	       	drillShot = drillShot + nullToLong(Long.valueOf(dailyReport.get("dailyDrillSpNum").toString()!=""?dailyReport.get("dailyDrillSpNum").toString():"0"));
        	surfaceShot = surfaceShot + nullToLong(Long.valueOf(dailyReport.get("dailySmallRefractionNum").toString()!=""?dailyReport.get("dailySmallRefractionNum").toString():"0"))+ nullToLong(Long.valueOf(dailyReport.get("dailyMicroMeasuePointNum").toString()!=""?dailyReport.get("dailyMicroMeasuePointNum").toString():"0"));
        	surveyShotNum = surveyShotNum + nullToLong(Long.valueOf(dailyReport.get("dailySurveyShotNum").toString()!=""?dailyReport.get("dailySurveyShotNum").toString():"0")) ;
        	surveyGeophoneNum = surveyGeophoneNum + nullToLong(Long.valueOf(dailyReport.get("dailySurveyGeophoneNum").toString()!=""?dailyReport.get("dailySurveyGeophoneNum").toString():"0"));
        }
        
        //将日完成点数置进所拼pojo
        dpProcess.setCollShotNum(String.valueOf( acquireShot));
        dpProcess.setDrillShotNum(String.valueOf( drillShot));
        dpProcess.setSurfacePointNo(String.valueOf( surfaceShot ));
        dpProcess.setSurveyShotNum(String.valueOf( surveyShotNum ));
        dpProcess.setSurveyGeophoneNum(String.valueOf( surveyGeophoneNum ));
       
		//查找各项项目累计值
        String sql1 = "select nvl(sum(nvl(t1.daily_acquire_sp_num,0)),0) as projectAcquireSpNum1 ," +
        		"nvl(sum(nvl(t1.daily_micro_measue_point_num,0)),0) as projectMicroMeasueNum," +
        		"nvl(sum(nvl(t1.daily_small_refraction_num,0)),0) as projectSmallRefractionNum ," +
        		"nvl(sum(nvl(t1.daily_survey_shot_num,0)),0) as projectSurveyShotNum ," +
        		"nvl(sum(nvl(t1.daily_survey_geophone_num,0)),0) as projectSurveyGeophoneNum ," +
        		"nvl(sum(nvl(t1.daily_drill_sp_num,0)),0) as projectDrillSpNum ," +
        		"nvl(sum(nvl(t1.daily_jp_acquire_shot_num,0)),0) as projectAcquireSpNum2," +
        		"nvl(sum(nvl(t1.daily_qq_acquire_shot_num,0)),0) as projectAcquireSpNum3 " +
        		"from gp_ops_daily_report t1 left outer join gp_task_project gp on " +
        		"t1.project_info_no = gp.project_info_no " +
        		"where t1.bsflag = '0' and gp.bsflag = '0' ";
		        if(projectInfoNo != ""){
		        	sql1 = sql1 + " and t1.project_info_no = '"+projectInfoNo+"'";
		        }
		        if(produceDate != ""){
		        	sql1 = sql1 + " and TO_CHAR(t1.produce_date,'YYYY-MM-DD') <= '"+produceDate+"'";
		        }

		List<Map> listsql1 = jdbcDao.queryRecords(sql1);
		
		//没有符合条件的记录
		if (listsql1 == null || listsql1.isEmpty()){

			return dpProcess;		
		} 
		Long projectAcquireSpNum1 = (long)0;
		Long projectAcquireSpNum2 = (long)0;
		Long projectAcquireSpNum3 = (long)0;
		Long projectAcquireSpNum = (long)0;

		Long projectMicroMeasueNum = (long)0;
		Long projectSmallRefractionNum = (long)0;	
		Long projectSurveyShotNum = (long)0;
		Long projectSurveyGeophoneNum = (long)0;
		Long projectDrillSpNum = (long)0;
		
		Map listsqlMap = listsql1.get(0);
		if(listsqlMap != null){
			projectAcquireSpNum1 = Long.valueOf(listsqlMap.get("projectacquirespnum1").toString());	
			projectAcquireSpNum2 = Long.valueOf(listsqlMap.get("projectacquirespnum2").toString());	
			projectAcquireSpNum3 = Long.valueOf(listsqlMap.get("projectacquirespnum3").toString());	
			projectAcquireSpNum = projectAcquireSpNum1 + projectAcquireSpNum2 + projectAcquireSpNum3;

			projectMicroMeasueNum = Long.valueOf(listsqlMap.get("projectmicromeasuenum").toString());
			projectSmallRefractionNum = Long.valueOf(listsqlMap.get("projectsmallrefractionnum").toString());		
			projectSurveyShotNum = Long.valueOf(listsqlMap.get("projectsurveyshotnum").toString());
			projectSurveyGeophoneNum = Long.valueOf(listsqlMap.get("projectsurveygeophonenum").toString());
			projectDrillSpNum = Long.valueOf(listsqlMap.get("projectdrillspnum").toString());
		}
		

				
		//将累计工作量置进所拼pojo中
		dpProcess.setCollFinishedSpNum(String.valueOf(projectAcquireSpNum));
		dpProcess.setSurfaceFinishedSpNum(String.valueOf(projectMicroMeasueNum+projectSmallRefractionNum));
		dpProcess.setSurveyFinishedSpNum(String.valueOf(projectSurveyShotNum+projectSurveyGeophoneNum));
		dpProcess.setDrillFinishedSpNum(String.valueOf(projectDrillSpNum));
			
		String sql2 = "";
		log.debug("the explorationMethod is:"+explorationMethod);
		//查找各项设计值：如果为二维，查找二维工区设计参数；如果为三、四维，查找三维工区设计参数
		if( explorationMethod != null && explorationMethod.equals("0300100012000000002")){
			sql2 = "select nvl(t.design_sp_num,0) as designSpNum," +
					"nvl(t.design_geophone_num,0) as designGeophoneNum," +
					"nvl(t.design_drilling_num,0) as designDrillNum," +
					"nvl(t.design_micro_measue_num,0) as designMicroMeasueNum," +
					"nvl(t.design_small_regraction_num,0) as designSmallRegractionNum" +
					" from gp_ops_2dwa_design_basic_data t left outer join gp_task_project gp " +
					" on t.project_info_no = gp.project_info_no where t.bsflag = '0' and gp.bsflag = '0'";
	        if(projectInfoNo != ""){
	        	sql2 = sql2 + " and t.project_info_no = '"+projectInfoNo+"'";
	        }
    		
		} else if( explorationMethod != null && explorationMethod.equals("0300100012000000003")){
    		sql2 = "select nvl(t1.design_shot_num,0) as designSpNum," +
    				"nvl(t1.receiveing_point_num,0) as designGeophoneNum," +
    				"nvl(t1.design_drilling_num,0) as designDrillNum," +
    				"nvl(t1.design_micro_measue_num,0) as designMicroMeasueNum," +
    				"nvl(t1.design_small_regraction_num,0) as designSmallRegractionNum" +
    				" from gp_ops_3dwa_design_data t1 left outer join gp_task_project gp1 " +
    				" on t1.project_info_no = gp1.project_info_no where t1.bsflag = '0' and gp1.bsflag = '0'";
	        if(projectInfoNo != ""){
	        	sql2 = sql2 + " and t1.project_info_no = '"+projectInfoNo+"'";
	        }
		}
		log.debug("The sql2 is:"+sql2);
		List<Map> listsql2 = jdbcDao.queryRecords(sql2);
		
		
		//没有符合条件的记录
		if (listsql2 == null || listsql2.isEmpty()){
			
			return dpProcess;		
		} 
		
		Long designSpNum = (long)0;
		Long designGeophoneNum = (long)0;
		Long designDrillNum = (long)0;
		Long designMicroMeasueNum = (long)0;
		Long designSmallRegractionNum = (long)0;
		Map listsqlMap2 = listsql2.get(0);
	
		if(listsqlMap2 != null){
			designSpNum = Long.valueOf(listsqlMap2.get("designspnum").toString());
			designGeophoneNum = Long.valueOf(listsqlMap2.get("designgeophonenum").toString());
			designDrillNum = Long.valueOf(listsqlMap2.get("designdrillnum").toString());
			designMicroMeasueNum = Long.valueOf(listsqlMap2.get("designmicromeasuenum").toString());
			designSmallRegractionNum = Long.valueOf(listsqlMap2.get("designsmallregractionnum").toString());
		}
		
		//计算出百分比，并四舍五入保留两位小数		
		Double projectAcquireSpRatio = 0.00;	
		Double projectSurfaceRatio = 0.00;		
		Double projectSurveyRatio = 0.00;	
		Double projectDrillSpRatio = 0.00;
	
		if(designSpNum != 0) {
			
			projectAcquireSpRatio = (double)(Math.round(10000 * (double)projectAcquireSpNum/(double)designSpNum))/100;  
		}

		if(designMicroMeasueNum+designSmallRegractionNum != 0) {
			
			projectSurfaceRatio = (double)(Math.round(10000 * (double)(projectMicroMeasueNum+projectSmallRefractionNum)/(double)(designMicroMeasueNum+designSmallRegractionNum)))/100;  
		}
		
		if(designSpNum+designGeophoneNum != 0) {
			
			projectSurveyRatio = (double)(Math.round(10000 * (double)(projectSurveyShotNum+projectSurveyGeophoneNum)/(double)(designSpNum+designGeophoneNum)))/100;  
		}
		
		if(designDrillNum != 0) {
			
			projectDrillSpRatio = (double)(Math.round(10000 * (double)projectDrillSpNum/(double)designDrillNum))/100;  
		}			
		
		//将完成百分比置进所拼pojo中
		dpProcess.setCollFinishedRate(String.valueOf(projectAcquireSpRatio));
		dpProcess.setSurfaceFinishedRate(String.valueOf(projectSurfaceRatio));
		dpProcess.setSurveyFinishedRate(String.valueOf(projectSurveyRatio));
		dpProcess.setDrillFinishedRate(String.valueOf(projectDrillSpRatio));
	   
		log.debug("操作成功，离开 GpOpsDailyReportDAO 的 findDailyReportProcessByProject 方法.....");
		
		return dpProcess;
	}
	
	/**
	 * 删除日报数据
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteDailyReport(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteDailyReport !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String dailyNos = isrvmsg.getValue("dailyNos");		
		String[] params = dailyNos.split(",");	
		String updateSql = "";
		String updateSurface = "";
		String updateSurvey = "";
		String updateAcquire = "";		
		String updateDrill = "";
		String updateSit = "";
		String getReportInfoSql = "";
		String updateDailyWorkloadSql = "";
		String updateReportQuestion = "";
		
		if(dailyNos != null){
			for(String id : params){
				//删除对应日期的工作量分配和日报对应的问题
				getReportInfoSql = "select r.project_info_no,r.produce_date from gp_ops_daily_report r where r.bsflag = '0' and r.daily_no = '"+id+"'";
				Map reportInofMap = radDao.queryRecordBySQL(getReportInfoSql);
				if(reportInofMap != null){
					updateReportQuestion = "update gp_ops_daily_question w set w.bsflag = '1' where w.project_info_no = '"+reportInofMap.get("project_info_no")+"' and w.produce_date = to_date('"+reportInofMap.get("produce_date")+"','yyyy-MM-dd')";
					radDao.executeUpdate(updateReportQuestion);
					updateDailyWorkloadSql = "update bgp_p6_workload w set w.bsflag = '1' where w.project_info_no = '"+reportInofMap.get("project_info_no")+"' and w.produce_date = to_date('"+reportInofMap.get("produce_date")+"','yyyy-MM-dd')";
					radDao.executeUpdate(updateDailyWorkloadSql);
				}
				
				updateSql = "update gp_ops_daily_report g set g.bsflag='1' where g.daily_no='"+id+"'";
				radDao.executeUpdate(updateSql);
				//删除相关联的日报数据
				updateSurface = "update gp_ops_daily_surface s set s.bsflag = '1' where s.daily_no = '"+id+"'";
				radDao.executeUpdate(updateSurface);
				updateSurvey = "update gp_ops_daily_survey s set s.bsflag = '1' where s.daily_no = '"+id+"'";
				radDao.executeUpdate(updateSurvey);
				updateAcquire = "update gp_ops_daily_acquire s set s.bsflag = '1' where s.daily_no = '"+id+"'";
				radDao.executeUpdate(updateAcquire);
				updateDrill = "update gp_ops_daily_drill s set s.bsflag = '1' where s.daily_no = '"+id+"'";
				radDao.executeUpdate(updateDrill);
				updateSit = "update gp_ops_daily_produce_sit s set s.bsflag = '1' where s.daily_no = '"+id+"'";
				radDao.executeUpdate(updateSit);

				//
			}
		}
		return responseDTO;

	}
	
	/**
	 * 重新读取计划日效
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg refreshDailyPlan(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String checkSql = "select p.pro_plan_id from gp_proj_product_plan p where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'";
		if(radDao.queryRecords(checkSql) != null && radDao.queryRecords(checkSql).size() > 0){
			String delDailyPlanSql = "update gp_proj_product_plan p set p.bsflag = '1' where p.project_info_no = '"+projectInfoNo+"'";
			if(radDao.executeUpdate(delDailyPlanSql) > 0){
				List list = countDailyPlan(projectInfoNo);
				msg.setValue("allList", list.get(0));
				msg.setValue("measuredailylist", list.get(1));
				msg.setValue("drilldailylist", list.get(2));
				msg.setValue("colldailylist", list.get(3));
			}
		}else{
			List list = countDailyPlan(projectInfoNo);
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		msg.setValue("hasSaved", "0");
		return msg;
	}
	//////////////////////////////////////////////////////////////////////////////////
	/**
	 * 井中 重新读取计划日效
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg refreshDailyPlanWs(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String checkSql = "select p.pro_plan_id from gp_proj_product_plan p where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'";
		if(radDao.queryRecords(checkSql) != null && radDao.queryRecords(checkSql).size() > 0){
			String delDailyPlanSql = "update gp_proj_product_plan p set p.bsflag = '1' where p.project_info_no = '"+projectInfoNo+"'";
			if(radDao.executeUpdate(delDailyPlanSql) > 0){
				List list = countDailyPlanWs(projectInfoNo);
				msg.setValue("allList", list.get(0));
				msg.setValue("measuredailylist", list.get(1));
				msg.setValue("drilldailylist", list.get(2));
				msg.setValue("colldailylist", list.get(3));
			}
		}else{
			List list = countDailyPlanWs(projectInfoNo);
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		msg.setValue("hasSaved", "0");
		return msg;
	}
	
	private List countDailyPlanWs(String projectInfoNo){
		//根据projectInfoNo 从bgp_p6_workload表中取工作量
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		
		List AllList = new ArrayList();
		List measuredailylist = new ArrayList();
		List drilldailylist = new ArrayList();
		List colldailylist = new ArrayList();
		
		
		//String[] measureType = {"G9001"};//测量
		String[] drillType = {"G10001"};//钻井 炮点数
		String[] collType = {"G1301"};//采集  炮点数
		 
		
		String sqlTemp = null;
		String sql = null;
		//总的

		sqlTemp = " and resource_id in ('G10001','G1301')";
		
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		String max_finish_date = null;
		String min_start_date = null;
		
		Date start_date = null;
		Date end_date = null;
		
		int day = 0;
		
		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		Date temp = start_date;
		String dateTemp = null;
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			temp.setTime(temp.getTime()+86400000L);
			AllList.add(map);
		}
		
		

		/////////////////////////////////////////////////////////////钻井
		sqlTemp = " and resource_id in ('G10001')";
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		max_finish_date = null;
		min_start_date = null;
		
		start_date = null;
		end_date = null;
		
		day = 0;//钻井开始到结束之间的总天数
		
		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		
		//---------------------------
		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else floor(w.planned_units * 8 / a.planned_duration) end) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		
		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		int total_workload_num = 0;// 钻井炮点总数

		for (int j = 0; j < list.size(); j++) {
			Map tempMap = (Map) list.get(j);
			total_workload_num += Double.parseDouble((String) tempMap
					.get("planned_units"));
		}

		int total_workload_num_bak = total_workload_num;// 钻井炮点总数

		// ------------------求剩余工作量
		for (int i = 0; i < day; i++) {
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			int workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Integer.parseInt((String) tempMap
							.get("average_units"));
				}

			}

			// 计算剩余
			total_workload_num_bak = total_workload_num_bak - workload_num;

		}

		// ------------------平均分配工作量 把剩余工作量分到这一天
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation
					.formatDate(temp, "yyyy-MM-dd"));

			int workload_num = 0;
			boolean isday = false;// 是否包含当天
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Integer.parseInt((String) tempMap
							.get("average_units"));
					if (isday == false) {
						isday = true;
					}
				}

			}

			if (isday) {
				if (total_workload_num_bak > 0) {
					workload_num++;
					total_workload_num_bak--;
				}
			}

			map.put("workload", df_1.format(workload_num));
			drilldailylist.add(map);
		}
		
		////////////////////////////////////////////////////////////////////////采集
		
		sqlTemp = " and resource_id in ('G1301')";
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		max_finish_date = null;
		min_start_date = null;
		
		start_date = null;
		end_date = null;
		
		day = 0;
		
		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");
			
			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation.getDateSkip(min_start_date, max_finish_date);
			}
		}
		
//		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration, 3) end) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
//				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
//				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
//		
//		sql += sqlTemp;
//		
//		page = radDao.queryRecordsBySQL(sql.toString(), page);
//		list = page.getData();
//		
//		temp = new Date();
//		dateTemp = null;
//		
//		for (int i = 0; i < day; i++) {
//			Map map = new HashMap();
//			temp.setTime(start_date.getTime()+86400000L*i);
//			dateTemp = DateOperation.formatDate(temp);
//			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
//			
//			double workload_num = 0;
//			for (int j = 0; j < list.size(); j++) {
//				Map tempMap = (Map) list.get(j);
//				String s = (String) tempMap.get("start_date");
//				String e = (String) tempMap.get("finish_date");
//				
//				if (DateOperation.dateBetween(s, e, dateTemp)) {
//					workload_num += Double.parseDouble((String)tempMap.get("average_units"));
//				}
//			}
//			map.put("workload", df_1.format(workload_num));
//			colldailylist.add(map);
//		}
		
		//---------------------------
		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration) end) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		total_workload_num = 0;// 钻井炮点总数

		for (int j = 0; j < list.size(); j++) {
			Map tempMap = (Map) list.get(j);
			total_workload_num += Double.parseDouble((String) tempMap
					.get("planned_units"));
		}

		total_workload_num_bak = total_workload_num;// 钻井炮点总数

		// ------------------求剩余工作量
		for (int i = 0; i < day; i++) {
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			int workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Integer.parseInt((String) tempMap
							.get("average_units"));
				}

			}

			// 计算剩余
			total_workload_num_bak = total_workload_num_bak - workload_num;

		}

		// ------------------平均分配工作量 把剩余工作量分到这一天
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation
					.formatDate(temp, "yyyy-MM-dd"));

			int workload_num = 0;
			boolean isday = false;// 是否包含当天
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Integer.parseInt((String) tempMap
							.get("average_units"));
					if (isday == false) {
						isday = true;
					}
				}

			}

			if (isday) {
				if (total_workload_num_bak > 0) {
					workload_num++;
					total_workload_num_bak--;
				}
			}

			map.put("workload", df_1.format(workload_num));
			colldailylist.add(map);
		}
		
		//-----------------------------------------
		
		List list2 = new ArrayList();
		list2.add(AllList);
		list2.add(measuredailylist);
		list2.add(drilldailylist);
		list2.add(colldailylist);
		return list2;
	}
	
	/**
	 * 查询井中工作量分配
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg queryDailyPlanWs(ISrvMsg reqDTO) throws Exception{
		
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		//String[] planType = {"measuredailylist","drilldailylist","colldailylist"};
		
		String[] planType = {"drilldailylist","colldailylist"};
		
		StringBuffer sql = new StringBuffer();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		sql.append("select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"'  and oper_plan_type in(");
		
		for (int i = 0; i < planType.length; i++) {
			sql.append("'"+planType[i]+"',");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(") and bsflag ='0' order by to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') ");
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		List list = page.getData();
		if(list != null && list.size() != 0){
			
			//gp_proj_product_plan 计划日效 存在project_info_no项目的oper_plan_type in  {"measuredailylist","drilldailylist","colldailylist"}的记录
			
			msg.setValue("hasSaved", "1");
			msg.setValue("allList", list);
			
			for (int i = 0; i < planType.length; i++) {
				sql = new StringBuffer();
				sql.append("select pro_plan_id,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,workload_num,workload from gp_proj_product_plan where bsflag = '0' and project_info_no = '"+projectInfoNo+"'  and oper_plan_type = '"+planType[i]+"'  order by to_char(to_date(" +
						"record_month,'yyyy-MM-dd'),'yyyy-MM-dd')");
				page = radDao.queryRecordsBySQL(sql.toString(), page);
				msg.setValue(planType[i], page.getData());
			}
		}else if(list == null || list.size() == 0) {
			//gp_proj_product_plan 无计划日效记录
			
			msg.setValue("hasSaved", "0");
			list = countDailyPlanWs(projectInfoNo);//根据projectInfoNo 从bgp_p6_workload表中取工作量
			
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		
		return msg;
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * 综合物化探重新读取计划日效
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg refreshDailyPlanWt(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		//删除所有以添加的计划
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
		jdbcTemplate.execute("delete from gp_proj_product_plan_wt t where t.project_info_no='"+projectInfoNo+"'");
		
		msg.setValue("hasSaved", "0");
		return msg;
	}
}
