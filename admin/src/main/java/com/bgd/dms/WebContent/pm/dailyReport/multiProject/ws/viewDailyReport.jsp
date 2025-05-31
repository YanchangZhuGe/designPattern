<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

	String daily_no = request.getParameter("daily_no_ws");
	

	String project_info_no = request.getParameter("project_info_no");

	if(project_info_no == null || "".equals(project_info_no)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		project_info_no = user.getProjectInfoNo();

	}
	
	String produce_date = request.getParameter("produce_date");
	
	if(produce_date == null){
		produce_date = "null";
	}
	 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
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
</head>


<script type="text/javascript">
//debugger;
cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
var produceDate;
function page_init(){
	var produceDate = document.getElementById("produceDate").value;
	debugger;
	if(produceDate == null || produceDate == ""){
		produceDate = '<%=produce_date %>';
	} 
 
	var retObj = jcdpCallService("WsDailyReportSrv", "getDailyReportInfo", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate);
debugger;
	var retAuditMap = jcdpCallService("WsDailyReportSrv", "getAuditInfo", "dailyNo=<%=daily_no %>");
	if(retAuditMap.auditMap.employeeName!=""){
		document.getElementById("ratifier").innerHTML= retAuditMap.auditMap.employeeName;
	}
	document.getElementById("daily_no").value = retObj.build.dailyNoWs;
	document.getElementById("audit_opinion").value= retAuditMap.auditMap.auditOpinion;
	
	//gp_task_project_dynamic数据
	//alert(retObj.dailyProject.designSurveyNum);TOTAL_SURVEY_SP_NUM

	var design_survey_num=retObj.dailyProject.designSurveyNum;
	document.getElementById("DESIGN_SURVEY_NUM").innerHTML=design_survey_num;
	var design_surface_num=retObj.dailyProject.designSurfaceNum;
	document.getElementById("DESIGN_SURFACE_NUM").innerHTML=design_surface_num;
	var design_drill_num=retObj.dailyProject.designDrillNum;
	document.getElementById("DESIGN_DRILL_NUM").innerHTML=design_drill_num;
	var design_sp_num=retObj.dailyProject.designSpNum;
	document.getElementById("DESIGN_SP_NUM").innerHTML=design_sp_num;
	var measure_km=retObj.dailyProject.measureKm;
	document.getElementById("MEASURE_KM").innerHTML=measure_km;
	
	
	var dailyAcquireCj=retObj.sumDaily.dailyAcquireCj;		
	document.getElementById("dailyAcquireCj").innerHTML=dailyAcquireCj;
	var dailyDrillZj=retObj.sumDaily.dailyDrillZj;		
	document.getElementById("dailyDrillZj").innerHTML=dailyDrillZj;
	var dailySurfaceBc=retObj.sumDaily.dailySurfaceBc;		
	document.getElementById("dailySurfaceBc").innerHTML=dailySurfaceBc;
	var sumCe=retObj.sumDaily.sumCe;		
	document.getElementById("sumCe").innerHTML=sumCe;
	var sumRightCe=retObj.sumDaily.sumRightCe;		
	document.getElementById("sumRightCe").innerHTML=sumRightCe;
	 
	var avg_ce=Math.round(sumCe/design_survey_num*100);
	document.getElementById("avg_ce").innerHTML=avg_ce;
	
	var avg_bc=Math.round(dailySurfaceBc/design_surface_num*100) ;
	document.getElementById("avg_bc").innerHTML=avg_bc;
	
	var avg_zj=Math.round(dailyDrillZj/design_drill_num*100) ;
	document.getElementById("avg_zj").innerHTML=avg_zj;
	
	var avg_cj=Math.round(dailyAcquireCj/design_sp_num*100) ;
	document.getElementById("avg_cj").innerHTML=avg_cj;
	
	
	var project_acquire_sp_pratio=Math.round(sumRightCe/dailyAcquireCj*100) ;
	document.getElementById("PROJECT_ACQUIRE_SP_PRATIO").innerHTML=project_acquire_sp_pratio;
	
	
	
 
	var audit_status=retObj.build.auditStatus;  alert(audit_status) ;
	if(audit_status == "" || audit_status == null) {
		document.getElementById("audit_status").innerHTML = '日报未录入!';
		document.getElementById("tj").style.display="none";
		document.getElementById("gb").style.display="none";
		document.getElementById("cx").colSpan="3";
	} else if(audit_status == "0") {
		document.getElementById("audit_status").innerHTML = '日报还没有提交!';
		document.getElementById("tj").style.display="none";
		document.getElementById("gb").style.display="none";
		document.getElementById("cx").colSpan="3";
	} else if(audit_status == "1") {
		document.getElementById("audit_status").innerHTML = '日报已经提交，等待审批中!';
		document.getElementById("tj").style.display="inline";
		document.getElementById("gb").style.display="inline";
		document.getElementById("cx").colSpan="1";
	} else if(audit_status == "3") {
		document.getElementById("audit_status").innerHTML = '日报已经审批通过!';
		document.getElementById("tj").style.display="none";
		document.getElementById("gb").style.display="none";
		document.getElementById("cx").colSpan="1";
	 
	}else if(audit_status == "4") {
		document.getElementById("audit_status").innerHTML = '日报审批不通过!';
		document.getElementById("tj").style.display="none";
		document.getElementById("gb").style.display="none";
		document.getElementById("cx").colSpan="3";
	 
	}


	var if_build = retObj.build.ifBuild;
	document.getElementById("if_build_value").value=if_build;
	if(if_build == "" || if_build == null){
		document.getElementById("IF_BUILD").innerHTML = '';
	} else if(if_build == "1"){
		document.getElementById("IF_BUILD").innerHTML = '动迁';
	} else if(if_build == "2"){
		document.getElementById("IF_BUILD").innerHTML = '踏勘';
	} else if(if_build == "3"){
		document.getElementById("IF_BUILD").innerHTML = '试验';
	} else if(if_build == "4"){
		document.getElementById("IF_BUILD").innerHTML = '测量';
	} else if(if_build == "5"){
		document.getElementById("IF_BUILD").innerHTML = '钻井';
	} else if(if_build == "6"){
		document.getElementById("IF_BUILD").innerHTML = '采集';
	} else if(if_build == "7"){
		document.getElementById("IF_BUILD").innerHTML = '停工';
		//显示停工原因
		document.getElementById("stop_title").innerHTML = '停工原因:';
		var stop_reason = retObj.dailyMap.STOP_REASON;
		if(stop_reason == "1"){
			document.getElementById("stop_content").innerHTML = '试验';
		}else if(stop_reason == "2"){
			document.getElementById("stop_content").innerHTML = '检修';
		}else if(stop_reason == "3"){
			document.getElementById("stop_content").innerHTML = '组织停工';
		}else if(stop_reason == "4"){
			document.getElementById("stop_content").innerHTML = '自然停工';
		}else if(stop_reason == "5"){
			document.getElementById("stop_content").innerHTML = '其他';
		}
	} else if(if_build == "8"){
		document.getElementById("IF_BUILD").innerHTML = '暂停';
	} else if(if_build == "9"){
		document.getElementById("IF_BUILD").innerHTML = '结束';
	}
 
	var  work_time=retObj.build.workTime;
	var  collect_time=retObj.build.collectTime;
	var  daily_survey_point_num_ws=retObj.build.dailySurveyPointNumWs;
	var  daily_surface_point_num=retObj.build.dailySurfacePointNum;
	var  daily_drill_sp_num=retObj.build.dailyDrillSpNum;
	//alert(retObj.build.drillShotWorkloadWs);
	
	var  drill_shot_workload_ws=retObj.build.drillShotWorkloadWs;
	var  daily_acquire_qualified_num=retObj.build.dailyAcquireQualifiedNum;
	var  fracture_supervise_level_ws=retObj.build.fractureSuperviseLevelWs;
	var  equipment_length_ws=retObj.build.equipmentLengthWs;
	var  daily_acquire_sp_num=retObj.build.dailyAcquireSpNum;
	
	document.getElementById("WORK_TIME").innerHTML=work_time;
	document.getElementById("COLLECT_TIME").innerHTML=collect_time;
	document.getElementById("DAILY_SURVEY_POINT_NUM_WS").innerHTML=daily_survey_point_num_ws;
	document.getElementById("DAILY_SURFACE_POINT_NUM").innerHTML=daily_surface_point_num;
	document.getElementById("DAILY_DRILL_SP_NUM").innerHTML=daily_drill_sp_num;
	document.getElementById("DRILL_SHOT_WORKLOAD_WS").innerHTML=drill_shot_workload_ws;
	document.getElementById("DAILY_ACQUIRE_QUALIFIED_NUM").innerHTML=daily_acquire_qualified_num;
	document.getElementById("FRACTURE_SUPERVISE_LEVEL_WS").innerHTML=fracture_supervise_level_ws;
	document.getElementById("EQUIPMENT_LENGTH_WS").innerHTML=equipment_length_ws;
	document.getElementById("DAILY_ACQUIRE_SP_NUM").innerHTML=daily_acquire_sp_num;
	//alert(ratifier);
	
	var produceDate=retObj.build.produceDate;
	var weather =retObj.build.weather;
	if(weather == "" || weather == null){
		document.getElementById("WEATHER").innerHTML = '';
	} else if(weather == "1"){
		document.getElementById("WEATHER").innerHTML = '晴';
	} else if(weather == "2"){
		document.getElementById("WEATHER").innerHTML = '阴';
	} else if(weather == "3"){
		document.getElementById("WEATHER").innerHTML = '多云';
	} else if(weather == "4"){
		document.getElementById("WEATHER").innerHTML = '雨';
	} else if(weather == "5"){
		document.getElementById("WEATHER").innerHTML = '雾';
	} else if(weather == "6"){
		document.getElementById("WEATHER").innerHTML = '大风';
	} else if(weather == "7"){
		document.getElementById("WEATHER").innerHTML = '霾';
	} else if(weather == "8"){
		document.getElementById("WEATHER").innerHTML = '霜冻';
	} else if(weather == "9"){
		document.getElementById("WEATHER").innerHTML = '暴风';
	} else if(weather == "10"){
		document.getElementById("WEATHER").innerHTML = '台风';
	} else if(weather == "11"){
		document.getElementById("WEATHER").innerHTML = '暴风雪';
	} else if(weather == "12"){
		document.getElementById("WEATHER").innerHTML = '雪';
	} else if(weather == "13"){
		document.getElementById("WEATHER").innerHTML = '雨夹雪';
	} else if(weather == "14"){
		document.getElementById("WEATHER").innerHTML = '冰雹';
	} else if(weather == "15"){
		document.getElementById("WEATHER").innerHTML = '浮尘';
	} else if(weather == "16"){
		document.getElementById("WEATHER").innerHTML = '扬沙';
	} else if(weather == "17"){
		document.getElementById("WEATHER").innerHTML = '其他';
	}  
	document.getElementById("produceDate").value=produceDate;
  

	//debugger;
	 
	
 
}
 
function toSubmit(){
	//debugger;
	var form = document.getElementById("form1");
	var projectInfoNo = '<%=project_info_no %>';
	var dailyNo = '<%=daily_no %>';
	produceDate = document.getElementById("produceDate").value;
 
 //form.action="<%=contextPath%>/pm/dailyReport/submitDailyReport.srq?projectInfoNo="+projectInfoNo+"&dailyNo="+dailyNo+"produceDate="+produceDate;
	var retObj = jcdpCallService("WsDailyReportSrv", "submitDailyReport", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate);
	
 
	//form.action="<%=contextPath%>/pm/dailyReport/submitDailyReport.srq?projectInfoNo="+projectInfoNo+"&dailyNo="+dailyNo+"produceDate="+produceDate;
//	var retObj = jcdpCallService("WsDailyReportSrv", "submitDailyReport", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate+"&survey_process_status="+survey_process_status+"&surface_process_status="+surface_process_status+"&drill_process_status="+drill_process_status+"&collect_process_status="+collect_process_status);
	var retObj = jcdpCallService("WsDailyReportSrv", "submitDailyReport", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate);
	top.frames('list').refreshData();
 
	page_init();
}



function toQueryQuestion(){
	var produceDate = document.getElementById("produceDate").value;
	popWindow("<%=contextPath%>/ws/pm/dailyReport/singleProject/dailyQuestionList.jsp?projectInfoNo=<%=project_info_no %>&produceDate="+produceDate);
}

function audit(auditStatus){
	debugger;
	var form = document.getElementById("form1");
	var projectInfoNo = '<%=project_info_no %>';
	var dailyNo = '<%=daily_no %>';
	var produceDate = document.getElementById("produceDate").value;
	var daily_no = document.getElementById("daily_no").value;
	var if_build = document.getElementById("if_build_value").value
	var audit_opinion = document.getElementById("audit_opinion").value;
	var retObj = jcdpCallService("WsDailyReportSrv", "auditDailyReport", "dailyNo="+daily_no+"&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate+"&audit_status="+auditStatus+"&if_build="+if_build+"&audit_opinion="+audit_opinion);
	top.frames[5].refreshData();
	page_init();
}
</script>
<body onload="page_init()" style="overflow:scroll;">
		<div id="tab_box" class="tab_box" >
			<div id="tab_box_content0" class="tab_box_content">
				<form id="form1"  method="post">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">生产日期：</td>	
						<td class="inquire_form8">
							<input type="hidden" name="daily_no" id="daily_no"/>
							<input type="text" name="produceDate" id='produceDate' value='' readonly="readonly"/>&nbsp;&nbsp;
							<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(produceDate,tributton1);" />&nbsp;&nbsp;
							<font color="red" style="text-align: right;" id="audit_status">审批通过</font>
						</td>
						<td class="inquire_form4">&nbsp;</td>
						<auth:ListButton tdid="cx" functionId="" css="cx" event="onclick='query_data()'" title="JCDP_btn_query"></auth:ListButton>
						<auth:ListButton tdid="tj" display="none" functionId="" css="tj" event="onclick='audit(3)'" title="JCDP_btn_audit"></auth:ListButton>
		    			<auth:ListButton tdid="gb" display="none" functionId="" css="gb" event="onclick='audit(4)'" title="JCDP_btn_audit"></auth:ListButton>
		    			</tr>
				</table>
				</form>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="audit">
					<tr style="background-color: #97cbfd">
					 	<td class="inquire_item6" >审批人:</td>
					 	<td class="inquire_form6" colspan="5" id='ratifier' name="ratifier"  ></td>
					 </tr>
					 <tr class="odd">
					 	<td class="inquire_item6">审批意见</td>
					 	<td class="inquire_form6"  colspan="5">
					 		<textarea type="text"  rows="4" style="width:100%;" readonly="readonly" id="audit_opinion"></textarea>
					 	</td>
					 </tr>
				 </table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr class="even">
						<td class="inquire_item6">项目状态：</td><input type="hidden" value="" id="if_build_value"/>
						<td class="inquire_form6" id="IF_BUILD"></td>
						<td class="inquire_item6">天气：</td>
						<td class="inquire_form6" name="WEATHER" id='WEATHER' value='' ></td>
						<td class="inquire_item6">&nbsp;</td>
						<td class="inquire_form6">&nbsp;</td>
					</tr>
					<tr class="odd">
						<td class="inquire_item6">施工时长(小时)：</td>
						<td class="inquire_form6" id="WORK_TIME"></td>
						<td class="inquire_item6">采集时间(小时)：</td>
						<td class="inquire_form6" id="COLLECT_TIME"></td>
						<td class="inquire_item6">日检时间(小时)：</td>
						<td class="inquire_form6" id="DAY_CHECK_TIME"></td>
					</tr>
					<!--
					<tr class="even">
						<td class="inquire_item6">合同化用工：</td>
						<td class="inquire_form6" id="WORKMAN_NUM"></td>
						<td class="inquire_item6">市场化用工：</td>
						<td class="inquire_form6" id="OUT_EMPLOYEE_NUM"></td>
						<td class="inquire_item6">季节性用工：</td>
						<td class="inquire_form6" id="SEASON_EMPLOYEE_NUM"></td>
					</tr>
					 -->
				</table>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">测量工作量：</td>
						 
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<!--  
					<tr class="even">
						<td class="inquire_item8">日完成炮点数：</td>
						<td class="inquire_form8" id="DAILY_SURVEY_SHOT_NUM"></td>
						<td class="inquire_item8">累计完成炮点数：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_SHOT_NUM"></td>
						<td class="inquire_item8">设计炮点数：</td>
						<td class="inquire_form8" id="DESIGN_SP_NUM1"></td>
						<td class="inquire_item8">日完成总点数：</td>
						<td class="inquire_form8" id="DAILY_SURVEY_TOTAL_NUM"></td>
					</tr>
					-->
					<tr class="odd">
						<td class="inquire_item8">日完成测点数：</td>
						<td class="inquire_form8" id="DAILY_SURVEY_POINT_NUM_WS"></td>
						<td class="inquire_item8">累计完成测点数：</td>
						<td class="inquire_form8" id="sumCe"></td>
						<td class="inquire_item8">设计完成测点数：</td>
						<td class="inquire_form8" id="DESIGN_SURVEY_NUM"></td>
						<td class="inquire_item8">完成%：</td>
						<td class="inquire_form8" id="avg_ce"></td>
					</tr>
					<!--  
					<tr class="even">
						<td class="inquire_item8">日完成接收线公里数：</td>
						<td class="inquire_form8" id="SURVEY_INCEPT_WORKLOAD"></td>
						<td class="inquire_item8">日完成炮线公里数：</td>
						<td class="inquire_form8" id="SURVEY_SHOT_WORKLOAD"></td>
						<td class="inquire_item8">累计接收线公里数：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_INCEPT_WORKLOAD"></td>
						<td class="inquire_item8">累计炮线公里数：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_SHOT_WORKLOAD"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">设计总公里数：</td>
						<td class="inquire_form8" id="MEASURE_KM"></td>
						<td class="inquire_item8">测量总公里完成%：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_KM_RATIO"></td>
						<td class="inquire_item8">累计测量公里数: </td>
						<td class="inquire_form8" id="PROJECT_SURVEY_TOTAL_WORKLOAD"></td>
						<td class="inquire_item8">&nbsp;</td>
						<td class="inquire_form8">&nbsp;</td>
					</tr>
					-->
					
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="survey">
					<tr>
						<td class="bt_info_odd"></td>
						
					</tr>
				</table>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">表层工作量：</td>
						<!-- <td class="inquire_form8"><select class="select_width" name="surface_process_status" id="surface_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td> -->
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr class="odd">
						<td class="inquire_item8">日完成点数：</td>
						<td class="inquire_form8" id="DAILY_SURFACE_POINT_NUM"></td>
						<td class="inquire_item8">累计完成点数：</td>
						<td class="inquire_form8" id="dailySurfaceBc"></td>
						<td class="inquire_item8">设计完成点数：</td>
						<td class="inquire_form8" id="DESIGN_SURFACE_NUM"></td>
						<td class="inquire_item8">完成%：</td>
						<td class="inquire_form8" id="avg_bc"></td>
					</tr>
					 
					
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="surface">
					<tr>
						<td class="bt_info_odd"></td>
					
					</tr>
				</table>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="drill_tab">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">钻井工作量：</td>
						<!-- <td class="inquire_form8"><select class="select_width" name="drill_process_status" id="drill_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td> -->
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="drill_info">
					<tr class="even">
						<td class="inquire_item8">日完成炮点数：</td>
						<td class="inquire_form8" id="DAILY_DRILL_SP_NUM"></td>
						<td class="inquire_item8">项目累计完成炮点数：</td>
						<td class="inquire_form8" id="dailyDrillZj"></td>
						<td class="inquire_item8">设计点数：</td>
						<td class="inquire_form8" id="DESIGN_DRILL_NUM"></td>
						<td class="inquire_item8">完成%：</td>
						<td class="inquire_form8" id="avg_zj"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">日完成公里数：</td>
						<td class="inquire_form8" id="DRILL_SHOT_WORKLOAD_WS"></td>
						<td class="inquire_item8">项目累计完成公里数：</td>
						<td class="inquire_form8" id="PROJECT_SURVEY_SHOT_WORKLOAD"></td>
						<td class="inquire_item8">设计公里数：</td>
						<td class="inquire_form8" id="MEASURE_KM"></td>
						<td class="inquire_item8"></td>
						<td class="inquire_form8" id="tt"></td>
						
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="drill_tab">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">采集工作量：</td>
						<!-- <td class="inquire_form8"><select class="select_width" name="drill_process_status" id="drill_process_status"><option value="1">未开始</option><option value="2">正在施工</option><option value="3">结束</option></select></td> -->
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="drill_info">
					<tr class="even">
						<td class="inquire_item8">日完成炮点数：</td>
						<td class="inquire_form8" id="DAILY_ACQUIRE_SP_NUM"></td>
						<td class="inquire_item8">累计完成炮数：</td>
						<td class="inquire_form8" id="dailyAcquireCj"></td>
						<td class="inquire_item8">设计炮数：</td>
						<td class="inquire_form8" id="DESIGN_SP_NUM"></td>
						<td class="inquire_item8">完成%：</td>
						<td class="inquire_form8" id="avg_cj"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">日完成合格炮：</td>
						<td class="inquire_form8" id="DAILY_ACQUIRE_QUALIFIED_NUM"></td>
						<td class="inquire_item8">累计完成合格炮：</td>
						<td class="inquire_form8" id="sumRightCe"></td>
						<td class="inquire_item8">合格炮率%：</td>
						<td class="inquire_form8" id="PROJECT_ACQUIRE_SP_PRATIO"></td>
						<td class="inquire_item8"></td>
						<td class="inquire_form8" id="tt"></td>
						
					</tr>
				
				</table>
			
			 
					<table>
					
						<tr class="even">
						<td class="inquire_item6">压裂监测井段：</td>
						<td class="inquire_form6" id="FRACTURE_SUPERVISE_LEVEL_WS"></td>
						<td class="inquire_item6">仪器下放深度：</td>
						<td class="inquire_form6" id="EQUIPMENT_LENGTH_WS"></td>
						<td class="inquire_item6"></td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD"></td>
						<td class="inquire_item6"></td>
						<td class="inquire_form6" id="DAILY_JP_ACQUIRE_WORKLOAD"></td>
					</tr>
					</table>
					
			 
				 
				 
			</div>
		</div>
</body>

<script type="text/javascript">


	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function cancel() {
		window.close();
	}

	function save() {
		//if (!checkForm()) return;
		document.getElementById("form1").submit();
	}

	function refreshData() {
		//var ctt = top.frames('list').frames[1];
		//var file_name = document.getElementsByName("file_name")[0].value;
		//ctt.refreshData(undefined, file_name);
		//newClose();
		document.getElementById("form1").submit();
		newClose();
	}
</script>
</html>