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
	html,body { height:100%; margin:0; overflow-y:hidden;}
</style>
</head>
<body>
<table width="100%" height="98.5%" cellpadding="0" cellspacing="0">
  <tr height="300" >
  	<!-- <td width="100%" style="height:70%"> 
  		<iframe id="mapFrame" name="mapFrame" title="" width="100%"  height="100%"  frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/dms_info/content_map.jsp"></iframe>
  	</td> -->
  	<td width="100%"  > 
  		<iframe id="mapFrame" name="mapFrame" title="" width="100%"  height="100%"  frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/dms_info/assess_frame.jsp"></iframe>
  	</td>
  </tr>
  <tr height="100">
  	<td width="100%" >
  		<iframe id="dasFrame" name="dasFrame" title="" width="100%" height="100%" frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/pm/bpm/singleProcess/dashbordProcess.jsp"></iframe>
  	</td>
  </tr>
  </table>
 </body>
</html>
<script type="text/javascript">
function frameSize(){
	$("#mapFrame").css("height",$(window).height()*0.52);
	$("#dasFrame").css("height",$(window).height()*0.48);
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});	
</script>
