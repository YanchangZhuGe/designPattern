<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>

<frameset cols="300,*" frameborder="yes" border="0" framespacing="0">

  <frame src="<%=contextPath%>/doc/common/common_folder_list_eps.jsp" name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  
  <frame src="<%=contextPath%>/doc/multiproject/doc_list_eps.jsp" name="mainFrame" frameborder="no" scrolling="auto" id="mainFrame" style="border-left: 2px solid #5796DD; cursor: w-resize;"/> 

</frameset>