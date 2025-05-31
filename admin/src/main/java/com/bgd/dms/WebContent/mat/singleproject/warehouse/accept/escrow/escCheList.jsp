<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body onload='refreshData()' style="background:#fff">
<form name="form1" id="form1" method="post"
	action="">
	<input type='hidden' name='code_id' id = 'code_id' value='1'/>
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
	<tr>
    	<td colspan="6" align="center">接受单据选择</td>
    </tr>
</table>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{invoices_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{invoices_no}">编号</td>
			      <td class="bt_info_even" exp="{source}">来源</td>
			      <td class="bt_info_odd" exp="{input_date}">日期</td>
			      <td class="bt_info_even" exp="{operator}">经办人</td>
			      <td class="bt_info_odd" exp="{total_money}">金额</td>
			      <td class="bt_info_even" exp="{note}">备注</td>
			    </tr>
			  </table>
			</div>
			<table id="fenye_box_table">
			</table>
<div id="oper_div"><span class="tj_btn"><a href="#"
	onclick="save()"></a></span> <span class="gb_btn"><a href="#"
	onclick="newClose()"></a></span></div>
</form>
</body>
<script type="text/javascript">
function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>
<script type="text/javascript"><!--
	cruConfig.contextPath =  "<%=contextPath%>";
	function refreshData(){
		var sql ="select t.* from gms_mat_teammat_invoices t where t.project_info_no='<%=projectInfoNo%>' and t.invoices_type='3'and t.if_input='1'";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouse/accept/escrow/escCheList.jsp";
		queryData(1);
	}
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
		document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/accept/escrow/queryEscList.srq?invoices_type=3&laborId="+ids;
		document.getElementById("form1").submit();
			}
	}
	
</script>
</html>