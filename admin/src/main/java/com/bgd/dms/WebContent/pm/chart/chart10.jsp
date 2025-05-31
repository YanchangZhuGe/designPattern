<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
//公司队伍动态表
	String contextPath=request.getContextPath();
%>
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<table width="100%" id="lineTable_12312123" border="1" align="center">
	<tr background="blue" class="bt_info">
      <td class="tableHeader" width="25%">直属单位</td>
      <td class="tableHeader" width="15%">队伍总数</td>
      <td class="tableHeader" width="15%">运行</td>
      <td class="tableHeader" width="15%">闲置</td>
<!--  <td class="tableHeader" width="15%">准备</td>
      <td class="tableHeader" width="15%">结束</td>
 -->      
    </tr>
</table>
<script type="text/javascript">

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

var retObj = jcdpCallServiceCache("TeamDynamicSrv","getTeamStatistics","startDate=" + startDate + "&endDate="+endDate);
if(retObj.teamStatistics != null){
	dataXml = retObj.Str;
	dataXml2 = retObj.Str2;
	dataXml3 = retObj.Str3;
	for(var i=0;i<retObj.teamStatistics.length;i++){
		var record = retObj.teamStatistics[i];
		var rowNum = i;
		var tr = document.getElementById("lineTable_12312123").insertRow();
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
//		tr.insertCell().innerHTML = '<a onclick="inBrowse(\'prepare\',\''+record.orgCode+'\');">'+record.teamPrepareNums+'</a>';
//		tr.insertCell().innerHTML = '<a onclick="inBrowse(\'stop\',\''+record.orgCode+'\');">'+record.teamStopNums+'</a>';
	}
}

function inBrowse(status,orgId){
	popWindow(getContextPath() + "/pm/teamDynamic/chujiOrgStatistics.jsp?orgSubjectionId="+orgId);
}

function open1(orgSubjectionId){
	popWindow(getContextPath() + "/pm/teamDynamic/chujiOrgStatistics.jsp?orgSubjectionId=" + orgSubjectionId);
}


</script>  

