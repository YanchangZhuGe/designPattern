<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
	String project_info_no = request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff;height: 120px;" >
<div id="tab_box" class="tab_box">
	<div id="tab_box_content1" class="tab_box_content" >
		<div id="workLoad3">
         	<input type="hidden" id="work_load3" name="work_load3" value="" />
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
			    <td class="inquire_item6"><input type="radio" name="area" id="area1" value="1" onclick="work_load('area')" checked="checked" />设计施工面积：</td>
			    <td class="inquire_form6"><input type="text" id="design_execution_area" name="design_execution_area" class="input_width" />&nbsp;km²</td>
			    <td class="inquire_item6"><input type="radio" name="area" id="area2" value="2" onclick="work_load('area')"/>设计有资料面积：</td>
			    <td class="inquire_form6"><input type="text" id="design_data_area" name="design_data_area" class="input_width" />&nbsp;km²</td>
			    <td class="inquire_item6"><input type="radio" name="area" id="area3" value="3" onclick="work_load('area')"/>设计满覆盖面积：</td> <!-- id="td3_9_item" id="td3_9_form"-->
			    <td class="inquire_form6"><input type="text" id="design_object_area" name="design_object_area" class="input_width" />&nbsp;km²</td>
			  </tr>
			  <tr>
			  	<td class="inquire_item6">设计测量总公里数：</td>
			    <td class="inquire_form6"><input type="text" id="measure_km" name="measure_km" class="input_width" />&nbsp;km</td>
			    <td class="inquire_item6">设计检波点个数：</td>
			    <td class="inquire_form6"><input type="text" id="design_geophone_num" name="design_geophone_num" class="input_width" />&nbsp;个</td>
			    <td class="inquire_item6">设计总炮数：</td>
			    <td class="inquire_form6"><input type="text" id="design_sp_num" name="design_sp_num" class="input_width" />&nbsp;炮</td>
			  </tr>
			  <tr>
			    <td class="inquire_item6">设计试验炮：</td>
			    <td class="inquire_form6"><input type="text" id="full_fold_workload" name="full_fold_workload" class="input_width" />&nbsp;炮</td>
			    <td class="inquire_item6">设计线束数：</td>
			    <td class="inquire_form6"><input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;束</td>
			    <td class="inquire_item6" id="td3_8_item"></td>
			    <td class="inquire_form6" id="td3_8_form"><!-- <input type="text" id="design_dw_num" name="design_dw_num" class="input_width" />&nbsp;炮 --></td>
			  </tr>
			  <tr id="tr3_1">
			    <td class="inquire_item6" id="td3_10_item">设计气枪：</td>
			    <td class="inquire_form6" id="td3_10_form"><input type="text" id="design_qq_num" name="design_qq_num" class="input_width" />&nbsp;炮</td>
			    <td class="inquire_item6" id="td3_11_item">设计井炮：</td>
			    <td class="inquire_form6" id="td3_11_form"><input type="text" id="design_drilling_num" name="design_drilling_num" class="input_width" />&nbsp;炮</td>
			    <td class="inquire_item6" id="td3_12_item">设计震源：</td>
			    <td class="inquire_form6" id="td3_12_form"><input type="text" id="design_sp_num_zy" name="design_sp_num_zy" class="input_width" />&nbsp;炮</td>
			  </tr>
			  <tr id="tr3_2">
			    <td class="inquire_item6">设计小折射点数：</td>
			    <td class="inquire_form6"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" />&nbsp;个</td>
			    <td class="inquire_item6">设计微测井点数：</td>
			    <td class="inquire_form6"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" />&nbsp;个</td>
			  </tr>
			</table>
	    </div>
	    <div id="workLoad2">
			<input type="hidden" id="work_load2" name="work_load2" value="" />
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
			    <td class="inquire_item6"><input type="radio" name="lgth" id="length1" value="1" onclick="work_load('lgth')" checked="checked"/>设计实物工作量：</td>
			    <td class="inquire_form6"><input type="text" id="design_physical_workload" name="design_physical_workload" class="input_width" />&nbsp;km</td>
			    <td class="inquire_item6"><input type="radio" name="lgth" id="length2" value="2" onclick="work_load('lgth')"/>设计有资料工作量：</td>
			    <td class="inquire_form6"><input type="text" id="design_data_workload" name="design_data_workload" class="input_width" />&nbsp;km</td>
			    <td class="inquire_item6"><input type="radio" name="lgth" id="length3" value="3" onclick="work_load('lgth')"/>设计满覆盖工作量：</td>
			 	<td class="inquire_form6"><input type="text" id="design_object_workload" name="design_object_workload" class="input_width" />&nbsp;km</td>
			  </tr>
			  <tr>
			    <td class="inquire_item6">设计测量总公里数：</td>
			    <td class="inquire_form6"><input type="text" id="measure_km2" name="measure_km2" class="input_width" />&nbsp;km</td>
			    <td class="inquire_item6">设计检波点个数：</td>
			    <td class="inquire_form6"><input type="text" id="design_geophone_num2" name="design_geophone_num2" class="input_width" />&nbsp;个</td>
			    <td class="inquire_item6">设计总炮数：</td>
			    <td class="inquire_form6"><input type="text" id="design_sp_num2" name="design_sp_num2" class="input_width" />&nbsp;炮</td>
			  </tr>
			  <tr>
			    <td class="inquire_item6">设计试验炮：</td>
			    <td class="inquire_form6"><input type="text" id="full_fold_workload2" name="full_fold_workload2" class="input_width" />&nbsp;炮</td>
			    <td class="inquire_item6">设计测线：</td>
			    <td class="inquire_form6"><input type="text" id="other_line_num" name="other_line_num" class="input_width" />&nbsp;条</td>
			    <td class="inquire_item6" id="td2_8_item">设计定位炮：</td>
			    <td class="inquire_form6" id="td2_8_form"><input type="text" id="design_dw_num2" name="design_dw_num2" class="input_width" />&nbsp;炮</td>
			  </tr>
			  <tr id="tr3_3">
			    <td class="inquire_item6" id="td2_9_item">设计气枪：</td>
			    <td class="inquire_form6" id="td2_9_form"><input type="text" id="design_qq_num" name="design_qq_num" class="input_width" />&nbsp;炮</td>
			    <td class="inquire_item6" id="td2_10_item">设计震源：</td>
			    <td class="inquire_form6" id="td2_10_form"><input type="text" id="design_sp_num_zy" name="design_sp_num_zy" class="input_width" />&nbsp;炮</td>
			    <td class="inquire_item6" id="td2_11_item">设计井炮：</td>
			    <td class="inquire_form6" id="td2_11_form"><input type="text" id="design_drilling_num" name="design_drilling_num" class="input_width" />&nbsp;炮</td>
			  </tr>
			  <tr id="tr3_4">
			  	<td class="inquire_item6" id="td2_12_item">设计小折射点数：</td>
			    <td class="inquire_form6" id="td2_12_form"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" />&nbsp;个</td>
			    <td class="inquire_item6" id="td2_13_item">设计微测井点数：</td>
			    <td class="inquire_form6" id="td2_13_form"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" />&nbsp;个</td>
			  </tr>
			</table>
		</div>
	</div>
</div>

</body>
<script type="text/javascript">
function frameSize(){
	$("#tab_box").css("height",$(window).height());
}

frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script>

<script type="text/javascript">
	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var exploration_method = "0300100012000000002";
	refreshData();
	function refreshData(){
		var ids = '<%=project_info_no%>';
		var retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
		exploration_method = retObj.map.exploration_method;
		//加载激发方式
		//this.changeExploration(retObj.map.exploration_method);
		//-----------------------------工作量-----------------------------------------
		$("#design_line_num").val(retObj.dynamicMap.design_line_num);
		$("#design_execution_area").val(retObj.dynamicMap.design_execution_area);
		$("#design_data_area").val(retObj.dynamicMap.design_data_area);
		$("#design_object_area").val(retObj.dynamicMap.design_object_area);
		$("#measure_km").val(retObj.dynamicMap.measure_km);
		$("#design_geophone_num").val(retObj.dynamicMap.design_geophone_num);
		$("#design_sp_num").val(retObj.dynamicMap.design_sp_num);
		$("#design_qq_num").val(retObj.dynamicMap.design_qq_num);
		$("#design_drilling_num").val(retObj.dynamicMap.design_drilling_num);
		$("#design_sp_num_zy").val(retObj.dynamicMap.design_sp_num_zy);
		$("#full_fold_workload").val(retObj.dynamicMap.full_fold_workload);
	//	$("#design_dw_num").val(retObj.dynamicMap.design_dw_num);
		$("#design_small_regraction_num").val(retObj.dynamicMap.design_small_regraction_num);
		$("#design_micro_measue_num").val(retObj.dynamicMap.design_micro_measue_num);
		$("#design_data_workload").val(retObj.dynamicMap.design_data_workload);//设计有资料长度
		
		$("#other_line_num").val(retObj.dynamicMap.other_line_num);
		$("#design_physical_workload").val(retObj.dynamicMap.design_physical_workload);
		$("#design_object_workload").val(retObj.dynamicMap.design_object_workload);
		$("#measure_km2").val(retObj.dynamicMap.measure_km2);
		$("#design_geophone_num2").val(retObj.dynamicMap.design_geophone_num2);
		$("#design_sp_num2").val(retObj.dynamicMap.design_sp_num2);
		$("#full_fold_workload2").val(retObj.dynamicMap.full_fold_workload2);
		$("#design_dw_num2").val(retObj.dynamicMap.design_dw_num2);
		
		$("#workLoad2").css("display","block");
		$("#workLoad3").css("display","block");
		$("#workLoad2 input[type=text]").removeAttr("disabled");
		$("#workLoad3 input[type=text]").removeAttr("disabled");
		$("#[id^=tr3_]").attr("style","display:block");
		$("#[id^=td3_]").attr("style","display:block");
		$("#[id^=td2_]").attr("style","display:block");
		if("0300100012000000003"==retObj.map.exploration_method){//三维
			$("#workLoad3 input[id=design_qq_num]").val(retObj.dynamicMap.design_qq_num);//设计气枪
			$("#workLoad3 input[id=design_drilling_num]").val(retObj.dynamicMap.design_drilling_num);//设计井炮
			$("#workLoad3 input[id=design_sp_num_zy]").val(retObj.dynamicMap.design_sp_num_zy);//设计震源
			$("#workLoad3 input[id=design_small_regraction_num]").val(retObj.dynamicMap.design_small_regraction_num);//小折射点数赋值
			$("#workLoad3 input[id=design_micro_measue_num]").val(retObj.dynamicMap.design_micro_measue_num);//微测井点数赋值
			$("#workLoad2").attr("style","display:none");
			$("#workLoad2 input[type=text]").attr("disabled","disabled");
			if("5000100003000000003"==retObj.map.build_method){//气枪
				$("#tr3_1").attr("style","display:none");
				$("#tr3_2").attr("style","display:none");
			}
			if("5000100003000000001"==retObj.map.build_method){//井炮
				$("#[id^=td3_8_]").attr("style","display:none");
				$("#tr3_1").attr("style","display:none");
			}
			if("5000100003000000004"==retObj.map.build_method){//井炮/震源
				$("#[id^=td3_8_]").attr("style","display:none");
				$("#[id^=td3_10_]").attr("style","display:none");
			}
			if("5000100003000000005"==retObj.map.build_method){//气枪/井炮
				$("#[id^=td3_12_]").attr("style","display:none");
				$("#tr3_2").attr("style","display:none");
			}
			var index = retObj.dynamicMap.work_load3==null || retObj.dynamicMap.work_load3==''?'1':retObj.dynamicMap.work_load3;
			document.getElementById("area"+index).checked = 'checked';
		}
		if("0300100012000000002"==retObj.map.exploration_method){//二维
			
			$("#workLoad2 input[id=design_qq_num]").val(retObj.dynamicMap.design_qq_num);//设计气枪
			$("#workLoad2 input[id=design_drilling_num]").val(retObj.dynamicMap.design_drilling_num);//设计井炮
			$("#workLoad2 input[id=design_sp_num_zy]").val(retObj.dynamicMap.design_sp_num_zy);//设计震源
			$("#workLoad2 input[id=design_small_regraction_num]").val(retObj.dynamicMap.design_small_regraction_num);//小折射点数赋值
			$("#workLoad2 input[id=design_micro_measue_num]").val(retObj.dynamicMap.design_micro_measue_num);//微测井点数赋值
			$("#workLoad3").css("display","none");
			$("#workLoad3 input[type=text]").attr("disabled","disabled");
			if("5000100003000000003"==retObj.map.build_method){//气枪
				$("#tr3_3").attr("style","display:none");
				$("#tr3_4").attr("style","display:none");
			}
			if("5000100003000000001"==retObj.map.build_method){//井炮
				$("#[id^=td2_8_]").attr("style","display:none");
				$("#[id^=tr3_3]").attr("style","display:none");
			}
			if("5000100003000000004"==retObj.map.build_method){//井炮/震源
				$("#[id^=td2_8_]").attr("style","display:none");
				$("#[id^=td2_9_]").attr("style","display:none");
			}
			if("5000100003000000005"==retObj.map.build_method){//气枪/井炮
				$("#[id^=td2_10_]").attr("style","display:none");
			}
			var index = retObj.dynamicMap.work_load2==null || retObj.dynamicMap.work_load2==''?'1':retObj.dynamicMap.work_load2;
			document.getElementById("length"+index).checked = 'checked';
		}
		if("0300100012000000029"==retObj.map.exploration_method){//二维+三维
			if("5000100003000000001"==retObj.map.build_method){//井炮
				$("#[id^=tr3_1]").attr("style","display:none");
				$("#[id^=tr3_3]").attr("style","display:none");
				$("#[id^=tr3_4]").attr("style","display:none");
				$("#[id^=td3_8_]").attr("style","display:none");
				$("#[id^=td2_8_]").attr("style","display:none");
				$("#tr3_4 input[type=text]").attr("disabled","disabled");
			}else{
				$("#[id^=tr3_]").attr("style","display:none");
			}
		}
	}
	function getExplorationMethod(){
		return exploration_method ;
	}
	
	
	function work_load(type){
		var types = document.getElementsByName(type);
		debugger;
		for(var i =0 ;i< types.length ;i++){
			if(types[i].checked == true){
				var value = types[i].value;
				if(type=='area'){
					document.getElementById("work_load3").value = value;
				}else if(type=='lgth'){
					document.getElementById("work_load2").value = value;
				}
			}
		}
	}
</script>

</html>

