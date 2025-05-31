<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
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

</head>

<body style="background:#cdddef; overflow-y: auto;">
	<div id="tag-container_3">
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
	  </ul>
	</div>
	
	<div id="tab_box" class="tab_box">
		<div id="tab_box_content0" class="tab_box_content">

		</div>
	</div>
</body>

<script type="text/javascript">

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	var selectedTag=document.getElementsByTagName("li")[0];

	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
	}

</script>

</html>

