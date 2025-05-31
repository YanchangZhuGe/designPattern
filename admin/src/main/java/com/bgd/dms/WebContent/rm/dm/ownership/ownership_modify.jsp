<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceappid = request.getParameter("deviceappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	
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
<title>调配主申请修改</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin:2px;margin-bottom:4px;padding:2px;"><legend>配置计划基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="project_name" id="project_name" class="input_width" type="text" value=""  readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="device_allapp_id" id="device_allapp_id" type="hidden" value="" />
          	<input name="device_app_id" id="device_app_id" type="hidden" value="<%=deviceappid%>" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >配置计划单号:</td>
          <td class="inquire_form4">
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text" value=""  readonly/>
          </td>
          <td class="inquire_item4" >配置计划申请时间:</td>
          <td class="inquire_form4">
          	<input name="allappdate" id="allappdate" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
      <fieldset style="margin:2px;margin-top:4px;padding:2px;"><legend>调配申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">调配申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="device_app_name" id="device_app_name" class="input_width" type="text" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">调配申请单号:</td>
          <td class="inquire_form4">
          	<input name="device_app_no" id="device_app_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="appdate" id="appdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位:</td>
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
		//大计划保存
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMixAppBaseInfo.srq?state=0";
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=deviceappid%>'!=null){
			//查询基本信息
			var querySql = "select project.project_name,devapp.device_app_id,devapp.device_app_no,devapp.device_app_name,devapp.remark,";
				querySql += "devapp.project_info_no,devapp.app_org_id,devapp.appdate,devapp.employee_id,devapp.create_date,devapp.modifi_date,";
				querySql += "case devapp.state when '0' then '未提交' when '9' then '已提交' else '流程处理中' end as state_desc,org.org_name,";
				querySql += "emp.employee_name,allapp.device_allapp_id,allapp.device_allapp_name,allapp.device_allapp_no,allapp.appdate as allappdate ";
				querySql += "from gms_device_app devapp left join comm_org_information org on devapp.org_id=org.org_id ";
				querySql += "left join gms_device_allapp allapp on devapp.device_allapp_id=allapp.device_allapp_id ";
				querySql += "left join comm_human_employee emp on devapp.employee_id=emp.employee_id ";
				querySql += "left join gp_task_project project on devapp.project_info_no=project.project_info_no ";
				querySql += "where allapp.bsflag='0' and devapp.bsflag='0' and devapp.device_app_id='<%=deviceappid%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
		}
		//回填基本信息调整
		$("#project_name").val(basedatas[0].project_name);
		$("#projectInfoNo").val(basedatas[0].project_info_no);
		$("#device_allapp_name").val(basedatas[0].device_allapp_name);
		$("#device_allapp_no").val(basedatas[0].device_allapp_no);
		$("#device_allapp_id").val(basedatas[0].device_allapp_id);
		$("#allappdate").val(basedatas[0].allappdate);
		
		$("#device_app_name").val(basedatas[0].device_app_name);
		$("#device_app_no").val(basedatas[0].device_app_no);
		$("#appdate").val(basedatas[0].appdate);
		$("#app_org_id").val(basedatas[0].app_org_id);
		$("#app_org_name").val(basedatas[0].app_org_name);
		$("#employee_id").val(basedatas[0].employee_id);
		$("#employee_name").val(basedatas[0].employee_name);
		//注：这个地方有隐患，如果remark有回车，需要对回车进行处理
		$("#remark").val(basedatas[0].remark);
	}
</script>
</html>

