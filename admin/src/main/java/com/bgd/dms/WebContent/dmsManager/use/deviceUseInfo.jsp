<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String ProjectType = user.getProjectType();
	String project_info_no = request.getParameter("project_info_id");
	IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	String sql="select project_name   from gp_task_project where  project_info_no ='"+project_info_no+"'";
	String name=pureJdbcDao.queryRecordBySQL(sql).get("project_name").toString();
	Random r=new Random();
	int  change=r.nextInt();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>项目综合查询</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/element_style.css" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css"
	rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.min.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/element_script.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/styles/style.css" />

<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/styles/SpryTabbedPanels.css" />
<style type="text/css">
</style>
<script type="text/javascript">
function selectProject(){
	var obj = new Object();
	var vReturnValue = window.showModalDialog('<%=contextPath%>/dmsManager/use/selectProject.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
  if(undefined!=vReturnValue&&""!=vReturnValue){
	    $("#showTitle").html("");
		var id=vReturnValue.split("~")[0];
		var name=vReturnValue.split("~")[1];
		var project_type=vReturnValue.split("~")[2];
		$("#project_type").val(project_type);
		$("#project_info_id").val(id);
		jcdpCallService("ProjectSrv", "selectProject", "projectInfoNo="+id);
		document.getElementById('title').innerHTML='<a href="#"  onclick="selectProject();" ><font  style=\'font-family: Open Sans\' color=\'FF3366\'>'+name+'</font></a>';
		load();
  }

}

</script>
</head>
<body onload="load()">
    <div>
		<div   id="title"   style="width: 100%;height: auto;color:#0f6ab2;background-color:#bcdaf3;text-align: left;text-indent: 12px;font-weight:bold;font-size: 16px;line-height: 20px;padding-bottom: 0px  " >
			<a href="#" onclick="selectProject();"><font color='FF3366' style='font-family: Open Sans'><%=name%></font></a><div id = "back"></div>
		</div>
	</div>
	<div id="zzz" class="navigation"  style="padding-top: 0px;padding-bottom:0px">
		 <!--  <div style="width: 100%;height: auto;color:#0f6ab2;background-color:#bcdaf3;text-align: left;font-weight:bold;font-size: 10px ;display: none;" >
			<span  style="font-family: verdana; color:black; width: 100%;">项目综合数据查询</span>
		</div> -->
		<ul id="ulmenu">
		</ul>
	</div>
	<!--  <div>
		<p class="slide">
			<a href="javascript:frameWidthResize();" class="btn-slide">菜单</a>
		</p>
	</div>-->
	<div>
		<iframe width="100%" style="HEIGHT: 400px" frameborder="no"
			scrolling="yes" id="deviceInfoContent" src=""></iframe>
	
	</div>
	<input type="hidden"  id="project_type"  value="<%=ProjectType %>"/>
	<input type="hidden"  id="project_info_id" value="<%=project_info_no %>" />
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
	//$("#zzz").slideUp();
	document.getElementById("deviceInfoContent").src='<%=contextPath%>'+url; 
}
function load()
{
	var baseData;
	var projectType=$("#project_type").val();
	var project_info_id=$("#project_info_id").val();
	baseData = jcdpCallService("DevInsSrv", "getProjectTypeMenu", "projectType="+projectType);
	var DmenuId;
	var html="";
if(baseData.datas!=null)
	{
		var f=1;
		for (var i=0; i< baseData.datas.length; i++) {
			if(baseData.datas[i].menu_c_name=='单项目')
				{
				document.getElementById("deviceInfoContent").src='<%=contextPath%>'
							+ baseData.datas[i].menu_url+"?projectInfoNo="+project_info_id;
				
					//获取单项目的menuID
					DmenuId = baseData.datas[i].menu_id;
					for ( var j = 0; j < baseData.datas.length; j++) {
						if (baseData.datas[j].parent_menu_id == DmenuId) {
							html += "<li style='background-color: #bcdaf9;'><a href = '#'><font color='black'>"
									+ baseData.datas[j].menu_c_name
									+ "</font></a><ul>";
							for ( var z = 0; z < baseData.datas.length; z++) {
								if (baseData.datas[z].parent_menu_id == baseData.datas[j].menu_id) {
									if (baseData.datas[z].menu_url == "") {
										for ( var b = 0; b < baseData.datas.length; b++) {

											if (baseData.datas[z].menu_id == baseData.datas[b].parent_menu_id) {
												if( baseData.datas[b].parent_menu_id==""){
													for(var c=0;c< baseData.datas.length;c++){
														html += "  <li style='background-color: #bcdaf9;'><a href = javascript:showContent('"
															+ baseData.datas[c].menu_url
															+ "'); >"
															+ baseData.datas[c].menu_c_name
															+ "</a></li>";
													}
													html += "  <li><a href = '#')> "
															+ baseData.datas[b].menu_c_name
															+ "</a></li>";
												}else{

												html += "  <li style='background-color: #bcdaf9;'><a href = javascript:showContent('"
														+ baseData.datas[b].menu_url
														+ "'); >"
														+ baseData.datas[b].menu_c_name
														+ "</a></li>";
												}
											}

										}

									}
									var url = baseData.datas[z].menu_url;
									if(""==url){
										html += "  <li><a href = '#'> "
											+ baseData.datas[z].menu_c_name
											+ "</a></li>";
									}else{
										html += "  <li><a href = javascript:showContent('"
											+ url
											+ "');> "
											+ baseData.datas[z].menu_c_name
											+ "</a></li>";
									}
									

								}
							}
							html += "</ul></li>";
							f++;
						}
					}

				}
			}
			$("#ulmenu").html(html);
		} else {
			alert("未知错误!");
		}

	}
</script>

