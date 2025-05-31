<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getCodeAffordOrgID();
	String orgSubjectionId = "C105005";//user.getSubOrgIDofAffordOrg();
	String url = "";
	if(orgSubjectionId.length() == 4){
		//局级
		url = "jujiFrame.jsp";
	} else if(orgSubjectionId.indexOf("C105005") != -1) {
		//东部经理部处级
		url = "chujiFrame.jsp";
	} else if(orgSubjectionId.length()==7) {
		//其他处级
		url = "chujiFrame.jsp";
	} else {
		//小队
		url = "xiaoduiFrame.jsp";
	}
%>
<script type="text/javascript">
//alert('<%=orgSubjectionId%>');
location.href="<%=contextPath %>/pm/chart/<%=url %>";
</script>
<html>
</html>

