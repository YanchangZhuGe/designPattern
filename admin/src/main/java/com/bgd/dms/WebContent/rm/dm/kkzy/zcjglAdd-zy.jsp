<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>

<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	
	String userSubid = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String wx_ids=request.getParameter("wx_ids");
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title></title>
</head>
<body class="bgColor_f3f3f3" onload="load()">
<form name="form1" id="form1" method="post"
	action="">
	<input type='hidden' name='selectWzId' id='selectWzId'/>
	<div id="new_table_box" style="width: 100%">
		<div id="new_table_box_content" style="width: 100%">
			<div id="new_table_box_bg" style="width: 95%">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td style="width: 90%"></td>
							<td><span class="zj"><a href="#" id="addProcess"
									name="addXgllEqSelect" onclick="toAddzy()"></a></span></td>
							<auth:ListButton id="zj1" functionId="" css="zj" event="onclick='toAdd()'" title="手工录入"></auth:ListButton>		
							<td><span class="sc"><a href="#" id="delProcess"
									name="delXgllEq" onclick="deleteMatHave()"></a></span></td>
							<td style="width: 1%"></td>
						</tr>
					</table>
				</div>
				<fieldset style="margin-left: 2px">
					<legend>可控震源主要总成件维修记录录入</legend>
					<div style="height: 300px; overflow: auto">
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height" >
							<tr>
						    <td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
								<td class="bt_info_even" width="12%">日期</td>
								<td class="bt_info_odd" width="8%">总成件名称</td>
							    <td class="bt_info_odd" width="8%">型号</td>
								<td class="bt_info_even" width="12%">系列号</td>
								<td class="bt_info_even" width="15%">自编号</td>
								
								<td class="bt_info_odd" width="12%">累计运转小时</td>
								<td class="bt_info_odd" width="13%">修理级别</td>
								<td class="bt_info_odd" width="13%">主要修理内容</td>
								<td class="bt_info_even" width="15%">主要装配尺寸及性能指标</td>
								<td class="bt_info_odd" width="12%">主修人</td>
								<td class="bt_info_odd" width="12%">承修单位</td>
								<td class="bt_info_odd" width="12%">验收人</td>
								<td class="bt_info_even" width="15%">备注</td>

							</tr>
							<tbody id="processtable0" name="processtable0">
							</tbody>
						</table>
					</div>
				</fieldset>


			</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
		</div>
	</div>

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
		alert('请录入总成件维修信息！');
		return;
	}
	var selectedlines = line_infos.split("~");
	var wronglineinfos = "";
	for(var index=0;index<selectedlines.length;index++){
		var wx_date = $("#wx_date"+selectedlines[index]).val();
		var zcj_name = $("#zcj_name"+selectedlines[index]).val();
		var work_hour = $("#work_hour"+selectedlines[index]).val();
		var self_num = $("#self_num"+selectedlines[index]).val();
		var wx_level = $("#wx_level"+selectedlines[index]).val();
		var worker_unit = $("#worker_unit"+selectedlines[index]).val();
		if(wx_date == "" || zcj_name == "" || wx_level=="" || worker_unit==""){
			if(index == 0){
				wronglineinfos += (parseInt(selectedlines[index])+1);
			}else{
				wronglineinfos += ","+(parseInt(selectedlines[index])+1);
			}
		}
	}
	if(wronglineinfos!=""){
		alert("请设置第"+wronglineinfos+"行明细的总成件维修记录!");
		return;
	}
	document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveZcjwxInfo.srq?count="+count+"&line_infos="+line_infos;
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
	function load()
	{
		var wx_ids=<%=wx_ids%>;
			var baseData;
			 baseData = jcdpCallService("DevInsSrv", "getzcjwxInfos", "wx_ids="+wx_ids);
			//通过查询结果动态填充使用情况select;
				var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000189' and bsflag='0'";
				var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
				usingdatas = queryRet.datas;
				
				var zcjtypeSql="select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0'";
				var zcjtytpeRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+zcjtypeSql);
			    var zcjtypedatas = zcjtytpeRet.datas;
				if(baseData.datas!=null)
				{
					for (var i = 0; i< baseData.datas.length; i++) {
						tr_id=$("#processtable0 tr").length;
						var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
						innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='"+baseData.datas[i].dev_acc_id+"' size='16'  type='hidden' />";
						innerhtml += "<input name='zcjwx_id"+tr_id+"' id='zcjwx_id"+tr_id+"' value='"+baseData.datas[i].zcjwx_id+"' size='16'  type='hidden' />";
						innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
						innerhtml += "<td><input name='wx_date"+tr_id+"' id='wx_date"+tr_id+"' value='"+baseData.datas[i].wx_date+"' size='16' readonly />";
						innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(wx_date"+tr_id+",tributton2"+tr_id+");'/></td>";
						innerhtml += "<td align='center'><select name='zcj_name"+tr_id+"' id='zcj_name"+tr_id+"'><option > 请选择</option>";
						if(zcjtypedatas != null){
							for (var j = 0; j< zcjtypedatas.length; j++) {
								if(baseData.datas[i].zcj_name==zcjtypedatas[j].coding_code_id){
									innerhtml +=  "<option  selected value='"+zcjtypedatas[j].coding_code_id+"'>"+zcjtypedatas[j].coding_name+"</option>";
								}else{
									innerhtml +=  "<option   value='"+zcjtypedatas[j].coding_code_id+"'>"+zcjtypedatas[j].coding_name+"</option>";
								}
								
							}
						}
						innerhtml += "</select></td>";
						innerhtml += "<td  align='center'><input name='zcj_model"+tr_id+"' id='zcj_model"+tr_id+"' value='"+baseData.datas[i].zcj_model+"' size='16' /></td>";
						innerhtml += "<td  align='center'><input name='sequence"+tr_id+"' id='sequence"+tr_id+"' value='"+baseData.datas[i].sequence+"' size='16' /></td>";
						innerhtml += "<td  align='center'>"+baseData.datas[i].self_num+"</td>";
						innerhtml += "<td  align='center'><input name='work_hour"+tr_id+"' id='work_hour"+tr_id+"' value='"+baseData.datas[i].work_hour+"' size='16' /></td>";
						innerhtml += "<td  align='center'><select name='wx_level"+tr_id+"' id='wx_level"+tr_id+"'>";
						if(usingdatas != null){
							for (var j = 0; j< usingdatas.length; j++) {
								if(baseData.datas[i].zcj_type==usingdatas[j].coding_code_id)
									{
									innerhtml +=  "<option selected   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
									}
								innerhtml +=  "<option   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
							}
						
						}
						innerhtml +="</select></td>";
						innerhtml += "<td  align='center'> <input name='wx_content"+tr_id+"' id='wx_content"+tr_id+"' value='"+baseData.datas[i].wx_content+"' size='16' /></td>";
						innerhtml += "<td  align='center'><input name='performance_desc"+tr_id+"' id='performance_desc"+tr_id+"' value='"+baseData.datas[i].performance_desc+"' size='16' /></td>";

						innerhtml += "<td  align='center'><input name='worker"+tr_id+"' id='worker"+tr_id+"' value='"+baseData.datas[i].worker+"' size='16' /></td>";
						innerhtml += "<td  align='center'><input name='worker_unit"+tr_id+"' id='worker_unit"+tr_id+"' value='"+baseData.datas[i].worker_unit+"' size='16' /></td>";
						innerhtml += "<td  align='center'><input name='accepter"+tr_id+"' id='accepter"+tr_id+"' value='"+baseData.datas[i].accepter+"' size='16' /></td>";

						innerhtml += "<td><input name='bak"+tr_id+"' id='bak"+tr_id+"' value='"+baseData.datas[i].bak+"' size='16' /></td>";
						$("#processtable0").append(innerhtml);
						}
				
					$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
					$("#processtable0>tr:odd>td:even").addClass("odd_even");
					$("#processtable0>tr:even>td:odd").addClass("even_odd");
					$("#processtable0>tr:even>td:even").addClass("even_even");
					}
		
	}
	
function refreshData(){
	var wz_id=document.getElementById("selectWzId").value;
	var baseData;
	 baseData = jcdpCallService("DevInsSrv", "getdeviceZyInfos", "wz_id="+wz_id);
		if(baseData.datas!=null)
		{

			//通过查询结果动态填充使用情况select;
			var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000189' and bsflag='0'";
			var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			usingdatas = queryRet.datas;
			
			var zcjtypeSql="select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0'";
			var zcjtytpeRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+zcjtypeSql);
		    var zcjtypedatas = zcjtytpeRet.datas;
			
			for (var i = 0; i< baseData.datas.length; i++) {
				tr_id=$("#processtable0 tr").length;
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
				innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='"+baseData.datas[i].dev_acc_id+"' size='16'  type='hidden' />";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
				innerhtml += "<td><input name='wx_date"+tr_id+"' id='wx_date"+tr_id+"' value='' size='16' readonly />";
				innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(wx_date"+tr_id+",tributton2"+tr_id+");'/></td>";
				innerhtml += "<td align='center'><select name='zcj_name"+tr_id+"' id='zcj_name"+tr_id+"'><option > 请选择</option>";
				if(zcjtypedatas != null){
					for (var j = 0; j< zcjtypedatas.length; j++) {
						innerhtml +=  "<option   value='"+zcjtypedatas[j].coding_code_id+"'>"+zcjtypedatas[j].coding_name+"</option>";
					}
				}
				innerhtml += "</select></td>";
				innerhtml += "<td><input name='zcj_model"+tr_id+"' id='zcj_model"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><input name='sequence"+tr_id+"' id='sequence"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td>"+baseData.datas[i].self_num+"</td>";
				innerhtml += "<td><input name='work_hour"+tr_id+"' id='work_hour"+tr_id+"' value='' size='16'  onkeyup='this.value=this.value.replace(/\D/g,'')' onafterpaste='this.value=this.value.replace(/\D/g,'')'/></td>";
				innerhtml += "<td><select name='wx_level"+tr_id+"' id='wx_level"+tr_id+"'>";
				if(usingdatas != null){
					for (var j = 0; j< usingdatas.length; j++) {
						innerhtml +=  "<option   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
					}
				}
				innerhtml +="</select></td>"
				innerhtml += "<td><input name='wx_content"+tr_id+"' id='wx_content"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><input name='performance_desc"+tr_id+"' id='performance_desc"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><input name='worker"+tr_id+"' id='worker"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><input name='worker_unit"+tr_id+"' id='worker_unit"+tr_id+"' value='' size='16' /></td>";
				innerhtml += "<td><input name='accepter"+tr_id+"' id='accepter"+tr_id+"' value='' size='16' /></td>";
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
	var selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/selectkkzyLists.jsp?selectWzId="+selectWzId,"","dialogWidth=1240px;dialogHeight=480px");
	var wz_id = selected;
	document.getElementById("selectWzId").value = wz_id;
	if(selected!=null&&selected!=""){
		refreshData();
	}
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
var tr_id=0;
function toAdd()
{
	//通过查询结果动态填充使用情况select;
	var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000189' and bsflag='0'";
	var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
	usingdatas = queryRet.datas;
	
	
	var zcjtypeSql="select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0'";
	var zcjtytpeRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+zcjtypeSql);
    var zcjtypedatas = zcjtytpeRet.datas;
	
	tr_id=$("#processtable0 tr").length;
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<td>&nbsp;<input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
	
	innerhtml += "<td>&nbsp;<input name='wx_date"+tr_id+"' id='wx_date"+tr_id+"' value='' size='16' readonly />";
	innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(wx_date"+tr_id+",tributton2"+tr_id+");'/></td>";
	innerhtml += "<td align='center'>&nbsp;<select name='zcj_name"+tr_id+"' id='zcj_name"+tr_id+"'><option > 请选择</option>";
	if(zcjtypedatas != null){
		for (var j = 0; j< zcjtypedatas.length; j++) {
			innerhtml +=  "<option   value='"+zcjtypedatas[j].coding_code_id+"'>"+zcjtypedatas[j].coding_name+"</option>";
		}
	}
	innerhtml += "</select></td>";
	innerhtml += "<td>&nbsp;<input name='zcj_model"+tr_id+"' id='zcj_model"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input name='sequence"+tr_id+"' id='sequence"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input type='text'  id='self_num"+tr_id+"'  name='self_num"+tr_id+"' value='' onblur='checkSelf("+tr_id+")' size='16' ></td>";
	innerhtml += "<td>&nbsp;<input name='work_hour"+tr_id+"' id='work_hour"+tr_id+"' value='' size='16'  onkeyup='this.value=this.value.replace(/\D/g,'')' onafterpaste='this.value=this.value.replace(/\D/g,'')'/></td>";
	innerhtml += "<td>&nbsp;<select name='wx_level"+tr_id+"' id='wx_level"+tr_id+"'>";
	if(usingdatas != null){
		for (var j = 0; j< usingdatas.length; j++) {
			innerhtml +=  "<option   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
		}
	}
	innerhtml +="</select></td>";
	innerhtml += "<td align='center'>&nbsp;<input name='wx_content"+tr_id+"' id='wx_content"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input name='performance_desc"+tr_id+"' id='performance_desc"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input name='worker"+tr_id+"' id='worker"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input name='worker_unit"+tr_id+"' id='worker_unit"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input name='accepter"+tr_id+"' id='accepter"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td>&nbsp;<input name='bak"+tr_id+"' id='bak"+tr_id+"' value='' size='16' /></td>";
	$("#processtable0").append(innerhtml);
	
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
        document.getElementById("self_num"+num).focus();   
       return false;   
    }
    var sql = "select dev_acc_id from gms_device_account dui where dui.project_info_id='<%=projectInfoNo%>' and dui.dev_type like 'S062301SQL_LIKE_PERCENT' and dui.self_num='"+self_num+"' ";
    baseData = jcdpCallService("DevInsSrv", "getZyInfoForSelfNums", "self_num="+self_num);
    if(baseData.data!=null)
	{
    	 document.getElementById("dev_acc_id"+num).value=baseData.data.dev_acc_id;
	}
	else
	{
		  alert("请输入有效的自编号!");
		  document.getElementById("self_num"+num).value="";
	      document.getElementById("self_num"+num).focus();   
		return false;
	}
}

	
	
}
</script>
</html>