<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="auth" prefix="auth"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String costProjectSchemaId=request.getParameter("costProjectSchemaId");
	String projectInfoNo=request.getParameter("projectInfoNo");
%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript">
	cruConfig.contextPath = "<%= request.getContextPath()%>";
	
	function submit(){
		var fileName=document.getElementById("fileName").value;
		if(fileName==""){
			alert("请点击浏览上传文件");
		}else{
			var form = document.getElementById("fileForm");
			form.action = "<%=contextPath%>/op/OpCostSrv/saveProjectCostByExcel.srq?projectInfoNo=<%=projectInfoNo%>&costProjectSchemaId=<%=costProjectSchemaId%>";
			form.submit();
		}
	}
</script>
<title>导入excel</title>
</head>
<body  style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box">
	<form action="<%=contextPath%>/op/OpCostSrv/saveProjectCostByExcel.srq?projectInfoNo=<%=projectInfoNo%>&costProjectSchemaId=<%=costProjectSchemaId%>" id="fileForm" method="post" enctype="multipart/form-data">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png">
	    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton css="tj" event="onclick='submit()'" title="JCDP_btn_submit"></auth:ListButton>
				<auth:ListButton css="gb" event="onclick='newClose()'" title="JCDP_btn_close"></auth:ListButton>
			  </tr>
			</table>
		</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
	</table>
	</div>
	<div id="table_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="inquire_item4">文件</td>
				<td class="inquire_form4" colspan="3">
					<input type="file" name="fileName" id="fileName" class="input_width"/>
				</td>
			</tr>
		</table>
	</div>
	</form>
</body>
</html>