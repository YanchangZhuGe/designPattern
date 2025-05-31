<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>

<%
	String contextPath = request.getContextPath();
	String reportFileName = "/lineRport.raq";
	
	UserToken user = OMSMVCUtil.getUserToken(request);

	String orgSubjectionId=user.getSubOrgIDofAffordOrg();
  	 
	String title = reportFileName; 
 
 
 
	 
	
	String orgS_id = (user==null)?"":user.getSubOrgIDofAffordOrg();
	
	  String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0'    start with t.org_sub_id = '"+orgS_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
		
		System.out.println("sql ="+sql);	
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String orgSubIdA = "";
		String orgSubIdB = "";
		String orgSubIdC = "";
		String organ_flagA = "";
		String organ_flagB = "";
		String organ_flagC = "";
		
		if(list.size()>1){
		 	Map mapA = (Map)list.get(0);
		 	Map mapOrgB= (Map)list.get(1); 
			
//		 	if(mapOrgB == null){
//		 		mapOrgB= mapA;	 
//		 	} 
		 	
			orgSubIdA = (String)mapA.get("orgSubId");
			orgSubIdB = (String)mapOrgB.get("orgSubId"); 
			organ_flagA = (String)mapA.get("organFlag");
			organ_flagB = (String)mapOrgB.get("organFlag"); 
			
			if(organ_flagB.equals("")){
				if(organ_flagA.equals("1")){
					orgS_id = orgSubIdA;
				}
			}
			if(organ_flagB.equals("1")){
				orgS_id = orgSubIdB;
			}

			if(list.size()>2){ 
				Map mapOrgC = (Map)list.get(2);
				orgSubIdC = (String)mapOrgC.get("orgSubId");
				organ_flagC = (String)mapOrgC.get("organFlag");
				
				if(organ_flagC.equals("1")){
					orgS_id = orgSubIdC;
				}

				if(organ_flagC.equals("")){
					if(organ_flagB.equals("1")){
						orgS_id = orgSubIdB;
					}
				}
			}
		 
			
		 	if(organ_flagA.equals("0")||user.getOrgSubjectionId().equals("C105")){
		 		orgS_id = "C105";
		 	}
		}
		
	 
 
	
 
	 
 
	String project_info_no = user.getProjectInfoNo();
 
	
	String project_name = user.getProjectName();
	String exploration_method = user.getExplorationMethod();
	title = project_name + title;
	String rptParams = request.getParameter("rptParams");
	if(rptParams==null ){
		  rptParams ="project_name="+project_name+";project_info_no="+project_info_no;
	}
	 
 
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
 <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	 
	<div id="table_box">
		<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
			<tr>
				<td>
					<report:html name="report1"
					reportFileName="<%=reportFileName %>"
					params="<%=rptParams%>"
					width="-1" 
					height="-1"
					needScroll="no"
					needSaveAsExcel="yes"
					saveAsName="<%=title%>" excelPageStyle="0"/>
				</td>
			</tr>
		</table>
	</div>
</div>
 
 
</script>
</body>
</html>