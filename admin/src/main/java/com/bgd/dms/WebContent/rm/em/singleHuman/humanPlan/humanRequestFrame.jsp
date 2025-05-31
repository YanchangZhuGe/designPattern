<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>


<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%> 
<%@ page import="java.io.OutputStream"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%> 
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>

<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%> 

<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);	

	String projectInfoNo = user.getProjectInfoNo();
	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");
//	String startDate = request.getParameter("startDate");
//	String endDate = request.getParameter("endDate");
//	String wbsBackUrl = request.getParameter("wbsBackUrl");
//	String taskBackUrl = request.getParameter("taskBackUrl");
    String object_id="";
	String sqlP6 = "  select t.object_id , t.wbs_object_id  from bgp_p6_project t where   t.bsflag='0' and  t.project_info_no = '"+projectInfoNo+"'";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlP6); 
	if(list.size()>0){  
		Map map = (Map)list.get(0); 
		object_id = (String)map.get("wbsObjectId");
	}
	
		 

String wbsBackUrl = "/rm/em/singleHuman/humanPlan/wbsPlanList.jsp";
String taskBackUrl = "/rm/em/singleHuman/humanPlan/taskPlanList.jsp";
String rootBackUrl = "/rm/em/singleHuman/humanPlan/rootPlanList.jsp";
	
%> 

<%
	String projectType=user.getProjectType();
	if(projectType.equals("5000100004000000009")){  //综合 
		
%>

<frameset cols="250,*" frameborder="yes" border="0" framespacing="0">
<frame src="<%=contextPath %>/rm/em/singleHuman/humanPlan/zh_project_tree.jsp" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
<frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>
 

 <%
		
	}else{
		
		String sqlP6Wbs = "    select w.object_id  as ids    from bgp_p6_project_wbs w  where w.parent_object_id = '"+object_id+"'   and w.bsflag = '0'  union all  select to_number(to_char(a.object_id) || to_char(a.project_object_id)) as ids   from bgp_p6_activity a   where a.wbs_object_id = '"+object_id+"'     and a.bsflag = '0' ";
		List listWbs = BeanFactory.getQueryJdbcDAO().queryRecords(sqlP6Wbs); 
		if(listWbs.size()>0){  
			 
%> 

<frameset cols="250,*" frameborder="yes" border="0" framespacing="0">
<frame src="<%=contextPath %>/p6/tree/tree_rl.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
<frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>

<%	
		} else {
 
			%> 	
			
			<frameset cols="250,*" frameborder="yes" border="0" framespacing="0">
			<frame src="<%=contextPath %>/rm/em/singleHuman/supplyHumanPlan/tree.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=/rm/em/singleHuman/humanPlan/jz_planningList.jsp&taskBackUrl=/rm/em/singleHuman/humanPlan/jz_planningList.jsp&rootBackUrl=/rm/em/singleHuman/humanPlan/jz_planningList.jsp" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
			<frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
			</frameset>
			
 <%
		}

	}

%>

