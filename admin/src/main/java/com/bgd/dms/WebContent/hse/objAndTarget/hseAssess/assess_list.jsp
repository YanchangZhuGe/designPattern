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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">主管</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">员工</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">上级主管</a></li>
			  </ul>
			</div>
		<div id="tab_box2" class="tab_box">
      		<div id="tab_box_content20" class="tab_box_content" style="height: 100%;">
      			<iframe src= "<%=contextPath%>/hse/objAndTarget/hseAssess/assess11_list.jsp" width="100%" height="100%" scrolling="no" name= "window3 " frameborder="0"> </iframe>
			</div>
			<div id="tab_box_content21" class="tab_box_content" style="display:none;">
				<iframe src= "<%=contextPath%>/hse/objAndTarget/hseAssess/assess22_list.jsp" width="100%" height="100%" scrolling="no" name= "window2 " frameborder="0"> </iframe>
			</div>
			<div id="tab_box_content22" class="tab_box_content" style="display:none;"	>
				<iframe src= "<%=contextPath%>/hse/objAndTarget/hseAssess/assess33_list.jsp" width="100%" height="100%" scrolling="no" name= "window3 " frameborder="0"> </iframe>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	
	$("#tab_box2 .tab_box_content").css("height",$(window).height()-$("#tag-container2_3").height()-10);
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content20");
	
	function getTab3(index) {  
		var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		var selectedTabBox = document.getElementById("tab_box_content2"+selectedTagIndex)
		selectedTag.className ="";
		selectedTabBox.style.display="none";

		selectedTagIndex = index;
		
		selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTabBox = document.getElementById("tab_box_content2"+selectedTagIndex)
		selectedTag.className ="selectTag";
		selectedTabBox.style.display="block";
	}
	
	
</script>

</html>

