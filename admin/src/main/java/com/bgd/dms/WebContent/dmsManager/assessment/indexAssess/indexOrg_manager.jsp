<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>

<frameset cols="200,*" frameborder="yes" border="0" framespacing="0">

  <frame src="indexOrg_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  
  <frame src="indexOrg_list.jsp" name="mainFrame" frameborder="no" scrolling="auto" id="mainFrame" style="border-left: 2px solid #5796DD; cursor: w-resize;"/> 

</frameset>