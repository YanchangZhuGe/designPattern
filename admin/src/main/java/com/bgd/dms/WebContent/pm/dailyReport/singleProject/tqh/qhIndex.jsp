<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.*" contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib uri="code" prefix="code"%> 
<%
    String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = request.getParameter("projectName");
	String orgName = request.getParameter("orgName");
	UserToken user = OMSMVCUtil.getUserToken(request);
	if(projectInfoNo == null || "".equals(projectInfoNo)){
	
		projectInfoNo = user.getProjectInfoNo();
		projectName = user.getProjectName();
		orgName = user.getOrgName();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup-new.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<style type="text/css">
 .myButton {
	BORDER: #deddde 1px solid;
	font-size: 12px;
	background:#2C83C1;
	CURSOR:  hand;
	COLOR: #FFFFFF;
	padding-top: 2px;
	padding-left: 2px;
	padding-right: 2px;
	height:22px;
}
</style>
</head>

<script type="text/javascript">
	function g(o){
		return document.getElementById(o);
	}

	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	var exploration_method="";
	
	var flag = "";
	var edit_flag = "no";
	
	function validate(){
		var produce_date = document.getElementById("produce_date").value;
		var project_info_no = document.getElementById("project_info_no").value;
		
		var retObj = jcdpCallService("DailyReportSrv", "getDailyReportDate", "projectInfoNo=<%=projectInfoNo %>&produceDate="+produce_date);
		
		if(retObj == null || retObj.dailyMap == null || retObj.dailyMap.dailyNo == null){
			//日报未录入
			cleanTheBlank();
			g('edit_button').style.display="none";
			g('zj_button').style.display="inline";
			g('message').innerHTML="日报没有录入！";
			g('flag').value = "notSaved";
		} else if(retObj.dailyMap.auditStatus=="0"){
			fillTheBlank(retObj.dailyMap);
			disableTheBlank();
			g('message').innerHTML="日报已经录入但未提交，请点确定继续反馈工作量或者返回！";
			g('edit_button').style.display="inline";
			g('edit_button').removeAttribute("disabled");
			g('zj_button').style.display="inline";
			g('flag').value = "notSubmited";
		} else if(retObj.dailyMap.auditStatus=="1"){
			//日报已经提交
			fillTheBlank(retObj.dailyMap);
			disableTheBlank();
			g('message').innerHTML="日报已经提交，请点确定查看反馈工作量或者返回！";		
			g('edit_button').style.display="none";
			g('zj_button').style.display="none";
			g('flag').value = "Submited";
		} else if(retObj.dailyMap.auditStatus=="3"){
			//日报审批通过
			fillTheBlank(retObj.dailyMap);
			disableTheBlank();
			g('message').innerHTML="日报审批通过，请点确定查看反馈工作量或者返回！";		
			g('edit_button').style.display="none";
			g('zj_button').style.display="none";
			g('flag').value = "Passed";
		} else if(retObj.dailyMap.auditStatus=="4"){
			//日报审批未通过
			fillTheBlank(retObj.dailyMap);
			disableTheBlank();
			g('message').innerHTML="日报审批未通过，请点确定继续反馈工作量或者返回！";		
			g('edit_button').style.display="inline";
			g('edit_button').removeAttribute("disabled");
			g('zj_button').style.display="inline";
			g('flag').value = "notPassed";
		}
		
		retObj = jcdpCallService("DailyReportSrv", "queryDailyQuestion", "projectInfoNo=<%=projectInfoNo %>&produceDate="+produce_date);
	    var lineNum = 0;
	    if(retObj != null && retObj.questionList != null){
	      lineNum = retObj.questionList.length;
	    }
	    
	    var table = document.getElementById("table");
		if(table.rows.length != 1){
			//清掉已增加的列
			for(var i=1; i < table.rows.length;i++){
				table.deleteRow(1);
			}
		}
	    
	    document.getElementById("rowNum").value = lineNum;
	    
	    for(var i = 0; i < lineNum; i++){
	      var tr = document.getElementById("table").insertRow();
	      if ( i % 2 == 0) {
	        tr.className = "even";
	      } else {
	        tr.className = "odd";
	      }
	      
	      var rowNum = i;
	      var lineId = "row_" + rowNum + "_";
	      tr.id=lineId;
	      
	      var obj = retObj.questionList[i];
	      
	      //序号
	      tr.insertCell().innerHTML = (i+1);
	      
	      //问题分类bugCode
	      tr.insertCell().innerHTML = '<input type="hidden" name="question_id_'+rowNum+'" id="question_id_'+rowNum+'" value="'+obj.question_id+'"/><select name="bug_code_'+rowNum+'" id="bug_code_'+rowNum+'" class="select_width"> '+
										    		'<option value="">--请选择--</option>'+
										    		'<option value="5000100005000000001">人员</option>'+
										    		'<option value="5000100005000000002">物资</option>'+
										    		'<option value="5000100005000000003">设备</option>'+
										    		'<option value="5000100005000000004">HSE</option>'+
										    		'<option value="5000100005000000005">后勤</option>'+
										    		'<option value="5000100005000000006">工农、社区关系</option>'+
										    		'<option value="5000100005000000007">技术</option>'+
										    		'<option value="5000100005000000008">生产</option>'+
										    		'<option value="5000100005000000009">甲方信息</option>'+
										    		'<option value="5000100005000000010">自然因素</option>'+
										    		'<option value="5000100005000000011">质量</option>'+
										    		'<option value="5000100005000000012">财务经营</option>'+
										    		'<option value="5000100005000000013">其它</option>'+
										    	'</select>';
										    	
		  document.getElementsByName("bug_code_"+rowNum)[0].value = obj.bug_code;
	      
	      //问题描述
	      tr.insertCell().innerHTML = '<textarea name="q_description_'+rowNum+'" id="q_description_'+rowNum+'" class="textarea" >'+obj.q_description+'</textarea>';
	      
	      //解决方案
	      tr.insertCell().innerHTML = '<textarea name="resolvent_'+rowNum+'" id="resovlent_'+rowNum+'" class="textarea" >'+obj.resolvent+'</textarea>';
	      
	      //删除
	      tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
	    }
	    
	}
	function disableTheBlank(){
		document.getElementsByName("if_build")[0].disabled = true;
		document.getElementsByName("weather")[0].disabled = true;
		document.getElementsByName("OPERATION_EXPLAIN")[0].disabled = false;
		document.getElementsByName("stop_reason")[0].disabled = true;
		document.getElementsByName("work_time")[0].disabled = true;
		document.getElementsByName("collect_time")[0].disabled = true;
		document.getElementsByName("day_check_time")[0].disabled = true;
		 
		document.getElementsByName("daily_jp_acquire_shot_num")[0].disabled = true;
		document.getElementsByName("daily_qq_acquire_shot_num")[0].disabled = true;
		document.getElementsByName("daily_acquire_sp_num")[0].disabled = true;
		document.getElementsByName("DAILY_JP_ACQUIRE_WORKLOAD")[0].disabled = true;
		document.getElementsByName("DAILY_QQ_ACQUIRE_WORKLOAD")[0].disabled = true;
		document.getElementsByName("DAILY_ACQUIRE_WORKLOAD")[0].disabled = true;
		document.getElementsByName("DAILY_TEST_SP_NUM")[0].disabled = true;
		document.getElementsByName("EFFICIENCY_ADJUST")[0].disabled = true;
		document.getElementsByName("DAILY_ACQUIRE_FIRSTLEVEL_NUM")[0].disabled = true;
		document.getElementsByName("COLLECT_2_CLASS")[0].disabled = true;
		document.getElementsByName("COLLECT_MISS_NUM")[0].disabled = true;
		document.getElementsByName("COLLECT_WASTER_NUM")[0].disabled = true;
		document.getElementsByName("DAILY_MICRO_MEASUE_POINT_NUM")[0].disabled = true;
		document.getElementsByName("DAILY_SMALL_REFRACTION_NUM")[0].disabled = true;
		document.getElementsByName("DAILY_DRILL_SP_NUM")[0].disabled = true;
		document.getElementsByName("DAILY_DRILL_WELL_NUM")[0].disabled = true;
		document.getElementsByName("DAILY_DRILL_FOOTAGE_NUM")[0].disabled = true;
		document.getElementsByName("DAILY_SURVEY_SHOT_NUM")[0].disabled = true;
		document.getElementsByName("DAILY_SURVEY_GEOPHONE_NUM")[0].disabled = true;
		document.getElementsByName("SURVEY_SHOT_WORKLOAD")[0].disabled = true;
		document.getElementsByName("SURVEY_INCEPT_WORKLOAD")[0].disabled = true;
		document.getElementsByName("PATH")[0].disabled = true;
		document.getElementsByName("TIDE_DELAY")[0].disabled = true;
		document.getElementsByName("ACTUAL_SHOT")[0].disabled = true;
		document.getElementsByName("ARRAY_TROUBLE")[0].disabled = true;
		document.getElementsByName("RELATION_DELAY")[0].disabled = true;
		document.getElementsByName("WEATHER_DELAY")[0].disabled = true;
		document.getElementsByName("MACHINE_DELAY")[0].disabled = true;
		document.getElementsByName("MEASURE_DELAY")[0].disabled = true;
		document.getElementsByName("CLEARUP_DELAY")[0].disabled = true;
		document.getElementsByName("TRANSIT_DELAY")[0].disabled = true;
		document.getElementsByName("LINE_LAY")[0].disabled = true;
		document.getElementsByName("ARRAY_CHECK")[0].disabled = true;
		document.getElementsByName("HSE_DELAY")[0].disabled = true;
		document.getElementsByName("FIRST_SHOT_TIME")[0].disabled = true;
		document.getElementsByName("LAST_SHOT_TIME")[0].disabled = true;
		document.getElementsByName("AIR_GUN_USE_TIME")[0].disabled = true;
		document.getElementsByName("INFO_AREA_NUM")[0].disabled = true;
		document.getElementsByName("ORIENTATION_SHOT_NUM")[0].disabled = true;
		
		document.getElementsByName("FOCUS_DELAY")[0].disabled = true;//夏秋雨添加震源故障时间
		
	}
	function forEdit(){
		document.getElementById("edit_button").disabled=true;
		document.getElementById("edit_flag").value="yes";
		edit_flag="yes";
		document.getElementsByName("if_build")[0].disabled = false;
		document.getElementsByName("weather")[0].disabled = false;
		document.getElementsByName("OPERATION_EXPLAIN")[0].disabled = false;
		document.getElementsByName("stop_reason")[0].disabled = false;
		document.getElementsByName("work_time")[0].disabled = false;
		document.getElementsByName("collect_time")[0].disabled = false;
		document.getElementsByName("day_check_time")[0].disabled = false;
		//document.getElementsByName("workman_num")[0].disabled = false;
		//document.getElementsByName("out_employee_num")[0].disabled = false;
		//document.getElementsByName("season_employee_num")[0].disabled = false;
		document.getElementsByName("daily_jp_acquire_shot_num")[0].disabled = false;
		document.getElementsByName("daily_qq_acquire_shot_num")[0].disabled = false;
		document.getElementsByName("daily_acquire_sp_num")[0].disabled = false;
		document.getElementsByName("DAILY_JP_ACQUIRE_WORKLOAD")[0].disabled = false;
		document.getElementsByName("DAILY_QQ_ACQUIRE_WORKLOAD")[0].disabled = false;
		document.getElementsByName("DAILY_ACQUIRE_WORKLOAD")[0].disabled = false;
		document.getElementsByName("DAILY_TEST_SP_NUM")[0].disabled = false;
		document.getElementsByName("EFFICIENCY_ADJUST")[0].disabled = false;
		document.getElementsByName("DAILY_ACQUIRE_FIRSTLEVEL_NUM")[0].disabled = false;
		document.getElementsByName("COLLECT_2_CLASS")[0].disabled = false;
		document.getElementsByName("COLLECT_MISS_NUM")[0].disabled = false;
		document.getElementsByName("COLLECT_WASTER_NUM")[0].disabled = false;
		document.getElementsByName("DAILY_MICRO_MEASUE_POINT_NUM")[0].disabled = false;
		document.getElementsByName("DAILY_SMALL_REFRACTION_NUM")[0].disabled = false;
		document.getElementsByName("DAILY_DRILL_SP_NUM")[0].disabled = false;
		document.getElementsByName("DAILY_DRILL_WELL_NUM")[0].disabled = false;
		document.getElementsByName("DAILY_DRILL_FOOTAGE_NUM")[0].disabled = false;
		document.getElementsByName("DAILY_SURVEY_SHOT_NUM")[0].disabled = false;
		document.getElementsByName("DAILY_SURVEY_GEOPHONE_NUM")[0].disabled = false;
		document.getElementsByName("SURVEY_SHOT_WORKLOAD")[0].disabled = false;
		document.getElementsByName("SURVEY_INCEPT_WORKLOAD")[0].disabled = false;
		document.getElementsByName("PATH")[0].disabled = false;
		document.getElementsByName("TIDE_DELAY")[0].disabled = false;
		document.getElementsByName("ACTUAL_SHOT")[0].disabled = false;
		document.getElementsByName("ARRAY_TROUBLE")[0].disabled = false;
		document.getElementsByName("RELATION_DELAY")[0].disabled = false;
		document.getElementsByName("WEATHER_DELAY")[0].disabled = false;
		document.getElementsByName("MACHINE_DELAY")[0].disabled = false;
		document.getElementsByName("MEASURE_DELAY")[0].disabled = false;
		document.getElementsByName("CLEARUP_DELAY")[0].disabled = false;
		document.getElementsByName("TRANSIT_DELAY")[0].disabled = false;
		document.getElementsByName("LINE_LAY")[0].disabled = false;
		document.getElementsByName("ARRAY_CHECK")[0].disabled = false;
		document.getElementsByName("HSE_DELAY")[0].disabled = false;
		document.getElementsByName("FIRST_SHOT_TIME")[0].disabled = false;
		document.getElementsByName("LAST_SHOT_TIME")[0].disabled = false;
		document.getElementsByName("AIR_GUN_USE_TIME")[0].disabled = false;
		document.getElementsByName("INFO_AREA_NUM")[0].disabled = false;
		document.getElementsByName("ORIENTATION_SHOT_NUM")[0].disabled = false;
		
		document.getElementsByName("FOCUS_DELAY")[0].disabled = false;//夏秋雨添加震源故障时间
	}
	function fillTheBlank(dailyMap){
		document.getElementsByName("if_build")[0].value = dailyMap.ifBuild;
		if(dailyMap.ifBuild =='9'){
			document.getElementsByName("td1")[0].style.display ='block';
		}else{
			document.getElementsByName("td1")[0].style.display ='none';
		}
		document.getElementsByName("weather")[0].value = dailyMap.weather;
		document.getElementsByName("OPERATION_EXPLAIN")[0].value = dailyMap.operationExplain ;
		document.getElementsByName("stop_reason")[0].value = dailyMap.stopReason;
		
		document.getElementsByName("work_time")[0].value = dailyMap.workTime==0?"":dailyMap.workTime;
		document.getElementsByName("collect_time")[0].value = dailyMap.collectTime==0?"":dailyMap.collectTime;
		document.getElementsByName("day_check_time")[0].value = dailyMap.dayCheckTime==0?"":dailyMap.dayCheckTime;
		document.getElementsByName("daily_jp_acquire_shot_num")[0].value = dailyMap.dailyJpAcquireShotNum==0?"":dailyMap.dailyJpAcquireShotNum;
		document.getElementsByName("daily_qq_acquire_shot_num")[0].value = dailyMap.dailyQqAcquireShotNum==0?"":dailyMap.dailyQqAcquireShotNum;
	    document.getElementsByName("daily_acquire_sp_num")[0].value = dailyMap.dailyAcquireSpNum==0?"":dailyMap.dailyAcquireSpNum;
	    document.getElementsByName("DAILY_JP_ACQUIRE_WORKLOAD")[0].value = dailyMap.dailyJpAcquireWorkload;
		document.getElementsByName("DAILY_QQ_ACQUIRE_WORKLOAD")[0].value = dailyMap.dailyQqAcquireWorkload;
		document.getElementsByName("DAILY_ACQUIRE_WORKLOAD")[0].value = dailyMap.dailyAcquireWorkload;
		
		document.getElementsByName("DAILY_TEST_SP_NUM")[0].value = dailyMap.dailyTestSpNum;
		document.getElementsByName("EFFICIENCY_ADJUST")[0].value = dailyMap.efficiencyAdjust;
		document.getElementsByName("DAILY_ACQUIRE_FIRSTLEVEL_NUM")[0].value = dailyMap.dailyAcquireFirstlevelNum;
		document.getElementsByName("COLLECT_2_CLASS")[0].value = dailyMap.collect2Class;
		document.getElementsByName("COLLECT_MISS_NUM")[0].value = dailyMap.collectMissNum;
		document.getElementsByName("COLLECT_WASTER_NUM")[0].value = dailyMap.collectWasterNum;
		document.getElementsByName("DAILY_MICRO_MEASUE_POINT_NUM")[0].value = dailyMap.dailyMicroMeasuePointNum;
		document.getElementsByName("DAILY_SMALL_REFRACTION_NUM")[0].value = dailyMap.dailySmallRefractionNum;
		document.getElementsByName("DAILY_DRILL_SP_NUM")[0].value = dailyMap.dailyDrillSpNum;
		document.getElementsByName("DAILY_DRILL_WELL_NUM")[0].value = dailyMap.dailyDrillWellNum;
		document.getElementsByName("DAILY_DRILL_FOOTAGE_NUM")[0].value = dailyMap.dailyDrillFootageNum;
		document.getElementsByName("DAILY_SURVEY_SHOT_NUM")[0].value = dailyMap.dailySurveyShotNum;
		document.getElementsByName("DAILY_SURVEY_GEOPHONE_NUM")[0].value = dailyMap.dailySurveyGeophoneNum;
		document.getElementsByName("SURVEY_SHOT_WORKLOAD")[0].value = dailyMap.surveyShotWorkload;
		document.getElementsByName("SURVEY_INCEPT_WORKLOAD")[0].value = dailyMap.surveyInceptWorkload;
		
		document.getElementsByName("PATH")[0].value = dailyMap.path;
		document.getElementsByName("TIDE_DELAY")[0].value = dailyMap.tideDelay;
		document.getElementsByName("ACTUAL_SHOT")[0].value = dailyMap.actualShot;
		
		document.getElementsByName("ARRAY_TROUBLE")[0].value = dailyMap.arrayTrouble;
		document.getElementsByName("WEATHER_DELAY")[0].value = dailyMap.weatherDelay;
		document.getElementsByName("MACHINE_DELAY")[0].value = dailyMap.machineDelay;
		document.getElementsByName("MEASURE_DELAY")[0].value = dailyMap.measureDelay;
		document.getElementsByName("CLEARUP_DELAY")[0].value = dailyMap.clearupDelay;
		document.getElementsByName("TRANSIT_DELAY")[0].value = dailyMap.transitDelay;
		document.getElementsByName("LINE_LAY")[0].value = dailyMap.lineLay;
		document.getElementsByName("ARRAY_CHECK")[0].value = dailyMap.arrayCheck;
		document.getElementsByName("HSE_DELAY")[0].value = dailyMap.hseDelay;
		document.getElementsByName("FIRST_SHOT_TIME")[0].value = dailyMap.firstShotTime;
		document.getElementsByName("LAST_SHOT_TIME")[0].value = dailyMap.lastShotTime;
		document.getElementsByName("AIR_GUN_USE_TIME")[0].value = dailyMap.airGunUseTime;
		document.getElementsByName("INFO_AREA_NUM")[0].value = dailyMap.infoAreaNum;
		document.getElementsByName("ORIENTATION_SHOT_NUM")[0].value = dailyMap.orientationShotNum;
		document.getElementsByName("RELATION_DELAY")[0].value = dailyMap.relationDelay;
		
		document.getElementsByName("FOCUS_DELAY")[0].value = dailyMap.focusDelay;//夏秋雨添加震源故障时间
		document.getElementsByName("FIRST_SHOT_TIME")[0].value = dailyMap.firstDelay;//首炮时间,夏秋雨添加（大港物探处）
		document.getElementsByName("LAST_SHOT_TIME")[0].value = dailyMap.lastDelay;//末炮时间,夏秋雨添加（大港物探处）
	
	}
	function cleanTheBlank(){
		document.getElementsByName("if_build")[0].value = "";
		document.getElementsByName("weather")[0].value = "";
		document.getElementsByName("OPERATION_EXPLAIN")[0].value = "";
		document.getElementsByName("stop_reason")[0].value = "";
		document.getElementsByName("work_time")[0].value = "";
		document.getElementsByName("collect_time")[0].value = "";
		document.getElementsByName("day_check_time")[0].value = "";
	 
		//document.getElementsByName("workman_num")[0].value = "";
		//document.getElementsByName("out_employee_num")[0].value = "";
		//document.getElementsByName("season_employee_num")[0].value = "";
		document.getElementsByName("daily_jp_acquire_shot_num")[0].value = "";
		document.getElementsByName("daily_qq_acquire_shot_num")[0].value = "";
		document.getElementsByName("daily_acquire_sp_num")[0].value = "";
		document.getElementsByName("DAILY_JP_ACQUIRE_WORKLOAD")[0].value = "";
		document.getElementsByName("DAILY_QQ_ACQUIRE_WORKLOAD")[0].value = "";
		document.getElementsByName("DAILY_ACQUIRE_WORKLOAD")[0].value = "";
		document.getElementsByName("DAILY_TEST_SP_NUM")[0].value = "";
		document.getElementsByName("EFFICIENCY_ADJUST")[0].value = "";
		document.getElementsByName("DAILY_ACQUIRE_FIRSTLEVEL_NUM")[0].value = "";
		document.getElementsByName("COLLECT_2_CLASS")[0].value = "";
		document.getElementsByName("COLLECT_MISS_NUM")[0].value = "";
		document.getElementsByName("COLLECT_WASTER_NUM")[0].value = "";
		document.getElementsByName("DAILY_MICRO_MEASUE_POINT_NUM")[0].value = "";
		document.getElementsByName("DAILY_SMALL_REFRACTION_NUM")[0].value = "";
		document.getElementsByName("DAILY_DRILL_SP_NUM")[0].value = "";
		document.getElementsByName("DAILY_DRILL_WELL_NUM")[0].value = "";
		document.getElementsByName("DAILY_DRILL_FOOTAGE_NUM")[0].value = "";
		document.getElementsByName("DAILY_SURVEY_SHOT_NUM")[0].value = "";
		document.getElementsByName("DAILY_SURVEY_GEOPHONE_NUM")[0].value = "";
		document.getElementsByName("SURVEY_SHOT_WORKLOAD")[0].value = "";
		document.getElementsByName("SURVEY_INCEPT_WORKLOAD")[0].value = "";
		document.getElementsByName("PATH")[0].value = "";
		document.getElementsByName("TIDE_DELAY")[0].value = "";
		document.getElementsByName("ACTUAL_SHOT")[0].value = "";
		document.getElementsByName("ARRAY_TROUBLE")[0].value = "";
		document.getElementsByName("RELATION_DELAY")[0].value = "";
		document.getElementsByName("WEATHER_DELAY")[0].value = "";
		document.getElementsByName("MACHINE_DELAY")[0].value = "";
		document.getElementsByName("MEASURE_DELAY")[0].value = "";
		document.getElementsByName("CLEARUP_DELAY")[0].value = "";
		document.getElementsByName("TRANSIT_DELAY")[0].value = "";
		document.getElementsByName("LINE_LAY")[0].value = "";
		document.getElementsByName("ARRAY_CHECK")[0].value = "";
		document.getElementsByName("HSE_DELAY")[0].value = "";
		document.getElementsByName("FIRST_SHOT_TIME")[0].value = "";
		document.getElementsByName("LAST_SHOT_TIME")[0].value = "";
		document.getElementsByName("AIR_GUN_USE_TIME")[0].value = "";
		document.getElementsByName("INFO_AREA_NUM")[0].value = "";
		document.getElementsByName("ORIENTATION_SHOT_NUM")[0].value = "";
		
		document.getElementsByName("FOCUS_DELAY")[0].value = "";//夏秋雨添加震源故障时间
		
		forEdit();
		

		//document.getElementsByName("out_employee_num")[0].disabled = false;
		//document.getElementsByName("season_employee_num")[0].disabled = false;
		
	}
	
	function goNext(){
		var reg=/^((20|21|22|23|[0-1]\d)\:[0-5][0-9])(\:[0-5][0-9])?$/;
		
		var first_shot_time = document.getElementsByName("FIRST_SHOT_TIME")[0].value;
	    if(first_shot_time.length!=0){
	        if(!reg.test(first_shot_time)){
	            alert("首炮时间格式不正确!");
	            return false;
	        }
	    }
	    
	    var last_shot_time = document.getElementsByName("LAST_SHOT_TIME")[0].value;
	    if(last_shot_time.length!=0){
	        if(!reg.test(last_shot_time)){
	            alert("末炮时间格式不正确!");
	            return false;
	        }
	    }
		
		var produce_date = document.getElementById("produce_date");
		if(produce_date == null || produce_date.value == ""){
			alert("生产日期不能为空!");
			return false;
		}
		
		var if_build = document.getElementById("if_build");
		if(if_build == null || if_build.value == ""){
			alert("项目状态不能为空!");
			return false;
		}else if(if_build != null && if_build.value == "9"){
			var stop_reason = document.getElementById("stop_reason");
			if(stop_reason == null || stop_reason.value == ""){
				alert("停工原因不能为空!");
				return false;
			}
		}
		
		var weather = document.getElementById("weather");
		if(weather == null || weather.value == ""){
			alert("天气不能为空!");
			return false;
		}
		var names = "PATH,LINE_LAY,ARRAY_CHECK,day_check_time,WEATHER_DELAY,TIDE_DELAY,MACHINE_DELAY,FOCUS_DELAY,"+
			"MEASURE_DELAY,ARRAY_TROUBLE,CLEARUP_DELAY,TRANSIT_DELAY,AIR_GUN_USE_TIME,RELATION_DELAY,HSE_DELAY"
		var sum = 0;
		var column_names = names.split(',');
		for(var i in column_names){
			var value = document.getElementsByName(column_names[i])[0].value;
			if(value !=null && value !='') {
				sum = sum -(-value);
			}
		}
		if(sum>24){
			alert("时间之和不能超过24个小时!");
			return false;
		}
		document.form1.submit();
	}
	function toAdd(){
		var rowNum = Number(document.getElementById("rowNum").value);
		var lineId = "row_" + rowNum + "_";
		
		var tr = document.getElementById("table").insertRow();
		tr.id=lineId;	
		if ( rowNum % 2 == 0) {
			tr.className = "even";
		} else {
			tr.className = "odd";
		}
		
		//序号
	      tr.insertCell().innerHTML = (rowNum+1);
	      
	      //问题分类bugCode
	      tr.insertCell().innerHTML = '<input type="hidden" name="question_id_'+rowNum+'" id="question_id_'+rowNum+'"/><select name="bug_code_'+rowNum+'" id="bug_code_'+rowNum+'" class="select_width"> '+
										    		'<option value="">--请选择--</option>'+
										    		'<option value="5000100005000000001">人员</option>'+
										    		'<option value="5000100005000000002">物资</option>'+
										    		'<option value="5000100005000000003">设备</option>'+
										    		'<option value="5000100005000000004">HSE</option>'+
										    		'<option value="5000100005000000005">后勤</option>'+
										    		'<option value="5000100005000000006">工农、社区关系</option>'+
										    		'<option value="5000100005000000007">技术</option>'+
										    		'<option value="5000100005000000008">生产</option>'+
										    		'<option value="5000100005000000009">甲方信息</option>'+
										    		'<option value="5000100005000000010">自然因素</option>'+
										    		'<option value="5000100005000000011">质量</option>'+
										    		'<option value="5000100005000000012">财务经营</option>'+
										    		'<option value="5000100005000000013">其它</option>'+
										    	'</select>';
	      
	      //问题描述
	      tr.insertCell().innerHTML = '<textarea name="q_description_'+rowNum+'" class="textarea"></textarea>';
	      
	      //解决方案
	      tr.insertCell().innerHTML = '<textarea name="resolvent_'+rowNum+'" class="textarea"></textarea>';
	      
	      //删除
	      tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
	      
	     document.getElementById("rowNum").value = rowNum+1;
	}
	
	function toDelete(lineId){
		var rowNum = lineId.split('_')[1];
		var line = document.getElementById(lineId);	
		
		var lineNum = Number(document.getElementById("rowNum").value);
		
		var question_id = document.getElementById('question_id_'+rowNum);
		
		if(question_id != null){
			//删除数据库中现有记录
			document.getElementById('deleteId').value = document.getElementById('deleteId').value + "," +question_id.value;
		}
		
		line.parentNode.removeChild(line);
		
		lineNum--;
		document.getElementById("rowNum").value = lineNum;
	}
	function change(){
		if(document.getElementsByName("if_build")[0].value == "9"){
			g('td1').style.display="inline";
			g('td2').className="odd";
		} else {
			g('td1').style.display="none";
			g('td2').className="even";
		}
	}
</script>
<body style="background:#fff">
<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">  
	<tr class="tongyong_box_title">
		<td colspan="6" align="left"><span>&nbsp;&nbsp;<font size="2">日报基本信息</font></span></td>
	</tr>
  	<tr class="even">
	    <td class="inquire_item6">施工队伍：</td>
	    <td class="inquire_form6"><%=orgName  %></td>
    	<td class="inquire_item6">项目信息：</td>
		<td class="inquire_form6"><%=projectName %></td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6" >
			<input id="edit_button" type="button" name="button2" value="编辑" onclick="forEdit()" class="myButton" style="display: none;"/>&nbsp;&nbsp;&nbsp;
			<input type="button" name="button2" value="下一步"  class="myButton"  onclick="goNext()"/>
		</td>
	</tr> 
</table>
<form name="form1" action="<%=contextPath%>/pm/dailyReport/saveOrUpdateQhDailyReport.srq" method="post" style="overflow-y: scroll;height: 370px;">

<input id="project_info_no" name="project_info_no" value="<%=projectInfoNo %>" type="hidden"/>
<input id="edit_flag" name="edit_flag" value="no" type="hidden"/>
<input id="flag" name="flag" value="" type="hidden"/>


<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
<tr class="odd">
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;生产日期:</td>
		<td class="inquire_form6"><input type="text" name='produce_date' id='produce_date' value=''  onchange="validate()" readonly />&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1"  name="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector('produce_date',tributton1);" /></td>
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;项目状态:</td>
		<td class="inquire_form6">
			<select name="if_build" id="if_build" class="select_width" onchange="change()">
					<option value="">请选择</option>
						<option value="1">动迁</option>
						<option value="2">踏勘</option>
						<option value="3">基地建设</option>
						<option value="4">培训</option>
						<option value="5">试验</option>
						<option value="6">测量</option>
						<option value="7">钻井</option>
						<option value="8">采集</option>
						<option value="9">停工</option>
						<option value="10">暂停（人员设备撤离）</option>
						<option value="11">结束</option>
			</select>
		</td>
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;天气情况：</td>
		<td class="inquire_form6">
			<select name="weather" id="weather" class="select_width">
				<option value="">请选择</option>
				<option value="1">晴</option>
				<option value="2">阴</option>
				<option value="3">多云</option>
				<option value="4">雨</option>
				<option value="5">雾</option>
				<option value="17">大风</option>
				<option value="6">霾</option>
				<option value="7">霜冻</option>
				<option value="8">暴风</option>
				<option value="9">台风</option>
				<option value="10">暴风雪</option>
				<option value="11">雪</option>
				<option value="12">雨夹雪</option>
				<option value="13">冰雹</option>
				<option value="14">浮尘</option>
				<option value="15">扬沙</option>
				<option value="16">其它</option>
			</select>
		</td>
	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
	<tr class="even" id="td1" style="display: none;">
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;停工原因:</td>
		<td class="inquire_form6">
			<select name="stop_reason" id="stop_reason" class="select_width">
				<option value="">请选择</option>
				<option value="1">试验</option>
				<option value="2">天气</option>
				<option value="3">搬迁</option>
				<option value="4">设备检修</option>
				<option value="5">设备故障</option>
				<option value="6">地方关系</option>
			</select>
		</td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6">&nbsp;</td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="6" class="inquire_item6">
			<span id="message" style="color:red">&nbsp;</span>			
		</td>
	</tr>
</table>  	
	<table border="0" cellpadding="0" cellspacing="0"	class="tab_line_height" id="ta1" name="ta1" style="height: 200px;overflow-y: scroll;">
			<tr class="even" id="td3" style="display: none;">
				<td class="inquire_item6">日完成井炮:</td>
				<td class="inquire_form6"><input name="daily_jp_acquire_shot_num" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">日完成气枪:</td>
				<td class="inquire_form6"><input name="daily_qq_acquire_shot_num" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">日完成震源</td>
				<td class="inquire_form6"><input name="daily_acquire_sp_num" type="text" class="input_width" />
				</td>
			</tr>

			<tr class="even" id="td4" style="display: none;">
				<td class="inquire_item6">井炮日完成工作量:</td>
				<td class="inquire_form6"><input name="DAILY_JP_ACQUIRE_WORKLOAD" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">气枪日完成工作量:</td>
				<td class="inquire_form6"><input name="DAILY_QQ_ACQUIRE_WORKLOAD" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">震源日完成工作量:</td>
				<td class="inquire_form6"><input name="DAILY_ACQUIRE_WORKLOAD" type="text" class="input_width" />
				</td>

			</tr>

			<tr class="even" id="td5" style="display: none;">
				<td class="inquire_item6">试验炮:</td>
				<td class="inquire_form6"><input name="DAILY_TEST_SP_NUM" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">调整后资源时效:</td>
				<td class="inquire_form6"><input name="EFFICIENCY_ADJUST" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">一级品:</td>
				<td class="inquire_form6"><input name="DAILY_ACQUIRE_FIRSTLEVEL_NUM" type="text" class="input_width" />
				</td>
			</tr>

			<tr class="even" id="td6" style="display: none;">
				<td class="inquire_item6">二级品:</td>
				<td class="inquire_form6"><input name="COLLECT_2_CLASS" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">空炮:</td>
				<td class="inquire_form6"><input name="COLLECT_MISS_NUM" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">废炮:</td>
				<td class="inquire_form6"><input name="COLLECT_WASTER_NUM" type="text" class="input_width" />
				</td>
			</tr>

			<tr class="even" id="td7" style="display: none;">
				<td class="inquire_item6">微测井点数:</td>
				<td class="inquire_form6"><input name="DAILY_MICRO_MEASUE_POINT_NUM" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">小折射点数:</td>
				<td class="inquire_form6"><input name="DAILY_SMALL_REFRACTION_NUM" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">钻井炮点数:</td>
				<td class="inquire_form6"><input name="DAILY_DRILL_SP_NUM" type="text" class="input_width" />
				</td>
			</tr>

			<tr class="even" id="td8" style="display: none;">
				<td class="inquire_item6">钻井井口数:</td>
				<td class="inquire_form6"><input name="DAILY_DRILL_WELL_NUM" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">钻井进尺数:</td>
				<td class="inquire_form6"><input  name="DAILY_DRILL_FOOTAGE_NUM" type="text" class="input_width" />
				</td>
				<td class="inquire_item6">测量炮点数:</td>
				<td class="inquire_form6"><input name="DAILY_SURVEY_SHOT_NUM" 	type="text" class="input_width" />
				</td>
			</tr>

			<tr class="even" id="td9" style="display: none;">
				<td class="inquire_item6">测量检波点数:</td>
				<td class="inquire_form6"><input 	name="DAILY_SURVEY_GEOPHONE_NUM" type="text"  class="input_width" />
				</td>
				<td class="inquire_item6">测量炮线公里数:</td>
				<td class="inquire_form6"><input  name="SURVEY_SHOT_WORKLOAD" 	type="text" class="input_width" />
				</td>
				<td class="inquire_item6">测量接收线公里数</td>
				<td class="inquire_form6"><input  name="SURVEY_INCEPT_WORKLOAD" type="text" class="input_width" />
				</td>
			</tr>

			<tr class="even" id="td2" style="display: none;">
				<td class="inquire_item6"><font style="color:  red">*</font>&nbsp;施工时长:</td>
				<td class="inquire_form6"><input name="work_time"  type="text" class="input_width" /></td>
				<td class="inquire_item6">采集时间:</td>
				<td class="inquire_form6"><input name="collect_time" type="text" class="input_width" /></td>
				
			</tr>

			<tr class="even" id="td10">
				<td class="inquire_item8">路途时间:</td>
				<td class="inquire_form8"><input name="PATH" type="text" class="input_width" /></td>
				<td class="inquire_item8">收放线时间:</td>
				<td class="inquire_form8"><input name="LINE_LAY" type="text" class="input_width" /></td>
				<td class="inquire_item8">查排列时间:</td>
				<td class="inquire_form8"><input name="ARRAY_CHECK" type="text" class="input_width" /></td>
				<td class="inquire_item8">日检时间:</td>
				<td class="inquire_form8"><input name="day_check_time" type="text" class="input_width" /></td>
			</tr>
			<tr class="even" id="td11">
				<td class="inquire_item8">首炮时间:</td>
				<td class="inquire_form8"><input name="FIRST_SHOT_TIME" type="text" class="input_width" /> </td>
				<td class="inquire_item8">末炮时间:</td>
				<td class="inquire_form8"><input name="LAST_SHOT_TIME" type="text" class="input_width" /> </td>
				<td class="inquire_item8">实际放炮时间:</td>
				<td class="inquire_form8"><input name="ACTUAL_SHOT"  type="text" class="input_width" /></td>
				<td class="inquire_item8">天气影响时间:</td>
				<td class="inquire_form8"><input name="WEATHER_DELAY" type="text" class="input_width" /></td>
			</tr>
			<tr class="even" id="td12">
				<td class="inquire_item8">潮汐影响时间:</td>
				<td class="inquire_form8"><input name="TIDE_DELAY"  type="text" class="input_width" /></td>
				<td class="inquire_item8">仪器故障时间:</td>
				<td class="inquire_form8"><input name="MACHINE_DELAY" type="text" class="input_width" /></td>
				<td class="inquire_item8">震源故障时间:</td>
				<td class="inquire_form8"><input name="FOCUS_DELAY" type="text" class="input_width" /></td>
				<td class="inquire_item8">测量故障时间:</td>
				<td class="inquire_form8"><input name="MEASURE_DELAY" type="text" class="input_width" /></td>
			</tr>
			<tr class="even" id="td13">
				<td class="inquire_item8">排列故障时间:</td>
				<td class="inquire_form8"><input name="ARRAY_TROUBLE"type="text" class="input_width" /></td>
				<td class="inquire_item8">工区清障时间:</td>
				<td class="inquire_form8"><input name="CLEARUP_DELAY" type="text" class="input_width" /></td>
				<td class="inquire_item8">工地搬迁时间:</td>
				<td class="inquire_form8"><input name="TRANSIT_DELAY" type="text" class="input_width" /></td>
				<td class="inquire_item8">气枪调头上线时间:</td>
				<td class="inquire_form8"><input name="AIR_GUN_USE_TIME" type="text" class="input_width" /></td>
			</tr>
			
			<tr class="even" id="td14">
				<td class="inquire_item8">地方关系影响:</td>
				<td class="inquire_form8"><input name="RELATION_DELAY" type="text" class="input_width" /></td>
				<td class="inquire_item8">HSE影响时间:</td>
				<td class="inquire_form8"><input name="HSE_DELAY" type="text" class="input_width" /></td>
				<td class="inquire_item8"></td>
				<td class="inquire_form8"></td>
				<td class="inquire_item8"></td>
				<td class="inquire_form8"></td>
			</tr>
			<tr class="even" id="td15" style="display: none;">
				<td class="inquire_item8">有资料面积:</td>
				<td class="inquire_form8"><input name="INFO_AREA_NUM" type="text" class="input_width" /></td>
				<td class="inquire_item8">定位炮:</td>
				<td class="inquire_form8"><input name="ORIENTATION_SHOT_NUM" type="text" class="input_width" /></td>
				
			</tr>

			<tr><td colspan="6" class="inquire_item6"><span id="message" style="color: red">&nbsp;</span></td></tr>
		</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="display: none;">
	<tr class="tongyong_box_title">
		<td colspan="3" align="left"><span>&nbsp;&nbsp;<font size="2">日问题信息</font></span></td>
		<span id="zj_button" ><auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton></span>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="table" style="display: none;">
	<tr class="bt_info">
		<td class="bt_info_odd" width="5%">序号<input type="hidden" value="0" id="rowNum" name="rowNum"/><input type="hidden" value="" id="deleteId" name="deleteId"/></td>
		<td class="bt_info_even" width="20%">问题分类</td>
		<td class="bt_info_odd" width="35%">问题描述</td>
		<td class="bt_info_even" width="35%">解决方案</td>
		<td class="bt_info_odd" width="5%">删除</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	<tr class="even">
		<td width="10px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;生产写实：</td><!-- class="inquire_item6" -->
		<td width=""> <!-- class="inquire_item6" -->
			<textarea id="OPERATION_EXPLAIN" name="OPERATION_EXPLAIN" cols="45" rows="3" class="textarea"></textarea>			
		</td>
	</tr>
</table>
</form>
</body>
</html>