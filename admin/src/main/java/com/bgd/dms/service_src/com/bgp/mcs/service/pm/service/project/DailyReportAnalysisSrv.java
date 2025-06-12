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
	//�  �ɼ��ۻ����ݷ���
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

		double designWorkLoad = 0;// ��ƹ�����
		double dailyWorkLoad = 0;// �ձ�������
		double sum_designWorkLoad = 0;// ��ƹ�����֮��
		double sum_dailyWorkLoad = 0;// �ձ�������֮��
		double sum_curDesignWorkLoad = 0;
		double sum_curDailyWorkLoad = 0;
		double avgWorkLoad = 1;// ���7��ƽ��������
		DecimalFormat df = new DecimalFormat("0.00");
		Date curDate = new Date();// ��ǰ����
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sCurDate = sdf.format(curDate);
		
		boolean noDailyData = false;
		
		String chatInfo = "";
		String xmlData = "";
		String taskName = "";
		String unitName = "��";
		String endFlagColumn = "survey_process_status";
		
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			designColumn = "workload_num";
			dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
			taskName = "����";
			ifBuild = "4";
			unitName = "km";
		} else if (type == "colldailylist" || "colldailylist".equals(type)) {
			String expMethod = reqDTO.getValue("exploration_method");
			if("0300100012000000003".equals(expMethod)){
				unitName = "ƽ��km";
			}else{
				unitName = "km";
			}
			
			designColumn = "workload";
			dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_workload,0) ";
			taskName = "�ɼ�";
			ifBuild = "6";
			endFlagColumn = "collect_process_status";
		} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
			designColumn = "workload";
			dailyColumn = " nvl(daily_drill_sp_num,0) ";
			taskName = "�꾮";
			ifBuild = "5";
			endFlagColumn = "drill_process_status";
		}

		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+
		
		//String getLastDailyDate = "select max(t.produce_date) as last_daily_date from gp_ops_daily_report t where t.bsflag = '0' and t.audit_status = '3' and t.project_info_no = '"+projectInfoNo+"'";
		//String lastDailyDate = (String) radDao.queryRecordBySQL(getLastDailyDate).get("last_daily_date");

		// ȡ�����ʼ���ڡ�����ۻ�ֵ
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
		
		// ȡ�ձ���ʼ���ڡ��ձ��ۻ�ֵ
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
			// û���ձ�����
			if("".equals(dailyStartDate)){
				noDailyData = true;
			}
		}
		// ȡ��ֹ��ǰ����ƹ�����
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
		// ȡ��ֹ��ǰ��ʵ�ʹ�����
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
		// ȡ��ǰ����Ľ���״̬
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
		// ������Ŀ��ʼ�����ڵ����� ���ڼ������ֵ,ʵ�ʽ���ʱ��-�ƻ���ʼʱ��
		long projectUpToNowDays = DateOperation.diffDaysOfDate(dailyEndDate, designStartDate)+1;
		
		// ������Ŀʵ�ʿ�ʼ�����ڵ����� ���ڼ���ʵ��ֵ,ʵ�ʽ���ʱ��-ʵ�ʿ�ʼʱ�� 
		long actualWorkDays = DateOperation.diffDaysOfDate(dailyEndDate, dailyStartDate)+1;
		
		//������Ŀ��ʼ�����ڵ�ʩ������ ������ͣ����
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
		
		// ���㵱ǰ�����ƽ����Ч
		double curDesignAvgWorkLoad = 0;
		if (projectUpToNowDays != 0) {
			curDesignAvgWorkLoad = sum_curDesignWorkLoad / projectUpToNowDays;
		}
		// ���㵱ǰ��ʵ��ƽ����Ч
		double curDailyAvgWorkLoad = 0;
		if (projectUpToNowDays != 0) {
			curDailyAvgWorkLoad = sum_curDailyWorkLoad / workDay;
		}
		
		long compareDate = DateOperation.diffDaysOfDate(dailyEndDate, designEndDate);
		if(compareDate >= 0){
			chatInfo = "����"+ dailyEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		}else{
			chatInfo = "����"+ dailyEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		}
		
		//֮ǰ���������õ���dailyEndDate,��ͼ���ϵ�ʱ�䲻��
		//chatInfo = "����"+ dailyEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";

		//��designEndDate,�ܺ�ͼ���ϵ�ʱ���Ӧ��
		//chatInfo = "����"+ designEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		
		// ȡ����
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

		// �������7�칤������Ϊ�������
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
			//root.addAttribute("xAxisName", "����");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "16");
			root.addAttribute("palette", "2");
			root.addAttribute("baseFontSize", "12");
			//root.addAttribute("labelDisplay", "none");
			//root.addAttribute("labelStep", "3");
			
			if ("measuredailylist".equals(type)) {
				//root.addAttribute("caption", "������Ч�ۻ�ͼ");
				root.addAttribute("yAxisName", "�ս����߹������������߹������ĺ�");
			} else if ("colldailylist".equals(type)) {
				//root.addAttribute("caption", "�ɼ���Ч�ۻ�ͼ");
				
				String tn = "����ɹ���/ƽ��������";
				String  explorationMethod = getExplorationMethod(projectInfoNo);
				if("0300100012000000002".equals(explorationMethod) ){
					//��ά
					tn = "����ɹ�����";
				} else {
					//��ά
					tn = "�����ƽ��������";
				}
				
				
				root.addAttribute("yAxisName", tn);
			} else if ("drilldailylist".equals(type)) {
				//root.addAttribute("caption", "�꾮��Ч�ۻ�ͼ");
				root.addAttribute("yAxisName", "������ڵ���");
			}
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "0");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");

			Element categories = root.addElement("categories");
			Element designDataset = root.addElement("dataset");
			designDataset.addAttribute("seriesName", "�����Ч");
			//designDataset.addAttribute("Color", "0000FF");
			designDataset.addAttribute("lineDashed", "1");
			designDataset.addAttribute("color", "1381c0");
			designDataset.addAttribute("anchorBorderColor", "1381c0");
			designDataset.addAttribute("anchorBgColor", "1381c0");
			
			Element actualDataset = root.addElement("dataset");
			actualDataset.addAttribute("seriesName", "ʵ����Ч");
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

					// ��������
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					// �������
					// ���ֵ
					Element designSet = designDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
					} else {
						if(designWorkLoad > 0){
							designSet.addAttribute("value", "" + designWorkLoad);
						}
					}
					// �ձ�ֵ
					Element actualSet = actualDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
						actualSet.addAttribute("value", "" + dailyWorkLoad);
					}
				}
				chatInfo = chatInfo + taskName + "���������;�ۼ����"+df.format(dailyWorkLoad)+""+unitName;
			} else {
				Element forcastDataset = root.addElement("dataset"); // ʣ�๤������Ԥ�������Ч
				forcastDataset.addAttribute("seriesName", "Ԥ�������Ч");
				//forcastDataset.addAttribute("Color", "Olive");
				forcastDataset.addAttribute("color", "e7d948");
				forcastDataset.addAttribute("anchorBorderColor", "e7d948");
				forcastDataset.addAttribute("anchorBgColor", "e7d948");
				
				Element planDataset = root.addElement("dataset"); // ʣ�๤�������ƻ����������Ч
				//planDataset.addAttribute("seriesName", "�ƻ������Ч");
				
				//����������ƻ������Ч����Ϊ�����ƻ����������Ч��(20130403)
				planDataset.addAttribute("seriesName", "���ƻ����������Ч");
				
				//planDataset.addAttribute("Color", "66FF00");
				planDataset.addAttribute("color", "95a700");
				planDataset.addAttribute("anchorBorderColor", "95a700");
				planDataset.addAttribute("anchorBgColor", "95a700");
				
				String axisEndDate = designEndDate;
				if (DateOperation.diffDaysOfDate(dailyEndDate, designEndDate) > 0) {
					axisEndDate = dailyEndDate;
				}
				// ����Ԥ�������Ч
				String forcastFinishDate = dailyEndDate; // Ԥ���������
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
					chatInfo = chatInfo + "��Ŀǰ����������㣬ʣ�๤����" + df.format(sum_designWorkLoad - sum_dailyWorkLoad) + unitName + "��Ԥ���������Ϊ" + forcastFinishDate + "����" + forcastFinishDays + "��.";
				}
				// ���㰴�ƻ����������Ч(��ǰ����С�ڼƻ�����ʱ)
				boolean planFinishLine = false;
				double planFinishWorkLoad = 0;
				long drawPlanDays = 1;
				long diffDays = DateOperation.diffDaysOfDate(designEndDate,	dailyEndDate);
				// long diffDays = DateOperation.diffDaysOfDate(designEndDate,dailyEndDate);
				if (diffDays > 0) {
					// ��ƹ�������ȥʵ����ɹ����� / ʣ������
					planFinishWorkLoad = (long)(sum_designWorkLoad - sum_dailyWorkLoad)/ diffDays;
					planFinishLine = true;
					chatInfo = chatInfo + "���ƻ�ʱ����ɣ�������ЧΪ" + df.format(planFinishWorkLoad) + unitName + ".";
				}else{
					chatInfo = chatInfo + "ʵ�ʹ��������ѳ����������.";
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
					// ��������
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					// �������
					// ���ֵ
					Element designSet = designDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
					} else {
						designSet.addAttribute("value", "" + designWorkLoad);
					}
					// �ձ�ֵ
					Element dailySet = actualDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
							dailySet.addAttribute("value", "" + dailyWorkLoad);
					}
					// ���ƻ������Чֵ
					Element planSet = planDataset.addElement("set");
					if (planFinishLine) {
						if(xAxisDate.equals(dailyEndDate)) {
							planSet.addAttribute("value", "" + sum_dailyWorkLoad);
							planSet.addAttribute("Color", "95a700");
							planSet.addAttribute("toolText", "ʵ����Ч,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
						}
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0) {
							planSet.addAttribute("value", "" + (sum_dailyWorkLoad + planFinishWorkLoad * drawPlanDays));
							drawPlanDays++;
						}
					}
					// Ԥ�������Чֵ
					Element forcastSet = forcastDataset.addElement("set");
					if (xAxisDate.equals(dailyEndDate)) {
						forcastSet.addAttribute("value", "" + sum_dailyWorkLoad);
						forcastSet.addAttribute("Color", "e7d948");
						forcastSet.addAttribute("toolText", "ʵ����Ч,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
					}
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0 && DateOperation.diffDaysOfDate(forcastFinishDate, xAxisDate) >= 0) {
						drawForcastDays++;
						forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
					}
				}

				// Ԥ����������Ƿ��������Ľ�������(������׷����������)
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
				chatInfo = "��ǰ�ձ�û��ʵ�ʹ�������.";
			}
			repMsg.setValue("xmlData", xmlData);
			repMsg.setValue("chatInfo", chatInfo);
		}else{
			//û�мƻ�����
			repMsg.setValue("xmlData", "");
			repMsg.setValue("chatInfo", "");
		}
		return repMsg;
	}
	
	//��ɼ��ձ����ݷ���
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
		
		// ȡ�����ʼ����
		String designDateSql = "select min(record_month) as min_date, max(record_month) as max_date from gp_proj_product_plan where bsflag = '0' and project_info_no = '"+projectInfoNo+"'  and oper_plan_type = '"+type+"'";
		Map dateRecord = radDao.queryRecordBySQL(designDateSql);
		if(dateRecord != null){
			designStartDate = "" + dateRecord.get("min_date");
			designEndDate = "" + dateRecord.get("max_date");
		}
		// ȡ�ձ���ʼ����
		String dailyDateSql = "select to_char(min(produce_date),'yyyy-MM-dd') as min_date,to_char(max(produce_date),'yyyy-MM-dd') as max_date from gp_ops_daily_report where audit_status = '3' and bsflag = '0' and project_info_no = '"+projectInfoNo+"' and "+ dailyColumn + " > 0";
		dateRecord = radDao.queryRecordBySQL(dailyDateSql);
		if(dateRecord != null){
			dailyStartDate = "" + dateRecord.get("min_date");
			dailyEndDate = "" + dateRecord.get("max_date");
		}
		
		// ȡ���� (20130903������һ������״̬)
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
			
			//root.addAttribute("xAxisName", "����");
			if("measuredailylist".equals(type)){
				//root.addAttribute("caption", "������Чͼ");
				root.addAttribute("yAxisName", "�ս����߹������������߹������ĺ�");
			}else if("colldailylist".equals(type)){
				//root.addAttribute("caption", "�ɼ���Чͼ");
				//root.addAttribute("yAxisName", "������ڵ���");
				
				String tn = "����ɹ���/ƽ��������";
				String  explorationMethod = getExplorationMethod(projectInfoNo);
				if("0300100012000000002".equals(explorationMethod) ){
					//��ά
					tn = "����ɹ�����";
				} else {
					//��ά
					tn = "�����ƽ��������";
				}
				
				
				root.addAttribute("yAxisName", tn);
				
				
			}else if("drilldailylist".equals(type)){
				//root.addAttribute("caption", "�꾮��Чͼ");
				root.addAttribute("yAxisName", "������ڵ���");
			}
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "0");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");
			
			Element categories = root.addElement("categories");
			Element designDataset = root.addElement("dataset");
			designDataset.addAttribute("seriesName", "�����Ч");
			//designDataset.addAttribute("Color", "0000FF");
			designDataset.addAttribute("color", "1381c0");
			designDataset.addAttribute("anchorBorderColor", "1381c0");
			designDataset.addAttribute("anchorBgColor", "1381c0");
			
			Element actualDataset = root.addElement("dataset");
			actualDataset.addAttribute("seriesName", "ʵ����Ч");
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
				
				// ��������
				Element category = categories.addElement("category");
				category.addAttribute("label", xAxisDate.substring(5));
				//�������
				//���ֵ
				Element designSet = designDataset.addElement("set");
				if(DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0){
				}else{
					//�������Ч��Ϊ0��ʱ��,showFlag = true
					if(!showFlag){
						if(Float.parseFloat(recordMap.get("design_data").toString())>0){
							showFlag = true;
						}
					}
					
					if(showFlag){
						designSet.addAttribute("value", design_value);
					}
				}
				
				//�ձ�ֵ
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

		double designWorkLoad = 0;// ��ƹ�����
		double dailyWorkLoad = 0;// �ձ�������
		double sum_designWorkLoad = 0;// ��ƹ�����֮��
		double sum_dailyWorkLoad = 0;// �ձ�������֮��
		double sum_curDesignWorkLoad = 0;
		double sum_curDailyWorkLoad = 0;
		double avgWorkLoad = 1;// ���7��ƽ��������
		DecimalFormat df = new DecimalFormat("0.00");
		Date curDate = new Date();// ��ǰ����
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sCurDate = sdf.format(curDate);
		
		boolean noDailyData = false;
		
		String chatInfo = "";
		String xmlData = "";
		String taskName = "";
		String unitName = "��";
		String endFlagColumn = "survey_process_status";
		
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			designColumn = "workload_num";
			dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
			taskName = "����";
			ifBuild = "4";
			unitName = "km";
		} else if (type == "colldailylist" || "colldailylist".equals(type)) {
			designColumn = "workload";
			dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0) ";
			taskName = "�ɼ�";
			ifBuild = "6";
			endFlagColumn = "collect_process_status";
		} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
			designColumn = "workload";
			dailyColumn = " nvl(daily_drill_sp_num,0) ";
			taskName = "�꾮";
			ifBuild = "5";
			endFlagColumn = "drill_process_status";
		}

		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+
		
		//String getLastDailyDate = "select max(t.produce_date) as last_daily_date from gp_ops_daily_report t where t.bsflag = '0' and t.audit_status = '3' and t.project_info_no = '"+projectInfoNo+"'";
		//String lastDailyDate = (String) radDao.queryRecordBySQL(getLastDailyDate).get("last_daily_date");

		// ȡ�����ʼ���ڡ�����ۻ�ֵ
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
		
		// ȡ�ձ���ʼ���ڡ��ձ��ۻ�ֵ
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
			// û���ձ�����
			if("".equals(dailyStartDate)){
				noDailyData = true;
			}
		}
		// ȡ��ֹ��ǰ����ƹ�����
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
		// ȡ��ֹ��ǰ��ʵ�ʹ�����
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
		// ȡ��ǰ����Ľ���״̬
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
		// ������Ŀ��ʼ�����ڵ����� ���ڼ������ֵ,ʵ�ʽ���ʱ��-�ƻ���ʼʱ��
		long projectUpToNowDays = DateOperation.diffDaysOfDate(dailyEndDate, designStartDate)+1;
		
		// ������Ŀʵ�ʿ�ʼ�����ڵ����� ���ڼ���ʵ��ֵ,ʵ�ʽ���ʱ��-ʵ�ʿ�ʼʱ�� 
		long actualWorkDays = DateOperation.diffDaysOfDate(dailyEndDate, dailyStartDate)+1;
		
		//������Ŀ��ʼ�����ڵ�ʩ������ ������ͣ����
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
		
		// ���㵱ǰ�����ƽ����Ч
		double curDesignAvgWorkLoad = 0;
		if (projectUpToNowDays != 0) {
			curDesignAvgWorkLoad = sum_curDesignWorkLoad / projectUpToNowDays;
		}
		// ���㵱ǰ��ʵ��ƽ����Ч
		double curDailyAvgWorkLoad = 0;
		if (projectUpToNowDays != 0) {
			curDailyAvgWorkLoad = sum_curDailyWorkLoad / workDay;
		}
		
		long compareDate = DateOperation.diffDaysOfDate(dailyEndDate, designEndDate);
		if(compareDate >= 0){
			chatInfo = "����"+ dailyEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		}else{
			chatInfo = "����"+ dailyEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		}
		
		//֮ǰ���������õ���dailyEndDate,��ͼ���ϵ�ʱ�䲻��
		//chatInfo = "����"+ dailyEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";

		//��designEndDate,�ܺ�ͼ���ϵ�ʱ���Ӧ��
		//chatInfo = "����"+ designEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
		
		// ȡ����
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

		// �������7�칤������Ϊ�������
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
			//root.addAttribute("xAxisName", "����");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "16");
			root.addAttribute("palette", "2");
			root.addAttribute("baseFontSize", "12");
			//root.addAttribute("labelDisplay", "none");
			//root.addAttribute("labelStep", "3");
			
			if ("measuredailylist".equals(type)) {
				//root.addAttribute("caption", "������Ч�ۻ�ͼ");
				root.addAttribute("yAxisName", "�ս����߹������������߹������ĺ�");
			} else if ("colldailylist".equals(type)) {
				//root.addAttribute("caption", "�ɼ���Ч�ۻ�ͼ");
				root.addAttribute("yAxisName", "������ڵ���");
			} else if ("drilldailylist".equals(type)) {
				//root.addAttribute("caption", "�꾮��Ч�ۻ�ͼ");
				root.addAttribute("yAxisName", "������ڵ���");
			}
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "0");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");

			Element categories = root.addElement("categories");
			Element designDataset = root.addElement("dataset");
			designDataset.addAttribute("seriesName", "�����Ч");
			//designDataset.addAttribute("Color", "0000FF");
			designDataset.addAttribute("lineDashed", "1");
			designDataset.addAttribute("color", "1381c0");
			designDataset.addAttribute("anchorBorderColor", "1381c0");
			designDataset.addAttribute("anchorBgColor", "1381c0");
			
			Element actualDataset = root.addElement("dataset");
			actualDataset.addAttribute("seriesName", "ʵ����Ч");
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

					// ��������
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					// �������
					// ���ֵ
					Element designSet = designDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
					} else {
						if(designWorkLoad > 0){
							designSet.addAttribute("value", "" + designWorkLoad);
						}
					}
					// �ձ�ֵ
					Element actualSet = actualDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
						actualSet.addAttribute("value", "" + dailyWorkLoad);
					}
				}
				chatInfo = chatInfo + taskName + "���������;�ۼ����"+df.format(dailyWorkLoad)+""+unitName;
			} else {
				Element forcastDataset = root.addElement("dataset"); // ʣ�๤������Ԥ�������Ч
				forcastDataset.addAttribute("seriesName", "Ԥ�������Ч");
				//forcastDataset.addAttribute("Color", "Olive");
				forcastDataset.addAttribute("color", "e7d948");
				forcastDataset.addAttribute("anchorBorderColor", "e7d948");
				forcastDataset.addAttribute("anchorBgColor", "e7d948");
				
				Element planDataset = root.addElement("dataset"); // ʣ�๤�������ƻ����������Ч
				//planDataset.addAttribute("seriesName", "�ƻ������Ч");
				
				//����������ƻ������Ч����Ϊ�����ƻ����������Ч��(20130403)
				planDataset.addAttribute("seriesName", "���ƻ����������Ч");
				
				//planDataset.addAttribute("Color", "66FF00");
				planDataset.addAttribute("color", "95a700");
				planDataset.addAttribute("anchorBorderColor", "95a700");
				planDataset.addAttribute("anchorBgColor", "95a700");
				
				String axisEndDate = designEndDate;
				if (DateOperation.diffDaysOfDate(dailyEndDate, designEndDate) > 0) {
					axisEndDate = dailyEndDate;
				}
				// ����Ԥ�������Ч
				String forcastFinishDate = dailyEndDate; // Ԥ���������
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
					chatInfo = chatInfo + "��Ŀǰ����������㣬ʣ�๤����" + df.format(sum_designWorkLoad - sum_dailyWorkLoad) + unitName + "��Ԥ���������Ϊ" + forcastFinishDate + "����" + forcastFinishDays + "��.";
				}
				// ���㰴�ƻ����������Ч(��ǰ����С�ڼƻ�����ʱ)
				boolean planFinishLine = false;
				double planFinishWorkLoad = 0;
				long drawPlanDays = 1;
				long diffDays = DateOperation.diffDaysOfDate(designEndDate,	dailyEndDate);
				// long diffDays = DateOperation.diffDaysOfDate(designEndDate,dailyEndDate);
				if (diffDays > 0) {
					// ��ƹ�������ȥʵ����ɹ����� / ʣ������
					planFinishWorkLoad = (long)(sum_designWorkLoad - sum_dailyWorkLoad)/ diffDays;
					planFinishLine = true;
					chatInfo = chatInfo + "���ƻ�ʱ����ɣ�������ЧΪ" + df.format(planFinishWorkLoad) + unitName + ".";
				}else{
					chatInfo = chatInfo + "ʵ�ʹ��������ѳ����������.";
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
					// ��������
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					// �������
					// ���ֵ
					Element designSet = designDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
					} else {
						designSet.addAttribute("value", "" + designWorkLoad);
					}
					// �ձ�ֵ
					Element dailySet = actualDataset.addElement("set");
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
							dailySet.addAttribute("value", "" + dailyWorkLoad);
					}
					// ���ƻ������Чֵ
					Element planSet = planDataset.addElement("set");
					if (planFinishLine) {
						if(xAxisDate.equals(dailyEndDate)) {
							planSet.addAttribute("value", "" + sum_dailyWorkLoad);
							planSet.addAttribute("Color", "95a700");
							planSet.addAttribute("toolText", "ʵ����Ч,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
						}
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0) {
							planSet.addAttribute("value", "" + (sum_dailyWorkLoad + planFinishWorkLoad * drawPlanDays));
							drawPlanDays++;
						}
					}
					// Ԥ�������Чֵ
					Element forcastSet = forcastDataset.addElement("set");
					if (xAxisDate.equals(dailyEndDate)) {
						forcastSet.addAttribute("value", "" + sum_dailyWorkLoad);
						forcastSet.addAttribute("Color", "e7d948");
						forcastSet.addAttribute("toolText", "ʵ����Ч,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
					}
					if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0 && DateOperation.diffDaysOfDate(forcastFinishDate, xAxisDate) >= 0) {
						drawForcastDays++;
						forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
					}
				}

				// Ԥ����������Ƿ��������Ľ�������(������׷����������)
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
				chatInfo = "��ǰ�ձ�û��ʵ�ʹ�������.";
			}
			repMsg.setValue("xmlData", xmlData);
			repMsg.setValue("chatInfo", chatInfo);
		}else{
			//û�мƻ�����
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
		
		// ȡ�����ʼ����
		String designDateSql = "select min(record_month) as min_date, max(record_month) as max_date from gp_proj_product_plan where bsflag = '0' and project_info_no = '"+projectInfoNo+"'  and oper_plan_type = '"+type+"'";
		Map dateRecord = radDao.queryRecordBySQL(designDateSql);
		if(dateRecord != null){
			designStartDate = "" + dateRecord.get("min_date");
			designEndDate = "" + dateRecord.get("max_date");
		}
		// ȡ�ձ���ʼ����
		String dailyDateSql = "select to_char(min(produce_date),'yyyy-MM-dd') as min_date,to_char(max(produce_date),'yyyy-MM-dd') as max_date from gp_ops_daily_report where audit_status = '3' and bsflag = '0' and project_info_no = '"+projectInfoNo+"' and "+ dailyColumn + " > 0";
		dateRecord = radDao.queryRecordBySQL(dailyDateSql);
		if(dateRecord != null){
			dailyStartDate = "" + dateRecord.get("min_date");
			dailyEndDate = "" + dateRecord.get("max_date");
		}
		
		// ȡ���� (20130903������һ������״̬)
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
			
			//root.addAttribute("xAxisName", "����");
			if("measuredailylist".equals(type)){
				//root.addAttribute("caption", "������Чͼ");
				root.addAttribute("yAxisName", "�ս����߹������������߹������ĺ�");
			}else if("colldailylist".equals(type)){
				//root.addAttribute("caption", "�ɼ���Чͼ");
				root.addAttribute("yAxisName", "������ڵ���");
			}else if("drilldailylist".equals(type)){
				//root.addAttribute("caption", "�꾮��Чͼ");
				root.addAttribute("yAxisName", "������ڵ���");
			}
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "0");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");
			
			Element categories = root.addElement("categories");
			Element designDataset = root.addElement("dataset");
			designDataset.addAttribute("seriesName", "�����Ч");
			//designDataset.addAttribute("Color", "0000FF");
			designDataset.addAttribute("color", "1381c0");
			designDataset.addAttribute("anchorBorderColor", "1381c0");
			designDataset.addAttribute("anchorBgColor", "1381c0");
			
			Element actualDataset = root.addElement("dataset");
			actualDataset.addAttribute("seriesName", "ʵ����Ч");
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
				
				// ��������
				Element category = categories.addElement("category");
				category.addAttribute("label", xAxisDate.substring(5));
				//�������
				//���ֵ
				Element designSet = designDataset.addElement("set");
				if(DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0){
				}else{
					//�������Ч��Ϊ0��ʱ��,showFlag = true
					if(!showFlag){
						if(Float.parseFloat(recordMap.get("design_data").toString())>0){
							showFlag = true;
						}
					}
					
					if(showFlag){
						designSet.addAttribute("value", design_value);
					}
				}
				
				//�ձ�ֵ
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
