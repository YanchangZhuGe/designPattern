<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	if(orgSubjectionId == null || "".equals(orgSubjectionId)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
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
<title>综合物化探项目运行动态</title>
</head>
<body style="overflow-y: auto;background:#C0E2FB;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="99%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">大港物探处项目运行动态</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 450px;">
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
							      <!-- <td class="tableHeader" rowspan="2">结束日期</td> -->
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
</body>
<script type="text/javascript">
var nowDate = new Date();
var year = nowDate.getFullYear();
cruConfig.contextPath =  "<%=contextPath%>";
var orgSubjectionId = "C105007";	

var retObj = jcdpCallService("ChartSrv","getProjectDynamicDg","orgSubjectionId=<%=orgSubjectionId %>&project_year="+year);
if(null!=retObj.map){
	var td2 = document.getElementById("td2");
	td2.innerHTML = "截止到"+retObj.map.endDate+"，正在运行的项目"+retObj.map.workNum+"个，正在准备的项目"+retObj.map.readyNum+"个，已完工的项目"+retObj.map.stopNum+"个，累计完成二维"+retObj.map.finish_2d_workload+"km，"+retObj.map.daily_finishing_2d_sp+"炮，完成三维"+retObj.map.finish_3d_workload+"km²，"+retObj.map.daily_finishing_3d_sp+"炮";
	
	var td3 = document.getElementById("td3");
	td3.innerHTML = "今年立项的项目截止日期："+retObj.map.endDate;

}
if(retObj.list != null){
	document.getElementById("chartContainer1").style.height=170+retObj.list.length*20;
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
		tr.insertCell().innerHTML = data.design_object_workload;
		tr.insertCell().innerHTML = data.design_sp_num;
		tr.insertCell().innerHTML = data.daily_workload;
		tr.insertCell().innerHTML = data.daily_sp;
		tr.insertCell().innerHTML = data.workload_radio;
		tr.insertCell().innerHTML = data.project_status;
		//tr.insertCell().innerHTML = data.project_end_date;
	}
}

 
</script>  
</html>
