<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
  UserToken user = OMSMVCUtil.getUserToken(request);
  if(user==null){
	  request.getRequestDispatcher("login.jsp").forward(request, response);
	  return;
  }
  response.setContentType("text/html;charset=utf-8");
  String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>设备寿命周期管理平台</title>
<style type="text/css">
	html,body { height:100%; margin:0; overflow-y:hidden;}
</style>
<script type="text/javascript"> 

	 function selectProject(){
		popWindow('<%=contextPath%>/pm/project/multiProject/index.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','1024:768');
	 }

	 topDialogs=[];

	 function dialogCallback(funcName, arg){
		if(topDialogs.length>1){
			eval("top.topDialogs[top.topDialogs.length-2][0].get(0).contentWindow." + funcName + "(arg)");
		}else{
			eval("top.frames[1]." + funcName + "(arg)");
		}
	 }
 
	 function test(menuId,menuUrl,fl,menuName){ 
		if("仪表盘" == menuName){
			window.frames['topFrame'].preIsDashBoard=true;
		    window.frames['indexFrame'].location.href=menuUrl; 
		}else{		
		    window.frames['indexFrame'].location.href='<%=request.getContextPath()%>/dms_info/index_info_old.jsp?menuId='+menuId+'&fl='+fl+'&menuUrl='+menuUrl;
		}
	 }
	 //为收藏夹专用的跳转连接
	 function testColl(menuId,menuUrl,fl,menuName,fromColl){	    
		if("仪表盘" == menuName){
			window.frames['topFrame'].preIsDashBoard=true;
			window.frames['indexFrame'].location.href=menuUrl; 
		}else{			
			window.frames['indexFrame'].location.href='<%=request.getContextPath()%>/dms_info/index_info_old.jsp?menuId='+menuId+'&fl='+fl+'&menuUrl='+menuUrl+'&fromColl='+fromColl;
		}
	}
 
	function indexPage(page){
	    window.frames['indexFrame'].location.href=page; 
	}
 
</script>   
</head>
<body >

<div id="dialog_wrap" style=""></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
 <tr>
  <td id='ttt' style="height:5.7%;background-color: #fff">
	   <iframe id="topFrame" name="topFrame" title="topFrame" width="100%" height="44px" frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/common/index/header.srq"></iframe>
  </td>
 </tr>
 <tr>
  <td id='ttt3' style="height:1.3%;background:#F1F4F9;background-image:url(<%=contextPath%>/css/dms_home/images/yemei-yinying.png); background-position:center top; background-repeat: repeat-x;">
  </td>
 </tr>
 <tr>
 <td id='ttt1' style="height:93%">
    <%
 	if(user.getSubOrgIDofAffordOrg().startsWith("C105008")){ //综合物化探%>
		<iframe id="indexFrame"  name="indexFrame" title="indexFrame" width="100%" height="100%" frameborder="0" 
		scrolling="no" src="<%=request.getContextPath()%>/dms_info/index_info1.jsp"></iframe>
	<% 
	}else if(user.getSubOrgIDofAffordOrg().startsWith("C105006")){ //装备服务处%>
		<iframe id="indexFrame"  name="indexFrame" title="indexFrame" width="100%" height="100%" frameborder="0" 
		scrolling="no" src="<%=request.getContextPath()%>/dms_info/index_info2.jsp"></iframe>
	<%}else{%>
		<iframe id="indexFrame"  name="indexFrame" title="indexFrame" width="100%" height="100%" frameborder="0" 
		scrolling="no" src="<%=request.getContextPath()%>/dms_info/index_info.jsp"></iframe>
	<%}%>
	 </td>
 </tr>
 </table>
 </body>
</html>
