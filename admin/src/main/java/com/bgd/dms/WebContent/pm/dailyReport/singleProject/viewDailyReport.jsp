<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

	String daily_no = request.getParameter("daily_no");
	
	String project_info_no = request.getParameter("project_info_no");
	
	if(project_info_no == null || "".equals(project_info_no)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		project_info_no = user.getProjectInfoNo();
	}
	
	String produce_date = request.getParameter("produce_date");
	
	if(produce_date == null){
		produce_date = "null";
	}
	
	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	
	WorkMethodSrv srv = new WorkMethodSrv();
	String build_method = srv.getProjectExcitationMode(project_info_no);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup-new.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
</head>


<script type="text/javascript">

cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
var produceDate;
function page_init(){
	var produceDate = document.getElementById("produceDate").value;
	debugger;
	if(produceDate == null || produceDate == ""){
		produceDate = '<%=produce_date %>';
	} 
	//alert(prodceDate);
	var retObj = jcdpCallService("DailyReportSrv", "getDailyReportInfo", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate);
	
	document.getElementById("produceDate").value = retObj.dailyMap.PRODUCE_DATE;
	document.getElementById("daily_no").value = retObj.dailyMap.DAILY_NO;
	
	
	var audit_status = retObj.dailyMap.AUDIT_STATUS;
	//debugger;
	if(audit_status == "" || audit_status == null) {
		document.getElementById("audit_status").innerHTML = '日报未录入!';
		document.getElementById("tj_btn").style.display="none";
		document.getElementById("cx_btn").colSpan="2";
	} else if(audit_status == "0") {
		document.getElementById("audit_status").innerHTML = '日报还没有提交!';
		document.getElementById("tj_btn").style.display="inline";
		document.getElementById("cx_btn").colSpan="1";
	} else if(audit_status == "1") {
		document.getElementById("audit_status").innerHTML = '日报已经提交，等待审批中!';
		document.getElementById("tj_btn").style.display="none";
		document.getElementById("cx_btn").colSpan="2";
	} else if(audit_status == "3") {
		document.getElementById("audit_status").innerHTML = '日报已经审批通过!';
		document.getElementById("tj_btn").style.display="none";
		document.getElementById("cx_btn").colSpan="2";
	} else {
		document.getElementById("audit_status").innerHTML = '日报审批未通过!';
		document.getElementById("tj_btn").style.display="inline";
		document.getElementById("cx_btn").colSpan="1";
	}
	
	var IF_BUILD = retObj.dailyMap.IF_BUILD;
	if(IF_BUILD == "" || IF_BUILD == null){
		document.getElementById("IF_BUILD").innerHTML = '';
	} else if(IF_BUILD == "1"){
		document.getElementById("IF_BUILD").innerHTML = '动迁';
	} else if(IF_BUILD == "2"){
		document.getElementById("IF_BUILD").innerHTML = '踏勘';
	} else if(IF_BUILD == "3"){
		document.getElementById("IF_BUILD").innerHTML = '试验';
	} else if(IF_BUILD == "4"){
		document.getElementById("IF_BUILD").innerHTML = '测量';
	} else if(IF_BUILD == "5"){
		document.getElementById("IF_BUILD").innerHTML = '钻井';
	} else if(IF_BUILD == "6"){
		document.getElementById("IF_BUILD").innerHTML = '采集';
	} else if(IF_BUILD == "7"){
		document.getElementById("IF_BUILD").innerHTML = '停工';
		//显示停工原因
		document.getElementById("stop_title").innerHTML = '停工原因:';
		var stop_reason = retObj.dailyMap.STOP_REASON;
		if(stop_reason == "1"){
			document.getElementById("stop_content").innerHTML = '试验';
		}else if(stop_reason == "2"){
			document.getElementById("stop_content").innerHTML = '检修';
		}else if(stop_reason == "3"){
			document.getElementById("stop_content").innerHTML = '组织停工';
		}else if(stop_reason == "4"){
			document.getElementById("stop_content").innerHTML = '自然停工';
		}else if(stop_reason == "5"){
			document.getElementById("stop_content").innerHTML = '其他';
		}
	} else if(IF_BUILD == "8"){
		document.getElementById("IF_BUILD").innerHTML = '暂停';
	} else if(IF_BUILD == "9"){
		document.getElementById("IF_BUILD").innerHTML = '结束';
	}
	
	var WEATHER = retObj.dailyMap.WEATHER;
	if(WEATHER == "" || WEATHER == null){
		document.getElementById("WEATHER").innerHTML = '';
	} else if(WEATHER == "1"){
		document.getElementById("WEATHER").innerHTML = '晴';
	} else if(WEATHER == "2"){
		document.getElementById("WEATHER").innerHTML = '阴';
	} else if(WEATHER == "3"){
		document.getElementById("WEATHER").innerHTML = '多云';
	} else if(WEATHER == "4"){
		document.getElementById("WEATHER").innerHTML = '雨';
	} else if(WEATHER == "5"){
		document.getElementById("WEATHER").innerHTML = '雾';
	} else if(WEATHER == "6"){
		document.getElementById("WEATHER").innerHTML = '霾';
	} else if(WEATHER == "7"){
		document.getElementById("WEATHER").innerHTML = '霜冻';
	} else if(WEATHER == "8"){
		document.getElementById("WEATHER").innerHTML = '暴风';
	} else if(WEATHER == "9"){
		document.getElementById("WEATHER").innerHTML = '台风';
	} else if(WEATHER == "10"){
		document.getElementById("WEATHER").innerHTML = '暴风雪';
	} else if(WEATHER == "11"){
		document.getElementById("WEATHER").innerHTML = '雪';
	} else if(WEATHER == "12"){
		document.getElementById("WEATHER").innerHTML = '雨夹雪';
	} else if(WEATHER == "13"){
		document.getElementById("WEATHER").innerHTML = '冰雹';
	} else if(WEATHER == "14"){
		document.getElementById("WEATHER").innerHTML = '浮尘';
	} else if(WEATHER == "15"){
		document.getElementById("WEATHER").innerHTML = '扬沙';
	} else if(WEATHER == "16"){
		document.getElementById("WEATHER").innerHTML = '其他';
	} else if(WEATHER == "17"){
		document.getElementById("WEATHER").innerHTML = '大风';
	}
	debugger;
	//document.getElementById("IF_BUILD").innerHTML = retObj.dailyMap.IF_BUILD;
	//document.getElementById("WEATHER").innerHTML = retObj.dailyMap.WEATHER;
	
	document.getElementById("WORK_TIME").innerHTML = retObj.dailyMap.WORK_TIME;
	document.getElementById("COLLECT_TIME").innerHTML = retObj.dailyMap.COLLECT_TIME;
	document.getElementById("DAY_CHECK_TIME").innerHTML = retObj.dailyMap.DAY_CHECK_TIME;
	//document.getElementById("WORKMAN_NUM").innerHTML = retObj.dailyMap.WORKMAN_NUM;
	//document.getElementById("OUT_EMPLOYEE_NUM").innerHTML = retObj.dailyMap.OUT_EMPLOYEE_NUM;
	//document.getElementById("SEASON_EMPLOYEE_NUM").innerHTML = retObj.dailyMap.SEASON_EMPLOYEE_NUM;
	
	//测量
	document.getElementById("DAILY_SURVEY_SHOT_NUM").innerHTML = retObj.dailyMap.DAILY_SURVEY_SHOT_NUM;
	document.getElementById("PROJECT_SURVEY_SHOT_NUM").innerHTML = retObj.dailyMap.PROJECT_SURVEY_SHOT_NUM;
	document.getElementById("DESIGN_SP_NUM1").innerHTML = retObj.dailyMap.DESIGN_SP_NUM;
	//document.getElementById("DAILY_SURVEY_TOTAL_NUM").innerHTML = retObj.dailyMap.DAILY_SURVEY_TOTAL_NUM;
	document.getElementById("DAILY_SURVEY_TOTAL_NUM").innerHTML = Number(retObj.dailyMap.DAILY_SURVEY_SHOT_NUM) + Number(retObj.dailyMap.DAILY_SURVEY_GEOPHONE_NUM);
	
	document.getElementById("DAILY_SURVEY_GEOPHONE_NUM").innerHTML = retObj.dailyMap.DAILY_SURVEY_GEOPHONE_NUM;
	document.getElementById("PROJECT_SURVEY_GEOPHONE_NUM").innerHTML = retObj.dailyMap.PROJECT_SURVEY_GEOPHONE_NUM;
	document.getElementById("DESIGN_GEOPHONE_NUM").innerHTML = retObj.dailyMap.DESIGN_GEOPHONE_NUM;
	document.getElementById("PROJECT_SURVEY_RATIO").innerHTML = retObj.dailyMap.PROJECT_SURVEY_RATIO;
	
	document.getElementById("SURVEY_INCEPT_WORKLOAD").innerHTML = retObj.dailyMap.SURVEY_INCEPT_WORKLOAD;
	document.getElementById("SURVEY_SHOT_WORKLOAD").innerHTML = retObj.dailyMap.SURVEY_SHOT_WORKLOAD;
	document.getElementById("PROJECT_SURVEY_INCEPT_WORKLOAD").innerHTML = retObj.dailyMap.PROJECT_SURVEY_INCEPT_WORKLOAD;
	document.getElementById("PROJECT_SURVEY_SHOT_WORKLOAD").innerHTML = retObj.dailyMap.PROJECT_SURVEY_SHOT_WORKLOAD;
	document.getElementById("PROJECT_SURVEY_TOTAL_WORKLOAD").innerHTML = retObj.dailyMap.PROJECT_SURVEY_TOTAL_WORKLOAD;
	
	document.getElementById("MEASURE_KM").innerHTML = retObj.dailyMap.MEASURE_KM;
	document.getElementById("PROJECT_SURVEY_KM_RATIO").innerHTML = retObj.dailyMap.PROJECT_SURVEY_KM_RATIO;
	
	//表层
	document.getElementById("DAILY_MICRO_MEASUE_POINT_NUM").innerHTML = retObj.dailyMap.DAILY_MICRO_MEASUE_POINT_NUM;
	document.getElementById("PROJECT_MICRO_MEASUE_NUM").innerHTML = retObj.dailyMap.PROJECT_MICRO_MEASUE_NUM;
	document.getElementById("DESIGN_MICRO_MEASUE_NUM").innerHTML = retObj.dailyMap.DESIGN_MICRO_MEASUE_NUM;
	
	document.getElementById("DAILY_SMALL_REFRACTION_NUM").innerHTML = retObj.dailyMap.DAILY_SMALL_REFRACTION_NUM;
	document.getElementById("PROJECT_SMALL_REFRACTION_NUM").innerHTML = retObj.dailyMap.PROJECT_SMALL_REFRACTION_NUM;
	document.getElementById("DESIGN_SMALL_REGRACTION_NUM").innerHTML = retObj.dailyMap.DESIGN_SMALL_REGRACTION_NUM;
	
	//钻井
	document.getElementById("DAILY_DRILL_SP_NUM").innerHTML = retObj.dailyMap.DAILY_DRILL_SP_NUM;
	document.getElementById("PROJECT_DRILL_SP_NUM").innerHTML = retObj.dailyMap.PROJECT_DRILL_SP_NUM;
	document.getElementById("DESIGN_DRILL_NUM").innerHTML = retObj.dailyMap.DESIGN_DRILL_NUM;
	document.getElementById("PROJECT_DRILL_SP_RATIO").innerHTML = retObj.dailyMap.PROJECT_DRILL_SP_RATIO;
	
	document.getElementById("DAILY_DRILL_WELL_NUM").innerHTML = retObj.dailyMap.DAILY_DRILL_WELL_NUM;
	document.getElementById("PROJECT_DRILL_WELL_NUM").innerHTML = retObj.dailyMap.PROJECT_DRILL_WELL_NUM;
	document.getElementById("DAILY_DRILL_FOOTAGE_NUM").innerHTML = retObj.dailyMap.DAILY_DRILL_FOOTAGE_NUM;
	document.getElementById("PROJECT_DRILL_FOOTAGE_NUM").innerHTML = retObj.dailyMap.PROJECT_DRILL_FOOTAGE_NUM;
	
	//采集
	document.getElementById("DAILY_ACQUIRE_SP_NUM").innerHTML = retObj.dailyMap.DAILY_ACQUIRE_SP_NUM;
	document.getElementById("DAILY_JP_ACQUIRE_SHOT_NUM").innerHTML = retObj.dailyMap.DAILY_JP_ACQUIRE_SHOT_NUM;
	document.getElementById("DAILY_QQ_ACQUIRE_SHOT_NUM").innerHTML = retObj.dailyMap.DAILY_QQ_ACQUIRE_SHOT_NUM;
	
	document.getElementById("PROJECT_ACQUIRE_SP_NUM").innerHTML = retObj.dailyMap.PROJECT_ACQUIRE_SP_NUM;
	document.getElementById("DESIGN_SP_NUM2").innerHTML = retObj.dailyMap.DESIGN_SP_NUM;
	document.getElementById("PROJECT_ACQUIRE_SP_RATIO").innerHTML = retObj.dailyMap.PROJECT_ACQUIRE_SP_RATIO;
	
	document.getElementById("DAILY_ACQUIRE_WORKLOAD").innerHTML = retObj.dailyMap.DAILY_ACQUIRE_WORKLOAD;
	document.getElementById("DAILY_JP_ACQUIRE_WORKLOAD").innerHTML = retObj.dailyMap.DAILY_JP_ACQUIRE_WORKLOAD;
	document.getElementById("DAILY_QQ_ACQUIRE_WORKLOAD").innerHTML = retObj.dailyMap.DAILY_QQ_ACQUIRE_WORKLOAD;
	
	document.getElementById("PROJECT_ACQUIRE_WORKLOAD").innerHTML = retObj.dailyMap.PROJECT_ACQUIRE_WORKLOAD;
	document.getElementById("DESIGN_OBJECT_WORKLOAD").innerHTML = retObj.dailyMap.DESIGN_OBJECT_WORKLOAD;
	document.getElementById("PROJECT_ACQUIRE_WORK_RATIO").innerHTML = retObj.dailyMap.PROJECT_ACQUIRE_WORK_RATIO;
	
	document.getElementById("DAILY_ACQUIRE_QUALIFIED_NUM").innerHTML = retObj.dailyMap.DAILY_ACQUIRE_QUALIFIED_NUM;
	document.getElementById("PROJECT_QUALIFIED_SP_NUM").innerHTML = retObj.dailyMap.PROJECT_QUALIFIED_SP_NUM;
	document.getElementById("PROJECT_QUALIFIED_SP_RATIO").innerHTML = retObj.dailyMap.PROJECT_QUALIFIED_SP_RATIO;
	
	document.getElementById("DAILY_ACQUIRE_FIRSTLEVEL_NUM").innerHTML = retObj.dailyMap.DAILY_ACQUIRE_FIRSTLEVEL_NUM;
	document.getElementById("PROJECT_FIRSTLEVEL_SP_NUM").innerHTML = retObj.dailyMap.PROJECT_FIRSTLEVEL_SP_NUM;
	document.getElementById("PROJECT_FIRSTLEVEL_SP_RATIO").innerHTML = retObj.dailyMap.PROJECT_FIRSTLEVEL_SP_RATIO;
	
	document.getElementById("COLLECT_2_CLASS").innerHTML = retObj.dailyMap.COLLECT_2_CLASS;
	document.getElementById("PROJECT_COLLECT_2_CLASS").innerHTML = retObj.dailyMap.PROJECT_COLLECT_2_CLASS;
	document.getElementById("PROJECT_COLLECT_2_CLASS_RATIO").innerHTML = retObj.dailyMap.PROJECT_COLLECT_2_CLASS_RATIO;
	
	document.getElementById("COLLECT_WASTER_NUM").innerHTML = retObj.dailyMap.COLLECT_WASTER_NUM;
	document.getElementById("PROJECT_COLLECT_WASTER_NUM").innerHTML = retObj.dailyMap.PROJECT_COLLECT_WASTER_NUM;
	document.getElementById("PROJECT_COLLECT_WASTER_NUM_RATIO").innerHTML = retObj.dailyMap.PROJECT_COLLECT_WASTER_NUM_RATIO;
	
	document.getElementById("COLLECT_MISS_NUM").innerHTML = retObj.dailyMap.COLLECT_MISS_NUM;
	document.getElementById("PROJECT_COLLECT_MISS_NUM").innerHTML = retObj.dailyMap.PROJECT_COLLECT_MISS_NUM;
	document.getElementById("PROJECT_COLLECT_MISS_NUM_RATIO").innerHTML = retObj.dailyMap.PROJECT_COLLECT_MISS_NUM_RATIO;
	
	//试验
	document.getElementById("DAILY_TEST_SP_NUM").innerHTML = retObj.dailyMap.DAILY_TEST_SP_NUM;
	document.getElementById("PROJECT_DAILY_TEST_SP_NUM").innerHTML = retObj.dailyMap.PROJECT_TEST_SP_NUM;
	document.getElementById("DAILY_TEST_QUALIFIED_SP_NUM").innerHTML = retObj.dailyMap.DAILY_TEST_QUALIFIED_SP_NUM;
	document.getElementById("PROJECT_QUALIFIED_TEST_SP_NUM").innerHTML = retObj.dailyMap.PROJECT_QUALIFIED_TEST_SP_NUM;
	
	var retAuditMap = jcdpCallService("DailyReportSrv", "getAuditInfo", "dailyNo="+retObj.dailyMap.DAILY_NO);
	document.getElementById("employee_name").innerHTML= retAuditMap.auditMap.employeeName;
	document.getElementById("audit_opinion").value= retAuditMap.auditMap.auditOpinion;
	
	debugger;
	var surveyList = retObj.surveyList;
	var surfaceList = retObj.surfaceList;
	var drillList = retObj.drillList;
	var acquireList = retObj.acquireList;
	
	document.getElementById("survey_process_status").value = retObj.dailyMap.SURVEY_PROCESS_STATUS;
	document.getElementById("surface_process_status").value = retObj.dailyMap.SURFACE_PROCESS_STATUS;
	document.getElementById("drill_process_status").value = retObj.dailyMap.DRILL_PROCESS_STATUS;
	document.getElementById("collect_process_status").value = retObj.dailyMap.COLLECT_PROCESS_STATUS;
	
	var survey = document.getElementById("survey");
	var surveysize = survey.rows.length;
	if(surveysize != 1){
		//清掉已增加的列
		for(var i=1; i < surveysize;i++){
			survey.deleteRow(1);
		}
	}
	var surface = document.getElementById("surface");
	var surfacesize = surface.rows.length;
	if(surfacesize != 1){
		//清掉已增加的列
		for(var i=1; i < surfacesize;i++){
			surface.deleteRow(1);
		}
	}
	var drill = document.getElementById("drill");
	var drillsize = drill.rows.length;
	if(drillsize != 1){
		for(var i=1; i < drillsize;i++){
			drill.deleteRow(1);
		}
	}
	
	var acquire = document.getElementById("acquire");
	var acquiresize = acquire.rows.length;
	if(acquiresize != 1){
		//清掉已增加的列
		for(var i=1; i < acquiresize;i++){
			acquire.deleteRow(1);
		}
	}
	
	if(surveyList != null){
		for(var i = 0 ; i<surveyList.length; i++){
			var tr = document.getElementById("survey").insertRow();
			if ( i % 2 == 0) {
		        tr.className = "even";
		    } else {
		        tr.className = "odd";
		    }
			var obj = retObj.surveyList[i];
			
			tr.insertCell().innerHTML = obj.LINE_GROUP_ID;
			tr.insertCell().innerHTML = obj.SHOT_NUM != null?obj.SHOT_NUM:"0";
			tr.insertCell().innerHTML = obj.GEOPHONE_NUM != null?obj.GEOPHONE_NUM:"0";
			tr.insertCell().innerHTML = obj.SURVEY_INCEPT_WORKLOAD != null?obj.SURVEY_INCEPT_WORKLOAD:"0";;
			tr.insertCell().innerHTML = obj.SURVEY_SHOT_WORKLOAD != null?obj.SURVEY_SHOT_WORKLOAD:"0";;
		}
	}
	
	if(surfaceList != null){
		for(var i = 0 ; i<surfaceList.length; i++){
			var tr = document.getElementById("surface").insertRow();
			if ( i % 2 == 0) {
		        tr.className = "even";
		    } else {
		        tr.className = "odd";
		    }
			var obj = retObj.surfaceList[i];
			
			tr.insertCell().innerHTML = obj.LINE_GROUP_ID;
			var type = obj.SURFACE_METHOD_TYPE;
			if(type == "1"){
				tr.insertCell().innerHTML = '微测井';	
			} else {
				tr.insertCell().innerHTML = '小折射';
			}
			 
			tr.insertCell().innerHTML = obj.POINT_NUM != null?obj.POINT_NUM : "0";
		}
	}
	
	if(drillList != null){
		for(var i = 0 ; i<drillList.length; i++){
			var tr = document.getElementById("drill").insertRow();
			if ( i % 2 == 0) {
		        tr.className = "even";
		    } else {
		        tr.className = "odd";
		    }
			var obj = retObj.drillList[i];
			
			tr.insertCell().innerHTML = obj.LINE_GROUP_ID;
			tr.insertCell().innerHTML = obj.DRILL_SP_NUM!=null?obj.DRILL_SP_NUM:"0";
			tr.insertCell().innerHTML = obj.DRILL_WELL_NUM!=null?obj.DRILL_WELL_NUM:"0";
			tr.insertCell().innerHTML = obj.DRILL_FOOTAGE_NUM!=null?obj.DRILL_FOOTAGE_NUM:"0";
		}
	}
	
	if(acquireList != null){
		for(var i = 0 ; i<acquireList.length; i++){
			var tr = document.getElementById("acquire").insertRow();
			if ( i % 2 == 0) {
		        tr.className = "even";
		    } else {
		        tr.className = "odd";
		    }
			var obj = retObj.acquireList[i];
			
			tr.insertCell().innerHTML = obj.LINE_GROUP_ID;
			var type = obj.BUILD_TYPE;
			if(type == "1"){
				tr.insertCell().innerHTML = '震源';	
			} else if(type == "2"){
				tr.insertCell().innerHTML = '井炮';
			} else {
				tr.insertCell().innerHTML = '气枪';
			}
			tr.insertCell().innerHTML = obj.DAILY_FINISH_SP !=null?obj.DAILY_FINISH_SP:"0";
			tr.insertCell().innerHTML = obj.DAILY_FINISH_WORKLOAD !=null?obj.DAILY_FINISH_WORKLOAD:"0";
		}
	}
	
	document.getElementById("dailyQuestion").src = "<%=contextPath%>/pm/dailyReport/singleProject/dailyQuestionList.jsp?projectInfoNo=<%=project_info_no %>&produceDate="+produceDate;
}
function toSubmit(){
	//debugger;
	var form = document.getElementById("form1");
	var projectInfoNo = '<%=project_info_no %>';
	var dailyNo = '<%=daily_no %>';
	produceDate = document.getElementById("produceDate").value;
	var survey_process_status = document.getElementById("survey_process_status").value;
	var surface_process_status = document.getElementById("surface_process_status").value;
	var drill_process_status = document.getElementById("drill_process_status").value;
	var collect_process_status = document.getElementById("collect_process_status").value;
	//form.action="<%=contextPath%>/pm/dailyReport/submitDailyReport.srq?projectInfoNo="+projectInfoNo+"&dailyNo="+dailyNo+"produceDate="+produceDate;
	var retObj = jcdpCallService("DailyReportSrv", "submitDailyReport", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate+"&survey_process_status="+survey_process_status+"&surface_process_status="+surface_process_status+"&drill_process_status="+drill_process_status+"&collect_process_status="+collect_process_status);
	
//	alert(top.frames('list').name);
//	top.frames('list').alertmsg(); 
	top.frames('list').refreshData();

//	alert(top.frames[4].name);
//	top.frames[4].alertmsg();
//	top.frames[4].refreshData();
	
	page_init();
}

function toQueryQuestion(){
	var produceDate = document.getElementById("produceDate").value;
	popWindow("<%=contextPath%>/pm/dailyReport/singleProject/dailyQuestionList.jsp?projectInfoNo=<%=project_info_no %>&produceDate="+produceDate);
}

</script>
<body onload="page_init()" style="overflow:scroll;">
		<div id="tab_box" class="tab_box" >
			<div id="tab_box_content0" class="tab_box_content">
				<form id="form1"  method="post">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">生产日期：</td>	
						<td class="inquire_form8">
							<input type="hidden" name="daily_no" id="daily_no"/>
							<input type="text" name="produceDate" id='produceDate' value='' readonly="readonly"/>&nbsp;&nbsp;
							<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(produceDate,tributton1);" />&nbsp;&nbsp;
							<font color="red" style="text-align: right;" id="audit_status">审批通过</font>
						</td>
						<td class="inquire_form4">&nbsp;</td>
						<auth:ListButton tdid="cx_btn" functionId="" css="cx" event="onclick='page_init()'" title="JCDP_btn_query"></auth:ListButton>
						<auth:ListButton tdid="tj_btn" functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
					</tr>
				</table>
				</form>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="audit">
					<tr style="background-color: #97cbfd">
					 	<td class="inquire_item6" >审批人</td>
					 	<td class="inquire_form6" colspan="5" id="employee_name">&nbsp;</td>
					 </tr>
					 <tr class="odd">
					 	<td class="inquire_item6">审批意见</td>
					 	<td class="inquire_form6"  colspan="5">
					 		<textarea type="text"  rows="4" style="width:100%;" readonly="readonly" id="audit_opinion"></textarea>
					 	</td>
					 </tr>
				 </table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr class="even">
						<td class="inquire_item6">项目状态：</td>
						<td class="inquire_form6" id="IF_BUILD"></td>
						<td class="inquire_item6">天气：</td>
						<td class="inquire_form6" id="WEATHER"></td>
						<td class="inquire_item6" id="stop_title">&nbsp;</td>
						<td class="inquire_form6" id="stop_content">&nbsp;</td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">施工时长(小时)：</td>
						<td class="inquire_form6" id="WORK_TIME"></td>
						<td class="inquire_item6">采集时间(小时)：</td>
						<td class="inquire_form6" id="COLLECT_TIME"></td>
						<td class="inquire_item6">日检时间(小时)：</td>
						<td class="inquire_form6" id="DAY_CHECK_TIME"></td>
					</tr>
					<!--
					<tr class="even">
						<td class="inquire_item6">合同化用工：</td>
						<td class="inquire_form6" id="WORKMAN_NUM"></td>
						<td class="inquire_item6">市场化用工：</td>
						<td class="inquire_form6" id="OUT_EMPLOYEE_NUM"></td>
						<td class="inquire_item6">季节性用工：</td>
						<td class="inquire_form6" id="SEASON_EMPLOYEE_NUM"></td>
					</tr>
					 -->
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">测量工作量：</td>
						<td class="inquire_form8"><select class="select_width" name="survey_process_status" id="survey_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td>
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr class="even">
						<td class="inquire_item8">日完成炮点数：</td>
						<td class="inquire_form8" id="DAILY_SURVEY_SHOT_NUM"></td>
						<td class="inquire_item8">累计完成炮点数：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_SHOT_NUM"></td>
						<td class="inquire_item8">设计炮点数：</td>
						<td class="inquire_form8" id="DESIGN_SP_NUM1"></td>
						<td class="inquire_item8">日完成总点数：</td>
						<td class="inquire_form8" id="DAILY_SURVEY_TOTAL_NUM"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">日完成检波点数：</td>
						<td class="inquire_form8" id="DAILY_SURVEY_GEOPHONE_NUM"></td>
						<td class="inquire_item8">累计完成检波点数：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_GEOPHONE_NUM"></td>
						<td class="inquire_item8">设计检波点数：</td>
						<td class="inquire_form8" id="DESIGN_GEOPHONE_NUM"></td>
						<td class="inquire_item8">完成%：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_RATIO"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item8">日完成接收线公里数：</td>
						<td class="inquire_form8" id="SURVEY_INCEPT_WORKLOAD"></td>
						<td class="inquire_item8">日完成炮线公里数：</td>
						<td class="inquire_form8" id="SURVEY_SHOT_WORKLOAD"></td>
						<td class="inquire_item8">累计接收线公里数：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_INCEPT_WORKLOAD"></td>
						<td class="inquire_item8">累计炮线公里数：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_SHOT_WORKLOAD"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">设计总公里数：</td>
						<td class="inquire_form8" id="MEASURE_KM"></td>
						<td class="inquire_item8">测量总公里完成%：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_KM_RATIO"></td>
						<td class="inquire_item8">累计测量公里数: </td>
						<td class="inquire_form8" id="PROJECT_SURVEY_TOTAL_WORKLOAD"></td>
						<td class="inquire_item8">&nbsp;</td>
						<td class="inquire_form8">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="survey">
					<tr>
						<td class="bt_info_odd">线号</td>
						<td class="bt_info_even">日完成炮点数</td>
						<td class="bt_info_odd">日完成检波点数</td>
						<td class="bt_info_even">接收线公里数</td>
						<td class="bt_info_odd">炮线公里数</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">表层工作量：</td>
						<td class="inquire_form8"><select class="select_width" name="surface_process_status" id="surface_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td>
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr class="even">
						<td class="inquire_item6">微测井日完成点数</td>
						<td class="inquire_form6" id="DAILY_MICRO_MEASUE_POINT_NUM"></td>
						<td class="inquire_item6">微测井累计完成点数</td>
						<td class="inquire_form6" id="PROJECT_MICRO_MEASUE_NUM"></td>
						<td class="inquire_item6">微测井设计点数</td>
						<td class="inquire_form6" id="DESIGN_MICRO_MEASUE_NUM"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">小折射日完成点数</td>
						<td class="inquire_form6" id="DAILY_SMALL_REFRACTION_NUM"></td>
						<td class="inquire_item6">小折射累计完成点数</td>
						<td class="inquire_form6" id="PROJECT_SMALL_REFRACTION_NUM"></td>
						<td class="inquire_item6">小折射设计点数</td>
						<td class="inquire_form6" id="DESIGN_SMALL_REGRACTION_NUM"></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="surface">
					<tr>
						<td class="bt_info_odd">线号</td>
						<td class="bt_info_even">类型</td>
						<td class="bt_info_odd">日完成点数</td>
					</tr>
				</table>
				
				<%  //激发方式有井炮,显示钻井工作量
					if("5000100003000000001".equals(build_method) || "5000100003000000004".equals(build_method) || "5000100003000000005".equals(build_method) || "5000100003000000007".equals(build_method)){ 
				%>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="drill_tab" >
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">钻井工作量：</td>
						<td class="inquire_form8"><select class="select_width" name="drill_process_status" id="drill_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td>
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="drill_info" >
					<tr class="even">
						<td class="inquire_item8">日完成炮点数：</td>
						<td class="inquire_form8" id="DAILY_DRILL_SP_NUM"></td>
						<td class="inquire_item8">项目累计完成炮点数：</td>
						<td class="inquire_form8" id="PROJECT_DRILL_SP_NUM"></td>
						<td class="inquire_item8">设计点数：</td>
						<td class="inquire_form8" id="DESIGN_DRILL_NUM"></td>
						<td class="inquire_item8">完成%：</td>
						<td class="inquire_form8" id="PROJECT_DRILL_SP_RATIO"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">日完成井口数：</td>
						<td class="inquire_form8" id="DAILY_DRILL_WELL_NUM"></td>
						<td class="inquire_item8">项目累计完成井口数：</td>
						<td class="inquire_form8" id="PROJECT_DRILL_WELL_NUM"></td>
						<td class="inquire_item8">日完成进尺数：</td>
						<td class="inquire_form8" id="DAILY_DRILL_FOOTAGE_NUM"></td>
						<td class="inquire_item8">项目累计完成进尺数：</td>
						<td class="inquire_form8" id="PROJECT_DRILL_FOOTAGE_NUM"></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="drill" >
					<tr>
						<td class="bt_info_odd">线号</td>
						<td class="bt_info_even">日完成炮点数</td>
						<td class="bt_info_odd">日完成井口数</td>
						<td class="bt_info_even">日完成进尺</td>
					</tr>
				</table>
				
				<%
					}else{
				%>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="drill_tab" style="display:none;">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">钻井工作量：</td>
						<td class="inquire_form8"><select class="select_width" name="drill_process_status" id="drill_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td>
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="drill_info" style="display:none;">
					<tr class="even">
						<td class="inquire_item8">日完成炮点数：</td>
						<td class="inquire_form8" id="DAILY_DRILL_SP_NUM"></td>
						<td class="inquire_item8">项目累计完成炮点数：</td>
						<td class="inquire_form8" id="PROJECT_DRILL_SP_NUM"></td>
						<td class="inquire_item8">设计点数：</td>
						<td class="inquire_form8" id="DESIGN_DRILL_NUM"></td>
						<td class="inquire_item8">完成%：</td>
						<td class="inquire_form8" id="PROJECT_DRILL_SP_RATIO"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">日完成井口数：</td>
						<td class="inquire_form8" id="DAILY_DRILL_WELL_NUM"></td>
						<td class="inquire_item8">项目累计完成井口数：</td>
						<td class="inquire_form8" id="PROJECT_DRILL_WELL_NUM"></td>
						<td class="inquire_item8">日完成进尺数：</td>
						<td class="inquire_form8" id="DAILY_DRILL_FOOTAGE_NUM"></td>
						<td class="inquire_item8">项目累计完成进尺数：</td>
						<td class="inquire_form8" id="PROJECT_DRILL_FOOTAGE_NUM"></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="drill" style="display:none;">
					<tr>
						<td class="bt_info_odd">线号</td>
						<td class="bt_info_even">日完成炮点数</td>
						<td class="bt_info_odd">日完成井口数</td>
						<td class="bt_info_even">日完成进尺</td>
					</tr>
				</table>				
				
				<%
					}
				%>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">采集工作量：</td>
						<td class="inquire_form8"><select class="select_width" name="collect_process_status" id="collect_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td>
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<%  //井炮
					if("5000100003000000001".equals(build_method)){ 
				%>
					<tr class="even">
						<td class="inquire_item6">日完成井炮炮点数：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_SHOT_NUM"></td>
						<td class="inquire_item6" >日完成井炮km：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6" style="display:none;">日完成震源炮点数：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_SP_NUM" style="display:none;"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6" >累计完成炮数：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">设计炮数：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM2"></td>
						<td class="inquire_item6">完成炮数%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_RATIO"></td>
					</tr>
					<tr class="even" style="display:none;">
						<td class="inquire_item6" style="display:none;">日完成气枪炮点数：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_SHOT_NUM" style="display:none;"></td>
						<td class="inquire_item6" style="display:none;">日完成震源km：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_WORKLOAD" style="display:none;"></td>
						<td class="inquire_item6" style="display:none;">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD" style="display:none;"></td>
					</tr>
				<%} //震源
					else if("5000100003000000002".equals(build_method)){%>
					<tr class="even">
						<td class="inquire_item6">日完成震源炮点数：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">日完成震源km：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6" style="display:none;">日完成气枪炮点数：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_SHOT_NUM" style="display:none;"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">累计完成炮数：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">设计炮数：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM2"></td>
						<td class="inquire_item6">完成炮数%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_RATIO"></td>
					</tr>
					<tr class="even" style="display:none;">
						<td class="inquire_item6" style="display:none;">日完成井炮炮点数：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_SHOT_NUM" style="display:none;"></td>
						<td class="inquire_item6" style="display:none;">日完成井炮km：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD" style="display:none;"></td>
						<td class="inquire_item6" style="display:none;">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD" style="display:none;"></td>
					</tr>
					
				<%} //气枪
					else if("5000100003000000003".equals(build_method)){%>
					<tr class="even">
						<td class="inquire_item6">日完成气枪炮点数：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_SHOT_NUM"></td>
						<td class="inquire_item6">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6" style="display:none;">日完成井炮炮点数：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_SHOT_NUM" style="display:none;"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">累计完成炮数：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">设计炮数：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM2"></td>
						<td class="inquire_item6">完成炮数%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_RATIO"></td>
					</tr>
					<tr class="even" style="display:none;">
						<td class="inquire_item6" style="display:none;">日完成震源炮点数：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_SP_NUM" style="display:none;"></td>
						<td class="inquire_item6" style="display:none;">日完成震源km：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_WORKLOAD" style="display:none;"></td>
						<td class="inquire_item6" style="display:none;">日完成井炮km：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD" style="display:none;"></td>
					</tr>
				<%} //井炮/震源
					else if("5000100003000000004".equals(build_method)){%>
					<tr class="even">
						<td class="inquire_item6">日完成震源炮点数：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">日完成井炮炮点数：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_SHOT_NUM"></td>
						<td class="inquire_item6">日完成震源km：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_WORKLOAD"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">累计完成炮数：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">设计炮数：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM2"></td>
						<td class="inquire_item6">完成炮数%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_RATIO"></td>
					</tr>
					<tr class="even" style="display:none;">
						<td class="inquire_item6" style="display:none;">日完成气枪炮点数：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_SHOT_NUM" style="display:none;"></td>
						<td class="inquire_item6" style="display:none;">日完成井炮km：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD" style="display:none;"></td>
						<td class="inquire_item6" style="display:none;">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD" style="display:none;"></td>
					</tr>
				<%} //井炮/气枪
					else if("5000100003000000005".equals(build_method)){%>
					<tr class="even">
						<td class="inquire_item6">日完成井炮炮点数：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_SHOT_NUM"></td>
						<td class="inquire_item6">日完成气枪炮点数：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_SHOT_NUM"></td>
						<td class="inquire_item6" style="display:none;">日完成震源炮点数：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_SP_NUM" style="display:none;"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">累计完成炮数：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">设计炮数：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM2"></td>
						<td class="inquire_item6">完成炮数%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_RATIO"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item6">日完成井炮km：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6" style="display:none;">日完成震源km：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_WORKLOAD" style="display:none;"></td>
					</tr>
				<%} //震源/气枪
					else if("5000100003000000006".equals(build_method)){%>
					<tr class="even">
						<td class="inquire_item6">日完成震源炮点数：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">日完成气枪炮点数：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_SHOT_NUM"></td>
						<td class="inquire_item6" style="display:none;">日完成井炮炮点数：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_SHOT_NUM" style="display:none;"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">累计完成炮数：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">设计炮数：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM2"></td>
						<td class="inquire_item6">完成炮数%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_RATIO"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item6">日完成震源km：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6" style="display:none;">日完成井炮km：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD" style="display:none;"></td>
					</tr>
				<%} //井炮/震源/气枪
					else if("5000100003000000007".equals(build_method)){%>
					<tr class="even">
						<td class="inquire_item6">日完成震源炮点数：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">日完成井炮炮点数：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_SHOT_NUM"></td>
						<td class="inquire_item6">日完成气枪炮点数：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_SHOT_NUM"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">累计完成炮数：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">设计炮数：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM2"></td>
						<td class="inquire_item6">完成炮数%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_RATIO"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item6">日完成震源km：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">日完成井炮km：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD"></td>
					</tr>
				<%} //其他的
					else {%>
					<tr class="even">
						<td class="inquire_item6">日完成震源炮点数：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">日完成井炮炮点数：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_SHOT_NUM"></td>
						<td class="inquire_item6">日完成气枪炮点数：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_SHOT_NUM"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">累计完成炮数：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item6">设计炮数：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM2"></td>
						<td class="inquire_item6">完成炮数%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_SP_RATIO"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item6">日完成震源km：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">日完成井炮km：</td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD"></td>
					</tr>
				<%} %>
					<tr class="odd">
						<td class="inquire_item6">累计完成km：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">设计km：</td>
						<td class="inquire_form6" id="DESIGN_OBJECT_WORKLOAD"></td>
						<td class="inquire_item6">完成工作量%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_WORK_RATIO"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item6">日完成合格炮：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_QUALIFIED_NUM"></td>
						<td class="inquire_item6">累计完成合格炮：</td>
						<td class="inquire_form6" id="PROJECT_QUALIFIED_SP_NUM"></td>
						<td class="inquire_item6">合格炮率%：</td>
						<td class="inquire_form6" id="PROJECT_QUALIFIED_SP_RATIO"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">日完成一级炮：</td>
						<td class="inquire_form6" id="DAILY_ACQUIRE_FIRSTLEVEL_NUM"></td>
						<td class="inquire_item6">累计完成一级炮：</td>
						<td class="inquire_form6" id="PROJECT_FIRSTLEVEL_SP_NUM"></td>
						<td class="inquire_item6">一级炮率%：</td>
						<td class="inquire_form6" id="PROJECT_FIRSTLEVEL_SP_RATIO"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item6">日完成二级炮：</td>
						<td class="inquire_form6" id="COLLECT_2_CLASS"></td>
						<td class="inquire_item6">累计完成二级炮：</td>
						<td class="inquire_form6" id="PROJECT_COLLECT_2_CLASS"></td>
						<td class="inquire_item6">二级炮率%：</td>
						<td class="inquire_form6" id="PROJECT_COLLECT_2_CLASS_RATIO"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">日完成废炮：</td>
						<td class="inquire_form6" id="COLLECT_WASTER_NUM"></td>
						<td class="inquire_item6">累计完成废炮：</td>
						<td class="inquire_form6" id="PROJECT_COLLECT_WASTER_NUM"></td>
						<td class="inquire_item6">废炮率%：</td>
						<td class="inquire_form6" id="PROJECT_COLLECT_WASTER_NUM_RATIO"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item6">日完成空炮：</td>
						<td class="inquire_form6" id="COLLECT_MISS_NUM"></td>
						<td class="inquire_item6">累计完成空炮：</td>
						<td class="inquire_form6" id="PROJECT_COLLECT_MISS_NUM"></td>
						<td class="inquire_item6">空炮率%：</td>
						<td class="inquire_form6" id="PROJECT_COLLECT_MISS_NUM_RATIO"></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="acquire">
					<tr>
						<td class="bt_info_odd">线号</td>
						<td class="bt_info_even">激发方式</td>
						<td class="bt_info_odd">日完成炮数</td>
						<td class="bt_info_even">日完成km</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">试验情况：</td>
						<td colspan="7">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr class="even">
						<td class="inquire_item8">日完成试验炮：</td>
						<td class="inquire_form8" id="DAILY_TEST_SP_NUM"></td>
						<td class="inquire_item8">项目累计完成试验炮：</td>
						<td class="inquire_form8" id="PROJECT_DAILY_TEST_SP_NUM"></td>
						<td class="inquire_item8">日合格试验炮：</td>
						<td class="inquire_form8" id="DAILY_TEST_QUALIFIED_SP_NUM"></td>
						<td class="inquire_item8">项目累计合格试验炮：</td>
						<td class="inquire_form8" id="PROJECT_QUALIFIED_TEST_SP_NUM"></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">日问题信息：</td>
						<td colspan="7">&nbsp;</td>
					</tr>
				</table>
				<iframe width="100%" height="100%" name="dailyQuestion" id="dailyQuestion" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>

			</div>
		</div>
</body>

<script type="text/javascript">


	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function cancel() {
		window.close();
	}

	function save() {
		//if (!checkForm()) return;
		document.getElementById("form1").submit();
	}

	function refreshData() {
		//var ctt = top.frames('list').frames[1];
		//var file_name = document.getElementsByName("file_name")[0].value;
		//ctt.refreshData(undefined, file_name);
		//newClose();
		document.getElementById("form1").submit();
		newClose();
	}
</script>
</html>