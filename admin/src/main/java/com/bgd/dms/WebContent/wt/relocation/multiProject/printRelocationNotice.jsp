<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page  import="java.util.*" %>
<%@ page import="java.text.*" %>

<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String username = user.getUserName();
	SimpleDateFormat df = new SimpleDateFormat("yyyy年MM月dd日");
	String appDate = df.format(new Date());
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<style>
table,table td,table th{border:1px solid;border-collapse:collapse;}
.item_center{
height:40px;
	text-align:center;
	width:12%;
}
.small_center{
	text-align:center;
	width:ippx;
	padding:0 5px;
}
.item_heigh{
height:80px;
	text-align:center;
	width:100px;
}
</style>
<title>无标题文档</title>
</head>
<body style="text-align:center;font-family: 宋体;">
 <div style="margin:70px auto auto auto;width:595px;">
 <div style="text-align:center;font-size: 29px;font-weight: bold;"> 动迁通知书 </div>
 <div style="text-align:right;font-size: 16px;font-weight: bold;">BGP&sdot;ZH/Q/JL7.5.1-3</div>

<div style="text-align:left;margin:18px auto auto auto ;font-size: 21px;line-height:35px;">
   <span id="teamid" style="text-decoration: underline;"></span>：
   <span style="display:block;text-indent: 2em;"> 经主管部门对各项工作的全面审查，认为：你队前期准备工作充分、到位，技术、基础资料准备齐全，各种设备的配备能够满足施工要求，动迁路线明确，安全措施有效，同意你队开始动迁。</span>

     <span style="display:block;text-indent: 2em;">同时，要求你队尽快与所辖探区项目部沟通，及时做好开工前的各项准备工作。</span>

</div>


 <div id="keid" style="margin:70px auto auto 280px;font-size: 21px;">生产管理科：</div>
 <div id="dateid" style="margin:20px auto auto 440px;font-size: 21px;">年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</div>
 </div>

 </body>

<script type="text/javascript">
	//根据项目id  取施工队document.getElementById("work_team").innerText =retObj.relocationMap.work_team;
		var retObj2 = jcdpCallService("WtProjectSrv", "getProjectOrgNames", "projectInfoNo=<%=projectInfoNo%>");
		if(null!=retObj2.orgNameMap){
			$("#teamid").html(retObj2.orgNameMap.org_name);
		}else{
			$("#teamid").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;队");
		}
		
//$("#dateid").html("<%=appDate%>");
//$("#keid").html(" 生产管理科：<%=username%>");

window.print(); 
</script>
</html>