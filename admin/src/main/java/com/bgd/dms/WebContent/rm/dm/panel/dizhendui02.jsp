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
<div id="chart_caaa9d80663ae084e0430a15082ce084" style="width:100%;height:100%">
</div>

<script type="text/javascript">
	var retObj2 = jcdpCallServiceCache("EarthquakeTeamStatistics","getCollEqSumStatistics","projectInfoNo=<%=projectInfoNo%>&drillLevel=2");
	var dataXml2 = retObj2.dataXML;
	var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart2.setXMLData(dataXml2);
	myChart2.render("chart_caaa9d80663ae084e0430a15082ce084");
	
	function popCollEqStaticinfo(obj){
		//�ĳ�pop��������ʽ
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDCollEqStaticinfo.jsp?code='+obj,'800:600');
	}
</script>
