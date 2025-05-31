<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
	String index = request.getParameter("index");
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
	<%=index %>
	<form action="<%=contextPath %>/demo/test.jsp" method="post" id="form1">
		<input type="text" name="index"/>
		<input type="submit" value="submit" onclick="tj()"/>
	</form>
	<a href="<%=contextPath%>/demo/test.jsp?index=中国">中国</a>

<script type="text/javascript">
//window.location = "<%=contextPath%>/demo/test1.jsp?index=中国";

function tj(){
	var pathName = document.location.href;
    var index = pathName.substr(9).indexOf("/");
    var result = pathName.substr(0,index+1);
    if(result!="/gms3") result="";alert(result);
    return result;
}
</script>
</body>
</html>