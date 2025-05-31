<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
 
 
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();
	String projectInfoNo = user.getProjectInfoNo();
	String project_subjection_id = QualityUtil.getProjectSubjectionId(projectInfoNo);
	String reportFile="daily_report.raq";

	String reportName = "综合物化探价值工作量统计表(按地区) ";//ReportGenInitServlet.getReportFile(reportId);
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
 
<body>
  <div>
	<table   align="center"  id="90" >
		<tr>
			    		<td class="report1_2_8"><a  href="#" onclick="report1_saveAsExcel();return false">导出Excel</a></td>
			     
				 
			  		</tr>
		<tr align="center" >
		    <td align="center" >
		  
			  <report:html name="report1" reportFileName="<%=reportFile %>"
						   funcBarLocation=""
						     params=""
						   needScroll="yes"
						   scrollWidth="100%"
						   scrollHeight="50%"
						   needSaveAsExcel="yes"
						   saveAsName="<%=reportName %>"
						   excelPageStyle="0"
			  />
		
			</td>
			
  	</tr>
	</table>
	</div>
</body>
</html>