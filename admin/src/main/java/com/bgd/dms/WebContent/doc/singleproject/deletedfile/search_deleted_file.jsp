<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" media="all" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script language="javaScript">
	function refreshData(){
		var ctt = top.frames['list'].frames[1];
		var file_name = document.getElementsByName("file_name")[0].value;
		var doc_type = document.getElementsByName("doc_type")[0].value;
		var doc_keyword = document.getElementsByName("doc_keyword")[0].value;
		var doc_importance = document.getElementsByName("doc_importance")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;		
		ctt.refreshData(undefined, file_name,doc_type,doc_keyword,doc_importance,create_date);
		newClose();
	}
	//refreshData();
	//newClose();
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">文档名称:</td>
          <td class="inquire_form4"><input name="file_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">文档类型:</td>
          <td class="inquire_form4">
            <select name="doc_type" class="select_width">
	      		<option value="">-请选择-</option>
	      		<option value="word">word</option>
	      		<option value="excel">excel</option>
	      		<option value="ppt">PowerPoint</option>
	      		<option value="pdf">PDF</option>
	      		<option value="txt">TXT</option>
	      		<option value="picture">图片文件</option>
	      		<option value="compress">压缩文件</option>
	      		<option value="other">其他文件</option>
	      	</select>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">关键字:</td>
          <td class="inquire_form4"><input name="doc_keyword" class="input_width" type="text" /></td>
          <td class="inquire_item4">重要程度:</td>
          <td class="inquire_form4">
 	      	<select name="doc_importance" class="select_width">
	      		<option value="">-请选择-</option>
	      		<option value="1">高</option>
	      		<option value="2">中</option>
	      		<option value="3">低</option>
	      	</select>         
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">上传时间:</td>
          <td class="inquire_form4"><input name="create_date" class="input_width" type="text" readonly="readonly"/>&nbsp;&nbsp;
          <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(create_date,tributton1);" />
          </td>
          <td class="inquire_item4">&nbsp;</td>
          <td class="inquire_form4">&nbsp;</td>
        </tr>
      </table>
     
    </div>
    <div id="oper_div">
    	<auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>
    </div>
  </div>
</div>
</body>

</html>

