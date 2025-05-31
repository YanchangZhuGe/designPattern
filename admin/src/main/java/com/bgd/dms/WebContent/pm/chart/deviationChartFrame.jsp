<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.chart.ChartSrv"%>
<%
	String contextPath=request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo(); 
	}
 
	 ChartSrv  CtSrv=new ChartSrv();
	String orgSubId= CtSrv.getOrgData(projectInfoNo);
	
	
	 if(orgSubId.startsWith("C105007")){
		response.sendRedirect(contextPath+"/pm/chart/dg/deviationChartFrame.jsp");
		 return;
	} 

	if(user.getProjectType().equals("5000100004000000008") || user.getProjectType().equals("5000100004000000002")){
		

		
		response.sendRedirect(contextPath+"/pm/chart/wsDeviationChartFrame.jsp");
	}
	
		 //request.getRequestDispatcher("p3.jsp").forward(request,response);
	
	
	String projectType = user.getProjectType();//项目类型
	//projectType="5000100004000000006";//测试
	if("5000100004000000006".equals(projectType)){
		//深海
		response.sendRedirect(contextPath+"/pm/chart/sh/deviationChartFrame.jsp");
	}else if("5000100004000000009".equals(projectType)){
		//综合物化探
		response.sendRedirect(contextPath+"/pm/chart/wt/deviationChartFrameWt.jsp");
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
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
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
				<table width="99%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">偏离度</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 300px;">
			 
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="99%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100%" align="center">
							<table width="100%" border="1" cellspacing="0" cellpadding="0">
								<tr class="bt_info">
									<td class="tableHeader">工序</td>
									<td class="tableHeader">计量单位</td>
									<td class="tableHeader" >施工状态</td>
									<td class="tableHeader">施工线束</td>
									<td class="tableHeader" >设计工作量</td>
									<td class="tableHeader" >累积完成</td>
									<td class="tableHeader" >实际完成百分比(%)</td>
									<td class="tableHeader" >计划偏离度(%)</td>
									<td class="tableHeader">实际开始日期</td>
									<td class="tableHeader" >计划开始日期</td>
									<td class="tableHeader">实际完成日期</td>
									<td class="tableHeader" >计划完成日期</td>
								</tr>
								
								<tr class="odd" height="25px" id="trMeasure">
									<td>测量</td>
									<td>(平方)公里数(km)</td>
									<td id="tdStatus1"></td>
									<td id="tdGroupLine1"></td>
									<td id="tdDesignWorkLoad1"></td>
									<td id="tdDailyWorkLoad1"></td>
									<td id="tdFinishPercentage1"></td>
									<td id="tdDeviation1"></td>
									<td id="tdStartDate1"></td>
									<td id="minDesignDate1"></td>
									<td id="tdDate1"></td>
									<td id="designDate1"></td>
								</tr>
								
								<tr class="even" height="25px" id="trDrill">
									<td>钻井</td>
									<td>点数(个)</td>
									<td id="tdStatus2"></td>
									<td id="tdGroupLine2"></td>
									<td id="tdDesignWorkLoad2"></td>
									<td id="tdDailyWorkLoad2"></td>
									<td id="tdFinishPercentage2"></td>
									<td id="tdDeviation2"></td>
									<td id="tdStartDate2"></td>
									<td id="minDesignDate2"></td>
									<td id="tdDate2"></td>
									<td id="designDate2"></td>
								</tr>
								
								<tr class="odd" height="25px" id="trCollection">
									<td>采集</td>
									<td>炮点数(个)</td>
									<td id="tdStatus3"></td>
									<td id="tdGroupLine3"></td>
									<td id="tdDesignWorkLoad3"></td>
									<td id="tdDailyWorkLoad3"></td>
									<td id="tdFinishPercentage3"></td>
									<td id="tdDeviation3"></td>
									<td id="tdStartDate3"></td>
									<td id="minDesignDate3"></td>
									<td id="tdDate3"></td>
									<td id="designDate3"></td>
								</tr>
							</table>
							</br>
						</td>
					</tr>
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

function initPageBody(){	//根据项目类型初始化页面显示内容
	var projectType="<%=user.getProjectType()%>"; 
	if( !strIsNullOrEmpty(projectType) )
	{
		if( projectType=="5000100004000000001")	 // 陆地项目
		{
		}
		else if( projectType=="5000100004000000002" || projectType=="5000100004000000010")	// 浅海项目和滩浅海地震项目
		{ 
			//删除测量数据行
			var trMeasure = document.getElementById("trMeasure");
			trMeasure.parentNode.removeChild(trMeasure);
			
			//删除钻井数据行
			var trDrill = document.getElementById("trDrill");
			trDrill.parentNode.removeChild(trDrill);
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

	//var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );    
	//myChart1.setXMLUrl("<%=contextPath%>/pm/chart/getDeviation.srq?type=measuredailylist");
	//myChart1.render("chartContainer1");
	
	//var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "100%", "0", "0" );    
	//myChart2.setXMLUrl("<%=contextPath%>/pm/chart/getDeviation.srq?type=drilldailylist");
	//myChart2.render("chartContainer2");
	
	//var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "100%", "0", "0" );    
	//myChart3.setXMLUrl("<%=contextPath%>/pm/chart/getDeviation.srq?type=colldailylist");
	//myChart3.render("chartContainer3");
	
	//var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId4", "100%", "100%", "0", "0" );    
	//myChart4.setXMLUrl("<%=contextPath%>/pm/chart/getDeviation.srq?type=surfacedailylist");
	//myChart4.render("chartContainer4");
	
	var retObj = jcdpCallServiceCache("ChartSrv","getDeviation","projectInfoNo=<%=projectInfoNo %>");
	var dataXml = retObj.Str;
	var existDrillData = retObj.existDrillData;
	var gridData = retObj.gridData;
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLData(dataXml);
	myChart1.render("chartContainer1");

	if(gridData != null){
		for(var i=0; i< gridData.length; i++){
			var record = gridData[i];
			var lineNum = i + 1;
			document.getElementById("tdStatus" + lineNum).innerHTML = record.status;
			document.getElementById("tdGroupLine" + lineNum).innerHTML = record.groupLine;
			document.getElementById("tdDesignWorkLoad" + lineNum).innerHTML = record.designWorkLoad;
			document.getElementById("tdDailyWorkLoad" + lineNum).innerHTML = record.dailyWorkLoad;
			document.getElementById("tdFinishPercentage" + lineNum).innerHTML = record.finishPercentage;
			document.getElementById("tdDeviation" + lineNum).innerHTML = record.deviation;
			document.getElementById("tdStartDate" + lineNum).innerHTML = record.startDate;
			document.getElementById("minDesignDate" + lineNum).innerHTML = record.minDesignDate;
			document.getElementById("tdDate" + lineNum).innerHTML = record.date;
			document.getElementById("designDate" + lineNum).innerHTML = record.designDate;
		}
	}
	if(existDrillData == "no"){
		//document.getElementById("trDrill").style.display = "none";
		var line = document.getElementById("trDrill");
		line.parentNode.removeChild(line);
	}
}
 
 function myJs(myVar){
	 alert(myVar);
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

