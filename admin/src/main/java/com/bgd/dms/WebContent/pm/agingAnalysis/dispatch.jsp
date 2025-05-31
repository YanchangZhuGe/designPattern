<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();
	String projectInfoNo = user.getProjectInfoNo();
	String project_subjection_id = QualityUtil.getProjectSubjectionId(projectInfoNo);
	/*
	if(project_subjection_id!=null && project_subjection_id.trim().startsWith("C105007")){//大港物探处
		String title = "项目时效分析表";
		String start_date = "";
		String end_date = "";
		String agin_date="";
		String sql = "select min(t.produce_date) start_date,max(t.produce_date)end_date from gp_ops_daily_report t "+
			 
			" where t.project_info_no = '"+projectInfoNo+"' and t.bsflag='0'";
			  

 
		Map<String,String> map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sql);
		String sqlDate="  select min(dd.produce_date)produce_date from( select sum(nvl(t.daily_acquire_sp_num, 0) "+
		       "     +nvl(t.daily_jp_acquire_shot_num, 0) +     nvl(t.daily_qq_acquire_shot_num, 0)) sum_shot,  t.produce_date  "+
		    " from gp_ops_daily_report t   where t.bsflag = '0'  and t.project_info_no ='"+projectInfoNo+"'and t.produce_date>=to_date('"+ map.get("start_date")+"', 'yyyy-MM-dd')"+
		   " group by t.produce_date  order by t.produce_date asc )dd where dd.sum_shot>0   ";
		   Map<String,String> mapDate = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sqlDate);
		if(map!=null && mapDate!=null ){
			start_date = map.get("start_date") == null || map.get("start_date").trim().equals("")?"2010-01-01":map.get("start_date");
			end_date = map.get("end_date") == null || map.get("end_date").trim().equals("")?"3000-12-31":map.get("end_date");
			agin_date=mapDate.get("produce_date");
		}
		request.getRequestDispatcher("dateRate.jsp?reportFileName=/pm/dateRate.raq&title="+title+"&start_date="+start_date+"&end_date="+end_date+"&agin_date="+agin_date).forward(request,response);
	} */
	
	 if("5000100004000000006".equals(projectType)){//深海项目报备单独处理 新加 shedit.jsp -- add by bianshen
		request.getRequestDispatcher("shedit.jsp").forward(request,response);
	}else if("5000100004000000009".equals(projectType)){
		request.getRequestDispatcher("multiple.jsp").forward(request,response);
	}else{
		request.getRequestDispatcher("edit.jsp").forward(request,response);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
</html>