<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
    String contextPath = request.getContextPath();
    String	nodeid = request.getParameter("nodeid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>修改企业编码</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script>
	
function forward()
	{
	//window.location.href="index.html"
	}
</script>
<script type="text/javascript">
cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
var objectid = "<%=nodeid%>";

function loadData(){	
	var retObj = jcdpCallService("EpsCodesSrv", "getEpsCodeById", "objectid="+objectid);
	document.getElementById("epsname").value = retObj.epscode.eps_name;
	document.getElementById("orgname").value = retObj.epscode.org_name;
	document.getElementById("epsid").value = retObj.epscode.eps_id;
	document.getElementById("orgid").value = retObj.epscode.org_id;	
}
	
function checkForm() {
        if (!isTextPropertyNotNull("epsid", "EPSID")) {
		
			document.form1.epsid.focus();
			return false;	
		}
        if (!isTextPropertyNotNull("epsname", "EPS名称")) {
			document.form1.epsname.focus();
			return false;	
		}
        if (!isTextPropertyNotNull("orgname", "责任人")) {
			document.form1.orgname.focus();
			return false;
		}
		return true;
	}
	
	function saveEpsCode(){
		if (!checkForm()) return;
		var form = document.forms[0];
		form.action="<%=contextPath%>/pm/eps/updateEpsCode.srq";
		form.submit();
	}
		
	function cancle(){
	}
	
	//选择责任人
	function selectOrg(){
		var obj = new Object();
		obj.fkValue="";
		obj.value="";
		var resObj = window.showModalDialog('<%=contextPath%>/pm/eps/selectorg.jsp',window);
		document.getElementById("orgid").value = resObj.fkValue;
		document.getElementById("orgname").value = resObj.value;
	}
	
</script>
<link href="table.css" rel="stylesheet" type="text/css" />
</head>

<body onload="loadData();">

<form id="CheckForm" name="form1" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;EPSID：</td>
   <td class="inquire_form4"><input id="epsid" name="epsid" type="text" class="input_width" />
   <input id="nodeid" name="nodeid" type="hidden" value="<%=nodeid%>"/>
   </td>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;EPS名称：</td>
   <td class="inquire_form4"><input id="epsname" name="epsname" type="text" class="input_width" />
   
   </td>
  </tr>
  <tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;责任人：</td>
   <td class="inquire_form4">
   <input id="orgname" name="orgname" type="text" class="input_width" readonly/>
   <input id="orgid" name="orgid" type="hidden"/>
   <img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectOrg();" />
   </td>
    <td class="inquire_item4"></td>
    <td class="inquire_form4"></td>
  </tr>
</table>
  </div>
  <div id="oper_div">
   	<span class="tj_btn"><a href="#" onclick="saveEpsCode()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
</body>
</html>