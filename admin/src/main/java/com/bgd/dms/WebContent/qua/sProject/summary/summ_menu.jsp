<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null){
		project_info_no="";
	}
%>
 <script type="text/javascript">
	var projectInfoNo = '<%=project_info_no%>';
	if(projectInfoNo==null || projectInfoNo==''){
		alert("ว๋ักิ๑ฯ๎ฤฟ");
	}
</script>

</head>
 <frameset cols="300,*"  frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/qua/sProject/summary/summ_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="<%=contextPath %>/qua/sProject/summary/summaryList.jsp" name="menuFrame"  frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="menuFrame"/>
 </frameset> 
<body>

</body>
</html>
 