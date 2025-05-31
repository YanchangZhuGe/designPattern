<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empids = request.getParameter("empids");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>专家信息</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" >
  <div id="new_table_box_content">
    <div id="new_table_box_bg" >
      <fieldset><legend>专家信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">专家名称</td>
			<td class="inquire_form6">
				<input id="id" name="id" type ="hidden" value="<%=empids%>"/>
				<input id="employee_name" name="employee_name" class="input_width"  type="text" readonly/>
			<td class="inquire_item6">专家意见</td>
			<td class="inquire_form6"><input id="employee_opinion" name="employee_opinion"  class="input_width" type="text"/></td>
			</td>
		  </tr>
	  </table>	  
	  </fieldset>
	</div>
		<div id="oper_div" style="margin-bottom:5px">
			<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
    </div>   
</div>
</form>
</body>
<script type="text/javascript"> 
	var ids='<%=empids%>';
	var baseData;
	function submitInfo(){
		document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/updateScrapeEmp.srq";
		document.getElementById("form1").submit();
	}

	function loadDataDetail(){
		baseData = jcdpCallService("ScrapeSrv", "getScrapeEmp", "id="+ids);
		$("#employee_name").val(baseData.deviceappMap.employee_name);
		$("#employee_opinion").val(baseData.deviceappMap.employee_opinion);
	}
	
</script>
</html>
 