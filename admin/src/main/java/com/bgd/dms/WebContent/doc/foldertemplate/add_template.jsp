<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath(); 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上传文档</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body>
<form name="form1" id="form1" method="post" action="<%=contextPath%>/doc/addTemplate.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	
  	<tr>
    	<td colspan="4" align="center">新增文档结构模板</td>
    </tr>
    <tr>
    	<td class="inquire_item4">模板名称：</td>
      	<td class="inquire_form4"><input type="text" name="template_name" id="template_name" class="input_width" /></td>
     	<td class="inquire_item4" >模板类型：</td>
      	<td class="inquire_form4"> 
        <select id="is_template" name="is_template"  class="select_width"> 
					 <option value="2">井中</option>
					 <option value="1">采集</option>

         </td>
    </tr> 
      <tr> 
     	<td class="inquire_item4"  >  模板缩写：</td>
      	<td class="inquire_form4"  > <input type="text" name="template_abbr" id="template_abbr" class="input_width" /></td>
    </tr>

</table>
</div>
    <div id="oper_div">
    	<auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>        
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

	cruConfig.contextPath = "<%=contextPath%>";
	
	function refreshData(){
		if (!isTextPropertyNotNull("template_name", "模板名称")) {		
			document.form1.template_name.focus();
			return false;	
		}
		
		if (!isTextPropertyNotNull("template_abbr", "模板缩写")) {		
			document.form1.template_abbr.focus();
			return false;	
		}
		
		var template_abbr = document.getElementById("template_abbr").value;
		var is_template = document.getElementById("is_template").value;
		var result = jcdpCallService('ucmSrv','checkTemplateName','templateName='+template_abbr+'&isTemplate'+is_template); 
		if(result.isexist == 1){ 
			  alert("该缩写已存在,不能重复!"); 
			  return false; 
		} 
		document.getElementById("form1").submit();
	}
</script>
</html>