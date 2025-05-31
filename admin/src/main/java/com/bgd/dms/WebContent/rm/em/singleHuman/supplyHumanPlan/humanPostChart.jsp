<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);	
	String  projectInfoNo = user.getProjectInfoNo();
	String splan_id = request.getParameter("splan_id");
	String team = "";
	if(request.getParameter("team") != null && !"".equals(request.getParameter("team"))){
		team = request.getParameter("team");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
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
 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100%"> 
						<div class="tongyong_box_title" ><span class="kb"><a
							href="#"></a></span><code:codeSelect name='s_team' option="teamOps" addAll="true"  selectedValue='<%=team%>' onchange="changeTeam()"/>
							<span class="gd"><a href="#"></a></span>
							
							</div>
						<div id="chartContainer1" style="height: 455px;">
			 
						</div>
				 
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
 
</body>
<script type="text/javascript">
 function getFusionChart(){
	 
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/rm/em/chart/queryBanPost.srq?projectInfoNo=<%=projectInfoNo%>&team=<%=team%>&splan_id=<%=splan_id%>");      
	myChart1.render("chartContainer1"); 

}
  

 function changeTeam(){ 
     var chartReference = FusionCharts("myChartId1");     
     var s_team = document.getElementsByName("s_team")[0].value;
     chartReference.setXMLUrl("<%=contextPath%>/rm/em/chart/queryBanPost.srq?projectInfoNo=<%=projectInfoNo%>&splan_id=<%=splan_id%>&team="+s_team);
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

