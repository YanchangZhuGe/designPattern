<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo= user.getProjectInfoNo();
	boolean proc_status = OPCommonUtil.getProcessStatus2("BGP_OP_TARGET_PROJECT_INFO","gp_target_project_id","5110000004100000032",projectInfoNo);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	Map map = OPCommonUtil.getProjectDate(projectInfoNo);
	String end_date = map==null || map.get("planned_finish_date")==null?df.format(new Date()):(String)map.get("planned_finish_date");
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
<title>设备折旧费测算表</title>
</head>
<body style="background:#fff" onload="refreshData()">
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			   <td class="ali_cdn_name">班组</td>
			    <td class="ali_cdn_input"><input id="team_name" name="team_name" class="input_width" type="text"/></td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input"><input id="dev_sign" name="dev_sign" class="input_width" type="text"/>
			    <input id="popstr" name="popstr" class="input_width" type="hidden"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			  <td>&nbsp;</td>
			  <td align="right" style="padding-right: 20px;"><font color="red"><span id="sum_value"></span></font></td>
			  <auth:ListButton css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton>
				<%if(proc_status){ %>
				<auth:ListButton functionId="OP_ACTUAL_DEP_EDIT" css="qr" event="onclick='toImport()'" title="JCDP_btn_add"></auth:ListButton>
				<auth:ListButton functionId="OP_ACTUAL_DEP_EDIT" css="bc" event="onclick='saveDatas()'" title="JCDP_btn_add"></auth:ListButton>
				<auth:ListButton functionId="OP_ACTUAL_DEP_EDIT" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			  	<auth:ListButton functionId="OP_ACTUAL_DEP_EDIT" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			  	<auth:ListButton functionId="OP_ACTUAL_DEP_EDIT" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  <%} %>
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
			    		<td class="bt_info_odd"><input id="checkbox" name="checkbox" onclick="checkAllNodes()" name="rdo_entity_id"  type="checkbox"/></td>
			    	    <td class="bt_info_even">序号</td>
			    	    <td class="bt_info_odd">班组</td>
			            <td class="bt_info_even">设备名称</td>
			            <td class="bt_info_odd">数量</td>
			            <td class="bt_info_even">规格型号</td>
			            <td class="bt_info_odd">自编号</td>
			            <td class="bt_info_even">牌照号</td>
			            <td class="bt_info_odd">实物标识号</td>
			            <td class="bt_info_even">AMIS资产编号</td>
			            <td class="bt_info_odd">实际进队时间</td>
			            <td class="bt_info_even">实际离开时间</td>
			            <td class="bt_info_odd">使用时间</td>
			            <td class="bt_info_even">设备原值(元)</td>
			            <td class="bt_info_odd">折旧年限(年)</td>
			            <td class="bt_info_even">月提取折旧额及资产占用费（元）</td>
			            <td class="bt_info_odd" onclick="getSum()">本项目承担折旧额及资产占用费（元）</td>
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
						    <td class="inquire_form6"><input id="dev_acc_name" name=""  class="input_width" type="text" /></td>
						    <td class="inquire_item6">规格型号</td>
						    <td class="inquire_form6"><input id="dev_acc_model" name="" class="input_width" type="text" /></td>
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
</body>
<script type="text/javascript">

$(document).ready(readyForSetHeight);

frameSize();

$(document).ready(lashen);	

cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.pageSize=10;
var rowsCount=0;
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getDeviceActualDepreInfo&projectInfoNo=<%=projectInfoNo%>";

function simpleSearch(){
	refreshData();
}

function clearQueryText(){
	$("#team_name").val('');
	$("#dev_sign").val('');
	$("#popstr").val('');
	refreshData();
}


function refreshData(ids){
	if(ids==undefined||ids==""||ids==null) ids=cruConfig.currentPage;
	if(ids==0)ids=1;
	var submitStr = "currentPage="+ids+"&pageSize="+cruConfig.pageSize;
	
	if($("#team_name").val()!=''){
		submitStr+="&teamName="+$("#team_name").val();
	}
	if($("#dev_sign").val()!=''){
		submitStr+="&licenseNum="+$("#dev_sign").val();
	}
	
	submitStr+=$("#popstr").val();
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
            
            var td = tr.insertCell(0);
    		td.innerHTML ='<INPUT id="fy'+i+'checkbox" name="rdo_entity_id"  value='+datas[i].targetDepreId+' type=checkbox>'+
    		'<input type="hidden" id="fy'+i+'dev_acc_id" name="fy'+i+'dev_acc_id" value="'+datas[i].devAccId+'" class="input_width"/>'

    		
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
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].selfNum;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].licenseNum;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].devSign;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].assetCoding;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].actualStartDate;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].actualEndDate;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].dateNum;
			
			var td = tr.insertCell();
			td.innerHTML=datas[i].assetValue;
			
			var td = tr.insertCell();
			td.innerHTML="<input type='text' id='fy"+i+"depreciation_value' name='fy"+i+"depreciation_value' value='"+datas[i].depreciationValue+"' class='input_width'/>"+
			"<input type='hidden' id='fy"+i+"target_depre_id' name='fy"+i+"target_depre_id' value='"+datas[i].targetDepreId+"' class='input_width'/>";
				
			var td = tr.insertCell();
			td.innerHTML = datas[i].sumMonthDepreciation;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].sumDepreciation;
			
			
			
		}
	}
	var tbObj=document.getElementById("editionList");
	changeTrBackground(tbObj);
}
 dataInfo={
		 depreciation_value:"",
		 target_depre_id:""
 };
 
 dataInfoForSum={
		 sum_depreciation:"本项目承担折旧额及资产占用费（元）"
 };
 
 function saveDatas(){
	 var submitStr=getCheckTrInfo();
	 if(submitStr.indexOf("checkNums")==-1){
		 alert("请勾选需要保存的数据!");
		 return;
	 }
	  submitStr=submitStr+'&tableName=bgp_op_tartet_device_depre'
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
	 
	//deviceInfo
	if(deviceId==null || deviceId=='')return;
	var querySql = "select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from GMS_DEVICE_ACCOUNT_DUI t where dev_acc_id= '"+deviceId+"'";
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
function toAdd(){
	popWindow(cruConfig.contextPath+"/op/costActualManager/costTargetActualDeviceRcEdit.jsp");
}
function toModify(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	popWindow(cruConfig.contextPath+"/op/costActualManager/costTargetActualDeviceRcEdit.jsp?target_depre_id="+ids);
}
function toDelete(){
	ids = getSelIds('rdo_entity_id');
	if(ids == '') {
		alert("请选择一条记录!");
		return;
	}
	if(!window.confirm("确认要删除吗?")) {
		return;
	}
	ids = ids.replace(/\,/g,"','");
	var sql = "update bgp_op_tartet_device_depre t set t.bsflag ='1' where t.target_depre_id in('"+ids+"')";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	var project_info_no ='<%=projectInfoNo%>';
	var sql = "update bgp_op_target_device_rent t set t.bsflag ='1' where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
	" and t.dev_acc_id in (select dd.dev_acc_id from bgp_op_tartet_device_depre dd where dd.target_depre_id in ('"+ids+"'));";
	var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
	refreshData();
}
function getSum(){
	var project_info_no = '<%=projectInfoNo%>';
	var querySql = "select sum(nvl(to_char(td.asset_value*0.97/td.depreciation_value/8*td.device_count/30*(nvl(td.actual_end_date,to_date('<%=end_date%>','yyyy-MM-dd'))-nvl(da.actual_in_time,td.actual_start_date)+1),'9999999999999999.00'),0)) sum_value"+
	" from bgp_op_tartet_device_depre td left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id "+
	" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id"+
	" where td.bsflag='0' and  td.project_info_no = '"+project_info_no+"'  and td.record_type='0'  and td.if_actual_change is null and td.if_delete_change is null";
	var retObj = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
	if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
		debugger;
		var sum_value = retObj.datas[0].sum_value;
		document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
	}	
}
</script>

</html>

