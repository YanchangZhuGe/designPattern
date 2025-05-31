<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.net.URLDecoder" %>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectName = user.getProjectName();
	String projectInfoNo = request.getParameter("project_info_no") != null ? request.getParameter("project_info_no").toString() : "";
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>增加作业</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body>
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height: 100px;">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
  	<tr>
    	<td colspan="4" align="center"><b>项目进度计算</b></td>
    </tr>
    <tr>
      	<td class="inquire_item4">项目名称：</td>
      	<td class="inquire_form4"><%=projectName%>&nbsp;</td>
      	<td class="inquire_item4"><font color="red">*</font>计算日期：</td>
      	<td class="inquire_form4">
		<input type="text" name="data_date" id="data_date" class="input_width" readonly="readonly"/>
      	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(data_date,tributton1);" />
      	 </td>
    </tr>
  </table> 
</div>
    <div id="oper_div">
        <auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";	
	
	getDataDate();
	
	function refreshData(){
		if(checkForm()){
			//alert("计算期间请耐心等待，不要关闭浏览器！");
			var data_date = document.getElementById("data_date").value;
			var str = "project_info_no=<%=projectInfoNo%>&data_date="+data_date;
			var obj = jcdpCallService("P6ProjectPlanSrv", "scheduleP6Project", str);
			if(obj != null && obj.message == "success") {
				alert("计算成功");
				reload();
				newClose();
			}else if(obj != null && obj.message == "invalidDate"){
				alert("选择的计算时间有问题");
			}else {
				alert("计算失败");
			}
		}

	}
	
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("data_date", "计算日期")) {		
			document.form1.data_date.focus();
			return false;	
		}
		return true;
	}	

	function reload(){
		var ctt = top.frames['list'];
		if(ctt != "" && ctt != undefined){
			ctt.location.reload();
		}
	}
	
	function getDataDate(){
		var str = "project_info_no=<%=projectInfoNo%>";
		var obj = jcdpCallService("P6ProjectPlanSrv", "getDataDate", str);
		if(obj != null && obj.message == "success") {
			document.getElementById("data_date").value = obj.dataDate;
		}else if(obj != null && obj.message == "nodatadate"){
			alert("目前没有数据日期");
		}else {
			alert("项目有问题");
		}
	}

</script>

</html>