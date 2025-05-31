<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	//用户的组织机构信息和界面选择的机构信息
	String orgstrId = request.getParameter("code");
	String orgsubId = request.getParameter("orgsubId");
	String proYear=request.getParameter("proYear");
	String rptParams ="orgsubId="+orgsubId+";proYear="+proYear;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="table_box"  style="height:510px;" >
		<table id=rpt border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
			<!-- width="-1" height="-1" needScroll="no" scrollWidth="100%" scrollHeight="100%" scrollBorder="border:1px solid red" needSaveAsExcel="yes" excelPageStyle="1"-->
			<report:html name="report1"
			reportFileName="/device/getWutanTeamCostInfos.raq"
			params="<%=rptParams%>"
			width="-1" 
			height="-1"
			needScroll="no"
			needSaveAsExcel="yes"
			saveAsName="物探处级各项目主要设备主要费用统计报表<%=proYear%>"  excelPageStyle="0"/>
				</td>
			</tr>
		</table>
	</div>
	

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
								<div class="tongyong_box_title"><span class="kb">
								<a
								href="#"></a></span><a href="#">各项目费用钻取分析</a>
								<span class="gd"><a href="#"></a></span>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 100%;">
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
<!-- -->
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	function getFusionChart(){
		document.getElementById("list_content").style.display="none";
		var xmldata2 ="";
		var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
		myChart2.setXMLData(xmldata2);
		myChart2.render("chartContainer2");
	}
	function getWutanTeamCLCostInfos(obj){
		document.getElementById("table_box").style.display="none";
		var param='<%=orgstrId%>^<%=orgsubId%>';
		var retObj2 = jcdpCallService("DevCommInfoSrv","getClCostData","orgkeyId="+param+"&projectInfoNo="+obj+"&drillLevel=1");
		var xmldata2 = retObj2.dataXML;
		var chartReference = FusionCharts("myChartId2"); 
		chartReference.setXMLData(xmldata2);
		document.getElementById("list_content").style.display="block";
	}
	function drilldown(obj){
		var chartReference = FusionCharts("myChartId2"); 
		var param = obj.split("~",-1);
		var retObj = jcdpCallService("DevCommInfoSrv","getCostDrill","orgkeyId="+param[0]+"&projectInfoNo="+param[1]+"&devtype="+param[2]+"&drillLevel=1");
		var xmldata2 = retObj.dataXML;
		chartReference.setXMLData(xmldata2);
	}
	function getWutanTeamRYCostInfos(obj){
		document.getElementById("table_box").style.display="none";
		var param='<%=orgstrId%>^<%=orgsubId%>';
		var retObj2 = jcdpCallService("DevCommInfoSrv","getRyCostData","orgkeyId="+param+"&projectInfoNo="+obj+"&drillLevel=1");
		var xmldata2 = retObj2.dataXML;
		var chartReference = FusionCharts("myChartId2"); 
		chartReference.setXMLData(xmldata2);
		document.getElementById("list_content").style.display="block";
	}
	function drillryxh(obj){
		var chartReference = FusionCharts("myChartId2"); 
		var param = obj.split("~",-1);
		var retObj = jcdpCallService("DevCommInfoSrv","getRyDrill","orgkeyId="+param[0]+"&projectInfoNo="+param[1]+"&devtype="+param[2]+"&drillLevel=1");
		var xmldata2 = retObj.dataXML;
		chartReference.setXMLData(xmldata2);
	}
	function drillback(obj){
		self.location.reload();
		//var retObj = jcdpCallService("DevCommInfoSrv","getWutanTeamCostInfos","orgstrId="+param[0]+"&orgsubId="+param[1]+"&drillLevel=1");
		//var xmldata2 = retObj.xmldata;
		//var startindex2 = xmldata2.indexOf("<chart");
		//xmldata2 = xmldata2.substr(startindex2);
		//var chartReference = FusionCharts("myChartId2"); 
		//chartReference.setXMLData(xmldata2);
	}
	
	
</script>
</html>

