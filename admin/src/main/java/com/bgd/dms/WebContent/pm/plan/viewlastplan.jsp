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
	String action = request.getParameter("action");
	if(action == null || "".equals(action)){
		action = "edit";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
	//根据项目id获得项目类型
	String sql = "select t.project_type from gp_task_project t where t.project_info_no='"+projectInfoNo+"'";
  	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
  	String projectType = "";
	if(list!=null&&list.size()!=0){
		Map map = (Map)list.get(0);
		projectType = (String)map.get("projectType");
	}
	
	//根据项目类型判断 
	if("5000100004000000009".equals(projectType)){
		//综合物化探 到综合物化探页面
		//request.getRequestDispatcher("/wt/tm/parameter/technicalParameter.jsp").forward(request,response);
		response.sendRedirect(contextPath+"/wt/pm/planManager/multiProject/progress/viewlastplan.jsp?projectInfoNo="+projectInfoNo+"&action=view");

	}
	String org_subjection_id = QualityUtil.getProjectSubjectionId(projectInfoNo);
	if(org_subjection_id!=null && org_subjection_id.startsWith("C105007")){
		response.sendRedirect(contextPath+"/pm/plan/planchangelist/planListView.jsp?projectInfoNo="+projectInfoNo+"&action=view");
	}
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
var projectType = "<%=projectType %>";//项目类型

cruConfig.contextPath =  "<%=contextPath%>";
var ids = "<%=projectInfoNo %>";
var querySql = "select nvl(max(p.base_plan_id),0) as plan_num from bgp_pm_project_plan p where p.bsflag = '0' and p.project_info_no = '"+ids+"'";
var submitStr =  "currentPage=1&pageSize=10";
submitStr += "&querySql="+querySql;
var path = "<%=contextPath%>"+appConfig.queryListAction;
retObject = syncRequest('Post',path,submitStr);
var basePlanId = "";
if(retObject.datas != null){
	basePlanId = retObject.datas[0].plan_num == "0" ? "":retObject.datas[0].plan_num;
}

function loadData(){
	debugger;
	var retObj = jcdpCallService("ProjectPlanSrv", "getEditProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);
	//var retObj = jcdpCallService("ProjectPlanSrv", "getProjectPlan", "project_info_no="+ids);
	
	if(retObj.map == undefined){
		//bgp_pm_project_plan无数据
		//没有保存计划
		alert("未保存计划");
	} else {
		//bgp_pm_project_plan 有数据
		
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
		document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
		document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
		

		
		document.getElementById("start_date").value = retObj.map.project_design_start_date;
		document.getElementById("end_date").value = retObj.map.project_design_end_date;
		document.getElementById("duration_date").value = retObj.map.project_duration_date;
		

		//显示项目井中工作量
		if("5000100004000000008"==projectType){  
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
				    +'<td class="inquire_form6" id="item1_0"><input type="text" id="design_object_workload" name="design_object_workload" class="input_width"  disabled="disabled" />&nbsp;</td>'
				    +'<td class="inquire_item6" id="design_object_workload_td">设计测线条数：</td>'
				    +'<td class="inquire_form6" id="item1_1"><input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'<td class="inquire_item6">试验炮数：</td>'
				    +'<td class="inquire_form6" id="item1_2"><input type="text" id="full_fold_workload" name="full_fold_workload" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="odd">'
				    +'<td class="inquire_item6">设计检波点数：</td>'
				    +'<td class="inquire_form6" id="item1_3"><input type="text" id="design_geophone_num" name="design_geophone_num" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'<td class="inquire_item6">设计炮数：</td>'
				    +'<td class="inquire_form6" id="item1_4"><input type="text" id="design_sp_num" name="design_sp_num" class="input_width" disabled="disabled" />&nbsp;炮</td>'
				    +'<td class="inquire_item6">小折射设计点数：</td>'
				    +'<td class="inquire_form6" id="item1_5"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="even">'
				    +'<td class="inquire_item6">大折射设计点数：</td>'
				    +'<td class="inquire_form6" id="item1_3"><input type="text" id="design_big_regraction_num" name="design_big_regraction_num" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'<td class="inquire_item6">微测井设计点数：</td>'
				    +'<td class="inquire_form6" id="item1_4"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'<td class="inquire_item6">钻井设计点数：</td>'
				    +'<td class="inquire_form6" id="item1_5"><input type="text" id="design_drill_num" name="design_drill_num" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="odd">'
				    +'<td class="inquire_item6">设计总公里数：</td>'
				    +'<td class="inquire_form6" id="item1_3"><input type="text" id="measure_km" name="measure_km" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'<td class="inquire_item6">压裂监测井段：</td>'
				    +'<td class="inquire_form6" id="item1_4"><input type="text" id="press_well_num" name="press_well_num" class="input_width" disabled="disabled" />&nbsp;</td>'
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
			
		}else if("5000100004000000006"==projectType){	//显示深海项目工作量
			$("#lineTable").html('<tr class="even">'
				    +'<td class="inquire_item6" id="design_line_num_td">设计线束数：</td>'
				    +'<td class="inquire_form6" id="item1_1"><input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;</td>'
				    +'<td class="inquire_item6" id="design_workload_td">设计工作量：</td>'
				    +'<td class="inquire_form6" id="item1_0"><input type="text" id="design_workload" name="design_workload" class="input_width"  disabled="disabled" />&nbsp;</td>'
				    +'<td class="inquire_item6"></td>'
				    +'<td class="inquire_form6" id="item1_2"></td>'
				    +'</tr>'
				    );
			$("#design_line_num").val(retObj.map.design_line_num);//设计测线条数
			$("#design_workload").val(retObj.map.design_object_workload);//设计工作量
			
		}else{
		//其他项目工作量开始
		
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
		
		//page2 组织结构处理
		if("5000100004000000006"==projectType)
		{//显示深海类型项目的组织机构
		/**	
			document.getElementById("org").innerHTML= "";
			$("#org").html('<tr class="even">'
				    +'<td class="inquire_item4" >船队：</td>'
				    +'<td class="inquire_form4"  id="boat_train_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >项目经理：</td>'
				    +'<td class="inquire_form4" id="project_manager_td">&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="odd">'
				    +'<td class="inquire_item4" >船队经理：</td>'
				    +'<td class="inquire_form4"  id="boat_manager_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >船长：</td>'
				    +'<td class="inquire_form4" id="captain_td">&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="even">'
				    +'<td class="inquire_item4" >船队副经理：</td>'
				    +'<td class="inquire_form4"  id="boat_assistant_manager_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >大副：</td>'
				    +'<td class="inquire_form4" id="first_mate_td">&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="odd">'
				    +'<td class="inquire_item4" >岸基经理：</td>'
				    +'<td class="inquire_form4"  id="shore_base_manager_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >二副：</td>'
				    +'<td class="inquire_form4" id="second_mate_td">&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="even">'
				    +'<td class="inquire_item4" >HSE监督：</td>'
				    +'<td class="inquire_form4"  id="hse_supervisor_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >三副：</td>'
				    +'<td class="inquire_form4" id="third_mate_td">&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="odd">'
				    +'<td class="inquire_item4" >导航组长：</td>'
				    +'<td class="inquire_form4"  id="navigation_leader_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >水手长：</td>'
				    +'<td class="inquire_form4" id="boatswain_td">&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="even">'
				    +'<td class="inquire_item4" >仪器组长：</td>'
				    +'<td class="inquire_form4"  id="instrument_leader_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >轮机长：</td>'
				    +'<td class="inquire_form4" id="chief_engineer_td">&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="odd">'
				    +'<td class="inquire_item4" >气爆组长：</td>'
				    +'<td class="inquire_form4"  id="air_blast_leader_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >大管轮：</td>'
				    +'<td class="inquire_form4" id="second_engineer_td">&nbsp;</td>'
				    +'</tr>'
				    +'<tr class="even">'
				    +'<td class="inquire_item4" >地球物理师：</td>'
				    +'<td class="inquire_form4"  id="geophysical_division_td" >&nbsp;</td>'
				    +'<td class="inquire_item4" >队医：</td>'
				    +'<td class="inquire_form4" id="team_doctor_td">&nbsp;</td>'
				    +'</tr>'
				    );

			if( retObj.map.boat_train != null && retObj.map.boat_train != "" )
			{
				document.getElementById("boat_train_td").innerHTML = retObj.map.boat_train ;
			}
			if( retObj.map.project_manager != null && retObj.mapproject_manager != "" )
			{
				document.getElementById("project_manager_td").innerHTML = retObj.map.project_manager ;
			}
			if( retObj.map.boat_manager != null && retObj.map.boat_manager != "" )
			{
				document.getElementById("boat_manager_td").innerHTML = retObj.map.boat_manager ;
			}
			if( retObj.map.captain != null && retObj.map.captain != "" )
			{
				document.getElementById("captain_td").innerHTML = retObj.map.captain ;
			}
			if( retObj.map.boat_assistant_manager != null && retObj.map.boat_assistant_manager != "" )
			{
				document.getElementById("boat_assistant_manager_td").innerHTML = retObj.map.boat_assistant_manager ;
			}
			if( retObj.map.first_mate != null && retObj.map.first_mate != "" )
			{
				document.getElementById("first_mate_td").innerHTML = retObj.map.first_mate ;
			}
			if( retObj.map.shore_base_manager != null && retObj.map.shore_base_manager != "" )
			{
				document.getElementById("shore_base_manager_td").innerHTML = retObj.map.shore_base_manager ;
			}
			if( retObj.map.second_mate != null && retObj.map.second_mate != "" )
			{
				document.getElementById("second_mate_td").innerHTML = retObj.map.second_mate ;
			}
			if( retObj.map.hse_supervisor != null && retObj.map.hse_supervisor != "" )
			{
				document.getElementById("hse_supervisor_td").innerHTML = retObj.map.hse_supervisor ;
			}
			if( retObj.map.third_mate != null && retObj.map.third_mate != "" )
			{
				document.getElementById("third_mate_td").innerHTML = retObj.map.third_mate ;
			}
			if( retObj.map.navigation_leader != null && retObj.map.navigation_leader != "" )
			{
				document.getElementById("navigation_leader_td").innerHTML = retObj.map.navigation_leader ;
			}
			if( retObj.map.boatswain != null && retObj.map.boatswain != "" )
			{
				document.getElementById("boatswain_td").innerHTML = retObj.map.boatswain ;
			}
			if( retObj.map.instrument_leader != null && retObj.map.instrument_leader != "" )
			{
				document.getElementById("instrument_leader_td").innerHTML = retObj.map.instrument_leader ;
			}
			if( retObj.map.chief_engineer != null && retObj.map.chief_engineer != "" )
			{
				document.getElementById("chief_engineer_td").innerHTML = retObj.map.chief_engineer ;
			}
			if( retObj.map.air_blast_leader != null && retObj.map.air_blast_leader != "" )
			{
				document.getElementById("air_blast_leader_td").innerHTML = retObj.map.air_blast_leader ;
			}
			if( retObj.map.second_engineer != null && retObj.map.second_engineer != "" )
			{
				document.getElementById("second_engineer_td").innerHTML = retObj.map.second_engineer ;
			}
			if( retObj.map.geophysical_division != null && retObj.map.geophysical_division != "" )
			{
				document.getElementById("geophysical_division_td").innerHTML = retObj.map.geophysical_division ;
			}
			if( retObj.map.team_doctor != null && retObj.map.team_doctor != "" )
			{
				document.getElementById("team_doctor_td").innerHTML = retObj.map.team_doctor ;
			}
		**/
			document.getElementById("org").innerHTML= "";
		
			var cells = 0;
			var rows = 0;
			var tr;
			
			if(retObj.map.boat_train != null && retObj.map.boat_train != "") {
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
					td.innerHTML = "船队：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.boat_train;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "船队：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.boat_train;
				}
			}
			
			if(retObj.map.project_manager != null && retObj.map.project_manager != "") {
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
					td.innerHTML = "项目经理：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.project_manager;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "项目经理：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.project_manager;
				}
			}
			
			if(retObj.map.boat_manager != null && retObj.map.boat_manager != "") {
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
					td.innerHTML = "船队经理：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.boat_manager;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "船队经理：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.boat_manager;
				}
			}
			
			if(retObj.map.captain != null && retObj.map.captain != "") {
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
					td.innerHTML = "船长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.captain;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "船长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.captain;
				}
			}
			
			if(retObj.map.boat_assistant_manager != null && retObj.map.boat_assistant_managern != "") {
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
					td.innerHTML = "船队副经理 ：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.boat_assistant_manager;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "船队副经理 ：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.boat_assistant_manager;
				}
			}
			
			if(retObj.map.first_mate != null && retObj.map.first_mate != "") {
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
					td.innerHTML = "大副：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.first_mate;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "大副：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.first_mate;
				}
			}
			
			if(retObj.map.shore_base_manager != null && retObj.map.shore_base_manager != "") {
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
					td.innerHTML = "岸基经理：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.shore_base_manager;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "岸基经理：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.shore_base_manager;
				}
			}
			
			if(retObj.map.second_mate != null && retObj.map.second_mate != "") {
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
					td.innerHTML = "二副：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.second_mate;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "二副：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.second_mate;
				}
			}
			
			if(retObj.map.hse_supervisor != null && retObj.map.hse_supervisor != "") {
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
					td.innerHTML = "HSE监督：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.hse_supervisor;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "HSE监督：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.hse_supervisor;
				}
			}
			
			if(retObj.map.third_mate != null && retObj.map.third_mate != "") {
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
					td.innerHTML = "三副：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.third_mate;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "三副：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.third_mate;
				}
			}
			
			if(retObj.map.navigation_leader != null && retObj.map.navigation_leader != "") {
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
					td.innerHTML = "导航组长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.navigation_leader;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "导航组长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.navigation_leader;
				}
			}
			
			if(retObj.map.boatswain != null && retObj.map.boatswain != "") {
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
					td.innerHTML = "水手长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.boatswain;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "水手长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.boatswain;
				}
			}
			
			if(retObj.map.instrument_leader != null && retObj.map.instrument_leader != "") {
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
					td.innerHTML = retObj.map.instrument_leader;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "仪器组长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.instrument_leader;
				}
			}
			
			if(retObj.map.chief_engineer != null && retObj.map.chief_engineer != "") {
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
					td.innerHTML = "轮机长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.chief_engineer;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "轮机长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.chief_engineer;
				}
			}
			
			if(retObj.map.air_blast_leader != null && retObj.map.air_blast_leader != "") {
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
					td.innerHTML = "气爆组长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.air_blast_leader;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "气爆组长：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.air_blast_leader;
				}
			}
			
			if(retObj.map.second_engineer != null && retObj.map.second_engineer != "") {
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
					td.innerHTML = "大管轮：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.second_engineer;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "大管轮：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.second_engineer;
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
			
			if(retObj.map.team_doctor != null && retObj.map.team_doctor != "") {
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
					td.innerHTML = "队医：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.team_doctor;
				} else {
					var td = tr.insertCell();
					td.className = "inquire_item4";
					td.innerHTML = "队医：";
					td = tr.insertCell();
					td.className = "inquire_form4";
					td.innerHTML = retObj.map.team_doctor;
				}
			}
			
			var check_field = new Array(
					"boat_train","project_manager","boat_manager","captain","boat_assistant_manager","first_mate",
					"shore_base_manager","second_mate","hse_supervisor","third_mate","navigation_leader","boatswain",
					"instrument_leader","chief_engineer","air_blast_leader","second_engineer","geophysical_division","team_doctor",
					);
			var isNull = true ;  
			
			for(var i=0; i<check_field.length; i++)
			{
				var temp = check_field[i];
				if( retObj.map[temp]!= null && retObj.map[temp] != "" )
				{
					isNull = false ;
					break;
				}
				else
				{
					isNull = true ;
					continue;
				}
			
			}
			//当组织机构相关的字段全为空时,在增加空白行
			if(isNull)
			{
				$("#org").html('<tr class="even">'
					    +'<td class="inquire_item4">&nbsp;</td>'
					    +'<td class="inquire_form4">&nbsp;</td>'
					    +'<td class="inquire_item4">&nbsp;</td>'
					    +'<td class="inquire_form4">&nbsp;</td>'
					    +'</tr>');
			}
			
		}
		else
		{
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
		}	//处理组织机构结束
		
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
	//parent.document.all("iframe_0").style.height=document.body.scrollHeight; 
	//parent.document.all("iframe_0").style.width=document.body.scrollWidth; 
	

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
<input type="hidden" id="object_id"/>





</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.4 施工方法：</div></td>
</table>

<%--判断是否为井中项目施工方法  --%>
<%
	if("5000100004000000008".equals(projectType)){
		//井中项目 施工方法
 %>
		<iframe width="100%" id="if5"height="100%" frameborder="0" src="<%=contextPath %>/ws/pm/plan/singlePlan/projectSchedule/wellmethod.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="overflow: scroll;"></iframe>
		
<%	}else{ %>
		<iframe width="100%" id="if5" height="100%" frameborder="0" src="<%=contextPath %>/pm/project/singleProject/workmethodshow.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="overflow: scroll;"></iframe>
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
<tr class="odd">
<td class="inquire_form4" >
&nbsp;
</td>
</tr>
</table>
<table>
	<tr>
		<td height="10">&nbsp;</td>
	</tr>
</table>
</body>
</html>