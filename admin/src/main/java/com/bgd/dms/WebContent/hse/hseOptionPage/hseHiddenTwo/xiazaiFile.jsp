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
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
 
	function uploadFile(allValue){		

		var project='<%=request.getParameter("project")%>';
	 
		var check_date = document.getElementById("check_date").value;
		var check_dateA = document.getElementById("check_date2").value; 
		if(allValue =="1"){
	        if (check_date  ==""  || check_dateA ==""){
	        	alert("上报日期不能为空!");
	        	return;
	        }
        }
        //1,过滤信息 2, 全部信息
		window.open("<%=contextPath%>/hse/hseHidden/exportHseHidden.srq?project="+project+"&check_date="+check_date+"&check_date_a="+check_dateA+"&all_value="+allValue);
		
		 
	}
	 
</script>
<title>选择要导入的文件</title>
</head>
<body>
<form action="" id="fileForm" method="post" enctype="multipart/form-data">
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	 <tr>
          <td class="rtCRUFdName">上报日期：</td>
		  <td class="rtCRUFdValue"><input type="text" id="check_date" name="check_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date,tributton1);" />&nbsp;</td>
		  <td class="rtCRUFdName">至</td>
		  <td class="inquire_form6"><input type="text" id="check_date2" name="check_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date2,tributton2);" />&nbsp;</td>
         </tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		<td>
		<a href="javascript:uploadFile('2')"><font color=red>下载全部信息</font></a>
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="uploadFile('1')" value="确定" />
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="newClose()" value="关闭" />
		&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
</table>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
</html>