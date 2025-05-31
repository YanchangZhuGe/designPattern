<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
        
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
 
 
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
 
<body style="background: #fff; " onload="getTab1();getChartAduitList();" >
<div id="tag-container_3" >
<ul id="tags" class="tags">
<li class="selectTag" id="tag3_0" name="tag3_0"><a href="#" onclick="getTab1()">井中(父项目)</a></li> 
<li id="tag3_1" name="tag3_1"><a href="#" onclick="getTab2()">井中(子项目)</a></li> 
</ul>
</div>
<div id="tab_box" class="tab_box"  >
<div id="tab_box_content0" class="tab_box_content" style="background:#fff;height:600px;overflow-x:hidden; overflow-y: hidden; "  >  
	<iframe width="100%" height="100%" name="selectLabor" id="selectLabor" frameborder="0" src="<%=contextPath%>/td/checkDoc/tdChartOrgJz.jsp?reportId=js_father_report.raq" marginheight="0" marginwidth="0" >
	</iframe>	
 </div>   
 <div id="tab_box_content1" class="tab_box_content" style="display:none;background:#fff;height:600px;overflow-x:hidden;overflow-y:hidden;" > 
	<iframe width="100%" height="100%" name="selectLabors" id="selectLabors" frameborder="0" src="<%=contextPath%>/td/checkDoc/tdChartOrgJz.jsp?reportId=js_jzi_report.raq" marginheight="0" marginwidth="0" >
	</iframe>	
 </div>  
</div>

</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
 
   
function getTab1() {  
	var selectedTag=document.getElementsByTagName("li")[0];
	var selectedTag1=document.getElementsByTagName("li")[1]; 
	
	if(selectedTag!=null){
		selectedTag.className ="selectTag";
	}
	if(selectedTag1!=null){
		selectedTag1.className ="";
	}
	 
	
	var selectedTabBox = document.getElementById("tab_box_content1")
	selectedTabBox.style.display="NONE";
	var selectedTabBox0 = document.getElementById("tab_box_content0")
	selectedTabBox0.style.display="BLOCK";
 
}

function getTab2() {  
	var selectedTag=document.getElementsByTagName("li")[0];
	var selectedTag1=document.getElementsByTagName("li")[1];
	 
	if(selectedTag!=null){
		selectedTag.className ="";
	}
	if(selectedTag1!=null){
		selectedTag1.className ="selectTag";
	}
 
	var selectedTabBox = document.getElementById("tab_box_content1")
	selectedTabBox.style.display="BLOCK";
	var selectedTabBox0 = document.getElementById("tab_box_content0")
	selectedTabBox0.style.display="NONE";
 
}
  
</script>  
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

