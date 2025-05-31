<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" align="center" >
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span>维修项目费用统计&nbsp;</span>
					<select id="pria_org_sub_id" name="org_sub_id" class="select">
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
					<input  id="pria_date_1_1" name="start_date" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
				    <img width="18" height="16" id="pria_cal_button_1_1" style="cursor: hand;" 
		    		onmouseover="calDateSelector(pria_date_1_1,pria_cal_button_1_1);" src="<%=contextPath%>/images/calendar.gif" />
		    		<span>&nbsp;结束时间：</span>
					<input  id="pria_date_1_2" name="end_date" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
				    <img width="18" height="16" id="pria_cal_button_1_2" style="cursor: hand;" 
		    		onmouseover="calDateSelector(pria_date_1_2,pria_cal_button_1_2);" src="<%=contextPath%>/images/calendar.gif" />
		    		<span>&nbsp;</span>
		    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toPRIAQuery()"/>
		    		<span>&nbsp;</span>
		    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toPRIAClear()"/>
				</div>
				<div class="tongyong_box_content_left" id="pRIAChartContainer" style="height: 400px;"></div>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	//初始化日期
	$('#pria_date_1_1') .val(iStartDate);
	$('#pria_date_1_2') .val(iEndDate);
	//维修项目费用
	gePRIAFusionChart();
	//获取维修项目费用
	function gePRIAFusionChart(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "pRIAId", "95%", "400", "0", "0" );    
		chart1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairItemChartData.srq");
		chart1.render("pRIAChartContainer");
	}
	//查询
	function toPRIAQuery(){
		var orgSubId = $('#pria_org_sub_id') .val();
		var startDate= $('#pria_date_1_1') .val();
		var endDate= $('#pria_date_1_2') .val();
		var chartReference1 = FusionCharts("pRIAId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairItemChartData.srq?orgSubId="+orgSubId+"&startDate="+startDate+"&endDate="+endDate);
	}
	//清除
	function toPRIAClear(){
		$('#pria_org_sub_id') .val('');
		$('#pria_date_1_1') .val('');
		$('#pria_date_1_2') .val('');
		var chartReference1 = FusionCharts("pRIAId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairItemChartData.srq");
	}
</script>

