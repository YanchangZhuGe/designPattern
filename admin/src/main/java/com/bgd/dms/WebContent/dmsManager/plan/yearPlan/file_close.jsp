<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>

<%
	String contextPath = request.getContextPath();
	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
	//记录导入操作是否成功
  	String operationFlag = responseDTO.getValue("operationFlag");
  	//申请id
  	String applyId = responseDTO.getValue("applyId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"> 
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script language="javaScript">
		//记录保存操作是否成功
		var operationFlag="<%=operationFlag%>";
		//申请id
		var applyId="<%=applyId%>";
		if("success"==operationFlag){
			//刷新
			 top.frames['list'][2].refreshData();
		}else{
			alert("保存失败！");
		}
		newClose();
	</script>
</head>
<body>
</body>