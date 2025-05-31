<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	//String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceallappid = request.getParameter("deviceallappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String userorgid = user.getOrgId();
	String userorgname = user.getOrgName();
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
<title>调剂明细添加界面_大港</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >调剂申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_mixapp_no" id="device_mixapp_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          	<input name="project_name" id="project_name" class="input_width" type="hidden"  value="" readonly/>
          	<input name="deviceallappid" id="deviceallappid" type="hidden" value="<%=deviceallappid%>" />
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="mix_type_id" id="mix_type_id" type="hidden" value="" />
          </td>
          <td class="inquire_item4" >调剂申请单名称:</td>
          <td class="inquire_form4" >
          	<input name="device_mixapp_name" id="device_mixapp_name" class="input_width" type="text"  value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >调剂申请单位:</td>
          <td class="inquire_form4" >
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text"  value="<%=userorgname%>" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden"  value="<%=userorgid%>" />
          </td>
          <td class="inquire_item4" >调剂单位:</td>
          <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/><img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage('out_org')" />
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调配申请明细</legend>
		  <div style="overflow:auto">
			  <table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<!-- <td class="bt_info_odd" width="5%"><input type='checkbox' id='devchecked'name='devchecked' /></td> -->
					<td class="bt_info_even" width="1%">序号</td>
					<td class="bt_info_odd" width="8%">班组</td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="3%">计量单位</td>
					<td class="bt_info_odd" width="6%">调剂数量</td>
					<td class="bt_info_even" width="12%">开始时间</td>
					<td class="bt_info_odd" width="12%">结束时间</td>
					<td class="bt_info_even" width="8%">备注</td>
					<!-- <td class="bt_info_odd" width="15%">调剂单位</td> -->
				</tr>
				<tbody id="processtable" name="processtable" />
				</table>
	      </div>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo(9)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
    </div>
    </div>
</form>
</body>
<script type="text/javascript">
$().ready(function(){
	$("#devchecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='detinfo']").attr('checked',checkvalue);
	});
});
var device_allapp_id = '<%=deviceallappid%>';

var strLen;

	function submitInfo(state){
		//保留的行信息
		var count = strLen;		
		var line_infos;
		var idinfos;
		
		for(var i=0;i<count;i++){
			if(i==0){
				line_infos = i;
				idinfos = $("#detid"+i).val();
			}else{
				line_infos += "~"+i;
				idinfos += "~"+$("#detid"+i).val();
			}
		}

		if(count == 0){
			alert('无调剂设备信息！');
			return;
		}
		
		var mixName = $("#device_mixapp_name").val();
		if(mixName.replace(/^\s+|\s+$/g,"").length == 0){
			alert('请填写调剂申请单名称！');
			return;
		}
		
		var outName = $("#out_org_name").val();
		if(outName.replace(/^\s+|\s+$/g,"").length == 0){
			alert('请选择调剂单位信息！');
			return;
		}
		//给调配单号设置成空
		$("#device_mixapp_no").val("");
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveSelfDisMixFormAllInfoDg.srq?state="+state+"&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
			document.getElementById("form1").submit();
		}
	}
	function refreshData(){
		var retObj;
		var basedatas;
		
		if(device_allapp_id!=null){
			var prosql = "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,";
				prosql += "aad.dev_name as dev_ci_name,";
				prosql += "aad.dev_type as dev_ci_model, ";
				prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
				prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
				prosql += "aad.project_info_no ";
				prosql += "from gms_device_allapp_detail aad ";
				prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
				prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join common_busi_wf_middle wf on aad.device_allapp_id = wf.business_id ";
				prosql += "where wf.proc_status = '3' and aad.device_allapp_id='"+device_allapp_id+"' and aad.bsflag='0' ";
				
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=10000');
			retObj = proqueryRet.datas;
			//回填基本信息
			//$("#project_name").val(basedatas[0].project_name);
			//$("#device_allapp_no").val(basedatas[0].device_allapp_no);
			//$("#device_allapp_name").val(basedatas[0].device_allapp_name);
			//$("#allappdate").val(basedatas[0].allappdate);
			//$("#device_allapp_id").val(basedatas[0].device_allapp_id);
			//$("#appdate").val(basedatas[0].currentdate);	
			$("#project_info_no").val(retObj[0].project_info_no);
		}
		strLen = retObj.length;
		for(var index=0;index<retObj.length;index++){
			var devoutorgName;
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			//innerhtml += "<td width='5%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_allapp_detid+"' checked/></td>";
			innerhtml += "<td>"+(index+1)+"</td>";
			innerhtml += "<td width='8%'>";
			innerhtml += "<input name='detid"+index+"' id='detid"+index+"' value='"+retObj[index].device_allapp_detid+"' type = 'hidden'/>";
			innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' style='line-height:15px' value='"+retObj[index].teamid+"' type='hidden' />";
			innerhtml += "<input name='teamname"+index+"' id='teamname"+index+"' value='"+retObj[index].teamname+"' size='7' type='text' readonly/>";
			innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+retObj[index].team+"' type='hidden'/></td>";			
			innerhtml += "<td width='10%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='10' type='text' readonly/></td>";
			innerhtml += "<td width='10%'><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].dev_ci_model+"' size='10'  type='text' readonly/>";
			innerhtml += "<input name='isdevicecode"+index+"' id='isdevicecode"+index+"' value='"+retObj[index].isdevicecode+"' type='hidden' />";
			innerhtml += "<input name='devcicode"+index+"' id='devcicode"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' /></td>";			
			innerhtml += "<td width='4%'><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='4' type='text' readonly>";
			innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden'></td>";			
			innerhtml += "<td width='5%'><input name='mixappnum"+index+"' id='mixappnum"+index+"' value='"+retObj[index].require_num+"' size='4' type='text' readonly/></td>";
			innerhtml += "<td width='12%'><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
			innerhtml += "<td width='12%'><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "<td width='8%'><input name='purpose"+index+"' id='purpose"+index+"' value='"+retObj[index].purpose+"' size='8' type='text' readonly/></td>";
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(index){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001&orgId=C6000000000001","test","");
		
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割

		var names = strs[0].split(":");
		$("#out_org_name").val(names[1]);
		
		var orgSubId = strs[2].split(":");
		$("#out_org_id").val(orgSubId[1]);
		
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

