<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());

 
 
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
<link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';

var currentCount=parseInt('0');
var deviceCount = parseInt('0');
 
function sucess11(){

	var deviceCount = document.getElementById("equipmentSize").value;
	alert(deviceCount);
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){
		if(document.getElementById("fy"+i+"check").checked == true){
			isCheck=false;
		}
	}
	if(isCheck){
		alert("��ѡ��һ����¼");
		return false;
	}else{
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveHumanRequired.srq";
		form.submit();
		alert('����ɹ�');
		newClose();
		return true;
	}
	
 
}

 
function sucess(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveHumanRequired.srq";
		form.submit();
		alert('����ɹ�');
		newClose();
	}
}

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){
		if(document.getElementById("fy"+i+"check").checked == true){
			isCheck=false;
		}
	}
	if(isCheck){
		alert("��ѡ��һ����¼");
		return false;
	}else{
		return true;
	}
	

}
	

 
 
 
</script>
<title>��Ա�������</title>
</head>
<body  >
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">

	<tr  >
		<td  class="inquire_item4"><font color=red></font>&nbsp;���䵥�ţ�22</td>
		<td class="inquire_form4">
		
		</td>
		<td class="inquire_item4">�����ˣ�</td> 
		<td class="inquire_form4">
		
		</td>	
	</tr>
	<tr  >
	<td  class="inquire_item4"><font color=red></font>&nbsp;�������ڣ�</td>
	<td class="inquire_form4">
	  
	</td>
	<td class="inquire_item4" >  <a href="<%=contextPath%>/rm/em/humanPlant/download.jsp?path=/rm/em/humanPlant/importHumanList.xls&filename=��Ա���뵼��ģ��.xls">������Ա����ģ��</a>
	  &nbsp;&nbsp;  <auth:ListButton functionId="" css="dr" event="onclick='importSerialNumber()'" title="����"></auth:ListButton>
	</td> 	 
	<td class="inquire_form4"></td>
    </tr>
    
	 

	
</table>
<div style="width:1000;overflow-x:scroll;overflow-y:scroll;"> 
<table id="zigeMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
<tr>    
    <TD class="bt_info_odd" width="3%">���11</TD>
	<TD class="bt_info_even" width="10%">����</TD>
	<TD class="bt_info_odd" width="10%">��λ</TD>
	<TD class="bt_info_even" width="6%">��������</TD>
	<TD class="bt_info_odd" width="6%">�������</TD>
	<TD class="bt_info_even" width="6%">�ѵ�������</TD>
	<TD class="bt_info_odd" width="6%"><font color=red>*</font>&nbsp;���ε�������</TD>
	<TD class="bt_info_even" width="7%">����</TD>
	<TD class="bt_info_odd" width="7%">��������</TD>
	<TD class="bt_info_even" width="7%">�Ļ��̶�</TD>
	<TD class="bt_info_odd" width="10%">Ԥ�ƽ�����Ŀʱ��</TD>
	<TD class="bt_info_even" width="10%">Ԥ���뿪��Ŀʱ��</TD>
	<TD class="bt_info_odd" width="6%">Ԥ������</TD>
	<TD class="bt_info_even" width="3%">��ע</TD>
	<TD class="bt_info_odd" width="3%">����</TD>
</tr>
</table>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
  <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
  <td background="<%=contextPath%>/images/list_15.png">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp; </td>

  <td> </td>
</tr>
</table>
</td>
  <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
</tr>
</table>
<div style="width:1000;overflow-x:scroll;overflow-y:scroll;"> 	
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info" width="100%" id="equipmentTableInfo">
	<tr  > 
		<TD class="bt_info_odd" width="3%">���</TD>
		<TD class="bt_info_even" width="10%"><font color=red>*</font>&nbsp;����</TD>
		<TD class="bt_info_odd" width="10%"><font color=red>*</font>&nbsp;��λ</TD>
		<TD class="bt_info_even" width="10%"><font color=red>*</font>&nbsp;����</TD>
		<TD class="bt_info_odd" width="10%"><font color=red>*</font>&nbsp;Ԥ�ƽ�����Ŀʱ��</TD>
		<TD class="bt_info_even" width="10%"><font color=red>*</font>&nbsp;Ԥ���뿪��Ŀʱ��	</TD>
		<TD class="bt_info_odd" width="6%">&nbsp;Ԥ������</TD>
		<TD class="bt_info_even" width="3%">���� 	</TD>
	</tr>
		  
</table>	</div>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="right">
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </td>
  <td>
  <span  class="bc_btn"> <a href="#" onclick="sucess(); "></a></span>
  <span class="gb_btn"> <a href="#" onclick="newClose();"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>

</form>
</body>
</html>