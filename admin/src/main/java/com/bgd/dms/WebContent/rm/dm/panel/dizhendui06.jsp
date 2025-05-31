<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String orgId = user.getSubOrgIDofAffordOrg();
String projectInfoNo = user.getProjectInfoNo();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_caaa9d806639e084e0430a15082ce084" style="width:100%;height:100%"/>
<script type="text/javascript">
	//设备单机材料消耗统计
	var retObj3 = jcdpCallServiceCache("DevCommInfoSrv","getClCostData","projectInfoNo=<%=projectInfoNo%>");
	var dataXml3 = retObj3.dataXML;
	var myChart3 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" );    
	myChart3.setXMLData(dataXml3);
	myChart3.render("chart_caaa9d806639e084e0430a15082ce084");
	function drilldown(obj){
		//改成pop形式
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDCLCostInfos.jsp?code='+obj,'800:600');
	}
</script>
		
</script>  