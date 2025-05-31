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


cruConfig.contextPath =  "<%=contextPath%>";
function loadData(){
	var ids = "<%=projectInfoNo %>";
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no="+ids);
	if(retObj.map == undefined){
		//需要创建记录 手动录入
	} else {
		//无须创建记录 显示
		//debugger;
		//alert("obj id "+retObj.map.object_id);
		document.getElementById("object_id").value = retObj.map.object_id;
		document.getElementById("boat_train").value = retObj.map.boat_train;
		document.getElementById("project_manager").value = retObj.map.project_manager;
		document.getElementById("boat_manager").value = retObj.map.boat_manager;
		document.getElementById("captain").value = retObj.map.captain;
		document.getElementById("boat_assistant_manager").value = retObj.map.boat_assistant_manager;
		document.getElementById("first_mate").value = retObj.map.first_mate;
		document.getElementById("shore_base_manager").value = retObj.map.shore_base_manager;
		document.getElementById("second_mate").value = retObj.map.second_mate;
		document.getElementById("hse_supervisor").value = retObj.map.hse_supervisor;
		document.getElementById("third_mate").value = retObj.map.third_mate;
		document.getElementById("navigation_leader").value = retObj.map.navigation_leader;
		document.getElementById("boatswain").value = retObj.map.boatswain;
		document.getElementById("instrument_leader").value = retObj.map.instrument_leader;
		document.getElementById("chief_engineer").value = retObj.map.chief_engineer;
		document.getElementById("air_blast_leader").value = retObj.map.air_blast_leader;
		document.getElementById("second_engineer").value = retObj.map.second_engineer;
		document.getElementById("geophysical_division").value = retObj.map.geophysical_division;
		document.getElementById("team_doctor").value = retObj.map.team_doctor;

	}
}
function save(){
	
	debugger;
	
	var baseInfoStr = "";
	var projectPlanStr = "";
	var ctt = this.parent.frames;
	if(ctt.length != 0){
		baseInfoStr = ctt.frames["if1"].getBaseInfoStr();
		projectPlanStr = ctt.frames["if3"].getProjectPlanStr();
	}
	
	var str="project_info_no=<%=projectInfoNo %>";
	
	str += "&boat_train="+document.getElementById("boat_train").value;
	str += "&project_manager="+document.getElementById("project_manager").value;
	str += "&boat_manager="+document.getElementById("boat_manager").value;
	str += "&captain="+document.getElementById("captain").value;
	str += "&boat_assistant_manager="+document.getElementById("boat_assistant_manager").value;
	str += "&first_mate="+document.getElementById("first_mate").value;
	str += "&shore_base_manager="+document.getElementById("shore_base_manager").value;
	str += "&second_mate="+document.getElementById("second_mate").value;
	str += "&hse_supervisor="+document.getElementById("hse_supervisor").value;
	str += "&third_mate="+document.getElementById("third_mate").value;
	str += "&navigation_leader="+document.getElementById("navigation_leader").value;
	str += "&boatswain="+document.getElementById("boatswain").value;
	str += "&instrument_leader="+document.getElementById("instrument_leader").value;
	str += "&chief_engineer="+document.getElementById("chief_engineer").value;
	str += "&air_blast_leader="+document.getElementById("air_blast_leader").value;
	str += "&second_engineer="+document.getElementById("second_engineer").value;
	str += "&geophysical_division="+document.getElementById("geophysical_division").value;
	str += "&team_doctor="+document.getElementById("team_doctor").value;
	str += baseInfoStr;
	str += projectPlanStr;

	//var id = document.getElementById("object_id").value;
	//if(id == null || id == ""){
		//新增 
	//}else{
		//新增 未跳转  修改
		//str += "&object_id="+document.getElementById("object_id").value;//计划记录id
	//}
	
	
	
	
	var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
	if(retObj != null && retObj.message == "success") {
		alert("修改成功");
		parent.location.href="<%=contextPath %>/pm/plan/planchangelist/sh/checkPlanList.jsp";//保存后跳转到列表页
		
	} else {
		alert("修改失败");
	}
	loadData();
}

function getOrgInfoStr(){
	var str="";

	str += "&team_id="+document.getElementById("team_id").value;
	str += "&is_majorteam="+document.getElementById("is_majorteam").value;


	str += "&boat_train="+document.getElementById("boat_train").value;
	str += "&project_manager="+document.getElementById("project_manager").value;
	str += "&boat_manager="+document.getElementById("boat_manager").value;
	str += "&captain="+document.getElementById("captain").value;
	str += "&boat_assistant_manager="+document.getElementById("boat_assistant_manager").value;
	str += "&first_mate="+document.getElementById("first_mate").value;
	str += "&shore_base_manager="+document.getElementById("shore_base_manager").value;
	str += "&second_mate="+document.getElementById("second_mate").value;
	str += "&hse_supervisor="+document.getElementById("hse_supervisor").value;
	str += "&third_mate="+document.getElementById("third_mate").value;
	str += "&navigation_leader="+document.getElementById("navigation_leader").value;
	str += "&boatswain="+document.getElementById("boatswain").value;
	str += "&instrument_leader="+document.getElementById("instrument_leader").value;
	str += "&chief_engineer="+document.getElementById("chief_engineer").value;
	str += "&air_blast_leader="+document.getElementById("air_blast_leader").value;
	str += "&second_engineer="+document.getElementById("second_engineer").value;
	str += "&geophysical_division="+document.getElementById("geophysical_division").value;
	str += "&team_doctor="+document.getElementById("team_doctor").value;

	
	return str;
}


//----------------------------------------------------
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

<input type="hidden" id="team_id"/>
<input type="hidden" id="is_majorteam"/>
<input type="hidden" id="object_id"/>


<div id="addChangePlan" align="left">&nbsp;&nbsp;<b>增加项目变更计划</b></div>




<div id="tab_box_content0" class="tab_box_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">

<td class="inquire_item4" >船队：</td>
<td class="inquire_form4" ><input  id="boat_train" name="boat_train" /></td>
<td class="inquire_item4" >项目经理：</td>
<td class="inquire_form4"  ><input id="project_manager" name="project_manager" /></td>
</tr>
<tr class="odd">
<td class="inquire_item4">船队经理：</td>
<td class="inquire_form4"><input id="boat_manager" name="boat_manager"/></td>
<td class="inquire_item4">船长：</td>
<td class="inquire_form4"><input id="captain" name="captain"/></td>
</tr>
<tr class="even">
<td class="inquire_item4">船队副经理：</td>
<td class="inquire_form4"><input id="boat_assistant_manager" name="boat_assistant_manager"/></td>
<td class="inquire_item4">大副：</td>
<td class="inquire_form4"><input id="first_mate" name="first_mate"/></td>
</tr>
<tr class="odd">
<td class="inquire_item4">岸基经理：</td>
<td class="inquire_form4"><input id="shore_base_manager" name="shore_base_manager"/></td>
<td class="inquire_item4">二副：</td>
<td class="inquire_form4"><input id="second_mate" name="second_mate"/></td>
</tr>
<tr class="even">
<td class="inquire_item4">HSE监督：</td>
<td class="inquire_form4"><input id="hse_supervisor" name="hse_supervisor"/></td>
<td class="inquire_item4"> 三副：</td>
<td class="inquire_form4"><input id="third_mate" name="third_mate"/></td>
</tr>
<tr class="odd">
<td class="inquire_item4">导航组长：</td>
<td class="inquire_form4"><input id="navigation_leader" name="navigation_leader"/></td>
<td class="inquire_item4">水手长：</td>
<td class="inquire_form4"><input id="boatswain" name="boatswain"/></td>
</tr>
<tr class="even">
<td class="inquire_item4">仪器组长：</td>
<td class="inquire_form4"><input id="instrument_leader" name="instrument_leader"/></td>
<td class="inquire_item4">轮机长：</td>
<td class="inquire_form4"><input id="chief_engineer" name="chief_engineer"/></td>
</tr>
<tr class="odd">
<td class="inquire_item4">气爆组长：</td>
<td class="inquire_form4"><input id="air_blast_leader" name="air_blast_leader"/></td>
<td class="inquire_item4">大管轮 ：</td>
<td class="inquire_form4"><input id="second_engineer" name="second_engineer"/></td>
</tr>
<tr class="even">
<td class="inquire_item4">地球物理师 ：</td>
<td class="inquire_form4"><input id="geophysical_division" name="geophysical_division"/></td>
<td class="inquire_item4">队医：</td>
<td class="inquire_form4"><input id="team_doctor" name="team_doctor"/></td>
</tr>
</table>
</div>
<div id="oper_div">
<%if(action != "view" && !"view".equals(action)){ %>
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
<%} %>
</div>
</body>
</html>