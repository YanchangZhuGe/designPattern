<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.bgp.mcs.service.common.CodeSelectOptionsUtil"%>
<%@page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	String relation_id = request.getParameter("relationId").toString();
	String owner = request.getParameter("owner").toString();
	List list=CodeSelectOptionsUtil.getOptionByName("owner");
	String flag = "true";
	if (owner == null || "".equals(owner)){
		flag = "false";
		if (list != null && list.size() > 0) {
			Map mapCode = (Map) list.get(0);
			if (mapCode != null) {
				owner = (String) mapCode.get("value");
			}
		}
	}
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
		var ctt = top.frames('list').frames[1];
		var code_name = document.getElementsByName("code_name")[0].value;
		var code_type_name = document.getElementsByName("code_type_name")[0].value;
		ctt.frames("codeManager").refreshData(code_name,code_type_name);
		newClose();
	}
	//refreshData();
	//newClose();
</script>
<title>分类码查询</title>
</head>
<body>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">分类码名:</td>
          <td class="inquire_form4"><input name="code_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">分类码大类名:</td>
          <td class="inquire_form4"><input name="code_type_name" class="input_width" type="text" /></td>
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

