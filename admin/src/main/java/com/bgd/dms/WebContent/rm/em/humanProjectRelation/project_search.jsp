<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
	function refreshData(){
		var ctt = top.frames('list').frames[1];
		var file_name = document.getElementsByName("file_name")[0].value;
		ctt.refreshData(undefined, file_name);
		newClose();
	}
	//refreshData();
	//newClose();
</script>
<title>查询条件</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      <tr>
	      <td class="inquire_item4">班组:</td>
	      <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
	      <td class="inquire_item4">岗位:</td>
	      <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
	    </tr>
        <tr>
          <td class="inquire_item4">项目名称:</td>
          <td class="inquire_form4"><input name="file_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">审核状态:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>

        
      </table>
     
    </div>
    <div ic="oper_div">
     	<span class="tj"><a href="#" onclick="refreshData()"></a></span>
        <span class="gb"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>
<script type="text/javascript">

</script>

</html>

