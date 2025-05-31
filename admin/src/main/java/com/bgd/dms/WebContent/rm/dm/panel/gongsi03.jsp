<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgstrId = user.getOrgId();
%>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_caa538f67dbd90f6e0430a15082c90f6" style="width:100%;height:100%"/>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" );    
		var retObj3 = jcdpCallServiceCache("DevCommInfoSrv","getComXindu","code=<%=orgstrId%>");
		var xmldata = retObj3.xmldata;
		var startindex = xmldata.indexOf("<chart");
		xmldata = xmldata.substr(startindex);
		myChart3.setXMLData(xmldata);
		myChart3.render("chart_caa538f67dbd90f6e0430a15082c90f6"); 
	function popComxinduDisdrill(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popComXinduDisDrill.jsp?code='+obj,'800:600');
	}
</script>
