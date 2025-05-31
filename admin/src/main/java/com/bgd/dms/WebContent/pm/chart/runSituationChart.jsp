<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<div style="height: 100%;width: 100%;overflow: hidden;">
<table width="100%"  align="center">
	<tr>
     <td width="20%"><div id="chart_c63ea7b925412316e0123a15082c8016" align="right" style="width:100%; height:100%; overflow:auto;"></div></td>
     <td width="80%"><div id="chart_c63ea7b925412416e0123a15082c8016" align="left" style="width:100%; height:100%; overflow:auto;"></div></td>
   </tr>
</table>
</div>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';

var nowDate = new Date();
var year = nowDate.getFullYear();
var month = nowDate.getMonth()+1;
var day = nowDate.getDate();
var date1 = year + "-01-01";
var date2 = "";
if(month >= 10){
	date2 = year + "-" + month + "-" + day;
}else{
	date2 = year + "-0" + month + "-" + day;
}
var retObj = jcdpCallServiceCache("ProjectDynamicSrv","getProjectSiuation","curDate="+date2+"&startDate=" + date1 + "&endDate="+date2);
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId1", "100%", "100%", "0", "0" );
	myChart1.setXMLData(retObj.Str1);
	myChart1.render("chart_c63ea7b925412316e0123a15082c8016");
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId2", "100%", "100%", "0", "0" );
	myChart2.setXMLData(retObj.Str2);
	myChart2.render("chart_c63ea7b925412416e0123a15082c8016");

function inBrowse(orgId){
	popWindow(getContextPath() + "/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=yearProjectStat1&noLogin=admin&tokenId=admin&orgSubjectionId="+orgId);
}

</script>

