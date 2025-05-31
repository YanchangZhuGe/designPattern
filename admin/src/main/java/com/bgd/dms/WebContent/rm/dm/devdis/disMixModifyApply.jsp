<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String devappid = request.getParameter("deviceappid");
	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
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
<title>(自有设备)调剂单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >调配申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_app_no" id="device_app_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="device_mixapp_id" id="device_mixapp_id" type="hidden" value="<%=devappid%>" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >调剂申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_mixapp_no" id="device_mixapp_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
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
	  <fieldset style="margin-left:2px"><legend>调剂明细</legend>
		  <div style="height:240px;overflow:auto">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="5%">选择</td>
					<td class="bt_info_odd" width="12%">设备名称</td>
					<td class="bt_info_even" width="12%">规格型号</td>
					<td class="bt_info_odd" width="6%">单位</td>
					<td class="bt_info_even" width="4%">调配申请数量</td>
					<td class="bt_info_odd" width="4%">已调配数量</td>
					<td class="bt_info_even" width="4%">调剂申请数量</td>
					<td class="bt_info_odd" width="13%">计划进场时间</td>
					<td class="bt_info_even" width="13%">计划离场时间</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
	       </div>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	function submitInfo(state){
		var appnamevalue = $("#device_mixapp_name").val();
		if(appnamevalue == ""){
			alert("请输入调剂申请单名称！");
			return;
		}
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
			var valueinfo = $("#mixappnum"+selectedlines[index]).val();
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
		//给调配单号设置成空
		$("#device_mixapp_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveSelfDisMixFormAllInfo.srq?state="+state+"&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
		document.getElementById("form1").submit();
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById(str+"_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById(str+"_id").value = orgId[1];
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var mixednumVal = parseInt($("#mixappednum"+index).val(),10);
		var applynumVal = parseInt($("#apply_num"+index).val(),10);
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("调配数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(objValue,10)>applynumVal){
				alert("调配数量必须小于等于申请数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+mixednumVal)>applynumVal){
				alert("调配数量必须小于等于未调配数量!");
				obj.value = "";
				return false;
			}
		}
	}
	function refreshData(){
		var devappid;
		var retObj;
		var basedatas;
		if('<%=devappid%>'!=null){
			//回填基本信息
			var str = "select app.device_app_id,app.device_app_no,gp.project_name,t.device_mixapp_no,t.device_mixapp_name,app.app_org_id,"
				+"org.org_abbreviation as app_org_name,t.mix_org_id,mixorg.org_abbreviation as mix_org_name from gms_device_dismixapp t "
				+"left join gp_task_project gp on t.project_info_no = gp.project_info_no left join (gms_device_app app left join comm_org_information "
				+"org on app.app_org_id=org.org_id) on t.device_app_id = app.device_app_id and app.bsflag='0' left join comm_org_information mixorg on t.mix_org_id = mixorg.org_id "
				+"where t.device_mixapp_id='<%=devappid%>'";

			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = proqueryRet.datas;
			devappid = retObj[0].device_app_id;
			if(retObj!=undefined && retObj.length>0){
				$("#device_app_no").val(retObj[0].device_app_no);
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#device_mixapp_no").val(retObj[0].device_mixapp_no);
				$("#device_mixapp_name").val(retObj[0].device_mixapp_name);
				$("#in_org_id").val(retObj[0].app_org_id);
				$("#in_org_name").val(retObj[0].app_org_name);
				$("#out_org_id").val(retObj[0].mix_org_id);
				$("#out_org_name").val(retObj[0].mix_org_name);
				
			}
			//回填明细信息
			var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
				str += "p6.name as jobname,pro.project_name,nvl(tmp.mixed_num, 0) mixed_num,";
				str += "case when appdet.isdevicecode='N' then ci.dev_ci_name else ct.dev_ct_name end as dev_ci_name,";
				str += "case when appdet.isdevicecode='N' then ci.dev_ci_model else '' end as dev_ci_model, ";
				str += "appdet.apply_num,appdet.teamid,appdet.team,appdet.isdevicecode, ";
				str += "appdet.dev_ci_code,appdet.purpose,appdet.employee_id,emp.employee_name, ";
				str += "appdet.plan_start_date,appdet.plan_end_date  ";
				str += "from gms_device_app_detail appdet ";
				str += "left join gms_device_app devapp on appdet.device_app_id = devapp.device_app_id and devapp.bsflag = '0' ";
				str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
				str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
				str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
				str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
				str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
				str += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
				str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
				str += "left join (select device_app_detid, sum(assign_num) as mixed_num from gms_device_appmix_main amm where amm.bsflag = '0' group by device_app_detid) tmp on tmp.device_app_detid = appdet.device_app_detid ";
				str += "where devapp.device_app_id = '"+devappid+"' and appdet.bsflag='0' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = proqueryRet.datas;
		}
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_app_detid+"' /></td>";
				innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='20' type='text' readonly/>";
				innerhtml += "<input name='isdevicecode"+index+"' id='isdevicecode"+index+"' value='"+retObj[index].isdevicecode+"' type='hidden' />";
				innerhtml += "<input name='devcicode"+index+"' id='devcicode"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' /></td>";
				innerhtml += "<td><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].dev_ci_model+"' size='20' type='text' readonly/></td>";
				innerhtml += "<td><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unitname+"' size='5' type='text' readonly/>";
				innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden' /></td>";
				
				innerhtml += "<td><input name='apply_num"+index+"' id='apply_num"+index+"' style='line-height:15px' value='"+retObj[index].apply_num+"' size='6' type='text' /></td>";
				innerhtml += "<td><input name='mixappednum"+index+"' id='mixappednum"+index+"' value='"+retObj[index].mixed_num+"' size='6'  type='text' readonly/></td>";
				innerhtml += "<td><input name='mixappnum"+index+"' id='mixappnum"+index+"' detindex='"+index+"' value='' onkeyup='checkAssignNum(this)' size='6' type='text' />";
				
				innerhtml += "<td><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='13' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
				innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='13' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
				
					
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
