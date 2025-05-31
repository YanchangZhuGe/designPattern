<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%
String contextPath = request.getContextPath();
String extPath = contextPath + "/js/ext-min";
UserToken user = OMSMVCUtil.getUserToken(request);
String projectInfoNo=user.getProjectInfoNo();
projectInfoNo=projectInfoNo==null?"":projectInfoNo;

String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+contextPath+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>forwardJsp</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  </head>
  <script type="text/javascript">
  	function onload(){
  		var projectInfoNo='<%=projectInfoNo%>';
  		if(projectInfoNo==null||projectInfoNo==''){
  			var temp=popWindow('<%=contextPath%>/pm/project/multiProject/index.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','1024:768');
  			parent.frames["list"].location='<%=contextPath%>/op/costTargetManager/costTargetProjectManager.jsp';
  		}else{
  			parent.frames["list"].location='<%=contextPath%>/op/costTargetManager/costTargetProjectManager.jsp';
  		}
  	}
  	function initInfo(){
  		alert();
  	}
  </script>
  <body onload="onload()">
  </body>
</html>
