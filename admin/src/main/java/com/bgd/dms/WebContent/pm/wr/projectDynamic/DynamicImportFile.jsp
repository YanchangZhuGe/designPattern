<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String project_type = request.getParameter("project_type");
	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	String org_subjection_id = request.getParameter("org_subjection_id");
	String action = request.getParameter("action");
	String message = "";
	if(respMsg != null){
		message = respMsg.getValue("message");
	}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
 
		if(filename == ""){
			alert("请选择上传附件!");
			return;
		}

		if(check(filename)){
			document.getElementById("confirmButton").disabled="disabled";	
			document.getElementById("fileForm").submit();
		}
			
	}
	function alertError(str){		
		alert(str);
	}

	function returnBack(){
	 var aa='<%=project_type%>';
	 if(aa=='1'){
		 window.parent.getTab(7)
	 }else if (aa=='3'){
		 window.parent.getTab(9)
	 }
	}
	function check(filename){
		var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
		type=type.toUpperCase();
		if(type=="XLS" || type=="XLSX"){
		   return true;
		}
		else{
		   alert("上传类型有误，请上传EXCLE文件！");
		   return false;
		}
	}
	
</script>
<title>选择要导入的文件</title>
</head>
<body>
<form action="<%=contextPath%>/pm/wr/importExcelTemplateTest.srq" id="fileForm" method="post" enctype="multipart/form-data">
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="even">
		<td class="rtCRUFdName">选择文件：</td>
		<td class="rtCRUFdValue">
		<input type="file"  id="fileName" name="fileName" class="input_width">
		<input type="hidden"  value="<%=week_date%>" id="ww" name="ww" class="input_width">
		<input type="hidden"  value="<%=project_type%>" id="project_type" name="project_type" class="input_width">
		<input type="hidden"  value="<%=org_id%>" id="org_id" name="org_id" class="input_width">
		<input type="hidden"  value="<%=action%>" id="action" name="action" class="input_width">
		<input type="hidden"  value="<%=org_subjection_id%>" id="org_subjection_id" name="org_subjection_id" class="input_width">
		<input type="hidden"  value="<%=week_end_date%>" id="week_end_date" name="week_end_date" class="input_width">
		</td>
	</tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		<td>
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="uploadFile()" value="确定" />
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="returnBack()" value="取消" /></td>
	</tr>
</table>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
</html>