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
<title>HSE月报</title>
</head>

<body style="background:#fff" >
      	<div id="list_table2">
      		<div id="tag-container2_3">
			  <ul id="tags" class="tags">  
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">单位HSE月报</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">公司HSE月报</a></li>
			  </ul>
			</div>
		<div id="tab_box2" class="tab_box">
      		<div id="tab_box_content0" class="tab_box_content"  >
      			<iframe  id ='hiddeninfo' src= "<%=contextPath%>/hse/hseOptionPage/hseMonthlyReport/unitMonthlyReportList.jsp" width="100%" height="100%" scrolling="no" name= "window0" frameborder="0"> </iframe>
			</div>
			<div id="tab_box_content1" class="tab_box_content"  >
				<iframe id ='assessment' src= "<%=contextPath%>/hse/hseOptionPage/hseMonthlyReport/companyMonthlyReport.jsp" width="100%" height="100%" scrolling="no" name= "window1" frameborder="0"> </iframe>
			</div>
		</div>
	</div>   
</body>

<script type="text/javascript"> 
	cruConfig.contextPath =  "<%=contextPath%>";	
	$("#tab_box2 .tab_box_content").css("height",$(window).height()-$("#tag-container2_3").height()-10);	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");	
	
	function reashDate(iframeName){
     window.frames(iframeName).refreshData();
	}
 
	function getTab3(index) {  

		  var selectedTag0 = document.getElementById("tag3_0");
		  var selectedTabBox0 = document.getElementById("tab_box_content0");
		  var selectedTag1 = document.getElementById("tag3_1");
		  var selectedTabBox1 = document.getElementById("tab_box_content1");
		 
 
		  if (index == '1'){				  
			// reashDate('assessment');
		    selectedTag1.className ="selectTag";
		    selectedTabBox1.style.display="block";
		    selectedTag0.className ="";
		    selectedTabBox0.style.display="none";
		    return;
		  }    
		   if (index == '0'){ 	 
			   reashDate('hiddeninfo');
		    selectedTag0.className ="selectTag";
		    selectedTabBox0.style.display="block";
		    selectedTag1.className ="";
		    selectedTabBox1.style.display="none";
	 
		  }
		 
		 
		}

	
</script>

</html>

