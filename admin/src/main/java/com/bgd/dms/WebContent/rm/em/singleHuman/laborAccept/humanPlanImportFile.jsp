<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%

	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String laborCategory = request.getParameter("laborCategory");
	String numSum = request.getParameter("numSum");
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
 
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
	var content="";
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
		if(filename == ""){
			alert("请选择上传附件!");
			return;
		}

		if(check(filename)){	
			document.getElementById("fileForm").submit();
		}
		newClose();
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
<form action="<%=contextPath%>/rm/em/toSaveHumanLaborDeployExcle.srq" id="fileForm" method="post" enctype="multipart/form-data" target="list">
<table width="96%" border="0" cellspacing="0" cellpadding="0"  class="form_info" >
	<tr class="even">
		<td class="rtCRUFdName">选择文件：</td>
		<td class="rtCRUFdValue"><input type="file" id="fileName" name="fileName" class="input_width">
		<input type="hidden" id="laborCategory" name="laborCategory" value="<%=laborCategory%>" class="input_width">
		<input type="hidden" id="numSum" name="numSum" value="<%=numSum%>" class="input_width">
		</td>
	</tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
<tr align="right">
	<td>
	<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="uploadFile()" value="确定" />
	<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="newClose()" value="取消" /></td>
</tr>
</table>
 
</form>
</body>
</html>