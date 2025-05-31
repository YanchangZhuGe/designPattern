<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String code = request.getParameter("code");
	String title="";
	if("D001".equals(code)){
		title="地震仪器存量分析";
	}
	if("D002".equals(code)){
		title="可控震源存量分析";
	}
	if("D003".equals(code)){
		title="钻机存量分析";
	}
	if("D004".equals(code)){
		title="运输设备存量分析";
	}
	if("D005".equals(code)){
		title="检波器存量分析";
	}
	if("D006".equals(code)){
		title="推土机存量分析";
	}
	String width = request.getParameter("width");
	if(null==width){
		width="630";
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
			//获取设备存量分析
			getStockFusionChart();
		}
		//获取设备存量分析
		function getStockFusionChart(){
			var chart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart", "<%=width%>", "<%=height%>", "0", "0" );    
			chart.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=<%=code%>&display=bigScreen");
			chart.render("chartContainer");
		}
	</script>
</html>

