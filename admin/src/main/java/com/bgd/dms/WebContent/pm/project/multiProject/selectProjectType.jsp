<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
	String orgId = user.getOrgId();
%>
<html>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript">
function setProjectType(){
	var project_type = document.getElementById("project_type").value;
	//jcdpCallService("ProjectSrv", "setProjectType", "project_type="+project_type);
	if(project_type=="5000100004000000008"){
		window.location.target="_self";
		window.location = "<%=contextPath%>/pm/project/singleProject/ws/insertProject.jsp?projectType="+project_type;
	}
	if(project_type=="5000100004000000001"){
		window.location.target="_self";
		window.location = "<%=contextPath%>/pm/project/multiProject/insertProject.jsp?orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgSubjectionId%>";
	}
}
</script>
<body>
请选择项目类型，点击下一步立项
<table width="50%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr>
<td class="inquire_item4">项目类型：</td>
<td class="inquire_form4" >
  	<select class="select_width" name="project_type" id="project_type">
		<option value='5000100004000000001'>陆地项目</option>
		<option value='5000100004000000008'>井中项目</option>
	</select>
</td>
</tr>
<tr>
<td class="inquire_item4"><input type="submit" value="下一步" onclick="setProjectType()"></td>
</tr>
</table>
</body>
</html>