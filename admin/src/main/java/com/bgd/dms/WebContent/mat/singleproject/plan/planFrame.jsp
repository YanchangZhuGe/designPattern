<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
//	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectInfoNo = user.getProjectInfoNo();
	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");
//	String startDate = request.getParameter("startDate");
//	String endDate = request.getParameter("endDate");
//	String wbsBackUrl = request.getParameter("wbsBackUrl");
//	String taskBackUrl = request.getParameter("taskBackUrl");
	
	
	String wbsBackUrl = "/mat/singleproject/plan/planItemList.jsp";
	String taskBackUrl = "/mat/singleproject/plan/planItemList.jsp";
	String rootBackUrl = "/mat/singleproject/plan/planSumList.jsp";
	String projectType = user.getProjectType();
	String orgCode=user.getOrgCode();
	//如果是否大港C105007/
	if(orgCode.indexOf("C105007")>-1){
			wbsBackUrl = "/mat/singleproject/plan/planItemListDg.jsp";
			taskBackUrl = "/mat/singleproject/plan/planItemListDg.jsp";
			rootBackUrl = "/mat/singleproject/plan/planSumListDg.jsp";
	}else{
	//项目类型为综合物化探的跳到另一个页面
		if(projectType!=null&&projectType.equals("5000100004000000009")){
			wbsBackUrl = "/mat/singleproject/plan/planRough/planItemListRough.jsp";
			taskBackUrl = "/mat/singleproject/plan/planRough/planItemListRough.jsp";
		}
		if(projectType!=null&&projectType.equals("5000100004000000008")){
			wbsBackUrl = "/mat/singleproject/plan/planItemListJZ.jsp";
			taskBackUrl = "/mat/singleproject/plan/planItemListJZ.jsp";
			rootBackUrl = "/mat/singleproject/plan/planItemListJZ.jsp";
		}
	}
	
	
%>
<script type="text/javascript">
if("<%=projectInfoNo %>"==null){
	alert("请选择项目");
}
</script>
<frameset cols="300,*" frameborder="yes" border="0" framespacing="1">
  <frame src="<%=contextPath %>/p6/tree/treeMat.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>
