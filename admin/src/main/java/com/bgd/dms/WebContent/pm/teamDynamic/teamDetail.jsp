<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>队伍信息</title>
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
function loadData()
{
	
}

</script>

<link href="table.css" rel="stylesheet" type="text/css" />
</head>

<body onload="loadData()">
<form id="CheckForm" name="form1" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
    <td class="inquire_item4">队伍名称：</td>
    <td class="inquire_form4"><input name="org_name" type="text" class="input_width" /></td>
    <td class="inquire_item4">队伍简称：</td>
    <td class="inquire_form4"><input name="org_abbreviation" type="text" class="input_width" /></td>
  </tr>
  <tr>
    <td class="inquire_item4">队伍统一编号：</td>
    <td class="inquire_form4"><input name="team_id" type="text" class="input_width" /></td>
    <td class="inquire_item4">队伍类型：</td>
    <td class="inquire_form4"><input name="team_specialty" type="text" class="input_width"/></td>
  </tr>
  <tr>
  	<td class="inquire_item4">队经理：</td>
    <td class="inquire_form4"><input name="header" type="text" class="input_width"/></td>
	<td class="inquire_item4">基地：</td>
	<td class="inquire_form4"><input name="team_base" type="text" value="" class="input_width" /></td>
  </tr>
  <tr>
    <td class="inquire_item4">组建时间：</td>
    <td class="inquire_form4"><input name="comp_date" type="text" class="input_width"/></td>
     <td class="inquire_item4">是否重点队：</td>
	 <td class="inquire_form4"><input name="if_majorteam" type="text" class="input_width"/></td>
  </tr>
  <tr>
   	<td class="inquire_item4">是否在册：</td>
   	<td class="inquire_form4"><input name="if_registered" type="text" class="input_width"/></td>
 
  	<td class="inquire_item4">当前状态：</td>
   	<td class="inquire_form4"><input name="cur_state" type="text" class="input_width"/></td> 
  </tr>
  <tr> 
    <td class="inquire_item4">当前工作位置：</td>
	<td class="inquire_form4"><input name="curr_position" type="text" value=""class="input_width" />
	</td>
    <td class="inquire_item4">显示序号：</td>
   	<td class="inquire_form4"><input name="coding_show_id" type="text" value=""class="input_width" />
   	</td>
  </tr>
    <tr>
    <td class="inquire_item4">电子邮箱：</td>
    <td class="inquire_form4"><input name="email" type="text" value="" class="input_width" /></td>
    <td class="inquire_item4">联系电话：</td>
    <td class="inquire_form4"><input name="phone_num" type="text" value="" class="input_width" /></td>
  </tr>
  <tr>
    <td class="inquire_item4">通讯地址：</td>
    <td class="inquire_form4"><input name="post_address" type="text" class="input_width" /></td>
    <td class="inquire_item4">邮政编码：</td>
    <td class="inquire_form4"><input name="post_code" type="text" class="input_width" /></td>
  </tr>
   <tr>
    <td class="inquire_item4">队伍描述：</td>
    <td class="inquire_form4" colspan="3"><textarea name="org_desc" class="textarea" ></textarea></td>    
  </tr>
</table>
  </div>
  <div id="oper_div">
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
</body>
</html>