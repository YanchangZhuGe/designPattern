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

<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no},{daily_no},{produce_date}' id='rdo_entity_id_{daily_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{produce_date}<input type='hidden' name='audit_status_{daily_no}' id='audit_status_{daily_no}' value='{audit_status}'/>" >施工日期</td>
			      <td class="bt_info_even" exp="{sp}" >日完成工作量</td>
			       <td class="bt_info_odd" exp="{total_sp}" >累计完成工作量</td>
			      <td class="bt_info_odd" exp="{total_sp_radio}" >累计完成总工作量的百分比</td>		
			     
			      <td class="bt_info_even" exp="{audit_status}" func="getOpValue,audit_status1">审批状态</td>
			      <td class="bt_info_odd" exp="<a href='#'  onclick=openGis('{project_info_no}')>查看</a>" >日报进度图</td>
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
		  </div>

</body>
<script type="text/javascript">

var audit_status1 = new Array(
		['0','未提交'],['1','待审批'],['2',''],['3','审批通过'],['4','审批不通过']
		);

function frameSize(){
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

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "DailyReportSrv";
	cruConfig.queryOp = "queryDailyReportListSh";
	var orgSubjectionId = "<%=orgSubjectionId %>";
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
			var retObj = jcdpCallService("DailyReportSrv", "deleteDailyReport", "dailyNos="+dailyNos.substr(1));
			queryData(cruConfig.currentPage);
		}
		
	}
	
	function dbclickRow(ids){
		var idss = ids.split(",");
	    var ids = idss[0];
	    var ids1 = idss[1];
	    var ids2 = idss[2];
		popWindow('<%=contextPath%>/pm/dailyReport/singleProject/sh/viewDailyReport.jsp?daily_no='+ids1+'&project_info_no='+ids+'&produce_date='+ids2+'&orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>','1280:800');
	}

	function toSearch(){
		popWindow('<%=contextPath%>/pm/dailyReport/multiProject/daily_search.jsp?orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
	}
	
	function openGis(projectInfoNo){
		popWindow("http://10.21.8.26/GeoCreator/Templete.html?projNo=8ad8827334181c0e01341ce0874300d6&time=2012-10-25&spType=cj&upstate=true&orgid=C6000000000001&orgsubid=C105&url=10.88.2.240:80","1280:800");
	}
	
	/*** 提交已录入保存的日报 ***/
	function toSubmit(){
		//debugger;
		var dailyNos = "";
	    row_data_str = getSelIds('rdo_entity_id');
	    if(row_data_str==''){ alert("请先选中一条记录!");
	     	return;
	    }else{
	    	var row_data = row_data_str.split(",") ;
		    var project_info_no = row_data[0] ;
		    var daily_no = row_data[1] ;
		    var produce_date = row_data[2] ; 
		    var retObj = jcdpCallService("DailyReportSrv", "getDailyReportInfo", "dailyNo="+daily_no+"&projectInfoNo="+project_info_no+"&produceDate="+produce_date);
		    var survey_process_status = retObj.dailyMap.SURVEY_PROCESS_STATUS ; 
			var surface_process_status = retObj.dailyMap.SURFACE_PROCESS_STATUS ;
			var drill_process_status = retObj.dailyMap.DRILL_PROCESS_STATUS ;
			var collect_process_status = retObj.dailyMap.COLLECT_PROCESS_STATUS ;
			var audit_status = retObj.dailyMap.AUDIT_STATUS ;	//审批状态 
			if( !strIsNullOrEmpty(audit_status) ){
				if( audit_status=="0" || audit_status=="4" ){		/* 审批状态 处于“未提交”和“审批不通过”的前提下，才能提交 */
					var retObj = jcdpCallService("DailyReportSrv", "submitDailyReport", "dailyNo="+daily_no+"&projectInfoNo="+project_info_no+"&produceDate="+produce_date+"&survey_process_status="+survey_process_status+"&surface_process_status="+surface_process_status+"&drill_process_status="+drill_process_status+"&collect_process_status="+collect_process_status);
					queryData(cruConfig.currentPage);	//提交后刷新数据
				}else{	/* 审批状态 处于“待审批（已经提交）”、“审批中”和“审批通过”的前提下，不能提交 */
					var msg="";
					if(audit_status=="1"){
						msg="该日报已经提交，正在等待审批！";
					}else if(audit_status=="2"){
						msg="该日报正在审批中！";
					}else if(audit_status=="3"){
						msg="该日报已经审批通过！";
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

