<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] devCodeids = rb.getString("DevCodeID").split("~",-1);
	String[] devCodenames = rb.getString("DevCodeName").split("~",-1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>新增设备代码归属</title>
</head>
<body class="bgColor_f3f3f3">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin:2px;padding:2px;"><legend>设备编码归属信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >设备编码:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="dev_ci_code" id="dev_ci_code" class="input_width" type="text" value=""  readonly/><input type='button' style='width:20px' value='...' onclick='showDevPage()'/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >设备名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="dev_ci_name" id="dev_ci_name" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >规格型号:</td>
          <td class="inquire_form4">
          	<input name="dev_ci_model" id="dev_ci_model" class="input_width" type="text" value=""  readonly/>
          </td>
          <td class="inquire_item4"></td>
          <td class="inquire_form4">&nbsp;</td>
        </tr>
        <tr>
          <td class="inquire_item4">流程模板类型:</td>
          <td class="inquire_form4" colspan="3">
          	<select name="promodel_id" id="promodel_id" class="selected_width" >
          		<%
          			for(int i=0;i<devCodeids.length;i++){
          				String idinfo = devCodeids[i];
          				String idname = devCodenames[i];
          		%>
          			<option id='<%=idinfo%>' value='<%=idinfo%>'><%=idname%></option>
          		<%
          			}
          		%>
          	</selected>
          </td>
        </tr>
      </table>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function showDevPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp",obj);
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			var devicename = returnvalues[0].substr(returnvalues[0].indexOf(':')+1,(returnvalues[0].indexOf('(')-returnvalues[0].indexOf(':')-1));
			var devicetype = returnvalues[0].substr(returnvalues[0].indexOf('(')+1,(returnvalues[0].indexOf(')')-returnvalues[0].indexOf('(')-1));
			var deviceCode = returnvalues[1].substr(returnvalues[1].indexOf(':')+1,(returnvalues[1].length-returnvalues[1].indexOf(':')));
			$( "#dev_ci_name" ).val(devicename);
			$( "#dev_ci_model" ).val(devicetype);
			$( "#dev_ci_code" ).val(deviceCode);
		}
	}
	function saveInfo(){
		var promodel_name = $("option:selected","#promodel_id").text();
		//调配申请保存
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevOwnershipInfo.srq?promodel_name="+promodel_name;
		document.getElementById("form1").submit();
	}
</script>
</html>

