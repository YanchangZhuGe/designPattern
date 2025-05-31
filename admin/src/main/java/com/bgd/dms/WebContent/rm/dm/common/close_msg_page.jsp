<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
	//导入返回信息
	String errorMsg = ""; 
	if(null != responseDTO.getValue("errorMsg")){
		errorMsg = responseDTO.getValue("errorMsg");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script language="javaScript">
$(function(){
	//导入返回信息
	var errorMsg = "<%=errorMsg%>";
	if(null == errorMsg || "" == errorMsg){
		refreshData();
		newClose();
	}else{
		getErrorMsg(errorMsg);
	}	
});

function getErrorMsg(errorMsg){
	$("#errorMsg").append(errorMsg);
}
</script>
</head>
<body>
	<div id="errorMsg"></div>
	<!-- <input type="button" value="close" onclick="refreshData()"/> -->
</body>
