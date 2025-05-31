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
	<div id="chart6">
		<div>
		年度：<select name="chart6year" id="chart6year" style="height: 20px;" onchange="chart6Refresh(this);"></select>
		设备类型：<devselect:typelist style="height: 20px;" id="chart6type" name="chart6type" cssClass="" selectonchange="chart6Refresh(this);"></devselect:typelist></div>
		<div id="chart6container"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	
	function getFusionChart(){
		
		//维修类型
		var year = $("#chart6year").val();
		var type = $("#chart6type").val();
		var chart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartid6", "100%", "250", "0", "0" );    
		chart6.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDDevRepairTypeChart.srq?qyear="+year+"&qtype="+type);      
		chart6.render("chart6container");
	}
	function chart6Refresh(obj){
		var chartReference = FusionCharts("myChartid6");     
		var year = $("#chart6year").val();
		var type = $("#chart6type").val();
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDDevRepairTypeChart.srq?qyear="+year+"&qtype="+type);
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
		var _obj6 = $("#chart6year");
		commInitYear(year,_obj6);
		$(window).resize(function() {
			frameSize();
		});
	});
	
</script>
</html>

