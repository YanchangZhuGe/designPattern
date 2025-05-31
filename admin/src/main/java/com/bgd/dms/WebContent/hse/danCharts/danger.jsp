<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<div id="tongyong_box" class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">安全隐患情况描述</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer" style="float: left;"></div>   
									<div id="chartContainer3" style="float: right;"></div>   
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">隐患整改信息</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">

						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">各单位安全隐患分布数量</a></div>
						<div class="tongyong_box_content_left" style="height: auto;">
								<div id="chartContainer2"></div>
								<div id="chartContainer4"></div>
						</div>
						</div>
						</td>
					
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
		<td width="1%"></td>
	</tr>
</table>
</div>
<script type="text/javascript">

$("#chartContainer").css("width", "57%");
$("#chartContainer3").css("width", "43%");
var width = $("#tongyong_box").width()*0.13;

	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId1", "100%", "220", "0", "0" );    
	//myChart.setXMLUrl("<%=contextPath%>/hse/danCharts/forth.xml");  
	myChart.setXMLUrl("<%=contextPath%>/hse/chart/queryDanPie.srq?radius="+width);      
	myChart.render("chartContainer");  
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId2", "100%", "220", "0", "0" );    
	//myChart.setXMLUrl("<%=contextPath%>/hse/danCharts/forth.xml");  
	myChart3.setXMLUrl("<%=contextPath%>/hse/chart/queryModPie.srq?radius="+width);      
	myChart3.render("chartContainer3");
  
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn2D.swf", "myChartId3", "100%", "300", "0", "0" );    
	//myChart.setXMLUrl("<%=contextPath%>/hse/danCharts/forth.xml");  
	myChart2.setXMLUrl("<%=contextPath%>/hse/chart/queryDanColumn.srq");      
	myChart2.render("chartContainer2");	
	
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn2D.swf", "myChartId4", "100%", "300", "0", "0" );    
	//myChart.setXMLUrl("<%=contextPath%>/hse/danCharts/forth.xml");  
	myChart4.setXMLUrl("<%=contextPath%>/hse/chart/queryModColumn.srq");      
	myChart4.render("chartContainer4");	
</script>  
</body>
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

