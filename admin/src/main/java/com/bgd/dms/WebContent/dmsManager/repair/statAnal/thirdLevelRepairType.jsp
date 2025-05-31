<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String level = request.getParameter("level");
	String devTreeId = request.getParameter("devTreeId");
	String orgSubId = request.getParameter("orgSubId");
	String country = request.getParameter("country");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<title>三级设备类别维修费用</title>
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
				width:120px;
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
								<span>维修费用&nbsp;&nbsp;&nbsp;</span>
							</div>
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
			//维修费用图表
			getThiLevRepTypeFusionChart();
		}
		//获取维修费用图表
		function getThiLevRepTypeFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "chart1", "98%", "400", "0", "0" ); 
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairTypeChartData.srq?level=<%=level%>&devTreeId=<%=devTreeId%>&orgSubId=<%=orgSubId%>&country=<%=country%>&startDate=<%=startDate%>&endDate=<%=endDate%>");
			chart1.render("chartContainer1");
		}
		//弹出维修类别费用信息
		function popRepairTypeList(devTreeId,orgSubId,country,startDate,endDate){
			popWindow('<%=contextPath%>/dmsManager/repair/statAnal/repairTypeList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&startDate='+startDate+'&endDate='+endDate+'&flag=whl','800:572');
		}
	</script>
</html>

