<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String multiProjectFlag = request.getParameter("multiProjectFlag");	// multiProjectFlag 多项目入口标记,为1时表示多项目菜单入口,为0是但项目菜单入口 
	String projectType = user.getProjectType();
	String orgSubId=user.getOrgSubjectionId();
	if( multiProjectFlag != null && !"".equals(multiProjectFlag) && "1".equals(multiProjectFlag)){
		projectType = request.getParameter("projectType");
	}
	/* if(orgSubId.startsWith("C105007")){
		response.sendRedirect(contextPath+"/pm/chart/dg/pmChartFrame.jsp");
		 return;
	} */

	if("5000100004000000008".equals(projectType)){
		response.sendRedirect(contextPath+"/pm/chart/wsChartFrame.jsp");
		//response.sendRedirect(contextPath+"/pm/dailyReport/singleProject/wt/wtIndex.jsp");

	}
	
	else if("5000100004000000006".equals(projectType)){
		//深海
		response.sendRedirect(contextPath+"/pm/chart/sh/pmChartFrame.jsp");
	}
	
	else if("5000100004000000009".equals(projectType)){
		//综合物化探
		response.sendRedirect(contextPath+"/pm/chart/wt/pmChartFrameWt.jsp");
	}
    
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
    	projectInfoNo = user.getProjectInfoNo();
	}
    WorkMethodSrv wm = new WorkMethodSrv();
	String 	buildMethod = wm.getProjectExcitationMode(projectInfoNo);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>	
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="initPageBody()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		
			<tr id="tr_measure">
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">测量日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">测量累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
					<tr><td colspan="3"><div class="tongyong_box">
						<div class="tongyong_box_content_left"  id="chartInfo2" style="height: 25px;">
					</div></div></td></tr>
				</table>
				</td>
			</tr>
			
			<tr id="tr_drill">
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">钻井日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer3" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%">
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">钻井累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
					<tr><td colspan="3"><div class="tongyong_box">
						<div class="tongyong_box_content_left" id="chartInfo4" style="height: 25px;">
					</div></div></td></tr>
				</table>
				</td>
			</tr>
			
			<tr id="tr_collection">
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">采集日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer5" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">采集累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer6" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
					<tr><td colspan="3"><div class="tongyong_box">
						<div class="tongyong_box_content_left"  id="chartInfo6" style="height: 25px;">
					</div></div></td></tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var projectInfoNo = "<%=projectInfoNo%>";
var buildMethod = "<%=buildMethod%>";

function initPageBody(){	//根据项目类型初始化页面显示内容
	var projectType="<%=projectType%>"; 	
	if( !strIsNullOrEmpty(projectType) )
	{
		if( projectType=="5000100004000000001")	 // 陆地项目
		{
		}
		else if( projectType=="5000100004000000002" || projectType=="5000100004000000010")	// 浅海项目和滩浅海地震项目
		{ 
			/* //删除测量分析数据行
			var tr_measure = document.getElementById("tr_measure");
			tr_measure.parentNode.removeChild(tr_measure);
			
			//删除钻井分析数据行
			var tr_drill = document.getElementById("tr_drill");
			tr_drill.parentNode.removeChild(tr_drill); */
		}
		else if( projectType=="5000100004000000003")	// 非地震项目
		{ 
		}
		else if( projectType=="5000100004000000004")	// ××项目
		{ 
		}
		else if( projectType=="5000100004000000005")	// 地震项目
		{ 
		}
		else if( projectType=="5000100004000000006")	 // 深海项目
		{ 
			//删除测量分析数据行
			var tr_measure = document.getElementById("tr_measure");
			tr_measure.parentNode.removeChild(tr_measure);
		}
		else if( projectType=="5000100004000000007")	// 陆地和浅海项目
		{ 
		}
		else if( projectType=="5000100004000000008")	// 井中地震项目
		{ 
		}
		else if( projectType=="5000100004000000009")	// 综合物化探项目
		{
		}
	}
	getFusionChart();
}

function getFusionChart(){
	
	if(buildMethod == "5000100003000000001" || buildMethod == "5000100003000000004" || buildMethod == "5000100003000000005" || buildMethod == "5000100003000000007"){
		var retObj3 = jcdpCallServiceCache("DailyReportAnalysisSrv","getDailyActivity","type=drilldailylist&project_info_no="+projectInfoNo);
		var drillDataXml = retObj3.xmlData;
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "100%", "0", "0" );    
		myChart3.setXMLData(drillDataXml);
		myChart3.render("chartContainer3");
		//var chatInfo3 = retObj3.chatInfo;
		//document.getElementById("chartInfo3").innerHTML = chatInfo3;
		
		var retObj4 = jcdpCallServiceCache("DailyReportAnalysisSrv","getDaysCumulative","type=drilldailylist&projectInfoNo="+projectInfoNo);
		var drillXml = retObj4.xmlData;
		var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId4", "100%", "100%", "0", "0" );    
		myChart4.setXMLData(drillXml);
		myChart4.render("chartContainer4");
		var chatInfo4 = retObj4.chatInfo;
		if(chatInfo4 == undefined){
			chatInfo4 = "";
		}
		if(chatInfo4!=null && chatInfo4.length > 100){
			chatInfo4 = "&nbsp;&nbsp;&nbsp;&nbsp;" + chatInfo4;
			document.getElementById("chartInfo4").style.height= 40;
			document.getElementById("chartInfo4").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%" align="left">'+chatInfo4+'</td><td width="5%"></td></tr><table>';
		}else{
			document.getElementById("chartInfo4").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%">'+chatInfo4+'</td><td width="5%"></td></tr><table>';
		}
		
	}else{
		//删除钻井分析数据行
		var line = document.getElementById("tr_drill");
		line.parentNode.removeChild(line);
	}
	var retObj1 = jcdpCallServiceCache("DailyReportAnalysisSrv","getDailyActivity","type=measuredailylist&project_info_no="+projectInfoNo);
	var measureDataXml = retObj1.xmlData;
	//var chatInfo1 = retObj1.chatInfo;
	//document.getElementById("chartInfo1").innerHTML = chatInfo1;
	
	var retObj5 = jcdpCallServiceCache("DailyReportAnalysisSrv","getDailyActivity","type=colldailylist&project_info_no="+projectInfoNo);
	var collDataXml = retObj5.xmlData;
	//var chatInfo5 = retObj5.chatInfo;
	//document.getElementById("chartInfo5").innerHTML = chatInfo5;
	
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLData(measureDataXml);
	myChart1.render("chartContainer1");
	
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId5", "100%", "100%", "0", "0" );    
	myChart5.setXMLData(collDataXml);
	myChart5.render("chartContainer5");
	
	if(buildMethod == "5000100003000000001" || buildMethod == "5000100003000000004" || buildMethod == "5000100003000000005" || buildMethod == "5000100003000000007"){
		
	}
	
	var retObj2 = jcdpCallServiceCache("DailyReportAnalysisSrv","getDaysCumulative","type=measuredailylist&projectInfoNo="+projectInfoNo);
	var measureXml = retObj2.xmlData;
	var chatInfo2 = retObj2.chatInfo;
	if(chatInfo2 == undefined){
		chatInfo2 = "";
	}
	if(chatInfo2!=null && chatInfo2.length > 100){
		chatInfo2 = "&nbsp;&nbsp;&nbsp;&nbsp;" + chatInfo2;
		document.getElementById("chartInfo2").style.height= 40;
		document.getElementById("chartInfo2").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%" align="left">'+chatInfo2+'</td><td width="5%"></td></tr><table>';
	}else{
		document.getElementById("chartInfo2").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%">'+chatInfo2+'</td><td width="5%"></td></tr><table>';
	}
	var retObj6 = jcdpCallServiceCache("DailyReportAnalysisSrv","getDaysCumulative","type=colldailylist&projectInfoNo="+projectInfoNo);
	var collXml = retObj6.xmlData;
	var chatInfo6 = retObj6.chatInfo;
	
	if(chatInfo6 == undefined){
		chatInfo6 = "";
	}
	if(chatInfo6!=null && chatInfo6.length > 100){
		chatInfo6 = "&nbsp;&nbsp;&nbsp;&nbsp;" + chatInfo6;
		document.getElementById("chartInfo6").style.height= 40;
		document.getElementById("chartInfo6").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%" align="left">'+chatInfo6+'</td><td width="5%"></td></tr><table>';
	}else{
		document.getElementById("chartInfo6").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%">'+chatInfo6+'</td><td width="5%"></td></tr><table>';
	}
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart2.setXMLData(measureXml);
	myChart2.render("chartContainer2");
	
	var myChart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId6", "100%", "100%", "0", "0" );    
	myChart6.setXMLData(collXml);
	myChart6.render("chartContainer6");
}
</script>
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

