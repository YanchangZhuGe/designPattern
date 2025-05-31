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
 	
	UserToken user = OMSMVCUtil.getUserToken(request);

 	String orgSubjectionId=user.getSubOrgIDofAffordOrg();
  	 
 		String reportFileName = request.getParameter("reportId").toString();
 		System.out.print(reportFileName);
 		String title = reportFileName; 
 		String typeId=request.getParameter("typeId");
 		System.out.print(typeId);
 		 Calendar cal = Calendar.getInstance();
		 int calYear = cal.get(Calendar.YEAR);
 		
 
	 
	
	String orgS_id = (user==null)?"":user.getSubOrgIDofAffordOrg();
	String year="";
	String org_name="";
	if(request.getParameter("year")!=null){
		if(request.getParameter("year").equals("")){
			year=calYear+"";
 		}else{
			year=request.getParameter("year");
		}
 	}
	if(request.getParameter("org_name")!=null){
 		org_name= new String(request.getParameter("org_name").getBytes("ISO-8859-1"),"UTF-8");
  	}
		
	 
 
	 String start_date=(String) request.getParameter("start_date");
 
	
	String end_date = (String) request.getParameter("end_date");
	if(end_date ==null || end_date.trim().equals("")){
		end_date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	}
	 
 
	String project_info_no = user.getProjectInfoNo();
 
	
	String project_name = user.getProjectName();
	String exploration_method = user.getExplorationMethod();
	title = project_name + title;
	String rptParams = request.getParameter("rptParams");
    if(rptParams==null){
	   rptParams="year="+year+";org_name="+org_name;
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
<body style="background:#fff" onload="page_init()" >
<div id="list_table">
	<div id="inq_tool_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
			 
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						  	<td class="ali_cdn_name">年度：</td>
							   <td class="ali_cdn_input">
					<select id="year" name="year">
					 	<option value="">全部</option>
 						<option value="2013">2013</option>
						<option value="2014" >2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
					</select>
			 	    </td>
						 </td>
			 	    <td class="ali_cdn_name">队伍：</td>
			 	    <td class="ali_cdn_input">
					<select id="obs_name" name="obs_name">
					 	<option value="">全部</option>
 						<option value="2504队">2504队</option>
						<option value="2508队">2508队</option>
						<option value="2513队">2513队</option>
						<option value="2514队">2514队</option>
						<option value="2517队">2517队</option>
						<option value="2518队">2518队</option>
						<option value="2521队">2521队</option>
						<option value="2522队">2522队</option>
					</select>
			 	    </td>
							<auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
					 
							<td>&nbsp;</td> 
						 
						</tr>
					</table>
			 
				
				</td>
			</tr>
		</table>
	</div>
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
<script type="text/javascript">
function page_init(){
	 $("#year").val('<%=year%>');
	$("#obs_name").val('<%=org_name%>');
 	
}
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height());
	function refreshData(){
		debugger;
  		var year = document.getElementById("year").value;
		var org_name = document.getElementById("obs_name").value;
		var typeId="<%=typeId%>";
  		if(year!=''&&org_name!=''){
 			if(typeId==1){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/unconfirm_report.raq&year='+year+'&org_name='+org_name+'&typeId='+typeId;
 			}else if(typeId==2){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/unWeek_report.raq&year='+year+'&org_name='+org_name+'&typeId='+typeId;
 			}else if(typeId==3){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/year_reportAll.raq&year='+year+'&org_name='+org_name+'&typeId='+typeId;
 			}else if(typeId==4){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/year_report2.raq&year='+year+'&org_name='+org_name+'&typeId='+typeId;
 			}
		}else if(year!=''&&org_name==''){
			
			if(typeId==1){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/unconfirm_report1.raq&year='+year+'&typeId='+typeId;
 			}else if(typeId==2){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/week_report1.raq&year='+year+'&typeId='+typeId;
			} else if(typeId==3){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/year_unReport.raq&year='+year+'&typeId='+typeId;
			}  else if(typeId==4){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/year_unReport2.raq&year='+year+'&typeId='+typeId;
			} 
			
		}   else if(year==''&&org_name!=''){
 			if(typeId==1){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/unconfirm_report2.raq&org_name='+org_name+'&typeId='+typeId;
			}else if(typeId==2){
		  		  window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/week_report2.raq&org_name='+org_name+'&typeId='+typeId;
			}else if(typeId==3){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/year_unReport1.raq&org_name='+org_name+'&typeId='+typeId;
 			}else if(typeId==4){
  	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/year_report3.raq&org_name='+org_name+'&typeId='+typeId;
 			}
		}  else{
			if(typeId==1){
				window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/unReport.raq&reportId='+typeId;
			}else if(typeId==2){
		  		  window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/week_report.raq&reportId='+typeId; 
			}else if(typeId==3){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/year_report.raq&typeId='+typeId;
 			}else if(typeId==4){
 	  			window.location.href='<%=contextPath%>/pm/projectReport/ws_report.jsp?reportId=jz/year_report1.raq&typeId='+typeId;
 			}
		}

	 
    
	}
 
</script>
</body>
</html>