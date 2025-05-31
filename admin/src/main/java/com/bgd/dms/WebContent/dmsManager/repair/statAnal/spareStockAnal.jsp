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
		<title>备件库存占比</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>所属单位：</span>
								<input id="org_name" name="org_name" type="text" class="tongyong_box_title_input" readonly="readonly"/>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage()"  />
								<input id="org_sub_id" name="org_sub_id" class="" type="hidden" />
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
			frameSize();
		});
		//获取图表
		function getFusionChart(){
			//备件库存占比
			getSpareStockFusionChart();
		}
		//获取备件库存占比
		function getSpareStockFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareStockChartData.srq");
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery(orgSubId){
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareStockChartData.srq?orgSubId="+orgSubId);
		}
		//选择组织机构树
		function showOrgTreePage(){
			var returnValue={
				fkValue:"",
				value:""
			};
			window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
			document.getElementById("org_name").value = returnValue.value;
			document.getElementById("org_sub_id").value = returnValue.fkValue;
			toQuery(returnValue.fkValue);
		}
	</script>
</html>

