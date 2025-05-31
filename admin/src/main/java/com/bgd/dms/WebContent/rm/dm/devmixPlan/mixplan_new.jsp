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
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] mixtypeids = rb.getString("MixTypeID").split("~", -1);
	String[] mixtypenames = rb.getString("MixTypeName").split("~", -1);
	String[] mixtypeusernames = rb.getString("MixTypeUserName").split("~", -1);
	String project_type = user.getProjectType();
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
<title>单项目-调配申请-调配申请(单台)-新增按钮页面</title>
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
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >调配设备类别:</td>
          <td class="inquire_form4">
          	<select name="mixownership" id="mixownership" class="selected_width" ></selected>
          </td>
          <td class="inquire_item4" ></td>
          <td class="inquire_form4"></td>
        </tr>
      </table>
      </fieldset>
      <fieldset style="margin:2px:padding:2px;"><legend>调配申请基本信息</legend>
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
	var projectType = '<%=project_type%>';
	var projectInfoNos = '<%=projectInfoNo%>';

	function saveInfo(){
		$("#device_app_no").val("");
		var mixtypename = $("option:selected","#mixownership").text();
		var mixtypeusername = $("option:selected","#mixownership").attr("mixtypeusername");
		//调配申请保存
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMixAppBaseInfo.srq?state=0&mixtypename="+mixtypename+"&mixtypeusername="+mixtypeusername;
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=projectInfoNo%>'!=null){
			//查询基本信息
			var querySql = "select allapp.device_allapp_id,allapp.device_allapp_no,allapp.device_allapp_name,allapp.appdate as allappdate,";
			querySql += "pro.project_name,to_char(sysdate,'yyyy-mm-dd') as currentdate,org.org_name,emp.employee_name ";
			querySql += "from gms_device_allapp allapp  ";
			querySql += "left join gp_task_project pro on allapp.project_info_no=pro.project_info_no ";

			//综合物化探
			if(projectType == "5000100004000000009"){					
				var ret = jcdpCallService("WtProjectSrv", "getProjectInfo", "projectInfoNo="+projectInfoNos);
				var pro_dep = ret.map.project_department;
					
				if(pro_dep=="C6000000000124"){businessType = "5110000004100001019";}//海外项目部
				if(pro_dep=="C6000000004707"){businessType = "5110000004100001016";}//工程项目部									
				if(pro_dep=="C6000000005592"){businessType = "5110000004100001022";}//北疆项目部		
				if(pro_dep=="C6000000005594"){businessType = "5110000004100001024";}//东部项目部
				if(pro_dep=="C6000000005595"){businessType = "5110000004100001023";}//敦煌项目部
				if(pro_dep=="C6000000005605"){businessType = "5110000004100001021";}//塔里木项目部
									
				querySql += "left join common_busi_wf_middle allwfmiddle on allapp.project_info_no= allwfmiddle.business_id and allwfmiddle.bsflag='0' ";
				querySql += "and allwfmiddle.business_type = '"+businessType+"' "
	        }else{
	        	querySql += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.device_allapp_id and allwfmiddle.bsflag='0' ";
	         }

			querySql += "left join comm_org_information org on allapp.org_id = org.org_id  ";
			querySql += "left join comm_human_employee emp on allapp.employee_id = emp.employee_id ";
			querySql += "where allapp.bsflag = '0' and  allapp.project_info_no='<%=projectInfoNo%>' ";
			querySql += " and allwfmiddle.proc_status='3' ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			//回填基本信息
			$("#project_name").val(basedatas[0].project_name);
			$("#device_allapp_no").val(basedatas[0].device_allapp_no);
			$("#device_allapp_name").val(basedatas[0].device_allapp_name);
			$("#allappdate").val(basedatas[0].allappdate);
			$("#device_allapp_id").val(basedatas[0].device_allapp_id);
			$("#appdate").val(basedatas[0].currentdate);
			var innerHTML = "";

			<%
				for(int j=0;j<mixtypeids.length;j++){
					String mixtypeid = mixtypeids[j];
					String mixtypename = mixtypenames[j];
					String mixtypeusername = mixtypeusernames[j];
			%>
				var tmpstr = "<option id='<%=mixtypeid%>' value='<%=mixtypeid%>' mixtypeusername='<%=mixtypeusername%>'>"+'<%=mixtypename%>'+"</option>";
				innerHTML += tmpstr;
			<%
				}
			%>
			
			$("#mixownership").append(innerHTML);
			//井中项目隐藏专业化震源选项
			if(projectType == '5000100004000000008'){
				$("select option[value='S0623']").remove();
			}
			
		}
	}
</script>
</html>

