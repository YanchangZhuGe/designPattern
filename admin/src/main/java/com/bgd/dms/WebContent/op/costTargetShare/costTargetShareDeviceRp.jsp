<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ taglib uri="auth" prefix="auth"%>
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
 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

<title>设备材料费、恢复性修理费测算表</title>
</head>

<body style="background:#fff" onload="refreshData()">
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
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
			  <td align="center" style="padding-right: 20px;"><font color="red"><span id="sum_value"></span></font></td>
			  <auth:ListButton css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton>
			  <%if(proc_status){ %>
			  <auth:ListButton functionId="OP_TARGET_MA_EDIT" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			  <auth:ListButton functionId="OP_TARGET_MA_EDIT" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			  <auth:ListButton functionId="OP_TARGET_MA_EDIT" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  <auth:ListButton functionId="OP_TARGET_MA_EDIT" css="bc" event="onclick='saveDatas()'" title="JCDP_save"></auth:ListButton>
			  <%-- <auth:ListButton functionId="OP_TARGET_MA_EDIT" css="qr" event="onclick='getDeviceInfoFromDm()'" title="JCDP_btn_refresh"></auth:ListButton> --%>
			  <auth:ListButton functionId="OP_TARGET_MA_EDIT" css="dr" event="onclick='importDeviceInfoFromDm()'" title="JCDP_btn_import"></auth:ListButton>
			  <%} %>
			  <auth:ListButton css="dc" event="onclick='exportDeviceInfoFromDm()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			   
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table id="editionList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr class="bt_info">
			    		<td class="bt_info_odd"><INPUT id="checkbox" name="checkbox" onclick="checkAllNodes()" name=rdo_entity_id  type=checkbox></td>
			    	    <td  class="bt_info_even">序号</td>
			            <td class="bt_info_odd">班组</td>
			            <td  class="bt_info_even">设备名称</td>
			            <td  class="bt_info_odd">数量</td>
			            <td  class="bt_info_even">规格型号</td>
			            <!-- <td  class="bt_info_odd">自编号</td>
			            <td  class="bt_info_even">牌照号</td> -->
			            <td  class="bt_info_even">预计进队时间</td>
			            <td class="bt_info_odd">预计离开时间</td>
			            <td  class="bt_info_even">预计使用时间</td>
			            <td class="bt_info_odd">车辆日消耗材料（元）</td>
			            <td  class="bt_info_even">钻机日消耗材料（元）</td>
			            <td class="bt_info_odd" onclick="getSum(1)">车辆材料费(元)</td>
			            <td  class="bt_info_even" onclick="getSum(2)">钻机材料费(元)</td>
			            <td  class="bt_info_odd" onclick="getSum(3)">恢复性修理费(元)</td>
			        </tr>            
			   </table>
			</div>
			<div id="fenye_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			        <tr>
			          <td align="right">第1/1页，共0条记录</td>
			          <td width="10">&nbsp;</td>
			          <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			          <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			          <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			          <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			          <td width="50">到 
			            <label>
			              <input type="text" name="textfield" id="textfield" style="width:20px;" />
			            </label></td>
			          <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			        </tr>
			      </table>
			</div>
  </div>
</body>
<script type="text/javascript">
function setTabBoxHeight(){
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
}

cruConfig.contextPath =  "<%=contextPath%>";
var rowsCount=0;
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getDeviceMaterialShareInfo&projectInfoNo=<%=projectInfoNo%>";

function simpleSearch(){
	refreshData();
}

function clearQueryText(){
	document.getElementById("dev_team").options[0].selected = true;
	document.getElementById("dev_name").value = "";
	document.getElementById("dev_model").value = "";
	refreshData();
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
function refreshData(ids){
	if(ids==undefined||ids==""||ids==null) ids=cruConfig.currentPage;
	if(ids==0)ids=1;
	var submitStr = "currentPage="+ids+"&pageSize="+cruConfig.pageSize;
	
	if($("#dev_team").val()!=''){
		submitStr+="&dev_team="+$("#dev_team").val();
	}
	if($("#dev_name").val()!=''){
		submitStr+="&dev_name="+$("#dev_name").val();
	}
	if($("#dev_model").val()!=''){
		submitStr+="&dev_model="+$("#dev_model").val();
	}
	appConfig.queryListAction = queryListAction;
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,submitStr);
	
	renderNaviTable(tbObj,queryRet);
	
	var datas = queryRet.datas;
	
	deleteTableTr("editionList");
	if(datas != null){
		rowsCount=datas.length;
		for (var i = 0; i< queryRet.datas.length; i++) {
			var tr = document.getElementById("editionList").insertRow();		
             	if(i % 2 == 1){  
             		tr.className = "even";
			}else{ 
				tr.className = "odd";
			}
             	
            var td = tr.insertCell();
    		td.innerHTML = '<INPUT id="fy'+i+'checkbox" name="rdo_entity_id"  value='+datas[i].targetMaterialId+' type=checkbox>'+
    		'<input type="hidden" id="fy'+i+'dev_acc_id" name="fy'+i+'dev_acc_id" value="'+datas[i].devAccId+'" class="input_width"/>'+
    		'<input type="hidden" id="fy'+i+'target_material_id" name="fy'+i+'target_material_id" value="'+datas[i].targetMaterialId+'" class="input_width"/>'+
    		'<input type="hidden" id="fy'+i+'sum_vehicle_daily_material" name="fy'+i+'sum_vehicle_daily_material" value="'+datas[i].sumVehicleDailyMaterial+'" class="input_width"/>'+
    		'<input type="hidden" id="fy'+i+'sum_drilling_daily_material" name="fy'+i+'sum_drilling_daily_material" value="'+datas[i].sumDrillingDailyMaterial+'" class="input_width"/>';
    		
    		var td = tr.insertCell();
			td.innerHTML = datas[i].rownum;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].devTeam;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].devName;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].deviceCount;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].devModel;
			/* 
			var td = tr.insertCell();
			td.innerHTML = datas[i].selfNum;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].licenseNum; */

			var td = tr.insertCell();
			td.innerHTML = datas[i].planStartDate;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].planEndDate;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].dateNum;
			
			var td = tr.insertCell();
			td.innerHTML =  '<input type="text" id="fy'+i+'vehicle_daily_material" name="fy'+i+'vehicle_daily_material" value="'+datas[i].vehicleDailyMaterial+'" class="input_width"/>' ;
			
			var td = tr.insertCell();
			td.innerHTML =  '<input type="text" id="fy'+i+'drilling_daily_material" name="fy'+i+'drilling_daily_material" value="'+datas[i].drillingDailyMaterial+'" class="input_width"/>' ;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].sumVehicleDailyMaterial;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].sumDrillingDailyMaterial;
			
			var td = tr.insertCell();
			td.innerHTML =  '<input type="text" id="fy'+i+'restore_repails" name="fy'+i+'restore_repails" value="'+datas[i].restoreRepails+'" class="input_width"/>' ;
		} 
	}	
	var tbObj=document.getElementById("editionList");
	changeTrBackground(tbObj);
}
 dataInfo={
		 vehicle_daily_material:"",
		 drilling_daily_material:"",
		 restore_repails:"",
		 target_material_id:""
 };
 
 dataInfoForSum={
		 sum_vehicle_daily_material:"车辆材料费(元)",
		 sum_drilling_daily_material:"钻机材料费(元)",
		 restore_repails:"本项目恢复性修理费(元)"
 };
 
 function saveDatas(){
	 var check = document.getElementsByName("rdo_entity_id");
	 var checked = false;
	 for(var i=0;i<check.length;i++){
		 if(check[i].checked){
			 checked = true;
		 }
	 }
	 if(!checked){
		 alert("请选择要修改的记录，可选择多条");
		 return ;
	 }
	 var submitStr=getCheckTrInfo();
	 submitStr=submitStr+'&tableName=bgp_op_tartet_device_material'
	 var retObj = jcdpCallService("OPCostSrv", "saveDeviceShareInfo", submitStr);
	 if(retObj.success=="true"){
		 alert("保存成功");
	 }
	 refreshData();
 }
 function toShare(){
	popWindow(cruConfig.contextPath+"/op/costTargetShare/costTargetProjectDoShare.jsp?moneyInfo="+getCheckDataForSum());
 }
 
function loadDataDetail(clickId,deviceId){
	 
 }
 
 function toAdd(){
	popWindow(cruConfig.contextPath+"/op/costTargetShare/costTargetShareDeviceRpEdit.upmd?pagerAction=edit2Add&projectInfoNo=<%=projectInfoNo%>");
}
function toModify(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	popWindow(cruConfig.contextPath+"/op/costTargetShare/costTargetShareDeviceRpEdit.upmd?pagerAction=edit2Edit&id="+ids+"&projectInfoNo=<%=projectInfoNo%>");
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
	var sql = "update bgp_op_tartet_device_material t set t.bsflag='1' where t.target_material_id in('"+ids+"')";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	var project_info_no ='<%=projectInfoNo%>';
	sql = "update bgp_op_tartet_device_depre t set t.bsflag ='1' where t.bsflag ='0' and t.record_type ='0' and t.project_info_no ='"+project_info_no+"'"+
	" and t.dev_acc_id in (select dm.dev_acc_id from bgp_op_tartet_device_material dm where dm.target_material_id in ('"+ids+"'));";
	sql += "update bgp_op_tartet_device_oil t set t.bsflag ='1' where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
	" and t.dev_acc_id in (select dm.dev_acc_id from bgp_op_tartet_device_material dm where dm.target_material_id in ('"+ids+"'));";
	sql += "update bgp_op_target_device_rent t set t.bsflag ='1' where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
	" and t.dev_acc_id in (select dm.dev_acc_id from bgp_op_tartet_device_material dm where dm.target_material_id in ('"+ids+"'));";
	var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
	refreshData();
}

function importDatas(){
	popWindow(cruConfig.contextPath+"/common/ExcelImportFile.jsp?modelName=OpTargetDeviceMaterial&redirectUrl=/common/close_page.jsp");
}


function getDeviceInfoFromDm(){
	 submitStr='projectInfoNo=<%=projectInfoNo%>'
	 if(confirm("将从设备业务中导入最新的计划设备信息，并同时删除掉现有从设备中获取的数据，是否确定导入")){
		 var retObj = jcdpCallService("OPCostSrv", "getMaterialDevicePlanInfoFromDm", submitStr);
		 if(retObj.success=="true"){
			 alert("导入设备信息成功");
			 refreshData();
		 }
	 }
	 
}
function exportDeviceInfoFromDm(){
	window.location.href="<%=contextPath%>/op/OpCostSrv/exportDeviceInfoForCostRp.srq";
}

function importDeviceInfoFromDm(){
	popWindow(cruConfig.contextPath+"/op/common/ExcelImport.jsp?path=/op/OpCostSrv/importDeviceInfoForCost.srq");
}

function getSum(type){
	var project_info_no = '<%=projectInfoNo%>';
	var querySql = "select sum(nvl(to_char(td.vehicle_daily_material*(td.plan_end_date - td.plan_start_date+1)*td.device_count,'9999999999999999.00'),0)) sum_value1, "+
	" sum(nvl(to_char(td.drilling_daily_material*(td.plan_end_date - td.plan_start_date+1)*td.device_count,'9999999999999999.00'),0)) sum_value2,"+
	" sum(nvl(td.restore_repails,0)) sum_value3 from bgp_op_tartet_device_material td left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id "+
	" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id "+
	" where  td.bsflag='0' and td.project_info_no = '<%=projectInfoNo%>'  and td.if_change ='0'";
	var retObj = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
	if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
		debugger;
		var sum_value = 0;
		if(type==1){
			sum_value = retObj.datas[0].sum_value1;
		}else if(type==2){
			sum_value = retObj.datas[0].sum_value2;
		}else if(type==3){
			sum_value = retObj.datas[0].sum_value3;
		}
		document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
	}	
}
</script>

</html>

