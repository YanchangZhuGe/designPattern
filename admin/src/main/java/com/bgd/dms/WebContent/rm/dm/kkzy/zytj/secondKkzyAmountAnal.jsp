<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	String useStat = request.getParameter("useStat");
	if(null==useStat || "null".equals(useStat)){
		useStat="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<%@include file="/common/include/easyuiresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
		<title>可控震源数量统计分析</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto">
		<div id="list_content">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span></span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
	 var useStat="<%=useStat%>";
	 var height=400;
		$(function() {
			height=$(window).height()-$("#tongyong_box_title").height()-30;
			getFusionChart();
		});
		//获取图标
		function getFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn3D.swf", "chart1", "95%", height, "0", "0" );    
			//在用
			if("0110000007000000001"==useStat){
				chart1.setXMLUrl("<%=contextPath%>/rm/dm/kkzy/getUseKkzyAmountAnal.srq");
			}
			//闲置
			if("0110000007000000002"==useStat){
				chart1.setXMLUrl("<%=contextPath%>/rm/dm/kkzy/getIdleKkzyAmountAnal.srq");
			}
			chart1.render("chartContainer1");
		}
		// 弹出在用震源信息
		function popUseKkzyList(orgId,devModel){
			popWindow('<%=contextPath%>/rm/dm/kkzy/zytj/useKkzyList.jsp?orgId='+orgId+'&devModel='+devModel,'800:572');
		}
		// 弹出闲置震源信息
		function popIdleKkzyList(positionId,devModel){
			popWindow('<%=contextPath%>/rm/dm/kkzy/zytj/idleKkzyList.jsp?positionId='+positionId+'&devModel='+devModel,'800:572');
		}
	</script>
</html>

