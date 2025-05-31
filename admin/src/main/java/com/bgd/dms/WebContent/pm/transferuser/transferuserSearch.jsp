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
		var trans_user_name = document.getElementById("trans_user_name").value;
		var trans_user_prj = document.getElementById("trans_user_prj").value;
		var trans_user_org = document.getElementById("trans_user_org").value;
		
		var s_filter = "";
		if(trans_user_name!=""){
			s_filter = " and t.trans_user_name like'%"+trans_user_name+"%'";
		}
		if(trans_user_prj!=""){
			s_filter = s_filter + " and t.prj_name like'%"+trans_user_prj+"%'";
		}
		if(trans_user_org!=""){
			s_filter = s_filter + " and t.org_name like'%"+trans_user_org+"%'";
		}
		if(s_filter.length >4){
			s_filter = s_filter.substr(4);
		}
		top.frames('list').refreshData(s_filter);
		newClose();
	}
</script>
<title>传输用户查询</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">用户名:</td>
          <td class="inquire_form4"><input id="trans_user_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">项目:</td>
          <td class="inquire_form4"><input id="trans_user_prj" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">队伍:</td>
          <td class="inquire_form4"><input id="trans_user_org" class="input_width" type="text" /></td>
          <td class="inquire_item4"></td>
          <td class="inquire_form4"></td>
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

