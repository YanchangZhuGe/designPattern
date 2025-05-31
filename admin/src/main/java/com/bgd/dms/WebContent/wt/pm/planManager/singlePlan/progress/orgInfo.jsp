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
	debugger;
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
		document.getElementById("object_id").value = retObj.map.object_id;
		
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
		
	
		
		if(retObj.map.dirll_leader == undefined || retObj.map.dirll_leader == ""){
			document.getElementById("dirll_leader").value = temp.map.dirll_leader;
		} else {
			document.getElementById("dirll_leader").value = retObj.map.dirll_leader;
		}
		
		
		
		
	
		
		if(retObj.map.geophysical_division == undefined || retObj.map.geophysical_division == ""){
			document.getElementById("geophysical_division").value = temp.map.geophysical_division;
		} else {
			document.getElementById("geophysical_division").value = retObj.map.geophysical_division;
		}
		
		
		
	}
}

function save(){

	<%--
	队号：team_id_td
	队伍资质 is_majorteam_td
	队经理：team_leader
	副经理：collect_leader
	指导员：dirll_leader
	仪器组长：instrument_monitor
	资料处理组长：geophysical_division
	司机组长：surface_monitor
	测量室内计算：powder_monitor
	--%>
	var baseInfoStr = "";
	var projectPlanStr = "";
	var ctt = this.parent.frames;
	if(ctt.length != 0){
		baseInfoStr = ctt.frames["if1"].getBaseInfoStr();
		projectPlanStr = ctt.frames["if3"].getProjectPlanStr();
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
	str += baseInfoStr;
	str += projectPlanStr;

	//新增补充计划
	var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
	if(retObj != null && retObj.message == "success") {
		alert("修改成功");
		parent.location.href="<%=contextPath %>/wt/pm/planManager/singlePlan/progress/planchangelist/checkPlanList.jsp";//保存后跳转到列表页
	} else {
		alert("修改失败");
	}
	loadData();
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
	str += "&object_id="+document.getElementById("object_id").value;
	
	var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectPlan", str);
	if(retObj != null && retObj.message == "success") {
		
	} else {
		alert("修改组织机构失败");
		return;
	}
}

function submit(){
	var id = document.getElementById("object_id").value;
	if(id == null || id == ""){
		alert("请保存后再提交!");
	}
	//debugger;
	processNecessaryInfo={
			businessTableName:"bgp_pm_project_plan",
			businessType:"5110000004100000060",
			businessId:id,
			businessInfo:"项目进度计划审批",
			applicantDate:"<%=appDate%>"
	};
	processAppendInfo={
			action:'view',
			projectInfoNo:'<%=projectInfoNo %>'
	};
	
	if(confirm('确定提交吗?该操作会提交整个计划!')){ 
		//查询流程是否已提交
		var submitStr='businessTableName='+processNecessaryInfo.businessTableName+'&businessType='+processNecessaryInfo.businessType+'&businessId='+processNecessaryInfo.businessId;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var procStatus=retObject.procStatus;
		processStatusInfo.procStatus=procStatus;
		
		if(processStatusInfo.procStatus=='3'||processStatusInfo.procStatus=='1'){
			alert("该单据已提交流程，无法再次提交");
			return ;
		}
		var submitStr="startProcess=true";
		for(i in processNecessaryInfo){
			submitStr+="&"+i+"="+processNecessaryInfo[i];
			if(processNecessaryInfo[i]==null||processNecessaryInfo[i]==""||processNecessaryInfo[i]==undefined){
				alert(i+"未设置值,请设置后再进行提交");
				return false;
			}
		}
		for(j in processAppendInfo){
			submitStr+="&wfVar_"+j+"="+processAppendInfo[j];
		}
		
		submitStr = encodeURI(submitStr);

		retObject = jcdpCallService('WFCommonSrv','startWFProcess',submitStr)
	}
}
</script>
<body onload="loadData()">


<input type="hidden" id="team_id"/>
<input type="hidden" id="is_majorteam"/>
<input type="hidden" id="object_id"/>

<div id="tab_box_content0" class="tab_box_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">



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
</body>
</html>