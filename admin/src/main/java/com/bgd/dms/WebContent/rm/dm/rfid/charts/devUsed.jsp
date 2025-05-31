<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib uri="devselect" prefix="devselect" %>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	
	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>采集站统计分析</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div>
	<div id="chart2">
		<div>年度：
		<select name="chart2year" id="chart2year" style="height: 20px;" onchange="chart2Refresh(this);"></select></div>
		<div id="chart2container"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	
	function getFusionChart(){
		
		//综合利用率
		var year = $("#chart2year").val();
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/ZoomLine.swf", "myChartid2", "100%", "250", "0", "0" );    
		chart2.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDUsedChart.srq?qyear="+year);      
		chart2.render("chart2container");
	}
	
	function chart2Refresh(obj){
		var chartReference = FusionCharts("myChartid2");     
		var year = $("#chart2year").val();
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDUsedChart.srq?qyear="+year);
	}
	function commInitYear(year,_ojb){
		for(var i=parseInt(year)-5;i<=parseInt(year)+5;i++){
			if(i==year){
				_ojb.append($("<option selected='selected'>"+i+"</option>"));
			}else{
				_ojb.append($("<option>"+i+"</option>"));
			}
		}
	}
</script>  
<script type="text/javascript">
	function frameSize() {
		//var width = $(window).width() - 256;
		//$("#tongyong_box_content_left_1").css("width", width);
	}
	//frameSize();

	$(function() {
		var year = '<%=yearinfo%>';
		var _obj2 = $("#chart2year");
		commInitYear(year,_obj2);
		$(window).resize(function() {
			frameSize();
		});
	});
	
</script>
</html>

