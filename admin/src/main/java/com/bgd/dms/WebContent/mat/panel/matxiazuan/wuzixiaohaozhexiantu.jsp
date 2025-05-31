<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #cdddef; overflow-y: auto" onload="">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<tr>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">物资消耗折线图</a>
						&nbsp;&nbsp;&nbsp;&nbsp;查询起始日期:&nbsp;<input type="text" id="start_date" name="start_date" class=""   value="" style="width: 80px;height: 12px;" readonly="readonly"/>
				      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_date,tributton1);" />&nbsp;
						至<input type="text" id="end_date" name="end_date" class=""   value="" style="width: 80px;height: 12px;" readonly="readonly"/>
				      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(end_date,tributton2);" />&nbsp;
				      	<button style="height: 24px;" title="查询" onclick="searchByDate()">查询</button>
						
						</div>
						<div class="tongyong_box_content_left" style="height: 100%;">
									<div id="chartContainer5"></div>  
						</div>
						</div>
						</td>
					</tr>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
		<td width="1%"></td>
	</tr>
</table>
</div>
<script type="text/javascript">
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId", "100%", "220", "0", "0" );    
	myChart5.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart18.srq?projectInfoNo=<%=projectInfoNo%>");      
	myChart5.render("chartContainer5");
	
	function searchByDate(){
		var start_date = document.getElementById("start_date").value;
		var end_date = document.getElementById("end_date").value;
		var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId", "100%", "220", "0", "0" );    
		myChart5.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart18.srq?projectInfoNo=<%=projectInfoNo%>&start_date="+start_date+"&end_date="+end_date);      
		myChart5.render("chartContainer5");
	}
	
</script>  
</body>
<script type="text/javascript">
	function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

