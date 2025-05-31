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
	String notSaveFlag = request.getParameter("notSaveFlag") != null ? request.getParameter("notSaveFlag"):"";
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
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
</head>
<script type="text/javascript" language="javascript">
cruConfig.contextPath =  "<%=contextPath%>";
var notSaveFlag = "<%=notSaveFlag %>";
var basePlanId = "<%=basePlanId %>";
var projectType = "<%=projectType %>";//项目类型
function loadData(){
	debugger;
	
	var ids = "<%=projectInfoNo %>";
	
	var retObj = jcdpCallService("ProjectPlanSrv", "getEditProjectPlan", "project_info_no="+ids+"&base_plan_id="+basePlanId);
	
	if(retObj.map == undefined){
		//需要创建记录
		document.getElementById("message").innerHTML = '<font color="red">该信息尚未保存</font>';
		retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
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
		
		
		document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
		document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
		document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
		document.getElementById("start_date").value = retObj.map.design_start_date;
		document.getElementById("end_date").value = retObj.map.design_end_date;
		document.getElementById("duration_date").value = retObj.map.duration_date;

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
			$("#design_object_workload").val(retObj.dynamicMap.design_object_workload);//设计工作量
			$("#design_line_num").val(retObj.dynamicMap.design_line_num);//设计测线条数
			$("#full_fold_workload").val(retObj.dynamicMap.full_fold_workload);//试验炮数
			$("#design_geophone_num").val(retObj.dynamicMap.design_geophone_num);//设计检波点数
			$("#design_sp_num").val(retObj.dynamicMap.design_sp_num);//设计炮数
			$("#design_small_regraction_num").val(retObj.dynamicMap.design_small_regraction_num);//小折射设计点数
			$("#design_big_regraction_num").val(retObj.dynamicMap.design_big_regraction_num);//大折射设计点数：
			$("#design_micro_measue_num").val(retObj.dynamicMap.design_micro_measue_num);//微测井设计点数
			$("#design_drill_num").val(retObj.dynamicMap.design_drill_num);//钻井设计点数：
			$("#measure_km").val(retObj.dynamicMap.measure_km);//设计总公里数：
			$("#press_well_num").val(retObj.dynamicMap.press_well_num);//压裂监测井段：

			
			
		}else{
		
			if(retObj.map.exploration_method == "0300100012000000002"){
				//二维
				//document.getElementById("workload_td").innerHTML= '二维测线：<font style="text-decoration: underline;">'+retObj.dynamicMap.design_line_num+'</font>条<font style="text-decoration: underline;">'+retObj.dynamicMap.design_object_workload+'</font>km<font style="text-decoration: underline;">'+retObj.dynamicMap.design_sp_num+'</font>炮';
				document.getElementById("design_line_num_td").innerHTML= '设计测线条数：';
				document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;条';
				document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;
				
				document.getElementById("design_object_workload_td").innerHTML= '设计工作量：';
				document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km';
				document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;
				
				//document.getElementById("tr1_9").style.display="none";
				document.getElementById("item1_10_1").style.display="none";
				document.getElementById("item1_10").style.display="none";
				document.getElementById("item1_11").style.display="none";
				document.getElementById("item1_11_1").style.display="none";
				document.getElementById("tr1_10").style.display="none";
			} else {
				//三维
				//document.getElementById("workload_td").innerHTML= '三维偏前满覆盖面积：<font style="text-decoration: underline;">'+retObj.dynamicMap.design_object_workload+'</font>km²<font style="text-decoration: underline;">'+retObj.dynamicMap.design_line_num+'</font>束线<font style="text-decoration: underline;">'+retObj.dynamicMap.design_sp_num+'</font>炮';
				document.getElementById("design_line_num_td").innerHTML= '设计线束数：';
				document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;束';
				document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;
				
				document.getElementById("design_object_workload_td").innerHTML= '设计工作量：';
				document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km²';
				document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;
				
				document.getElementById("design_geophone_area").value= retObj.dynamicMap.design_geophone_area;
				document.getElementById("design_execution_area").value= retObj.dynamicMap.design_execution_area;
				document.getElementById("design_data_area").value= retObj.dynamicMap.design_data_area;
				document.getElementById("design_sp_area").value= retObj.dynamicMap.design_sp_area;
				
				//document.getElementById("tr1_9").style.display="block";
				document.getElementById("item1_10_1").style.display="block";
				document.getElementById("item1_10").style.display="block";
				document.getElementById("item1_11").style.display="block";
				document.getElementById("item1_11_1").style.display="block";
				document.getElementById("tr1_10").style.display="block";
			}
		}
		
		//document.getElementById("weather_delay").value = retObj.map.weather_delay;
	} else {
		//无须创建记录
		document.getElementById("object_id").value = retObj.map.object_id;
		document.getElementById("plan_num_value").value = retObj.map.base_plan_id;
		if(retObj.map.manage_org_name == undefined || retObj.map.project_name == undefined || retObj.map.exploration_method == undefined ||  retObj.map.org_id == undefined || retObj.map.project_name == "" || retObj.map.org_id == "" || retObj.map.manage_org_name == "" || retObj.map.exploration_method == "" ||retObj.map.end_date == undefined || retObj.map.start_date == undefined || retObj.map.start_date == "" || retObj.map.end_date == "" || retObj.map.duration_date == undefined || retObj.map.duration_date == ""){
			//该页面所需的值有缺失 需更新记录
			//document.getElementById("message").innerHTML = '<font color="red">该信息尚未保存</font>';
			retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
			document.getElementById("manage_org_name_td").innerHTML= '本项目来源于：<font style="text-decoration: underline;" >'+retObj.map.manage_org_name+'</font>';
			document.getElementById("project_name_td").innerHTML= '项目名称：<font style="text-decoration: underline;">《'+retObj.map.project_name+'》</font>';
			document.getElementById("project_name").value = retObj.map.project_name;
			document.getElementById("manage_org_name").value = retObj.map.manage_org_name;
			document.getElementById("exploration_method").value = retObj.map.exploration_method;
			document.getElementById("org_id").value = retObj.dynamicMap.org_id;
			document.getElementById("org_subjection_id").value = retObj.dynamicMap.org_subjection_id;
			
			document.getElementById("full_fold_workload").value= retObj.dynamicMap.full_fold_workload;
			document.getElementById("design_geophone_num").value= retObj.dynamicMap.design_geophone_num;
			document.getElementById("design_sp_num").value= retObj.dynamicMap.design_sp_num;
			document.getElementById("design_small_regraction_num").value= retObj.dynamicMap.design_small_regraction_num;
			document.getElementById("design_micro_measue_num").value= retObj.dynamicMap.design_micro_measue_num;
			document.getElementById("design_drill_num").value= retObj.dynamicMap.design_drill_num;
			//document.getElementById("org_name").value= retObj.dynamicMap.org_name;
			document.getElementById("measure_km").value= retObj.dynamicMap.measure_km;
			document.getElementById("design_sp_num_zy").value= retObj.dynamicMap.design_sp_num_zy;
			
			document.getElementById("notes_td").value= retObj.map.notes;
			document.getElementById("notes").value = retObj.map.notes;
			


			document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
			document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
			document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
			document.getElementById("start_date").value = retObj.map.design_start_date;
			document.getElementById("end_date").value = retObj.map.design_end_date;
			document.getElementById("duration_date").value = retObj.map.duration_date;
			
			//retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
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
				$("#design_object_workload").val(retObj.dynamicMap.design_object_workload);//设计工作量
				$("#design_line_num").val(retObj.dynamicMap.design_line_num);//设计测线条数
				$("#full_fold_workload").val(retObj.dynamicMap.full_fold_workload);//试验炮数
				$("#design_geophone_num").val(retObj.dynamicMap.design_geophone_num);//设计检波点数
				$("#design_sp_num").val(retObj.dynamicMap.design_sp_num);//设计炮数
				$("#design_small_regraction_num").val(retObj.dynamicMap.design_small_regraction_num);//小折射设计点数
				$("#design_big_regraction_num").val(retObj.dynamicMap.design_big_regraction_num);//大折射设计点数：
				$("#design_micro_measue_num").val(retObj.dynamicMap.design_micro_measue_num);//微测井设计点数
				$("#design_drill_num").val(retObj.dynamicMap.design_drill_num);//钻井设计点数：
				$("#measure_km").val(retObj.dynamicMap.measure_km);//设计总公里数：
				$("#press_well_num").val(retObj.dynamicMap.press_well_num);//压裂监测井段：

				
				
			}else{
				
				if(retObj.map.exploration_method == "0300100012000000002"){
					//二维
					//document.getElementById("workload_td").innerHTML= '二维测线：<font style="text-decoration: underline;">'+retObj.dynamicMap.design_line_num+'</font>条<font style="text-decoration: underline;">'+retObj.dynamicMap.design_object_workload+'</font>km<font style="text-decoration: underline;">'+retObj.dynamicMap.design_sp_num+'</font>炮';
					document.getElementById("design_line_num_td").innerHTML= '设计测线条数：';
					document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;条';
					document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;
					
					document.getElementById("design_object_workload_td").innerHTML= '设计工作量：';
					document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km';
					document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;
					
					//document.getElementById("tr1_9").style.display="none";
					document.getElementById("item1_10_1").style.display="none";
					document.getElementById("item1_10").style.display="none";
					document.getElementById("item1_11").style.display="none";
					document.getElementById("item1_11_1").style.display="none";
					document.getElementById("tr1_10").style.display="none";
				} else {
					//三维
					//document.getElementById("workload_td").innerHTML= '三维偏前满覆盖面积：<font style="text-decoration: underline;">'+retObj.dynamicMap.design_object_workload+'</font>km²<font style="text-decoration: underline;">'+retObj.dynamicMap.design_line_num+'</font>束线<font style="text-decoration: underline;">'+retObj.dynamicMap.design_sp_num+'</font>炮';
					document.getElementById("design_line_num_td").innerHTML= '设计线束数：';
					document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;束';
					document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;
					
					document.getElementById("design_object_workload_td").innerHTML= '设计工作量：';
					document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km²';
					document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;
					
					document.getElementById("design_geophone_area").value= retObj.dynamicMap.design_geophone_area;
					document.getElementById("design_execution_area").value= retObj.dynamicMap.design_execution_area;
					document.getElementById("design_data_area").value= retObj.dynamicMap.design_data_area;
					document.getElementById("design_sp_area").value= retObj.dynamicMap.design_sp_area;
					
					//document.getElementById("tr1_9").style.display="block";
					document.getElementById("item1_10_1").style.display="block";
					document.getElementById("item1_10").style.display="block";
					document.getElementById("item1_11").style.display="block";
					document.getElementById("item1_11_1").style.display="block";
					document.getElementById("tr1_10").style.display="block";
				}
			}
			
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
			
			document.getElementById("start_date_td").innerHTML= '开工时间：'+retObj.map.project_design_start_date;
			document.getElementById("end_date_td").innerHTML= '收工时间：'+retObj.map.project_design_end_date;
			document.getElementById("duration_date_td").innerHTML= '自然天数：'+retObj.map.project_duration_date+'天';
			document.getElementById("start_date").value = retObj.map.design_start_date;
			document.getElementById("end_date").value = retObj.map.design_end_date;
			document.getElementById("duration_date").value = retObj.map.duration_date;
			
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
				//显示数据库中保存的值
				if(retObj.map.exploration_method == "0300100012000000002"){
					//二维
					//document.getElementById("workload_td").innerHTML= '二维测线：<font style="text-decoration: underline;">'+retObj.map.design_line_num+'</font>条<font style="text-decoration: underline;">'+retObj.map.design_object_workload+'</font>km<font style="text-decoration: underline;">'+retObj.map.design_sp_num+'</font>炮';
					document.getElementById("design_line_num_td").innerHTML= '设计测线条数：';
					document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;条';
					document.getElementById("design_line_num").value= retObj.map.design_line_num;
					
					document.getElementById("design_object_workload_td").innerHTML= '设计工作量：';
					document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km';
					document.getElementById("design_object_workload").value= retObj.map.design_object_workload;
					
					//document.getElementById("tr1_9").style.display="none";
					document.getElementById("item1_10_1").style.display="none";
					document.getElementById("item1_10").style.display="none";
					document.getElementById("item1_11").style.display="none";
					document.getElementById("item1_11_1").style.display="none";
					document.getElementById("tr1_10").style.display="none";
				} else {
					//三维
					//document.getElementById("workload_td").innerHTML= '三维偏前满覆盖面积：<font style="text-decoration: underline;">'+retObj.map.design_object_workload+'</font>km²<font style="text-decoration: underline;">'+retObj.map.design_line_num+'</font>束线<font style="text-decoration: underline;">'+retObj.map.design_sp_num+'</font>炮';
					document.getElementById("design_line_num_td").innerHTML= '设计线束数：';
					document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" disabled="disabled" />&nbsp;束';
					document.getElementById("design_line_num").value= retObj.map.design_line_num;
					
					document.getElementById("design_object_workload_td").innerHTML= '设计工作量：';
					document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km²';
					document.getElementById("design_object_workload").value= retObj.map.design_object_workload;
					
					document.getElementById("design_geophone_area").value= retObj.map.design_geophone_area;
					document.getElementById("design_execution_area").value= retObj.map.design_execution_area;
					document.getElementById("design_data_area").value= retObj.map.design_data_area;
					document.getElementById("design_sp_area").value= retObj.map.design_sp_area;
					
					//document.getElementById("tr1_9").style.display="block";
					document.getElementById("item1_10_1").style.display="block";
					document.getElementById("item1_10").style.display="block";
					document.getElementById("item1_11").style.display="block";
					document.getElementById("item1_11_1").style.display="block";
					document.getElementById("tr1_10").style.display="block";
					
				}
			}
			
			//document.getElementById("weather_delay").value = retObj.map.weather_delay;
			
		}
	}
	//如果是大港物探处的项目，工作量部署一致不区分陆地和浅海
	var org_subjection_id ='<%=org_subjection_id%>';
	if(org_subjection_id!=null && org_subjection_id.indexOf("C105007")!=-1){
		document.getElementById("lineTable").style.display = 'none';
		document.getElementById("if6").style.display = 'block';
	}else{
		document.getElementById("lineTable").style.display = 'block';
		document.getElementById("if6").style.display = 'none';
	}
	
	//$("#lineTable input[type=text]").attr("disabled",false);
	parent.document.all("if1").style.height=document.body.scrollHeight; 
	parent.document.all("if1").style.width=document.body.scrollWidth-1; 
	
}

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
	str += "&plan_num_value="+document.getElementById("plan_num_value").value;
	//str += "&design_line_num="+document.getElementById("design_line_num").value;
	//str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	//str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	//str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	//str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	//str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	//str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	//str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	


	//非井中工作量
	if("5000100004000000008"!=projectType){
		str += "&design_data_area="+document.getElementById("design_data_area").value;
		str += "&design_sp_area="+document.getElementById("design_sp_area").value;
		str += "&design_geophone_area="+document.getElementById("design_geophone_area").value;
		str += "&design_sp_num_zy="+document.getElementById("design_sp_num_zy").value;
		str += "&design_execution_area="+document.getElementById("design_execution_area").value;
	}else{
		str += "&press_well_num"+document.getElementById("press_well_num").value;//压裂监测井段：
	}

	//$("#design_object_workload").val(retObj.map.design_object_workload);//设计工作量
	str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	//$("#design_line_num").val(retObj.map.design_line_num);//设计测线条数
	str += "&design_line_num="+document.getElementById("design_line_num").value;
	//$("#full_fold_workload").val(retObj.map.full_fold_workload);//试验炮数
	str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	//$("#design_geophone_num").val(retObj.map.design_geophone_num);//设计检波点数
	str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	//$("#design_sp_num").val(retObj.map.design_sp_num);//设计炮数
	str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	//$("#design_small_regraction_num").val(retObj.map.design_small_regraction_num);//小折射设计点数
	str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	str += "&design_big_regraction_num="+$("#design_big_regraction_num").val();//大折射设计点数：
	//$("#design_micro_measue_num").val(retObj.map.design_micro_measue_num);//微测井设计点数
	str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	//$("#design_drill_num").val(retObj.map.design_drill_num);//钻井设计点数：
	str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	//$("#measure_km").val(retObj.map.measure_km);//设计总公里数：
	str += "&measure_km="+document.getElementById("measure_km").value;

	return str;
}

function save(){
	var orgInfoStr = "";
	var projectPlanStr = "";
	var ctt = this.parent.frames;
	if(ctt.length != 0){
		orgInfoStr = ctt.frames["if2"].getOrgInfoStr();
		projectPlanStr = ctt.frames["if3"].getProjectPlanStr();
	}
	
	var str="project_info_no=<%=projectInfoNo %>";
	str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
	str += "&manage_org_name="+encodeURI(encodeURI(document.getElementById("manage_org_name").value));
	str += "&exploration_method="+document.getElementById("exploration_method").value;
	str += "&org_id="+document.getElementById("org_id").value;
	str += "&org_subjection_id="+document.getElementById("org_subjection_id").value;
	str += "&start_date="+document.getElementById("start_date").value;
	str += "&end_date="+document.getElementById("end_date").value;
	str += "&duration_date="+document.getElementById("duration_date").value;
	str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
	str += "&plan_num_value="+document.getElementById("plan_num_value").value;
	//str += "&design_line_num="+document.getElementById("design_line_num").value;
	//str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	//str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	//str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	//str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	//str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	//str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	//str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	str += "&design_execution_area="+document.getElementById("design_execution_area").value;
	str += "&design_data_area="+document.getElementById("design_data_area").value;
	str += "&design_sp_area="+document.getElementById("design_sp_area").value;
	str += "&design_geophone_area="+document.getElementById("design_geophone_area").value;
	//str += "&measure_km="+document.getElementById("measure_km").value;
	str += "&design_sp_num_zy="+document.getElementById("design_sp_num_zy").value;
	str += "&object_id="+document.getElementById("object_id").value;
	str += orgInfoStr;
	str += projectPlanStr;
	
	//$("#design_object_workload").val(retObj.map.design_object_workload);//设计工作量
	str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	//$("#design_line_num").val(retObj.map.design_line_num);//设计测线条数
	str += "&design_line_num="+document.getElementById("design_line_num").value;
	//$("#full_fold_workload").val(retObj.map.full_fold_workload);//试验炮数
	str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	//$("#design_geophone_num").val(retObj.map.design_geophone_num);//设计检波点数
	str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	//$("#design_sp_num").val(retObj.map.design_sp_num);//设计炮数
	str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	//$("#design_small_regraction_num").val(retObj.map.design_small_regraction_num);//小折射设计点数
	str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	str += "&design_big_regraction_num="+$("#design_big_regraction_num").val();//大折射设计点数：
	//$("#design_micro_measue_num").val(retObj.map.design_micro_measue_num);//微测井设计点数
	str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	//$("#design_drill_num").val(retObj.map.design_drill_num);//钻井设计点数：
	str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	//$("#measure_km").val(retObj.map.measure_km);//设计总公里数：
	str += "&measure_km="+document.getElementById("measure_km").value;
	str += "&press_well_num"+document.getElementById("press_well_num").value;//压裂监测井段：



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
	press_well_num//压裂监测井段--%>
	
	
	if(basePlanId != "" && basePlanId != undefined){
		var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
		if(retObj != null && retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		loadData();
	}else{
		var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectPlan", str);
		if(retObj != null && retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		loadData();
	}
	
}

function saveBaseInfo(){
	var str="project_info_no=<%=projectInfoNo %>";
	str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
	str += "&manage_org_name="+encodeURI(encodeURI(document.getElementById("manage_org_name").value));
	str += "&exploration_method="+document.getElementById("exploration_method").value;
	str += "&org_id="+document.getElementById("org_id").value;
	str += "&org_subjection_id="+document.getElementById("org_subjection_id").value;
	str += "&start_date="+document.getElementById("start_date").value;
	str += "&end_date="+document.getElementById("end_date").value;
	str += "&duration_date="+document.getElementById("duration_date").value;
	str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
	str += "&plan_num_value="+document.getElementById("plan_num_value").value;
	//str += "&design_line_num="+document.getElementById("design_line_num").value;
	//str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	//str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	//str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	//str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	//str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	//str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	//str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	str += "&design_execution_area="+document.getElementById("design_execution_area").value;
	str += "&design_data_area="+document.getElementById("design_data_area").value;
	str += "&design_sp_area="+document.getElementById("design_sp_area").value;
	str += "&design_geophone_area="+document.getElementById("design_geophone_area").value;
	//str += "&measure_km="+document.getElementById("measure_km").value;
	str += "&design_sp_num_zy="+document.getElementById("design_sp_num_zy").value;

	//$("#design_object_workload").val(retObj.map.design_object_workload);//设计工作量
	str += "&design_object_workload="+document.getElementById("design_object_workload").value;
	//$("#design_line_num").val(retObj.map.design_line_num);//设计测线条数
	str += "&design_line_num="+document.getElementById("design_line_num").value;
	//$("#full_fold_workload").val(retObj.map.full_fold_workload);//试验炮数
	str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
	//$("#design_geophone_num").val(retObj.map.design_geophone_num);//设计检波点数
	str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
	//$("#design_sp_num").val(retObj.map.design_sp_num);//设计炮数
	str += "&design_sp_num="+document.getElementById("design_sp_num").value;
	//$("#design_small_regraction_num").val(retObj.map.design_small_regraction_num);//小折射设计点数
	str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
	str += "&design_big_regraction_num="+$("#design_big_regraction_num").val();//大折射设计点数：
	//$("#design_micro_measue_num").val(retObj.map.design_micro_measue_num);//微测井设计点数
	str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
	//$("#design_drill_num").val(retObj.map.design_drill_num);//钻井设计点数：
	str += "&design_drill_num="+document.getElementById("design_drill_num").value;
	//$("#measure_km").val(retObj.map.measure_km);//设计总公里数：
	str += "&measure_km="+document.getElementById("measure_km").value;
	str += "&press_well_num"+document.getElementById("press_well_num").value;//压裂监测井段：
	
	var retObj = jcdpCallService("ProjectPlanSrv", "saveProjectBackUpPlan", str);
	if(retObj != null && retObj.message == "success") {
		
	} else {
		alert("修改基本信息失败");
		return;
	}
}

</script>
<body onload="loadData()" style="overflow:hidden;">
<div id="addChangePlan" align="left">&nbsp;&nbsp;<b>修改项目初始计划</b></div>
<div id="message" align="center"><font color="red"></font></div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr>
		<td><div class="tongyong_box_title">1.1 项目来源：</div></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">
<input type="hidden" id="project_name"/>
<input type="hidden" id="manage_org_name"/>
<input type="hidden" id="plan_num_value"/>
<input type="hidden" id="exploration_method"/>
<input type="hidden" id="org_id"/>
<input type="hidden" id="org_subjection_id"/>
<input type="hidden" id="object_id"/>
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
  <input type="hidden" id="notes"/>	
	<td colspan="3" class="inquire_form4"><textarea id="notes_td"  name="notes_td"cols="45" rows="5" class="textarea" readonly="readonly"></textarea></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.3 工作量部署：</div></td>
</table>
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height" id="lineTable" style="overflow: scroll;">
<tr class="even">
    <td class="inquire_item6" id="design_line_num_td">设计测线条数：</td>
    <td class="inquire_form6" id="item1_0"><input type="text" id="design_line_num" name="design_line_num" class="input_width"  disabled="disabled" />&nbsp;条</td>
    <td class="inquire_item6" id="design_object_workload_td">设计工作量：</td>
    <td class="inquire_form6" id="item1_1"><input type="text" id="design_object_workload" name="design_object_workload" class="input_width" disabled="disabled" />&nbsp;km</td>
    <td class="inquire_item6">设计试验炮：</td>
    <td class="inquire_form6" id="item1_2"><input type="text" id="full_fold_workload" name="full_fold_workload" class="input_width" disabled="disabled" />&nbsp;炮</td>
  </tr>
  <tr class="odd">
    <td class="inquire_item6">设计检波点数：</td>
    <td class="inquire_form6" id="item1_3"><input type="text" id="design_geophone_num" name="design_geophone_num" class="input_width" disabled="disabled" />&nbsp;个</td>
    <td class="inquire_item6">设计炮数：</td>
    <td class="inquire_form6" id="item1_4"><input type="text" id="design_sp_num" name="design_sp_num" class="input_width" disabled="disabled" />&nbsp;炮</td>
    <td class="inquire_item6">设计震源炮数：</td>
    <td class="inquire_form6" id="item1_5"><input type="text" id="design_sp_num_zy" name="design_sp_num_zy" class="input_width" disabled="disabled" />&nbsp;炮</td>
   </tr>
   <tr class="even">
    <td class="inquire_item6">小折射设计点数：</td>
    <td class="inquire_form6" id="item1_6"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" disabled="disabled" />&nbsp;个</td>
    <td class="inquire_item6">微测井设计点数：</td>
    <td class="inquire_form6" id="item1_7"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" disabled="disabled" />&nbsp;个</td>
    <td class="inquire_item6">钻井设计点数：</td>
    <td class="inquire_form6" id="item1_8"><input type="text" id="design_drill_num" name="design_drill_num" class="input_width" disabled="disabled" />&nbsp;个</td>
   </tr>
   <tr id="tr1_9" class="odd">
    <td class="inquire_item6">测量总公里数：</td>
    <td class="inquire_form6" id="item1_9"><input type="text" id="measure_km" name="measure_km" class="input_width" disabled="disabled" />&nbsp;km</td>
    <td class="inquire_item6"  style="display: none;" id="item1_10_1">设计检波点面积：</td>
    <td class="inquire_form6" id="item1_10" style="display: none;"><input type="text" id="design_geophone_area" name="design_geophone_area" class="input_width" disabled="disabled" />&nbsp;km²</td>
   	<td class="inquire_item6" style="display: none;" id="item1_11_1">设计有资料面积：</td>
    <td class="inquire_form6" id="item1_11" style="display: none;"><input type="text" id="design_data_area" name="design_data_area" class="input_width" disabled="disabled" />&nbsp;km²</td>
   </tr>
   <tr style="display: none;" id="tr1_10" class="even">
    <td class="inquire_item6">设计激发点面积：</td>
    <td class="inquire_form6" id="item1_12"><input type="text" id="design_sp_area" name="design_sp_area" class="input_width" disabled="disabled" />&nbsp;km²</td>
    <td class="inquire_item6" >设计施工面积：</td>
    <td class="inquire_form6" id="item1_133"><input type="text" id="design_execution_area" name="design_execution_area" class="input_width" disabled="disabled" />&nbsp;km²</td>
   	<td class="inquire_item6" colspan="4">&nbsp;</td>
   </tr>
</table>
<!-- 大港物探处的工作量部署-->
<iframe width="100%" id="if6" height="100%" frameborder="0" src="<%=contextPath %>/pm/plan/planchangelist/workload.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="display: none;" ></iframe>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.4 施工方法：</div></td>
</table>
<iframe width="100%" id="if5" height="100%;" frameborder="0" src="<%=contextPath %>/pm/project/singleProject/workmethod.jsp?projectInfoNo=<%=projectInfoNo %>&action=view"  style="overflow: scroll;" ></iframe>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<td><div class="tongyong_box_title">1.5 工期要求：</div></td>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">
<input type="hidden" id="start_date"/>
<input type="hidden" id="end_date"/>
<input type="hidden" id="duration_date"/>
<td class="inquire_form4"  id="start_date_td"></td>
</tr>
<tr class="odd">
<td class="inquire_form4" id="end_date_td"></td>
</tr>
<tr class="even">
<td class="inquire_form4" id="duration_date_td"></td>
</tr>
</table>
<!-- 
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	<tr class="tongyong_box_title">
		<td class="inquire_item8">1.6 自然因素影响时间：</td>
		<td colspan="7">&nbsp;</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr class="even">
<td class="inquire_form4" >
<input type="text" id="weather_delay"/>天
</td>
</tr>
</table>
 -->
<div id="oper_div">

</div>
<table>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
</table>
<script type="text/javascript" language="javascript">
if(basePlanId != ""){
	$("#addChangePlan").html("&nbsp;&nbsp;<b>修改项目变更计划"+basePlanId+"</b>");
}

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

</script>
</body>
</html>