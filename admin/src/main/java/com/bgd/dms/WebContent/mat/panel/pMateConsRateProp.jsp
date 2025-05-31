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
					<span class="kb"><a href="#"></a></span><a href="#">物资消耗占比分析</a>
				</div>
				<div class="tongyong_box_content_left" style="height: 220px;">
					<div id="pMCRPChartContainer"></div>
				</div>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	getPMCRPFusionChart();
	function getPMCRPFusionChart(){
		var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "pMCRPId", "100%", "220", "0", "0" );    
		myChart4.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart1.srq");   
		myChart4.render("pMCRPChartContainer"); 
	}
    function drillwzzbxh(obj){
    	popWindow('<%=contextPath%>/mat/panel/matChart2xz.jsp?matId='+obj,'800:600');
    }
</script>  

