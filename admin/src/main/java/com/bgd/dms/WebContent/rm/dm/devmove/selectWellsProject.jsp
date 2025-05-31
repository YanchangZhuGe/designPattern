<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String orgId = user.getCodeAffordOrgID();
	if(orgSubId.startsWith("C105006")){
		orgSubId = "C105";
		orgId = "C6000000000001";
	}
	
	String backUrl = request.getParameter("backUrl");	
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	if (backUrl == null || "".equals(backUrl)) {
		backUrl = respMsg.getValue("backUrl");
	}
	
	String action = request.getParameter("action");
	if("".equals(action) || action == null){
		action = "edit";
	}
	//井中项目转移专用
	//String projecttype = "5000100004000000008";
	String projecttype = "";
	if(!"C105".equals(orgSubId)) {
		System.out.println("orgSubId111111 == "+orgSubId);
	//非局级用户
	//	request.getRequestDispatcher("/pm/project/multiProject/noTagProjectList.jsp?action="+action+"&orgSubjectionId="+orgSubId+"&orgId="+orgId).forward(request,response);
		request.getRequestDispatcher("/rm/dm/devmove/noWellsTagProjectList.jsp?action="+action+"&orgSubjectionId="+orgSubId+"&orgId="+orgId+"&projectType="+projecttype).forward(request,response);
	}
%>
<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0" framespacing="0">
  <frame src="<%=contextPath %>/rm/dm/devmove/eps_tree.jsp?backUrl=/rm/dm/devmove/noTagProjectList.jsp&action=<%=action %>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/rm/dm/devmove/noWellsTagProjectList.jsp?action=<%=action %>&orgSubjectionId=<%=orgSubId %>&orgId=<%=orgId %>" name="mainRightframe" frameborder="no" scrolling="auto"  id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
