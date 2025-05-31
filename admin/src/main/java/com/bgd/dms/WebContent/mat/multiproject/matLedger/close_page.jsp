<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String taskId = (String)resultMsg.getValue("taskId");
	if(taskId==null || taskId.equals("")){
		taskId = "";
	} 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
	refreshData();
	newClose();
	function newClose() {
	//	var $parent = top.$;
		//$parent('#dialog').dialog('close');
		//self.parent.$("#dialogin").remove();
	//	$parent('#dialog').remove();
		parent.location.href="<%=contextPath%>/mat/multiproject/matLedger/close_page2.jsp";
	}
	function refreshData(){
		var ctt = parent.frames['list'];
		if(ctt.frames.length == 0){
			
			ctt.refreshData();
		}else{
			ctt.frames[1].refreshData();
		//	ctt.frames[1].location.href = '<%=contextPath %>/mat/multiproject/matLedger/matItemList.jsp' ;
		}
	} 
</script>
</head>
<body>
	<!-- <input type="button" value="close" onclick="refreshData()"/> -->
</body>
</html>
