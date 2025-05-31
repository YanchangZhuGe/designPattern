<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId=user.getSubOrgIDofAffordOrg();
	String projectInfoNo= request.getParameter("projectInfoNo");
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		projectInfoNo=user.getProjectInfoNo();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>	
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
	<div id="list_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="49%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">

													</span><a href="#">采集月度支出同比折线图</a><span class="gd"><a href="#"></a> </span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer1" style="height: 230px;"></div>
											</div>
										</td>
										<td width="1%"></td>
										<td width="49%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">

													</span><a href="#">国际/国内采集支出对比图</a><span class="gd"><a href="#"></a> </span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer2" style="height: 230px;"></div>
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
										<td width="100%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">

													</span><a href="#">各物探处总采集支出对比图</a><span class="gd"><a href="#"></a> </span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer3" style="height: 230px;"></div>
											</div>
										</td>
									</tr>
								</table>
							</td>
							<td width="1%"></td>
						</tr>
					</table>
	</div>
</body>
<script type="text/javascript">
 function getFusionChart(){
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getOutcomeCompareYearInfo.srq");      
	myChart1.render("chartContainer1");  
	
	
	
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId8", "100%", "100%", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getCompanyCompareCountryOutInfo.srq");      
	myChart2.render("chartContainer2"); 
	
	
	 
	 var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId5", "100%", "100%", "0", "0" );    
	 myChart3.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getCompanyOutcomeCompareSectionInfo.srq");   
	 myChart3.render("chartContainer3");  
	
	 
}
 function drillxmzc(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/costSectionZCZQ.jsp?orgId="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
	 }
 function drillwtzc(obj){
		if(obj=='0'){
			  window.showModalDialog("<%=contextPath%>/op/costDashBoard/company5table.jsp?orgId=C105002",obj,"dialogWidth=800px;dialogHeight=600px");
		 }else{
			 window.showModalDialog("<%=contextPath%>/op/costDashBoard/company5.jsp?gjb=0",obj,"dialogWidth=800px;dialogHeight=600px");
		 } 	
	}
 function drillgszc(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/costCompanyZCZQ.jsp?d_month="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
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

