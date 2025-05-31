<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	//类别信息
	String code = request.getParameter("code");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
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
									href="#"></a></span><a href="#">公司级主要设备新度系数钻取情况</a><span class="gd"><a
									href="#"></a></span>
									<span class="dc" style="float:right;margin-top:-4px;">
										<a href="#" onclick="exportDataDoc()" title="导出excel"></a>
									</span>
								</div>
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
	var exportFlag='';
	var orgsubId='';
	var code='';
	function getFusionChart(){
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );  
		myChart3.setXMLUrl("<%=contextPath%>/rm/dm/getComXinduDisDrillInfo.srq?code=<%=code%>&drillLevel=0");      
		myChart3.render("chartContainer2"); 
		exportFlag="gsjzysbxdxszqqk";
	}
	
	function drillComXinduByType(obj){
		var chartReference = FusionCharts("myChartId2"); 
		var paramobj = obj.split("~",-1);
		var retObj = jcdpCallService("DevCommInfoSrv","getComXinduByType","code="+paramobj[0]+"&orgsubId="+paramobj[1]+"&drillLevel=0");
		var dataXml = retObj.xmldata;
		chartReference.setXMLData(dataXml);
		exportFlag="wtczysbxuxszqqk";
		code=paramobj[0];
		orgsubId=paramobj[1];
	}
	
	function drillComXinduBack(obj){
		var chartReference = FusionCharts("myChartId2"); 
		chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getComXinduDisDrillInfo.srq?code="+obj+"&drillLevel=0");     
		exportFlag="gsjzysbxdxszqqk";
	}
	function exportDataDoc(){
		//调用导出方法
		var path = "<%=contextPath%>/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		//公司级主要设备新度系数钻取情况
		if("gsjzysbxdxszqqk"==exportFlag){
			submitStr = "exportFlag="+exportFlag;
		}
		//物探处主要设备新度系数钻取情况
		if("wtczysbxuxszqqk"==exportFlag){
			submitStr = "code="+code+"&orgsubId="+orgsubId+"&exportFlag="+exportFlag;
		}
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location="<%=contextPath%>/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
</script>
</html>

