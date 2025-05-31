<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

%>

<frameset cols="300,*" frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/pm/bpm/common/procTypeTree.jsp" name="mainTopframe" frameborder="no" scrolling="no" style="border-right: 2px solid #5796DD; cursor: w-resize;"  id="mainTopframe"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>
