<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

	String backUrl = request.getParameter("backUrl");
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	if (backUrl == null || "".equals(backUrl)) {
		backUrl = respMsg.getValue("backUrl");
	}
	
%>
<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0" framespacing="0">
  <frame src="<%=contextPath %>/pm/comm/eps_tree.jsp?backUrl=<%=backUrl %>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/pm/projectHealthInfo/reportList.jsp" name="mainRightframe" frameborder="no" scrolling="auto"  id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
