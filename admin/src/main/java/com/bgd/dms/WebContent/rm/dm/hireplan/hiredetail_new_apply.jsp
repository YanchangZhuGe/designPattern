<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicehireappid = request.getParameter("devicehireappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
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
<title>外租设备添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >配置计划基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="devicehireappid" id="devicehireappid" type="hidden" value="<%=devicehireappid%>" />
          </td>
          <td class="inquire_item4" ></td>
          <td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >配置计划单号:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >配置计划单名称:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调配申请明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="3.5%"><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even" width="6%">班组</td>
					<td class="bt_info_odd" width="10.5%">设备名称</td>
					<td class="bt_info_even" width="10.5%">规格型号</td>
					<td class="bt_info_odd" width="6%">计量单位</td>
					<td class="bt_info_even" width="6%">需求数量</td>
					<td class="bt_info_odd" width="7.5%">已申请数量</td>
					<td class="bt_info_even" width="6%">申请数量</td>
					<td class="bt_info_odd" width="6.5%">用途</td>
					<td class="bt_info_even" width="6%">预计租赁费</td>
					<td class="bt_info_odd" width="9.5%">出租方单位名称</td>
					<td class="bt_info_even" width="10.5%">开始时间</td>
					<td class="bt_info_odd" width="11.5%">结束时间</td>
					
				</tr>
				</table>
			   <div style="height:240px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable" name="processtable" >
			   		</tbody>
		      	</table>
		      </div>
		      
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
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='detinfo']").attr('checked',checkvalue);
	});
});
	var projectType="<%=projectType%>";
	
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var line_infos;
		var idinfos ;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked){
				if(count == 0){
					line_infos = this.id;
					idinfos = this.value;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+this.value;
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
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveHireAppDetailInfo.srq?count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
			document.getElementById("form1").submit();
		}
	}
	function refreshData(){
		var retObj;
		var basedatas;
		//先查询基本信息 
		var basesql = "select pro.project_name,allapp.device_allapp_id,allapp.device_allapp_no,allapp.device_allapp_name,app.mix_type_id from gms_device_hireapp app "
			+"left join gp_task_project pro on app.project_info_no=pro.project_info_no "
			+"left join gms_device_allapp allapp on app.device_allapp_id=allapp.device_allapp_id "
			+"where app.device_hireapp_id='<%=devicehireappid%>' ";
		var baseRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+basesql);
		var baseObj = baseRet.datas;
		//回填基本信息
		$("#project_name").val(baseObj[0].project_name);
		$("#device_allapp_no").val(baseObj[0].device_allapp_no);
		$("#device_allapp_name").val(baseObj[0].device_allapp_name);
		if('<%=devicehireappid%>'!=null){
			var prosql = "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,";
				prosql += "aad.dev_name as dev_ci_name,";
				prosql += "aad.dev_type as dev_ci_model, ";
				prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
				prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
				prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
				prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
				prosql += "from gms_device_allapp_detail aad ";
				prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
				prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
				prosql += "left join gms_device_hireapp dha on allapp.device_allapp_id=dha.device_allapp_id ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
				prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
				prosql += "left join ";
				prosql += "(select device_allapp_detid,dev_ci_code,sum(apply_num) as applyed_num ";
				prosql += "from (select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'1' as type ";
				prosql += "from gms_device_app_detail det join gms_device_app app on det.device_app_id=app.device_app_id where app.bsflag='0' union ";
				prosql += "select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'2' as type ";
				prosql += "from gms_device_hireapp_detail det join gms_device_hireapp app on det.device_hireapp_id=app.device_hireapp_id where app.bsflag='0' )tmp ";
				prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_ci_code) ";
				prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				prosql += "where dha.device_hireapp_id='<%=devicehireappid%>' and dha.bsflag='0' and aad.bsflag='0' and aad.device_addapp_id is null and allapp.bsflag='0' and pro.bsflag='0' ";
				prosql += "union all ";
				prosql += "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,";
				prosql += "aad.dev_name as dev_ci_name,";
				prosql += "aad.dev_type as dev_ci_model, ";
				prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
				prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
				prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
				prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
				prosql += "from gms_device_allapp_detail aad ";
				prosql += "left join common_busi_wf_middle wf on wf.business_id=aad.device_addapp_id ";
				if(projectType == "5000100004000000008"){//井中
					prosql += "and wf.business_type = '5110000004100001064' ";
			    }
				prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
				prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
				prosql += "left join gms_device_hireapp dha on allapp.device_allapp_id=dha.device_allapp_id ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
				prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
				prosql += "left join ";
				prosql += "(select device_allapp_detid,dev_ci_code,sum(apply_num) as applyed_num ";
				prosql += "from (select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'1' as type ";
				prosql += "from gms_device_app_detail det join gms_device_app app on det.device_app_id=app.device_app_id where app.bsflag='0' union ";
				prosql += "select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'2' as type ";
				prosql += "from gms_device_hireapp_detail det join gms_device_hireapp app on det.device_hireapp_id=app.device_hireapp_id where app.bsflag='0' )tmp ";
				prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_ci_code) ";
				prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				prosql += "where dha.device_hireapp_id='<%=devicehireappid%>' and dha.bsflag='0' and aad.bsflag='0' and wf.proc_status='3' and allapp.bsflag='0' and pro.bsflag='0' ";
				//项目资源配置中录入的
				prosql +=" and aad.resourceflag is null union "
				prosql += "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,";
				prosql += "aad.dev_name as dev_ci_name,";
				prosql += "aad.dev_type as dev_ci_model, ";
				prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
				prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
				prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
				prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
				prosql += "from gms_device_allapp_detail aad ";
				prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
				prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
				prosql += "left join gms_device_hireapp dha on allapp.device_allapp_id=dha.device_allapp_id ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
				prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
				prosql += "left join ";
				prosql += "(select device_allapp_detid,dev_ci_code,sum(apply_num) as applyed_num ";
				prosql += "from (select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'1' as type ";
				prosql += "from gms_device_app_detail det join gms_device_app app on det.device_app_id=app.device_app_id where app.bsflag='0' union ";
				prosql += "select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'2' as type ";
				prosql += "from gms_device_hireapp_detail det join gms_device_hireapp app on det.device_hireapp_id=app.device_hireapp_id where app.bsflag='0' )tmp ";
				prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_ci_code) ";
				prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				prosql += "where dha.device_hireapp_id='<%=devicehireappid%>' and dha.bsflag='0' and aad.bsflag='0' and allapp.bsflag='0' and pro.bsflag='0' and aad.resourceflag='0' and aad.device_addapp_id is null ";
				//项目资源补充配置中录入审核通过的
				prosql += "union select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,";
				prosql += "aad.dev_name as dev_ci_name,";
				prosql += "aad.dev_type as dev_ci_model, ";
				prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
				prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
				prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
				prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
				prosql += "from gp_middle_resources r left join common_busi_wf_middle wf on r.mid=wf.business_id and wf.bsflag='0' ";
				prosql += "left join gms_device_allapp_add  al on r.dev_id=al.device_addapp_id and al.bsflag='0' ";
				prosql += "left join gms_device_allapp_detail aad on al.device_addapp_id=aad.device_addapp_id ";
				prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
				prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
				prosql += "left join gms_device_hireapp dha on allapp.device_allapp_id=dha.device_allapp_id ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
				prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
				prosql += "left join ";
				prosql += "(select device_allapp_detid,dev_ci_code,sum(apply_num) as applyed_num ";
				prosql += "from (select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'1' as type ";
				prosql += "from gms_device_app_detail det join gms_device_app app on det.device_app_id=app.device_app_id where app.bsflag='0' union ";
				prosql += "select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'2' as type ";
				prosql += "from gms_device_hireapp_detail det join gms_device_hireapp app on det.device_hireapp_id=app.device_hireapp_id where app.bsflag='0' )tmp ";
				prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_ci_code) ";
				prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				prosql += "where dha.device_hireapp_id='<%=devicehireappid%>' and dha.bsflag='0' and aad.bsflag='0' and allapp.bsflag='0' and pro.bsflag='0' and aad.resourceflag='0' and r.supplyflag='0' and wf.proc_status='3' ";
				
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=10000');
			retObj = proqueryRet.datas;
		}
		for(var index=0;index<retObj.length;index++){
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			innerhtml += "<td width='3.5%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_allapp_detid+"'/>";
			innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' style='line-height:15px' value='"+retObj[index].teamid+"' type='hidden' /></td>";
			innerhtml += "<td width='6%'><input name='teamname"+index+"' id='teamname"+index+"' value='"+retObj[index].teamname+"' size='5' type='text' readonly/>";
			innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+retObj[index].team+"' type='hidden'/></td>";			
			innerhtml += "<td width='10.5%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='10' type='text' readonly/></td>";
			innerhtml += "<td width='10.5%'><input name='devicetype"+index+"' id='devicetype"+index+"' value='"+retObj[index].dev_ci_model+"' size='8'  type='text' readonly/>";
			innerhtml += "<input name='isdevicecode"+index+"' id='isdevicecode"+index+"' value='"+retObj[index].isdevicecode+"' type='hidden' />";
			innerhtml += "<input name='signtype"+index+"' id='signtype"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' /></td>";			
			innerhtml += "<td width='6%'><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='4' type='text' readonly>";
			innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden'></td>";			
			innerhtml += "<td width='6%'><input name='neednum"+index+"' id='neednum"+index+"' value='"+retObj[index].require_num+"' size='6' type='text' readonly/></td>";
			innerhtml += "<td width='7.5%'><input name='applyednum"+index+"' id='applyednum"+index+"' value='"+retObj[index].applyed_num+"' size='6' type='text' readonly/></td>";
			innerhtml += "<td width='6%'><input name='applynum"+index+"' id='applynum"+index+"' detindex='"+index+"' value='' size='6' type='text' onkeyup='checkAssignNum(this)'/></td>";			
			innerhtml += "<td width='6.5%'><input name='purpose"+index+"' id='purpose"+index+"' value='"+retObj[index].purpose+"' size='5' type='text' readonly/></td>";			
			innerhtml += "<td width='6%'><input name='devrental"+index+"' id='devrental"+index+"' style='line-height:15px' value='' size='5' type='text' onkeyup='checkDevrental(this)'/></td>";
			innerhtml += "<td width='9.5%'><input name='rentname"+index+"' id='rentname"+index+"' style='line-height:15px' value='' size='10' type='text' /></td>";			
			innerhtml += "<td width='10.5%'><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
			innerhtml += "<td width='11.5%'><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	function checkDevrental(obj){
		var value = obj.value;
		var re = /^(?:[1-9][0-9]*(?:\.[0-9]{0,2})?)$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("申请数量必须为数字!");
			obj.value = "";
        	return false;
		}
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var neednumval = parseInt($("#neednum"+index).val(),10);
		var applyednumval = parseInt($("#applyednum"+index).val(),10);
		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("申请数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(value,10)>neednumval){
				alert("申请数量必须小于等于需求数量!");
				obj.value = "";
				return false;
			}else if((parseInt(value,10)+applyednumval)>neednumval){
				alert("申请数量必须小于等于未申请数量!");
				obj.value = "";
				return false;
			}
		}
	}
</script>
</html>

