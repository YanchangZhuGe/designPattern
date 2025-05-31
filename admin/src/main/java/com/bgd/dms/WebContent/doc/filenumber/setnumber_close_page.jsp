<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String number_format_value = respMsg.getValue("numberFormatValue");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">

	if('<%=number_format_value%>'!=""&&'<%=number_format_value%>'!=null){
		getFormatValue();
	}	
	newClose();

	function getFormatValue(){
		var ctt = top.frames['list'];
		if('<%=number_format_value%>'!=""&&'<%=number_format_value%>'!=null){
			ctt.document.getElementById("number_format").value = '<%=number_format_value%>';
		}
	}


</script>
</head>
<body>
	<!-- <input type="button" value="close" onclick="refreshData()"/> -->
</body>