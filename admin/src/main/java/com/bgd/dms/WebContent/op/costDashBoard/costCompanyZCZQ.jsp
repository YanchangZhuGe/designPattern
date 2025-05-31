<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String d_month=request.getParameter("d_month");
	String orgId=request.getParameter("orgId");
	orgId=orgId==null?orgId="C105":orgId;
	String projectInfoNo= request.getParameter("projectInfoNo");
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		projectInfoNo=user.getProjectInfoNo();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="getFusionChart()">

	<div class="tongyong_box" style="width:96%; height: 100%; margin: 10px;">
		<div class="tongyong_box_title">
			</span><a href="#">公司周支出同比分析</a><span class="gd"><a href="#"></a> </span>
		</div>
		<div class="tongyong_box_content_left" id="chartContainer2" style="width: 100%; height: 550px;"></div>
	</div>

</body>
<script type="text/javascript">
 function getFusionChart(){
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getCompanyOutcomeWeekInfo.srq?d_month=<%=d_month%>&orgSubjectionId=<%=orgId%>");      
	myChart2.render("chartContainer2");  
}
</script>
</html>

