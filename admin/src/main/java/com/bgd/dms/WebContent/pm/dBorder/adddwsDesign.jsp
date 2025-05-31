<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
    String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新增工区设计边框</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script>
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

function forward()
	{
	//window.location.href="index.html"
	}
</script>
<script type="text/javascript">
function checkForm() {
	if (!isTextPropertyNotNull("border_break_point", "边界拐点")) {
   		document.form1.border_break_point.focus();
		return false;
	}
	if (!isLimitB32("border_break_point", "边界拐点")) {
    	document.forms[0].border_break_point.focus();
		return false;
	}
	if (!isValidFloatProperty7_2("altitude", "海拔")) {
    	document.forms[0].altitude.focus();
		return false;
	}
    if (!isTextPropertyNotNull("point_x", "X坐标")) {
        document.forms[0].point_x.focus();
		return false;
	}		
	if (!isValidFloatProperty12_2("point_x", "X坐标")) {
    	document.forms[0].point_x.focus();
		return false;
	}		
    if (!isTextPropertyNotNull("point_y", "Y坐标")) {
    	document.forms[0].point_y.focus();
		return false;
	}
	if (!isValidFloatProperty12_2("point_y", "Y坐标")) {
    	document.forms[0].point_y.focus();
		return false;
	}

	return true;
}
	
function toSave(){
	if (!checkForm()) return;
	var form = document.forms[0];
	form.action="<%=contextPath%>/pm/gpe/saveDwsDesign.srq";
	form.submit();
}
	
function cancle(){
}
	
</script>
<link href="table.css" rel="stylesheet" type="text/css" />
</head>

<body>
<form id="CheckForm" name="form1" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   <td class="inquire_item4">边框类型：</td>
   <td class="inquire_form4">
   	<input type="hidden" name="wa3d_design_no" value=""/>
	<input type="hidden" name="project_info_no" value="<%=projectInfoNo%>"/>
	<select name="frame_shape" class="select_width">
   		<option value="1">边框设计数据</option>
   		<option value="2">边框成果数据</option>
   </select>
   </td>
   <td class="inquire_item4">数据类型：</td>
   <td class="inquire_form4">
   <select name="data_type" class="select_width">
   		<option value="1">炮点</option>
   		<option value="2">检波点</option>
   		<option value="3">满覆盖</option>
   		<option value="4">一次覆盖</option>
   		<option value="5">施工面积</option>
   </select>
   </td>
  </tr>
  <tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;边界拐点：</td>
   <td class="inquire_form4">
	<input name="border_break_point" type="text" value="" class="input_width" />
   </td>

    <td class="inquire_item4">海拔：</td>
    <td class="inquire_form4"><input name="altitude" type="text" value=""class="input_width"/>    
    </td>
  </tr>
  <tr>
  	<td class="inquire_item4"><font color="red">*</font>&nbsp;X坐标(6位或8位)：</td>
    <td class="inquire_form4">
    <input name="point_x" value="" type="text" class="input_width"/> 
	</td>
	<td class="inquire_item4"><font color="red">*</font>&nbsp;Y坐标(7位)：</td>
	 <td class="inquire_form4"><input name="point_y" type="text" value="" class="input_width" />
	 </td>
  </tr>
</table>
  </div>
  <div id="oper_div">
   	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
</body>
</html>