<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String orgSubId = request.getParameter("orgSubId");
	String deviceType = request.getParameter("deviceType");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	String deviceName="";
	// 可控震源
	if("1".equals(deviceType)){
		deviceName="可控震源";
	}
	// 钻机
	if("2".equals(deviceType)){
		deviceName="钻机";
	}
	// 运输设备
	if("3".equals(deviceType)){
		deviceName="运输设备";
	}
	// 推土机
	if("4".equals(deviceType)){
		deviceName="推土机";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>项目设备出勤率</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span><%=deviceName%>设备出勤率</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		//调整页面高度
		function frameSize() {
			var height=$(window).height()-$("#tongyong_box_title").height()-50;
			$("#chartContainer1").css("height", height);
		}
		$(function() {
			$(window).resize(function() {
				frameSize();
			});
		});
		//获取图表
		function getFusionChart(){
			//项目设备出勤率图表
			getProDevAtteFusionChart();
		}
		//获取项目设备出勤率
		function getProDevAtteFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "95%", "0", "0" ); 
			chart1.setXMLUrl("<%=contextPath%>/dms/device/getProDevAtteChartData.srq?orgSubId=<%=orgSubId%>&deviceType=<%=deviceType%>&startDate=<%=startDate%>&endDate=<%=endDate%>");
			chart1.render("chartContainer1");
		}
		//钻取项目设备出勤率
		function popProDevAtteList(orgSubId,proNo,deviceType,startDate,endDate){
			popWindow('<%=contextPath%>/dmsManager/device/proDevAtteList.jsp?orgSubId='+orgSubId+'&proNo='+proNo+'&deviceType='+deviceType+'&startDate='+startDate+'&endDate='+endDate,'800:572');
		}
		
	</script>
</html>

