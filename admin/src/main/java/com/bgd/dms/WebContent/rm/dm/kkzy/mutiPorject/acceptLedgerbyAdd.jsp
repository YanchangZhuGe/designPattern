﻿<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String projectInfoNo = user.getProjectInfoNo();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String wx_ids = request.getParameter("wx_ids");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<title></title>
<style type="text/css">
.inputWidth{
width: 220px;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="load()">

	<form name="form1" id="form1" method="post" action="">
		<input type='hidden' name='selectWzId' id='selectWzId' />
		<div id="new_table_box" style="width: 100%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 95%">
					<div style="overflow: auto">
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr align="right">
								<td style="width: 90%"></td>
								<auth:ListButton id="zj0" functionId="" css="zj"
									event="onclick='toAddzy()'" title="选择设备"></auth:ListButton>
								<auth:ListButton id="zj1" functionId="" css="zj"
									event="onclick='toAdd()'" title="手工录入"></auth:ListButton>

								<td><span class="sc"><a href="#" id="delProcess"
										name="delXgllEq" onclick="deleteMatHave()"></a></span></td>
								<td style="width: 1%"></td>
							</tr>
						</table>
					</div>
					<fieldset style="margin-left: 2px">
						<legend>保养记录录入</legend>
						<div style="height: 300px; overflow: auto">
							<table width="97%" border="0" cellspacing="0" cellpadding="0"
								class="tab_line_height">
								<tr>
									<td class="bt_info_odd" style="width: 1%"><input
										type='checkbox' id='hirechecked' name='hirechecked' /></td>
									<td class="bt_info_odd" style="width: 7.5%">自编号</td>
									<td class="bt_info_even" style="width: 7.5%">实物标识号</td>
									<td class="bt_info_odd" style="width: 7.5%">日期</td>
									<td class="bt_info_odd" style="width: 7.5%">累计工作小时</td>
									<!-- <td class="bt_info_even" style="width: 15%">故障现象</td>
									<td class="bt_info_even" style="width: 7.5%">故障原因</td>
									<td class="bt_info_even" style="width: 15%">故障解决办法</td>
									<td class="bt_info_even" style="width: 7.5%">主要总成件名称</td> -->
									<td class="bt_info_even" style="width: 7.5%">保养级别</td>
									<td class="bt_info_odd" style="width:7.5%">保养项目</td>
									<td class="bt_info_even" style="width: 15%">主要保养内容</td>
									<td class="bt_info_odd" style="width: 7.5%">性能描述</td>
									<td class="bt_info_odd" style="width:7.5%">故障信息</td>
									<td class="bt_info_even" style="width: 7.5%">遗留问题</td>
									<td class="bt_info_odd" style="width: 7.5%">承修单位</td>
									<td class="bt_info_even" style="width: 7.5%">主修人</td>
									<td class="bt_info_odd" style="width: 7.5%">备注</td>
								</tr>
								<tbody id="processtable0" name="processtable0">
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
	function frameSize() {
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	});
	$(document).ready(lashen);
</script>
<script type="text/javascript">
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
function submitInfo()
{
	
	
	//保留的行信息
	var count = 0;
	var line_infos;
	$("input[type='checkbox'][name='idinfo']").each(function(){
		if(this.checked){
			if(count == 0){
				line_infos = this.id;
			}else{
				line_infos += "~"+this.id;
			}
			count++;
		}
	});
	if(count == 0){
		alert('请录入设备保养维修信息！');
		return;
	}
	var selectedlines = line_infos.split("~");
	var selectedlines = line_infos.split("~");
	var wronglineinfos = "";
	for(var index=0;index<selectedlines.length;index++){
		var maintenance_level=$("#maintenance_level"+index).val();
		var zcj_type=$("#zcj_type"+index+"  option:selected").text();
		//var xuanze = $("#xuanze"+selectedlines[index]).val();
		if(maintenance_level=='无'){
			var bywx_date = $("#bywx_date"+selectedlines[index]).val();
			var work_hours = $("#work_hours"+selectedlines[index]).val();
			var dev_acc_id = $("#dev_acc_id"+selectedlines[index]).val();
			var repair_men = $("#repair_men"+selectedlines[index]).val();
			//falut_desc,falut_reason,falut_case,zcj_type,repair_men
			if(bywx_date == "" || work_hours == "" || dev_acc_id==""|| repair_men==""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}else{
			//maintenance_desc,performance_desc,repair_men
			var bywx_date = $("#bywx_date"+selectedlines[index]).val();
			var work_hours = $("#work_hours"+selectedlines[index]).val();
			var dev_acc_id = $("#dev_acc_id"+selectedlines[index]).val();
			var maintenance_desc = $("#maintenance_desc"+selectedlines[index]).val();
			var performance_desc = $("#performance_desc"+selectedlines[index]).val();
			var repair_men = $("#repair_men"+selectedlines[index]).val();
			if(maintenance_desc == "" || performance_desc == "" || repair_men=="" || bywx_date == "" || work_hours==""|| dev_acc_id==""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
	}
		
	if(wronglineinfos!=""){
		alert("请设置第"+wronglineinfos+"行明细的保养维修记录!");
		return;
	}
	
	document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveBywxInfos.srq?bywx_type=2&count="+count+"&line_infos="+line_infos;
	document.getElementById("form1").submit();
}

var checked = false;
	function check(){
	var chk = document.getElementsByName("rdo_entity_id");
	for(var i = 0; i < chk.length; i++){ 
		if(!checked){ 
			chk[i].checked = true; 
		}
		else{
			chk[i].checked = false;
		}
	} 
	if(checked){
		checked = false;
	}
	else{
		checked = true;
	}
}
	var tr_id=0;
	function load()
	{
		var wx_ids=<%=wx_ids%>;
			var baseData;
			 baseData = jcdpCallService("DevZcjByItemSrv", "getwxbyInfo", "wx_ids="+wx_ids);
				if(baseData.datas!=null)
				{
					//通过查询结果动态填充使用情况select;
					var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0'";
					var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
					usingdatas = queryRet.datas;
					for (var i=0; i< baseData.datas.length; i++) {
						tr_id=$("#processtable0 tr").length;
						var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
						innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='"+baseData.datas[i].dev_acc_id+"' size='16'  type='hidden' />";
						innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='"+baseData.datas[i].usemat_id+"' size='16'  type='hidden' />";
						innerhtml += "<input name='bywx_id"+tr_id+"' id='bywx_id"+tr_id+"' value='"+baseData.datas[i].bywx_id+"' size='16'  type='hidden' />";
						innerhtml += "<input name='self_num"+tr_id+"' id='self_num"+tr_id+"' value='"+baseData.datas[i].self_num+"' size='16'  type='hidden' />";
						innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
						//自编号
						innerhtml += "<td>"+baseData.datas[i].self_num+"</td>";
						//实物标识号
						innerhtml += "<td>"+baseData.datas[i].dev_sign+"</td>";
						//日期
						innerhtml += "<td><input name='bywx_date"+tr_id+"' id='bywx_date"+tr_id+"' value='"+baseData.datas[i].bywx_date+"' size='16' readonly />";
						innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: pointer;'"+"onmouseover='calDateSelector(bywx_date"+tr_id+",tributton2"+tr_id+");'/></td>";
						//累计工作小时数
						innerhtml += "<td><input name='work_hours"+tr_id+"' id='work_hours"+tr_id+"' value='"+baseData.datas[i].work_hours+"' size='16' onblur='checkUse_num("+tr_id+")' onmouseout='checkWorkHour("+tr_id+")'/></td>";
						//故障现象
						/* innerhtml += "<td><input class='inputWidth' name='falut_desc"+tr_id+"' id='falut_desc"+tr_id+"' value='"+baseData.datas[i].falut_desc+"' size='16' /></td>";
						//故障原因
						innerhtml += "<td><input name='falut_reason"+tr_id+"' id='falut_reason"+tr_id+"' value='"+baseData.datas[i].falut_reason+"' size='16' /></td>";
						//故障解决办法
						innerhtml += "<td><input  class='inputWidth' name='falut_case"+tr_id+"' id='falut_case"+tr_id+"' value='"+baseData.datas[i].falut_case+"' size='16' /></td>"; */
						//类别隐藏，默认保养
						innerhtml += "<input name='bywx_type"+tr_id+"' id='bywx_type"+tr_id+"' value='2'  type='hidden'>";
						//主要总成件
						/* innerhtml += "<td><select name='zcj_type"+tr_id+"' id='zcj_type"+tr_id+"'  onchange='changeZcj("+tr_id+")'>"; 
						if(usingdatas != null){
							innerhtml +=  "<option   value=''>无</option>";
							for (var j = 0; j< usingdatas.length; j++) {
								if(baseData.datas[i].zcj_type==usingdatas[j].coding_code_id)
									{
									innerhtml +=  "<option selected   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
									}
								innerhtml +=  "<option   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
							}
						
						}
						innerhtml +="</select></td>";*/
						//更换备件
						//innerhtml += "<td><input type='button' id='xuanze"+tr_id+"' value='更换备件' onclick='selectMatData("+tr_id+")'/></td>";
						//保养级别
						if(baseData.datas[i].maintenance_level=='无')
							{
							innerhtml += "<td><select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无' selected>无</option><option value='B'>B级</option><option value='C'>C级</option><option value='D'>D级</option></select></td>";
							}
						if(baseData.datas[i].maintenance_level=='B')
						{
						innerhtml += "<td><select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无' >无</option><option value='B' selected>B级</option><option value='C'>C级</option><option value='D'>D级</option></select></td>";
						}
						if(baseData.datas[i].maintenance_level=='C')
						{
						innerhtml += "<td><select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无' >无</option><option value='B'>B级</option><option value='C' selected>C级</option><option value='D'>D级</option></select></td>";
						}
						if(baseData.datas[i].maintenance_level=='D')
						{
						innerhtml += "<td><select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无' >无</option><option value='B'>B级</option><option value='C'>C级</option><option value='D' selected>D级</option></select></td>";
						}
						innerhtml += " <td><input type='button' id='glbyxx"+tr_id+"' value='保养项目' onclick='selectBYData("+tr_id+")'/></td>";
						//主要保养内容
						innerhtml += "<td><input class='inputWidth' name='maintenance_desc"+tr_id+"' id='maintenance_desc"+tr_id+"' value='"+baseData.datas[i].maintenance_desc+"' size='16' /></td>";
						//性能描述
						if(baseData.datas[i].performance_desc=='0')
						{
						innerhtml += "<td><select name='performance_desc"+tr_id+"' id='performance_desc"+tr_id+"'><option value='0' selected>良好</option><option value='1'>待修</option><option value='2' >待查</option></select></td>";
						}
						if(baseData.datas[i].performance_desc=='1')
						{
						innerhtml += "<td><select name='performance_desc"+tr_id+"' id='performance_desc"+tr_id+"'><option value='0' >良好</option><option value='1' selected>待修</option><option value='2' >待查</option></select></td>";
						}
						if(baseData.datas[i].performance_desc=='2')
						{
						innerhtml += "<td><select name='performance_desc"+tr_id+"' id='performance_desc"+tr_id+"'><option value='0' >良好</option><option value='1'>待修</option><option value='2' selected>待查</option></select></td>";
						}
						innerhtml += "<td><input type='button' id='glgzxx"+tr_id+"' value='故障信息' onclick='selectGZData("+tr_id+")'/></td>";
						//遗留问题
						innerhtml += "<td><input name='legacy"+tr_id+"' id='legacy"+tr_id+"' value='"+baseData.datas[i].legacy+"' size='16' /></td>";
						//承修单位
						if(baseData.datas[i].repair_unit=='东部维修组')
						{
						innerhtml += "<td><select name='repair_unit"+tr_id+"' id='repair_unit"+tr_id+"'><option value='东部维修组' selected>东部维修组</option><option value='西部维修组'>西部维修组</option><option value='其他'>其他</option></select></td>";
						}
						if(baseData.datas[i].repair_unit=='西部维修组')
						{
						innerhtml += "<td><select name='repair_unit"+tr_id+"' id='repair_unit"+tr_id+"'><option value='东部维修组'>东部维修组</option><option value='西部维修组' selected>西部维修组</option><option value='其他'>其他</option></select></td>";
						}
						if(baseData.datas[i].repair_unit=='其他')
						{
						innerhtml += "<td><select name='repair_unit"+tr_id+"' id='repair_unit"+tr_id+"'><option value='东部维修组'>东部维修组</option><option value='西部维修组'>西部维修组</option><option value='其他' selected>其他</option></select></td>";
						}
						//承修人
						innerhtml += "<td><input name='repair_men"+tr_id+"' id='repair_men"+tr_id+"' value='"+baseData.datas[i].repair_men+"' size='16' /></td>";
						//备注
						innerhtml += "<td><input name='bak"+tr_id+"' id='bak"+tr_id+"' value='"+baseData.datas[i].bak+"' size='16' /></td>";
						$("#processtable0").append(innerhtml);
					
						}
				
					$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
					$("#processtable0>tr:odd>td:even").addClass("odd_even");
					$("#processtable0>tr:even>td:odd").addClass("even_odd");
					$("#processtable0>tr:even>td:even").addClass("even_even");
					}
		
	}
	/**点击更换备件使用的方法，
	该方法生成唯一系统id，
	使它作为保养主表与备件信息间的唯一关联标识，
	该标识也将用在保养主表与保养项目间作为唯一标识**/
	<%-- function selectMatData(i)
	{
		var usemat_id=document.getElementById("usemat_id"+i+"").value;
		if(usemat_id==null || usemat_id=='' || usemat_id=='undefined'){
			var sql = "select lower(sys_guid()) devicebackappid from dual";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
			if(retObj!=null && retObj.returnCode=='0'){
				usemat_id = retObj.datas[0].devicebackappid;
			}
			document.getElementById("usemat_id"+i+"").value = usemat_id;
		}
		//自编号
		var self_num = document.getElementById("self_num"+i+"").value;
		if(self_num==""){
			alert("自编号不能为空！");
			return ;
		}
		/* var zcj_type=document.getElementById("zcj_type"+i+"").value; */
		var work_hours = document.getElementById("work_hours"+i+"").value;
		var selected;
		selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/selectMatList-zy.jsp?self_num="+self_num+"&bywx_type=2&selectWzId="+usemat_id+"&work_hours="+work_hours,"","dialogWidth=1240px;dialogHeight=680px");
		selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/zcjMatList-zy.jsp?selectWzId="+usemat_id,"","dialogWidth=1240px;dialogHeight=680px");
		if(selected=='true'){
			document.getElementById("xuanze"+i+"").value="已提交";
		}
	} --%>
/**点击保养等级生成唯一标识，
该方法生成唯一系统id，
该标识用在保养主表与保养项目间作为唯一标识**/
function  byGradeChange(obj,i){
	<%-- alert(document.getElementById("maintenance_level"+i+"").value);
	var usemat_id=document.getElementById("usemat_id"+i+"").value;
	if(usemat_id==null || usemat_id=='' || usemat_id=='undefined'){
		var sql = "select lower(sys_guid()) devicebackappid from dual";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
		if(retObj!=null && retObj.returnCode=='0'){
			usemat_id = retObj.datas[0].devicebackappid;
		}
		document.getElementById("usemat_id"+i+"").value = usemat_id;
	}
	alert(document.getElementById("usemat_id"+i+"").value); --%>
}
/**
保养项目方法
点击保养等级生成唯一标识，
该方法生成唯一系统id，
该标识用在保养主表与保养项目间作为唯一标识
**/
function  selectBYData(i){
	//获取保养等级
	var maintenance_level = document.getElementById("maintenance_level"+i+"").value;
	if(maintenance_level!='无'){
		//获取唯一标识符
		var usemat_id=document.getElementById("usemat_id"+i+"").value;
		if(usemat_id==null || usemat_id=='' || usemat_id=='undefined'){
			var sql = "select lower(sys_guid()) devicebackappid from dual";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
			if(retObj!=null && retObj.returnCode=='0'){
				usemat_id = retObj.datas[0].devicebackappid;
			}
			document.getElementById("usemat_id"+i+"").value = usemat_id;
		}
		var dev_acc_id = document.getElementById("dev_acc_id"+i+"").value;
		//打开页面需要两个参数1、唯一标识usemat_id 2、保养等级maintenance_leve 3、设备id dev_acc_id
		var selected;
		selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/mutiPorject/selectByItemList.jsp?selectWzId="+usemat_id+"&maintenance_level="+maintenance_level+"&dev_acc_id="+dev_acc_id,"","dialogWidth=1240px;dialogHeight=680px");
		/* if(selected=='true'){
			document.getElementById("glbyxx"+i+"").value="已关联";
		} */
	}else {
		alert("请选择保养等级！");
	}
}
function refreshData(){
	var wz_id=document.getElementById("selectWzId").value;
	var baseData;
	 baseData = jcdpCallService("DevZcjByItemSrv", "getdeviceZyInfo", "wz_id="+wz_id);
		if(baseData.datas!=null)
		{
			
			//通过查询结果动态填充使用情况select;
			/* var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0'";
			var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			usingdatas = queryRet.datas; */
			for (var i=0; i< baseData.datas.length; i++) {
				tr_id=$("#processtable0 tr").length;
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
				innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='"+baseData.datas[i].dev_acc_id+"' size='16'  type='hidden' />";
				innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='' size='16'  type='hidden' />";
				innerhtml += "<input name='self_num"+tr_id+"' id='self_num"+tr_id+"' value='"+baseData.datas[i].self_num+"' size='16'  type='hidden' />";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
				innerhtml += "<td>"+baseData.datas[i].self_num+"</td>";
				innerhtml += "<td>"+baseData.datas[i].dev_sign+"</td>";
				innerhtml += "<td><input name='bywx_date"+tr_id+"' id='bywx_date"+tr_id+"' value='' size='16' readonly />";
				innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: pointer;'"+"onmouseover='calDateSelector(bywx_date"+tr_id+",tributton2"+tr_id+");'/></td>";
				innerhtml += "<td><input name='work_hours"+tr_id+"' id='work_hours"+tr_id+"' value='' size='16'  onblur='checkUse_num("+tr_id+")' onmouseout='checkWorkHour("+tr_id+")'/></td>";
				/* innerhtml += "<td><input  class='inputWidth' name='falut_desc"+tr_id+"' id='falut_desc"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><input name='falut_reason"+tr_id+"' id='falut_reason"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><input class='inputWidth' name='falut_case"+tr_id+"' id='falut_case"+tr_id+"' value='' size='16' /></td>"; */
				innerhtml += "<input name='bywx_type"+tr_id+"' id='bywx_type"+tr_id+"' value='2'  type='hidden'>";
				/* innerhtml += "<td><select name='zcj_type"+tr_id+"' id='zcj_type"+tr_id+"' onchange='changeZcj("+tr_id+")'>";
				if(usingdatas != null){
					innerhtml +=  "<option   value=''>无</option>";
					for (var j = 0; j< usingdatas.length; j++) {
						innerhtml +=  "<option   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
					}
				}
				innerhtml +="</select></td>"; */
				//innerhtml += "<td><input type='button' id='xuanze"+tr_id+"' value='更换备件' onclick='selectMatData("+tr_id+")'/></td>";
				///
				//保养级别
				if(baseData.datas[i].yjbyjb=='无'){
					innerhtml += "<td><select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无' selected>无</option><option value='B'>B级</option><option value='C'>C级</option><option value='D'>D级</option></select></td>";
				}
				if(baseData.datas[i].yjbyjb=='B'){
					innerhtml += "<td><select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无' >无</option><option value='B' selected>B级</option><option value='C'>C级</option><option value='D'>D级</option></select></td>";
				}
				if(baseData.datas[i].yjbyjb=='C'){
					innerhtml += "<td><select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无' >无</option><option value='B'>B级</option><option value='C' selected>C级</option><option value='D'>D级</option></select></td>";
				}
				if(baseData.datas[i].yjbyjb=='D'){
					innerhtml += "<td><select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无' >无</option><option value='B'>B级</option><option value='C'>C级</option><option value='D' selected>D级</option></select></td>";
				}
				///
				innerhtml += "<td><input type='button' id='glbyxx"+tr_id+"' value='保养项目' onclick='selectBYData("+tr_id+")'/></td>";
				innerhtml += "<td><input  class='inputWidth'  name='maintenance_desc"+tr_id+"' id='maintenance_desc"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><select name='performance_desc"+tr_id+"' id='performance_desc"+tr_id+"'><option value='0'>良好</option><option value='1'>待修</option><option value='2'>待查</option></select></td>";
				innerhtml += "<td><input type='button' id='glgzxx"+tr_id+"' value='故障信息' onclick='selectGZData("+tr_id+")'/></td>";
				innerhtml += "<td><input name='legacy"+tr_id+"' id='legacy"+tr_id+"' value='无' size='16' /></td>";
				innerhtml += "<td><select name='repair_unit"+tr_id+"' id='repair_unit"+tr_id+"'><option value='东部维修组'>东部维修组</option><option value='西部维修组'>西部维修组</option><option value='其他'>其他</option></select></td>";
				innerhtml += "<td><input name='repair_men"+tr_id+"' id='repair_men"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><input name='bak"+tr_id+"' id='bak"+tr_id+"' value='' size='16' /></td>";
				$("#processtable0").append(innerhtml);
				}
		
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
			}
	
}
function toAddzy(){
	var selectWzId = document.getElementById("selectWzId").value;
	var selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/mutiPorject/selectkkzyList.jsp","","dialogWidth=1240px;dialogHeight=480px");
	var wz_id = selected;
	document.getElementById("selectWzId").value = wz_id;
	if(selected!=null&&selected!=""){
		refreshData('');
	}
}
function toAdd()
{
	//通过查询结果动态填充使用情况select;
	/* var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0'";
	var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
	usingdatas = queryRet.datas; */
	tr_id=$("#processtable0 tr").length;
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
	innerhtml += "<td>&nbsp;<input name='self_num"+tr_id+"' id='self_num"+tr_id+"' value='' onblur='checkSelf("+tr_id+")' size='16'/></td>";
	innerhtml += "<td>&nbsp;<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' onblur='checkDevSign("+tr_id+")' size='16'/></td>";
	innerhtml += "<td>&nbsp;<input name='bywx_date"+tr_id+"' id='bywx_date"+tr_id+"' value='' size='16' readonly />";
	innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: pointer;'"+"onmouseover='calDateSelector(bywx_date"+tr_id+",tributton2"+tr_id+");'/></td>";
	innerhtml += "<td>&nbsp;<input name='work_hours"+tr_id+"' id='work_hours"+tr_id+"' value='' size='16'  onblur='checkUse_num("+tr_id+")' onmouseout='checkWorkHour("+tr_id+")'/></td>";
	/* innerhtml += "<td>&nbsp;<input class='inputWidth' name='falut_desc"+tr_id+"' id='falut_desc"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input name='falut_reason"+tr_id+"' id='falut_reason"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input class='inputWidth' name='falut_case"+tr_id+"' id='falut_case"+tr_id+"' value='' size='16' /></td>"; */
	innerhtml += "<input name='bywx_type"+tr_id+"' id='bywx_type"+tr_id+"' value='2'  type='hidden'>";
	/* innerhtml += "<td>&nbsp;<select name='zcj_type"+tr_id+"' id='zcj_type"+tr_id+"'  onchange='changeZcj("+tr_id+")'>";
	if(usingdatas != null){
		innerhtml +=  "<option   value=''>无</option>";
		for (var j = 0; j< usingdatas.length; j++) {
			innerhtml +=  "<option   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
		}
	}
	innerhtml +="</select></td>"; */
	//innerhtml += "<td>&nbsp;<input type='button' id='xuanze"+tr_id+"' value='更换备件' onclick='selectMatData("+tr_id+")'/></td>";
	innerhtml += "<td>&nbsp;<select name='maintenance_level"+tr_id+"' id='maintenance_level"+tr_id+"' onchange='byGradeChange(this,"+tr_id+")'><option value='无'>无</option><option value='B'>B级</option><option value='C'>C级</option><option value='D'>D级</option></select></td>";
	innerhtml += "<td>&nbsp;<input type='button' id='glbyxx"+tr_id+"' value='保养项目' onclick='selectBYData("+tr_id+")'/></td>";
	innerhtml += "<td>&nbsp;<input class='inputWidth' name='maintenance_desc"+tr_id+"' id='maintenance_desc"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<select name='performance_desc"+tr_id+"' id='performance_desc"+tr_id+"'><option value='0'>良好</option><option value='1'>待修</option><option value='2'>待查</option></select></td>";
	innerhtml += "<td><input type='button' id='glgzxx"+tr_id+"' value='故障信息' onclick='selectGZData("+tr_id+")'/></td>";
	innerhtml += "<td>&nbsp;<input name='legacy"+tr_id+"' id='legacy"+tr_id+"' value='无' size='16' /></td>";
	innerhtml += "<td><select name='repair_unit"+tr_id+"' id='repair_unit"+tr_id+"'><option value='东部维修组'>东部维修组</option><option value='西部维修组'>西部维修组</option><option value='其他'>其他</option></select></td>";
	innerhtml += "<td>&nbsp;<input name='repair_men"+tr_id+"' id='repair_men"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input name='bak"+tr_id+"' id='bak"+tr_id+"' value='' size='16' /></td>";
	$("#processtable0").append(innerhtml);	
}

function deleteMatHave(){
	$("input[name='idinfo']").each(function(){
		if(this.checked == true){
			$('#tr'+this.id,"#processtable0").remove();
		}
	});
	$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable0>tr:odd>td:even").addClass("odd_even");
	$("#processtable0>tr:even>td:odd").addClass("even_odd");
	$("#processtable0>tr:even>td:even").addClass("even_even");
}

function checkSelf(num)
{
	var self_num=document.getElementById("self_num"+num).value;
	//只能输入数字
	 var re = /^[0-9]+[0-9]*]*$/;   
	 if(self_num.length>0)
		 {
    if (!re.test(self_num))   
   	{   
        alert("请输入数字!");   
        document.getElementById("self_num"+num).value="";
        document.getElementById("self_num" + num).style.border = "1px solid red";
        document.getElementById("self_num"+num).focus();   
       return false;   
    }
   
			baseData = jcdpCallService("DevZcjByItemSrv", "getZyInfoForSelfNums",
					"self_num=" + self_num);
			if (baseData.data != null) {
				document.getElementById("self_num" + num).style.border = "";
				document.getElementById("dev_acc_id" + num).value = baseData.data.dev_acc_id;
				document.getElementById("dev_sign" + num).value = baseData.data.dev_sign;
				var yjbyjbmessage=baseData.data.yjbyjb;
				$("#maintenance_level"+num).val(yjbyjbmessage);
			} else {
				alert("请输入有效的自编号!");
				document.getElementById("self_num" + num).value = "";
				document.getElementById("self_num" + num).style.border = "1px solid red";
				document.getElementById("self_num" + num).focus();
				document.getElementById("dev_sign"+num).value="";
				return false;
			}
		}

	}
/*实物标识号检测*/
function checkDevSign(num)
{
	var dev_sign=document.getElementById("dev_sign"+num).value;
	 if(dev_sign.length>0)
		 {
   
			baseData = jcdpCallService("DevZcjByItemSrv", "getZyInfoForDevSigns",
					"dev_sign=" + dev_sign);
			if (baseData.data != null) {
				document.getElementById("dev_sign" + num).style.border = "";
				document.getElementById("dev_acc_id" + num).value = baseData.data.dev_acc_id;
				document.getElementById("self_num" + num).value = baseData.data.self_num;
				var yjbyjbmessage=baseData.data.yjbyjb;
				$("#maintenance_level"+num).val(yjbyjbmessage);
			} else {
				alert("请输入有效的实物标识号!");
				document.getElementById("dev_sign" + num).value = "";
				document.getElementById("dev_sign" + num).style.border = "1px solid red";
				document.getElementById("dev_sign" + num).focus();
				document.getElementById("self_num" + num).value = "";
				return false;
			}
		}

	}
	function checkUse_num(tr_id) {
		var use_num = document.getElementById("work_hours" + tr_id).value;
		//只能输入数字
		var re = /^[0-9]{0}([0-9]|[.])+$/;
		if (use_num.length > 0) {
			if (!re.test(use_num)) {
				alert("请输入数字!");
				document.getElementById("work_hours" + tr_id).value = "";
				document.getElementById("work_hours" + tr_id).focus();
				return false;
			}else{
				check_num_daxiao(tr_id);
			}
		}
	}
	function check_num_daxiao(tr_id) {
		var use_num = document.getElementById("work_hours" + tr_id).value;
		var self_num = document.getElementById("self_num" + tr_id).value;
		var baseData;
		baseData = jcdpCallService("DevInsSrv", "getdeviceBigHour", "self_num="+self_num);
		var biggest_work_hour = baseData.datas.biggest_work_hour;
		if (use_num<biggest_work_hour) {
			alert("你输入的小时数小于目前该设备的最大小时数:"+biggest_work_hour+"!");
			document.getElementById("work_hours" + tr_id).value = "";
			document.getElementById("work_hours" + tr_id).focus();
			return false;
		}
	}
	//根据自编号查询最新工作小时数
	function checkWorkHour(tr_id){
		var work_hours = document.getElementById("work_hours" + tr_id).value;
		var self_num = document.getElementById("self_num" + tr_id).value;
		//查找该自编号设备的最新工作小时数
		var baseData = jcdpCallService("DevZcjByItemSrv", "getWorkHourBySelf","self_num=" + self_num);
		if (baseData.datas != null) {
			if(baseData.datas.hours>parseInt(work_hours)){
				alert("该设备运行小时数大于当前设置的值。");
				return ;
			}
		}
	}
	//选择总成件名称  保养级别和保养内容变为不可用
	function changeZcj(trId){
		var value=$("#zcj_type"+trId+"  option:selected").text();
		if(value=='无' || value=='其他'){
			$("#maintenance_level"+trId).removeAttr("disabled");
			$("#maintenance_desc"+trId).removeAttr("readonly");
		}else{
			$("#maintenance_level"+trId).attr('disabled','disabled ');
			$("#maintenance_desc"+trId).attr('readonly','readonly ');
		}
		
	}
	/**
	故障信息方法
	**/
	function  selectGZData(i){
		//先获取到设备编码dev_acc_id,如果没有，不允许进入故障信息，并提示，请选择设备
		var dev_acc_id = document.getElementById("dev_acc_id" + i+"").value;
		if(dev_acc_id==null || dev_acc_id=='' || dev_acc_id=='undefined'){
			alert("请选择设备,再进入故障信息页面");
			return ;
		}
		//获取保养等级
		var usemat_id=document.getElementById("usemat_id"+i+"").value;
		if(usemat_id==null || usemat_id=='' || usemat_id=='undefined'){
			var sql = "select lower(sys_guid()) devicebackappid from dual";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
			if(retObj!=null && retObj.returnCode=='0'){
				usemat_id = retObj.datas[0].devicebackappid;
			}
			document.getElementById("usemat_id"+i+"").value = usemat_id;
		}
		var self_num = document.getElementById("self_num"+i+"").value;
		if(self_num==""){
			alert("自编号不能为空！");
			return ;
		}
		//打开页面需要两个参数1、唯一标识usemat_id
		var selected;
		selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/mutiPorject/selectGzList.jsp?usemat_id="+usemat_id+"&dev_acc_id="+dev_acc_id+"&self_num="+self_num,"","dialogWidth=1240px;dialogHeight=680px");
		if(selected){//true 说明有未解决的故障
			document.getElementById("legacy"+i+"").value="有";
		}else{
			document.getElementById("legacy"+i+"").value="无";
		}
	}
</script>
</html>