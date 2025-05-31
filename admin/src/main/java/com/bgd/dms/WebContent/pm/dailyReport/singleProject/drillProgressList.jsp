<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.util.*" contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="code" prefix="code"%>
<%@taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="java.util.List" %>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String orgName = user.getOrgName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String toadyFlag = respMsg.getValue("todayFlag")!=null?respMsg.getValue("todayFlag"):"";
    String drillProgressId = respMsg.getValue("dailyProgressNo")!=null?respMsg.getValue("dailyProgressNo"):"";
    String expMethod = respMsg.getValue("expMethod")!=null?respMsg.getValue("expMethod"):"";
    String queryDate = respMsg.getValue("queryDate")!=null?respMsg.getValue("queryDate"):"";
    String queryDrillType = respMsg.getValue("queryDrillType")!=null?respMsg.getValue("queryDrillType"):"";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
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

<body style="background:#fff">
<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">  
	<tr class="even">
		<td colspan="4" align = "left">
			<a href="<%=contextPath%>/pm/dailyreport/querySurveyProgress.srq?projectInfoNo=<%=projectInfoNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>">测量进度</a>
		    &nbsp;&nbsp;
			<a href="<%=contextPath%>/pm/dailyreport/querySurfaceProgress.srq?projectInfoNo=<%=projectInfoNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>">表层进度</a>						
			&nbsp;&nbsp;
		    <a href="<%=contextPath%>/pm/dailyreport/queryDrillProgress.srq?projectInfoNo=<%=projectInfoNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>"><font color="red">钻井进度</font></a>
			&nbsp;&nbsp;
			<a href="<%=contextPath%>/pm/dailyreport/queryAcquireProgress.srq?projectInfoNo=<%=projectInfoNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>">采集进度</a>
			&nbsp;&nbsp;
			<a href="<%=contextPath%>/pm/dailyreport/queryTestProgress.srq?projectInfoNo=<%=projectInfoNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>">试验进度</a>
			&nbsp;&nbsp;
			<%
			Object recordsError = respMsg.getValue("recordsError");
			if(recordsError!=null && recordsError.equals("YES")){
			%>
				<font color="red"><%=respMsg.getValue("message") %></font>  
			<%
			 } 
		    %>
		</td>	
	</tr> 
  	<tr class="tongyong_box_title">
		<td class="inquire_item4">施工队伍：</td>
		<td class="inquire_form4"><%=orgName  %></td>
		<td class="inquire_item4">项目信息：</td>
		<td class="inquire_form4"><%=projectName %></td>
	</tr> 
</table>
<form name="form1" action="" method="post" enctype="multipart/form-data">

<input id="project_info_no" name="project_info_no" value="<%=projectInfoNo %>" type="hidden"/>
<input id="drillProgressId" name="drillProgressId" value="<%=drillProgressId %>" type="hidden"/>

<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">

		<tr class="even">
	
		<%
			if("1".equals(toadyFlag)){
		%>		
			<td class="inquire_item6"><font style="color:red">*</font>&nbsp;施工日期:</td>
		<% 		
			}else{
		%>	
			<td class="inquire_item6"><font color='red'>今天数据还未录入</font>&nbsp;&nbsp;<font style="color:red">*</font>&nbsp;施工日期:</td>
		<%
			}
		%>
	
		<td class="inquire_form6">
			<input type="text" name="consDate" id="consDate" readonly="readonly" />&nbsp;&nbsp;
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(consDate,tributton1);" />
		</td>
		<td class="inquire_item6"><font color="red">*</font>&nbsp;钻井类型：</td>
		<td class="inquire_form6">
			<input type="radio" name="drillType" value="2" checked="checked"/>人工钻井&nbsp;
			<input type="radio" name="drillType" value="1" />机械钻井	
		</td>
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;附件:</td>
		<td class="inquire_form6">
			<input name="drillFile" id="drillFile" type="file" />
		</td>
		<td class="inquire_item6">
			<a href="" id="downloadFile" name="downloadFile" style="display:none;">查看附件</a>
			<auth:ListButton functionId="" css="tj_btn" event="onclick='validate()'"></auth:ListButton>
		</td>
	</tr>

	</table>
</form>	

    <div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">施工日期:</td>
			    <td class="">
				<input id="queryDate" name="queryDate" type="text" readonly="readonly"/>
				&nbsp;
			    <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(queryDate,tributton2);"/>
				&nbsp;&nbsp;&nbsp;&nbsp;钻井类型：&nbsp;	
				<input type="radio" name="queryDrillType" value="2" checked="checked"/>人工钻井
				<input type="radio" name="queryDrillType" value="1" />机械钻井	
				&nbsp;	
				</td>
			    <td class="ali_query">
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <%		
					if("2".equals(expMethod)){
				%>
					<auth:ListButton functionId="" css="xz" event="onclick='toDownload2()'" title="下载钻井二维模板"></auth:ListButton>
				<%
					}else if("3".equals(expMethod)){
				%>
					<auth:ListButton functionId="" css="xz" event="onclick='toDownload3()'" title="下载钻井三维模板"></auth:ListButton>
				<%
					}
				%>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出数据"></auth:ListButton>
				<%-- 				
					<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
 				--%>			  
 				</tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			  
			  
			  	<%
					List surfaceProgressList = respMsg.getMsgElements("datas");
					if(surfaceProgressList!=null && !surfaceProgressList.isEmpty()) {
						MsgElement progressNo = (MsgElement)surfaceProgressList.get(0);
				%>
				<%		
					if("2".equals(expMethod)){
				%>
					<tr>
						<td class="">序号</td>
						<td class="">测线号</td>
						<td class="">桩号</td>
						<td class="">井深</td>
						<td class="">X坐标</td>
						<td class="">Y坐标</td>
					</tr>
				<%
					for(int i=0; i<surfaceProgressList.size(); i++){
					MsgElement surfaceProgress = (MsgElement)surfaceProgressList.get(i);
					if(i%2 != 0){
				%>
					<tr class="even">
						<td class=""><%=i+1 %></td>
						<td class=""><%=surfaceProgress.getValue("lineGroupId") %></td>
						<td class=""><%=surfaceProgress.getValue("pointNo") %></td>
						<td class=""><%=surfaceProgress.getValue("wellDepth") %></td>
						<td class=""><%=surfaceProgress.getValue("pointX") %></td>
						<td class=""><%=surfaceProgress.getValue("pointY") %></td>
					</tr>				
				<%	}else{%>
					<tr class="odd">
						<td class=""><%=i+1 %></td>
						<td class=""><%=surfaceProgress.getValue("lineGroupId") %></td>
						<td class=""><%=surfaceProgress.getValue("pointNo") %></td>
						<td class=""><%=surfaceProgress.getValue("wellDepth") %></td>
						<td class=""><%=surfaceProgress.getValue("pointX") %></td>
						<td class=""><%=surfaceProgress.getValue("pointY") %></td>
					</tr>					
				<%}
					}
				}
				else if("3".equals(expMethod)){

				%>	
					<tr>
						<td class="">序号</td>
						<td class="">线束号</td>
						<td class="">线号</td>
						<td class="">桩号</td>
						<td class="">井深</td>
						<td class="">X坐标</td>
						<td class="">Y坐标</td>
					</tr>
				<%
				for(int i=0; i<surfaceProgressList.size(); i++){
					MsgElement surfaceProgress = (MsgElement)surfaceProgressList.get(i);
					if(i%2 != 0){
				%>
					<tr class="even">
						<td class=""><%=i+1 %></td>
						<td class=""><%=surfaceProgress.getValue("lineGroupId") %></td>
						<td class=""><%=surfaceProgress.getValue("lineNo") %></td>
						<td class=""><%=surfaceProgress.getValue("pointNo") %></td>
						<td class=""><%=surfaceProgress.getValue("wellDepth") %></td>
						<td class=""><%=surfaceProgress.getValue("pointX") %></td>
						<td class=""><%=surfaceProgress.getValue("pointY") %></td>
					</tr>				
				<%	
				}else{
				%>
					<tr class="odd">
						<td class=""><%=i+1 %></td>
						<td class=""><%=surfaceProgress.getValue("lineGroupId") %></td>
						<td class=""><%=surfaceProgress.getValue("lineNo") %></td>
						<td class=""><%=surfaceProgress.getValue("pointNo") %></td>
						<td class=""><%=surfaceProgress.getValue("wellDepth") %></td>
						<td class=""><%=surfaceProgress.getValue("pointX") %></td>
						<td class=""><%=surfaceProgress.getValue("pointY") %></td>
					</tr>			
				<%
				}
				}
				}
				}
				%>
				
			  </table>
			</div>
			<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				
			</table>
			</div>
		  </div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
	//setTabBoxHeight();
	$("#table_box").css("height",$(window).height()*0.65);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	if('<%=queryDate%>' != ''){
		document.getElementById("queryDate").value = '<%=queryDate%>';
	}else{
		document.getElementById("queryDate").value = '<%=curDate%>';
	}
	
	if('<%=queryDrillType%>' == '2'){
		$("input[type='radio'][name='queryDrillType'][value='2']").attr("checked",true);;
	}else if('<%=queryDrillType%>' == '1'){
		$("input[type='radio'][name='queryDrillType'][value='1']").attr("checked",true);;
	}
	
	var projectNo = '<%=projectInfoNo%>';
	var exportDataDate = "";
	
	function simpleSearch(){
		var queryDate = document.getElementById("queryDate").value;
		exportDataDate = queryDate;
		var queryDrillType = $("input[type='radio'][name='queryDrillType']:checked").val();
		window.location = "<%=contextPath%>/pm/dailyreport/queryDrillProgress.srq?projectInfoNo="+projectNo+"&consDate="+queryDate+"&queryDrillType="+queryDrillType;	
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function validate(){
		var flag = checkData();
		if (flag){
			var consDate = $("#consDate").attr("value");
			var drillType = $("input[type='radio'][name='drillType']:checked").val();
			
		    var retObj = jcdpCallService("InputDailyProgressSrv", "validateDrillProgress", "projectInfoNo=<%=projectInfoNo%>&consDate="+consDate+"&drillType="+drillType);
		    if(retObj.updateFlag == "1"){
		    	var drillProgressId = retObj.daily_progress_no;
		  	  	var con = confirm("确认更新此记录吗？");
			  	if(!con){
			  		return false;
			 	} 
			  	else 
			  	{
					document.form1.action="<%=contextPath%>/pm/dailyreport/updateDrillProgress.srq?projectInfoNo=<%=projectInfoNo %>&drillProgressId="+drillProgressId;
					document.form1.submit();
			  	 	return true;
			   	}
		    	
		    }else if(retObj.updateFlag == "0"){
		    		document.form1.action="<%=contextPath%>/pm/dailyreport/insertDrillProgress.srq?projectInfoNo=<%=projectInfoNo %>&consDate="+consDate+"&drillType="+drillType;
		    		document.form1.submit();
		    }	  	
		}else{
			return false;
		}	  	
	}
	
	function checkData()
	{
		var consDate=document.form1.consDate.value;
		var drillFile = document.form1.drillFile.value;
		if (consDate=="")
		{
			alert("施工日期不应为空，请重新输入！");
			return false;
		}

		if (drillFile=="")
		{
				alert("附件不应为空，请重新输入！");
				return false;
		}
		return true;
	}

	function toDelete(){
		var dailyProgressNo = '<%=drillProgressId%>';
		if(dailyProgressNo != "" && dailyProgressNo != undefined){
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("InputDailyProgressSrv", "deleteDrillProgress", "drillProgressId="+dailyProgressNo);
				
				var queryDate = document.getElementById("queryDate").value;
				var queryDrillType = $("input[type='radio'][name='queryDrillType']:checked").val();
				
				cruConfig.queryService = "InputDailyProgressSrv";
				cruConfig.queryOp = "queryDrillProgress";
				cruConfig.submitStr = "projectInfoNo="+projectNo+"&consDate="+queryDate+"&queryDrillType="+queryDrillType;
				queryData(1);
			}
		}else{
			alert("请先选择一条记录!");
			return;
		}
	}
	
	function toEdit(){
		var drillType = $("input[type='radio'][name='drillType']:checked").val();
		var retObj = jcdpCallService("InputDailyProgressSrv", "validateDrillProgress", "projectInfoNo=<%=projectInfoNo%>&consDate=<%=queryDate%>&drillType="+drillType);
		//有数据,可以修改
		if(retObj.updateFlag == "1"){
			var curDate = retObj.curDate;
			var daily_progress_no = retObj.daily_progress_no;
			document.getElementById("downloadFile").href="<%=contextPath %>/pm/dailyreport/downloadDrillFile.srq?dailyProgressNo="+daily_progress_no;
			document.getElementById("downloadFile").style.display="block";
		}else if(retObj.updateFlag == "0"){
			alert("请先选择一条记录！");
			return;
		}
	}
	
	function exportData(){
		var dailyProgressNo = '<%=drillProgressId%>';
		if(dailyProgressNo != "" && dailyProgressNo != undefined){
			window.location = "<%=contextPath%>/pm/dailyreport/downloadDrillFile.srq?dailyProgressNo="+dailyProgressNo;	
		}else{
			alert("请先选择一条记录!");
			return;
		}
	}
	
	function toDownload2(){
		window.location.href="<%=contextPath%>/pm/dailyReport/singleProject/download.jsp?path=/pm/dailyReport/singleProject/drill_2d.txt&filename=钻井进度模版(二维).txt";

	}
	
	function toDownload3(){
		window.location.href="<%=contextPath%>/pm/dailyReport/singleProject/download.jsp?path=/pm/dailyReport/singleProject/drill_3d.txt&filename=钻井进度模版(三维).txt";
	}
	
</script>
</html>