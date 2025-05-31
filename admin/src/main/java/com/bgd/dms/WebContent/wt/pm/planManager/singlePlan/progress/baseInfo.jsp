<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
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


function loadData(){
	debugger;
	
	var ids = "<%=projectInfoNo %>";
	//项目进度计划表
	var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no="+ids);
	
	if(retObj.map == undefined){
		//当前项目无进度计划  根据projectInfoNo查 bgp_pm_project_plan无数据
		//需要创建记录
		//document.getElementById("message").innerHTML = '<font color="red">该信息尚未保存</font>';
		
		// bgp_pm_project_plan无数据 从gp_task_project , gp_task_project_dynamic 取数据填充
		retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
		
		if (typeof(retObj.dynamicMap) == "undefined") { 
			//为空 则初始化 以防下面出错
			retObj.dynamicMap = new Array();
		}
		
		document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
		document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
		document.getElementById("project_name").value = retObj.map.project_name;
		document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
		document.getElementById("exploration_method").value = retObj.map.exploration_method;
		document.getElementById("org_id").value = retObj.dynamicMap.org_id;
		document.getElementById("org_subjection_id").value = retObj.dynamicMap.org_subjection_id;
		document.getElementById("notes_td").innerHTML= retObj.map.notes;
		document.getElementById("notes").value = retObj.map.notes;
		
		document.getElementById("full_fold_workload").value= retObj.dynamicMap.full_fold_workload;
		document.getElementById("design_geophone_num").value= retObj.dynamicMap.design_geophone_num;
		document.getElementById("design_sp_num").value= retObj.dynamicMap.design_sp_num;
		document.getElementById("design_small_regraction_num").value= retObj.dynamicMap.design_small_regraction_num;
		document.getElementById("design_micro_measue_num").value= retObj.dynamicMap.design_micro_measue_num;
		document.getElementById("design_drill_num").value= retObj.dynamicMap.design_drill_num;
		//document.getElementById("org_name").value= retObj.dynamicMap.org_name;
		document.getElementById("measure_km").value= retObj.dynamicMap.measure_km;
		document.getElementById("design_sp_num_zy").value= retObj.dynamicMap.design_sp_num_zy;
		
		document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.design_start_date;
		document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.design_end_date;
		document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.duration_date+'天';
		document.getElementById("start_date").value = retObj.map.design_start_date;
		document.getElementById("end_date").value = retObj.map.design_end_date;
		document.getElementById("duration_date").value = retObj.map.duration_date;

	
	} else {
		//当前项目有进度计划  根据projectInfoNo查 bgp_pm_project_plan有数据
		//无须创建记录
		
		//无须创建记录  补充计划
		document.getElementById("plan_num_value").value = retObj.map.plan_num;
		
		//document.getElementById("object_id").value = retObj.map.object_id;
		if(retObj.map.manage_org_name == undefined || retObj.map.project_name == undefined || retObj.map.exploration_method == undefined ||  retObj.map.org_id == undefined || retObj.map.project_name == "" || retObj.map.org_id == "" || retObj.map.manage_org_name == "" || retObj.map.exploration_method == "" ||retObj.map.end_date == undefined || retObj.map.start_date == undefined || retObj.map.start_date == "" || retObj.map.end_date == "" || retObj.map.duration_date == undefined || retObj.map.duration_date == ""){
			//该页面所需的值有缺失 需更新记录
			//document.getElementById("message").innerHTML = '<font color="red">该信息尚未保存</font>';
			retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
			if (typeof(retObj.dynamicMap) == "undefined") { 
				//为空 则初始化 以防下面出错
				retObj.dynamicMap = new Array();
			}
			document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
			document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
			document.getElementById("project_name").value = retObj.map.project_name;
			document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
			document.getElementById("exploration_method").value = retObj.map.exploration_method;
			document.getElementById("org_id").value = retObj.dynamicMap.org_id;
			document.getElementById("org_subjection_id").value = retObj.dynamicMap.org_subjection_id;
			
			document.getElementById("notes_td").value= retObj.map.notes;
			document.getElementById("notes").value = retObj.map.notes;
			
			document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
			document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
			document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
			document.getElementById("start_date").value = retObj.map.design_start_date;
			document.getElementById("end_date").value = retObj.map.design_end_date;
			document.getElementById("duration_date").value = retObj.map.duration_date;
			
			//retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
			
			
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
			
			document.getElementById("full_fold_workload").value= retObj.map.full_fold_workload;
			document.getElementById("design_geophone_num").value= retObj.map.design_geophone_num;
			document.getElementById("design_sp_num").value= retObj.map.design_sp_num;
			document.getElementById("design_small_regraction_num").value= retObj.map.design_small_regraction_num;
			document.getElementById("design_micro_measue_num").value= retObj.map.design_micro_measue_num;
			document.getElementById("design_drill_num").value= retObj.map.design_drill_num;
			//document.getElementById("org_name").value= retObj.dynamicMap.org_name;
			document.getElementById("measure_km").value= retObj.map.measure_km;
			document.getElementById("design_sp_num_zy").value= retObj.map.design_sp_num_zy;
			
			document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.start_date;
			document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.end_date;
			document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.duration_date+'天';
			document.getElementById("start_date").value = retObj.map.start_date;
			document.getElementById("end_date").value = retObj.map.end_date;
			document.getElementById("duration_date").value = retObj.map.duration_date;

			
			
		}
	}
	parent.document.all("if1").style.height=document.body.scrollHeight; 
	parent.document.all("if1").style.width=document.body.scrollWidth; 
}



//保存时 获得该页面的信息
function getBaseInfoStr(){
	var str= "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
	str += "&manage_org_name="+encodeURI(encodeURI(document.getElementById("manage_org_name").value));
	str += "&exploration_method="+document.getElementById("exploration_method").value;
	str += "&org_id="+document.getElementById("org_id").value;
	str += "&org_subjection_id="+document.getElementById("org_subjection_id").value;
	str += "&start_date="+document.getElementById("start_date").value;
	str += "&end_date="+document.getElementById("end_date").value;
	str += "&duration_date="+document.getElementById("duration_date").value;
	str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
	str += "&plan_num_value="+document.getElementById("plan_num_value").value;//计划版本号
	//设计工作量
	//str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	//设计测线条数
	//str += "&design_line_num="+document.getElementById("design_line_num").value;
	//str += "&design_big_regraction_num="+$("#design_big_regraction_num").val();//大折射设计点数：

	
	return str;
}




</script>
<body onload="loadData()" style="overflow: hidden;">


<input type="hidden" id="project_name"/>
<input type="hidden" id="manage_org_name"/>
<input type="hidden" id="object_id"/>
<input type="hidden" id="exploration_method"/>
<input type="hidden" id="org_id"/>
<input type="hidden" id="org_subjection_id"/>
<input type="hidden" id="plan_num_value"/>
<input type="hidden" id="notes"/>	
<input type="hidden" id="start_date"/>
<input type="hidden" id="end_date"/>
<input type="hidden" id="duration_date"/>


<%--<font color="red">该信息尚未保存</font> --%>
<div id="message" align="center"></div>

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
	<tr><td><div class="tongyong_box_title">1.2 地质任务：</div></td></tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
  <tr>
	<td colspan="3" class="inquire_form4"><textarea id="notes_td"  name="notes_td"cols="45" rows="5" class="textarea" readonly="readonly"></textarea></td>
	</tr>
</table>





<%--#########################################设计工作量###########################################--%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr><td><div class="tongyong_box_title">1.3 工作量部署：</div></td></tr>
</table>
<iframe width="100%" id="viewprojectiframe" height="100%" frameborder="0" src="<%=contextPath %>/wt/pm/planManager/singlePlan/progress/viewProject.jsp" style="overflow: scroll;"></iframe>


 

<%--#########################################设计工作量###########################################--%>


<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr><td><div class="tongyong_box_title">1.4 设计参数：</div></td></tr>
</table>
<iframe width="100%" id="technicalparameteriframe" height="100%" frameborder="0" src="<%=contextPath %>/wt/tm/parameter/technicalParameter.jsp?action=view"  style="overflow: scroll;"></iframe>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr><td><div class="tongyong_box_title">1.5 工期要求：</div></td></tr>
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


<table>
	<tr>
		<td height="10">&nbsp;</td>
	</tr>
</table>
</body>
</html>