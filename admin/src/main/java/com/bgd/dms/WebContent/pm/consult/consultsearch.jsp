<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script language="javaScript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function refreshData(){
		var reportName = document.getElementsByName("report_name")[0].value;
		var createDate= document.getElementById("create_date").value;
		var submitFlag= document.getElementById("submit_flag").value;
		
		var s_filter = "";
		if(reportName!=""){
				s_filter = " and report_name like'%"+reportName+"%'";
		}
		if(createDate!=""){
			s_filter = s_filter + " and to_char(create_date,'yyyy-MM-dd')='"+createDate+"'";
		}
		if(submitFlag!=""){
			s_filter = s_filter + " and submit_flag ='"+submitFlag+"'";
		}
				
		if(s_filter.length > 0){
			s_filter = s_filter.substr(4);
		}
		top.frames('list').refreshData(s_filter);
		newClose();
	}
</script>
<title>请示报告搜索</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">报告名称:</td>
          <td class="inquire_form4"><input id="report_name" name="report_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">创建日期:</td>
          <td class="inquire_form4"><input id="create_date" name="create_date" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">提交:</td>
          <td class="inquire_form4">
          <select id="submit_flag" class="select_width">
          	<option value="">所有</option>
          	<option value="0">否</option>
          	<option value="1">是</option>
          </select></td>
          <td class="inquire_item4">审批状态:</td>
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