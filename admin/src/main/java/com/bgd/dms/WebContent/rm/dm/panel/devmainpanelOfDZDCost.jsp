<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
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
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">设备单机燃油消耗统计</a>
							<span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('sbdjryxhtj')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
						</div>
						</div>
						</td>
						
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">设备单机材料消耗统计</a><span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('sbdjclxhtj')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer3" style="height: 250px;">
			 
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
						<td width="100%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">现场维修费用统计</a><span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('xcwxfytj')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer4" style="height: 250px;">
			 
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
cruConfig.contextPath='<%=contextPath%>';

function getFusionChart(){
	var projectInfoNo='<%=projectInfoNo%>';
	var retObj2 = jcdpCallService("DevCommInfoSrv","getRyCostData","projectInfoNo=<%=projectInfoNo%>");
	var dataXml2 = retObj2.dataXML;
	var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart2.setXMLData(dataXml2);
	myChart2.render("chartContainer2");
	
	var retObj3 = jcdpCallService("DevCommInfoSrv","getClCostData","projectInfoNo=<%=projectInfoNo%>");
	var dataXml3 = retObj3.dataXML;
	var myChart3 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" );    
	myChart3.setXMLData(dataXml3);
	myChart3.render("chartContainer3");
	
	var retObj4 = jcdpCallService("DevCommInfoSrv","getWxCostData","projectInfoNo=<%=projectInfoNo%>");
	var dataXml4 = retObj4.dataXML;
	var myChart4 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId4", "100%", "250", "0", "0" );    
	myChart4.setXMLData(dataXml4);
	myChart4.render("chartContainer4");
}
function drillryxh(obj){
	//改成pop形式
//	popWindow('<%=contextPath %>/rm/dm/panel/popDZDRYCostInfos.jsp?code='+obj,'900:600');
	popWindow('<%=contextPath %>/rm/dm/panel/xiazua/devRanyouxiaohaoList.jsp?code='+obj,'900:600');
}
function drilldown(obj){
	//改成pop形式
	popWindow('<%=contextPath %>/rm/dm/panel/popDZDCLCostInfos.jsp?code='+obj,'800:600');
}
function drillwx(obj){
	//改成pop的形式
	popWindow('<%=contextPath %>/rm/dm/panel/popDZDWXCostInfos.jsp?code='+obj,'800:600');
}
function drillxiaoyoupin(obj){
	//改成pop的形式
	popWindow('<%=contextPath %>/rm/dm/panel/popDZDXYPInfos.jsp?code='+obj,'800:600');
}

function exportDataDoc(exportFlag){
	//调用导出方法
	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
	var submitStr = "projectInfoNo=<%=projectInfoNo%>&exportFlag="+exportFlag;
	var retObj = syncRequest("post", path, submitStr);
	var filename=retObj.excelName;
	filename = encodeURI(filename);
	filename = encodeURI(filename);
	var showname=retObj.showName;
	showname = encodeURI(showname);
	showname = encodeURI(showname);
	window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
}
</script>
<script type="text/javascript">
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

