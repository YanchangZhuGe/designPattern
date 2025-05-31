<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		projectInfoNo = user.getProjectId();
	}
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
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
<title>新增调配主申请</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin:2px;padding:2px;"><legend>配置计划基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="project_name" id="project_name" class="input_width" type="text" value=""  readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="device_allapp_id" id="device_allapp_id" type="hidden" value="" />
          	<input name="device_app_id" id="device_app_id" type="hidden" value="" />
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
          	<input type='hidden' name='mixownership' id='mixownership value='S0000' />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >外租设备类型:</td>
          <td class="inquire_form4">
          	<select name="hireplantype" id="hireplantype" class="selected_width" 
></selected>
          </td>
          <td class="inquire_item4" ></td>
          <td class="inquire_form4"></td>
        </tr>
      </table>
      </fieldset>
      <fieldset style="margin:2px:padding:2px;"><legend>外租申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">外租申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="device_hireapp_name" id="device_hireapp_name" class="input_width" type="text" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">外租申请单号:</td>
          <td class="inquire_form4">
          	<input name="device_hireapp_no" id="device_hireapp_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="appdate" id="appdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getTeamOrgId()%>"/>
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

	var projectType="<%=projectType%>";
	
	function saveInfo(){
		$("#device_hireapp_no").val("");

		//调配申请保存
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveHireAppBaseInfo.srq?state=0";
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var basedatas;
		var retObj,queryRet;
		//回填设备调配类型
		var bysql = "select coding_name,coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000184' order by coding_show_id";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+bysql);
		retObj = queryRet.datas;
		if(retObj!=undefined && retObj.length>=1){
			//回填信息
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='wzlx' id='wzlx"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#hireplantype").append(optionhtml);
		}
		if('<%=projectInfoNo%>'!=null){
			//查询基本信息
			var querySql = "select allapp.device_allapp_id,allapp.device_allapp_no,allapp.device_allapp_name,allapp.appdate as allappdate,";
			querySql += "pro.project_name,to_char(sysdate,'yyyy-mm-dd') as currentdate,org.org_name,emp.employee_name ";
			querySql += "from gms_device_allapp allapp  ";
			querySql += "left join gp_task_project pro on allapp.project_info_no=pro.project_info_no ";
			//querySql += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.device_allapp_id  ";

			//综合物化探
			if(projectType == "5000100004000000009")
	        {
				querySql += "left join common_busi_wf_middle allwfmiddle on allapp.project_info_no= allwfmiddle.business_id and allwfmiddle.bsflag='0' ";
				querySql += "and wfmiddle.business_type = '5110000004100000095' "
	        }else{
	        	querySql += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.device_allapp_id and allwfmiddle.bsflag='0' ";
	        	//querySql += "and wfmiddle.business_type = '5110000004100000027' "
	         }

			//综合物化探从生产--项目资源配置中录入的设备信息
			//querySql +=" or (allapp.project_info_no= allwfmiddle.business_id and allwfmiddle.business_type='5110000004100000095') ";
			
			querySql += "left join comm_org_information org on allapp.org_id = org.org_id  ";
			querySql += "left join comm_human_employee emp on allapp.employee_id = emp.employee_id ";
			querySql += "where allapp.bsflag = '0' and  allapp.project_info_no='<%=projectInfoNo%>' ";
			querySql += " and allwfmiddle.proc_status='3' ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			if(basedatas.length >=1){
				//回填基本信息
				$("#project_name").val(basedatas[0].project_name);
				$("#device_allapp_no").val(basedatas[0].device_allapp_no);
				$("#device_allapp_name").val(basedatas[0].device_allapp_name);
				$("#allappdate").val(basedatas[0].allappdate);
				$("#device_allapp_id").val(basedatas[0].device_allapp_id);
				$("#appdate").val(basedatas[0].currentdate);
			}
		
		}
	}
</script>
</html>

