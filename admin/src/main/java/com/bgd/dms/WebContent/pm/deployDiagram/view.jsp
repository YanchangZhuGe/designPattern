<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
    String contextPath = request.getContextPath();
    String objectId = request.getParameter("objectId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>部署图</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link href="table.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="new_table_box">
  <div id="new_table_box_content" >
    <div id="new_table_box_bg" style="overflow: scroll;">
		<img src="<%=contextPath%>/doc/downloadDocByUcmId.srq?docId=<%=objectId %>&emflag=0" />
 	</div>
 	<div id="oper_div">
   		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  	</div>
  </div>
</div>
</body>
</html>