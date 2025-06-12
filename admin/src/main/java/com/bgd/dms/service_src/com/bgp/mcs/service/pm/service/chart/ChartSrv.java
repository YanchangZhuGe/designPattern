package com.bgp.mcs.service.pm.service.chart;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.collections.map.HashedMap;

import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.doc.service.MyUcm;
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

public class ChartSrv extends BaseService {

	private ILog log;
	private RADJdbcDao radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	public ChartSrv() {
		log = LogFactory.getLogger(ChartSrv.class);
	}

	// 将勘探方法和颜色值
	public static Map<String, String> colorMap = new HashMap<String, String>();


	public static void initColorMap() {
		// 化学勘探
		colorMap.put("5110000056000000005", "FA04D5");
		// 重力
		colorMap.put("5110000056000000007", "C904FA");
		colorMap.put("5110000056000000008", "B804FA");
		colorMap.put("5110000056000000009", "A404FA");
		colorMap.put("5110000056000000010", "9F2CBF");
		colorMap.put("5110000056000000011", "711A89");
		// 磁力
		colorMap.put("5110000056000000012", "701AE8");
		colorMap.put("5110000056000000013", "621AC6");
		colorMap.put("5110000056000000014", "5E1CBC");
		colorMap.put("5110000056000000015", "5519AB");
		// 天然场源
		colorMap.put("5110000056000000016", "1111E9");
		colorMap.put("5110000056000000017", "1212DD");
		colorMap.put("5110000056000000018", "1010C1");
		colorMap.put("5110000056000000019", "2121A1");
		colorMap.put("5110000056000000020", "6E6EF3");
		// 人工场源
		colorMap.put("5110000056000000021", "0898F8");
		colorMap.put("5110000056000000022", "0B93EE");
		colorMap.put("5110000056000000023", "0A8AE0");
		colorMap.put("5110000056000000024", "0D83D1");
		colorMap.put("5110000056000000025", "0E7AC3");
		colorMap.put("5110000056000000026", "0D71B4");
		colorMap.put("5110000056000000027", "0B66A2");
		// 工程勘探
		colorMap.put("5110000056000000028", "08F778");
		colorMap.put("5110000056000000029", "08E16D");
		colorMap.put("5110000056000000030", "07CD64");
		colorMap.put("5110000056000000031", "5EED0C");
		colorMap.put("5110000056000000032", "54D609");
		colorMap.put("5110000056000000033", "8EEE11");
		colorMap.put("5110000056000000034", "74C608");
		colorMap.put("5110000056000000035", "589803");
		colorMap.put("5110000056000000036", "F6FA08");
		colorMap.put("5110000056000000037", "E6E909");
		colorMap.put("5110000056000000038", "D5D808");
		colorMap.put("5110000056000000039", "FAD506");
		colorMap.put("5110000056000000040", "DDBD08");
		colorMap.put("5110000056000000041", "FBA607");
		colorMap.put("5110000056000000042", "E69706");
		colorMap.put("5110000056000000043", "CC8706");
	}
	 public static List listOtoB=new ArrayList();
	 public static void inList() {
	  listOtoB.add("511000005600000007");
	  listOtoB.add("511000005600000008");
	  listOtoB.add("5110000056000000011");
	  listOtoB.add("5110000056000000012");
	  listOtoB.add("5110000056000000015");
	  listOtoB.add("5110000056000000016");
	  listOtoB.add("5110000056000000017");
	  listOtoB.add("5110000056000000018");
	  listOtoB.add("5110000056000000019");
	  listOtoB.add("5110000056000000020");
	  listOtoB.add("5110000056000000051");
	  listOtoB.add("5110000056000000022");
	  listOtoB.add("5110000056000000027");
	  listOtoB.add("5110000056000000046");
	  listOtoB.add("5110000056000000047");
	  listOtoB.add("5110000056000000048");
	  listOtoB.add("511000005600000005");
	 }
	// 查询项目的勘探方法
	public ISrvMsg getProjectMethod(ISrvMsg req) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(req);
		UserToken user = req.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String projectSql = "select * from gp_task_project where PROJECT_INFO_NO='"
				+ projectInfoNo + "'";
		String exMethodSql = "SELECT CODING_CODE_ID,CODING_NAME FROM COMM_CODING_SORT_DETAIL where coding_sort_id='5110000056'";
		Map projectObj = radDao.queryRecordBySQL(projectSql);
		List<Map> expMethodObj = radDao.queryRecords(exMethodSql);
		List<Map> resultList = new ArrayList<Map>();
		String expMethod = (String) projectObj.get("exploration_method");
		String[] expMothods = expMethod.split(",");
		for (int i = 0; i < expMothods.length; i++) {
			String methodCode = expMothods[i];

			for (int j = 0; j < expMethodObj.size(); j++) {
				Map map = expMethodObj.get(j);
				String commCode = (String) map.get("coding_code_id");
				if (commCode.equals(methodCode)) {
					String methodName = (String) map.get("coding_name");
					Map<String, String> expMethodMap = new HashMap<String, String>();
					expMethodMap.put("methodCode", methodCode);
					expMethodMap.put("methodName", methodName);
					resultList.add(expMethodMap);
				}
			}

		}
		msg.setValue("resultList", resultList);
		return msg;
	}

	// 查询勘探方法图
	public ISrvMsg getExeMthodPicture(ISrvMsg req) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(req);
		UserToken user = req.getUserToken();
		String projectInfoNo = req.getValue("projectInfoNo");
		String produceDate = req.getValue("produceDate");
		String exMethod = req.getValue("exMethod");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}
		String sql = "SELECT * FROM gp_ops_daily_report_zb where project_info_no='"
				+ projectInfoNo
				+ "'"
				+ " and BSFLAG='0' and EXPLORATION_METHOD!='5110000056000000045' and EXPLORATION_METHOD='"
				+ exMethod
				+ "'  and PRODUCE_DATE=to_date('"
				+ produceDate
				+ "','yyyy-MM-dd')";
		Map projectDaily = radDao.queryRecordBySQL(sql);
		String isUcmId = "";

		if (projectDaily != null) {
			String ucmId = (String) projectDaily.get("upload_file_ucmdocid");
			if (!"".equals(ucmId)) {
				MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
				String imageName = myUcm.getDocTitle(ucmId);
				String imagePath = myUcm.getDocUrl(ucmId);
				msg.setValue("imageName", imageName);
				msg.setValue("imagePath", imagePath);
				msg.setValue("ucmId", ucmId);
				isUcmId = "yes";
			} else {
				isUcmId = "no";
			}
		}

		msg.setValue("isUcmId", isUcmId);

		return msg;
	}

	public ISrvMsg getData(ISrvMsg reqDTO) throws Exception {

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
		String sql = "select workload as paodian,workload_num as gongli,to_char(to_date(record_month,'yyyy-MM-dd'),'MM-dd') as record_month,to_date(record_month,'yyyy-MM-dd') as data"
				+ " from gp_proj_product_plan where project_info_no = '"
				+ projectInfoNo
				+ "' and bsflag = '0' "
				+ " and oper_plan_type = '" + type + "' order by record_month ";

		List<Map> list = radDao.queryRecords(sql);

		if (list == null || list.size() == 0) {
			return msg;
		}

		String xml = "";
		// 标题 x坐标标题 y坐标标题 是否显示数据
		if (type == "colldailylist" || "colldailylist".equals(type)) {
			// 采集
			xml = "<chart caption='采集工作量' xAxisName='日期' yAxisName='炮点数' showValues='0' >";
		} else if (type == "measuredailylist"
				|| "measuredailylist".equals(type)) {
			// 测量
			xml = "<chart caption='测量工作量' xAxisName='日期' yAxisName='工作量' showValues='0' >";
		} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
			// 钻井
			xml = "<chart caption='钻井工作量' xAxisName='日期' yAxisName='炮点数' showValues='0' >";
		}

		// x坐标绘制
		xml += "<categories>";
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			xml += "<category label='" + map.get("record_month") + "' />";
		}
		xml += "</categories>";

		String minDate = (String) ((Map) list.get(0)).get("data");
		String maxDate = (String) ((Map) list.get(list.size() - 1)).get("data");

		long cumulativeValue = 0;
		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+

		// 数据绘制
		xml += "<datase seriesName='设计工作量'>";
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			for (int i = 0; i < list.size(); i++) {
				Map map = list.get(i);
				if ("2".equals(graphStyle)) {
					String value = "" + map.get("gongli");
					Matcher isNum = pattern.matcher(value);
					if (isNum.matches()) {
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='" + cumulativeValue + "' />";
				} else if ("1".equals(graphStyle)) {
					xml += "<set value='" + map.get("gongli") + "' />";
				}
			}
		} else {
			for (int i = 0; i < list.size(); i++) {
				Map map = list.get(i);
				if ("2".equals(graphStyle)) {
					String value = "" + map.get("paodian");
					Matcher isNum = pattern.matcher(value);
					if (isNum.matches()) {
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='" + cumulativeValue + "' />";
				} else if ("1".equals(graphStyle)) {
					xml += "<set value='" + map.get("paodian") + "' />";
				}
			}
		}
		xml += "</dataset>";

		sql = "select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)) as coll_value"
				+ ",sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value"
				+ ",sum(nvl(d.daily_drill_sp_num,0)) as drill_value"
				+ ",produce_date "
				+ ",produce_date-to_date('"
				+ minDate
				+ "','yyyy-MM-dd') as deviation_date"
				+ " from gp_ops_daily_report d where project_info_no = '"
				+ projectInfoNo
				+ "' and bsflag = '0' "
				+ " and produce_date >= to_date('"
				+ minDate
				+ "','yyyy-MM-dd') and produce_date <= to_date('"
				+ maxDate
				+ "','yyyy-MM-dd')"
				+ " group by produce_date order by produce_date ";

		list = radDao.queryRecords(sql);

		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			if ((String) map.get("deviation_date") == "0"
					|| "0".equals((String) map.get("deviation_date"))) {
				for (int i = 0; i < Integer.parseInt((String) map
						.get("deviation_date")); i++) {
					xml += "<set value='0' />";
				}
			}
		}

		cumulativeValue = 0;
		xml += "<dataset seriesName='实际工作量'>";
		if (type == "colldailylist" || "colldailylist".equals(type)) {
			// 采集
			if ("2".equals(graphStyle)) {
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					String value = "" + map.get("coll_value");
					Matcher isNum = pattern.matcher(value);
					if (isNum.matches()) {
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='" + cumulativeValue + "' />";
				}
			} else if ("1".equals(graphStyle)) {
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					xml += "<set value='" + map.get("coll_value") + "' />";
				}
			}
		} else if (type == "measuredailylist"
				|| "measuredailylist".equals(type)) {
			// 测量
			if ("2".equals(graphStyle)) {
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					String value = "" + map.get("measure_value");
					Matcher isNum = pattern.matcher(value);
					if (isNum.matches()) {
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='" + cumulativeValue + "' />";
				}
			} else if ("1".equals(graphStyle)) {
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					xml += "<set value='" + map.get("measure_value") + "' />";
				}
			}
		} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
			// 钻井
			if ("2".equals(graphStyle)) {
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					String value = "" + map.get("drill_value");
					Matcher isNum = pattern.matcher(value);
					if (isNum.matches()) {
						cumulativeValue += Long.valueOf(value);
					}
					xml += "<set value='" + cumulativeValue + "' />";
				}
			} else if ("1".equals(graphStyle)) {
				for (int i = 0; i < list.size(); i++) {
					Map map = list.get(i);
					xml += "<set value='" + map.get("drill_value") + "' />";
				}
			}
		}
		xml += "</dataset>";

		// 样式区
		xml += "<styles>";
		xml += "<definition><style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' /></definition>";
		xml += "<application><apply toObject='Canvas' styles='CanvasAnim' /></application>";
		xml += "</styles>";
		xml += "</chart>";

		msg.setValue("Str", xml);
		System.out.println("xml:" + xml);

		// List<Map<String, Object>> jsonList = new
		// ArrayList<Map<String,Object>>();
		// Map<String, Object> chart = new HashMap<String, Object>();
		// //chart
		// chart.put("caption", "采集工作量");//图标题
		// chart.put("xAxisName", "日期");//x坐标标题
		// chart.put("yAxisName", "工作量");//y坐标标题
		// chart.put("showValues", "0");//是否显示数字 0不显示 1显示
		//
		// //categories
		// Map<String, Object> category = new HashMap<String, Object>();
		// //category
		// List<Map<String, Object>> categoryList = new
		// ArrayList<Map<String,Object>>();
		// for (Iterator iterator = list.iterator(); iterator.hasNext();) {
		// Map<String, Object> temp = (Map<String, Object>) iterator.next();
		// Map<String, Object> map1 = new HashMap<String, Object>();
		// map1.put("label", temp.get("recordMonth"));
		// categoryList.add(map1);
		// }
		// category.put("category", categoryList);
		//
		// //dataset
		// Map<String, Object> dataset = new HashMap<String, Object>();
		// //set
		// List<Map<String, Object>> setList = new
		// ArrayList<Map<String,Object>>();
		// for (Iterator iterator = list.iterator(); iterator.hasNext();) {
		// Map<String, Object> temp = (Map<String, Object>) iterator.next();
		// Map<String, Object> map1 = new HashMap<String, Object>();
		// map1.put("value", temp.get("workload"));
		// setList.add(map1);
		// }
		// dataset.put("seriesname", "设计工作量");
		// dataset.put("data", setList);
		//
		// //=====================样式======================
		//
		// //styles
		// Map<String, Object> styles = new HashMap<String, Object>();
		// //definition
		// Map<String, Object> definition = new HashMap<String, Object>();
		// //style
		// Map<String, Object> style = new HashMap<String, Object>();
		// style.put("name", "CanvasAnim");
		// style.put("type", "animation");
		// style.put("param", "xScale");
		// style.put("start", "0");
		// style.put("duration", "1");
		//
		// definition.put("style", style);
		//
		//
		// //application
		// Map<String, Object> application = new HashMap<String, Object>();
		// //apply
		// Map<String, Object> apply = new HashMap<String, Object>();
		// apply.put("toobject", "Canvas");
		// apply.put("styles", "CanvasAnim");
		//
		// application.put("apply", apply);
		//
		// styles.put("definition", definition);
		// styles.put("application", application);

		return msg;
	}

	
	@SuppressWarnings({ "unchecked", "unused" })
	public ISrvMsg dgGetDeviation(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		//String projectInfoNo = user.getProjectInfoNo();
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}
		
		WorkMethodSrv wm = new WorkMethodSrv();
		String 	buildMethod = wm.getProjectExcitationMode(projectInfoNo);
		
		//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		//String curDate = format.format(new Date());
		
		String xml = "<chart showValues='0' numberSuffix='%' yAxisName='负数表示滞后，正数表示超前' rotateYAxisName='0' yAxisNameWidth='16'>";
		
		//标题 x坐标标题 y坐标标题 是否显示数据
		String[] types = {"measuredailylist","drilldailylist","colldailylist"};
		String[] typeNames = {"测量","钻井","采集"};
		String[] colors = {"1381c0","69bf5d","fd962e"};
		
		String endFlagColumn = "survey_process_status";
		//List axisDateList = new ArrayList();
		List axisDateListDesign = new ArrayList();
		List axisDateListDaily = new ArrayList();
		String axis_start_date = "";
		String axis_end_date = "";
		
		//设计时间
		String designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month " +
		" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' " +
		" and oper_plan_type in('colldailylist','measuredailylist','drilldailylist') order by record_month";
		if("5000100003000000002".equals(buildMethod)){
			designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month " +
			" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' " +
			" and oper_plan_type in('colldailylist','measuredailylist') order by record_month";
		}
		
		List<Map> designDateList = radDao.queryRecords(designDateSql);
		for (int i = 0; i < designDateList.size(); i++) {
			Map map = designDateList.get(i);
			String axis_date = "" + map.get("record_month");
			axisDateListDesign.add(axis_date);
		}
		
		//用于合并横坐标日期的操作
		//List<Map> mergeDesignDateList = designDateList;
		
		if (designDateList == null || designDateList.size() == 0) {
			return msg;
		}
		//实际时间
		String dailyDateSql = " select to_char(produce_date,'yyyy-MM-dd') as produce_date from gp_ops_daily_report where project_info_no = '" + projectInfoNo + "' and bsflag = '0' order by produce_date";
		
		//用于合并横坐标日期的操作
		List<Map> dailyDateList = radDao.queryRecords(dailyDateSql);
		//List<Map> mergeDailyDateList = dailyDateList;
		for (int i = 0; i < dailyDateList.size(); i++) {
			Map map = dailyDateList.get(i);
			String axis_date = "" + map.get("produce_date");
			axisDateListDaily.add(axis_date);
		}
		
		
		//日期合并
		axisDateListDesign.removeAll(axisDateListDaily);
		axisDateListDaily.addAll(axisDateListDesign);
		Collections.sort(axisDateListDaily);
		List<String> axisDateList = axisDateListDaily;
		//不再使用的对象,垃圾回收
		axisDateListDaily = null;
		axisDateListDesign = null;
		
		//绘制x坐标,日期
		xml += "<categories>";
		for (int i = 0; i < axisDateList.size(); i++) {
			//Map map = designDateList.get(i);
			String axis_date = "" + axisDateList.get(i);
			//axisDateList.add(axis_date);
			if(i==0){
				axis_start_date = axis_date;
			}else if(i == axisDateList.size() - 1){
				axis_end_date = axis_date;
			}
			xml += "<category label='" + axis_date.substring(5) + "' />";
		}
		//实际生产日期大于设计日期,追加大于设计的日期
		//2012-11-21 卢占国提出实际大于设计不添加日期
//		int addDay = 0;
//
//		for (int i = 0; i < dailyDateList.size(); i++) {
//			Map map = dailyDateList.get(i);
//			String axis_date = "" + map.get("produce_date");
//			if(DateOperation.diffDaysOfDate(axis_date, axis_end_date) > 0){
//				//xml += "<category label='" + axis_date.substring(5) + "' />";
//				axis_end_date = axis_date;
//				axisDateList.add(axis_date);
//				addDay++;
//			}
//		}
		xml += "</categories>";
		
		List<Map> gridData = new ArrayList<Map>();
		String existDrillData = "yes";
		for(int m=0; m<types.length; m++){
			String type = types[m];
			String typeName = typeNames[m];
			Map lineMap = new HashMap();
			if("drilldailylist".equals(type)){
				if("5000100003000000002".equals(buildMethod)){
					lineMap.put("status","");
					lineMap.put("groupLine","");
					lineMap.put("designWorkLoad","");
					lineMap.put("dailyWorkLoad","");
					lineMap.put("finishPercentage","");
					lineMap.put("deviation","");
					lineMap.put("date","");
					gridData.add(lineMap);
					existDrillData = "no";
					continue;
				}
			}
			String dailyColumn="";
			String dailyParam = "";
			if (type == "measuredailylist" || "measuredailylist".equals(type)) {
				dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
				endFlagColumn = "survey_process_status";
				dailyParam = " and nvl(workload_num,0) > 0";
			} else if (type == "colldailylist" || "colldailylist".equals(type)) {
				dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0) ";
				endFlagColumn = "collect_process_status";
				dailyParam = " and nvl(workload,0) > 0";
			} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
				dailyColumn = " nvl(daily_drill_sp_num,0) ";
				endFlagColumn = "drill_process_status";
				dailyParam = " and nvl(workload,0) > 0";
			}
			
			String sql = "select nvl(workload,0) as paodian,nvl(workload_num,0) as gongli,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,to_date(record_month,'yyyy-MM-dd') as data" +
			" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' " + dailyParam +
			" and oper_plan_type = '"+type+"' order by record_month ";
			
			List<Map> designList = radDao.queryRecords(sql);
			 
			String minDate = (String) ((Map) designList.get(0)).get("record_month");
			String maxDate = (String) ((Map) designList.get(designList.size()-1)).get("record_month");
			String produceStartDate = "";
			String produceEndDate = "";
			String produceCurDate = "";
			String statusDesc = "";
			
			// 取当前工序的结束状态 (20131218修改之前)
//			String endFlagSql = "select " + endFlagColumn + " as end_flag from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "
//				+ " where d.produce_date = (select max(produce_date) from gp_ops_daily_report where project_info_no = '" + projectInfoNo + "' and audit_status = '3' and bsflag = '0' and "+ dailyColumn + " > 0) "
//				+ " and project_info_no = '"+projectInfoNo +"' and d.bsflag = '0'";
//			String statusDesc = "";
//			Map recordMap = radDao.queryRecordBySQL(endFlagSql);
//			if (recordMap != null) {
//				String value = "" + recordMap.get("end_flag");
//				if("1".equals(value)){
//					statusDesc = "未开始";
//				}else if("2".equals(value)){
//					statusDesc = "正在施工";
//				}else if("3".equals(value)){
//					statusDesc = "结束";
//				}
//			}
			
			//1218修改
			if (type == "measuredailylist" || "measuredailylist".equals(type)) {
				//测量
				boolean surveyEndFlag = false;
				boolean surveyInProgressFlag = false;
				String surveyEndSql = "select count(*) as survey_end from gp_ops_daily_report d "+
									  " join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
									  " and s.bsflag = '0'and s.survey_process_status = '3' "+
									  " where d.project_info_no = '"+projectInfoNo+"'"+
									  " and d.audit_status = '3' and d.bsflag = '0'";
				Map<Object,String> suervyEndMap = radDao.queryRecordBySQL(surveyEndSql);
				int surveyEnd = Integer.parseInt(suervyEndMap.get("survey_end"));
				if(surveyEnd > 0){
					surveyEndFlag = true;
					statusDesc = "结束";
					//获取结束日期
					String getSurveyEndDateSql = "select min(d.produce_date) as survey_end_date from gp_ops_daily_report d "+
												 "join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
												 "and s.bsflag = '0'and s.survey_process_status = '3' "+
												 "where d.project_info_no = '"+projectInfoNo+"' "+
												 "and d.audit_status = '3' and d.bsflag = '0'";
					Map<Object,String> suervyEndDateMap = radDao.queryRecordBySQL(getSurveyEndDateSql);
					produceEndDate = suervyEndDateMap.get("survey_end_date");
				}
				//未结束,判断是否正在施工
				if(!surveyEndFlag){
					String surveyInProgressSql = "select count(*) as survey_in_progress from gp_ops_daily_report d "+
					  " join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
					  " and s.bsflag = '0'and s.survey_process_status = '2' "+
					  " where d.project_info_no = '"+projectInfoNo+"'"+
					  " and d.audit_status = '3' and d.bsflag = '0'";
						Map<Object,String> suervyInProgressMap = radDao.queryRecordBySQL(surveyInProgressSql);
						int surveyInProgress = Integer.parseInt(suervyInProgressMap.get("survey_in_progress"));
						if(surveyInProgress > 0){
							surveyInProgressFlag = true;
							statusDesc = "正在施工";
						}
						//没有正在施工,就是未开始
						if(!surveyInProgressFlag){
							statusDesc = "未开始";
						}
				}
			} else if (type == "colldailylist" || "colldailylist".equals(type)) {
				//采集
				boolean collEndFlag = false;
				boolean collInProgressFlag = false;
				String collEndSql = "select count(*) as coll_end from gp_ops_daily_report d "+
									  " join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
									  " and s.bsflag = '0'and s.collect_process_status = '3' "+
									  " where d.project_info_no = '"+projectInfoNo+"'"+
									  " and d.audit_status = '3' and d.bsflag = '0'";
				Map<Object,String> collEndMap = radDao.queryRecordBySQL(collEndSql);
				int collEnd = Integer.parseInt(collEndMap.get("coll_end"));
				if(collEnd > 0){
					collEndFlag = true;
					statusDesc = "结束";
					//获取结束日期
					String getCollEndDateSql = "select min(d.produce_date) as coll_end_date from gp_ops_daily_report d "+
												 "join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
												 "and s.bsflag = '0'and s.collect_process_status = '3' "+
												 "where d.project_info_no = '"+projectInfoNo+"' "+
												 "and d.audit_status = '3' and d.bsflag = '0'";
					Map<Object,String> collEndDateMap = radDao.queryRecordBySQL(getCollEndDateSql);
					produceEndDate = collEndDateMap.get("coll_end_date");
				}
				//未结束,判断是否正在施工
				if(!collEndFlag){
					String collInProgressSql = "select count(*) as coll_in_progress from gp_ops_daily_report d "+
					  " join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
					  " and s.bsflag = '0'and s.collect_process_status = '2' "+
					  " where d.project_info_no = '"+projectInfoNo+"'"+
					  " and d.audit_status = '3' and d.bsflag = '0'";
						Map<Object,String> collInProgressMap = radDao.queryRecordBySQL(collInProgressSql);
						int collInProgress = Integer.parseInt(collInProgressMap.get("coll_in_progress"));
						if(collInProgress > 0){
							collInProgressFlag = true;
							statusDesc = "正在施工";
						}
						//没有正在施工,就是未开始
						if(!collInProgressFlag){
							statusDesc = "未开始";
						}
				}
			} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
				//钻井
				boolean drillEndFlag = false;
				boolean drillInProgressFlag = false;
				String drillEndSql = "select count(*) as drill_end from gp_ops_daily_report d "+
									  " join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
									  " and s.bsflag = '0'and s.drill_process_status = '3' "+
									  " where d.project_info_no = '"+projectInfoNo+"'"+
									  " and d.audit_status = '3' and d.bsflag = '0'";
				Map<Object,String> drillEndMap = radDao.queryRecordBySQL(drillEndSql);
				int drillEnd = Integer.parseInt(drillEndMap.get("drill_end"));
				if(drillEnd > 0){
					drillEndFlag = true;
					statusDesc = "结束";
					//获取结束日期
					String getDrillEndDateSql = "select min(d.produce_date) as drill_end_date from gp_ops_daily_report d "+
												 "join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
												 "and s.bsflag = '0'and s.drill_process_status = '3' "+
												 "where d.project_info_no = '"+projectInfoNo+"' "+
												 "and d.audit_status = '3' and d.bsflag = '0'";
					Map<Object,String> drillEndDateMap = radDao.queryRecordBySQL(getDrillEndDateSql);
					produceEndDate = drillEndDateMap.get("drill_end_date");
				}
				//未结束,判断是否正在施工
				if(!drillEndFlag){
					String drillInProgressSql = "select count(*) as drill_in_progress from gp_ops_daily_report d "+
					  " join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "+
					  " and s.bsflag = '0'and s.drill_process_status = '2' "+
					  " where d.project_info_no = '"+projectInfoNo+"'"+
					  " and d.audit_status = '3' and d.bsflag = '0'";
						Map<Object,String> drillInProgressMap = radDao.queryRecordBySQL(drillInProgressSql);
						int drillInProgress = Integer.parseInt(drillInProgressMap.get("drill_in_progress"));
						if(drillInProgress > 0){
							drillInProgressFlag = true;
							statusDesc = "正在施工";
						}
						//没有正在施工,就是未开始
						if(!drillInProgressFlag){
							statusDesc = "未开始";
						}
				}
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
									
			sql = "select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)) as coll_value" +
					",sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value"+
					",sum(nvl(d.daily_drill_sp_num,0)) as drill_value"+
					",sum(nvl(d.daily_micro_measue_point_num,0)+nvl(d.daily_small_refraction_num,0)) as surface_value"+
					",to_char(produce_date,'yyyy-MM-dd') as produce_date" +
				//",produce_date-to_date('"+minDate+"','yyyy-MM-dd') as deviation_date"+
					" from gp_ops_daily_report d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and audit_status = '3'" +
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
				//20131219 结束日期在上面获取
				//if("结束".equals(statusDesc) || "结束" == statusDesc){
					//produceEndDate = (String) ((Map) dailyList.get(dailyList.size()-1)).get("produce_date");
				//}				
				
				//此处判断最大最小日期
				/*if(DateOperation.diffDaysOfDate(minDate,produceStartDate) >= 0){
					minDate = produceStartDate;
				}
				if(DateOperation.diffDaysOfDate(produceCurDate,maxDate) >= 0){
					maxDate = produceCurDate;
				}*/
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
			
			String[] measure2Type = {"G02003","G02004"};
			String[] measure3Type = {"G2003","G2004"};
			
			String[] drill2Type = {"G05001"};
			String[] drill3Type = {"G5001"};
			
			String[] coll2Type = {"G07001","G07003","G07005"};
			String[] coll3Type = {"G7001","G7003","G7005"};
			
			sql = "select exploration_method from gp_task_project  where project_info_no = '"+projectInfoNo+"' and bsflag = '0'";
			List<Map> list = radDao.queryRecords(sql);
			
			String exploration_method = null;
			if (list != null && list.size() != 0) {
				Map map = (Map) list.get(0);
				exploration_method = (String) map.get("exploration_method");
			} else {
				return null;
			}
			
			String sqlTemp = "";
			
			//20140106 设计工作量都取计划日效的合计值
			String designWorkloadSql = "";
			
			if (type == "colldailylist" || "colldailylist".equals(type)) {
				//采集
				designWorkloadSql = "select nvl(sum(p.workload),0) as num"+
								    " from gp_proj_product_plan p"+
								    " where p.project_info_no = '"+projectInfoNo+"'"+
								    " and p.oper_plan_type = 'colldailylist'"+
								    " and p.bsflag = '0' and p.workload is not null";
				
				designValueColumn = "paodian";
				dailyValueColumn = "coll_value";
				if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < coll2Type.length; i++) {
						sqlTemp = sqlTemp + coll2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < coll3Type.length; i++) {
						sqlTemp = sqlTemp + coll3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
					sqlTemp += ")";
				}
				
			} else if (type == "measuredailylist" || "measuredailylist".equals(type)) {
				//测量
				designWorkloadSql = "select round(nvl(sum(p.workload_num),0),2) as num"+
								    " from gp_proj_product_plan p"+
								    " where p.project_info_no = '"+projectInfoNo+"'"+
								    " and p.oper_plan_type = 'measuredailylist'"+
								    " and p.bsflag = '0' and p.workload_num is not null";
				
				designValueColumn = "gongli";
				dailyValueColumn = "measure_value";
				if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < measure2Type.length; i++) {
						sqlTemp = sqlTemp + measure2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < measure3Type.length; i++) {
						sqlTemp = sqlTemp + measure3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
					sqlTemp += ")";
				}
			} else if (type == "drilldailylist" || "drilldailylist".equals(type)) {
				//钻井
				designWorkloadSql = "select nvl(sum(p.workload),0) as num"+
								    " from gp_proj_product_plan p"+
								    " where p.project_info_no = '"+projectInfoNo+"'"+
								    " and p.oper_plan_type = 'drilldailylist'"+
								    " and p.bsflag = '0' and p.workload is not null";
				
				designValueColumn = "paodian";
				dailyValueColumn = "drill_value";
				if (exploration_method == "0300100012000000002" || "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < drill2Type.length; i++) {
						sqlTemp = sqlTemp + drill2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < drill3Type.length; i++) {
						sqlTemp = sqlTemp + drill3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length()-2);
					sqlTemp += ")";
				}
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
			
			log.debug("The sql is:"+designWorkloadSql);
			list = radDao.queryRecords(designWorkloadSql);
			if (list != null && list.size() != 0) {
					Map map = list.get(0);
					//之前设计工作量的赋值
					//20130415又改回这个了
					lineMap.put("designWorkLoad", "" + (String)map.get("num"));
					lineMap.put("finishPercentage", "" + df.format(sum_daily_num / Double.parseDouble((String)map.get("num")) * 100));
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
			lineMap.put("date", produceEndDate);//实际完成日期
			lineMap.put("designDate", maxDate);//计划完成日期
			lineMap.put("startDate", produceStartDate);//实际开始日期
			lineMap.put("minDesignDate", minDate);//计划开始日期
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
	
	
	public ISrvMsg getDeviation(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		// String projectInfoNo = user.getProjectInfoNo();

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}

		WorkMethodSrv wm = new WorkMethodSrv();
		String buildMethod = wm.getProjectExcitationMode(projectInfoNo);

		// SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		// String curDate = format.format(new Date());

		String xml = "<chart showValues='0' numberSuffix='%' yAxisName='负数表示滞后，正数表示超前' rotateYAxisName='0' yAxisNameWidth='16'>";

		// 标题 x坐标标题 y坐标标题 是否显示数据
		String[] types = { "measuredailylist", "drilldailylist",
				"colldailylist" };
		String[] typeNames = { "测量", "钻井", "采集" };
		String[] colors = { "1381c0", "69bf5d", "fd962e" };

		String endFlagColumn = "survey_process_status";

		String designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month "
				+ " from gp_proj_product_plan where project_info_no = '"
				+ projectInfoNo
				+ "' and bsflag = '0' "
				+ " and oper_plan_type in('colldailylist','measuredailylist','drilldailylist') order by record_month";
		if ("5000100003000000002".equals(buildMethod)) {
			designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month "
					+ " from gp_proj_product_plan where project_info_no = '"
					+ projectInfoNo
					+ "' and bsflag = '0' "
					+ " and oper_plan_type in('colldailylist','measuredailylist') order by record_month";
		}

		List<Map> designDateList = radDao.queryRecords(designDateSql);
		if (designDateList == null || designDateList.size() == 0) {
			return msg;
		}
		// x坐标绘制
		@SuppressWarnings("unused")
		String axis_start_date = "";
		String axis_end_date = "";
		List axisDateList = new ArrayList();
		xml += "<categories>";
		for (int i = 0; i < designDateList.size(); i++) {
			Map map = designDateList.get(i);
			String axis_date = "" + map.get("record_month");
			axisDateList.add(axis_date);
			if (i == 0) {
				axis_start_date = axis_date;
			} else if (i == designDateList.size() - 1) {
				axis_end_date = axis_date;
			}
			xml += "<category label='" + axis_date.substring(5) + "' />";
		}
		// 实际生产日期大于设计日期,追加大于设计的日期
		// 2012-11-21 卢占国提出实际大于设计不添加日期
		int addDay = 0;
		String dailyDateSql = " select to_char(produce_date,'yyyy-MM-dd') as produce_date from gp_ops_daily_report where project_info_no = '"
				+ projectInfoNo + "' and bsflag = '0' order by produce_date";
		List<Map> dailyDateList = radDao.queryRecords(dailyDateSql);
		for (int i = 0; i < dailyDateList.size(); i++) {
			Map map = dailyDateList.get(i);
			String axis_date = "" + map.get("produce_date");
			if (DateOperation.diffDaysOfDate(axis_date, axis_end_date) > 0) {
				// xml += "<category label='" + axis_date.substring(5) + "' />";
				axis_end_date = axis_date;
				axisDateList.add(axis_date);
				addDay++;
			}
		}
		xml += "</categories>";

		List<Map> gridData = new ArrayList<Map>();
		String existDrillData = "yes";
		for (int m = 0; m < types.length; m++) {
			String type = types[m];
			String typeName = typeNames[m];
			Map lineMap = new HashMap();
			if ("drilldailylist".equals(type)) {
				if ("5000100003000000002".equals(buildMethod)) {
					lineMap.put("status", "");
					lineMap.put("groupLine", "");
					lineMap.put("designWorkLoad", "");
					lineMap.put("dailyWorkLoad", "");
					lineMap.put("finishPercentage", "");
					lineMap.put("deviation", "");
					lineMap.put("date", "");
					gridData.add(lineMap);
					existDrillData = "no";
					continue;
				}
			}
			String dailyColumn = "";
			String dailyParam = "";
			if (type == "measuredailylist" || "measuredailylist".equals(type)) {
				dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
				endFlagColumn = "survey_process_status";
				dailyParam = " and nvl(workload_num,0) > 0";
		 
			} else if (type == "colldailylist" || "colldailylist".equals(type)) {
				dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0) ";
				endFlagColumn = "collect_process_status";
				dailyParam = " and nvl(workload,0) > 0";
			 
			} else if (type == "drilldailylist"
					|| "drilldailylist".equals(type)) {
				dailyColumn = " nvl(daily_drill_sp_num,0) ";
				endFlagColumn = "drill_process_status";
				dailyParam = " and nvl(workload,0) > 0";
	 
			}

			String sql = "select nvl(workload,0) as paodian,nvl(workload_num,0) as gongli,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,to_date(record_month,'yyyy-MM-dd') as data"
					+ " from gp_proj_product_plan where project_info_no = '"
					+ projectInfoNo
					+ "' and bsflag = '0' "
					+ dailyParam
					+ " and oper_plan_type = '"
					+ type
					+ "' order by record_month ";

			List<Map> designList = radDao.queryRecords(sql);
			if (designList.size() == 0 || designList == null) {
				continue;
			}
			String minDate = (String) ((Map) designList.get(0))
					.get("record_month");
			String maxDate = (String) ((Map) designList
					.get(designList.size() - 1)).get("record_month");
			String produceStartDate = "";
			String produceEndDate = "";
			String produceCurDate = "";

			// 取当前工序的结束状态
			String endFlagSql = "select "
					+ endFlagColumn
					+ " as end_flag from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "
					+ " where d.produce_date = (select max(produce_date) from gp_ops_daily_report where project_info_no = '"
					+ projectInfoNo
					+ "' and audit_status = '3' and bsflag = '0' and "
					+ dailyColumn + " > 0) " + " and project_info_no = '"
					+ projectInfoNo + "' and d.bsflag = '0'";
			String statusDesc = "";
			Map recordMap = radDao.queryRecordBySQL(endFlagSql);
			if (recordMap != null) {
				String value = "" + recordMap.get("end_flag");
				if ("1".equals(value)) {
					statusDesc = "未开始";
				} else if ("2".equals(value)) {
					statusDesc = "正在施工";
				} else if ("3".equals(value)) {
					statusDesc = "结束";
				}
			}

			// 取施工线束
			sql = "select a.* from bgp_p6_activity a"
					+ " join bgp_p6_project_wbs w on w.object_id = a.wbs_object_id and w.bsflag = '0' "
					+ " join bgp_p6_project p on p.object_id = w.project_object_id and w.name = '"
					+ typeName + "'" + " and p.project_info_no = '"
					+ projectInfoNo + "'" + " where a.status = 'In Progress'";// Completed
																				// In
																				// Progress
			List<Map> groupLineList = radDao.queryRecords(sql);
			String groupLineName = "";
			if (groupLineList != null) {
				for (int i = 0; i < groupLineList.size(); i++) {
					Map groupLineMap = groupLineList.get(i);
					String value = "" + groupLineMap.get("name");
					if (!"".equals(value)) {
						groupLineName = groupLineName + "&nbsp;&nbsp;" + value;
					}
				}
			}
			lineMap.put("status", statusDesc);
			lineMap.put("groupLine", groupLineName);

			sql = "select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)) as coll_value"
					+ ",sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value"
					+ ",sum(nvl(d.daily_drill_sp_num,0)) as drill_value"
					+ ",sum(nvl(d.daily_micro_measue_point_num,0)+nvl(d.daily_small_refraction_num,0)) as surface_value"
					+ ",to_char(produce_date,'yyyy-MM-dd') as produce_date"
					+
					// ",produce_date-to_date('"+minDate+"','yyyy-MM-dd') as deviation_date"+
					" from gp_ops_daily_report d where project_info_no = '"
					+ projectInfoNo
					+ "' and bsflag = '0' and audit_status = '3'"
					+ " and "
					+ dailyColumn + " > 0 " +
					// " and produce_date >= to_date('"+minDate+"','yyyy-MM-dd') and produce_date <= to_date('"+maxDate+"','yyyy-MM-dd')"+
					" group by produce_date order by produce_date ";

			xml += "<dataset color='" + colors[m] + "' anchorBorderColor='"
					+ colors[m] + "' anchorBgColor='" + colors[m]
					+ "' seriesName='" + typeName + "偏离度'>";

			// // add by liweiming
			// if(DateOperation.diffDaysOfDate(minDate, axis_start_date) > 0){
			// long diffDays = DateOperation.diffDaysOfDate(minDate,
			// axis_start_date);
			// for(int k=0; k<diffDays; k++){
			// xml += "<set/>";
			// }
			// }
			// // end add by liweiming

			List<Map> dailyList = radDao.queryRecords(sql);
			if (dailyList != null && dailyList.size() > 0) {
				produceStartDate = (String) ((Map) dailyList.get(0))
						.get("produce_date");
				produceCurDate = (String) ((Map) dailyList
						.get(dailyList.size() - 1)).get("produce_date");
				if ("结束".equals(statusDesc) || "结束" == statusDesc) {
					produceEndDate = (String) ((Map) dailyList.get(dailyList
							.size() - 1)).get("produce_date");
				}
			}

			DecimalFormat df = new DecimalFormat();
			String style = "0.00";

			df.applyPattern(style);

			int actualNum = 0;
			int designNum = 0;
			double radio = 0.0;

			// 阀值
			double value = 100;
			double sum_daily_num = 0;
			double sum_design_num = 0;

			String designDateColumn = "record_month";
			String dailyDateColumn = "produce_date";
			String designValueColumn = "";
			String dailyValueColumn = "";

			String[] measure2Type = { "G02003", "G02004" };
			String[] measure3Type = { "G2003", "G2004" };

			String[] drill2Type = { "G05001" };
			String[] drill3Type = { "G5001" };

			String[] coll2Type = { "G07001", "G07003", "G07005" };
			String[] coll3Type = { "GS7001", "GS7002" };

			sql = "select exploration_method from gp_task_project  where project_info_no = '"
					+ projectInfoNo + "' and bsflag = '0'";
			List<Map> list = radDao.queryRecords(sql);

			String exploration_method = null;
			if (list != null && list.size() != 0) {
				Map map = (Map) list.get(0);
				exploration_method = (String) map.get("exploration_method");
			} else {
				return null;
			}

			String sqlTemp = "";

			if (type == "colldailylist" || "colldailylist".equals(type)) {
				// 采集
				designValueColumn = "paodian";
				dailyValueColumn = "coll_value";
				if (exploration_method == "0300100012000000002"
						|| "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < coll2Type.length; i++) {
						sqlTemp = sqlTemp + coll2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < coll3Type.length; i++) {
						sqlTemp = sqlTemp + coll3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				}

			} else if (type == "measuredailylist"
					|| "measuredailylist".equals(type)) {
				// 测量
				designValueColumn = "gongli";
				dailyValueColumn = "measure_value";
				if (exploration_method == "0300100012000000002"
						|| "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < measure2Type.length; i++) {
						sqlTemp = sqlTemp + measure2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < measure3Type.length; i++) {
						sqlTemp = sqlTemp + measure3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				}
			} else if (type == "drilldailylist"
					|| "drilldailylist".equals(type)) {
				// 钻井
				designValueColumn = "paodian";
				dailyValueColumn = "drill_value";
				if (exploration_method == "0300100012000000002"
						|| "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < drill2Type.length; i++) {
						sqlTemp = sqlTemp + drill2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < drill3Type.length; i++) {
						sqlTemp = sqlTemp + drill3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				}
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

			// System.out.println("type:"+type);

			for (int i = 0; i < axisDateList.size(); i++) {
				String axisDate = "" + axisDateList.get(i);

				if (DateOperation.diffDaysOfDate(produceCurDate, axisDate) >= 0) {
					String designValue = "" + designData.get(axisDate);
					String dailyValue = "" + dailyData.get(axisDate);

					if ("null".equals(designValue) || "".equals(designValue)) {
						designValue = "0";
					}
					if ("null".equals(dailyValue) || "".equals(dailyValue)) {
						dailyValue = "0";
					}
					double designNum1 = Double.parseDouble(designValue);
					double actualNum1 = Double.parseDouble(dailyValue);
					sum_daily_num += actualNum1;
					// 设计值改为从bgp_p6_workload中查询
					sum_design_num += designNum1;
					// System.out.println("axisDate:"+axisDate);
					// System.out.println("sum_design_num"+sum_design_num);
					// System.out.println("sum_daily_num"+sum_daily_num);
					if (DateOperation.diffDaysOfDate(axisDate, minDate) >= 0
							&& DateOperation.diffDaysOfDate(maxDate, axisDate) >= 0) {
						if (sum_design_num == 0) {
							radio = 0;
						} else {
							radio = (double) (sum_daily_num - sum_design_num)
									/ sum_design_num * 100;
						}

						xml += "<set value='" + df.format(radio) + "' />";

					} else {
						xml += "<set/>";
					}
					if (DateOperation.diffDaysOfDate(axisDate, minDate) >= 0
							&& DateOperation.diffDaysOfDate(produceEndDate,
									axisDate) >= 0) {
						if (sum_design_num == 0) {
							radio = 0;
						} else {
							radio = (double) (sum_daily_num - sum_design_num)
									/ sum_design_num * 100;
						}
					}
				}
			}

			sql = "select sum(nvl(planned_units,0)) as num from bgp_p6_workload where project_info_no = '"
					+ projectInfoNo
					+ "' and produce_date is null and bsflag = '0' and resource_id in ";
			sql += sqlTemp;
			// break 1
			System.out.println("The sql is:" + sql);
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map map = list.get(0);
				// 之前设计工作量的赋值
				// 20130415又改回这个了
				lineMap.put("designWorkLoad", "" + (String) map.get("num"));
				lineMap.put(
						"finishPercentage",
						""
								+ df.format(sum_daily_num
										/ Double.parseDouble((String) map
												.get("num")) * 100));
			}

			// 现在设计工作量的赋值
			// lineMap.put("designWorkLoad", "" + df.format(sum_design_num));
			lineMap.put("dailyWorkLoad", "" + df.format(sum_daily_num));
			// lineMap.put("finishPercentage", "" + df.format(sum_daily_num /
			// sum_design_num * 100));
			// 改成从bgp_p6_workload中查询设计工作量

			if (DateOperation.diffDaysOfDate(produceEndDate, maxDate) > 0) {
				lineMap.put(
						"deviation",
						"超出计划日期"
								+ DateOperation.diffDaysOfDate(produceEndDate,
										maxDate) + "天");

			} else if (DateOperation.diffDaysOfDate(minDate, produceEndDate) > 0) {
				lineMap.put(
						"deviation",
						"实际比计划早开始"
								+ DateOperation.diffDaysOfDate(minDate,
										produceStartDate) + "天");

			} else if (DateOperation.diffDaysOfDate(maxDate, produceEndDate) > 0) {
				lineMap.put(
						"deviation",
						"实际比计划提前完成"
								+ DateOperation.diffDaysOfDate(maxDate,
										produceEndDate) + "天");

			} else {
				lineMap.put("deviation", "" + df.format(radio));

			}
			lineMap.put("date", produceEndDate);
			lineMap.put("designDate", maxDate);
			lineMap.put("startDate", produceStartDate);
			lineMap.put("minDesignDate", minDate);
			gridData.add(lineMap);

			// else if (type == "surfacedailylist" ||
			// "surfacedailylist".equals(type)) {
			// //表层
			// for (int i = 0; i < list.size(); i++) {
			// Map map = list.get(i);
			// Map map1 = designList.get(i);
			// actualNum = Integer.parseInt((String) map.get("surface_value"));
			// designNum = Integer.parseInt((String) map1.get("paodian"));
			// radio = Math.abs((double)(designNum - actualNum) /designNum)*100;
			// if (radio >= value) {
			// xml += "<set value='"+df.format(radio)+"' />";
			// } else {
			// xml += "<set value='"+df.format(radio)+"' />";
			// }
			// }
			// }

			xml += "</dataset>";
		}
		// 阀值线
		xml += "<trendlines>";

		// xml +=
		// "<line startValue='-30'  displayValue='健康' showOnTop='1' color='69bf5d'   valueOnRight='1'  dashed='1'  thickness='2'/>";

		// xml +=
		// "<line startValue='30' color='91C728' displayValue='健康' showOnTop='1'/>";

		// xml +=
		// "<line startValue='-60' color='AA0000' displayValue='危险' showOnTop='1'  valueOnRight='1'  dashed='1'  thickness='2'/>";

		// xml +=
		// "<line startValue='60' color='AA0000' displayValue='危险' showOnTop='1'/>";

		xml += "<line startValue='0' color='000000' showOnTop='0' thickness='2'/>";

		xml += "</trendlines>";

		// 样式区
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
	public ISrvMsg getDgBuild(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}
		 String sql="select  t.BUILD_METHOD from gp_task_project t where t.project_info_no='"+projectInfoNo+"'";
		 Map  map = radDao.queryRecordBySQL(sql);
			msg.setValue("map", map);
		return msg;
		
	}

	/**
	 * 进度管理--进度分析--大港物探处专用代码 请勿修改  add by bianshen @ 2014-2-24 11:03:51
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg getDgDeviation(ISrvMsg reqDTO) throws Exception {
   
	UserToken user = reqDTO.getUserToken();
	String projectInfoNo = reqDTO.getValue("projectInfoNo");

	ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

	if (projectInfoNo == null || "".equals(projectInfoNo)) {
		projectInfoNo = user.getProjectInfoNo();
	}

	WorkMethodSrv wm = new WorkMethodSrv();
	String buildMethod = wm.getProjectExcitationMode(projectInfoNo);

	String xml = "<chart showValues='0' numberSuffix='%' yAxisName='负数表示滞后，正数表示超前' rotateYAxisName='0' yAxisNameWidth='16'>";

	// 标题 x坐标标题 y坐标标题 是否显示数据
	String[] types = { "measuredailylist", "colldailylist",
			"drilldailylist" };
	String[] typeNames = { "测量", "采集", "钻井" };
	String[] colors = { "1381c0", "69bf5d", "fd962e" };

	String endFlagColumn = "survey_process_status";

	String designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month "
			+ " from gp_proj_product_plan where project_info_no = '"
			+ projectInfoNo
			+ "' and bsflag = '0' "
			+ " and oper_plan_type in('colldailylist','measuredailylist','drilldailylist') order by record_month";
	if ("5000100003000000002".equals(buildMethod)) {
		designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month "
				+ " from gp_proj_product_plan where project_info_no = '"
				+ projectInfoNo
				+ "' and bsflag = '0' "
				+ " and oper_plan_type in('colldailylist','measuredailylist') order by record_month";
	}

	List<Map> designDateList = radDao.queryRecords(designDateSql);
	if (designDateList == null || designDateList.size() == 0) {
		return msg;
	}
	// x坐标绘制
	@SuppressWarnings("unused")
	String axis_start_date = "";
	String axis_end_date = "";
	List axisDateList = new ArrayList();
	xml += "<categories>";
	for (int i = 0; i < designDateList.size(); i++) {
		Map map = designDateList.get(i);
		String axis_date = "" + map.get("record_month");
		axisDateList.add(axis_date);
		if (i == 0) {
			axis_start_date = axis_date;
		} else if (i == designDateList.size() - 1) {
			axis_end_date = axis_date;
		}
		xml += "<category label='" + axis_date.substring(5) + "' />";
	}
	// 实际生产日期大于设计日期,追加大于设计的日期
	// 2012-11-21 卢占国提出实际大于设计不添加日期
	int addDay = 0;
	String dailyDateSql = " select to_char(produce_date,'yyyy-MM-dd') as produce_date from gp_ops_daily_report where project_info_no = '"
			+ projectInfoNo + "' and bsflag = '0' order by produce_date";
	List<Map> dailyDateList = radDao.queryRecords(dailyDateSql);
	for (int i = 0; i < dailyDateList.size(); i++) {
		Map map = dailyDateList.get(i);
		String axis_date = "" + map.get("produce_date");
		if (DateOperation.diffDaysOfDate(axis_date, axis_end_date) > 0) {
			// xml += "<category label='" + axis_date.substring(5) + "' />";
			axis_end_date = axis_date;
			axisDateList.add(axis_date);
			addDay++;
		}
	}
	xml += "</categories>";

	List<Map> gridData = new ArrayList<Map>();
	String existDrillData = "yes";
	for (int m = 0; m < types.length; m++) {
		String type = types[m];
		String typeName = typeNames[m];
		Map lineMap = new HashMap();
		if ("drilldailylist".equals(type)) {
			if ("5000100003000000002".equals(buildMethod)) {
				lineMap.put("status", "");
				lineMap.put("groupLine", "");
				lineMap.put("designWorkLoad", "");
				lineMap.put("dailyWorkLoad", "");
				lineMap.put("finishPercentage", "");
				lineMap.put("deviation", "");
				lineMap.put("date", "");
				gridData.add(lineMap);
				existDrillData = "no";
				continue;
			}
		}
		String dailyColumn = "";
		String dailyParam = "";
		if (type == "measuredailylist" || "measuredailylist".equals(type)) {
			dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
			endFlagColumn = "survey_process_status";
			dailyParam = " and nvl(workload_num,0) > 0";
			lineMap.put("xName", "测量");
		} else if (type == "colldailylist" || "colldailylist".equals(type)) {
			dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0) ";
			endFlagColumn = "collect_process_status";
			dailyParam = " and nvl(workload,0) > 0";
			lineMap.put("xName", "采集");
		} else if (type == "drilldailylist"
				|| "drilldailylist".equals(type)) {
			dailyColumn = " nvl(daily_drill_sp_num,0) ";
			endFlagColumn = "drill_process_status";
			dailyParam = " and nvl(workload,0) > 0";
			lineMap.put("xName", "钻井");
		}

		String sql = "select nvl(workload,0) as paodian,nvl(workload_num,0) as gongli,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,to_date(record_month,'yyyy-MM-dd') as data"
				+ " from gp_proj_product_plan where project_info_no = '"
				+ projectInfoNo
				+ "' and bsflag = '0' "
				+ dailyParam
				+ " and oper_plan_type = '"
				+ type
				+ "' order by record_month ";

		List<Map> designList = radDao.queryRecords(sql);
		if (designList.size() == 0 || designList == null) {
			continue;
		}
		String minDate = (String) ((Map) designList.get(0))
				.get("record_month");
		String maxDate = (String) ((Map) designList
				.get(designList.size() - 1)).get("record_month");
		String produceStartDate = "";
		String produceEndDate = "";
		String produceCurDate = "";

		
		
		// 取施工线束
		sql = "select a.* from bgp_p6_activity a"
				+ " join bgp_p6_project_wbs w on w.object_id = a.wbs_object_id and w.bsflag = '0'  and a.bsflag='0' "
				+ " join bgp_p6_project p on p.object_id = w.project_object_id where w.name = '"
				+ typeName + "'" + " and p.project_info_no = '"
				+ projectInfoNo +  "' and w.name!=a.name order by a.name desc" ;// Completed
																			// In
																			// Progress
		List<Map> groupLineList = radDao.queryRecords(sql);
		String groupLineName = "";
		String startDate="";
		String endDate="";
		String statusDesc = "";
		String lineDate="";
		String lineEnd="";
        String  psDate="";
        String pfDate="";
			if (groupLineList != null) {
				for (int i = 0; i < groupLineList.size(); i++) {
					Map groupLineMap = groupLineList.get(i);
					String value =(String) groupLineMap.get("name");

					if (!" ".equals(value)) {
						
						if (groupLineMap.equals(" "))
							groupLineName = value;
						else
							groupLineName = value + "," + groupLineName;//查线束用逗号分割
					}
					String planDate=" "+groupLineMap.get("planned_start_date");
					if(planDate.equals(" ")){
						planDate=" ";
					}
					psDate=planDate+","+psDate;
					String finishDate=" "+groupLineMap.get("planned_finish_date");
					if(finishDate.equals(" ")){
						finishDate=" ";
					}
					pfDate=finishDate+","+pfDate;
					String valueDate =   " "+groupLineMap.get("actual_start_date");
					if(valueDate.equals(" ")){
						valueDate=" ";
					
					}
					lineDate=valueDate+","+lineDate;

					String valueEndDate =  " "+groupLineMap.get("actual_finish_date");
					if(valueEndDate.equals(" ")){
						valueEndDate=" ";
					
					}
					
					lineEnd=valueEndDate+","+lineEnd;
					if (valueDate.equals(" ")&&valueEndDate.equals(" ")) {  //查施工状态根据开始时间和结束时间判断状态
						statusDesc="未开始,"+statusDesc;                  //开始时间为空“未开始”
					}else if(!" ".equals(valueDate)&&" ".equals(valueEndDate)){
						statusDesc="正在施工,"+statusDesc;                //开始时间不为空，结束时间为空，“正在施工”
					}else if(!" ".equals(valueDate)&&!" ".equals(valueEndDate)){
						statusDesc="结束,"+statusDesc;                    //开始时间，结束时间不为空  “结束”
					}
				}
			}
			lineMap.put("designDate", pfDate);
			lineMap.put("minDesignDate", psDate);
			lineMap.put("endDate", lineEnd);
		lineMap.put("groupLine", groupLineName);
		lineMap.put("startDate", lineDate);
		lineMap.put("status", statusDesc);
		DecimalFormat df = new DecimalFormat();
		String style = "0.00";
		df.applyPattern(style);
		int actualNum = 0;
		int designNum = 0;
		double radio = 0.0;

		// 阀值
		double value = 100;
		double sum_daily_num = 0;
		double sum_design_num = 0;

		String designDateColumn = "record_month";
		String dailyDateColumn = "produce_date";
		String designValueColumn = "";
		String dailyValueColumn = "";

		String[] measure2Type = { "G02003", "G02004" };
		String[] measure3Type = { "G2003", "G2004" };

		String[] drill2Type = { "G05001" };
		String[] drill3Type = { "G5001" };


		String[] coll2Type = { "G07001", "G07003", "G07005" };
		String[] coll3Type ={ "G7001", "G7003","G7005" };
		/*
		 * String[] measure2Type = { "G02003", "G02004" };
			String[] measure3Type = { "G2003", "G2004" };

			String[] drill2Type = { "G05001" };
			String[] drill3Type = { "G5001" };

			String[] coll2Type = { "G07001", "G07003", "G07005" };
			String[] coll3Type = { "GS7001", "GS7002" };

		 */

		sql = "select exploration_method from gp_task_project  where project_info_no = '"
				+ projectInfoNo + "' and bsflag = '0'";
		List<Map> list = radDao.queryRecords(sql);

		String exploration_method = null;
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			exploration_method = (String) map.get("exploration_method");
		} else {
			return null;
		}

		String sqlTemp = "";

		if (type == "colldailylist" || "colldailylist".equals(type)) {
			// 采集
			designValueColumn = "paodian";
			dailyValueColumn = "coll_value";
			if (exploration_method == "0300100012000000002"
					|| "0300100012000000002".equals(exploration_method)) {
				sqlTemp = "('";
				for (int i = 0; i < coll2Type.length; i++) {
					sqlTemp = sqlTemp + coll2Type[i] + "','";
				}
				sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
				sqlTemp += ")";
			} else {
				sqlTemp = "('";
				for (int i = 0; i < coll3Type.length; i++) {
					sqlTemp = sqlTemp + coll3Type[i] + "','";
				}
				sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
				sqlTemp += ")";
			}

		} else if (type == "measuredailylist"
				|| "measuredailylist".equals(type)) {
			// 测量
			designValueColumn = "gongli";
			dailyValueColumn = "measure_value";
			if (exploration_method == "0300100012000000002"
					|| "0300100012000000002".equals(exploration_method)) {
				sqlTemp = "('";
				for (int i = 0; i < measure2Type.length; i++) {
					sqlTemp = sqlTemp + measure2Type[i] + "','";
				}
				sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
				sqlTemp += ")";
			} else {
				sqlTemp = "('";
				for (int i = 0; i < measure3Type.length; i++) {
					sqlTemp = sqlTemp + measure3Type[i] + "','";
				}
				sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
				sqlTemp += ")";
			}
		} else if (type == "drilldailylist"
				|| "drilldailylist".equals(type)) {
			// 钻井
			designValueColumn = "paodian";
			dailyValueColumn = "drill_value";
			if (exploration_method == "0300100012000000002"
					|| "0300100012000000002".equals(exploration_method)) {
				sqlTemp = "('";
				for (int i = 0; i < drill2Type.length; i++) {
					sqlTemp = sqlTemp + drill2Type[i] + "','";
				}
				sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
				sqlTemp += ")";
			} else {
				sqlTemp = "('";
				for (int i = 0; i < drill3Type.length; i++) {
					sqlTemp = sqlTemp + drill3Type[i] + "','";
				}
				sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
				sqlTemp += ")";
			}
		}
		Map designData = new HashMap();
		Map dailyData = new HashMap();

		for (int i = 0; i < designList.size(); i++) {
			Map designMap = designList.get(i);
			String designDate = "" + designMap.get(designDateColumn);
			String designValue = "" + designMap.get(designValueColumn);
			designData.put(designDate, designValue);
		}

		sql = "select sum(pd.actual_this_period_units) as "+dailyValueColumn+",pd.produce_date  from bgp_p6_workload pd " +
		 "inner join  gp_ops_daily_report  t  on t.project_info_no=pd.project_info_no  and t.produce_date=pd.produce_date and t.bsflag='0'"+		
		" where pd.project_info_no = '"+projectInfoNo+"'and t.audit_status='3'  "+
" and  pd.bsflag = '0'  and pd.resource_id in"+sqlTemp+"  and pd.produce_date is not null  and pd.actual_this_period_units>0"+
" group by pd.produce_date  order by pd.produce_date";
//			 over(order by pd.produce_date)
//		String sql = "select sum(nvl(d.actual_this_period_units,0)) as sum_daily_num from bgp_p6_workload d " +
//        "inner join  gp_ops_daily_report  t  on t.project_info_no=d.project_info_no  and t.produce_date=d.produce_date and t.bsflag='0'"+
//	" where d.project_info_no = '"
//+ projectInfoNo
//+ "' and d.produce_date is not null and t.audit_status='3' and d.bsflag = '0' and d.resource_id in ";
			 
			 
		xml += "<dataset color='" + colors[m] + "' anchorBorderColor='"
				+ colors[m] + "' anchorBgColor='" + colors[m]
				+ "' seriesName='" + typeName + "偏离度'>";

 
		List<Map> dailyList = radDao.queryRecords(sql);
		if (dailyList != null && dailyList.size() > 0) {
			produceStartDate = (String) ((Map) dailyList.get(0))
					.get("produce_date");
			produceCurDate = (String) ((Map) dailyList
					.get(dailyList.size() - 1)).get("produce_date");
			if ("结束".equals(statusDesc) || "结束" == statusDesc) {
				produceEndDate = (String) ((Map) dailyList.get(dailyList
						.size() - 1)).get("produce_date");
			}
		} 
		for (int i = 0; i < dailyList.size(); i++) {
			Map dailyMap = dailyList.get(i);
			String produce_date = "" + dailyMap.get(dailyDateColumn);
			String dailyValue = "" + dailyMap.get(dailyValueColumn);
			dailyData.put(produce_date, dailyValue);
		}

		// System.out.println("type:"+type);

	
		sql = "select sum(nvl(planned_units,0)) as num from bgp_p6_workload where project_info_no = '"
				+ projectInfoNo
				+ "' and produce_date is null and bsflag = '0' and resource_id in ";
		sql += sqlTemp;
		// break 1
		System.out.println("The sql is:" + sql);
		list = radDao.queryRecords(sql);
		if (list != null && list.size() != 0) {
			Map map = list.get(0);
			// 之前设计工作量的赋值
			// 20130415又改回这个了
			lineMap.put("designWorkLoad", "" + (String) map.get("num"));
	
		}
		String sqlShi = "select sum(nvl(d.actual_this_period_units,0)) as sum_daily_num from bgp_p6_workload d " +
		               "inner join  gp_ops_daily_report  t  on t.project_info_no=d.project_info_no  and t.produce_date=d.produce_date and t.bsflag='0'"+
				" where d.project_info_no = '"
			+ projectInfoNo
			+ "' and d.produce_date is not null and t.audit_status='3' and d.bsflag = '0' and d.resource_id in ";
		sqlShi += sqlTemp;
	 
		List listShi = radDao.queryRecords(sqlShi);
		if (listShi != null && listShi.size() != 0) {
			Map map = (Map) listShi.get(0);
		 
			//实际工作量
				lineMap.put("dailyWorkLoad", "" +  (String) map.get("sum_daily_num"));
	
		}
	
		for (int i = 0; i < axisDateList.size(); i++) {
			String axisDate = "" + axisDateList.get(i);

			if (DateOperation.diffDaysOfDate(produceCurDate, axisDate) >= 0) {
				String designValue = "" + designData.get(axisDate);
				String dailyValue = "" + dailyData.get(axisDate);

				if ("null".equals(designValue) || "".equals(designValue)) {
					designValue = "0";
				}
				if ("null".equals(dailyValue) || "".equals(dailyValue)) {
					dailyValue = "0";
				}
				double designNum1 = Double.parseDouble(designValue);
				double actualNum1 = Double.parseDouble(dailyValue);
				sum_daily_num += actualNum1;
				// 设计值改为从bgp_p6_workload中查询
				sum_design_num += designNum1;
				// System.out.println("axisDate:"+axisDate);
				// System.out.println("sum_design_num"+sum_design_num);
				// System.out.println("sum_daily_num"+sum_daily_num);
				if (DateOperation.diffDaysOfDate(axisDate, minDate) >= 0
						&& DateOperation.diffDaysOfDate(maxDate, axisDate) >= 0) {
					if (sum_design_num == 0) {
						radio = 0;
					} else {
						radio = (double) (sum_daily_num - sum_design_num)
								/ sum_design_num * 100;
					}

					xml += "<set value='" + df.format(radio) + "' />";

				} else {
					xml += "<set/>";
				}
				if (DateOperation.diffDaysOfDate(axisDate, minDate) >= 0
						&& DateOperation.diffDaysOfDate(produceEndDate,
								axisDate) >= 0) {
					if (sum_design_num == 0) {
						radio = 0;
					} else {
						radio = (double) (sum_daily_num - sum_design_num)
								/ sum_design_num * 100;
					}
				}
			}
		}

		
 
		if (DateOperation.diffDaysOfDate(produceEndDate, maxDate) > 0) {
			lineMap.put(
					"deviation",
					"超出计划日期"
							+ DateOperation.diffDaysOfDate(produceEndDate,
									maxDate) + "天");

		} else if (DateOperation.diffDaysOfDate(minDate, produceEndDate) > 0) {
			lineMap.put(
					"deviation",
					"实际比计划早开始"
							+ DateOperation.diffDaysOfDate(minDate,
									produceStartDate) + "天");

		} else if (DateOperation.diffDaysOfDate(maxDate, produceEndDate) > 0) {
			lineMap.put(
					"deviation",
					"实际比计划提前完成"
							+ DateOperation.diffDaysOfDate(maxDate,
									produceEndDate) + "天");

		} else {
			lineMap.put("deviation", "" + df.format(radio));

		}
  
			lineMap.put("date", produceEndDate);
//			lineMap.put("designDate", maxDate);
//			//lineMap.put("startDate", produceStartDate);
//			lineMap.put("minDesignDate", minDate);
			gridData.add(lineMap);
	 
	

		// else if (type == "surfacedailylist" ||
		// "surfacedailylist".equals(type)) {
		// //表层
		// for (int i = 0; i < list.size(); i++) {
		// Map map = list.get(i);
		// Map map1 = designList.get(i);
		// actualNum = Integer.parseInt((String) map.get("surface_value"));
		// designNum = Integer.parseInt((String) map1.get("paodian"));
		// radio = Math.abs((double)(designNum - actualNum) /designNum)*100;
		// if (radio >= value) {
		// xml += "<set value='"+df.format(radio)+"' />";
		// } else {
		// xml += "<set value='"+df.format(radio)+"' />";
		// }
		// }
		// }

		xml += "</dataset>";
	}
	// 阀值线
	xml += "<trendlines>";

	// xml +=
	// "<line startValue='-30'  displayValue='健康' showOnTop='1' color='69bf5d'   valueOnRight='1'  dashed='1'  thickness='2'/>";

	// xml +=
	// "<line startValue='30' color='91C728' displayValue='健康' showOnTop='1'/>";

	// xml +=
	// "<line startValue='-60' color='AA0000' displayValue='危险' showOnTop='1'  valueOnRight='1'  dashed='1'  thickness='2'/>";

	// xml +=
	// "<line startValue='60' color='AA0000' displayValue='危险' showOnTop='1'/>";

	xml += "<line startValue='0' color='000000' showOnTop='0' thickness='2'/>";

	xml += "</trendlines>";

	// 样式区
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


	public ISrvMsg getProjectDynamic(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String project_year = reqDTO.getValue("project_year");
		if (orgSubjectionId == null || "".equals(orgSubjectionId)) {
			orgSubjectionId = user.getSubOrgIDofAffordOrg();
		}
		
		Date date = new Date();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String d = sdf.format(date);
		
		String sql = "select count(gp.project_info_no) as num,project_status from gp_task_project gp "+
			" join gp_task_project_dynamic dy "+
			" on dy.project_info_no = gp.project_info_no "+
			" and dy.exploration_method = gp.exploration_method "+
			" and gp.project_year='"+project_year+"'"+
			" and dy.bsflag = '0' and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
			" where gp.bsflag = '0' "+
			" and gp.project_status is not null "+
			" and gp.acquire_start_time >= "+
		    " (select min(gp.acquire_start_time) from gp_task_project gp"+
		    " join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no"+  
		    " and dy.exploration_method = gp.exploration_method"+
		    " and dy.bsflag = '0' and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
		    " join rpt_gp_daily dr on dr.project_info_no = gp.project_info_no and dr.bsflag = '0'"+
		    " and dr.send_date <= to_date('"+d+"','yyyy-MM-dd')"+
		    " where gp.bsflag = '0')"+ 
			" group by gp.project_status";
		
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
		
		sql = "select sum(nvl(rpt.daily_finishing_2d_sp,0)) as daily_finishing_2d_sp,sum(nvl(rpt.daily_finishing_3d_sp,0)) as daily_finishing_3d_sp,sum(nvl(rpt.finish_2d_workload,0)) as finish_2d_workload,sum(nvl(rpt.finish_3d_workload,0)) as finish_3d_workload "
				+ "from rpt_gp_daily rpt "
				+ "join gp_task_project gp "
				+ "on rpt.project_info_no = gp.project_info_no "
				+ "where rpt.org_subjection_id like '"+orgSubjectionId+"%' and rpt.bsflag = '0' and gp.bsflag='0' "
				+ "and gp.project_year='"+project_year+"'"+
		      "and rpt.send_date <= to_date('"+d+"','yyyy-MM-dd')";
		list = radDao.queryRecords(sql);
		if (list != null && list.size() != 0) {
			map.putAll(list.get(0));
		}
		
		DecimalFormat df = new DecimalFormat();
		String style = "0.00%";
		
		df.applyPattern(style);
		
		sql = "select distinct gp.project_info_no,gp.project_name,ccsd.coding_name,oi.org_abbreviation,gp.vsp_team_leader,"
				+ " case gp.exploration_method when '0300100012000000002' then case dy.work_load2 when '1' then dy.design_physical_workload  when '2' then dy.design_data_workload when '3' then dy.design_object_workload end "
				+ " else case dy.work_load3 when '1' then dy.design_execution_area when '2' then dy.design_data_workload when '3' then dy.design_object_workload  end end as design_object_workload,"
				+ "dy.design_sp_num2 as design_sp_num "+
				" ,case gp.exploration_method when '0300100012000000002' then sum(nvl(rpt.daily_finishing_2d_sp,0)) over (partition by rpt.project_info_no) else sum(nvl(rpt.daily_finishing_3d_sp,0)) over (partition by rpt.project_info_no) end as daily_sp "+
				" ,case gp.exploration_method when '0300100012000000002' then sum(nvl(rpt.finish_2d_workload,0)) over (partition by rpt.project_info_no) else sum(nvl(rpt.finish_3d_workload,0)) over (partition by rpt.project_info_no) end as daily_workload "+
				" ,case gp.project_status when '5000100001000000001' then '项目启动' when '5000100001000000002' then '正在施工' when '5000100001000000003' then '项目结束' when '5000100001000000004' then '项目暂停' when '5000100001000000005' then '施工结束' end as project_status "+
				" ,nvl(gp.project_end_time,gp.design_end_date) as project_end_date "+
				" ,pm_info,qm_info,hse_info"+
				" from gp_task_project gp "+
				" join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no and dy.bsflag = '0' and gp.bsflag='0' and gp.project_year='"+project_year+"' and dy.exploration_method = gp.exploration_method and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
				" join comm_org_information oi on dy.org_id = oi.org_id "+
				" left join comm_coding_sort_detail ccsd on gp.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' "+
				" join rpt_gp_daily rpt on rpt.project_info_no = gp.project_info_no and rpt.bsflag = '0' and rpt.send_date <= to_date('"+d+"','yyyy-MM-dd')"+
				" left join bgp_pm_project_heath_info info on info.project_info_no = gp.project_info_no "+
				" where gp.acquire_start_time >= " +
			    " (select min(gp.acquire_start_time) from gp_task_project gp"+
			    " join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no"+  
			    " and dy.exploration_method = gp.exploration_method"+
			    " and dy.bsflag = '0' and  gp.bsflag='0' and gp.project_year='"+project_year+"' and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
			    " join rpt_gp_daily dr on dr.project_info_no = gp.project_info_no and dr.bsflag = '0'"+
			    " and dr.send_date <= to_date('"+d+"','yyyy-MM-dd')"+
			    " where gp.bsflag = '0')"+ 
				" and gp.project_status is not null and gp.bsflag = '0' ";
		
		List<Map> datas = radDao.queryRecords(sql);
		
		for (Iterator iterator = datas.iterator(); iterator.hasNext();) {
			Map data = (Map) iterator.next();
			String design_object_workload = (String) data.get("design_object_workload");
			//String daily_workload = (String) data.get("daily_workload");
			//如果出现跨年的项目  统计进度的时候需要累积项目开始以后所有完成的工作量  不能只统计从年初到当前日期完成的工作量 add by bianshen
			String project_info_no = (String) data.get("project_info_no");
			String sql_in_for = " select distinct case gp.exploration_method when '0300100012000000002'" +
					" then sum(nvl(rpt.finish_2d_workload,0)) over (partition by rpt.project_info_no) " +
					" else sum(nvl(rpt.finish_3d_workload,0)) over (partition by rpt.project_info_no) " +
					" end as daily_workload " +
					" from gp_task_project gp join rpt_gp_daily rpt " +
					" on rpt.project_info_no = gp.project_info_no " +
					" and rpt.bsflag = '0' " +
					" and rpt.project_info_no ='"+project_info_no+"' ";
			List<Map> temp = radDao.queryRecords(sql_in_for);
			if(temp!=null&&temp.size()!=0){
				String daily_workload = temp.get(0).get("daily_workload").toString();
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
			}else{
				data.put("workload_radio", "0.00%");
			}
			
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("map", map);
		msg.setValue("list", datas);
		
		return msg;
	
	}

	
	/**
	 * 大港项目运行动态图
	 * @param projectInfoNo
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectDynamicDg(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String project_year = reqDTO.getValue("project_year");
		if (orgSubjectionId == null || "".equals(orgSubjectionId)) {
			orgSubjectionId = user.getSubOrgIDofAffordOrg();
		}
		
		Date date = new Date();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String d = sdf.format(date);
		
		String sql = "select count(gp.project_info_no) as num,project_status from gp_task_project gp "+
			" join gp_task_project_dynamic dy "+
			" on dy.project_info_no = gp.project_info_no "+
			" and dy.exploration_method = gp.exploration_method "+
			" and gp.project_year='"+project_year+"'"+
			" and dy.bsflag = '0' and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
			" where gp.bsflag = '0' "+
			" and gp.project_status is not null "+
			" and gp.acquire_start_time <= to_date('"+d+"','yyyy-MM-dd')"+
			" group by gp.project_status";
		
		List<Map> list = radDao.queryRecords(sql);
		
		int workNum = 0;//施工
		int stopNum = 0;//停工
		int readyNum = 0;//准备
		int pauseNum = 0;//暂停
	 
		
		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
			Map map = (Map) iterator.next();
			if ("5000100001000000002".equals((String)map.get("project_status"))) {
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
			} else if ("5000100001000000001".equals((String)map.get("project_status"))) {
				//项目启动（项目准备）
				readyNum = Integer.parseInt((String)map.get("num"));
			} 
			
			
		}
		
		Map map = new HashMap();
		map.put("workNum", workNum);
		map.put("stopNum", stopNum);
		map.put("readyNum", readyNum);
		map.put("pauseNum", pauseNum);
		
		//readyNum
		//根据大肛物探处济公提出的需求 立项审核通过 还没报日报的项目 才叫项目准备
		//
//		String sql_count = " SELECT COUNT(*) as num FROM gp_task_project gp JOIN common_busi_wf_middle wf ON gp.project_info_no = wf.BUSINESS_ID "
//				+ " AND gp.bsflag='0' AND wf.bsflag='0' AND wf.PROC_STATUS ='3' "
//				+ " JOIN gp_task_project_dynamic dy ON dy.project_info_no = gp.project_info_no AND dy.bsflag='0'"
//				+ "  AND dy.ORG_SUBJECTION_ID LIKE 'C105007%' ";
//		
//		String map_count_1 = radDao.queryRecordBySQL(sql_count).get("num").toString();
//		
//		sql_count += " JOIN  (SELECT DISTINCT   PROJECT_INFO_NO FROM GP_OPS_DAILY_REPORT  WHERE  BSFLAG='0') rpt ON gp.PROJECT_INFO_NO = rpt.PROJECT_INFO_NO ";
//		String map_count_2 = radDao.queryRecordBySQL(sql_count).get("num").toString();
//		
//		
//		map.put("readyNum", Integer.parseInt(map_count_1)-Integer.parseInt(map_count_2));
		
		map.put("startDate", d.substring(0, 4)+"-01-01");
		map.put("endDate", d);
		
		sql = "select oi.org_abbreviation as org_name from comm_org_information oi,comm_org_subjection os where oi.org_id = os.org_id and os.bsflag = '0' and os.org_subjection_id = '"+orgSubjectionId+"' and oi.bsflag = '0' ";
		
		list = radDao.queryRecords(sql);
		if (list != null && list.size() != 0) {
			map.put("orgName", list.get(0).get("org_name"));
		}
		
		sql = "select sum(nvl(rpt.daily_finishing_2d_sp,0)) as daily_finishing_2d_sp,sum(nvl(rpt.daily_finishing_3d_sp,0)) as daily_finishing_3d_sp,sum(nvl(rpt.finish_2d_workload,0)) as finish_2d_workload,sum(nvl(rpt.finish_3d_workload,0)) as finish_3d_workload "
				+ "from rpt_gp_daily rpt "
				+ "join gp_task_project gp "
				+ "on rpt.project_info_no = gp.project_info_no "
				+ "where rpt.org_subjection_id like '"+orgSubjectionId+"%' and rpt.bsflag = '0' and gp.bsflag='0' "
				+ "and gp.project_year='"+project_year+"'"+
		      "and rpt.send_date <= to_date('"+d+"','yyyy-MM-dd')";
		list = radDao.queryRecords(sql);
		if (list != null && list.size() != 0) {
			map.putAll(list.get(0));
		}
		
		DecimalFormat df = new DecimalFormat();
		String style = "0.00%";
		
		df.applyPattern(style);
		
		sql = "select distinct gp.project_info_no,gp.project_name,ccsd.coding_name,oi.org_abbreviation,gp.vsp_team_leader,"
				+ " case gp.exploration_method when '0300100012000000002' then case dy.work_load2 when '1' then dy.design_physical_workload  when '2' then dy.design_data_workload when '3' then dy.design_object_workload else  dy.design_physical_workload end "
				+ " else case dy.work_load3 when '1' then dy.design_execution_area when '2' then dy.design_data_area when '3' then dy.design_object_area else  dy.design_execution_area   end end as design_object_workload,"
				+ "dy.design_sp_num as design_sp_num "+
				" ,case gp.exploration_method when '0300100012000000002' then sum(nvl(rpt.daily_finishing_2d_sp,0)) over (partition by rpt.project_info_no) else sum(nvl(rpt.daily_finishing_3d_sp,0)) over (partition by rpt.project_info_no) end as daily_sp "+
				" ,case gp.exploration_method when '0300100012000000002' then sum(nvl(rpt.finish_2d_workload,0)) over (partition by rpt.project_info_no) else sum(nvl(rpt.finish_3d_workload,0)) over (partition by rpt.project_info_no) end as daily_workload "+
				" ,case gp.project_status when '5000100001000000001' then '项目启动' when '5000100001000000002' then '正在施工' when '5000100001000000003' then '项目结束' when '5000100001000000004' then '项目暂停' when '5000100001000000005' then '施工结束' end as project_status "+
				" ,nvl(gp.project_end_time,gp.design_end_date) as project_end_date "+
				" ,pm_info,qm_info,hse_info"+
				" from gp_task_project gp "+
				" join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no and dy.bsflag = '0' and gp.bsflag='0' and gp.project_year='"+project_year+"' and dy.exploration_method = gp.exploration_method and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
				" join comm_org_information oi on dy.org_id = oi.org_id "+
				" left join comm_coding_sort_detail ccsd on gp.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' "+
				"left join rpt_gp_daily rpt on rpt.project_info_no = gp.project_info_no and rpt.bsflag = '0' and rpt.send_date <= to_date('"+d+"','yyyy-MM-dd')"+
				" left join bgp_pm_project_heath_info info on info.project_info_no = gp.project_info_no "+
				" where gp.acquire_start_time >= " +
			    " (select min(gp.acquire_start_time) from gp_task_project gp"+
			    " join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no"+  
			    " and dy.exploration_method = gp.exploration_method"+
			    " and dy.bsflag = '0' and  gp.bsflag='0' and gp.project_year='"+project_year+"' and dy.org_subjection_id like '"+orgSubjectionId+"%' "+
			    "left join rpt_gp_daily dr on dr.project_info_no = gp.project_info_no and dr.bsflag = '0'"+
			    " and dr.send_date <= to_date('"+d+"','yyyy-MM-dd')"+
			    " where gp.bsflag = '0')"+ 
				" and gp.project_status is not null and gp.bsflag = '0' ";
		
		List<Map> datas = radDao.queryRecords(sql);
		
		for (Iterator iterator = datas.iterator(); iterator.hasNext();) {
			Map data = (Map) iterator.next();
			String design_object_workload = (String) data.get("design_object_workload");
			//String daily_workload = (String) data.get("daily_workload");
			//如果出现跨年的项目  统计进度的时候需要累积项目开始以后所有完成的工作量  不能只统计从年初到当前日期完成的工作量 add by bianshen
			String project_info_no = (String) data.get("project_info_no");
			String sql_in_for = " select distinct case gp.exploration_method when '0300100012000000002'" +
					" then sum(nvl(rpt.finish_2d_workload,0)) over (partition by rpt.project_info_no) " +
					" else sum(nvl(rpt.finish_3d_workload,0)) over (partition by rpt.project_info_no) " +
					" end as daily_workload " +
					" from gp_task_project gp join rpt_gp_daily rpt " +
					" on rpt.project_info_no = gp.project_info_no " +
					" and rpt.bsflag = '0' " +
					" and rpt.project_info_no ='"+project_info_no+"' ";
			List<Map> temp = radDao.queryRecords(sql_in_for);
			if(temp!=null&&temp.size()!=0){
				String daily_workload = temp.get(0).get("daily_workload").toString();
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
			}else{
				data.put("workload_radio", "0.00%");
			}
			
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("map", map);
		msg.setValue("list", datas);
		
		return msg;
	
	}
	
	
	
	public String getOrgData(String projectInfoNo) throws Exception {
		String sql = "select org_subjection_id from gp_task_project_dynamic where project_info_no='"+projectInfoNo + "'";
		
	  Map m = radDao.queryRecordBySQL(sql);
	  String orgSubId=(String) m.get("org_subjection_id");
		return orgSubId;
		
	}
	public ISrvMsg getGanntData(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getSubOrgIDofAffordOrg();

		// 只显示非完成的项目 按照预计开始时间从上之下排列
		String sql = "select gp.exploration_method,gp.project_info_no,p6.object_id,max(p6.baseline_project_id) as baseline_project_id,gp.project_name,to_char(min(a.planned_start_date),'yyyy-MM-dd') as start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as end_date,"
				+ " to_char(min(a.actual_start_date),'yyyy-MM-dd') as actual_start_date,to_char(max(a.actual_finish_date),'yyyy-MM-dd') as actual_finish_date from gp_task_project gp "
				+
				// " join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no and dy.bsflag = '0' and dy.org_subjection_id like '"+orgSubjectionId+"%' "
				// +
				" join gp_task_project_dynamic dy on dy.project_info_no = gp.project_info_no and dy.bsflag = '0' and dy.org_subjection_id like '"
				+ orgSubjectionId
				+ "%' "
				+ " join bgp_p6_project p6 on p6.project_info_no = gp.project_info_no and p6.bsflag = '0' "
				+ " join bgp_p6_activity a on p6.object_id = a.project_object_id and a.bsflag = '0' "
				+ " where gp.bsflag = '0' and gp.project_status<>'5000100001000000003' "
				+ " group by gp.exploration_method,gp.project_info_no,p6.object_id,gp.project_name "
				+ " order by start_date";

		List<Map> datas = radDao.queryRecords(sql);

		Date date = new Date();
		Calendar c = Calendar.getInstance();
		Calendar c1 = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (datas != null && datas.size() != 0) {
			Map map = datas.get(0);
			String start_date = (String) map.get("start_date");
			// 取开始日期减2个月，显示
			Date sss = sdf.parse(start_date);
			c.setTime(sss);
			c.add(Calendar.MONTH, -2);
			start_date = sdf.format(c.getTime());

			String[] dates = start_date.split("-");
			c.set(Calendar.YEAR, Integer.parseInt(dates[0]));
			c.set(Calendar.MONTH, Integer.parseInt(dates[1]) - 1);
			c.set(Calendar.DAY_OF_MONTH, 1);

			map = datas.get(datas.size() - 1);
			String end_date = (String) map.get("end_date");
			dates = end_date.split("-");
			c1.set(Calendar.YEAR, Integer.parseInt(dates[0]));
			c1.set(Calendar.MONTH, Integer.parseInt(dates[1]) - 1);
			c1.set(Calendar.DAY_OF_MONTH, 1);
		}

		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+

		long endFlagDay = 0;

		String xml = "<chart dateFormat='yyyy-mm-dd' showSlackAsFill='0' ganttPaneDuration='12' ganttPaneDurationUnit='m' >";
		xml += "<categories>";
		for (int i = 0; i < 14; i++) {
			xml += "<category label='" + c.get(Calendar.YEAR) + "-"
					+ (c.get(Calendar.MONTH) + 1) + "' start='"
					+ sdf.format(c.getTime());
			c.add(Calendar.MONTH, 1);
			xml += "' end='" + sdf.format(c.getTime()) + "' />";
		}
		do {
			xml += "<category label='" + c.get(Calendar.YEAR) + "-"
					+ (c.get(Calendar.MONTH) + 1) + "' start='"
					+ sdf.format(c.getTime());
			c.add(Calendar.MONTH, 1);
			xml += "' end='" + sdf.format(c.getTime()) + "' />";
		} while (c1.after(c));
		xml += "</categories>";

		xml += "<processes fontSize='12' isBold='1' align='left' headertext='项目名'>";

		String project_name_xml = "";
		String survey_actual_xml = "";
		String survey_plan_xml = "";
		String drill_actual_xml = "";
		String drill_plan_xml = "";
		String acquire_actual_xml = "";
		String acquire_plan_xml = "";

		// 把需要拼接的字符串放到一个循环里
		for (int i = 0; i < datas.size(); i++) {
			// 项目名拼接
			Map map = datas.get(i);
			project_name_xml += "<process label='" + map.get("project_name")
					+ "' id='" + map.get("project_info_no") + "'/>";

			// 其他信息拼接
			String objectId = (String) map.get("object_id");
			String projectInfoNo = (String) map.get("project_info_no");
			String baseLineProjectId = map.get("baseline_project_id") != null ? map
					.get("baseline_project_id").toString() : "";

			sql = "select min(a.actual_start_date) start_date,max(a.actual_finish_date) as end_date, to_date(to_char(nvl(max(a.actual_finish_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(nvl(min(a.actual_start_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs "
					+ "join bgp_p6_activity a "
					+ "on a.wbs_object_id = wbs.object_id "
					+ "start with wbs.name = '测量' and wbs.project_object_id = '"
					+ map.get("object_id")
					+ "' "
					+ "connect by prior wbs.object_id = wbs.parent_object_id ";
			List list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String) task.get("start_date") == null
						|| "".equals((String) task.get("start_date"))) {

				} else {

					String endFlagSql = "select nvl(count(*),0) as end_day from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no"
							+ " where project_info_no = '"
							+ projectInfoNo
							+ "'"
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
						survey_actual_xml += "<task label='测量已完成，"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' toolText='测量已完成，"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' showLabel='1' start='"
								+ task.get("start_date")
								+ "' end='"
								+ task.get("end_date")
								+ "' processId='"
								+ map.get("project_info_no")
								+ "' color='4567aa' height='10%' topPadding='15%' percentComplete='100'/>";
					} else {
						survey_actual_xml += "<task label='测量实际天数"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' toolText='测量实际天数"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' showLabel='1' start='"
								+ task.get("start_date")
								+ "' end='"
								+ sdf.format(date)
								+ "' processId='"
								+ map.get("project_info_no")
								+ "' color='4567aa' height='10%' topPadding='15%' percentComplete='100'/>";
					}
				}
			}

			sql = "select min(a.planned_start_date) start_date,max(a.planned_finish_date) as end_date,to_date(to_char(max(a.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(min(a.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs "
					+ "join bgp_p6_activity a "
					+ "on a.wbs_object_id = wbs.object_id "
					+ "start with wbs.name = '测量' and wbs.project_object_id = '"
					+ baseLineProjectId
					+ "' "
					+ "connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String) task.get("start_date") == null
						|| "".equals((String) task.get("start_date"))
						|| (String) task.get("end_date") == null
						|| "".equals((String) task.get("end_date"))) {

				} else {
					survey_plan_xml += "<task label='测量计划天数"
							+ task.get("days")
							+ "天' toolText='测量计划天数"
							+ task.get("days")
							+ "天 "
							+ task.get("start_date")
							+ "~"
							+ task.get("end_date")
							+ "' showLabel='0' start='"
							+ task.get("start_date")
							+ "' end='"
							+ task.get("end_date")
							+ "' processId='"
							+ map.get("project_info_no")
							+ "' color='4567aa' height='20%' topPadding='10%' percentComplete = '0'/>";
				}
			}

			sql = "select min(a.actual_start_date) start_date,max(a.actual_finish_date) as end_date, to_date(to_char(nvl(max(a.actual_finish_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(nvl(min(a.actual_start_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs "
					+ "join bgp_p6_activity a "
					+ "on a.wbs_object_id = wbs.object_id "
					+ "start with wbs.name = '钻井' and wbs.project_object_id = '"
					+ map.get("object_id")
					+ "' "
					+ "connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String) task.get("start_date") == null
						|| "".equals((String) task.get("start_date"))
						|| (String) task.get("end_date") == null
						|| "".equals((String) task.get("end_date"))) {

				} else {
					String endFlagSql = "select nvl(count(*),0) as end_day from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no"
							+ " where project_info_no = '"
							+ projectInfoNo
							+ "'"
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
						drill_actual_xml += "<task label='钻井已完成"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' toolText='钻井已完成"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' showLabel='1' start='"
								+ task.get("start_date")
								+ "' end='"
								+ task.get("end_date")
								+ "' processId='"
								+ map.get("project_info_no")
								+ "' color='4567aa' height='10%' topPadding='50%' percentComplete='100'/>";
					} else {
						drill_actual_xml += "<task label='钻井实际天数"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' toolText='钻井实际天数"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' showLabel='1' start='"
								+ task.get("start_date")
								+ "' end='"
								+ sdf.format(date)
								+ "' processId='"
								+ map.get("project_info_no")
								+ "' color='4567aa' height='10%' topPadding='50%' percentComplete='100'/>";
					}
				}
			}

			sql = "select min(a.planned_start_date) start_date,max(a.planned_finish_date) as end_date,to_date(to_char(max(a.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(min(a.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs "
					+ "join bgp_p6_activity a "
					+ "on a.wbs_object_id = wbs.object_id "
					+ "start with wbs.name = '钻井' and wbs.project_object_id = '"
					+ baseLineProjectId
					+ "' "
					+ "connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String) task.get("start_date") == null
						|| "".equals((String) task.get("start_date"))
						|| (String) task.get("end_date") == null
						|| "".equals((String) task.get("end_date"))) {

				} else {
					drill_plan_xml += "<task label='钻井计划天数"
							+ task.get("days")
							+ "天' toolText='钻井计划天数"
							+ task.get("days")
							+ "天 "
							+ task.get("start_date")
							+ "~"
							+ task.get("end_date")
							+ "' showLabel='0' start='"
							+ task.get("start_date")
							+ "' end='"
							+ task.get("end_date")
							+ "' processId='"
							+ map.get("project_info_no")
							+ "' color='4567aa' height='20%' topPadding='45%' percentComplete = '0'/>";
				}
			}

			sql = "select min(a.actual_start_date) start_date,max(a.actual_finish_date) as end_date, to_date(to_char(nvl(max(a.actual_finish_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(nvl(min(a.actual_start_date),sysdate),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs "
					+ "join bgp_p6_activity a "
					+ "on a.wbs_object_id = wbs.object_id "
					+ "start with wbs.name = '采集' and wbs.project_object_id = '"
					+ map.get("object_id")
					+ "' "
					+ "connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String) task.get("start_date") == null
						|| "".equals((String) task.get("start_date"))
						|| (String) task.get("end_date") == null
						|| "".equals((String) task.get("end_date"))) {

				} else {
					String endFlagSql = "select nvl(count(*),0) as end_day from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no"
							+ " where project_info_no = '"
							+ projectInfoNo
							+ "'"
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
						acquire_actual_xml += "<task label='采集已完成"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' toolText='采集已完成"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' showLabel='1' start='"
								+ task.get("start_date")
								+ "' end='"
								+ task.get("end_date")
								+ "' processId='"
								+ map.get("project_info_no")
								+ "' color='4567aa' height='10%' topPadding='80%' percentComplete='100'/>";
					} else {
						acquire_actual_xml += "<task label='采集实际天数"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' toolText='采集实际天数"
								+ task.get("days")
								+ "天 "
								+ task.get("start_date")
								+ "~"
								+ task.get("end_date")
								+ "' showLabel='1' start='"
								+ task.get("start_date")
								+ "' end='"
								+ sdf.format(date)
								+ "' processId='"
								+ map.get("project_info_no")
								+ "' color='4567aa' height='10%' topPadding='80%' percentComplete='100'/>";
					}
				}
			}

			sql = "select min(a.planned_start_date) start_date,max(a.planned_finish_date) as end_date,to_date(to_char(max(a.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(min(a.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd')+1 as days from bgp_p6_project_wbs wbs "
					+ "join bgp_p6_activity a "
					+ "on a.wbs_object_id = wbs.object_id "
					+ "start with wbs.name = '采集' and wbs.project_object_id = '"
					+ baseLineProjectId
					+ "' "
					+ "connect by prior wbs.object_id = wbs.parent_object_id ";
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map task = (Map) list.get(0);
				if ((String) task.get("start_date") == null
						|| "".equals((String) task.get("start_date"))
						|| (String) task.get("end_date") == null
						|| "".equals((String) task.get("end_date"))) {

				} else {
					acquire_plan_xml += "<task label='采集计划天数"
							+ task.get("days")
							+ "天' toolText='采集计划天数"
							+ task.get("days")
							+ "天 "
							+ task.get("start_date")
							+ "~"
							+ task.get("end_date")
							+ "' showLabel='0' start='"
							+ task.get("start_date")
							+ "' end='"
							+ task.get("end_date")
							+ "' processId='"
							+ map.get("project_info_no")
							+ "' color='4567aa' height='20%' topPadding='75%' percentComplete = '0'/>";
				}
			}
		}

		// 循环结束
		xml += project_name_xml;
		xml += "  </processes>";
		xml += "<tasks showPercentLabel='0' >";

		xml += survey_actual_xml;
		xml += survey_plan_xml;
		xml += drill_actual_xml;
		xml += drill_plan_xml;
		xml += acquire_actual_xml;
		xml += acquire_plan_xml;

		xml += "</tasks>";

		xml += "<trendlines>";
		xml += "<line start='" + sdf.format(date) + "' displayValue='"
				+ sdf.format(date)
				+ "' color='333333' thickness='2' dashed='1' />";
		xml += "</trendlines>";

		xml += "</chart>";

		System.out.println(xml);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("Str", xml);
		msg.setValue("projectNum", datas.size());
		return msg;
	}

	/**
	 * 综合物化探项目运行状态
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWtProjectDynamic(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		if (orgSubjectionId == null || "".equals(orgSubjectionId)) {
			orgSubjectionId = user.getSubOrgIDofAffordOrg();
		}
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String d = sdf.format(date);

		String sql = "select count(gp.project_info_no) as num,project_status from gp_task_project gp "
				+ " join gp_task_project_dynamic dy "
				+ " on dy.project_info_no = gp.project_info_no "
				+ " and dy.exploration_method = gp.exploration_method "
				+ " and gp.project_type='5000100004000000009' "
				+ " and dy.bsflag = '0' and dy.org_subjection_id like '"
				+ orgSubjectionId
				+ "%' "
				+ " where gp.bsflag = '0' "
				+ " and gp.project_status is not null "
				+ " and gp.acquire_start_time >= to_date('"
				+ d.substring(0, 4)
				+ "-01-01','yyyy-MM-dd') and gp.acquire_start_time <= sysdate "
				+ " group by  gp.project_status";
		List<Map> list = radDao.queryRecords(sql);
		int workNum = 0;// 施工
		int stopNum = 0;// 停工
		int readyNum = 0;// 准备
		int pauseNum = 0;// 暂停
		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
			Map map = (Map) iterator.next();
			if ("5000100001000000001"
					.equals((String) map.get("project_status"))) {
				// 准备
				readyNum = Integer.parseInt((String) map.get("num"));
			} else if ("5000100001000000002".equals((String) map
					.get("project_status"))) {
				// 施工
				workNum = Integer.parseInt((String) map.get("num"));
			} else if ("5000100001000000003".equals((String) map
					.get("project_status"))) {
				// 项目结束
				stopNum = Integer.parseInt((String) map.get("num"));
			} else if ("5000100001000000004".equals((String) map
					.get("project_status"))) {
				// 暂停
				pauseNum = Integer.parseInt((String) map.get("num"));
			} else if ("5000100001000000005".equals((String) map
					.get("project_status"))) {
				// 施工结束
				stopNum = Integer.parseInt((String) map.get("num"));
			}
		}
		Map map = new HashMap();
		map.put("workNum", workNum);
		map.put("stopNum", stopNum);
		map.put("readyNum", readyNum);
		map.put("pauseNum", pauseNum);
		map.put("startDate", d.substring(0, 4) + "-01-01");
		map.put("endDate", d);

		sql = " SELECT ds2.nums,gp.PROJECT_INFO_NO,gp.project_name,ccsd.CODING_NAME AS MANAGE_ORG_name,org.ORG_ABBREVIATION AS team_name,dy.org_id,ds3.CODING_NAME AS EXPLORATION_METHOD,wd.LINE_LENGTH,wd.PHYSICS_POINT,ds.WORKLOAD,ds.PHYSICAL_POINT, "
			+ " ds.WORKLOAD/wd.LINE_LENGTH*100 jd1,ds.PHYSICAL_POINT/wd.PHYSICS_POINT*100 jd2,gp.project_status FROM "
			+ " gp_task_project gp JOIN gp_task_project_dynamic dy ON gp.project_info_no = dy.project_info_no AND gp.bsflag='0' AND dy.bsflag='0' "
			+ " AND gp.project_type='5000100004000000009' JOIN gp_wt_workload wd ON  gp.project_info_no = wd.project_info_no AND wd.bsflag='0'"
			+ " AND wd.EXPLORATION_METHOD<>'5110000056000000045' JOIN COMM_ORG_INFORMATION org ON dy.org_id = org.org_id AND org.bsflag='0' JOIN"
			+ " COMM_CODING_SORT_DETAIL ccsd ON gp.MANAGE_ORG = ccsd.CODING_CODE_ID AND ccsd.bsflag='0' JOIN (SELECT project_info_no,EXPLORATION_METHOD,SUM(DAILY_WORKLOAD)  WORKLOAD,"
			+ " SUM(DAILY_PHYSICAL_POINT) PHYSICAL_POINT FROM gp_ops_daily_report_zb WHERE EXPLORATION_METHOD <>'5110000056000000045' AND bsflag='0'"
			+ " GROUP BY project_info_no, EXPLORATION_METHOD ) ds ON  gp.project_info_no = ds.project_info_no AND wd.EXPLORATION_METHOD= ds.EXPLORATION_METHOD "
			+ " JOIN(SELECT PROJECT_INFO_NO,COUNT(*) nums FROM gp_wt_workload WHERE bsflag='0'AND EXPLORATION_METHOD <>'5110000056000000045' GROUP BY PROJECT_INFO_NO)ds2"
			+ " ON gp.project_info_no = ds2.PROJECT_INFO_NO JOIN( SELECT CODING_NAME,CODING_CODE_ID FROM  comm_coding_sort_detail t WHERE  t.coding_sort_id = '5110000056'"
			+ " AND t.bsflag = '0' ) ds3 ON ds3.CODING_CODE_ID = wd.EXPLORATION_METHOD ";
		List<Map> datas = radDao.queryRecords(sql);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("map", map);
		msg.setValue("list", datas);
		return msg;
	}

	/**
	 * 添加深海进度分析数据图 by bianshen
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getShDeviation(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}

		WorkMethodSrv wm = new WorkMethodSrv();
		String buildMethod = wm.getProjectExcitationMode(projectInfoNo);

		String xml = "<chart showValues='0' numberSuffix='%' yAxisName='负数表示滞后，正数表示超前' rotateYAxisName='0' yAxisNameWidth='16'>";

		// 标题 x坐标标题 y坐标标题 是否显示数据
		String[] types = { "measuredailylist", "drilldailylist",
				"colldailylist" };
		String[] typeNames = { "测量", "钻井", "采集" };
		String[] colors = { "1381c0", "69bf5d", "fd962e" };

		String endFlagColumn = "survey_process_status";

		String designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month "
				+ " from gp_proj_product_plan where project_info_no = '"
				+ projectInfoNo
				+ "' and bsflag = '0' "
				+ " and oper_plan_type in('colldailylist','measuredailylist','drilldailylist') order by record_month";
		if ("5000100003000000002".equals(buildMethod)) {
			designDateSql = "select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month "
					+ " from gp_proj_product_plan where project_info_no = '"
					+ projectInfoNo
					+ "' and bsflag = '0' "
					+ " and oper_plan_type in('colldailylist','measuredailylist') order by record_month";
		}

		List<Map> designDateList = radDao.queryRecords(designDateSql);
		if (designDateList == null || designDateList.size() == 0) {
			return msg;
		}
		// x坐标绘制
		String axis_end_date = "";
		List<String> axisDateList = new ArrayList<String>();
		xml += "<categories>";
		for (int i = 0; i < designDateList.size(); i++) {
			Map map = designDateList.get(i);
			String axis_date = "" + map.get("record_month");
			axisDateList.add(axis_date);
			if (i == 0) {

			} else if (i == designDateList.size() - 1) {
				axis_end_date = axis_date;
			}
			xml += "<category label='" + axis_date.substring(5) + "' />";
		}
		// 实际生产日期大于设计日期,追加大于设计的日期
		// 2012-11-21 卢占国提出实际大于设计不添加日期
		String dailyDateSql = " select to_char(produce_date,'yyyy-MM-dd') as produce_date from gp_ops_daily_report where project_info_no = '"
				+ projectInfoNo + "' and bsflag = '0' order by produce_date";
		List<Map> dailyDateList = radDao.queryRecords(dailyDateSql);
		for (int i = 0; i < dailyDateList.size(); i++) {
			Map map = dailyDateList.get(i);
			String axis_date = "" + map.get("produce_date");
			if (DateOperation.diffDaysOfDate(axis_date, axis_end_date) > 0) {
				axis_end_date = axis_date;
				axisDateList.add(axis_date);
			}
		}
		xml += "</categories>";

		List<Map> gridData = new ArrayList<Map>();
		String existDrillData = "yes";
		for (int m = 0; m < types.length; m++) {
			String type = types[m];
			String typeName = typeNames[m];
			Map lineMap = new HashMap();
			if ("drilldailylist".equals(type)) {
				if ("5000100003000000002".equals(buildMethod)) {
					lineMap.put("status", "");
					lineMap.put("groupLine", "");
					lineMap.put("designWorkLoad", "");
					lineMap.put("dailyWorkLoad", "");
					lineMap.put("finishPercentage", "");
					lineMap.put("deviation", "");
					lineMap.put("date", "");
					gridData.add(lineMap);
					existDrillData = "no";
					continue;
				}
			}
			String dailyColumn = "";
			String dailyParam = "";
			if (type == "measuredailylist" || "measuredailylist".equals(type)) {
				dailyColumn = " nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) ";
				endFlagColumn = "survey_process_status";
				dailyParam = " and nvl(workload_num,0) > 0";
			} else if (type == "colldailylist" || "colldailylist".equals(type)) {
				// 把统计字段 daily_qq_acquire_shot_num 修改为 daily_qq_acquire_workload
				dailyColumn = " nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_workload,0) ";
				endFlagColumn = "collect_process_status";
				dailyParam = " and nvl(workload,0) > 0";
			} else if (type == "drilldailylist"
					|| "drilldailylist".equals(type)) {
				dailyColumn = " nvl(daily_drill_sp_num,0) ";
				endFlagColumn = "drill_process_status";
				dailyParam = " and nvl(workload,0) > 0";
			}

			String sql = "select nvl(workload,0) as paodian,nvl(workload_num,0) as gongli,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,to_date(record_month,'yyyy-MM-dd') as data"
					+ " from gp_proj_product_plan where project_info_no = '"
					+ projectInfoNo
					+ "' and bsflag = '0' "
					+ dailyParam
					+ " and oper_plan_type = '"
					+ type
					+ "' order by record_month ";

			List<Map> designList = radDao.queryRecords(sql);
			if (designList.size() == 0 || designList == null) {
				continue;
			}
			String minDate = (String) ((Map) designList.get(0))
					.get("record_month");
			String maxDate = (String) ((Map) designList
					.get(designList.size() - 1)).get("record_month");
			String produceStartDate = "";
			String produceEndDate = "";
			String produceCurDate = "";

			// 取当前工序的结束状态
			String endFlagSql = "select "
					+ endFlagColumn
					+ " as end_flag from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no "
					+ " where d.produce_date = (select max(produce_date) from gp_ops_daily_report where project_info_no = '"
					+ projectInfoNo
					+ "' and audit_status = '3' and bsflag = '0' and "
					+ dailyColumn + " > 0) " + " and project_info_no = '"
					+ projectInfoNo + "' and d.bsflag = '0'";
			String statusDesc = "";
			Map recordMap = radDao.queryRecordBySQL(endFlagSql);
			if (recordMap != null) {
				String value = "" + recordMap.get("end_flag");
				if ("1".equals(value)) {
					statusDesc = "未开始";
				} else if ("2".equals(value)) {
					statusDesc = "正在施工";
				} else if ("3".equals(value)) {
					statusDesc = "结束";
				}
			}

			// 取施工线束
			sql = "select a.* from bgp_p6_activity a"
					+ " join bgp_p6_project_wbs w on w.object_id = a.wbs_object_id and w.bsflag = '0' "
					+ " join bgp_p6_project p on p.object_id = w.project_object_id and w.name = '"
					+ typeName + "'" + " and p.project_info_no = '"
					+ projectInfoNo + "'" + " where a.status = 'In Progress'";// Completed
																				// In
																				// Progress
			List<Map> groupLineList = radDao.queryRecords(sql);
			String groupLineName = "";
			if (groupLineList != null) {
				for (int i = 0; i < groupLineList.size(); i++) {
					Map groupLineMap = groupLineList.get(i);
					String value = "" + groupLineMap.get("name");
					if (!"".equals(value)) {
						groupLineName = groupLineName + "&nbsp;&nbsp;" + value;
					}
				}
			}
			lineMap.put("status", statusDesc);
			lineMap.put("groupLine", groupLineName);

			sql = "select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_workload,0)) as coll_value"
					+ ",sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value"
					+ ",sum(nvl(d.daily_drill_sp_num,0)) as drill_value"
					+ ",sum(nvl(d.daily_micro_measue_point_num,0)+nvl(d.daily_small_refraction_num,0)) as surface_value"
					+ ",to_char(produce_date,'yyyy-MM-dd') as produce_date"
					+ " from gp_ops_daily_report d where project_info_no = '"
					+ projectInfoNo
					+ "' and bsflag = '0' and audit_status = '3'"
					+ " and "
					+ dailyColumn
					+ " > 0 "
					+ " group by produce_date order by produce_date ";

			xml += "<dataset color='" + colors[m] + "' anchorBorderColor='"
					+ colors[m] + "' anchorBgColor='" + colors[m]
					+ "' seriesName='" + typeName + "偏离度'>";

			List<Map> dailyList = radDao.queryRecords(sql);
			if (dailyList != null && dailyList.size() > 0) {
				produceStartDate = (String) ((Map) dailyList.get(0))
						.get("produce_date");
				produceCurDate = (String) ((Map) dailyList
						.get(dailyList.size() - 1)).get("produce_date");
				if ("结束".equals(statusDesc) || "结束" == statusDesc) {
					produceEndDate = (String) ((Map) dailyList.get(dailyList
							.size() - 1)).get("produce_date");
				}
			}

			DecimalFormat df = new DecimalFormat();
			String style = "0.00";

			df.applyPattern(style);

			double radio = 0.0;

			// 阀值
			double sum_daily_num = 0;
			double sum_design_num = 0;

			String designDateColumn = "record_month";
			String dailyDateColumn = "produce_date";
			String designValueColumn = "";
			String dailyValueColumn = "";

			String[] measure2Type = { "G02003", "G02004" };
			String[] measure3Type = { "G2003", "G2004" };

			String[] drill2Type = { "G05001" };
			String[] drill3Type = { "G5001" };

			String[] coll2Type = { "G07001", "G07003", "G07005" };
			String[] coll3Type = { "GS7001", "GS7002" };

			sql = "select exploration_method from gp_task_project  where project_info_no = '"
					+ projectInfoNo + "' and bsflag = '0'";
			List<Map> list = radDao.queryRecords(sql);

			String exploration_method = null;
			if (list != null && list.size() != 0) {
				Map map = (Map) list.get(0);
				exploration_method = (String) map.get("exploration_method");
			} else {
				return null;
			}

			String sqlTemp = "";

			if (type == "colldailylist" || "colldailylist".equals(type)) {
				// 采集
				designValueColumn = "paodian";
				dailyValueColumn = "coll_value";
				if (exploration_method == "0300100012000000002"
						|| "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < coll2Type.length; i++) {
						sqlTemp = sqlTemp + coll2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < coll3Type.length; i++) {
						sqlTemp = sqlTemp + coll3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				}

			} else if (type == "measuredailylist"
					|| "measuredailylist".equals(type)) {
				// 测量
				designValueColumn = "gongli";
				dailyValueColumn = "measure_value";
				if (exploration_method == "0300100012000000002"
						|| "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < measure2Type.length; i++) {
						sqlTemp = sqlTemp + measure2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < measure3Type.length; i++) {
						sqlTemp = sqlTemp + measure3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				}
			} else if (type == "drilldailylist"
					|| "drilldailylist".equals(type)) {
				// 钻井
				designValueColumn = "paodian";
				dailyValueColumn = "drill_value";
				if (exploration_method == "0300100012000000002"
						|| "0300100012000000002".equals(exploration_method)) {
					sqlTemp = "('";
					for (int i = 0; i < drill2Type.length; i++) {
						sqlTemp = sqlTemp + drill2Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				} else {
					sqlTemp = "('";
					for (int i = 0; i < drill3Type.length; i++) {
						sqlTemp = sqlTemp + drill3Type[i] + "','";
					}
					sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
					sqlTemp += ")";
				}
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

			for (int i = 0; i < axisDateList.size(); i++) {
				String axisDate = "" + axisDateList.get(i);

				if (DateOperation.diffDaysOfDate(produceCurDate, axisDate) >= 0) {
					String designValue = "" + designData.get(axisDate);
					String dailyValue = "" + dailyData.get(axisDate);

					if ("null".equals(designValue) || "".equals(designValue)) {
						designValue = "0";
					}
					if ("null".equals(dailyValue) || "".equals(dailyValue)) {
						dailyValue = "0";
					}
					double designNum1 = Double.parseDouble(designValue);
					double actualNum1 = Double.parseDouble(dailyValue);
					sum_daily_num += actualNum1;
					// 设计值改为从bgp_p6_workload中查询
					sum_design_num += designNum1;
					if (DateOperation.diffDaysOfDate(axisDate, minDate) >= 0
							&& DateOperation.diffDaysOfDate(maxDate, axisDate) >= 0) {
						if (sum_design_num == 0) {
							radio = 0;
						} else {
							radio = (double) (sum_daily_num - sum_design_num)
									/ sum_design_num * 100;
						}

						xml += "<set value='" + df.format(radio) + "' />";

					} else {
						xml += "<set/>";
					}
					if (DateOperation.diffDaysOfDate(axisDate, minDate) >= 0
							&& DateOperation.diffDaysOfDate(produceEndDate,
									axisDate) >= 0) {
						if (sum_design_num == 0) {
							radio = 0;
						} else {
							radio = (double) (sum_daily_num - sum_design_num)
									/ sum_design_num * 100;
						}
					}
				}
			}

			sql = "select sum(nvl(planned_units,0)) as num from bgp_p6_workload where project_info_no = '"
					+ projectInfoNo
					+ "' and produce_date is null and bsflag = '0' and resource_id in ";
			sql += sqlTemp;
			list = radDao.queryRecords(sql);
			if (list != null && list.size() != 0) {
				Map map = list.get(0);
				lineMap.put("designWorkLoad", "" + (String) map.get("num"));
				lineMap.put(
						"finishPercentage",
						""
								+ df.format(sum_daily_num
										/ Double.parseDouble((String) map
												.get("num")) * 100));
			}

			// 现在设计工作量的赋值
			lineMap.put("dailyWorkLoad", "" + df.format(sum_daily_num));

			if (DateOperation.diffDaysOfDate(produceEndDate, maxDate) > 0) {
				lineMap.put(
						"deviation",
						"超出计划日期"
								+ DateOperation.diffDaysOfDate(produceEndDate,
										maxDate) + "天");

			} else if (DateOperation.diffDaysOfDate(minDate, produceEndDate) > 0) {
				lineMap.put(
						"deviation",
						"实际比计划早开始"
								+ DateOperation.diffDaysOfDate(minDate,
										produceStartDate) + "天");

			} else if (DateOperation.diffDaysOfDate(maxDate, produceEndDate) > 0) {
				lineMap.put(
						"deviation",
						"实际比计划提前完成"
								+ DateOperation.diffDaysOfDate(maxDate,
										produceEndDate) + "天");

			} else {
				lineMap.put("deviation", "" + df.format(radio));

			}
			lineMap.put("date", produceEndDate);
			lineMap.put("designDate", maxDate);
			lineMap.put("startDate", produceStartDate);
			lineMap.put("minDesignDate", minDate);
			gridData.add(lineMap);

			xml += "</dataset>";
		}
		// 阀值线
		xml += "<trendlines>";

		xml += "<line startValue='0' color='000000' showOnTop='0' thickness='2'/>";

		xml += "</trendlines>";

		// 样式区
		xml += "<styles>";
		xml += "<definition><style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' /></definition>";
		xml += "<application><apply toObject='Canvas' styles='CanvasAnim' /></application>";
		xml += "</styles>";
		xml += "</chart>";

		log.info("xml:" + xml);
		msg.setValue("Str", xml);
		msg.setValue("existDrillData", existDrillData);
		msg.setValue("gridData", gridData);
		return msg;
	}

	/**
	 * 进度分析图
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	/**
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviationWt(ISrvMsg reqDTO) throws Exception {
		  inList();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		String projectInfoNo = reqDTO.getValue("project_info_no");
		String methodList = reqDTO.getValue("exp_methods");

		if (methodList.length() == 0) {
			return null;
		}

		String[] methods = methodList.substring(1, methodList.length() - 1)
				.split(",");

		List<String> typeList = Arrays.asList(methods);

		Map<String, Object> xmlDataMap = new HashMap<String, Object>();

		String xml = "<chart showValues='0' numberSuffix='%' yAxisName='负数表示滞后，正数表示超前' rotateYAxisName='0' yAxisNameWidth='16'>";

		// 标题 x坐标标题 y坐标标题 是否显示数据
		// String[] colors = {"1381c0","69bf5d","fd962e"};

		// 初始化颜色
		initColorMap();

		String designDateSql = "select distinct t.mdate as record_month"
				+ " from gp_proj_product_plan_wt t join bgp_activity_method_mapping m on"
				+ " t.mid = m.activity_object_id and t.project_info_no = m.project_info_no and m.bsflag = '0'"
				+ " where t.project_info_no = '" + projectInfoNo + "'"
				+ "   order by t.mdate";

		List<Map> designDateList = radDao.queryRecords(designDateSql);
		if (designDateList != null || designDateList.size() > 0) {

			// x坐标绘制
			@SuppressWarnings("unused")
			String axis_start_date = "";
			String axis_end_date = "";
			List<String> axisDateList = new ArrayList<String>();
			xml += "<categories>";
			for (int i = 0; i < designDateList.size(); i++) {
				Map map = designDateList.get(i);
				String axis_date = "" + map.get("record_month");
				axisDateList.add(axis_date);
				if (i == 0) {
					axis_start_date = axis_date;
				} else if (i == designDateList.size() - 1) {
					axis_end_date = axis_date;
				}
				xml += "<category label='" + axis_date.substring(5) + "' />";
			}
			// 实际生产日期大于设计日期,追加大于设计的日期
			// 2012-11-21 卢占国提出实际大于设计不添加日期
			int addDay = 0;
			String dailyDateSql = "select distinct to_char(zb.produce_date, 'yyyy-MM-dd') as produce_date "
					+ "from gp_ops_daily_report_zb zb "
					+ "where zb.bsflag = '0' "
					+ "and zb.project_info_no = '"
					+ projectInfoNo + "' order by produce_date desc";

			List<Map> dailyDateList = radDao.queryRecords(dailyDateSql);
			for (int i = 0; i < dailyDateList.size(); i++) {
				Map map = dailyDateList.get(i);
				String axis_date = "" + map.get("produce_date");
				if (DateOperation.diffDaysOfDate(axis_date, axis_end_date) > 0) {
					axis_end_date = axis_date;
					axisDateList.add(axis_date);
					addDay++;
				}
			}
			xml += "</categories>";

			List<Map> gridData = new ArrayList<Map>();

			for (int m = 0; m < typeList.size(); m++) {
				String typeId = typeList.get(m).trim();
				String typeName = this.getExpMethodName(typeId);
				Map lineMap = new HashMap();
				lineMap.put("typeId", typeId);
				lineMap.put("typeName", typeName);
				String dailyColumn = "";
				String dailyParam = "";
				List<Map> designList=new ArrayList<Map>();
				String sql = "select nvl(w.value,0) as design_value,w.mdate as record_month from "
						+ " gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id"
						+ " and w.project_info_no = m.project_info_no and m.bsflag = '0'"
						+ " and w.project_info_no = '"
						+ projectInfoNo
						+ "'"
						+ " and w.wid = '02' and m.exploration_method = '"
						+ typeId + "' order by w.mdate";

				        designList = radDao.queryRecords(sql);
				if(designList.size()==0){
				  sql = "select nvl(w.value,0) as design_value,w.mdate as record_month from "
						+ " gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id"
						+ " and w.project_info_no = m.project_info_no and m.bsflag = '0'"
						+ " and w.project_info_no = '"
						+ projectInfoNo
						+ "'"
						+ " and w.wid = '03' and m.exploration_method = '"
						+ typeId + "' order by w.mdate";
				  designList= radDao.queryRecords(sql);
				} 
				if(designList.size()==0){
					  sql = "select nvl(w.value,0) as design_value,w.mdate as record_month from "
							+ " gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id"
							+ " and w.project_info_no = m.project_info_no and m.bsflag = '0'"
							+ " and w.project_info_no = '"
							+ projectInfoNo
							+ "'"
							+ " and w.wid = '05' and m.exploration_method = '"
							+ typeId + "' order by w.mdate";
					  designList= radDao.queryRecords(sql);
					  if(designList.size()==0){
						  sql = "select nvl(w.value,0) as design_value,w.mdate as record_month from "
								+ " gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id"
								+ " and w.project_info_no = m.project_info_no and m.bsflag = '0'"
								+ " and w.project_info_no = '"
								+ projectInfoNo
								+ "'"
								+ " and w.wid = '01' and m.exploration_method = '"
								+ typeId + "' order by w.mdate";
						  designList= radDao.queryRecords(sql);
					  }
				}
				if (designList != null && designList.size() > 0) {

					String minDate = (String) ((Map) designList.get(0))
							.get("record_month");
					String maxDate = (String) ((Map) designList.get(designList
							.size() - 1)).get("record_month");
					String produceStartDate = "";
					String produceEndDate = "";
					String produceCurDate = "";
					String statusDesc = "";

					// 判断工序的状态
					boolean endFlag = false;
					boolean inProgressFlag = false;
					String endSql = "select nvl(count(*),0) as end_day"
							+ " from gp_ops_daily_report_zb zb"
							+ " where bsflag = '0'"
							+ " and project_info_no = '" + projectInfoNo + "'"
							+ " and zb.exploration_method = '" + typeId + "'"
							+ " and zb.task_status = '4'";
					Map<Object, String> endMap = radDao
							.queryRecordBySQL(endSql);
					int endCount = Integer.parseInt(endMap.get("end_day"));
					if (endCount > 0) {
						endFlag = true;
						statusDesc = "结束";
						// 获取结束日期
						String getEndDateSql = "select min(zb.produce_date) as end_date"
								+ " from gp_ops_daily_report_zb zb"
								+ " where bsflag = '0'"
								+ " and project_info_no = '"
								+ projectInfoNo
								+ "'"
								+ " and zb.exploration_method = '"
								+ typeId + "'" + " and zb.task_status = '4'";
						Map<Object, String> suervyEndDateMap = radDao
								.queryRecordBySQL(getEndDateSql);
						produceEndDate = suervyEndDateMap.get("end_date");
					}
					// 未结束,判断是否正在施工
					if (!endFlag) {
						String inProgressSql = "select nvl(count(*),0) as in_progress"
								+ " from gp_ops_daily_report_zb zb"
								+ " where bsflag = '0'"
								+ " and project_info_no = '"
								+ projectInfoNo
								+ "'"
								+ " and zb.exploration_method = '"
								+ typeId
								+ "'"
								+ " and zb.task_status in ('1','3')";
						Map<Object, String> inProgressMap = radDao
								.queryRecordBySQL(inProgressSql);
						int inProgressCount = Integer.parseInt(inProgressMap
								.get("in_progress"));
						if (inProgressCount > 0) {
							inProgressFlag = true;
							statusDesc = "正在施工";
						}
						// 没有正在施工,就是未开始
						if (!inProgressFlag) {
							statusDesc = "未开始";
						}
					}

					// 取施工线束
					sql = "select a.name as activity_name,a.project_name,m.project_info_no "
							+ "from bgp_p6_activity a "
							+ "join bgp_activity_method_mapping m on a.object_id = m.activity_object_id "
							+ "and m.bsflag = '0' and m.project_info_no = '"
							+ projectInfoNo
							+ "' "
							+ "where a.bsflag = '0' and m.exploration_method = '"
							+ typeId + "'";
					List<Map> groupLineList = radDao.queryRecords(sql);
					String groupLineName = "";
					if (groupLineList != null && groupLineList.size() > 0) {
						// for(int i=0; i<groupLineList.size(); i++){
						// Map groupLineMap = groupLineList.get(i);
						// String value = "" +
						// groupLineMap.get("activity_name");
						// if(!"".equals(value)){
						// groupLineName = groupLineName + "&nbsp;&nbsp;"+
						// value;
						// }
						// }
						Map groupLineMap = groupLineList.get(0);
						String value = "" + groupLineMap.get("activity_name");
						groupLineName = groupLineName + "&nbsp;" + value;
					}
					lineMap.put("status", statusDesc);
					lineMap.put("groupLine", groupLineName);
					StringBuffer  sb=new StringBuffer();
					sb.append("select ");
		
				 
					sb.append("nvl(zb.daily_workload, 0) as daily_value,");
					sb.append(" nvl(daily_physical_point,0)daily_num,");
					sb.append("zb.produce_date,zb.exploration_method");
					sb.append(" from gp_ops_daily_report_zb zb where zb.bsflag = '0' " +
							" and zb.task_status = '1' and zb.project_info_no = '"+ projectInfoNo + "'"+
					" and zb.exploration_method='"+typeId+"' order by zb.produce_date ");
				  List listW=radDao.queryRecords(sb.toString());
			 
					xml += "<dataset color='" + colorMap.get(typeId)
							+ "' anchorBorderColor='" + colorMap.get(typeId)
							+ "' anchorBgColor='" + colorMap.get(typeId)
							+ "' seriesName='" + typeName + "偏离度'>";

				//	List<Map> dailyList = radDao.queryRecords(sql);
					if (listW != null && listW.size() > 0) {
						produceStartDate = (String) ((Map) listW.get(0))
								.get("produce_date");
						produceCurDate = (String) ((Map) listW
								.get(listW.size() - 1)).get("produce_date");
					}

					DecimalFormat df = new DecimalFormat();
					String style = "0.00";

					df.applyPattern(style);

					int actualNum = 0;
					int designNum = 0;
					double radio = 0.0;

					// 阀值
					double value = 100;
					double sum_daily_num = 0;
					double sum_design_num = 0;

					Map designData = new HashMap();
					Map dailyData = new HashMap();
					Map mapT=getE(projectInfoNo);
					
					
					//重力 设计工作量 G660201 公里数 G660205 物理点
					  if(mapT.get("G660201"+typeId)!=null&&!mapT.get("G660201"+typeId).equals("")){
							lineMap.put("designWorkLoad", "" + (String) mapT.get("G660201"+typeId));
					  }else if(mapT.get("G660205"+typeId)!=null&&!mapT.get("G660205"+typeId).equals("")){
						  lineMap.put("designWorkLoad", "" + (String) mapT.get("G660205"+typeId));
					  }else  if(mapT.get("G660301"+typeId)!=null&&!mapT.get("G660301"+typeId).equals("")){
							lineMap.put("designWorkLoad", "" + (String) mapT.get("G660301"+typeId));
					  }else  if(mapT.get("G660305"+typeId)!=null&&!mapT.get("G660305"+typeId).equals("")){
						  lineMap.put("designWorkLoad", "" + (String) mapT.get("G660305"+typeId));
					  }else  if(mapT.get("G660401"+typeId)!=null&&!mapT.get("G660401"+typeId).equals("")){
							lineMap.put("designWorkLoad", "" + (String) mapT.get("G660401"+typeId));
					  }else   if(mapT.get("G660404"+typeId)!=null&&!mapT.get("G660404"+typeId).equals("")){
						  lineMap.put("designWorkLoad", "" + (String) mapT.get("G660404"+typeId));
					  }else  if(mapT.get("G660501"+typeId)!=null&&!mapT.get("G660501"+typeId).equals("")){
							lineMap.put("designWorkLoad", "" + (String) mapT.get("G660501"+typeId));
					  }else if(mapT.get("G660505"+typeId)!=null&&!mapT.get("G660505"+typeId).equals("")){
						  lineMap.put("designWorkLoad", "" + (String) mapT.get("G660505"+typeId));
					  }else   if(mapT.get("G660601"+typeId)!=null&&!mapT.get("G660601"+typeId).equals("")){
							lineMap.put("designWorkLoad", "" + (String) mapT.get("G660601"+typeId));
					  }else  if(mapT.get("G660604"+typeId)!=null&&!mapT.get("G660604"+typeId).equals("")){
						  lineMap.put("designWorkLoad", "" + (String) mapT.get("G660604"+typeId));
					  }else   if(mapT.get("G660701"+typeId)!=null&&!mapT.get("G660701"+typeId).equals("")){
							lineMap.put("designWorkLoad", "" + (String) mapT.get("G660701"+typeId));
					  }else   if(mapT.get("G660707"+typeId)!=null&&!mapT.get("G660707"+typeId).equals("")){
						  lineMap.put("designWorkLoad", "" + (String) mapT.get("G660707"+typeId));
					  }else {
							lineMap.put("designWorkLoad", 0);
					  }
					  if( mapT.get("sum_daily_num"+typeId)!=null){
						  lineMap.put("dailyWorkLoad","" +(String) mapT.get("sum_daily_num"+typeId));
					  }else if(mapT.get("sum_daily_value"+typeId)!=null){
						  lineMap.put("dailyWorkLoad","" +(String) mapT.get("sum_daily_value"+typeId));
					  }else{
							lineMap.put("dailyWorkLoad", 0);
					  }

					 if(lineMap.get("dailyWorkLoad")!=null&&!lineMap.get("designWorkLoad").equals("0")&&lineMap.get("designWorkLoad")!=null){
						 lineMap.put( "finishPercentage", "" + df.format( Double.parseDouble(lineMap.get("dailyWorkLoad").toString()) /  Double.parseDouble(lineMap.get("designWorkLoad").toString())* 100));
						 
					 }
					 

					for (int i = 0; i < designList.size(); i++) {
						//System.out.print(typeId);
						Map designMap = designList.get(i);
						String designDate = "" + designMap.get("record_month");
						String designValue = "" + designMap.get("design_value");
						designData.put(designDate, designValue);
					}
					for (int i = 0; i < listW.size(); i++) {
						String dailyValue="";
						Map dailyMap = (Map) listW.get(i);
						 if(!dailyMap.get("daily_num").equals("")){
							 dailyValue = "" + dailyMap.get("daily_num");
						  }else{
								  dailyValue = "" + dailyMap.get("daily_value");
							  
						  }
//						  if(!dailyMap.get("daily_value").equals("")){
//								 dailyValue = "" + dailyMap.get("daily_value");
//						  }else{
//								  dailyValue = "" + dailyMap.get("daily_num");
//						  }
						String produce_date = "" + dailyMap.get("produce_date");
				
						dailyData.put(produce_date, dailyValue);
					}

					for (int i = 0; i < axisDateList.size(); i++) {
						String axisDate = "" + axisDateList.get(i);

						if (DateOperation.diffDaysOfDate(produceCurDate, axisDate) >= 0) {
							String designValue = "" + designData.get(axisDate);
							String dailyValue = "" + dailyData.get(axisDate);

							if ("null".equals(designValue)
									|| "".equals(designValue)) {
								designValue = "0";
							}
							if ("null".equals(dailyValue)
									|| "".equals(dailyValue)) {
								dailyValue = "0";
							}
							double designNum1 = Double.parseDouble(designValue);
							double actualNum1 = Double.parseDouble(dailyValue);
							sum_daily_num += actualNum1;
							// 设计值改为从bgp_p6_workload中查询
							sum_design_num += designNum1;
							if (DateOperation.diffDaysOfDate(axisDate, minDate) >= 0
									&& DateOperation.diffDaysOfDate(maxDate,
											axisDate) >= 0) {
								if (sum_design_num == 0) {
									radio = 0;
								} else {
									radio = (double) (sum_daily_num - sum_design_num)
											/ sum_design_num * 100;
								}

								xml += "<set value='" + df.format(radio)
										+ "' />";

							} else {
								xml += "<set/>";
							}
							if (DateOperation.diffDaysOfDate(axisDate, minDate) >= 0
									&& DateOperation.diffDaysOfDate(
											produceEndDate, axisDate) >= 0) {
								if (sum_design_num == 0) {
									radio = 0;
								} else {
									radio = (double) (sum_daily_num - sum_design_num)
											/ sum_design_num * 100;
								}
							}
						}
					}
			 
				
					 
					 
						 
				 

					// 现在设计工作量的赋值
				//	lineMap.put("dailyWorkLoad", "" + df.format(sum_daily_num));
					// 改成从bgp_p6_workload中查询设计工作量

					if (DateOperation.diffDaysOfDate(produceEndDate, maxDate) > 0) {
						lineMap.put(
								"deviation",
								"超出计划日期"
										+ DateOperation.diffDaysOfDate(
												produceEndDate, maxDate) + "天");

					} else if (DateOperation.diffDaysOfDate(minDate,
							produceEndDate) > 0) {
						lineMap.put(
								"deviation",
								"实际比计划早开始"
										+ DateOperation.diffDaysOfDate(minDate,
												produceStartDate) + "天");

					} else if (DateOperation.diffDaysOfDate(maxDate,
							produceEndDate) > 0) {
						lineMap.put(
								"deviation",
								"实际比计划提前完成"
										+ DateOperation.diffDaysOfDate(maxDate,
												produceEndDate) + "天");

					} else {
						lineMap.put("deviation", "" + df.format(radio));

					}
					lineMap.put("date", produceEndDate);
					lineMap.put("designDate", maxDate);
					lineMap.put("startDate", produceStartDate);
					lineMap.put("minDesignDate", minDate);
					xml += "</dataset>";
				}
				gridData.add(lineMap);
			}
			// 阀值线
			xml += "<trendlines>";

			xml += "<line startValue='0' color='000000' showOnTop='0' thickness='2'/>";

			xml += "</trendlines>";

			// 样式区
			xml += "<styles>";
			xml += "<definition><style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' /></definition>";
			xml += "<application><apply toObject='Canvas' styles='CanvasAnim' /></application>";
			xml += "</styles>";
			xml += "</chart>";

			msg.setValue("Str", xml);
			msg.setValue("gridData", gridData);

		}
		return msg;
	}
	public Map getE(String projectInfoNo) {
		
		String sql = "select * from (select distinct d.planned_units, d.resource_id,d.activity_object_id from bgp_p6_workload d "+
          " where d.project_info_no = '"+projectInfoNo+"'  and d.resource_id in ('G660201', 'G660301', 'G660401', 'G660501',"+
         " 'G660601', 'G660701', 'G660205','G660505','G660305','G660404','G660604','G660707') and d.bsflag='0')s"+
        " join(select g.exploration_method,g.activity_object_id from bgp_activity_method_mapping g "+
       " where g.project_info_no='"+projectInfoNo+"' and g.bsflag='0')w on s.activity_object_id=w.activity_object_id";
 
		String sqlZb = "select zb.exploration_method, nvl(sum(zb.daily_workload), 0) as daily_value,nvl(sum(zb.DAILY_PHYSICAL_POINT),0) as daily_porint  from gp_ops_daily_report_zb zb where zb.bsflag = '0'"
				+ "   and zb.task_status = '1'  and zb.project_info_no = '"
				+ projectInfoNo
				+ "'  and zb.bsflag='0' and zb.exploration_method!='5110000056000000045'"
				+ " group by zb.exploration_method  order by  zb.exploration_method ";
	
	  List listM=radDao.queryRecords(sql);
	  List listN=radDao.queryRecords(sqlZb);


	  Map mapE=new HashMap();
	  for(int i=0;i<listM.size();i++){
		  Map map=(Map) listM.get(i);
		//  mapE.put("exploration_method", map.get("exploration_method"));
		  mapE.put(map.get("resource_id").toString()+ map.get("exploration_method").toString(), map.get("planned_units"));
	  }
	  for(int i=0;i<listN.size();i++){
		  Map map=(Map) listN.get(i);
 
		  if( !map.get("daily_value").equals("")&&!map.get("daily_value").equals("0")){
				 mapE.put("sum_daily_value"+map.get("exploration_method"), map.get("daily_value")) ;
			  }else{
				  mapE.put("sum_daily_num"+map.get("exploration_method"), map.get("daily_porint")) ;
			  }
	  }
	  
		return mapE;
	 
	 
	}
	/**
	 * 根据expMethod编号获取内容
	 * 
	 * @return
	 */
	public String getExpMethodName(String expMethodId) {
		String sql = "select d.coding_name from comm_coding_sort_detail d where d.bsflag = '0' and d.coding_code_id = '"
				+ expMethodId + "'";
		Map m = radDao.queryRecordBySQL(sql);
		if (m != null) {
			return m.get("coding_name").toString();
		} else {
			return null;
		}
	}
}
