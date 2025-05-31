<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceappid = request.getParameter("deviceappid");
	String deviceappdetid = request.getParameter("deviceappdetid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
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
<title>调剂明细修改界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">配置计划基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" style="color:#B0B0B0;">项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" style="color:#B0B0B0;" value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=deviceappid%>" />
          </td>
          <td class="inquire_item4"></td>
          <td class="inquire_form4"></td>
        </tr>
        <tr>
          <td class="inquire_item4" style="color:#B0B0B0;">配置计划单号:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text" style="color:#B0B0B0;" value="" readonly/>
          </td>
          <td class="inquire_item4" style="color:#B0B0B0;">配置计划单名称:</td>
          <td class="inquire_form4">
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text" style="color:#B0B0B0;" value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调剂申请明细</legend>
		  <div style="height:105px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="5%">工序</td>
					<td class="bt_info_even" width="8%">班组</td>
					<td class="bt_info_odd" width="12%">设备名称</td>
					<td class="bt_info_even" width="15%">规格型号</td>
					<td class="bt_info_odd" width="3%">计量单位</td>
					<td class="bt_info_even" width="6%">需求数量</td>
					<td class="bt_info_odd" width="6%">已申请数量</td>
					<td class="bt_info_even" width="6%">申请数量</td>
					<td class="bt_info_odd" width="12%">用途</td>
					<td class="bt_info_even" width="15%">开始时间</td>
					<td class="bt_info_odd" width="15%">结束时间</td>
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
    <div id="oper_div2" style="display:none;width:100%;height:35px;text-align:center;">
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
		var idinfos ;
		$("input[type='hidden'][name='detinfo']").each(function(){
			if(count == 0){
				line_infos = this.id;
				idinfos = this.alldetvalue;
			}else{
				line_infos = line_infos+"~"+this.id;
				idinfos += "~"+this.alldetvalue;
			}
			count++;
		});
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
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDisAppDetailInfo.srq?count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=deviceappid%>'!=null){
			var prosql = "select dad.device_allapp_detid,dad.device_app_detid,dad.team,dad.teamid,dad.apply_num,dad.dev_ci_code,aad.isdevicecode";
				prosql += "case when aad.isdevicecode='N' then ci.dev_ci_name else ct.dev_ct_name end as dev_ci_name,";
				prosql += "case when aad.isdevicecode='N' then ci.dev_ci_model else '' end as dev_ci_model, ";
				prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,aad.approve_num as require_num,dad.purpose,da.state,";
				prosql += "dad.plan_start_date,dad.plan_end_date,dad.unitinfo,";
				prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.remark,allapp.project_info_no,";
				prosql += "pro.project_name,nvl(tmp.applyed_num, 0) as applyed_num "
				prosql += "from gms_device_disapp_detail dad left join gms_device_disapp da on dad.device_app_id = da.device_app_id ";
				prosql += "left join bgp_p6_activity p6 on dad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail teamsd on dad.team = teamsd.coding_code_id ";
				prosql += "left join gms_device_allapp allapp on da.device_allapp_id = allapp.device_allapp_id ";
				prosql += "left join gms_device_allapp_detail aad on dad.device_allapp_detid = aad.device_allapp_detid ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo = sd.coding_code_id ";
				prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join gp_task_project pro on dad.project_info_no = pro.project_info_no ";
				prosql += "left join (select device_allapp_detid,dev_ci_code,sum(apply_num) as applyed_num ";
				prosql += "from gms_device_disapp_detail where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_ci_code) ";
				prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				prosql += "where da.device_app_id='<%=deviceappid%>' and da.bsflag='0' and aad.bsflag='0' and allapp.bsflag='0' and pro.bsflag='0' ";
				prosql += "and dad.device_app_detid='<%=deviceappdetid%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
		}
		//回填基本信息
		$("#project_name").val(retObj[0].project_name);
		$("#device_allapp_no").val(retObj[0].device_allapp_no);
		$("#device_allapp_name").val(retObj[0].device_allapp_name);
		if(retObj[0].state=='9'){
			$("#oper_div2").show();
			$("#oper_div").hide();
		}
		for(var index=0;index<retObj.length;index++){
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			
			innerhtml += "<td><input name='deviceappdetid"+index+"' id='deviceappdetid"+index+"' value='"+retObj[index].device_app_detid+"' type='hidden' readonly/>";
			innerhtml += "<input type='hidden' name='detinfo' id='"+index+"' alldetvalue='"+retObj[index].device_allapp_detid+"' value='"+retObj[index].device_app_detid+"' />";
			
			innerhtml += "<input name='jobname"+index+"' id='jobname"+index+"' style='line-height:15px' value='"+retObj[index].jobname+"' size='12' type='text' readonly/>";
			innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' style='line-height:15px' value='"+retObj[index].teamid+"' type='hidden' /></td>";
			innerhtml += "<td><input name='teamname"+index+"' id='teamname"+index+"' value='"+retObj[index].teamname+"' type='text' readonly/>";
			innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+retObj[index].team+"' type='hidden'/></td>";
			
			innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='12' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicetype"+index+"' id='devicetype"+index+"' value='"+retObj[index].dev_ci_model+"' size='15'  type='text' readonly/>";
			innerhtml += "<input name='isdevicecode"+index+"' id='isdevicecode"+index+"' value='"+retObj[index].isdevicecode+"' type='hidden' />";
			innerhtml += "<input name='signtype"+index+"' id='signtype"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' /></td>";
			
			innerhtml += "<td><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='3' type='text' readonly>";
			innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden'></td>";
			
			innerhtml += "<td><input name='neednum"+index+"' id='neednum"+index+"' value='"+retObj[index].require_num+"' size='2' type='text' readonly/></td>";
			innerhtml += "<td><input name='applyednum"+index+"' id='applyednum"+index+"' value='"+retObj[index].applyed_num+"' size='2' type='text' readonly/></td>";
			innerhtml += "<td><input name='applynum"+index+"' id='applynum"+index+"' detindex='"+index+"' value='"+retObj[index].apply_num+"' size='2' type='text'  onkeyup='checkAssignNum(this)'/>";
			var checknum = parseInt(retObj[index].applyed_num)-parseInt(retObj[index].apply_num);
			innerhtml += "<input name='checknum"+index+"' id='checknum"+index+"'  value='"+checknum+"' type='hidden' /></td>";
			
			innerhtml += "<td><input name='purpose"+index+"' id='purpose"+index+"' value='"+retObj[index].purpose+"' size='10' type='text' readonly/></td>";
			innerhtml += "<td><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
			innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var neednumval = parseInt($("#neednum"+index).val(),10);
		var applyednumval = parseInt($("#checknum"+index).val(),10);
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

