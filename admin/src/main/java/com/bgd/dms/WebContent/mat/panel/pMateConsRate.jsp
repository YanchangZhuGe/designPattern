<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span class="kb"><a href="#"></a></span><a href="#">万元产值物资消耗率</a>
				</div>
				<div class="tongyong_box_content_left" style="height: 220px;">
					<div id="pMCRChartContainer"></div>
				</div>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	getPMCRFusionChart();
	function getPMCRFusionChart(){
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "pMCRId", "100%", "220", "0", "0" );    
		myChart3.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart2.srq");   
		myChart3.render("pMCRChartContainer"); 
	}
	function drillwyczxh(obj){
	   	popWindow('<%=contextPath%>/mat/panel/wtcwycz.jsp?orgSubjectionId='+obj,'800:600');
	}
</script>

