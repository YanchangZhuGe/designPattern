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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>公司主要设备完好率 利用率统计</title>
</head>
<body style="background: #fff; overflow-y: auto" ><div id="chartContainer1"></div>						 
</body>
<script type="text/javascript">
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId4", "100%", "250", "0", "0" );  
	myChart4.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompDevRatioChartWTNew.srq?orgstrId=<%=orgstrId%>&drilllevel=0");
	myChart4.render("chartContainer1");
	
	function popComWanhaoForMonth(obj){
	    var s_org_id = document.getElementsByName("s_org_id2")[0].value;
	    popWindow('<%=contextPath %>/rm/dm/panel/popComMonthWanhaoLiyongDrill.jsp?monthinfo='+obj , '800:600');
	}
</script>