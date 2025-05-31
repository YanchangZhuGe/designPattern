<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="<%=contextPath%>/common/include/quotesresource.jsp"%>
<%@include file="<%=contextPath%>/common/include/easyuiresource.jsp"%>
<meta http-equiv="Content-Type" content="text/html;" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script language="javaScript">
	debugger;
	//alert($(window.frames["mainFrame"]).html());
	//$(window.frames["mainFrame"].document).find("table").each(function(){
    //	alert($(this).html());
  	//});
	$("#mixcoll_grid").datagrid('reload');
	newClose();
</script>
</head>
<body>
	<!-- <input type="button" value="close" onclick="refreshData()"/> -->
</body>
