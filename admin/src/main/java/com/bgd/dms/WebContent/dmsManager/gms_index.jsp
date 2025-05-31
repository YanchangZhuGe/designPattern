<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@page import="com.bgp.mcs.web.common.util.Base64"%>
<%

	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getLoginId();	
	String gmsUrl = "http://10.88.2.241:9898/gms4/wtgl/dms_index.jsp?url=";
	String url = request.getParameter("url");
	byte[] urlBytes = url.getBytes();
	String localUrl = new String(Base64.encode(urlBytes));
	response.sendRedirect(gmsUrl+localUrl+"&userName="+userId);
%>
