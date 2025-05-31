<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userOrgSubjectionId=user.getOrgSubjectionId();
	String orgId=request.getParameter("orgId");
	if(orgId==null||"".equals(orgId)){
		orgId="C105";
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
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart('<%=orgId%>')">
	<div id="list_content">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="/images/list_13.png" width="6" height="36" /></td>
			    <td background="/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="8%" >&nbsp;&nbsp;&nbsp;物探处:</td>
					    <td width="5%" class="ali1">
							 <select name="s_org_id" id="s_org_id" style="width:220px" onchange="changeOrg()">
									<option value="">--请选择--</option>
									<option value="C105002">国际勘探事业部</option>
									<option value="C105001005">塔里木物探处</option>
									<option value="C105001002">新疆物探处</option>
									<option value="C105001003">吐哈物探处</option>
									<option value="C105001004">青海物探处</option>
									<option value="C105005004">长庆物探处</option>
									<option value="C105005000">华北经理部</option>
									<option value="C105005001">新兴物探开发处</option>
									<option value="C105007">大港物探处</option>
									<option value="C105063">辽河物探处</option>
									<option value="C105006">装备服务处</option>
							</select>
						</td>
					    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="50%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">
													</span><a href="#">物探处收入完成情况</a><span class="gd"><a href="#"></a> </span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer1" style="height: 230px;"></div>
											</div>
										</td>
										<td width="50%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">

													</span><a href="#">物探处周收入同比分析</a><span class="gd"><a href="#"></a> </span>
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
										<td width="50%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">

													</span><a href="#">物探处二三维收入对比饼图</a><span class="gd"><a href="#"></a> </span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer3" style="height: 230px;"></div>
											</div>
										</td>
										<td width="50%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">

													</span><a href="#">物探处二三维支出对比饼图<span class="gd"><a href="#"></a> </span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer4" style="height: 230px;"></div>
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
										<td width="50%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">

													</span><a href="#">物探处小队收入支出对比图</a><span class="gd"><a href="#"></a> </span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer5" style="height: 230px;"></div>
											</div>
										</td>
										<td width="50%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">

													</span><a href="#">采集项目收支差异率<span class="gd"><a href="#"></a> </span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer6" style="height: 230px;"></div>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
	</div>
</body>
<script type="text/javascript">
 function getFusionChart(orgId){
	
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getSectionIncomeInfo.srq?orgId=<%=orgId%>");      
	myChart1.render("chartContainer1");  
	
	
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "230", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getSectionIncomeWeekInfo.srq?orgId=<%=orgId%>");      
	myChart2.render("chartContainer2");  
	
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId3", "100%", "100%", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getSectionIncomeTwoTreePieInfo.srq?orgId=<%=orgId%>");   
	myChart3.render("chartContainer3"); 
	
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId4", "100%", "100%", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getSectionOutcomeTwoTreePieInfo.srq?orgId=<%=orgId%>");   
	myChart4.render("chartContainer4"); 
	
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId5", "100%", "100%", "0", "0" );    
	myChart5.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getSectionCompareTeamInfo.srq?orgId=<%=orgId%>");   
	myChart5.render("chartContainer5"); 
	
	var myChart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId6", "100%", "100%", "0", "0" );    
	myChart6.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getSectionRatioTwoThreeInfo.srq?orgId=<%=orgId%>");   
	myChart6.render("chartContainer6"); 
	
}
 
  function changeOrg(){
     var s_org_id = document.getElementsByName("s_org_id")[0].value;
     getFusionChart(s_org_id)
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

