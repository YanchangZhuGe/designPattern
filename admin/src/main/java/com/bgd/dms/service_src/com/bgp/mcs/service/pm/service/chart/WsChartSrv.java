package com.bgp.mcs.service.pm.service.chart;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.pm.service.p6.project.ProjectWSBean;
import com.bgp.mcs.service.pm.service.project.WorkMethodSrv;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.primavera.ws.p6.project.Project;

public class WsChartSrv extends BaseService {
	
	private ILog log;
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	
	public WsChartSrv(){
		log = LogFactory.getLogger(WsChartSrv.class);
	}

	
	public ISrvMsg getData(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			return msg;
		}
		
		String type = reqDTO.getValue("type");
		if (type == null || "".equals(type)) {
			return msg;
		}
		String graphStyle = reqDTO.getValue("graphStyle");
		if (graphStyle == null || "".equals(graphStyle)) {
			return msg;
		}
		String sql = "select workload as paodian,workload_num as gongli,to_char(to_date(record_month,'yyyy-MM-dd'),'MM-dd') as record_month,to_date(record_month,'yyyy-MM-dd') as data" +
				" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' " +
				" and oper_plan_type = '"+type+"' order by record_month ";
		
		List<Map> list = radDao.queryRecords(sql);
		
		if (list == null || list.size() == 0) {
			return msg;
		}
		
		String xml = "";
		//标题 x坐标标题 y坐标标题 是否显示数据
		if (type == "colldailylist" || "colldailylist".equals(type)) {
			//采集
			xml = "<chart caption='采集工作量' xAxisName='日期' yAxisName='炮点数' showValues='0' >";
		} else if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			//测量
			xml = "<chart caption='测量工作量' xAxisName='日期' yAxisName='工作量' showValues='0' >";
		} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
			//钻井
			xml = "<chart caption='钻井工作量' xAxisName='日期' yAxisName='炮点数' showValues='0' >";
		}
		
		//x坐标绘制
		xml += "<categories>";
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			xml += "<category label='"+map.get("record_month")+"' />";
		}
		xml += "</categories>";
		
		String minDate = (String) ((Map) list.get(0)).get("data");
		String maxDate = (String) ((Map) list.get(list.size()-1)).get("data");
		
		long cumulativeValue = 0;
		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");//[0-9]+(.[0-9]?)?+
		
		//数据绘制
		xml += "<datase seriesName='设计工作量'>";
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			for (int i = 0; i < list.size(); i++) {
				Map map = list.get(i);
				if("2".equals(graphStyle)){
					String value = "" +map.get("gongli");
					Matcher isNum = pattern.matcher(value);
					if(isNum.matches()){
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='" + cumulativeValue + "' />";
				}else if("1".equals(graphStyle)){
					xml += "<set value='"+map.get("gongli")+"' />";
				}
			}
		} else {
			for (int i = 0; i < list.size(); i++) {
				Map map = list.get(i);
				if("2".equals(graphStyle)){
					String value = "" +map.get("paodian");
					Matcher isNum = pattern.matcher(value);
					if(isNum.matches()){
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='" + cumulativeValue + "' />";
				}else if("1".equals(graphStyle)){
					xml += "<set value='"+map.get("paodian")+"' />";
				}
			}
		}
		xml += "</dataset>";
		
		sql = "select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)) as coll_value" +
				",sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value"+
				",sum(nvl(d.daily_drill_sp_num,0)) as drill_value"+
				",produce_date " +
				",produce_date-to_date('"+minDate+"','yyyy-MM-dd') as deviation_date"+
				" from gp_ops_daily_report d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' " +
				" and produce_date >= to_date('"+minDate+"','yyyy-MM-dd') and produce_date <= to_date('"+maxDate+"','yyyy-MM-dd')"+
				" group by produce_date order by produce_date ";
		
		list = radDao.queryRecords(sql);
		
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			if ((String) map.get("deviation_date") == "0" || "0".equals((String) map.get("deviation_date"))) {
				for (int i = 0; i < Integer.parseInt((String)map.get("deviation_date")); i++) {
					xml += "<set value='0' />";
				}
			}
		}
		
		cumulativeValue = 0;
		xml += "<dataset seriesName='实际工作量'>";
		if (type == "colldailylist" || "colldailylist".equals(type)) {
			//采集
			if("2".equals(graphStyle)){
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					String value = "" + map.get("coll_value");
					Matcher isNum = pattern.matcher(value);
					if(isNum.matches()){
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='"+cumulativeValue+"' />";
				}
			}else if("1".equals(graphStyle)){
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					xml += "<set value='"+map.get("coll_value")+"' />";
				}
			}
		} else if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			//测量
			if("2".equals(graphStyle)){
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					String value = "" + map.get("measure_value");
					Matcher isNum = pattern.matcher(value);
					if(isNum.matches()){
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='"+cumulativeValue+"' />";
				}
			}else if("1".equals(graphStyle)){
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					xml += "<set value='"+map.get("measure_value")+"' />";
				}
			}
		} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
			//钻井
			if("2".equals(graphStyle)){
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					String value = "" + map.get("drill_value");
					Matcher isNum = pattern.matcher(value);
					if(isNum.matches()){
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='"+cumulativeValue+"' />";
				}
			}else if("1".equals(graphStyle)){
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					xml += "<set value='"+map.get("drill_value")+"' />";
				}
			}
		}
		xml += "</dataset>";
		
		//样式区
		xml += "<styles>";
		xml += "<definition><style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' /></definition>";
		xml += "<application><apply toObject='Canvas' styles='CanvasAnim' /></application>";
		xml += "</styles>";
		xml += "</chart>";
		
		msg.setValue("Str", xml);
		System.out.println("xml:"+xml);
		
//		List<Map<String, Object>> jsonList = new ArrayList<Map<String,Object>>();
//		Map<String, Object> chart = new HashMap<String, Object>();
//		//chart
//		chart.put("caption", "采集工作量");//图标题
//		chart.put("xAxisName", "日期");//x坐标标题
//		chart.put("yAxisName", "工作量");//y坐标标题
//		chart.put("showValues", "0");//是否显示数字 0不显示 1显示
//		
//		//categories
//		Map<String, Object> category = new HashMap<String, Object>();
//		//category
//		List<Map<String, Object>> categoryList = new ArrayList<Map<String,Object>>();
//		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
//			Map<String, Object> temp = (Map<String, Object>) iterator.next();
//			Map<String, Object> map1 = new HashMap<String, Object>();
//			map1.put("label", temp.get("recordMonth"));
//			categoryList.add(map1);
//		}
//		category.put("category", categoryList);
//		
//		//dataset
//		Map<String, Object> dataset = new HashMap<String, Object>();
//		//set
//		List<Map<String, Object>> setList = new ArrayList<Map<String,Object>>();
//		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
//			Map<String, Object> temp = (Map<String, Object>) iterator.next();
//			Map<String, Object> map1 = new HashMap<String, Object>();
//			map1.put("value", temp.get("workload"));
//			setList.add(map1);
//		}
//		dataset.put("seriesname", "设计工作量");
//		dataset.put("data", setList);
//		
//		//=====================样式======================
//		
//		//styles
//		Map<String, Object> styles = new HashMap<String, Object>();
//		//definition
//		Map<String, Object> definition = new HashMap<String, Object>();
//		//style
//		Map<String, Object> style = new HashMap<String, Object>();
//		style.put("name", "CanvasAnim");
//		style.put("type", "animation");
//		style.put("param", "xScale");
//		style.put("start", "0");
//		style.put("duration", "1");
//		
//		definition.put("style", style);
//		
//		
//		//application
//		Map<String, Object> application = new HashMap<String, Object>();
//		//apply
//		Map<String, Object> apply = new HashMap<String, Object>();
//		apply.put("toobject", "Canvas");
//		apply.put("styles", "CanvasAnim");
//		
//		application.put("apply", apply);
//		
//		styles.put("definition", definition);
//		styles.put("application", application);
		
		return msg;
	}
	
	
	public ISrvMsg getDeviation(ISrvMsg reqDTO) throws Exception{
		System.out.println("”进来了没有“");
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		//String projectInfoNo = user.getProjectInfoNo();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}
		
		WorkMethodSrv wm = new WorkMethodSrv();
		//String 	buildMethod = wm.getProjectExcitationMode(projectInfoNo);
		
		//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		//String curDate = format.format(new Date());
		
		String xml = "<chart showValues='0' numberSuffix='%' yAxisName='负数表示滞后，正数表示超前' rotateYAxisName='0' yAxisNameWidth='16'>";
		
		//标题 x坐标标题 y坐标标题 是否显示数据
		String[] types = {"measuredailylist","drilldailylist","colldailylist"};
		String[] typeNames = {"测量","钻井","采集"};
		String[] colors = {"1381c0","69bf5d","fd962e"};
		
		//String endFlagColumn = "survey_process_status";
		
		String designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month " +
		" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' " +
		" and oper_plan_type in('colldailylist','measuredailylist','drilldailylist') order by record_month";
		
		List<Map> designDateList = radDao.queryRecords(designDateSql);
		if (designDateList == null || designDateList.size() == 0) {
			return msg;
		}
		//x坐标绘制
		@SuppressWarnings("unused")
		String axis_start_date = "";
		String axis_end_date = "";
		List axisDateList = new ArrayList();
		xml += "<categories>";
		for (int i = 0; i < designDateList.size(); i++) {
			Map map = designDateList.get(i);
			String axis_date = "" + map.get("record_month");
			axisDateList.add(axis_date);
			if(i==0){
				axis_start_date = axis_date;
			}else if(i == designDateList.size() - 1){
				axis_end_date = axis_date;
			}
			xml += "<category label='" + axis_date.substring(5) + "' />";
		}
		//实际生产日期大于设计日期,追加大于设计的日期
		//2012-11-21 卢占国提出实际大于设计不添加日期
		int addDay = 0;
		String dailyDateSql = " select to_char(produce_date,'yyyy-MM-dd') as produce_date from gp_ops_daily_report_ws where project_info_no = '" + projectInfoNo + "' and bsflag = '0' order by produce_date";
		List<Map> dailyDateList = radDao.queryRecords(dailyDateSql);
		for (int i = 0; i < dailyDateList.size(); i++) {
			Map map = dailyDateList.get(i);
			String axis_date = "" + map.get("produce_date");
			if(DateOperation.diffDaysOfDate(axis_date, axis_end_date) > 0){
				//xml += "<category label='" + axis_date.substring(5) + "' />";
				axis_end_date = axis_date;
				axisDateList.add(axis_date);
				addDay++;
			}
		}
		xml += "</categories>";
		
		List<Map> gridData = new ArrayList<Map>();
		String existDrillData = "yes";
		for(int m=0; m<types.length; m++){
			String type = types[m];
			String typeName = typeNames[m];
			Map lineMap = new HashMap();
//			if("drilldailylist".equals(type)){
//				if("5000100003000000002".equals(buildMethod)){
//					lineMap.put("status","");
//					lineMap.put("groupLine","");
//					lineMap.put("designWorkLoad","");
//					lineMap.put("dailyWorkLoad","");
//					lineMap.put("finishPercentage","");
//					lineMap.put("deviation","");
//					lineMap.put("date","");
//					gridData.add(lineMap);
//					existDrillData = "no";
//					continue;
//				}
//			}
			String dailyColumn="";
			if (type == "measuredailylist" || "measuredailylist".equals(type)) {
				dailyColumn = " nvl(DAILY_SURVEY_POINT_NUM_WS,0) ";
				//endFlagColumn = "survey_process_status";
			} else if (type == "colldailylist" || "colldailylist".equals(type)) {
				dailyColumn = " nvl(DAILY_ACQUIRE_SP_NUM,0)";
				//endFlagColumn = "collect_process_status";
			} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
				dailyColumn = " nvl(daily_drill_sp_num,0) ";
				//endFlagColumn = "drill_process_status";
			}
			
			String sql = "select nvl(workload,0) as paodian,nvl(workload_num,0) as gongli,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,to_date(record_month,'yyyy-MM-dd') as data" +
			" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' " +
			" and oper_plan_type = '"+type+"' order by record_month ";
			
			List<Map> designList = radDao.queryRecords(sql);
			String minDate = (String) ((Map) designList.get(0)).get("record_month");
			String maxDate = (String) ((Map) designList.get(designList.size()-1)).get("record_month");
			String produceStartDate = "";
			String produceEndDate = "";
			String produceCurDate = "";
			
			// 取当前工序的结束状态
			String endFlagSql = "select IF_BUILD as end_flag from gp_ops_daily_report_ws d "
				+ " where d.produce_date = (select max(produce_date) from gp_ops_daily_report_ws where project_info_no = '" + projectInfoNo + "' and audit_status = '3' and bsflag = '0' and "+ dailyColumn + " > 0) "
				+ " and project_info_no = '"+projectInfoNo +"' and d.bsflag = '0'";
			String statusDesc = "";
			Map recordMap = radDao.queryRecordBySQL(endFlagSql);
			if (recordMap != null) {
				String value = "" + recordMap.get("end_flag");
				if("9".equals(value)){
					statusDesc = "结束";
				}else{
					statusDesc = "正在施工";
				}
			}else{
				statusDesc = "未开始";
			}
			
			// 取施工线束
			sql = "select a.* from bgp_p6_activity a"
				+" join bgp_p6_project_wbs w on w.object_id = a.wbs_object_id and w.bsflag = '0' "
				+" join bgp_p6_project p on p.object_id = w.project_object_id and w.name = '"+typeName+"'"
				+" and p.project_info_no = '" + projectInfoNo+"'"
				+" where a.status = 'In Progress'";//Completed In Progress
			List<Map> groupLineList = radDao.queryRecords(sql);
			String groupLineName = "";
			if(groupLineList != null){
				for(int i=0; i<groupLineList.size(); i++){
					Map groupLineMap = groupLineList.get(i);
					String value = "" + groupLineMap.get("name");
					if(!"".equals(value)){
						groupLineName = groupLineName + "&nbsp;&nbsp;"+ value;
					}
				}	
			}
			lineMap.put("status", statusDesc);
			lineMap.put("groupLine", groupLineName);
									
			sql = "select sum(nvl(d.daily_acquire_sp_num,0)) as coll_value" +
					",sum(nvl(d.DAILY_SURVEY_POINT_NUM_WS,0)) as measure_value"+
					",sum(nvl(d.daily_drill_sp_num,0)) as drill_value"+
					",sum(nvl(d.DAILY_SURFACE_POINT_NUM,0)) as surface_value"+
					",to_char(produce_date,'yyyy-MM-dd') as produce_date" +
				//",produce_date-to_date('"+minDate+"','yyyy-MM-dd') as deviation_date"+
					" from gp_ops_daily_report_ws d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and audit_status = '3'" +
					" and " + dailyColumn + " > 0 " +
				//" and produce_date >= to_date('"+minDate+"','yyyy-MM-dd') and produce_date <= to_date('"+maxDate+"','yyyy-MM-dd')"+
					" group by produce_date order by produce_date ";
			
			xml += "<dataset color='"+colors[m]+"' anchorBorderColor='"+colors[m]+"' anchorBgColor='"+colors[m]+"' seriesName='" + typeName + "偏离度'>";
			
//			// add by liweiming
//			if(DateOperation.diffDaysOfDate(minDate, axis_start_date) > 0){
//				long diffDays = DateOperation.diffDaysOfDate(minDate, axis_start_date);
//				for(int k=0; k<diffDays; k++){
//					xml += "<set/>";
//				}
//			}
//			// end add by liweiming
			
			List<Map> dailyList = radDao.queryRecords(sql);
			if(dailyList != null && dailyList.size() > 0){
				produceStartDate = (String) ((Map) dailyList.get(0)).get("produce_date");
				produceCurDate = (String) ((Map) dailyList.get(dailyList.size()-1)).get("produce_date");
				if("结束".equals(statusDesc) || "结束" == statusDesc){
					produceEndDate = (String) ((Map) dailyList.get(dailyList.size()-1)).get("produce_date");
				}				
			}
			
			DecimalFormat df = new DecimalFormat();
			String style = "0.00";
			
			df.applyPattern(style);
			
			int actualNum = 0;
			int designNum = 0;
			double radio = 0.0;
			
			//阀值
			double value = 100;
			double sum_daily_num = 0;
			double sum_design_num = 0;
			
			String designDateColumn = "record_month";
			String dailyDateColumn = "produce_date";
			String designValueColumn = "";
			String dailyValueColumn = "";
			
//			String[] measure2Type = {"G02003","G02004"};
//			String[] measure3Type = {"G2003","G2004"};
//			
//			String[] drill2Type = {"G05001"};
//			String[] drill3Type = {"G5001"};
//			
//			String[] coll2Type = {"G07001","G07003","G07005"};
//			String[] coll3Type = {"G7001","G7003","G7005"};
			String measureType = "G9001";//测量
			String drillType = "G1001";//钻井
			String collType = "G1301";//采集

			
			//sql = "select exploration_method from gp_task_project  where project_info_no = '"+projectInfoNo+"' and bsflag = '0'";
			//List<Map> list = radDao.queryRecords(sql);
			
			//String exploration_method = null;
//			if (list != null && list.size() != 0) {
//				Map map = (Map) list.get(0);
//				exploration_method = (String) map.get("exploration_method");
//			} else {
//				return null;
//			}
			
			String sqlTemp = "";
			
			if (type == "colldailylist" || "colldailylist".equals(type)) {
				//采集
				designValueColumn = "paodian";
				dailyValueColumn = "coll_value";
				System.out.println("0000000000000000000");
				sqlTemp = "select nvl(sum(planned_units),0) as num from bgp_p6_workload where project_info_no = '"+projectInfoNo+"' and produce_date is null and bsflag = '0' and resource_id = '"+collType+"'";
				System.out.println("1111111111111111111111111111111"+sqlTemp);
			} else if (type == "measuredailylist" || "measuredailylist".equals(type)) {
				//测量
				designValueColumn = "gongli";
				dailyValueColumn = "measure_value";
				sqlTemp = "select nvl(sum(planned_units),0) as num from bgp_p6_workload where project_info_no = '"+projectInfoNo+"' and produce_date is null and bsflag = '0' and resource_id = '"+measureType+"'";
			} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
				//钻井
				designValueColumn = "paodian";
				dailyValueColumn = "drill_value";
				sqlTemp = "select nvl(sum(planned_units),0) as num from bgp_p6_workload where project_info_no = '"+projectInfoNo+"' and produce_date is null and bsflag = '0' and resource_id = '"+drillType+"'";

			}
			Map designData = new HashMap();
			Map dailyData = new HashMap();
			
			for (int i = 0; i < designList.size(); i++) {
				Map designMap = designList.get(i);
				String designDate = "" + designMap.get(designDateColumn);
				String designValue = "" + designMap.get(designValueColumn);
				designData.put(designDate, designValue);
			}
			for (int i = 0; i < dailyList.size(); i++) {
				Map dailyMap = dailyList.get(i);
				String produce_date = "" + dailyMap.get(dailyDateColumn);
				String dailyValue = "" + dailyMap.get(dailyValueColumn);
				dailyData.put(produce_date, dailyValue);
			}
			
			//System.out.println("type:"+type);
			
			for(int i=0; i<axisDateList.size(); i++){
				String axisDate = "" + axisDateList.get(i);
				
				if(DateOperation.diffDaysOfDate(produceCurDate, axisDate) >= 0){
					String designValue = "" + designData.get(axisDate);
					String dailyValue = "" + dailyData.get(axisDate);
					
					if("null".equals(designValue) || "".equals(designValue)){
						designValue = "0";
					}
					if("null".equals(dailyValue) || "".equals(dailyValue)){
						dailyValue = "0";
					}
					double designNum1 = Double.parseDouble(designValue);
					double actualNum1 = Double.parseDouble(dailyValue);
					sum_daily_num += actualNum1;
					//设计值改为从bgp_p6_workload中查询
					sum_design_num += designNum1;
					//System.out.println("axisDate:"+axisDate);
					//System.out.println("sum_design_num"+sum_design_num);
					//System.out.println("sum_daily_num"+sum_daily_num);
					if(DateOperation.diffDaysOfDate(axisDate, minDate) >=0 && DateOperation.diffDaysOfDate(maxDate, axisDate) >=0 ){
						if(sum_design_num == 0){
							radio = 0;
						}else{
							radio = (double)(sum_daily_num - sum_design_num) /sum_design_num*100;							
						}
						
						xml += "<set value='"+df.format(radio)+"' />";
						
					}else{
						xml += "<set/>";
					}
					if(DateOperation.diffDaysOfDate(axisDate, minDate) >=0 && DateOperation.diffDaysOfDate(produceEndDate, axisDate) >=0 ){
						if(sum_design_num == 0){
							radio = 0;
						}else{
							radio = (double)(sum_daily_num - sum_design_num) /sum_design_num*100;
						}
					}
				}
			}
			
			//sql = "select sum(nvl(planned_units,0)) as num from bgp_p6_workload where project_info_no = '"+projectInfoNo+"' and produce_date is null and bsflag = '0' and resource_id in ";
			//sql += sqlTemp;
			//break 1
//			System.out.println("The sql is:"+sqlTemp);
			List<Map> list_temp = radDao.queryRecords(sqlTemp);
			if (list_temp != null && list_temp.size() != 0) {
					Map map = list_temp.get(0);
					//之前设计工作量的赋值
					//20130415又改回这个了
					lineMap.put("designWorkLoad", "" + (String)map.get("num"));
					if(Double.parseDouble((String)map.get("num")) == 0){
						lineMap.put("finishPercentage",0);
					}else{
						lineMap.put("finishPercentage", "" + df.format(sum_daily_num / Double.parseDouble((String)map.get("num")) * 100));
					}
			}
			
			//现在设计工作量的赋值
			//lineMap.put("designWorkLoad", "" + df.format(sum_design_num));
			lineMap.put("dailyWorkLoad", "" + df.format(sum_daily_num));
			//lineMap.put("finishPercentage", "" + df.format(sum_daily_num / sum_design_num * 100));
			//改成从bgp_p6_workload中查询设计工作量
			
			if (DateOperation.diffDaysOfDate(produceEndDate, maxDate) > 0) {
				lineMap.put("deviation", "超出计划日期"+DateOperation.diffDaysOfDate(produceEndDate, maxDate)+"天");
				
			} else if(DateOperation.diffDaysOfDate(minDate, produceEndDate) > 0) {
				lineMap.put("deviation", "实际比计划早开始"+DateOperation.diffDaysOfDate(minDate, produceStartDate)+"天");
				
			} else if(DateOperation.diffDaysOfDate(maxDate, produceEndDate) > 0) {
				lineMap.put("deviation", "实际比计划提前完成"+DateOperation.diffDaysOfDate(maxDate, produceEndDate)+"天");
				
			} else {
				lineMap.put("deviation", "" + df.format(radio));
				
			}
			lineMap.put("date", produceEndDate);
			lineMap.put("designDate", maxDate);
			lineMap.put("startDate", produceStartDate);
			lineMap.put("minDesignDate", minDate);
			gridData.add(lineMap);
			
//			else if (type == "surfacedailylist" || "surfacedailylist".equals(type)) {
//				//表层
//				for (int i = 0; i < list.size(); i++) {
//					Map map = list.get(i);
//					Map map1 = designList.get(i);
//					actualNum = Integer.parseInt((String) map.get("surface_value"));
//					designNum = Integer.parseInt((String) map1.get("paodian"));
//					radio = Math.abs((double)(designNum - actualNum) /designNum)*100;
//					if (radio >= value) {
//						xml += "<set value='"+df.format(radio)+"' />";
//					} else {
//						xml += "<set value='"+df.format(radio)+"' />";
//					}
//				}
//			}
			
			xml += "</dataset>";
		}
		//阀值线
		xml += "<trendlines>";
		
		//xml += "<line startValue='-30'  displayValue='健康' showOnTop='1' color='69bf5d'   valueOnRight='1'  dashed='1'  thickness='2'/>";
		
		//xml += "<line startValue='30' color='91C728' displayValue='健康' showOnTop='1'/>";
		
		//xml += "<line startValue='-60' color='AA0000' displayValue='危险' showOnTop='1'  valueOnRight='1'  dashed='1'  thickness='2'/>";
		
		//xml += "<line startValue='60' color='AA0000' displayValue='危险' showOnTop='1'/>";
		
		xml += "<line startValue='0' color='000000' showOnTop='0' thickness='2'/>";
		
	      
	   xml += "</trendlines>";
		
		//样式区
		xml += "<styles>";
		xml += "<definition><style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' /></definition>";
		xml += "<application><apply toObject='Canvas' styles='CanvasAnim' /></application>";
		xml += "</styles>";
		xml += "</chart>";
		
		msg.setValue("Str", xml);
		msg.setValue("existDrillData", existDrillData);
		msg.setValue("gridData", gridData);
		return msg;
	}
	
	public ISrvMsg getProjectDynamic(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		if (orgSubjectionId == null || "".equals(orgSubjectionId)) {
			orgSubjectionId = user.getSubOrgIDofAffordOrg();
		}
		//String orgId = user.getCodeAffordOrgID();
		
		Date date = new Date();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String d = sdf.format(date);
		
		String sql = "select count(gp.project_info_no) as num,project_status from gp_task_project gp "+
			" join gp_task_project_dynamic dy "+
			" on dy.project_info_no = gp.project_info_no "+
			" and dy.exploration_method = gp.exploration_method "+
			" and dy.bsflag = '0' and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
			" where gp.bsflag = '0' "+
			" and gp.project_status is not null "+
			" and gp.acquire_start_time >= to_date('"+d.substring(0, 4)+"-01-01','yyyy-MM-dd')"+
			" group by  gp.project_status";
		
		List<Map> list = radDao.queryRecords(sql);
		
		int workNum = 0;//施工
		int stopNum = 0;//停工
		int readyNum = 0;//准备
		int pauseNum = 0;//暂停
		
		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
			Map map = (Map) iterator.next();
			if ("5000100001000000001".equals((String)map.get("project_status"))) {
				//准备
				readyNum = Integer.parseInt((String)map.get("num"));
			} else if ("5000100001000000002".equals((String)map.get("project_status"))) {
				//施工
				workNum = Integer.parseInt((String)map.get("num"));
			} else if ("5000100001000000003".equals((String)map.get("project_status"))) {
				//项目结束
				stopNum = Integer.parseInt((String)map.get("num"));
			} else if ("5000100001000000004".equals((String)map.get("project_status"))) {
				//暂停
				pauseNum = Integer.parseInt((String)map.get("num"));
			} else if ("5000100001000000005".equals((String)map.get("project_status"))) {
				//施工结束
				stopNum = Integer.parseInt((String)map.get("num"));
			}
		}
		
		Map map = new HashMap();
		map.put("workNum", workNum);
		map.put("stopNum", stopNum);
		map.put("readyNum", readyNum);
		map.put("pauseNum", pauseNum);
		
		map.put("startDate", d.substring(0, 4)+"-01-01");
		map.put("endDate", d);
		
		sql = "select oi.org_abbreviation as org_name from comm_org_information oi,comm_org_subjection os where oi.org_id = os.org_id and os.bsflag = '0' and os.org_subjection_id = '"+orgSubjectionId+"' and oi.bsflag = '0' ";
		
		list = radDao.queryRecords(sql);
		if (list != null && list.size() != 0) {
			map.put("orgName", list.get(0).get("org_name"));
		}
		
		sql = "select sum(nvl(rpt.daily_finishing_2d_sp,0)) as daily_finishing_2d_sp,sum(nvl(rpt.daily_finishing_3d_sp,0)) as daily_finishing_3d_sp,sum(nvl(rpt.finish_2d_workload,0)) as finish_2d_workload,sum(nvl(rpt.finish_3d_workload,0)) as finish_3d_workload from rpt_gp_daily rpt where org_subjection_id like '"+orgSubjectionId+"%' and bsflag = '0' ";
		list = radDao.queryRecords(sql);
		if (list != null && list.size() != 0) {
			map.putAll(list.get(0));
		}
		
		DecimalFormat df = new DecimalFormat();
		String style = "0.00%";
		
		df.applyPattern(style);
		
		sql = "select distinct gp.project_info_no,gp.project_name,ccsd.coding_name,oi.org_abbreviation,gp.vsp_team_leader,dy.design_object_workload,dy.design_sp_num "+
				" ,case gp.exploration_method when '0300100012000000002' then sum(nvl(rpt.daily_finishing_2d_sp,0)) over (partition by rpt.project_info_no) else sum(nvl(rpt.daily_finishing_3d_sp,0)) over (partition by rpt.project_info_no) end as daily_sp "+
				" ,case gp.exploration_method when '0300100012000000002' then sum(nvl(rpt.finish_2d_workload,0)) over (partition by rpt.project_info_no) else sum(nvl(rpt.finish_3d_workload,0)) over (partition by rpt.project_info_no) end as daily_workload "+
				" ,case gp.project_status when '5000100001000000001' then '项目启动' when '5000100001000000002' then '正在施工' when '5000100001000000003' then '项目结束' when '5000100001000000004' then '项目暂停' when '5000100001000000005' then '施工结束' end as project_status "+
				" ,nvl(gp.project_end_time,gp.design_end_date) as project_end_date "+
				" ,pm_info,qm_info,hse_info"+
				" from gp_task_project gp "+
				" join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no and dy.bsflag = '0' and dy.exploration_method = gp.exploration_method and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
				" join comm_org_information oi on dy.org_id = oi.org_id "+
				" left join comm_coding_sort_detail ccsd on gp.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' "+
				" left join rpt_gp_daily rpt on rpt.project_info_no = gp.project_info_no and rpt.bsflag = '0'" +
				" left join bgp_pm_project_heath_info info on info.project_info_no = gp.project_info_no "+
				" where gp.acquire_start_time >= to_date('"+d.substring(0, 4)+"-01-01','yyyy-MM-dd') " +
				" and gp.project_status is not null and gp.bsflag = '0' ";
		
		List<Map> datas = radDao.queryRecords(sql);
		
		for (Iterator iterator = datas.iterator(); iterator.hasNext();) {
			Map data = (Map) iterator.next();
			String design_object_workload = (String) data.get("design_object_workload");
			String daily_workload = (String) data.get("daily_workload");
			
			if (design_object_workload == null || "".equals(design_object_workload) || daily_workload == null || "".equals(daily_workload)) {
				data.put("workload_radio", "0.00%");
			} else {
				double design_object_workload_num = Double.parseDouble(design_object_workload);
				if (design_object_workload_num == 0) {
					data.put("workload_radio", "0.00%");
				} else {
					double daily_workload_num = Double.parseDouble(daily_workload);
					
					data.put("workload_radio", df.format(daily_workload_num/design_object_workload_num));
				}
			}
			
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("map", map);
		msg.setValue("list", datas);
		
		return msg;
	}
	
	public ISrvMsg getGanntData(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getSubOrgIDofAffordOrg();
		
//		String[] measure2Type = {"G02003","G02004"};
//		String[] measure3Type = {"G2003","G2004"};
//		
//		String[] drill2Type = {"G05001"};
//		String[] drill3Type = {"G5001"};
//		
//		String[] coll2Type = {"G07001","G07003","G07005"};
//		String[] coll3Type = {"G7001","G7003","G7005"};
		
		//只显示非完成的项目 按照预计开始时间从上之下排列
		String sql = "select gp.exploration_method,gp.project_info_no,p6.object_id,gp.project_name,to_char(min(a.planned_start_date),'yyyy-MM-dd') as start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as end_date," +
				" to_char(min(a.actual_start_date),'yyyy-MM-dd') as actual_start_date,to_char(max(a.actual_finish_date),'yyyy-MM-dd') as actual_finish_date from gp_task_project gp " +
				" join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no and dy.bsflag = '0' and dy.org_subjection_id like '"+orgSubjectionId+"%' " +
				" join bgp_p6_project p6 on p6.project_info_no = gp.project_info_no and p6.bsflag = '0' "+
				" join bgp_p6_activity a on p6.object_id = a.project_object_id and a.bsflag = '0' "+
				" where gp.bsflag = '0' and gp.project_status<>'5000100001000000003' "+
				//" and gp.project_status not in ('5000100001000000003','5000100001000000005') "+
				" group by gp.exploration_method,gp.project_info_no,p6.object_id,gp.project_name " +
				" order by start_date";
		
		List<Map> datas = radDao.queryRecords(sql);
		
		Date date = new Date();
		Calendar c = Calendar.getInstance();
		Calendar c1 = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (datas != null && datas.size() != 0) {
			Map map = datas.get(0);
			String start_date = (String) map.get("start_date");
			//取开始日期减2个月，显示
			Date sss = sdf.parse(start_date);
			c.setTime(sss);
			c.add(Calendar.MONTH, -2);
			start_date = sdf.format(c.getTime());
			
			String[] dates = start_date.split("-");
			c.set(Calendar.YEAR, Integer.parseInt(dates[0]));
			c.set(Calendar.MONTH, Integer.parseInt(dates[1])-1);
			c.set(Calendar.DAY_OF_MONTH, 1);
			
			map = datas.get(datas.size()-1);
			String end_date = (String) map.get("end_date");
			dates = end_date.split("-");
			c1.set(Calendar.YEAR, Integer.parseInt(dates[0]));
			c1.set(Calendar.MONTH, Integer.parseInt(dates[1])-1);
			c1.set(Calendar.DAY_OF_MONTH, 1);
		}
		
		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+
		
		long endFlagDay = 0;
		
		String xml = "<chart dateFormat='yyyy-mm-dd' showSlackAsFill='0' ganttPaneDuration='12' ganttPaneDurationUnit='m' >";
//		String year = "2012";
//		xml += "<categories>";
//		xml += "<category start='"+year+"-01-01' end='"+year+"-04-01' label='一季度' />";
//		xml += "<category start='"+year+"-04-01' end='"+year+"-07-01' label='二季度' />";
//		xml += "<category start='"+year+"-07-01' end='"+year+"-10-01' label='三季度' />";
//		xml += "<category start='"+year+"-10-01' end='"+(year+1)+"-01-01' label='四季度' />";
//		xml += "</categories>";
		
		xml += "<categories>";
		for (int 	i = 0; i < 14; i++) {
			xml += "<category label='"+c.get(Calendar.YEAR)+"-"+(c.get(Calendar.MONTH)+1)+"' start='"+sdf.format(c.getTime());
			c.add(Calendar.MONTH, 1);
			xml += "' end='"+sdf.format(c.getTime())+"' />";
		}
		do {
			xml += "<category label='"+c.get(Calendar.YEAR)+"-"+(c.get(Calendar.MONTH)+1)+"' start='"+sdf.format(c.getTime());
			c.add(Calendar.MONTH, 1);
			xml += "' end='"+sdf.format(c.getTime())+"' />";
		} while (c1.after(c));
		xml += "</categories>";
		
//		xml += "<categories>";
//		xml += "<category start='"+year+"-01-01' end='"+year+"-02-01' label='1' />";
//		xml += "<category start='"+year+"-02-01' end='"+year+"-03-01' label='2' />";
//		xml += "<category start='"+year+"-03-01' end='"+year+"-04-01' label='3' />";
//		xml += "<category start='"+year+"-04-01' end='"+year+"-05-01' label='4' />";
//		xml += "<category start='"+year+"-05-01' end='"+year+"-06-01' label='5' />";
//		xml += "<category start='"+year+"-06-01' end='"+year+"-07-01' label='6' />";
//		xml += "<category start='"+year+"-07-01' end='"+year+"-08-01' label='7' />";
//		xml += "<category start='"+year+"-08-01' end='"+year+"-09-01' label='8' />";
//		xml += "<category start='"+year+"-09-01' end='"+year+"-10-01' label='9' />";
//		xml += "<category start='"+year+"-10-01' end='"+year+"-11-01' label='10' />";
//		xml += "<category start='"+year+"-11-01' end='"+year+"-12-01' label='11' />";
//		xml += "<category start='"+year+"-12-01' end='"+(year+1)+"-01-01' label='12' />";
//		xml += "</categories>";
		
		xml += "<processes fontSize='12' isBold='1' align='left' headertext='项目名'>";
		//项目名循环
		for (int i = 0; i < datas.size(); i++) {
			Map map = datas.get(i);
			xml += "<process label='"+map.get("project_name")+"' id='"+map.get("project_info_no")+"'/>";
		}
		xml += "  </processes>";
		
//		xml += "<datatable headerVAlign='middle'>";
//		
//		xml += "<datacolumn headerText='计划开始时间'>";
//		//项目名循环
//		for (int i = 0; i < datas.size(); i++) {
//			Map map = datas.get(i);
//			xml += "<text  label='"+map.get("start_date")+"' />";
//		}
//		xml += "</datacolumn>";
//		
//		xml += "<datacolumn headerText='计划结束时间'>";
//		//项目名循环
//		for (int i = 0; i < datas.size(); i++) {
//			Map map = datas.get(i);
//			xml += "<text  label='"+map.get("end_date")+"' />";
//		}
//		xml += "</datacolumn>";
//		
//		xml += "<datacolumn headerText='实际开始时间'>";
//		//项目名循环
//		for (int i = 0; i < datas.size(); i++) {
//			Map map = datas.get(i);
//			xml += "<text  label='"+map.get("actual_start_date")+"' />";
//		}
//		xml += "</datacolumn>";
//		
//		xml += "<datacolumn headerText='实际结束时间'>";
//		//项目名循环
//		for (int i = 0; i < datas.size(); i++) {
//			Map map = datas.get(i);
//			xml += "<text  label='"+map.get("actual_finish_date")+"' />";
//		}
//		xml += "</datacolumn>";
//		
//		xml += "</datatable>";
		
		//项目循环
		xml += "<tasks showPercentLabel='0' >";
		for (int i = 0; i < datas.size(); i++) {
			Map map = datas.get(i);
			//String sqlTemp = null;
			//String exploration_method = (String) map.get("exploration_method");
			String objectId = (String) map.get("object_id");
			String projectInfoNo = (String) map.get("project_info_no");
			
			String baseLineProjectId = "";
			ProjectWSBean projectWSBean = (ProjectWSBean) BeanFactory.getBean("P6ProjectWSBean");
			List<Project> projectInfoList = projectWSBean.getProjectFromP6(null, "ObjectId = "+objectId, null); 
			if(projectInfoList != null){
				Project projectInfo = projectInfoList.get(0);
				if(projectInfo.getCurrentBaselineProjectObjectId().getValue() != null){
					baseLineProjectId = projectInfo.getCurrentBaselineProjectObjectId().getValue().toString();
				}
			}
			
			//xml += "<task start='"+map.get("start_date")+"' end='"+map.get("end_date")+"' processId='"+map.get("project_info_no")+"'/>";
			sql ="select min(a.actual_start_date) start_date,max(a.actual_finish_date) as end_date, to_date(to_char(nvl(max(a.actual_finish_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(nvl(min(a.actual_start_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs " +
					"join bgp_p6_activity a " +
					"on a.wbs_object_id = wbs.object_id " +
					"start with wbs.name = '测量' and wbs.project_object_id = '"+map.get("object_id")+"' " +
					"connect by prior wbs.object_id = wbs.parent_object_id ";
			List list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String)task.get("start_date") == null || "".equals((String)task.get("start_date"))) {
					
				} else {
//					sql = "select sum(planned_units) as workload,sum(actual_units) as actual,round(sum(actual_units)/sum(planned_units)*100,2) as workload_radio from bgp_p6_workload where bsflag = '0' and project_object_id = '"+map.get("object_id")+"' ";
//					if ("0300100012000000002".equals(exploration_method) || "0300100012000000002" == exploration_method) {
//						sqlTemp = " and resource_id in ('";
//						for (int j = 0; j < measure2Type.length; j++) {
//							sqlTemp = sqlTemp + measure2Type[j] + "','";
//						}
//						sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
//						sqlTemp += ")";
//					} else {
//						sqlTemp = " and resource_id in ('";
//						for (int j = 0; j < measure3Type.length; j++) {
//							sqlTemp = sqlTemp + measure3Type[j] + "','";
//						}
//						sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
//						sqlTemp += ")";
//					}
//					List temp = radDao.queryRecords(sql+sqlTemp);
//					if (temp != null && temp.size() != 0) {
//						Map radio = (Map) temp.get(0);
//						xml += "<task label='测量' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='15%' percentComplete='"+radio.get("workload_radio")+"'/>";
//					} else {
//						xml += "<task label='测量' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='15%'/>";
//					}
					
					String endFlagSql = "select nvl(count(*),0) as end_day from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no"
							+ " where project_info_no = '"+projectInfoNo +"'"
							+ " and  survey_process_status = '3' and d.bsflag = '0' and d.audit_status = '3' ";
					
					List temp = radDao.queryRecords(endFlagSql);
					if (temp != null && temp.size() != 0) {
						Map map2 = (Map) temp.get(0);
						String value = "" + map2.get("end_day");
						Matcher isNum = pattern.matcher(value);
						if (isNum.matches()) {
							endFlagDay = Long.valueOf(value);
						}
					}
					
					if (endFlagDay > 0) {
						xml += "<task label='测量已完成，"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' toolText='测量已完成，"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='15%' percentComplete='100'/>";
					} else {
						xml += "<task label='测量实际天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' toolText='测量实际天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='1' start='"+task.get("start_date")+"' end='"+sdf.format(date)+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='15%' percentComplete='100'/>";
					}
				}
			}
			
			sql ="select min(a.planned_start_date) start_date,max(a.planned_finish_date) as end_date,to_date(to_char(max(a.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(min(a.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs " +
					"join bgp_p6_activity a " +
					"on a.wbs_object_id = wbs.object_id " +
					"start with wbs.name = '测量' and wbs.project_object_id = '"+baseLineProjectId+"' " +
					"connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String)task.get("start_date") == null || "".equals((String)task.get("start_date")) || (String)task.get("end_date") == null || "".equals((String)task.get("end_date"))) {
					
				} else {
					xml += "<task label='测量计划天数"+task.get("days")+"天' toolText='测量计划天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='0' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='20%' topPadding='10%' percentComplete = '0'/>";
				}
			}
			
			sql ="select min(a.actual_start_date) start_date,max(a.actual_finish_date) as end_date, to_date(to_char(nvl(max(a.actual_finish_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(nvl(min(a.actual_start_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs " +
					"join bgp_p6_activity a " +
					"on a.wbs_object_id = wbs.object_id " +
					"start with wbs.name = '钻井' and wbs.project_object_id = '"+map.get("object_id")+"' " +
					"connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String)task.get("start_date") == null || "".equals((String)task.get("start_date")) || (String)task.get("end_date") == null || "".equals((String)task.get("end_date"))) {
					
				} else {
//					sql = "select sum(planned_units) as workload,sum(actual_units) as actual,round(sum(actual_units)/sum(planned_units)*100,2) as workload_radio from bgp_p6_workload where bsflag = '0' and project_object_id = '"+map.get("object_id")+"' ";
//					if ("0300100012000000002".equals(exploration_method) || "0300100012000000002" == exploration_method) {
//						sqlTemp = " and resource_id in ('";
//						for (int j = 0; j < drill2Type.length; j++) {
//							sqlTemp = sqlTemp + drill2Type[j] + "','";
//						}
//						sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
//						sqlTemp += ")";
//					} else {
//						sqlTemp = " and resource_id in ('";
//						for (int j = 0; j < drill3Type.length; j++) {
//							sqlTemp = sqlTemp + drill3Type[j] + "','";
//						}
//						sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
//						sqlTemp += ")";
//					}
//					List temp = radDao.queryRecords(sql+sqlTemp);
//					if (temp != null && temp.size() != 0) {
//						Map radio = (Map) temp.get(0);
//						xml += "<task label='钻井' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='50%' percentComplete='"+radio.get("workload_radio")+"'/>";
//					} else {
//						xml += "<task label='钻井' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='50%'/>";
//					}
					String endFlagSql = "select nvl(count(*),0) as end_day from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no"
							+ " where project_info_no = '"+projectInfoNo +"'"
							+ " and  drill_process_status = '3' and d.bsflag = '0' and d.audit_status = '3' ";
					
					List temp = radDao.queryRecords(endFlagSql);
					if (temp != null && temp.size() != 0) {
						Map map2 = (Map) temp.get(0);
						String value = "" + map2.get("end_day");
						Matcher isNum = pattern.matcher(value);
						if (isNum.matches()) {
							endFlagDay = Long.valueOf(value);
						}
					}
					
					if (endFlagDay > 0) {
						xml += "<task label='钻井已完成"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' toolText='钻井已完成"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='50%' percentComplete='100'/>";
					} else {
						xml += "<task label='钻井实际天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' toolText='钻井实际天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='1' start='"+task.get("start_date")+"' end='"+sdf.format(date)+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='50%' percentComplete='100'/>";
					}
				}
			}
			
			sql ="select min(a.planned_start_date) start_date,max(a.planned_finish_date) as end_date,to_date(to_char(max(a.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(min(a.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs " +
					"join bgp_p6_activity a " +
					"on a.wbs_object_id = wbs.object_id " +
					"start with wbs.name = '钻井' and wbs.project_object_id = '"+baseLineProjectId+"' " +
					"connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String)task.get("start_date") == null || "".equals((String)task.get("start_date")) || (String)task.get("end_date") == null || "".equals((String)task.get("end_date"))) {
					
				} else {
					xml += "<task label='钻井计划天数"+task.get("days")+"天' toolText='钻井计划天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='0' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='20%' topPadding='45%' percentComplete = '0'/>";
				}
			}
			
			sql ="select min(a.actual_start_date) start_date,max(a.actual_finish_date) as end_date, to_date(to_char(nvl(max(a.actual_finish_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(nvl(min(a.actual_start_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs " +
					"join bgp_p6_activity a " +
					"on a.wbs_object_id = wbs.object_id " +
					"start with wbs.name = '采集' and wbs.project_object_id = '"+map.get("object_id")+"' " +
					"connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String)task.get("start_date") == null || "".equals((String)task.get("start_date")) || (String)task.get("end_date") == null || "".equals((String)task.get("end_date"))) {
					
				} else {
					
//					sql = "select sum(planned_units) as workload,sum(actual_units) as actual,round(sum(actual_units)/sum(planned_units)*100,2) as workload_radio from bgp_p6_workload where bsflag = '0' and project_object_id = '"+map.get("object_id")+"' ";
//					if ("0300100012000000002".equals(exploration_method) || "0300100012000000002" == exploration_method) {
//						sqlTemp = " and resource_id in ('";
//						for (int j = 0; j < coll2Type.length; j++) {
//							sqlTemp = sqlTemp + coll2Type[j] + "','";
//						}
//						sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
//						sqlTemp += ")";
//					} else {
//						sqlTemp = " and resource_id in ('";
//						for (int j = 0; j < coll3Type.length; j++) {
//							sqlTemp = sqlTemp + coll3Type[j] + "','";
//						}
//						sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
//						sqlTemp += ")";
//					}
//					List temp = radDao.queryRecords(sql+sqlTemp);
//					if (temp != null && temp.size() != 0) {
//						Map radio = (Map) temp.get(0);
//						xml += "<task label='采集' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='80%' percentComplete='"+radio.get("workload_radio")+"' />";
//					} else {
//						xml += "<task label='采集' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='80%' />";
//					}
					String endFlagSql = "select nvl(count(*),0) as end_day from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no"
							+ " where project_info_no = '"+projectInfoNo +"'"
							+ " and  collect_process_status = '3' and d.bsflag = '0' and d.audit_status = '3' ";
					
					List temp = radDao.queryRecords(endFlagSql);
					if (temp != null && temp.size() != 0) {
						Map map2 = (Map) temp.get(0);
						String value = "" + map2.get("end_day");
						Matcher isNum = pattern.matcher(value);
						if (isNum.matches()) {
							endFlagDay = Long.valueOf(value);
						}
					}
					
					if (endFlagDay > 0) {
						xml += "<task label='采集已完成"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' toolText='采集已完成"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='1' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='80%' percentComplete='100'/>";
					} else {
						xml += "<task label='采集实际天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' toolText='采集实际天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='1' start='"+task.get("start_date")+"' end='"+sdf.format(date)+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='10%' topPadding='80%' percentComplete='100'/>";
					}
				}
			}
			
			sql ="select min(a.planned_start_date) start_date,max(a.planned_finish_date) as end_date,to_date(to_char(max(a.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(min(a.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs " +
					"join bgp_p6_activity a " +
					"on a.wbs_object_id = wbs.object_id " +
					"start with wbs.name = '采集' and wbs.project_object_id = '"+baseLineProjectId+"' " +
					"connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String)task.get("start_date") == null || "".equals((String)task.get("start_date")) || (String)task.get("end_date") == null || "".equals((String)task.get("end_date"))) {
					
				} else {
					xml += "<task label='采集计划天数"+task.get("days")+"天' toolText='采集计划天数"+task.get("days")+"天 "+task.get("start_date")+"~"+task.get("end_date")+"' showLabel='0' start='"+task.get("start_date")+"' end='"+task.get("end_date")+"' processId='"+map.get("project_info_no")+"' color='4567aa' height='20%' topPadding='75%' percentComplete = '0'/>";
				}
			}
			
		}
		xml += "</tasks>";
		
		xml += "<trendlines>";
		xml += "<line start='"+sdf.format(date)+"' displayValue='"+sdf.format(date)+"' color='333333' thickness='2' dashed='1' />";
		xml += "</trendlines>";
		
		xml += "</chart>";
		
		System.out.println(xml);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("Str", xml);
		msg.setValue("projectNum", datas.size());
		return msg;
	}
}
