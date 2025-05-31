<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = "C105006";
    String optionP =request.getParameter("optionP"); 
    String corrective_no =request.getParameter("corrective_no");
%>

<frameset rows="147,*"  cols="*" frameborder="yes" border="0" framespacing="1">

  <frame src="<%=contextPath %>/hse/hseOptionPage/hiddeniInformation/CtopSelect.jsp" name="topframe" frameborder="no" scrolling="auto" noresize="noresize" id="topframe"/>

  <frameset cols="620,620" frameborder="yes" border="0" framespacing="1">   
    <frame  src="<%=contextPath %>/hse/hseOptionPage/hiddeniInformation/CleftPage.jsp?corrective_no=<%=corrective_no%>" name="leftframe" frameborder="1" scrolling="auto" noresize="noresize" id="leftframe"/> 
 
    <frame src="<%=contextPath %>/hse/hseOptionPage/hiddeniInformation/CrightPage.jsp?optionP=<%=optionP%>&corrective_no=<%=corrective_no%>" name="rightframe" frameborder="1" scrolling="auto" noresize="noresize" id="rightframe"/>    
  </frameset>
 

</frameset>

 