<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String stats=request.getParameter("stats");
	String id=request.getParameter("questionid");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>设备台账新增</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
  	<%
  		if(stats.equals("0")){
  			%>
  			<iframe width="100%" height="460px;" scrolling="no" src="http://10.88.248.133:9080/ess/question/selModul.srq?request_token={'name':'<%=user.getLoginId()%>','userOrg':'<%=user.getOrgId() %>','sysInfo':'gms'}"></iframe>
  			<%
  		}else{
  			%>
  			<iframe width="100%" height="460px;" scrolling="no" src="http://10.88.248.133:9080/ess/question/modulParticular.srq?questionid=<%=id %>&stats=0&groupid=gms&pageSize=1&type=index&request_token={'name':'<%=user.getLoginId()%>','sysInfo':'gms'}"></iframe>
  		<%
  		}
  	%>
    
  </div>
</div>
</body>
</html>

