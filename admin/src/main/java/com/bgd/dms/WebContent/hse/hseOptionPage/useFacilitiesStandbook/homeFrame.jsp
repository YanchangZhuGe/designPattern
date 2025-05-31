<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = "C105006";
    String optionP =request.getParameter("optionP");    
    String usefacilities_no =request.getParameter("usefacilities_no");
    String addTypes =request.getParameter("addTypes");
%>

<frameset rows="148,*"  cols="*" frameborder="yes" border="0" framespacing="1">

  <frame src="<%=contextPath %>/hse/hseOptionPage/useFacilitiesStandbook/topSelect.jsp" name="topframe" frameborder="no" scrolling="auto" noresize="noresize" id="topframe"/>

  <frameset cols="620,620" frameborder="yes" border="0" framespacing="1">   
    <frame  src="<%=contextPath %>/hse/hseOptionPage/useFacilitiesStandbook/testLeft.jsp?addTypes=<%=addTypes%>&usefacilities_no=<%=usefacilities_no%>" name="leftframe" frameborder="1" scrolling="auto" noresize="noresize" id="leftframe"/> 
 
    <frame src="<%=contextPath %>/hse/hseOptionPage/useFacilitiesStandbook/rightPage.jsp?addTypes=<%=addTypes%>&optionP=<%=optionP%>&usefacilities_no=<%=usefacilities_no%>" name="rightframe" frameborder="1" scrolling="auto" noresize="noresize" id="rightframe"/>    
  </frameset>
 

</frameset>

 