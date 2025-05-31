<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String orgId = user.getSubOrgIDofAffordOrg();
String orgstrId = user.getCodeAffordOrgID();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_5e68cb9346524ab0b5fa1cedbccf24f0" style="width:100%;height:100%"/>
<script type="text/javascript">
	//各项目主要设备主要费用统计
	var myChart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId7", "100%", "250", "0", "0" );    
	var retObj5 = jcdpCallServiceCache("DevCommInfoSrv","getWutanTeamCostInfosBase","orgstrId=<%=orgstrId%>");
	var xmldata5 = retObj5.xmldata;
	var startindex5 = xmldata5.indexOf("<chart");
	xmldata5 = xmldata5.substr(startindex5);
	myChart6.setXMLData(xmldata5);
	myChart6.render("chart_5e68cb9346524ab0b5fa1cedbccf24f0");
	function popWutanTeamCostInfos(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanTeamCLCostInfos.jsp?code='+obj,'800:600');
	}
</script>
		
</script>  