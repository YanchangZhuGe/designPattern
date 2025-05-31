<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = "C105";
	String orgId = "C6000000000001";
	if(user != null){
		orgSubId = user.getSubOrgIDofAffordOrg();
		orgId = user.getCodeAffordOrgID();
	}
	String projectType = user.getProjectType();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	if(orgSubId.startsWith("C105008")){
		  	projectType="5000100004000000009";
		  	request.getRequestDispatcher("/dmsManager/use/project/noTagProjectList.jsp?&orgSubjectionId="+orgSubId+"&orgId="+orgId+"&projectType="+projectType).forward(request,response);
	    return;
		} else 
	if(orgSubId.startsWith("C105007")){
	  	request.getRequestDispatcher("/dmsManager/use/project/noTagProjectList.jsp?&orgSubjectionId="+orgSubId+"&orgId="+orgId+"&projectType="+projectType).forward(request,response);
    	return;
	} else 
	if(orgSubId.startsWith("C105005001")){
	  	request.getRequestDispatcher("/dmsManager/use/project/noTagProjectList.jsp?&orgSubjectionId="+orgSubId+"&orgId="+orgId+"&projectType="+projectType).forward(request,response);
    	return;
	}
%>
<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0" framespacing="0">
  <frame src="<%=contextPath %>/pm/comm/eps_tree.jsp?backUrl=/dmsManager/use/project/noTagProjectList.jsp" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/dmsManager/use/project/noTagProjectList.jsp?orgSubjectionId=<%=orgSubId %>&orgId=<%=orgId %>" name="mainRightframe" frameborder="no" scrolling="auto"  id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
