<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	user.getSubOrgIDofAffordOrg();
	user.getCodeAffordOrgID();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="getFusionChart()">
	<div id="list_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" id="td0">
					<div class="tongyong_box">
						<div class="tongyong_box_title">
							<span class="kb"><a href="#"></a></span><a href="#">物资消耗占比分析</a>
						</div>
						<div class="tongyong_box_content_left" style="height: 220px;">
							<div id="chartContainer4"></div>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>
<script type="text/javascript">
	var showNewTitle = false;
	cruConfig.contextPath = '<%=contextPath%>';
	function getFusionChart(){
		var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId", "100%", "220", "0", "0" );    
		myChart4.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart1.srq");   
		myChart4.render("chartContainer4"); 
	}
    function drillwzzbxh(obj){
    	popWindow('<%=contextPath%>/mat/panel/matChart2xz.jsp?matId='+obj,'800:600');
    }
</script>  
</body>

</html>

