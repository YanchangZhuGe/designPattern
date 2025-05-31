<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String analType = request.getParameter("analType");
	String title="";
	if("cost".equals(analType)){
		title="资产创收";
	}
	if("profit".equals(analType)){
		title="资产创效";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>资产创收创效</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title" style="text-indent:0px;">
								<span>&nbsp;&nbsp;</span>
								<span><%=title%></span>
								<span>&nbsp;&nbsp;年度：</span>
							    <input id="amount_year" name="amount_year" class="easyui-numberspinner tongyong_box_title_input" style="line-height:23px; height:23px;" data-options="editable:false"/>
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
		var orgSubId='<%=orgSubId%>';
		//调整页面高度
		function frameSize() {
			var height=$(window).height()-$("#tongyong_box_title").height()-50;
			$("#chartContainer1").css("height", height);
		}
	    $(function(){
	    	frameSize();
	    	$(window).resize(function() {
				frameSize();
			});
			$('#amount_year').numberspinner('setValue', new Date().getFullYear());
		});
		//获取图表
		function getFusionChart(){
			var amountYear = $('#amount_year').numberspinner('getValue');
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/use/getAssetsIncomeOrProfitData.srq?analType=<%=analType%>&orgSubId="+orgSubId+"&amountYear="+amountYear);
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery(){
			var amountYear = $('#amount_year').numberspinner('getValue');
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/use/getAssetsIncomeOrProfitData.srq?analType=<%=analType%>&orgSubId="+orgSubId+"&amountYear="+amountYear);
		}
		//清除
		function toClear(){
			$('#amount_year').numberspinner('setValue', new Date().getFullYear());
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/use/getAssetsIncomeOrProfitData.srq?analType=<%=analType%>&orgSubId="+orgSubId+"&amountYear="+new Date().getFullYear());
		}
		
		function popWuTanIncomeProfitRate(amountYear,analType,orgSubId){
			popWindow('<%=contextPath%>/dmsManager/use/assetsIncome/wuTanAssetsIncomeProfit.jsp?amountYear='+amountYear+'&analType='+analType+'&orgSubId='+orgSubId,'800:572');
		}
	</script>
</html>

