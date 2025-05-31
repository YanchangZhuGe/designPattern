<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
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
<title>多项目-井中设备分中心-新增子页面</title>
</head>
<body class="bgColor_f3f3f3" >
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin-left:2px"><legend>设备申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单号:</td>
          <td class="inquire_form4">
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text" value="保存后自动生成.." style="color:#B0B0B0;" readonly/>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="appdate" id="appdate" class="input_width" type="text" value="<%=appDate %>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
          <td class="inquire_item4">申请人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
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

	function saveInfo(){
		$("#device_allapp_no").val("");
		//大计划保存
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevAllAppBaseInfo.srq?state=0&wellsflag=Y&allapp_type=S10002";
			document.getElementById("form1").submit();
		}
	}
</script>
</html>

