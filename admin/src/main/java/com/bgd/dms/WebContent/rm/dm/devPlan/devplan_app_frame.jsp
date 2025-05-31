<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

	String wbsBackUrl = "/rm/dm/devPlan/wbsPlanList.jsp";
	String taskBackUrl = "/rm/dm/devPlan/taskPlanListM.jsp";
	String rootBackUrl = "/rm/dm/devPlan/rootPlanList.jsp";
	
	String deviceallappid = request.getParameter("deviceallappid");
	String allappType = request.getParameter("allappType");

	
	String sonFlag = request.getParameter("sonFlag");
	String dgFlag = request.getParameter("dgFlag");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo")==null?user.getProjectInfoNo():request.getParameter("projectInfoNo");
%>
<script type="text/javascript">

</script>
<frameset cols="300,*" frameborder="yes" border="0" framespacing="1">
  <frame src="<%=contextPath %>/p6/tree/treeM.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>&customKey=idinfo,sonFlag,dgFlag,allappType&customValue=<%=deviceallappid%>,<%=sonFlag%>,<%=dgFlag%>,<%=allappType %>" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
 
<frame src="<%=contextPath %>/rm/dm/devPlan/rootPlanList.jsp?projectInfoNo=<%=projectInfoNo%>&idinfo=<%=deviceallappid%>" name="mainRightframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
  <!-- <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/> -->
</frameset>
