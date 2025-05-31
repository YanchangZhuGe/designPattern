<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
  <frameset cols="300,*" frameborder="yes" border="0" framespacing="0">
    <frame src="<%=contextPath %>/doc/multiproject/folder_tree_eps.jsp" name="mainTopframe" frameborder="no" scrolling="auto" noresize="noresize" id="mainTopframe"/>
    <frame src="" name="menuFrame" frameborder="no" scrolling="auto" noresize="noresize" id="mainDownframe"/> 
  </frameset>
