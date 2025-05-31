<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
 <frameset  rows="280,0"  frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/op/projectEvaluation/evaluation_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe"/>
  <frame src="<%=contextPath %>/op/projectEvaluation/evaluation_value.jsp" name="menuFrame" frameborder="no" scrolling="auto" id="menuFrame"/>
 </frameset>
 