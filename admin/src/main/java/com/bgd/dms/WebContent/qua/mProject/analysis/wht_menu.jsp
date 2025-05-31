<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
 <frameset  cols="300,*"  frameborder="yes" border="0" framespacing="0"><%-- <%=contextPath %>/qua/mProject/analysis/wht_analysis.jsp --%>
  <frame src="<%=contextPath %>/qua/mProject/analysis/wht_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="" name="menuFrame" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="menuFrame"/>
 </frameset>
 