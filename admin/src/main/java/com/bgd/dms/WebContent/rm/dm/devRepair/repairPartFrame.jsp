<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String path = request.getContextPath();
%>
<frameset rows="*" cols="260,*" frameborder="no" border="0" framespacing="0">
  <frame src="repairPartTree.jsp" name="treeFrame" frameborder="no" scrolling="No" noresize="noresize" id="mainTopframe"/>
  <frame src="<%=path%>/rm/dm/devRepair/repairPartDetailList.jsp?id=INIT_REPAIR_012345678900000" name="menuFrame" frameborder="no" scrolling="No" noresize="noresize" id="mainDownframe"/>
</frameset>
