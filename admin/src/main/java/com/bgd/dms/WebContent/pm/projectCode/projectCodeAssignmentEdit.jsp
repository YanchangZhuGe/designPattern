<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
    String relationId = request.getParameter("relationId").toString();
    String owner = request.getParameter("owner").toString();
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增分类码</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body>
<form name="form1" id="form1"  method="post" action="<%=contextPath%>/pm/projectCode/saveProjectCodeAssignment.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
  	<tr>		
    	<td colspan="4" align="center">上传文档</td>
    </tr>
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>文档编号：</td>
      	<td class="inquire_form4">
      	<input type="hidden" name="relation_id" value="<%=relationId%>"/>
      	<input type="text" name="doc_number" class="input_width" />
      	</td>
      	<td class="inquire_item4">选择目录：</td>
      	<td class="inquire_form4">
      		<input type="text" name="select_folder" class="input_width" readonly="readonly"/>
      		<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectFolder()" />	
      		<input type="hidden" name="folder_id"/>
      	</td>
    </tr>
    <tr>
    	<td class="inquire_item4">文档名称：</td>
      	<td class="inquire_form4"><input type="text" name="doc_name" class="input_width"/></td>
     	<td class="inquire_item4">文件类型：</td>
      	<td class="inquire_form4">
      	     <select name="doc_type">
	      		<option value=" ">-请选择-</option>
	      		<option value="1">word</option>
	      		<option value="2">excel</option>
	      		<option value="3">ppt</option>
	      		<option value="4">pdf</option>
	      		<option value="5">txt</option>
	      	</select>
      	</td>
    </tr>    
   <tr>
        <td class="inquire_item4">关键字</td>
      	<td class="inquire_form4">
      		<input type="text" name="doc_keyword" class="input_width"/>
      	</td>
		<td class="inquire_item4">重要程度：</td>
      	<td class="inquire_form4">
	      	<select name="doc_importance">
	      		<option value=" ">-请选择-</option>
	      		<option value="1">高</option>
	      		<option value="2">中</option>
	      		<option value="3">低</option>
	      	</select>
      	</td>

    </tr> 
    <tr>
    	<td class="inquire_item4">摘要：</td>
      	<td class="inquire_form4"><input type="text" name="doc_brief" class="input_width"/></td>
		<td class="inquire_item4">是否模板：</td>
      	<td class="inquire_form4">
      	    <select name="doc_template">
	      		<option value=" ">-请选择-</option>
	      		<option value="1">是</option>
	      		<option value="0">否</option>
	      	</select>
      	</td>

    </tr>
    <tr>
     	<td class="inquire_item4">文档：</td>
      	<td class="inquire_form4"><input type="file" name="doc_content" /></td>
      	<td class="inquire_item4">分数</td>
      	<td class="inquire_form4">
      		<select name="doc_score">
	      		<option value=" ">-请选择-</option>
	      		<option value="10">10</option>
	      		<option value="20">20</option>
	      		<option value="30">30</option>
	      		<option value="40">40</option>
	      		<option value="50">50</option>
	      		<option value="60">60</option>
	      		<option value="70">70</option>
	      		<option value="80">80</option>
	      		<option value="90">90</option>
	      		<option value="100">100</option>
	      	</select>
      	</td>
    </tr>        

</table>
</div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="refreshData()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

	function cancel()
	{
		window.close();
	}
										
	function refreshData(){
		
		document.getElementById("form1").submit();
	}
	
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("doc_number", "文档编号")) {
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}
	
	function selectFolder(){

		var folder_info={
		        fkValue:"",
		        value:""
		    };
		window.showModalDialog('<%=contextPath%>/doc/common/select_folder.jsp?project_info_no=<%=root_folderId%>',folder_info);
		document.getElementsByName("select_folder")[0].value = folder_info.value;
		document.getElementsByName("folder_id")[0].value = folder_info.fkValue;
	}
</script>

</html>