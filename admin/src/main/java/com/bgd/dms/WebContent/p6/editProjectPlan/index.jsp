<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	//String projectInfoNo = "8ad8918341be9eb70141bf17c19f0048";
%>

<frameset rows="350,*" cols="*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=contextPath %>/p6/editProjectPlan/projectPlanTree.jsp?projectInfoNo=<%=projectInfoNo %>" name="mainTopframe" frameborder="no" scrolling="no"  id="mainTopframe" style="border-buttom: 2px solid #5796DD;cursor: s-resize;"/>
  <frame src="<%=contextPath %>/p6/editProjectPlan/editInfoEmpty.jsp" name="mainDownframe" frameborder="no" scrolling="auto"  id="mainDownframe" style="border-top: 2px solid #5796DD; cursor: s-resize;"/>
</frameset>
