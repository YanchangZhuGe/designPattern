<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
%>

<html>
<head>
<title>����ҳ��</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css"  />

<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script> 
<link rel="stylesheet" href="<%=contextPath%>/css/common.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/main.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/rt_cru.css" type="text/css" />
<script type="text/javascript">
function doAdd() {
	var form = document.forms[0];
	form.action = "${pageContext.request.contextPath }/wf/test/startUpProcess.srq";

		form.submit();
	
}
  function openProcWindow()
	   {
		 window.showModalDialog("/epDemo/ibp/bpm/carapply/proSelectList2Link.lpmd",window,"height=500,width=500,scrollbars=yes");
	   }
       
       
  function openUserWindow()
	   {
		  window.open("/epDemo/ibp/bpm/carapply/userList2Select.jsp","window","height=500,width=500,scrollbars=yes");
	   }
       
        
  function returnProcnfos(names,ids,procEName,procVersion) {
     //   alert(names+"==="+ids+"==="+procEName+"==="+procVersion)
			   document.getElementById("procName").value = names;
			   document.getElementById("procId").value = ids;
			   document.getElementById("procEName").value = procEName;
			   document.getElementById("procVersion").value = procVersion;
		}	
		
  function refreshData(ids){
	alert('aaaa'+ids)
	}
</script>
</head>

<body>
<div id="hintTitle">
<span id="cruTitle"></span>	
</div>
<div>
<span id="cruTitle"></span>	
</div>

<div id="addDiv">	

  
  
  <form name="insertOrgForm" method="post">
 <span id="hiddenFields" style="display:none"></span>
 <table id="rtCRUTable" cellSpacing=0 cellPadding=1 width="100%" align=center border=0>
  
    <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;������⣺</td>
      <td class="rtCRUFdValue">
      	<input type="text" class="input_width"  name="proc_car_title" id="proc_car_title" />
      </td>
    </tr>
    <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;�ó�ʱ�䣺</td>
      <td class="rtCRUFdValue"><input type="text" class="input_width" name="proc_date" id="proc_date" /></td>
    </tr>
    <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;������ʼ��ַ��</td>
      <td class="rtCRUFdValue"><input type="text"  name="proc_start_address" id="proc_start_address" />&nbsp;��&nbsp;
     <input type="text"  name="proc_end_address" id="proc_end_address" /></td>
    </tr>
    <tr>   
      <td class="rtCRUFdName">&nbsp;&nbsp;&nbsp;��ϵ�绰��</td>
      <td class="rtCRUFdValue"><input type="text" class="input_width" name="proc_officePhone" id="proc_officePhone"></td>
    </tr>
     <tr>
      <td class="rtCRUFdName">&nbsp;&nbsp;&nbsp;����ģ��ID��</td>
      <td class="rtCRUFdValue"><input type="text" class="input_width" name="procName" id="procName" value=""/>
      
      <input type="hidden"  name="procEName" id="procEName" value=""/>
      <input type="hidden"  name="procVersion" id="procVersion" value=""/>
      
      <input type="hidden"  name="procId" id="procId" value="8ad8b68d24b3a7ac0124b3c92baf0002"/>
      <input type="button" class="button save" value="ѡ��ģ��" onClick="openProcWindow()"/>
      </td>
    </tr>
    <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;����˵����</td>
      <td class="rtCRUFdValue" colspan="3"><textarea name="proc_Desc" id="proc_Desc"></textarea></td>
    </tr>
     <tr>
       <td class="rtCRUFdName"><font color="red">*</font>&nbsp;�û�ID��</td>	   
	   <td class="rtCRUFdValue">  <input type="text" class="input_width"  name="ccUsers" id="ccUsers" value=""/>
	   <input type="hidden"  name="ccUserIds" id="ccUserIds" value=""/>
       <input type="hidden"  name="userName" id="userName" value=""/>
	   <input type="button" class="button save" value="ѡ���û�" onClick="openUserWindow()"/>
	   </td>
    </tr>
</table>
</form>
	<table cellSpacing=0 cellPadding=5 width="100%" align=center border=0 class="small"> 
	<tr>
		<td colspan="4" align="center">
		<input type="button" class="button save" value="����" onClick="doAdd()"/>
		<input type="button" class="button cancel" value="�ر�" onClick="window.close()"/>
		</td>
	</tr>
	</table>  
</div>

</body>
</html>