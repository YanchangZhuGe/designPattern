<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.Map"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%> 
<%@taglib prefix="auth" uri="auth"%>
 
<%
	String contextPath = request.getContextPath(); 
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request); 
	
	String projectInfoNo =request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新建人工成本补充计划</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
</head>
<body  >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
	<div id="new_table_box_content">
    	<div id="new_table_box_bg">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
		     	<tr>
			    	<td class="inquire_item4"><font color="red">*</font>申请理由：</td>
			      	<td class="inquire_form4" colspan="3"><textarea id="applyReason" name="applyReason" class="textarea"></textarea></td>
		        </tr>
			</table>
		</div>
		<div id="oper_div" >
			<span class="tj_btn"><a href="#" onclick="save()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	</div>
</div> 
</form>
</body>
<script type="text/javascript"> 
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

	function save(){ 
		if (!isTextPropertyNotNull("applyReason","申请理由")) return false;
		var params = $("#form").serialize();
		params+="&projectInfoNo=<%=projectInfoNo%>&costState=1";
		
		var planId = jcdpCallService("HumanCommInfoSrv","saveHumanPlanCostTwo",params);
		if(planId.planId!=""){
			alert("保存成功!");
			parent.list.frames[1].location.reload();	
			newClose();
		}
	}
</script>
</html>