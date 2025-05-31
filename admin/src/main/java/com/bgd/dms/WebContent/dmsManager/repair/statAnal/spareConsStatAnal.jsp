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
		<title>备件消耗统计图表</title>
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
						    	<span>开始时间：</span>
								<input id="start_date" name="start_date" type="text" class="easyui-datebox tongyong_box_title_input" editable="false"/>
							    <span>结束时间：</span>
								<input id="end_date" name="end_date" type="text" class="easyui-datebox tongyong_box_title_input" editable="false" validType="gtStartDate['#start_date']" />
							    <input type="button" value="查询" class="tongyong_box_title_button" onclick="toQuery()"/>
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
			//备件消耗统计
			getSpareConsFusionChart();
		}
		//获取备件消耗统计
		function getSpareConsFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareConsStatChartData.srq?orgSubId="+$('#org_sub_id') .val());
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery(){
			if(!$('#end_date').datebox("isValid")){
				return;
			}
			var orgSubId = $('#org_sub_id') .val();
			var startDate= $("#start_date").datebox("getValue");
			var endDate= $("#end_date").datebox("getValue");
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareConsStatChartData.srq?orgSubId="+orgSubId+"&startDate="+startDate+"&endDate="+endDate);
		}
		//清除
		function toClear(){
			$('#org_sub_id') .val('');
			$("#start_date").datebox("setValue","");
			$("#end_date").datebox("setValue","");
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareConsStatChartData.srq");
		}
		function popSpareConsStatList(matType,orgSubId,startDate,endDate,flag){
			popWindow('<%=contextPath%>/dmsManager/repair/statAnal/spareConsStatList.jsp?matType='+matType+'&orgSubId='+orgSubId+'&startDate='+startDate+'&endDate='+endDate+'&flag='+flag,'800:572');
		}
		function popCSpareConsStat(matCode,level,orgSubId,startDate,endDate){
			popWindow('<%=contextPath%>/dmsManager/repair/statAnal/cSpareConsStatAnal.jsp?matCode='+matCode+'&level='+level+'&orgSubId='+orgSubId+'&startDate='+startDate+'&endDate='+endDate,'800:572');
		}
	</script>
</html>

