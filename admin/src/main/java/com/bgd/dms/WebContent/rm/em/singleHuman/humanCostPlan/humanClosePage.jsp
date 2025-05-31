<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%

	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//菜单传过来的标志位，1为物探处0为专业化单位
 
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	String projectInfoNoA  = "";
	String projectTypeA = "";
	String projectNameA  = "";
	String planIdD  = "";
	if(respMsg != null){
		message = respMsg.getValue("message");
		  projectInfoNoA = respMsg.getValue("projectInfoNo");
		  projectTypeA = respMsg.getValue("projectType");
		  projectNameA = respMsg.getValue("projectName");
		  planIdD = respMsg.getValue("planIdD");
		
	}
	 response.sendRedirect(contextPath+"/rm/em/humanCostPlan/humanCostPlanFrame.jsp?backUrl=/rm/em/singleHuman/humanCostPlan/humanCostPlanList.jsp&projectInfoNo="+projectInfoNoA+"&projectType="+projectNameA+"&message="+message);

%>

 