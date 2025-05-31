<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
 
<%@ page import="java.util.Map"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 


<%
	String contextPath = request.getContextPath();
//	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);	
	String projectInfoNo = user.getProjectInfoNo();
	String wbsObjectId = request.getParameter("wbsObjectId"); 
	String projectObjectId = request.getParameter("projectObjectId");
 
//	String startDate = request.getParameter("startDate");
//	String endDate = request.getParameter("endDate");
//	String wbsBackUrl = request.getParameter("wbsBackUrl");
//	String taskBackUrl = request.getParameter("taskBackUrl");

String wbsBackUrl = "/rm/em/singleHuman/humanLedger/wbsPlanList.jsp";
String taskBackUrl = "/rm/em/singleHuman/humanLedger/taskPlanList.jsp";
String rootBackUrl = "/rm/em/singleHuman/humanLedger/rootPlanList.jsp";
	
//查询是否 子项目
String sqlButton = " select t.project_info_no,t.project_father_no ,t.project_name   from gp_task_project  t  where  t.project_info_no='"+projectInfoNo+"' and  t.bsflag='0' and t.project_father_no is not  null "; 
List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlButton);
//System.out.println("sql ="+list.size());	
if(list.size()>0){
 	Map mapA = (Map)list.get(0);
 	String pFid= (String)mapA.get("projectFatherNo");
	%>  
	<frameset cols="0,*" frameborder="yes" border="0" framespacing="0">
	<frame src="" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
	<frame src="<%=contextPath %>/rm/em/singleHuman/humanLedger/rootPlanList.jsp?taskId=4007&projectInfoNo=<%=projectInfoNo%>&zPview=<%=pFid%>" name="mainRightframe" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
	</frameset>

	<%
}else{ 
%>

<frameset cols="300,*" frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/rm/em/singleHuman/humanLedger/tree.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>" name="mainTopframe" frameborder="no" scrolling="no" style="border-right: 2px solid #5796DD; cursor: w-resize;"  id="mainTopframe"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>
<%
  } 
%>