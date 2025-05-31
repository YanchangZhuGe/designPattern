<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath(); 
	String template_id = request.getParameter("id") != null ? request.getParameter("id"):"";
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
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body onload="getTemplateInfo1()">
<form name="form1" id="form1" method="post" action="<%=contextPath%>/doc/editTemplateInfo.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	
  	<tr>
    	<td colspan="4" align="center">新增文档结构模板
    	<input type="hidden" name="template_id" id="template_id" value="<%=template_id%>"/>
    	</td>
    </tr>
    <tr>
    	<td class="inquire_item4">模板名称：</td>
      	<td class="inquire_form4"> 
      		<input id="template_name" type="text"  name="template_name"  class="input_width"/> 
      	</td>
     	 	<td class="inquire_item4" >模板类型：</td>
      	<td class="inquire_form4"> 
        <select id="is_template"   class="select_width"> 
					 <option value="1">采集</option>
					 <option value="2">井中</option>

         </td> 
    </tr> 
   <tr> 
     	<td class="inquire_item4">模板缩写：</td>
      	<td class="inquire_form4"><input  id="template_abbr"  disabled="disabled"  type="text" name="template_abbr"      class="input_width"  /></td>
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
	cruConfig.contextPath =  "<%=contextPath%>";
	
	
	
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("template_name", "文档编号")) {		
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}		
	
	function refreshData(){
		document.getElementById("form1").submit();
	}
	
	function getTemplateInfo1(){
		var template_id = "<%=template_id%>"; 
		var retObj = jcdpCallService("ucmSrv", "getTemplateInfo", "templateID="+template_id);
		//document.all.objSelect.value = retObj.docInfoMap.is_template;
		document.getElementById("template_name").value= retObj.docInfoMap.template_name;	
		document.getElementById("template_abbr").value= retObj.docInfoMap.template_abbr;

		var is_templates = document.getElementById("is_template");
		for(var i=0;i<is_templates.options.length;i++){
		    if(retObj.docInfoMap.is_template==is_templates.options[i].value)
		    {
			  is_templates.options[i].selected = true;
		      return;
		    }
		  }
	}
</script>
</html>