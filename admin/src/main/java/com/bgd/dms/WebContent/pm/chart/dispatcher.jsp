<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = user.getProjectInfoNo();
    String projectType = user.getProjectType();
    String orgSubjectionId = user.getOrgSubjectionId();
 
	String orgId = user.getSubOrgIDofAffordOrg();
	// 处理多项目首页面新兴井中用户看到的菜单
	String sql = " SELECT DISTINCT M.menu_id  FROM P_AUTH_USER_ROLE PR, p_auth_role_menu_dms PM, P_AUTH_MENU_DMS M WHERE ((PR.USER_ID = '"+user.getUserId()+"'   AND PM.ROLE_ID = PR.ROLE_ID) or PM.ROLE_ID = 'INIT_AUTH_ROLE_012345678000001')   AND PM.MENU_ID = M.MENU_ID   AND M.IS_LEAF = '1' and m.menu_c_name ='井中首页图表' ";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String menu_id = "";
	if(orgId.startsWith("C105005001")){
		if(list.size()>0){
		 	Map map = (Map)list.get(0); 
		 	menu_id = (String)map.get("menuId");	  
		}
	} 
 
    if(orgSubjectionId.startsWith("C105007")){//大港
 
		request.getRequestDispatcher("../chart/dg/dg_chujiFrame.jsp").forward(request, response);
 
	}else if(orgSubjectionId.startsWith("C105008")){//综合物化探
		request.getRequestDispatcher("../chart/wt/chart3.jsp").forward(request, response);
	}else{ 
		 if(!menu_id.equals("")){
			request.getRequestDispatcher("tdChartJz.jsp").forward(request, response);
		 }else{ 
				request.getRequestDispatcher("chujiFrame.jsp").forward(request, response);
		 }

	}
%>