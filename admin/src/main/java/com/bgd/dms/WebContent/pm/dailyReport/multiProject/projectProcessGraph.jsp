<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();

	String backUrl = request.getParameter("backUrl");
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	if (backUrl == null || "".equals(backUrl)) {
		backUrl = respMsg.getValue("backUrl");
	}
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String orgSubId = "C105";
	String orgId = "C6000000000001";
	if(user != null){
		orgSubId = user.getSubOrgIDofAffordOrg();
		orgId = user.getCodeAffordOrgID();
	}
	
	if(!"C105".equals(orgSubId)) {
		//非局级用户
		request.getRequestDispatcher("/pm/dailyReport/multiProject/reportList.jsp?orgSubjectionId="+orgSubId+"&orgId="+orgId).forward(request,response);
	}
	
%>
<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0" framespacing="0">
  <frame src="<%=contextPath %>/pm/comm/eps_tree.jsp?backUrl=<%=backUrl %>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/pm/dailyReport/multiProject/projectProcessList.jsp" name="mainRightframe" frameborder="no" scrolling="auto"  id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
