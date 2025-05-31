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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>项目运行情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';

var nowDate = new Date();
var year = nowDate.getFullYear();
var month = nowDate.getMonth()+1;
var day = nowDate.getDate();
var date1 = year + "-01-01";
var date2 = "";
if(month >= 10){
	date2 = year + "-" + month + "-" + day;
}else{
	date2 = year + "-0" + month + "-" + day;
}

function statistics(){
	var startDate = document.getElementById("start_date").value;
	var endDate =  document.getElementById("end_date").value;
	
	if("" == startDate){
		alert("请选择开始日期!");
		return;
	}
	if("" == endDate){
		alert("请选择结束日期!");
		return;
	}
	clearData();
	drawPage();
}

function clearData(){
	//清除数据
	var lines = document.getElementById("lineNum").value;
	if(lines > 0){
	    for(var i=lines; i--; i >=0){
	    	var lineId = "line_"+i;
	    	var line = document.getElementById(lineId);
	    	if(line != null){
	    		line.parentNode.removeChild(line);
	    	}
	    }
	}
}

function setDateObject(){
	document.getElementById("start_date").value = date1;
	document.getElementById("end_date").value = date2;
	document.getElementById("endTd").innerHTML = date1+'至'+date2+'<input type="hidden" value="'+date1+'" id="start_date" name="start_date"  width="12" readonly/><input type="hidden" value="'+date2+'" id="end_date" name="start_date"  width="12" readonly/>';
}

function initData(){
	setDateObject();
	drawPage();
}

function drawPage(){
	var curDate = date2;
	var startDate = document.getElementById("start_date").value;
	var endDate =  document.getElementById("end_date").value;	
	var retObj = jcdpCallService("ProjectDynamicSrv","getProjectSiuation","curDate="+curDate+"&startDate=" + startDate + "&endDate="+endDate);
	var dataXml1="";
	var dataXml2="";
	
	if(retObj.projectStatistics != null){
		dataXml1=retObj.Str1;
		dataXml2=retObj.Str2;
		
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
			tr.insertCell().innerHTML = record.todayFinish2dSPNums;
			tr.insertCell().innerHTML = record.todayFinish2dNums;
			tr.insertCell().innerHTML = record.todayFinish3dSPNums;
			tr.insertCell().innerHTML = record.todayFinish3dNums;
			tr.insertCell().innerHTML = record.cumlativeFinish2dSPNums;
			tr.insertCell().innerHTML = record.cumlativeFinish2dNums;
			tr.insertCell().innerHTML = record.cumlativeFinish3dSPNums;
			tr.insertCell().innerHTML = record.cumlativeFinish3dNums;
		}
		document.getElementById("lineNum").value = retObj.projectStatistics.length;
	}
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId1", "100%", "100%", "0", "0" );
	myChart1.setXMLData(dataXml1);
	myChart1.render("chartContainer1");
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "ChartId2", "100%", "100%", "0", "0" );
	myChart2.setXMLData(dataXml2);
	myChart2.render("chartContainer2");
}

function inBrowse(orgId){
	popWindow(getContextPath() + "/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=yearProjectStat1&noLogin=admin&tokenId=admin&orgSubjectionId="+orgId);
}

function open1(orgCode){
	//popWindow('<%=contextPath %>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=yearProjectStat1&noLogin=admin&tokenId=admin&orgSubjectionId='+orgCode,'1024:768');
	popWindow('<%=contextPath %>/pm/chart/chart3.jsp?orgSubjectionId='+orgCode,'1024:768');
	//alert(orgCode);
}

</script>
<body style="background:#C0E2FB;overflow-y: auto" onload="initData()">
<input type="hidden" id="lineNum" value="0"/>
<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
    <tr background="blue" class="bt_info">
      <td colspan="9">&nbsp;</td>
      <td colspan="2">统计时间为</td>
      <td align="center" colspan="3" id="endTd">
      <input type="hidden" id="start_date" name="start_date"  width="12" readonly/>
      <input type="hidden" id="end_date" name="end_date"  width="12" readonly/>
      </td>
    </tr>
    <!-- 
    <tr class="bt_info">
      <td class="tableHeader" rowspan="3">单位名称</td>
      <td class="tableHeader" colspan="5">运 作 项 目 个 数</td>
      <td class="tableHeader" colspan="4">本 日 完 成</td>
      <td class="tableHeader" colspan="4">累 计 完 成</td>
    </tr> -->
    <tr class="bt_info">
      <td class="tableHeader" rowspan="2">单位名称</td>
      <td class="tableHeader" rowspan="2">结束</td>
      <td class="tableHeader" rowspan="2">运行</td>
      <td class="tableHeader" rowspan="2">暂停</td>
      <td class="tableHeader" rowspan="2">准备</td>
      <td class="tableHeader" rowspan="2">共计</td>
      <td class="tableHeader" colspan="2">二维日完成</td>
      <td class="tableHeader" colspan="2">三维日完成</td>
      <td class="tableHeader" colspan="2">二维累计</td>
      <td class="tableHeader" colspan="2">三维累计</td>
    </tr>
    <tr class="bt_info">
      <td class="tableHeader">炮数</td>
      <td class="tableHeader">公里</td>
      <td class="tableHeader">炮数</td>
      <td class="tableHeader">平方公里</td>
      <td class="tableHeader">炮数</td>
      <td class="tableHeader">公里</td>
      <td class="tableHeader">炮数</td>
      <td class="tableHeader">平方公里</td>
    </tr>
  </table>
  <table width="100%" align="center">
	<tr>
      <td width="20%"><div id="chartContainer1" align="center"></div></td>
      <td width="80%"><div id="chartContainer2" align="center"></div></td>
    </tr>
  </table>
  </body>
  </html>