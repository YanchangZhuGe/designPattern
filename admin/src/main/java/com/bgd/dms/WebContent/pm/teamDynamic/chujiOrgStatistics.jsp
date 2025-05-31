<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId =  user.getEmpId();
	String contextPath = request.getContextPath();
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	if(orgSubjectionId == null || "".equals(orgSubjectionId)){
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
		for(var i=0;i<retObj.teamStatistics.length;i++){
			var record = retObj.teamStatistics[i];
			var rowNum = i;
			var tr = document.getElementById("lineTable").insertRow();
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.id="line_"+rowNum;
			tr.height= 20;
			// 单元格
			tr.insertCell().innerHTML = record.orgName;
			tr.insertCell().innerHTML =record.num;
			tr.insertCell().innerHTML = record.run;
			tr.insertCell().innerHTML = record.idle;
//			tr.insertCell().innerHTML = record.stop;
			tr.insertCell().innerHTML = record.useTime;
			tr.insertCell().innerHTML = record.teamUse;
		}
	}
	var tr = document.getElementById("lineTable").insertRow();
	if(retObj.teamStatistics.length % 2 == 0){
		tr.className = "even";
	} else {
		tr.className = "odd";
	}
	tr.id="line_"+rowNum;
	tr.height= 20;
	
	tr.insertCell().innerHTML = "动用率";
	tr.insertCell().innerHTML = retObj.teamUse2;
	tr.insertCell().innerHTML = "&nbsp;";
	tr.insertCell().innerHTML = "&nbsp;";
	tr.insertCell().innerHTML = "&nbsp;";
	tr.insertCell().innerHTML = "&nbsp;";
	tr.insertCell().innerHTML = "&nbsp;";
	
	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId", "100%", "100%", "0", "0" );
	myChart.setXMLData(dataXml);
	myChart.render("chartContainer2");
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
							<tr id="line1">
								<td width="98%">
									<div class="tongyong_box">
									<div class="tongyong_box_title"><span class="kb"><a
										href="#"></a></span><a href="#">队伍动态</a><span class="gd"><a
										href="#"></a></span></div>
									<table width="100%" id="lineTable" border="1" align="center">
										<tr background="blue" class="bt_info">
									      <td class="tableHeader" width="30%">队伍名称</td>
									      <td class="tableHeader" width="15%">队伍总数</td>
									      <td class="tableHeader" width="15%">在用</td>
									      <td class="tableHeader" width="15%">闲置</td>
							<!-- 		      <td class="tableHeader" width="11%">结束</td>       -->
									      <td class="tableHeader" width="15%">动用次数</td>
									      <td class="tableHeader" width="15%">利用率</td>
									    </tr>
									</table>
									</div>
								</td>
								<td width="1%"></td>
							</tr>
							<tr style="height: 5%"></tr>
							<tr id="line2">
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100%">
												<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a
													href="#"></a></span><a href="#">队伍利用率</a><span class="gd"><a
													href="#"></a></span></div>
												<div class="tongyong_box_content_left" id="chartContainer2" ></div>
												</div>
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