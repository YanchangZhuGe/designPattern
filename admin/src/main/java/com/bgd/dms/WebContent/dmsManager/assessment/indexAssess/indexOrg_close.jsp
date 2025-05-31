<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
	String operationFlag ="";
	if(null!=responseDTO){
		operationFlag = responseDTO.getValue("operationFlag");
	}
	String org_id ="";
	if(null!=responseDTO){
		org_id = responseDTO.getValue("org_id");
	}
	String org_subjection_id ="";
	if(null!=responseDTO){
		org_subjection_id = responseDTO.getValue("org_subjection_id");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
	var operationFlag="<%=operationFlag%>";
	if(''!=operationFlag){
		if("failed"==operationFlag){
			alert("保存失败！");
		}	
		if("success"==operationFlag){
			alert("保存成功！");
		}
	}
	//获取顶层页面下的iframe(id='indexFrame')
	//var indexFrame=top.document.getElementById('indexFrame');
	//获取iframe(id='indexFrame')页面下的iframe(id='list')
	//var list=indexFrame.contentWindow.document.getElementById('list');
	//获取iframe(id='list')页面下的frameset中的frame页面(id='mainFrame')
	//var mainFrame=list.contentWindow.document.frames['mainFrame'];
	//调用刷新方法mainFrame.
	refreshData("","<%=org_id%>","<%=org_subjection_id%>");
	newClose();
</script>
</head>
<body>
</body>
