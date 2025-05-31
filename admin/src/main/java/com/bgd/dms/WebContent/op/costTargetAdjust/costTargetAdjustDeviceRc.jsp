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
	boolean proc_status = OPCommonUtil.getProcessStatus2("BGP_OP_TARGET_PROJECT_INFO","gp_target_project_id","5110000004100000014",projectInfoNo);
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
			    <td class="ali_cdn_input"><select id="dev_team" name="dev_team" onchange="refreshData()" class="select_width"><option value="">请选择</option></select></td>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="dev_name" name="dev_name" class="input_width" type="text"/></td>
			    <td class="ali_cdn_name">型号</td>
			    <td class="ali_cdn_input"><input id="dev_model" name="dev_model" class="input_width" type="text"/></td>
			    <td class="ali_query"><span class="cx"><a href="#" onclick="refreshData()" title="JCDP_btn_query"></a></span></td>
			    <td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>
			  <td>&nbsp;</td>
			  <td align="right" style="padding-right: 20px;"><font color="red"><span id="sum_value"></span></font></td>
				<%if(proc_status){ %>
			     <auth:ListButton functionId="OP_ADJUST_DE_EDIT" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			     <auth:ListButton functionId="OP_ADJUST_DE_EDIT" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			     <auth:ListButton functionId="OP_ADJUST_DE_EDIT" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			    		<td class="bt_info_odd"><INPUT id="checkbox" name="checkbox" onclick="checkAllNodes()" name=rdo_entity_id  type=checkbox></td>
			    	     <td  class="bt_info_even">序号</td>
			            <td class="bt_info_odd">班组</td>
			            <td  class="bt_info_even">设备名称</td>
			            <td  class="bt_info_odd">数量</td>
			            <td  class="bt_info_even">规格型号</td>
			           <!--  <td  class="bt_info_odd">自编号</td>
			            <td  class="bt_info_even">牌照号</td>
			            <td  class="bt_info_odd">实物标识号</td>
			            <td  class="bt_info_even">AMIS资产编号</td> -->
			            <td  class="bt_info_odd">是否变更数据</td>
			            <td  class="bt_info_even">变更日期</td>
			            <td  class="bt_info_odd">预计进队时间</td>
			            <td class="bt_info_even">预计离开时间</td>
			            <td  class="bt_info_odd">预计使用时间</td>
			            <td class="bt_info_even">设备原值(元)</td>
			            <td  class="bt_info_odd">折旧年限(年)</td>
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
  </div>
</body>
<script type="text/javascript">
function setTabBoxHeight(){
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-2);
}

cruConfig.contextPath =  "<%=contextPath%>";
var rowsCount=0;
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getDeviceAdjustDepreInfo&projectInfoNo=<%=projectInfoNo%>";

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
			
			/* var td = tr.insertCell();
			td.innerHTML = datas[i].selfNum;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].licenseNum;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].devSign;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].assetCoding; */
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].changeData;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].changeDate;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].planStartDate;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].planEndDate;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].dateNum;
			
			var td = tr.insertCell();
			td.innerHTML=datas[i].assetValue;
			
			var td = tr.insertCell();
			td.innerHTML=datas[i].depreciationValue;
			
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
		 asset_value:"",
		 depreciation_value:"",
		 target_depre_id:""
 };
 
 dataInfoForSum={
		 sum_depreciation:"本项目承担折旧额及资产占用费（元）"
 };
 
 function saveDatas(){
	 var submitStr=getCheckTrInfo();
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
	 
 }
 
 
function toAdd(){
	popWindow(cruConfig.contextPath+"/op/costTargetAdjust/costTargetAdjustDeviceRcEdit.jsp");
}
function toModify(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	popWindow(cruConfig.contextPath+"/op/costTargetAdjust/costTargetAdjustDeviceRcEdit.jsp?target_depre_id="+ids);
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
	var sql = "update bgp_op_tartet_device_depre t set t.if_delete_change ='1' where t.target_depre_id in('"+ids+"')";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	var project_info_no ='<%=projectInfoNo%>';
	sql = "update bgp_op_tartet_device_oil t set t.if_delete_change ='1' where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
	" and t.dev_acc_id in (select dd.dev_acc_id from bgp_op_tartet_device_depre dd where dd.target_depre_id in ('"+ids+"'));";
	sql += "update bgp_op_tartet_device_material t set t.if_delete_change ='1' where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
	" and t.dev_acc_id in (select dd.dev_acc_id from bgp_op_tartet_device_depre dd where dd.target_depre_id in ('"+ids+"'));";
	sql += "update bgp_op_target_device_rent t set t.if_delete_change ='1' where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
	" and t.dev_acc_id in (select dd.dev_acc_id from bgp_op_tartet_device_depre dd where dd.target_depre_id in ('"+ids+"'));";
	var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
	
	refreshData();
}
function getSum(){
	var project_info_no = '<%=projectInfoNo%>';
	var querySql = "select sum(nvl(to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8*td.device_count/30*(td.plan_end_date-td.plan_start_date+1)),'9999999999999999.00'),0)) sum_value"+
	" from bgp_op_tartet_device_depre td left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id "+
	" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id"+
	" where td.bsflag='0' and  td.project_info_no = '"+project_info_no+"'  and td.record_type='0' and (td.if_change!='2' and  td.if_delete_change is null) ";
	var retObj = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
	if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
		var sum_value = retObj.datas[0].sum_value;
		document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
	}	
}
</script>

</html>

