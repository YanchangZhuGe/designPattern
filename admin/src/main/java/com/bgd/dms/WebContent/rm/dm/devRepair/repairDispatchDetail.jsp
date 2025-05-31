<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String id = request.getParameter("id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script> 
<title>设备派工维修界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
	<form name="form1" id="form1" method="post" action="">
		<div id="new_table_box" style="width: 98%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 95%">
					<fieldset style="margin: 2px:padding:2px;">
						<legend>送修申请基本信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item4">送修单号:</td>
								<td class="inquire_form4" colspan="3"><input
									name="repair_form_code" id="repair_form_code"
									class="input_width" type="text" value="保存后自动生成.."
									style="color: #DDDDDD;" readonly /></td>
							</tr>
							<tr>
								<td class="inquire_item4">送修单名称:</td>
								<td class="inquire_form4"><input name="repair_form_name"
									id="repair_form_name" class="input_width" type="text" value="" readonly/>
									<input name="id"
									id="id" class="input_width" type="hidden" value="" />
								</td>
								<td class="inquire_item4">申请日期:</td>
								<td class="inquire_form4"><input name="apply_date"
									id="apply_date" class="input_width" type="text" value=""
									readonly /></td>
							</tr>
							<tr>
								<td class="inquire_item4">送修单位:</td>
								<td class="inquire_form4"><input id="req_comp_name"
									name="req_comp_name" class="input_width" type="text" readonly/>
									 <input id="req_comp"
									name="req_comp" class="" type="hidden" /></td>
								<td class="inquire_item4">送修人:</td>
								<td class="inquire_form4"><input name="req_user_name"
									id="req_user_name" class="input_width" type="text" value="" readonly/></td>
							</tr>
							<tr>
								<td class="inquire_item4">送修日期:</td>
								<td class="inquire_form4" colspan="1"><input
									name="req_date" id="req_date" class="input_width" type="text"
									value="" readonly /> </td>
								<td class="inquire_item4">所属项目:</td>
								<td class="inquire_form4" colspan="1">
								<input name="project_name"
									id="project_name" class="input_width" type="text" value=""  readonly/>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">维修单位:</td>
								<td class="inquire_form4"><input id="todo_comp_name"
									name=todo_comp_name class="input_width" type="text" readonly/>
									<input
									id="todo_comp" name="todo_comp" class="" type="hidden" /></td>

							</tr>
						</table>
					</fieldset>
					<fieldset>
						<legend>备注</legend>
						<table id="table2" width="100%" border="0" cellspacing="0"
							cellpadding="0" class="tab_line_height">
							<tr>
								<td><textarea id='remark' name='remark' rows="5" cols="80" readonly></textarea>
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset style="margin-left: 2px">
						<legend>设备送修明细</legend>
						 
						<div>
							<table width="99%" border="0" height="30" cellspacing="0" cellpadding="0">
								<tr>
									<td id ="teamtd" align="right"></td>
									<td>
									<!--  2014年3月28日 换成机构树  修改
										<auth:ListButton functionId="" css="xg"
										event="onclick='asignTeam()'" title="批量设定班组"></auth:ListButton>
										 -->
										<!-- 
									<auth:ListButton functionId="" css="sc"
										event="onclick='delRows()'" title="删除设备"></auth:ListButton>
										 -->
								</tr>
							</table>
						</div>
							<div style="overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<!-- -->
									<td width="4%" class="bt_info_odd"><input type='checkbox'
										id='checkinfo' name='checkinfo' /></td>
									<td width="9%" class="bt_info_odd">设备名称</td>
									<td width="9%" class="bt_info_even">规格型号</td>
									<td width="9%" class="bt_info_odd">实物标识号</td>
									<td width="9%" class="bt_info_odd">故障类别</td>
									<td width="9%" class="bt_info_even">故障现象</td>
									<td width="9%" class="bt_info_odd">设备状态</td>
									<td width="9%" class="bt_info_odd">派工状态</td>
									<td width="9%" class="bt_info_even">班组</td>
									<td width="9%" class="bt_info_odd">接收状态</td>
									<td width="9%" class="bt_info_even">备注</td>
								</tr>
							</table>
							<div style="height: 190px; overflow: auto;">
								<table style="width: 97.9%" border="0" cellspacing="0"
									cellpadding="0" class="tab_line_height">
									<tbody id="processtable0" name="processtable0">
									</tbody>
								</table>
							</div>
						</div>
					</fieldset>
				</div>
				<div id="oper_div">
					<span class="bc_btn"><a id="allSub" href="#" title="保存" onclick="submitInfo()"></a></span>
					<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
				</div>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">
var projectType="<%=projectType%>";
function submitInfo(){
	//保留的行信息
	var count = 0;
	var line_infos;
	var seqinfo;
	$("input[type='checkbox'][name='key_id']").each(function(){
		//if(this.checked){
			if(count == 0){
				line_infos = this.id;
				seqinfo = this.seqinfo;
			}else{
				line_infos += "~"+this.id;
				seqinfo += "~"+this.seqinfo;
			}
			count++;
		//}
	});
	if(count == 0){
		alert('请选择需要派工的明细信息！');
		return;
	}
	var selectedlines = line_infos.split("~");
	/***
	var wronglineinfos = "";
	for(var index=0;index<selectedlines.length;index++){
		var valueinfo = $("#neednum"+selectedlines[index]).val();
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
	****/
	document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devRepair/repairDispatchDetail.srq?count="+count+"&line_infos="+line_infos+"&seqinfo="+seqinfo;
	document.getElementById("form1").submit();
}
	$().ready(function(){
		$("#checkinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name='key_id']").attr('checked',checkvalue);
		});
	});
	$().ready(function(){
		$("#hirechecked").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
		});
	});
	/***
	$().ready(function getTeam(selval){
	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","projectType="+selval);
	var applypost_str='<option value="">请选择</option>';
	if(null==applyTeamList.detailInfo)return;
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		if(templateMap.value == selval || templateMap.label == selval){
			applypost_str+='<option value="'+templateMap.value+'" selected="selected" >'+templateMap.label+'</option>';			
		}else{
			applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
		}
	}
	return applypost_str;
	});
	$().ready(function(){
		var str = '<select   id="repair_team_sel"  name="repair_team_sel" >'+getTeam('')+'</select>';
		$("#teamtd").html(str);
		});
	****/
	$().ready(function(){
	var str = '<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="showOrgTreePage(\'repair_team\')" />';
	$("#teamtd").html(str);
	}
	);
	function showDevPage(){
		var returnValue = window.showModalDialog('<%=contextPath%>/rm/dm/devRepair/selectProject.jsp?backUrl=/rm/dm/devRepair/selectProject.jsp&action=view',"test",'dialogWidth=800px;dialogHeight=450px');
		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var name = strs[0].split(":");
		var id = strs[1].split(":");
		var checkText = name[1];
		 if(checkText=='')checkText='';
		 var checkValue=id[1];
		 $("input[type='checkbox'][name='key_id']").each(function(){
				if(this.checked){
					var index = this.seqinfo;
					$("#repair_team_code"+index).val(checkValue);
					$("#repair_team"+index).val(checkText);
				}
			});
	};
	/**
	$().ready(function asignTeam(){
		 var checkText=$("#repair_team_sel").find("option:selected").text();
		 if(checkText=='请选择')checkText='';
		 var checkValue=$("#repair_team_sel").val();
		 $("input[type='checkbox'][name='key_id']").each(function(){
				if(this.checked){
					var index = this.seqinfo;
					$("#repair_team_code"+index).val(checkValue);
					$("#repair_team"+index).val(checkText);
				}
			});
		});
	**/
	/****
	$().ready(function(){
		$("#repair_team_sel").click(function(){
			var checkText=$("#repair_team_sel").find("option:selected").text();
			 if(checkText=='请选择')checkText='';
			 var checkValue=$("#repair_team_sel").val();
			 $("input[type='checkbox'][name='repair_id']").each(function(){
					if(this.checked){
						var index = this.seqinfo;
						$("#repair_team_code"+index).val(checkValue);
						$("#repair_team"+index).val(checkText);
					}
				});
		});
	});
	****/
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
	
	function refreshData(){
		var sql = "select rep.*,";
		sql += " pro.project_name as project_name, REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME,TODOORG.ORG_ABBREVIATION AS TODO_COMP_NAME,"; 
		sql += " decode(rep.status, 0, '编制', 1, '生效' ，2, '作废', '无效状态') as status_desc,EMP.EMPLOYEE_NAME as req_user_name  "; 
		sql += "   from GMS_DEVICE_COLL_REPAIRFORM rep, gp_task_project pro,COMM_ORG_INFORMATION REQORG, COMM_ORG_INFORMATION TODOORG,COMM_HUMAN_EMPLOYEE EMP  "; 
		sql += "  where  rep.OWN_PROJECT = pro.project_info_no(+)  "; 
		sql += "  AND REP.REQ_COMP =  REQORG.ORG_ID(+) "; 
		sql += "  AND REP.TODO_COMP = TODOORG.ORG_ID(+)  "; 
		sql += "  AND REP.req_user = EMP.EMPLOYEE_ID(+)  ";
		sql += " and rep.id = '<%=id%>'";
		
		var repairQueryRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
		var repairObj = repairQueryRet.datas;
		$("#repair_form_code").val(repairObj[0].repair_form_code);
		$("#repair_form_name").val(repairObj[0].repair_form_name);
		$("#apply_date").val(repairObj[0].apply_date);
		$("#req_comp").val(repairObj[0].req_comp);
		$("#todo_comp").val(repairObj[0].req_comp);
		$("#req_user_name").val(repairObj[0].req_user_name);
		$("#req_date").val(repairObj[0].req_date);
		$("#id").val(repairObj[0].id);
		$("#remark").val(repairObj[0].remark);
		$("#project_name").val(repairObj[0].project_name);
		$("#req_comp_name").val(repairObj[0].req_comp_name);
		$("#todo_comp_name").val(repairObj[0].todo_comp_name);
		var querySql =
			"SELECT ACC.DEV_NAME AS DEV_NAME,\n" +
			"       ACC.DEV_TYPE AS DEV_TYPE,\n" + 
			"       ACC.DEV_MODEL AS DEV_MODEL,\n" + 
			"       DECODE(SUB.ERROR_TYPE, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORTYPE)%>) AS ERROR_TYPE,\n" + 
			"       DECODE(SUB.ERROR_DESC,\n" + 
			"        <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORDESC)%>) AS ERROR_DESC,\n" + 
			"       ACC.DEV_SIGN AS DEV_SIGN,\n" + 
			"       DECODE(SUB.DEV_STATUS,\n" + 
			"              <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_DEVSTATUS)%>) AS DEV_STATUS,\n" + 
			"       SUB.REMARK AS REMARK,\n" + 
			"       DECODE(AGN.ASSIGNSTATE,\n" + 
			"              '',\n" + 
			"              '待派工',\n" + 
			"              '0',\n" + 
			"              '待派工',\n" + 
			"              '1',\n" + 
			"              '已派工'\n" + 
			"              ) AS ASSIGN_STATUS,\n" + 
			"       DECODE(AGN.RECIEVESTATE,\n" + 
			"              '0',\n" + 
			"              '待接收',\n" + 
			"              '1',\n" + 
			"              '已接收',\n" + 
			"              '2',\n" + 
			"              '拒接收'\n" + 
			"              ,'') AS RECIEVESTATE_DESC,\n" + 
			"				AGN.* \n" +
			"  FROM GMS_DEVICE_COLL_REPAIR_SUB    SUB,\n" + 
			"       GMS_DEVICE_ACCOUNT_B          ACC,\n" + 
			"       GMS_DEVICE_COLL_REPAIRFORM    SEND,\n" + 
			"       GMS_DEVICE_COLL_REPAIR_ASSIGN AGN,\n" + 
			"       GMS_DEVICE_COLL_REPAIR_REC REC\n" + 
			" WHERE SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + 
			"   AND SUB.REPAIRFORM_ID = SEND.ID(+)\n" + 
			"   AND SUB.ID(+) = AGN.REPAIR_ID\n" + 
			"   AND AGN.RECIEVE_ID(+) = REC.ID\n" + 
			"   AND SUB.BSFLAG = '0'\n" + 
			"   AND ACC.BSFLAG = '0'\n" + 
			"   AND (AGN.BSFLAG = '0'or AGN.BSFLAG is null)\n" + 
			"   AND (AGN.ENABLEFLAG = '0' or AGN.ENABLEFLAG is null)" +
			"   AND REC.REC_STATUS = '1' \n" + 
			"   AND SEND.ID = '<%=id%>'";
		var dataret = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
		var retObj = dataret.datas;
		for(var index=0;index<retObj.length;index++){
			//$("#device_hireapp_id").val(retObj[0].device_hireapp_id);
			//$("#device_hireapp_no").val(retObj[0].device_hireapp_no);
			//$("#device_hireapp_name").val(retObj[0].device_hireapp_name);
			//$("#appdate").val(retObj[0].appdate);
			//动态新增表格
			var status = retObj[index].assign_status;
			var recstatus = retObj[index].recievestate_desc;
			//已经接收的无法派工
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			//innerhtml += "<td><input type='checkbox' name='idinfo' id='"+index+"' checked/></td>";
			//innerhtml += "<td>"+(index+1)+"</td>";
			if(status == ''||status == '待派工'){
				innerhtml += "<td width='4%' ><input type='checkbox' name='key_id' seqinfo='"+index+"' id='"+retObj[index].id+"'/></td>";
			}else if(recstatus == '拒接收'){
				innerhtml += "<td width='4%' ><input type='checkbox' name='key_id' seqinfo='"+index+"' id='"+retObj[index].id+"'/></td>";
			}else{
				innerhtml += "<td></td>";
			}
			innerhtml += "<td width='9%'><input name='dev_name"+index+"' id='dev_name"+index+"' style='line-height:15px' value='"+retObj[index].dev_name+"' size='6' type='text' disabled/>";
			innerhtml += "</td>";
			innerhtml += "<td width='9%'><input name='dev_model"+index+"' id='dev_model"+index+"' value='"+retObj[index].dev_model+"' size='8'  type='text' disabled/></td>";
			innerhtml += "<td width='9%'><input name='dev_sign"+index+"' id='dev_sign"+index+"' value='"+retObj[index].dev_sign+"' size='8'  type='text' disabled/></td>";
			innerhtml += "<td width='9%'><input name='error_type"+index+"' id='error_type"+index+"' value='"+retObj[index].error_type+"' size='6'  type='text' disabled/></td>";
			innerhtml += "<td width='9%'><input name='error_desc"+index+"' id='error_desc"+index+"' value='"+retObj[index].error_desc+"' size='7'  type='text' disabled/></td>";
			innerhtml += "<td width='9%'><input name='dev_status"+index+"' id='dev_status"+index+"' value='"+retObj[index].dev_status+"' size='6'  type='text' disabled/></td>";
			innerhtml += "<td width='9%'><input name='assign_status"+index+"' id='assign_status"+index+"' value='"+retObj[index].assign_status+"' size='6'  type='text' disabled/>";
			innerhtml += "<input name='repair_team_code"+index+"' id='repair_team_code"+index+"' value='"+retObj[index].repair_team_code+"' size='6'  type='hidden' />";
			innerhtml += "<input name='repair_id"+index+"' id='repair_id"+index+"' value='"+retObj[index].repair_id+"' size='8'  type='hidden' /></td>";
			innerhtml += "<td width='9%'><input name='repair_team"+index+"' id='repair_team"+index+"' value='"+retObj[index].repair_team+"' size='8'  type='text' readonly/></td>";
			innerhtml += "<td width='9%'><input name='recievestate_desc"+index+"' id='recievestate_desc"+index+"' value='"+retObj[index].recievestate_desc+"' size='6'  type='text' disabled/>";
			innerhtml += "<td width='9%'><input name='remark"+index+"' id='remark"+index+"' value='"+retObj[index].remark+"' size='8'  type='text' disabled/></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
			//查询公共代码，并且回填到界面的单位中
			/****
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
			var unitObj = unitRet.datas;
			var optionhtml = "";
			for(var i=0;i<unitObj.length;i++){
				optionhtml +=  "<option name='unitcode' id='unitcode"+i+"' value='"+unitObj[i].coding_code_id+"'>"+unitObj[i].coding_name+"</option>";
			}
			$("#unit"+index).append(optionhtml);
			****/
			}
		 
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
		//刷新 显示隐藏接收按钮
		var querySql = "SELECT REC_STATUS FROM GMS_DEVICE_COLL_REPAIR_REC T WHERE T.REPARE_ID = '<%=id%>'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var stateflag = false;
		}
function addRows(value){
	
			tr_id = $("#processtable0>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//动态新增表格
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
			innerhtml += "<td width='17%'><input name='devicename"+tr_id+"' id='devicename"+tr_id+"' style='line-height:15px' value='' size='15' type='text' />";
			innerhtml += "</td>";
			innerhtml += "<td width='16%'><input name='devicetype"+tr_id+"' id='devicetype"+tr_id+"' value='' size='16'  type='text' /></td>";
			innerhtml += "<td width='7%'><select name='unit"+tr_id+"' id='unit"+tr_id+"' /></select></td>";
			innerhtml += "<td width='7%'><input name='neednum"+tr_id+"' id='neednum"+tr_id+"' value='' size='4' type='text' onkeyup='checkDevrental(this)'/>";
			innerhtml += "<td width='13%'><input value='' name='startdate"+tr_id+"' id='startdate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+tr_id+",tributton2"+tr_id+");'/></td>";
			innerhtml += "<td width='13%'><input value='' name='enddate"+tr_id+"' id='enddate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+tr_id+",tributton3"+tr_id+");'/></td>";
			innerhtml += "<td width='11%'><input name='purpose"+tr_id+"' value='' size='10' type='text'/></td>";
			innerhtml += "</tr>";
			
			$("#processtable0").append(innerhtml);
			//查询公共代码，并且回填到界面的单位中
			var teamObj;
			var teamSql = "select t.coding_code_id as value,t.coding_name as label from comm_coding_sort_detail t ";
				teamSql += "where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 ";
				if(projectType != "5000100004000000009" && projectType != "5000100004000000006"){
					//除了深海项目和综合物化探项目类型班组都使用陆地项目班组
					teamSql += "and t.coding_mnemonic_id='5000100004000000001' ";
				}else{
					teamSql += "and t.coding_mnemonic_id='"+projectType+"' ";
				}
				teamSql += "order by t.coding_show_id ";
			var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
			teamObj = teamRet.datas;
			var teamoptionhtml = "";
			for(var index=0;index<teamObj.length;index++){
				teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
			}
			$("#team"+tr_id).append(teamoptionhtml);
			//查询公共代码，并且回填到界面的单位中
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'
				+ appConfig.queryListAction, 'querySql=' + unitSql
				+ '&pageSize=1000');
		retObj = unitRet.datas;
		var optionhtml = "";
		for ( var index = 0; index < retObj.length; index++) {
			optionhtml += "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"
					+ retObj[index].coding_name + "</option>";
		}
		$("#unit" + tr_id).append(optionhtml);

		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	};
	function delRows() {
		$("input[name='idinfo']").each(function() {
			if (this.checked == true) {
				$('#tr' + this.id, "#processtable0").remove();
			}
		});

		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	};
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001",
						"test", "");

		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		//document.getElementById(str + '_name').value = names[1];
		var orgId = strs[1].split(":");
		//document.getElementById(str).value = orgId[1];
		var checkText = names[1];
		 if(checkText=='')checkText='';
		 var checkValue=orgId[1];
		 $("input[type='checkbox'][name='key_id']").each(function(){
				if(this.checked){
					var index = this.seqinfo;
					$("#repair_team_code"+index).val(checkValue);
					$("#repair_team"+index).val(checkText);
					this.checked = false;
				}
			});
	};
	</script>
</html>

