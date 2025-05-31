<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = user.getProjectInfoNo();
    String orgSubId = "C105";
	String orgId = "C6000000000001";
	if(user != null){
		orgSubId = user.getSubOrgIDofAffordOrg();
		orgId = user.getCodeAffordOrgID();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>	
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="45%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">项目分布</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;overflow: hidden;">
			 				<!-- <iframe width="100%" height="100%" frameborder="0" src="<%=contextPath %>/pm/projectDynamic/domestic.jsp" marginheight="0" marginwidth="0"  scrolling="auto"  style="overflow: scroll;"></iframe> -->
			 				<img src="map1.png" alt=""  height="250px" onclick="alertChina()" style="cursor: pointer;"/>
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="53%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">项目运行动态</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height:250px;width:100%;overflow: scroll;">
							<!--  <iframe width="100%" height="100%" frameborder="0" src="<%=contextPath %>/pm/projectDynamic/international.jsp" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>-->
							<!-- <img src="International.png" alt=""  height="250px" onclick="alertInternational()" style="cursor: pointer;"/> -->
							<table id="lineTable" border="1" align="center" width="100%" style= "border:1px solid #000000;border-color: #000000">
							    <tr background="#DDF1F2" >
							      <td style="background-color: #DDF1F2" rowspan="2">单位名称</td>
							      <td style="background-color: #DDF1F2" rowspan="2">结束</td>
							      <td style="background-color: #DDF1F2" rowspan="2">运行</td>
							      <td style="background-color: #DDF1F2" rowspan="2">暂停</td>
							      <td style="background-color: #DDF1F2" rowspan="2">准备</td>
							      <td style="background-color: #DDF1F2" rowspan="2">共计</td>
							      <td style="background-color: #DDF1F2" colspan="2">二维累计</td>
							      <td style="background-color: #DDF1F2" colspan="2">三维累计</td>
							    </tr>
							    <tr background="#ddf1f2" >
							      <td style="background-color: #DDF1F2">炮数</td>
							      <td style="background-color: #DDF1F2">公里数</td>
							      <td style="background-color: #DDF1F2">炮数</td>
							      <td style="background-color: #DDF1F2">平方公里数</td>
							    </tr>
							</table>
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="45%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">队伍动态</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer3" style="height: 250px;">

						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="53%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">项目健康状况</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;overflow: visible;">
							<iframe src="<%=contextPath %>/p6/projectTask/projectMeter.jsp?orgSubjectionId=<%=orgSubId %>&orgId=<%=orgId %>" marginheight="0" marginwidth="0" style="height:100%;width:100%;overflow: scroll;"></iframe>
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var projectInfoNo = "<%=projectInfoNo%>";

function getFusionChart(){
	var nowDate = new Date();
	var year = nowDate.getFullYear();
	var month = nowDate.getMonth()+1;
	var day = nowDate.getDate();
	var startDate = year + "-01-01";
	var endDate = "";
	if(month >= 10){
		endDate = year + "-" + month + "-" + day;
	}else{
		endDate = year + "-0" + month + "-" + day;
	}
	var dataXml = "";
	var retObj = jcdpCallServiceCache("TeamDynamicSrv","getTeamStatistics1","startDate=" + startDate + "&endDate="+endDate);
	if(retObj.teamStatistics != null){
		dataXml = retObj.Str;
	}	
	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId123", "100%", "100%", "0", "0" );
	myChart.setXMLData(dataXml);
	myChart.render("chartContainer3");
	
	var curDate = endDate;
	var retObj = jcdpCallServiceCache("ProjectDynamicSrv","getProjectSiuation","curDate="+curDate+"&startDate=" + startDate + "&endDate="+endDate);
	if(retObj.projectStatistics != null){		
		for(var i=0;i<retObj.projectStatistics.length;i++){
			var record = retObj.projectStatistics[i];
			var rowNum = i;
			var tr = document.getElementById("lineTable").insertRow();
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.id="line_"+rowNum;
			tr.height= 25;
			// 单元格
			tr.insertCell().innerHTML = "<a href='#' onclick=open1('"+record.orgCode+"')>"+record.orgName+"</a>";
			tr.insertCell().innerHTML = record.projectEndNums;
			tr.insertCell().innerHTML = record.projectRunNums;
			tr.insertCell().innerHTML = record.projectPauseNums;
			tr.insertCell().innerHTML = record.projectReadyNums;
			tr.insertCell().innerHTML = record.projectTotalNums;
			tr.insertCell().innerHTML = record.cumlativeFinish2dSPNums;
			tr.insertCell().innerHTML = record.cumlativeFinish2dNums;
			tr.insertCell().innerHTML = record.cumlativeFinish3dSPNums;
			tr.insertCell().innerHTML = record.cumlativeFinish3dNums;
		}
	}
}

function open1(orgCode){
	//popWindow('<%=contextPath %>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=yearProjectStat1&noLogin=admin&tokenId=admin&orgSubjectionId='+orgCode,'1024:768');
	popWindow('<%=contextPath %>/pm/chart/chart3.jsp?orgSubjectionId='+orgCode,'1024:768');
	//alert(orgCode);
}

function alertChina(){
	
	var randomNumber = new Date().getTime();
	//A7地图
	//popWindow('http://10.88.2.240/OMS_Web_GPE/login.do?username=bgp_oa_erp_report&password=bgp_oa_erp_report&requestType=0&addr=/OMS_Web_GPE/gpe/projectReport/projectMap/main.jsp','1024:768');
	
	//BI地图正式环境 20130401 暂时用这个20130909
	popWindow('http://10.88.248.133:7002/richfit/flexos/index.jsp?orgId=<%=user.getSubOrgIDofAffordOrg() %>&random='+randomNumber,'1024:768');
	//1317001正式环境 1337002测试环境	
	//popWindow('http://10.88.248.131:7001/richfit/flexos/index.jsp?orgId=<%=user.getSubOrgIDofAffordOrg() %>&random='+randomNumber,'1024:768');
	
	//BI地图正式环境
	//popWindow('http://10.88.248.131:7001/richfit/flexos/index.jsp?orgId=<%=user.getSubOrgIDofAffordOrg() %>','1024:768');
	
	//BI地图测试环境
	//popWindow('http://10.88.248.133:7003/richfit/flexos/index.jsp?orgId=<%=user.getSubOrgIDofAffordOrg() %>','1024:768');
}

function alertInternational(){
	popWindow('<%=contextPath %>/pm/projectDynamic/international.jsp','1024:768');
}

function inBrowse(status,orgId){
	var nowDate = new Date();
	var year = nowDate.getFullYear();
	var month = nowDate.getMonth()+1;
	var day = nowDate.getDate();
	var endDate = "";
	if(month >= 10){
		endDate = year + "-" + month + "-" + day;
	}else{
		endDate = year + "-0" + month + "-" + day;
	}
	popWindow(getContextPath() + "/pm/chart/chart7.jsp?orgSubjectionId="+orgId,'1024:768');
}
</script>
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

