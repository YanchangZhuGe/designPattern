<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
	  response.setHeader("Pragma","No-cache"); 
	  response.setHeader("Cache-Control","no-cache"); 
	  response.setDateHeader("Expires", 0);
	  
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body>
<center>
	<input type="button" value="popWindow" onclick="showframes()"/>
	<br></br>
	<div>下一层传递来的消息：</div>
	<input type="text" name="showMessage"/>
	<input type="text" name="showMessage2"/>
</center>
</body>
<script type="text/javascript">
	function showframes(){
		popWindow("<%=contextPath%>/demo/testPopWindow3.jsp");
	}
	function getMessage(arg){
		document.getElementsByName("showMessage")[0].value=arg[0];
		document.getElementsByName("showMessage2")[0].value=arg[1];
	}
</script>
</html>