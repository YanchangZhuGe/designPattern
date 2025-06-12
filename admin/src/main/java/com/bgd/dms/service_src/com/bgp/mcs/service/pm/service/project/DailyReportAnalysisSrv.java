package com.bgp.mcs.service.pm.service.project;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.bgp.mcs.service.common.DateOperation;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class DailyReportAnalysisSrv extends BaseService {

	
	public String getExplorationMethod(String projectInfoNo) throws Exception{
		RADJdbcDao radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String exploration_method = "select p.exploration_method from gp_task_project p where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'";
		if(radDao.queryRecordBySQL(exploration_method)!=null){
			exploration_method = radDao.queryRecordBySQL(exploration_method).get("exploration_method").toString();
		}
		return exploration_method;
	}
	//深海  采集累积数据分析
	public ISrvMsg getDaysCumulativeSh(ISrvMsg reqDTO) throws Exception {
		ISrvMsg repMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		RADJdbcDao radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			return repMsg;
		}
		String type = reqDTO.getValue("type");
		if (type == null || "".equals(type)) {
			return repMsg;
		}

		String designStartDate = "";
		String designEndDate = "";
		String dailyStartDate = "";
		String dailyEndDate = "";
		String designColumn = "";
		String dailyColumn = "";
		String ifBuild = "";

		double designWorkLoad = 0;// 设计工作量
		double dailyWorkLoad = 0;// 日报工作量
		double sum_designWorkLoad = 0;// 设计工作量之和
		double sum_dailyWorkLoad = 0;// 日报工作量之和
		double sum_curDesignWorkLoad = 0;
		double sum_curDailyWorkLoad = 0;
		double avgWorkLoad = 1;// 最近7天平均工作量
		DecimalFormat df = new DecimalFormat("0.00");
		Date curDate = new Date();// 当前日期
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sCurDate = sdf.format(curDate);
		
		boolean noDailyData = false;
		
		String chatInfo = "";
		String xmlData = "";
		String taskName = "";
		String unitName = "炮";
		String endFlagColumn = "survey_process_status";
		
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			designColumn = "workload_num";
			dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
			taskName = "测量";
			ifBuild = "4";
			unitName = "km";
		} else if (type == "colldailylist" || "colldailylist".equals(type)) {
			String expMethod = reqDTO.getValue("exploration_method");
			if("0300100012000000003".equals(expMethod)){
				unitName = "平方km";
			}else{
				unitName = "km";
			}
			
			designColumn = "workload";
			dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_workload,0) ";
			taskName = "采集";
			ifBuild = "6";
			endFlagColumn = "collect_process_status";
		} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
			designColumn = "workload";
			dailyColumn = " nvl(daily_drill_sp_num,0) ";
			taskName = "钻井";
			ifBuild = "5";
			endFlagColumn = "drill_process_status";
		}

		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+
		
		//String getLastDailyDate = "select max(t.produce_date) as last_daily_date from gp_ops_daily_report t where t.bsflag = '0' and t.audit_status = '3' and t.project_info_no = '"+projectInfoNo+"'";
		//String lastDailyDate = (String) radDao.queryRecordBySQL(getLastDailyDate).get("last_daily_date");

		// 取设计起始日期、设计累积值
		String designDateSql = "select min(record_month) as min_date, max(record_month) as max_date, sum(nvl("
				+ designColumn
				+ ",0)) as sum_design_data from gp_proj_product_plan where bsflag = '0' and project_info_no = '"
				+ projectInfoNo + "'  and oper_plan_type = '" + type + "'";
		if(type == "colldailylist" || "colldailylist".equals(type)){
			designDateSql = designDateSql + " and workload is not null";
		}else if(type == "drilldailylist" || "drilldailylist".equals(type)){
			designDateSql = designDateSql + " and workload is not null";
		}else if(type == "measuredailylist" || "measuredailylist".equals(type)){
			designDateSql = designDateSql + " and workload_num is not null";
		}
		Map recordMap = radDao.queryRecordBySQL(designDateSql);
		if (recordMap != null) {
			designStartDate = "" + recordMap.get("min_date");
			designEndDate = "" + recordMap.get("max_date");
			String sumDesignNum = "" + recordMap.get("sum_design_data");
			Matcher isNum1 = pattern.matcher(sumDesignNum);
			if (isNum1.matches()) {
				sum_designWorkLoad = Double.valueOf(sumDesignNum);
			}
		}
		
		// 取日报起始日期、日报累积值
		String dailyDateSql = "select to_char(min(produce_date),'yyyy-MM-dd') as min_date,to_char(max(produce_date),'yyyy-MM-dd') as max_date, sum("
				+ dailyColumn
				+ ") as sum_daily_data from gp_ops_daily_report where project_info_no = '"
				+ projectInfoNo + "' and " + dailyColumn + " > 0 and audit_status = '3' and bsflag = '0' ";
		recordMap = radDao.queryRecordBySQL(dailyDateSql);
		if (recordMap != null) {
			dailyStartDate = "" + recordMap.get("min_date");
			dailyEndDate = "" + recordMap.get("max_date");
			String sumDailyData = "" + recordMap.get("sum_daily_data");
			Matcher isNum1 = pattern.matcher(sumDailyData);
			if (isNum1.matches()) {
				sum_dailyWorkLoad = Double.valueOf(sumDailyData);
			}
			// 没有日报数据
			if("".equals(dailyStartDate)){
				noDailyData = true;
			}
		}
		// 取截止当前的设计工作量
		String curDesignWorkloadSql = "select sum(nvl("
				+ designColumn
				+ ",0)) as sum_design_data from gp_proj_product_plan where bsflag = '0' and project_info_no = '"
				+ projectInfoNo
				+ "' and to_date(record_month,'yyyy-MM-dd') <= to_date('"
				+ dailyEndDate + "','yyyy-MM-dd') and oper_plan_type = '" + type
				+ "' and bsflag = '0' ";
		recordMap = radDao.queryRecordBySQL(curDesignWorkloadSql);
		if (recordMap != null) {
			String value = "" + recordMap.get("sum_design_data");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				sum_curDesignWorkLoad = Double.valueOf(value);
			}
		}
		// 取截止当前的实际工作量
		//String curDailyWorkloadSql = "select sum("
		//		+ dailyColumn
		//		+ ") as sum_daily_data from gp_ops_daily_report r join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' and sit.if_build = '"+ifBuild+"' where project_info_no = '"
		//		+ projectInfoNo + "' and " + dailyColumn
		//		+ " > 0 and produce_date <= to_date('" + dailyEndDate
		//		+ "','yyyy-MM-dd') and r.audit_status = '3' and r.bsflag = '0' ";
		
		String curDailyWorkloadSql = "select sum("
			+ dailyColumn
			+ ") as sum_daily_data from gp_ops_daily_report where project_info_no = '"
			+ projectInfoNo + "' and " + dailyColumn
			+ " > 0 and produce_date <= to_date('" + dailyEndDate
			+ "','yyyy-MM-dd') and audit_status = '3' and bsflag = '0' ";
		
		recordMap = radDao.queryRecordBySQL(curDailyWorkloadSql);
		if (recordMap != null) {
			String value = "" + recordMap.get("sum_daily_data");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				sum_curDailyWorkLoad = Double.valueOf(value);
			}
		}
		// 取当前工序的结束状态
		String endFlagSql = "select nvl(count(*),0) as end_day from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no"
			+ " where d.produce_date >= to_date('" + dailyStartDate + "','yyyy-MM-dd') and d.produce_date <= to_date('" + dailyEndDate + "','yyyy-MM-dd') "
			+ " and project_info_no = '"+projectInfoNo +"'"
			+ " and " + endFlagColumn + " = '3' and d.bsflag = '0' and d.audit_status = '3' ";
		recordMap = radDao.queryRecordBySQL(endFlagSql);
		long endFlagDay = 0;
		if (recordMap != null) {
			String value = "" + recordMap.get("end_day");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				endFlagDay = Long.valueOf(value);
			}
		}
		// 计算项目开始到现在的天数 用于计算设计值,实际结束时间-计划开始时间
		long projectUpToNowDays = DateOperation.diffDaysOfDate(dailyEndDate, designStartDate)+1;
		
		// 计算项目实际开始到现在的天数 用于计算实际值,实际结束时间-实际开始时间 
		long actualWorkDays = DateOperation.diffDaysOfDate(dailyEndDate, dailyStartDate)+1;
		
		//计算项目开始到现在的施工天数 除掉暂停天数
		long workDay = 0;
		String sql = "select count(*) as work_day from rpt_gp_daily r where r.project_info_no = '"+projectInfoNo+"' and r.work_status = '"+taskName+"' and r.bsflag = '0' ";
		recordMap = radDao.queryRecordBySQL(sql);
		if (recordMap != null) {
			String value = "" + recordMap.get("work_day");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				workDay = Long.valueOf(value);
			}
		}
		//
		workDay = actualWorkDays;
		
		// 计算当前的设计平均日效
		double curDesignAvgWorkLoad = 0;
		if (projectUpToNowDays != 0) {
			curDesignAvgWorkLoad = sum_curDesignWorkLoad / projectUpToNowDays;
		}
		// 计算当前的实际平均日效
		double curDailyAvgWorkLoad = 0;
		if (projectUpToNowDays != 0) {
			curDailyAvgWorkLoad = sum_curDailyWorkLoad / workDay;
		}
		
		long compareDate = DateOperation.diffDaysOfDate(dailyEndDate, designEndDate);
		if(compareDate >= 0){
			chatInfo = "截至"+ dailyEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		}else{
			chatInfo = "截至"+ dailyEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		}
		
		//之前截至日期用的是dailyEndDate,和图表上的时间不符
		//chatInfo = "截至"+ dailyEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";

		//用designEndDate,能和图表上的时间对应上
		//chatInfo = "截至"+ designEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		
		// 取数据
		StringBuffer dataSql = new StringBuffer();
		dataSql.append("select axis_date, sum(design_data) as design_data, sum(daily_data) as daily_data from (");
		dataSql.append("select record_month as axis_date, ").append(designColumn).append(" as design_data, 0 as daily_data");
		dataSql.append(" from gp_proj_product_plan");
		dataSql.append(" where project_info_no = '").append(projectInfoNo).append("'");
		dataSql.append(" and bsflag = '0' and oper_plan_type = '").append(type).append("'");
		dataSql.append(" and ").append(designColumn).append(" is not null");
		dataSql.append(" union ");
		dataSql.append(" select to_char(produce_date,'yyyy-MM-dd') as axis_date, '0' as design_data,");
		dataSql.append(dailyColumn).append(" as daily_data");
		dataSql.append(" from gp_ops_daily_report");
		dataSql.append(" where project_info_no = '").append(projectInfoNo).append("' and audit_status = '3' and bsflag = '0' ");
		dataSql.append(" and ").append(dailyColumn).append(" > 0");
		dataSql.append(" )");
		dataSql.append(" group by axis_date order by axis_date");

		List<Map> dataList = radDao.queryRecords(dataSql.toString());

		// 计算最近7天工作量不为零的数据
		StringBuffer daysAvgSql = new StringBuffer(
				" select sum(colsadd_value)/7  as avg_value from (");
		String select_col = " 0 ";
		if ("colldailylist".equals(type)) {
			select_col = " nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_workload,0)";
		} else if ("measuredailylist".equals(type)) {
			select_col = " nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)";
		} else if ("drilldailylist".equals(type)) {
			select_col = "nvl(d.daily_drill_sp_num,0)";
		}
		daysAvgSql.append("select ").append(select_col).append(" as colsadd_value ");
		daysAvgSql.append(" ,to_char(produce_date,'yyyy-MM-dd') as date1");
		daysAvgSql.append(" from gp_ops_daily_report d");
		daysAvgSql.append(" where ").append(select_col).append(" > 0 and audit_status = '3' and bsflag = '0'  and project_info_no = '" + projectInfoNo+"'");
		daysAvgSql.append(" order by date1 desc");
		daysAvgSql.append(" ) where rownum < 8");
		List<Map> daysAvgList = radDao.queryRecords(daysAvgSql.toString());

		if (daysAvgList != null && daysAvgList.size() > 0) {
			recordMap = daysAvgList.get(0);
			String value = "" + recordMap.get("avg_value");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				avgWorkLoad = Double.valueOf(value);
				avgWorkLoad = Double.valueOf(df.format(avgWorkLoad));
			}
		}

		if (dataList != null && dataList.size() > 0) {
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("chart");
			root.addAttribute("bgColor", "F3F5F4,DEE6EB");
			//root.addAttribute("xAxisName", "日期");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "16");
			root.addAttribute("palette", "2");
			root.addAttribute("baseFontSize", "12");
			//root.addAttribute("labelDisplay", "none");
			//root.addAttribute("labelStep", "3");
			
			if ("measuredailylist".equals(type)) {
				//root.addAttribute("caption", "测量日效累积图");
				root.addAttribute("yAxisName", "日接收线公里数与日炮线公里数的和");
			} else if ("colldailylist".equals(type)) {
				//root.addAttribute("caption", "采集日效累积图");
				
				String tn = "日完成公里/平方公里数";
				String  explorationMethod = getExplorationMethod(projectInfoNo);
				if("0300100012000000002".equals(explorationMethod) ){
					//二维
					tn = "日完成公里数";
				} else {
					//三维
					tn = "日完成平方公里数";
				}
				
				
				root.addAttribute("yAxisName", tn);
			} else if ("drilldailylist".equals(type)) {
				//root.addAttribute("caption", "钻井日效累积图");
				root.addAttribute("yAxisName", "日完成炮点数");
			}
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "0");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");

			Element categories = root.addElement("categories");
			Element designDataset = root.addElement("dataset");
			designDataset.addAttribute("seriesName", "设计日效");
			//designDataset.addAttribute("Color", "0000FF");
			designDataset.addAttribute("lineDashed", "1");
			designDataset.addAttribute("color", "1381c0");
			designDataset.addAttribute("anchorBorderColor", "1381c0");
			designDataset.addAttribute("anchorBgColor", "1381c0");
			
			Element actualDataset = root.addElement("dataset");
			actualDataset.addAttribute("seriesName", "实际日效");
			//actualDataset.addAttribute("Color", "990033");
			//color="fd962e" anchorBorderColor="fd962e" anchorBgColor="fd962e"
			actualDataset.addAttribute("color", "fd962e");
			actualDataset.addAttribute("anchorBorderColor", "fd962e");
			actualDataset.addAttribute("anchorBgColor", "fd962e");

			if (endFlagDay > 0) {
				for (int i = 0; i < dataList.size(); i++) {
					Map map = dataList.get(i);
					String xAxisDate = "" + map.get("axis_date");
					String design_value = "" + map.get("design_data");
					String daily_value = "" + map.get("daily_data");
					Matcher isNum1 = pattern.matcher(design_value);
					if (isNum1.matches()) {
						designWorkLoad += Double.valueOf(design_value);
					}
					Matcher isNum2 = pattern.matcher(daily_value);
					if (isNum2.matches()) {
						dailyWorkLoad += Double.valueOf(daily_value);
					}

					// 日期坐标
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					// 填充数据
					// 设计值
					Element designSet = designDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
					} else {
						if(designWorkLoad > 0){
							designSet.addAttribute("value", "" + designWorkLoad);
						}
					}
					// 日报值
					Element actualSet = actualDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
						actualSet.addAttribute("value", "" + dailyWorkLoad);
					}
				}
				chatInfo = chatInfo + taskName + "工序已完成;累计完成"+df.format(dailyWorkLoad)+""+unitName;
			} else {
				Element forcastDataset = root.addElement("dataset"); // 剩余工作量的预测完成日效
				forcastDataset.addAttribute("seriesName", "预测完成日效");
				//forcastDataset.addAttribute("Color", "Olive");
				forcastDataset.addAttribute("color", "e7d948");
				forcastDataset.addAttribute("anchorBorderColor", "e7d948");
				forcastDataset.addAttribute("anchorBgColor", "e7d948");
				
				Element planDataset = root.addElement("dataset"); // 剩余工作量按计划日期完成日效
				//planDataset.addAttribute("seriesName", "计划完成日效");
				
				//姜科提出“计划完成日效”改为“按计划完成所需日效”(20130403)
				planDataset.addAttribute("seriesName", "按计划完成所需日效");
				
				//planDataset.addAttribute("Color", "66FF00");
				planDataset.addAttribute("color", "95a700");
				planDataset.addAttribute("anchorBorderColor", "95a700");
				planDataset.addAttribute("anchorBgColor", "95a700");
				
				String axisEndDate = designEndDate;
				if (DateOperation.diffDaysOfDate(dailyEndDate, designEndDate) > 0) {
					axisEndDate = dailyEndDate;
				}
				// 计算预测完成日效
				String forcastFinishDate = dailyEndDate; // 预测完成日期
				long forcastFinishDays = 0;
				long drawForcastDays = 1;
				if ((sum_designWorkLoad - sum_dailyWorkLoad) > 0) {
					long days = (long)((sum_designWorkLoad - sum_dailyWorkLoad) / avgWorkLoad);
					if(0 < ((sum_designWorkLoad - sum_dailyWorkLoad) / avgWorkLoad)){
						if (((sum_designWorkLoad - sum_dailyWorkLoad) % avgWorkLoad) > 0) {
							forcastFinishDays = days + 1;
						} else {
							forcastFinishDays = days;
						}
					}
					forcastFinishDate = DateOperation.afterNDays(dailyEndDate,forcastFinishDays);
					chatInfo = chatInfo + "以目前生产情况推算，剩余工作量" + df.format(sum_designWorkLoad - sum_dailyWorkLoad) + unitName + "，预计完成日期为" + forcastFinishDate + "尚需" + forcastFinishDays + "天.";
				}
				// 计算按计划日期完成日效(当前日期小于计划日期时)
				boolean planFinishLine = false;
				double planFinishWorkLoad = 0;
				long drawPlanDays = 1;
				long diffDays = DateOperation.diffDaysOfDate(designEndDate,	dailyEndDate);
				// long diffDays = DateOperation.diffDaysOfDate(designEndDate,dailyEndDate);
				if (diffDays > 0) {
					// 设计工作量减去实际完成工作量 / 剩余天数
					planFinishWorkLoad = (long)(sum_designWorkLoad - sum_dailyWorkLoad)/ diffDays;
					planFinishLine = true;
					chatInfo = chatInfo + "按计划时间完成，所需日效为" + df.format(planFinishWorkLoad) + unitName + ".";
				}else{
					chatInfo = chatInfo + "实际工作日期已超出设计日期.";
				}
				for (int i = 0; i < dataList.size(); i++) {
					Map map = dataList.get(i);
					String xAxisDate = "" + map.get("axis_date");
					String design_value = "" + map.get("design_data");
					String daily_value = "" + map.get("daily_data");
					Matcher isNum1 = pattern.matcher(design_value);
					if (isNum1.matches()) {
						designWorkLoad += Double.valueOf(design_value);
					}
					Matcher isNum2 = pattern.matcher(daily_value);
					if (isNum2.matches()) {
						dailyWorkLoad += Double.valueOf(daily_value);
					}
					// 日期坐标
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					// 填充数据
					// 设计值
					Element designSet = designDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
					} else {
						designSet.addAttribute("value", "" + designWorkLoad);
					}
					// 日报值
					Element dailySet = actualDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
							dailySet.addAttribute("value", "" + dailyWorkLoad);
					}
					// 按计划完成日效值
					Element planSet = planDataset.addElement("set");
					if (planFinishLine) {
						if(xAxisDate.equals(dailyEndDate)) {
							planSet.addAttribute("value", "" + sum_dailyWorkLoad);
							planSet.addAttribute("Color", "95a700");
							planSet.addAttribute("toolText", "实际日效,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
						}
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0) {
							planSet.addAttribute("value", "" + (sum_dailyWorkLoad + planFinishWorkLoad * drawPlanDays));
							drawPlanDays++;
						}
					}
					// 预测完成日效值
					Element forcastSet = forcastDataset.addElement("set");
					if (xAxisDate.equals(dailyEndDate)) {
						forcastSet.addAttribute("value", "" + sum_dailyWorkLoad);
						forcastSet.addAttribute("Color", "e7d948");
						forcastSet.addAttribute("toolText", "实际日效,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
					}
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0 && DateOperation.diffDaysOfDate(forcastFinishDate, xAxisDate) >= 0) {
						drawForcastDays++;
						forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
					}
				}

				// 预测完成日期是否大于坐标的结束日期(大于则追加坐标日期)
				if (DateOperation.diffDaysOfDate(forcastFinishDate, axisEndDate) > 0) {
					diffDays = DateOperation.diffDaysOfDate(forcastFinishDate,axisEndDate);
					String nextDate = axisEndDate;
					for (int j = 0; j < diffDays; j++) {
						nextDate = DateOperation.afterNDays(nextDate, 1);
						Element category = categories.addElement("category");
						category.addAttribute("label", nextDate.substring(5));
						Element designSet = designDataset.addElement("set");
						Element dailySet = actualDataset.addElement("set");
						Element planSet = planDataset.addElement("set");
						Element forcastSet = forcastDataset.addElement("set");
						forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
						drawForcastDays++;
					}
				}
			}
			xmlData = document.asXML();
			int p_start = xmlData.indexOf("<chart");
			if (p_start > 0) {
				xmlData = xmlData.substring(p_start, xmlData.length());
			}
			if(noDailyData){
				chatInfo = "当前日报没有实际工作数据.";
			}
			repMsg.setValue("xmlData", xmlData);
			repMsg.setValue("chatInfo", chatInfo);
		}else{
			//没有计划数据
			repMsg.setValue("xmlData", "");
			repMsg.setValue("chatInfo", "");
		}
		return repMsg;
	}
	
	//深海采集日报数据分析
	public ISrvMsg getDailyActivitySh(ISrvMsg reqDTO) throws Exception{
		ISrvMsg repMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String projectInfoNo = reqDTO.getValue("project_info_no");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			return repMsg;
		}
		String type = reqDTO.getValue("type");
		if (type == null || "".equals(type)) {
			return repMsg;
		}
		
		//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		//String curDate = format.format(new Date());
		//String getLastDailyDate = "select max(t.produce_date) as last_daily_date from gp_ops_daily_report t where t.bsflag = '0' and t.audit_status = '3' and t.project_info_no = '"+projectInfoNo+"'";
		//String lastDailyDate = (String) radDao.queryRecordBySQL(getLastDailyDate).get("last_daily_date");
		
		String designStartDate = "";
		String designEndDate = "";
		String dailyStartDate = "";
		String dailyEndDate = "";
		
		String designColumn = "";
		String dailyColumn = "";		
		
		boolean showFlag = false;
		
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			designColumn = "workload_num";
			dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
		}else if (type == "colldailylist" || "colldailylist".equals(type)){
			designColumn = "workload";
			dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_workload,0) ";
		}else if (type == "drilldailylist" || "drilldailylist".equals(type)){
			designColumn = "workload";
			dailyColumn = " nvl(daily_drill_sp_num,0) ";
		}
		String chatInfo = "";
		String xmlData = "";
		
		// 取设计起始日期
		String designDateSql = "select min(record_month) as min_date, max(record_month) as max_date from gp_proj_product_plan where bsflag = '0' and project_info_no = '"+projectInfoNo+"'  and oper_plan_type = '"+type+"'";
		Map dateRecord = radDao.queryRecordBySQL(designDateSql);
		if(dateRecord != null){
			designStartDate = "" + dateRecord.get("min_date");
			designEndDate = "" + dateRecord.get("max_date");
		}
		// 取日报起始日期
		String dailyDateSql = "select to_char(min(produce_date),'yyyy-MM-dd') as min_date,to_char(max(produce_date),'yyyy-MM-dd') as max_date from gp_ops_daily_report where audit_status = '3' and bsflag = '0' and project_info_no = '"+projectInfoNo+"' and "+ dailyColumn + " > 0";
		dateRecord = radDao.queryRecordBySQL(dailyDateSql);
		if(dateRecord != null){
			dailyStartDate = "" + dateRecord.get("min_date");
			dailyEndDate = "" + dateRecord.get("max_date");
		}
		
		// 取数据 (20130903增加了一个审批状态)
		StringBuffer dataSql = new StringBuffer();
		dataSql.append("select axis_date, sum(design_data) as design_data, sum(daily_data) as daily_data,max(audit_status) as audit_status from (");
		dataSql.append("select record_month as axis_date, ").append(designColumn).append(" as design_data, 0 as daily_data, '' as audit_status");
		dataSql.append(" from gp_proj_product_plan");
		dataSql.append(" where project_info_no = '").append(projectInfoNo).append("'");
		dataSql.append(" and bsflag = '0' and oper_plan_type = '").append(type).append("'");
		dataSql.append(" and ").append(designColumn).append(" is not null");
		dataSql.append(" union ");
		dataSql.append(" select to_char(produce_date,'yyyy-MM-dd') as axis_date, '0' as design_data,");
		dataSql.append(dailyColumn).append(" as daily_data,audit_status");
		dataSql.append(" from gp_ops_daily_report");
		dataSql.append(" where project_info_no = '").append(projectInfoNo).append("'");
		dataSql.append(" and ").append(dailyColumn).append(" > 0");
		dataSql.append(" )");
		dataSql.append(" group by axis_date order by axis_date");
		
		List<Map> dataList = radDao.queryRecords(dataSql.toString());
		if(dataList != null && dataList.size() > 0){
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("chart");
			root.addAttribute("bgColor", "F3F5F4,DEE6EB");
			root.addAttribute("palette", "2");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "16");
			root.addAttribute("baseFontSize", "12");
			//root.addAttribute("labelDisplay", "none");
			//root.addAttribute("labelStep", "3");
			
			//root.addAttribute("xAxisName", "日期");
			if("measuredailylist".equals(type)){
				//root.addAttribute("caption", "测量日效图");
				root.addAttribute("yAxisName", "日接收线公里数与日炮线公里数的和");
			}else if("colldailylist".equals(type)){
				//root.addAttribute("caption", "采集日效图");
				//root.addAttribute("yAxisName", "日完成炮点数");
				
				String tn = "日完成公里/平方公里数";
				String  explorationMethod = getExplorationMethod(projectInfoNo);
				if("0300100012000000002".equals(explorationMethod) ){
					//二维
					tn = "日完成公里数";
				} else {
					//三维
					tn = "日完成平方公里数";
				}
				
				
				root.addAttribute("yAxisName", tn);
				
				
			}else if("drilldailylist".equals(type)){
				//root.addAttribute("caption", "钻井日效图");
				root.addAttribute("yAxisName", "日完成炮点数");
			}
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "0");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");
			
			Element categories = root.addElement("categories");
			Element designDataset = root.addElement("dataset");
			designDataset.addAttribute("seriesName", "设计日效");
			//designDataset.addAttribute("Color", "0000FF");
			designDataset.addAttribute("color", "1381c0");
			designDataset.addAttribute("anchorBorderColor", "1381c0");
			designDataset.addAttribute("anchorBgColor", "1381c0");
			
			Element actualDataset = root.addElement("dataset");
			actualDataset.addAttribute("seriesName", "实际日效");
			//actualDataset.addAttribute("Color", "990033");
			actualDataset.addAttribute("color", "fd962e");
			actualDataset.addAttribute("anchorBorderColor", "fd962e");
			actualDataset.addAttribute("anchorBgColor", "fd962e");
			
			for(int i=0; i<dataList.size(); i++){
				Map recordMap = dataList.get(i);
				String xAxisDate = "" + recordMap.get("axis_date");				
				String design_value = "" + recordMap.get("design_data");
				String daily_value = "" + recordMap.get("daily_data");
				String audit_status = recordMap.get("audit_status")!=null ? ""+recordMap.get("audit_status"):"";
				
				// 日期坐标
				Element category = categories.addElement("category");
				category.addAttribute("label", xAxisDate.substring(5));
				//填充数据
				//设计值
				Element designSet = designDataset.addElement("set");
				if(DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0){
				}else{
					//当设计日效不为0的时候,showFlag = true
					if(!showFlag){
						if(Float.parseFloat(recordMap.get("design_data").toString())>0){
							showFlag = true;
						}
					}
					
					if(showFlag){
						designSet.addAttribute("value", design_value);
					}
				}
				
				//日报值
				Element actualSet = actualDataset.addElement("set");
				if(DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0){
					if(DateOperation.diffDaysOfDate(dailyEndDate, xAxisDate) >= 0){
						if("3".equals(audit_status.trim()) || audit_status.trim() == "3"){
							actualSet.addAttribute("value", daily_value);
						}
					}
				}
			}
			xmlData = document.asXML();
			int p_start = xmlData.indexOf("<chart");
			if(p_start > 0){
				xmlData = xmlData.substring(p_start, xmlData.length());
			}
			repMsg.setValue("xmlData", xmlData);
			repMsg.setValue("chatInfo", chatInfo);
		}else{
			repMsg.setValue("xmlData", "");
			repMsg.setValue("chatInfo", "");
		}
		return repMsg;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public ISrvMsg getDaysCumulative(ISrvMsg reqDTO) throws Exception {
		ISrvMsg repMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		RADJdbcDao radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			return repMsg;
		}
		String type = reqDTO.getValue("type");
		if (type == null || "".equals(type)) {
			return repMsg;
		}

		String designStartDate = "";
		String designEndDate = "";
		String dailyStartDate = "";
		String dailyEndDate = "";
		String designColumn = "";
		String dailyColumn = "";
		String ifBuild = "";

		double designWorkLoad = 0;// 设计工作量
		double dailyWorkLoad = 0;// 日报工作量
		double sum_designWorkLoad = 0;// 设计工作量之和
		double sum_dailyWorkLoad = 0;// 日报工作量之和
		double sum_curDesignWorkLoad = 0;
		double sum_curDailyWorkLoad = 0;
		double avgWorkLoad = 1;// 最近7天平均工作量
		DecimalFormat df = new DecimalFormat("0.00");
		Date curDate = new Date();// 当前日期
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sCurDate = sdf.format(curDate);
		
		boolean noDailyData = false;
		
		String chatInfo = "";
		String xmlData = "";
		String taskName = "";
		String unitName = "炮";
		String endFlagColumn = "survey_process_status";
		
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			designColumn = "workload_num";
			dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
			taskName = "测量";
			ifBuild = "4";
			unitName = "km";
		} else if (type == "colldailylist" || "colldailylist".equals(type)) {
			designColumn = "workload";
			dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0) ";
			taskName = "采集";
			ifBuild = "6";
			endFlagColumn = "collect_process_status";
		} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
			designColumn = "workload";
			dailyColumn = " nvl(daily_drill_sp_num,0) ";
			taskName = "钻井";
			ifBuild = "5";
			endFlagColumn = "drill_process_status";
		}

		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+
		
		//String getLastDailyDate = "select max(t.produce_date) as last_daily_date from gp_ops_daily_report t where t.bsflag = '0' and t.audit_status = '3' and t.project_info_no = '"+projectInfoNo+"'";
		//String lastDailyDate = (String) radDao.queryRecordBySQL(getLastDailyDate).get("last_daily_date");

		// 取设计起始日期、设计累积值
		String designDateSql = "select min(record_month) as min_date, max(record_month) as max_date, sum(nvl("
				+ designColumn
				+ ",0)) as sum_design_data from gp_proj_product_plan where bsflag = '0' and project_info_no = '"
				+ projectInfoNo + "'  and oper_plan_type = '" + type + "'";
		if(type == "colldailylist" || "colldailylist".equals(type)){
			designDateSql = designDateSql + " and workload is not null";
		}else if(type == "drilldailylist" || "drilldailylist".equals(type)){
			designDateSql = designDateSql + " and workload is not null";
		}else if(type == "measuredailylist" || "measuredailylist".equals(type)){
			designDateSql = designDateSql + " and workload_num is not null";
		}
		Map recordMap = radDao.queryRecordBySQL(designDateSql);
		if (recordMap != null) {
			designStartDate = "" + recordMap.get("min_date");
			designEndDate = "" + recordMap.get("max_date");
			String sumDesignNum = "" + recordMap.get("sum_design_data");
			Matcher isNum1 = pattern.matcher(sumDesignNum);
			if (isNum1.matches()) {
				sum_designWorkLoad = Double.valueOf(sumDesignNum);
			}
		}
		
		// 取日报起始日期、日报累积值
		String dailyDateSql = "select to_char(min(produce_date),'yyyy-MM-dd') as min_date,to_char(max(produce_date),'yyyy-MM-dd') as max_date, sum("
				+ dailyColumn
				+ ") as sum_daily_data from gp_ops_daily_report where project_info_no = '"
				+ projectInfoNo + "' and " + dailyColumn + " > 0 and audit_status = '3' and bsflag = '0' ";
		recordMap = radDao.queryRecordBySQL(dailyDateSql);
		if (recordMap != null) {
			dailyStartDate = "" + recordMap.get("min_date");
			dailyEndDate = "" + recordMap.get("max_date");
			String sumDailyData = "" + recordMap.get("sum_daily_data");
			Matcher isNum1 = pattern.matcher(sumDailyData);
			if (isNum1.matches()) {
				sum_dailyWorkLoad = Double.valueOf(sumDailyData);
			}
			// 没有日报数据
			if("".equals(dailyStartDate)){
				noDailyData = true;
			}
		}
		// 取截止当前的设计工作量
		String curDesignWorkloadSql = "select sum(nvl("
				+ designColumn
				+ ",0)) as sum_design_data from gp_proj_product_plan where bsflag = '0' and project_info_no = '"
				+ projectInfoNo
				+ "' and to_date(record_month,'yyyy-MM-dd') <= to_date('"
				+ dailyEndDate + "','yyyy-MM-dd') and oper_plan_type = '" + type
				+ "' and bsflag = '0' ";
		recordMap = radDao.queryRecordBySQL(curDesignWorkloadSql);
		if (recordMap != null) {
			String value = "" + recordMap.get("sum_design_data");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				sum_curDesignWorkLoad = Double.valueOf(value);
			}
		}
		// 取截止当前的实际工作量
		//String curDailyWorkloadSql = "select sum("
		//		+ dailyColumn
		//		+ ") as sum_daily_data from gp_ops_daily_report r join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no and sit.bsflag = '0' and sit.if_build = '"+ifBuild+"' where project_info_no = '"
		//		+ projectInfoNo + "' and " + dailyColumn
		//		+ " > 0 and produce_date <= to_date('" + dailyEndDate
		//		+ "','yyyy-MM-dd') and r.audit_status = '3' and r.bsflag = '0' ";
		
		String curDailyWorkloadSql = "select sum("
			+ dailyColumn
			+ ") as sum_daily_data from gp_ops_daily_report where project_info_no = '"
			+ projectInfoNo + "' and " + dailyColumn
			+ " > 0 and produce_date <= to_date('" + dailyEndDate
			+ "','yyyy-MM-dd') and audit_status = '3' and bsflag = '0' ";
		
		recordMap = radDao.queryRecordBySQL(curDailyWorkloadSql);
		if (recordMap != null) {
			String value = "" + recordMap.get("sum_daily_data");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				sum_curDailyWorkLoad = Double.valueOf(value);
			}
		}
		// 取当前工序的结束状态
		String endFlagSql = "select nvl(count(*),0) as end_day from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no"
			+ " where d.produce_date >= to_date('" + dailyStartDate + "','yyyy-MM-dd') and d.produce_date <= to_date('" + dailyEndDate + "','yyyy-MM-dd') "
			+ " and project_info_no = '"+projectInfoNo +"'"
			+ " and " + endFlagColumn + " = '3' and d.bsflag = '0' and d.audit_status = '3' ";
		recordMap = radDao.queryRecordBySQL(endFlagSql);
		long endFlagDay = 0;
		if (recordMap != null) {
			String value = "" + recordMap.get("end_day");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				endFlagDay = Long.valueOf(value);
			}
		}
		// 计算项目开始到现在的天数 用于计算设计值,实际结束时间-计划开始时间
		long projectUpToNowDays = DateOperation.diffDaysOfDate(dailyEndDate, designStartDate)+1;
		
		// 计算项目实际开始到现在的天数 用于计算实际值,实际结束时间-实际开始时间 
		long actualWorkDays = DateOperation.diffDaysOfDate(dailyEndDate, dailyStartDate)+1;
		
		//计算项目开始到现在的施工天数 除掉暂停天数
		long workDay = 0;
		String sql = "select count(*) as work_day from rpt_gp_daily r where r.project_info_no = '"+projectInfoNo+"' and r.work_status = '"+taskName+"' and r.bsflag = '0' ";
		recordMap = radDao.queryRecordBySQL(sql);
		if (recordMap != null) {
			String value = "" + recordMap.get("work_day");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				workDay = Long.valueOf(value);
			}
		}
		//
		workDay = actualWorkDays;
		
		// 计算当前的设计平均日效
		double curDesignAvgWorkLoad = 0;
		if (projectUpToNowDays != 0) {
			curDesignAvgWorkLoad = sum_curDesignWorkLoad / projectUpToNowDays;
		}
		// 计算当前的实际平均日效
		double curDailyAvgWorkLoad = 0;
		if (projectUpToNowDays != 0) {
			curDailyAvgWorkLoad = sum_curDailyWorkLoad / workDay;
		}
		
		long compareDate = DateOperation.diffDaysOfDate(dailyEndDate, designEndDate);
		if(compareDate >= 0){
			chatInfo = "截至"+ dailyEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		}else{
			chatInfo = "截至"+ dailyEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		}
		
		//之前截至日期用的是dailyEndDate,和图表上的时间不符
		//chatInfo = "截至"+ dailyEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";

		//用designEndDate,能和图表上的时间对应上
		//chatInfo = "截至"+ designEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		
		// 取数据
		StringBuffer dataSql = new StringBuffer();
		dataSql.append("select axis_date, sum(design_data) as design_data, sum(daily_data) as daily_data from (");
		dataSql.append("select record_month as axis_date, ").append(designColumn).append(" as design_data, 0 as daily_data");
		dataSql.append(" from gp_proj_product_plan");
		dataSql.append(" where project_info_no = '").append(projectInfoNo).append("'");
		dataSql.append(" and bsflag = '0' and oper_plan_type = '").append(type).append("'");
		dataSql.append(" and ").append(designColumn).append(" is not null");
		dataSql.append(" union ");
		dataSql.append(" select to_char(produce_date,'yyyy-MM-dd') as axis_date, '0' as design_data,");
		dataSql.append(dailyColumn).append(" as daily_data");
		dataSql.append(" from gp_ops_daily_report");
		dataSql.append(" where project_info_no = '").append(projectInfoNo).append("' and audit_status = '3' and bsflag = '0' ");
		dataSql.append(" and ").append(dailyColumn).append(" > 0");
		dataSql.append(" )");
		dataSql.append(" group by axis_date order by axis_date");

		List<Map> dataList = radDao.queryRecords(dataSql.toString());

		// 计算最近7天工作量不为零的数据
		StringBuffer daysAvgSql = new StringBuffer(
				" select sum(colsadd_value)/7  as avg_value from (");
		String select_col = " 0 ";
		if ("colldailylist".equals(type)) {
			select_col = " nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)";
		} else if ("measuredailylist".equals(type)) {
			select_col = " nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)";
		} else if ("drilldailylist".equals(type)) {
			select_col = "nvl(d.daily_drill_sp_num,0)";
		}
		daysAvgSql.append("select ").append(select_col).append(" as colsadd_value ");
		daysAvgSql.append(" ,to_char(produce_date,'yyyy-MM-dd') as date1");
		daysAvgSql.append(" from gp_ops_daily_report d");
		daysAvgSql.append(" where ").append(select_col).append(" > 0 and audit_status = '3' and bsflag = '0'  and project_info_no = '" + projectInfoNo+"'");
		daysAvgSql.append(" order by date1 desc");
		daysAvgSql.append(" ) where rownum < 8");
		List<Map> daysAvgList = radDao.queryRecords(daysAvgSql.toString());

		if (daysAvgList != null && daysAvgList.size() > 0) {
			recordMap = daysAvgList.get(0);
			String value = "" + recordMap.get("avg_value");
			Matcher isNum = pattern.matcher(value);
			if (isNum.matches()) {
				avgWorkLoad = Double.valueOf(value);
				avgWorkLoad = Double.valueOf(df.format(avgWorkLoad));
			}
		}

		if (dataList != null && dataList.size() > 0) {
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("chart");
			root.addAttribute("bgColor", "F3F5F4,DEE6EB");
			//root.addAttribute("xAxisName", "日期");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "16");
			root.addAttribute("palette", "2");
			root.addAttribute("baseFontSize", "12");
			//root.addAttribute("labelDisplay", "none");
			//root.addAttribute("labelStep", "3");
			
			if ("measuredailylist".equals(type)) {
				//root.addAttribute("caption", "测量日效累积图");
				root.addAttribute("yAxisName", "日接收线公里数与日炮线公里数的和");
			} else if ("colldailylist".equals(type)) {
				//root.addAttribute("caption", "采集日效累积图");
				root.addAttribute("yAxisName", "日完成炮点数");
			} else if ("drilldailylist".equals(type)) {
				//root.addAttribute("caption", "钻井日效累积图");
				root.addAttribute("yAxisName", "日完成炮点数");
			}
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "0");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");

			Element categories = root.addElement("categories");
			Element designDataset = root.addElement("dataset");
			designDataset.addAttribute("seriesName", "设计日效");
			//designDataset.addAttribute("Color", "0000FF");
			designDataset.addAttribute("lineDashed", "1");
			designDataset.addAttribute("color", "1381c0");
			designDataset.addAttribute("anchorBorderColor", "1381c0");
			designDataset.addAttribute("anchorBgColor", "1381c0");
			
			Element actualDataset = root.addElement("dataset");
			actualDataset.addAttribute("seriesName", "实际日效");
			//actualDataset.addAttribute("Color", "990033");
			//color="fd962e" anchorBorderColor="fd962e" anchorBgColor="fd962e"
			actualDataset.addAttribute("color", "fd962e");
			actualDataset.addAttribute("anchorBorderColor", "fd962e");
			actualDataset.addAttribute("anchorBgColor", "fd962e");

			if (endFlagDay > 0) {
				for (int i = 0; i < dataList.size(); i++) {
					Map map = dataList.get(i);
					String xAxisDate = "" + map.get("axis_date");
					String design_value = "" + map.get("design_data");
					String daily_value = "" + map.get("daily_data");
					Matcher isNum1 = pattern.matcher(design_value);
					if (isNum1.matches()) {
						designWorkLoad += Double.valueOf(design_value);
					}
					Matcher isNum2 = pattern.matcher(daily_value);
					if (isNum2.matches()) {
						dailyWorkLoad += Double.valueOf(daily_value);
					}

					// 日期坐标
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					// 填充数据
					// 设计值
					Element designSet = designDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
					} else {
						if(designWorkLoad > 0){
							designSet.addAttribute("value", "" + designWorkLoad);
						}
					}
					// 日报值
					Element actualSet = actualDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
						actualSet.addAttribute("value", "" + dailyWorkLoad);
					}
				}
				chatInfo = chatInfo + taskName + "工序已完成;累计完成"+df.format(dailyWorkLoad)+""+unitName;
			} else {
				Element forcastDataset = root.addElement("dataset"); // 剩余工作量的预测完成日效
				forcastDataset.addAttribute("seriesName", "预测完成日效");
				//forcastDataset.addAttribute("Color", "Olive");
				forcastDataset.addAttribute("color", "e7d948");
				forcastDataset.addAttribute("anchorBorderColor", "e7d948");
				forcastDataset.addAttribute("anchorBgColor", "e7d948");
				
				Element planDataset = root.addElement("dataset"); // 剩余工作量按计划日期完成日效
				//planDataset.addAttribute("seriesName", "计划完成日效");
				
				//姜科提出“计划完成日效”改为“按计划完成所需日效”(20130403)
				planDataset.addAttribute("seriesName", "按计划完成所需日效");
				
				//planDataset.addAttribute("Color", "66FF00");
				planDataset.addAttribute("color", "95a700");
				planDataset.addAttribute("anchorBorderColor", "95a700");
				planDataset.addAttribute("anchorBgColor", "95a700");
				
				String axisEndDate = designEndDate;
				if (DateOperation.diffDaysOfDate(dailyEndDate, designEndDate) > 0) {
					axisEndDate = dailyEndDate;
				}
				// 计算预测完成日效
				String forcastFinishDate = dailyEndDate; // 预测完成日期
				long forcastFinishDays = 0;
				long drawForcastDays = 1;
				if ((sum_designWorkLoad - sum_dailyWorkLoad) > 0) {
					long days = (long)((sum_designWorkLoad - sum_dailyWorkLoad) / avgWorkLoad);
					if(0 < ((sum_designWorkLoad - sum_dailyWorkLoad) / avgWorkLoad)){
						if (((sum_designWorkLoad - sum_dailyWorkLoad) % avgWorkLoad) > 0) {
							forcastFinishDays = days + 1;
						} else {
							forcastFinishDays = days;
						}
					}
					forcastFinishDate = DateOperation.afterNDays(dailyEndDate,forcastFinishDays);
					chatInfo = chatInfo + "以目前生产情况推算，剩余工作量" + df.format(sum_designWorkLoad - sum_dailyWorkLoad) + unitName + "，预计完成日期为" + forcastFinishDate + "尚需" + forcastFinishDays + "天.";
				}
				// 计算按计划日期完成日效(当前日期小于计划日期时)
				boolean planFinishLine = false;
				double planFinishWorkLoad = 0;
				long drawPlanDays = 1;
				long diffDays = DateOperation.diffDaysOfDate(designEndDate,	dailyEndDate);
				// long diffDays = DateOperation.diffDaysOfDate(designEndDate,dailyEndDate);
				if (diffDays > 0) {
					// 设计工作量减去实际完成工作量 / 剩余天数
					planFinishWorkLoad = (long)(sum_designWorkLoad - sum_dailyWorkLoad)/ diffDays;
					planFinishLine = true;
					chatInfo = chatInfo + "按计划时间完成，所需日效为" + df.format(planFinishWorkLoad) + unitName + ".";
				}else{
					chatInfo = chatInfo + "实际工作日期已超出设计日期.";
				}
				for (int i = 0; i < dataList.size(); i++) {
					Map map = dataList.get(i);
					String xAxisDate = "" + map.get("axis_date");
					String design_value = "" + map.get("design_data");
					String daily_value = "" + map.get("daily_data");
					Matcher isNum1 = pattern.matcher(design_value);
					if (isNum1.matches()) {
						designWorkLoad += Double.valueOf(design_value);
					}
					Matcher isNum2 = pattern.matcher(daily_value);
					if (isNum2.matches()) {
						dailyWorkLoad += Double.valueOf(daily_value);
					}
					// 日期坐标
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					// 填充数据
					// 设计值
					Element designSet = designDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
					} else {
						designSet.addAttribute("value", "" + designWorkLoad);
					}
					// 日报值
					Element dailySet = actualDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
							dailySet.addAttribute("value", "" + dailyWorkLoad);
					}
					// 按计划完成日效值
					Element planSet = planDataset.addElement("set");
					if (planFinishLine) {
						if(xAxisDate.equals(dailyEndDate)) {
							planSet.addAttribute("value", "" + sum_dailyWorkLoad);
							planSet.addAttribute("Color", "95a700");
							planSet.addAttribute("toolText", "实际日效,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
						}
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0) {
							planSet.addAttribute("value", "" + (sum_dailyWorkLoad + planFinishWorkLoad * drawPlanDays));
							drawPlanDays++;
						}
					}
					// 预测完成日效值
					Element forcastSet = forcastDataset.addElement("set");
					if (xAxisDate.equals(dailyEndDate)) {
						forcastSet.addAttribute("value", "" + sum_dailyWorkLoad);
						forcastSet.addAttribute("Color", "e7d948");
						forcastSet.addAttribute("toolText", "实际日效,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
					}
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0 && DateOperation.diffDaysOfDate(forcastFinishDate, xAxisDate) >= 0) {
						drawForcastDays++;
						forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
					}
				}

				// 预测完成日期是否大于坐标的结束日期(大于则追加坐标日期)
				if (DateOperation.diffDaysOfDate(forcastFinishDate, axisEndDate) > 0) {
					diffDays = DateOperation.diffDaysOfDate(forcastFinishDate,axisEndDate);
					String nextDate = axisEndDate;
					for (int j = 0; j < diffDays; j++) {
						nextDate = DateOperation.afterNDays(nextDate, 1);
						Element category = categories.addElement("category");
						category.addAttribute("label", nextDate.substring(5));
						Element designSet = designDataset.addElement("set");
						Element dailySet = actualDataset.addElement("set");
						Element planSet = planDataset.addElement("set");
						Element forcastSet = forcastDataset.addElement("set");
						forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
						drawForcastDays++;
					}
				}
			}
			xmlData = document.asXML();
			int p_start = xmlData.indexOf("<chart");
			if (p_start > 0) {
				xmlData = xmlData.substring(p_start, xmlData.length());
			}
			if(noDailyData){
				chatInfo = "当前日报没有实际工作数据.";
			}
			repMsg.setValue("xmlData", xmlData);
			repMsg.setValue("chatInfo", chatInfo);
		}else{
			//没有计划数据
			repMsg.setValue("xmlData", "");
			repMsg.setValue("chatInfo", "");
		}
		return repMsg;
	}
	
 
	 
	
	public ISrvMsg getDailyActivity(ISrvMsg reqDTO) throws Exception{
		ISrvMsg repMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String projectInfoNo = reqDTO.getValue("project_info_no");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			return repMsg;
		}
		String type = reqDTO.getValue("type");
		if (type == null || "".equals(type)) {
			return repMsg;
		}
		
		//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		//String curDate = format.format(new Date());
		//String getLastDailyDate = "select max(t.produce_date) as last_daily_date from gp_ops_daily_report t where t.bsflag = '0' and t.audit_status = '3' and t.project_info_no = '"+projectInfoNo+"'";
		//String lastDailyDate = (String) radDao.queryRecordBySQL(getLastDailyDate).get("last_daily_date");
		
		String designStartDate = "";
		String designEndDate = "";
		String dailyStartDate = "";
		String dailyEndDate = "";
		
		String designColumn = "";
		String dailyColumn = "";		
		
		boolean showFlag = false;
		
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			designColumn = "workload_num";
			dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
		}else if (type == "colldailylist" || "colldailylist".equals(type)){
			designColumn = "workload";
			dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0) ";
		}else if (type == "drilldailylist" || "drilldailylist".equals(type)){
			designColumn = "workload";
			dailyColumn = " nvl(daily_drill_sp_num,0) ";
		}
		String chatInfo = "";
		String xmlData = "";
		
		// 取设计起始日期
		String designDateSql = "select min(record_month) as min_date, max(record_month) as max_date from gp_proj_product_plan where bsflag = '0' and project_info_no = '"+projectInfoNo+"'  and oper_plan_type = '"+type+"'";
		Map dateRecord = radDao.queryRecordBySQL(designDateSql);
		if(dateRecord != null){
			designStartDate = "" + dateRecord.get("min_date");
			designEndDate = "" + dateRecord.get("max_date");
		}
		// 取日报起始日期
		String dailyDateSql = "select to_char(min(produce_date),'yyyy-MM-dd') as min_date,to_char(max(produce_date),'yyyy-MM-dd') as max_date from gp_ops_daily_report where audit_status = '3' and bsflag = '0' and project_info_no = '"+projectInfoNo+"' and "+ dailyColumn + " > 0";
		dateRecord = radDao.queryRecordBySQL(dailyDateSql);
		if(dateRecord != null){
			dailyStartDate = "" + dateRecord.get("min_date");
			dailyEndDate = "" + dateRecord.get("max_date");
		}
		
		// 取数据 (20130903增加了一个审批状态)
		StringBuffer dataSql = new StringBuffer();
		dataSql.append("select axis_date, sum(design_data) as design_data, sum(daily_data) as daily_data,max(audit_status) as audit_status from (");
		dataSql.append("select record_month as axis_date, ").append(designColumn).append(" as design_data, 0 as daily_data, '' as audit_status");
		dataSql.append(" from gp_proj_product_plan");
		dataSql.append(" where project_info_no = '").append(projectInfoNo).append("'");
		dataSql.append(" and bsflag = '0' and oper_plan_type = '").append(type).append("'");
		dataSql.append(" and ").append(designColumn).append(" is not null");
		dataSql.append(" union ");
		dataSql.append(" select to_char(produce_date,'yyyy-MM-dd') as axis_date, '0' as design_data,");
		dataSql.append(dailyColumn).append(" as daily_data,audit_status");
		dataSql.append(" from gp_ops_daily_report");
		dataSql.append(" where project_info_no = '").append(projectInfoNo).append("'");
		dataSql.append(" and ").append(dailyColumn).append(" > 0 and bsflag='0'");
		dataSql.append(" )");
		dataSql.append(" group by axis_date order by axis_date");
		
		List<Map> dataList = radDao.queryRecords(dataSql.toString());
		if(dataList != null && dataList.size() > 0){
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("chart");
			root.addAttribute("bgColor", "F3F5F4,DEE6EB");
			root.addAttribute("palette", "2");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "16");
			root.addAttribute("baseFontSize", "12");
			//root.addAttribute("labelDisplay", "none");
			//root.addAttribute("labelStep", "3");
			
			//root.addAttribute("xAxisName", "日期");
			if("measuredailylist".equals(type)){
				//root.addAttribute("caption", "测量日效图");
				root.addAttribute("yAxisName", "日接收线公里数与日炮线公里数的和");
			}else if("colldailylist".equals(type)){
				//root.addAttribute("caption", "采集日效图");
				root.addAttribute("yAxisName", "日完成炮点数");
			}else if("drilldailylist".equals(type)){
				//root.addAttribute("caption", "钻井日效图");
				root.addAttribute("yAxisName", "日完成炮点数");
			}
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "0");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");
			
			Element categories = root.addElement("categories");
			Element designDataset = root.addElement("dataset");
			designDataset.addAttribute("seriesName", "设计日效");
			//designDataset.addAttribute("Color", "0000FF");
			designDataset.addAttribute("color", "1381c0");
			designDataset.addAttribute("anchorBorderColor", "1381c0");
			designDataset.addAttribute("anchorBgColor", "1381c0");
			
			Element actualDataset = root.addElement("dataset");
			actualDataset.addAttribute("seriesName", "实际日效");
			//actualDataset.addAttribute("Color", "990033");
			actualDataset.addAttribute("color", "fd962e");
			actualDataset.addAttribute("anchorBorderColor", "fd962e");
			actualDataset.addAttribute("anchorBgColor", "fd962e");
			
			for(int i=0; i<dataList.size(); i++){
				Map recordMap = dataList.get(i);
				String xAxisDate = "" + recordMap.get("axis_date");				
				String design_value = "" + recordMap.get("design_data");
				String daily_value = "" + recordMap.get("daily_data");
				String audit_status = recordMap.get("audit_status")!=null ? ""+recordMap.get("audit_status"):"";
				
				// 日期坐标
				Element category = categories.addElement("category");
				category.addAttribute("label", xAxisDate.substring(5));
				//填充数据
				//设计值
				Element designSet = designDataset.addElement("set");
				if(DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0){
				}else{
					//当设计日效不为0的时候,showFlag = true
					if(!showFlag){
						if(Float.parseFloat(recordMap.get("design_data").toString())>0){
							showFlag = true;
						}
					}
					
					if(showFlag){
						designSet.addAttribute("value", design_value);
					}
				}
				
				//日报值
				Element actualSet = actualDataset.addElement("set");
				if(DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0){
					if(DateOperation.diffDaysOfDate(dailyEndDate, xAxisDate) >= 0){
						if("3".equals(audit_status.trim()) || audit_status.trim() == "3"){
							actualSet.addAttribute("value", daily_value);
						}
					}
				}
			}
			xmlData = document.asXML();
			int p_start = xmlData.indexOf("<chart");
			if(p_start > 0){
				xmlData = xmlData.substring(p_start, xmlData.length());
			}
			repMsg.setValue("xmlData", xmlData);
			repMsg.setValue("chatInfo", chatInfo);
		}else{
			repMsg.setValue("xmlData", "");
			repMsg.setValue("chatInfo", "");
		}
		return repMsg;
	}
}
