<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
//物探处队伍动态表
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
	var retObj = jcdpCallServiceCache("TeamDynamicSrv","getTeamUse","orgSubId=<%=orgSubjectionId %>&startDate=" + startDate + "&endDate="+endDate);
	if(retObj.Str != null){
		dataXml = retObj.Str;
	}
	if(retObj.teamStatistics != null){
		for(var i=0;i<retObj.teamStatistics.length;i++){
			var record = retObj.teamStatistics[i];
			var rowNum = i;
			var tr = document.getElementById("lineTable111111").insertRow();
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.id="line_"+rowNum;
			tr.height= 20;
			// 单元格
			tr.insertCell().innerHTML = record.orgName;
			tr.insertCell().innerHTML = record.num;
			tr.insertCell().innerHTML = record.run;
			tr.insertCell().innerHTML = record.idle;
//			tr.insertCell().innerHTML = record.prepare;
//			tr.insertCell().innerHTML = record.stop;
			tr.insertCell().innerHTML = record.useTime;
		}
	}
}

</script>
<body  style="overflow-y: auto;background: #fff;" onload="initData()">
<table width="100%" id="lineTable111111" border="1" align="center">
	<tr background="blue" class="bt_info">
      <td class="tableHeader" width="22%">队伍名称</td>
      <td class="tableHeader" width="13%">队伍总数</td>
      <td class="tableHeader" width="13%">运行</td>
      <td class="tableHeader" width="13%">闲置</td>
<!--  <td class="tableHeader" width="13%">准备</td>
      <td class="tableHeader" width="13%">结束</td>
 -->      
      <td class="tableHeader" width="13%">动用次数</td>
    </tr>
</table>
</body>
</html>