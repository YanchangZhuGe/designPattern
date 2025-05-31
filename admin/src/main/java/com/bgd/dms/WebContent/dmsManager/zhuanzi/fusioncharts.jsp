<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_type_id = request.getParameter("dev_type_id");
	String title="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
		<title>生命周期对比</title>
		<style type="text/css">
			.select {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:120px;
				height:20px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
			.input {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:100px;
				height:18px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
			.tongyong_box_title {
				width:100%;
				height:auto;
				text-align:left;
				text-indent:12px;
				font-weight:bold;
				font-size:14px;
				color:#0f6ab2;
				line-height:22px;
			}
		</style>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>&nbsp;&nbsp;</span>
								<span>&nbsp;设备类型:</span>
								<select style="width:120px;" id="dev_type_name" name="dev_type_name">
										<option value=""></option>
								</select> 
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevTypeTreePage()"  />
								<input id="dev_type_id" name="dev_type_id" class="" type="hidden" />
						    	<span>&nbsp;</span>
					    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toQuery()"/>
					    		<span>&nbsp;</span>
					    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toClear()"/>
							</div>
							
						</div>
					</td>
				</tr>
				<tr>
					<td width="49%">
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>设备原值比对&nbsp;&nbsp;</span>
								<div class="tongyong_box_content_left" id="chartContainer1" style="height: 350px;"></div>
							</div>
						</div>
					</td>
					<td width="1%"></td>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>行驶里程比对&nbsp;&nbsp;</span>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 350px;"></div>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td width="49%">
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>油料消耗比对&nbsp;&nbsp;</span>
								<div class="tongyong_box_content_left" id="chartContainer3" style="height: 350px;"></div>
							</div>
						</div>
					</td>
					<td width="1%"></td>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>参与项目数&nbsp;&nbsp;</span>
								<div class="tongyong_box_content_left" id="chartContainer4" style="height: 350px;"></div>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
	
	function frameSize() {
		var width = $(window).width() - 256;
		$("#tongyong_box_content_left").css("width", width);
	}
	
	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	});
	
	//获取图表
	function getFusionChart(){
		//获取原值对比
		getDevCostRateFusionChart();
		//获取油料消耗对比
		getDevTotalMoneyFusionChart();
		//获取行驶公里
		getDevMileageFusionChart();
		//获取参与项目对比
		getDevCountFusionChart();
	}
	
	//获取原值对比
	function getDevCostRateFusionChart(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "97%", "345", "0", "0" );    
		//修改默认的提示信息中文提示
		chart1.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDevicebf.srq");
		chart1.render("chartContainer1");
	}

	//获取油料消耗对比
	function getDevTotalMoneyFusionChart(){
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart2", "97%", "345", "0", "0" );    
		chart2.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceTotalMoney.srq");
		chart2.render("chartContainer2");
	}

	//获取行驶公里
	function getDevMileageFusionChart(){
		var chart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart3", "97%", "345", "0", "0" );    
		chart3.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceMileage.srq");
		chart3.render("chartContainer3");
	}

	//获取参与项目对比
	function getDevCountFusionChart(){
		var chart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart4", "97%", "345", "0", "0" );    
		chart4.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceCount.srq");
		chart4.render("chartContainer4");
	}
	
	//查询
	function toQuery(){
		var dev_type_id= $('#dev_type_id') .val();
		var chartReference1 = FusionCharts("chart1"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDevicebf.srq?dev_type_id="+dev_type_id);
		var chartReference2 = FusionCharts("chart2"); 
		chartReference2.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceTotalMoney.srq?dev_type_id="+dev_type_id);
		var chartReference3 = FusionCharts("chart3"); 
		chartReference3.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceMileage.srq?dev_type_id="+dev_type_id);
		var chartReference4 = FusionCharts("chart4"); 
		chartReference4.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceCount.srq?dev_type_id="+dev_type_id);
	}
	
	//清除
	function toClear(){
		var dev_type_name= $('#dev_type_name') .val();
		var chartReference1 = FusionCharts("chart1"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDevicebf.srq");
		var chartReference2 = FusionCharts("chart2"); 
		chartReference2.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceTotalMoney.srq");
		var chartReference3 = FusionCharts("chart3"); 
		chartReference3.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceMileage.srq");
		var chartReference4 = FusionCharts("chart4"); 
		chartReference4.setXMLUrl("<%=contextPath%>/dmsManager/zhuanzi/getDeviceCount.srq");
	}
	
	function showDevTypeTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/dmsManager/zhuanzi/selectDevType.jsp",returnValue,"");
		var  innerHtml="";
		$("#dev_type_name").html("");
		 var selectedProjects=returnValue.value;
			var typename = selectedProjects.split(",");
		 for(var i=0;i<typename.length;i++ ){
		    innerHtml+="<option>"+typename[i]+"</option>";
		 }
		$("#dev_type_name").append(innerHtml);
		//var orgId = strs[1].split(":");
		document.getElementById("dev_type_id").value = returnValue.fkValue;
	}

	</script>
</html>

