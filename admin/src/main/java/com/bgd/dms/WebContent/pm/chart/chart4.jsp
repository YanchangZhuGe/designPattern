<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
//物探处项目进度统计
	String contextPath=request.getContextPath();
%>
<div id="chart_a12ea7b925408016e0123a15082c8016" style="width:100%; height:100%;"></div>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>	
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

	var retObj = jcdpCallServiceCache("ChartSrv","getGanntData","");
	//myChart1.setXMLUrl("<%=contextPath%>/pm/chart/getGanntData.srq");
	var num = retObj.projectNum;
	//document.getElementById("chart_a12ea7b925408016e0123a15082c8016").style.height=num*100+50;
	var myChart1 = new FusionCharts( "${applicationScope.fusionWidgetsURL}/Charts/Gantt.swf", "myChartId12e1", "100%", num*130+50, "0", "0" );
	myChart1.setXMLData(retObj.Str);
	myChart1.render("chart_a12ea7b925408016e0123a15082c8016");

</script>  
