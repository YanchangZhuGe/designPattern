<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	String bussId = request.getParameter("bussId");
%>
 <frameset cols="320,*"  frameborder="yes" border="0" framespacing="1">
  <frame src="<%=contextPath %>/mat/multiproject/matLedger/matLedgerTreeWTC.jsp?bussId=<%=bussId %>" name="mainTopframe" frameborder="no" scrolling="auto" noresize="noresize" id="mainTopframe"/>
  <frame src="<%=contextPath %>/mat/multiproject/matLedger/matItemListWTC.jsp?bussId=<%=bussId %>" name="menuFrame" frameborder="no" scrolling="auto" noresize="noresize" id="menuFrame"/>
 </frameset>
 