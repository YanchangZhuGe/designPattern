<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
	  response.setHeader("Pragma","No-cache"); 
	  response.setHeader("Cache-Control","no-cache"); 
	  response.setDateHeader("Expires", 0);
	  
	  request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<input type="button" value="submit" onclick="tj()"/>

<script type="text/javascript">

function tj(){
	window.location = "<%=contextPath%>/demo/test.jsp?index=中国";
}
</script>
</body>
</html>