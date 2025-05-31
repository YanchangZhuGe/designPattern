<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
		<title>地震仪器动态情况</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto"  onload="getFusionChart()">
	<div id="list_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="49%">
					<div class="tongyong_box">
						<div class="tongyong_box_title">
							<span class="kb"><a href="#"></a></span>
							<a href="#">地震仪器动态情况</a>
							<span class="gd"><a href="#"></a></span>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer" style="height: 250px;"></div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	</body>
	<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	function getFusionChart(){
		//地震仪器
		var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "myChartId", "100%", "250", "0", "0" );    
		myChart.setXMLUrl("<%=contextPath%>/dms/use/getCompEqChart.srq");      
		myChart.render("chartContainer"); 
	}
	
	function popzaiyongdrill(obj){
		popWindow('<%=contextPath %>/dmsManager/use/statAnal/popChartOfEqZaiyongChartDrill.jsp?code='+obj,'800:500');
	}
	function popxianzhidrill(obj){
		popWindow('<%=contextPath %>/dmsManager/use/statAnal/popChartOfEqXianzhiChartDrill.jsp?code='+obj,'800:500');
	}
</script>
</html>

