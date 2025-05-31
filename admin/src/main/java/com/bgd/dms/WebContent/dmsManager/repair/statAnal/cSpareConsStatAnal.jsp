<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String matCode = request.getParameter("matCode");
	String level = request.getParameter("level");
	String orgSubId = request.getParameter("orgSubId");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>子类型备件消耗统计图表</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				<td colspan="3">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							<td>	<span class="dc" style="float:right;margin-top:-4px;">
								<a href="####" onclick="exportDataDoc()" title="导出excel"></a>	
								</span>
							</td>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
				</td>
				</tr>
				<tr id="tr_1">
					<td colspan="3" align="center" >
						
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>备件消耗统计图表</span>
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
			//备件消耗统计
			getCSpareConsFusionChart();
		}
		//获取备件消耗统计
		function getCSpareConsFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "chart1", "95%", "95%", "0", "0" ); 
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getCSpareConsStatChartData.srq?matCode=<%=matCode%>&level=<%=level%>&orgSubId=<%=orgSubId%>&startDate=<%=startDate%>&endDate=<%=endDate%>");
			chart1.render("chartContainer1");
		}
		//弹出子层级备件消耗统计
		function popNextSpareConsStat(matCode,level,orgSubId,startDate,endDate){
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl('<%=contextPath%>/dms/repair/getCSpareConsStatChartData.srq?matCode='+matCode+'&level='+level+'&orgSubId='+orgSubId+'&startDate='+startDate+'&endDate='+endDate);
		}
		function popDSpareConsStatList(matCode,orgSubId,startDate,endDate,flag){
			popWindow('<%=contextPath%>/dmsManager/repair/statAnal/spareConsStatList.jsp?matCode='+matCode+'&orgSubId='+orgSubId+'&startDate='+startDate+'&endDate='+endDate+'&flag='+flag,'800:572');
		}
		
		function exportDataDoc(){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		submitStr = "matCode=<%=matCode%>&level=<%=level%>&orgSubId=<%=orgSubId%>&startDate=<%=startDate%>&endDate=<%=endDate%>&exportFlag=bjxhtj";
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

