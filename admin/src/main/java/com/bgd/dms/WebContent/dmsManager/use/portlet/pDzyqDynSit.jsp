<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%> 
<%
	String contextPath=request.getContextPath();
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span class="kb"><a href="#"></a></span>
					<a href="#">地震仪器动态情况</a>
					<span class="gd"><a href="#"></a></span>
				</div>
				<div class="tongyong_box_content_left" id="pddsChartContainer" style="height: 250px;"></div>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	//地震仪器
	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "pddsMyChartId", "100%", "250", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/dms/use/getCompEqChart.srq");      
	myChart.render("pddsChartContainer"); 
	function popzaiyongdrill(obj){
		popWindow('<%=contextPath %>/dmsManager/use/statAnal/popChartOfEqZaiyongChartDrill.jsp?code='+obj,'800:500');
	}
	function popxianzhidrill(obj){
		popWindow('<%=contextPath %>/dmsManager/use/statAnal/popChartOfEqXianzhiChartDrill.jsp?code='+obj,'800:500');
	}
</script>

