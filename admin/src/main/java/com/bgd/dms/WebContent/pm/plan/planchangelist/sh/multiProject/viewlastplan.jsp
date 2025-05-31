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











//alert("总页面viewlastplan jsp");
cruConfig.contextPath =  "<%=contextPath%>";
var basePlanId = "<%=basePlanId %>"; 

function loadData(){
	
	//alert("总页面viewlastplan jsp");
	debugger;
	var action = "<%=action%>";
	//alert(action);
	var ids = "<%=projectInfoNo %>";
	
	
	//var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no="+ids);
	var retObj1 = jcdpCallService("ProjectPlanSrv", "getEditProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);
	
	if(retObj1.map == undefined){
		//没有保存计划
		alert("未保存计划");
	} else {
		
		//page1
		//此页面为显示 页面 之前的值未保存   ，修改时重新在读取一遍数据  
		retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
	
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
		
		//1.3 工作量部署：
		document.getElementById("design_line_num").value= retObj.map.design_line_num;
		document.getElementById("design_object_workload").value= retObj.map.design_object_workload;
		//--------------------------------------------------page2--------------------------------------------------------------
		// 组织机构

		document.getElementById("boat_train").value = retObj1.map.boat_train;
		document.getElementById("project_manager").value = retObj1.map.project_manager;
		document.getElementById("boat_manager").value = retObj1.map.boat_manager;
		document.getElementById("captain").value = retObj1.map.captain;
		document.getElementById("boat_assistant_manager").value = retObj1.map.boat_assistant_manager;
		document.getElementById("first_mate").value = retObj1.map.first_mate;
		document.getElementById("shore_base_manager").value = retObj1.map.shore_base_manager;
		document.getElementById("second_mate").value = retObj1.map.second_mate;
		document.getElementById("hse_supervisor").value = retObj1.map.hse_supervisor;
		document.getElementById("third_mate").value = retObj1.map.third_mate;
		document.getElementById("navigation_leader").value = retObj1.map.navigation_leader;
		document.getElementById("boatswain").value = retObj1.map.boatswain;
		document.getElementById("instrument_leader").value = retObj1.map.instrument_leader;
		document.getElementById("chief_engineer").value = retObj1.map.chief_engineer;
		document.getElementById("air_blast_leader").value = retObj1.map.air_blast_leader;
		document.getElementById("second_engineer").value = retObj1.map.second_engineer;
		document.getElementById("geophysical_division").value = retObj1.map.geophysical_division;
		document.getElementById("team_doctor").value = retObj1.map.team_doctor;
		
		
		
		//------------------------------------------------------------page3---------------------------------------------------------------------
 
 
		document.getElementById("object_id").value = retObj.map.object_id;
		
		var projectBaselineId = retObj.projectBaselineId;
		var projectObjectId = retObj.projectObjectId;
		
		document.getElementById("baseline_plan_object_id").value = retObj.projectBaselineId;
		document.getElementById("project_plan_object_id").value = retObj.projectObjectId;
		document.getElementById("update_date").innerHTML = "&nbsp;"+retObj.map.update_date;
		document.getElementById("weather_delay").value = retObj.map.weather_delay;
		projectName = retObj.map.project_name;
		
		if(retObj.map.baseline_plan_object_id == null || retObj.map.baseline_plan_object_id == ""){
			retObj.map.baseline_plan_object_id = "1";
		}
		
		var temp = jcdpCallService("P6ProjectSrv", "queryBaselineProject", "objectId="+retObj.projectBaselineId);
		if(temp.datas != null){
				var map = temp.datas[0];
				document.getElementById("project_name").innerHTML = '&nbsp;'+map.project_name+'';
		} else {
			document.getElementById("project_name").innerHTML = '&nbsp;';
		}
		var temp = "";
		if(basePlanId != "" && basePlanId != undefined){
			temp = jcdpCallService("ProjectPlanSrv", "getBackupActivity", "objectId="+retObj.projectBaselineId+"&projectInfoNo="+ids+"&basePlanId="+basePlanId);
		}else{
			temp = jcdpCallService("ProjectPlanSrv", "getActivity", "objectId="+retObj.projectBaselineId+"&projectInfoNo="+ids);
		}
		
		list = temp;
		if(temp.datas != null) {
			var j = 0;
			var k = 0;
			var wbs_object_id = 0;
			for(var i = 0;i<temp.datas.length;i++){
				var map = temp.datas[i];
				
				if(map.listSize != undefined){
					//分隔行
					var tr = document.getElementById("lineTable").insertRow();
					if(j % 2 == 0){
						tr.className = "even";
					} else {
						tr.className = "odd";
					}
					j++;
					k=0;
					
					var td = tr.insertCell(0);
	    			td.innerHTML = map.name;
	    			td.rowSpan = map.listSize;
	    			
	    			map = temp.datas[++i];
	    			//WBS
	    			tr.insertCell(1).innerHTML = map.wbs_name;
	    			//工作内容
	    			tr.insertCell(2).innerHTML = map.name;
	    			//计划工期
	    			tr.insertCell(3).innerHTML = map.planned_duration/8;
	    			//计划开始
	    			tr.insertCell(4).innerHTML = map.planned_start_date;
	    			//计划完成
	    			tr.insertCell(5).innerHTML = map.planned_finish_date;
	    			if(map.planned_units != 0){
	    				//工作量
	    				tr.insertCell(6).innerHTML = map.planned_units;
	    				//计划日效
	    				//tr.insertCell(7).innerHTML = (map.planned_units/map.planned_duration*8).toFixed(2);
	    			} else {
	    				//工作量
	    				tr.insertCell(6).innerHTML = "";
	    				//计划日效
	    				//tr.insertCell(7).innerHTML = "";
	    			}
	    			if(wbs_object_id != map.wbs_object_id){
	    				//责任人
		    			tr.insertCell(7).innerHTML = "<input name='obs_name_"+map.wbs_object_id+"' style='text-align:center' id='obs_name_"+map.wbs_object_id+"' value='"+map.obs_name+"'/>";
		    			wbs_object_id = map.wbs_object_id;
	    			} else {
	    				//责任人
		    			tr.insertCell(7).innerHTML = map.obs_name
	    			}
	    			
				} else {
					var tr = document.getElementById("lineTable").insertRow();
					if((j+k) % 2 == 0){
						tr.className = "even";
					} else {
						tr.className = "odd";
					}
					k++;
					//WBS
	    			tr.insertCell(0).innerHTML = map.wbs_name;
					//工作内容
	    			tr.insertCell(1).innerHTML = map.name;
	    			//计划工期
	    			tr.insertCell(2).innerHTML = map.planned_duration/8;
	    			//计划开始
	    			tr.insertCell(3).innerHTML = map.planned_start_date;
	    			//计划完成
	    			tr.insertCell(4).innerHTML = map.planned_finish_date;
	    			
	    			if(map.planned_units != 0){
	    				//工作量
	    				tr.insertCell(5).innerHTML = map.planned_units;
	    				//计划日效
	    				//tr.insertCell(6).innerHTML = (map.planned_units/map.planned_duration*8).toFixed(2);
	    			} else {
	    				//工作量
	    				tr.insertCell(5).innerHTML = "";
	    				//计划日效
	    				//tr.insertCell(6).innerHTML = "";
	    			}
	    			if(wbs_object_id != map.wbs_object_id){
	    				//责任人
		    			tr.insertCell(6).innerHTML = "<input name='obs_name_"+map.wbs_object_id+"' style='text-align:center' id='obs_name_"+map.wbs_object_id+"' value='"+map.obs_name+"'/>";
		    			wbs_object_id = map.wbs_object_id;
	    			} else {
	    				//责任人
		    			tr.insertCell(6).innerHTML = map.obs_name
	    			}
				}
				
			}
		}
	
	parent.document.all("if3").style.height=300+30*temp.datas.length; 
	//parent.document.all("if3").style.width=document.body.scrollWidth; 
	
	
	}//end else

	if(action=='view'){
	
		$("#weather_delay").attr("disabled","disabled");
	}
	//禁用页面所有input框
	$("input[type=text]").attr("disabled","true");
}


</script>
<body onload="loadData()" style="overflow: hidden;">

<input type="hidden" id="project_name" />
<input type="hidden" id="manage_org_name" />
<input type="hidden" id="plan_num_value" />
<input type="hidden" id="exploration_method" />
<input type="hidden" id="org_id" />
<input type="hidden" id="org_subjection_id" />
<input type="hidden" id="object_id" />
<input type="hidden" id="project_plan_object_id"/>
<input type="hidden" id="baseline_plan_object_id"/>
<input type="hidden" id="notes" />

<input type="hidden" id="start_date" />
<input type="hidden" id="end_date" />
<input type="hidden" id="duration_date" />


<div id="addChangePlan" align="left">&nbsp;&nbsp;<b>修改项目初始计划</b></div>
 

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
		<td class="inquire_item6">设计线束数：</td>
		<td class="inquire_form6"><input type="text"
			id="design_line_num" name="design_line_num" class="input_width"
			disabled="disabled" />&nbsp;束</td>
		<td class="inquire_item6">设计工作量：</td>
		<td class="inquire_form6"><input type="text"
			id="design_object_workload" name="design_object_workload"
			class="input_width" disabled="disabled" />&nbsp;km</td>
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

<%----------------------------------------------------------------------------------------%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">2 组织机构：</div></td>
</table>

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



<%----------------------------------------------------------------------------------------%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">3 进度计划：</div></td>
</table>
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height" >

<tr class="bt_info">
<td align="right">目标项目名：</td>
<td align="left"  colspan="6" id="project_name_td1">&nbsp;</td>
</tr>
<tr class="bt_info">
<td align="right" >更新时间：</td>
<td align="left" colspan="6" id="update_date">&nbsp;</td>
</tr>
<tr class="bt_info">
<td align="center" colspan="7">项目运行计划运行时间表</td>
</tr>
</table>
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height" id="lineTable1" >
<thead>
<tr class="bt_info">
<td align="center">阶段</td>
<td align="center">WBS</td>
<td align="center">工作内容</td>
<td align="center">计划工期</td>
<td align="center">计划开始</td>
<td align="center">计划完成</td>
<td align="center">工作量</td>
<td align="center">责任人</td>
</tr>
</thead>

</table>


<%----------------------------------------------------------------------------------------%>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">自然因素影响时间</div></td>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">
<td class="inquire_form4" >
<input type="text" id="weather_delay"/>天
</td>
</tr>
</table>

</body>
</html>