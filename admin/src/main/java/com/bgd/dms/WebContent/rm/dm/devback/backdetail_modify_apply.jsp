<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("devicebackappid");
	String devicebackdetid = request.getParameter("devicebackdetid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	String backtypewaizu = backTypeIDs[0];
	String backtypeziyou = backTypeIDs[1];
	String[] backTypeNames = rb.getString("BackTypeName").split("~", -1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>调配明细添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">配置计划基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="devicebackappid" id="devicebackappid" type="hidden" value="<%=devicebackappid%>" />
          </td>         
        </tr>
        <tr>
          <td class="inquire_item4" >返还申请单名称:</td>
          <td class="inquire_item4" colspan="3">
          	<input name="backapp_name" id="backapp_name" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <td class="inquire_item4" >返还申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text" value="" readonly/>
          </td>
        <tr>
          <td class="inquire_item4" >设备返还类别:</td>
          <td class="inquire_form4" >
          	<input name="backdevtypename" id="backdevtypename" class="input_width" type="text" value="" readonly/>
          	<input name="backdevtype" id="backdevtype" type="hidden" value="" />
          </td>
          <td class="inquire_item4" ></td>
          <td class="inquire_form4" ></td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调配申请明细</legend>
		  <div style="height:105px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="4%">选择</td>
					<td class="bt_info_odd" width="11%">设备编码</td>
					<td class="bt_info_even" width="11%">设备名称</td>
					<td class="bt_info_odd" width="11%">规格型号</td>
					<td class="bt_info_even" width="11%">自编号</td>
					<td class="bt_info_odd" width="11%">实物标识号</td>
					<td class="bt_info_even" width="11%">牌照号</td>
					<td class="bt_info_odd" width="8%">数量</td>
					<td class="bt_info_even" width="13%">实际进场时间</td>
					<td class="bt_info_odd" width="13%">计划离场时间</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
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
		//保留的行信息
		var count = 0;
		var line_infos;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked){
				if(count == 0){
					line_infos = this.id;
				}else{
					line_infos = line_infos+"~"+this.id;
				}
				count++;
			}
		});
		if(count == 0){
			alert('请选择调配设备申请明细信息！');
			return;
		}
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#applynum"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细的申请数量!");
			return;
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMixAppDetailInfo.srq?count="+count+"&line_infos="+line_infos;
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		if('<%=devicebackappid%>'!=null){
			var proSql = "select backapp.back_org_id,backapp_name,backapp.backdate,backapp.back_employee_id,";
			proSql += "backapp.out_org_id,backapp.remark,pro.project_info_no,pro.project_name,";
			proSql += "backorg.org_name as back_org_name,outorg.org_name as out_org_name,emp.employee_name as back_emp_name ";
			proSql += "from gms_device_backapp backapp left join gp_task_project pro on backapp.project_info_id=pro.project_info_no ";
			proSql += "left join comm_org_information backorg on backorg.org_id=backapp.back_org_id ";
			proSql += "left join comm_org_information outorg on outorg.org_id=backapp.out_org_id ";
			proSql += "left join comm_human_employee emp on emp.employee_id=backapp.back_employee_id ";
			proSql += "where backapp.project_info_id= '<%=projectInfoNo%>' and backapp.device_backapp_id='<%=devicebackappid%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#project_name").val(retObj[0].project_name);
			$("#backdate").val(retObj[0].backdate);
			$("#backapp_name").val(retObj[0].backapp_name);
			$("#out_org_name").val(retObj[0].out_org_name);
			$("#out_org_id").val(retObj[0].out_org_id);
			$("#remark").val(retObj[0].remark);
		}
		var detailObj;
		//查询明细信息
		if('<%=devicebackdetid%>'!=null){
			var str = "select backdet.device_backdet_id,backdet.device_backapp_id,backdet.dev_acc_id, ";
			str += "backdet.dev_coding,backdet.self_num,backdet.dev_sign, ";
			str += "backdet.license_num,backdet.actual_in_time,backdet.planning_out_time, ";
			str += "account.dev_name,account.dev_model ";
			str += "from gms_device_backapp_detail backdet ";
			str += "left join gms_device_account_dui account on backdet.dev_acc_id = account.dev_acc_id ";
			str += "where backdet.device_backdet_id='<%=devicebackdetid%>' ";
			//查询需要修改的一条数据
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			detailObj = unitRet.datas;
			//查询已申请信息 -- 修改界面
			for(var index=0;index<detailObj.length;index++){
				var innerhtml = "<tr id='tr"+detailObj[index].dev_acc_id+"' name='tr' midinfo='"+detailObj[index].dev_acc_id+"'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+detailObj[index].dev_acc_id+"'/></td>";
				innerhtml += "<td>"+detailObj[index].dev_coding+"</td>";
				innerhtml += "<td>"+detailObj[index].dev_name+"</td>";
				innerhtml += "<td>"+detailObj[index].dev_model+"</td>";
				innerhtml += "<td>"+detailObj[index].self_num+"</td>";
				innerhtml += "<td>"+detailObj[index].dev_sign+"</td>";
				innerhtml += "<td>"+detailObj[index].license_num+"</td>";
				innerhtml += "<td>1</td>";
				innerhtml += "<td>"+detailObj[index].actual_in_time+"</td>";
				innerhtml += "<td>"+detailObj[index].planning_out_time+"</td>";
				innerhtml += "</tr>";
				$("#processtable").append(innerhtml);
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
	}
</script>
</html>

