<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
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
		<title>资产创收</title>
		<style type="text/css">
			.select {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:100px;
				height:20px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
			.input {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:85px;
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
							<div class="tongyong_box_content_left" id="chartContainer1" style="height: 400px;"></div>
						</div>
					</td>
				</tr>
				
			</table>
		</div>
	</body>
	<script type="text/javascript">
		//获取图表
		function getFusionChart(){
			//资产创收图表
			getAmountWhlFusionChart();
		}
		//获取资产创收
		function getAmountWhlFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "400", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/use/getAssetsIncomeData.srq?level=2");
			chart1.render("chartContainer1");
		}

	</script>
</html>

