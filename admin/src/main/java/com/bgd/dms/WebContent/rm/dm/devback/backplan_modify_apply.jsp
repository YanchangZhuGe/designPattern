<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.util.DateUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("devicebackappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String userName = user.getUserName();
	
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	String backtypewaizu = backTypeIDs[backTypeIDs.length-1];
	String[] backTypeNames = rb.getString("BackTypeName").split("~", -1);
	String[] backTypeUserNames = rb.getString("BackTypeUserName").split("~", -1);
	
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
<title>修改返还单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend>返还单基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" style="color:#B0B0B0;" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden" value="<%=projectInfoNo%>"/>
          	<input name="m_device_backapp_id" id="m_device_backapp_id" class="input_width" type="hidden" value="<%=devicebackappid%>"/>
          </td>
          <td class="inquire_item4">返还申请单号:</td>
          <td class="inquire_form4">
          	<input name="device_backapp_no" id="device_backapp_no" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="backappname" id="backappname" class="input_width" style="width:92%" type="text" />
          </td>
        </tr>
        <tr>
         <td class="inquire_item4">返还单位</td>
          <td class="inquire_form4">
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text" value="" readonly/>
          	<input name="back_org_id" id="back_org_id" class="input_width" value="" type="hidden" />
          </td>
          <td class="inquire_item4">申请人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="back_employee_id" id="back_employee_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >返还设备类别:</td>
          <td class="inquire_form4">
          	<select name="backdevtype" id="backdevtype" class="selected_width" disabled></selected>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="backdate" id="backdate" class="input_width" type="text" value="" readonly/>
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
		var backappname = $("#backappname").val();
		if(backappname == ""){
			alert("请输入返还单名称!");
			return;
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackBaseAppInfo.srq?state=0";
		document.getElementById("form1").submit();
	}
	
	function showOrgPage(){
		var projectInfoNo = '<%= projectInfoNo %>';
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devback/selectOutOrgId.jsp?projectinfoid="+projectInfoNo,obj,"dialogWidth=305px;dialogHeight=420px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			$("#out_org_id").val(returnvalues[0]);
			$("#out_org_name").val(returnvalues[1]);
		}
	}
	function refreshData(){
		var retObj;
		var projectInfoNos = '<%=projectInfoNo%>';
		var devicebackappid = '<%=devicebackappid%>';
		if(devicebackappid!=null){
			//查询明细信息
			var str = "select pro.project_name,backapp.device_backapp_id,backapp.backapp_name,";
			str += "backapp.device_backapp_no,backapp.project_info_id,backapp.back_org_id,";
			str += "backapp.back_employee_id,backapp.backdate,backapp.create_date,backapp.modifi_date,";
			str += "backdevtype,";
			str += "case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,";
			str += "org.org_name as back_org_name,emp.employee_name as back_employee_name ";
			str += "from gms_device_backapp backapp ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = backapp.device_backapp_id  ";
			str += "left join comm_org_information org on backapp.back_org_id = org.org_id ";
			str += "left join comm_human_employee emp on backapp.back_employee_id = emp.employee_id ";
			str += "left join gp_task_project pro on backapp.project_info_id = pro.project_info_no ";
			str += "where backapp.bsflag = '0' and backapp.device_backapp_id='"+devicebackappid+"'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = proqueryRet.datas;
			if(retObj != undefined && retObj.length >= 1){
				//将项目信息放在里面
				$("#project_name").val(retObj[0].project_name);
				$("#device_backapp_no").val(retObj[0].device_backapp_no);
				$("#backdate").val(retObj[0].backdate);
				$("#backappname").val(retObj[0].backapp_name);
				$("#back_employee_id").val(retObj[0].back_employee_id);
				$("#back_employee_name").val(retObj[0].back_employee_name);
				$("#back_org_id").val(retObj[0].back_org_id);
				$("#back_org_name").val(retObj[0].back_org_name);
				$("#out_org_id").val(retObj[0].out_org_id);
				$("#out_org_name").val(retObj[0].out_org_name);
				
				var innerHTML = "";
				var waizuhtml = ""
				<%
					for(int j=0;j<backTypeIDs.length;j++){
						String backTypeId = backTypeIDs[j];
						String backTypeName = backTypeNames[j];
						String backTypeUserName = backTypeUserNames[j];
					var tmpstr = "<option id='<%=backTypeId%>' value='<%=backTypeId%>' userinfo='<%=backTypeUserName%>'>"+'<%=backTypeName%>'+"</option>";
					innerHTML += tmpstr;
				<%
					}
				%>
				$("#backdevtype").append(innerHTML);
				$("#backdevtype").val(retObj[0].backdevtype);
			}
		}
	}
</script>
</html>

