<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>公司地震仪器动态情况</title>
</head>
<body style="background: #fff; overflow-y: auto" ><div id="chartContainer1"></div>						 
</body>
<script type="text/javascript">
		var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "myChartId1", "100%", "250", "0", "0" );
		myChart2.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompEqChart.srq");    
		myChart2.render("chartContainer1"); 
		function popzaiyongdrill(obj){
			//popWindow('<%=contextPath %>/rm/dm/panel/popChartOfEqZaiyongChartDrill.jsp?code='+obj,'800:600');
			//window.open("<%=contextPath %>/rm/dm/panel/popChartOfEqZaiyongChartDrill.jsp?code="+obj,"","height=350,width=800,top=120,location=no");
			window.showModalDialog("<%=contextPath%>/rm/dm/panel/popChartOfEqZaiyongChartDrill.jsp?code="+obj,"","dialogWidth=800px;dialogHeight=350px");
		}
		function popxianzhidrill(obj){
			//popWindow('<%=contextPath %>/rm/dm/panel/popChartOfEqXianzhiChartDrill.jsp?code='+obj,'800:600');
			//window.open("<%=contextPath %>/rm/dm/panel/popChartOfEqXianzhiChartDrill.jsp?code="+obj,"","height=350,width=800,top=120,location=no");
			window.showModalDialog("<%=contextPath%>/rm/dm/panel/popChartOfEqXianzhiChartDrill.jsp?code="+obj,"","dialogWidth=800px;dialogHeight=350px");
		}
</script>