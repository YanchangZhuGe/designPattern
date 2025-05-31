<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = "C105006";
%>

<frameset cols="250,*"  frameborder="yes" border="0" framespacing="1">

  <frame src="<%=contextPath %>/rm/em/humanLabor/selectLeft.jsp?orgSubId=<%=orgSubId%>" name="leftframe" frameborder="no" scrolling="auto" noresize="noresize" id="leftframe"/>

  <frameset rows="50%,50%" frameborder="yes" border="0" framespacing="1">   
    <frame  src="<%=contextPath %>/rm/em/humanLabor/humanLaborList.jsp?orgSubId=<%=orgSubId%>" name="topframe" frameborder="1" scrolling="auto" noresize="noresize" id="topframe"/> 
    <frame src="" name="downframe" frameborder="1" scrolling="auto" noresize="noresize" id="downframe"/>    
  </frameset>
 

</frameset>