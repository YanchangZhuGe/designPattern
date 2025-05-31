<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo= user.getProjectInfoNo();
	boolean proc_status = OPCommonUtil.getProcessStatus("BGP_OP_TARGET_PROJECT_BASIC","tartget_basic_id","5110000004100000009",projectInfoNo);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	Map map = OPCommonUtil.getProjectDate(projectInfoNo);
	String end_date = map==null || map.get("planned_finish_date")==null?df.format(new Date()):(String)map.get("planned_finish_date");
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
					    <auth:ListButton css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton> 
					    <%if(proc_status){ %>
					    <auth:ListButton functionId="OP_ACTUAL_RENT_EDIT" css="qr" event="onclick='toImport()'" title="JCDP_btn_add"></auth:ListButton>
					    <auth:ListButton functionId="OP_ACTUAL_RENT_EDIT" css="zj" event="onclick='toAdd()'" functionId="OP_ACTUAL_RENT_EDIT"  title="JCDP_btn_add"></auth:ListButton>
					    <auth:ListButton functionId="OP_ACTUAL_RENT_EDIT" css="xg" event="onclick='toEdit()'"  functionId="OP_ACTUAL_RENT_EDIT"  title="JCDP_btn_edit"></auth:ListButton>
					    <auth:ListButton functionId="OP_ACTUAL_RENT_EDIT" css="sc" event="onclick='toDelete()'"  functionId="OP_ACTUAL_RENT_EDIT"  title="JCDP_btn_delete"></auth:ListButton>
					    <auth:ListButton functionId="OP_ACTUAL_RENT_EDIT" css="bc" event="onclick='saveDatas()'"  functionId="OP_ACTUAL_RENT_EDIT"  title="JCDP_save"></auth:ListButton>
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
		            <td class="bt_info_even" exp="{dev_model}">型号</td>
		            <td class="bt_info_odd" exp="{self_num}">自编号</td>
				 	<td class="bt_info_even" exp="{license_num}">牌照号</td>
				 	<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>	
		            <td class="bt_info_even" exp="{asset_coding}">AMIS资产编号</td>
		            <td class="bt_info_odd" exp="{actual_start_date}">实际进队时间</td>
		            <td class="bt_info_even" exp="{actual_end_date}">实际离开时间</td>
		            <td class="bt_info_even" exp="{actual_num}" >使用时间</td>
		            <td class="bt_info_odd" exp="<input name='taxi_unit' id='{target_rent_id}' value='{taxi_unit}' type='text' style='width: 70px'/>">租赁单价 </td>
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
	<div class="lashen" id="line"></div>
	<div id="tag-container_3">
		  <ul id="tags" class="tags">
		    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">设备基本信息</a></li>
		  </ul>
	</div>
	<div id="tab_box" class="tab_box">
		<div id="tab_box_content0" class="tab_box_content">
			<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
		    	<tr>
				    <td class="inquire_item6">设备名称</td>
				    <td class="inquire_form6"><input id="dev_acc_name" name="dev_acc_name"  class="input_width" type="text" /></td>
				    <td class="inquire_item6">规格型号</td>
				    <td class="inquire_form6"><input id="dev_acc_model" name="dev_acc_model" class="input_width" type="text" /></td>
				    <td class="inquire_item6">设备编码</td>
				    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" /></td>
				 </tr>
				 <tr>
				    <td class="inquire_item6">AMIS资产编号</td>
				    <td class="inquire_form6"><input id="dev_acc_assetcoding" name="" class="input_width" type="text" /></td>
				    <td class="inquire_item6">实物标识号</td>
				    <td class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" /></td>
				    <td class="inquire_item6">自编号</td>
				    <td class="inquire_form6"><input id="dev_acc_self" name="" class="input_width" type="text" /></td>
				  </tr>
				    <tr>
				    <td class="inquire_item6">主机序列号</td>
				    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" /></td>
				    <td class="inquire_item6">出厂编号</td>
				    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" /></td>
				    <td class="inquire_item6">出厂日期</td>
				    <td class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" /></td>
				  </tr>
				   <tr>
				    <td class="inquire_item6">牌照号</td>
				    <td class="inquire_form6"><input id="dev_acc_license" name="" class="input_width" type="text" /></td>
				    <td class="inquire_item6">发动机号</td>
				    <td class="inquire_form6"><input id="dev_acc_engine_num" name="" class="input_width" type="text" /></td>
				    <td class="inquire_item6">底盘号</td>
				    <td class="inquire_form6"><input id="dev_acc_chassis_num" name="" class="input_width" type="text" /></td>
				  </tr>
				    <tr>
				    <td class="inquire_item6">资产状况</td>
				    <td class="inquire_form6"><input id="dev_acc_asset_stat" name="" class="input_width" type="text" /></td>
				    <td class="inquire_item6">技术状况</td>
				    <td class="inquire_form6"><input id="dev_acc_tech_stat" name="" class="input_width" type="text" /></td>
				    <td class="inquire_item6">是否停用</td>
				    <td class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" /></td>
				  </tr>
				               
	        </table>
		</div>
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
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	$(document).ready(lashen);
	// 复杂查询
	function refreshData(){
		var dev_team = document.getElementById("dev_team").value;
		var dev_name = document.getElementById("dev_name").value;
		var dev_model = document.getElementById("dev_model").value;
		cruConfig.queryStr = "select t.*,d.coding_name dev_team1,t.device_count*(nvl(t.actual_end_date,to_date('<%=end_date%>','yyyy-MM-dd'))-t.actual_start_date+1)*t.taxi_unit sum_money, " +
		" (nvl(t.actual_end_date,to_date('<%=end_date%>','yyyy-MM-dd'))-t.actual_start_date+1) actual_num from bgp_op_target_device_rent t left join comm_coding_sort_detail d on t.dev_team = d.coding_code_id " +
		" where t.bsflag ='0' and t.if_change ='2' and t.project_info_no ='<%=projectInfoNo%>' and (t.dev_name is null or t.dev_name like '%"+dev_name+"%') "+
		" and (t.dev_team is null or t.dev_team like'%"+dev_team+"%') and (t.dev_model is null or t.dev_model like '%"+dev_model+"%') ";
		queryData(1);
	}
	refreshData();
	function loadDataDetail(id){
		if(id==null || id=='')return;
		var querySql = "select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from gms_device_account_dui t where dev_acc_id= (select dev_acc_id from bgp_op_target_device_rent where bsflag ='0' and target_rent_id='"+id+"')";
		var queryRet = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
		var retObj = queryRet.datas;
		if(retObj!=null && queryRet.returnCode =='0' && retObj[0]!=null){
			$("#dev_acc_name").val(retObj[0].dev_name);
			$("#dev_acc_sign").val(retObj[0].dev_sign);
			$("#dev_acc_model").val(retObj[0].dev_model);
			$("#dev_acc_self").val(retObj[0].self_num);
			$("#dev_acc_license").val(retObj[0].license_num);
			$("#dev_acc_assetcoding").val(retObj[0].asset_coding);
			$("#dev_acc_using_stat").val(retObj[0].using_stat_desc);
			$("#dev_acc_tech_stat").val(retObj[0].tech_stat_desc);
			$("#dev_acc_producting_date").val(retObj[0].producting_date);
			$("#dev_acc_engine_num").val(retObj[0].engine_num);
			$("#dev_acc_chassis_num").val(retObj[0].chassis_num);
			$("#dev_acc_asset_stat").val(retObj[0].account_stat_desc);
			$("#dev_acc_asset_value").val(retObj[0].asset_value);
			$("#dev_acc_net_value").val(retObj[0].net_value);
			$("#dev_type").val(retObj[0].dev_type);
		}else{
			$("#dev_acc_name").val("");
			$("#dev_acc_sign").val("");
			$("#dev_acc_model").val("");
			$("#dev_acc_self").val("");
			$("#dev_acc_license").val("");
			$("#dev_acc_assetcoding").val("");
			$("#dev_acc_using_stat").val("");
			$("#dev_acc_tech_stat").val("");
			$("#dev_acc_producting_date").val("");
			$("#dev_acc_engine_num").val("");
			$("#dev_acc_chassis_num").val("");
			$("#dev_acc_asset_stat").val("");
			$("#dev_acc_asset_value").val("");
			$("#dev_acc_net_value").val("");
			$("#dev_type").val("");
		}
	}

	function clearQueryText(){
		document.getElementById("dev_team").options[0].selected = true;
		document.getElementById("dev_name").value = "";
		document.getElementById("dev_model").value = "";
		refreshData();
	}
	
	function toAdd(){
	  	popWindow('<%=contextPath%>/op/costActualManager/costTargetActualDevRentEdit.jsp');
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
		popWindow('<%=contextPath%>/op/costActualManager/costTargetActualDevRentEdit.jsp?target_rent_id='+ids);
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
		var sql = "update bgp_op_target_device_rent t set t.bsflag='1' where t.target_rent_id in('"+ids+"')";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		syncRequest('Post',path,params);
		var project_info_no ='<%=projectInfoNo%>';
		sql += "update bgp_op_tartet_device_depre t set t.bsflag ='1' where t.bsflag ='0' and t.record_type ='0' and t.project_info_no ='"+project_info_no+"'"+
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
	function toImport(){
		submitStr='projectInfoNo=<%=projectInfoNo%>'
		if(confirm("将从设备业务中导入最新的设备信息，并同时删除掉现有从设备中获取的数据，是否确定导入")){
			var retObj = jcdpCallService("OPCostSrv", "getDepreDevicePlanInfoFromDm", submitStr);
			if(retObj.success=="true"){
				alert("导入设备信息成功");
				refreshData();
			}
		}
	}
	function getSum(){
		var project_info_no = '<%=projectInfoNo%>';
		var querySql = "select sum(nvl(t.device_count*(nvl(t.actual_end_date,to_date('<%=end_date%>','yyyy-MM-dd'))-t.actual_start_date+1)*t.taxi_unit,0)) sum_value"+
			" from bgp_op_target_device_rent t where t.project_info_no='<%=projectInfoNo%>'"+
			" and t.if_change ='2' and t.bsflag='0'";
		var retObj = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
		if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
			var sum_value = retObj.datas[0].sum_value;
			document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
		}	
	}
</script>
</body>
</html>