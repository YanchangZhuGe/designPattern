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

<body style="overflow: auto;">
<div id="addChangePlan" align="left">&nbsp;&nbsp;<b>修改项目初始计划</b></div>
<div id="selectProject" style="display: block;">
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height">
<tr>
<td>P6中没有指定目标项目</td>
</tr>
</table>
</div>
<div id="data" style="display: none;">
<input type="hidden" id="object_id"/>
<input type="hidden" id="project_plan_object_id"/>
<input type="hidden" id="baseline_plan_object_id"/>
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height" >
<tr class="bt_info">
<td align="right">目标项目名：</td>
<td align="left"  colspan="6" id="project_name">&nbsp;</td>
</tr>
<tr class="bt_info">
<td align="right" >更新时间：</td>
<td align="left" colspan="6" id="update_date">&nbsp;</td>
</tr>
<tr class="bt_info">
<td align="center" colspan="7">项目运行计划运行时间表</td>
</tr>
</table>
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height" id="lineTable" >
<thead>
<tr class="bt_info">
<td align="center">阶段</td>
<td align="center">WBS</td>
<td align="center">工作内容</td>
<td align="center">计划工期</td>
<td align="center">计划开始</td>
<td align="center">计划完成</td>
<td align="center">工作量</td>
<!-- <td align="center">计划日效</td> -->
<td align="center">责任人</td>
<!-- <td align="center">备注</td> -->
</tr>
</thead>
<tbody id="table_boby">
</tbody>
</table>
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
<div id="oper_div">
<%if(action != "view" && !"view".equals(action)){ %>
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
<%} %>
</div>
</div>
<table>
	<tr>
		<td height="10">&nbsp;</td>
	</tr>
</table>
</body>

<script type="text/javascript" language="javascript">
cruConfig.contextPath =  "<%=contextPath%>";
var notSaveFlag = "<%=notSaveFlag %>";
var basePlanId = "<%=basePlanId %>";

if(basePlanId != ""){
	$("#addChangePlan").html("&nbsp;&nbsp;<b>修改项目变更计划"+basePlanId+"</b>");
}

	var list;
	var ids = "<%=projectInfoNo %>";
	
	var projectName = "";
	debugger;
	var unitRet = jcdpCallService("ProjectPlanSrv", "getActivityWtUnits", "projectInfoNo="+ids);
	
	var retObj = jcdpCallService("ProjectPlanSrv", "getEditProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);
	var projectBaselineId = retObj.projectBaselineId;
	var projectObjectId = retObj.projectObjectId;
	if(retObj.map == undefined || retObj.map.baseline_plan_object_id == undefined){
		//需要创建记录
		
		if(projectBaselineId != undefined && projectObjectId != undefined && projectBaselineId != ""){
			document.getElementById("selectProject").style.display="none";
			document.getElementById("data").style.display="block";
			document.getElementById("baseline_plan_object_id").value = projectBaselineId;
			document.getElementById("project_plan_object_id").value = projectObjectId;
			
			var temp = jcdpCallService("P6ProjectSrv", "queryBaselineProject", "objectId="+projectBaselineId);
			if(temp.datas != null){
					var map = temp.datas[0];
					document.getElementById("project_name").innerHTML = '&nbsp;'+map.project_name+'';
			} else {
				document.getElementById("project_name").innerHTML = '&nbsp;';
			}
			var temp = jcdpCallService("ProjectPlanSrv", "getActivityWt", "objectId="+projectBaselineId+"&projectInfoNo="+ids);
			
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
	    				tr.insertCell(6).innerHTML = "";
	    				for(var m=0;m<unitRet.listResult.length;m++){
	    					var resultUnit = unitRet.listResult[m];
	    						if(resultUnit.name==map.name){
	    		    				tr.insertCell(6).innerHTML = resultUnit.value;
	    		    				break;
	    						}
	    				}
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
	    				tr.insertCell(5).innerHTML = "";
	    				for(var m=0;m<unitRet.listResult.length;m++){
	    					var resultUnit = unitRet.listResult[m];
	    						if(resultUnit.name==map.name){
	    		    				tr.insertCell(5).innerHTML = resultUnit.value;
	    		    				break;
	    						}
	    				}
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
		
		}else{
			document.getElementById("selectProject").style.display="block";
			document.getElementById("data").style.display="none";
		}

	} else {
		//无须创建记录
		debugger;
		document.getElementById("selectProject").style.display="none";
		document.getElementById("data").style.display="block";
		document.getElementById("object_id").value = retObj.map.object_id;
		//document.getElementById("baseline_plan_object_id").value = retObj.map.baseline_plan_object_id;
		//document.getElementById("project_plan_object_id").value = retObj.map.project_plan_object_id;
		document.getElementById("baseline_plan_object_id").value = retObj.projectBaselineId;
		document.getElementById("project_plan_object_id").value = retObj.projectObjectId;
		
		document.getElementById("update_date").innerHTML = "&nbsp;"+retObj.map.update_date;
		document.getElementById("weather_delay").value = retObj.map.weather_delay;
		projectName = retObj.map.project_name;
		
		//if(retObj.map.baseline_plan_object_id == null || retObj.map.baseline_plan_object_id == ""){
		//	retObj.map.baseline_plan_object_id = "1";
		//}
		
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
			temp = jcdpCallService("ProjectPlanSrv", "getActivityWt", "objectId="+retObj.projectBaselineId+"&projectInfoNo="+ids);
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
    				tr.insertCell(6).innerHTML = "";
    				for(var m=0;m<unitRet.listResult.length;m++){
    					var resultUnit = unitRet.listResult[m];
    						if(resultUnit.name==map.name){
    		    				tr.insertCell(6).innerHTML = resultUnit.value;
    		    				break;
    						}
    				}
	    			
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
    				tr.insertCell(5).innerHTML = "";
	    			
	    			for(var m=0;m<unitRet.listResult.length;m++){
	    				var resultUnit = unitRet.listResult[m];
	    				
	    					if(resultUnit.name==map.name){
	    	    				tr.insertCell(5).innerHTML = resultUnit.value;
	    	    				break;
	    					}
	    			}
	    			
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
	
	//parent.document.all("if3").style.height=300+30*temp.datas.length; 
	//parent.document.all("if3").style.width=document.body.scrollWidth; 
	
	}
	
	
function getProjectPlanStr(){
	if(list == null){
		alert("请选择目标项目!");
		return;
	}
	
	var str = "&project_plan_object_id="+document.getElementById("project_plan_object_id").value;
	str += "&baseline_plan_object_id="+document.getElementById("baseline_plan_object_id").value;
	str += "&weather_delay="+document.getElementById("weather_delay").value;
	
	var length = list.datas.length;
	var wbs_object_id = 0;
	for(var i = 0; i < length; i++){
		var map = list.datas[i];
		if(wbs_object_id != map.wbs_object_id){
			var obj = document.getElementById("obs_name_"+map.wbs_object_id);
			if(obj == null || obj.value == null){
				
			} else {
				str += "&obs_name_"+map.wbs_object_id+"="+obj.value;
			}
			wbs_object_id = map.wbs_object_id;
		}
	}
	return str;
}
	
function save(){
	debugger;
	if(list == null){
		alert("请选择目标项目!");
		return;
	}
	
	var baseInfoStr = "";
	var orgInfoStr = "";
	var ctt = this.parent.frames;
	if(ctt.length != 0){
		if(notSaveFlag == "1"){
			
		}
		baseInfoStr = ctt.frames["if1"].getBaseInfoStr();
		orgInfoStr = ctt.frames["if2"].getOrgInfoStr();
	}
	
	var str="project_info_no=<%=projectInfoNo %>";
	str += "&project_plan_object_id="+document.getElementById("project_plan_object_id").value;
	str += "&baseline_plan_object_id="+document.getElementById("baseline_plan_object_id").value;
	str += "&weather_delay="+document.getElementById("weather_delay").value;
	str += "&object_id="+document.getElementById("object_id").value;
	str += baseInfoStr;
	str += orgInfoStr;
	
	var length = list.datas.length;
	var wbs_object_id = 0;
	for(var i = 0; i < length; i++){
		var map = list.datas[i];
		if(wbs_object_id != map.wbs_object_id){
			var obj = document.getElementById("obs_name_"+map.wbs_object_id);
			if(obj == null || obj.value == null){
				
			} else {
				str += "&obs_name_"+map.wbs_object_id+"="+obj.value;
			}
			wbs_object_id = map.wbs_object_id;
		}
	}
	
	
	if(basePlanId != "" && basePlanId != undefined){
		var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
		if(retObj != null && retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}else{
		var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectPlan", str);
		if(retObj != null && retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}
}

function updateData(projectObjectId,targetProjectObjectId){
	debugger;
	document.getElementById('project_plan_object_id').value = projectObjectId;
	document.getElementById('baseline_plan_object_id').value = targetProjectObjectId;
	document.getElementById("selectProject").style.display="none";
	document.getElementById("data").style.display="block";
	var temp = jcdpCallService("P6ProjectSrv", "queryBaselineProject", "projectObjectId="+projectObjectId+"&targetObjectId="+targetProjectObjectId);
	if(temp.datas != null){
			debugger;
			var map = temp.datas[0];
			document.getElementById("project_name").innerHTML = "<font color='red'>&nbsp;"+map.project_name+"</font>";
			document.getElementById("update_date").innerHTML = "<font color='red'>&nbsp;"+(new Date()).toLocaleDateString()+"</font>";
	}
	var elementList = document.getElementById("table_boby");
	while(elementList.hasChildNodes()){
	      elementList.removeChild(elementList.lastChild);
	}
	//var row = table.rows[];
	temp = jcdpCallService("ProjectPlanSrv", "getActivityWt", "objectId="+targetProjectObjectId+"&projectInfoNo="+ids);
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
    				//tr.insertCell(6).innerHTML =(map.planned_units/map.planned_duration*8).toFixed(2);
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
	parent.document.all("if3").style.height=document.body.scrollHeight; 
	parent.document.all("if3").style.width=document.body.scrollWidth; 
}

function toSelectProject(){
	popWindow('<%=contextPath%>/pm/plan/baselineProjectList.jsp?projectInfoNo=<%=projectInfoNo %>');
	//window.showModalDialog('<%=contextPath%>/pm/plan/baselineProjectList.jsp?projectInfoNo=<%=projectInfoNo %>', teamInfo);
}

</script>
</html>