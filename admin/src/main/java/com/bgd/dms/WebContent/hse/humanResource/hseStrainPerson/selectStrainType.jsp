<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
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
</head>
<body>
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box" style="width: 530px;;height: 275px;">
  <div id="new_table_box_content" style="width: 515px;height: 246px;padding-left: 8px;">
    <div id="new_table_box_bg" style="width: 500px;height: 200px;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr>
				     	<td class="inquire_item6"></td>
				      	<td class="inquire_form6"> 
				      	<input type="checkbox"  name="selected" value="1">自然灾害</input><br/>
				      	<input type="checkbox"  name="selected" value="2">事故灾难</input><br/>
				      	<input type="checkbox"  name="selected" value="3">公共卫生</input><br/>
				      	<input type="checkbox"  name="selected" value="4">社会安全</input><br/>
				      	</td>
				     </tr>
					</table>
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

function submitButton(){
	var ids = "";
	var selected = document.getElementsByName("selected");
	for(var i=0; i<selected.length;i++){
		if(selected[i].checked){
			if(ids!="") ids += "、";
			ids +=selected[i].value;
		}
	}
	window.returnValue = ids;
	window.close();
}

function closeButton(){
	window.close();
}

</script>
</html>