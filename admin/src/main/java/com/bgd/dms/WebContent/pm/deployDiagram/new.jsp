<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
    String contextPath = request.getContextPath();
    String projectInfoNo = request.getParameter("projectInfoNo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新增部署图</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script>
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

var projectInfoNo = "<%=projectInfoNo%>";
	
function forward()
{
	//window.location.href="index.html"
}
</script>
<script type="text/javascript">

function checkForm() {
	return true;
}
	
function toSave(){
	var deployName = document.getElementById("deploy_name").value;
	var image_content = document.getElementById("image_content").value;
	if(deployName == "" || deployName =="undefined"){
		alert("请输入部署图名称!");
		return;
	}
	if(image_content == "" || image_content =="undefined"){
		alert("请选择部署图文件!");
		return;
	}
	var form = document.forms[0];
	form.action="<%=contextPath%>/pm/deployDiagram.srq";
	form.submit();
}

function cancle(){
}

</script>
<link href="table.css" rel="stylesheet" type="text/css" />
</head>

<body>
<form id="CheckForm" name="form1" enctype="multipart/form-data" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   	<td class="inquire_item4"><font color="red">*</font>&nbsp;名称：</td>
   	<td class="inquire_form4" colspan="3"><input type="text" name="deploy_name" id="deploy_name" size="47"/>
   		<input type="hidden" name="project_info_no" id="project_info_no" value="<%=projectInfoNo%>"/></td>
   	</td>
  	</tr>
  <tr>
     <td class="inquire_item4">部署图：</td>
     <td class="inquire_form4" colspan="3">
     	<input type="file" name="image_content" id="image_content" onchange="getFileInfo()" class="input_width"/>
     </td>
  </tr>
</table>
  </div>
  <div id="oper_div">
   	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
</body>
</html>