<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%
	String contextPath = request.getContextPath();
	System.out.println("--------->"+request.getInputStream().toString());
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />

<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/rm/em/humanRequest/DivHiddenOpen.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
	var content="";
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
		if(filename !=""){
			if(check(filename)){
				document.getElementById("confirmButton").disabled="disabled";			
				document.getElementById("fileForm").submit();
			}
		}	
	}
	function alertError(str){
		
		alert(str);
	}
	function returnFile(){
		var returncheck = "";
		if(content != ""){
			content = encodeURI(content);
			content = encodeURI(content);
			var str = "checked="+content;

			var humanList = jcdpCallService("HumanCommInfoSrv","queryImportCertList",str);		

			if(humanList.str!=null){
				alert(humanList.str);
				return;
			}
			if(humanList.newstr!=null){
				returncheck = humanList.newstr;	
			}
		}
	
		window.returnValue = returncheck;
		window.close();
	}
	function returnNull(){
		window.returnValue = "";
		window.close();
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
<form action="<%=contextPath%>/rm/em/commCertificate/certImportFile_t.jsp" id="fileForm" method="post" enctype="multipart/form-data" target="targetIframe">
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="even">
		<td class="rtCRUFdName">选择文件：</td>
		<td class="rtCRUFdValue"><input type="file"  id="fileName" name="fileName" onChange="uploadFile()" class="input_width">
	</tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		<td>
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="returnFile()" value="确定" />
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="returnNull()" value="取消" /></td>
	</tr>
</table>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
</html>