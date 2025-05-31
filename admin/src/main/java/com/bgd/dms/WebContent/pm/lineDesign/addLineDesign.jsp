<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>新增线束设计</title>
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
function forward()
	{
	//window.location.href="index.html"
	}
</script>
<script type="text/javascript">
	function checkForm() {
        if (!isTextPropertyNotNull("line_group_id", "线束号")) {
			document.form1.line_group_id.focus();
			return false;	
		}
        if(!isValidFloatProperty20_0("design_infill_sp_num","设计加密炮数")) return false;		
		if(!isValidFloatProperty12_2("receiving_line_start_loc","接收线起始点号")) return false;		
		if(!isValidFloatProperty12_2("receiving_line_end_loc","接收线终止点号")) return false;		
		if(!isValidFloatProperty12_2("receiving_line_start_line","接收线起始线号")) return false;		
		if(!isValidFloatProperty12_2("receiving_line_end_line","接收线终止线号")) return false;	
		if(!isValidFloatProperty12_2("shot_line_start_loc","炮线起始点号")) return false;	
		if(!isValidFloatProperty12_2("shot_line_end_loc","炮线终止点号")) return false;	
		if(!isValidFloatProperty12_2("shot_line_start_line","炮线起始线号")) return false;
		if(!isValidFloatProperty12_2("shot_line_end_line","炮线终止线号")) return false;	
		if(!isValidFloatProperty20_0("shot_array_num","炮排数")) return false;				
		if (!isTextPropertyNotNull("group_design_shot_num", "单束线设计炮数")) return false;	
		if(!isValidFloatProperty20_0("group_design_shot_num","单束线设计炮数")) return false;
		if(!isValidFloatProperty20_0("receiving_line_num","接收线数")) return false;				
		if (!isTextPropertyNotNull("geophone_point", "总检波点数")) return false;			
		if(!isValidFloatProperty20_0("geophone_point","总检波点数")) return false;			
		if(!isValidFloatProperty20_0("total_point_num","总物理点数")) return false;					
		if(!isValidFloatProperty8_3("shot_area","炮点面积")) return false;
		if (!isTextPropertyNotNull("construction_area", "施工面积")) return false;			
		if(!isValidFloatProperty8_3("construction_area","施工面积")) return false;					
		if(!isValidFloatProperty20_0("shot_density","炮密度")) return false;		
		if (!isTextPropertyNotNull("design_sp_num", "设计总炮数")) return false;			
		if(!isValidFloatProperty20_0("design_sp_num","设计总炮数")) return false;		
		if (!isTextPropertyNotNull("actual_fullfold_area", "设计满覆盖工作量")) return false;				
		if(!isValidFloatProperty8_3("actual_fullfold_area","设计满覆盖工作量")) return false;		
		if (!isTextPropertyNotNull("design_surface_3d_sp_num", "线束表层设计点数")) return false;		
		if(!isValidFloatProperty10_0("design_surface_3d_sp_num","线束表层设计点数")) return false;					
		if(!isLimitB32("trace_interval","道距")) return false;
		if (!isLimitB50("fold","覆盖次数")) return false;
       
		return true;
	}
	
	function toSave(){
		if (!checkForm()) return;
		var form = document.forms[0];
		form.action="<%=contextPath%>/pm/gpe/saveLineGroupDesign.srq";
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
   		<td class="inquire_item4"><font color="red">*</font>&nbsp;线束号：</td>
  		<td class="inquire_form4">
  		<input type="hidden" name="group_design_no" value="" />
  		<input type="hidden" name="project_info_no" value="<%=projectInfoNo%>"/>
  		<input name="line_group_id" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4">设计加密炮数：</td>
   		<td class="inquire_form4"><input name="design_infill_sp_num" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">接收线起始点号：</td>
  		<td class="inquire_form4"><input name="receiving_line_start_loc" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4">接收线终止点号：</td>
   		<td class="inquire_form4"><input name="receiving_line_end_loc" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">接收线起始线号：</td>
  		<td class="inquire_form4"><input name="receiving_line_start_line" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4">接收线终止线号：</td>
   		<td class="inquire_form4"><input name="receiving_line_end_line" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">炮线起始点号：</td>
  		<td class="inquire_form4"><input name="shot_line_start_loc" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4">炮线终止点号：</td>
   		<td class="inquire_form4"><input name="shot_line_end_loc" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">炮线起始线号：</td>
  		<td class="inquire_form4"><input name="shot_line_start_line" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4">炮线终止线号：</td>
   		<td class="inquire_form4"><input name="shot_line_end_line" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">炮排数：</td>
  		<td class="inquire_form4"><input name="shot_array_num" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4"><font color="red">*</font>&nbsp;单束线设计炮数：</td>
   		<td class="inquire_form4"><input name="group_design_shot_num" type="text" value="" class="input_width" /></td>
  	</tr>
  	
  	<tr>
   		<td class="inquire_item4">接收线数：</td>
  		<td class="inquire_form4"><input name="receiving_line_num" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4"><font color="red">*</font>&nbsp;总检波点数：</td>
   		<td class="inquire_form4"><input name="geophone_point" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">炮点面积(km&sup2)：</td>
  		<td class="inquire_form4"><input name="shot_area" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4"><font color="red">*</font>&nbsp;施工面积(km&sup2)：</td>
   		<td class="inquire_form4"><input name="construction_area" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">炮密度：</td>
  		<td class="inquire_form4"><input name="shot_density" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4"><font color="red">*</font>&nbsp;设计总炮数：</td>
   		<td class="inquire_form4"><input name="design_sp_num" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">道距(m)：</td>
  		<td class="inquire_form4"><input name="trace_interval" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4">覆盖次数：</td>
   		<td class="inquire_form4"><input name="fold" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4"><font color="red">*</font>&nbsp;设计满覆盖工作量(km&sup2)：</td>
  		<td class="inquire_form4"><input name="actual_fullfold_area" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4"><font color="red">*</font>&nbsp;线束表层设计点数：</td>
   		<td class="inquire_form4"><input name="design_surface_3d_sp_num" type="text" value="" class="input_width" /></td>
  	</tr>
  	<tr>
   		<td class="inquire_item4">总物理点数：</td>
  		<td class="inquire_form4"><input name="total_point_num" type="text" value="" class="input_width" /></td>
   		<td class="inquire_item4"></td>
   		<td class="inquire_form4"></td>
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