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
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
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
debugger;
cruConfig.contextPath =  "<%=contextPath%>";
var notSaveFlag = "<%=notSaveFlag %>";
var basePlanId = "<%=basePlanId %>";
if(basePlanId != ""){
	$("#addChangePlan").html("&nbsp;&nbsp;<b>修改项目变更计划"+basePlanId+"</b>");
}

function loadData(){

	debugger;
	

	var ids = "<%=projectInfoNo %>";
	
	var retObj = jcdpCallService("ProjectPlanSrv", "getEditWtProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);
	if(retObj.map == undefined){
		//需要创建记录
		//alert('需要创建记录');
		<%--
	有数据
	队号：team_id_td
	队伍资质 is_majorteam_td
	队经理：team_leader
	副经理：collect_leader
	指导员：dirll_leader
	
	无数据
	仪器组长：instrument_monitor
	资料处理组长：geophysical_division
	司机组长：surface_monitor
	测量室内计算：powder_monitor
	--%>
		
		retObj = jcdpCallService("ProjectPlanSrv", "getWtOrgInfo", "projectInfoNo="+ids);//获得 队号 资质 经理 副经理 指导员
		
		if (typeof(retObj.rsMap.org_name) != "undefined")
		{
			document.getElementById("team_id_td").innerHTML= retObj.rsMap.org_name;//队号 1
			//document.getElementById("team_id").value= retObj.rsMap.org_name;//队号 1
		}
		if (typeof(retObj.rsMap.is_majorteam) != "undefined")
		{
			document.getElementById("is_majorteam_td").innerHTML= retObj.rsMap.is_majorteam;//队伍资质 2
		}
		if (typeof(retObj.rsMap.team_manager) != "undefined")
		{
			document.getElementById("team_leader").value = retObj.rsMap.team_manager;//队经理 3
		}
		if (typeof(retObj.rsMap.team_manager_f) != "undefined")
		{
			document.getElementById("collect_leader").value = retObj.rsMap.team_manager_f;//副经理 4
		}
		if (typeof(retObj.rsMap.instructor) != "undefined")
		{
			document.getElementById("dirll_leader").value = retObj.rsMap.instructor;//指导员 5
		}

	} else {
		//alert('无须创建记录');
		//无须创建记录
		document.getElementById("object_id").value = retObj.map.object_id;

		retObj1 = jcdpCallService("ProjectPlanSrv", "getWtOrgInfo", "projectInfoNo="+ids);
		
		if (typeof(retObj1.rsMap.org_name) != "undefined")
		{
			document.getElementById("team_id_td").innerHTML= retObj1.rsMap.org_name;//队号 1
		}
		if (typeof(retObj1.rsMap.is_majorteam) != "undefined")
		{
			document.getElementById("is_majorteam_td").innerHTML= retObj1.rsMap.is_majorteam;//队伍资质 2
		}

		//显示数据库中保存的值	
		
		if (typeof(retObj.map.team_leader) != "undefined")
		{
			document.getElementById("team_leader").value = retObj.map.team_leader;//队经理 3
		}
		if (typeof(retObj.map.collect_leader) != "undefined")
		{
			document.getElementById("collect_leader").value = retObj.map.collect_leader;//副经理 4
		}
		if (typeof(retObj.map.dirll_leader) != "undefined")
		{
			document.getElementById("dirll_leader").value = retObj.map.dirll_leader;//指导员 5
		}
<%--
		仪器组长：instrument_monitor
		资料处理组长：geophysical_division
		司机组长：surface_monitor
		测量室内计算：powder_monitor
	--%>	
		if (typeof(retObj.map.instrument_monitor) != "undefined")
		{
			document.getElementById("instrument_monitor").value = retObj.map.instrument_monitor;//仪器组长
		}
		if (typeof(retObj.map.geophysical_division) != "undefined")
		{
			document.getElementById("geophysical_division").value = retObj.map.geophysical_division;//资料处理组长
		}
		if (typeof(retObj.map.surface_monitor) != "undefined")
		{
			document.getElementById("surface_monitor").value = retObj.map.surface_monitor;//司机组长
		}
		if (typeof(retObj.map.powder_monitor) != "undefined")
		{
			document.getElementById("powder_monitor").value = retObj.map.powder_monitor;//测量室内计算
		}
		
		

	}
}
function save(){

	<%--
	有数据
	队号：team_id_td
	队伍资质 is_majorteam_td
	队经理：team_leader
	副经理：collect_leader
	指导员：dirll_leader
	
	无数据
	仪器组长：instrument_monitor
	资料处理组长：geophysical_division
	司机组长：surface_monitor
	测量室内计算：powder_monitor
	--%>

	debugger;
	var baseInfoStr = "";
	var projectPlanStr = "";
	var ctt = this.parent.frames;
	if(ctt.length != 0){
		if(notSaveFlag == "1"){
			
		}
		baseInfoStr = ctt.frames["if1"].getBaseInfoStr();
		projectPlanStr = ctt.frames["if3"].getProjectPlanStr();
		if(projectPlanStr == undefined || projectPlanStr == 'undefined'){
			return;
		}
	}


	
	var str="project_info_no=<%=projectInfoNo %>";
	str += "&team_id="+document.getElementById("team_id_td").innerHTML;//队号
	str += "&is_majorteam="+document.getElementById("is_majorteam_td").innerHTML;//队伍资质
	str += "&team_leader="+document.getElementById("team_leader").value;
	str += "&collect_leader="+document.getElementById("collect_leader").value;
	str += "&dirll_leader="+document.getElementById("dirll_leader").value;
	
	str += "&instrument_monitor="+document.getElementById("instrument_monitor").value;
	str += "&geophysical_division="+document.getElementById("geophysical_division").value;
	str += "&surface_monitor="+document.getElementById("surface_monitor").value;
	str += "&powder_monitor="+document.getElementById("powder_monitor").value;

	
	str += "&object_id="+document.getElementById("object_id").value;
	str += baseInfoStr;
	str += projectPlanStr;
	
	if(basePlanId != "" && basePlanId != undefined){
		//
		//alert("保存过");
		var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
		if(retObj != null && retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		loadData();
	}else{
		var retObj = jcdpCallService("ProjectPlanSrv", "saveWtProjectPlan", str);
		if(retObj != null && retObj.message == "success") {
			alert("修改成功");
		} else if(retObj != null && retObj.message == "alreadysaved"){
			alert("已经存在初始计划,不能再添加!")
		} else{
			alert("修改失败");
		}
		loadData();
	}
}

function getOrgInfoStr(){



	var str="&team_leader="+document.getElementById("team_leader").value;
	str += "&collect_leader="+document.getElementById("collect_leader").value;
	str += "&dirll_leader="+document.getElementById("dirll_leader").value;
	
	str += "&instrument_monitor="+document.getElementById("instrument_monitor").value;
	str += "&geophysical_division="+document.getElementById("geophysical_division").value;
	str += "&surface_monitor="+document.getElementById("surface_monitor").value;
	str += "&powder_monitor="+document.getElementById("powder_monitor").value;
	
	//str += "&team_id_td="+document.getElementById("team_id_td").value;
	//str += "&team_id="+document.getElementById("team_id").value;
	//str += "&is_majorteam_td="+document.getElementById("is_majorteam_td").value;
	

	

	<%--
	var str="&team_leader="+document.getElementById("team_leader").value;
	str += "&collect_leader="+document.getElementById("collect_leader").value;
	str += "&surface_monitor="+document.getElementById("surface_monitor").value;
	str += "&powder_monitor="+document.getElementById("powder_monitor").value;
	str += "&instrument_monitor="+document.getElementById("instrument_monitor").value;
	str += "&acquire_leader="+document.getElementById("acquire_leader").value;
	str += "&dirll_leader="+document.getElementById("dirll_leader").value;
	str += "&dirll_monitor="+document.getElementById("dirll_monitor").value;
	str += "&survey_leader="+document.getElementById("survey_leader").value;
	str += "&survey_monitor="+document.getElementById("survey_monitor").value;
	str += "&geophysical_division="+document.getElementById("geophysical_division").value;
	str += "&suface_leader="+document.getElementById("suface_leader").value;
	str += "&team_id="+document.getElementById("team_id").value;
	str += "&is_majorteam="+document.getElementById("is_majorteam").value;
	--%>
	return str;
}

function saveOrgInfo(){
	var str="project_info_no=<%=projectInfoNo %>";
	str += "&team_leader="+document.getElementById("team_leader").value;
	str += "&collect_leader="+document.getElementById("collect_leader").value;
	str += "&surface_monitor="+document.getElementById("surface_monitor").value;
	str += "&powder_monitor="+document.getElementById("powder_monitor").value;
	str += "&instrument_monitor="+document.getElementById("instrument_monitor").value;
	str += "&acquire_leader="+document.getElementById("acquire_leader").value;
	str += "&dirll_leader="+document.getElementById("dirll_leader").value;
	str += "&dirll_monitor="+document.getElementById("dirll_monitor").value;
	str += "&survey_leader="+document.getElementById("survey_leader").value;
	str += "&survey_monitor="+document.getElementById("survey_monitor").value;
	str += "&geophysical_division="+document.getElementById("geophysical_division").value;
	str += "&suface_leader="+document.getElementById("suface_leader").value;
	str += "&team_id="+document.getElementById("team_id").value;
	str += "&is_majorteam="+document.getElementById("is_majorteam").value;
	
	var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectPlan", str);
	if(retObj != null && retObj.message == "success") {
		
	} else {
		alert("修改组织机构失败");
		return;
	}
}

</script>
<body onload="loadData()">
<div id="addChangePlan" align="left">&nbsp;&nbsp;<b>修改项目初始计划</b></div>
<div id="tab_box_content0" class="tab_box_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">
<input type="hidden" id="team_id"/>
<input type="hidden" id="is_majorteam"/>
<input type="hidden" id="object_id"/>



<td class="inquire_item4" >队号：</td>
<td class="inquire_form4"  id="team_id_td" >&nbsp;</td>
<td class="inquire_item4" >队伍资质</td>
<td class="inquire_form4" id="is_majorteam_td">&nbsp;</td>
</tr>
<tr class="odd">
<td class="inquire_item4">队经理：</td>
<td class="inquire_form4"><input id="team_leader" name="team_leader"/></td>
<td class="inquire_item4">副经理：</td>
<td class="inquire_form4"><input id="collect_leader" name="collect_leader"/></td>
</tr>
<tr class="even">
<td class="inquire_item4">指导员：</td>
<td class="inquire_form4"><input id="dirll_leader" name="dirll_leader"/></td>
<td class="inquire_item4">仪器组长：</td>
<td class="inquire_form4"><input id="instrument_monitor" name="instrument_monitor"/></td>
</tr>
<tr class="odd">
<td class="inquire_item4">资料处理组长：</td>
<td class="inquire_form4"><input id="geophysical_division" name="geophysical_division"/></td>
<td class="inquire_item4">司机组长：</td>
<td class="inquire_form4"><input id="surface_monitor" name="surface_monitor"/></td>
</tr>
<tr class="even">
<td class="inquire_item4">测量室内计算：</td>
<td class="inquire_form4"><input id="powder_monitor" name="powder_monitor"/></td>
<td class="inquire_item4"></td>
<td class="inquire_form4"></td>

</tr>
</table>
</div>
<div id="oper_div">
<%if(action != "view" && !"view".equals(action)){ %>
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
<%} %>
</div>
<script type="text/javascript" language="javascript">

</script>
</body>
</html>