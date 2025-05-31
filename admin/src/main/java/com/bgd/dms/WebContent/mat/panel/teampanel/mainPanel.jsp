<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
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
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">各班组物资消耗情况</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer1"></div>  
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">主要物资消耗情况</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer2"></div>   
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
						<tr>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">主要物资消耗占比情况</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer3"></div>  
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">计划与实际消耗对比</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer4"></div>   
						</div>
						</div>
						</td>
					</tr>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">物资材料库存情况</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;overflow: visible;">
						<iframe src="<%=contextPath %>\mat\panel\teampanel\teamwzkc.jsp?projectInfoNo=<%=projectInfoNo %>" marginheight="0" marginwidth="0" style="height:220px;width:100%;"></iframe>
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">物资材料待料情况</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;overflow: visible;">
						<iframe src="<%=contextPath %>\mat\panel\teampanel\teamdlwz.jsp?projectInfoNo=<%=projectInfoNo %>" marginheight="0" marginwidth="0" style="height:220px;width:100%;"></iframe>
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
						<tr>
						<td>
						<div class="tongyong_box">
					<iframe src="<%=contextPath %>/mat/panel/matxiazuan/wuzixiaohaozhexiantuForMainPanel.jsp" marginheight="0" frameborder="0" marginwidth="0" style="height:240px;width:100%;" scrolling="no"></iframe>
						</div>
						</td>
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">主要物资消耗预警</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;overflow: visible;">
						<iframe src="<%=contextPath %>\mat\panel\teampanel\teamwzyj.jsp?projectInfoNo=<%=projectInfoNo %>" marginheight="0" marginwidth="0" style="height:220px;width:100%;"></iframe>
						</div>
						</div>
						</td>
					</tr>
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
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "220", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart4.srq?projectInfoNo=<%=projectInfoNo%>");   
	myChart1.render("chartContainer1"); 
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "ChartId", "100%", "220", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart5.srq?projectInfoNo=<%=projectInfoNo%>");   
	myChart2.render("chartContainer2"); 
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "ChartId", "100%", "220", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart6.srq?projectInfoNo=<%=projectInfoNo%>");   
	myChart3.render("chartContainer3"); 
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "ChartId", "100%", "220", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart7.srq?projectInfoNo=<%=projectInfoNo%>");   
	myChart4.render("chartContainer4"); 
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId", "100%", "220", "0", "0" );    
	myChart5.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart18.srq?projectInfoNo=<%=projectInfoNo%>");      
	myChart5.render("chartContainer5");
	
	
	function searchByDate(){
		var start_date = document.getElementById("start_date").value;
		var end_date = document.getElementById("end_date").value;
		var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId", "100%", "220", "0", "0" );    
		myChart5.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart18.srq?projectInfoNo=<%=projectInfoNo%>&start_date="+start_date+"&end_date="+end_date);      
		myChart5.render("chartContainer5");
	}
</script>  
</body>
<script type="text/javascript">
	function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
	function drillsjxhxh(obj){
		popWindow("<%=contextPath%>/mat/panel/teampanel/teamdlwzxh.jsp?date="+obj+"&projectInfoNo=<%=projectInfoNo%>",'800:600');
		}
	function drillwzbzxh(obj){
		popWindow("<%=contextPath%>/mat/panel/teampanel/teamdlwzbzxh.jsp?date="+obj+"&projectInfoNo=<%=projectInfoNo%>",'1000:750');
		}
	
</script>
</html>

