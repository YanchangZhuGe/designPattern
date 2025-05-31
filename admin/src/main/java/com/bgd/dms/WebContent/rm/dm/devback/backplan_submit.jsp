<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.util.DateUtil"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("devicebackappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String userName = user.getUserName();
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
<title>新建返还单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin-left:2px"><legend>返还单基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">项目名称</td>
          <td class="inquire_form4">
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="project_info_id" id="project_info_id" class="input_width" type="hidden" value=""/>
          	<input name="m_device_backapp_id" id="m_device_backapp_id" class="input_width" type="hidden" value=""/>
          </td>
          <td class="inquire_item4">返还单号:</td>
          <td class="inquire_form4"><input name="device_backapp_no" id="device_backapp_no" class="input_width" type="text" value="提交后自动生成..." readonly/></td>
        </tr>
        <tr>
          <td class="inquire_item4">返还单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="backappname" id="backappname" class="input_width" style="width:92%" type="text" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">转出单位:</td>
          <td class="inquire_form4">
          	<input name="in_org_name" id="out_org_name" class="input_width" type="text" readonly/>
          	<input name="in_org_id" id="out_org_id" class="input_width" type="hidden" />
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="backdate" id="backdate" class="input_width" type="text" value="" readonly/>
          </td>
          
        </tr>
        <tr>
          <td class="inquire_item4">返还单位</td>
          <td class="inquire_form4">
          	<input name="out_org_name" id="back_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          	<input name="out_org_id" id="back_org_id" class="input_width" value="<%=user.getOrgId()%>" type="hidden" />
          </td>
          <td class="inquire_item4">申请人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="back_employee_id" id="back_employee_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >备注:</td>
          <td class="inquire_form4" colspan="3" style="padding-right:45px;">
          	<textarea id="remark" name="remark" class="textarea" rows="1" cols="45" style="color:#B0B0B0;" readonly></textarea>
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调配明细信息</legend>
		  <div style="height:100px;overflow:auto">
		  <table width="99%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	       <tr>
				<td class="bt_info_odd" width="4%">选择</td>
				<td class="bt_info_even" width="6%">序号</td>
				<td class="bt_info_odd" width="8%">设备编码</td>
				<td class="bt_info_even" width="8%">设备名称</td>
				<td class="bt_info_odd" width="8%">规格型号</td>
				<td class="bt_info_even" width="8%">自编号</td>
				<td class="bt_info_odd" width="9%">实物标识号</td>
				<td class="bt_info_even" width="8%">牌照号</td>
				<td class="bt_info_odd" width="13%">实际进场时间</td>
				<td class="bt_info_even" width="13%">计划离场时间</td>
			</tr>
		   <tbody id="backDevtable" name="backDevtable">
		   </tbody>
	      </table>
	      </div>
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
		if(confirm('提交后信息不能修改，是否确认提交?')){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackBaseAppInfo.srq?state=9";
			document.getElementById("form1").submit();
		}
	}
	
	function refreshData(){
		var retObj;
		var projectInfoNos = '<%=projectInfoNo%>';
		var devicebackappid = <%=devicebackappid%>;
		if(devicebackappid!=null){
			//查询明细信息
			var proSql = "select ba.device_backapp_id,ba.device_backapp_no,ba.backapp_name,ba.project_info_id,pro.project_name,";
			proSql += "bad.dev_coding,accdui.dev_name,accdui.dev_model,bad.self_num,bad.dev_sign,bad.license_num,";
			proSql += "bad.actual_in_time,bad.planning_out_time,ba.back_org_id,baorg.org_name as back_org_name,ba.remark,";
			proSql += "ba.org_id,org.org_name as out_org_name,ba.backdate,ba.back_employee_id,emp.employee_name as back_employee_name ";
			proSql += "from gms_device_backapp_detail bad ";
			proSql += "left join gms_device_backapp ba on ba.device_backapp_id = bad.device_backapp_id ";
			proSql += "left join gp_task_project pro on ba.project_info_id = pro.project_info_no ";
			proSql += "left join comm_org_information org on ba.org_id = org.org_id ";
			proSql += "left join comm_org_information baorg on ba.back_org_id = baorg.org_id ";
			proSql += "left join gms_device_account_dui accdui on bad.dev_acc_id = accdui.dev_acc_id ";
			proSql += "left join comm_human_employee emp on ba.back_employee_id = emp.employee_id ";
			proSql += "where ba.project_info_id = '"+projectInfoNos+"' ";
			proSql += "and ba.device_backapp_id = '"+devicebackappid+"' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas;
			//查询出多条，回填下面的输入框
			for(var index=0;index<retObj.length;index++){
				if(index==0){
					$("#m_device_backapp_id").val(retObj[index].device_backapp_id);
					$("#project_info_id").val(retObj[index].project_info_id);
					$("#project_name").val(retObj[index].project_name);
					//TODO 补充显示申请单名称和备注
					$("#backappname").val(retObj[index].backapp_name);
					$("#remark").val(retObj[index].remark);
					
					$("#out_org_name").val(retObj[index].out_org_name);
					$("#out_org_id").val(retObj[index].org_id);
					
					if(retObj[index].device_backapp_no!=""){
						$("#device_backapp_no").val(retObj[index].device_backapp_no);
					}
					$("#back_org_name").val(retObj[index].back_org_name);
					$("#back_org_id").val(retObj[index].back_org_id);
					$("#backdate").val(retObj[index].backdate);
					$("#back_employee_name").val(retObj[index].back_employee_name);
					$("#back_employee_id").val(retObj[index].back_employee_id);
				}
				var seq = $("tr","#backDevtable").size();
				var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' mdminfo='"+retObj[index].dev_acc_id+"'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_acc_id+"' disabled/></td>";
				innerhtml += "<td>"+(seq+1)+"</td>";
				innerhtml += "<td>"+retObj[index].dev_coding+"</td>";
				innerhtml += "<td>"+retObj[index].dev_name+"</td>";
				innerhtml += "<td>"+retObj[index].dev_model+"</td>";
				innerhtml += "<td>"+retObj[index].self_num+"</td>";
				innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
				innerhtml += "<td>"+retObj[index].license_num+"</td>";
				innerhtml += "<td>"+retObj[index].actual_in_time+"</td>";
				innerhtml += "<td>"+retObj[index].planning_out_time+"</td>";
				innerhtml += "</tr>";
				$("#backDevtable").append(innerhtml);
			}
			$("#backDevtable>tr:odd>td:odd").addClass("odd_odd");
			$("#backDevtable>tr:odd>td:even").addClass("odd_even");
			$("#backDevtable>tr:even>td:odd").addClass("even_odd");
			$("#backDevtable>tr:even>td:even").addClass("even_even");
		}
	}
</script>
</html>