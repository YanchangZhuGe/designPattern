<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String path = request.getContextPath();
%>
<frameset rows="*" cols="380,*" frameborder="no" border="0" framespacing="0">
  <frame src="org_tree.jsp" name="treeFrame" frameborder="1" scrolling="No" noresize="noresize" id="mainTopframe"/>
  <frame src="<%=path%>/blank.htm" name="menuFrame" frameborder="1" scrolling="No" noresize="noresize" id="mainDownframe"/>
</frameset>