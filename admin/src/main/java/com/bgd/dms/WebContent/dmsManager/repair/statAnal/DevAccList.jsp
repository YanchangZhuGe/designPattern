<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
  	String code = request.getParameter("code");
  	String is_devicecode = request.getParameter("isDeviceCode");
 
 
	String userSubid = user.getOrgSubjectionId();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	String orgId= user.getOrgId();
	String orgType="";
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(orgId)){
		orgType="Y";
	}else{
		orgType="N";
	}
	String zhEquSub="";
	if(userSubid.startsWith("C105008042")){//综合物化探机动设备服务中心用户显示设备物资科设备
		zhEquSub="Y";
	}
	String repairtype=request.getParameter("repairtype");
  	String dev_type=request.getParameter("dev_type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
  <title>多项目-设备台账管理-设备台账管理(单台)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
  <input id="export_name" name="export_name" value="地震仪器" type='hidden' />
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <!--<tr>
			      <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="query_dev_name" name="query_dev_name" type="text" class="input_width"/></td>
			    <td class="ali_cdn_name">设备型号</td>
			    <td class="ali_cdn_input">
			    	<input id="type_id" name="type_id" type="text" class="input_width"/>
      			</td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>		
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>-->
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}' />" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{repairtype}">维修类型</td>
					<td class="bt_info_odd" exp="{orgname}">所属单位</td>
					<td class="bt_info_even" exp="{repair_start_date}">维修开始时间</td>
					<td class="bt_info_even" exp="{repair_end_date}">维修结束时间</td>
					<td class="bt_info_odd" exp="{human_cost}">维修费用</td>
					<td class="bt_info_even" exp="{material_cost}">材料费用</td>
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
		 
</div>
</body>
<script type="text/javascript">
$(function(){
	$(window).resize(function(){
		
		if(lashened==0){
			$("#table_box").css("height",$(window).height()*0.75);
		}
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-10);
		$("#tab_box .tab_box_content").each(function(){
			if($(this).children('iframe').length > 0){
				$(this).css('overflow-y','hidden');
			}
		});
	});
})
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var orgtype = '<%=orgType%>';//大港8个专业化中心判断
	var usersubid = '<%=userSubid%>';

	function searchDevData(){
	var query_dev_name = document.getElementById("query_dev_name").value;
		var query_dev_type = document.getElementById("type_id").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":query_dev_name});
		obj.push({"label":"dev_model","value":query_dev_type});	
		refreshData(obj,'');
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    	document.getElementById("s_dev_model").value="";
		document.getElementById("s_license_num").value="";		
    }
	//点击树节点查询
	var code = '<%=code%>';
	var is_devicecode = '<%=is_devicecode%>';
	var	node_level;
	var repairtype=decodeURI('<%=repairtype%>');
	var dev_type=decodeURI('<%=dev_type%>');
	var subOrgId='<%=subOrgId%>';
	function refreshData(arrObj,numObj){
	var sql="select * from(select dui.dev_name || '(' || dui.dev_model || ')' dev_name,DeviceTreeIdToName(dt.dev_tree_id) dev_type, '项目维修' repairtype, OrgSubIdToName(orginfo.org_subjection_id) orgname, pinfo.repair_start_date, pinfo.repair_end_date, nvl(pinfo.human_cost,0) human_cost, nvl(pinfo.material_cost,0) material_cost from BGP_COMM_DEVICE_REPAIR_INFO pinfo left join gms_device_account_dui dui on dui.dev_acc_id = pinfo.device_account_id left join dms_device_tree dt on dt.device_code = dui.dev_type inner join (select t.project_info_no, org_id from (select p.project_info_no, p.project_name as t_project_name, p.project_type, dy.org_id from gp_task_project p left join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method where 1 = 1 and p.bsflag = '0' and dy.org_subjection_id like 'C105%') t where 1 = 1 and t.project_type in ('5000100004000000001', '5000100004000000002', '5000100004000000010', '5000100004000000007')) t1 on t1.project_info_no = pinfo.project_info_no left join comm_org_subjection orginfo on orginfo.org_id = t1.org_id where pinfo.bsflag = '0' and pinfo.REPAIR_START_DATE between to_date('2017-01-01', 'yyyy-MM-dd') and to_date('2017-09-01', 'yyyy-MM-dd') and pinfo.project_info_no is not null and dt.bsflag = '0' and dt.device_code is not null and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%') union all select account.dev_name || '(' || account.dev_model || ')' dev_name,DeviceTreeIdToName(dt.dev_tree_id) dev_type, (select coding_name from comm_coding_sort_detail where coding_code_id = info.repair_type) as repairtype, OrgSubIdToName(subinfo.org_subjection_id) org_abbreviation， info.repair_start_date, info.repair_end_date, nvl(info.human_cost,0) human_cost, nvl(info.material_cost,0) material_cost from bgp_comm_device_repair_info info inner join gms_device_account account on account.dev_acc_id = info.device_account_id and account.bsflag = '0' left join dms_device_tree dt on dt.device_code = account.dev_type left join comm_org_information orginfo on orginfo.org_id = account.owning_org_id left join comm_org_subjection subinfo on orginfo.org_id = subinfo.org_id where info.bsflag = '0' and info.REPAIR_START_DATE between to_date('2017-01-01', 'yyyy-MM-dd') and to_date('2017-09-11', 'yyyy-MM-dd') and repair_type <> '0110000037000000002' and (info.datafrom <> 'SAP' or info.datafrom is null) and account.owning_sub_id like 'C105%' and account.account_stat in ('0110000013000000003', '0110000013000000001', '0110000013000000006') and dt.bsflag = '0' and dt.device_code is not null and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')) where 1=1 and repairtype='"+repairtype+"' and orgname=(select t1.ORG_ABBREVIATION from comm_org_information t1,comm_org_subjection t2 where t1.org_id=t2.org_id and t2.org_subjection_id='"+subOrgId+"') and dev_type = '"+dev_type+"'";
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
    

	function excelDataAdd(){
		popWindow('<%=contextPath%>/rm/dm/deviceAccount/devExcelAdd.jsp');
		}
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/deviceAccount/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}
		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = "newTitleTable";
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable)-4;
		newTitleTable.style.top=y+"px";
		
		
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd";
			}else{
				tr.cells[i].className="bt_info_even";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}
		
		document.getElementById("table_box").onscroll = resetNewTitleTablePos;
		
	}
	  /**
	 * 选择组织机构树
	 */
	 
	function showOrgTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
		document.getElementById("s_own_org_name").value = returnValue.value;
		
		//var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = returnValue.fkValue;
	}
	function toCopy(){
 		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
	     	return;
	    }
	    var temp = ids.split(",");
		var dev_ids = "";
		for(var i=0;i<temp.length;i++){
			if(dev_ids!=""){
				dev_ids += ","; 
			}
			dev_ids += "'"+temp[i]+"'";
		}
		var baseData;
		 baseData = jcdpCallService("DevInsSrv", "gettjCheckInfo", "mixId="+dev_ids);
		unProCount = baseData.devicerecMap.owning_sub_id;
		countSaveFalg= baseData.devicerecMap.name;
		if (unProCount == undefined) {
			return;
		}
		if(countSaveFalg>0)
			{
			alert("正在调剂的设备不能进行调剂!");
			return;
			}
		if(unProCount.indexOf(",")>0)
			{
				alert("请选择同一个物探处的设备进行调剂!");
				return;
			}
		
		if(confirm('确定要将设备进行调剂么?')){  
				popWindow("<%=contextPath%>/rm/dm/deviceXZAccount/devMixForxztjNewApply.jsp?ids="+dev_ids+"&orgId="+unProCount,'950:680'); 
				
		}
	}
</script>
</html>