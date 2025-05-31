<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo=user.getProjectInfoNo();
	String projectName=user.getProjectName();
	String ProjectType=user.getProjectType();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel = "stylesheet" type = "text/css" href = "<%=contextPath%>/css/element_style.css" />
	<script type = "text/javascript" src = "<%=contextPath%>/js/jquery.min.js"></script>
	<script type = "text/javascript" src = "<%=contextPath%>/js/element_script.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
	</head>
	<body onload="load()">
<div id="zzz" class = "navigation"> <!-- Begin div.navigation -->
	<!-- Begin Navigation -->
	<div>
		<span>项目综合数据查询</span> <!-- Title -->
	</div>
	
	<ul id="ulmenu"> 
	
	</ul> 
</div>
<div><p class="slide"><a href="javascript:frameWidthResize();" class="btn-slide" >菜单</a></p></div>
<div >
<iframe  width="100%" style="HEIGHT: 400px" frameborder="no" scrolling="yes"  id="deviceInfoContent" src=""></iframe>
</div>
</body>
</html>
<script type="text/javascript">
function frameWidthResize(){
	if(document.getElementById("zzz").style.display == 'none')
		$("#zzz").slideToggle();
	else{
		$("#zzz").slideUp();
	}
}
function showContent(url)
{
	$("#zzz").slideUp();
	document.getElementById("deviceInfoContent").src='<%=contextPath%>'+url; 
}
function load()
{
	var baseData;
	var projectType='<%=ProjectType%>';
		baseData = jcdpCallService("DevInsSrv", "getProjectTypeMenu", "projectType="+projectType);
	var DmenuId;
	var html="";
if(baseData.datas!=null)
	{
		var f=1;
		for (var i=0; i< baseData.datas.length; i++) {
			if(baseData.datas[i].menu_c_name=='单项目')
				{
				document.getElementById("deviceInfoContent").src='<%=contextPath%>'+baseData.datas[i].menu_url; 
				//获取单项目的menuID
				DmenuId=baseData.datas[i].menu_id;	
				for (var j=0; j< baseData.datas.length; j++) {
					if(baseData.datas[j].parent_menu_id==DmenuId)
					{
					html+="<li class = 'color"+f+"'><a href = '#'>"+baseData.datas[j].menu_c_name+"</a><ul>";
					for (var z=0; z< baseData.datas.length; z++) {
						if(baseData.datas[z].parent_menu_id==baseData.datas[j].menu_id)
							{
							if(baseData.datas[z].menu_url=="")
								{
								for (var b=0; b< baseData.datas.length; b++) {
									
									if(baseData.datas[z].menu_id==baseData.datas[b].parent_menu_id)
										{
									
										html+="  <li><a href = javascript:showContent('"+baseData.datas[b].menu_url+"'); >"+baseData.datas[b].menu_c_name+"</a></li>";
										}
									
								}
									
								}
							var url=baseData.datas[z].menu_url;
							html+="  <li><a href = javascript:showContent('"+url+"');> "+baseData.datas[z].menu_c_name+"</a></li>";
							
							}
					}
					html+="</ul></li>";
					f++;
					}
				 }
				
				}
			}
		$("#ulmenu").html(html);
	}
	else
		{
		alert("未知错误!");
		}
	
}

</script>

