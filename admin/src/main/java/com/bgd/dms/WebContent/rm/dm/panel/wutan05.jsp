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
<div id="chart_a048d46f83d343a1b6aa6eaa6d0f442d" style="width:100%;height:100%"/>
<script type="text/javascript">
	//各项目主要设备利用率、完好率统计
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId6", "100%", "250", "0", "0" );    
	var retObj6 = jcdpCallServiceCache("DevCommInfoSrv","getWutanTeamLiyongWanhaoInfosBase","orgstrId=<%=orgstrId%>");
	var xmldata6 = retObj6.xmldata;
	var startindex6 = xmldata6.indexOf("<chart");
	xmldata6 = xmldata6.substr(startindex6);
	myChart5.setXMLData(xmldata6);
	myChart5.render("chart_a048d46f83d343a1b6aa6eaa6d0f442d");
	
	function popWutanWHLYInfos(obj){
		 popWindow('<%=contextPath %>/rm/dm/panel/popWutanWHLYInfosDrill.jsp?code='+obj,'800:600');
	}
</script>
		
</script>  