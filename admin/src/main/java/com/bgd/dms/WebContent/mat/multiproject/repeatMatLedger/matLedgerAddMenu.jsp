<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
%>
 <frameset cols="320,*"  frameborder="yes" border="0" framespacing="1">
  <frame src="<%=contextPath %>/mat/multiproject/repeatMatLedger/matLedgerAddTree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" noresize="noresize" id="mainTopframe"/>
  <frame src="<%=contextPath %>/mat/multiproject/repeatMatLedger/matAddItemList.jsp" name="menuFrame" frameborder="no" scrolling="auto" noresize="noresize" id="menuFrame"/>
 </frameset>
 