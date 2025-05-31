<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	//钻取的类别信息
	String code = request.getParameter("code");
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
								href="#"></a></span><a href="#">现场维修钻取信息&lt;小油品&gt;</a>
								<span class="gd"><a href="#"></a></span>
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
		var retObj2 = jcdpCallService("DevCommInfoSrv","getXYPDrillForPop","projectInfoNo=<%=projectInfoNo%>&code=<%=code%>");
		var dataXml2 = retObj2.dataXML;
		var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId2", "100%", "250", "0", "0" );    
		myChart2.setXMLData(dataXml2);
		myChart2.render("chartContainer2");
	}
	function drillXYPSingle(obj){
		var infos = obj.split("~",-1);
		var retObj2 = jcdpCallService("DevCommInfoSrv","getXYPSingleDrillForPop","projectInfoNo=<%=projectInfoNo%>&devaccid="+infos[0]+"&code="+infos[1]);
		var dataXml2 = retObj2.dataXML;
		var chartReference = FusionCharts("myChartId2"); 
		chartReference.setXMLData(dataXml2);
	}
	function drillXYPBack(obj){
		var retObj2 = jcdpCallService("DevCommInfoSrv","getXYPDrillForPop","projectInfoNo=<%=projectInfoNo%>&code=<%=code%>");
		var dataXml2 = retObj2.dataXML;
		var chartReference = FusionCharts("myChartId2"); 
		chartReference.setXMLData(dataXml2);
	}
	
</script>
</html>

