<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	if(resultMsg!=null){
		message = resultMsg.getValue("message");
	}
	if(message==null){
		message = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			    <td>&nbsp;<a href="<%=contextPath%>/qua/sProject/quaFile/equipment.xls"><font color="red">导入模板下载</font></a>&nbsp;&nbsp;</td>
			    <auth:ListButton functionId="F_QUA_FILE_002" css="tj" event="onclick='importExcel()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
		</table>
		<form action="<%=contextPath %>/qua/equipment/excelImport.srq" id="form1" name="form1" method="post" enctype="multipart/form-data" >
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
				    <td class="inquire_item4">请选择导入文件:</td>
				    <td class="inquire_form4" colspan="3"><input type="file" name="import_file" id="import_file" value="" class="input_width" />
				    <input type="hidden" id="file_name" name="file_name" value=""/></td>
				</tr>
			</table>
		</form>
	</div>
</div>
<script type="text/javascript">
	var checked = false;
	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
</script>
<script type="text/javascript">
	
	function page_init(){
		var message = '<%=message%>';
		if(message!=null && message =='导入成功!'){
			alert('导入成功!');
			parent.refreshData();
		}else if(message !=null && message!='' && message !='导入成功!'){
			alert('<%=message%>');
		}
	}
	page_init();
	function importExcel(){
		var file = document.getElementById("import_file").value;
		if(file==null || file==''){
			alert("请选择文件!");
			return;
		}
		document.getElementById("form1").submit();
	}
</script>
</body>
</html>