<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
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
	
	//添加井中项目判断
	String sql = "select t.project_type from gp_task_project t where t.project_info_no='"+projectInfoNo+"'";
  	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
  	String projectType = "";
	if(list!=null&&list.size()!=0){
		Map map = (Map)list.get(0);
		projectType = (String)map.get("projectType");
	}
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
debugger;
var basePlanId = "<%=basePlanId %>"; 

function loadData(){
	var projectType = "<%=projectType %>";//项目类型
	
	var ids = "<%=projectInfoNo %>";
	
	
	//var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no="+ids);
	var retObj = jcdpCallService("ProjectPlanSrv", "getEditProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);
	
	if(retObj.map == undefined){
		//没有保存计划
	} else {
		
		//page1
		document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
		document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
		//document.getElementById("project_name").value = retObj.map.project_name;
		//document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
		//document.getElementById("exploration_method").value = retObj.map.exploration_method;
		//document.getElementById("org_id").value = retObj.map.org_id;
		//document.getElementById("org_subjection_id").value = retObj.map.org_subjection_id;
		

		document.getElementById("notes").value = retObj.map.notes;
		document.getElementById("notes_td").value= retObj.map.notes;
		
		document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
		document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;;
		document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
		
		document.getElementById("start_date").value = retObj.map.project_design_start_date;
		document.getElementById("end_date").value = retObj.map.project_design_end_date;
		document.getElementById("duration_date").value = retObj.map.project_duration_date;

		<%--原4期代码
		
		document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.start_date;
		document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.end_date;
		document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.duration_date+'天';
		
		document.getElementById("start_date").value = retObj.map.start_date;
		document.getElementById("end_date").value = retObj.map.end_date;
		document.getElementById("duration_date").value = retObj.map.duration_date;
		--%>
		


		//alert('projectid:'+ids);
		//alert('projectType:'+projectType);

		//显示项目井中工作量
		if("5000100004000000008"==projectType){
			<%--
			document.getElementById("design_workload1").value= retObj.dynamicMap.design_workload1;//设计工作量
			document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;//设计测线条数
			document.getElementById("workload").value= retObj.dynamicMap.workload;
			document.getElementById("full_fold_workload").value= retObj.dynamicMap.full_fold_workload;//试验炮数
			document.getElementById("design_geophone_num").value= retObj.dynamicMap.design_geophone_num;//设计检波点数
			document.getElementById("design_sp_num").value= retObj.dynamicMap.design_sp_num;//设计炮数
			document.getElementById("design_small_regraction_num").value= retObj.dynamicMap.design_small_regraction_num;//小折射设计点数
			document.getElementById("design_big_regraction_num").value= retObj.dynamicMap.design_big_regraction_num;//大折射设计点数：
			document.getElementById("design_micro_measue_num").value= retObj.dynamicMap.design_micro_measue_num;//微测井设计点数
			document.getElementById("design_drill_num").value= retObj.dynamicMap.design_drill_num;//钻井设计点数：
			document.getElementById("org_id").value= retObj.dynamicMap.org_id;
			document.getElementById("org_name").value= retObj.dynamicMap.org_name;
			document.getElementById("measure_km").value= retObj.dynamicMap.measure_km;//设计总公里数：
			document.getElementById("design_sp_num_zy").value= retObj.dynamicMap.design_sp_num_zy;
			document.getElementById("press_well_num").value= retObj.dynamicMap.press_well_num;//压裂监测井段：
				--%>
			<%--
			表bgp_pm_project_plan 字段
			design_object_workload//设计工作量
			design_line_num//设计测线条数
			full_fold_workload//试验炮数
			design_small_regraction_num//小折射设计点数
			design_big_regraction_num//大折射设计点数
			design_micro_measue_num//微测井设计点数
			design_drill_num//钻井设计点数
			measure_km//设计总公里数
			press_well_num//压裂监测井段
			
			--%>
			$("#lineTable").html('<tr class="even">'
				    +'<td class="inquire_item6" id="design_line_num_td">设计工作量：</td>'
				    +'<td class="inquire_form6" id="item1_0"><input type="text" id="design_object_workload" name="design_object_workload" class="input_width"  disabled="disabled" />&nbsp;条</td>'
				    +'<td class="inquire_item6" id="design_object_workload_td">设计测线条数：</td>'
				    +'<td class="inquire_form6" id="item1_1"><input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;km</td>'
				    +'<td class="inquire_item6">试验炮数：</td>'
				    +'<td class="inquire_form6" id="item1_2"><input type="text" id="full_fold_workload" name="full_fold_workload" class="input_width" disabled="disabled" />&nbsp;炮</td>'
				    +'</tr>'
				    +'<tr class="odd">'
				    +'<td class="inquire_item6">设计检波点数：</td>'
				    +'<td class="inquire_form6" id="item1_3"><input type="text" id="design_geophone_num" name="design_geophone_num" class="input_width" disabled="disabled" />&nbsp;个</td>'
				    +'<td class="inquire_item6">设计炮数：</td>'
				    +'<td class="inquire_form6" id="item1_4"><input type="text" id="design_sp_num" name="design_sp_num" class="input_width" disabled="disabled" />&nbsp;炮</td>'
				    +'<td class="inquire_item6">小折射设计点数：</td>'
				    +'<td class="inquire_form6" id="item1_5"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" disabled="disabled" />&nbsp;炮</td>'
				    +'</tr>'
				    +'<tr class="even">'
				    +'<td class="inquire_item6">大折射设计点数：</td>'
				    +'<td class="inquire_form6" id="item1_3"><input type="text" id="design_big_regraction_num" name="design_big_regraction_num" class="input_width" disabled="disabled" />&nbsp;个</td>'
				    +'<td class="inquire_item6">微测井设计点数：</td>'
				    +'<td class="inquire_form6" id="item1_4"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" disabled="disabled" />&nbsp;炮</td>'
				    +'<td class="inquire_item6">钻井设计点数：</td>'
				    +'<td class="inquire_form6" id="item1_5"><input type="text" id="design_drill_num" name="design_drill_num" class="input_width" disabled="disabled" />&nbsp;炮</td>'
				    +'</tr>'
				    +'<tr class="odd">'
				    +'<td class="inquire_item6">设计总公里数：</td>'
				    +'<td class="inquire_form6" id="item1_3"><input type="text" id="measure_km" name="measure_km" class="input_width" disabled="disabled" />&nbsp;个</td>'
				    +'<td class="inquire_item6">压裂监测井段：</td>'
				    +'<td class="inquire_form6" id="item1_4"><input type="text" id="press_well_num" name="press_well_num" class="input_width" disabled="disabled" />&nbsp;炮</td>'
				    +'<td class="inquire_item6"></td>'
				    +'<td class="inquire_form6" id="item1_5"></td>'
				    +'</tr>'
				    );
			//alert($("#lineTable").html());
			$("#design_object_workload").val(retObj.map.design_object_workload);//设计工作量
			$("#design_line_num").val(retObj.map.design_line_num);//设计测线条数
			$("#full_fold_workload").val(retObj.map.full_fold_workload);//试验炮数
			$("#design_geophone_num").val(retObj.map.design_geophone_num);//设计检波点数
			$("#design_sp_num").val(retObj.map.design_sp_num);//设计炮数
			$("#design_small_regraction_num").val(retObj.map.design_small_regraction_num);//小折射设计点数
			$("#design_big_regraction_num").val(retObj.map.design_big_regraction_num);//大折射设计点数：
			$("#design_micro_measue_num").val(retObj.map.design_micro_measue_num);//微测井设计点数
			$("#design_drill_num").val(retObj.map.design_drill_num);//钻井设计点数：
			$("#measure_km").val(retObj.map.measure_km);//设计总公里数：
			$("#press_well_num").val(retObj.map.press_well_num);//压裂监测井段：

			
			
		}else{
		//非井中工作量开始


		
		
		var cells = 0;
		var rows = 1;
		var tr;
		if(retObj.map.full_fold_workload != null && retObj.map.full_fold_workload != ""){
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
				td.innerHTML = "设计试验炮：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.full_fold_workload+"&nbsp;炮";
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item6";
				td.innerHTML = "设计试验炮：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.full_fold_workload+"&nbsp;炮";
			}
		}
		
		if(retObj.map.design_geophone_num != null && retObj.map.design_geophone_num != ""){
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
				td.innerHTML = "设计检波点数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_geophone_num+"&nbsp;个";
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item6";
				td.innerHTML = "设计检波点数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_geophone_num+"&nbsp;个";
			}
		}
		
		if(retObj.map.design_sp_num != null && retObj.map.design_sp_num != ""){
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
				td.innerHTML = "设计炮数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_sp_num+"&nbsp;炮";
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item6";
				td.innerHTML = "设计炮数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_sp_num+"&nbsp;炮";
			}
		}
		
		if(retObj.map.design_small_regraction_num != null && retObj.map.design_small_regraction_num != ""){
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
				td.innerHTML = "小折射设计点数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_small_regraction_num+"&nbsp;个";
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item6";
				td.innerHTML = "小折射设计点数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_small_regraction_num+"&nbsp;个";
			}
		}
		
		if(retObj.map.design_micro_measue_num != null && retObj.map.design_micro_measue_num != ""){
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
				td.innerHTML = "微测井设计点数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_micro_measue_num+"&nbsp;个";
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item6";
				td.innerHTML = "微测井设计点数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_micro_measue_num+"&nbsp;个";
			}
		}
		
		if(retObj.map.design_drill_num != null && retObj.map.design_drill_num != ""){
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
				td.innerHTML = "钻井设计点数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_drill_num+"&nbsp;个";
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item6";
				td.innerHTML = "钻井设计点数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_drill_num+"&nbsp;个";
			}
		}
		
		if(retObj.map.measure_km != null && retObj.map.measure_km != ""){
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
				td.innerHTML = "测量总公里数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.measure_km+"&nbsp;km";
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item6";
				td.innerHTML = "测量总公里数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.measure_km+"&nbsp;km";
			}
		}
		
		if(retObj.map.design_sp_num_zy != null && retObj.map.design_sp_num_zy != ""){
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
				td.innerHTML = "设计震源炮数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_sp_num_zy+"&nbsp;个";
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item6";
				td.innerHTML = "设计震源炮数：";
				td = tr.insertCell();
				td.className = "inquire_form6";
				td.innerHTML = retObj.map.design_sp_num_zy+"&nbsp;个";
			}
		}
		
		//显示数据库中保存的值
		if(retObj.map.exploration_method == "0300100012000000002"){
			//二维
			//document.getElementById("workload_td").innerHTML= '二维测线：<font style="text-decoration: underline;">'+retObj.map.design_line_num+'</font>条<font style="text-decoration: underline;">'+retObj.map.design_object_workload+'</font>km<font style="text-decoration: underline;">'+retObj.map.design_sp_num+'</font>炮';
			//document.getElementById("design_line_num_td").innerHTML= '设计测线条数：';
			//document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;条';
			//document.getElementById("design_line_num").value= retObj.map.design_line_num;
			
			
			if(retObj.map.design_line_num != null && retObj.map.design_line_num != ""){
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
					td.innerHTML = "设计测线条数：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_line_num+"&nbsp;条";
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计测线条数：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_line_num+"&nbsp;条";
				}
			}
			
			
			//document.getElementById("design_object_workload_td").innerHTML= '设计工作量：';
			//document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km';
			//document.getElementById("design_object_workload").value= retObj.map.design_object_workload;
			
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
					td.innerHTML = retObj.map.design_object_workload+"&nbsp;km";
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item6";
					td.innerHTML = "设计工作量：";
					td = tr.insertCell();
					td.className = "inquire_form6";
					td.innerHTML = retObj.map.design_object_workload+"&nbsp;km";
				}
			}
			
			//document.getElementById("tr1_9").style.display="none";
			//document.getElementById("item1_10_1").style.display="none";
			//document.getElementById("item1_10").style.display="none";
			//document.getElementById("item1_11").style.display="none";
			//document.getElementById("item1_11_1").style.display="none";
			//document.getElementById("tr1_10").style.display="none";
		} else {
			//三维
			//document.getElementById("workload_td").innerHTML= '三维偏前满覆盖面积：<font style="text-decoration: underline;">'+retObj.map.design_object_workload+'</font>km²<font style="text-decoration: underline;">'+retObj.map.design_line_num+'</font>束线<font style="text-decoration: underline;">'+retObj.map.design_sp_num+'</font>炮';
			//tr = document.getElementById("lineTable").insertRow();
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
			
			
			//document.getElementById("design_line_num_td").innerHTML= '设计线束数：';
			//document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;束';
			//document.getElementById("design_line_num").value= retObj.map.design_line_num;
			
			//document.getElementById("design_object_workload_td").innerHTML= '设计工作量：';
			//document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km²';
			//document.getElementById("design_object_workload").value= retObj.map.design_object_workload;
			
			//document.getElementById("design_geophone_area").value= retObj.map.design_geophone_area;
			
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
			
			//document.getElementById("design_execution_area").value= retObj.map.design_execution_area;
			
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
			
			//document.getElementById("design_data_area").value= retObj.map.design_data_area;
			
			//document.getElementById("design_sp_area").value= retObj.map.design_sp_area;
			
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
			
			//document.getElementById("tr1_9").style.display="block";
			//document.getElementById("item1_10_1").style.display="block";
			//document.getElementById("item1_10").style.display="block";
			//document.getElementById("item1_11").style.display="block";
			//document.getElementById("item1_11_1").style.display="block";
			//document.getElementById("tr1_10").style.display="block";
		}
		//非井中工作量结束
		}		
		//page2
		document.getElementById("team_id_td").innerHTML= retObj.map.team_id;
		document.getElementById("is_majorteam_td").innerHTML= retObj.map.is_majorteam;
		
		//document.getElementById("team_leader").value = retObj.map.team_leader;
		//document.getElementById("collect_leader").value = retObj.map.collect_leader;
		//document.getElementById("surface_monitor").value = retObj.map.surface_monitor;
		//document.getElementById("powder_monitor").value = retObj.map.powder_monitor;
		//document.getElementById("instrument_monitor").value = retObj.map.instrument_monitor;
		//document.getElementById("acquire_leader").value = retObj.map.acquire_leader;
		//document.getElementById("dirll_leader").value = retObj.map.dirll_leader;
		//document.getElementById("dirll_monitor").value = retObj.map.dirll_monitor;
		//document.getElementById("survey_leader").value = retObj.map.survey_leader;
		//document.getElementById("survey_monitor").value = retObj.map.survey_monitor;
		//document.getElementById("geophysical_division").value = retObj.map.geophysical_division;
		//document.getElementById("suface_leader").value = retObj.map.suface_leader;
		
		var cells = 0;
		var rows = 1;
		var tr;
		//debugger;
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
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "队经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.team_leader;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "队经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.team_leader;
			}
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
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "采集分管副经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.collect_leader;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "采集分管副经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.collect_leader;
			}
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
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "钻井分管副经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.dirll_leader;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "钻井分管副经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.dirll_leader;
			}
		}
		
		if(retObj.map.survey_leader != null && retObj.map.survey_leader != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "测量分管副经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.survey_leader;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "测量分管副经理：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.survey_leader;
			}
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
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "地球物理师：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.geophysical_division;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "地球物理师：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.geophysical_division;
			}
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
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "放线班长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.surface_monitor;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "放线班长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.surface_monitor;
			}
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
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "爆炸班长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.powder_monitor;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "爆炸班长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.powder_monitor;
			}
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
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "仪器组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.instrument_monitor;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "仪器组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.instrument_monitor;
			}
		}
		
		if(retObj.map.acquire_leader != null && retObj.map.acquire_leader != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "震源组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.acquire_leader;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "震源组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.acquire_leader;
			}
		}
		
		if(retObj.map.dirll_monitor != null && retObj.map.dirll_monitor != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "钻井组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.dirll_monitor;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "钻井组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.dirll_monitor;
			}
		}
		
		if(retObj.map.survey_monitor != null && retObj.map.survey_monitor != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "测量项目长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.survey_monitor;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "测量项目长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.survey_monitor;
			}
		}
		
		if(retObj.map.suface_leader != null && retObj.map.suface_leader != "") {
			cells++;
			if(cells%2 !=0){
				tr = document.getElementById("org").insertRow();
				rows++;
				if(rows % 2 != 0){
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "表层调查组组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.suface_leader;
			} else {
				var td = tr.insertCell();
				td.className = "inquire_item4";
				td.innerHTML = "表层调查组组长：";
				td = tr.insertCell();
				td.className = "inquire_form4";
				td.innerHTML = retObj.map.suface_leader;
			}
		}
		
		//page3
		//document.getElementById("baseline_plan_object_id").value = retObj.map.baseline_plan_object_id;
		//document.getElementById("project_plan_object_id").value = retObj.map.project_plan_object_id;
		document.getElementById("update_date").innerHTML = "&nbsp;"+retObj.map.update_date;
		document.getElementById("weather_delay").value = retObj.map.weather_delay;
		
		var temp = jcdpCallService("P6ProjectSrv", "queryBaselineProject", "objectId="+retObj.map.baseline_plan_object_id);
		if(temp.datas != null){
				var map = temp.datas[0];
				document.getElementById("project_name_td1").innerHTML = '&nbsp;'+map.project_name;
		} else {
		}
		
		//var temp = jcdpCallService("ProjectPlanSrv", "getActivity", "objectId="+retObj.map.baseline_plan_object_id+"&projectInfoNo="+ids);
		var temp = "";
		
		if(basePlanId != "" && basePlanId != undefined){
			temp = jcdpCallService("ProjectPlanSrv", "getBackupActivity", "objectId="+retObj.map.baseline_plan_object_id+"&projectInfoNo="+ids+"&basePlanId="+basePlanId);
		}else{
			temp = jcdpCallService("ProjectPlanSrv", "getActivity", "objectId="+retObj.map.baseline_plan_object_id+"&projectInfoNo="+ids);
		}
		
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
	    			//责任人
	    			tr.insertCell(6).innerHTML = map.obs_name;
				}
				
			}
		}
		
	}//end else
		
	//如果是大港物探处的项目，工作量部署一致不区分陆地和浅海
	var org_subjection_id ='<%=org_subjection_id%>';
	if(org_subjection_id!=null && org_subjection_id.indexOf("C105007")!=-1){
		document.getElementById("lineTable").style.display = 'none';
		document.getElementById("if6").style.display = 'block';
		
		document.getElementById("org").style.display = 'none';
		document.getElementById("if4").style.display = 'block';
	}else{
		document.getElementById("lineTable").style.display = 'block';
		document.getElementById("if6").style.display = 'none';
		
		document.getElementById("org").style.display = 'block';
		document.getElementById("if6").style.display = 'none';
	}
}


</script>
<body onload="loadData()" style="overflow-y: auto; overflow-x: auto;">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr>
		<td><div class="tongyong_box_title">1.1 项目来源：</div></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">
<input type="hidden" id="project_name"/>
<input type="hidden" id="manage_org_name"/>
<input type="hidden" id="object_id"/>
<input type="hidden" id="exploration_method"/>
<input type="hidden" id="org_id"/>
<input type="hidden" id="org_subjection_id"/>
<td class="inquire_form4" id="manage_org_name_td"></td>
</tr>
<tr class="odd">
<td class="inquire_form4" id="project_name_td"></td>
</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.2 地质任务：</div></td>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
  <tr>
  <input type="hidden" id="object_id"/>
  <input type="hidden" id="notes"/>	
	<td colspan="3" class="inquire_form4"><textarea id="notes_td"  name="notes_td"cols="45" rows="5" class="textarea" readonly="readonly"></textarea></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.3 工作量部署：</div></td>
</table>
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height" id="lineTable" style="overflow: scroll;">
<input type="hidden" id="object_id"/></table>
<!-- 大港物探处的工作量部署-->
<iframe width="100%" id="if6" height="100%" frameborder="0" src="<%=contextPath %>/pm/plan/planchangelist/workload.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="display: none;" ></iframe>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.4 施工方法：</div></td>
</table>


<%--判断是否为井中项目施工方法  --%>
<%if(org_subjection_id!=null && org_subjection_id.trim().startsWith("C105007")){%>
	<!-- 大港物探处的工作量部署-->
	<iframe width="100%" id="if5" height="100%;" frameborder="0" src="<%=contextPath %>/pm/project/singleProject/workmethod.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="overflow: scroll;" ></iframe>

<% }else if("5000100004000000008".equals(projectType)){//井中项目 施工方法
 %>
		<iframe width="100%" id="if5"height="100%" frameborder="0" src="<%=contextPath %>/ws/pm/plan/singlePlan/projectSchedule/wellmethod.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="overflow: scroll;"></iframe>
		
<%}else{ %>
	<iframe width="100%" id="if5"height="100%" frameborder="0" src="<%=contextPath %>/pm/project/singleProject/workmethodshow.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="overflow: scroll;"></iframe>
<%	} %>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.5 工期要求：</div></td>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">
<input type="hidden" id="start_date"/>
<input type="hidden" id="end_date"/>
<input type="hidden" id="duration_date"/>
<input type="hidden" id="object_id"/>
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
	<td><div class="tongyong_box_title">2 组织机构：</div></td>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="org">
<tr class="even">
<td class="inquire_item4" >队号：</td>
<td class="inquire_form4"  id="team_id_td" >&nbsp;</td>
<td class="inquire_item4" >地震队资质：</td>
<td class="inquire_form4" id="is_majorteam_td">&nbsp;</td>
</tr>
</table>

<!-- 大港物探处的组织机构 -->
<iframe width="100%" id="if4" height="100%;" frameborder="0" src="<%=contextPath %>/pm/plan/planchangelist/orgInfoView.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="overflow: scroll;" ></iframe>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">3 进度计划：</div></td>
</table>
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height" >
<input type="hidden" id="object_id"/>
<input type="hidden" id="project_plan_object_id"/>
<input type="hidden" id="baseline_plan_object_id"/>
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
<script type="text/javascript">
var org_subjection_id ='<%=org_subjection_id%>';
if(org_subjection_id!=null && org_subjection_id.indexOf("C105007")!=-1){//大港
	document.getElementById("if5").style.height = '700';
	var timer = window.setInterval(function(){
		var scrollHeight = window.frames['if5'].document.body.scrollHeight;
		if(scrollHeight >216){
			document.getElementById("if5").style.height = window.frames['if5'].document.body.scrollHeight;
			clearInterval(timer);
			return;
		}
	},1000) ;
	
	var timer1 = window.setInterval(function(){
		var scrollHeight = document.body.scrollHeight;
		if(scrollHeight >216){
			var exploration_method = window.frames['if6'].getExplorationMethod();
			if("0300100012000000002" == exploration_method){
				document.getElementById("if6").style.height = window.frames['if6'].document.getElementById("workLoad2").lastChild.clientHeight-(-3);
			}else{
				document.getElementById("if6").style.height = window.frames['if6'].document.getElementById("workLoad3").lastChild.clientHeight-(-3);
			}
			clearInterval(timer1);
			return;
		}
	},1000) ;
	
	var timer2 = window.setInterval(function(){
		var scrollHeight = document.body.scrollHeight;
		if(scrollHeight >216){
			document.getElementById("if4").style.height = window.frames['if4'].document.body.scrollHeight;
			clearInterval(timer2);
			return;
		}
	},1000) ;
}


</script>
</body>
</html>