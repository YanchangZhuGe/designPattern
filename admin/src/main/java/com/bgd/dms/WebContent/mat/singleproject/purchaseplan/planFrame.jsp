<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
//	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectInfoNo = user.getProjectInfoNo();
	System.out.println(projectInfoNo);
	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");
//	String startDate = request.getParameter("startDate");
//	String endDate = request.getParameter("endDate");
//	String wbsBackUrl = request.getParameter("wbsBackUrl");
//	String taskBackUrl = request.getParameter("taskBackUrl");
	String projectType = user.getProjectType(); 
	
	String wbsBackUrl = "/mat/singleproject/purchaseplan/planItemList.jsp";
	String taskBackUrl = "/mat/singleproject/purchaseplan/planItemList.jsp";
	String rootBackUrl = "/mat/singleproject/purchaseplan/planSumList.jsp";
	
	String orgCode=user.getOrgCode();
	//如果是否大港C105007/开发时用superadmin改成C105
	if(orgCode.indexOf("C105007")>-1){
			wbsBackUrl = "/mat/singleproject/purchaseplan/planItemListDg.jsp";
			taskBackUrl = "/mat/singleproject/purchaseplan/planItemListDg.jsp";
			rootBackUrl = "/mat/singleproject/purchaseplan/planSumListDg.jsp";
	}else{
		if(projectType!=null&&projectType.equals("5000100004000000008")){
			rootBackUrl = "/mat/singleproject/purchaseplan/planItemList.jsp";
		}
	}
	
%>
<script type="text/javascript">
if(<%=projectInfoNo %>==null){
	alert("请选择项目");
}
</script>
<frameset cols="300,*" frameborder="yes" border="0" framespacing="1">
  <frame src="<%=contextPath %>/p6/tree/treeMat.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>
