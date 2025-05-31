<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
//公司队伍动用率
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<div class="tongyong_box_content_left" id="chart_a11ea45625408016e0123123082c8016" style="height: 100%">
<script type="text/javascript">

var nowDate = new Date();
var year = nowDate.getFullYear();
var month = nowDate.getMonth()+1;
var day = nowDate.getDate();
var startDate = year + "-01-01";
var endDate = "";
if(month >= 10){
	endDate = year + "-" + month + "-" + day;
}else{
	endDate = year + "-0" + month + "-" + day;
}

var retObj = jcdpCallServiceCache("TeamDynamicSrv","getTeamStatistics","startDate=" + startDate + "&endDate="+endDate);
if(retObj.Str3 != null){
	dataXml = retObj.Str3;
}

var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId123", "100%", "100%", "0", "0" );
myChart.setXMLData(dataXml);
myChart.render("chart_a11ea45625408016e0123123082c8016");



</script>  

