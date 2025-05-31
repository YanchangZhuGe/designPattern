<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%
	String contextPath = request.getContextPath();
	String deviceappid = request.getParameter("deviceappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		projectInfoNo = user.getProjectId();
	}
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] mixtypeids = rb.getString("MixTypeID").split("~", -1);
	String[] mixtypenames = rb.getString("MixTypeName").split("~", -1);
	String[] mixtypeusernames = rb.getString("MixTypeUserName").split("~", -1);
	
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
        <tr>
          <td class="inquire_item4" >调配申请类别:</td>
          <td class="inquire_form4">
          	<select name="mixownership" id="mixownership" class="selected_width" ></selected>
          </td>
          <td class="inquire_item4" ></td>
          <td class="inquire_form4"></td>
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
		//调配计划修改
		var mixownership = $("option:selected","#mixownership").val();
		var mixtypename = $("option:selected","#mixownership").text();
		var mixtypeusername = $("option:selected","#mixownership").attr("mixtypeusername");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMixAppBaseInfo.srq?state=0&mixownership="+mixownership+"&mixtypename="+mixtypename+"&mixtypeusername="+mixtypeusername;
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=deviceappid%>'!=null){
			//查询基本信息
			var querySql = "select pro.project_name,devapp.device_allapp_id,devapp.device_app_id,devapp.device_app_no,devapp.device_app_name,devapp.project_info_no,allapp.appdate as allappdate,";
				querySql += "devapp.org_id,devapp.employee_id,devapp.appdate,devapp.create_date,devapp.modifi_date,devapp.mix_type_id,";
				querySql += "case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,";
				querySql += "org.org_abbreviation as org_name,emp.employee_name,allapp.device_allapp_name,allapp.device_allapp_no ";
						
				querySql += "from gms_device_app devapp ";
				querySql += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id  ";
				querySql += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id ";
				querySql += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.device_allapp_id  ";
				querySql += "left join comm_org_information org on devapp.org_id = org.org_id  ";
				querySql += "left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
				querySql += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no ";
				querySql += "where devapp.bsflag = '0' and  devapp.device_app_id='<%=deviceappid%>' ";
				querySql += "and allwfmiddle.proc_status='3'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
		}
		if(basedatas.length>=1){
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
			var innerHTML = "";
		
			var tmpstr = "<option id='S14050208' value='S14050208' mixtypeusername='S14050208'>"+'检波器'+"</option>";
			innerHTML += tmpstr;
		
			$("#mixownership").append(innerHTML);
			$("#mixownership").val(basedatas[0].mix_type_id);
			$("#mixownership").attr('disabled','disabled');
		}
	}
</script>
</html>

