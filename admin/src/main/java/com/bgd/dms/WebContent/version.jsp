<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%
	String contextPath = request.getContextPath();
	String buildTime = "";
	String lastRev = "";
	String path = this.getServletContext().getRealPath("/WEB-INF/config/rev.properties");
	File file = new File(path);
	
	if(file.exists()){
		FileInputStream is = new FileInputStream(file);
		Properties prop = new Properties();
		prop.load(is);
		buildTime = prop.getProperty("build.time");
		lastRev = prop.getProperty("svn.info.lastRev");
		is.close();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>东方地球物理公司生产运行管理系统-版本</title>
</head>
<body>
<p>构建时间：<%=buildTime %></p>
<p>SVN版本号：<%=lastRev %></p>
</body>
</html>