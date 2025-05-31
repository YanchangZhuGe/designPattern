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
		projectId = request.getParameter("project");
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

<title>ѡ��Ҫ������ļ�</title>
</head>
<body>
<form action="" id="fileForm" method="post" enctype="multipart/form-data">
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="even">
		<td class="rtCRUFdName">ѡ���ļ���</td>
		<td class="rtCRUFdValue">
		<input type="file"  id="fileName" name="fileName" class="input_width">
		</td>
	</tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr  >
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td align="right"> 	 
	<div id="div1" name="div1" style="display:none;" ><a href="javascript:downloadModelA('ImpleHseTrainer','HSE��ѵʦ��Ϣ')"><font color=red>HSE��ѵʦ��Ϣģ��</font></a></div>
	<div id="div2" name="div2" style="display:none;" ><a href="javascript:downloadModelB('ImpleHseAuditer','HSE����Ա��Ϣ')"><font color=red>HSE����Ա��Ϣģ��</font></a></div>
	<div id="div3" name="div3" style="display:none;" ><a href="javascript:downloadModelC('ImpleHseChecker','ע��HSE���Ա')"><font color=red>ע��HSE���Ա��Ϣģ��</font></a></div>
	<div id="div4" name="div4" style="display:none;" ><a href="javascript:downloadModelD('ImpleHseResoure','ע�ᰲȫ����ʦ')"><font color=red>ע�ᰲȫ����ʦ��Ϣģ��</font></a></div>
	 </td>
		<td align="left">
		&nbsp;&nbsp;		&nbsp;&nbsp;&nbsp;&nbsp;
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="uploadFile()" value="ȷ��" />
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="newClose()" value="�ر�" />

		</td>
	</tr>
</table>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
var message = "<%=message%>";
var addType='<%=request.getParameter("addType")%>';

if(message != "" && message != 'null'){
	if(message=="����ɹ�!"){ 
		alert(message);
		top.frames('list').frames[1].refreshData();
		newClose();
	}else{
		alert(message);		
	}
	
}


if(addType !="" && addType !='null'){
	if(addType =="1"){
 
		 document.getElementById('div1').style.display='block'; 
	}
	if(addType =="2"){
		 document.getElementById('div2').style.display='block'; 
	}
	if(addType =="3"){
		 document.getElementById('div3').style.display='block'; 
	}
	if(addType =="4"){
		 document.getElementById('div4').style.display='block'; 
	}
	
	
}


	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
 
		if(filename == ""){
			alert("��ѡ���ϴ�����!");
			return;
		}

		var project='<%=request.getParameter("project")%>';
		if(check(filename)){
			document.getElementById("confirmButton").disabled="disabled";	
			if(addType !="" && addType !='null'){
				if(addType =="1"){
					document.getElementById("fileForm").action = "<%=contextPath%>/hse/professional/importExcelTrainerList.srq?project="+project+"&addType="+addType;
				}
				if(addType =="2"){
					document.getElementById("fileForm").action = "<%=contextPath%>/hse/professional/importExcelTrainer2.srq?project="+project+"&addType="+addType;
				}
				if(addType =="3"){
					document.getElementById("fileForm").action = "<%=contextPath%>/hse/professional/importExcelTrainer3.srq?project="+project+"&addType="+addType;
				}
				if(addType =="4"){
					document.getElementById("fileForm").action = "<%=contextPath%>/hse/professional/importExcelTrainer4.srq?project="+project+"&addType="+addType;
				}
				
				
			} 
		
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

	function downloadModelA(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanLabor/download.jsp?path=/hse/techAndResource/hseTrainer/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	function downloadModelB(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanLabor/download.jsp?path=/hse/techAndResource/hseAuditor/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
 
	function downloadModelC(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanLabor/download.jsp?path=/hse/techAndResource/hseChecker/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	function downloadModelD(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanLabor/download.jsp?path=/hse/techAndResource/hseEngineer/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	
	
	
</script>
</html>