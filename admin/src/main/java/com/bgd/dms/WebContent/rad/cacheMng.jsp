<%@page contentType="text/html;charset=utf-8"%>
<%
  String contextPath = request.getContextPath();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
	function Save1(){
		form1.submit();
	}
	
	function Save2(){
		form1.cacheType.value = "srvCfg";
		form1.submit();
	}
	function Save3(){
		form1.action = "<%=contextPath%>/auth/reloadInterCache.srq";
		form1.submit();
	}	
</script>
</head>
<body>
<form name="form1" action="<%=contextPath%>/auth/reloadCache.srq" method="post">
<input type="hidden" name="cacheType" value="auth"/>
<table>
<tr>
<td>
	<input type="button" value="服务数据更新" onclick="Save2()"/>
</td>
</tr>
<tr>
<td>
	<input type="button" value="权限数据更新" onclick="Save1()"/>
</td>
</tr>
<tr>
<td>
	<input type="button" value="国际化数据更新" onclick="Save3()"/>
</td>
</tr>
</table>
</form>
</body>
</html>
