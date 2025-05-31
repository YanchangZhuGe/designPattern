<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%> 
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String deviceappdetid = request.getParameter("deviceappdetid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	String orgId= user.getOrgId();	
	String projectInfoNo = request.getParameter("projectInfoNo");
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
      <fieldset style="margin-left:2px"><legend >外租申请明细</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="pro_name" name="pro_name" class="input_width" type="text" readonly/>
				<input id="project_info_no" name="project_info_no" class="input_width" type="hidden" value='<%=projectInfoNo%>'/>
				<input id="deviceappdetid" name="deviceappdetid" class="input_width" type="hidden" value='<%=deviceappdetid%>'/>
			</td>
			<td class="inquire_item6">班组</td>
			<td class="inquire_form6">
				<input id="teamname" name="teamname" class="input_width" type="text" readonly/>
				<input id="team" name="team" class="input_width" type="hidden" readonly/>
			</td>
		  </tr>
		  <tr>
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_ci_code" name="dev_ci_code" type="hidden"/>
					<input id="unitinfo" name="unitinfo" type="hidden"/>
				<input id="isdevicecode" name="isdevicecode" type="hidden"/>
				<input id="dev_ci_name" name="dev_ci_name" class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6">
				<input id="dev_ci_model" name="dev_ci_model" class="input_width" type="text" readonly/>
			</td>
		  </tr>
			<tr>
			<td class="inquire_item6">计划开始时间</td>
			<td class="inquire_form6"><input name="plan_start_date" id="plan_start_date" class="input_width" type="text" readonly /></td>
			<td class="inquire_item6">计划结束时间</td>
			<td class="inquire_form6"><input name="plan_end_date" id="plan_end_date" class="input_width" type="text" readonly /></td>
		  </tr>
		  <tr>
			<td class="inquire_item6">审批数量</td>
			<td class="inquire_form6"><input name="applynum" id="applynum" class="input_width" type="text" readonly /></td>
			
			<td class="inquire_item6">已验收数量</td>
			<td class="inquire_form6"><input name="mixnum" id="mixnum" class="input_width" type="text" readonly /></td>
		  </tr>
		
		  
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>外租设备明细</legend>
		  <div style="height:210px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="10%">设备名称</td>
					<td class="bt_info_even" width="10%">规格型号</td>
					<td class="bt_info_even" width="15%">接收数量</td>
					<td class="bt_info_odd" width="20%">预计进场时间</td>
					<td class="bt_info_even" width="20%">预计离场时间</td>
					<td class="bt_info_odd" width="20%">实际进场时间</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
	       </div>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	function submitInfo(){
		//保留的行信息
		var count = $("#processtable>tr").size();
		var wronglineinfos = 0;
		for(var index=0;index<count;index++){
			var detdev_ci_code = $("#detdev_ci_code"+index).val();
			var realstartdate = $("#realstartdate"+index).val();
			var mix_num = $("#mix_num"+index).val();
			if(detdev_ci_code != "" && realstartdate !=""&& mix_num !=""){
				wronglineinfos = wronglineinfos+1;
			}
		}
		if(wronglineinfos>0){
			if(confirm("确认提交？")){
				document.getElementById("submitButton").onclick = "";
				document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveHireFillDetailJBQInfo.srq?count="+count+"&checknum="+wronglineinfos;
				document.getElementById("form1").submit();
			}
		}else{
			alert("请选择设备规格型号，填写实际进场日期及接收数量");
		}

	}
	function refreshData(){		
		var retObj;
		var basedatas;
		var str = "select pro.project_name,teamsd.coding_name as teamname,hd.isdevicecode,";
			str += "hd.dev_name as dev_ci_name,";
			str += "hd.dev_type as dev_ci_model, ";
			str += " hd.unitinfo, ";
			str += " hd.rentname, ";
			str += "team,device_app_detid,hd.dev_ci_code,apply_num,mix_num,plan_start_date,plan_end_date,";
			str += "ha.org_id,org.org_name,ha.app_org_id,apporg.org_name as app_org_name,ha.org_subjection_id ";
			str += "from gms_device_hireapp_detail hd ";
			str += "left join gp_task_project pro on pro.project_info_no=hd.project_info_no ";
			str += "left join gms_device_codeinfo ci on hd.dev_ci_code=ci.dev_ci_code ";
			str += "left join gms_device_codetype ct on hd.dev_ci_code=ct.dev_ct_code ";
			str += "left join comm_coding_sort_detail teamsd on hd.team = teamsd.coding_code_id ";
			str += "left join gms_device_hireapp ha on hd.device_hireapp_id = ha.device_hireapp_id ";
			str += "left join comm_org_information org on org.org_id=ha.org_id ";
			str += "left join comm_org_information apporg on apporg.org_id=ha.app_org_id ";
			str += "where hd.bsflag='0' and hd.device_app_detid='<%= deviceappdetid %>' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		basedatas = queryRet.datas;
		
		if(basedatas == undefined || basedatas.length == 0 )
			return;
		//先回填基本信息
		$("#pro_name").val(basedatas[0].project_name);
		$("#unitinfo").val(basedatas[0].unitinfo);
		$("#teamname").val(basedatas[0].teamname);
		$("#team").val(basedatas[0].team);
		$("#dev_ci_code").val(basedatas[0].dev_ci_code);
		$("#isdevicecode").val(basedatas[0].isdevicecode);
		$("#dev_ci_name").val(basedatas[0].dev_ci_name);
		$("#dev_ci_model").val(basedatas[0].dev_ci_model);
		$("#plan_start_date").val(basedatas[0].plan_start_date);
		$("#plan_end_date").val(basedatas[0].plan_end_date);
		$("#applynum").val(basedatas[0].apply_num);
		$("#mixnum").val(basedatas[0].mix_num);


		var applynum = basedatas[0].apply_num;
		var mixnum = basedatas[0].mix_num;
		var dev_ci_name = basedatas[0].dev_ci_name;
		var dev_ci_model = basedatas[0].dev_ci_model;
		var dev_ci_code = basedatas[0].dev_ci_code;
		var plan_start_date = basedatas[0].plan_start_date;
		var plan_end_date = basedatas[0].plan_end_date;
		var team = basedatas[0].team;
		var org_id = basedatas[0].org_id;
		var org_name = basedatas[0].org_name;
		var org_subjection_id = basedatas[0].org_subjection_id;
		var app_org_id = basedatas[0].app_org_id;
		var app_org_name = basedatas[0].app_org_name;
		var rentname = basedatas[0].rentname;
		var isdevicecode = basedatas[0].isdevicecode;
		var colnum = applynum - mixnum;
		
		//动态设置表的显示
		for(var index=0;index<1;index++){
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			innerhtml += "<td><input name='detdev_ci_name"+index+"' id='detdev_ci_name"+index+"' style='line-height:15px' value='"+dev_ci_name+"' size='12' type='text' />";
			innerhtml += "<input name='account_stat"+index+"' id='account_stat"+index+"' value='0110000013000000005' type='hidden' />";
			innerhtml += "<input name='detisdevicecode"+index+"' id='detisdevicecode"+index+"' value='"+isdevicecode+"' type='hidden' />";
			innerhtml += "<input name='detdev_ci_code"+index+"' id='detdev_ci_code"+index+"' value='"+dev_ci_code+"' type='hidden' /></td>";
			innerhtml += "<td><input name='detdev_ci_model"+index+"' id='detdev_ci_model"+index+"' value='"+dev_ci_model+"' size='15' type='text' /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+index+")' />";
			innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+team+"' type='hidden'/></td>";
			innerhtml += "<td><input name='mix_num"+index+"' id='mix_num"+index+"' style='line-height:15px' value='' size='10' type='text'  onkeyup='checkAssignNum(this)'/></td>";
			innerhtml += "<td><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+plan_start_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
			innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+plan_end_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "<td><input name='realstartdate"+index+"' id='realstartdate"+index+"' style='line-height:15px' value='' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton4"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(realstartdate"+index+",tributton4"+index+");'/></td>";
			innerhtml += "<td><input name='ownorgname"+index+"' id='ownorgname"+index+"' value='"+rentname+"' size='18'   type='hidden' /> ";
			innerhtml += "<input name='ownorgid"+index+"' id='ownorgid"+index+"' value='"+org_id+"' type='hidden' readonly/>";
			innerhtml += "<input name='orgsubjectionid"+index+"' id='orgsubjectionid"+index+"' value='"+org_subjection_id+"' type='hidden' /></td>";
			innerhtml += "<input name='usageorgid"+index+"' id='usageorgid"+index+"' value='"+app_org_id+"' type='hidden' /></td>";
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	function showOrgPage(index){
		var obj = new Object();
		window.showModalDialog("<%=contextPath%>/common/selectOrg.jsp",obj);
		if(obj.value!=undefined){
			$("#ownorgname"+index).val(obj.value);
			$("#ownorgid"+index).val(obj.fkValue);
		}
	}
	function showDevCodePage(index){
		var obj = new Object();
		var dev_ci_code = $("#dev_ci_code").val();
		var returnval = window.showModalDialog("<%=contextPath%>/rm/dm/collectTree/collectJBQTreeManager.jsp?ctxmenu=false&inline=true",obj,"dialogWidth=300px;dialogHeight=400px");
		//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号
		if(returnval!=undefined){
			$("#detdev_ci_name"+index).val(returnval.dev_name);
			$("#detdev_ci_model"+index).val(returnval.dev_model);
			$("#detdev_ci_code"+index).val(returnval.device_id);
			$("#detisdevicecode"+index).val("N");
		}
	}
	function checkDevrental(obj){
		var value = obj.value;
		var re = /^(?:[1-9][0-9]*(?:\.[0-9]{0,2})?)$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("必须为数字!");
			obj.value = "";
        	return false;
		}
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var neednumval = parseInt($("#mixnum").val(),10);
		var applyednumval = parseInt($("#applynum").val(),10);
		var value = obj.value;
		var noneddnum=applyednumval-neednumval;
		var re = /^\+?[1-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("接收数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(value,10)>applyednumval){
				alert("接收数量必须小于等于审批数量!");
				obj.value = "";
				return false;
			}else if(parseInt(value,10)>noneddnum){
				alert("接收数量必须小于等于未接收数量!");
				obj.value = "";
				return false;
			}
		}
	}
</script>
</html>

