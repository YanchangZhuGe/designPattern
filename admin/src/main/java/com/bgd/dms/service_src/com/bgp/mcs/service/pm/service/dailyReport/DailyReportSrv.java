package com.bgp.mcs.service.pm.service.dailyReport;

import java.io.ByteArrayInputStream;
import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.soap.SOAPException;

import org.apache.commons.collections.MapUtils;
import org.jsoup.helper.StringUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.workload.WorkloadMCSBean;
import com.bgp.mcs.service.pm.service.project.DBDataService;
import com.bgp.mcs.service.pm.service.project.DailyReportProcessRatePOJO;
import com.bgp.mcs.service.pm.service.project.ProjectMCSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class DailyReportSrv extends BaseService {
	
	private ILog log;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	
	public DailyReportSrv() {
		log = LogFactory.getLogger(DailyReportSrv.class);
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
				" join gp_task_project gp on gp.project_info_no = r.project_info_no and gp.project_name like '"+project_name+"' and gp.bsflag = '0' and gp.project_status like '%"+project_status+"%' and project_type in('"+project_type+"') "+
				" join comm_org_information oi on oi.org_id = r.org_id and oi.org_name like '"+org_name+"' and oi.bsflag = '0' "+
				" where r.bsflag = '0' and r.org_subjection_id like '%"+org_subjection_id+"%' " +
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
	public String getStatus(String activity_object_id) throws Exception{
		String build_status = "";
		String get_build_method = "select distinct     case status  when 'Not Started' then     '未开始'   when 'In Progress' then   '正在施工'"+
               "  when 'Completed' then   '完成'    else     ''  end as status_name from bgp_p6_activity pa left join bgp_p6_calendar" +
               " pc on pc.object_id = pa.calendar_object_id  where 1 = 1  and pa.bsflag = '0'  and pa.object_id = '"+activity_object_id+"'";
 
 
		if(jdbcDao.queryRecordBySQL(get_build_method)!=null){
			build_status = jdbcDao.queryRecordBySQL(get_build_method).get("statusName").toString();
		}
		return build_status;
		 
	
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
	
	public List getCollect(Map map) throws SOAPException{
		
		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");
		 
			List collectList =new ArrayList();
		 
			 String sql="select t.*  from bgp_pm_daily_information t  where t.bsflag = '0'  and t.project_info_no = '"+projectInfoNo+"'and t.produce_date = to_date('"+produceDate+"', 'yyyy-MM-dd')";
			 
			 collectList =   radDao.getJdbcTemplate().queryForList(sql);
	  
			return collectList;
	}
public ISrvMsg getDgTime(ISrvMsg reqDTO) throws SOAPException{
		
	String daily_no = reqDTO.getValue("dailyNo");
	 
		Map dailyMap = new HashMap();
	 
		 String sql="select *   from  bgp_ops_ss_daily_efficiency_1 e  where e.daily_no = '"+daily_no+"' ";
		 
		dailyMap = jdbcDao.queryRecordBySQL(sql);
     ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("dailyMap", dailyMap);
		
		return msg;
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
			//
			String sql_ = " select exploration_method from gp_task_project where PROJECT_INFO_NO='"+projectInfoNo+"'";
			
			List<Map<String,Object>> list_ = radDao.getJdbcTemplate().queryForList(sql_);
			if(list_!=null&&list_.size()!=0){
				String exploration_method = list_.get(0).get("exploration_method").toString();
				if(exploration_method.equals("0300100012000000002")){//2维
					String WORK_LOAD2 = dailyReport.get("WORK_LOAD2").toString();
					if(WORK_LOAD2!=null&&WORK_LOAD2.length()!=0){
						if(WORK_LOAD2.equals("1")){
							designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_OBJECT_WORKLOAD"));
						}
						if(WORK_LOAD2.equals("2")){
							designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_DATA_WORKLOAD"));
						}
						if(WORK_LOAD2.equals("3")){
							designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_DATA_WORKLOAD"));
						}
						dailyReport.put("DESIGN_OBJECT_WORKLOAD", designNum);
					}else{
						dailyReport.put("DESIGN_OBJECT_WORKLOAD", "0");
					}
				}
				if(exploration_method.equals("0300100012000000003")){//3维
					String WORK_LOAD3 = dailyReport.get("WORK_LOAD3").toString();
					if(WORK_LOAD3!=null&&WORK_LOAD3.length()!=0){
						if(WORK_LOAD3.equals("1")){
							designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_EXECUTION_AREA"));
						}
						if(WORK_LOAD3.equals("2")){
							designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_DATA_AREA"));
						}
						if(WORK_LOAD3.equals("3")){
							designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_OBJECT_AREA"));
						}
						dailyReport.put("DESIGN_OBJECT_WORKLOAD", designNum);
					}else{
						dailyReport.put("DESIGN_OBJECT_WORKLOAD", "0");
					}
				}
			}
			
			
			
			if (dailyReport.get("PROJECT_ACQUIRE_WORKLOAD") == null || "".equals(dailyReport.get("PROJECT_ACQUIRE_WORKLOAD"))) {
				dailyReport.put("PROJECT_ACQUIRE_WORKLOAD", "0");
			}
			//designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_OBJECT_WORKLOAD"));
			
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
	
	public ISrvMsg getDailyReportDate(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String produceDate = (String) reqDTO.getValue("produceDate");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String exploration_method = user.getExplorationMethod();
		StringBuffer sb = new StringBuffer();
		sb.append(" select * from gp_ops_daily_report t left join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no and s.bsflag ='0'")
		.append(" left join bgp_ops_ss_daily_efficiency_1 e on t.daily_no = e.daily_no")
		.append(" where t.bsflag ='0' and t.produce_date = to_date('"+produceDate+"','yyyy-MM-dd') and t.project_info_no ='"+projectInfoNo+"' ");//and t.exploration_method ='"+exploration_method+"'
		
		Map dailyMap = new HashMap();
		dailyMap = jdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("dailyMap", dailyMap);
		return msg;
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
		
		//日报状态是未提交0或审批未通过4,则状态显示前一天的
		if(dailyReport.size() > 0){
			dailyReport.put("noRecord", "0");
			String if_build = dailyReport.get("IF_BUILD").toString();
		 
			String collect_process_status = (String) dailyReport.get("COLLECT_PROCESS_STATUS");
			String audit_status = (String) dailyReport.get("audit_status");
			
			 
			
			map.put("dailyNo", dailyReport.get("DAILY_NO"));
			map.put("lineGroupId", "");
			map.put("line_group_id", "");
			
	 
			
			map.put("tableName", "gp_ops_daily_acquire");
			List acquireList = findGpOpsDaily(map);
			
			msg.setValue("dailyMap", dailyReport);
		 
			msg.setValue("acquireList", acquireList);
		}else if(dailyReport.size() == 0){
			dailyReport.put("noRecord", "1");
			msg.setValue("dailyMap", dailyReport);
		}
		return msg;
	}
public ISrvMsg getDgDailyReportInfo(ISrvMsg reqDTO) throws Exception{
		
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
 		//日报状态是未提交0或审批未通过4,则状态显示前一天的
		if(dailyReport.size() > 0){
			dailyReport.put("noRecord", "0");
			String if_build = dailyReport.get("if_build").toString();
			String survey_process_status = (String) dailyReport.get("SURVEY_PROCESS_STATUS");
			String surface_process_status = (String) dailyReport.get("SURFACE_PROCESS_STATUS");
			String drill_process_status = (String) dailyReport.get("DRILL_PROCESS_STATUS");
			String collect_process_status = (String) dailyReport.get("COLLECT_PROCESS_STATUS");
			String audit_status = (String) dailyReport.get("audit_status");
			
			if (surface_process_status == "0" || "0".equals(surface_process_status)) {
				if("0".equals(audit_status) || "4".equals(audit_status)){
					map.put("difference", 1);
				}else if("1".equals(audit_status) || "3".equals(audit_status)){
					map.put("difference", 0);
				}
				Map map1 = getDailyReportProduceSit(map);
				if (map1 != null) {
					dailyReport.put("SURVEY_PROCESS_STATUS", map1.get("surveyProcessStatus") != "" ? map1.get("surveyProcessStatus"):"1");
					dailyReport.put("SURFACE_PROCESS_STATUS", map1.get("surfaceProcessStatus") != "" ? map1.get("surfaceProcessStatus"):"1");
					dailyReport.put("DRILL_PROCESS_STATUS", map1.get("drillProcessStatus") != "" ? map1.get("surfaceProcessStatus"):"1");
					if("9".equals(if_build) || "9" == if_build){
						dailyReport.put("COLLECT_PROCESS_STATUS", "3");
					}else{
						dailyReport.put("COLLECT_PROCESS_STATUS", map1.get("collectProcessStatus") != "" ? map1.get("collectProcessStatus"):"1");
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
						dailyReport.put("SURVEY_PROCESS_STATUS", map3.get("surveyProcessStatus") != "" ? map3.get("surveyProcessStatus"):"1");
						dailyReport.put("SURFACE_PROCESS_STATUS", map3.get("surfaceProcessStatus") != "" ? map3.get("surfaceProcessStatus"):"1");
						dailyReport.put("DRILL_PROCESS_STATUS", map3.get("drillProcessStatus") != "" ? map3.get("drillProcessStatus"):"1");
						if("9".equals(if_build) || "9" == if_build){
							dailyReport.put("COLLECT_PROCESS_STATUS", "3");
						}else{
							dailyReport.put("COLLECT_PROCESS_STATUS", map3.get("collectProcessStatus") != "" ? map3.get("collectProcessStatus"):"1");
						}
					}
				}
			}
			
			map.put("dailyNo", dailyReport.get("DAILY_NO"));
			map.put("lineGroupId", "");
			map.put("line_group_id", "");
			
			List collectList = getCollect(map);
			
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
			msg.setValue("collectList", collectList);
			msg.setValue("acquireList", acquireList);
		}else if(dailyReport.size() == 0){
			dailyReport.put("noRecord", "1");
			msg.setValue("dailyMap", dailyReport);
		}
		return msg;
	}
	
	///////////////////////////////////////////////////////////////////
	/*
	 * 
	 * 深海 列表
	 */
	public ISrvMsg queryDailyReportListSh(ISrvMsg reqDTO) throws Exception{
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
			String projectInfoNo = reqDTO.getValue("projectInfoNo");
			if(projectInfoNo==null||projectInfoNo.equals("")){
				projectInfoNo = user.getProjectInfoNo();
				if (projectInfoNo == null || "".equals(projectInfoNo)) {
					msg.setValue("totalRows", 0);
					return msg;
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
			
			 //不带审核的生产日报 
			String sql =  "select  nvl(t.DAILY_QQ_ACQUIRE_WORKLOAD, 0)  as sp, ( sum(nvl(t.DAILY_QQ_ACQUIRE_WORKLOAD, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.DAILY_QQ_ACQUIRE_WORKLOAD, 0)) from gp_ops_daily_report r  where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date), 0) ) as total_sp, (round(case nvl(dy.design_sp_num, 0) when 0 then 0 else (sum(nvl(t.DAILY_QQ_ACQUIRE_WORKLOAD, 0) )over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.DAILY_QQ_ACQUIRE_WORKLOAD, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end,2) ) total_sp_radio, t.produce_date,gp.project_name,gp.build_method,oi.org_abbreviation as org_name,t.audit_status, t.daily_no, t.project_info_no,dy.design_sp_num from gp_ops_daily_report t join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0' and t.exploration_method = gp.exploration_method join comm_org_information oi on oi.org_id = t.org_id and oi.bsflag = '0' join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_no and dy.exploration_method = t.exploration_method where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"' order by produce_date desc ";
			
			page = radDao.queryRecordsBySQL(sql, page);
			msg.setValue("datas", page.getData());
			msg.setValue("totalRows", page.getTotalRow());
			msg.setValue("pageSize", pageSize);
		}
		return msg;
	}
	/*
	 * 深海生产日报保存
	 */
	public ISrvMsg saveOrUpdateDailyReportSh(ISrvMsg reqDTO) throws Exception{

		
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
		msg.setValue("taskBackUrl", "/pm/dailyReport/queryResourceAssignmentSh.srq");
		return msg;
	
	}
	/*
	 * 深海 生产日报 查看
	 * @param reqDTO
	 * @return
	 * @throws SOAPException
	 */
	public ISrvMsg getDailyReportInfoSh(ISrvMsg reqDTO) throws Exception{
		
		String dailyNo = (String) reqDTO.getValue("dailyNo");
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String produceDate = (String) reqDTO.getValue("produceDate");
		Map temp = reqDTO.toMap();
		
		Map map = new HashMap();
		map.put("produceDate", produceDate);
		map.put("dailyNo", dailyNo);
		map.put("projectInfoNo", projectInfoNo);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		Map dailyReport = getDailyReportSh(map);
		
		//日报状态是未提交0或审批未通过4,则状态显示前一天的
		if(dailyReport.size() > 0){
			dailyReport.put("noRecord", "0");
			String if_build = dailyReport.get("IF_BUILD").toString();
		 
			String collect_process_status = (String) dailyReport.get("COLLECT_PROCESS_STATUS");
			String audit_status = (String) dailyReport.get("audit_status");
			
			 
			
			map.put("dailyNo", dailyReport.get("DAILY_NO"));
			map.put("lineGroupId", "");
			map.put("line_group_id", "");
			
	 
			
			map.put("tableName", "gp_ops_daily_acquire");
			List acquireList = findGpOpsDaily(map);
			
			msg.setValue("dailyMap", dailyReport);
		 
			msg.setValue("acquireList", acquireList);
		}else if(dailyReport.size() == 0){
			dailyReport.put("noRecord", "1");
			msg.setValue("dailyMap", dailyReport);
		}
		return msg;
	}
	
public Map getDailyReportSh(Map map){
		
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
//			sql = "select * from gp_ops_daily_report r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' " +
//					" join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) " +
//					" where r.project_info_no = '"+projectInfoNo+"'  and r.bsflag = '0' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') ";
			
			sql+="select * from(";
			
			sql += "select sum(nvl(sit.breakdown_time,0)) as breakdown_time_total,sum(nvl(sit.work_time, 0)) as work_time_total,sum(nvl(sit.collect_time, 0)) as collect_time_total,sum(nvl(sit.day_check_time, 0)) as day_check_time_total from gp_ops_daily_report r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' " +
			" join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) " +
			" where r.project_info_no = '"+projectInfoNo+"'  and r.bsflag = '0' and produce_date <= to_date('"+produceDate+"','yyyy-MM-dd') ";//修改累计时间 by bianshen@2013年12月19日16:13:11
			
			sql+="),(";
			
			sql += "select * from gp_ops_daily_report r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' " +
			" join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) " +
			" where r.project_info_no = '"+projectInfoNo+"'  and r.bsflag = '0' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') ";
			
			sql+=")";
			
			
			
			
			
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
			
//				document.getElementById("DAILY_QQ_ACQUIRE_WORKLOAD").innerHTML = DAILY_QQ_ACQUIRE_WORKLOAD;//日完成气枪km
//				document.getElementById("PROJECT_ACQUIRE_WORKLOAD").innerHTML = PROJECT_ACQUIRE_WORKLOAD;//累计完成km
//				document.getElementById("PROJECT_ACQUIRE_WORK_RATIO").innerHTML = PROJECT_ACQUIRE_WORK_RATIO;//完成工作量%
				
			//存在审核状态
//			sql = "select sum(nvl(r.daily_qq_acquire_workload,0)) as project_acquire_workload"+// 累计完成km
//					" from gp_ops_daily_report r where r.audit_status = '3' and r.project_info_no = '"+projectInfoNo+"' and r.bsflag = '0'";
				
				//不存在审核状态
				sql = "select sum(nvl(r.daily_qq_acquire_workload,0)) as project_acquire_workload"+// 累计完成km
				" from gp_ops_daily_report r where  r.project_info_no = '"+projectInfoNo+"' and r.bsflag = '0'";
			
			if (produceDate != null && !"".equals(produceDate) && produceDate != "null" && !"null".equals(produceDate)) {
				sql += " and produce_date <= to_date('"+produceDate+"','yyyy-MM-dd') ";
			}
			
			dailyReport.put("PRODUCE_DATE", produceDate);
			//System.out.println("aaaaaaaaaaaaaaaaaaaaaa"+dailyReport.get("DESIGN_OBJECT_WORKLOAD"));
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
			
			
			//各种比率
			double designNum = 0.0;
			double actualNum = 0.0;
			
		
			
			
			
			
			/////////////////////////////////////////////////////
			

			
			///////////////////////////////////////////////////
			//采集 工作量
			//最外层sql 查询出气枪
			if (dailyReport.get("DAILY_QQ_ACQUIRE_WORKLOAD") == null || "".equals(dailyReport.get("DAILY_QQ_ACQUIRE_WORKLOAD"))) {
				dailyReport.put("DAILY_QQ_ACQUIRE_WORKLOAD", "0");
			}
			if (dailyReport.get("PROJECT_ACQUIRE_WORKLOAD") == null || "".equals(dailyReport.get("PROJECT_ACQUIRE_WORKLOAD"))) {////////////////////////累计
				dailyReport.put("PROJECT_ACQUIRE_WORKLOAD", "0");
			}
			designNum = P6TypeConvert.convertDouble(dailyReport.get("DESIGN_SP_NUM"));//DESIGN_OBJECT_WORKLOAD
			
			if (designNum == 0.0) {
				dailyReport.put("PROJECT_ACQUIRE_WORK_RATIO", "-");///////////////////////////// 百分比
			} else {
				actualNum = P6TypeConvert.convertDouble(dailyReport.get("PROJECT_ACQUIRE_WORKLOAD"));
				dailyReport.put("PROJECT_ACQUIRE_WORK_RATIO", df.format((actualNum/designNum)));
			}
			

			}
		}

		return dailyReport;
	}

//////////////////////////////////////////////////////////////////////
	
	
	/*
	 * 滩浅海生产日报查看--lx
	 * 
	 * 为避免和陆地项目生产日报查看有冲突，新建方法
	 */
public ISrvMsg getDailyReportInfoSea(ISrvMsg reqDTO) throws Exception{
		
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
		
		String sql = "select  t.* from gp_ops_daily_report r left join bgp_ops_ss_daily_efficiency_1 t on r.daily_no = t.daily_no where r.daily_no='"+dailyNo+"'";
		
		Map effMap = radDao.getJdbcTemplate().queryForMap(sql);
		dailyReport.putAll(effMap);
		if (dailyReport.get("DAY_CHECK") == null || "".equals(dailyReport.get("DAY_CHECK"))) {
			dailyReport.put("DAY_CHECK", "");
		}
		if (dailyReport.get("PATH") == null || "".equals(dailyReport.get("PATH"))) {
			dailyReport.put("PATH", "");
		}
		if (dailyReport.get("TIDE_DELAY") == null || "".equals(dailyReport.get("TIDE_DELAY"))) {
			dailyReport.put("TIDE_DELAY", "");
		}
		if (dailyReport.get("ACTUAL_SHOT") == null || "".equals(dailyReport.get("ACTUAL_SHOT"))) {
			dailyReport.put("ACTUAL_SHOT", "");
		}
		if (dailyReport.get("ARRAY_TROUBLE") == null || "".equals(dailyReport.get("ARRAY_TROUBLE"))) {
			dailyReport.put("ARRAY_TROUBLE", "");
		}
		if (dailyReport.get("RELATION_DELAY") == null || "".equals(dailyReport.get("RELATION_DELAY"))) {
			dailyReport.put("RELATION_DELAY", "");
		}
		if (dailyReport.get("WEATHER_DELAY") == null || "".equals(dailyReport.get("WEATHER_DELAY"))) {
			dailyReport.put("WEATHER_DELAY", "");
		}
		if (dailyReport.get("MACHINE_DELAY") == null || "".equals(dailyReport.get("MACHINE_DELAY"))) {
			dailyReport.put("MACHINE_DELAY", "");
		}
		if (dailyReport.get("MEASURE_DELAY") == null || "".equals(dailyReport.get("MEASURE_DELAY"))) {
			dailyReport.put("MEASURE_DELAY", "");
		}
		if (dailyReport.get("CLEARUP_DELAY") == null || "".equals(dailyReport.get("CLEARUP_DELAY"))) {
			dailyReport.put("CLEARUP_DELAY", "");
		}
		if (dailyReport.get("FOCUS_DELAY") == null || "".equals(dailyReport.get("FOCUS_DELAY"))) {
			dailyReport.put("FOCUS_DELAY", "");
		}
		if (dailyReport.get("TRANSIT_DELAY") == null || "".equals(dailyReport.get("TRANSIT_DELAY"))) {
			dailyReport.put("TRANSIT_DELAY", "");
		}
		if (dailyReport.get("LINE_LAY") == null || "".equals(dailyReport.get("LINE_LAY"))) {
			dailyReport.put("LINE_LAY", "");
		}
		if (dailyReport.get("ARRAY_CHECK") == null || "".equals(dailyReport.get("ARRAY_CHECK"))) {
			dailyReport.put("ARRAY_CHECK", "");
		}
		if (dailyReport.get("HSE_DELAY") == null || "".equals(dailyReport.get("HSE_DELAY"))) {
			dailyReport.put("HSE_DELAY", "");
		}
		if (dailyReport.get("FIRST_SHOT_TIME") == null || "".equals(dailyReport.get("FIRST_SHOT_TIME"))) {
			dailyReport.put("FIRST_SHOT_TIME", "");
		}
		if (dailyReport.get("LAST_SHOT_TIME") == null || "".equals(dailyReport.get("LAST_SHOT_TIME"))) {
			dailyReport.put("LAST_SHOT_TIME", "");
		}
		if (dailyReport.get("AIR_GUN_USE_TIME") == null || "".equals(dailyReport.get("AIR_GUN_USE_TIME"))) {
			dailyReport.put("AIR_GUN_USE_TIME", "");
		}
		if (dailyReport.get("EFFICIENCY_ADJUST") == null || "".equals(dailyReport.get("EFFICIENCY_ADJUST"))) {
			dailyReport.put("EFFICIENCY_ADJUST", "");
		}
		if (dailyReport.get("PLANE_FLY_TIME") == null || "".equals(dailyReport.get("PLANE_FLY_TIME"))) {
			dailyReport.put("PLANE_FLY_TIME", "");
		}
		if (dailyReport.get("PLANE_TYPE") == null || "".equals(dailyReport.get("PLANE_TYPE"))) {
			dailyReport.put("PLANE_TYPE", "");
		}
		
		//日报状态是未提交0或审批未通过4,则状态显示前一天的
		if(dailyReport.size() > 0){
			dailyReport.put("noRecord", "0");
			String if_build = dailyReport.get("if_build").toString();
			String survey_process_status = (String) dailyReport.get("SURVEY_PROCESS_STATUS");
			String surface_process_status = (String) dailyReport.get("SURFACE_PROCESS_STATUS");
			String drill_process_status = (String) dailyReport.get("DRILL_PROCESS_STATUS");
			String collect_process_status = (String) dailyReport.get("COLLECT_PROCESS_STATUS");
			String audit_status = (String) dailyReport.get("audit_status");
			
			if (surface_process_status == "0" || "0".equals(surface_process_status)) {
				if("0".equals(audit_status) || "4".equals(audit_status)){
					map.put("difference", 1);
				}else if("1".equals(audit_status) || "3".equals(audit_status)){
					map.put("difference", 0);
				}
				Map map1 = getDailyReportProduceSit(map);
				if (map1 != null) {
					dailyReport.put("SURVEY_PROCESS_STATUS", map1.get("surveyProcessStatus") != "" ? map1.get("surveyProcessStatus"):"1");
					dailyReport.put("SURFACE_PROCESS_STATUS", map1.get("surfaceProcessStatus") != "" ? map1.get("surfaceProcessStatus"):"1");
					dailyReport.put("DRILL_PROCESS_STATUS", map1.get("drillProcessStatus") != "" ? map1.get("surfaceProcessStatus"):"1");
					if("9".equals(if_build) || "9" == if_build){
						dailyReport.put("COLLECT_PROCESS_STATUS", "3");
					}else{
						dailyReport.put("COLLECT_PROCESS_STATUS", map1.get("collectProcessStatus") != "" ? map1.get("collectProcessStatus"):"1");
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
						dailyReport.put("SURVEY_PROCESS_STATUS", map3.get("surveyProcessStatus") != "" ? map3.get("surveyProcessStatus"):"1");
						dailyReport.put("SURFACE_PROCESS_STATUS", map3.get("surfaceProcessStatus") != "" ? map3.get("surfaceProcessStatus"):"1");
						dailyReport.put("DRILL_PROCESS_STATUS", map3.get("drillProcessStatus") != "" ? map3.get("drillProcessStatus"):"1");
						if("9".equals(if_build) || "9" == if_build){
							dailyReport.put("COLLECT_PROCESS_STATUS", "3");
						}else{
							dailyReport.put("COLLECT_PROCESS_STATUS", map3.get("collectProcessStatus") != "" ? map3.get("collectProcessStatus"):"1");
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
//	
	
	
	
	
	
	
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
			
			  
//			String sql =  "select nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0) as sp, "+
//			 		"(case t.audit_status when '3' then  sum(nvl(t.daily_acquire_sp_num, 0) +  nvl(t.daily_qq_acquire_shot_num, 0) +  nvl(t.daily_jp_acquire_shot_num, 0))  over(partition by t.project_info_no order by t.produce_date asc) - "+
//					"nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "+
//					"and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else  sum(nvl(t.daily_acquire_sp_num, 0) +  nvl(t.daily_qq_acquire_shot_num, 0) +  nvl(t.daily_jp_acquire_shot_num, 0)) "+
//					"over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "+
//					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_sp, (case t.audit_status "+
//					"when '3' then round(case nvl(dy.design_sp_num, 0) when 0 then 0 else (sum(nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0)) "+
//					"over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "+
//					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) else round(case nvl(dy.design_sp_num, 0) when 0 then "+
//					"0 else (sum(nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0)) over(partition by t.project_info_no order by  t.produce_date asc) - nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + "+
//					"nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "+
//					"and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) end) total_sp_radio, nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0) as survey, (case t.audit_status when '3' then sum(nvl(t.survey_incept_workload, 0) + "+
//					"nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r "+
//					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
//					"nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
//					"end) as total_survey, (case t.audit_status when '3' then round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
//					"nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 "+
//					"end, 2) else round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + "+
//					"nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 end, 2) end) as total_survey_radio, "+
//					"nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0) as measue, (case t.audit_status when '3' then sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "+
//					"nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
//					"else sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) "+
//					"from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_measue, (case t.audit_status when '3' then round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "+
//					"when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r "+
//					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) else round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "+
//					"when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r "+
//					"where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) end) as total_measue_radio, nvl(t.daily_drill_sp_num, 0) as drill, "+
//					"(case t.audit_status when '3' then sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "+
//					"else sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_drill, "+
//					"(case t.audit_status when '3' then round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "+
//					"and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) else round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "+ 
//					"and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) end) as total_drill_radio, "+
//			        "t.produce_date, gp.project_name, gp.build_method, oi.org_abbreviation as org_name, t.audit_status, t.daily_no, t.project_info_no "+
//					"from gp_ops_daily_report t join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0'  and t.exploration_method = gp.exploration_method " +
//					" join comm_org_information oi on oi.org_id = t.org_id and oi.bsflag = '0' " +
//					" join gp_task_project_dynamic dy "+
//				    " on dy.project_info_no = t.project_info_no "+
//				    " and dy.exploration_method = t.exploration_method"+
//					" where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"' order by produce_date desc";
			
			
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

	public ISrvMsg queryDailyReportListsh2(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		return msg;
	}
	
/*
 * 滩浅海生产日报列表----lx
 * 	
 */
public ISrvMsg queryDailyReportListSea(ISrvMsg reqDTO) throws Exception{
		
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
			
			  
			String sql =  "";
			
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
			
			  
			String sql =  "select nvl(t.daily_acquire_sp_num, 0) daily_acquire_sp_num,nvl(t.daily_qq_acquire_shot_num, 0) daily_qq_acquire_shot_num,"
						+" nvl(t.daily_jp_acquire_shot_num, 0) daily_jp_acquire_shot_num,"
						+" nvl(t.daily_acquire_workload,0)+nvl(t.daily_qq_acquire_workload,0)+nvl(t.daily_jp_acquire_workload,0) workload,"
						+" t.produce_date,gp.project_name,gp.build_method,oi.org_abbreviation as org_name,t.audit_status,t.daily_no,t.project_info_no"
						+" from gp_ops_daily_report t join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0'"
						+" and t.exploration_method = gp.exploration_method join comm_org_information oi  on oi.org_id = t.org_id  and oi.bsflag = '0' join gp_task_project_dynamic dy"
						+" on dy.project_info_no = t.project_info_no and dy.exploration_method = t.exploration_method"
						+" where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"' order by produce_date desc";
			
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
	

	/**
	 * 生产日报提交
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
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
		
		String sql = "select * from gp_task_project where project_info_no = '"+projectInfoNo+"' ";
		
		Map project = jdbcDao.queryRecordBySQL(sql);
		String tableName="gp_ops_daily_report" ;
		if(MapUtils.isNotEmpty(project)){
			Object project_type_obj = project.get("projectType") ;
			if(project_type_obj!=null && project_type_obj!=""){
				String project_type = project_type_obj.toString();
				if(project_type.equals("5000100004000000001")){ //陆地项目
					tableName="gp_ops_daily_report" ;
				}else if(project_type.equals("5000100004000000007")){ // 陆地和浅海项目
					tableName="gp_ops_daily_report" ;
				}else if(project_type.equals("5000100004000000008")){ //井中地震
					tableName="gp_ops_daily_report_ws" ;
				}else if(project_type.equals("5000100004000000009")){//综合物化探
					tableName="gp_ops_daily_report_wt" ;
				}else if(project_type.equals("5000100004000000002") || project_type.equals("5000100004000000010")){//滩浅海地震
					tableName="gp_ops_daily_report" ;
				}
			}
		}
		UserToken user = reqDTO.getUserToken();
		
		Map map = reqDTO.toMap();
		map.put("updator", user.getUserName());
		map.put("modifi_date", new Date());
		map.put("submit_status", "2");
		map.put("audit_status", "1");
		map.put("daily_no", dailyNo);
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,tableName);
		
		map.put("survey_process_status", reqDTO.getValue("survey_process_status"));
		map.put("surface_process_status", reqDTO.getValue("surface_process_status"));
		map.put("drill_process_status", reqDTO.getValue("drill_process_status"));
		map.put("collect_process_status", reqDTO.getValue("collect_process_status"));
		
		String update = "update gp_ops_daily_produce_sit set survey_process_status = '"+reqDTO.getValue("survey_process_status")+"',surface_process_status = '"+reqDTO.getValue("surface_process_status")+"',drill_process_status = '"+reqDTO.getValue("drill_process_status")+"',collect_process_status = '"+reqDTO.getValue("collect_process_status")+"' where daily_no = '"+dailyNo+"' ";
		radDao.getJdbcTemplate().update(update);
		
		update = "update bgp_p6_assign_mapping set submit_flag = '1',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"+projectInfoNo+"') and bsflag = '0'";
		
		radDao.getJdbcTemplate().update(update);
		
		update = "update gp_ops_daily_report set submit_time = sysdate where project_info_no='"+projectInfoNo+"' and produce_date=to_date('yyyy-MM-dd','"+produceDate+"') bsflag = '0'";
		
		radDao.getJdbcTemplate().update(update);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		return msg;
	}
	
	
	/**
	 * 生产日报审批
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg auditDailyReport(ISrvMsg reqDTO) throws Exception{   
		String dailyNo = reqDTO.getValue("dailyNo");				//日报编号
		String auditStatus = reqDTO.getValue("audit_status");		//审批状态
		String projectInfoNo = reqDTO.getValue("projectInfoNo");	//项目编号
		String audit_opinion = reqDTO.getValue("audit_opinion");	//审批意见
		//String orgId = reqDTO.getValue("orgId");
		
		
		String sql = "select * from gp_task_project where project_info_no = '"+projectInfoNo+"' ";
		
		Map project = jdbcDao.queryRecordBySQL(sql);
		
		UserToken user = reqDTO.getUserToken();
		String subOrg=user.getOrgSubjectionId();
		Map map = reqDTO.toMap();
		map.put("audit_status", auditStatus);
		map.put("ratifier", user.getEmpId());
		map.put("audit_date", new Date());
		
		//map.put("org_id", orgId);
		
		String tableName="" ;
		String tablePk="";
		if(MapUtils.isNotEmpty(project)){
			Object project_type_obj = project.get("projectType") ;
			if(project_type_obj!=null && project_type_obj!=""){
				String project_type = project_type_obj.toString();
				Map m = this.getDailyReportTableNameAndPkNameByProjectType(project_type);
				if(MapUtils.isNotEmpty(m)){
					tableName=m.get("tableName").toString();
					tablePk=m.get("tablePk").toString();
					map.put(tablePk, dailyNo);
				}
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
			}
		}
		log.info(map+"============="+tableName);
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,tableName);  //审批操作
		
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
			
			
			String  sql_sta = "select "
					+ "SURFACE_PROCESS_STATUS，"
					+ "DRILL_PROCESS_STATUS，"
					+ "COLLECT_PROCESS_STATUS "
					+ "from GP_OPS_DAILY_PRODUCE_SIT where daily_no = '"+dailyNo+"' ";
			
			Map daily_sta = jdbcDao.queryRecordBySQL(sql_sta);
			if(daily_sta!=null&&daily_sta.size()!=0){
				String surface_process_status = daily_sta.get("surfaceProcessStatus").toString();
				String drill_process_status = daily_sta.get("drillProcessStatus").toString();
				String collect_process_status = daily_sta.get("collectProcessStatus").toString();
				if(surface_process_status.equals("2")||drill_process_status.equals("2")||collect_process_status.equals("2")){
					map.put("project_info_no", projectInfoNo);
					map.put("project_status", "5000100001000000002");
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}
				
				if(collect_process_status.equals("3")){
					map.put("project_info_no", projectInfoNo);
					map.put("project_status", "5000100001000000005");
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}
			}
			
			
			
			if(subOrg!=null && subOrg.trim().startsWith("C105007")){
				//大港日报状态关联项目状态
				if (map.get("if_build").equals("4") || "5".equals((String) map.get("if_build"))||map.get("if_build").equals("6")) {
					//日报状态4 5 6 项目状态为正在施工					

					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					map.put("project_status", "5000100001000000002");
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				} else if (map.get("if_build") != null && "9".equals((String) map.get("if_build"))) {
					//结束
					map.put("project_status", "5000100001000000005");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				} else if (map.get("if_build") != null && "8".equals((String) map.get("if_build"))) {
					//暂停
					map.put("project_status", "5000100001000000004");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}
			}else{
				if (map.get("if_build") != null && "4".equals((String) map.get("if_build"))) {
					//测量 改成正在施工
					map.put("project_status", "5000100001000000002");
					map.put("project_info_no", projectInfoNo);
					map.put("modifi_date", new Date());
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				} else if (map.get("if_build") != null && "5".equals((String) map.get("if_build"))) {
					//钻井
					map.put("project_status", "5000100001000000002");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}else if(map.get("if_build") != null && "9".equals((String) map.get("if_build"))){
					//采集
					map.put("project_status", "5000100001000000002");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}else if (map.get("if_build") != null && "9".equals((String) map.get("if_build"))) {
					//结束
					map.put("project_status", "5000100001000000005");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				} else if (map.get("if_build") != null && "8".equals((String) map.get("if_build"))) {
					//暂停
					map.put("project_status", "5000100001000000004");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_task_project");
				}
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
			
			
			AuditDailyReportThread thread = new AuditDailyReportThread(map);
			thread.start();
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
	
//	public ISrvMsg saveOrUpdateQhDailyReport(ISrvMsg reqDTO) throws Exception{
//		
//		UserToken user = reqDTO.getUserToken();
//		
//		String flag = reqDTO.getValue("flag");
//		String edit_flag = reqDTO.getValue("edit_flag");
//		String project_info_no = reqDTO.getValue("project_info_no");
//		String produceDate = reqDTO.getValue("produce_date");
//		String daily_jp_acquire_shot_num=reqDTO.getValue("daily_jp_acquire_shot_num");//日完成井炮
//		
//		String daily_qq_acquire_shot_num = reqDTO.getValue("daily_qq_acquire_shot_num");//日完成气枪
//		String daily_acquire_sp_num = reqDTO.getValue("daily_acquire_sp_num");//日完成震源
//		String DAILY_JP_ACQUIRE_WORKLOAD = reqDTO.getValue("DAILY_JP_ACQUIRE_WORKLOAD");//井炮日完成工作量
//		String DAILY_QQ_ACQUIRE_WORKLOAD = reqDTO.getValue("DAILY_QQ_ACQUIRE_WORKLOAD");//气枪日完成工作量
//		String DAILY_ACQUIRE_WORKLOAD=reqDTO.getValue("DAILY_ACQUIRE_WORKLOAD");//震源日完成工作量
//		String DAILY_TEST_SP_NUM = reqDTO.getValue("DAILY_TEST_SP_NUM");//试验炮
//		String EFFICIENCY_ADJUST = reqDTO.getValue("EFFICIENCY_ADJUST");//调整后资源时效
//		String DAILY_ACQUIRE_FIRSTLEVEL_NUM = reqDTO.getValue("DAILY_ACQUIRE_FIRSTLEVEL_NUM");//一级品
//		String COLLECT_2_CLASS = reqDTO.getValue("COLLECT_2_CLASS");//二级品
//		String COLLECT_MISS_NUM=reqDTO.getValue("COLLECT_MISS_NUM");//空炮
//		String COLLECT_WASTER_NUM = reqDTO.getValue("COLLECT_WASTER_NUM");//废炮
//		String DAILY_MICRO_MEASUE_POINT_NUM = reqDTO.getValue("DAILY_MICRO_MEASUE_POINT_NUM");//微测井点数
//		String DAILY_SMALL_REFRACTION_NUM = reqDTO.getValue("DAILY_SMALL_REFRACTION_NUM");//小折射点数
//		String DAILY_DRILL_SP_NUM = reqDTO.getValue("DAILY_DRILL_SP_NUM");//钻井炮点数
//		String DAILY_DRILL_WELL_NUM=reqDTO.getValue("DAILY_DRILL_WELL_NUM");//钻井井口数
//		String DAILY_DRILL_FOOTAGE_NUM = reqDTO.getValue("DAILY_DRILL_FOOTAGE_NUM");//钻井进尺数
//		String DAILY_SURVEY_SHOT_NUM = reqDTO.getValue("DAILY_SURVEY_SHOT_NUM");//测量炮点数
//		String DAILY_SURVEY_GEOPHONE_NUM = reqDTO.getValue("DAILY_SURVEY_GEOPHONE_NUM");//测量检波点数
//		String SURVEY_SHOT_WORKLOAD = reqDTO.getValue("SURVEY_SHOT_WORKLOAD");//测量炮线公里数
//		String SURVEY_INCEPT_WORKLOAD=reqDTO.getValue("SURVEY_INCEPT_WORKLOAD");//
//		String PATH = reqDTO.getValue("PATH");//路途时间
//		String TIDE_DELAY = reqDTO.getValue("TIDE_DELAY");//潮汐影响时间
//		String ACTUAL_SHOT = reqDTO.getValue("ACTUAL_SHOT");//实际放炮时间
//		
//		
//		String RELATION_DELAY = reqDTO.getValue("RELATION_DELAY");//地方关系影响
//		String WEATHER_DELAY = reqDTO.getValue("WEATHER_DELAY");//天气影响时间
//		String MACHINE_DELAY = reqDTO.getValue("MACHINE_DELAY");//仪器影响时间
//		
//		String MEASURE_DELAY = reqDTO.getValue("MEASURE_DELAY");//测量影响时间
//		String CLEARUP_DELAY = reqDTO.getValue("CLEARUP_DELAY");//工区清障时间
//
//		
//		
//		String ARRAY_TROUBLE = reqDTO.getValue("ARRAY_TROUBLE");//排列故障时间
//		String TRANSIT_DELAY=reqDTO.getValue("TRANSIT_DELAY");//工地搬迁时间
//		String LINE_LAY = reqDTO.getValue("LINE_LAY");//收放线时间
//		String ARRAY_CHECK = reqDTO.getValue("ARRAY_CHECK");//查排列时间
//		String HSE_DELAY = reqDTO.getValue("HSE_DELAY");//HSE影响时间
//		String FIRST_SHOT_TIME = reqDTO.getValue("FIRST_SHOT_TIME");//首炮时间
//		String LAST_SHOT_TIME=reqDTO.getValue("LAST_SHOT_TIME");//末炮时间
//		
//		String AIR_GUN_USE_TIME = reqDTO.getValue("AIR_GUN_USE_TIME");//气枪调头上线时间
//		String INFO_AREA_NUM = reqDTO.getValue("INFO_AREA_NUM");//有资料面积
//		String ORIENTATION_SHOT_NUM = reqDTO.getValue("ORIENTATION_SHOT_NUM");//定位炮
//		String OPERATION_EXPLAIN = reqDTO.getValue("OPERATION_EXPLAIN");//作业综述(滩浅海,浅海)
//		
//		String FOCUS_DELAY = reqDTO.getValue("FOCUS_DELAY");//震源设备影响时间 夏秋雨添加
//		String day_check_time = reqDTO.getValue("day_check_time");//日检时间 add by bianshen
//		
//		
//		String org_id = null;
//		String org_subjection_id = null;
//		
//		boolean flag1 = false;
//		
//		ProjectMCSBean projectMCSBean = (ProjectMCSBean) BeanFactory.getBean("ProjectMCSBean");
//		
//		PageModel page = new PageModel();
//		
//		Map map = reqDTO.toMap();
//		map.put("projectInfoNo", map.get("project_info_no"));
//		
//		page = projectMCSBean.quertProject(map, page);
//
//		List list = page.getData();
//		if (list != null && list.size() != 0) {
//			Map project = (Map) list.get(0);
//			map.put("workarea_no", project.get("workarea_no"));
//			map.put("exploration_method", project.get("exploration_method"));
//		}
//		
//		page = projectMCSBean.quertProjectDynamic(map, page);
//
//		list = page.getData();
//		if (list != null && list.size() != 0) {
//			Map dy = (Map) list.get(0);
//			
//			org_id = (String) dy.get("org_id");
//			map.put("org_id", dy.get("org_id"));
//			
//			org_subjection_id = (String) dy.get("org_subjection_id");
//			map.put("org_subjection_id", dy.get("org_subjection_id"));
//		}
//		
//	
//	
//		
//		if(flag.equals("notSaved")){
//			//新增
//			map.put("creator", user.getUserName());
//			map.put("create_date", new Date());
//			
//			map.put("updator", user.getUserName());
//			map.put("modifi_date", new Date());
//			
//			map.put("bsflag", "0");
//			map.put("submit", "1");
//			map.put("audit_status", "0");
//			map.put("daily_jp_acquire_shot_num", daily_jp_acquire_shot_num);
//			map.put("daily_qq_acquire_shot_num", daily_qq_acquire_shot_num);
//			
//			map.put("daily_acquire_sp_num", daily_acquire_sp_num);
//			map.put("DAILY_JP_ACQUIRE_WORKLOAD", DAILY_JP_ACQUIRE_WORKLOAD);
//			
//			map.put("DAILY_QQ_ACQUIRE_WORKLOAD", DAILY_QQ_ACQUIRE_WORKLOAD);
//			map.put("DAILY_ACQUIRE_WORKLOAD",DAILY_ACQUIRE_WORKLOAD);
//			map.put("DAILY_TEST_SP_NUM", DAILY_TEST_SP_NUM);
//			map.put("EFFICIENCY_ADJUST", EFFICIENCY_ADJUST);
//			map.put("DAILY_ACQUIRE_FIRSTLEVEL_NUM",DAILY_ACQUIRE_FIRSTLEVEL_NUM);
//			
//			map.put("COLLECT_2_CLASS", COLLECT_2_CLASS);
//			map.put("COLLECT_MISS_NUM", COLLECT_MISS_NUM);
//			
//			map.put("COLLECT_WASTER_NUM", COLLECT_WASTER_NUM);
//			map.put("DAILY_MICRO_MEASUE_POINT_NUM", DAILY_MICRO_MEASUE_POINT_NUM);
//			
//			map.put("DAILY_SMALL_REFRACTION_NUM", DAILY_SMALL_REFRACTION_NUM);
//			map.put("DAILY_DRILL_SP_NUM",DAILY_DRILL_SP_NUM);
//			map.put("DAILY_DRILL_FOOTAGE_NUM", DAILY_DRILL_FOOTAGE_NUM);
//			map.put("DAILY_SURVEY_SHOT_NUM", DAILY_SURVEY_SHOT_NUM);
//			map.put("DAILY_SURVEY_GEOPHONE_NUM",DAILY_SURVEY_GEOPHONE_NUM);
//			map.put("SURVEY_SHOT_WORKLOAD", SURVEY_SHOT_WORKLOAD);
//			map.put("SURVEY_INCEPT_WORKLOAD", SURVEY_INCEPT_WORKLOAD);
//			
//			map.put("PATH", PATH);
//			map.put("TIDE_DELAY", TIDE_DELAY);
//			map.put("ACTUAL_SHOT", ACTUAL_SHOT);
//			map.put("ARRAY_TROUBLE",ARRAY_TROUBLE);
//			map.put("TRANSIT_DELAY", TRANSIT_DELAY);
//			map.put("LINE_LAY", LINE_LAY);
//			map.put("ARRAY_CHECK",ARRAY_CHECK);
//			map.put("HSE_DELAY", HSE_DELAY);
//			map.put("FIRST_SHOT_TIME", FIRST_SHOT_TIME);
//			map.put("LAST_SHOT_TIME", LAST_SHOT_TIME);
//			map.put("AIR_GUN_USE_TIME", AIR_GUN_USE_TIME);
//			
//			map.put("RELATION_DELAY", RELATION_DELAY);
//			map.put("WEATHER_DELAY", WEATHER_DELAY);
//			map.put("MACHINE_DELAY", MACHINE_DELAY);
//			map.put("MEASURE_DELAY", MEASURE_DELAY);
//			map.put("CLEARUP_DELAY", CLEARUP_DELAY);
//			map.put("DAY_CHECK", day_check_time);
//			
//			
//			map.put("INFO_AREA_NUM", INFO_AREA_NUM);
//			map.put("ORIENTATION_SHOT_NUM",ORIENTATION_SHOT_NUM);
//			map.put("OPERATION_EXPLAIN",OPERATION_EXPLAIN);
//			
//			map.put("FOCUS_DELAY",FOCUS_DELAY);//夏秋雨添加  震源设备影响时间
//			map.put("FIRST_DELAY",FIRST_SHOT_TIME);//首炮时间,夏秋雨添加（大港物探处）
//			map.put("LAST_DELAY",LAST_SHOT_TIME);//末炮时间,夏秋雨添加（大港物探处）
//			
//			Serializable dailyNo = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report");
//
//			map.put("daily_no", dailyNo);
//			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_produce_sit");
//			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_OPS_SS_DAILY_EFFICIENCY");
//			flag1 = true;
//			
//			JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
//			
//			String sql = "select * from bgp_p6_workload where bsflag = '0' and project_info_no = '"+project_info_no+"' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd') ";
//			
//			List<Map<String,Object>> temp = radDao.getJdbcTemplate().queryForList(sql);
//			if (temp == null || temp.size() == 0) {
//				//本日没有记录
//				sql = "select * from bgp_p6_workload where bsflag = '0' and produce_date is null and project_info_no = '"+project_info_no+"' ";
//				List<Map<String,Object>> tempList = radDao.getJdbcTemplate().queryForList(sql);
//				//创建本日记录
//				for (int i = 0; i < tempList.size(); i++) {
//					Map<String, Object> mapTemp = tempList.get(i);
//					
//					mapTemp.put("produce_date", produceDate);
//					mapTemp.put("object_id", null);
//					
//					mapTemp.put("actual_this_period_units", "0");
//					
//					mapTemp.put("create_date", new Date());
//					mapTemp.put("creator", user.getUserId());
//					mapTemp.put("modifi_date", new Date());
//					mapTemp.put("updator", user.getUserId());
//				}
//				
//				WorkloadMCSBean w = new WorkloadMCSBean();
//				w.saveOrUpdateWorkloadToMCS(tempList, user);
//			}
//			
//			
//			
//		} else if(edit_flag.equals("yes")&&(flag.equals("notPassed")||flag.equals("notSubmited"))){
//			//修改
//			Map daily = this.getDailyReport(map);
//			map.put("daily_no", daily.get("dailyNo"));
//			
//			map.put("updator", user.getUserName());
//			map.put("modifi_date", new Date());
//			
//			map.put("bsflag", "0");
//			map.put("submit", "1");
//			map.put("audit_status", "0");
//			map.put("daily_jp_acquire_shot_num", daily_jp_acquire_shot_num);
//			map.put("daily_qq_acquire_shot_num", daily_qq_acquire_shot_num);
//			
//			map.put("daily_acquire_sp_num", daily_acquire_sp_num);
//			map.put("DAILY_JP_ACQUIRE_WORKLOAD", DAILY_JP_ACQUIRE_WORKLOAD);
//			
//			map.put("DAILY_QQ_ACQUIRE_WORKLOAD", DAILY_QQ_ACQUIRE_WORKLOAD);
//			map.put("DAILY_ACQUIRE_WORKLOAD",DAILY_ACQUIRE_WORKLOAD);
//			map.put("DAILY_TEST_SP_NUM", DAILY_TEST_SP_NUM);
//			map.put("EFFICIENCY_ADJUST", EFFICIENCY_ADJUST);
//			map.put("DAILY_ACQUIRE_FIRSTLEVEL_NUM",DAILY_ACQUIRE_FIRSTLEVEL_NUM);
//			
//			map.put("COLLECT_2_CLASS", COLLECT_2_CLASS);
//			map.put("COLLECT_MISS_NUM", COLLECT_MISS_NUM);
//			
//			map.put("COLLECT_WASTER_NUM", COLLECT_WASTER_NUM);
//			map.put("DAILY_MICRO_MEASUE_POINT_NUM", DAILY_MICRO_MEASUE_POINT_NUM);
//			
//			map.put("DAILY_SMALL_REFRACTION_NUM", DAILY_SMALL_REFRACTION_NUM);
//			map.put("DAILY_DRILL_SP_NUM",DAILY_DRILL_SP_NUM);
//			map.put("DAILY_DRILL_FOOTAGE_NUM", DAILY_DRILL_FOOTAGE_NUM);
//			map.put("DAILY_SURVEY_SHOT_NUM", DAILY_SURVEY_SHOT_NUM);
//			map.put("DAILY_SURVEY_GEOPHONE_NUM",DAILY_SURVEY_GEOPHONE_NUM);
//			map.put("SURVEY_SHOT_WORKLOAD", SURVEY_SHOT_WORKLOAD);
//			map.put("SURVEY_INCEPT_WORKLOAD", SURVEY_INCEPT_WORKLOAD);
//			
//			map.put("PATH", PATH);
//			map.put("TIDE_DELAY", TIDE_DELAY);
//			
//			map.put("ACTUAL_SHOT", ACTUAL_SHOT);
//			map.put("ARRAY_TROUBLE",ARRAY_TROUBLE);
//			map.put("TRANSIT_DELAY", TRANSIT_DELAY);
//			map.put("LINE_LAY", LINE_LAY);
//			map.put("ARRAY_CHECK",ARRAY_CHECK);
//			map.put("HSE_DELAY", HSE_DELAY);
//			map.put("FIRST_SHOT_TIME", FIRST_SHOT_TIME);
//			
//			map.put("LAST_SHOT_TIME", LAST_SHOT_TIME);
//			map.put("AIR_GUN_USE_TIME", AIR_GUN_USE_TIME);
//			
//			map.put("INFO_AREA_NUM", INFO_AREA_NUM);
//			map.put("ORIENTATION_SHOT_NUM",ORIENTATION_SHOT_NUM);
//			map.put("OPERATION_EXPLAIN",OPERATION_EXPLAIN);
//			
//			map.put("FOCUS_DELAY",FOCUS_DELAY);//夏秋雨添加  震源设备影响时间
//			map.put("FIRST_DELAY",FIRST_SHOT_TIME);//首炮时间,夏秋雨添加（大港物探处）
//			map.put("LAST_DELAY",LAST_SHOT_TIME);//末炮时间,夏秋雨添加（大港物探处）
//			map.put("DAY_CHECK", day_check_time);
//			
//			Serializable dailyNo = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report");
//			
//			
//			//查询出daily_sit_no进行更新
//			String getsitDailyNo = "select s.daily_sit_no from gp_ops_daily_produce_sit s where s.bsflag = '0' and s.daily_no = '"+dailyNo+"'";
//			String getEfficiencyNo="select e.efficiency_no from bgp_ops_ss_daily_efficiency e where e.daily_no = '"+dailyNo+"'";
//			if(radDao.queryRecordBySQL(getsitDailyNo.toString()) != null){
//				map.put("daily_sit_no", radDao.queryRecordBySQL(getsitDailyNo.toString()).get("daily_sit_no"));
//				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_produce_sit");
//			}
//			if(radDao.queryRecordBySQL(getsitDailyNo.toString()) != null){
//				map.put("efficiency_no", radDao.queryRecordBySQL(getEfficiencyNo.toString()).get("efficiency_no"));
//				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_ops_ss_daily_efficiency");
//			}
//			
//			flag1 = true;
//		}
//		
//		if (flag1) {
//			String deleteId = reqDTO.getValue("deleteId");
//			Map map1 = reqDTO.toMap();
//			String[] deleteIds = deleteId.split(",");
//			List<String> list1 = new ArrayList<String>();
//			if (deleteIds != null && deleteIds.length > 1) {
//				for (int i = 1; i < deleteIds.length; i++) {
//					list1.add(deleteIds[i]);
//				}
//				this.deleteQuestion(list1);
//			}
//			
//			List<String> listOrders = reqDTO.getValues("order");
//			String order = reqDTO.getValue("order");
//			
//			if (listOrders == null && order != null) {
//				listOrders = new ArrayList<String>();
//				listOrders.add(order);
//			}
//			
//			
//			List saveList = new ArrayList();
//			List updateList = new ArrayList();
//			
//			String j = null;
//			
//			String question_id = null;
//			
//			String bug_code = null;
//			String q_description = null;
//			String resolvent = null;
//			
//			if (listOrders != null && listOrders.size() !=0) {
//				
//				for (int i = 0; i < listOrders.size(); i++) {
//					j = listOrders.get(i);
//					
//					question_id = reqDTO.getValue("question_id_"+j);
//					bug_code = reqDTO.getValue("bug_code_"+j);
//					q_description = reqDTO.getValue("q_description_"+j);
//					resolvent = reqDTO.getValue("resolvent_"+j);
//					if (question_id == null || "".equals(question_id)) {
//						//新增
//						map = new HashMap();
//						
//						map.put("creator", user.getEmpId());
//						map.put("create_date", new Date());
//						map.put("updator", user.getEmpId());
//						map.put("modifi_date", new Date());
//						
//						map.put("bsflag", "0");
//						map.put("bug_code", bug_code);
//						map.put("q_description", q_description);
//						map.put("resolvent", resolvent);
//						map.put("project_info_no", project_info_no);
//						map.put("org_id", org_id);
//						map.put("org_subjection_id", org_subjection_id);
//						map.put("produce_date", produceDate);
//						
//						saveList.add(map);
//					} else {
//						//修改
//						map = new HashMap();
//						
//						map.put("updator", user.getEmpId());
//						map.put("modifi_date", new Date());
//						
//						map.put("bsflag", "0");
//						map.put("bug_code", bug_code);
//						map.put("q_description", q_description);
//						map.put("resolvent", resolvent);
//						map.put("project_info_no", project_info_no);
//						map.put("org_id", org_id);
//						map.put("org_subjection_id", org_subjection_id);
//						map.put("produce_date", produceDate);
//						
//						map.put("question_id", question_id);
//						
//						updateList.add(map);
//					}
//					
//				}
//			}
//			
//			this.saveDailyQuestion(saveList);
//			this.updateDailyQuestion(updateList);
//		}
//		
//		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
//		msg.setValue("flag", flag);
//		msg.setValue("projectInfoNo", project_info_no);
//
//		
//		msg.setValue("customKey", "edit_flag,produceDate");
//		msg.setValue("customValue", edit_flag+","+produceDate);
//		msg.setValue("taskBackUrl", "/pm/dailyReport/queryQhResourceAssignment.srq");
//		return msg;
//	}
	public ISrvMsg saveOrUpdateDailyReportDg(ISrvMsg reqDTO) throws Exception{

		
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
	     //System.out.print(map.get("FIRST_SHOT_TIME"));
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
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_OPS_SS_DAILY_EFFICIENCY_1");
			
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
			String getEfficiencyNo="select e.efficiency_no from bgp_ops_ss_daily_efficiency_1 e where e.daily_no = '"+dailyNo+"'";
			if(radDao.queryRecordBySQL(getsitDailyNo.toString()) != null){
				map.put("daily_sit_no", radDao.queryRecordBySQL(getsitDailyNo.toString()).get("daily_sit_no"));
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_produce_sit");
			}
			if(radDao.queryRecordBySQL(getEfficiencyNo.toString()) != null){
				map.put("efficiency_no", radDao.queryRecordBySQL(getEfficiencyNo.toString()).get("efficiency_no"));
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_ops_ss_daily_efficiency_1");
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
		msg.setValue("taskBackUrl", "/pm/dailyReport/queryResourceAssignmentDg.srq");
		return msg;
	
	}
	
public ISrvMsg saveOrUpdateDailyReport(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		String if_build = reqDTO.getValue("if_build");
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
				sql = "select w.*,w.activity_name as activity_name1 from bgp_p6_workload w where w.bsflag = '0' and w.produce_date is null and w.project_info_no = '"+project_info_no+"' ";
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
				//此处的tempList是初始的工作量值????
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
		
		//if (flag1) { modify by bianshen 
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
		//}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("flag", flag);
		msg.setValue("projectInfoNo", project_info_no);

		msg.setValue("if_build", if_build);
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
	
	public ISrvMsg queryDailyPlan(ISrvMsg reqDTO) throws Exception{

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
		//List list = null;
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
			list = countDailyPlanNew(projectInfoNo);
			
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		
		return msg;
	
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
	
	/**
	 * s
	* @Title: countDailyPlanNew
	* @Description: 重新修改计划日效算法
	* @param @param projectInfoNo
	* @param @return    设定文件
	* @return List    返回类型
	* @throws
	 */
	private List countDailyPlanNew(String projectInfoNo){
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		
		List AllList = new ArrayList();
		List measuredailylist = new ArrayList();
		List drilldailylist = new ArrayList();
		List colldailylist = new ArrayList();
		
		String[] measure2Type = {"G02003","G02004"};
		String[] measure3Type = {"G2003","G2004"};
		
		String[] drill2Type = {"G05001"};
		String[] drill3Type = {"G5001"};
		
		String[] coll2Type = {"G07001","G07003","G07005"};
		String[] coll3Type = {"G7001","G7003","G7005"};
		
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
		
		String sqlTemp = null;
		
		//总的
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
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null and w.planned_units > 0";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		String max_finish_date = null;
		String min_start_date = null;
		
		Date start_date = null;
		Date end_date = null;
		
		int day = 0;
		
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
		
		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration, 3) end) as average_units," +
				" to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();
		//处理如果接收线公里数与炮线公里数都存在时
		List ls = new ArrayList(); 
		for(int j=0; j<list.size(); j++){
			Map map = (Map)list.get(j);
			if(ls.isEmpty()){
				ls.add(map);
			} else { 
				boolean flag = true;
				for(int i=0; i<ls.size();i++){
					double workloadNum = 0;
					double   plannedUnits = 0;
					Map map0 = (Map)ls.get(i);
					if(map.get("finish_date").equals(map0.get("finish_date"))){
						workloadNum = Double.parseDouble((String)map.get("average_units")) + Double.parseDouble((String)map0.get("average_units"));
						plannedUnits = Double.parseDouble((String)map.get("planned_units")) + Double.parseDouble((String)map0.get("planned_units"));
						ls.remove(i);
						map0.put("average_units", df_1.format(workloadNum));
						map0.put("planned_units", df_1.format(plannedUnits));
						ls.add(map0);
						flag = false;
						break;
					} 
				}
				if(flag)
				ls.add(map);
			}
	 
		}
		
		temp = new Date();
		dateTemp = null;
		
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime()+86400000L*i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			
			double workload_num = 0;
			for (int j = 0; j < ls.size(); j++) {
				Map tempMap = (Map) ls.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");
				
				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String)tempMap.get("average_units"));
				}
			}
			map.put("workload_num", df_1.format(workload_num));
			measuredailylist.add(map);
		}
		 
		
		//钻井
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
		
		
		sql = "select w.planned_units ," +
				" to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();
		
		long plannedUnitsd;
		long workload_num_d0=0;
		long workload_num_d1=0;
		int dayNumd0 = 0;
		List lsd = new  ArrayList();
		for (int j = 0; j < list.size(); j++)
		{
			Map tempMap = (Map) list.get(j);
			String s = (String) tempMap.get("start_date");
			String e = (String) tempMap.get("finish_date"); 
			//计算天数 
			int dayNum = DateOperation.getDateSkip(s, e);
			
			plannedUnitsd = Long.parseLong(tempMap.get("planned_units")
					.toString());
			workload_num_d0 = plannedUnitsd / dayNum;
			workload_num_d1 = plannedUnitsd % dayNum;
			if (workload_num_d1 > 0)
			{
				dayNumd0 = dayNum - (int)workload_num_d1;
			}
		
			tempMap.put("average_units", workload_num_d0);
			Date sdt = null;
			if(dayNumd0 != 0){ 
				sdt = DateOperation.parseToUtilDate(s); 
				sdt.setDate(sdt.getDate()+(int)dayNumd0);
				tempMap.put("middle_date", DateOperation.formatDate(sdt));  
				dayNumd0= 0;
			}
			 
			lsd.add(tempMap);
		}
		list = lsd;
		
		temp = new Date();
		dateTemp = null;
		
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime()+86400000L*i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			
			long workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");
				Object md =  tempMap.get("middle_date"); 
				if (DateOperation.dateBetween(s, e, dateTemp)) {
					
					workload_num += Long.parseLong(tempMap.get("average_units").toString());
					
					if(md!=null && DateOperation.dateBetween(md.toString(),e,dateTemp)){
						workload_num = workload_num + 1;
					}
				}
			}
			map.put("workload", workload_num );
			drilldailylist.add(map);
		}
		
		//采集
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
		
		sql = "select w.planned_units, " +
				" to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();
		
		//处理如果接收震源炮点数、井炮炮点数和都存在时
				List ls2 = new ArrayList(); 
				for(int j=0; j<list.size(); j++){
					Map map = (Map)list.get(j);
					if(ls2.isEmpty()){
						ls2.add(map);
					} else { 
						boolean flag = true;
						for(int i=0; i<ls2.size();i++){
							long workloadNum = 0;
							long   plannedUnits = 0;
							Map map0 = (Map)ls2.get(i);
							if(map.get("finish_date").equals(map0.get("finish_date"))){
							 plannedUnits = Long.parseLong((String)map.get("planned_units")) + Long.parseLong((String)map0.get("planned_units"));
								ls2.remove(i);
								 map0.put("planned_units", plannedUnits);
								ls2.add(map0);
								flag = false;
								break;
							} 
						}
						if(flag)
							ls2.add(map);
					}
			 
				}
		long plannedUnits0 = 0;
		long workload_num_0 = 0;
		long workload_num_1 = 0;
		long dayNum0 = 0;
		List ls21 = new ArrayList();
		for (int j = 0; j < ls2.size(); j++)
		{
			Map tempMap = (Map) ls2.get(j);
			String s = (String) tempMap.get("start_date");
			String e = (String) tempMap.get("finish_date"); 
			//计算天数 
			int dayNum = DateOperation.getDateSkip(s, e);
			
			plannedUnits0 = Long.parseLong(tempMap.get("planned_units")
					.toString());
			workload_num_0 = plannedUnits0 / dayNum;
			workload_num_1 = plannedUnits0 % dayNum;
			if (workload_num_1 > 0)
			{
				dayNum0 = dayNum - workload_num_1;
			}
		
			tempMap.put("planned_units", workload_num_0);
			Date sdt = null;
			if(dayNum0 != 0){ 
				sdt = DateOperation.parseToUtilDate(s); 
				sdt.setDate(sdt.getDate()+(int)dayNum0);
				tempMap.put("middle_date", DateOperation.formatDate(sdt));  
				dayNum0= 0;
			}
	
			ls21.add(tempMap);
		}
		ls2 = ls21;
		
		temp = new Date();
		dateTemp = null;
		
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime()+86400000L*i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			
			long workload_num = 0;
			for (int j = 0; j < ls2.size(); j++) {
				Map tempMap = (Map) ls2.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");
				
				if (DateOperation.dateBetween(s, e, dateTemp) ) {
					workload_num = Long.parseLong(tempMap.get("planned_units").toString());
					Object md =  tempMap.get("middle_date");
					
					if(md!=null && DateOperation.dateBetween(md.toString(),e,dateTemp)){
						workload_num = workload_num + 1;
					}
					
				}
			}
			map.put("workload", workload_num);
			colldailylist.add(map);
		}
		
		List list2 = new ArrayList();
		list2.add(AllList);
		list2.add(measuredailylist);
		list2.add(drilldailylist);
		list2.add(colldailylist);
		return list2;
	}
	
	private List countDailyPlan(String projectInfoNo){
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);
		
		List AllList = new ArrayList();
		List measuredailylist = new ArrayList();
		List drilldailylist = new ArrayList();
		List colldailylist = new ArrayList();
		
		String[] measure2Type = {"G02003","G02004"};
		String[] measure3Type = {"G2003","G2004"};
		
		String[] drill2Type = {"G05001"};
		String[] drill3Type = {"G5001"};
		
		String[] coll2Type = {"G07001","G07003","G07005"};
		String[] coll3Type = {"G7001","G7003","G7005"};
		
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
		
		String sqlTemp = null;
		
		//总的
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
		
		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null and w.planned_units > 0";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		
		String max_finish_date = null;
		String min_start_date = null;
		
		Date start_date = null;
		Date end_date = null;
		
		int day = 0;
		
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
		
		sql = "select w.planned_units," +
//				"a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration, 3) end) as average_units," +
				" to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		String sql_tmp = " select sum(planned_units) as planned_units, start_date, finish_date from ( "+sql+" ) wd group by start_date, finish_date";
		
		page = radDao.queryRecordsBySQL(sql_tmp.toString(), page);
		list = page.getData();
		
		 
		long  plannedUnits0 = 0;
		long workload_num_0 = 0;
		long workload_num_1 = 0;
		long day0=0;
		for (int j = 0; j < list.size(); j++) {
			Map tempMap = (Map) list.get(j);
			String s = (String) tempMap.get("start_date");
			
			String e = (String) tempMap.get("finish_date");
			plannedUnits0 = Long.parseLong(tempMap.get("planned_units").toString());
			workload_num_0 = plannedUnits0/day;
			workload_num_1 = plannedUnits0%day;
			if(workload_num_1>0){
				day0 = day-workload_num_1;
			}
		}
		
		temp = new Date();
		dateTemp = null;
		
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime()+86400000L*i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
			
		    if(i<day0){
		    	map.put("workload_num", workload_num_0);
		    } else {
		    	map.put("workload_num", workload_num_0+1);
		    }
			 
			measuredailylist.add(map);
		}
		
		
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
		
		//钻井
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
		
		sql = "select w.planned_units," +
//				",a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration, 3) end) as average_units," +
				" to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
				" join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' " +
				" where w.project_info_no = '"+projectInfoNo+"' and w.bsflag = '0' and w.produce_date is null ";
		
		sql += sqlTemp;
		
		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();
		
		temp = new Date();
		dateTemp = null;
		
		 
		long  plannedUnits = 0;
		long workload_num0 = 0;
		long workload_num1 = 0;
		long day1=0;
		for (int j = 0; j < list.size(); j++) {
			Map tempMap = (Map) list.get(j);
			String s = (String) tempMap.get("start_date");
			String e = (String) tempMap.get("finish_date");
			plannedUnits = Long.parseLong(tempMap.get("planned_units").toString());
			workload_num0 = plannedUnits/day;
			workload_num1 = plannedUnits%day;
			if(workload_num1>0){
				day1 = day-workload_num1;
			}
		}
		
		
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime()+86400000L*i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month", DateOperation.formatDate(temp, "yyyy-MM-dd"));
		    if(i<day1){
		    	map.put("workload", workload_num0);
		    } else {
		    	map.put("workload", workload_num0+1);
		    }
			
			drilldailylist.add(map);
		}
		
		//采集
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
		
		sql = "select w.planned_units,a.planned_duration/8 as duration,(case a.planned_duration when 0 then w.planned_units else round(w.planned_units * 8 / a.planned_duration, 3) end) as average_units," +
				" to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w " +
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
				List list = countDailyPlanNew(projectInfoNo);
				msg.setValue("allList", list.get(0));
				msg.setValue("measuredailylist", list.get(1));
				msg.setValue("drilldailylist", list.get(2));
				msg.setValue("colldailylist", list.get(3));
			}
		}else{
			List list = countDailyPlanNew(projectInfoNo);
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		msg.setValue("hasSaved", "0");
		return msg;
	}
	
	
	// 判断字符串值是否数字
	private boolean isNumeric(String str){
		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");//[0-9]+(.[0-9]?)?+
		Matcher isNum = pattern.matcher(str);
		if( !isNum.matches()){
			return false;
		}
		return true;
	}
	
	// 判断字符串值是否日期
	private boolean isDate(String str){
		String eL= "^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))";        
		Pattern pattern = Pattern.compile(eL);//[0-9]+(.[0-9]?)?+
		Matcher isDate = pattern.matcher(str);
		if( !isDate.matches()){
			return false;
		}
		return true;
	}
	
	/**
	 * 导入计划日效
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg importExcelDailyPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		String build_method = reqDTO.getValue("buildMethod")!=null?reqDTO.getValue("buildMethod"):"";
		if("5000100003000000001".equals(build_method) || "5000100003000000004".equals(build_method)){
			//有钻井
			
		}
		StringBuffer message = new StringBuffer("");
		
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				String name = fs.getFilename();
				if (fs.getFilename().indexOf(".xlsx") == -1 && fs.getFilename().indexOf(".xls") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					if(fs.getFilename().indexOf(".xlsx") != -1){
						book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}else if(fs.getFilename().indexOf(".xls") != -1){
						book = new HSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					
					row = sheet.getRow(1);
					// 验证文件表头
					boolean bCheck = checkLineCompletedFileHeader(build_method, row);
					//boolean bCheck = true;
					boolean bSaveFlag = true;
					
					// 
					if(bCheck){
						int rows = sheet.getPhysicalNumberOfRows();
						int headerCells = row.getPhysicalNumberOfCells();
						if(rows >= 2){
							// 读取数据(行号大于2时存在数据)
							//去掉最后行空数据
							int endRow = rows - 1;
							Row endDataRow = sheet.getRow(endRow);
							int endDataCells = endDataRow.getPhysicalNumberOfCells();
							for(int j=0; j <= endDataCells; j++){
								Cell endRowCell = endDataRow.getCell(j);
								if(endRowCell != null){
									endRowCell.setCellType(1);
									String endCellValue = endRowCell.getStringCellValue().trim();
									if("".equals(endCellValue)){
										rows = endRow;
										break;
									}
								}else{
									rows = endRow;
									break;
								}
							}
							List<Map> dataList = new ArrayList<Map>();
							Map fileColumnMap = getLineCompletedHeader(build_method);
							int mapSize = fileColumnMap.size();	
							if(mapSize == 4){
								//有钻井
								for(int i=2; i< rows; i++){
									Row dataRow = sheet.getRow(i);
									
									if(dataRow == null){
										continue;
									}
									
									Cell cell_0 = dataRow.getCell(0);//日期
									//String dateValue = cell_0.getStringCellValue().trim();
									String dateValue = cell_0.getStringCellValue().trim().substring(0, cell_0.getStringCellValue().trim().length()-1);
									//判断是否是日期格式
									if(this.isDate(dateValue)){
										for(int m=1;m<mapSize;m++){
											//测量
											Map recordMap = null;
											if(m == 1){
												recordMap = new HashMap();
												Cell cell_1 = dataRow.getCell(1);
												cell_1.setCellType(1);
												String cellValue_1 = cell_1.getStringCellValue().trim();;
												
												if(!"".equals(cellValue_1)){
													if(isNumeric(cellValue_1)){
														if(Double.parseDouble(cellValue_1) > 0){
															recordMap.put("record_month", dateValue);
															recordMap.put("workload_num", cellValue_1);
															recordMap.put("oper_plan_type", "measuredailylist");
															dataList.add(recordMap);
														}
													}else{
														message.append("第[").append(i).append("]行第2列'").append("'列应为数值!");
														bSaveFlag = false;
														break;
													}
												}
											}
											//钻井
											if(m == 2){
												recordMap = new HashMap();
												Cell cell_2 = dataRow.getCell(2);
												cell_2.setCellType(1);
												String cellValue_2 = cell_2.getStringCellValue().trim();;
												
												if(!"".equals(cellValue_2)){
													if(isNumeric(cellValue_2)){
														if(Double.parseDouble(cellValue_2) > 0){
															recordMap.put("record_month", dateValue);
															recordMap.put("workload", cellValue_2);
															recordMap.put("oper_plan_type", "drilldailylist");
															dataList.add(recordMap);
														}
													}else{
														message.append("第[").append(i).append("]行第3列'").append("'列应为数值!");
														bSaveFlag = false;
														break;
													}
												}
											}
											//采集
											if(m == 3){
												recordMap = new HashMap();
												Cell cell_3 = dataRow.getCell(3);
												cell_3.setCellType(1);
												String cellValue_3 = cell_3.getStringCellValue().trim();;
												
												if(!"".equals(cellValue_3)){
													if(isNumeric(cellValue_3)){
														if(Double.parseDouble(cellValue_3) > 0){
															recordMap.put("record_month", dateValue);
															recordMap.put("workload", cellValue_3);
															recordMap.put("oper_plan_type", "colldailylist");
															dataList.add(recordMap);
														}
													}else{
														message.append("第[").append(i).append("]行第4列'").append("'列应为数值!");
														bSaveFlag = false;
														break;
													}
												}
											}
										}
									}else{
										message.append("第[").append(i).append("]行第1列'").append("'列应为日期:年-月-日!");
										bSaveFlag = false;
										break;
									}
								}
							}else if(mapSize == 3){
								//没钻井
								
								for(int i=2; i< rows; i++){
									Row dataRow = sheet.getRow(i);
									
									if(dataRow == null){
										continue;
									}
									
									Cell cell_0 = dataRow.getCell(0);//日期
									String dateValue = cell_0.getStringCellValue().trim().substring(0, cell_0.getStringCellValue().trim().length()-1);
									//判断是否是日期格式
									if(this.isDate(dateValue)){
										for(int m=1;m<mapSize;m++){
											//测量
											Map recordMap = null;
											if(m == 1){
												recordMap = new HashMap();
												Cell cell_1 = dataRow.getCell(1);
												cell_1.setCellType(1);
												String cellValue_1 = cell_1.getStringCellValue().trim();;
												
												if(!"".equals(cellValue_1)){
													if(isNumeric(cellValue_1)){
														if(Double.parseDouble(cellValue_1) > 0){
															recordMap.put("record_month", dateValue);
															recordMap.put("workload_num", cellValue_1);
															recordMap.put("oper_plan_type", "measuredailylist");
															dataList.add(recordMap);	
														}
													}else{
														message.append("第[").append(i).append("]行第2列'").append("'列应为数值!");
														bSaveFlag = false;
														break;
													}
												}
											}
											//采集
											if(m == 2){
												recordMap = new HashMap();
												Cell cell_2 = dataRow.getCell(2);
												cell_2.setCellType(1);
												String cellValue_2 = cell_2.getStringCellValue().trim();;
												
												if(!"".equals(cellValue_2)){
													if(isNumeric(cellValue_2)){
														if(Double.parseDouble(cellValue_2) > 0){
															recordMap.put("record_month", dateValue);
															recordMap.put("workload", cellValue_2);
															recordMap.put("oper_plan_type", "colldailylist");
															dataList.add(recordMap);	
														}
													}else{
														message.append("第[").append(i).append("]行第3列'").append("'列应为数值!");
														bSaveFlag = false;
														break;
													}
												}
											}
										}
									}else{
										message.append("第[").append(i).append("]行第1列'").append("'列应为日期:年-月-日!");
										bSaveFlag = false;
										break;
									}
								}
							}							
							if(bSaveFlag == true){
								String tableName = "gp_proj_product_plan";
								String rts = saveDailyPlanToDB(user, tableName, dataList);
								message.append(rts);
							}
						}
					}else{
						message.append("导入文件表头格式不符!");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		responseDTO.setValue("message", message.toString());
		return responseDTO;
	}
	
	private boolean checkLineCompletedFileHeader(String build_method ,Row row){
		//二维比较前12项,三维比较前5项
		boolean result = true;
		Map columns = this.getLineCompletedHeader(build_method);
		int templateCols = columns.size();
		int physicalCols = row.getPhysicalNumberOfCells();
		if(physicalCols != templateCols){
			result = false;
		}else{
			for(int m=0; m<physicalCols; m++){
				Cell cell = row.getCell(m);
				cell.setCellType(1);
				String cellValue = cell.getStringCellValue().trim().toUpperCase();
				String columnName = (String)columns.get((m+1)+"");
				if(!columnName.equals(cellValue)){
					result = false;
					break;
				}
			}
		}
		return result;
	}
	
	private Map getLineCompletedHeader(String build_method){
		Map columnMap = new HashMap();
		if("5000100003000000001".equals(build_method) || "5000100003000000004".equals(build_method)){
			//有钻井
			columnMap.put("1", "日期");
			columnMap.put("2", "测量计划日效(KM)");
			columnMap.put("3", "钻井计划日效(个)");
			columnMap.put("4", "采集计划日效(炮)");
	
		}else {
			columnMap.put("1", "日期");
			columnMap.put("2", "测量计划日效(KM)");
			columnMap.put("3", "采集计划日效(炮)");
		}
		return columnMap;
	}
	
	public String saveDailyPlanToDB(UserToken user, String tableName ,List<Map> dataList) throws Exception{
		StringBuffer writeDBMessage = new StringBuffer();
		RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String deleteSql = "update "+tableName+" p set p.bsflag = '1' where p.project_info_no = '"+user.getProjectInfoNo()+"'";		
		try{
			jdbcDao.executeUpdate(deleteSql);
		}catch(Exception e){
			writeDBMessage.append("清除已有数据失败!");
			return writeDBMessage.toString();
		}
		// 修改为批量导入
		if(dataList != null && dataList.size() > 0){
			List<Map> newList = new ArrayList<Map>();
			for(int i=0; i <dataList.size(); i++){
				Map map = dataList.get(i);
				map.put("project_info_no", user.getProjectInfoNo());
				map.put("bsflag", "0");
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("pro_plan_id", jdbcDao.generateUUID());
				if(map != null){
					newList.add(map);
				}
			}
			DBDataService dbSrv = new DBDataService();
			List strSqlList = dbSrv.mapsToBatchInsertSql(newList, tableName);
			
			int insertResult = dbSrv.executeBatchSql(strSqlList);
			if(insertResult < 0){
				writeDBMessage.append("导入计划日效失败!");
				return writeDBMessage.toString();
			}else{
				writeDBMessage.append("导入计划日效成功!");
				return writeDBMessage.toString();
			}
		}
		return writeDBMessage.toString();
	}
	
	/**
	 * 根据项目编号查询项目类型
	  * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectTypeByProjectInfoNo(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String project_info_no = reqDTO.getValue("project_info_no") ;
		if(!StringUtil.isBlank(project_info_no)){
			String sql = "select project_type from gp_task_project where project_info_no = '"+project_info_no+"' ";
			Map project = jdbcDao.queryRecordBySQL(sql);
			if(MapUtils.isNotEmpty(project)){
				Object project_type_obj = project.get("projectType") ;
				if(project_type_obj!=null && project_type_obj!=""){
					msg.setValue("project_type", project_type_obj.toString());
				}
			}
		}
		return msg;
	}
	

	/**
	 * 根据项目类型查询生产日报对应的表名和表主键
	 * @param project_type
	 * @return 返回项目类型编码
	 */
	public Map<String,String> getDailyReportTableNameAndPkNameByProjectType (String project_type){
		Map map = new HashMap();
		String tableName="";
		String tablePk="";
		if(!StringUtil.isBlank(project_type)){
			if(project_type.equals("5000100004000000001")){ // 陆地项目
				tableName="gp_ops_daily_report" ;
				tablePk="daily_no";
			}else if(project_type.equals("5000100004000000002")){ // 浅海项目
				tableName="gp_ops_daily_report" ;
				tablePk="daily_no";
			}else if(project_type.equals("5000100004000000003")){ // 非地震项目
				tableName="" ;
				tablePk="";
			}else if(project_type.equals("5000100004000000004")){ // ××项目
				tableName="" ;
				tablePk="";
			}else if(project_type.equals("5000100004000000005")){ // 地震项目
				tableName="" ;
				tablePk="";
			}else if(project_type.equals("5000100004000000006")){ // 深海项目
				tableName="gp_ops_daily_report" ;
				tablePk="daily_no";
			}else if(project_type.equals("5000100004000000007")){ // 陆地和浅海项目
				tableName="" ;
				tablePk="";
			}else if(project_type.equals("5000100004000000008")){ // 井中地震项目
				tableName="gp_ops_daily_report_ws" ;
				tablePk="daily_no_ws" ;
			}else if(project_type.equals("5000100004000000009")){// 综合物化探项目
				tableName="gp_ops_daily_report_wt" ;
				tablePk="";
			}else if(project_type.equals("5000100004000000010")){// 滩浅海地震项目
				tableName="gp_ops_daily_report" ;
				tablePk="daily_no";
			}
		}
		map.put("tableName", tableName) ;
		map.put("tablePk", tablePk) ;
		return map ;
	}
	
	/**
	 * 获取项目的施工队伍
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectTeamName(ISrvMsg reqDTO) throws Exception{
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		//如果队伍都在一条记录里,如下
		  ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
	      String getTeamSql = "select d.org_id from gp_task_project_dynamic d where d.bsflag = '0' and d.project_info_no = '"+projectInfoNo+"'";
	      Map projectInfoMap = radDao.queryRecordBySQL(getTeamSql);
	      if(projectInfoMap != null){
	    	  String teamName = "";
	    	  String orgIdParmas = "";
	    	  String orgId = projectInfoMap.get("org_id").toString();
	    	  String[] orgIds = orgId.split(",");
	    	  int orgLength = orgIds.length;
	    	  if(orgLength == 1){
	    		  String getTeamNameSlq = "select i.org_name from comm_org_information i where i.bsflag = '0' and i.org_id = '"+orgId+"'";
	    		  Map teamNameMap = radDao.queryRecordBySQL(getTeamNameSlq);
	    		  if(teamNameMap != null){
	    			  teamName = teamNameMap.get("org_name").toString();
	    		  }
	    	  }else if(orgLength >= 2){
	    		  for(int i=0;i<orgLength;i++){
	    			  orgIdParmas += ",'"+orgIds[i]+"'";
	    		  }
	    		  orgIdParmas = orgIdParmas.substring(1, orgIdParmas.length());
	    		  String getTeamNameSlq = "select wm_concat(i.org_abbreviation) as teams from comm_org_information i where i.bsflag = '0' and i.org_id in ("+orgIdParmas+")";
	    		  Map teamNameMap = radDao.queryRecordBySQL(getTeamNameSlq);
	    		  if(teamNameMap != null){
	    			  teamName = teamNameMap.get("teams").toString();
	    		  }
	    	  }
	    	  
	      	msg.setValue("teamName", teamName);
	      }
		
        return msg;
	}
}
