<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String level = request.getParameter("level");
	String devTreeId = request.getParameter("devTreeId");
	String orgSubId = request.getParameter("orgSubId");
	String country = request.getParameter("country");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	String deviceName="";
	// 地震仪器
	if("D001".equals(devTreeId)){
		deviceName="地震仪器";
	}
	// 可控震源
	if("D002".equals(devTreeId)){
		deviceName="可控震源";
	}
	// 物探钻机
	if("D003".equals(devTreeId)){
		deviceName="物探钻机";
	}
	// 运输设备
	if("D004".equals(devTreeId)){
		deviceName="运输设备";
	}
	// 检波器
	if("D005".equals(devTreeId)){
		deviceName="检波器";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>三级闲置情况</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span><%=deviceName%>闲置情况</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		var level = "<%=level%>";
		var devTreeId ="<%=devTreeId%>";
		var orgSubId = "<%=orgSubId%>";
		var country = "<%=country%>";
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
			//利用率图表
			getSecondLevelUseRateFusionChart();
		}
		//获取闲置
		function getSecondLevelUseRateFusionChart(){
			country= encodeURI(encodeURI(country));
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "chart1", "95%", "95%", "0", "0" ); 
			chart1.setXMLUrl("<%=contextPath%>/dms/device/getDeviceLie.srq?level="+level+"&devTreeId="+devTreeId+"&orgSubId="+orgSubId+"&country="+country+"");
			chart1.render("chartContainer1");
		}
		//弹出子层级利用率
		function popNextLevelUseRate(level,devTreeId,orgSubId,country,startDate,endDate){
			popWindow('<%=contextPath%>/dmsManager/device/thirdLevelInsUseRate.jsp?level='+level+'&devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&startDate='+startDate+'&endDate='+endDate,'800:572');
		}
		//弹出设备信息
		function popDevList(devTreeId,orgSubId,country,startDate,endDate){
			popWindow('<%=contextPath%>/dmsManager/use/deviceLie/devList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&flag=ttj','800:572','设备闲置情况');
		}
	</script>
</html>

