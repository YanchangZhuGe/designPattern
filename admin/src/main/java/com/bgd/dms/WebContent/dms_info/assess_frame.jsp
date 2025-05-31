<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubId = user.getSubOrgIDofAffordOrg();
	 
%>

	<%
		if("C105".equals(orgsubId)){
	%>
		<frameset rows="25px,*" cols="*" frameborder="no" border="0" framespacing="0" bordercolor="f3f3f3">
			<frame src="<%=contextPath %>/dms_info/assess_tag.jsp" name="mainTopframe" frameborder="yes" scrolling="yes" noresize="noresize" id="assessTagframe"/>
		 	<frame src="" name="assessFrame" frameborder="no" scrolling="no" id="assessFrame" />
	  	</frameset>
  	<%
		}else if(orgsubId.startsWith("C105006")){
	%>
		<frameset rows="25px,*" cols="*" frameborder="no" border="0" framespacing="0" bordercolor="f3f3f3">
			<frame src="<%=contextPath %>/dms_info/assess_tagZB.jsp" name="mainTopframe" frameborder="no" scrolling="no" noresize="noresize" id="assessTagframe"/>
			<frame src="" name="assessFrame" frameborder="no" id="assessFrame" />
		</frameset>	
	<%
		}else{
	%>
		<frameset rows="25px,*" cols="*" frameborder="no" border="0" framespacing="0" bordercolor="f3f3f3">
			<frame src="<%=contextPath %>/dms_info/assess_tagWTC.jsp" name="mainTopframe" frameborder="no" scrolling="no" noresize="noresize" id="assessTagframe"/>
			<frame src="" name="assessFrame" frameborder="no" id="assessFrame" />
	  	</frameset>
  	<% 
  		}
  	%>
