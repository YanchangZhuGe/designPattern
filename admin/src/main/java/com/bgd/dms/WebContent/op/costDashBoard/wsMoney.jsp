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
<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>

			 		<td class="ali_cdn_name">年度：</td>
			 	    <td class="ali_cdn_input">
					<select id="year" name="year">
						<option value="">全部</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
					</select>
			 	    </td>
			 	    <td class="ali_cdn_name">队伍：</td>
			 	    <td class="ali_cdn_input">
					<select id="org_name" name="org_name">
						<option value="">全部</option>
						<option value="2504">2504队</option>
						<option value="2508">2508队</option>
						<option value="2513">2513队</option>
						<option value="2514">2514队</option>
						<option value="2517">2517队</option>
						<option value="2518">2518队</option>
						<option value="2521">2521队</option>
						<option value="2522">2522队</option>
					</select>
			 	    </td>
			  		  <td class="ali_cdn_input"><span class="cx"><a href="#" onclick="getFusionChart()" title="查询"></a></span></td>
			 
			 	    <td>&nbsp;</td>

				</tr>
			</table>
				</td>
				 <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				
			</tr>
		</table>
	</div>
	<div id="list_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div class="tongyong_box">
								<div class="tongyong_box_title">
									</span><a href="#">井中经营综合报表</a><span class="gd"><a href="#"></a> </span>
								</div>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 230px;"></div>
							</div>
							</td>
						</tr>
				</table>

	</div>
</body>
<script type="text/javascript">

 function getFusionChart(){
		var year = $("#year").val();
		var org_name = $("#org_name").val();
		
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId9", "100%", "100%", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getjzMoney.srq?year="+year+"&org_name="+org_name);      
	myChart2.render("chartContainer2");  
		
}

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
</script>
</html>


