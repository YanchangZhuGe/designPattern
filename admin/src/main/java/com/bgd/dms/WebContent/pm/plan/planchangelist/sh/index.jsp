<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}
	
	String action = request.getParameter("action");
	if(action == null || "".equals(action)){
		action = "edit";
	}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>增加变更计划</title>
</head>

<body style="background:#fff;">
<div id="tag-container_3">
  <ul id="tags" class="tags">
    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">项目概况</a></li>
    <li id="tag3_1"><a href="#" onclick="getTab3(1)">组织机构</a></li>
    <li id="tag3_2"><a href="#" onclick="getTab3(2);change(3)">项目进度计划</a></li>
  </ul>
</div>
	<div id="tab_box_content0" class="tab_box_content"  style="height: 500px;">
		<iframe width="100%" id="if1" height="100%" frameborder="0" src="<%=contextPath %>/pm/plan/planchangelist/sh/baseInfo.jsp?projectInfoNo=<%=projectInfoNo %>&action=<%=action %>" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: hidden;"></iframe>
	</div>
	<div id="tab_box_content1" class="tab_box_content" style="display:none;height: 500px;">
		<iframe width="100%" id="if2"  height="100%" frameborder="0" src="<%=contextPath %>/pm/plan/planchangelist/sh/orgInfo.jsp?projectInfoNo=<%=projectInfoNo %>&action=<%=action %>" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
	</div>
	<div id="tab_box_content2" class="tab_box_content" style="display:none;height: 500px;">
		<iframe width="100%" id="if3"  height="100%" frameborder="0" src="<%=contextPath %>/pm/plan/planchangelist/sh/projectPlan.jsp?projectInfoNo=<%=projectInfoNo %>&action=<%=action %>" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
	</div>
	
</body>

<script type="text/javascript">

var selectedTagIndex = 0;
var showTabBox = document.getElementById("tab_box_content0");
function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script>
</html>