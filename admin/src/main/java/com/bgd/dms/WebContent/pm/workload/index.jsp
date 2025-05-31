<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = request.getParameter("projectName");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	
	

	String projectType = user.getProjectType();//项目类型
	//<option value='5000100004000000008'>井中项目</option>
	//<option value='5000100004000000001'>陆地项目</option>
	//<option value='5000100004000000007'>陆地和浅海项目</option>
	//<option value='5000100004000000009'>综合物化探</option>
	//<option value='5000100004000000010'>滩浅海地震</option>
	//<option value='5000100004000000005'>地震项目</option>
	//<option value='5000100004000000002'>浅海项目</option>
	//<option value='5000100004000000003'>非地震项目</option>
	//<option value='5000100004000000006'>深海项目</option>
	//5000100004000000002 浅海项目
	//5000100004000000010 滩浅海过渡带项目	
	
	

	//projectType="5000100004000000006";
	
	if("5000100004000000009".equals(projectType)){
		//综合物化探
		//request.getRequestDispatcher("/wt/tm/parameter/technicalParameter.jsp").forward(request,response);
		response.sendRedirect(contextPath+"/p6/showTree.srq?projectInfoNo="+projectInfoNo+"&checked=true&taskBackUrl=/wt/pm/planManager/singlePlan/planning/workloadList.jsp");

	}else if("5000100004000000008".equals(projectType)){
		//井中
		response.sendRedirect(contextPath+"/p6/showTree.srq?projectInfoNo="+projectInfoNo+"&checked=true&taskBackUrl=/ws/pm/plan/singlePlan/workload/workloadList.jsp");
	
	}else if("5000100004000000006".equals(projectType)){
		//深海
		response.sendRedirect(contextPath+"/p6/showTree.srq?projectInfoNo="+projectInfoNo+"&checked=true&taskBackUrl=/pm/workload/sh/workloadList.jsp");
	
	}else{
		//原项目
		response.sendRedirect(contextPath+"/p6/showTree.srq?projectInfoNo="+projectInfoNo+"&checked=true&taskBackUrl=/pm/workload/workloadList.jsp");

	}
	
%>
<html>
<head>
</head>

<script type="text/javascript">

//location.href="<%=contextPath %>/p6/showTree.srq?projectInfoNo=<%=projectInfoNo %>&checked=true&taskBackUrl=/pm/workload/workloadList.jsp";
//location.href="<%=contextPath %>/p6/showTree.srq?projectInfoNo=<%=projectInfoNo %>&checked=true&taskBackUrl=/wt/pm/planManager/singlePlan/planning/workloadList.jsp";


</script>
<body>
</body>
</html>