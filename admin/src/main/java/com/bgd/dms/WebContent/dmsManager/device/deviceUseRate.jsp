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
					<td colspan="3" align="center" >
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
								<select id="ifproduction" name="ifproduction" class="tongyong_box_title_select">									
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
		//获取图表w
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
			var orgSubId = $('#org_sub_id_1') .val();
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/device/getUseRate.srq?orgSubId="+orgSubId);
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery1(){
			if(!$('#end_date').datebox("isValid")){
				return;
			}
			var orgSubId = $('#org_sub_id_1') .val();
			var country = $('#country_1') .val();
			country= encodeURI(encodeURI(country));
			var startDate= $("#start_date").datebox("getValue");
			var endDate= $("#end_date").datebox("getValue");
			var ifproduction = $('#ifproduction') .val();
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getUseRate.srq?orgSubId="+orgSubId+"&country="+country+"&startDate="+startDate+"&endDate="+endDate+"&ifproduction="+ifproduction);
		}
		//清除
		function toClear(){
			$('#org_sub_id_1') .val('');
			$('#country_1') .val('');
			$("#start_date").datebox("setValue","");
			$("#end_date").datebox("setValue","");
			$('#ifproduction') .val('5110000186000000001');
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getUseRate.srq");
		}
		//弹出子层级利用率
		function popNextLevelUseRate(level,devTreeId,orgSubId,country,startDate,endDate,ifproduction){
			popWindow('<%=contextPath%>/dmsManager/device/secondLevelUseRate.jsp?level='+level+'&devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&startDate='+startDate+'&endDate='+endDate+'&ifproduction='+ifproduction,'800:572');
		}
		//弹出设备信息
		function popDevList(devTreeId,orgSubId,country,startDate,endDate,ifproduction){
			popWindow('<%=contextPath%>/dmsManager/device/devList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&startDate='+startDate+'&endDate='+endDate+'&flag=userate&ifproduction='+ifproduction,'800:572');
		}
	</script>
</html>

