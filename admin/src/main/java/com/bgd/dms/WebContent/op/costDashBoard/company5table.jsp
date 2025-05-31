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
	String orgId=request.getParameter("orgId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>物探处收入情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
</head>
<body style="background: #C0E2FB; overflow-y: auto" onload="drawPage()">
<input type="hidden" id="lineNum" value="0"/>
<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
    <tr class="bt_info">
      <td class="tableHeader">项目名称</td>
      <td class="tableHeader">类型</td>
      <td class="tableHeader">队伍</td>
      <td class="tableHeader">项目支出(万元)</td>
      <td class="tableHeader">采集开始时间</td>
      <td class="tableHeader">采集结束时间</td>
      <td class="tableHeader">项目状况</td>
    </tr>
  </table>
  </body>
  
  <script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
function drawPage(){
	var retObj = jcdpCallService("OPCostSrv","getSectionTeamOutcomeInfo","orgId=<%=orgId%>");
	if(retObj.datas != null){
		for(var i=0;i<retObj.datas.length;i++){
			var record = retObj.datas[i];
			var rowNum = i;
			var tr = document.getElementById("lineTable").insertRow();
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.height= 25;
			// 单元格
			var td1=tr.insertCell();
			td1.innerHTML = "<a href='#' onclick=open1('"+record.project_info_no+"')>"+record.w_label+"</a>";
			tr.insertCell().innerHTML = record.exploration_method;
			tr.insertCell().innerHTML = record.team_name;
			tr.insertCell().innerHTML = record.new_price;
			tr.insertCell().innerHTML = record.acquire_start_time;
			tr.insertCell().innerHTML = record.acquire_end_time;
			tr.insertCell().innerHTML = record.project_status;
			
		}
		document.getElementById("lineNum").value = retObj.datas.length;
	}
}
function open1(project_info_no){
	var obj=new Object();
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/team7.jsp?projectInfoNo="+project_info_no,obj,"dialogWidth=800px;dialogHeight=600px");
}
</script>
  </html>