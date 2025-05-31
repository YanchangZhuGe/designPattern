<%@page import="com.bgp.mcs.web.common.util.Base64" %>
<%
	String url = request.getParameter("url");
	if(url!=null){
		url = new String(Base64.decode(url));
	}
%>
<iframe width="100%" height="100%" frameborder="0" scrolling="no" src="<%=request.getContextPath()+url%>"></iframe>