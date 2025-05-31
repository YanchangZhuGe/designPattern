<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.mcs.service.rm.dm.equipmentApply.pojo.*"%>
<%@ page import="java.io.OutputStream"%>
<%@page import="java.net.URLDecoder"%>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String project_type = respMsg.getValue("project_type");
	String week_date = respMsg.getValue("week_date");
	String week_end_dates = respMsg.getValue("week_end_date");
	String org_id = respMsg.getValue("org_id"); 
	String action=respMsg.getValue("action"); 
	String message =respMsg.getValue("message"); 
	
	if("add".equals(action)){
		if("1".equals(project_type)){
			out.write("<script type=\"text/javascript\" >window.location = '"+contextPath+"/pm/wr/projectDynamic/edit.jsp?projectType=1&org_id="+org_id+"&week_date="+week_date+"&week_end_date="+week_end_dates+"&action=add&message='+encodeURI(encodeURI('"+message+"'));</script>");
		}else if("3".equals(project_type)){
			out.write("<script type=\"text/javascript\">window.location = '"+contextPath+"/pm/wr/projectDynamic/edit.jsp?projectType=3&org_id="+org_id+"&week_date="+week_date+"&week_end_date="+week_end_dates+"&action=add&message='+encodeURI(encodeURI('"+message+"'));</script>");
		}
	}else if ("edit".equals(action)){
		if("1".equals(project_type)){
			out.write("<script type=\"text/javascript\">window.location = '"+contextPath+"/pm/wr/projectDynamic/edit.jsp?projectType=1&org_id="+org_id+"&week_date="+week_date+"&week_end_date="+week_end_dates+"&action=edit&message='+encodeURI(encodeURI('"+message+"'));</script>");
		}else if("3".equals(project_type)){
			out.write("<script type=\"text/javascript\">window.location = '"+contextPath+"/pm/wr/projectDynamic/edit.jsp?projectType=3&org_id="+org_id+"&week_date="+week_date+"&week_end_date="+week_end_dates+"&action=edit&message='+encodeURI(encodeURI('"+message+"'));</script>");
		}
	}
%>

</html>
