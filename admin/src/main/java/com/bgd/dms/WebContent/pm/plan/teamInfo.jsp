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
	debugger;
	if(retObj.map == undefined){
		//需要创建记录
		retObj = jcdpCallService("ProjectPlanSrv", "getTeamInfo", "projectInfoNo="+ids);
		document.getElementById("team_id_td").innerHTML= '队号：'+retObj.map.team_id;
		document.getElementById("is_majorteam_td").innerHTML= '地震队资质：'+retObj.map.is_majorteam;
		document.getElementById("team_leader_td").innerHTML= '队经理：'+retObj.map.team_leader;
		document.getElementById("team_id").value = retObj.map.team_id;
		document.getElementById("is_majorteam").value = retObj.map.is_majorteam;
		document.getElementById("team_leader").value = retObj.map.team_leader;
	} else {
		//无须创建记录
		document.getElementById("object_id").value = retObj.map.object_id;
		if(retObj.map.is_majorteam == undefined || retObj.map.team_id == undefined || retObj.map.team_id == "" || retObj.map.is_majorteam == "" || retObj.map.team_leader == undefined || retObj.map.team_leader == ""){
			//该页面所需的值有缺失 需更新记录
			retObj = jcdpCallService("ProjectPlanSrv", "getTeamInfo", "projectInfoNo="+ids);
			document.getElementById("team_id_td").innerHTML= '队号：'+retObj.map.team_id;
			document.getElementById("is_majorteam_td").innerHTML= '地震队资质：'+retObj.map.is_majorteam;
			document.getElementById("team_leader_td").innerHTML= '队经理：'+retObj.map.team_leader;
			document.getElementById("team_id").value = retObj.map.team_id;
			document.getElementById("is_majorteam").value = retObj.map.is_majorteam;
			document.getElementById("team_leader").value = retObj.map.team_leader;
		} else {
			//显示数据库中保存的值
			document.getElementById("team_id_td").innerHTML= '队号：'+retObj.map.team_id;
			document.getElementById("is_majorteam_td").innerHTML= '地震队资质：'+retObj.map.is_majorteam;
			document.getElementById("team_leader_td").innerHTML= '队经理：'+retObj.map.team_leader;
			document.getElementById("team_id").value = retObj.map.team_id;
			document.getElementById("is_majorteam").value = retObj.map.is_majorteam;
			document.getElementById("team_leader").value = retObj.map.team_leader;
		}
	}
}
function save(){
	var str="project_info_no=<%=projectInfoNo %>";
	str += "&team_id="+document.getElementById("team_id").value;
	str += "&is_majorteam="+document.getElementById("is_majorteam").value;
	str += "&team_leader="+document.getElementById("team_leader").value;
	str += "&object_id="+document.getElementById("object_id").value;
	
	var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectPlan", str);
	if(retObj != null && retObj.message == "success") {
		alert("修改成功");
	} else {
		alert("修改失败");
	}
	loadData();
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
		submitStr = encodeURI(submitStr);

		retObject = jcdpCallService('WFCommonSrv','startWFProcess',submitStr)
	}
}
</script>
<body onload="loadData()">
<div id="tab_box_content0" class="tab_box_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr>
<input type="hidden" id="team_id"/>
<input type="hidden" id="is_majorteam"/>
<input type="hidden" id="team_leader"/>
<input type="hidden" id="object_id"/>
<td class="inquire_form4"  id="team_id_td"></td>
</tr>
<tr>
<td class="inquire_form4" id="is_majorteam_td"></td>
</tr>
<tr>
<td class="inquire_form4" id="team_leader_td"></td>
</tr>
</table>
</div>
<div id="oper_div">
<%if(action != "view" && !"view".equals(action)){ %>
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="tj_btn"><a href="#" onclick="submit()"></a></span>
<%} %>
</div>
</body>
</html>