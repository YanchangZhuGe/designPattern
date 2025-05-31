<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
	function refreshData(){
		var struct_unit_name = document.getElementsByName("struct_unit_name")[0].value;
		var struct_unit_level= document.getElementById("struct_unit_level").value;
		var s_filter = "";
		if(struct_unit_level!="0" && struct_unit_level!=""){
				s_filter = " a.struct_unit_level='"+struct_unit_level+"'";
		}
		if(struct_unit_name!=""){
			s_filter = s_filter + " and a.struct_unit_name like'%"+struct_unit_name+"%'";
		}
		top.frames('list').refreshData(s_filter);
		newClose();
	}
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">构造单元名称:</td>
          <td class="inquire_form4"><input name="struct_unit_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">构造单元级别:</td>
          <td class="inquire_form4"><select id="struct_unit_level" class="select_width">
          					 <option value="0">所有</option>
                             <option value="1">一级</option>
						     <option value="2">二级</option>
						     <option value="3">三级</option>
						     <option value="4">四级</option>
                        </select></td>
        </tr>
      </table>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="refreshData()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>

</html>

