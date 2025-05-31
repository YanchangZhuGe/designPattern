<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
//物探处项目运行动态
	String contextPath=request.getContextPath();
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	if(orgSubjectionId == null || "".equals(orgSubjectionId)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
	}
	if("C105008".equals(orgSubjectionId)){//综合物化探
		response.sendRedirect(contextPath+"/pm/chart/wt/chart3.jsp");
	}else if("C105007".equals(orgSubjectionId)){
		response.sendRedirect(contextPath+"/pm/chart/dg/dg_chujiFrame.jsp");
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
</head>
<body style="overflow-y: auto;background:#C0E2FB;">
<table id="lineTable" border="1" align="center" width="100%">
	<tr background="blue" class="bt_info">
      <td class="tableHeader"  id="td1" colspan="10"></td>
    </tr>
    <tr background="blue" class="bt_info">
      <td class="tableHeader"  id="td2" colspan="10" align="left"></td>
    </tr>
    <tr background="blue" class="bt_info">
      <td class="tableHeader"  id="td3" colspan="10" align="right"></td>
    </tr>
    <tr background="blue" class="bt_info">
      <td class="tableHeader" rowspan="2">项目名称</td>
      <td class="tableHeader" rowspan="2">甲方单位</td>
      <td class="tableHeader" rowspan="2">队号</td>
      <!-- 
      <td class="tableHeader" rowspan="2">队经理</td> -->
      <td class="tableHeader"  colspan="2">设计</td>
      <td class="tableHeader"  colspan="2">完成</td>
      <td class="tableHeader" rowspan="2">进度</td>
      <td class="tableHeader" rowspan="2">状态</td>
      <!-- <td class="tableHeader" colspan="3">健康状况</td> -->
      <td class="tableHeader" rowspan="2">结束日期</td>
    </tr>
    <tr background="blue" class="bt_info">
    	<td class="tableHeader" >km/km²</td>
    	<td class="tableHeader" >炮数</td>
    	<td class="tableHeader" >km/km²</td>
    	<td class="tableHeader" >炮数</td>
    	<!-- <td class="tableHeader" >生产</td>
    	<td class="tableHeader" >质量</td>
    	<td class="tableHeader" >HSE</td> -->
    </tr>
</table>
</body>
</html>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';

var retObj = jcdpCallServiceCache("ChartSrv","getProjectDynamic","orgSubjectionId=<%=orgSubjectionId %>");
if(retObj.map != null){
	var td1 = document.getElementById("td1");
	td1.innerHTML = retObj.map.orgName+"_项目运行动态表";
	
	var td2 = document.getElementById("td2");
	td2.innerHTML = "截止到"+retObj.map.endDate+"，正在运行的项目"+retObj.map.workNum+"个，正在准备的项目"+retObj.map.readyNum+"个，已完工的项目"+retObj.map.stopNum+"个，累计完成二维"+retObj.map.finish_2d_workload+"km，"+retObj.map.daily_finishing_2d_sp+"炮，完成三维"+retObj.map.finish_3d_workload+"km²，"+retObj.map.daily_finishing_3d_sp+"炮";
	
	var td3 = document.getElementById("td3");
	td3.innerHTML = "起止日期："+retObj.map.startDate+" 至 "+retObj.map.endDate;
}
if(retObj.list != null){
	for (var i = 0; i < retObj.list.length ; i++) {
		var data = retObj.list[i];
		var rowNum = i;
		var tr = document.getElementById("lineTable").insertRow();
		if(rowNum % 2 == 0){
			tr.className = "even";
		}else{
			tr.className = "odd";
		}
		tr.id="line_"+rowNum;
		
		//单元格
		tr.insertCell().innerHTML = data.project_name;
		tr.insertCell().innerHTML = data.coding_name;
		tr.insertCell().innerHTML = data.org_abbreviation;
		//tr.insertCell().innerHTML = data.vsp_team_leader;
		tr.insertCell().innerHTML = data.design_object_workload;
		tr.insertCell().innerHTML = data.design_sp_num;
		tr.insertCell().innerHTML = data.daily_workload;
		tr.insertCell().innerHTML = data.daily_sp;
		tr.insertCell().innerHTML = data.workload_radio;
		tr.insertCell().innerHTML = data.project_status;
		//tr.insertCell().innerHTML = "<img src='<%=contextPath%>/pm/projectHealthInfo/head"+data.pm_info+".jpg' alt='生产' style='cursor: pointer;'  onclick=openProjectHealth('"+data.project_info_no+"','0') width='14px' height='14px'/>";
		//tr.insertCell().innerHTML = "<img src='<%=contextPath%>/pm/projectHealthInfo/head"+data.qm_info+".jpg' alt='质量' style='cursor: pointer;'  onclick=openProjectHealth('"+data.project_info_no+"','1') width='14px' height='14px'/>";
		//tr.insertCell().innerHTML = "<img src='<%=contextPath%>/pm/projectHealthInfo/head"+data.hse_info+".jpg' alt='HSE' style='cursor: pointer;'  onclick=openProjectHealth('"+data.project_info_no+"','2') width='14px' height='14px'/>";
		tr.insertCell().innerHTML = data.project_end_date;
	}
}
function openProjectHealth(projectInfoNo,flag){
	popWindow('<%=contextPath%>/pm/projectHealthInfo/detail.jsp?healthInfoId='+projectInfoNo+'&flag='+flag,'1280:800');
}


</script>  

