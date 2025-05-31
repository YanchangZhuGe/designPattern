<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" align="center" >
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span>维修费用率&nbsp;</span>
					<span>&nbsp;物探处：</span>
					<select id="prcra_org_sub_id" name="org_sub_id" class="select">
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
			    	<span>&nbsp;国内/国外：</span>
					<select id="prcra_country" name="country" class="select">
						<option value="">全部</option>
						<option value="1">国内</option>
						<option value="2">国外</option>
			    	</select>
			    	<span>&nbsp;开始时间：</span>
					<input  id="prcra_date_1_1" name="start_date" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
				    <img width="18" height="16" id="prcra_cal_button_1_1" style="cursor: hand;" 
		    		onmouseover="calDateSelector(prcra_date_1_1,prcra_cal_button_1_1);" src="<%=contextPath%>/images/calendar.gif" />
		    		<span>&nbsp;结束时间：</span>
					<input  id="prcra_date_1_2" name="end_date" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
				    <img width="18" height="16" id="prcra_cal_button_1_2" style="cursor: hand;" 
		    		onmouseover="calDateSelector(prcra_date_1_2,prcra_cal_button_1_2);" src="<%=contextPath%>/images/calendar.gif" />
		    		<span>&nbsp;</span>
		    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toPRCRAQuery()"/>
		    		<span>&nbsp;</span>
		    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toPRCRAClear()"/>
				</div>
				<div class="tongyong_box_content_left" id="pRCRAChartContainer" style="height: 400px;"></div>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	//初始化日期
	$('#prcra_date_1_1') .val(iStartDate);
	$('#prcra_date_1_2') .val(iEndDate);
	//维修费用率图表
	getPRCRAFusionChart();
	//获取维修费用率图表
	function getPRCRAFusionChart(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "pRCRAId", "95%", "400", "0", "0" );    
		chart1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairCostRateChartData.srq");
		chart1.render("pRCRAChartContainer");
	}
	//查询
	function toPRCRAQuery(){
		var orgSubId = $('#prcra_org_sub_id') .val();
		var country = $('#prcra_country') .val();
		var startDate= $('#prcra_date_1_1') .val();
		var endDate= $('#prcra_date_1_2') .val();
		var chartReference1 = FusionCharts("pRCRAId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairCostRateChartData.srq?orgSubId="+orgSubId+"&country="+country+"&startDate="+startDate+"&endDate="+endDate);
	}
	//清除
	function toPRCRAClear(){
		$('#prcra_org_sub_id') .val('');
		$('#prcra_country') .val('');
		$('#prcra_date_1_1') .val('');
		$('#prcra_date_1_2') .val('');
		var chartReference1 = FusionCharts("pRCRAId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairTypeChartData.srq");
	}
	//弹出子层级
	function popNextRepairCostRate(level,devTreeId,orgSubId,country,startDate,endDate){
		popWindow('<%=contextPath%>/dmsManager/repair/statAnal/secondLevelRepairCostRate.jsp?level='+level+'&devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&startDate='+startDate+'&endDate='+endDate,'800:572');
	}
	//弹出维修费用率信息
	function popRepairCostRateList(devTreeId,orgSubId,country,startDate,endDate){
		popWindow('<%=contextPath%>/dmsManager/repair/statAnal/repairCostRateList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&startDate='+startDate+'&endDate='+endDate+'&flag=whl','800:572');
	}
</script>

