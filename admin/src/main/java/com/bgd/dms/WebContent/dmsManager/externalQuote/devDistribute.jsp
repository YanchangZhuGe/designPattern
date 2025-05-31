<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	String devType = request.getParameter("devType");
	String title="";
	if("D002".equals(devType)){
		title="控震源分布分析";
	}
	if("D003".equals(devType)){
		title="钻机分布分析";
	}
	if("D004".equals(devType)){
		title="运输设备分布分析";
	}
	if("D006".equals(devType)){
		title="推土机分布分析";
	}
	String width = request.getParameter("width");
	if(null==width){
		width="950";
	}
	String height = request.getParameter("height");
	if(null==height){
		height="500";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title><%=title%></title>
	</head>
	<body onload="getFusionChart()">
		<div id="chartContainer"></div>
	</body>
	<script type="text/javascript">
		//获取图表
		function getFusionChart(){
			//获取设备分布分析
			getStockFusionChart();
		}
		//获取设备分布分析
		function getStockFusionChart(){
			var chart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart", "<%=width%>", "<%=height%>", "0", "0" );    
			chart.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDistribute.srq?devType=<%=devType%>&display=bigScreen");
			chart.render("chartContainer");
		}
	</script>
</html>

