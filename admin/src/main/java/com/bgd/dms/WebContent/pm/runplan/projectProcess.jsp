
<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>项目进度计划</title>
<style type="text/css">
.td_title1 {
	FONT-SIZE: 16px;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	height:30px;
}
.td_title2 {
	FONT-SIZE: 15px;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	height:30px;
}
.td_title3 {
	FONT-SIZE: 14px;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	height:30px;
}
</style>
<script type="text/javascript">
var projectInfoNo = "<%=projectInfoNo%>";
cruConfig.contextPath =  "<%=contextPath%>";

function loadData(){
	getProjctFrom();
	getGeologicalTask();
	getWorkload();
	getDurationInfo();
	getTeamInfo();
	getOrgInfo();
	getEffectTime();
}

function getProjctFrom(){
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no=" + projectInfoNo);
	if(retObj.map == undefined){
		retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=" + projectInfoNo);
		document.getElementById("td_project_from").innerHTML= '本项目来源于<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
		document.getElementById("td_project_name").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
	}else{
		if(retObj.map.manage_org_name == undefined || retObj.map.project_name == undefined || retObj.map.exploration_method == undefined ||  retObj.map.org_id == undefined || retObj.map.project_name == "" || retObj.map.org_id == "" || retObj.map.manage_org_name == "" || retObj.map.exploration_method == ""){
			document.getElementById("td_project_from").innerHTML= '本项目来源于<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
			document.getElementById("td_project_name").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
		}
		else{
			document.getElementById("td_project_from").innerHTML= '本项目来源于<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
			document.getElementById("td_project_name").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
		}
	}
}

function getGeologicalTask(){
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no=" + projectInfoNo);
	if(retObj.map == undefined){
		document.getElementById("td_geological_task").innerHTML= retObj.map.notes;
	}else{
		if(retObj.map.notes == undefined || retObj.map.notes == ""){
			retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=" + projectInfoNo);
			document.getElementById("td_geological_task").innerHTML = retObj.map.notes;
		}else{
			document.getElementById("td_geological_task").innerHTML= retObj.map.notes;
		}
	}
}

function getWorkload(){
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no=" + projectInfoNo);
	if(retObj.map == undefined){
		if(retObj.map.exploration_method == "0300100012000000002"){
			//二维
			document.getElementById("td_workload").innerHTML= '二维测线：<font style="text-decoration: underline;">'+retObj.dynamicMap.design_line_num+'</font>条<font style="text-decoration: underline;">'+retObj.dynamicMap.design_object_workload+'</font>km<font style="text-decoration: underline;">'+retObj.dynamicMap.design_sp_num+'</font>炮';
		} else {
			//三维
			document.getElementById("td_workload").innerHTML= '三维偏前满覆盖面积：<font style="text-decoration: underline;">'+retObj.dynamicMap.design_object_workload+'</font>km²<font style="text-decoration: underline;">'+retObj.dynamicMap.design_line_num+'</font>束线<font style="text-decoration: underline;">'+retObj.dynamicMap.design_sp_num+'</font>炮';
		}
	}else{
		if(retObj.map.design_object_workload == undefined || retObj.map.design_line_num == undefined || retObj.map.design_line_num == "" || retObj.map.design_object_workload == "" || retObj.map.design_sp_num == undefined || retObj.map.design_sp_num == ""){
			retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=" + projectInfoNo);
			if(retObj.map.exploration_method == "0300100012000000002"){
				//二维
				document.getElementById("td_workload").innerHTML= '二维测线：<font style="text-decoration: underline;">'+retObj.dynamicMap.design_line_num+'</font>条<font style="text-decoration: underline;">'+retObj.dynamicMap.design_object_workload+'</font>km<font style="text-decoration: underline;">'+retObj.dynamicMap.design_sp_num+'</font>炮';
			} else {
				//三维
				document.getElementById("td_workload").innerHTML= '三维偏前满覆盖面积：<font style="text-decoration: underline;">'+retObj.dynamicMap.design_object_workload+'</font>km²<font style="text-decoration: underline;">'+retObj.dynamicMap.design_line_num+'</font>束线<font style="text-decoration: underline;">'+retObj.dynamicMap.design_sp_num+'</font>炮';
			}
		}else{
			if(retObj.map.exploration_method == "0300100012000000002"){
				//二维
				document.getElementById("td_workload").innerHTML= '二维测线：<font style="text-decoration: underline;">'+retObj.map.design_line_num+'</font>条<font style="text-decoration: underline;">'+retObj.map.design_object_workload+'</font>km<font style="text-decoration: underline;">'+retObj.map.design_sp_num+'</font>炮';
			} else {
				//三维
				document.getElementById("td_workload").innerHTML= '三维偏前满覆盖面积：<font style="text-decoration: underline;">'+retObj.map.design_object_workload+'</font>km²<font style="text-decoration: underline;">'+retObj.map.design_line_num+'</font>束线<font style="text-decoration: underline;">'+retObj.map.design_sp_num+'</font>炮';
			}
		}
	}
}

function getDurationInfo(){
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no=" + projectInfoNo);
	if(retObj.map == undefined){
		retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=" + projectInfoNo);
		document.getElementById("td_start_date").innerHTML= '开工时间：'+retObj.map.design_start_date;
		document.getElementById("td_end_date").innerHTML= '收工时间：'+retObj.map.design_end_date;
		document.getElementById("td_duration_date").innerHTML= '自然天数：'+retObj.map.duration_date+'天';
	} else {
		//无须创建记录
		if(retObj.map.end_date == undefined || retObj.map.start_date == undefined || retObj.map.start_date == "" || retObj.map.end_date == "" || retObj.map.duration_date == undefined || retObj.map.duration_date == ""){
			//该页面所需的值有缺失 需更新记录
			retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=" + projectInfoNo);
			document.getElementById("td_start_date").innerHTML= '开工时间：'+retObj.map.design_start_date;
			document.getElementById("td_end_date").innerHTML= '收工时间：'+retObj.map.design_end_date;
			document.getElementById("td_duration_date").innerHTML= '自然天数：'+retObj.map.duration_date+'天';
		} else {
			//显示数据库中保存的值
			document.getElementById("td_start_date").innerHTML= '开工时间：'+retObj.map.start_date;
			document.getElementById("td_end_date").innerHTML= '收工时间：'+retObj.map.end_date;
			document.getElementById("td_duration_date").innerHTML= '自然天数：'+retObj.map.duration_date+'天';
		}
	}
}

function getTeamInfo(){
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no=" + projectInfoNo);
	if(retObj.map == undefined){
		retObj = jcdpCallService("ProjectPlanSrv", "getTeamInfo", "projectInfoNo=" + projectInfoNo);
		document.getElementById("td_team_id").innerHTML= '队号：'+retObj.map.team_id;
		document.getElementById("td_is_majorteam").innerHTML= '地震队资质：'+retObj.map.is_majorteam;
		document.getElementById("td_team_leader").innerHTML= '队经理：'+retObj.map.team_leader;
	} else {
		if(retObj.map.is_majorteam == undefined || retObj.map.team_id == undefined || retObj.map.team_id == "" || retObj.map.is_majorteam == "" || retObj.map.team_leader == undefined || retObj.map.team_leader == ""){
			retObj = jcdpCallService("ProjectPlanSrv", "getTeamInfo", "projectInfoNo=" + projectInfoNo);
			document.getElementById("td_team_id").innerHTML= '队号：'+retObj.map.team_id;
			document.getElementById("td_is_majorteam").innerHTML= '地震队资质：'+retObj.map.is_majorteam;
			document.getElementById("td_team_leader").innerHTML= '队经理：'+retObj.map.team_leader;
		} else {
			document.getElementById("td_team_id").innerHTML= '队号：'+retObj.map.team_id;
			document.getElementById("td_is_majorteam").innerHTML= '地震队资质：'+retObj.map.is_majorteam;
			document.getElementById("td_team_leader").innerHTML= '队经理：'+retObj.map.team_leader;
		}
	}
}

function getOrgInfo(){
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no=" + projectInfoNo);
	if(retObj.map == undefined){
		retObj = jcdpCallService("ProjectPlanSrv", "getOrgInfo", "projectInfoNo=" + projectInfoNo);
		document.getElementById("td_team_leader").innerHTML = retObj.map.team_leader;
		document.getElementById("td_collect_leader").innerHTML = retObj.map.collect_leader;
		document.getElementById("td_surface_monitor").innerHTML = retObj.map.surface_monitor;
	} else {
		var temp = jcdpCallService("ProjectPlanSrv", "getOrgInfo", "projectInfoNo=" + projectInfoNo);
		
		if(retObj.map.team_leader == undefined || retObj.map.team_leader == ""){
			document.getElementById("td_team_leader").innerHTML = temp.map.team_leader;
		} else {
			document.getElementById("td_team_leader").innerHTML = retObj.map.team_leader;
		}
		
		if(retObj.map.collect_leader == undefined || retObj.map.collect_leader == ""){
			document.getElementById("td_collect_leader").innerHTML = temp.map.collect_leader;
		} else {
			document.getElementById("td_collect_leader").innerHTML = retObj.map.collect_leader;
		}
		
		if(retObj.map.surface_monitor == undefined || retObj.map.surface_monitor == ""){
			document.getElementById("td_surface_monitor").innerHTML = temp.map.surface_monitor;
		} else {
			document.getElementById("td_surface_monitor").innerHTML = retObj.map.surface_monitor;
		}
		
		if(retObj.map.powder_monitor == undefined || retObj.map.powder_monitor == ""){
			document.getElementById("td_powder_monitor").innerHTML = temp.map.powder_monitor;
		} else {
			document.getElementById("td_powder_monitor").innerHTML = retObj.map.powder_monitor;
		}
		
		if(retObj.map.instrument_monitor == undefined || retObj.map.instrument_monitor == ""){
			document.getElementById("td_instrument_monitor").innerHTML = temp.map.instrument_monitor;
		} else {
			document.getElementById("td_instrument_monitor").innerHTML = retObj.map.instrument_monitor;
		}
		
		if(retObj.map.acquire_leader == undefined || retObj.map.acquire_leader == ""){
			document.getElementById("td_acquire_leader").innerHTML = temp.map.acquire_leader;
		} else {
			document.getElementById("td_acquire_leader").innerHTML = retObj.map.acquire_leader;
		}
		
		if(retObj.map.dirll_leader == undefined || retObj.map.dirll_leader == ""){
			document.getElementById("td_dirll_leader").innerHTML = temp.map.dirll_leader;
		} else {
			document.getElementById("td_dirll_leader").innerHTML = retObj.map.dirll_leader;
		}
		
		if(retObj.map.dirll_monitor == undefined || retObj.map.dirll_monitor == ""){
			document.getElementById("td_dirll_monitor").innerHTML = temp.map.dirll_monitor;
		} else {
			document.getElementById("td_dirll_monitor").innerHTML = retObj.map.dirll_monitor;
		}
		
		if(retObj.map.survey_leader == undefined || retObj.map.survey_leader == ""){
			document.getElementById("td_survey_leader").innerHTML = temp.map.survey_leader;
		} else {
			document.getElementById("td_survey_leader").innerHTML = retObj.map.survey_leader;
		}
		
		if(retObj.map.survey_monitor == undefined || retObj.map.survey_monitor == ""){
			document.getElementById("td_survey_monitor").innerHTML = temp.map.survey_monitor;
		} else {
			document.getElementById("td_survey_monitor").innerHTML = retObj.map.survey_monitor;
		}
		
		if(retObj.map.geophysical_division == undefined || retObj.map.geophysical_division == ""){
			document.getElementById("td_geophysical_division").innerHTML = temp.map.geophysical_division;
		} else {
			document.getElementById("td_geophysical_division").innerHTML = retObj.map.geophysical_division;
		}
	}
}

function getEffectTime(){
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no=" + projectInfoNo);
	if(retObj.map == undefined){
		retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=" + projectInfoNo);
		document.getElementById("td_weather_delay").innerHTML = retObj.map.weather_delay + "&nbsp;天";
	} else {
		if(retObj.map.weather_delay == undefined || retObj.map.weather_delay == undefined){
			//手填 不提取
		} else {
			//显示数据库中保存的值
			document.getElementById("td_weather_delay").innerHTML = retObj.map.weather_delay + "&nbsp;天";
		}
	}
}
</script>
</head>
<body style="background:#FFFFFF;overflow: auto;" onload="loadData();">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr><td>&nbsp;&nbsp;</td></tr>
 <tr><td class="td_title1">&nbsp;&nbsp;项目进度计划</td></tr>
 <tr><td class="td_title2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;项目概况</td></tr>
 <tr><td class="td_title3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;项目来源</td></tr>
 <tr>
    <td><table><tr>
    		<td width="80px"></td></td>
    		<td><table>
    			<tr><td height="25px" id="td_project_from"></td></tr>
    			<tr><td id="td_project_name"></td></tr>
    		</table></td>
    </tr></table></td>
 </tr>
 <tr><td class="td_title3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;地质任务</td></tr>
 <tr>
    <td><table width="100%"><tr>
    		<td width="80px"></td></td>
    		<td><table width="80%">
    			<tr><td height="25px" width="100%" id="td_geological_task"></td></tr>
    		</table></td>
    </tr></table></td>
 </tr>
 <tr><td class="td_title3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;工作量部署</td></tr>
 <tr>
    <td><table width="100%"><tr>
    		<td width="80px"></td></td>
    		<td><table width="80%">
    			<tr><td height="25px" width="100%">本次部署工作量</td></tr>
    			<tr><td height="25px" width="100%" id="td_workload"></td></tr>
    		</table></td>
    </tr></table></td>
 </tr>
 <tr><td class="td_title3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;施工方法</td></tr>
 <tr><td class="td_title3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;工期要求</td></tr>
 <tr>
    <td><table width="100%"><tr>
    		<td width="80px"></td></td>
    		<td><table width="80%">
    			<tr><td height="25px" width="100%" id="td_start_date"></td></tr>
    			<tr><td height="25px" width="100%" id="td_end_date"></td></tr>
    			<tr><td height="25px" width="100%" id="td_duration_date"></td></tr>
    		</table></td>
    </tr></table></td>
 </tr>
 <tr><td class="td_title2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;组织机构</td></tr>
 <tr><td class="td_title3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;队伍信息</td></tr>
 <tr>
    <td><table width="100%"><tr>
    		<td width="80px"></td></td>
    		<td><table width="80%">
    			<tr><td height="25px" width="100%" id="td_team_id"></td></tr>
    			<tr><td height="25px" width="100%" id="td_is_majorteam"></td></tr>
    			<tr><td height="25px" width="100%" id="td_team_leader"></td></tr>
    		</table></td>
    </tr></table></td>
 </tr>
 <tr><td class="td_title3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;组织构成</td></tr>
 <tr>
    <td><table width="100%"><tr>
    		<td width="80px"></td></td>
    		<td><table width="50%">
    			<tr><td width="25%">队经理：</td><td width="25%" height="25px" id="td_team_leader"></td>
    				<td width="25%">采集分管副经理：</td><td width="25%" height="25px" id="td_collect_leader"></td>
    			</tr>
    			<tr><td width="25%">放线班长：</td><td width="25%" height="25px" id="td_surface_monitor"></td>
    				<td width="25%">爆炸班长：</td><td width="25%" height="25px" id="td_powder_monitor"></td>
    			</tr>
    			<tr><td width="25%">仪器组长：</td><td width="25%" height="25px" id="td_instrument_monitor"></td>
    				<td width="25%">震源组长：</td><td width="25%" height="25px" id="td_acquire_leader"></td>
    			</tr>
    			<tr><td width="25%">钻井分管副经理：</td><td width="25%" height="25px" id="td_dirll_leader"></td>
    				<td width="25%">钻井组长：</td><td width="25%" height="25px" id="td_dirll_monitor"></td>
    			</tr>
    			<tr><td width="25%">测量分管副经理：</td><td width="25%" height="25px" id="td_survey_leader"></td>
    				<td width="25%">测量项目长：</td><td width="25%" height="25px" id="td_survey_monitor"></td>
    			</tr>
    			<tr><td width="25%">地球物理师：</td><td width="25%" height="25px" id="td_geophysical_division"></td>
    				<td width="25%"></td><td width="25%"></td>
    			</tr>
    		</table></td>
    </tr></table></td>
 </tr>
 <tr><td class="td_title2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;项目进度计划</td></tr>
 <tr><td class="td_title2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;自然因素影响时间</td></tr>
 <tr>
    <td><table width="100%"><tr>
    		<td width="60px"></td></td>
    		<td><table width="80%">
    			<tr><td height="25px" width="100%" id="td_weather_delay"></td></tr>
    		</table></td>
    </tr></table></td>
 </tr>
</table>
</body>
</html>