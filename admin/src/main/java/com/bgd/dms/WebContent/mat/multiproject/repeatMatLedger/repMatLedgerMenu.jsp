<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
%>
 <frameset cols="320,*"  frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/mat/multiproject/repeatMatLedger/repMatLedgerTree.jsp" name="mainTopframe" frameborder="no" scrolling="auto"  id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/mat/multiproject/repeatMatLedger/repMatItemList.jsp" name="menuFrame" frameborder="no" scrolling="auto" id="menuFrame" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
 </frameset>
 