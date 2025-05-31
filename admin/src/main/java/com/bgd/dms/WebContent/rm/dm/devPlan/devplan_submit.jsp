<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceallappid = request.getParameter("deviceallappid");
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
<title>项目申请提交</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
     <fieldset style="margin-left:2px"><legend>计划基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
          <td class="inquire_item4">项目名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="device_allapp_id" id="device_allapp_id" type="hidden" value="<%=deviceallappid%>" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单号:</td>
          <td class="inquire_form4">
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text" value="保存后自动生成.." style="color:#B0B0B0;" readonly/>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="appdate" id="appdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="app_org_id" class="input_width" type="hidden" value="" />
          	<input name="org_name" id="app_org_name" class="input_width" type="text" value="" readonly/>
          </td>
          <td class="inquire_item4">申请人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">备注:</td>
          <td class="inquire_form4" colspan='3' style="padding-right:45px;">
          	<textarea id="remark" name="remark" class="textarea" rows="3" cols="45" readonly></textarea>
          </td>
        </tr>
       </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>计划明细信息</legend>
      	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
		     <tr id='device_appdet_id_{device_appdet_id}' name='device_appdet_id'>
				<td class="bt_info_odd" >序号</td>
				<td class="bt_info_even" >班组</td>
				<td class="bt_info_odd" >设备名称</td>
				<td class="bt_info_even" >规格型号</td>
				<td class="bt_info_odd" >计量单位</td>
				<td class="bt_info_even" >需求数量</td>
				<td class="bt_info_odd" >用途</td>
				<td class="bt_info_even" >开始时间</td>
				<td class="bt_info_odd" >结束时间</td>
		     </tr>
		     <tbody id='devDetailList'>
		     </tbody>
		  </table>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function submitInfo(){
		var size = $("#devDetailList").children("tr").size();
		if(size == 0){
			alert("请添加计划申请明细!");
			return;
		}
		//计划提交
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevAllAppBaseInfo.srq?state=9";
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		if('<%=projectInfoNo%>'!=null){
			var mainSql = "select devapp.project_info_no,pro.project_name,devapp.appdate,devapp.device_allapp_no,devapp.remark,";
			mainSql += "devapp.device_allapp_name,devapp.app_org_id,devapp.employee_id,org.org_name as app_org_name,emp.employee_name ";
			mainSql += "from gms_device_allapp devapp ";
			mainSql += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no ";
			mainSql += "left join comm_org_information org on devapp.app_org_id = org.org_id  ";
			mainSql += "left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
			mainSql += "where devapp.bsflag='0' ";
			mainSql += "and devapp.project_info_no='<%=projectInfoNo%>' and devapp.device_allapp_id='<%=deviceallappid%>'";
			
			var mainRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainSql);
			retObj = mainRet.datas;
			$("#projectInfoNo").val(retObj[0].project_info_no);
			$("#project_name").val(retObj[0].project_name);
			$("#device_allapp_name").val(retObj[0].device_allapp_name);
			$("#appdate").val(retObj[0].appdate);
			$("#app_org_id").val(retObj[0].app_org_id);
			$("#app_org_name").val(retObj[0].app_org_name);
			$("#employee_name").val(retObj[0].employee_name);
			$("#employee_id").val(retObj[0].employee_id);
			
			if(retObj[0].remark!=null){
				$("#remark").text(retObj[0].remark);
			}
			$("#appdate").val(retObj[0].appdate);
		
			var querySql = "select alldet.device_allapp_detid,sd.coding_name as unitname,";
			querySql += "ci.dev_ci_name,ci.dev_ci_model,alldet.dev_ci_code,alldet.unitinfo, ";
			querySql += "alldet.apply_num,alldet.teamid,alldet.team, ";
			querySql += "alldet.purpose,alldet.plan_start_date,alldet.plan_end_date, ";
			querySql += "devapp.project_info_no,pro.project_name,devapp.appdate,devapp.device_allapp_no,devapp.remark,";
			querySql += "devapp.device_allapp_name,devapp.app_org_id,devapp.employee_id,org.org_name as app_org_name,emp.employee_name ";
			
			querySql += "from gms_device_allapp_detail alldet left join gms_device_allapp devapp on alldet.device_allapp_id=devapp.device_allapp_id ";
			querySql += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no ";
			querySql += "left join comm_org_information org on devapp.app_org_id = org.org_id  ";
			querySql += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
			querySql += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
			querySql += "left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
			querySql += "where alldet.bsflag=0 and devapp.bsflag='0' ";
			querySql += "and devapp.project_info_no='<%=projectInfoNo%>' and devapp.device_allapp_id='<%=deviceallappid%>'";
			
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
		}
		//回填明细信息
		for(var i=0;i<retObj.length;i++){
			var tempobj = retObj[i];
			var listInnerHtml = "<tr id='tr"+i+"' name='tr"+i+"' seq='"+i+"'>";
			listInnerHtml += "<td>"+(i+1)+"</td>";
			listInnerHtml += "<td>"+tempobj.team+"</td>";
			listInnerHtml += "<td>"+tempobj.dev_ci_name+"</td>";
			listInnerHtml += "<td>"+tempobj.dev_ci_model+"</td>";
			listInnerHtml += "<td>"+tempobj.unitname+"</td>";
			listInnerHtml += "<td>"+tempobj.apply_num+"</td>";
			listInnerHtml += "<td>"+tempobj.employee_name+"</td>";
			listInnerHtml += "<td>"+tempobj.plan_start_date+"</td>";
			listInnerHtml += "<td>"+tempobj.plan_end_date+"</td>";
			listInnerHtml += "</tr>";
			$("#devDetailList").append(listInnerHtml);
		}
		$("#devDetailList>tr:odd>td:odd").addClass("odd_odd");
		$("#devDetailList>tr:odd>td:even").addClass("odd_even");
		$("#devDetailList>tr:even>td:odd").addClass("even_odd");
		$("#devDetailList>tr:even>td:even").addClass("even_even");
		//查询设备配置流程映射信息
		
	}
</script>
</html>

