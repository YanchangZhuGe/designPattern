<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.dailyReport.DailyReportSrv"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("project_info_no") != null ? request.getParameter("project_info_no"):"";
	String daily_no = request.getParameter("daily_no") != null ? request.getParameter("daily_no"):"";
	String produce_date = request.getParameter("produce_date") != null ? request.getParameter("produce_date"):"";
	String projectName = request.getParameter("projectName") != null ? request.getParameter("projectName"):"";
	String orgId = request.getParameter("orgId") != null ? request.getParameter("orgId"):"";
	
	DailyReportSrv drs = new DailyReportSrv();
	String build_method = drs.getBuildMethod(projectInfoNo);
	
	if("5000100003000000001".equals(build_method) || "5000100003000000004".equals(build_method) || "5000100003000000005".equals(build_method) || "5000100003000000007".equals(build_method)){
		//request.getRequestDispatcher("reportListAuditDrill.jsp").forward(request,response);
	}else{
		//request.getRequestDispatcher("reportListAuditDrill.jsp").forward(request,response);
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
</head>
<script type="text/javascript">
var selectedTagIndex=0;
	function getTab3(index) {  
		var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
		selectedTag.className ="";
		selectedTabBox.style.display="none";
		selectedTagIndex = index;	
		selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
		selectedTag.className ="selectTag";
		selectedTabBox.style.display="block";
	}
</script>
<body>
<div>
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">批量导入日报信息</a></li>
	    <li id="tag3_1"><a href="#" onclick="getTab3(1)">日报信息</a></li>
	  </ul>
</div>
<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content" style="height:500px;" >
	<iframe   width="100%" height="100%"  id="attachement1" name="attachement1" frameborder="0"  src="<%=contextPath%>/pm/dailyReport/multiProject/wt/reportListAuditDrillCollExcle.jsp?&project_info_no=<%=projectInfoNo %>" marginheight="0" marginwidth="0"></iframe>
</div>
<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="height:550px; display:none;">																																	
		<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="<%=contextPath%>/pm/dailyReport/multiProject/wt/reportListAuditDrill.jsp?daily_no=<%=daily_no %>&project_info_no=<%=projectInfoNo %>&produce_date=<%=produce_date %>&projectName=<%=projectName %>&orgId=<%=orgId %>" marginheight="0" marginwidth="0" ></iframe>	
</div>
</body>
