<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%@taglib prefix="devselect" uri="devselect"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String id = request.getParameter("id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备送修修改界面</title>
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
									id="repair_form_name" class="input_width" type="text" value="" />
									<input name="id"
									id="id" class="input_width" type="hidden" value="" />
									<input name="status"
									id="status" class="input_width" type="hidden" value="" />
								</td>
								<td class="inquire_item4">申请日期:</td>
								<td class="inquire_form4"><input name="apply_date"
									id="apply_date" class="input_width" type="text" value=""
									readonly /> <img src='<%=contextPath%>/images/calendar.gif'
									id='tributton1' width='16' height='16' style='cursor: hand;'
									onmouseover='calDateSelector(apply_date,tributton1);' /></td>
							</tr>
							<tr>
								<td class="inquire_item4">送修单位:</td>
								<td class="inquire_form4"><input id="req_comp_name"
									name="req_comp_name" class="input_width" type="text" /> 
									<!-- 
									<img
									src="<%=contextPath%>/images/magnifier.gif" width="16"
									height="16" style="cursor: hand;"
									onclick="showOrgTreePage('req_comp')" /> 
									 --><input id="req_comp"
									name="req_comp" class="" type="hidden" /></td>
								<td class="inquire_item4">送修人:</td>
								<td class="inquire_form4">
								<input
									name="req_user_name" id="req_user_name" class="input_width"
									type="text" value="" readonly /> <input name="req_user"
									id="req_user" class="input_width" type="hidden" value="" />
									<img src="<%=contextPath%>/images/magnifier.gif" width="16"
									height="16" style="cursor: hand;" onclick="showPersonPage()" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">送修日期:</td>
								<td class="inquire_form4" colspan="1"><input
									name="req_date" id="req_date" class="input_width" type="text"
									value="" readonly /> <img
									src='<%=contextPath%>/images/calendar.gif' id='tributton2'
									width='16' height='16' style='cursor: hand;'
									onmouseover='calDateSelector(req_date,tributton2);' /></td>
								<td class="inquire_item4">所属项目:</td>
								<td class="inquire_form4" colspan="1">
								<input
									name="project_name" id="project_name" class="input_width"
									type="text" value="" readonly /> <input name="own_project"
									id="own_project" class="input_width" type="hidden" value="" />
									<img src="<%=contextPath%>/images/magnifier.gif" width="16"
									height="16" style="cursor: hand;" onclick="showDevPage()" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">维修单位:</td>
								<td class="inquire_form4"><input id="todo_comp_name"
									name=todo_comp_name class="input_width" type="text" /> <img
									src="<%=contextPath%>/images/magnifier.gif" width="16"
									height="16" style="cursor: hand;"
									onclick="showOrgTreePage('todo_comp')" /> <input
									id="todo_comp" name="todo_comp" class="" type="hidden" /></td>

							</tr>
						</table>
					</fieldset>
					<fieldset>
						<legend>备注</legend>
						<table id="table2" width="100%" border="0" cellspacing="0"
							cellpadding="0" class="tab_line_height">
							<tr>
								<td><textarea id='remark' name='remark' rows="5" cols="74"></textarea>
								</td>
							</tr>
						</table>
					</fieldset>
					<div style="overflow: auto">
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr align="right">
								<td style="width: 90%"></td>
								<td><span class="zj"><a href="#" id="addProcess"
										name="addProcess"></a></span></td>
								<td><span class="sc"><a href="#" id="delProcess"
										name="delProcess"></a></span></td>
								<td style="width: 1%"></td>
							</tr>
						</table>
					</div>
					<fieldset style="margin-left: 2px">
						<legend>设备送修明细</legend>
						<div style="overflow: auto">
							<table style="width: 97.9%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td width="4%" class="bt_info_odd"><input type='checkbox'
										id='collbackinfo' name='collbackinfo' /></td>
									<td width="13%" class="bt_info_even">设备名称</td>
									<td width="17%"  class="bt_info_odd">规格型号</td>
									<td width="13%" class="bt_info_even">实物标志号</td>
									<td width="13%" class="bt_info_even">故障类别</td>
									<td width="13%" class="bt_info_odd">故障现象</td>
									<td width="13%" class="bt_info_odd">备注</td>
								</tr>
							</table>
							<div style="height: 190px; overflow: auto;">
								<table style="width: 97.9%" border="0" cellspacing="0"
									cellpadding="0" class="tab_line_height">
								<tbody id="detaillist" name="detaillist" >
								</tbody>
								</table>
							</div>
						</div>
					</fieldset>
				</div>
				<div id="oper_div">
					<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
					<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
				</div>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript"> 
$().ready(function(){
	$("#collbackinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name='idinfo']").attr('checked',checkvalue);
	});
});
	function submitInfo(){
		var count = 0;
		var line_infos;
		var seqinfo;
		$("input[type='checkbox'][name='idinfo']").each(function(){
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
		var begin = 1;
		var flag = true;
		$("[name^=error_type]").each(function(){
			var valueinfo = this.value;
			if(valueinfo == ""){
				alert("请设置第"+begin+"行的故障类别!");
				flag = false;
				return false;
			}
			begin++;
		});
		if(!flag){
			return;
		}
		var begin2 = 1;
		var flag2 = true;
		$("[name^=error_desc]").each(function(){
			var valueinfo = this.value;
			if(valueinfo == ""){
				alert("请设置第"+begin2+"行的故障现象!");
				flag2 = false;
				return false;
			}
			begin2++;
		});
		if(!flag2){
			return;
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devRepair/repairNewApply.srq?count="+count+"&line_infos="+line_infos+"&seqinfo="+seqinfo;
		document.getElementById("form1").submit();
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
	function refreshData(){
		var sql = "select rep.*,";
		sql += " pro.project_name as project_name, REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME,TODOORG.ORG_ABBREVIATION AS TODO_COMP_NAME,"; 
		sql += " decode(rep.status, 0, '编制', 1, '生效' ，2, '作废', '无效状态') as status_desc,EMP.EMPLOYEE_NAME as req_user_name "; 
		sql += "   from GMS_DEVICE_COLL_REPAIRFORM rep, gp_task_project pro,COMM_ORG_INFORMATION REQORG, COMM_ORG_INFORMATION TODOORG,COMM_HUMAN_EMPLOYEE EMP "; 
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
		$("#todo_comp").val(repairObj[0].todo_comp);
		$("#req_user_name").val(repairObj[0].req_user_name);
		$("#req_user").val(repairObj[0].req_user);
		$("#req_date").val(repairObj[0].req_date);
		$("#id").val(repairObj[0].id);
		$("#status").val(repairObj[0].status);
		$("#remark").val(repairObj[0].remark);
		$("#project_name").val(repairObj[0].project_name);
		$("#own_project").val(repairObj[0].own_project);
		$("#req_comp_name").val(repairObj[0].req_comp_name);
		$("#todo_comp_name").val(repairObj[0].todo_comp_name);
		var querySql =
			"SELECT ACC.DEV_NAME AS DEV_NAME,\n" +
			"       ACC.DEV_MODEL AS DEV_MODEL,\n" + 
			"       ACC.DEV_TYPE AS DEV_TYPE, SUB.DEV_ACC_ID as DEV_ACC_ID,SUB.ID as ID,\n" + 
			"       SUB.ERROR_TYPE  AS ERROR_TYPE,\n" + 
			"       SUB.ERROR_DESC \n" + 
			"       AS ERROR_DESC,\n" + 
			"       ACC.DEV_SIGN AS DEV_SIGN,\n" + 
			"       DECODE(SUB.DEV_STATUS,\n" + 
			"              '0',\n" + 
			"              '待修',\n" + 
			"              '1',\n" + 
			"              '在修',\n" + 
			"              '2',\n" + 
			"              '待仪器检测',\n" + 
			"              '3',\n" + 
			"              '无法修复',\n" + 
			"              '4',\n" + 
			"              '完好',\n" + 
			"              '') AS DEV_STATUS,\n" + 
			"       SUB.REMARK AS REMARK\n" + 
			"  FROM GMS_DEVICE_COLL_REPAIR_SUB SUB,\n" + 
			"       GMS_DEVICE_ACCOUNT_B       ACC,\n" + 
			"       GMS_DEVICE_COLL_REPAIRFORM SEND\n" + 
			" WHERE SUB.BSFLAG = '0'\n" + 
			"   AND ACC.BSFLAG = '0'\n" + 
			"   AND SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + 
			"   AND SUB.REPAIRFORM_ID = SEND.ID(+)" +
			"   AND SEND.ID = '<%=id%>'";
		var dataret = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
		var retObj = dataret.datas;
		addLine(retObj,true);		 
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
		}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001",
						"test", "");

		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById(str + '_name').value = names[1];
		var orgId = strs[1].split(":");
		document.getElementById(str).value = orgId[1];
	};
	function showPersonPage(){
		var returnValue = window.showModalDialog('<%=contextPath%>/rm/dm/devRepair/selectOrgHR.jsp?select=employeeid',"test",'dialogWidth=600px;dialogHeight=450px');
		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var name = strs[0].split(":");
		$("#req_user_name").val(name[1]);
		var id = strs[1].split(":");
		$("#req_user").val(id[1]);
	};
	function showDevPage(){
		var returnValue = window.showModalDialog('<%=contextPath%>/rm/dm/devRepair/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view',"test",'dialogWidth=800px;dialogHeight=450px');
		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var name = strs[0].split(":");
		$("#project_name").val(name[1]);
		var id = strs[1].split(":");
		$("#own_project").val(id[1]);
	};
	$().ready(function(){
		$("#addProcess").click(function(){
			var paramobj = new Object();
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devRepair/rfidAccountFrame.jsp",paramobj,"dialogWidth=820px;dialogHeight=400px");
			if(vReturnValue == undefined){
				return;
			}
			var accountidinfos = vReturnValue.split("|","-1");
			var condition ="(";
				for(var index=0;index<accountidinfos.length;index++){
					if(index==0)
						condition += "'"+accountidinfos[index]+"'";
					else
						condition += ",'"+accountidinfos[index]+"'";
				}
				condition += ") ";
				var str = "SELECT T.* FROM GMS_DEVICE_ACCOUNT_B T where 1=1 " + 
				"   AND T.DEV_ACC_ID in " + condition ;
			    var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				var retObj = proqueryRet.datas;
				addLine(retObj,false);
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked == true){
					var id=this.id;
					$("#tr"+id).remove();
				}
			});
			$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
			$("#detaillist>tr:odd>td:even").addClass("odd_even");
			$("#detaillist>tr:even>td:odd").addClass("even_odd");
			$("#detaillist>tr:even>td:even").addClass("even_even");
		});
	});
	function addLine(retObj,readflag){  //flag 是否从数据库中读取  true  是
		//$("#detaillist").empty();
		var curline =  $("#detaillist>tr").size();
		var length = curline + retObj.length;
		for(var index=0;index<retObj.length;index++){
			var flag = true;
			$("input[type='checkbox'][name='idinfo']").each(function(){
					var id=this.id;
					if(retObj[index].dev_acc_id == id){
					flag = false;
					}
			});
			var line = index+curline; 
			var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
				innerhtml += "<td width='4%' ><input type='checkbox' name='idinfo' seqinfo='"+line+"' id='"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_acc_id+"'/>";
			if(readflag){
				innerhtml += "<input type='hidden' id='subid"+retObj[index].dev_acc_id+"' name='subid"+retObj[index].dev_acc_id+"'  value='"+retObj[index].id+"'/></td>";
			}else{
				innerhtml += "<input type='hidden' id='subid"+retObj[index].dev_acc_id+"' name='subid"+retObj[index].dev_acc_id+"'  value=''/></td>";
			}
			innerhtml += "<td width='13%'>"+retObj[index].dev_name+"</td><td width='17%'>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td width='13%'>"+retObj[index].dev_sign+"</td>";
			//innerhtml += "<td width='13%'><select name='error_type"+line+"' id='error_type"+line+"' /></select></td>";
			//innerhtml += "<td width='13%'><select name='error_desc"+line+"' id='error_desc"+line+"' /></select></td>";
			innerhtml += "<td width='13%'><devselect:combolist name='error_type"+line+"' id='error_type"+line+"' selectdefaultV='true' selectedValue='0' typeKey='errortype'></devselect:combolist></td>";
			innerhtml += "<td width='13%'><devselect:combolist name='error_desc"+line+"'  id='error_desc"+line+"' selectdefaultV='true' selectedValue='0' typeKey='errordesc'></devselect:combolist></td>";			
			if(readflag){
				innerhtml += "<td width='13%'><input name='remark"+line+"' id='remark"+line+"' value='"+retObj[index].remark+"' size='10'  type='text' /></td>";
			}else{
				innerhtml += "<td width='13%'><input name='remark"+line+"' id='remark"+line+"' value='' size='10'  type='text' /></td>";
			}
			innerhtml += "</tr>";
			if(flag){//如果与现有的设备台账不重复
				$("#detaillist").append(innerhtml);
				$("#error_type"+line).find("option[value='"+retObj[index].error_type+"']").attr("selected",true);
				$("#error_desc"+line).find("option[value='"+retObj[index].error_desc+"']").attr("selected",true);
				$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
				$("#detaillist>tr:odd>td:even").addClass("odd_even");
				$("#detaillist>tr:even>td:odd").addClass("even_odd");
				$("#detaillist>tr:even>td:even").addClass("even_even");
			}
		}
	}
</script>
</html>

