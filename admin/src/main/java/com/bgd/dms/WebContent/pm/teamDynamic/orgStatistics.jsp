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
	var retObj = jcdpCallService("TeamDynamicSrv","getTeamStatistics","startDate=" + startDate + "&endDate="+endDate);
	if(retObj.teamStatistics != null){
		dataXml = retObj.Str;
		dataXml2 = retObj.Str2;
		dataXml3 = retObj.Str3;
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
			tr.insertCell().innerHTML = '<a onclick="inBrowse(\'nostatus\',\''+record.orgCode+'\');">'+record.orgName+'</a>';
			tr.insertCell().innerHTML = '<a onclick="inBrowse(\'nostatus\',\''+record.orgCode+'\');">'+record.teamSums+'</a>';
			tr.insertCell().innerHTML = '<a onclick="inBrowse(\'run\',\''+record.orgCode+'\');">'+record.teamOperationNums+'</a>';
			tr.insertCell().innerHTML = '<a onclick="inBrowse(\'no\',\''+record.orgCode+'\');">'+record.teamIdleNums+'</a>';
//			tr.insertCell().innerHTML = '<a onclick="inBrowse(\'prepare\',\''+record.orgCode+'\');">'+record.teamStopNums+'</a>';
			tr.insertCell().innerHTML = '<a onclick="inBrowse(\'stop\',\''+record.orgCode+'\');">'+record.teamUse2+'</a>';
			tr.insertCell().innerHTML = '<a onclick="inBrowse(\'stop\',\''+record.orgCode+'\');">'+record.teamUse+'</a>';
		}
	}
	
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId", "100%", "100%", "0", "0" );
	myChart1.setXMLData(dataXml);
	myChart1.render("chartContainer");
	
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId", "100%", "100%", "0", "0" );
	myChart2.setXMLData(dataXml2);
	myChart2.render("chartContainer2");
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId", "100%", "100%", "0", "0" );
	myChart3.setXMLData(dataXml3);
	myChart3.render("chartContainer3");
}

function inBrowse(status,orgId){
	popWindow(getContextPath() + "/pm/teamDynamic/chujiOrgStatistics.jsp?orgSubjectionId="+orgId);
}

function open1(orgSubjectionId){
	popWindow(getContextPath() + "/pm/teamDynamic/chujiOrgStatistics.jsp?orgSubjectionId=" + orgSubjectionId);
}
</script>
<body  style="overflow-y: auto;background: #C0E2FB;" onload="initData()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr id="line1">
								<td width="49%">
									<div class="tongyong_box">
									<div class="tongyong_box_title"><span class="kb"><a
										href="#"></a></span><a href="#">队伍动态</a><span class="gd"><a
										href="#"></a></span></div>
									<table width="100%" id="lineTable" border="1" align="center">
										<tr background="blue" class="bt_info">
									      <td class="tableHeader" width="22%">直属单位</td>
									      <td class="tableHeader" width="13%">队伍总数</td>
									      <td class="tableHeader" width="13%">在用</td>
									      <td class="tableHeader" width="13%">闲置</td>
								<!-- 	  <td class="tableHeader" width="13%">结束</td>     -->
									      <td class="tableHeader" width="13%">动用率</td>
									      <td class="tableHeader" width="13%">利用率</td>
									    </tr>
									</table>
									</div>
								</td>
								<td width="1%"></td>
								<td width="48%">
								<div class="tongyong_box">
								<div class="tongyong_box_title"><span class="kb"><a
									href="#"></a></span><a href="#">队伍动态</a><span class="gd"><a
									href="#"></a></span></div>
								<div id="chartContainer" class="tongyong_box_content_left"  style="height: 296px;"></div>
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
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100%">
												<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a
													href="#"></a></span><a href="#">队伍动用率</a><span class="gd"><a
													href="#"></a></span></div>
												<div class="tongyong_box_content_left" id="chartContainer3" ></div>
												</div>
											</td>
										</tr>
									</table>
								</td>
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