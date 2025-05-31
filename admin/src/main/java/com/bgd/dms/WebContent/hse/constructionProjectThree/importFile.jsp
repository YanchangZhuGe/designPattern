<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	if(respMsg != null){
		message = respMsg.getValue("message");
	}
	String projectId ="";
	if(respMsg != null){
		projectId = respMsg.getValue("project");
	}else{
		projectId = request.getParameter("project");
	}
	
	String project_three_ids = "";
	if(respMsg != null){
		project_three_ids = respMsg.getValue("project_three_ids");
	}else{
		project_three_ids = request.getParameter("project_three_ids");
	}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"> 
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
var message = "<%=message%>";
if(message != "" && message != 'null'){
	if(message=="����ɹ�!"){ 
		alert(message);
		top.frames('list').refreshData();	
		newClose();
	}else{
		alert(message);		
	}
	
}
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
 
		if(filename == ""){
			alert("��ѡ���ϴ�����!");
			return;
		}

		var project="<%=projectId%>";
		if(check(filename)){
			document.getElementById("confirmButton").disabled="disabled";	
			document.getElementById("fileForm").action = "<%=contextPath%>/hse/importExcelSpecialDev.srq?project="+project;
			document.getElementById("fileForm").submit();
		}
			
	}
	function alertError(str){		
		alert(str);
	}

	function check(filename){
		var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
		type=type.toUpperCase();
		if(type=="XLS" || type=="XLSX"){
		   return true;
		}
		else{
		   alert("�ϴ������������ϴ�EXCLE�ļ���");
		   return false;
		}
	}
	
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanLabor/download.jsp?path=/hse/constructionProjectThree/"+modelname+".xlsx&filename="+filename+".xlsx";
	}	
	
</script>
<title>ѡ��Ҫ������ļ�</title>
</head>
<body>
<form action="<%=contextPath%>/hse/constructionProjectThree/importFile_t.jsp" id="fileForm" method="post" enctype="multipart/form-data" target="targetIframe">
<input type="hidden" id="project_three_ids" name="project_three_ids" value="<%=project_three_ids %>"/>
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="even">
		<td class="rtCRUFdName">ѡ���ļ���</td>
		<td class="rtCRUFdValue">
		<input type="file"  id="fileName" name="fileName" class="input_width">
		</td>
	</tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		<td>
		<a href="javascript:downloadModel('model','�����豸ģ��')"><font color=red>���ص���ģ��</font></a>
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="uploadFile()" value="ȷ��" />
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="newClose()" value="�ر�" />
		&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
</table>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
</html>