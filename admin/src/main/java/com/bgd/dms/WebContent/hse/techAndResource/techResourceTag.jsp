<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgSubjectionId();
	String isProject = request.getParameter("isProject");

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff" >
      	<div id="list_table2">
      		<div id="tag-container2_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">HSE培训师</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">HSE内审员</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">注册HSE审核员</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">注册安全工程师</a></li>
			  </ul>
			</div>
	</div>
</body>

<script type="text/javascript">

	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	getTab3(0);
	function getTab3(index) {  
		var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTag.className ="";

		selectedTagIndex = index;
		
		selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTag.className ="selectTag";
		if(index==0){
			parent.bottomFrame.location.href = "<%=contextPath%>/hse/techAndResource/hseTrainer/trainer_list.jsp?isProject=<%=isProject%>";
		}else if(index==1){
			parent.bottomFrame.location.href = "<%=contextPath%>/hse/techAndResource/hseAuditor/auditor_list.jsp?isProject=<%=isProject%>";
		}else if(index==2){
			parent.bottomFrame.location.href = "<%=contextPath%>/hse/techAndResource/hseChecker/checker_list.jsp?isProject=<%=isProject%>";
		}else if(index==3){
			parent.bottomFrame.location.href = "<%=contextPath%>/hse/techAndResource/hseEngineer/engineer_list.jsp?isProject=<%=isProject%>";
		}
	}
	
	
</script>

</html>

