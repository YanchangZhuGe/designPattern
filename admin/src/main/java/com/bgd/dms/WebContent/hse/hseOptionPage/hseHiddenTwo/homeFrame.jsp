<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = "C105006";
    String optionP =request.getParameter("optionP");    
%>

<frameset rows="205,*"  cols="*" frameborder="yes" border="0" framespacing="1">

  <frame src="<%=contextPath %>/hse/hseOptionPage/hseHiddenTwo/topSelect.jsp" name="topframe" frameborder="no" scrolling="auto" noresize="noresize" id="topframe"/>

  <frameset cols="620,620" frameborder="yes" border="0" framespacing="1">   
    <frame  src="<%=contextPath %>/hse/hseOptionPage/hseHiddenTwo/testLeft.jsp" name="leftframe" frameborder="1" scrolling="auto" noresize="noresize" id="leftframe"/> 
 
    <frame src="<%=contextPath %>/hse/hseOptionPage/hseHiddenTwo/rightPage.jsp?optionP=<%=optionP%>" name="rightframe" frameborder="1" scrolling="auto" noresize="noresize" id="rightframe"/>    
  </frameset>
 

</frameset>

 