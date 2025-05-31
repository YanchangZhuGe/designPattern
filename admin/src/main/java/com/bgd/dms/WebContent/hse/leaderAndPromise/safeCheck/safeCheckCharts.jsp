<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%
	String contextPath = request.getContextPath();

	String second = request.getParameter("second");
	String third = request.getParameter("third");
	String fourth = request.getParameter("fourth");
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
     	<div id="chartContainer"></div>
    </div>
    <div id="oper_div">
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
<script type="text/javascript">
var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "300", "0", "0" );  
myChart2.setXMLUrl("<%=contextPath%>/hse/chart/querySafeCheckColumn.srq?second_org=<%=second%>&&third_org=<%=third%>&&fourth_org=<%=fourth%>&&year=<%=year%>&&month=<%=month%>");   
myChart2.render("chartContainer");	
</script>  
</body>
</html>

