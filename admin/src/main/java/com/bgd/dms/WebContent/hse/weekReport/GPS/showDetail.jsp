<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String hse_gps_id = request.getParameter("hse_gps_id");
	
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
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
<body onload="queryOrg()">
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    	<fieldSet style="margin-left:2px"><legend><span id="org_name"></span>GPS使用信息</legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
				<tr>
			     	<td class="inquire_item4">现有安装台数：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="use_no" name="use_no" class="input_width" readonly="readonly"/>
			      	</td>
			     	<td class="inquire_item4">本周工作台数：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="week_use_no" name="week_use_no" class="input_width" readonly="readonly"/>
			      	</td>
		     	</tr>
			  	<tr>
			     	<td class="inquire_item4">正常：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="normal_no" name="normal_no" class="input_width" readonly="readonly"/>
			      	</td>
			     	<td class="inquire_item4">不正常：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="wrong_no" name="wrong_no" class="input_width" readonly="readonly"/>
			      	</td>
		     	</tr>
		     	<tr>
				    <td class="inquire_item4">待修：</td>
				    <td class="inquire_form4">
			      	<input type="text" id="fix_no" name="fix_no" class="input_width" readonly="readonly"/>
			      	</td>
			  	</tr>	
		     	<tr>
				    <td class="inquire_item4">不正常原因：</td>
				    <td class="inquire_form4" colspan="3"><textarea id="wrong_reason" name="wrong_reason" class="textarea"  readonly="readonly"></textarea></td>
			  	</tr>	
		     	<tr>
				    <td class="inquire_item4">采取措施：</td>
				    <td class="inquire_form4" colspan="3"><textarea id="wrong_step" name="wrong_step" class="textarea"  readonly="readonly"></textarea></td>
			  	</tr>	
			</table>
		</fieldSet>
		<fieldSet style="margin-left:2px"><legend><span id="org_name"></span>GPS监控信息</legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
				<tr>
			     	<td class="inquire_item4">违章统计(台)：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="rule_no" name="rule_no" class="input_width" readonly="readonly"/>
			      	</td>
		     	</tr>
		     	<tr>
				    <td class="inquire_item4">违章原因：</td>
				    <td class="inquire_form4" colspan="3"><textarea id="rule_reason" name="rule_reason" class="textarea"  readonly="readonly"></textarea></td>
			  	</tr>	
		     	<tr>
				    <td class="inquire_item4">采取措施：</td>
				    <td class="inquire_form4" colspan="3"><textarea id="rule_step" name="rule_step" class="textarea"  readonly="readonly"></textarea></td>
			  	</tr>	
			</table>
		</fieldSet>
	</div>
	<div id="oper_div">
		<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
	</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
var hse_gps_id = "<%=hse_gps_id%>";

function closeButton(){
	newClose();
}

function queryOrg(){
	debugger;
	var checkSql="select g.*,oi.org_abbreviation org_name from bgp_hse_common c left join bgp_hse_week_gps g on c.hse_common_id=g.hse_common_id left join comm_org_subjection os on c.org_id=os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where c.bsflag='0' and g.hse_gps_id='<%=hse_gps_id%>'";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	if(datas!=null&&datas!=""){
		document.getElementById("org_name").innerHTML = datas[0].org_name;
		document.getElementById("use_no").value = datas[0].use_no;
		document.getElementById("week_use_no").value = datas[0].week_use_no;
		document.getElementById("normal_no").value = datas[0].normal_no;
		document.getElementById("wrong_no").value = datas[0].wrong_no;
		document.getElementById("fix_no").value = datas[0].fix_no;
		document.getElementById("wrong_reason").value = datas[0].wrong_reason;
		document.getElementById("wrong_step").value = datas[0].wrong_step;
		
		document.getElementById("rule_no").value = datas[0].rule_no;
		document.getElementById("rule_reason").value = datas[0].rule_reason;
		document.getElementById("rule_step").value = datas[0].rule_step;
	}
		
}




</script>
</html>