<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}

	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	String fromPage = request.getParameter("fromPage");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>无标题文档</title>
</head>

 
<body style="background:#fff"  onload="frameSize()">
 
<body style="background:#fff" >
 
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  	<auth:ListButton tdid="tj" functionId="" css="tj" event="onclick='audit(3)'" title="JCDP_btn_audit"></auth:ListButton>
		    	<auth:ListButton tdid="gb" functionId="" css="gb" event="onclick='audit(4)'" title="JCDP_btn_audit"></auth:ListButton>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <input type="hidden" id="orgSubjectionId" name="orgSubjectionId"  value="<%=orgSubjectionId %>" class="input_width" />
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no},{daily_no_ws},{produce_date}' id='rdo_entity_id_{daily_no_ws}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{produce_date}<input type='hidden' name='audit_status_{daily_no_ws}' id='audit_status_{daily_no_ws}' value='{audit_status}'/>" >施工日期</td>
			      <td class="bt_info_even" exp="{daily_acquire_cj}" >累计采集炮点数</td>
			      <td class="bt_info_odd" exp="{avg_cj}" >完成%</td>			
			      <td class="bt_info_even" exp="{sum_ce}" >累计测量测点数</td>
			      <td class="bt_info_odd" exp="{avg_ce}" >完成%</td>
			      <td class="bt_info_even" exp="{daily_surface_bc}" >累计表层点数</td>
			      <td class="bt_info_odd" exp="{avg_bc}" >完成%</td>
			        <td class="bt_info_even" exp="{daily_drill_zj}" >累计钻井炮点数</td>
			         <td class="bt_info_odd" exp="{avg_zj}" >完成%</td>
			        <td class="bt_info_even" exp="{daily_test_sy}" >累计试验炮数</td>
			      <td class="bt_info_odd" exp="{avg_test}" >完成%</td>
			      <td class="bt_info_even" exp="{audit_status}" func="getOpValue,audit_status1">审批状态</td>
			      <td class="bt_info_odd" exp="<a href='#'  onclick=openGis('{project_info_no}','{daily_no_ws}','{produce_date}')>查看</a>" >生产日报</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<!-- 
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag"  id="tag3_0"><a href="#" onclick="getTab3(0)">审批信息</a></li>
			  </ul>
			</div>
			 -->
			 <!-- 
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content" style="display:block;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">审批状态：</td>
					    <td class="inquire_form6"><input id="audit_status" name="audit_status" class="input_width"/></td>
					    <td class="inquire_item6">审批人：</td>
					    <td class="inquire_form6"><input id="employee_name" name="audit_name" class="input_width"/></td>
					    <td class="inquire_item6">审批时间：</td>
					    <td class="inquire_form6"><input id="audit_date" name="audit_date" class="input_width"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">审批意见：</td>
						<td colspan="5" class="inquire_form6"><textarea id="audit_opinion"  name="opinion"cols="45" rows="5" class="textarea"></textarea></td>
					  </tr>
					</table>
				</div>
			</div>
			 -->
		  </div>

</body>
<script type="text/javascript">

var audit_status1 = new Array(
		['0','未提交'],['1','待审批'],['2','审批中'],['3','审批通过'],['4','审批不通过']
		);

function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
	$("#table_box").css("height",$(window).height()*0.85);
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



debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "WsDailyReportSrv";
	cruConfig.queryOp = "queryDailyReportList";

	var orgSubjectionId = "<%=orgSubjectionId %>";
	var fromPage = "<%=fromPage%>";
	// 复杂查询
	
	function refreshData(q_projectName, q_orgName, q_projectStatus, q_auditStatus, q_projectType, q_orgSubjectionId){

		cruConfig.submitStr = "projectStatus="+q_projectStatus+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&auditStatus="+q_auditStatus+"&projectType="+q_projectType+"&orgName="+q_orgName;
		queryData(1);
	}

	refreshData("", "", "", "", "",  "<%=orgSubjectionId%>");
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName, "", "", "", "", "", orgSubjectionId);
	}
	
	function loadDataDetail(id){
		//var ids = getSelIds('rdo_entity_id');
	    if(id==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    
	    var idss = id.split(",");
	    var ids = idss[0];
	    var ids1 = idss[1];
	    var ids2 = idss[2];
//debugger;
/*
		//审批信息
		var retAuditMap = jcdpCallService("DailyReportSrv", "getAuditInfo", "dailyNo="+ids1);
		
		var auditStatus = retAuditMap.auditMap.auditStatus;
		if(auditStatus == "0"){
			document.getElementById("audit_status").value = "未提交";
		} else if(auditStatus == "1"){
			document.getElementById("audit_status").value = "待审批";
		} else if(auditStatus == "3"){
			document.getElementById("audit_status").value = "审批通过";
		} else if(auditStatus == "4"){
			document.getElementById("audit_status").value = "审批未通过";
		}
		
		//document.getElementById("audit_status").value= retAuditMap.auditMap.auditStatus;
		document.getElementById("audit_date").value= retAuditMap.auditMap.auditDate;
		document.getElementById("employee_name").value= retAuditMap.auditMap.employeeName;
		document.getElementById("audit_opinion").value= retAuditMap.auditMap.auditOpinion;
*/		
		//document.getElementById("dailyQuestion").src = "<%=contextPath%>/ws/pm/dailyReport/singleProject/dailyQuestionList.jsp?projectInfoNo="+ids+"&produceDate="+ids2;
	}
	
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");


	function toDelete(){

		var dailyNos = "";
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    var params = ids.split(',');
	    var flag = true;
	    var i=1;
	    while(flag){
	    	dailyNos = dailyNos+","+params[i];
	    	
	    	var audit_status = document.getElementById("audit_status_"+params[i]).value;
	     
		    if(audit_status == "3"){
		    	alert("有已经审批通过的，不能删除！");
		    	return;
		    }
	    	
	    	i=i+3;
	    	if(i > params.length){
	    		flag = false;
	    	}
	    }
	    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WsDailyReportSrv", "deleteDailyReport", "dailyNos="+dailyNos.substr(1));
			queryData(cruConfig.currentPage);
		}
		
	}
	
	//function dbclickRow(ids){
		//var idss = ids.split(",");
	 //   var ids = idss[0];
	//    var ids1 = idss[1];
	 //   var ids2 = idss[2];
	//	popWindow('<%=contextPath%>/ws/pm/dailyReport/singleProject/viewDailyReport.jsp?daily_no='+ids1+'&project_info_no='+ids+'&produce_date='+ids2,'1280:800');
//	}

	function toSearch(){
		popWindow('<%=contextPath%>/pm/dailyReport/multiProject/ws/daily_search.jsp?orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
	}
	
	function openGis(projectInfoNo,dailyNo,produceDate){
		alert(projectInfoNo+"p");
		
		var projectInfoNo = projectInfoNo;
		var dailyNo = dailyNo;
		var produceDate = produceDate;
		
		popWindow('<%=contextPath%>/pm/dailyReport/multiProject/ws/viewDailyReport.jsp?daily_no_ws='+dailyNo+'&project_info_no='+projectInfoNo+'&produce_date='+produceDate,'1280:740');
	
	}
	
	// 审批日报
	function audit(audit_status){
		//debugger;
		var dailyNos = "";
	    row_data_str = getSelIds('rdo_entity_id');
	    if(row_data_str==''){ alert("请先选中一条记录!");
	     	return;
	    }else{
	    	var row_data = row_data_str.split(",") ;
		    var projectInfoNo = row_data[0] ;
		    var dailyNo = row_data[1] ;
		    var produceDate = row_data[2] ; 	
		    var retObj = jcdpCallService("WsDailyReportSrv", "getDailyReportInfo", "dailyNo="+dailyNo+"&projectInfoNo="+projectInfoNo+"&produceDate="+produceDate);
		    var if_build = retObj.build.ifBuild ; 	
			var audit_status_tmp = retObj.build.auditStatus ;	//审批状态  
			if( !strIsNullOrEmpty(audit_status_tmp) ){
				if( audit_status_tmp=="1" || audit_status_tmp=="2" ){		/* 审批状态 处于“待审批”和“审批中的”的前提下，可以审批 */
					var retObj = jcdpCallService("WsDailyReportSrv", "auditDailyReport", "dailyNo="+dailyNo+"&projectInfoNo="+projectInfoNo+"&produceDate="+produceDate+"&audit_status="+audit_status+"&if_build="+if_build);
					queryData(cruConfig.currentPage);	//审批后刷新数据
				}else{	/* 审批状态 处于“修订（尚未提交）”、“审批通过”和“审批不通过”的前提下，不能审批 */
					var msg="";
					if(audit_status_tmp=="0"){
						msg="该日报尚未提交！";
					}else if(audit_status_tmp=="3"){
						msg="该日报已审批通过！";
					}else if(audit_status_tmp=="4"){
						msg="该日报审批未通过！";
					}
					if(msg!=""){
						alert(msg);
					}
				}
			}
	    }
	}
	
</script>

</html>

