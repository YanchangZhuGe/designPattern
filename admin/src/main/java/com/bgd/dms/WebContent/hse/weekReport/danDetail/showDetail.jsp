<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String hse_danger_id = request.getParameter("hse_danger_id");
	
	
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
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
				<tr>
			     	<td class="inquire_item4">单位：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="org_name" name="org_name" class="input_width" readonly="readonly"/>
			      	</td>
			     	<td class="inquire_item4">基层单位：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="second_name" name="second_name" class="input_width" readonly="readonly"/>
			      	</td>
		     	</tr>
			  	<tr>
			     	<td class="inquire_item4">因素状态：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="dan_type" name="dan_type" class="input_width" readonly="readonly"/>
			      	</td>
			     	<td class="inquire_item4">因素级别：</td>
			      	<td class="inquire_form4">
			      	<input type="text" id="dan_level" name="dan_level" class="input_width" readonly="readonly"/>
			      	</td>
		     	</tr>
		     	<tr>
				    <td class="inquire_item4">危害因素描述：</td>
				    <td class="inquire_form4" colspan="3"><textarea id="dan_describe" name="dan_describe" class="textarea"  readonly="readonly"></textarea></td>
			  	</tr>	
		     	<tr>
				    <td class="inquire_item4">风险削减措施：</td>
				    <td class="inquire_form4" colspan="3"><textarea id="dan_step" name="dan_step" class="textarea"  readonly="readonly"></textarea></td>
			  	</tr>	
		     	<tr>
				    <td class="inquire_item4">备注：</td>
				    <td class="inquire_form4" colspan="3"><textarea id="dan_note" name="dan_note" class="textarea"  readonly="readonly"></textarea></td>
			  	</tr>	
			</table>
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

function closeButton(){
	newClose();
}

function queryOrg(){
	debugger;
	var checkSql="select d.*,decode(d.dan_type,'1','已整改','2','未整改','3','正在整改') danger_type,decode(d.dan_level,'1','特大','2','重大') danger_level,oi2.org_abbreviation org_name,oi.org_abbreviation second_name from bgp_hse_common c left join bgp_hse_dan_detail d on c.hse_common_id=d.hse_common_id left join bgp_hse_org ho on ho.org_sub_id=c.org_id left join comm_org_subjection os on os.org_subjection_id=ho.org_sub_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' left join comm_org_subjection os2 on ho.father_org_sub_id=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' where c.bsflag='0' and d.hse_danger_id='<%=hse_danger_id%>' ";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	if(datas!=null&&datas!=""){
		document.getElementById("org_name").value = datas[0].org_name;
		document.getElementById("second_name").value = datas[0].second_name;
		document.getElementById("dan_type").value = datas[0].danger_type;
		document.getElementById("dan_level").value = datas[0].danger_level;
		document.getElementById("dan_describe").value = datas[0].dan_describe;
		document.getElementById("dan_step").value = datas[0].dan_step;
		document.getElementById("dan_note").value = datas[0].dan_note;
	}
		
}




</script>
</html>