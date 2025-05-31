<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
	String projectInfoNo=request.getParameter("projectInfoNo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
</head>
<body style="height: 600px">

<div id="chart_c640c8b06d7020ece0430a1508210004" style="width:100%; height:100%; overflow:auto;"></div>   
</body> 
<script type="text/javascript">
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId4", "100%", "100%", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getTeamIncomeWeekInfo.srq?projectInfoNo=<%=projectInfoNo%>");   
	myChart4.render("chart_c640c8b06d7020ece0430a1508210004"); 
	
	function drillxmsrmx(args){
		var projectInfoNo=args.split("-")[0];
		var week=args.split("-")[1];
		var obj=new Object();
		window.showModalDialog("<%=contextPath%>/op/costDashBoard/team12.jsp?projectInfoNo="+projectInfoNo+"&week="+week,obj,"dialogWidth=800px;dialogHeight=600px");
 	}
</script>  
</html>