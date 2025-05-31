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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_6b91ed8ba18c4aa0909e8ef2ab905031" style="width:100%;height:100%"/>
<script type="text/javascript">
	//各项目主要设备投入统计
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId4", "100%", "250", "0", "0" );    
	var retObj5 = jcdpCallServiceCache("DevCommInfoSrv","getWutanTeamProDevInfosBase","orgstrId=<%=orgstrId%>");
	var xmldata5 = retObj5.xmldata;
	var startindex5 = xmldata5.indexOf("<chart");
	xmldata5 = xmldata5.substr(startindex5);
	myChart3.setXMLData(xmldata5);
	myChart3.render("chart_6b91ed8ba18c4aa0909e8ef2ab905031");
	
	function popWutanTeamProDevInfos(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanTeamProDevInfos.jsp?code='+obj,'800:600');
	}
</script>
