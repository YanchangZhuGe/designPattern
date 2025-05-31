<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<div class="tongyong_box_content_left" id="chart_a11ea7b925408016e0123123082c8123" style="height: 100%">
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
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

var retObj = jcdpCallService("TeamDynamicSrv","getTeamStatistics","startDate=" + startDate + "&endDate="+endDate);
if(retObj.Str != null){
	dataXml = retObj.Str;
}

var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId123", "100%", "100%", "0", "0" );
myChart.setXMLData(dataXml);
myChart.render("chart_a11ea7b925408016e0123123082c8123");

function inBrowse(status,orgId){
	var nowDate = new Date();
	var year = nowDate.getYear();
	var month = nowDate.getMonth()+1;
	var day = nowDate.getDate();
	var endDate = "";
	if(month >= 10){
		endDate = year + "-" + month + "-" + day;
	}else{
		endDate = year + "-0" + month + "-" + day;
	}
	popWindow(getContextPath() + "/pm/projectmgr/teamList.jsp?project_status=" + status + "&endDate=" + endDate + "&affordOrgId="+orgId);
}


</script>  

