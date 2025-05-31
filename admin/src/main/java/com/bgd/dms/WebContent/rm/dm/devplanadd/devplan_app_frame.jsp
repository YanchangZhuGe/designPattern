<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

	String wbsBackUrl = "/rm/dm/devplanadd/wbsPlanList.jsp";
	String taskBackUrl = "/rm/dm/devplanadd/taskPlanList.jsp";
	String rootBackUrl = "/rm/dm/devplanadd/rootPlanList.jsp";
	
	String deviceaddappid = request.getParameter("deviceaddappid");
	String deviceallappid = request.getParameter("allappid");
	String sonFlag = request.getParameter("sonFlag");
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo")==null?user.getProjectInfoNo():request.getParameter("projectInfoNo");
%>

<frameset cols="300,*" frameborder="yes" border="0" framespacing="1">
  <frame src="<%=contextPath %>/p6/tree/tree.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>&customKey=idinfo,allappid,sonFlag&customValue=<%=deviceaddappid%>,<%=deviceallappid%>,<%=sonFlag%>" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="<%=contextPath %>/rm/dm/devplanadd/rootPlanList.jsp?projectInfoNo=<%=projectInfoNo%>&idinfo=<%=deviceaddappid%>&allappid=<%=deviceallappid%>&sonFlag=<%=sonFlag%>" name="mainRightframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>
