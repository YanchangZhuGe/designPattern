<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.bgp.mcs.service.wt.pm.service.dailyReport.WtDailyReportSrv"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.constant.MVCConstant"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
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
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("project_info_no") != null ? request.getParameter("project_info_no"):"";

 WtDailyReportSrv wtsrv = new WtDailyReportSrv();
  List<Map> list=(List)wtsrv.getOrgId(projectInfoNo);
  Map mapFields = wtsrv.getListForFields(projectInfoNo);

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
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>无标题文档</title>
</head>
<script type="text/javascript">
function dailyChange(){
	 
 	window.location.href('<%=contextPath%>/pm/dailyReport/multiProject/wt/wtLengthReportList.jsp?project_info_no=<%=projectInfoNo%>&orgId=<%=orgId%>');
	
}
function dailyChange1(){
	 
 	window.location.href('<%=contextPath%>/pm/dailyReport/multiProject/wt/reportListAuditDrill.jsp?project_info_no=<%=projectInfoNo%>&orgId=<%=orgId%>');
	
}
</script>
<body style="background:#fff"  onload="frameSize()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td>
			   <!--
			 	     <auth:ListButton functionId="" css="xg" event="onclick='toUpdate()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			     -->
			   <input type="button" name="daily_mian" id="daily_mian" value="面积、长度/公里数" onclick="dailyChange();"></input>
			     <input type="button" name="daily_mian1" id="daily_mian1" value="坐标点" onclick="dailyChange1();"></input>
			   </td>
			  
			        
		<%if(orgId!=null&&(orgId.equals("C6000000000124")||orgId.equals("C6000000004707")||orgId.equals("C6000000005592")||orgId.equals("C6000000005594")||orgId.equals("C6000000005595")||orgId.equals("C6000000005605"))) {%>
		    <auth:ListButton tdid="tj" functionId="" css="tj" event="onclick='toSubmit(3)'" title="JCDP_btn_audit"></auth:ListButton>
	    	<auth:ListButton tdid="gb" functionId="" css="gb" event="onclick='toSubmit(4)'" title="JCDP_btn_audit"></auth:ListButton>
		    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
		<%} %>
			     
			    
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{produce_date},{audit_status},{if_build},{weather},<%=projectInfoNo %>,{daily_no_wt}' id='rdo_entity_id' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{produce_date}<input type='hidden' name='audit_status_{daily_no}' id='audit_status_{daily_no}' value='{audit_status}'/>" >施工日期</td>
			   
			  <% if(list!=null) {
				  for(int i=0;i<list.size();i++){
					  Map map=(Map)list.get(i);
					 
						  %>
 
						 
						  <td id="info_zhong" class="bt_info_even" exp="{<%=mapFields.get("exploration_method"+i) %>}"><%=map.get("exploration_method_name"+i) %></td>
					       <td class="bt_info_even" exp="{<%=mapFields.get("exploration_method_name"+i) %>}%" ><%=map.get("exploration_method_name"+i) %></td>

			  <%	
				  }
				  }
			  %>
			      
			      <!--<td class="bt_info_even" exp="{audit_status}" func="getOpValue,audit_status1">审批状态</td>-->
			      <!-- 
			      			          <td class="bt_info_odd" exp="<a href='#'  onclick=openGis('{project_info_no}')>查看</a>" >日报进度图</td>
			      
			      <td class="bt_info_odd" exp="<a href='#'  onclick=openGis('{project_info_no}','{daily_no_ws}','{produce_date}')>查看</a>" >生产日报</td>
			    -->
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

debugger;

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


debugger;



	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "WtDailyReportSrv";
	cruConfig.queryOp = "queryDailyReportList";
	var projectInfoNo = "<%=projectInfoNo%>";
	
	var orgSubjectionId = "<%=orgSubjectionId %>";
	var fromPage = "<%=fromPage%>";
	// 复杂查询
	
	function refreshData(q_projectName, q_orgName, q_projectStatus, q_auditStatus, q_projectType, q_orgSubjectionId){

		cruConfig.submitStr = "projectStatus="+q_projectStatus+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&auditStatus="+q_auditStatus+"&projectType="+q_projectType+"&orgName="+q_orgName+"&projectInfoNo="+projectInfoNo+"&multi=1";
		queryData(1);
	}
	refreshData("", "", "", "", "",  "<%=orgSubjectionId%>");

	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName, "", "", "", "", "", orgSubjectionId);
	}
	function loadDataDetail(id){
		var ids = getSelIds('rdo_entity_id');
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
		debugger;

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
	    	var audit_status = params[i] ;
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
			
			var retObj = jcdpCallService("WtDailyReportSrv", "deleteDailyReport", "projectInfoNo=<%=projectInfoNo %>&produceDate="+params[0]);
			queryData(cruConfig.currentPage);
		}
		
	}
	
	function toUpdate(){
		debugger;

	   var ids = getSelIds('rdo_entity_id');
	    var idss = ids.split(",");
	 	    var ids= idss[0];
 
			   var ids1 = idss[1];
			    var ids2 = idss[2];
			    var ids3=idss[3];
	 	    var ids4=idss[4];
	 	   var ids5=idss[5];
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    var params = ids.split(',');
	    var flag = true;
	    var i=1;
	    while(flag){
	    
	    	var audit_status = params[i];
		    if(audit_status == "3"){
		    	alert("有已经审批通过的，不能删除！");
		    	return;
		    }
	    	i=i+3;
	    	if(i > params.length){
	    		flag = false;
	    	}
	    }
	    
		if(confirm('确定要修改吗?')){  
	 
		
 
		    popWindow('<%=contextPath%>/pm/dailyReport/singleProject/wt/updateView.jsp?produce_date='+ids+'&status='+ids1+'&build='+ids2+'&weather='+ids3+'&daily_no_wt='+ids5,'1280:700');

			//var retObj = jcdpCallService("WtDailyReportSrv", "updateDailyReport", "projectInfoNo=<%=projectInfoNo %>&produceDate="+ids);
			//queryData(cruConfig.currentPage);
		}
		
	}
	
	function dbclickRow(ids){
	
		var idss = ids.split(",");
	    var ids = idss[0];
	   var ids1 = idss[1];
	    var ids2 = idss[2];
	    var ids3=idss[3];
	    var ids5=idss[5];
	    var ids4=idss[4];
  
	    popWindow('<%=contextPath%>/pm/dailyReport/multiProject/wt/viewDailyReport.jsp?produce_date='+ids+'&status='+ids1+'&build='+ids2+'&weather='+ids3+'&projectInfoNo='+ids4+'&daily_no_wt='+ids5,'1280:800');

	}

	function toSearch(){
		popWindow('<%=contextPath%>/ws/pm/dailyReport/singleProject/daily_search.jsp?orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
	}
	
	function openGis(projectInfoNo,dailyNo,produceDate){

		
		var projectInfoNo = projectInfoNo;
		var dailyNo = dailyNo;
		var produceDate = produceDate;
		
		popWindow('<%=contextPath%>/ws/pm/dailyReport/singleProject/viewDailyReport.jsp?daily_no_ws='+dailyNo+'&project_info_no='+projectInfoNo+'&produce_date='+produceDate,'1280:800');
	
	}
	
	/*** 提交已录入保存的日报 ***/
	function toSubmit(status_p){
		debugger;
		var dailyNos = "";
	    row_data_str = getSelIds('rdo_entity_id');
	    if(row_data_str==''){ alert("请先选中一条记录!");
	     	return;
	    }else{
	    	var row_data = row_data_str.split(",") ;
		    var project_info_no = row_data[4] ;
		    var daily_no = row_data[5] ;
		    var produce_date = row_data[0] ; 
		    var retObj = jcdpCallService("WtDailyReportSrv", "getDailyReportInfo", "dailyNo="+daily_no+"&projectInfoNo="+project_info_no+"&produceDate="+produce_date);
			var audit_status = row_data[1] ;	//审批状态 
			if( audit_status!=""&&audit_status!=null ){
				if( audit_status=="1" || audit_status=="2" ){		/* 审批状态 处于“已提交”和“待审批”的前提下，才能审批 */
					var retObj = jcdpCallService("WtDailyReportSrv", "submitDailyReport", "dailyNo="+daily_no+"&projectInfoNo="+project_info_no+"&produceDate="+produce_date+"&audit_status="+status_p);
					queryData(cruConfig.currentPage);	//提交后刷新数据
				}else{	/* 审批状态 处于“未提交”、“审批通过”和“审批不通过”的前提下，不能审批 */
					var msg="";
					if(audit_status=="0"){
						msg="该日报未提交！";
					}else if(audit_status=="3"){
						msg="该日报审批已通过！";
					}else if(audit_status=="3"){
						msg="该日报已经审批未通过！";
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

