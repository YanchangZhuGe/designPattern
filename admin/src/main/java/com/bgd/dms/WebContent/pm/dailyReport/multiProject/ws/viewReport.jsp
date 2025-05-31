<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=GBK" pageEncoding="GBK"%>
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
			 
			      </td>
			    <td>&nbsp;</td>
	 
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
 			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
  <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{projectInfoNo},{projectName}' id='rdo_entity_id' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{projectName}" >项目名称</td>
			      <td class="bt_info_even" exp="{orgName}" >施工队伍</td>
			      <td class="bt_info_odd" exp="{startTime}" >施工日期</td>
			      <td class="bt_info_odd" exp="{endTime}" >结束日期</td>
			   
			      <td class="bt_info_even" exp="{auditStatus}" func="getOpValue,audit_status1">审批状态</td>
			   
			    
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
		  </div>

</body>
<script type="text/javascript">
var audit_status1 = new Array(
		[' ','未提交'],['1','待审批'],['3','审批通过'],['4','审批不通过'] 
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
	cruConfig.queryOp = "querViewReport";
 
	
	// 复杂查询
 
		function refreshData(){
 
		  		queryData(1);
	}
 
		refreshData();
		// 简单查询
		function simpleRefreshData(){
			debugger;
		 
			refreshData( );
		}
	 
	//    var projectName = encodeURI(encodeURI(ids3,'UTF-8'),'UTF-8');
	function dbclickRow(ids){
		debugger;
		 var idss=document.getElementById("rdo_entity_id").value;
 		var idss = ids.split(",");
	    var ids = idss[0];
	    
	    var ids1 = encodeURI(encodeURI(idss[1],'UTF-8'),'UTF-8');
	    //改成待审批日报列表形式 reportListAuditDispatch.jsp
	   // alert(ids);
	  	popWindow('<%=contextPath%>/pm/dailyReport/multiProject/ws/multiReport.jsp?projectInfoNo='+ids+'&projectName='+ids1,'1280:800');
	  	//popWindow('<%=contextPath%>/pm/dailyReport/multiProject/viewDailyReport.jsp?daily_no='+ids1+'&project_info_no='+ids+'&produce_date='+ids2,'1280:800');
	}
	 
	function audit(audit_status){
		debugger;
	 
	    row_data_str = getSelIds('rdo_entity_id');
	    if(row_data_str==''){ alert("请先选中一条记录!");
	     	return;
	    }else{
	    	var row_data = row_data_str.split(",") ;
		    var projectInfoNo = row_data[0] ;
		    var retObj = jcdpCallService("WsDailyReportSrv", "getAustaus", "projectInfoNo="+projectInfoNo);
 
			var audit_status_tmp = retObj.dailyMap.auditStatus ;	//审批状态  
			 
				if( audit_status_tmp=="1" ){		/* 审批状态 处于“待审批”和“审批中的”的前提下，可以审批 */
					var retObj = jcdpCallService("WsDailyReportSrv", "updateAustaus", "projectInfoNo="+projectInfoNo+"&audit_status="+audit_status);
					queryData(cruConfig.currentPage);	//审批后刷新数据
				}else{	/* 审批状态 处于“修订（尚未提交）”、“审批通过”和“审批不通过”的前提下，不能审批 */
					var msg="";
					if(audit_status_tmp==""){
						msg="该日报尚未提交！";
					}else if(audit_status_tmp=="2"){
						msg="该日报已审批通过！";
					}else if(audit_status_tmp=="3"){
						msg="该日报审批未通过！";
					}
					if(msg!=""){
						alert(msg);
					}
				 
			}
	    }
	}
 
</script>

</html>

