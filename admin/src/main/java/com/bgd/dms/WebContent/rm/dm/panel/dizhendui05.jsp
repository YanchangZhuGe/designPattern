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
	//单机燃油消耗统计
	var retObj2 = jcdpCallServiceCache("DevCommInfoSrv","getRyCostData","projectInfoNo=<%=projectInfoNo%>");
	var dataXml2 = retObj2.dataXML;
	var myChart1 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart1.setXMLData(dataXml2);
	myChart1.render("chart_caaa9d806639e084e0430a15082ce084");
	
	function drillryxh(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDRYCostInfos.jsp?code='+obj,'800:600');
	}
</script>
