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
	 * �ۺϻ���̽ʱЧ����
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
		//��ѯ¼���ձ���Ϣ�����п�̽����
		String exmethodsSql ="SELECT EXPLORATION_METHOD FROM GP_OPS_DAILY_REPORT_ZB where PROJECT_INFO_NO='"+projectInfoNo+"' group by EXPLORATION_METHOD "; 
		//����Ŀ�Ϳ�̽������ѯ��ȡ
		List resultRecord = jdbcDAO.queryRecords(exmethodsSql);
		List<Map> resultList = new ArrayList<Map>(); 
		String reportStartDateSql = "SELECT min(PRODUCE_DATE) as produce_date FROM GP_OPS_DAILY_REPORT_ZB where PROJECT_INFO_NO='"+projectInfoNo+"'";
		String reportStartDate = "";
		Map reportStartDateObj = jdbcDAO.queryRecordBySQL(reportStartDateSql);
		if(reportStartDateObj!=null){
			reportStartDate = (String)reportStartDateObj.get("produce_date");
		}
		if(resultRecord!=null&&resultRecord.size()>0){
			//�ܵĽ��
			

			for(int i=0;i<resultRecord.size();i++){
				
				Map exMethodMap = (Map) resultRecord.get(i);
				String exMethod = (String) exMethodMap.get("exploration_method");
				if(!"5110000056000000045".equals(exMethod)){
				//��ѯ�����
				String wtWorkLoadSql = "select a.location_point, a.line_length,a.line_unit from gp_wt_workload a  where a.project_info_no = '"+projectInfoNo+"' and a.exploration_method='"+exMethod+"'";
				Map wtWorkLoadObj = jdbcDAO.queryRecordBySQL(wtWorkLoadSql);
				String loctionPoint = (String)wtWorkLoadObj.get("location_point");
				String lineLength = (String)wtWorkLoadObj.get("line_length");
				
				//ÿ����̽����һ��
				Map<String, Object> resultMap = new HashMap<String, Object>();
				//��ѯ�ÿ�̽�����µ��ձ��б�
				String dailyReportSql="select a.* ,b.CODING_NAME from GP_OPS_DAILY_REPORT_ZB a,COMM_CODING_SORT_DETAIL b where a.PROJECT_INFO_NO='"+projectInfoNo+"' and a.EXPLORATION_METHOD!='5110000056000000045' and a.EXPLORATION_METHOD='"+exMethod+"' and b.CODING_CODE_ID=a.EXPLORATION_METHOD";
				List dailyReportObjList = jdbcDAO.queryRecords(dailyReportSql);
				String exMethodName="";
				String startDate = "";
				String dailyEndDate="";
				String endDate = "";
				String teamName="";
				//������������㣬���㣬�����
				double daily_workload = 0.0;
				double daily_coordinate_point = 0.0;
				double daily_check_point = 0.0;
				double daily_physical_point = 0.0;
				int allDay = 0;
				int produceDay = 0;
				int stopDay = 0;
				int suspendDay=0;
				//��������	��Ա����	��������	��ũЭ������	�͹�˾���� ����
				

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
				
				//������
				double reworkPoint = 0.0;
				

				List<String> dateList2 = new ArrayList<String>();
				
				if(dailyReportObjList!=null&&dailyReportObjList.size()>0){
					//ȡ��̽��������С����
					String minReportSql = "select * from GP_OPS_DAILY_REPORT_ZB a where a.PRODUCE_DATE = "
							 		+"(SELECT min(PRODUCE_DATE) FROM GP_OPS_DAILY_REPORT_ZB  where PROJECT_INFO_NO='"+projectInfoNo+"'"
							 		+" and EXPLORATION_METHOD='"+exMethod+"') and a.EXPLORATION_METHOD='"+exMethod+"' " 
							 		+"and PROJECT_INFO_NO='"+projectInfoNo+"'";
					Map	minReportObj = jdbcDAO.queryRecordBySQL(minReportSql);
					startDate = (String)minReportObj.get("produce_date");
			
					//ȡ��̽�������������
					String maxReportSql = "select * from GP_OPS_DAILY_REPORT_ZB a where a.PRODUCE_DATE = "
							 		+"(SELECT max(PRODUCE_DATE) FROM GP_OPS_DAILY_REPORT_ZB  where PROJECT_INFO_NO='"+projectInfoNo+"'"
							 		+" and EXPLORATION_METHOD='"+exMethod+"') and a.EXPLORATION_METHOD='"+exMethod+"' " 
							 		+"and PROJECT_INFO_NO='"+projectInfoNo+"'";
					Map	maxReportObj = jdbcDAO.queryRecordBySQL(maxReportSql);
					dailyEndDate = (String)maxReportObj.get("produce_date");	
					//���������ڵ��ձ���¼״̬Ϊ���������ǲɼ���������
					String taskStatus = (String)maxReportObj.get("task_status");	
					if("4".equals(taskStatus)){
						endDate = dailyEndDate;
					}
					for(int j=0;j<dailyReportObjList.size();j++){
						Map dailyReportObj = (Map) dailyReportObjList.get(j);
						
						 exMethodName = (String)dailyReportObj.get("coding_name");


							//��ѯ��̽������
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

							
							//״̬
							 String taskStatu = (String)dailyReportObj.get("task_status");
							 
							 String stopReason = (String)dailyReportObj.get("stop_reason");//ͣ������
							 String pauseReason = (String)dailyReportObj.get("pause_reason");//��ͣ����
					 
					 
						 	if("1".equals(taskStatu)){
						 		produceDay++;
						 	}else if("2".equals(taskStatu)){ //ͣ��
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
							 }else if("3".equals(taskStatu)){ //��ͣ��
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
							//��ÿ�칤����/����ʹ������������
							if(dailyReportObj.get("daily_workload")!=null&&!"".equals(dailyReportObj.get("daily_workload"))){
								String x = (String) dailyReportObj.get("daily_workload");
								dailyWorkload = Double.parseDouble(x);
							}
								 
							//��ÿ�������/����ʹ������������
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
				
				//��ȡ���ڼ��ϡ���ȥ�����ڵ����ڡ���ѯ���в����ڵ���������zb.
				List<String> dateList = new ArrayList<String>();
				Calendar cal=Calendar.getInstance();
				Date start = sdf.parse(startDate);
				Date end = sdf.parse(dailyEndDate);
				Date date = start;
				while (date.getTime()<=end.getTime()){
					dateList.add(sdf.format(date));  
						cal.setTime(date);   
						cal.add(Calendar.DATE, 1);//����һ��   
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
				String sql = "select *��from gp_ops_daily_report_wt a where a.PROJECT_INFO_NO='"+projectInfoNo+"' and PRODUCE_DATE in("+daString+")";
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
				//������
				String reworkLv = "";
				double loction = Double.parseDouble(loctionPoint);
				double line= Double.parseDouble(lineLength);
				if(loction>0){
				 reworkLv = Math.round((reworkPoint/loction)*10000)/100.0+"";
				}
				resultMap.put("reworkLv", reworkLv);
				//�����
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
		
		//��ȡ��Ŀʩ������
		WorkMethodSrv wm = new WorkMethodSrv();
		String	workmethod = wm.getProjectWorkMethod(projectInfoNo);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		//��ȡ��Ŀ�ձ����硢���ʱ��
		//String queryDate = "select min(send_date) as min_date ,max(send_date) as max_date from rpt_gp_daily where project_info_no = '" + projectInfoNo + "'";
		String queryDate = "select acquire_start_time as min_date ,acquire_end_time as max_date from gp_task_project where project_info_no = '" + projectInfoNo + "' and bsflag ='0' ";
		resultRecord = jdbcDAO.queryRecordBySQL(queryDate);
		String projectStartDate = null;
		String projectEndDate = null;
		if(resultRecord != null){
			//projectStartDate = "" + resultRecord.get("min_date");
			projectEndDate = "" + resultRecord.get("max_date");
		}
		//��ȡ�����Ŀ�ʼʱ�䣬��Ϊ��Ч�����Ŀ�ʼʱ��
		String surveyStartDate = "select min(r.produce_date) as min_date from gp_ops_daily_report r join gp_ops_daily_produce_sit s on r.daily_no = s.daily_no where r.bsflag = '0' and s.bsflag = '0' and r.audit_status = '3' and s.if_build = '4' and r.project_info_no = '"+projectInfoNo+"'";
		surveyResultRecord = jdbcDAO.queryRecordBySQL(surveyStartDate);
		if(surveyResultRecord != null){
			projectStartDate = "" + surveyResultRecord.get("min_date");
		}
		
		if(projectStartDate == null || projectEndDate == null){
			return msg;
		}
		
		//��ȡ��Ŀ(�ɼ�)�ձ����硢���ʱ��
		queryDate = "select min(send_date) as min_date ,max(send_date) as max_date from rpt_gp_daily where project_info_no = '" + projectInfoNo + "' and (work_status='�ɼ�' or work_status='����')";
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
		
		//�����ձ��������������ܵ���ʼ����
		int day = getDayInWeek(reportStartDate) - 1;
		String firstWeekSunday = DateOperation.afterNDays(reportStartDate, -day);
		//�����ձ�������������ܵĽ�������
		day = 7 - getDayInWeek(reportEndDate);
		String lastWeekSaturday = DateOperation.afterNDays(reportEndDate, day);
		
		//���õ�һ�ܵ���ʼ��������
		String weekStartDate = firstWeekSunday;
		String weekEndDate = DateOperation.afterNDays(weekStartDate, 6);
		
		List<Map> datas = new ArrayList<Map>();
		
		String colName = "daily_finishing_3d_sp";
		if("0300100012000000002".equals(workmethod)){
			colName = "daily_finishing_2d_sp";
		}
		
		//�ܵ���Ȼ����
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
		//ѭ�����������
		while(DateOperation.diffDaysOfDate(lastWeekSaturday, weekEndDate) >= 0){
			Map weekData = new HashMap();
			weekData.put("week_work_start_time", weekStartDate);
			weekData.put("week_work_end_time", weekEndDate);
			
			//������Ȼ����
			long naturalDays = 7;
			
			if(weekStartDate.equals(firstWeekSunday)){
				//��һ�ܵ���Ȼ����
				naturalDays = DateOperation.diffDaysOfDate(weekEndDate,reportStartDate) + 1;
				weekData.put("week_work_start_time", reportStartDate);
			}else if(weekEndDate.equals(lastWeekSaturday)){
				//���һ�ܵ���Ȼ����
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
			
			//��ȡ������ͣ������
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
						//����ͣ��
						local_shutdown_test_days = Long.parseLong(stopDays);
						all_shutdown_test_days += local_shutdown_test_days;
					}else if("2".equals(stopReason)){
						//����ͣ��
						local_shutdown_overhaul_days = Long.parseLong(stopDays);
						all_shutdown_overhaul_days += local_shutdown_overhaul_days;
					}else if("3".equals(stopReason)){
						//��֯ͣ��
						local_shutdown_organization_days = Long.parseLong(stopDays);
						all_shutdown_organization_days += local_shutdown_organization_days;
					}else if("4".equals(stopReason)){
						//��Ȼͣ��
						local_shutdown_natural_days = Long.parseLong(stopDays);
						all_shutdown_natural_days += local_shutdown_natural_days;
					}else if("5".equals(stopReason)){
						//����ͣ��
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
			
			//��ȡ����
			sql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('" + weekData.get("week_work_start_time") + "','yyyy-MM-dd') and send_date <= to_date('" + weekData.get("week_work_end_time") + "','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
			resultRecord = jdbcDAO.queryRecordBySQL(sql);
			long shot_nums = 0;
			if(resultRecord != null){
				shot_nums =  new Long("" + resultRecord.get("shot_nums"));
			}
			weekData.put("product_shot_num",shot_nums);
			
			//begin�����ֹ�����ܵ���Ŀƽ����Ч
			double local_project_avg_daily_activity = 0;
			
			//��ȡ��ֹ�����ܵ���Ŀ������
			String localSql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('"+reportStartDate+"','yyyy-MM-dd') and send_date <= to_date('"+weekData.get("week_work_end_time")+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
			resultRecord = jdbcDAO.queryRecordBySQL(localSql);
			long local_shot_nums = 0;
			if(resultRecord != null){
				local_shot_nums = new Long("" + resultRecord.get("shot_nums"));
			}
			//֮ǰ�ļ��㷽ʽ
			//��ȡ��ֹ��������Ŀ������
			//long local_collDays = DateOperation.diffDaysOfDate(weekData.get("week_work_end_time").toString(), projectStartDate);
			//if(local_collDays >= 0){
			//	local_collDays = local_collDays + 1;
			//}
			//��Ŀ��������Ҫ��ȥͣ������
			//sql = "select nvl(count(*),0) as coll_days from rpt_gp_daily where send_date >= to_date('" + projectStartDate + "','yyyy-MM-dd') and send_date <= to_date('" + weekData.get("week_work_end_time") + "','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"' and (work_status='�ɼ�' or work_status='����')";
			//resultRecord = jdbcDAO.queryRecordBySQL(sql);
			
			//���㵽����ĩΪֹ����Ŀ�������·�ʽ
			String project_days_sql = "select nvl((to_date('"+weekEndDate+"','yyyy-MM-dd')-min(r.produce_date)),0)+1 as coll_days from gp_ops_daily_report r join gp_ops_daily_produce_sit s on r.daily_no = s.daily_no where r.bsflag = '0' and s.bsflag = '0' and r.audit_status = '3' and s.if_build = '4' and r.project_info_no = '"+projectInfoNo+"'";
			System.out.println("project_days_sql is:"+project_days_sql);
			resultRecord = jdbcDAO.queryRecordBySQL(project_days_sql);
			
			long local_collDays = 0;
			if(resultRecord != null){
				//local_collDays =  new Long("" + resultRecord.get("coll_days"));//û��ȥͣ������
				local_collDays =  new Long("" + resultRecord.get("coll_days"))-local_shutdown_test_days-local_shutdown_overhaul_days-local_shutdown_organization_days-local_shutdown_natural_days-local_shutdown_others;
			}
			
			if(local_collDays !=0){
				local_project_avg_daily_activity = (double)local_shot_nums / (double)local_collDays;
			}
			//end�����ֹ��������Ŀƽ����Ч
			weekData.put("project_avg_daily_activity",df.format(local_project_avg_daily_activity));
			
			//�����ܲɼ�ƽ����Ч
			double acq_avg_daily_activity = 0;
			//��ȡ��Ŀ�ܲɼ�����
			sql = "select nvl(count(*),0) as coll_days from rpt_gp_daily where send_date >= to_date('" + weekData.get("week_work_start_time") + "','yyyy-MM-dd') and send_date <= to_date('" + weekData.get("week_work_end_time") + "','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"' and (work_status='�ɼ�' or work_status='����')";
			resultRecord = jdbcDAO.queryRecordBySQL(sql);
			long collDays = 1;
			if(resultRecord != null){
				collDays =  new Long("" + resultRecord.get("coll_days"));
			}
			if(collDays !=0){
				acq_avg_daily_activity = (double)shot_nums / (double)collDays;
			}
			weekData.put("acq_avg_daily_activity", df.format(acq_avg_daily_activity));
			
			//��ѯ�ܲɼ������Ч
			sql = "select nvl(max("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('"+weekData.get("week_work_start_time")+"','yyyy-MM-dd') and send_date <= to_date('"+weekData.get("week_work_end_time")+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"' and (work_status='�ɼ�' or work_status='����')";
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
		
		//begin������Ŀ��ʼ��������ƽ����Ч
		double project_avg_daily_activity = 0;
		
		//��ȡ��Ŀ������
		sql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('"+reportStartDate+"','yyyy-MM-dd') and send_date <= to_date('"+reportEndDate+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
		resultRecord = jdbcDAO.queryRecordBySQL(sql);
		long all_shot_nums = 0;
		if(resultRecord != null){
			all_shot_nums = new Long("" + resultRecord.get("shot_nums"));
		}
		//��ȡ��Ŀ������(��Ŀ��ʼ������������)
		
		String project_days_sql = "select nvl((to_date('"+weekEndDate+"','yyyy-MM-dd')-min(r.produce_date)),0)+1 as coll_days from gp_ops_daily_report r join gp_ops_daily_produce_sit s on r.daily_no = s.daily_no where r.bsflag = '0' and s.bsflag = '0' and r.audit_status = '3' and s.if_build = '4' and r.project_info_no = '"+projectInfoNo+"'";
		System.out.println("project_days_sql is:"+project_days_sql);
		
		//�ɷ�ʽ
		//sql = "select nvl(count(*),0) as coll_days from rpt_gp_daily where project_info_no = '"+ projectInfoNo+"' and (work_status='�ɼ�' or work_status='����')";
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
		
		//end������Ŀƽ����Ч
		
		//������Ŀ�ɼ�ƽ����Ч
		double project_acq_avg_daily_activity = 0;
		//��ȡ��Ŀ�ܲɼ�����
		sql = "select nvl(count(*),0) as coll_days from rpt_gp_daily where send_date >= to_date('"+reportStartDate+"','yyyy-MM-dd') and send_date <= to_date('"+reportEndDate+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"' and (work_status='�ɼ�' or work_status='����')";
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
			//todo����������ͣ������
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
		
		//��ȡ��Ŀ(�ɼ�)�ձ������б�
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
		
		
		//�����ձ��������������ܵ���ʼ����
		int day = getDayInWeek(reportStartDate) - 1;
		String firstWeekSunday = DateOperation.afterNDays(reportStartDate, -day);
		//�����ձ�������������ܵĽ�������
		day = 7 - getDayInWeek(reportEndDate);
		String lastWeekSaturday = DateOperation.afterNDays(reportEndDate, day);
		
		//���õ�һ�ܵ���ʼ��������
		String weekStartDate = firstWeekSunday;
		String weekEndDate = DateOperation.afterNDays(weekStartDate, 6);
		
		List<Map> datas = new ArrayList<Map>();
		//ѭ�����������
		while(DateOperation.diffDaysOfDate(lastWeekSaturday, weekEndDate) >= 0){
			Map weekData = new HashMap();
			weekData.put("week_work_start_time", weekStartDate);
			weekData.put("week_work_end_time", weekEndDate);
			//������Ȼ����
			long naturalDays = 7;
			if(weekStartDate.equals(firstWeekSunday)){
				//��һ�ܵ���Ȼ����
				naturalDays = DateOperation.diffDaysOfDate(weekEndDate,reportStartDate) + 1;
				weekData.put("week_work_start_time", reportStartDate);
			}else if(weekEndDate.equals(lastWeekSaturday)){
				//���һ�ܵ���Ȼ����
				naturalDays = DateOperation.diffDaysOfDate(reportEndDate,weekStartDate) + 1;
				weekData.put("week_work_end_time", reportEndDate);
			}
			
			weekData.put("natural_days", naturalDays);
			String startDate = weekData.get("week_work_start_time").toString();
			String endDate = weekData.get("week_work_end_time").toString();
			
			String sql =" select " +
					" sum(nvl(r.daily_qq_acquire_workload,0)) workload_sum," + //������ 
					" round(avg(nvl(r.daily_qq_acquire_workload,0)),1) workload_avg," + //�ɼ�ƽ����Ч
					" max(nvl(r.daily_qq_acquire_workload,0)) workload_max, " + //�ɼ������Ч
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
			
			long day_check_time =  Long.parseLong(workLoadMap.get("day_check_time").toString())/24;//  DOWNTIME Сʱ��
			long collect_time = Long.parseLong(workLoadMap.get("collect_time").toString())/24;// STANDBYСʱ��
			long breakdown_time = Long.parseLong(workLoadMap.get("breakdown_time").toString())/24;// ͣ��Сʱ��
			weekData.put("workload_sum", workLoadMap.get("workload_sum").toString());
			weekData.put("workload_avg", workLoadMap.get("workload_avg").toString());
			weekData.put("workload_max", workLoadMap.get("workload_max").toString());
			weekData.put("day_check_time",day_check_time);
			weekData.put("collect_time", collect_time);
			weekData.put("breakdown_time", breakdown_time);
			weekData.put("produce_time", naturalDays-day_check_time-collect_time);//��������
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
