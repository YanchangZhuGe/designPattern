<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
    String mixId = request.getParameter("mixId");
    String[] ids = mixId.split("~");
    mixId = ids[0];
    String mixTypeId = ids[1];
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>单项目-设备接收-设备接收(自有单台)-接收页面--综合物化探专用</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jh" event="onclick='toAdd()'" title="接收确认"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title="修改接收时间"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="JCDP_btn_back"></auth:ListButton>
				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mix_detid_{device_mix_detid}' name='device_mix_detid'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{device_mix_detid}' id='rdo_entity_id_{device_mix_detid}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{team_name}">班组</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{dev_unit}">计量单位</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<!-- <td class="bt_info_odd" exp="{operator_name}">操作手</td> -->
					<td class="bt_info_odd" exp="{dev_position}">存放地</td>
					<td class="bt_info_even" exp="{state_desc}">接收状态</td>
					<td class="bt_info_odd" exp="{actual_in_time}">接收时间</td>
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6"><input id="dev_dev_name" name=""  class="input_width" type="text" /></td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="dev_dev_model" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">自编号</td>
				<td class="inquire_form6"><input id="dev_self_num" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>				
				<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input id="dev_license_num" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">实物标识号</td>
				<td class="inquire_form6"><input id="dev_dev_sign" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">存放地</td>
				<td class="inquire_form6"><input id="dev_usage_org_name" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>				
				<td class="inquire_item6">班组</td>
				<td class="inquire_form6"><input id="dev_team" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">用途</td>
				<td class="inquire_form6"><input id="dev_purpose" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">计划进场时间</td>
				<td class="inquire_form6"><input id="dev_plan_start_date" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>				
				<td class="inquire_item6">计划离场时间</td>
				<td class="inquire_form6"><input id="dev_plan_end_date" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">接收状态</td>
			  	<td class="inquire_form6"><input id="receive_state" name="" class="input_width" type="text" /></td>
			  	<td class="inquire_item6">接收时间</td>
				<td class="inquire_form6">
					<input id="actual_in_time" name="" class="input_width" type="text" />
					<input id="team_dev_acc_id" name="" type="hidden" />
				</td>
			  </tr> 
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">					
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
			</div>
			<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
			</div>		
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

	function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}		
		});
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		refreshData(v_dev_name, v_dev_model);
	}
	var mixId = '<%=mixId%>';
	var mixTypeId = '<%=mixTypeId%>';
	function refreshData(v_dev_name,v_dev_model){
		var str = "select case dad.state when '1' then '已接收' else '未接收' end as state_desc,teamid.coding_name as team_name,"+
			"dm.project_info_no,da.dev_name,da.dev_model,unit.coding_name as dev_unit,da.dev_position,dam.assign_num,dad.* "+
			"from gms_device_mixinfo_form dm "+
			"left join gms_device_appmix_main dam on dm.device_mixinfo_id=dam.device_mixinfo_id "+
			"left join gms_device_appmix_detail dad on dam.device_mix_subid=dad.device_mix_subid "+
			"left join gms_device_account da on dad.dev_acc_id=da.dev_acc_id "+
			"left join comm_coding_sort_detail teamid on dad.team=teamid.coding_code_id "+
			"left join comm_coding_sort_detail unit on da.dev_unit=unit.coding_code_id "+
			"where dm.device_mixinfo_id='"+mixId+"'";
			
		if(v_dev_name!=undefined && v_dev_name!=''){
			str += "and da.dev_name like '%"+v_dev_name+"%' ";
		}
		if(v_dev_model!=undefined && v_dev_model!=''){
			str += "and da.dev_model like '"+v_dev_model+"%' ";
		}
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	var devaccId;
    function loadDataDetail(shuaId){
    	var retObj;
		if(shuaId!=null){		     
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevRecDetailInfo", "devrecId="+shuaId);			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevCommInfoSrv", "getDevRecDetailInfo", "devrecId="+ids);
		}
		document.getElementById("dev_dev_name").value =retObj.devicerecMap.dev_name;
		document.getElementById("dev_dev_model").value =retObj.devicerecMap.dev_model;
		document.getElementById("dev_self_num").value =retObj.devicerecMap.self_num;
		document.getElementById("dev_license_num").value =retObj.devicerecMap.license_num;
		document.getElementById("dev_dev_sign").value =retObj.devicerecMap.dev_sign;
		document.getElementById("dev_usage_org_name").value =retObj.devicerecMap.usage_org_name;
		document.getElementById("dev_team").value =retObj.devicerecMap.team_name;
		document.getElementById("dev_purpose").value =retObj.devicerecMap.purpose;
		document.getElementById("dev_plan_start_date").value =retObj.devicerecMap.dev_plan_start_date;
		document.getElementById("dev_plan_end_date").value =retObj.devicerecMap.dev_plan_end_date;
		document.getElementById("receive_state").value =retObj.devicerecMap.state_desc;
		document.getElementById("actual_in_time").value=retObj.devicerecMap.actual_in_time;
		document.getElementById("team_dev_acc_id").value=retObj.devicerecMap.team_dev_acc_id;
		devaccId = retObj.devicerecMap.dev_acc_id;
    }
	 //打开新增界面
	 function toAdd(){ 
	 	ids = getSelIds('rdo_entity_id');  
	  	if(ids==''){
	  		alert("请选择一条记录!");
	  		return;
	  	}
	  	//向子页面传参 
	  	//设备名称
	   	var dev_name =document.getElementById("dev_dev_name").value;
       		dev_name =encodeURI(dev_name);
       		dev_name = encodeURI(dev_name);
       	//规格型号
       	var dev_model =document.getElementById("dev_dev_model").value;
       		dev_model =encodeURI(dev_model);
       		dev_model = encodeURI(dev_model);
       	//自编
       	var self_num =document.getElementById("dev_self_num").value;
       		self_num =encodeURI(self_num);
       		self_num = encodeURI(self_num);
       	//牌照
       	var license_num =document.getElementById("dev_license_num").value;
       		license_num =encodeURI(license_num);
       		license_num = encodeURI(license_num);
       	//实物标识
       	var dev_sign =document.getElementById("dev_dev_sign").value;
       		dev_sign =encodeURI(dev_sign);
       		dev_sign = encodeURI(dev_sign);
       	//存放
       	var usage_org_name =document.getElementById("dev_usage_org_name").value;
       		usage_org_name =encodeURI(usage_org_name);
       		usage_org_name = encodeURI(usage_org_name);
       	//班组
       	var team =document.getElementById("dev_team").value;
       		team =encodeURI(team);
       		team = encodeURI(team);
       	debugger;
	  		selId = ids.split(','); 
	  	if(document.getElementById("receive_state").value=="已接收"){
		  alert("该设备已接收!");
		  return;
	  	}
	 	editUrl2 = "<%=contextPath%>/rm/dm/devReceive/devZHRecieveSubmit.jsp?id={id}&mixId="+mixId+"&mixTypeId="+mixTypeId;
	 	editUrl2 = editUrl2.replace('{id}',selId); 
	 	popWindow(editUrl2,'900:680'); 
	 }
	 function dbclickRow(ids){
		if(ids==''){
	  		alert("请选择一条信息!");
	  		return;
	  	}
	  	//向子页面传参 
	  	//设备名称
	   	var dev_name =document.getElementById("dev_dev_name").value;
       		dev_name =encodeURI(dev_name);
       		dev_name = encodeURI(dev_name);
       	//规格型号
       	var dev_model =document.getElementById("dev_dev_model").value;
       		dev_model =encodeURI(dev_model);
       		dev_model = encodeURI(dev_model);
       	//自编
       	var self_num =document.getElementById("dev_self_num").value;
       		self_num =encodeURI(self_num);
       		self_num = encodeURI(self_num);
       	//牌照
       	var license_num =document.getElementById("dev_license_num").value;
       		license_num =encodeURI(license_num);
       		license_num = encodeURI(license_num);
       	//实物标识
       	var dev_sign =document.getElementById("dev_dev_sign").value;
       		dev_sign =encodeURI(dev_sign);
       		dev_sign = encodeURI(dev_sign);
       	//存放
       	var usage_org_name =document.getElementById("dev_usage_org_name").value;
       		usage_org_name =encodeURI(usage_org_name);
       		usage_org_name = encodeURI(usage_org_name);
       	//班组
       	var team =document.getElementById("dev_team").value;
       		team =encodeURI(team);
       		team = encodeURI(team);
       
	  		selId = ids.split(','); 
	  	if(document.getElementById("receive_state").value=="已接收"){
		  alert("该设备已接收!");
		  return;
	  	}
	 	editUrl2 = "<%=contextPath%>/rm/dm/devReceive/devZHRecieveSubmit.jsp?id={id}&mixId="+mixId+"&mixTypeId="+mixTypeId;
	 	editUrl2 = editUrl2.replace('{id}',selId); 
	 	popWindow(editUrl2,'900:680'); 
	 }
	 function toModify(){
		 ids = getSelIds('rdo_entity_id');  
		  	if(ids==''){
		  		alert("请选择一条记录!");
		  		return;
		  	}
		  	//向子页面传参 
		  	//设备名称
		   	var dev_name =document.getElementById("dev_dev_name").value;
	       		dev_name =encodeURI(dev_name);
	       		dev_name = encodeURI(dev_name);
	       	//规格型号
	       	var dev_model =document.getElementById("dev_dev_model").value;
	       		dev_model =encodeURI(dev_model);
	       		dev_model = encodeURI(dev_model);
	       	//自编
	       	var self_num =document.getElementById("dev_self_num").value;
	       		self_num =encodeURI(self_num);
	       		self_num = encodeURI(self_num);
	       	//牌照
	       	var license_num =document.getElementById("dev_license_num").value;
	       		license_num =encodeURI(license_num);
	       		license_num = encodeURI(license_num);
	       	//实物标识
	       	var dev_sign =document.getElementById("dev_dev_sign").value;
	       		dev_sign =encodeURI(dev_sign);
	       		dev_sign = encodeURI(dev_sign);
	       	//存放
	       	var usage_org_name =document.getElementById("dev_usage_org_name").value;
	       		usage_org_name =encodeURI(usage_org_name);
	       		usage_org_name = encodeURI(usage_org_name);
	       	//班组
	       	var team =document.getElementById("dev_team").value;
	       		team =encodeURI(team);
	       		team = encodeURI(team);
       
	  		selId = ids.split(',')[0]; 
	  	if(document.getElementById("receive_state").value=="未接收"){
		  alert("该设备未接收，不能修改已接收时间!");
		  return;
	  	}
	 	editUrl2 = "<%=contextPath%>/rm/dm/devReceive/devRecieveReSubmit.jsp?id={id}&mixId="+mixId;
	 	editUrl2 = editUrl2.replace('{id}',selId); 
	 	popWindow(editUrl2,'900:680'); 
	 }
	 function toBack(){
	 	window.location.href='devReceiveList.jsp';
	 }
	 function toDeleteSub(){
		var task_id = document.getElementsByName("task_id");
		var str_task_id = "";
		var flag = true;
		if(task_id != null){
			for(var i=0;i<task_id.length;i++){
				if(task_id[i].checked == true){
					flag = false;
					str_task_id = str_task_id + "," + "'" + task_id[i].value + "'";	
				}			
			}
		}
		if(flag){
			alert("请选择一条记录!");
		}else{
			if(!window.confirm("确认删除?")){
				return;
			}			
			var sql1 = "update bgp_comm_human_receive_process t set t.bsflag='1',t.modifi_date=sysdate where t.receive_no in ("+str_task_id.substr(1)+") ";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+str_task_id);
		}
		loadDataDetail();
	}
	//打开批量接收界面
	function plAdd(){
	  	var flag=0;
	  	var ids='';
	  	var icount = 0;
		$("input[type='checkbox'][name='rdo_entity_id']").each(function(i){
			if(this.checked){
				if(icount==0){
					ids = "('"+this.value+"'";
				}else{
					ids += ",'"+this.value+"'";
				}
				var columnsObj = this.parentNode.parentNode.cells;
				if(columnsObj(5).innerText=='已接收'){
					alert(columnsObj(2).innerText+"-"+columnsObj(3).innerText+"已经接收!");
					flag=1;
				}
			}
		});
		if(ids.length>0){
			ids +=")";
		}
	    if(flag)return;
	 	//ids = getSelIds('rdo_entity_id');  
	 	
	  	if(ids==''){  alert("请选择记录!");  return;  }
	  
	  	if(document.getElementById("receive_state").value=="已接收"){
		  alert("该设备已接收!");
		  return;
	  	}
	 	editUrl = "<%=contextPath%>/rm/dm/devReceive/plSubmit.jsp?ids="+ids+"&mixId="+mixId+"&mixTypeId="+mixTypeId;
	 	popWindow(editUrl,"1050:680"); 
	  } 
</script>
</html>