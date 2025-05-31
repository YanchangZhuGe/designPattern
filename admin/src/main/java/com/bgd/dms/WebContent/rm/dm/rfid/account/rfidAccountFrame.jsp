<%@ page language="java"
	import="com.cnpc.jcdp.common.UserToken,com.cnpc.jcdp.webapp.util.OMSMVCUtil"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String contexPath = request.getContextPath();
StringBuffer paramUrl = new StringBuffer();
for(Object key : request.getParameterMap().keySet()){
	paramUrl.append("&"+key+"="+request.getParameter(key.toString()));
}
if(paramUrl.length() > 0 ){
	paramUrl.insert(0,"?");
}
%>
<frameset cols="300,*" frameborder="yes" border="0" framespacing="0">
	<frame src="<%=contexPath%>/rm/dm/rfid/account/rfidDevTypeTree.jsp<%=paramUrl%>" name="mainleftframe" frameborder="0" scrolling="auto"
		id="mainleftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;" />
	<frame src="<%=contexPath%>/rm/dm/rfid/account/rfidDevAccList.jsp?code=" name="mainRightframe" frameborder="0" scrolling="auto"
		id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;" />
</frameset>
