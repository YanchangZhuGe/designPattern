<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String path = request.getContextPath();
%>
<frameset rows="*" cols="230,*" frameborder="no" border="0" framespacing="0">
  <frame src="collMenuTree.jsp" name="treeFrame" frameborder="no" scrolling="No" noresize="noresize" id="mainTopframe"/>
  <frame src="<%=path%>/ibp/auth2/menu/collList.lpmd" name="menuFrame" frameborder="no" scrolling="No" noresize="noresize" id="mainDownframe"/>
</frameset>
