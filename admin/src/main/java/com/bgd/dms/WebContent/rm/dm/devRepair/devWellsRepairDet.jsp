<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
    String devicebackinfoid = request.getParameter("id");
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

  <title>多项目-设备维修-井中设备维修-维修明细子页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
 <form name="form1" id="form1" method="post" action="">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="v_dev_name" name="v_dev_name" type="text" />
					<input id="device_backapp_id" name="device_backapp_id" type ="hidden"  value="<%=devicebackinfoid%>"/>
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="v_dev_model" name="v_dev_model" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="wxdj" event="onclick='toSumbitDevApp()'" title="维修"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toRepairBack()'" title="维修返还"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='javascript:window.history.back();'" title="返回"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_backapp_id}' name='device_backapp_id'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_backdet_id}~{dev_acc_id}~{state}~{back_state}' id='selectedbox_{device_backdet_id}' />" >选择</td><!-- <input type='checkbox' name='selectedbox' id='selectedbox' onclick='check()'/></td> -->
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_coding}">ERP编号</td>
					<td class="bt_info_odd" exp="{isrepair}">维修状态</td>
					<td class="bt_info_even" exp="{repairdate}">维修时间</td>
					<td class="bt_info_odd" exp="{backstatedesc}">返还状态</td>
					<td class="bt_info_even" exp="<a onclick=viewRepairInfo('{repair_info}','{state}')>查看</a>">维修明细查看</td>
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
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td class="inquire_item6">AMIS资产编号：</td>
				      <td class="inquire_form6" ><input id="dev_coding" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td class="inquire_item6">&nbsp;设备名称：</td>
				      <td class="inquire_form6"  ><input id="dev_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td class="inquire_item6">规格型号：</td>
				      <td class="inquire_form6"><input id="dev_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				     <td class="inquire_item6">&nbsp;自编号：</td>
				     <td class="inquire_form6"><input id="self_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td class="inquire_item6">实物标识号：</td>
				     <td class="inquire_form6"><input id="dev_sign" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td class="inquire_item6">&nbsp;牌照号：</td>
				     <td class="inquire_form6"><input id="license_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				    </tr>				    
				    <tr>
				     <td class="inquire_item6">资产状况：</td>
				     <td class="inquire_form6"><input id="stat_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
					</table>
				</div>
		 </div>
</div>
</form>
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
		$(filternotobj).hide();
		$(filterobj).show();
	}

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var device_backapp_id='<%=devicebackinfoid%>';
	
    function loadDataDetail(shuaId){        
        var retObj;
    	var ids;
		if(shuaId!=null){
			ids = shuaId;
		}else{
			ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		}
		var info = ids.split("~",-1);
		retObj = jcdpCallService("DevCommInfoSrv", "getStockDetailInfo", "devbackid="+info[0]);

		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+info[0]+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+info[0]+"']").attr("checked",'true');
		//------------------------------------------------------------------------------------
		document.getElementById("dev_coding").value =retObj.devStockMap.dev_coding;
		document.getElementById("dev_name").value =retObj.devStockMap.dev_name;
		document.getElementById("dev_model").value =retObj.devStockMap.dev_model;
		document.getElementById("self_num").value =retObj.devStockMap.self_num;
		document.getElementById("dev_sign").value =retObj.devStockMap.dev_sign;
		document.getElementById("license_num").value =retObj.devStockMap.license_num;
		document.getElementById("stat_desc").value =retObj.devStockMap.stat_desc;
    }

	function searchDevData(){
		var v_dev_name = document.getElementById("v_dev_name").value;
		var v_dev_model = document.getElementById("v_dev_model").value;
		refreshData(v_dev_name, v_dev_model);
	}
	function clearQueryText(){
		document.getElementById("v_dev_name").value = "";
		document.getElementById("v_dev_model").value = "";
	}
	function refreshData(v_dev_name,v_dev_model){
		var str = "select info.repair_info,info.create_date as repairdate,dui.license_num,dui.self_num,dui.dev_sign,dui.dev_coding,dui.dev_name,dui.dev_model,dui.check_time,sd.coding_name as stat_desc, ";
			str += "case backdet.state when '0' then '待修' when '1' then '已维修' end as isrepair,";
			str += "case backdet.back_state when '0' then '未返还' when '1' then '已返还' end as backstatedesc,";
			str += "backdet.device_backapp_id,backdet.device_backdet_id,backdet.dev_acc_id,backdet.state,backdet.back_state from gms_device_backapp_detail backdet ";
			str += "left join gms_device_account_dui dui on backdet.dev_acc_id=dui.dev_acc_id ";
			str += "left join comm_coding_sort_detail sd on dui.account_stat=sd.coding_code_id ";
			str += "left join bgp_comm_device_repair_info info on info.devback_repair_id = backdet.device_backapp_id and info.device_account_id = backdet.dev_acc_id ";
			str += "where backdet.device_backapp_id='<%=devicebackinfoid%>' ";
		//补充查询条件
		if(v_dev_name!=undefined && v_dev_name!=''){
			str += "and dui.dev_name like '"+v_dev_name+"%' ";
		}
		if(v_dev_model!=undefined && v_dev_model!=''){
			str += "and dui.dev_model like '"+v_dev_model+"%' ";
		}
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	function viewRepairInfo(id,state){
		if(state =='0'){
			alert("该设备尚未维修,暂不能查看维修信息!");
			return;
		}else{		
			if(id != ''){
				popWindow('<%=contextPath%>/rm/dm/devRepair/devWellsRepairInfoView.jsp?repairinfo='+id,'1050:680');
			}			
		}			
	}
	function toSumbitDevApp(){
	   ids = getSelIds('selectedbox');  
	   if(ids==''){  
		  alert("请选择一条信息!");  
		  return;  
	   }  
	   var info = ids.split("~",-1);
	   if(info[3]=="1"){
			alert("设备已返还,不能维修!");
			return;
	   }
	   popWindow("<%=contextPath%>/rm/dm/devRepair/devWellsRepairInfo.jsp?ids="+info[1]+"&devicebackappid="+device_backapp_id+"&devicebackdetid="+info[0]+"&repairflag="+info[2],'950:680');
	}
	function toRepairBack(){
		var retObj;
		ids = getSelIds('selectedbox');  
		if(ids==''){  
			alert("请选择一条信息!");
			return;  
		}  
		var info = ids.split("~",-1);
		if(info[3]=="1"){
			alert("设备已返还,不能重复返还!");
			return;
		}
		if(info[2]=="0"&&!confirm("设备未维修,确认返还？")){
			return;
		}else if(info[2]=="1"&&!confirm("确认返还？")){
			return;
		}
		retObj = jcdpCallService("DevCommInfoSrv", "saveWellsDevRepairBack", "devaccid="+info[1]+"&devicebackdetid="+info[0]+"&device_backapp_id="+device_backapp_id);
		refreshData();
	}
	function dbclickRow(shuaId){
		toSumbitDevApp();
	}
	
</script>
</html>