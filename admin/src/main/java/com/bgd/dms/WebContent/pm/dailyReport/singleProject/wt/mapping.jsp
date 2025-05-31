<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page import="com.bgp.mcs.service.wt.pm.service.dailyReport.WtResourceAssignmentSrv" %>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.*"%>
<%@ page  import="java.net.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>

<%


	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	List LaborList = respMsg.getMsgElements("LaborList");//人工
	List NonlaborList = respMsg.getMsgElements("NonlaborList");//非人工
	List MaterialLlist = respMsg.getMsgElements("MaterialLlist");//材料
	
	List WorkLoadLlist = respMsg.getMsgElements("WorkLoadLlist");//工作量
	
	String produceDate = request.getParameter("produceDate");

	String projectInfoNo = request.getParameter("projectInfoNo");
	System.out.print("++++++++++++++"+projectInfoNo);
	String flag = respMsg.getValue("flag");
	
 System.out.print(flag);
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getOrgId();
	
	if(produceDate == null || "".equals(produceDate)) {
		produceDate = respMsg.getValue("produceDate");
		System.out.print(produceDate+"-=-=-==-=-=---==");
	}
	if(projectInfoNo == null || "".equals(projectInfoNo)) {
		projectInfoNo = respMsg.getValue("projectInfoNo");
		System.out.print(projectInfoNo);
	}
	if(orgId == null || "".equals(orgId)) {
		orgId = respMsg.getValue("orgId");
	}
	if(flag == null || "".equals(flag)) {
		flag = request.getParameter("flag");
	}
	if(flag == null || "".equals(flag)) {
		flag = "Submited";
	}
	
	List list = respMsg.getMsgElements("list");
	for(int i=0;i<list.size();i++){
		Object bj=(Object)list.get(i);
		System.out.print(list.size());
	}
	MsgElement msg1 = (MsgElement)list.get(0);
	Map map1 = msg1.toMap();
	String stautsIn = (String)map1.get("STATUS");
	System.out.print(stautsIn);
	String activity_object_id = (String) map1.get("OBJECT_ID");

	String remainingDuration = respMsg.getValue("remainingDuration");
	//map1.put("PLANNED_DURATION", "32");
	//map1.put("HOURS_PER_DAY", "8");
	String taskName = URLDecoder.decode(respMsg.getValue("taskname"),"UTF-8");
 
	String message = "";
	if(flag == "Saved" || "Saved".equals(flag)){
		message = "未提交";
	} else if(flag == "Submited" || "Submited".equals(flag)){
		message = "已提交";
	} else if(flag == "Passed" || "Passed".equals(flag)){
		message = "审批通过";
	} else if(flag == "notPassed" || "notPassed".equals(flag)){
		message = "审批未通过";
	} else {
		message = "未保存";
	}

	  
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>列表页面</title>
</head>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/styles/calendar-blue.css"  />	

<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<!-- 上传控件相关的js css-->
<link rel="stylesheet" href="<%=contextPath %>/js/upload/uploadify.css" type="text/css"></link>
<script type="text/javascript" src="<%=contextPath %>/js/upload/jquery.uploadify.v2.1.4.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/upload/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/upload/uploadfile.js"></script>

<link id="artDialogSkin" href="<%=contextPath %>/js/artDialog/skins/blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/artDialog.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/iframeTools.js"></script>
<script type="text/javascript">

function viewPicture(path){
	//alert(path);
	//alert('<img src="'+path+'" width="450" height="175" />');
	 art.dialog({
		    padding: 0,
		    title: '图片',
		    content: '<img  src="'+path+'" width="500" height="330" />',
		    lock: true
		});
}
function deleteImage(){
	$("#idDelete").val("yes");
	$("#imgFileName").hide();
}

debugger;

var retObj = jcdpCallService("WtProjectSrv", "getProjectExploration", "projectInfoNo=<%=projectInfoNo%>");
var retObjWt = jcdpCallService("WtDailyReportSrv", "getStatus", "projectInfoNo=<%=projectInfoNo%>&produceDate=<%=produceDate %>");

var retObjTask = jcdpCallService("WtDailyReportSrv", "getActivityName", "projectInfoNo=<%=projectInfoNo %>&activityId=<%=activity_object_id%>");

function tt(){	
	debugger;
		if(retObjTask.daily_map!=null){
			var retObjEx = jcdpCallService("WtDailyReportSrv", "getMappingMethod", "projectInfoNo=<%=projectInfoNo %>&activityId=<%=activity_object_id%>");
			if(retObjEx.daily_map!=null){
				debugger;
				var codingName=retObjEx.daily_map.codingName;
				var explorationMethod=retObjEx.daily_map.explorationMethod;
				 document.getElementById("wtEx").innerHTML =codingName;
				 document.getElementById("exploration_method").value =explorationMethod;
				 document.getElementById("exploration_method_name").value =codingName;

				 if(explorationMethod!=null&&explorationMethod!=""&&explorationMethod!="5110000056000000045"){
						$("#uploadImageTr").show();	  
					 }
			}

			if(explorationMethod!=" "&&explorationMethod!=null){
					var retObj = jcdpCallService("WtResourceAssignmentSrv", "queryInstrumen", "projectInfoNo=<%=projectInfoNo %>&produceDate=<%=produceDate %>&explorationMethod="+explorationMethod);	
			 
			}

	  		if(retObj!=null&&retObj!=""){
			 	 if(retObj.ucmId!=null&&retObj.ucmId!=""){
					 $("#imgFileName").html("<span title=\"查看\" style=\"cursor: pointer;\" onclick=\"viewPicture('"+retObj.imagePath+"')\">"+retObj.fileName+"</span><input id=\"imageD\" onclick=\"deleteImage()\" value=\"删除\" type=\"button\"/> "
							 +"  <input onclick=\"window.location ='<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj.ucmId+"';\" type=\"button\" value=\"下载\" />");		  

							$("#ucmIdValue").val(retObj.ucmId);
							
							if("2"==retObj.isNowDate){
								
								$("#imageD").hide();
							}
						
				}

		    if(document.getElementById("iMethod").value=="重力"&&retObj.daily_map1!=null){
			   debugger;
				if(retObj.daily_map1.taskStatus=="2"){
					debugger;
				    	var wtStop=retObj.daily_map1.stopReason;
				    	document.getElementById("iBuild").value=retObj.daily_map1.taskStatus;
					    document.getElementById("td1").style.display="inline";
			 
						document.getElementById("stop_reason").value=wtStop;
			 
						document.getElementById("queryRetTable").style.display="none"; 
				}else if(retObj.daily_map1.taskStatus=="3"){
					    var wtPause=retObj.daily_map1.pauseReason;
					    document.getElementById("iBuild").value=retObj.daily_map1.taskStatus;
					    document.getElementById("td2").style.display="inline";
					    document.getElementById("td1").style.display="none";
						document.getElementById("pause_reason").value=wtPause;
						document.getElementById("queryRetTable").style.display="none"; 
				}else{
					 
					    document.getElementById("iBuild").value=retObj.daily_map1.taskStatus;
				}
			

			   var dailyAll=retObj.daily_map1.dailyInstrumentAll;
			   var dailyUse=retObj.daily_map1.dailyInstrumentUse;
			   document.getElementById("G6602").value=dailyUse;
			   document.getElementById("G6602all").value=dailyAll;
		    }
		   if(document.getElementById("iMethod").value=="磁力"&&retObj.daily_map2!=null){
			 
				
				if(retObj.daily_map2.taskStatus=="2"){
			    	var wtStop=retObj.daily_map2.stopReason;
			    	document.getElementById("iBuild").value=retObj.daily_map2.taskStatus;
				    document.getElementById("td1").style.display="inline";
 
					document.getElementById("stop_reason").value=wtStop;
			 
					document.getElementById("queryRetTable").style.display="none"; 
			}else if(retObj.daily_map2.taskStatus=="3"){
				    var wtPause=retObj.daily_map2.pauseReason;
				    document.getElementById("iBuild").value=retObj.daily_map2.taskStatus;
				    document.getElementById("td2").style.display="inline";
				    document.getElementById("td1").style.display="none";
					document.getElementById("pause_reason").value=wtPause;
					document.getElementById("queryRetTable").style.display="none"; 
			}else{
				   
				    document.getElementById("iBuild").value=retObj.daily_map2.taskStatus;
			}
			   var dailyAll=retObj.daily_map2.dailyInstrumentAll;
			   var dailyUse=retObj.daily_map2.dailyInstrumentUse;
			   document.getElementById("G6603").value=dailyUse;
			   document.getElementById("G6603all").value=dailyAll;
		   }
		   if(document.getElementById("iMethod").value=="天然"&&retObj.daily_map3!=null){
				
				
				if(retObj.daily_map3.taskStatus=="2"){
			    	var wtStop=retObj.daily_map3.stopReason;
			    	document.getElementById("iBuild").value=retObj.daily_map3.taskStatus;
				    document.getElementById("td1").style.display="inline";
			 
					document.getElementById("stop_reason").value=wtStop;
 
					document.getElementById("queryRetTable").style.display="none"; 
			}else if(retObj.daily_map3.taskStatus=="3"){
				    var wtPause=retObj.daily_map3.pauseReason;
				    document.getElementById("iBuild").value=retObj.daily_map3.taskStatus;
				    document.getElementById("td2").style.display="inline";
				    document.getElementById("td1").style.display="none";
					document.getElementById("pause_reason").value=wtPause;
					document.getElementById("queryRetTable").style.display="none"; 
			}else{
				  
				    document.getElementById("iBuild").value=retObj.daily_map3.taskStatus;
			}
			   var dailyAll=retObj.daily_map3.dailyInstrumentAll;
			   var dailyUse=retObj.daily_map3.dailyInstrumentUse;
			   document.getElementById("G6605").value=dailyUse;
			   document.getElementById("G6605all").value=dailyAll;
		   }
		   if(document.getElementById("iMethod").value=="人工"&&retObj.daily_map4!=null){			
				if(retObj.daily_map4.taskStatus=="2"){
			    	var wtStop=retObj.daily_map4.stopReason;
			    	document.getElementById("iBuild").value=retObj.daily_map4.taskStatus;
				    document.getElementById("td1").style.display="inline";
			 
					document.getElementById("stop_reason").value=wtStop;
		 
					document.getElementById("queryRetTable").style.display="none"; 
			}else if(retObj.daily_map4.taskStatus=="3"){
				    var wtPause=retObj.daily_map4.pauseReason;
				    document.getElementById("iBuild").value=retObj.daily_map4.taskStatus;
				    document.getElementById("td2").style.display="inline";
				    document.getElementById("td1").style.display="none";
					document.getElementById("pause_reason").value=wtPause;
					document.getElementById("queryRetTable").style.display="none"; 
			}else{
				 
				    document.getElementById("iBuild").value=retObj.daily_map4.taskStatus;
			}
			   var dailyAll=retObj.daily_map4.dailyInstrumentAll;
			   var dailyUse=retObj.daily_map4.dailyInstrumentUse;
			   document.getElementById("G6604").value=dailyUse;
			   document.getElementById("G6604all").value=dailyAll;
		   }
		   if(document.getElementById("iMethod").value=="化学"&&retObj.daily_map5!=null){
				
				if(retObj.daily_map5.taskStatus=="2"){
			    	var wtStop=retObj.daily_map5.stopReason;
			    	document.getElementById("iBuild").value=retObj.daily_map5.taskStatus;
				    document.getElementById("td1").style.display="inline";
			 
					document.getElementById("stop_reason").value=wtStop;
		 
					document.getElementById("queryRetTable").style.display="none"; 
			}else if(retObj.daily_map5.taskStatus=="3"){
				    var wtPause=retObj.daily_map5.pauseReason;
				    document.getElementById("iBuild").value=retObj.daily_map5.taskStatus;
				    document.getElementById("td2").style.display="inline";
				    document.getElementById("td1").style.display="none";
					document.getElementById("pause_reason").value=wtPause;
					document.getElementById("queryRetTable").style.display="none"; 
			}else{
				  
				    document.getElementById("iBuild").value=retObj.daily_map5.taskStatus;
			}
			   var dailyAll=retObj.daily_map5.dailyInstrumentAll;
			   var dailyUse=retObj.daily_map5.dailyInstrumentUse;
			   document.getElementById("G6606").value=dailyUse;
			   document.getElementById("G6606all").value=dailyAll;
			 
		   }
		   if(document.getElementById("iMethod").value=="工程"&&retObj.daily_map6!=null){
			   
				if(retObj.daily_map6.taskStatus=="2"){
			    	var wtStop=retObj.daily_map6.stopReason;
			    	document.getElementById("iBuild").value=retObj.daily_map6.taskStatus;
				    document.getElementById("td1").style.display="inline";
			 
					document.getElementById("stop_reason").value=wtStop;
				 
					document.getElementById("queryRetTable").style.display="none"; 
			}else if(retObj.daily_map6.taskStatus=="3"){
				    var wtPause=retObj.daily_map6.pauseReason;
				    document.getElementById("iBuild").value=retObj.daily_map6.taskStatus;
				    document.getElementById("td2").style.display="inline";
				    document.getElementById("td1").style.display="none";
					document.getElementById("pause_reason").value=wtPause;
					document.getElementById("queryRetTable").style.display="none"; 
			}else{
				  
				    document.getElementById("iBuild").value=retObj.daily_map6.taskStatus;
			}
			   var dailyAll=retObj.daily_map6.dailyInstrumentAll;
			   var dailyUse=retObj.daily_map6.dailyInstrumentUse;
			   document.getElementById("G6607").value=dailyUse;
			   document.getElementById("G6607all").value=dailyAll;
		   }   
	  }
	} 
}


function changeStartStatus(){
	var start_date = $("#start_date").val();
	var end_date = $("#finish_date").val();
	if(start_date == ""){
		$("#status").val("Not Started");
		$("#activityStatus").html("未开始");
	}else{
		if(end_date == ""){
			$("#status").val("In Progress");
			$("#activityStatus").html("运行");
		}else{
			if(end_date < start_date){
				alert("开始时间不能大于结束时间");
				$("#start_date").val("");
				return;
			}
			$("#status").val("Completed");
			$("#activityStatus").html("完成");
		}	
	}
}

function changeEndStatus(){
	var end_date = $("#finish_date").val();
	var start_date = $("#start_date").val();
	if(start_date == ""){
		if(end_date != ""){
			alert("开始时间未填写,不能填写结束时间");
			$("#finish_date").val("");
			return;
		}
	}else{
		if(end_date == ""){
			$("#status").val("In Progress");
			$("#activityStatus").html("运行");
		}else{
			if(end_date < start_date){
				alert("结束时间不能小于开始时间");
				$("#finish_date").val("");
				$("#status").val("In Progress");
				$("#activityStatus").html("运行");
				return;
			}
			$("#status").val("Completed");
			$("#activityStatus").html("完成");
		}
	}
}

function change(object_id){
	var value = document.getElementById('budgeted_units'+object_id).value;
	document.getElementById('in'+object_id).value = value;
	var num = new Number(value*document.getElementById('remaining_duration'+<%=activity_object_id%>).value);
	document.getElementById('REMAINING_UNITS_THIS'+object_id).value = num.toFixed(2);
	document.getElementById('actual_this_period_units'+object_id).value = value;
}
function change1(){
	<%
		if(LaborList != null){
		for(int i =0; i<LaborList.size();i++){
			MsgElement msg = (MsgElement)LaborList.get(i);
			Map map = msg.toMap();
	%>
	var value = document.getElementById('budgeted_units'+<%=map.get("OBJECT_ID") %>).value;
	document.getElementById('REMAINING_UNITS_THIS'+<%=map.get("OBJECT_ID") %>).value = value*document.getElementById('remaining_duration'+<%=activity_object_id%>).value;
	<%}}%>
	<%
		if(NonlaborList != null){
		for(int i =0; i<NonlaborList.size();i++){
			MsgElement msg = (MsgElement)NonlaborList.get(i);
			Map map = msg.toMap();
	%>
	var value = document.getElementById('budgeted_units'+<%=map.get("OBJECT_ID") %>).value;
	document.getElementById('REMAINING_UNITS_THIS'+<%=map.get("OBJECT_ID") %>).value = value*document.getElementById('remaining_duration'+<%=activity_object_id%>).value;
	<%}}%>
}
function change2(object_id){
	var value = document.getElementById('actual_this_period_units'+object_id).value;
	var value1 = document.getElementById('planned_units'+object_id).value;
	var num = new Number(value1 - value - document.getElementById('ACTUAL_UNITS_THIS'+object_id).value);
	document.getElementById('REMAINING_UNITS_THIS'+object_id).value = num.toFixed(2);
}
function change3(){
	//var value = document.getElementById('budgeted_units'+object_id).value;
	//alert(document.forms[0].status.value);
	if(document.forms[0].status.value=="Not Started"){
		//alert("1");
	} else if(document.forms[0].status.value=="In Progress"){
		//alert("2");
	} else if(document.forms[0].status.value=="Completed"){
		//alert("3");
	} 
	
}
function toAdd(){
	debugger;
	var start_date = $("#start_date").val();
	var end_date = $("#finish_date").val();
	 var org_name=document.getElementById("org_name").value;
	 var stop_reason=document.getElementById("stop_reason").value;
	 var pause_reason=document.getElementById("pause_reason").value;
	 if(document.getElementById("item0_10").style.display!="none"){
		 if(org_name== " "){
			 alert("请选择施工队伍");
				return;
		 }
	 }
	 if(document.getElementById("td1").style.display!="none"){
		 if(stop_reason== ""){
			 alert("请选择停工原因");
				return;
		 }
	 }
	 if(document.getElementById("td2").style.display!="none"){
		 if(pause_reason== ""){
		 alert("请选择暂停原因");
			return;
		 }
 }

 
	 
		 
	 if(document.getElementById("queryRetTable").style.display!=""&&document.getElementById("queryRetTable").style.display!="none"){
		 
	 
	if(document.getElementById("iMethod").value=="重力"){
		   if(document.getElementById("G6602").value==""){
		     alert("仪器数量(在用)不能为空");
		       return;
		   }
		   if(document.getElementById("G6602all").value==""){
		     alert("仪器数量(总共)不能为空");
	          return;
		   }
	}
	if(document.getElementById("iMethod").value=="磁力"){
		   if(document.getElementById("G6603").value==""){
		     alert("仪器数量(在用)不能为空");
		       return;
		   }
		   if(document.getElementById("G6603all").value==""){
		     alert("仪器数量(总共)不能为空");
	          return;
		   }
	}
	if(document.getElementById("iMethod").value=="人工"){
		   if(document.getElementById("G6604").value==""){
		     alert("仪器数量(在用)不能为空");
		       return;
		   }
		   if(document.getElementById("G6604all").value==""){
		     alert("仪器数量(总共)不能为空");
	          return;
		   }
	}
	if(document.getElementById("iMethod").value=="天然"){
		   if(document.getElementById("G6605").value==""){
		     alert("仪器数量(在用)不能为空");
		       return;
		   }		   
		   if(document.getElementById("G6605all").value==""){
		     alert("仪器数量(总共)不能为空");
	          return;
		   }
	}
	if(document.getElementById("iMethod").value=="化学"){
		   if(document.getElementById("G6606").value==""){
		     alert("仪器数量(在用)不能为空");
		       return;
		   }
		   if(document.getElementById("G6606all").value==""){
		     alert("仪器数量(总共)不能为空");
	          return;
		   }
	}
	if(document.getElementById("iMethod").value=="工程"){
		   if(document.getElementById("G6607").value==""){
		     alert("仪器数量(在用)不能为空");
		       return;
		   }
		   if(document.getElementById("G6607all").value==""){
		     alert("仪器数量(总共)不能为空");
	          return;
		   }
	}
	 }
	if(start_date == ""){
		alert("请填写开始时间");
		return;
	}
	if(end_date != ""&&start_date == ""){
		alert("请填写开始时间");
		return;
	}
	 
	document.form1.butL1.disabled = true;
	document.form1.action="<%=contextPath%>/pm/dailyReport/singleProject/wt/saveOrUpdateResourceAssignment.srq";
	document.form1.submit();
}
cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
function toSubmit(){
	if(window.confirm("确定提交吗？该操作会提交所有作业的当天的反馈！")) {
		document.form1.butL1.disabled = true;
		//document.form1.action="<%=contextPath%>/p6/resourceAssignment/submitResourceAssignment.srq?";
		debugger;
		var retObj = jcdpCallService("WtDailyReportSrv", "submitDailyReport", "projectInfoNo=<%=projectInfoNo %>&produceDate=<%=produceDate %>");
		if(retObj.message != null) {
			if(retObj.message == "success"){
				document.getElementById('message').innerHTML = "已提交，待审批";
				alert("提交成功!");
			}
		}
		//document.form1.submit();
	}
}
function toEdit(){
	var start_date = $("#actual_start_date").html().substr(0,10);
	var finish_date = $("#actual_finish_date").html().substr(0,10);
	var t1 = '<input type="text" name="start_date" id="start_date" value="'+start_date+'" onchange="changeStartStatus()" readonly/>&nbsp;&nbsp;'+
			 '<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(start_date,tributton1);" />'+
			 '&nbsp;<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="clearStartDate()"/>';
	var t2 = '<input type="text" name="finish_date" id="finish_date" value="'+finish_date+'" readonly>&nbsp;&nbsp;'+
			 '<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(finish_date,tributton2);" />'+
			 '&nbsp;<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="clearFinishDate()"/>';
	$("#actual_start_date").html(t1);
	$("#actual_finish_date").html(t2);
	$("#editbut").attr("disabled","disabled");
	$("#savebut").removeAttr("disabled");
}
function clearStartDate(){
	$("#start_date").val("");
	changeStartStatus();
}
function clearFinishDate(){
	$("#finish_date").val("");
	changeEndStatus();
}



</script>
</head>
<body onload="tt()">

<form action="" name="form1" id="form1" method="post">
<input id="ucmIdValue" name="ucmIdValue" type="hidden" value=""/>
<input id="idDelete" name="idDelete" type="hidden" value="no"/>



<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
<%if (flag == "Submited" || "Submited".equals(flag) || flag == "Passed" || "Passed".equals(flag) ){ %>
<input class="iButton2" type="button" id="savebut" name="butL1" value="保存" onClick="toAdd()" disabled="true"/>
<%} else {%>
<input class="iButton2" type="button" id="savebut" name="butL1" value="保存" onClick="toAdd()"/>
<%} %>
	<font id="message" color="red"><%=message %></font>
    </td>
    <td align="left">当前日报日期：<font color="red"><%=produceDate %></font></td>
	<td>
    <% if("Passed".equals(flag)||"Submited".equals(flag)){ %>
		<input class="iButton2" type="button" id="editbut" name="butL2" value="修改" onClick="toEdit()" disabled="disabled"/>
	<%} else {%>
		<input class="iButton2" type="button" id="editbut" name="butL2" value="修改" onClick="toEdit()"/>
	<%} %>
    
    </td>

  </tr>
</table>

<div id="resultable"  style="width:100%; overflow-x:scroll ;" >
<%

if(map1 != null) {
%>
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%">
<tr>
<td bgcolor="#DDF1F2" width="25%">状态</td>
<td bgcolor="#DDF1F2" width="25%">作业代码</td>
<td bgcolor="#DDF1F2" width="25%">作业名称</td>
<td bgcolor="#DDF1F2" width="25%">计划工期</td>
</tr>
<tr>

<td>
<%if ((String)map1.get("STATUS") =="Not Started" || "Not Started".equals((String)map1.get("STATUS")) ){ %>
<label id="activityStatus">未开始</label>
<input type="hidden" id="status" name="status" value="Not Started"/>
<%} else if ((String)map1.get("STATUS") =="In Progress" || "In Progress".equals((String)map1.get("STATUS")) ){%>
<label id="activityStatus">运行</label>
<input type="hidden" id="status" name="status" value="In Progress"/>
<%} else if ((String)map1.get("STATUS") =="Completed" || "Completed".equals((String)map1.get("STATUS")) ){%>
<label id="activityStatus">结束</label>
<input type="hidden" id="status" name="status" value="Completed"/>
<%} %>
</td>

<td><%=map1.get("ID") %></td>
<%-- <td><%=map1.get("NAME") %></td> --%>
<td><%=taskName %></td>
<td><%=Long.parseLong((String)map1.get("PLANNED_DURATION"))/Long.parseLong((String)map1.get("HOURS_PER_DAY")) %>天</td>
<!-- td><%=map1.get("PROJECT_ID")+"."+map1.get("WBS_CODE")+" "+map1.get("WBS_NAME") %></td-->
</tr>
<tr>
<td bgcolor="#DDF1F2">实际开始日期</td>
<td bgcolor="#DDF1F2">实际完工日期</td>
<td bgcolor="#DDF1F2">计划开工日期</td>
<td bgcolor="#DDF1F2">计划完工日期</td>
</tr>
<tr>
<td id="actual_start_date">
<%if ((String)map1.get("STATUS") =="Completed" || "Completed".equals((String)map1.get("STATUS")) ){ %>
<%=map1.get("ACTUAL_START_DATE")==null?"&nbsp;":map1.get("ACTUAL_START_DATE").toString() %>
<%} else {
	
	System.out.print(map1.get("STATUS")+"dfdfdf"+map1.get("ACTUAL_START_DATE"));
	%>

<input type="text" name="start_date" id='start_date' value='<%=map1.get("ACTUAL_START_DATE")==null?"":map1.get("ACTUAL_START_DATE").toString() %>' onchange='changeStartStatus()' readonly/>&nbsp;&nbsp;
<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(start_date,tributton1);" />
<%} %>
</td>
<td id="actual_finish_date">
<%if ((String)map1.get("STATUS") =="Completed" || "Completed".equals((String)map1.get("STATUS")) ){ %>
<%=map1.get("ACTUAL_FINISH_DATE")==null?"&nbsp;":map1.get("ACTUAL_FINISH_DATE").toString() %>
<%} else { %>
<input type="text" name="finish_date" id='finish_date' value='<%=map1.get("ACTUAL_FINISH_DATE")==null?"":map1.get("ACTUAL_FINISH_DATE").toString() %>' onchange='changeEndStatus()' readonly>&nbsp;&nbsp;
<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(finish_date,tributton2);" />
<%} %>
</td>
<!-- td><%=Long.parseLong((String)map1.get("PLANNED_DURATION"))/Long.parseLong((String)map1.get("HOURS_PER_DAY")) %>天</td-->
<td><%=map1.get("PLANNED_START_DATE")==null?"&nbsp;":map1.get("PLANNED_START_DATE").toString() %></td>
<td><%=map1.get("PLANNED_FINISH_DATE")==null?"&nbsp;":map1.get("PLANNED_FINISH_DATE").toString() %></td>
</tr>
<tr>
<td>---</td>
<td>
----
</td>
<td id="buildId">任务采集状态</td>
<td id="buildSelect">	<select name="iBuild" id="iBuild" class="select_width" onchange="changeWt()" >
			 
				<option value="1">采集</option>
				<option value="2">停工</option>
				<option value="3">暂停</option>
				<option value="4">结束</option>
			 
			</select>    </td>
		
</tr>
<tr id="actId" >

	<%
	WtResourceAssignmentSrv wtSrv=new WtResourceAssignmentSrv();
	 Map mapOrg=wtSrv.queryOrgId(projectInfoNo,activity_object_id,produceDate);

 System.out.print(mapOrg.get("vspTeamNo"));
		if(mapOrg.get("org_name")!=null){
			String activityName= (String)mapOrg.get("org_name");
			String activityId= (String)mapOrg.get("org_id"); 
	%>
	<td class="inquire_item4" id="item0_10"><span class="red_star">*</span>施工队伍：</td>
									<td class="inquire_form4" id="item0_11">
										<input id="org_id" name="org_id" value="<%=activityId %>" type="hidden" class="input_width" />
										<input id="org_name" name="org_name" value="<%=activityName %>" type="text" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
									</td>
										<td class="inquire_item4" id="item0_13">  勘探方法：</td>
										<td id="wtEx"></td>
								 
	<% 	 
	}else{
	%>
		<td class="inquire_item4" id="item0_10"><span class="red_star">*</span>施工队伍：</td>
									<td class="inquire_form4" id="item0_11">
										<input id="org_id" name="org_id" value=" " type="hidden" class="input_width" />
										<input id="org_name" name="org_name" value=" " type="text" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
									</td>
									<td class="inquire_item4" id="item0_13">  勘探方法：</td>
										<td id="wtEx"></td>
	<%	
		}
	%>
	</tr>
	<%if ((String)map1.get("STATUS") =="In Progress" || "In Progress".equals((String)map1.get("STATUS")) ){ %>
	<tr id="uploadImageTr" style="display: none;">
	<td class="inquire_item4"><span class="red_star">*</span>施工进度图上传:</td>
	 						<td colspan="3">
	 						<div id="imgFileName" style="color: red;padding-left: 3px;"></div>
										<input type="hidden" name="doc_name" id="doc_name" />
										<input type="hidden" name="upload_file_name" id="upload_file_name" />
							       	 	<div style="float:left" id="fileQueue" style="border:1px solid green;width:400px"></div>
										<div id="file_content" style="float:left"> <input type="file"  name="file" id="file"/></div>
										<div id="status-message"></div> 
										<div  id="td_down"></div>
								
								<div style="display:none;">
							      		<select name="doc_type" id="doc_type" class="select_width">
								      		<option value="0">-请选择-</option>
								      		<option value="word">word</option>
								      		<option value="excel">excel</option>
								      		<option value="ppt">PowerPoint</option>
								      		<option value="pdf">PDF</option>
								      		<option value="txt">TXT</option>
								      		<option value="picture">图片文件</option>
								      		<option value="compress">压缩文件</option>
								      		<option value="other">其他文件</option>
								      	</select>
	      						</div>
	      							
	      					</td>
	 </tr>
	<%} %>
	<tr id="td1" style="display: none;">
		<td class="inquire_item6"><span class="red_star">*</span>停工原因:</td>
		<td class="inquire_form6">
			<select name="stop_reason" id="stop_reason" class="select_width">
				<option value="">请选择</option>
				<option value="1">仪器因素停工天数</option>
				<option value="2">人员因素停工天数</option>
				<option value="3">气候因素停工天数</option>
				<option value="4">工农协调因素停工天数</option>
				<option value="5">油公司因素停工天数</option>
				<option value="6">其它</option>
 
			</select>
		</td>
	 
	</tr>
	
	<tr id="td2" style="display: none;">
		<td class="inquire_item6"><span class="red_star">*</span>暂停原因:</td>
		<td class="inquire_form6">
			<select name="pause_reason" id="pause_reason" class="select_width">
				<option value="">请选择</option>
				<option value="1">仪器因素停工天数</option>
				<option value="2">人员因素停工天数</option>
				<option value="3">气候因素停工天数</option>
				<option value="4">工农协调因素停工天数</option>
				<option value="5">油公司因素停工天数</option>
				<option value="6">其它</option>

			</select>
		</td>
	 
	</tr>
</table>
<br/>

<%} %>
<script type="text/javascript">


function changeWt(){
	debugger;
if(document.getElementsByName("iBuild")[0].value == "2"){
	document.getElementById("td1").style.display="inline";
 
 	document.getElementById("td2").style.display="none";
	document.getElementById("queryRetTable").style.display="none";
 
} else if(document.getElementsByName("iBuild")[0].value == "3"){
 
	document.getElementById("td1").style.display="none";
	document.getElementById("td2").style.display="inline";
	document.getElementById("queryRetTable").style.display="none";
}else{
	document.getElementById("td1").style.display="none";
	document.getElementById("td2").style.display="none";
	document.getElementById("queryRetTable").style.display="inline";
 
}
}
if(retObjTask.daily_map==null){
	document.getElementById("item0_10").style.display="none";
	document.getElementById("item0_11").style.display="none";
	document.getElementById("item0_13").style.display="none";
	document.getElementById("buildSelect").style.display="none";
	document.getElementById("buildId").style.display="none";
}

function selectTeam(){
	debugger;
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/wtselectTeams.jsp?isSelect=1',teamInfo);
	if(teamInfo.fkValue!=""){
		document.getElementById('org_id').value = teamInfo.fkValue;
		document.getElementById('org_name').value = teamInfo.value;
	}
}
 
</script>
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>
	<input type="hidden" value="<%=projectInfoNo %>" id="projectInfoNo" name="projectInfoNo"/>
	<input type="hidden" value="<%=produceDate %>" id="produceDate" name="produceDate"/>
	<input type="hidden" value="<%=orgId %>" id="orgId" name="orgId"/>
	<input type= "hidden" value="<%=activity_object_id %>" id = "activity_object_id" name = "activity_object_id"/>
	<input type= "hidden" value="<%=activity_object_id %>" id = "object_id" name = "object_id"/>
	<input  type= "hidden" value="<%=flag %>" id = "flag" name = "flag"/>
 	<input  type= "hidden"   id ="wtIbuild" name = "wtIbuild"/>
 	<input  type= "hidden"   id ="exploration_method" name = "exploration_method"/>
 		<input  type= "hidden"   id ="exploration_method_name" name = "exploration_method_name"/>
 
  	<input  type= "hidden"   id ="s_reason" name = "s_reason"/>
  	<input  type= "hidden"   id ="p_reason" name = "p_reason"/>
	<tr class="bt_info">
		<td>填报项</td>
	
	 
		<td>本日完成 </td>
		<td width="18%">剩余 </td>
		<td>累计完成</td>
		<td>设计 </td>
		<!--  td>开始</td>
		<td>结束</td-->
	</tr>
	</thead>
	<tbody>

	<%
		if(WorkLoadLlist != null){
	%>
	
		<tr>
			<td colspan="8" align="left" bgcolor="#DDF1F2">&nbsp;工作量 &nbsp;&nbsp;&nbsp;</td>
		</tr>
	

	<%
	List testList=new ArrayList();
	String []strTest=null;
		for(int i =0; i<WorkLoadLlist.size();i++){
			MsgElement msg = (MsgElement)WorkLoadLlist.get(i);
			Map map = msg.toMap();
		 
			String method=(String)map.get("RESOURCE_NAME");
			String explorationMethod=method.substring(0,2);
		String str=(String)	map.get("RESOURCE_ID");
		String str2=str.substring(0, 5);
		 if(testList.size()==0){
			 testList.add(str2);
		
			%>
			<tr>
			<input type="hidden" value="<%=explorationMethod %>" name="<%=explorationMethod %>" id="iMethod" ></input>
			<td colspan="8" align="left" bgcolor="#DDF1F2"  id="inId"><span class="red_star">*</span><%=explorationMethod %>仪器数量(在用)<input type="text" name="<%=str2%>" id="<%=str2%>" ></input>
				&nbsp;&nbsp;&nbsp;<span class="red_star">*</span><%=explorationMethod %>仪器数量(总共)<input type="text" name="<%=str2%>all" id="<%=str2%>all" ></input></td>
			</tr>
	<script type="text/javascript">
	debugger;
	
	if( "<%=str2%>" =="G6601"){
	
		document.getElementById("inId").style.display="none";
		document.getElementById("G6601").style.display="none";
		document.getElementById("G6601all").style.display="none";
		document.getElementById("item0_10").style.display="none";
		document.getElementById("item0_11").style.display="none";
		document.getElementById("item0_13").style.display="none";
		document.getElementById("buildSelect").style.display="none";
		document.getElementById("buildId").style.display="none";
	}
	
	</script>
			<%
		}else if(testList!=null){
			boolean has = false;
			for(int j=0;j<testList.size();j++){
			
				if(testList.get(j).equals(str2)){
				  
					has=true;
				}

			}
			if(has){
				
			}else{
				  testList.add(str2);
					
					%>
					<tr>
					<input type="hidden" value="<%=explorationMethod %>" name="<%=explorationMethod %>" id="iMethod" />  
	            	<td colspan="8" align="left" bgcolor="#DDF1F2" id="inId"><span class="red_star">*</span><%=explorationMethod %>仪器数量(在用)<input type="text" name="<%=str2%>" id="<%=str2%>" ></input>
			&nbsp;&nbsp;&nbsp;<span class="red_star">*</span><%=explorationMethod %>仪器数量(总共)<input type="text" name="<%=str2%>all" id="<%=str2%>all" ></input></td>
		
		</tr>
			<script type="text/javascript">
	debugger;
	
	if( "<%=str2%>" =="G6601"){
	
		document.getElementById("inId").style.display="none";
		document.getElementById("G6601").style.display="none";
		document.getElementById("G6601all").style.display="none";
		document.getElementById("item0_10").style.display="none";
		document.getElementById("item0_11").style.display="none";
		document.getElementById("item0_13").style.display="none";
		document.getElementById("buildSelect").style.display="none";
		document.getElementById("buildId").style.display="none";
	}
	
	</script>
		
				<%
			}
			
		}
	%>
		<tr>
			<td><%=map.get("RESOURCE_NAME") %></td>
		 
			 
		
			 <td><input class="input_width" id="actual_this_period_units<%=map.get("OBJECT_ID") %>" name = "actual_this_period_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("ACTUAL_THIS_PERIOD_UNITS") %>" onkeyup="change2('<%=map.get("OBJECT_ID") %>')"/></td>
			<td  id="REMAINING_UNITS_THIS<%=map.get("OBJECT_ID") %>" name = "REMAINING_UNITS_THIS<%=map.get("OBJECT_ID") %>">  <%=map.get("REMAINING_UNITS_THIS") %></td>
			<td><%=map.get("ACTUAL_UNITS_THIS") %>
			<input class="input_width" id="ACTUAL_UNITS_THIS<%=map.get("OBJECT_ID") %>" name = "ACTUAL_UNITS_THIS<%=map.get("OBJECT_ID") %>" value="<%=map.get("ACTUAL_UNITS_THIS") %>" type="hidden"/>
			</td>
			<td><%=map.get("PLANNED_UNITS") %>
			<input class="input_width" id="planned_units<%=map.get("OBJECT_ID") %>" name = "planned_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("PLANNED_UNITS") %>" type="hidden"/>
			</td>
		</tr>
	<%
		}}
	%>
	<%
		if(MaterialLlist != null){
	%>
	<tr>
		<td colspan="8" align="left" bgcolor="#DDF1F2">&nbsp;材料消耗</td>
	</tr>
	<%
		for(int i =0; i<MaterialLlist.size();i++){
			MsgElement msg = (MsgElement)MaterialLlist.get(i);
			Map map = msg.toMap();
	%>
		<tr>
			<td><%=map.get("RESOURCE_ID")+"."+map.get("RESOURCE_NAME") %></td>
			<td><%=map.get("TEXT_VALUE")==null?"&nbsp;":map.get("TEXT_VALUE") %></td>
			<td><%=map.get("DOUBLE_VALUE")==null?"&nbsp;":map.get("DOUBLE_VALUE") %></td>
			<td>-<input class="input_width" id="budgeted_units<%=map.get("OBJECT_ID") %>" name = "budgeted_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("BUDGETED_UNITS") %>" type="hidden"/></td>
			<td><input class="input_width" id="actual_this_period_units<%=map.get("OBJECT_ID") %>" name = "actual_this_period_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("ACTUAL_THIS_PERIOD_UNITS") %>" onkeyup="change2('<%=map.get("OBJECT_ID") %>')"/></td>
			<td><input class="input_width" id="REMAINING_UNITS_THIS<%=map.get("OBJECT_ID") %>" name = "REMAINING_UNITS_THIS<%=map.get("OBJECT_ID") %>" value="<%=map.get("REMAINING_UNITS_THIS") %>"/></td>
			<td><%=map.get("ACTUAL_UNITS_THIS") %>
			<input class="input_width" id="ACTUAL_UNITS_THIS<%=map.get("OBJECT_ID") %>" name = "ACTUAL_UNITS_THIS<%=map.get("OBJECT_ID") %>" value="<%=map.get("ACTUAL_UNITS_THIS") %>" type="hidden"/>
			</td>
			<td><%=map.get("PLANNED_UNITS") %>
			<input class="input_width" id="planned_units<%=map.get("OBJECT_ID") %>" name = "planned_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("PLANNED_UNITS") %>" type="hidden"/>
			</td>
			<!--td><%=map.get("START_DATE")==null?"":map.get("START_DATE").toString().substring(0,11) %></td>
			<td><%=map.get("FINISH_DATE")==null?"":map.get("FINISH_DATE").toString().substring(0,11)  %></td-->
		</tr>
	<%} }%>
	<%
		if(LaborList != null){
	%>
	<tr>
		<td align="left" bgcolor="#DDF1F2">&nbsp;人工</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;实际人数</td>
		<td colspan="4" bgcolor="#DDF1F2">&nbsp;</td>
	</tr>
	<%
		for(int i =0; i<LaborList.size();i++){
			MsgElement msg = (MsgElement)LaborList.get(i);
			Map map = msg.toMap();
	%>
		<tr>
			<td><%=map.get("RESOURCE_ID")+"."+map.get("RESOURCE_NAME") %></td>
			<td><%=map.get("TEXT_VALUE")==null?"&nbsp;":map.get("TEXT_VALUE") %></td>
			<td><%=map.get("DOUBLE_VALUE")==null?"&nbsp;":map.get("DOUBLE_VALUE") %></td>
			<td><input class="input_width" id="budgeted_units<%=map.get("OBJECT_ID") %>" name = "budgeted_units<%=map.get("OBJECT_ID") %>" value="<%=Long.parseLong((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")) %>" onkeyup="change('<%=map.get("OBJECT_ID") %>')"/></td>
			<td><input class="input_width" id="actual_this_period_units<%=map.get("OBJECT_ID") %>" name = "actual_this_period_units<%=map.get("OBJECT_ID") %>" value="<%=Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")) %>" type="hidden"/>
			<input class="input_width" id="in<%=map.get("OBJECT_ID") %>" value="<%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>" disabled="disabled">
			</td>
			<%
				double value = Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY"))*Double.parseDouble(remainingDuration) ;
				Double valueDouble = Double.valueOf(value);
				int valueInt = 0;
				if (valueDouble.intValue() < value) {
					valueInt = valueDouble.intValue()+1;
				} else {
					valueInt = valueDouble.intValue();
				}
			 %>
			<td><input style="width: 50%" id="REMAINING_UNITS_THIS<%=map.get("OBJECT_ID") %>" name = "REMAINING_UNITS_THIS<%=map.get("OBJECT_ID") %>" value="<%=valueInt %>"/>工日</td>
			<td><%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("ACTUAL_UNITS_THIS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>工日</td>
			<td><%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("PLANNED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>工日</td>
			<!--td><%=map.get("START_DATE")==null?"":map.get("START_DATE").toString().substring(0,11) %></td>
			<td><%=map.get("FINISH_DATE")==null?"":map.get("FINISH_DATE").toString().substring(0,11)  %></td-->
		</tr>
	<%} }%>
	<%
		if(NonlaborList != null){
	%>
	<tr>
		<td align="left" bgcolor="#DDF1F2">&nbsp;设备</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;实际设备台数</td>
		<td colspan="4" bgcolor="#DDF1F2">&nbsp;</td>
	</tr>
	<%
		for(int i =0; i<NonlaborList.size();i++){
			MsgElement msg = (MsgElement)NonlaborList.get(i);
			Map map = msg.toMap();
	%>
		<tr>
			<td><%=map.get("RESOURCE_ID")+"."+map.get("RESOURCE_NAME") %></td>
			<td><%=map.get("TEXT_VALUE")==null?"&nbsp;":map.get("TEXT_VALUE") %></td>
			<td><%=map.get("DOUBLE_VALUE")==null?"&nbsp;":map.get("DOUBLE_VALUE") %></td>
			<td><input class="input_width" id="budgeted_units<%=map.get("OBJECT_ID") %>" name = "budgeted_units<%=map.get("OBJECT_ID") %>" value="<%=Long.parseLong((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")) %>" onkeyup="change('<%=map.get("OBJECT_ID") %>')"/></td>
			<td>
			<input class="input_width" id="actual_this_period_units<%=map.get("OBJECT_ID") %>" name = "actual_this_period_units<%=map.get("OBJECT_ID") %>" value="<%=Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")) %>" type="hidden"/>
			<input class="input_width" id="in<%=map.get("OBJECT_ID") %>" value="<%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>" disabled="disabled">
			</td>
			<%
				double value = Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY"))*Double.parseDouble(remainingDuration) ;
				Double valueDouble = Double.valueOf(value);
				int valueInt = 0;
				if (valueDouble.intValue() < value) {
					valueInt = valueDouble.intValue()+1;
				} else {
					valueInt = valueDouble.intValue();
				}
			 %>
			<td><input style="width: 50%" id="REMAINING_UNITS_THIS<%=map.get("OBJECT_ID") %>" name = "REMAINING_UNITS_THIS<%=map.get("OBJECT_ID") %>" value="<%=valueInt %>"/>台班</td>
			<td><%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("ACTUAL_UNITS_THIS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>台班</td>
			<td><%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("PLANNED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>台班</td>
			<!--td><%=map.get("START_DATE")==null?"":map.get("START_DATE").toString().substring(0,11) %></td>
			<td><%=map.get("FINISH_DATE")==null?"":map.get("FINISH_DATE").toString().substring(0,11)  %></td-->
		</tr>
	<%} }%>
	</tbody>
		<script type="text/javascript">
		 
		debugger;
		
			if(retObjWt.daily_map.ifBuild=="11"){
			 
				var wtStop=retObjWt.daily_map.stopReason;
				document.getElementById("iBuild").value="2";
				document.getElementById("td1").style.display="inline";
				 
				document.getElementById("stop_reason").value=wtStop;
 				document.getElementById("queryRetTable").style.display="none"; 
			} 
			
		
			   
		 
			</script>
</table>
</div>
</form>
</body>
</html>
