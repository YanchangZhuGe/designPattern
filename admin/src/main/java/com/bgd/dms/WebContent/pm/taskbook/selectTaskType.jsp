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
		//top.frames('list').refreshData(s_filter);
		newClose();
	}
</script>
<title>选择任务书类型</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">任务书类型:</td>
          <td class="inquire_form4"><select id="task_type" name="taskType"></select></td>
          <td class="inquire_item4">结束号:</td>
          <td class="inquire_form4"><input id="task_end_num"  name="taskEndNum" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">任务书模板:</td>
          <td class="inquire_form4"><select id="task_template" name="taskTemplate"></select></td>
          <td class="inquire_item4"></td>
          <td class="inquire_form4"></td>
        </tr>
      </table>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="refreshData()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newclose()"></a></span>
    </div>
  </div>
</div>
</body>
</html>

