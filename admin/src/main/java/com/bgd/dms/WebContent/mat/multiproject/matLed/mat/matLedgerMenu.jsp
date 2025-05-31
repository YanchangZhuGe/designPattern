<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgCode=user.getOrgCode();
	String tree="";
	String list="";
	if("C105007".equals(orgCode)||"C105007001".equals(orgCode)){
		//tree=contextPath+"/mat/multiproject/matLed/mat/matLedgerTreeDg.jsp";
		list=contextPath+"/mat/multiproject/matLed/mat/matItemListDg.jsp?type=1";
		response.sendRedirect(list);
	}else{
		tree=contextPath+"/mat/multiproject/matLed/mat/matLedgerTree.jsp";
		list=contextPath+"/mat/multiproject/matLed/mat/matItemList.jsp";
	}

%>
 <frameset cols="320,*"  frameborder="yes" border="0" framespacing="0">
  <frame src="<%=tree%>" name="mainTopframe" frameborder="no" scrolling="auto"  id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=list%>" name="menuFrame" frameborder="no" scrolling="auto"  id="menuFrame" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
 </frameset>
 