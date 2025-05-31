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
<title>设备送外维修添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
	<form name="form1" id="form1" method="post" action="">
		<div id="new_table_box" style="width: 98%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 95%">
					<fieldset style="margin: 2px:padding:2px;">
						<legend>送外维修申请基本信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item4">送修单号:</td>
								<td class="inquire_form4" colspan="3"><input
									name="repair_form_no" id="repair_form_no" class="input_width"
									type="text" value="保存后自动生成.." style="color: #DDDDDD;" readonly /></td>
							</tr>
							<tr>
								<td class="inquire_item4">送修单名称:</td>
								<td class="inquire_form4"><input name="repair_form_name"
									id="repair_form_name" class="input_width" type="text" value="" />
									<input name="id"
									id="id" class="input_width" type="hidden" value="" />
								</td>
								<td class="inquire_item4">申请日期:</td>
								<td class="inquire_form4"><input name="apply_date"
									id="apply_date" class="input_width" type="text" value=""
									readonly /> <img src='<%=contextPath%>/images/calendar.gif'
									id='tributton1' width='16' height='16' style='cursor: hand;'
									onmouseover='calDateSelector(apply_date,tributton1);' /></td>
							</tr>
							<tr>
								<td class="inquire_item4">所属项目:</td>
								<td class="inquire_form4" colspan="1">
								<input
									name="project_name" id="project_name" class="input_width"
									type="text" value="" readonly /> <input name="own_project"
									id="own_project" class="input_width" type="hidden" value="" />
									<img src="<%=contextPath%>/images/magnifier.gif" width="16"
									height="16" style="cursor: hand;" onclick="showDevPage()" />
								</td>
								<td class="inquire_item4">送修单位:</td>
								<td class="inquire_form4"><input id="req_comp_name"
									name="req_comp_name" class="input_width" type="text" /> 
									<!-- 
									<img
									src="<%=contextPath%>/images/magnifier.gif" width="16"
									height="16" style="cursor: hand;"
									onclick="showOrgTreePage('apply_org')" /> 
									 -->
									 <input id="apply_org"
									name="apply_org" class="" type="hidden" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">维修单位:</td>
								<td class="inquire_form4"><input name="service_company"
									id="service_company" class="input_width" type="text" value="" /></td>
								<td class="inquire_item4">币种:</td>
								<td class="inquire_form4">
								<devselect:combolist name='currency'
											id='currency' selectdefaultV='true' selectedValue='0'
											typeKey='currency'></devselect:combolist>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">汇率:</td>
								<td class="inquire_form4"><input name="rate" id="rate"
									class="input_width" type="text" value="" onchange="getlocal();"/></td>
								<td class="inquire_item4">预计原币金额:</td>
								<td class="inquire_form4"><input name="buget_our"
									id="buget_our" class="input_width" type="text" value="" onchange="getlocal();"/></td>
							</tr>
							<tr>
								<td class="inquire_item4">预计本币金额:</td>
								<td class="inquire_form4"><input name="buget_local"
									id="buget_local" class="input_width" type="text" value="" /></td>
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
function getlocal(){
	var re = /^(?:[1-9][0-9]*(?:\.[0-9]{0,2})?)$/;
	var rate = $("#rate").val();
	var buget_our = $("#buget_our").val();
	if(rate!=""&&!re.test(rate)){
		alert("汇率必须为数字!");
		$("#rate").val("");
    	return false;
	}
	if(buget_our!=""&&!re.test(buget_our)){
		alert("预计原币金额必须为数字!");
		$("#buget_our").val("");
    	return false;
	}
	$("#buget_local").val(accMul(rate,buget_our));
}
function accMul(arg1,arg2)
{
var m=0,s1=arg1.toString(),s2=arg2.toString();
try{m+=s1.split(".")[1].length}catch(e){}
try{m+=s2.split(".")[1].length}catch(e){}
return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)
}
$().ready(function(){
	$("#collbackinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
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
		/***************** 数据验证 *****/
		var re = /^(?:[1-9][0-9]*(?:\.[0-9]{0,2})?)$/;
		//汇率     预计原币金额   预计本币金额
		var rate = $("#rate").val();
		var buget_our = $("#buget_our").val();
		var buget_local = $("#buget_local").val();
		var currency = $("#currency").val();
	    if(currency == ""){
	    	alert("请选择维修状态!");
	    	return;
	    }
		if(rate!=""&&!re.test(rate)){
			alert("汇率必须为数字!");
			$("#rate").val("");
        	return false;
		}
		if(buget_our!=""&&!re.test(buget_our)){
			alert("预计原币金额必须为数字!");
			$("#buget_our").val("");
        	return false;
		}
		if(buget_local!=""&&!re.test(buget_local)){
			alert(" 预计本币金额必须为数字!");
			$("#buget_local").val("");
        	return false;
		}
		/***************** 数据验证 *****/
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
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devRepair/repairSendNewApply.srq?count="+count+"&line_infos="+line_infos+"&seqinfo="+seqinfo;
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
		document.getElementById(str+'').value = orgId[1];
	};
	function showDevPage(){
		var returnValue = window.showModalDialog('<%=contextPath%>/rm/dm/devRepair/selectProject.jsp?backUrl=/rm/dm/devRepair/selectProject.jsp&action=view',"test",'dialogWidth=800px;dialogHeight=450px');
		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var name = strs[0].split(":");
		$("#project_name").val(name[1]);
		var id = strs[1].split(":");
		$("#own_project").val(id[1]);
	};
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
		$("#apply_date").val(clock);
		$("#apply_org").val('<%=user.getOrgId()%>');
		var sql = " SELECT ORG.ORG_ABBREVIATION AS REQ_COMP_NAME FROM COMM_ORG_INFORMATION ORG "; 
		sql += "  WHERE  ORG.ORG_ID =  '<%=user.getOrgId()%>'  "; 
		var repairQueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
		var repairObj = repairQueryRet.datas;
		$("#req_comp_name").val(repairObj[0].req_comp_name);
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
	});
	function addLine(retObj){
		//$("#detaillist").empty();
		for(var index=0;index<retObj.length;index++){
			var flag = true;
			$("input[type='checkbox'][name='idinfo']").each(function(i){
					var id=this.id;
					if(retObj[index].dev_acc_id == id){
					flag = false;
					}
			});
			var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
			innerhtml += "<td width='4%' ><input type='checkbox' name='idinfo' seqinfo='"+index+"' id='"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_acc_id+"'/>"+
			"<input type='hidden' id='subid"+retObj[index].dev_acc_id+"'  value=''/></td>";
			innerhtml += "<td width='13%'>"+retObj[index].dev_name+"</td><td width='17%'>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td width='13%'>"+retObj[index].dev_sign+"</td>";
			//innerhtml += "<td width='13%'><select name='error_type"+index+"' id='error_type"+index+"' /></select></td>";
			innerhtml += "<td width='13%'><devselect:combolist name='error_type"+index+"' selectdefaultV='true' selectedValue='0' typeKey='errortype'></devselect:combolist></td>";
			//innerhtml += "<td width='13%'><select name='error_desc"+index+"' id='error_desc"+index+"' /></select></td>";
			innerhtml += "<td width='13%'><devselect:combolist name='error_desc"+index+"' selectdefaultV='true' selectedValue='0' typeKey='errordesc'></devselect:combolist></td>";
			innerhtml += "<td width='13%'><input name='remark"+index+"' id='remark"+index+"' value='' size='10'  type='text' /></td>";
			innerhtml += "</tr>";
			if(flag){//如果与现有的设备台账不重复
				$("#detaillist").append(innerhtml);  
			}
		}
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
	}
</script>
</html>

