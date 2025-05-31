<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%
	String contextPath = request.getContextPath();
	String reportFileName = (String) request.getParameter("reportFileName");
	if (reportFileName == null || reportFileName.trim().equals("")) {
		reportFileName = "/pm/dateRate.raq";
	}
	String start_date = (String) request.getParameter("start_date");
	if(start_date ==null || start_date.trim().equals("")){
		start_date = "2010-01-01";
	}
	String end_date = (String) request.getParameter("end_date");
	if(end_date ==null || end_date.trim().equals("")){
		end_date = "3000-12-31";
	}
	String agin_date=(String) request.getParameter("agin_date");
	 
	if(agin_date ==null || agin_date.trim().equals("")){
		agin_date = "2010-01-01";
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	String title = (String) request.getParameter("title");
	
	String project_name = user.getProjectName();
	String exploration_method = user.getExplorationMethod();
	title = project_name + title;
	String rptParams = (String) request.getParameter("rptParams");
	if (rptParams == null) {
		rptParams = "project_info_no=" + project_info_no + ";project_name=" + project_name + ";exploration_method=" + exploration_method+
		";start_date="+start_date+";end_date="+end_date+";agin_date="+agin_date+"";
	}
	Calendar cal = Calendar.getInstance();
	String month_end = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
	String month_start = month_end.substring(0, 7) + "-01";

	int day_of_week = cal.get(Calendar.DAY_OF_WEEK) - 1;
	String week_monday = "";
	String week_sunday = "";
	if (day_of_week == 0) {
		int n = -1;//n为推迟的周数，0本周，-1向前推一周，1下周，依次类推
		cal.add(Calendar.DATE, (n + 1) * 7);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
		week_sunday = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

		cal.add(Calendar.DATE, n * 7);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		week_monday = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
	} else {
		int n = 0;//n为推迟的周数，0本周，-1向前推一周，1下周，依次类推
		cal.add(Calendar.DATE, n * 7);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		week_monday = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

		cal.add(Calendar.DATE, (n + 1) * 7);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
		week_sunday = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">开始日期</td>
							<td class="ali_cdn_input"><input type="text" name="start_date" id="start_date" value="<%=start_date %>" readonly="readonly"  class="input_width"/></td>
						    <td width="50px"><img width="16" height="16" id="cal_button8" style="cursor: hand;" onmouseover="calDateSelector(start_date,cal_button8);" src="<%=contextPath%>/images/calendar.gif" /></td> 
						    
						    <td class="ali_cdn_name">结束日期</td>
							<td class="ali_cdn_input"><input type="text" name="end_date" id="end_date" value="<%=end_date %>" readonly="readonly"  class="input_width"/></td>
						    <td width="50px"><img width="16" height="16" id="cal_button9" style="cursor: hand;" onmouseover="calDateSelector(end_date,cal_button9);" src="<%=contextPath%>/images/calendar.gif" /></td>
							
							<auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
						<!-- 
							<td class="ali_cdn_name"><a onclick="dateRate('week')" id="week" href="javascript:void(0)">周时效分析</a></td>
							<td class="ali_cdn_name"><a onclick="dateRate('month')" id="month" href="javascript:void(0)">月时效分析</a></td>
							<td class="ali_cdn_name"><a onclick="dateRate()" id="month" href="javascript:void(0)">采集时效分析</a></td>
							 -->
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box">
		<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
			<tr>
				<td>
					<report:html name="report1"
					reportFileName="<%=reportFileName %>"
					params="<%=rptParams%>"
					width="-1" 
					height="-1"
					needScroll="no"
					needSaveAsExcel="yes"
					saveAsName="<%=title%>" excelPageStyle="0"/>
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height());
	
	function refreshData(){
		var start_date = document.getElementById("start_date").value;
		var end_date = document.getElementById("end_date").value;
    
		window.location.href='<%=contextPath%>/pm/agingAnalysis/dateRate.jsp?reportFileName=pm/dateRate.raq&title=<%=title%>&start_date='+start_date+'&end_date='+end_date+'&agin_date=<%=agin_date%>';
	}
	function dateRate(type){
		if(type!=null && type =='week'){
			document.getElementById("start_date").value = "<%=week_monday%>";
			document.getElementById("end_date").value = "<%=week_sunday%>";
			refreshData();
		}else if(type!=null && type =='month'){
			document.getElementById("start_date").value = "<%=month_start%>";
			document.getElementById("end_date").value = "<%=month_end%>";
			refreshData();
		}else{
			var querySql = "select case when t.project_start_time is null then t.acquire_start_time else t.project_start_time end start_date,"+
			" case when t.project_end_time is null then t.acquire_end_time else t.project_start_time end end_date"+
			" from gp_task_project t where t.project_info_no ='<%=project_info_no%>' and rownum = 1";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(retObj!=null && retObj.returnCode == '0' && retObj.datas != null && retObj.datas[0] != null){
				document.getElementById("start_date").value = retObj.datas[0].start_date ==null || retObj.datas[0].start_date =='' ?"2010-01-01":retObj.datas[0].start_date;
				document.getElementById("end_date").value = retObj.datas[0].end_date ==null || retObj.datas[0].end_date =='' ?"2015-01-01":retObj.datas[0].end_date;
				refreshData();
			}
		}	
	}
</script>
</body>
</html>