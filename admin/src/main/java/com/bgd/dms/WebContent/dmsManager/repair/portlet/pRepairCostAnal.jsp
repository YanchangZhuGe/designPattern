<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" align="center" >
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span>维修费用统计&nbsp;</span>
					<span>&nbsp;物探处：</span>
					<select id="prca_org_sub_id" name="org_sub_id" class="select">
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
			    	<span>&nbsp;年度：</span>
					<input id="prca_year" name="year" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
			   		<img width="18" height="16" id="prca_cal_button" style="cursor: hand;" onmouseover="yearSelector(prca_year,prca_cal_button);" src="<%=contextPath%>/images/calendar.gif" />
		    		<span>&nbsp;</span>
		    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toPRCAQuery()"/>
		    		<span>&nbsp;</span>
		    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toPRCAClear()"/>
				</div>
				<div class="tongyong_box_content_left" id="pRCAChartContainer" style="height: 400px;"></div>
			</div>
		</td>
	</tr>
</table>
		
	<script type="text/javascript">
		//初始化年度
		$('#prca_year') .val(new Date().getFullYear());
		//维修费用统计
		getPRCAFusionChart();
		//维修费用统计
		function getPRCAFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "pRCAId", "97%", "400", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairCostChartData.srq");
			chart1.render("pRCAChartContainer");
		}
		//查询
		function toPRCAQuery(){
			var orgSubId = $('#prca_org_sub_id').val();
			var year = $('#prca_year').val();
			var chartReference1 = FusionCharts("pRCAId"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairCostChartData.srq?orgSubId="+orgSubId+"&year="+year);
		}
		//清除
		function toPRCAClear(){
			$('#prca_org_sub_id').val('');
			$('#prca_year').val('');
			var chartReference1 = FusionCharts("pRCAId"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getRepairCostChartData.srq");
		}
		//弹出维护,保养图表
		function popRepairMainChart(year,month,orgSubId,flag){
			popWindow('<%=contextPath%>/dmsManager/repair/statAnal/repairMainAnal.jsp?year='+year+'&month='+month+'&orgSubId='+orgSubId+'&flag='+flag,'800:572');
		}
	</script>

