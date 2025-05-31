<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_subjection_id = user.getOrgSubjectionId();
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	
	System.out.println("sql ="+sql);
	
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = "";
	String sub_id = "";
	String father_organ_flag = "";
	String organ_flag = "";
	if(list.size()>1){
	 	Map map = (Map)list.get(0);
	 	Map mapOrg = (Map)list.get(1);
	 	father_id = (String)map.get("orgSubId");
	 	sub_id = (String)mapOrg.get("orgSubId");
	 	father_organ_flag = (String)map.get("organFlag");
	 	organ_flag = (String)mapOrg.get("organFlag");
	}
 	
%>
<% //if(father_organ_flag.equals("0")||user.getOrgSubjectionId().equals("C105")){
response.sendRedirect(contextPath+"/hse/environmentManage/environmentMenuCompany.jsp");
//}else{ 
//response.sendRedirect(contextPath+"/hse/environmentManage/environmentMenu.jsp");
//} %>
