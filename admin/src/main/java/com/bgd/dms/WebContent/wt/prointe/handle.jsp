<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String design_id="";
	 
	System.out.print(request.getParameter("businessId"));
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
 <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

  <title>处理解释设计</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
	 
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
					    <td class="inquire_form6"> <input type="text" id="project_name" name="project_name" /></td>
					    <td class="inquire_item6"><span class="red_star">*</span>编写人： </td>
					    <td class="inquire_form6" ><input type="text" id="writer" name="writer" /></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6"> 处理计划开始时间：</td>
					    <td class="inquire_form6"> 
					         <input type="text" id="proces_plan_startdate" name="proces_plan_startdate" />
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(proces_plan_startdate,tributton1);" />
					    </td>
					    <td class="inquire_item6"> 处理计划结束时间： </td>
					    <td class="inquire_form6" >
					         <input type="text" id="proces_plan_enddate" name="proces_plan_enddate" />
		    			&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(proces_plan_enddate,tributton2);" />
					    </td>
					  </tr>
					    <tr>
					  	<td class="inquire_item6"> 解释计划开始时间：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="interp_plan_startdate" name="interp_plan_startdate" />
					    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(interp_plan_startdate,tributton3);" />
					    
					    </td>
					    <td class="inquire_item6"> 解释计划结束时间： </td>
					    <td class="inquire_form6" >
					    <input type="text" id="interp_plan_senddate" name="interp_plan_senddate" />
					    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(interp_plan_senddate,tributton4);" />
					    
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">处理解释设计</td>
					    <td class="inquire_form6" >
					    <input type="text"  name="file_name"  id="file_name" readonly style="background:#CCCCCC"/>
					    </td>
					  </tr>        
			  </table>
			</div>
 
 	 
			 
				 
				
		 
			 
		 	</div>
 </body>
 
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
 
	
	function refreshData(){
		debugger;
		var design_id="<%=design_id%>";
		   var retObj = jcdpCallService("WtProinteSrv", "getProjectInfo", "design_id="+design_id);
    		document.getElementById("project_name").value= retObj.map.projectName; 
    		document.getElementById("writer").value= retObj.map.writer; 
    		document.getElementById("proces_plan_startdate").value= retObj.map.procesPlanStartdate; 
    		document.getElementById("proces_plan_enddate").value= retObj.map.procesPlanEnddate; 
    		document.getElementById("interp_plan_startdate").value= retObj.map.interpPlanStartdate; 
    		document.getElementById("interp_plan_senddate").value= retObj.map.interpPlanSenddate; 
    		document.getElementById("file_name").value= retObj.map.fileName; 

	}
</script>
</html>