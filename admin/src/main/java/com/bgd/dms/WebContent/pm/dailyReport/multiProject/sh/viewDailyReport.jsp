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
//alert("ddddcccc1111");
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
	var retObj = jcdpCallService("DailyReportSrv", "getDailyReportInfoSh", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate);
	
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
	
	document.getElementById("WORK_TIME").innerHTML = retObj.dailyMap.WORK_TIME;
	document.getElementById("COLLECT_TIME").innerHTML = retObj.dailyMap.COLLECT_TIME;
	document.getElementById("DAY_CHECK_TIME").innerHTML = retObj.dailyMap.DAY_CHECK_TIME;
	document.getElementById("BREAKDOWN_TIME").innerHTML = retObj.dailyMap.BREAKDOWN_TIME;

	document.getElementById("WORK_TIME_TOTAL").innerHTML = retObj.dailyMap.WORK_TIME_TOTAL;
	document.getElementById("COLLECT_TIME_TOTAL").innerHTML = retObj.dailyMap.COLLECT_TIME_TOTAL;
	document.getElementById("DAY_CHECK_TIME_TOTAL").innerHTML = retObj.dailyMap.DAY_CHECK_TIME_TOTAL;
	document.getElementById("BREAKDOWN_TIME_TOTAL").innerHTML = retObj.dailyMap.BREAKDOWN_TIME_TOTAL;
	
	
	
	//气枪
	document.getElementById("DAILY_QQ_ACQUIRE_WORKLOAD").innerHTML = retObj.dailyMap.DAILY_QQ_ACQUIRE_WORKLOAD;//日完成气枪km
	document.getElementById("PROJECT_ACQUIRE_WORKLOAD").innerHTML = retObj.dailyMap.PROJECT_ACQUIRE_WORKLOAD;//累计完成km
	document.getElementById("DESIGN_SP_NUM").innerHTML = retObj.dailyMap.DESIGN_SP_NUM;//设计工作量
	document.getElementById("PROJECT_ACQUIRE_WORK_RATIO").innerHTML = retObj.dailyMap.PROJECT_ACQUIRE_WORK_RATIO;//完成工作量%
	
	
	var retAuditMap = jcdpCallService("DailyReportSrv", "getAuditInfo", "dailyNo="+retObj.dailyMap.DAILY_NO);
	document.getElementById("employee_name").innerHTML= retAuditMap.auditMap.employeeName;
	document.getElementById("audit_opinion").value= retAuditMap.auditMap.auditOpinion;
	
	debugger;
	var surveyList = retObj.surveyList;
	var surfaceList = retObj.surfaceList;
	var drillList = retObj.drillList;
	var acquireList = retObj.acquireList;
	
	document.getElementById("collect_process_status").value = retObj.dailyMap.COLLECT_PROCESS_STATUS;
}
function toSubmit(){
	//debugger;
	var form = document.getElementById("form1");
	var projectInfoNo = '<%=project_info_no %>';
	var dailyNo = '<%=daily_no %>';
	produceDate = document.getElementById("produceDate").value;
	var collect_process_status = document.getElementById("collect_process_status").value;
	var retObj = jcdpCallService("DailyReportSrv", "submitDailyReport", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate+"&collect_process_status="+collect_process_status);
	var retObj = jcdpCallService("DailyReportSrv", "submitDailyReport", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate+"&collect_process_status="+collect_process_status);
	top.frames('list').refreshData();
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
						<td class="inquire_item6" >&nbsp;</td>
						<td class="inquire_form6" >&nbsp;</td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">采集时间（小时）</td>
						<td class="inquire_form6" id="WORK_TIME"></td>
						<td class="inquire_item6">付费待工时间（小时）</td>
						<td class="inquire_form6" id="COLLECT_TIME"></td>
						<td class="inquire_item6">不付费待工时间（小时）</td>
						<td class="inquire_form6" id="DAY_CHECK_TIME"></td>
						<td class="inquire_item6">故障时间（小时）</td>
						<td class="inquire_form6" id="BREAKDOWN_TIME"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item6">采集时间累计（小时）</td>
						<td class="inquire_form6" id="WORK_TIME_TOTAL"></td>
						<td class="inquire_item6">付费待工时间累计（小时）</td>
						<td class="inquire_form6" id="COLLECT_TIME_TOTAL"></td>
						<td class="inquire_item6">不付费待工时间累计（小时）</td>
						<td class="inquire_form6" id="DAY_CHECK_TIME_TOTAL"></td>
						<td class="inquire_item6">故障时间累计（小时）</td>
						<td class="inquire_form6" id="BREAKDOWN_TIME_TOTAL"></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">采集工作量：</td>
						<td class="inquire_form8"><select class="select_width" name="collect_process_status" id="collect_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td>
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr class="even">
						<td class="inquire_item6">日完成气枪km：</td>
						<td class="inquire_form6" id="DAILY_QQ_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">累计完成km：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6">设计工作量：</td>
						<td class="inquire_form6" id="DESIGN_SP_NUM"></td>
						<td class="inquire_item6">完成工作量%：</td>
						<td class="inquire_form6" id="PROJECT_ACQUIRE_WORK_RATIO" ></td>
					</tr>
				</table>
			</div>
		</div>
</body>

<script type="text/javascript">
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function cancel() {
		window.close();
	}

	function save() {
		document.getElementById("form1").submit();
	}

	function refreshData() {
		document.getElementById("form1").submit();
		newClose();
	}
</script>
</html>