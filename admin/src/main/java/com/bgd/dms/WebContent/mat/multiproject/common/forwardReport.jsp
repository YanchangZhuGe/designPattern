<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo=user.getProjectInfoNo();
	String orgSubjectionId=user.getSubOrgIDofAffordOrg();
	projectInfoNo=projectInfoNo==null?"":projectInfoNo;
	String reportId = request.getParameter("reportId").toString();
	%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>forwardJsp</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
function simpleSearch(){
	var orgSubjectionId = document.getElementById("org_name").value;
	var projectInfoId = document.getElementById("progect_name").value;
	 document.getElementById("bireport").src="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId="+orgSubjectionId+"&projectInfoNo="+projectInfoId;	
}
function getOrgSubjection(){
	var selectObj = document.getElementById("org_name"); 
	document.getElementById("org_name").innerHTML="";
	selectObj.add(new Option('东方物探',"C105"),0);
	var applyTeamList=jcdpCallService("MatItemSrv","queryOrgSubjection","");	
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		selectObj.add(new Option(templateMap.lable,templateMap.value),i+1);
	}
	getProgectName();
}
function getProgectName(){
	var orgSubjectionId = document.getElementById("org_name").value;
	var selectObj = document.getElementById("progect_name"); 
	document.getElementById("progect_name").innerHTML="";
	selectObj.add(new Option('请选择',"%"),0);
	var applyTeamList=jcdpCallService("MatItemSrv","queryProgectName","orgSubjectionId="+orgSubjectionId);	
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		selectObj.add(new Option(templateMap.lable,templateMap.value),i+1);
	}
}
</script>
  </head>
  <body onload='getOrgSubjection()'>
  <div id="inq_tool_box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png"
				width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="ali_cdn_name">组织机构：</td>
			 	    <td class="ali_cdn_input"><select class="select_width" id="org_name" name="org_name" onchange="getProgectName()"></select></td>
			 	    <td class="ali_cdn_name">项目名称：</td>
			 	    <td class="ali_cdn_input"><select class="select_width" id="progect_name" name="progect_name" ></select></td>
			 	    <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
					<td>&nbsp;</td>
				</tr>
			</table>
			</td>
			<td width="4"><img src="<%=contextPath%>/images/list_17.png"
				width="4" height="36" /></td>
		</tr>
	</table>
</div>
<iframe id ="bireport" src="" marginheight="0" marginwidth="0" style="height:100%;width:100%;"></iframe>
 </body>
 <script type="text/javascript">
$("#bireport").css("height",$(window).height()-$("#inq_tool_box").height()-8);
</script>
</html>
