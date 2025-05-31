<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}
	String action = request.getParameter("action");
	if(action == null || "".equals(action)){
		action = "edit";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String org_subjection_id = QualityUtil.getProjectSubjectionId(projectInfoNo);
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
cruConfig.contextPath =  "<%=contextPath%>";
function loadData(){
	var ids = "<%=projectInfoNo %>";
	
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no="+ids);
	
	if(retObj.map == undefined){
		//需要创建记录
		retObj = jcdpCallService("ProjectPlanSrv", "getOrgInfo", "projectInfoNo="+ids);
		document.getElementById("team_leader").value = retObj.map.team_leader;
		document.getElementById("collect_leader").value = retObj.map.collect_leader;
		document.getElementById("surface_monitor").value = retObj.map.surface_monitor;
		
		retObj = jcdpCallService("ProjectPlanSrv", "getTeamInfo", "projectInfoNo="+ids);
		document.getElementById("team_id_td").innerHTML= retObj.map.team_id;
		document.getElementById("is_majorteam_td").innerHTML= retObj.map.is_majorteam;
		document.getElementById("team_id").value = retObj.map.team_id;
		document.getElementById("is_majorteam").value = retObj.map.is_majorteam;
		
	} else {
		//无须创建记录
		if(retObj.map.is_majorteam == undefined || retObj.map.team_id == undefined || retObj.map.team_id == "" || retObj.map.is_majorteam == ""){
			//该页面所需的值有缺失 需更新记录
			retObj = jcdpCallService("ProjectPlanSrv", "getTeamInfo", "projectInfoNo="+ids);
			document.getElementById("team_id_td").innerHTML= retObj.map.team_id;
			document.getElementById("is_majorteam_td").innerHTML= retObj.map.is_majorteam;
			document.getElementById("team_id").value = retObj.map.team_id;
			document.getElementById("is_majorteam").value = retObj.map.is_majorteam;
		} else {
			//显示数据库中保存的值
			document.getElementById("team_id_td").innerHTML= retObj.map.team_id;
			document.getElementById("is_majorteam_td").innerHTML= retObj.map.is_majorteam;
			document.getElementById("team_id").value = retObj.map.team_id;
			document.getElementById("is_majorteam").value = retObj.map.is_majorteam;
		}
		
		var temp = jcdpCallService("ProjectPlanSrv", "getOrgInfo", "projectInfoNo="+ids);
		
		if(retObj.map.team_leader == undefined || retObj.map.team_leader == ""){
			document.getElementById("team_leader").value = temp.map.team_leader;
		} else {
			document.getElementById("team_leader").value = retObj.map.team_leader;
		}
		
		if(retObj.map.collect_leader == undefined || retObj.map.collect_leader == ""){
			document.getElementById("collect_leader").value = temp.map.collect_leader;
		} else {
			document.getElementById("collect_leader").value = retObj.map.collect_leader;
		}
		
		if(retObj.map.surface_monitor == undefined || retObj.map.surface_monitor == ""){
			document.getElementById("surface_monitor").value = temp.map.surface_monitor;
		} else {
			document.getElementById("surface_monitor").value = retObj.map.surface_monitor;
		}
		
		if(retObj.map.powder_monitor == undefined || retObj.map.powder_monitor == ""){
			document.getElementById("powder_monitor").value = temp.map.powder_monitor;
		} else {
			document.getElementById("powder_monitor").value = retObj.map.powder_monitor;
		}
		
		if(retObj.map.instrument_monitor == undefined || retObj.map.instrument_monitor == ""){
			document.getElementById("instrument_monitor").value = temp.map.instrument_monitor;
		} else {
			document.getElementById("instrument_monitor").value = retObj.map.instrument_monitor;
		}
		
		if(retObj.map.acquire_leader == undefined || retObj.map.acquire_leader == ""){
			document.getElementById("acquire_leader").value = temp.map.acquire_leader;
		} else {
			document.getElementById("acquire_leader").value = retObj.map.acquire_leader;
		}
		
		if(retObj.map.dirll_leader == undefined || retObj.map.dirll_leader == ""){
			document.getElementById("dirll_leader").value = temp.map.dirll_leader;
		} else {
			document.getElementById("dirll_leader").value = retObj.map.dirll_leader;
		}
		
		if(retObj.map.dirll_monitor == undefined || retObj.map.dirll_monitor == ""){
			document.getElementById("dirll_monitor").value = temp.map.dirll_monitor;
		} else {
			document.getElementById("dirll_monitor").value = retObj.map.dirll_monitor;
		}
		
		if(retObj.map.survey_leader == undefined || retObj.map.survey_leader == ""){
			document.getElementById("survey_leader").value = temp.map.survey_leader;
		} else {
			document.getElementById("survey_leader").value = retObj.map.survey_leader;
		}
		
		if(retObj.map.survey_monitor == undefined || retObj.map.survey_monitor == ""){
			document.getElementById("survey_monitor").value = temp.map.survey_monitor;
		} else {
			document.getElementById("survey_monitor").value = retObj.map.survey_monitor;
		}
		
		if(retObj.map.geophysical_division == undefined || retObj.map.geophysical_division == ""){
			document.getElementById("geophysical_division").value = temp.map.geophysical_division;
		} else {
			document.getElementById("geophysical_division").value = retObj.map.geophysical_division;
		}
		
		if(retObj.map.suface_leader == undefined || retObj.map.suface_leader == ""){
			document.getElementById("suface_leader").value = temp.map.suface_leader;
		} else {
			document.getElementById("suface_leader").value = retObj.map.suface_leader;
		}
		/* 滩浅海新增的几个字段 */
		if(retObj.map.secretary == undefined || retObj.map.secretary == ""){
			document.getElementById("secretary").value = temp.map.secretary ==null ?"":temp.map.secretary;
		} else {
			document.getElementById("secretary").value = retObj.map.secretary==null?"":retObj.map.secretary;
		}
		
		if(retObj.map.technology_leader == undefined || retObj.map.technology_leader == ""){
			document.getElementById("technology_leader").value = temp.map.technology_leader==null?"":temp.map.technology_leader;
		} else {
			document.getElementById("technology_leader").value = retObj.map.technology_leader==null?"":retObj.map.technology_leader;
		}
		
		if(retObj.map.protect_leader == undefined || retObj.map.protect_leader == ""){
			document.getElementById("protect_leader").value = temp.map.protect_leader ==null ?"" :temp.map.protect_leader;
		} else {
			document.getElementById("protect_leader").value = retObj.map.protect_leader == null?"":retObj.map.protect_leader;
		}
		
		if(retObj.map.explain_monitor == undefined || retObj.map.explain_monitor == ""){
			document.getElementById("explain_monitor").value = temp.map.explain_monitor==null?"":temp.map.explain_monitor;
		} else {
			document.getElementById("explain_monitor").value = retObj.map.explain_monitor==null?"":retObj.map.explain_monitor;
		}
		
		if(retObj.map.scene == undefined || retObj.map.scene == ""){
			document.getElementById("scene").value = temp.map.scene ==null?"":temp.map.scene;
		} else {
			document.getElementById("scene").value = retObj.map.scene ==null?"":retObj.map.scene;
		}
		
		if(retObj.map.qb_monitor == undefined || retObj.map.qb_monitor == ""){
			document.getElementById("qb_monitor").value = temp.map.qb_monitor==null ?"":temp.map.qb_monitor;
		} else {
			document.getElementById("qb_monitor").value = retObj.map.qb_monitor ==null?"":retObj.map.qb_monitor;
		}
		/* 滩浅海新增的几个字段结束 */
	}
}
function save(){
	var baseInfoStr = "";
	var projectPlanStr = "";
	var ctt = this.parent.frames;
	if(ctt.length != 0){
		baseInfoStr = ctt.frames["if1"].getBaseInfoStr();
		projectPlanStr = ctt.frames["if3"].getProjectPlanStr();
	}
	
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
	
	var org_subjection_id = '<%=org_subjection_id%>';
	if(org_subjection_id!=null && org_subjection_id.indexOf("C105007")!=-1){
		str += "&secretary="+document.getElementById("secretary").value;
		str += "&technology_leader="+document.getElementById("technology_leader").value;
		str += "&protect_leader="+document.getElementById("protect_leader").value;
		str += "&explain_monitor="+document.getElementById("explain_monitor").value;
		str += "&scene="+document.getElementById("scene").value;
		str += "&qb_monitor="+document.getElementById("qb_monitor").value;
	}
	
	str += baseInfoStr;
	str += projectPlanStr;
	
	var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
	if(retObj != null && retObj.message == "success") {
		alert("修改成功");
	} else {
		alert("修改失败");
	}
//	loadData();
}

function getOrgInfoStr(){
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
	
	var org_subjection_id = '<%=org_subjection_id%>';
	if(org_subjection_id!=null && org_subjection_id.indexOf("C105007")!=-1){
		str += "&secretary="+document.getElementById("secretary").value;
		str += "&technology_leader="+document.getElementById("technology_leader").value;
		str += "&protect_leader="+document.getElementById("protect_leader").value;
		str += "&explain_monitor="+document.getElementById("explain_monitor").value;
		str += "&scene="+document.getElementById("scene").value;
		str += "&qb_monitor="+document.getElementById("qb_monitor").value;
	}
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
<div id="addChangePlan" align="left">&nbsp;&nbsp;<b>增加项目变更计划</b></div>
<div id="tab_box_content0" class="tab_box_content">
<%if(org_subjection_id!=null && org_subjection_id.trim().startsWith("C105007")){ %>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr class="even">
		<input type="hidden" id="team_id"/>
		<input type="hidden" id="is_majorteam"/>
		<td class="inquire_item4" >队号：</td>
		<td class="inquire_form4"  id="team_id_td" >&nbsp;</td>
		<td class="inquire_item4" >地震队资质：</td>
		<td class="inquire_form4" id="is_majorteam_td">&nbsp;</td>
	</tr>
		<tr class="odd">
		<td class="inquire_item4">队经理：</td>
		<td class="inquire_form4"><input id="team_leader" name="team_leader"/></td>
		<td class="inquire_item4">书记：</td>
		<td class="inquire_form4"><input id="secretary" name="secretary"/></td>
	</tr>
	<tr class="even">
		<td class="inquire_item4">生产分管副经理：</td>
		<td class="inquire_form4"><input id="collect_leader" name="collect_leader"/></td>
		<td class="inquire_item4">技术分管副经理：</td>
		<td class="inquire_form4"><input id="technology_leader" name="technology_leader"/></td>
	</tr>
	
	
	<tr class="odd">
		<td class="inquire_item4">设备分管副经理：</td>
		<td class="inquire_form4"><input id="survey_leader" name="survey_leader"/></td>
		<td class="inquire_item4">钻井分管副经理：</td>
		<td class="inquire_form4"><input id="dirll_leader" name="dirll_leader"/></td>
	</tr>
	<tr class="even">
		<td class="inquire_item4">护缆分管副经理：</td>
		<td class="inquire_form4"><input id="protect_leader" name="protect_leader"/></td>
		<td class="inquire_item4">地球物理师：</td>
		<td class="inquire_form4"><input id="geophysical_division" name="geophysical_division"/></td>
	</tr>
	<tr class="odd">
		<td class="inquire_item4">解释组组长：</td>
		<td class="inquire_form4"><input id="explain_monitor" name="explain_monitor"/></td>
		<td class="inquire_item4">现场处理师：</td>
		<td class="inquire_form4"><input id="scene" name="scene"/></td>
	</tr>
	
	
	
	<tr class="odd">
		<td class="inquire_item4">仪器组组长：</td>
		<td class="inquire_form4"><input id="instrument_monitor" name="instrument_monitor"/></td>
		<td class="inquire_item4">气爆组组长：</td>
		<td class="inquire_form4"><input id="qb_monitor" name="qb_monitor"/></td>
	</tr>
	<tr class="even">
		<td class="inquire_item4">放线班班长：</td>
		<td class="inquire_form4"><input id="surface_monitor" name="surface_monitor"/></td>
		<td class="inquire_item4">爆炸班班长：</td>
		<td class="inquire_form4"><input id="powder_monitor" name="powder_monitor"/></td>
	</tr>
	<tr class="odd">
		<td class="inquire_item4">测量项目长：</td>
		<td class="inquire_form4"><input id="survey_monitor" name="survey_monitor"/></td>
		<td class="inquire_item4">钻井组组长：</td>
		<td class="inquire_form4"><input id="dirll_monitor" name="dirll_monitor"/></td>
	</tr>
	<tr class="even">
		<td class="inquire_item4">震源组组长：</td>
		<td class="inquire_form4"><input id="acquire_leader" name="acquire_leader"/></td>
		<td class="inquire_item4">表层调查组组长：</td>
		<td class="inquire_form4"><input id="suface_leader" name="suface_leader"/></td>
	</tr>
</table>
<%}else{ %>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr class="even">
		<input type="hidden" id="team_id"/>
		<input type="hidden" id="is_majorteam"/>
		<td class="inquire_item4" >队号：</td>
		<td class="inquire_form4"  id="team_id_td" >&nbsp;</td>
		<td class="inquire_item4" >地震队资质：</td>
		<td class="inquire_form4" id="is_majorteam_td">&nbsp;</td>
	</tr>
		<tr class="odd">
		<td class="inquire_item4">队经理：</td>
		<td class="inquire_form4"><input id="team_leader" name="team_leader"/></td>
		<td class="inquire_item4">采集分管副经理：</td>
		<td class="inquire_form4"><input id="collect_leader" name="collect_leader"/></td>
	</tr>
	<tr class="even">
		<td class="inquire_item4">钻井分管副经理：</td>
		<td class="inquire_form4"><input id="dirll_leader" name="dirll_leader"/></td>
		<td class="inquire_item4">测量分管副经理：</td>
		<td class="inquire_form4"><input id="survey_leader" name="survey_leader"/></td>
	</tr>
	<tr class="odd">
		<td class="inquire_item4">地球物理师：</td>
		<td class="inquire_form4"><input id="geophysical_division" name="geophysical_division"/></td>
		<td class="inquire_item4">放线班长：</td>
		<td class="inquire_form4"><input id="surface_monitor" name="surface_monitor"/></td>
	</tr>
	<tr class="even">
		<td class="inquire_item4">爆炸班长：</td>
		<td class="inquire_form4"><input id="powder_monitor" name="powder_monitor"/></td>
		<td class="inquire_item4">仪器组长：</td>
		<td class="inquire_form4"><input id="instrument_monitor" name="instrument_monitor"/></td>
	</tr>
	<tr class="odd">
		<td class="inquire_item4">震源组长：</td>
		<td class="inquire_form4"><input id="acquire_leader" name="acquire_leader"/></td>
		<td class="inquire_item4">钻井组长：</td>
		<td class="inquire_form4"><input id="dirll_monitor" name="dirll_monitor"/></td>
	</tr>
	<tr class="even">
		<td class="inquire_item4">测量项目长：</td>
		<td class="inquire_form4"><input id="survey_monitor" name="survey_monitor"/></td>
		<td class="inquire_item4">表层调查组组长：</td>
		<td class="inquire_form4"><input id="suface_leader" name="suface_leader"/></td>
	</tr>
</table>
<%} %>

</div>
<div id="oper_div">
<%if(action != "view" && !"view".equals(action)){ %>
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
<%} %>
</div>
</body>
</html>