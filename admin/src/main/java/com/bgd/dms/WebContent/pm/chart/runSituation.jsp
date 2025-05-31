<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
//公司项目运行动态
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId =  user.getEmpId();
	String contextPath = request.getContextPath();	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>项目运行情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
</head>
<body style="background: #C0E2FB;" >
<input type="hidden" id="lineNum" value="0"/>
<div id="table_div" style="overflow:auto;">
<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
    <tr background="blue" class="bt_info">
      <td colspan="9">&nbsp;</td>
      <td colspan="2">统计时间段</td>
      <td align="left" colspan="3" id="endTd">
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
  </div>
  </body>
  
  <script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
debugger;
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

$(function(){
	$("#table_div").css("height",$(window).height()-10);
});
function setDateObject(){
	//document.getElementById("startTd").innerHTML = date1+'<input type="hidden" value="'+date1+'" id="start_date" name="start_date"  width="12" readonly/>';
	document.getElementById("endTd").innerHTML = date1+'至'+date2+'<input type="hidden" value="'+date1+'" id="start_date" name="start_date"  width="12" readonly/><input type="hidden" value="'+date2+'" id="end_date" name="start_date"  width="12" readonly/>';
}

setDateObject();
drawPage();

function drawPage(){
	debugger
	var curDate = date2;
	var startDate = document.getElementById("start_date").value;
	var endDate =  document.getElementById("end_date").value;	
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
}
function open1(orgCode){
	//popWindow('<%=contextPath %>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=yearProjectStat1&noLogin=admin&tokenId=admin&orgSubjectionId='+orgCode,'1024:768');
	popWindow('<%=contextPath %>/pm/chart/chart3.jsp?orgSubjectionId='+orgCode,'1024:768');
	//alert(orgCode);
}
</script>
  </html>