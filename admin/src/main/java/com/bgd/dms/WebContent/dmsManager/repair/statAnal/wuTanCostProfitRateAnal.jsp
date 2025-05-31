<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String amountYear = request.getParameter("amountYear");
	String analType = request.getParameter("analType");
	String orgSubId = request.getParameter("orgSubId");
	String title="";
	if("cost".equals(analType)){
		title="维修成本占收入比";
	}
	if("profit".equals(analType)){
		title="维修成本占利润比";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>维修成本占收入比利润比(物探处)</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span><%=title%></span>
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
			getWuTanCostRateFusionChart();
		}
		//设备费用占比
		function getWuTanCostRateFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getWuTanCostProfitRateChartData.srq?amountYear=<%=amountYear%>&analType=<%=analType%>&orgSubId=<%=orgSubId%>");
			chart1.render("chartContainer1");
		}
	</script>
</html>

