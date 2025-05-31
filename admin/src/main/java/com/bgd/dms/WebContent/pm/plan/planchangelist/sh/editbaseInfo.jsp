<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%
	String contextPath = request.getContextPath();

	String projectInfoNo = request.getParameter("projectInfoNo");
	String basePlanId = request.getParameter("basePlanId") != null
			? request.getParameter("basePlanId")
			: "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript"
	src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

<script type="text/javascript" language="javascript">
//alert("深海  editbaseInfo.jsp");
cruConfig.contextPath =  "<%=contextPath%>";
var basePlanId = "<%=basePlanId%>";
var ids = "<%=projectInfoNo%>";

function loadData(){
	
	var retObj = jcdpCallService("ProjectPlanSrv", "getEditProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);
	
	if(retObj.map == undefined){
		//需要创建记录
		document.getElementById("message").innerHTML = '<font color="red">该信息尚未保存</font>';
		retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
		document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
		document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
		document.getElementById("project_name").value = retObj.map.project_name;
		document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
		document.getElementById("exploration_method").value = retObj.map.exploration_method;
		document.getElementById("org_id").value = retObj.dynamicMap.org_id;
		document.getElementById("org_subjection_id").value = retObj.dynamicMap.org_subjection_id;
		document.getElementById("notes_td").innerHTML= retObj.map.notes;
		document.getElementById("notes").value = retObj.map.notes;
		
	
		
		
		document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
		document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
		document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
		document.getElementById("start_date").value = retObj.map.design_start_date;
		document.getElementById("end_date").value = retObj.map.design_end_date;
		document.getElementById("duration_date").value = retObj.map.duration_date;

		
		
		
		
	} else {
		//无须创建记录
		document.getElementById("object_id").value = retObj.map.object_id;
		document.getElementById("plan_num_value").value = retObj.map.base_plan_id;
		if(retObj.map.manage_org_name == undefined || retObj.map.project_name == undefined || retObj.map.exploration_method == undefined ||  retObj.map.org_id == undefined || retObj.map.project_name == "" || retObj.map.org_id == "" || retObj.map.manage_org_name == "" || retObj.map.exploration_method == "" ||retObj.map.end_date == undefined || retObj.map.start_date == undefined || retObj.map.start_date == "" || retObj.map.end_date == "" || retObj.map.duration_date == undefined || retObj.map.duration_date == ""){
			//该页面所需的值有缺失 需更新记录
			//document.getElementById("message").innerHTML = '<font color="red">该信息尚未保存</font>';
			retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
			document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
			document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
			document.getElementById("project_name").value = retObj.map.project_name;
			document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
			document.getElementById("exploration_method").value = retObj.map.exploration_method;
			//document.getElementById("org_id").value = retObj.dynamicMap.org_id;
			//document.getElementById("org_subjection_id").value = retObj.dynamicMap.org_subjection_id;
			
		
			
			document.getElementById("notes_td").value= retObj.map.notes;
			document.getElementById("notes").value = retObj.map.notes;
			


			document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
			document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
			document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
			document.getElementById("start_date").value = retObj.map.design_start_date;
			document.getElementById("end_date").value = retObj.map.design_end_date;
			document.getElementById("duration_date").value = retObj.map.duration_date;
			
			
			
			
		} else {
			//显示数据库中保存的值
			document.getElementById("message").style.display="none";
			document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
			document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
			document.getElementById("project_name").value = retObj.map.project_name;
			document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
			document.getElementById("exploration_method").value = retObj.map.exploration_method;
			document.getElementById("org_id").value = retObj.map.org_id;
			document.getElementById("org_subjection_id").value = retObj.map.org_subjection_id;
			
			document.getElementById("notes_td").value= retObj.map.notes;
			document.getElementById("notes").value = retObj.map.notes;
			
		
			
			document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
			document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
			document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
			document.getElementById("start_date").value = retObj.map.design_start_date;
			document.getElementById("end_date").value = retObj.map.design_end_date;
			document.getElementById("duration_date").value = retObj.map.duration_date;
			
			
			
		}
	}


	//1.3 工作量部署：
	var retObj2 = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=<%=projectInfoNo%>");
	document.getElementById("design_line_num").value= retObj2.dynamicMap.design_line_num;//设计线束数
	document.getElementById("workload_input2").value= retObj2.dynamicMap.design_sp_num;//设计工作量
	document.getElementById("design_workload1").value= retObj2.dynamicMap.design_workload1;
	document.getElementById("design_workload2").value= retObj2.dynamicMap.design_workload2;
	
	parent.document.all("if1").style.height=document.body.scrollHeight; 
	parent.document.all("if1").style.width=document.body.scrollWidth; 
}

function getBaseInfoStr(){

	var str= "";
	
	//隐藏  标识计划为初始计划还是补充计划
	str += "&plan_num_value="+document.getElementById("plan_num_value").value;//""为初始计划  1 2 3...为补充计划
	//未知
	str += "&exploration_method="+document.getElementById("exploration_method").value;
	str += "&org_id="+document.getElementById("org_id").value;
	str += "&org_subjection_id="+document.getElementById("org_subjection_id").value;

	//1.1 项目来源
	str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
	str += "&manage_org_name="+encodeURI(encodeURI(document.getElementById("manage_org_name").value));//本项目来源于

	
	//1.5 工期要求：
	str += "&start_date="+document.getElementById("start_date").value;
	str += "&end_date="+document.getElementById("end_date").value;
	str += "&duration_date="+document.getElementById("duration_date").value;
	//1.2 地质任务：
	str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
	

	// 1.3 工作量部署：
	//str += "&design_object_workload="+document.getElementById("design_object_workload").value;//设计工作量
	//str += "&design_line_num="+document.getElementById("design_line_num").value;//设计线束数


	return str;
}



</script>
</head>

<body onload="loadData()" style="overflow: hidden;">

<input type="hidden" id="project_name" />
<input type="hidden" id="manage_org_name" />
<input type="hidden" id="plan_num_value" />
<input type="hidden" id="exploration_method" />
<input type="hidden" id="org_id" />
<input type="hidden" id="org_subjection_id" />
<input type="hidden" id="object_id" />

<input type="hidden" id="notes" />

<input type="hidden" id="start_date" />
<input type="hidden" id="end_date" />
<input type="hidden" id="duration_date" />


<div id="addChangePlan" align="left">&nbsp;&nbsp;<b>修改项目初始计划</b></div>
<div id="message" align="center"><font color="red"></font></div>

<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<td>
		<div class="tongyong_box_title">1.1 项目来源：</div>
		</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr class="even">

		<td class="inquire_form4" id="manage_org_name_td"></td>
	</tr>
	<tr class="odd">
		<td class="inquire_form4" id="project_name_td"></td>
	</tr>
</table>





<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<td>
		<div class="tongyong_box_title">1.2 地质任务：</div>
		</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>

		<td colspan="3" class="inquire_form4"><textarea id="notes_td"
			name="notes_td" cols="45" rows="5" class="textarea"
			readonly="readonly"></textarea></td>
	</tr>
</table>




<%----------------------------------------------------------------------------------%>
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<td>
		<div class="tongyong_box_title">1.3 工作量部署：</div>
		</td>
	</tr>
</table>
<table width="100%" border="1" cellspacing="1" cellpadding="0"
	class="tab_line_height" id="lineTable" style="overflow: scroll;">
	<tr class="even">					
	    <td class="inquire_item6" >设计线束数：</td>
	    <td class="inquire_form6" ><input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;束</td>
	    <td class="inquire_item6" >设计工作量：</td>
	    <td class="inquire_form6" ><input type="text" id="workload_input2" name="workload_input2" class="input_width" disabled="disabled" />&nbsp;</td>
	</tr>
	<tr class="even">					
	    <td class="inquire_item6" >炮间距：</td>
	    <td class="inquire_form6" ><input type="text" id="design_workload1" name="design_workload1" class="input_width" disabled="disabled" />&nbsp;km²</td>
	    <td class="inquire_item6" >面元扩展：</td>
	    <td class="inquire_form6" ><input type="text" id="design_workload2" name="design_workload2" class="input_width" disabled="disabled" />&nbsp;km²</td>
	</tr>
</table>




<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<td>
		<div class="tongyong_box_title">1.4 施工方法：</div>
		</td>
	</tr>
</table>
<iframe width="100%" id="if5" height="100%" frameborder="0" src="<%=contextPath%>/pm/project/singleProject/sh/workmethod.jsp?projectInfoNo=<%=projectInfoNo%>&action=view" style="overflow: scroll;"></iframe>



<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<td>
		<div class="tongyong_box_title">1.5 工期要求：</div>
		</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr class="even">

		<td class="inquire_form4" id="start_date_td"></td>
	</tr>
	<tr class="odd">
		<td class="inquire_form4" id="end_date_td"></td>
	</tr>
	<tr class="even">
		<td class="inquire_form4" id="duration_date_td"></td>
	</tr>
</table>


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