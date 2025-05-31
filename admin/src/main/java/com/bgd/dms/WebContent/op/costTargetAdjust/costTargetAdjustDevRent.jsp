<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo= user.getProjectInfoNo();
	boolean proc_status = OPCommonUtil.getProcessStatus("BGP_OP_TARGET_PROJECT_BASIC","tartget_basic_id","5110000004100000009",projectInfoNo);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="ali_cdn_name">班组</td>
					    <td class="ali_cdn_input"><select id="dev_team" name="dev_team" onchange="refreshData()" class="select_width"><option value="">请选择</option></select></td>
					    <td class="ali_cdn_name">设备名称</td>
					    <td class="ali_cdn_input"><input id="dev_name" name="dev_name" class="input_width" type="text"/></td>
					     <td class="ali_cdn_name">型号</td>
					    <td class="ali_cdn_input"><input id="dev_model" name="dev_model" class="input_width" type="text"/></td>
					    <td class="ali_query"><span class="cx"><a href="#" onclick="refreshData()" title="JCDP_btn_query"></a></span></td>
					    <td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>
					    <td>&nbsp;</td>
					    <td align="center" ><font color="red"><span id="sum_value"></span></font></td>
					    <%-- <auth:ListButton css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton> --%>
					    <%if(proc_status){ %>
					    <auth:ListButton functionId="OP_ADJUST_RENT_EDIT" css="zj" event="onclick='toAdd()'" functionId="OP_ADJUST_RENT_EDIT"  title="JCDP_btn_add"></auth:ListButton>
					    <auth:ListButton functionId="OP_ADJUST_RENT_EDIT" css="xg" event="onclick='toEdit()'"  functionId="OP_ADJUST_RENT_EDIT"  title="JCDP_btn_edit"></auth:ListButton>
					    <auth:ListButton functionId="OP_ADJUST_RENT_EDIT" css="sc" event="onclick='toDelete()'"  functionId="OP_ADJUST_RENT_EDIT"  title="JCDP_btn_delete"></auth:ListButton>
					    <%} %>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</div>
	<div id="table_box">
		<input id="org_subjection_id" name="org_subjection_id" type="hidden" class="input_width"/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{target_rent_id}' />" >
					<input type='checkbox' name='rdo_entity_id' value='' onclick='check(this)'/></td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_team1}">班组</td>
				 	<td class="bt_info_even" exp="{dev_name}">设备名称</td>
				 	<td class="bt_info_odd" exp="{device_count}">数量</td>	
		            <td  class="bt_info_even" exp="{dev_model}">型号</td>
		            <td  class="bt_info_odd" exp="{change_data}">是否变更数据</td>
		            <td class="bt_info_even" exp="{change_date}">变更日期</td>
		            <td  class="bt_info_odd" exp="{plan_start_date}">预计进队时间</td>
		            <td class="bt_info_even" exp="{plan_end_date}">预计离开时间</td>
		            <td class="bt_info_even" exp="{plan_num}">预计使用时间</td>
		            <td class="bt_info_odd" exp="<input name='taxi_unit' id='{target_rent_id}' value='{taxi_unit}' type='text'  />">租赁单价 </td>
		            <td class="bt_info_even" exp="{sum_money}" onclick="getSum()">合计</td>
			</tr>
		</table>
	</div>
	<div id="fenye_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			<tr>
				<td align="right">第1/1页，共0条记录</td>
				<td width="10">&nbsp;</td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				<td width="50">到 <label><input type="text" name="textfield" id="textfield" style="width:20px;" /></label></td>
				<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
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
	var querySql = "select coding_code_id value,t.coding_name label from comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and length(t.coding_code)=2 and t.spare1='0' order by t.coding_show_id";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
	if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas.length>0){
		for(var i =0;i<retObj.datas.length;i++){
			var map = retObj.datas[i];
			with(map){
				document.getElementById("dev_team").options.add(new Option(label,value));
			}
		}
	}
</script>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-2);
	// 复杂查询
	function refreshData(){
		var dev_team = document.getElementById("dev_team").value;
		var dev_name = document.getElementById("dev_name").value;
		var dev_model = document.getElementById("dev_model").value;
		cruConfig.queryStr = "select t.*,d.coding_name dev_team1,t.device_count*(t.plan_end_date-t.plan_start_date+1)*t.taxi_unit sum_money,decode(t.if_change,'1','变更数据','非变更数据') change_data, " +
		" (t.plan_end_date-t.plan_start_date+1) plan_num from bgp_op_target_device_rent t join comm_coding_sort_detail d on t.dev_team = d.coding_code_id " +
		" where t.bsflag ='0' and t.if_change !='2' and t.if_delete_change is null and t.project_info_no ='<%=projectInfoNo%>' "+
		" and t.dev_team like'%"+dev_team+"%' and t.dev_name like '%"+dev_name+"%' and t.dev_model like '%"+dev_model+"%' ";
		queryData(1);
	}
	refreshData();
	function loadDataDetail(id){

	}

	function clearQueryText(){
		document.getElementById("dev_team").options[0].selected = true;
		document.getElementById("dev_name").value = "";
		document.getElementById("dev_model").value = "";
		refreshData();
	}
	
	function toAdd(){
	  	popWindow('<%=contextPath%>/op/costTargetAdjust/costTargetAdjustDevRentEdit.jsp');
	}

	function toEdit(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	     	return;
	    }
	    if(ids.split(",").length > 1){
	    	alert("只能修改一条记录");
	    	return;
	    }
		popWindow('<%=contextPath%>/op/costTargetAdjust/costTargetAdjustDevRentEdit.jsp?target_rent_id='+ids);
	}
	
	function toDelete(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		ids = ids.replace(/\,/g,"','");
		var sql = "update bgp_op_target_device_rent t set t.if_delete_change='1' where t.target_rent_id in('"+ids+"')";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		syncRequest('Post',path,params);
		var project_info_no ='<%=projectInfoNo%>';
		sql = "update bgp_op_tartet_device_oil t set t.if_delete_change ='1' where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
		" and t.dev_acc_id in (select dr.dev_acc_id from bgp_op_target_device_rent dr where dr.target_rent_id in ('"+ids+"'));";
		sql += "update bgp_op_tartet_device_depre t set t.if_delete_change ='1' where t.bsflag ='0' and t.record_type ='0' and t.project_info_no ='"+project_info_no+"'"+
		" and t.dev_acc_id in (select dr.dev_acc_id from bgp_op_target_device_rent dr where dr.target_rent_id in ('"+ids+"'));";
		sql += "update bgp_op_tartet_device_material t set t.if_delete_change ='1' where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
		" and t.dev_acc_id in (select dr.dev_acc_id from bgp_op_target_device_rent dr where dr.target_rent_id in ('"+ids+"'));";
		var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
		refreshData();
	}
	
	function saveDatas(){
		var sql = "";
		var taxi_units = document.getElementsByName("taxi_unit");
		for(var i =0;i<taxi_units.length;i++){
			var taxi_unit = taxi_units[i];
			sql +="update bgp_op_target_device_rent t set t.taxi_unit='"+taxi_unit.value+"' where target_rent_id ='"+taxi_unit.id+"';";
		}
		var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
		if(retObj!=null && retObj.returnCode == '0'){
			refreshData();
			alert("保存成功!");
		}else{
			alert("保存失败!");
		}
	}
	function exportDeviceInfoFromDm(){
		var project_info_no = '<%=projectInfoNo%>';
		var file_name = encodeURI(encodeURI("设备内部租赁"))
		window.location.href="<%=contextPath%>/op/OPCostSrv/commExportExcel.srq?export_function=exportRent&project_info_no="+project_info_no+"&file_name="+file_name;
	}
	
	function importDeviceInfoFromDm(){
		popWindow(cruConfig.contextPath+"/op/ExcelImport.jsp?path=/op/OPCostSrv/commImportExcel.srq&import_function=importRent");
	}
	
	function getSum(){
		var project_info_no = '<%=projectInfoNo%>';
		var querySql = "select sum(nvl(t.device_count*t.taxi_unit*(t.plan_end_date-t.plan_start_date+1),0)) sum_value"+
			" from bgp_op_target_device_rent t where t.project_info_no='<%=projectInfoNo%>'"+
			" and t.if_change ='0' and t.bsflag='0'";
		var retObj = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
		if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
			var sum_value = retObj.datas[0].sum_value;
			document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
		}	
	}
</script>
</body>
</html>