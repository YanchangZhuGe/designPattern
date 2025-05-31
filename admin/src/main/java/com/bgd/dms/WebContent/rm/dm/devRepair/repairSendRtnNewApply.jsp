<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicehireappid = request.getParameter("devicehireappid");
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
<title>设备维修返还单界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
	<form name="form1" id="form1" method="post" action="">
		<div id="new_table_box" style="width: 98%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 95%">
					<fieldset style="margin: 2px:padding:2px;">
						<legend>维修返还申请基本信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item4">返还单号:</td>
								<td class="inquire_form4" colspan="3"><input
									name="backapp_no" id="backapp_no" class="input_width"
									type="text" value="保存后自动生成.." style="color: #DDDDDD;" readonly />
									<input name="send_id" id="send_id" class="input_width" type="hidden"
									value="" />
									</td>
							</tr>
							<tr>
								<td class="inquire_item4">返还单名称:</td>
								<td class="inquire_form4"><input name="backapp_name"
									id="backapp_name" class="input_width" type="text" value="" />
									<input name="id" id="id" class="input_width" type="hidden"
									value="" /></td>
								<td class="inquire_item4">申请日期:</td>
								<td class="inquire_form4"><input name="backdate"
									id="backdate" class="input_width" type="text" value="" readonly />
									<img src='<%=contextPath%>/images/calendar.gif' id='tributton1'
									width='16' height='16' style='cursor: hand;'
									onmouseover='calDateSelector(backdate,tributton1);' /></td>
							</tr>
							<tr>
								<td class="inquire_item4">接收单位:</td>
								<td class="inquire_form4" colspan="1">
								<input name="org_id" id="org_id" class="input_width" type="hidden"
									value="" />
								<input
									name="org_name" id="org_name" class="input_width"
									type="text" value="" readonly /></td>
									
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
						<legend>设备送修返还明细</legend>
						<div style="overflow: auto">
							<table style="width: 97.9%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td width="4%" class="bt_info_odd"><input type='checkbox'
										id='collbackinfo' name='collbackinfo' /></td>
									<td width="13%" class="bt_info_even">设备名称</td>
									<td width="13%" class="bt_info_odd">规格型号</td>
									<td width="13%" class="bt_info_even">实物标志号</td>
									<td width="13%" class="bt_info_even">故障类别</td>
									<td width="13%" class="bt_info_odd">故障现象</td>
									<!-- <td width="13%" class="bt_info_even">故障状态</td> -->
									<td width="13%" class="bt_info_odd">备注</td>
								</tr>
							</table>
							<table style="width: 97.9%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
							<tbody id="detaillist" name="detaillist" >
			   </tbody>
			  </table>
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
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
function refreshData(){
	var now = new Date();
    var year = now.getFullYear();       //年
    var month = now.getMonth() + 1;     //月
    var day = now.getDate();            //日
    var clock = year + "-";
    if(month < 10)
        clock += "0";
    clock += month + "-";
    if(day < 10)
        clock += "0";
    clock += day;
	$("#backdate").val(clock);
};
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
	function submitInfo(){
		var repair_form_code = $("#repair_form_code").val();
		if(repair_form_code == ""){
			alert('请选择送修单!');
			return;
		}
		//保留的行信息
		var count = 0;
		var line_infos;
		var rosClass;
		var lin_id;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			//if(this.checked){
				if(count == 0){
					line_infos = this.id;
					rosClass ="'"+this.rosClass+"'";
					lin_id  ="'"+this.id+"'";
				}else{
					line_infos += "~"+this.id;
					rosClass += ",'"+this.rosClass+"'";
					lin_id+= ",'"+this.id+"'";
				}
				count++;

			//}
		});
		/****
		if(count == 0){
			alert('请选择返还明细信息！');
			return;
		}
		****/
		//var selectedlines = line_infos.split("~");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devRepair/repairSendRtnNewApply.srq?count="+count+"&line_infos="+line_infos+"&rosClass="+rosClass+"&lin_id="+lin_id;
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
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001",
						"test", "");

		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById('req_comp_name').value = names[1];
		var orgId = strs[1].split(":");
		document.getElementById(str + '').value = orgId[1];
	};
	$().ready(function(){
		$("#addProcess").click(function(){
			//var projectInfoNo = $("#projectInfoNo").val();
			//var backdevtype = $("#backdevtype").val();
			var paramobj = new Object();
			//var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devRepair/selectDetailForBack.jsp?projectinfono=projectInfoNo&backdevtype=backdevtype",paramobj,"dialogWidth=820px;dialogHeight=450px");
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devRepair/selectDevSendDetailForBack.jsp?projectinfono=projectInfoNo&backdevtype=backdevtype",paramobj,"dialogWidth=820px;dialogHeight=450px");
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
			
				var str = "SELECT SUB.SEND_FORM_ID,SEND.REPAIR_FORM_NO AS REPAIR_FORM_NO,SEND.REPAIR_FORM_NAME AS REPAIR_FORM_NAME,ACC.DEV_NAME AS DEV_NAME, ACC.DEV_MODEL AS DEV_MODEL,ACC.DEV_TYPE AS DEV_TYPE\n" +
				" ,REQORG.ORG_ID AS ORG_ID,REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME " +
				"  ,SUB.REMARK AS REMARK,SUB.ID as ID,"+
				"       DECODE(SUB.ERROR_TYPE, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORTYPE)%>) AS ERROR_TYPE,\n" + 
				"       DECODE(SUB.ERROR_DESC, \n" + 
				"              <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORDESC)%>) AS ERROR_DESC,\n" + 
				"       ACC.DEV_SIGN AS DEV_SIGN,\n" + 
				"       DECODE(SUB.DEV_STATUS,\n" + 
				"              <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_DEVSTATUS)%>) AS DEV_STATUS,\n" + 
				" SEND.ID AS SEND_ID FROM GMS_DEVICE_COLL_SEND_SUB SUB, GMS_DEVICE_ACCOUNT_B ACC,GMS_DEVICE_COLL_REPAIR_SEND SEND,COMM_ORG_INFORMATION       REQORG\n" + 
				" WHERE SUB.BSFLAG = '0'\n" + 
				"   AND ACC.BSFLAG = '0'\n" + 
				"   AND SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + 
				"   AND SUB.SEND_FORM_ID = SEND.ID(+)\n" +
				"   AND SEND.APPLY_ORG = REQORG.ORG_ID(+)\n" + 
				"   AND SUB.ID in " + condition +
				" union " +
				"SELECT SUB.REPAIRFORM_ID SEND_FORM_ID,REP.REPAIR_FORM_CODE AS REPAIR_FORM_NO,REP.REPAIR_FORM_NAME AS REPAIR_FORM_NAME,ACC.DEV_NAME AS DEV_NAME, ACC.DEV_MODEL AS DEV_MODEL, ACC.DEV_TYPE AS DEV_TYPE,DECODE(SUB.ERROR_TYPE, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORTYPE)%>) AS ERROR_TYPE\n" +
				" ,REQORG.ORG_ID AS ORG_ID,REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME,DECODE(SUB.ERROR_DESC,<%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORDESC)%>) AS ERROR_DESC " +
				" ,ACC.DEV_SIGN AS DEV_SIGN,DECODE(SUB.DEV_STATUS,<%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_DEVSTATUS)%>) AS DEV_STATUS,SUB.REMARK AS REMARK,SUB.ID as ID"+
				" ,REP.ID AS SEND_ID FROM GMS_DEVICE_COLL_REPAIR_SUB SUB, GMS_DEVICE_ACCOUNT_B ACC,GMS_DEVICE_COLL_REPAIRFORM REP,COMM_ORG_INFORMATION       REQORG\n" + 
				" WHERE SUB.BSFLAG = '0'\n" + 
				"   AND ACC.BSFLAG = '0'\n" + 
				"   AND SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + 
				"   AND SUB.REPAIRFORM_ID = REP.ID(+)\n" +
				"   AND REP.REQ_COMP = REQORG.ORG_ID(+)\n" + 
				"   AND SUB.ID in " + condition ;
			    var proqueryRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				var retObj = proqueryRet.datas;
				addLine(retObj);
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked == true){
					var id=this.id;
					$("#tr"+id).remove();
				}
			});
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		});
		
		$().ready(function(){
			$("#devbackinfo").change(function(){
				var checkvalue = this.checked;
				$("input[type='checkbox'][name^='idinfo2']").attr('checked',checkvalue);
			});
			
			
		});
	});
	$().ready(function(){
		$("#collbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name='idinfo']").attr('checked',checkvalue);
		});
	});
	function addLine(retObj){
		$("#detaillist").empty();
		for(var index=0;index<retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index].id+"' name='tr' midinfo='"+retObj[index].id+"'>";
			innerhtml += "<td width='4%' ><input type='checkbox' name='idinfo' id='"+retObj[index].id+"' value='"+retObj[index].id+"' rosClass='"+retObj[index].send_form_id+"'/></td>";
			//innerhtml += "<td>"+retObj[index].repair_form_no+"</td><td>"+retObj[index].repair_form_name+"</td>";
			innerhtml += "<td width='13%'>"+retObj[index].dev_name+"</td><td width='13%'>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td width='13%'>"+retObj[index].dev_sign+"</td>";
			innerhtml += "<td width='13%'>"+retObj[index].error_type+"</td><td width='13%'>"+retObj[index].error_desc+"</td>";
			//<td width='13%'>"+retObj[index].dev_status+"</td>
			innerhtml += "<td width='13%'>"+retObj[index].remark+"</td>";
			innerhtml += "</tr>";
			$("#detaillist").append(innerhtml);
			$("#org_name").val(retObj[0].req_comp_name);
			$("#send_id").val(retObj[0].send_id);
		}
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
	}
	function showFormPage(){
		var paramobj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devRepair/selectRepairSendFormForBack.jsp?projectinfono=projectInfoNo&backdevtype=backdevtype",paramobj,"dialogWidth=820px;dialogHeight=450px");
		if(vReturnValue == undefined){
			return;
		}
		var id = vReturnValue.split("|","-1");
		var str =  
			"SELECT SEND.*,REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME\n" +
			"  FROM GMS_DEVICE_COLL_REPAIR_SEND SEND,COMM_ORG_INFORMATION REQORG\n" + 
			"  WHERE SEND.APPLY_ORG = REQORG.ORG_ID(+)\n" + 
			"  AND SEND.ID = '" + id + "'";
	    var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var retObj = proqueryRet.datas;
		//送修单号改变liug  start------
		if($("#repair_form_code").val() != retObj[0].repair_form_no){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
					var id=this.id;
					$("#tr"+id).remove();
					//修改该条记录的状态
					var sql = "update GMS_DEVICE_COL_REP_DETAIL set bsflag='1' where REP_FORM_DET_ID ='"+id+"'";
					var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
					var params = "deleteSql="+sql;
					params += "&ids=";
					var retObject = syncRequest('Post',path,params);
			});
			$("#detaillist").empty();
		}
		//送修单号改变liug  end------
		$("#repair_form_code").val(retObj[0].repair_form_no);
		$("#org_name").val(retObj[0].req_comp_name);
		$("#org_id").val(retObj[0].apply_org);
		$("#repid").val(retObj[0].id);
		/***
		var condition ="(";
		for(var index=0;index<accountidinfos.length;index++){
			if(index==0)
				condition += "'"+accountidinfos[index]+"'";
			else
				condition += ",'"+accountidinfos[index]+"'";
		}
		condition += ") ";
		***/
		
	};
</script>
</html>

