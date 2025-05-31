<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}
	String basePlanId = request.getParameter("basePlanId") != null ? request.getParameter("basePlanId"):"";
	String notSaveFlag = request.getParameter("notSaveFlag") != null ? request.getParameter("notSaveFlag"):"";
	String action = request.getParameter("action");
	if(action == null || "".equals(action)){
		action = "edit";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title></title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
</head>
<script type="text/javascript" language="javascript">

cruConfig.contextPath =  "<%=contextPath%>";
var notSaveFlag = "<%=notSaveFlag %>";
var basePlanId = "<%=basePlanId %>";
function loadData(){
	var ids = "<%=projectInfoNo %>";
	
	var retObj = jcdpCallService("ProjectPlanSrv", "getEditWtProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);//从 bgp_pm_project_plan 计划表中取数据
	
	if(retObj.map == undefined){
		//需要创建记录
		document.getElementById("message").innerHTML = '<font color="red">该信息尚未保存</font>';
		
		retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);//查询项目信息
		
		document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
		document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
		document.getElementById("project_name").value = retObj.map.project_name;
		document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
		document.getElementById("exploration_method").value = retObj.map.exploration_method;
		if(retObj.dynamicMap != undefined){
		document.getElementById("org_id").value = retObj.dynamicMap.org_id;
		document.getElementById("org_subjection_id").value = retObj.dynamicMap.org_subjection_id;
		}
		document.getElementById("notes_td").innerHTML= retObj.map.notes;
		document.getElementById("notes").value = retObj.map.notes;
		
		
		document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
		document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
		document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
		//document.getElementById("start_date").value = retObj.map.design_start_date;
		//document.getElementById("end_date").value = retObj.map.design_end_date;
		//document.getElementById("duration_date").value = retObj.map.duration_date;
		
	} else {
		
		
		//无须创建记录
		//alert("editbaseInfo 无须创建记录");
		document.getElementById("object_id").value = retObj.map.object_id;
		document.getElementById("plan_num_value").value = retObj.map.base_plan_id;
		
			
			//此页面为显示 页面 之前的值未保存   ，修改时重新在读取一遍数据  
			retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
			document.getElementById("message").innerHTML = '';
			document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
			document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
			document.getElementById("project_name").value = retObj.map.project_name;
			document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
			document.getElementById("exploration_method").value = retObj.map.exploration_method;
			if(retObj.dynamicMap != undefined){
				document.getElementById("org_id").value = retObj.dynamicMap.org_id;
				document.getElementById("org_subjection_id").value = retObj.dynamicMap.org_subjection_id;
				}
			document.getElementById("notes_td").value= retObj.map.notes;
			document.getElementById("notes").value = retObj.map.notes;

			debugger;
			
			document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
			document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
			document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';

			
		
	}
	
	//$("#lineTable input[type=text]").attr("disabled",false);
	parent.document.all("if1").style.height=document.body.scrollHeight; 
	parent.document.all("if1").style.width=document.body.scrollWidth; 
}

function getBaseInfoStr(){

	var str= "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));


	return str;
	<%--
	var str= "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
	str += "&manage_org_name="+encodeURI(encodeURI(document.getElementById("manage_org_name").value));
	str += "&exploration_method="+document.getElementById("exploration_method").value;
	str += "&org_id="+document.getElementById("org_id").value;
	str += "&org_subjection_id="+document.getElementById("org_subjection_id").value;
	str += "&start_date="+document.getElementById("start_date").value;
	str += "&end_date="+document.getElementById("end_date").value;
	str += "&duration_date="+document.getElementById("duration_date").value;
	str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
	str += "&plan_num_value="+document.getElementById("plan_num_value").value;
	str += "&design_line_num="+document.getElementById("design_line_num").value;
	str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	str += "&design_execution_area="+document.getElementById("design_execution_area").value;
	str += "&design_data_area="+document.getElementById("design_data_area").value;
	str += "&design_sp_area="+document.getElementById("design_sp_area").value;
	str += "&design_geophone_area="+document.getElementById("design_geophone_area").value;
	str += "&measure_km="+document.getElementById("measure_km").value;
	str += "&design_sp_num_zy="+document.getElementById("design_sp_num_zy").value;
	return str;
	--%>
}

function save(){
	
	var orgInfoStr = "";
	var projectPlanStr = "";
	var ctt = this.parent.frames;
	if(ctt.length != 0){
		orgInfoStr = ctt.frames["if2"].getOrgInfoStr();
		projectPlanStr = ctt.frames["if3"].getProjectPlanStr();
	}
	
	var str="project_info_no=<%=projectInfoNo %>";
	str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
	str += "&manage_org_name="+encodeURI(encodeURI(document.getElementById("manage_org_name").value));
	str += "&exploration_method="+document.getElementById("exploration_method").value;
	str += "&org_id="+document.getElementById("org_id").value;
	str += "&org_subjection_id="+document.getElementById("org_subjection_id").value;
	str += "&start_date="+document.getElementById("start_date").value;
	str += "&end_date="+document.getElementById("end_date").value;
	str += "&duration_date="+document.getElementById("duration_date").value;
	str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
	str += "&plan_num_value="+document.getElementById("plan_num_value").value;
	str += "&design_line_num="+document.getElementById("design_line_num").value;
	str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	str += "&design_execution_area="+document.getElementById("design_execution_area").value;
	str += "&design_data_area="+document.getElementById("design_data_area").value;
	str += "&design_sp_area="+document.getElementById("design_sp_area").value;
	str += "&design_geophone_area="+document.getElementById("design_geophone_area").value;
	str += "&measure_km="+document.getElementById("measure_km").value;
	str += "&design_sp_num_zy="+document.getElementById("design_sp_num_zy").value;
	str += "&object_id="+document.getElementById("object_id").value;
	str += orgInfoStr;
	str += projectPlanStr;
	
	if(basePlanId != "" && basePlanId != undefined){
		var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
		if(retObj != null && retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		loadData();
	}else{
		var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectPlan", str);
		if(retObj != null && retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		loadData();
	}
	
}

function saveBaseInfo(){
	var str="project_info_no=<%=projectInfoNo %>";
	str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
	str += "&manage_org_name="+encodeURI(encodeURI(document.getElementById("manage_org_name").value));
	str += "&exploration_method="+document.getElementById("exploration_method").value;
	str += "&org_id="+document.getElementById("org_id").value;
	str += "&org_subjection_id="+document.getElementById("org_subjection_id").value;
	str += "&start_date="+document.getElementById("start_date").value;
	str += "&end_date="+document.getElementById("end_date").value;
	str += "&duration_date="+document.getElementById("duration_date").value;
	str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
	str += "&plan_num_value="+document.getElementById("plan_num_value").value;
	str += "&design_line_num="+document.getElementById("design_line_num").value;
	str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	str += "&design_execution_area="+document.getElementById("design_execution_area").value;
	str += "&design_data_area="+document.getElementById("design_data_area").value;
	str += "&design_sp_area="+document.getElementById("design_sp_area").value;
	str += "&design_geophone_area="+document.getElementById("design_geophone_area").value;
	str += "&measure_km="+document.getElementById("measure_km").value;
	str += "&design_sp_num_zy="+document.getElementById("design_sp_num_zy").value;
	
	var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
	if(retObj != null && retObj.message == "success") {
		
	} else {
		alert("修改基本信息失败");
		return;
	}
}

</script>
<body onload="loadData()" style="overflow:hidden;">


<input type="hidden" id="project_name"/>
<input type="hidden" id="manage_org_name"/>
<input type="hidden" id="plan_num_value"/>
<input type="hidden" id="exploration_method"/>
<input type="hidden" id="org_id"/>
<input type="hidden" id="org_subjection_id"/>
<input type="hidden" id="object_id"/>
<%-- 
<input type="hidden" id="start_date"/>
<input type="hidden" id="end_date"/>
<input type="hidden" id="duration_date"/>
--%>



<div id="addChangePlan" align="left">&nbsp;&nbsp;<b>修改项目初始计划</b></div>
<div id="message" align="center"><font color="red">该信息尚未保存</font></div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr>
		<td><div class="tongyong_box_title">1.1 项目来源：</div></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">


<td class="inquire_form4" id="manage_org_name_td"></td>
</tr>
<tr class="odd">
<td class="inquire_form4" id="project_name_td"></td>
</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.2 地质任务：</div></td>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
  <tr>
  <input type="hidden" id="notes"/>	
	<td colspan="3" class="inquire_form4"><textarea id="notes_td"  name="notes_td"cols="45" rows="5" class="textarea" readonly="readonly"></textarea></td>
	</tr>
</table>
<%--#########################################设计工作量###########################################--%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.3 工作量部署：</div></td>
</table>

<iframe width="100%" id="viewprojectiframe" height="100%" frameborder="0" src="<%=contextPath %>/wt/pm/planManager/singlePlan/progress/viewProject.jsp" style="overflow: scroll;"></iframe>


<%--#########################################设计工作量###########################################--%>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.4 施工方法：</div></td>
</table>
<iframe width="100%" id="technicalparameteriframe" height="100%" frameborder="0" src="<%=contextPath %>/wt/tm/parameter/technicalParameter.jsp?action=view"  style="overflow: scroll;"></iframe>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.5 工期要求：</div></td>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">

<td class="inquire_form4"  id="start_date_td"></td>
</tr>
<tr class="odd">
<td class="inquire_form4" id="end_date_td"></td>
</tr>
<tr class="even">
<td class="inquire_form4" id="duration_date_td"></td>
</tr>
</table>

<div id="oper_div">

</div>
<table>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
</table>
<script type="text/javascript" language="javascript">
if(basePlanId != ""){
	$("#addChangePlan").html("&nbsp;&nbsp;<b>修改项目变更计划"+basePlanId+"</b>");
}
</script>
</body>
</html>