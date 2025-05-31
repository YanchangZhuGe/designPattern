<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>利用率对比</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title" style="text-indent:0px;">
								<span>&nbsp;&nbsp;</span>
								<span>设备类型：</span>
								<input id="dev_type" name="dev_type" type="text" class="tongyong_box_title_input" readonly/>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTypeTreePage()"  />
								<input id="dev_type_id" name="dev_type_id" class="" type="hidden" />
						    	<span>国内/国外：</span>
								<select id="country_1" name="country" class="tongyong_box_title_select">
									<option value="">全部</option>
									<option value="1" selected>国内</option>
									<option value="2">国外</option>
						    	</select>
						    	<span>开始时间：</span>
								<input id="start_date" name="start_date" type="text" class="easyui-datebox tongyong_box_title_input" editable="false"/>
								<span>结束时间：</span>
								<input id="end_date" name="end_date" type="text" class="easyui-datebox tongyong_box_title_input" editable="false" validType="gtStartDate['#start_date']" />
					    		<span>是否生产设备：</span>
								<select id="prFlag" name="prFlag" class="tongyong_box_title_select">									
									<option value="5110000186000000001">生产设备</option>
									<option value="">全部</option>
						    	</select>
					    		<input type="button" value="查询" class="tongyong_box_title_button" onclick="toQuery1()"/>
					    		<input type="button" value="清除" class="tongyong_box_title_button" onclick="toClear()"/>
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
			frameSize();
			$(window).resize(function() {
				frameSize();
			});
		});
		//获取图表
		function getFusionChart(){
		//初始化日期
			var iDate = new Date();
			var iStartDate = iDate.getFullYear()+"-01-01";
			var iEndDate=getCurrentDate();
			$("#start_date").datebox("setValue",iStartDate);
			$("#end_date").datebox("setValue",iEndDate);
			//利用率图表
			getAmountWhlFusionChart();
		}
		//获取利用率
		function getAmountWhlFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/device/getUseRateForOrg.srq");
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery1(){
			if(!$('#end_date').datebox("isValid")){
				return;
			}
			var dev_type_id = $('#dev_type_id') .val();
			var startDate= $("#start_date").datebox("getValue");
			var endDate= $("#end_date").datebox("getValue");
			var prFlag = $('#prFlag') .val();
			var country=$('#country_1') .val();
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getUseRateForOrg.srq?dev_type_id="+dev_type_id+"&startDate="+startDate+"&endDate="+endDate+"&country="+country+"&prFlag="+prFlag);
		}
		//清除
		function toClear(){
			$('#dev_type_id') .val('');
			$('#dev_type') .val('');
			$("#start_date").datebox("setValue","");
			$("#end_date").datebox("setValue","");
			$('#prFlag') .val('5110000186000000001');
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getUseRateForOrg.srq");
		}
		//选择设备类型树
		function showDevTypeTreePage(){
			var returnValue={
				fkValue:"",
				value:""
			};
			window.showModalDialog("<%=contextPath%>/dmsManager/use/devOrgUseRate/selectDevTypeSub.jsp",returnValue,"");
			document.getElementById("dev_type").value = returnValue.value;
			document.getElementById("dev_type_id").value = returnValue.fkValue;
		}
	</script>
</html>

