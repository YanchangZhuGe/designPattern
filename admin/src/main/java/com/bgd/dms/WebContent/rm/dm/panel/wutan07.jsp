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
<div id="chart_5e68cb9346524ab0b5fa1cedbccf24f0" style="width:100%;height:100%"/>
<script type="text/javascript">
	//新度系数(物探处)
	var myChart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId7", "100%", "250", "0", "0" );    
	myChart6.setXMLUrl("<%=contextPath%>/cache/rm/dm/getComXindu.srq?orgstrId=<%=orgstrId%>&drillLevel=1");
	myChart6.render("chart_5e68cb9346524ab0b5fa1cedbccf24f0");
	function popWutanxinduDisdrill(obj){
		alert(1111)
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanXinduDisDrill.jsp?code='+obj,'800:600');
	}
</script>
