<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String item_id = request.getParameter("item_id");
	String item_name = request.getParameter("item_name");
	String org_sub_id = request.getParameter("org_sub_id");
	String isDisplay = request.getParameter("isDisplay");
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
		<title>设备物资降本增效五项指标分析</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>指标分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1"></div>
						</div>
					</td>
				</tr>
				<tr id="tr_2">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>国际部指标分析</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer2"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		var isDisplay="<%=isDisplay%>";
		//页面初始化信息
		$(function(){
			if("no"==isDisplay){
				$("#tr_2").hide();
				$("#chartContainer1").height(20);
				$("#chartContainer1").css("height","400");
			}else{
				$("#chartContainer2").css("height","250");
				$("#chartContainer2").css("height","250");
			}
		});
		//获取图表
		function getFusionChart(){
			if("no"==isDisplay){
				var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "98%", "400", "0", "0" ); 
				chart1.setXMLUrl("<%=contextPath%>/dms/assess/jbzx/getJbzxChartData.srq?item_id=<%=item_id%>&item_name=<%=item_name%>&org_sub_id=<%=org_sub_id%>");
				chart1.render("chartContainer1");
			}else{
				var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "98%", "250", "0", "0" ); 
				chart1.setXMLUrl("<%=contextPath%>/dms/assess/jbzx/getNotGjbJbzxChartData.srq?item_id=<%=item_id%>&item_name=<%=item_name%>&org_sub_id=<%=org_sub_id%>");
				chart1.render("chartContainer1");
				//国际部
				var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart2", "98%", "250", "0", "0" ); 
				chart2.setXMLUrl("<%=contextPath%>/dms/assess/jbzx/getJbzxChartData.srq?item_id=<%=item_id%>&item_name=<%=item_name%>&org_sub_id=C105002");
				chart2.render("chartContainer2");
			}
		}
	</script>
</html>

