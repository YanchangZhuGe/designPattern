<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = "C105006";
    String optionP =request.getParameter("optionP");
    String reward_no =request.getParameter("reward_no");
%>

<frameset rows="147,*"  cols="*" frameborder="yes" border="0" framespacing="1">

  <frame src="<%=contextPath %>/hse/hseOptionPage/hiddeniInformation/RtopSelect.jsp" name="topframe" frameborder="no" scrolling="auto" noresize="noresize" id="topframe"/>

  <frameset cols="620,620" frameborder="yes" border="0" framespacing="1">   
    <frame  src="<%=contextPath %>/hse/hseOptionPage/hiddeniInformation/RleftPage.jsp?reward_no=<%=reward_no%>" name="leftframe" frameborder="1" scrolling="auto" noresize="noresize" id="leftframe"/> 
 
    <frame src="<%=contextPath %>/hse/hseOptionPage/hiddeniInformation/RrightPage.jsp?optionP=<%=optionP%>&reward_no=<%=reward_no%>" name="rightframe" frameborder="1" scrolling="auto" noresize="noresize" id="rightframe"/>    
  </frameset>
 

</frameset>

 