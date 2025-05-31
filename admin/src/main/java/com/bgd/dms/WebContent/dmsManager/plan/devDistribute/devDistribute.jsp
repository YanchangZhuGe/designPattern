<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>设备分布分析</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="99%" border="0" cellspacing="0" cellpadding="0">
			<tr>
					<td colspan="3">
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>&nbsp;是否在账：</span>
								<select id="account_stat" name="account_stat" class="tongyong_box_title_select">
									<option value="0110000013000000003">在账</option>
									<option value="">全部</option>
						    	</select>
						    	<span>&nbsp;是否生产设备：</span>
								<select id="prFlag" name="prFlag" class="tongyong_box_title_select">
									<option value="5110000186000000001">生产</option>
									<option value="">全部</option>
						    	</select>
						    	<span>&nbsp;</span>
					    		<input type="button" value="查询" class="tongyong_box_title_button" onclick="toQuery()"/>
					    		<span>&nbsp;</span>
					    		<input type="button" value="清除" class="tongyong_box_title_button" onclick="toClear()"/>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td width="49%">
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>可控震源分布分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1" style="height:350px;"></div>
						</div>
					</td>
					<td width="1%"></td>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>钻机分布分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer2" style="height:350px;"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td width="49%">
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>运输设备分布分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer3" style="height:350px;"></div>
						</div>
					</td>
					<td width="1%"></td>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>推土机分布分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer4" style="height:350px;"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		//调整页面宽度
		function frameSize() {
			var width = $(window).width() - 256;
			$("#tongyong_box_content_left_1").css("width", width);
		}
		$(function() {
			$(window).resize(function() {
				frameSize();
			});
		});
		//获取图表
		function getFusionChart(){
			//可控震源分析
			getKkzyStockFusionChart();
			//获取钻机分布分析
			getZjStockFusionChart();
			//获取运输设备分布分析
			getYssbStockFusionChart();
			//获取推土机分布分析
			getTtjStockFusionChart();
		}
		//获取可控震源分布分析
		function getKkzyStockFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "97%", "345", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDistribute.srq?devType=D002");
			chart1.render("chartContainer1");
		}

		//获取钻机分布分析
		function getZjStockFusionChart(){
			var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart2", "97%", "345", "0", "0" );    
			chart2.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDistribute.srq?devType=D003");
			chart2.render("chartContainer2");
		}

		//获取运输设备分布分析
		function getYssbStockFusionChart(){
			var chart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart3", "97%", "345", "0", "0" );    
			chart3.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDistribute.srq?devType=D004");
			chart3.render("chartContainer3");
		}
	
		//获取推土机分布分析
		function getTtjStockFusionChart(){
			var chart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart4", "97%", "345", "0", "0" );    
			chart4.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDistribute.srq?devType=D006");
			chart4.render("chartContainer4");
		}
		
		//查询
		function toQuery(){
			var accountStat = $('#account_stat').val();
			var prFlag = $('#prFlag').val();
		
			//获取可控震源分布分析
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getDistribute.srq?devType=D002&accountStat="+accountStat+"&prFlag="+prFlag);
			//获取钻机分布分析
			var chartReference2 = FusionCharts("chart2"); 
			chartReference2.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getDistribute.srq?devType=D003&accountStat="+accountStat+"&prFlag="+prFlag);
			//获取运输设备分布分析
			var chartReference3 = FusionCharts("chart3"); 
			chartReference3.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getDistribute.srq?devType=D004&accountStat="+accountStat+"&prFlag="+prFlag);			
			//获取推土机分布分析
			var chartReference4 = FusionCharts("chart4"); 
			chartReference4.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getDistribute.srq?devType=D006&accountStat="+accountStat+"&prFlag="+prFlag);
		}
		//清除
		function toClear(){
			$('#account_stat').val('0110000013000000003');
			$('#prFlag').val('5110000186000000001');
			
			//获取可控震源分布分析
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getDistribute.srq?devType=D002");
			//获取钻机分布分析
			var chartReference2 = FusionCharts("chart2"); 
			chartReference2.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getDistribute.srq?devType=D003");
			//获取运输设备分布分析
			var chartReference3 = FusionCharts("chart3"); 
			chartReference3.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getDistribute.srq?devType=D004");
			//获取推土机分布分析
			var chartReference4 = FusionCharts("chart4"); 
			chartReference4.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getDistribute.srq?devType=D006");
		}
	
	</script>
</html>

