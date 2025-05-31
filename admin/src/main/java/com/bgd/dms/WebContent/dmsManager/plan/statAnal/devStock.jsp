<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>设备存量分析</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="99%" border="0" cellspacing="1" cellpadding="0">
				<tr>
					<td colspan="3">
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>物探处：</span>
								<select id="org_sub_id" name="org_sub_id" class="tongyong_box_title_select">
								<%
									if("C105".equals(orgId)){
								%>
									<option value="">全部</option>
								<%
									}
									if("C105".equals(orgId)){
										for(int i=0;i<DevUtil.orgNameList.size();i++){
											String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
								%>
											<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
								<%
										}
									}else{
										for(int i=0;i<DevUtil.orgNameList.size();i++){
											if(DevUtil.orgNameList.get(i).indexOf(orgId)>=0){
												String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
								%>
									<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
								<%
											}
										}
									}
								%>
						    	</select>
						    	<span>国内/国外：</span>
								<select id="country" name="country" class="tongyong_box_title_select">
									<option value="">全部</option>
									<option value="1">国内</option>
									<option value="2">国外</option>
						    	</select>
					    		<input type="button" value="查询" class="tongyong_box_title_button" onclick="toQuery()"/>
					    		<input type="button" value="清除" class="tongyong_box_title_button" onclick="toClear()"/>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>地震仪器存量分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1" style="height:350px;"></div>
						</div>
					</td>
					<td></td>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>可控震源存量分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer2" style="height:350px;"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>钻机存量分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer3" style="height:350px;"></div>
						</div>
					</td>
					<td></td>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>运输设备存量分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer4" style="height:350px;"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>检波器存量分析&nbsp;&nbsp;</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer5" style="height:350px;"></div>
						</div>
					</td>
					<td></td>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>推土机存量分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer6" style="height:350px;"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		//获取图表
		function getFusionChart(){
			//地震仪器存量分析
			getDzyqStockFusionChart();
			//地震可控震源分析
			getKkzyStockFusionChart();
			//钻机存量分析
			getZjStockFusionChart();
			//运输设备存量分析
			getYssbStockFusionChart();
			//获取检波器存量分析
			getJbqStockFusionChart();
			//推土机存量分析
			getTtjStockFusionChart();
		}
		//获取地震仪器存量分析
		function getDzyqStockFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart1", "97%", "345", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D001");
			chart1.render("chartContainer1");
		}
		//获取可控震源存量分析
		function getKkzyStockFusionChart(){
			var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart2", "97%", "345", "0", "0" );    
			chart2.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D002");
			chart2.render("chartContainer2");
		}
		//获取钻机存量分析
		function getZjStockFusionChart(){
			var chart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart3", "97%", "345", "0", "0" );    
			chart3.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D003");
			chart3.render("chartContainer3");
		}
		//获取运输设备存量分析
		function getYssbStockFusionChart(){
			var chart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart4", "97%", "345", "0", "0" );    
			chart4.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D004");
			chart4.render("chartContainer4");
		}
		//获取检波器存量分析
		function getJbqStockFusionChart(){
			var chart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart5", "97%", "345", "0", "0" );    
			chart5.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D005");
			chart5.render("chartContainer5");
		}
		//获取推土机存量分析
		function getTtjStockFusionChart(){
			var chart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart6", "97%", "345", "0", "0" );    
			chart6.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D006");
			chart6.render("chartContainer6");
		}
		//查询
		function toQuery(){
			var orgSubId = $('#org_sub_id').val();
			var country = $('#country').val();
			//获取地震仪器存量分析
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D001&orgSubId="+orgSubId+"&country="+country);
			//获取可控震源存量分析
			var chartReference2 = FusionCharts("chart2"); 
			chartReference2.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D002&orgSubId="+orgSubId+"&country="+country);
			//获取钻机存量分析
			var chartReference3 = FusionCharts("chart3"); 
			chartReference3.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D003&orgSubId="+orgSubId+"&country="+country);
			//获取运输设备存量分析
			var chartReference4 = FusionCharts("chart4"); 
			chartReference4.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D004&orgSubId="+orgSubId+"&country="+country);
			//获取检波器存量分析
			var chartReference5 = FusionCharts("chart5"); 
			chartReference5.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D005&orgSubId="+orgSubId+"&country="+country);
			//获取推土机存量分析
			var chartReference6 = FusionCharts("chart6"); 
			chartReference6.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D006&orgSubId="+orgSubId+"&country="+country);
		}
		//清除
		function toClear(){
			$('#org_sub_id').val('');
			$('#country').val('');
			//获取地震仪器存量分析
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D001");
			//获取可控震源存量分析
			var chartReference2 = FusionCharts("chart2"); 
			chartReference2.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D002");
			//获取钻机存量分析
			var chartReference3 = FusionCharts("chart3"); 
			chartReference3.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D003");
			//获取运输设备存量分析
			var chartReference4 = FusionCharts("chart4"); 
			chartReference4.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D004");
			//获取检波器存量分析
			var chartReference5 = FusionCharts("chart5"); 
			chartReference5.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D005");
			//获取推土机存量分析
			var chartReference6 = FusionCharts("chart6"); 
			chartReference6.setXMLUrl("<%=contextPath%>/dms/plan/statAnal/getStockChartData.srq?code=D006");
		}
	</script>
</html>

