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
		<title>利用率</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center">
						<div class="tongyong_box">
							<div class="tongyong_box_title" style="text-indent:0px;">
								<span>&nbsp;&nbsp;</span>
								<span>物探处：</span>
								<select id="org_sub_id_1" name="org_sub_id" class="tongyong_box_title_select">
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
						    	<span>设备类型：</span>
								<input id="dev_type" name="dev_type" type="text" class="tongyong_box_title_input" readonly/>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTypeTreePage()"  />
								<input id="dev_type_id" name="dev_type_id" class="" type="hidden" />
								<span>统计年限：</span>
								<select id="yearinfo" name="yearinfo" class="tongyong_box_title_select">
									<option value="">当前</option>
									<option value="3">三年</option>
						    		<option value="5">五年</option>
						    	</select>
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
			//利用率图表
			getAmountWhlFusionChart();
		}
		//获取利用率
		function getAmountWhlFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/device/getYearUseRate.srq");
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery1(){
			var orgSubId = $('#org_sub_id_1') .val();
			var yearinfo = $('#yearinfo') .val();
			var prFlag = $('#prFlag') .val();
			var devTypeId = $('#dev_type_id') .val();
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getYearUseRate.srq?orgSubId="+orgSubId+"&yearinfo="+yearinfo+"&prFlag="+prFlag+"&dev_type_id="+devTypeId);
		}
		//清除
		function toClear(){
			$('#org_sub_id_1') .val('');
			$('#prFlag') .val('5110000186000000001');
			$('#yearinfo') .val('');
			$('#dev_type') .val('');
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getYearUseRate.srq");
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

