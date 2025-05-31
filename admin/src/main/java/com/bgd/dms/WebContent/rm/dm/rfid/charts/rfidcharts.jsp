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
	<div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="50%">
					<div id="chart5" class="tongyong_box">
						<div class="tongyong_box_title">采集站投产年限统计&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						设备类型：<devselect:typelist style="height: 20px;" id="chart5type" name="chart5type" cssClass="" selectonchange="chart5Refresh(this);"></devselect:typelist></select></div>
						<div id="chart5container" class="tongyong_box_content" style="height: 250px;"></div>
					</div>
				</td>
				<td width="50%">
					<div id="chart6" class="tongyong_box">
						<div class="tongyong_box_title">采集站损坏率分析&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						年度：<select name="chart6year" id="chart6year" style="height: 20px;" onchange="chart6Refresh(this);"></select>
						设备类型：<devselect:typelist style="height: 20px;" id="chart6type" name="chart6type" cssClass="" selectonchange="chart6Refresh(this);"></devselect:typelist></div>
						<div id="chart6container" class="tongyong_box_content" style="height: 250px;"></div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="chart1" class="tongyong_box">
		<div class="tongyong_box_title">采集站使用情况&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="chart1year" id="chart1year" style="height: 20px;" onchange="chart1Refresh(this);"></select>
		</div>
		<div id="chart1container" class="tongyong_box_content" style="height: 250px;"></div>
	</div>
	<div id="chart2" class="tongyong_box">
		<div class="tongyong_box_title">采集站综合利用率分析&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="chart2year" id="chart2year" style="height: 20px;" onchange="chart2Refresh(this);"></select></div>
		<div id="chart2container" class="tongyong_box_content" style="height: 250px;"></div>
	</div>
	<div id="chart3" class="tongyong_box">
		<div class="tongyong_box_title">采集站综合完好率分析&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="chart3year" id="chart3year" style="height: 20px;" onchange="chart3Refresh(this);"></select></div>
		<div id="chart3container" class="tongyong_box_content" style="height: 250px;"></div>
	</div>
	<div id="chart4" class="tongyong_box">
		<div class="tongyong_box_title">采集站损坏率分析&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="chart4year" id="chart4year" style="height: 20px;" onchange="chart4Refresh(this);"></select></div>
		<div id="chart4container" class="tongyong_box_content" style="height: 250px;"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	
	function getFusionChart(){
		//使用情况
		var year = $("#chart1year").val();
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "myChartid1", "100%", "250", "0", "0" );    
		chart1.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDUsingChart.srq?qyear="+year);      
		chart1.render("chart1container");
		
		//综合利用率
		var year = $("#chart2year").val();
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/ZoomLine.swf", "myChartid2", "100%", "250", "0", "0" );    
		chart2.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDUsedChart.srq?qyear="+year);      
		chart2.render("chart2container");
		
		//综合完好率
		var year = $("#chart3year").val();
		var chart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/ZoomLine.swf", "myChartid3", "100%", "250", "0", "0" );    
		chart3.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDGoodChart.srq?qyear="+year);      
		chart3.render("chart3container");
		
		//损坏率率
		var year = $("#chart4year").val();
		var chart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "myChartid4", "100%", "250", "0", "0" );    
		chart4.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDDestoryChart.srq?qyear="+year);      
		chart4.render("chart4container");
		
		//投产年限
		var type = $("#chart5type").val();
		var chart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartid5", "100%", "250", "0", "0" );    
		chart5.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDDevAgeChart.srq?qtype="+type);      
		chart5.render("chart5container");
		
		//维修类型
		var year = $("#chart6year").val();
		var type = $("#chart6type").val();
		var chart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartid6", "100%", "250", "0", "0" );    
		chart6.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDDevRepairTypeChart.srq?qyear="+year+"&qtype="+type);      
		chart6.render("chart6container");
	}
	
	function chart2Refresh(obj){
		var chartReference = FusionCharts("myChartid2");     
		var year = $("#chart2year").val();
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDUsedChart.srq?qyear="+year);
	}
	function chart1Refresh(obj){
		var chartReference = FusionCharts("myChartid1");     
		var year = $("#chart1year").val();
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDUsingChart.srq?qyear="+year);
	}
	function chart3Refresh(obj){
		var chartReference = FusionCharts("myChartid3");     
		var year = $("#chart3year").val();
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDGoodChart.srq?qyear="+year);
	}
	function chart4Refresh(obj){
		var chartReference = FusionCharts("myChartid4");     
		var year = $("#chart4year").val();
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDDestoryChart.srq?qyear="+year);
	}
	function chart5Refresh(obj){
		var chartReference = FusionCharts("myChartid5");     
		var year = $("#chart5type").val();
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getRFIDDevAgeChart.srq?qtype="+year);
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
		var _obj1 = $("#chart1year");
		commInitYear(year,_obj1);
		var _obj2 = $("#chart2year");
		commInitYear(year,_obj2);
		var _obj3 = $("#chart3year");
		commInitYear(year,_obj3);
		var _obj4 = $("#chart4year");
		commInitYear(year,_obj4);
		var _obj6 = $("#chart6year");
		commInitYear(year,_obj6);
		$(window).resize(function() {
			frameSize();
		});
	});
	
</script>
</html>

