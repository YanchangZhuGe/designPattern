<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String projectInfoNo = user.getProjectInfoNo();
	//保存结果 1 保存成功
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String info = null;
	if (respMsg != null && respMsg.getValue("info") != null) {
		info = respMsg.getValue("info");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>施工履历信息录入添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData()">
	<form name="form1" id="form1" method="post" action="">
		<div id="new_table_box" style="width: 100%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 95%">
					<input id="projectInfoNo" name="projectInfoNo" type="hidden"
						value="<%=projectInfoNo%>" /> <input id="project_id"
						name="project_id" type="hidden" value="" /> <input id="local_temp"
						name="local_temp" type="hidden" value="" />
					<fieldset>
						<legend>项目信息</legend>
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item6">当地最低气温</td>
								<td class="inquire_form6"><input id="local_temp_low"
									name="local_temp_low" class="input_width" type="text" />°C<font color=red>*</font></td>
								<td class="inquire_item6">当地最高气温</td>
								<td class="inquire_form6"><input id="local_temp_height"
									name="local_temp_height" class="input_width" type="text"
									onkeyup="this.value=this.value.replace(/\D/g,'')"
									onafterpaste="this.value=this.value.replace(/\D/g,'')" />°C<font color=red>*</font></td>
							</tr>
							<tr>
								<td class="inquire_item6">施工方法</td>
								<td class="inquire_form6"><input id="construction_method"
									name="construction_method" class="input_width" type="text" /><font color=red>*</font></td>
								<td class="inquire_item6">施工参数</td>
								<td class="inquire_form6"><input id="construction_params"
									name="construction_params" class="input_width" type="text" /><font color=red>*</font></td>
							</tr>
							<tr>
								<td class="inquire_item6">国家</td>
								<td class="inquire_form6"><input id="country"
									name="country" class="input_width" type="text" /><font color=red>*</font></td>
								<td class="inquire_item6">地区</td>
								<td class="inquire_form6"><input id="project_address"
									name="project_address" class="input_width" type="text" /><font color=red>*</font>
							</tr>
							<tr>
								<td class="inquire_item6">项目长/组长</td>
								<td class="inquire_form6"><input id="projecter"
									name="projecter" class="input_width" type="text" /><font color=red>*</font>
								<td class="inquire_item6">工作时制</td>
								<td class="inquire_form6"><select width='100%'
									name="work_hour" id="work_hour"><option value="">请选择</option>
										<option name="hour8" id="hour8" value="8">8h</option>
										<option name="hour12" id="hour12" value="12">12h</option>
										<option name="hour" id="hour16" value="16">16h</option>
										<option name="hour" id="hour24" value="24">24h</option></select><font color=red>*</font>
							</tr>
							<tr>
								<td class="inquire_item6">主要地表特征：</td>
								<td class="inquire_form6"><input id="surface"
									name="surface" class="input_width" type="text" /><font color=red>*</font></td>
							</tr>
						</table>
					</fieldset>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
					</div>
				</div>
			</div>
	</form>
</body>
<script type="text/javascript">

	function frameSize() {
	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	});
	$(document).ready(lashen);
</script>
<script type="text/javascript">
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
function submitInfo()
{
	
	var local_temp_low = $("#local_temp_low").val();
	var local_temp_height = $("#local_temp_height").val();
	var surface = $("#surface").val();
	var work_hour = $("#work_hour").val();
	var projecter = $("#projecter").val();
	var method = $("#construction_method").val();
	var par = $("#construction_params").val();
	var country = $("#country").val();
	var address = $("#project_address").val();
	if(local_temp_low=="" ||surface=="" || work_hour=="" || projecter=="" ||local_temp_height==""||method==""||par==""||country==""||address=="")
		{
		alert("请施工履历基本信息!");
		return;
		}
	
	document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveSgllInfo.srq";
	document.getElementById("form1").submit();
}

function refreshData()
{
	if('<%=info%>'!='null')
		{
		alert('<%=info%>');
		}
	if('<%=projectInfoNo%>'!='null')
		{
		debugger;
		var sql = "select project_status from gp_task_project p where p.project_info_no='<%=projectInfoNo%>'";
		var retObj1 = syncRequest('Post','<%=contextPath%>'+ appConfig.queryListAction, 'querySql=' + sql
					+ '&pageSize=10000');
			if (retObj1 != null
					&& retObj1.datas[0].project_status == '5000100001000000003') {
				//document.getElementById("oper_div").style.display = "none";
			}
		}
		var baseData;
		baseData = jcdpCallService("DevInsSrv", "getZysglvInfo", "");
		if (baseData.projectMap != null) {
			$("#project_id").val(baseData.projectMap.project_id);
			$("#local_temp_low").val(baseData.projectMap.local_temp_low);
			$("#local_temp_height").val(baseData.projectMap.local_temp_height);
			$("#projecter").val(baseData.projectMap.projecter);
			$("#work_hour").val(baseData.projectMap.work_hour);
			$("#surface").val(baseData.projectMap.surface);
			
		    $("#construction_method").val(baseData.projectMap.construction_method);
			$("#construction_params").val(baseData.projectMap.construction_paramete);
			$("#country").val(baseData.projectMap.country);
			$("#project_address").val(baseData.projectMap.project_address);
			
			
			if ($("#work_hour").val() == '8') {
				document.getElementById("hour8").selected = true;
			}
			if ($("#work_hour").val() == '12') {
				document.getElementById("hour12").selected = true;
			}
			if ($("#work_hour").val() == '16') {
				document.getElementById("hour16").selected = true;
			}
			if ($("#work_hour").val() == '24') {
				document.getElementById("hour24").selected = true;
			}
		}

	}
</script>
</html>