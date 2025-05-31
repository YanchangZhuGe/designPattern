<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" align="center" >
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span>维修费用占比&nbsp;</span>
					<select id="prcpa_org_sub_id" name="org_sub_id" class="select">
						<option value="">全部</option>
						<option value="C105002">国际勘探事业部</option>
						<option value="C105005004">长庆物探处</option>
						<option value="C105001005">塔里木物探处</option>
			    		<option value="C105001002">新疆物探处</option>
			    		<option value="C105001003">吐哈物探处</option>
			    		<option value="C105001004">青海物探处</option>
			    		<option value="C105007">大港物探处</option>
			    		<option value="C105063">辽河物探处</option>
			    		<option value="C105005000">华北物探处</option>
			    		<option value="C105005001">新兴物探开发处</option>
			    		<option value="C105086">深海物探处</option>
			    		<option value="C105006">装备服务处</option>
			    	</select>
			    	<span>&nbsp;开始时间：</span>
					<input  id="prcpa_date_1_1" name="start_date" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
				    <img width="18" height="16" id="prcpa_cal_button_1_1" style="cursor: hand;" 
		    		onmouseover="calDateSelector(prcpa_date_1_1,prcpa_cal_button_1_1);" src="<%=contextPath%>/images/calendar.gif" />
		    		<span>&nbsp;结束时间：</span>
					<input  id="prcpa_date_1_2" name="end_date" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
				    <img width="18" height="16" id="prcpa_cal_button_1_2" style="cursor: hand;" 
		    		onmouseover="calDateSelector(prcpa_date_1_2,prcpa_cal_button_1_2);" src="<%=contextPath%>/images/calendar.gif" />
		    		<span>&nbsp;</span>
		    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toPRCPAQuery()"/>
		    		<span>&nbsp;</span>
		    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toPRCPAClear()"/>
				</div>
				<div class="tongyong_box_content_left" id="pRCPAChartContainer" style="height: 400px;"></div>
			</div>
		</td>
	</tr>
	
</table>
		
<script type="text/javascript">
	//初始化日期
	$('#prcpa_date_1_1') .val(iStartDate);
	$('#prcpa_date_1_2') .val(iEndDate);
	//维修费用占比统计
	getPRCPAFusionChart();
	//维修费用占比统计
	function getPRCPAFusionChart(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "pRCPAId", "97%", "400", "0", "0" );    
		chart1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairCostProportionChartData.srq");
		chart1.render("pRCPAChartContainer");
	}
	//查询
	function toPRCPAQuery(){
		var orgSubId = $('#prcpa_org_sub_id') .val();
		var startDate= $('#prcpa_date_1_1') .val();
		var endDate= $('#prcpa_date_1_2') .val();
		var chartReference1 = FusionCharts("pRCPAId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairCostProportionChartData.srq?orgSubId="+orgSubId+"&startDate="+startDate+"&endDate="+endDate);
	}
	//清除
	function toPRCPAClear(){
		$('#prcpa_org_sub_id') .val('');
		$('#prcpa_date_1_1') .val('');
		$('#prcpa_date_1_2') .val('');
		var chartReference1 = FusionCharts("pRCPAId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairCostProportionChartData.srq");
	}
	//弹出项目设备维修费用列表
	function popProjRepaCostList(orgSubId,startDate,endDate){
		popWindow('<%=contextPath%>/dmsManager/repair/statAnal/projRepaCostList.jsp?orgSubId='+orgSubId+'&startDate='+startDate+'&endDate='+endDate,'800:572');
	}
</script>

