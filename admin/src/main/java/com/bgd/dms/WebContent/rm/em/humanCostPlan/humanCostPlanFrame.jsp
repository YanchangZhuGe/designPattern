<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
String message = "";
String pInfoNo  = "1";
String pType = "1";
String pName  = "1";
String pId  = "1";
String pBackUrl  = "";

if(respMsg != null){
	message = respMsg.getValue("message");
	  pInfoNo = respMsg.getValue("projectInfoNo");
	  pType = respMsg.getValue("projectType");
	  pName = respMsg.getValue("projectName");
	  pId = respMsg.getValue("planIds");
	  pBackUrl= respMsg.getValue("pBackUrl");
	  pName= java.net.URLDecoder.decode(pName,"utf-8");
 
	  pName= java.net.URLEncoder.encode(pName,"utf-8");
} 
	String backUrl=request.getParameter("backUrl")==null?"":request.getParameter("backUrl");
%>

<%
if(message != null && !"".equals(message) ){
	%>
	<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0" framespacing="0">
	<frame src="<%=contextPath%>/rm/em/humanCostPlan/eps_project_tree.jsp?backUrl=<%=pBackUrl%>&message=<%=message%>&pInfoNo=<%=pInfoNo%>&pType=<%=pType%>&pName=<%=pName%>&pId=<%=pId%>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
	<frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
   </frameset>
	
	<% 
}else{
%>
<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0" framespacing="0">
	<frame src="<%=contextPath%>/rm/em/humanCostPlan/eps_project_tree.jsp?backUrl=<%=backUrl%>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
	<frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>
<%
}
%>
