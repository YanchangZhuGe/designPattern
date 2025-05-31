<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String orgId = user.getSubOrgIDofAffordOrg();
String orgstrId = user.getOrgId();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_caaa9d806638e084e0430a15082ce084" style="width:100%;height:100%"/>
<script type="text/javascript">
	//各项目采集设备投入统计
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId5", "100%", "250", "0", "0" );    
	var retObj4 = jcdpCallServiceCache("DevCommInfoSrv","getWutanTeamCaijiDevInfosBase","orgstrId=<%=orgstrId%>");
	var xmldata4 = retObj4.xmldata;
	var startindex4 = xmldata4.indexOf("<chart");
	xmldata4 = xmldata4.substr(startindex4);
	myChart4.setXMLData(xmldata4);
	myChart4.render("chart_caaa9d806638e084e0430a15082ce084");
	
	function popWutanTeamProCaijiDevInfos(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanTeamProCaijiDevInfos.jsp?code='+obj,'800:600');
	}
</script>
		
</script>  