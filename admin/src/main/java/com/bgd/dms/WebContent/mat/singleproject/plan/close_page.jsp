<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
//	var ctt = top.frames('list');
//	ctt.refreshData();
//	window.value='2';
	newClose();
	
	
	function newClose(){
		debugger;
    	if(parent.topDialogs!=null&&parent.topDialogs!=undefined){
    		var dialog = parent.topDialogs.pop();
    		debugger;
    		top.topDialogs[parent.topDialogs.length-1][0].get(0).contentWindow.newClose();
    		dialog[0].remove();
    		dialog[1].remove();
    	}
    }

</script>
</head>
<body>
	<!-- <input type="button" value="close" onclick="refreshData()"/> -->
</body>
