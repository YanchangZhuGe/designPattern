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
cruConfig.contextPath =  "<%=contextPath%>";
var basePlanId = "<%=basePlanId %>"; 
function loadData(){
	debugger;
	var ids = "<%=projectInfoNo %>";
	
	
	//var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no="+ids);
	var retObj = jcdpCallService("ProjectPlanSrv", "getEditProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);
	
	if(retObj.map == undefined){
		//没有保存计划
	} else {
		
		//page1
		//此页面为显示 页面 之前的值未保存   ，修改时重新在读取一遍数据  
		retObjp1 = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
		
		
		document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObjp1.map.manage_org_name+'</font>';
		document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObjp1.map.project_name+'》</font>';

		document.getElementById("notes").value = retObjp1.map.notes;
		document.getElementById("notes_td").value= retObjp1.map.notes;
		
		document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
		document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;;
		document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
		

		
		//显示数据库中保存的值
			if(retObj.map.design_line_num != null && retObj.map.design_line_num != ""){
				cells++;
				if(cells%2 !=0){
					tr = document.getElementById("lineTable").insertRow();
					rows++;
					if(rows % 3 != 1){
						tr.className = "even";
					} else {
						tr.className = "odd";
					}
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计线束数：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_line_num+"&nbsp;条";
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计线束数：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_line_num+"&nbsp;条";
				}
			}
			
			if(retObj.map.design_object_workload != null && retObj.map.design_object_workload != ""){
				cells++;
				if(cells%3 ==1){
					tr = document.getElementById("lineTable").insertRow();
					rows++;
					if(rows % 2 != 0){
						tr.className = "even";
					} else {
						tr.className = "odd";
					}
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计工作量：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_object_workload+"&nbsp;km²";
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计工作量：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_object_workload+"&nbsp;km²";
				}
			}
			
			
			
			if(retObj.map.design_geophone_area != null && retObj.map.design_geophone_area != ""){
				cells++;
				if(cells%3 ==1){
					tr = document.getElementById("lineTable").insertRow();
					rows++;
					if(rows % 2 != 0){
						tr.className = "even";
					} else {
						tr.className = "odd";
					}
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计检波点面积：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_geophone_area+"&nbsp;km²";
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计检波点面积：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_geophone_area+"&nbsp;km²";
				}
			}
			
			
			if(retObj.map.design_execution_area != null && retObj.map.design_execution_area != ""){
				cells++;
				if(cells%3 ==1){
					tr = document.getElementById("lineTable").insertRow();
					rows++;
					if(rows % 2 != 0){
						tr.className = "even";
					} else {
						tr.className = "odd";
					}
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计施工面积：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_execution_area+"&nbsp;km²";
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计施工面积：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_execution_area+"&nbsp;km²";
				}
			}
			
			if(retObj.map.design_data_area != null && retObj.map.design_data_area != ""){
				cells++;
				if(cells%3 ==1){
					tr = document.getElementById("lineTable").insertRow();
					rows++;
					if(rows % 2 != 0){
						tr.className = "even";
					} else {
						tr.className = "odd";
					}
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计有资料面积：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_data_area+"&nbsp;km²";
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计有资料面积：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_data_area+"&nbsp;km²";
				}
			}
			
			
			if(retObj.map.design_sp_area != null && retObj.map.design_sp_area != ""){
				cells++;
				if(cells%3 ==1){
					tr = document.getElementById("lineTable").insertRow();
					rows++;
					if(rows % 2 != 0){
						tr.className = "even";
					} else {
						tr.className = "odd";
					}
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计激发点面积：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_sp_area+"&nbsp;km²";
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计激发点面积：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_sp_area+"&nbsp;km²";
				}
			}
			
		
		
		//page2
		
		retObjp2 = jcdpCallService("ProjectPlanSrv", "getWtOrgInfo", "projectInfoNo="+ids);//获得 队号 资质 经理 副经理 指导员
		
		var cells = 0;
		var rows = 1;
		var tr;

		if(retObj.map.team_leader != null && retObj.map.team_leader != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
			}
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "队号：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObjp2.rsMap.org_name;//队号 1
			
		}
		if(retObj.map.team_leader != null && retObj.map.team_leader != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
			}
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "队伍资质：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObjp2.rsMap.is_majorteam;//队伍资质 2
			
		}
		
		if(retObj.map.team_leader != null && retObj.map.team_leader != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
			}
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "队经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.team_leader;
			
		}
		
		if(retObj.map.collect_leader != null && retObj.map.collect_leader != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
				
			} 
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "副经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.collect_leader;
			
		}
		
		if(retObj.map.dirll_leader != null && retObj.map.dirll_leader != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
			} 
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "指导员：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.dirll_leader;
			
		}
		
		
		
		if(retObj.map.geophysical_division != null && retObj.map.geophysical_division != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
			} 
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "仪器组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.geophysical_division;
			
		}
		
		if(retObj.map.surface_monitor != null && retObj.map.surface_monitor != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
			} 
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "资料处理组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.surface_monitor;
			
		}
		
		if(retObj.map.powder_monitor != null && retObj.map.powder_monitor != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
			} 
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "司机组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.powder_monitor;
			
		}
		
		if(retObj.map.instrument_monitor != null && retObj.map.instrument_monitor != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
			} 
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "测量室内计算：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.instrument_monitor;
			
		}
		
		
		
		
		
		//page3
		document.getElementById("update_date").innerHTML = "&nbsp;"+retObj.map.update_date;
		document.getElementById("weather_delay").value = retObj.map.weather_delay;
		
		var temp = jcdpCallService("P6ProjectSrv", "queryBaselineProject", "objectId="+retObj.map.baseline_plan_object_id);
		if(temp.datas != null){
				var map = temp.datas[0];
				document.getElementById("project_name_td1").innerHTML = '&nbsp;'+map.project_name;
		} else {
		}
		
		var temp = "";
		
		if(basePlanId != "" && basePlanId != undefined){
			temp = jcdpCallService("ProjectPlanSrv", "getBackupActivity", "objectId="+retObj.map.baseline_plan_object_id+"&projectInfoNo="+ids+"&basePlanId="+basePlanId);
		}else{
			temp = jcdpCallService("ProjectPlanSrv", "getActivityWt", "objectId="+retObj.map.baseline_plan_object_id+"&projectInfoNo="+ids);
		}
		var unitRet = jcdpCallService("ProjectPlanSrv", "getActivityWtUnits", "projectInfoNo="+ids);


		if(temp.datas != null) {
			var j = 0;
			var k = 0;
			for(var i = 0;i<temp.datas.length;i++){
				var map = temp.datas[i];
				
				if(map.listSize != undefined){
					//分隔行
					var tr = document.getElementById("lineTable1").insertRow();
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

/*
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
*/	    			
	    			//责任人
	    			tr.insertCell(7).innerHTML = map.obs_name;
	    			
				} else {
					var tr = document.getElementById("lineTable1").insertRow();
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
/*	    			
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
*/	    			
	    			//责任人
	    			tr.insertCell(6).innerHTML = map.obs_name;
				}
				
			}
		}
		
	}//end else
}


</script>
<body onload="loadData()" style="overflow-y: auto; overflow-x: auto;">

<input type="hidden" id="project_name"/>
<input type="hidden" id="manage_org_name"/>
<input type="hidden" id="object_id"/>
<input type="hidden" id="exploration_method"/>
<input type="hidden" id="org_id"/>
<input type="hidden" id="org_subjection_id"/>
<input type="hidden" id="object_id"/>
<input type="hidden" id="notes"/>	
<input type="hidden" id="start_date"/>
<input type="hidden" id="end_date"/>
<input type="hidden" id="duration_date"/>
<input type="hidden" id="object_id"/>
<input type="hidden" id="project_plan_object_id"/>
<input type="hidden" id="baseline_plan_object_id"/>



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






<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr><td><div class="tongyong_box_title">1.3 工作量部署：</div></td></tr>
</table>
<iframe width="100%" id="viewprojectiframe" height="100%" frameborder="0" src="<%=contextPath %>/wt/pm/planManager/singlePlan/progress/viewProject.jsp" style="overflow: scroll;"></iframe>





<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr><td><div class="tongyong_box_title">1.4 施工方法：</div></td></tr>
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
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr><td><div class="tongyong_box_title">2 组织机构：</div></td></tr>
</table>
<table id="org" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >

</table>



<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr><td><div class="tongyong_box_title">3 进度计划：</div></td></tr>
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
<tbody id="table_boby">
</tbody>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr><td><div class="tongyong_box_title">自然因素影响时间</div></td></tr>
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