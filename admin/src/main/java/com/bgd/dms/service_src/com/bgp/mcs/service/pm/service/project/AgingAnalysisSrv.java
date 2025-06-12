package com.bgp.mcs.service.pm.service.project;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.ws.pm.service.dailyReport.MethodWorkloadUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class AgingAnalysisSrv extends BaseService {
	/**
	 * 综合化物探时效分析
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg multipleReadDailyReport(ISrvMsg reqDTO) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		WorkMethodSrv wm = new WorkMethodSrv();
		String	workmethod = wm.getProjectWorkMethod(projectInfoNo);
		//查询录入日报信息的所有勘探方法
		String exmethodsSql ="SELECT EXPLORATION_METHOD FROM GP_OPS_DAILY_REPORT_ZB where PROJECT_INFO_NO='"+projectInfoNo+"' group by EXPLORATION_METHOD "; 
		//按项目和勘探方法查询，取
		List resultRecord = jdbcDAO.queryRecords(exmethodsSql);
		List<Map> resultList = new ArrayList<Map>(); 
		String reportStartDateSql = "SELECT min(PRODUCE_DATE) as produce_date FROM GP_OPS_DAILY_REPORT_ZB where PROJECT_INFO_NO='"+projectInfoNo+"'";
		String reportStartDate = "";
		Map reportStartDateObj = jdbcDAO.queryRecordBySQL(reportStartDateSql);
		if(reportStartDateObj!=null){
			reportStartDate = (String)reportStartDateObj.get("produce_date");
		}
		if(resultRecord!=null&&resultRecord.size()>0){
			//总的结果
			

			for(int i=0;i<resultRecord.size();i++){
				
				Map exMethodMap = (Map) resultRecord.get(i);
				String exMethod = (String) exMethodMap.get("exploration_method");
				if(!"5110000056000000045".equals(exMethod)){
				//查询坐标点
				String wtWorkLoadSql = "select a.location_point, a.line_length,a.line_unit from gp_wt_workload a  where a.project_info_no = '"+projectInfoNo+"' and a.exploration_method='"+exMethod+"'";
				Map wtWorkLoadObj = jdbcDAO.queryRecordBySQL(wtWorkLoadSql);
				String loctionPoint = (String)wtWorkLoadObj.get("location_point");
				String lineLength = (String)wtWorkLoadObj.get("line_length");
				
				//每个勘探方法一条
				Map<String, Object> resultMap = new HashMap<String, Object>();
				//查询该勘探方法下的日报列表
				String dailyReportSql="select a.* ,b.CODING_NAME from GP_OPS_DAILY_REPORT_ZB a,COMM_CODING_SORT_DETAIL b where a.PROJECT_INFO_NO='"+projectInfoNo+"' and a.EXPLORATION_METHOD!='5110000056000000045' and a.EXPLORATION_METHOD='"+exMethod+"' and b.CODING_CODE_ID=a.EXPLORATION_METHOD";
				List dailyReportObjList = jdbcDAO.queryRecords(dailyReportSql);
				String exMethodName="";
				String startDate = "";
				String dailyEndDate="";
				String endDate = "";
				String teamName="";
				//工作量，坐标点，检查点，物理点
				double daily_workload = 0.0;
				double daily_coordinate_point = 0.0;
				double daily_check_point = 0.0;
				double daily_physical_point = 0.0;
				int allDay = 0;
				int produceDay = 0;
				int stopDay = 0;
				int suspendDay=0;
				//仪器因素	人员因素	气候因素	工农协调因素	油公司因素 其他
				

				int stopInstrumentDay = 0;
				int stopPersonnelDay = 0;
				int stopSituationDay = 0;
				int stopWorkFarmerDay = 0;
				int stopOilDay = 0;
				int stopOtherDay = 0;
				
				int suspendInstrumentDay = 0;
				int suspendPersonnelDay = 0;
				int suspendSituationDay = 0;
				int suspendWorkFarmerDay = 0;
				int suspendOilDay = 0;
				int suspendOtherDay = 0;
				
				double teamWorkLoad = 0.0;
				double teamPhysical =0.0;
				
				double workUse = 0.0;
				double phyUse = 0.0;
				
				double rework = 0.0;
				double complete = 0.0;
				
				//返工点
				double reworkPoint = 0.0;
				

				List<String> dateList2 = new ArrayList<String>();
				
				if(dailyReportObjList!=null&&dailyReportObjList.size()>0){
					//取勘探方法的最小日期
					String minReportSql = "select * from GP_OPS_DAILY_REPORT_ZB a where a.PRODUCE_DATE = "
							 		+"(SELECT min(PRODUCE_DATE) FROM GP_OPS_DAILY_REPORT_ZB  where PROJECT_INFO_NO='"+projectInfoNo+"'"
							 		+" and EXPLORATION_METHOD='"+exMethod+"') and a.EXPLORATION_METHOD='"+exMethod+"' " 
							 		+"and PROJECT_INFO_NO='"+projectInfoNo+"'";
					Map	minReportObj = jdbcDAO.queryRecordBySQL(minReportSql);
					startDate = (String)minReportObj.get("produce_date");
			
					//取勘探方法的最大日期
					String maxReportSql = "select * from GP_OPS_DAILY_REPORT_ZB a where a.PRODUCE_DATE = "
							 		+"(SELECT max(PRODUCE_DATE) FROM GP_OPS_DAILY_REPORT_ZB  where PROJECT_INFO_NO='"+projectInfoNo+"'"
							 		+" and EXPLORATION_METHOD='"+exMethod+"') and a.EXPLORATION_METHOD='"+exMethod+"' " 
							 		+"and PROJECT_INFO_NO='"+projectInfoNo+"'";
					Map	maxReportObj = jdbcDAO.queryRecordBySQL(maxReportSql);
					dailyEndDate = (String)maxReportObj.get("produce_date");	
					//如果最大日期的日报记录状态为结束，就是采集结束日期
					String taskStatus = (String)maxReportObj.get("task_status");	
					if("4".equals(taskStatus)){
						endDate = dailyEndDate;
					}
					for(int j=0;j<dailyReportObjList.size();j++){
						Map dailyReportObj = (Map) dailyReportObjList.get(j);
						
						 exMethodName = (String)dailyReportObj.get("coding_name");


							//查询勘探队名称
							String maxTeamNoSql = "select a.VSP_TEAM_NO from GP_OPS_DAILY_REPORT_ZB a where a.PROJECT_INFO_NO='"+projectInfoNo+"' and a.EXPLORATION_METHOD='"+exMethod+"' and PRODUCE_DATE="
									+"(select max(b.PRODUCE_DATE) from GP_OPS_DAILY_REPORT_ZB b"
									+" where b.PROJECT_INFO_NO='"+projectInfoNo+"' and b.EXPLORATION_METHOD='"+exMethod+"' and b.VSP_TEAM_NO!='null')";
							Map	maxTeamNoObj = jdbcDAO.queryRecordBySQL(maxTeamNoSql);
							if(maxTeamNoObj!=null){
								String teamCode = (String)maxTeamNoObj.get("vsp_team_no");	
								if(!"".equals(teamCode)){
									String teamSql = "select wm_concat(org_abbreviation) as org_name,wm_concat(org_id) as org_id from comm_org_information where org_id='"+teamCode+"' and bsflag = '0'";
									Map	teamObj = jdbcDAO.queryRecordBySQL(teamSql);
									teamName = (String)teamObj.get("org_name");
								}
							}


							
							if(dailyReportObj.get("daily_workload")!=null&&!"".equals(dailyReportObj.get("daily_workload"))){
								String a = (String) dailyReportObj.get("daily_workload");
								daily_workload +=Double.parseDouble(a);
							}
								 
							if(dailyReportObj.get("daily_coordinate_point")!=null&&!"".equals(dailyReportObj.get("daily_coordinate_point"))){
								String b = (String) dailyReportObj.get("daily_coordinate_point");
								daily_coordinate_point +=Double.parseDouble(b);
							}
							if(dailyReportObj.get("daily_check_point")!=null&&!"".equals(dailyReportObj.get("daily_check_point"))){
								String c = (String) dailyReportObj.get("daily_check_point");
								daily_check_point +=Double.parseDouble(c);

							}
							if(dailyReportObj.get("daily_physical_point")!=null&&!"".equals(dailyReportObj.get("daily_physical_point"))){
								String d = (String) dailyReportObj.get("daily_physical_point");
								daily_physical_point +=Double.parseDouble(d);
							}
							
							if(dailyReportObj.get("daily_rework_point")!=null&&!"".equals(dailyReportObj.get("daily_rework_point"))){
								String e = (String) dailyReportObj.get("daily_rework_point");
								reworkPoint +=Double.parseDouble(e);
							}
							
							dateList2.add((String)dailyReportObj.get("produce_date"));
							Date end  = sdf.parse(dailyEndDate);
							Date start  = sdf.parse(startDate);
							long t = (end.getTime() - start.getTime()) / (3600 * 24 * 1000);
							allDay = (int) t+1;

							
							//状态
							 String taskStatu = (String)dailyReportObj.get("task_status");
							 
							 String stopReason = (String)dailyReportObj.get("stop_reason");//停工因数
							 String pauseReason = (String)dailyReportObj.get("pause_reason");//暂停因数
					 
					 
						 	if("1".equals(taskStatu)){
						 		produceDay++;
						 	}else if("2".equals(taskStatu)){ //停工
							 	stopDay++;
								 if("1".equals(stopReason)){
									 stopInstrumentDay++;
								 }else if("2".equals(stopReason)){
									 stopPersonnelDay++;
								 }else if("3".equals(stopReason)){
									 stopSituationDay++;
								 }else if("4".equals(stopReason)){
									 stopWorkFarmerDay++;
								 }else if("5".equals(stopReason)){
									 stopOilDay++;
								 }else{
									 stopOtherDay++; 
								 }
							 }else if("3".equals(taskStatu)){ //暂停工
								 suspendDay++;
								 if("1".equals(pauseReason)){
									 suspendInstrumentDay++;
								 }else if("2".equals(pauseReason)){
									 suspendPersonnelDay++;
								 }else if("3".equals(pauseReason)){
									 suspendSituationDay++;
								 }else if("4".equals(pauseReason)){
									 suspendWorkFarmerDay++;
								 }else if("5".equals(pauseReason)){
									 suspendOilDay++;
								 }else{
									 suspendOtherDay++; 
								 }
							 }
	
						 	double dailyWorkload = 0.0;
						 	double dailyPhysicalPoint = 0.0;
						 	double dailyInstrumentUse = 0.0;
							//（每天工作量/当天使用仪器数量）
							if(dailyReportObj.get("daily_workload")!=null&&!"".equals(dailyReportObj.get("daily_workload"))){
								String x = (String) dailyReportObj.get("daily_workload");
								dailyWorkload = Double.parseDouble(x);
							}
								 
							//（每天物理点/当天使用仪器数量）
							if(dailyReportObj.get("daily_physical_point")!=null&&!"".equals(dailyReportObj.get("daily_physical_point"))){
								String y = (String) dailyReportObj.get("daily_physical_point");
								dailyPhysicalPoint = Double.parseDouble(y);
							}
								
							
							if(dailyReportObj.get("daily_instrument_use")!=null&&!"".equals(dailyReportObj.get("daily_instrument_use"))){
								String z = (String) dailyReportObj.get("daily_instrument_use");
								dailyInstrumentUse = Double.parseDouble(z);
							}
	
							if(dailyInstrumentUse!=0){
								workUse += dailyWorkload/dailyInstrumentUse;
								phyUse +=dailyPhysicalPoint/dailyInstrumentUse;
							}
	
					}
					

				}
				
				//获取日期集合。。去掉存在的日期。查询所有不存在的日期数据zb.
				List<String> dateList = new ArrayList<String>();
				Calendar cal=Calendar.getInstance();
				Date start = sdf.parse(startDate);
				Date end = sdf.parse(dailyEndDate);
				Date date = start;
				while (date.getTime()<=end.getTime()){
					dateList.add(sdf.format(date));  
						cal.setTime(date);   
						cal.add(Calendar.DATE, 1);//增加一天   
						date=cal.getTime();
			     }
			 dateList.removeAll(dateList2);
			 StringBuffer sb = new StringBuffer();
			 List<Map> otherList = null;
			 if(dateList!=null&&dateList.size()>0){
				 for(int f=0;f<dateList.size();f++){
					 String dateString = dateList.get(f);
					 sb.append("to_date('"+dateString+"','yyyy-MM-dd'),");
				 }
				String daString =  sb.substring(0, sb.length()-1);
				String sql = "select *　from gp_ops_daily_report_wt a where a.PROJECT_INFO_NO='"+projectInfoNo+"' and PRODUCE_DATE in("+daString+")";
				 otherList =  jdbcDAO.queryRecords(sql);
			 }

			 

			 if(otherList!=null&&otherList.size()>0){
				 for(int g=0;g<otherList.size();g++){
					 Map otherDailyObj = otherList.get(g);
					 String if_build = (String)otherDailyObj.get("if_build");
					 String stops = (String)otherDailyObj.get("stop_reason");
					 if("9".equals(if_build)){
						 	stopDay++;
						 if("1".equals(stops)){
							 stopInstrumentDay++;
						 }else if("2".equals(stops)){
							 stopPersonnelDay++;
						 }else if("3".equals(stops)){
							 stopSituationDay++;
						 }else if("4".equals(stops)){
							 stopWorkFarmerDay++;
						 }else if("5".equals(stops)){
							 stopOilDay++;
						 }else{
							 stopOtherDay++; 
						 }
					 }
					 
				 }
			 }
				
			 String unitSql = "select EXPLORATION_METHOD,LINE_UNIT from gp_wt_workload t where t.project_info_no='"+projectInfoNo+"'";
			 List<Map> unitObj = jdbcDAO.queryRecords(unitSql);
			 if(unitObj!=null&&!"".equals(unitObj)){
				 for(int w=0;w<unitObj.size();w++){
					Map unitMap = unitObj.get(w);
					String exCode = (String)unitMap.get("exploration_method");
					if(exMethod.equals(exCode)){
						String lineUnit = (String)unitMap.get("line_unit");
						if(lineUnit!=null&&!"".equals(lineUnit)){
							resultMap.put("lineUnit",lineUnit);
						}
					}


				 }
			 }
			
				resultMap.put("exMethodName", exMethodName);
				resultMap.put("teamName", teamName);
				resultMap.put("startDate", startDate);
				resultMap.put("dailyEndDate", dailyEndDate);
				resultMap.put("endDate", endDate);
				
				resultMap.put("daily_workload", daily_workload);
				resultMap.put("daily_coordinate_point", daily_coordinate_point);
				resultMap.put("daily_check_point", daily_check_point);
				resultMap.put("daily_physical_point", daily_physical_point);
				
				resultMap.put("allDay", allDay);
				resultMap.put("produceDay", produceDay);

				
				resultMap.put("stopInstrumentDay", stopInstrumentDay);
				resultMap.put("stopPersonnelDay", stopPersonnelDay);
				resultMap.put("stopSituationDay", stopSituationDay);
				resultMap.put("stopWorkFarmerDay", stopWorkFarmerDay);
				resultMap.put("stopOilDay", stopOilDay);
				stopOtherDay = allDay-produceDay-suspendDay-(stopInstrumentDay+stopPersonnelDay+stopSituationDay+stopWorkFarmerDay+stopOilDay);
				resultMap.put("stopOtherDay", stopOtherDay);
				stopDay = stopInstrumentDay+stopPersonnelDay+stopSituationDay+stopWorkFarmerDay+stopOilDay+stopOtherDay;
				
				
				resultMap.put("stopDay", stopDay);
				resultMap.put("suspendDay", suspendDay);
				
				resultMap.put("suspendInstrumentDay", suspendInstrumentDay);
				resultMap.put("suspendPersonnelDay", suspendPersonnelDay);
				resultMap.put("suspendSituationDay", suspendSituationDay);
				resultMap.put("suspendWorkFarmerDay", suspendWorkFarmerDay);
				resultMap.put("suspendOilDay", suspendOilDay);
				resultMap.put("suspendOtherDay", suspendOtherDay);
				double singleWorkLoad = 0;
				double singlePhysical = 0;
				
				if(produceDay+stopDay!=0){
					teamWorkLoad=daily_workload/(produceDay+stopDay);
					teamWorkLoad= Math.round(teamWorkLoad*100)/100.0;
					teamPhysical=daily_physical_point/(produceDay+stopDay);
					teamPhysical= Math.round(teamPhysical*100)/100.0;


					singleWorkLoad = workUse/(produceDay+stopDay);
					singleWorkLoad= Math.round(singleWorkLoad*100)/100.0;

				    singlePhysical = phyUse/(produceDay+stopDay);
				    singlePhysical= Math.round(singlePhysical*100)/100.0;

				}
				resultMap.put("teamWorkLoad", teamWorkLoad);
				resultMap.put("teamPhysical", teamPhysical);
				resultMap.put("singleWorkLoad", singleWorkLoad);
				resultMap.put("singlePhysical", singlePhysical);
				
				resultMap.put("rework", rework);
				resultMap.put("complete", complete);
				//返工率
				String reworkLv = "";
				double loction = Double.parseDouble(loctionPoint);
				double line= Double.parseDouble(lineLength);
				if(loction>0){
				 reworkLv = Math.round((reworkPoint/loction)*10000)/100.0+"";
				}
				resultMap.put("reworkLv", reworkLv);
				//完成率
				String  comLv= "";
				if(loction>0){
					comLv = Math.round((daily_coordinate_point/loction)*10000)/100.0+"";
				}else{
					if(line>0){
						comLv = Math.round((daily_workload/loction)*10000)/100.0+"";
					}
						
				}
				resultMap.put("comLv", comLv);

					
				resultList.add(resultMap);

			}
				
		}
		}
		msg.setValue("resultList", resultList);
		msg.setValue("reportStartDate", reportStartDate);
		return msg;
	}

	
	
	
	
	public ISrvMsg readDailyReport(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		Map resultRecord = new HashMap();
		Map surveyResultRecord = new HashMap();
		
		//获取项目施工方法
		WorkMethodSrv wm = new WorkMethodSrv();
		String	workmethod = wm.getProjectWorkMethod(projectInfoNo);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		//读取项目日报最早、最后时间
		//String queryDate = "select min(send_date) as min_date ,max(send_date) as max_date from rpt_gp_daily where project_info_no = '" + projectInfoNo + "'";
		String queryDate = "select acquire_start_time as min_date ,acquire_end_time as max_date from gp_task_project where project_info_no = '" + projectInfoNo + "' and bsflag ='0' ";
		resultRecord = jdbcDAO.queryRecordBySQL(queryDate);
		String projectStartDate = null;
		String projectEndDate = null;
		if(resultRecord != null){
			//projectStartDate = "" + resultRecord.get("min_date");
			projectEndDate = "" + resultRecord.get("max_date");
		}
		//读取测量的开始时间，作为日效分析的开始时间
		String surveyStartDate = "select min(r.produce_date) as min_date from gp_ops_daily_report r join gp_ops_daily_produce_sit s on r.daily_no = s.daily_no where r.bsflag = '0' and s.bsflag = '0' and r.audit_status = '3' and s.if_build = '4' and r.project_info_no = '"+projectInfoNo+"'";
		surveyResultRecord = jdbcDAO.queryRecordBySQL(surveyStartDate);
		if(surveyResultRecord != null){
			projectStartDate = "" + surveyResultRecord.get("min_date");
		}
		
		if(projectStartDate == null || projectEndDate == null){
			return msg;
		}
		
		//读取项目(采集)日报最早、最后时间
		queryDate = "select min(send_date) as min_date ,max(send_date) as max_date from rpt_gp_daily where project_info_no = '" + projectInfoNo + "' and (work_status='采集' or work_status='结束')";
		resultRecord = jdbcDAO.queryRecordBySQL(queryDate);
		String reportStartDate = null;
		String reportEndDate = null;
		if(resultRecord != null){
			reportStartDate = "" + resultRecord.get("min_date");
			reportEndDate = "" + resultRecord.get("max_date");
		}
		if(reportStartDate == null || reportEndDate == null){
			return msg;
		}
		
		//计算日报最早日期所在周的起始日期
		int day = getDayInWeek(reportStartDate) - 1;
		String firstWeekSunday = DateOperation.afterNDays(reportStartDate, -day);
		//计算日报最后日期所在周的结束日期
		day = 7 - getDayInWeek(reportEndDate);
		String lastWeekSaturday = DateOperation.afterNDays(reportEndDate, day);
		
		//设置第一周的起始结束日期
		String weekStartDate = firstWeekSunday;
		String weekEndDate = DateOperation.afterNDays(weekStartDate, 6);
		
		List<Map> datas = new ArrayList<Map>();
		
		String colName = "daily_finishing_3d_sp";
		if("0300100012000000002".equals(workmethod)){
			colName = "daily_finishing_2d_sp";
		}
		
		//总的自然天数
		long all_naturalDays = 0;
		long all_shutdown_test_days = 0;
		long all_shutdown_overhaul_days = 0;
		long all_shutdown_organization_days = 0;
		long all_shutdown_natural_days = 0;
		long all_shutdown_others = 0;
		long sum_product_natural_days = 0;
		long sum_product_standard_days = 0;
		
		long sum_max_shot_nums = 0;
		DecimalFormat df = new DecimalFormat("#.00");
		
		String sql = "";
		//循环间隔的周数
		while(DateOperation.diffDaysOfDate(lastWeekSaturday, weekEndDate) >= 0){
			Map weekData = new HashMap();
			weekData.put("week_work_start_time", weekStartDate);
			weekData.put("week_work_end_time", weekEndDate);
			
			//计算自然天数
			long naturalDays = 7;
			
			if(weekStartDate.equals(firstWeekSunday)){
				//第一周的自然天数
				naturalDays = DateOperation.diffDaysOfDate(weekEndDate,reportStartDate) + 1;
				weekData.put("week_work_start_time", reportStartDate);
			}else if(weekEndDate.equals(lastWeekSaturday)){
				//最后一周的自然天数
				naturalDays = DateOperation.diffDaysOfDate(reportEndDate,weekStartDate) + 1;
				weekData.put("week_work_end_time", reportEndDate);
			}
			all_naturalDays += naturalDays;
			weekData.put("natural_days", naturalDays);
			
			long local_shutdown_test_days = 0;
			long local_shutdown_overhaul_days = 0;
			long local_shutdown_organization_days = 0;
			long local_shutdown_natural_days = 0;
			long local_shutdown_others = 0;
			
			//读取生产、停工日数
			sql = "select nvl(count(*),0) as stop_days, s.stop_reason as stop_reason from gp_ops_daily_report d join gp_ops_daily_produce_sit s"
				+ " on s.daily_no = d.daily_no "
				+ " where d.produce_date >= to_date('" + weekData.get("week_work_start_time") +"','yyyy-MM-dd') and d.produce_date <= to_date('" + weekData.get("week_work_end_time") + "','yyyy-MM-dd')"
				+ " and project_info_no = '" + projectInfoNo + "' group by stop_reason ";
			List<Map> stopDayList = jdbcDAO.queryRecords(sql);
			if(stopDayList != null){
				for(int i=0; i<stopDayList.size(); i++){
					Map stopDayRecord = stopDayList.get(i);
					String stopReason = "" + stopDayRecord.get("stop_reason");
					String stopDays = "" + stopDayRecord.get("stop_days");
					if("1".equals(stopReason)){
						//试验停工
						local_shutdown_test_days = Long.parseLong(stopDays);
						all_shutdown_test_days += local_shutdown_test_days;
					}else if("2".equals(stopReason)){
						//检修停工
						local_shutdown_overhaul_days = Long.parseLong(stopDays);
						all_shutdown_overhaul_days += local_shutdown_overhaul_days;
					}else if("3".equals(stopReason)){
						//组织停工
						local_shutdown_organization_days = Long.parseLong(stopDays);
						all_shutdown_organization_days += local_shutdown_organization_days;
					}else if("4".equals(stopReason)){
						//自然停工
						local_shutdown_natural_days = Long.parseLong(stopDays);
						all_shutdown_natural_days += local_shutdown_natural_days;
					}else if("5".equals(stopReason)){
						//其它停工
						local_shutdown_others = Long.parseLong(stopDays);
						all_shutdown_others += local_shutdown_others;
					}
				}
			}
			weekData.put("shutdown_test_days", local_shutdown_test_days);
			weekData.put("shutdown_overhaul_days", local_shutdown_overhaul_days);
			weekData.put("shutdown_organization_days", local_shutdown_organization_days);
			weekData.put("shutdown_natural_days", local_shutdown_natural_days);
			weekData.put("shutdown_others", local_shutdown_others);
			
			long product_natural_days = 0;
			long product_standard_days = 0;
			product_natural_days = naturalDays - local_shutdown_test_days - local_shutdown_overhaul_days - local_shutdown_organization_days - local_shutdown_natural_days - local_shutdown_others;	
			product_standard_days = 3 * product_natural_days;
			
			sum_product_natural_days += product_natural_days;
			sum_product_standard_days += product_standard_days;
			
			weekData.put("product_natural_days", product_natural_days);
			weekData.put("product_standard_days", product_standard_days);
			
			//读取炮数
			sql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('" + weekData.get("week_work_start_time") + "','yyyy-MM-dd') and send_date <= to_date('" + weekData.get("week_work_end_time") + "','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
			resultRecord = jdbcDAO.queryRecordBySQL(sql);
			long shot_nums = 0;
			if(resultRecord != null){
				shot_nums =  new Long("" + resultRecord.get("shot_nums"));
			}
			weekData.put("product_shot_num",shot_nums);
			
			//begin计算截止到本周的项目平均日效
			double local_project_avg_daily_activity = 0;
			
			//读取截止到本周的项目总炮数
			String localSql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('"+reportStartDate+"','yyyy-MM-dd') and send_date <= to_date('"+weekData.get("week_work_end_time")+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
			resultRecord = jdbcDAO.queryRecordBySQL(localSql);
			long local_shot_nums = 0;
			if(resultRecord != null){
				local_shot_nums = new Long("" + resultRecord.get("shot_nums"));
			}
			//之前的计算方式
			//读取截止到本周项目总天数
			//long local_collDays = DateOperation.diffDaysOfDate(weekData.get("week_work_end_time").toString(), projectStartDate);
			//if(local_collDays >= 0){
			//	local_collDays = local_collDays + 1;
			//}
			//项目总天数需要减去停工天数
			//sql = "select nvl(count(*),0) as coll_days from rpt_gp_daily where send_date >= to_date('" + projectStartDate + "','yyyy-MM-dd') and send_date <= to_date('" + weekData.get("week_work_end_time") + "','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"' and (work_status='采集' or work_status='结束')";
			//resultRecord = jdbcDAO.queryRecordBySQL(sql);
			
			//计算到本周末为止的项目天数，新方式
			String project_days_sql = "select nvl((to_date('"+weekEndDate+"','yyyy-MM-dd')-min(r.produce_date)),0)+1 as coll_days from gp_ops_daily_report r join gp_ops_daily_produce_sit s on r.daily_no = s.daily_no where r.bsflag = '0' and s.bsflag = '0' and r.audit_status = '3' and s.if_build = '4' and r.project_info_no = '"+projectInfoNo+"'";
			System.out.println("project_days_sql is:"+project_days_sql);
			resultRecord = jdbcDAO.queryRecordBySQL(project_days_sql);
			
			long local_collDays = 0;
			if(resultRecord != null){
				//local_collDays =  new Long("" + resultRecord.get("coll_days"));//没减去停工天数
				local_collDays =  new Long("" + resultRecord.get("coll_days"))-local_shutdown_test_days-local_shutdown_overhaul_days-local_shutdown_organization_days-local_shutdown_natural_days-local_shutdown_others;
			}
			
			if(local_collDays !=0){
				local_project_avg_daily_activity = (double)local_shot_nums / (double)local_collDays;
			}
			//end计算截止到本周项目平均日效
			weekData.put("project_avg_daily_activity",df.format(local_project_avg_daily_activity));
			
			//计算周采集平均日效
			double acq_avg_daily_activity = 0;
			//读取项目总采集天数
			sql = "select nvl(count(*),0) as coll_days from rpt_gp_daily where send_date >= to_date('" + weekData.get("week_work_start_time") + "','yyyy-MM-dd') and send_date <= to_date('" + weekData.get("week_work_end_time") + "','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"' and (work_status='采集' or work_status='结束')";
			resultRecord = jdbcDAO.queryRecordBySQL(sql);
			long collDays = 1;
			if(resultRecord != null){
				collDays =  new Long("" + resultRecord.get("coll_days"));
			}
			if(collDays !=0){
				acq_avg_daily_activity = (double)shot_nums / (double)collDays;
			}
			weekData.put("acq_avg_daily_activity", df.format(acq_avg_daily_activity));
			
			//查询周采集最高日效
			sql = "select nvl(max("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('"+weekData.get("week_work_start_time")+"','yyyy-MM-dd') and send_date <= to_date('"+weekData.get("week_work_end_time")+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"' and (work_status='采集' or work_status='结束')";
			resultRecord = jdbcDAO.queryRecordBySQL(sql);
			long max_shot_nums = 0;
			if(resultRecord != null){
				max_shot_nums =  new Long("" + resultRecord.get("shot_nums"));
			}
			if(max_shot_nums > sum_max_shot_nums){
				sum_max_shot_nums = max_shot_nums;
			}
			weekData.put("acq_max_daily_activity",max_shot_nums);
			
			datas.add(weekData);
			weekStartDate = DateOperation.afterNDays(weekStartDate, 7);
			weekEndDate = DateOperation.afterNDays(weekEndDate, 7);
		}
		
		//begin计算项目开始到结束的平均日效
		double project_avg_daily_activity = 0;
		
		//读取项目总炮数
		sql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('"+reportStartDate+"','yyyy-MM-dd') and send_date <= to_date('"+reportEndDate+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
		resultRecord = jdbcDAO.queryRecordBySQL(sql);
		long all_shot_nums = 0;
		if(resultRecord != null){
			all_shot_nums = new Long("" + resultRecord.get("shot_nums"));
		}
		//读取项目总天数(项目开始到结束的天数)
		
		String project_days_sql = "select nvl((to_date('"+weekEndDate+"','yyyy-MM-dd')-min(r.produce_date)),0)+1 as coll_days from gp_ops_daily_report r join gp_ops_daily_produce_sit s on r.daily_no = s.daily_no where r.bsflag = '0' and s.bsflag = '0' and r.audit_status = '3' and s.if_build = '4' and r.project_info_no = '"+projectInfoNo+"'";
		System.out.println("project_days_sql is:"+project_days_sql);
		
		//旧方式
		//sql = "select nvl(count(*),0) as coll_days from rpt_gp_daily where project_info_no = '"+ projectInfoNo+"' and (work_status='采集' or work_status='结束')";
		//resultRecord = jdbcDAO.queryRecordBySQL(sql);
		resultRecord = jdbcDAO.queryRecordBySQL(project_days_sql);
		
		long all_collDays = 1;
		if(resultRecord != null){
			//all_collDays =  new Long("" + resultRecord.get("coll_days"));
			all_collDays =  new Long("" + resultRecord.get("coll_days"))-all_shutdown_test_days-all_shutdown_overhaul_days-all_shutdown_organization_days-all_shutdown_natural_days-all_shutdown_others;
		}
		if(all_collDays !=0){
			project_avg_daily_activity = (double)all_shot_nums / (double)all_collDays;
		}
		
		//end计算项目平均日效
		
		//计算项目采集平均日效
		double project_acq_avg_daily_activity = 0;
		//读取项目总采集天数
		sql = "select nvl(count(*),0) as coll_days from rpt_gp_daily where send_date >= to_date('"+reportStartDate+"','yyyy-MM-dd') and send_date <= to_date('"+reportEndDate+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"' and (work_status='采集' or work_status='结束')";
		resultRecord = jdbcDAO.queryRecordBySQL(sql);
		long porjectCollDays = 1;
		if(resultRecord != null){
			porjectCollDays =  new Long("" + resultRecord.get("coll_days"));
		}
		if(porjectCollDays !=0){
			project_acq_avg_daily_activity = (double)all_shot_nums / (double)porjectCollDays;
		}		
		
		if(datas.size() > 0){
			Map sumData = new HashMap();
			sumData.put("week_work_start_time", reportStartDate);
			sumData.put("week_work_end_time", reportEndDate);
			sumData.put("natural_days", all_naturalDays);
			//todo汇总生产、停工日数
			sumData.put("product_natural_days", sum_product_natural_days);
			sumData.put("product_standard_days", sum_product_standard_days);
			sumData.put("shutdown_test_days", all_shutdown_test_days);
			sumData.put("shutdown_overhaul_days", all_shutdown_overhaul_days);
			sumData.put("shutdown_organization_days", all_shutdown_organization_days);
			sumData.put("shutdown_natural_days", all_shutdown_natural_days);
			sumData.put("shutdown_others", all_shutdown_others);
			sumData.put("product_shot_num",all_shot_nums);
			sumData.put("project_avg_daily_activity",df.format(project_avg_daily_activity));
			sumData.put("acq_avg_daily_activity",df.format(project_acq_avg_daily_activity));
			sumData.put("acq_max_daily_activity",sum_max_shot_nums);
			datas.add(sumData);
		}
		msg.setValue("projectStartDate", projectStartDate);
		msg.setValue("datas", datas);
		return msg;
	}
	
	public static int getDayInWeek(String sDate){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		int day = 0;
		if(!"".equals(sDate)){
			try{ 
				Date date = sdf.parse(sDate);
				Calendar cal = Calendar.getInstance();
		        cal.setTime(date);
		        day = cal.get(Calendar.DAY_OF_WEEK);
			}catch (ParseException e) {
				e.printStackTrace();
			}
		}
        return day;
	}
	
//	public static void main(String[] args){
//		
//	}
	public ISrvMsg readShDailyReport(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		//读取项目(采集)日报日期列表
		String queryDate = "select to_char(min(produce_date),'yyyy-mm-dd') min_date,to_char(max(produce_date),'yyyy-mm-dd') max_date from gp_ops_daily_report where project_info_no = '" + projectInfoNo + "' and audit_status = '3' and bsflag = '0' order by produce_date";
		Map map = jdbcDAO.queryRecordBySQL(queryDate);
		String reportStartDate = "";
		String reportEndDate = "";
		if(map != null && map.size()!=0){
			reportStartDate = map.get("min_date").toString();
			reportEndDate = map.get("max_date").toString();
			if(reportStartDate == null || reportEndDate == null){
				return msg;
			}
		}
		
		
		//计算日报最早日期所在周的起始日期
		int day = getDayInWeek(reportStartDate) - 1;
		String firstWeekSunday = DateOperation.afterNDays(reportStartDate, -day);
		//计算日报最后日期所在周的结束日期
		day = 7 - getDayInWeek(reportEndDate);
		String lastWeekSaturday = DateOperation.afterNDays(reportEndDate, day);
		
		//设置第一周的起始结束日期
		String weekStartDate = firstWeekSunday;
		String weekEndDate = DateOperation.afterNDays(weekStartDate, 6);
		
		List<Map> datas = new ArrayList<Map>();
		//循环间隔的周数
		while(DateOperation.diffDaysOfDate(lastWeekSaturday, weekEndDate) >= 0){
			Map weekData = new HashMap();
			weekData.put("week_work_start_time", weekStartDate);
			weekData.put("week_work_end_time", weekEndDate);
			//计算自然天数
			long naturalDays = 7;
			if(weekStartDate.equals(firstWeekSunday)){
				//第一周的自然天数
				naturalDays = DateOperation.diffDaysOfDate(weekEndDate,reportStartDate) + 1;
				weekData.put("week_work_start_time", reportStartDate);
			}else if(weekEndDate.equals(lastWeekSaturday)){
				//最后一周的自然天数
				naturalDays = DateOperation.diffDaysOfDate(reportEndDate,weekStartDate) + 1;
				weekData.put("week_work_end_time", reportEndDate);
			}
			
			weekData.put("natural_days", naturalDays);
			String startDate = weekData.get("week_work_start_time").toString();
			String endDate = weekData.get("week_work_end_time").toString();
			
			String sql =" select " +
					" sum(nvl(r.daily_qq_acquire_workload,0)) workload_sum," + //生产量 
					" round(avg(nvl(r.daily_qq_acquire_workload,0)),1) workload_avg," + //采集平均日效
					" max(nvl(r.daily_qq_acquire_workload,0)) workload_max, " + //采集最高日效
					" sum(nvl(t.day_check_time,0))            day_check_time," +
					" sum(nvl(t.collect_time,0))              collect_time," +
					" sum(nvl(t.breakdown_time,0))            breakdown_time" +
					" from gp_ops_daily_report r,gp_ops_daily_produce_sit t" +
					" where project_info_no='"+projectInfoNo+"'" +
					" and r.daily_no = t.daily_no "+
					" and r.audit_status='3' " +
					" and r.bsflag='0'" +
					" and t.bsflag='0'" +
					" and r.produce_date >=to_date('"+startDate+"','yyyy-mm-dd') " +
					" and r.produce_date <=to_date('"+endDate+"','yyyy-mm-dd') order by produce_date";
			Map workLoadMap = jdbcDAO.queryRecordBySQL(sql);
			
			long day_check_time =  Long.parseLong(workLoadMap.get("day_check_time").toString())/24;//  DOWNTIME 小时数
			long collect_time = Long.parseLong(workLoadMap.get("collect_time").toString())/24;// STANDBY小时数
			long breakdown_time = Long.parseLong(workLoadMap.get("breakdown_time").toString())/24;// 停工小时数
			weekData.put("workload_sum", workLoadMap.get("workload_sum").toString());
			weekData.put("workload_avg", workLoadMap.get("workload_avg").toString());
			weekData.put("workload_max", workLoadMap.get("workload_max").toString());
			weekData.put("day_check_time",day_check_time);
			weekData.put("collect_time", collect_time);
			weekData.put("breakdown_time", breakdown_time);
			weekData.put("produce_time", naturalDays-day_check_time-collect_time);//生产天数
			String workloadSql = "select nvl(round(avg(workload),1),0) workload_plan from gp_proj_product_plan where project_info_no='"+projectInfoNo+"' and bsflag='0' and record_month>='"+startDate+"' and record_month<='"+endDate+"'";
			Map map_p = jdbcDAO.queryRecordBySQL(workloadSql);
			if(map_p!=null&&map_p.size()!=0){
				String workload_plan = map_p.get("workload_plan").toString();
				weekData.put("workload_plan", workload_plan);				
			}
			datas.add(weekData);
			weekStartDate = DateOperation.afterNDays(weekStartDate, 7);
			weekEndDate = DateOperation.afterNDays(weekEndDate, 7);
		}
		
	    msg.setValue("datas", datas);
	    
		return msg;
	
	}
}
