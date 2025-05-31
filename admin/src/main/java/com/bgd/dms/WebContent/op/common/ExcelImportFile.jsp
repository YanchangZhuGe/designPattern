<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String redirectUrl=request.getParameter("redirectUrl");
	if(resultMsg!=null&&resultMsg.getValue(redirectUrl)!=null&&!"".equals(resultMsg.getValue(redirectUrl))){
		redirectUrl=resultMsg.getValue(redirectUrl);
	}
	if(redirectUrl==null||"".equals(redirectUrl)){
		redirectUrl="/op/common/ExcelImportFile.jsp";
	}
	if(resultMsg!=null){
		String errorMessage = resultMsg.getValue("errorMessage");
		if (errorMessage == null){
			response.sendRedirect(contextPath+redirectUrl);
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">    
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">    
<META HTTP-EQUIV="Expires" CONTENT="0">  
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
function import_device(){
	var form = document.getElementById("fileForm");
	form.action = "<%=contextPath%>/op/OpCostSrv/importDeviceInfoForCost.srq?redirectUrl=<%=redirectUrl%>";
	form.submit();
}
function back(){
	window.location="<%=contextPath+redirectUrl%>";
}
</script>
<title>选择要导入的序列号文件</title>
</head>
<body>
<form action="<%=contextPath%>/op/OpCostSrv/importDeviceInfoForCost.srq?redirectUrl=<%=redirectUrl%>" id="fileForm" method="post" enctype="multipart/form-data">
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="odd">
		<td colspan="2">
		<%
		if(resultMsg!=null){
			String errorMessage = resultMsg.getValue("errorMessage");
			if (errorMessage != null && !errorMessage.trim().equals("")){
				out.println("<font color='red' size='4'>" + errorMessage + "</font>");
			}else{
				out.println("<font color='red' size='4'>" + "请上传导入模板文件" + "</font>");
			}
		}else{
			out.println("<font color='red' size='4'>" + "请上传导入模板文件" + "</font>");
		}
		%></td>
	</tr>
	<tr class="even">
		<td class="rtCRUFdName">选择文件：</td>
		<td class="rtCRUFdValue"><input type="file"  id="file" name="fileName"  class="input_width">
	</tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		<td>
		<input name="Submit" type="button" class="iButton2" id="confirmButton" onclick="import_device()"   value="确定" />
		<input name="Submit" type="button" class="iButton2" id="confirmButton" onclick="back()"   value="返回" />
		</td>
	</tr>
</table>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
</html>