<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<html>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userName = (user==null)?"":user.getUserName();
	Map map=resultMsg.getMsgElement("map").toMap();
	String deptId = resultMsg.getValue("deptId");
	response.setHeader("Pragma","No-cache"); 
	response.setHeader("Cache-Control","no-cache"); 
	response.setDateHeader("Expires", 0);
%>
<head>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/forum.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript">
	function doOrder(){
		var form = document.forms[0];
		document.getElementById("form1").submit();
		document.getElementById("btu").disabled="disabled";
		setTimeout("parentInfo()",2000);
		setTimeout("window.close()",2000);
	}
	function parentInfo(){
		window.dialogArguments.location.href="<%=contextPath%>/market/departmentPage/DepartmentList.lpmd?corpId=<%=map.get("corpId")%>";
	}
</script>
</head>
<body style="background-color:#f5feff;">
<iframe id="hiddenIframe" name="hiddenIframe" style="display: none">

</iframe>
<form name="form1" id="form1"  method="post" action="<%=contextPath%>/market/deptOrderSave.srq" target="hiddenIframe">
	<table>
		<input name="deptId" type="hidden" value="<%=deptId %>"/>
		<input name="corpId" type="hidden" value="<%=map.get("corpId") %>"/>
	 	<input name="orderNo" type="hidden" value="<%=map.get("orderNo") %>"/>
		<tr>
			<td>
				<%=map.get("deptName") %>的序号为<%=map.get("orderNo") %>号，您可以将其调整到<input type="text" id="newOrderNo" name="newOrderNo" />号&nbsp;&nbsp;<input type="button" id="btu" value="确定" onclick="doOrder();"/>
			</td>
		</tr>
	</table>

</form>
	
</body>
</html>