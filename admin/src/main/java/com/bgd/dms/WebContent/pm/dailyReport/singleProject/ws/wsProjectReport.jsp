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
	if(projectInfoNo == null || "".equals(projectInfoNo)||projectName==null||"".equals(projectName)){
		
		 
		projectInfoNo = user.getProjectInfoNo();
		projectName = user.getProjectName();
		orgName = user.getOrgName();
		 
	}
	 
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
 

	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	 function page_init(){
		 debugger;
		 var retFn = jcdpCallService("WsDailyReportSrv", "getProjectFn", "projectInfoNo=<%=projectInfoNo%>");
		 if(retFn.projectFn.projectFatherNo==""){
			 alert("年度项目不能填写井报");
			 document.getElementById("bcBtn").style.display="none";
			 
		 } 
		 var retObj = jcdpCallService("WsDailyReportSrv", "getProjectReport", "projectInfoNo=<%=projectInfoNo%>");

		
		 if(retObj!=""&&retObj.projectMap!=null){
		 
			  debugger;
			 document.getElementById("start_date").disabled=true;
			 document.getElementById("end_date").disabled=true;
			 document.getElementById("if_build").disabled=true;
			 document.getElementById("collection_series").disabled=true;
			 document.getElementById("results_shot_number").disabled=true;
			 document.getElementById("shot_number").disabled=true;	 
			 document.getElementById("obs_point").disabled=true;
			 document.getElementById("check_shot_number").disabled=true;
			 document.getElementById("qu_point").disabled=true;
			 document.getElementById("qualified_products").disabled=true;
			 document.getElementById("waste_point").disabled=true;
			 document.getElementById("small_refraction").disabled=true;
			 document.getElementById("micro_logging").disabled=true;
			 document.getElementById("edit_button").style.display="inline";
		  
			 var startDate=retObj.projectMap.startDate;
				document.getElementById("start_date").value=startDate;
				document.getElementById("daily_pd_ws").value=retObj.projectMap.dailyPdWs;
		 var endDate=retObj.projectMap.endDate;
	
				document.getElementById("end_date").value=endDate;
		 
		 var ifBuild=retObj.projectMap.ifBuild;
		 
				document.getElementById("if_build").value=ifBuild;
		 
		 var collectionSeries=retObj.projectMap.collectionSeries;
		 
				document.getElementById("collection_series").value=collectionSeries;
		 
		 var shotNumber=retObj.projectMap.shotNumber;
		 
				document.getElementById("shot_number").value=shotNumber;
		 
		 var resultsShotNumber=retObj.projectMap.resultsShotNumber;
		 
				document.getElementById("results_shot_number").value=resultsShotNumber;
	 
		 var checkShotNumber=retObj.projectMap.checkShotNumber;
		 
				document.getElementById("check_shot_number").value=checkShotNumber;
		 
		 var obsPoint=retObj.projectMap.obsPoint;
		  
				document.getElementById("obs_point").value=obsPoint;
	 
		 var quPoint=retObj.projectMap.quPoint;
		 
				document.getElementById("qu_point").value=quPoint;
		 
		 var qualifiedProducts=retObj.projectMap.qualifiedProducts;
		 
				document.getElementById("qualified_products").value=qualifiedProducts;
		 
		 var wastePoint=retObj.projectMap.wastePoint;
		 
				document.getElementById("waste_point").value=wastePoint;
		 
		 var smallRefraction=retObj.projectMap.smallRefraction;
		 
				document.getElementById("small_refraction").value=smallRefraction;
	 
		 var microLogging=retObj.projectMap.microLogging;
		 
				document.getElementById("micro_logging").value=microLogging;
				
		 }else{
			 document.getElementById("edit_button").style.display="none"
		 }
	 }
	function forEdit(){
		document.getElementById("edit_button").disabled=true;
		 document.getElementById("start_date").disabled=false;
		 document.getElementById("end_date").disabled=false;
		 document.getElementById("if_build").disabled=false;
		 document.getElementById("collection_series").disabled=false;
		 document.getElementById("results_shot_number").disabled=false;
		 document.getElementById("shot_number").disabled=false;	 
		 document.getElementById("obs_point").disabled=false;
		 document.getElementById("check_shot_number").disabled=false;
		 document.getElementById("qu_point").disabled=false;
		 document.getElementById("qualified_products").disabled=false;
		 document.getElementById("waste_point").disabled=false;
		 document.getElementById("small_refraction").disabled=false;
		 document.getElementById("micro_logging").disabled=false;
		 document.getElementById("edit_button").style.display="inline";
	}
	function valiShot(){
		debugger;
		var shot_number = $("#shot_number").val();
		var results_shot_number=$("#results_shot_number").val();
		var check_shot_number=$("#check_shot_number").val();
		if(shot_number==""){
			shot_number="0";
		}
		if(results_shot_number==""){
			results_shot_number="0";
		}
		if(check_shot_number==""){
			check_shot_number="0";
		}
		
		var dd=parseInt(shot_number)+parseInt(results_shot_number)+parseInt(check_shot_number);
		document.getElementById("obs_point").value=dd;
	 
	}
		
 
 
 
 
 
	
	function goNext(){
		
		//debugger;
		var start_date = $("#start_date").val();
		if(start_date==""){
			alert("开工日期不能为空!");
			return false;
		}
		var end_date = $("#end_date").val();
		if(end_date == ""){
			alert("收工日期不能为空!");
			return false;
		}
		var if_build = $("#if_build").val();
		 
		if(if_build== ""){
			alert("激发方式不能为空!");
			return false;
		}
		var collection_series = $("#collection_series").val();
		 
		if( collection_series == ""){
			alert("采集级数不能为空!");
			return false;
		}
		var shot_number = $("#shot_number").val();
		 
		if( shot_number == ""){
			alert("炮数不能为空!");
			return false;
		}
		
		var results_shot_number = $("#results_shot_number").val();
		 
		if( results_shot_number == ""){
			alert("试验炮数不能为空!");
			return false;
		}
		var check_shot_number = $("#check_shot_number").val();
		 
		if( check_shot_number == ""){
			alert("考核炮数不能为空!");
			return false;
		}
		var obs_point = $("#obs_point").val();
		 
		if( obs_point == ""){
			
			alert("总观测点数不能为空!");
			return false;
		}
		 //alert(obs_point);
		var qu_point = $("#qu_point").val();
		 
		if( qu_point == ""){
			alert("优级品点数不能为空!");
			return false;
		}
		var qualified_products = $("#qualified_products").val();
		 
		if( qualified_products == ""){
			alert("合格品数不能为空!");
			return false;  
		}
		var waste_point = $("#waste_point").val();
		 
		if( waste_point == ""){
			alert("废空点数不能为空!");
			return false; 
		} 
		var small_refraction = $("#small_refraction").val();
		 
		if( small_refraction == ""){
			alert("小折射数不能为空!");
			return false; 
		}
		var micro_logging = $("#micro_logging").val();
		 
		if( micro_logging == ""){
			alert("微测井不能为空!");
			return false; 
		}
		document.form1.submit();
	}
	
	    
</script>

<body style="background:#fff"  onload="page_init()">

<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">  
	<tr class="tongyong_box_title">
		<td colspan="6" align="left"><span>&nbsp;&nbsp;<font size="2">井报基本信息</font></span></td>
	</tr>
  	<tr class="even">
	    <td class="inquire_item6">施工队伍：</td>
	    <td class="inquire_form6"id="td_team_name"></td>
    	<td class="inquire_item6">项目信息：</td>
		<td class="inquire_form6"><%=projectName %></td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6" >
			<input id="edit_button" type="button" name="button2" value="编辑" onClick="forEdit()" class="myButton" style="display: none;"/>&nbsp;&nbsp;&nbsp;
			<input type="button" id="bcBtn" name="button2" value="保存"  class="myButton"  onclick="goNext()"/>
		</td>
	</tr> 
</table>
<form name="form1" action="<%=contextPath%>/pm/dailyReport/singleProject/ws/saveOrUpdateWsProjectReport.srq" method="post">

<input id="project_info_no" name="project_info_no" value="<%=projectInfoNo %>" type="hidden" />
<input id="daily_pd_ws" name="daily_pd_ws" type="hidden"/>
 


<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
<tr class="odd">
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;开工日期:</td>
		<td class="inquire_form6"><input type="text" name='start_date' id='start_date' value=''   readonly/>&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1"  name="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector('start_date',tributton1);" /></td>
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;收工日期:</td>
		<td class="inquire_form6"><input type="text" name='end_date' id='end_date' value=''    readonly/>&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2"  name="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector('end_date',tributton2);" /></td>
		
		
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;激发方式:</td>
		<td class="inquire_form6">
			<select name="if_build" id="if_build" class="select_width"  >
				<option value="">请选择</option>
				<option value="1">观测方式观测</option>
				<option value="2">井段观测点距</option>
 			</select>
		</td>
	</tr>
	<tr class="odd">
	 	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;采集级数（级）:</td>
	  	<td class="inquire_form6"><input type="text" name="collection_series" id="collection_series"/></td>
	  	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;炮数:</td>
	  	<td class="inquire_form6"><input type="text" name="shot_number" id="shot_number"  onchange="valiShot()"/></td>
	  	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;试验炮数:</td>
	  	<td class="inquire_form6"><input type="text" name="results_shot_number" id="results_shot_number"  onchange="valiShot()"/></td>
	 </tr>
	 <tr class="odd">
	 	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;考核炮数:</td>
	  	<td class="inquire_form6"><input type="text" name="check_shot_number" id="check_shot_number"  onchange="valiShot()"/></td>
	  	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;总观测点数:</td>
	  	<td class="inquire_form6"><input type="text" name="obs_point" id="obs_point" readonly="readonly" /></td>
	  	<td class="inquire_item6" ><font style="color:red">*</font>&nbsp;优级品点数:</td>
	  	<td class="inquire_form6"><input type="text" name="qu_point" id="qu_point"/></td>
	 </tr>
	  <tr class="odd">
	 	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;合格品点数:</td>
	  	<td class="inquire_form6"><input type="text" name="qualified_products" id="qualified_products"/></td>
	  	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;废空点数:</td>
	  	<td class="inquire_form6"><input type="text" name="waste_point" id="waste_point"/></td>
	  	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;小折射:</td> 
	  	<td class="inquire_form6"><input type="text" name="small_refraction" id="small_refraction"/></td>
	 </tr>
	 <tr class="odd">
	   	<td class="inquire_item6"><font style="color:red">*</font>&nbsp;微测井（口）:</td>
	  	<td class="inquire_form6"><input type="text" name="micro_logging" id="micro_logging"/></td>
	 </tr>
</table>
 


<script type="text/javascript">

//获取施工队伍名称

getProjectTeam();

function getProjectTeam(){
	var retObj = jcdpCallService("WtDailyReportSrv", "getProjectTeamName", "projectInfoNo=<%=projectInfoNo %>");
	if(retObj != null && retObj.teamName != null){
		$("#td_team_name").html(retObj.teamName);
	}
}
</script>
</form>
</body>
</html>