<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
//物探处队伍利用率
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId =  user.getEmpId();
	String contextPath = request.getContextPath();
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	if(orgSubjectionId == null || "".equals(orgSubjectionId)){
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
	}
%>

<head>
<title>队伍动态</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var dataXml = "";
function initData(){
	var curDate = new Date();
	var startDate = curDate.getFullYear()+"-01-01";
	var endDate =  curDate.getFullYear()+"-12-31";
	var retObj = jcdpCallService("TeamDynamicSrv","getTeamUse","orgSubId=<%=orgSubjectionId %>&startDate=" + startDate + "&endDate="+endDate);
	if(retObj.Str != null){
		dataXml = retObj.Str;
	}
	if(retObj.teamStatistics != null){
		
	}
	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId", "100%", "100%", "0", "0" );
	myChart.setXMLData(dataXml);
	myChart.render("chartContainer_123123123");
}

</script>
<body  style="overflow-y: auto;background: #fff;" onload="initData()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr id="line2">
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100%">
												<div class="tongyong_box_content_left" id="chartContainer_123123123" ></div>
											</td>
										</tr>
									</table>
								</td>
								<td width="1%"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	</tr>
</table>

</div>
</body>
</html>