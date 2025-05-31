<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
UserToken user = OMSMVCUtil.getUserToken(request);
	String contextPath = request.getContextPath();

	String orgSubjectionId = user.getOrgSubjectionId();
	if( orgSubjectionId== null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	String orgId =user.getOrgId();
 
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	String fromPage = request.getParameter("fromPage");
	
	String projectType="5000100004000000009";
	 
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

<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名</td>
			    <td class="ali_cdn_input">
				    <input id="projectName" name="projectName" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no},{daily_no},{produce_date},{project_name}' id='rdo_entity_id_{project_info_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}" >项目名称</td>
			      <td class="bt_info_even" exp="{org_name}" >施工队伍</td>
			      <td class="bt_info_odd" exp="{produce_date}" >施工日期</td>
			      <!--<td class="bt_info_even" exp="{audit_status}" func="getOpValue,audit_status1">审批状态</td>-->
			      <!-- <td class="bt_info_odd" exp="<a href='#'  onclick=openChart('{project_info_no}')>查看</a>" >日报数据分析</td>
			      <td class="bt_info_even" exp="<a href='#'  onclick=openGis('{project_info_no},{produce_date}')>查看</a>" >日报进度图</td>
			       -->
			      <td class="bt_info_odd" exp="<a href='#'  onclick=openProcess('{project_info_no}')>查看</a>" >生产进度</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">日问题信息</a></li>
			  </ul>
			</div>
			 -->
			 <!-- 
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content" >
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
				 -->
				<!-- 
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="dailyQuestion" id="dailyQuestion" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
				</div>
				 -->
			</div>
		  </div>

</body>
<script type="text/javascript">

var audit_status1 = new Array(
		['0','未提交'],['1','待审批'],['2',''],['3','审批通过'],['4','审批不通过']
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
	cruConfig.queryService = "WtDailyReportSrv";
	cruConfig.queryOp = "queryDailyReport";
	var orgSubjectionId = "<%=orgSubjectionId %>";
	var org_id_ = "<%=orgId%>";
	var fromPage = "<%=fromPage%>";
	
	// 复杂查询
	function refreshData(q_projectName, q_orgId, q_projectStatus, q_auditStatus, q_projectType, q_orgSubjectionId){
debugger;
		  q_projectName=document.getElementById("projectName").value;
		
		cruConfig.submitStr = "projectStatus="+q_projectStatus+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&auditStatus="+q_auditStatus+"&projectType="+q_projectType+"&orgId="+q_orgId;
		queryData(1);
	}

	refreshData("", "<%=orgId%>", "", "", "<%=projectType%>",  "<%=orgSubjectionId%>");
	// 简单查询
	function simpleRefreshData(){
		debugger;
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName, "<%=orgId%>", "","","<%=projectType%>", orgSubjectionId);
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
		//document.getElementById("dailyQuestion").src = "<%=contextPath%>/pm/dailyReport/singleProject/dailyQuestionList.jsp?projectInfoNo="+ids;
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中至少一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ProjectSrv", "deleteProject", "projectInfoNos="+ids);
			queryData(cruConfig.currentPage);
		}
	}
	
	function dbclickRow(ids){
		var idss = ids.split(",");
	    var ids = idss[0];
	    var ids1 = idss[1];
	    var ids2 = idss[2];
	    var ids3 = idss[3];
	    var projectName = encodeURI(encodeURI(ids3,'UTF-8'),'UTF-8');
	    //改成待审批日报列表形式 reportListAuditDispatch.jsp
	   // alert(ids);
	  	popWindow('<%=contextPath%>/pm/dailyReport/multiProject/wt/reportListAuditDispatch.jsp?daily_no='+ids1+'&project_info_no='+ids+'&produce_date='+ids2+'&projectName='+projectName+'&orgId='+org_id_,'1280:800');
	 }

	function toSearch(){
		popWindow('<%=contextPath%>/pm/dailyReport/multiProject/daily_search.jsp?orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
	}
	
	function openChart(projectInfoNo){
		popWindow('<%=contextPath%>/pm/chart/pmChartFrame.jsp?projectInfoNo='+projectInfoNo,'1280:800');
	}
	
	function openGis(projectInfoNo,time){
		popWindow("http://10.21.8.26/GeoCreator/Templete.html?projNo=8ad8827334181c0e01341ce0874300d6&time=2012-10-25&spType=cj&upstate=true&orgid=C6000000000001&orgsubid=C105&url=10.88.2.240:80","1280:800");
	}
	function openProcess(projectInfoNo){
		window.open('<%=contextPath%>/pm/dailyReport/multiProject/wt/dailyreportWtprocess.jsp?projectInfoNo='+projectInfoNo);
	}
</script>

</html>

