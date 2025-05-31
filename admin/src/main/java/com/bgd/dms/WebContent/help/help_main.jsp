<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>Insert title here</title>
</head>
<body style="background:#cdddef;overflow-y:scroll">
	<table border="4" align="center" ">
		<caption>帮助文档1.0</caption>
		<tr>
			<td align="center">模块名称</td>
			<td align="center">业务简介</td>
			<td align="center">上传时间</td>
			<td align="center">下载</td>
		</tr>
		<tr>
			<a href="<%=contextPath%>/help/CheckDev/helpcheckdev.jsp">
			<td align="center">设备验收</td>
			<td align="center">功能主要针对设备的状态，设备的完整度，以及设备问题进行汇总、解决。对供货商进行满意度调查。</td>
			<td align="center">2016-08-16</td>
			</a>
			<td align="center"><a href="<%=contextPath%>/help/CheckDev/CheckDev-20160816-V1.0.docx">点击下载</a></td>
		</tr>
	</table>
</body>
</html>