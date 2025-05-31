<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String path = request.getParameter("path");
	String message = "";
	String import_function = request.getParameter("import_function");
	if(resultMsg!=null){
		message = resultMsg.getValue("message");
		if(message==null){
			message = "";
		}
		if(import_function==null){
			import_function = resultMsg.getValue("import_function");
		}
		if(import_function==null){
			import_function = "";
		}
	}
	if(path==null || path.trim().equals("")){
		message = "导入失败!";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head> 
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
 </head> 
 <body> 
 <form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" action="<%=contextPath%><%=path%>?import_function=<%=import_function%>">
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		<tr>
		    <td class="inquire_item4"><font color="red">*</font>选择上传的文件:</td>
		    <td class="inquire_form4" colspan="3"><input type="file" name="excel_file" id="excel_file" value="" class="input_width" /></td>
		</tr>
	</table>
  </div> 
  <div id="oper_div">
	<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
 	<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
  </div> 
  </div>
</form> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var form = document.getElementById("fileForm").submit();
	}
	function checkValue(){
		var obj = document.getElementById("excel_file");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("请选择上传的文档!");
			return false;
		}else{
			var type = value.substr(value.indexOf(".")-(-1));
			if(type!='xls' && type!='xlsx'){
				alert("上传的文档格式不正确!");
				return false;
			}else{
				return true;
			}
		}
	}
	var message = '<%=message%>';
	if(message=='导入成功!'){
		alert(message);
		top.frames['list'].refreshData();
		newClose();
	}else if(message !=''){
		alert(message);
	}
</script>
</body>
</html>