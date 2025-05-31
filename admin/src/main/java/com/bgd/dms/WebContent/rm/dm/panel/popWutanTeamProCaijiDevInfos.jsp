<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	//org信息
	String orgstrId = request.getParameter("code");
	String orgsubId = request.getParameter("orgsubId");
	String proYear = request.getParameter("proYear");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>无标题文档</title>
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
						<td width="99%">
							<div class="tongyong_box">
								<div class="tongyong_box_title"><span class="kb"><a
								href="#"></a></span><a href="#">各项目采集设备统计钻取</a>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
		
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
</body>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	function getFusionChart(){
		var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
		var retObj2 = jcdpCallService("DevCommInfoSrv","getWutanTeamCaijiDevInfos","orgstrId=<%=orgstrId%>&orgsubId=<%=orgsubId%>&proYear=<%=proYear%>");
		var xmldata4 = retObj2.xmldata;
		var startindex4 = xmldata4.indexOf("<chart");
		xmldata4 = xmldata4.substr(startindex4);
		myChart2.setXMLData(xmldata4);
		myChart2.render("chartContainer2");
	}
	function drillWutanTeamProCaijiDevInfos(obj){
		var param = obj.split("~",-1);
		var retObj2 = jcdpCallService("EarthquakeTeamStatistics","getCollEqSumStatistics","orgkeyId="+param[0]+"&projectInfoNo="+param[1]+"&drillLevel=1");
		var dataXml2 = retObj2.dataXML;
		var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
		myChart2.setXMLData(dataXml2);
		myChart2.render("chartContainer2");
	}
	function drillWutanTeamProCaijiDevInfosForSingle(obj){
		var param = obj.split("~",-1);
		var retObj2 = jcdpCallService("EarthquakeTeamStatistics","getElectronicEquipmentStatistics","orgkeyId="+param[0]+"&projectInfoNo="+param[1]+"&deviceid="+param[2]+"&drillLevel=1");
		var dataXml2 = retObj2.dataXML;
		var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "myChartId2", "100%", "250", "0", "0" );    
		myChart2.setXMLData(dataXml2);
		myChart2.render("chartContainer2");
	}
	//查询单台信息
	function drillWutanTeamProDantaiDevInfos(obj){
		$("#edev").hide();
		$("#chartContainer2").empty();
		var param = obj.split("~",-1);
		var retObj = jcdpCallService("EarthquakeTeamStatistics","getDevInfoDrillDownForTable","orgkeyId="+param[0]+"&projectInfoNo="+param[1]+"&code="+param[2]+"&drillLevel=1");
		var dataXml = retObj.dataXML;
		$("#chartContainer2").append(dataXml);
	}
	function drillWutanTeamProCaijiDevBack(obj){
		$("#edev").hide();
		var param = obj.split("^",-1);
		var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
		var retObj2 = jcdpCallService("DevCommInfoSrv","getWutanTeamCaijiDevInfos","orgstrId="+param[0]+"&orgsubId="+param[1]+"&proYear=<%=proYear%>");
		var xmldata4 = retObj2.xmldata;
		var startindex4 = xmldata4.indexOf("<chart");
		xmldata4 = xmldata4.substr(startindex4);
		myChart2.setXMLData(xmldata4);
		myChart2.render("chartContainer2");
	}
	function drillDownDevInfoBack(obj){
		$("#edev").hide();
		var param = obj.split("^",-1);
		var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
		var retObj2 = jcdpCallService("DevCommInfoSrv","getWutanTeamCaijiDevInfos","orgstrId="+param[0]+"&orgsubId="+param[1]+"&proYear=<%=proYear%>");
		var xmldata4 = retObj2.xmldata;
		var startindex4 = xmldata4.indexOf("<chart");
		xmldata4 = xmldata4.substr(startindex4);
		myChart2.setXMLData(xmldata4);
		myChart2.render("chartContainer2");
	}
</script>
</html>

