<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String content_type = request.getParameter("content_type");
	if(content_type == null || content_type.trim().equals("")){
		content_type = "1";//Ô¤Ëã£º1;µ÷Õû£º2;¿¼ºË¶ÒÏÖ£º3
	}
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null){
		project_info_no="";
	}
%>
 <frameset cols="300,*"  frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/op/mProject/costTargetTree.jsp?content_type=<%=content_type %>" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="<%=contextPath %>/blank.html" name="menuFrame"  frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="menuFrame"/>
 </frameset> 
 