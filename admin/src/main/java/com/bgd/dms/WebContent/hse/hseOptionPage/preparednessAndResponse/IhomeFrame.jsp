<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = "C105006";
    String optionP =request.getParameter("optionP");    
    String inspection_no =request.getParameter("inspection_no");
    String isProject =request.getParameter("isProject");  
    String addTypes =request.getParameter("addTypes");
%>

<frameset rows="108,*"  cols="*" frameborder="yes" border="0" framespacing="1">

  <frame src="<%=contextPath %>/hse/hseOptionPage/preparednessAndResponse/ItopSelect.jsp?isProject=<%=isProject%>" name="topframe" frameborder="no" scrolling="auto" noresize="noresize" id="topframe"/>

  <frameset cols="620,620" frameborder="yes" border="0" framespacing="1">   
    <frame  src="<%=contextPath %>/hse/hseOptionPage/preparednessAndResponse/IleftPage.jsp?addTypes=<%=addTypes%>&inspection_no=<%=inspection_no%>&isProject=<%=isProject%>" name="leftframe" frameborder="1" scrolling="auto" noresize="noresize" id="leftframe"/> 
 
    <frame src="<%=contextPath %>/hse/hseOptionPage/preparednessAndResponse/IrightPage.jsp?addTypes=<%=addTypes%>&optionP=<%=optionP%>&inspection_no=<%=inspection_no%>&isProject=<%=isProject%>" name="rightframe" frameborder="1" scrolling="auto" noresize="noresize" id="rightframe"/>    
  </frameset>
 

</frameset>

 