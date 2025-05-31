<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
 
<%

	String contextPath = request.getContextPath();
	String devappid=request.getParameter("devAppId");
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>备注页面</title>
</head>
<body style="background:#e8eaeb" onload="refreshData()"> 	
	<fieldset style="margin-left:2px;width:98%"><legend>备注信息</legend>
		<table width="100%" border="0"   cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			   <td class="even" >	
			    	<textarea id="notes" name="notes"  class="textarea" readonly></textarea>			      
			   </td>			  
			</tr>
		</table>
	</fieldset>
</body>
<script type="text/javascript">
function frameSize(){
	$("#queryRetTable").css("height",$(window).height()-36);
	$("#notes").css("height",$(window).height()-48);
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script>

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var foreignKeyId='<%=devappid%>';
 
	 function refreshData(){
		 if(foreignKeyId != 'null' && foreignKeyId != ""){
			var querySql = "select t.notes from BGP_COMM_REMARK t where t.foreign_key_id= '" + foreignKeyId + "' and t.bsflag='0' ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			if(queryRet.datas.length!='0'){
				document.getElementsByName("notes")[0].value=queryRet.datas[0].notes;	
				 
			}
		 }		 
	 }
</script>
</html>