<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.List"%>
<%@ page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.webapp.constant.MVCConstant"%>
<%@ page import="java.util.Map"%>
<html>
<head>
<%
	String contextPath = request.getContextPath();
    String examineinstID=request.getParameter("examineinstID");
 %>
<title>Insert title here</title>
</head>
<body>

<form action="<%=contextPath%>/wf/test/consignExamInst.srq" name="form" id="form">
<input type="hidden" name="examineinstID" id="examineinstID" value="<%=examineinstID %>">
委托用户： <input name="userIDs" id="userIDs">
<input type="submit" value="确定"> 

</form>
</body>
</html>