<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
<style type="text/css">
.select_height{height:20px;margin:0,0,0,0;}
SELECT {
	margin-bottom:0;
    margin-top:0;
	border:1px #52a5c4 solid;
	color: #333333;
	FONT-FAMILY: "微软雅黑";font-size:9pt;
}
.tongyong_box_title {
	width:100%;
	height:auto;
	background:url(<%=contextPath%>/dashboard/images/titlebg.jpg);
	text-align:left;
	text-indent:12px;
	font-weight:bold;
	font-size:14px;
	color:#0f6ab2;
	line-height:22px;
}
</style>

</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">一线员工在岗率</a>
							<code:codeSelect name='s_org_id' option="orgCommOps" addAll="true" cssClass="select_height"  selectedValue='' onchange="changeOrg()"/>
							<span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">

						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">物探处对比</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer3" style="height: 250px;">

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
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">物探处存量资源统计</a>
								<span class="gd"><a
							href="#"></a></span>
							<code:codeSelect name='s_org_id1' option="orgCommOps" addAll="true"  cssClass="select_height"   selectedValue='' onchange="changeOrg1()"/>
							<code:codeSelect name='s_team1' option="teamOps" addAll="true"  cssClass="select_height"   selectedValue='' onchange="changeTeam1()"/>
						
							</div>
						<div class="tongyong_box_content_left" id="chartContainer5" style="height: 250px;">

						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="50%">

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
</body>
<script type="text/javascript">

 function getFusionChart(){

	
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn3DLineDY.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/rm/em/getChart11.srq?orgId=<%=orgId%>");      
	myChart2.render("chartContainer2"); 
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn3DLineDY.swf", "myChartId3", "100%", "250", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/rm/em/getChart12.srq?orgId=<%=orgId%>");      
	myChart3.render("chartContainer3"); 

	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId5", "100%", "250", "0", "0" );    
	myChart5.setXMLUrl("<%=contextPath%>/rm/em/getChart15.srq?orgId=<%=orgId%>");      
	myChart5.render("chartContainer5"); 
}
 
 function changeOrg(){
	 
     var chartReference = FusionCharts("myChartId2");     
     var s_org_id = document.getElementsByName("s_org_id")[0].value;
     chartReference.setXMLUrl("<%=contextPath%>/rm/em/getChart11.srq?orgId="+s_org_id);
 }
 
 function changeOrg1(){
	 
     var chartReference = FusionCharts("myChartId5");     
     var s_org_id = document.getElementsByName("s_org_id1")[0].value;
     var s_team = document.getElementsByName("s_team")[0].value;
     chartReference.setXMLUrl("<%=contextPath%>/rm/em/getChart15.srq?orgId="+s_org_id+"&setTeam="+s_team);
 }

 
 function changeTeam1(){
	 
     var chartReference = FusionCharts("myChartId5");     
     var s_org_id = document.getElementsByName("s_org_id1")[0].value;
     var s_team = document.getElementsByName("s_team1")[0].value;
     chartReference.setXMLUrl("<%=contextPath%>/rm/em/getChart15.srq?orgId="+s_org_id+"&setTeam="+s_team);
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

