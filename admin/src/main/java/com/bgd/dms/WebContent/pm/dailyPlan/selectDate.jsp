<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();
	response.setHeader("Pragma","No-cache"); 
	response.setHeader("Cache-Control","no-cache"); 
	response.setDateHeader("Expires", 0);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup-new.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

<script language="javaScript">

function cancel(){
	newClose();
}

function save(){
	//debugger;
	var start_date = document.getElementById("start_date").value;
	if(start_date == null || start_date == ""){
		alert("开始日期不能为空！");
		return;
	}
	var end_date = document.getElementById("end_date").value;
	if(end_date == null || end_date == ""){
		alert("结束日期不能为空！");
		return;
	}
	top.dialogCallback('getMessage',[start_date, end_date]);
	cancel();
}


</script>
</head>
<body style="background:#fff;overflow: scroll;">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
    <tr class="even">
    	<td class="rtCRUFdName">开始日期：</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="start_date" id="start_date" />
      	<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(start_date,tributton1);" />&nbsp;&nbsp;
      	</td>
      	<td class="rtCRUFdName">结束日期：</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="end_date" id="end_date" />
      	<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(end_date,tributton2);" />&nbsp;&nbsp;
      	</td>
    </tr>
</table>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">
  <tr class="odd">
    <td colspan="4" align="center" >
    	<span class="bc_btn"><a href="#" onclick="save()"></a></span>
    	<span class="gb_btn"><a href="#" onclick="cancel()"></a></span>
    </td>
  </tr> 
</table>

</body>
</html>
