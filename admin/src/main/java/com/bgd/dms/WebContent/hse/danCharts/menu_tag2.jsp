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
      		<div id="tag-container2_3" style="width: 80%">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a style="width: 105px;" href="#" onclick="getTab3(0)">健康</a></li>
			    <li id="tag3_1"><a style="width: 105px;" href="#" onclick="getTab3(1)">安全</a></li>
			    <li id="tag3_2"><a style="width: 105px;" href="#" onclick="getTab3(2)">环境</a></li>
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
			parent.bottomFrame.location.href = "<%=contextPath%>/hse/danCharts/hsePanel21.jsp";
		}else if(index==1){
			parent.bottomFrame.location.href = "<%=contextPath%>/hse/danCharts/hsePanel22.jsp";
		}else if(index==2){
			parent.bottomFrame.location.href = "<%=contextPath%>/hse/danCharts/hsePanel23.jsp";
		}
	}
	
	
</script>

</html>

