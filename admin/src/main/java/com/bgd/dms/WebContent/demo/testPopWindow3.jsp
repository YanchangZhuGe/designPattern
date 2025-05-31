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
	<input type="text" name="message"/>
	<input type="text" name="message2"/>
	<input type="button" value="submit" onclick="ok()"/>
</center>
</body>
<script type="text/javascript">
	function ok(){
		var message = document.getElementsByName('message')[0].value;
		var message2 = document.getElementsByName('message2')[0].value;
		top.dialogCallback('getMessage',[message, message2]);
		newClose();
	}
</script>
</html>