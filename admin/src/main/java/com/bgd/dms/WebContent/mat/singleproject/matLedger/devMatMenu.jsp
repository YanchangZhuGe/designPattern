<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	System.out.println(user.getProjectType());
	//if(user.getProjectType().equals("5000100004000000010")||user.getProjectType().equals("5000100004000000001")||user.getProjectType().equals("5000100004000000002")){
	//	response.sendRedirect(contextPath+"/mat/singleproject/matLedger/matItemListDg.jsp?type=0");
		
	//}
%>
 <frameset cols="320,*"  frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/mat/singleproject/matLedger/matLedgerTree.jsp" name="mainTopframe" frameborder="no" scrolling="auto"  id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/mat/singleproject/matLedger/matItemList.jsp" name="menuFrame" frameborder="no" scrolling="auto"  id="menuFrame" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
 </frameset>
 