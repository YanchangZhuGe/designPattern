<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	String bussId = request.getParameter("bussId");
	if(bussId==null||bussId.equals("")){
		bussId = "";
	}
%>
 <frameset cols="320,*"  frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/mat/multiproject/matLedger/matLedgerTree.jsp?bussId=<%=bussId %>" name="mainTopframe" frameborder="no" scrolling="auto"  id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/mat/multiproject/matLedger/matItemList.jsp?bussId=<%=bussId %>" name="menuFrame" frameborder="no" scrolling="auto"  id="menuFrame" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
 </frameset>
 