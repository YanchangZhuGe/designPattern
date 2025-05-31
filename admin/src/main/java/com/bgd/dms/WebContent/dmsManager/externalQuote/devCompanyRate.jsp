<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	String width = request.getParameter("width");
	if(null==width){
		width="630";
	}
	String height = request.getParameter("height");
	if(null==height){
		height="1035";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" /> 
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>公司设备占比</title>
	</head>
	<body onload="getFusionChart()">
		<div id="chartContainer1"></div>
	</body>
	<script type="text/javascript">
		//获取图表
		function getFusionChart(){
			//野外采集单位资产占比
			getFieldCaptialFusionChart();
			
		}
		//野外采集单位资产占比
		function getFieldCaptialFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart1", "<%=width%>", "<%=height%>", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDeviceCompanyRate.srq?display=bigScreen");
			chart1.render("chartContainer1");
		}
	</script>
</html>

