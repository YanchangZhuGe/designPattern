<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String week_date = request.getParameter("week_date");
    String week_end_date = request.getParameter("week_end_date");
    String record_id=request.getParameter("record_id");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>

<script language="javaScript">

function init_page(){

	// 检查是否已存在
	var checkSql="select to_char(create_date,'yyyy-MM-dd hh24:mi:ss') as create_date, create_user, subflag, info from bgp_wr_audit_info where record_id='<%=record_id%>' and bsflag='0' order by create_date desc";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;

	for (var i = 0; i<datas.length; i++) {
		var tr = document.getElementById("table1").insertRow();
		tr.align="center";			
		tr.insertCell().innerHTML = datas[i].create_date;
		tr.insertCell().innerHTML = datas[i].create_user;
		if(datas[i].subflag=='1'){
			tr.insertCell().innerHTML = '审批通过';
		}else{
			tr.insertCell().innerHTML = '审批不通过';
		}
		tr.insertCell().innerHTML = datas[i].info;
	}	
}
</script>
</head>
<body onload="init_page()">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
    <tr class="odd">
    	<td class="rtCRUFdName">周报开始日期：</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="week_date" value="<%=week_date%>">
      	</td>
      	<td class="rtCRUFdName">周报结束日期：</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="week_end_date" value="<%=week_end_date%>">
      	</td>
    </tr>
</table>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" id="table1">
    <tr background="blue" class="bt_info">
      <td class="tableHeader" width="20%">审批时间</td>
      <td class="tableHeader" width="10%">审批人</td>
      <td class="tableHeader" width="10%">审批结果</td> 
      <td class="tableHeader" width="60%">审批意见</td> 
    </tr>
</table>
</body>
</html>
