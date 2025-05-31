<%@page contentType="text/html;charset=UTF-8"%>
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
	html,body { height:100%; margin:0; overflow-y:0;}
</style>
  
</head>
<body style="margin-left:12px"> 
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
  <tr>
  	<td width="100%" style="height:100%"> 
  		<iframe  id="protFrame" name="protFrame" title="" width="100%"  height="100%"  frameborder="0" scrolling="no" src="http://10.88.248.243:8980/BGPPSApp/flex/Portal1.html"></iframe>
  		<!-- <iframe  id="protFrame" name="protFrame" title="" width="100%"  height="100%"  frameborder="0" scrolling="no" src="http://10.88.2.241:7888/BGPPSApp/flex/MapIndex.swf?full=1"></iframe> -->
  	</td>
  </tr>
  </table>
 </body>
</html>
