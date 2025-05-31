<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String id = request.getParameter("id");
	if(id==null){
		id ="";
	}
	String creatorId = request.getParameter("creatorId");
	String isUser = request.getParameter("isUser");
%>

 <frameset  cols="250,*"  frameborder="yes" border="0" framespacing="0">
  <frame src="portlet_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="portlet.jsp?id=<%=id %>&creatorId=<%=creatorId %>&isUser=<%=isUser %>" name="menuFrame" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="menuFrame"/>
 </frameset>
 