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
    mixId = ids[3];
    String mixTypeId = ids[2];
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
  <title>单项目-设备接收-设备接收(装备补充单台)-接收页面</title> 
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
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="JCDP_btn_back"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_oif_detid_{device_oif_detid}' name='device_oif_detid'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_oif_detid}' id='selectedbox_{device_oif_detid}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{team_name}">班组</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{dev_unit}">计量单位</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{dev_position}">存放地</td>
					<td class="bt_info_even" exp="{state_desc}">接收状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">审批信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			    <li id="tag3_6"><a href="#" onclick="getContentTab(this,6)">作业</a></li>
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
				<td class="inquire_item6">单位</td>
				<td class="inquire_form6"><input id="dev_dev_unit" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">实物标识号</td>
				<td class="inquire_form6"><input id="dev_dev_sign" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">自编号</td>
				<td class="inquire_form6"><input id="dev_self_num" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input id="dev_license_num" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">存放地</td>
				<td class="inquire_form6"><input id="dev_usage_org_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">班组</td>
				<td class="inquire_form6"><input id="dev_team" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">用途</td>
				<td class="inquire_form6"><input id="dev_purpose" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">实际进场时间</td>
				<td class="inquire_form6"><input id="dev_plan_start_date" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">计划离场时间</td>
				<td class="inquire_form6"><input id="dev_plan_end_date" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">接收状态</td>
				<td class="inquire_form6"><input id="receive_state" name="" class="input_width" type="text" /></td>
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
				<div id="tab_box_content6" name="tab_box_content6" class="tab_box_content" style="display:none">
					<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    
				    	    <td>序号</td>
				    	    <td>作业名称</td>
				            <td>计划开始时间</td>
				            <td>计划结束时间</td>		
				            <td>原定工期</td>	
				        </tr>            
			        </table>
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
	var mixTypeId = '<%=mixTypeId%>';
	
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		refreshData(v_dev_name, v_dev_model);
	}
	var mixId = '<%=mixId%>';
	function refreshData(v_dev_name,v_dev_model){
		var str = "select dt.*,acc.dev_name,acc.dev_model,acc.dev_unit,acc.usage_org_name,acc.dev_position,"+
			"case dt.state when '0' then '未接收' when '9' then '已接收'  else '未接收' end as state_desc, "+
			"teamid.coding_name as team_name "+
			"from gms_device_equ_outdetail_added dt "+
			"left join gms_device_account acc on acc.dev_acc_id=dt.dev_acc_id "+
			"left join comm_coding_sort_detail teamid on dt.team=teamid.coding_code_id "+
			"where dt.device_outinfo_id='"+mixId+"' ";
		//var str = "select '1' as type,'' as asset_coding,null as dev_plan_start_date,null as dev_plan_end_date,'' as self_num,'' as dev_sign,'' as license_num,'调配出库' as showtype,cos.device_name as dev_name,cos.device_model as dev_model,cos.out_num,cos.receive_state,";
		//str += "case cos.receive_state when '0' then '未接收' when '1' then '接收完毕' when '9' then '接收中' when 'U' then '' else '异常状态' end as state_desc ";
		//str += "from gms_device_coll_outsub cos ";
		//str += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
		//str += "where cof.device_outinfo_id='"+mixId+"'";
		//str += "union ";
		//str += "(select '3' as type,'' as asset_coding,null as dev_plan_start_date,null as dev_plan_end_date,'' as self_num,'' as dev_sign,'' as license_num,'补充出库' as showtype,cos.device_name as dev_name,cos.device_model as dev_model,cos.out_num,cos.receive_state,";
		//str += "case cos.receive_state when '0' then '未接收' when '1' then '接收完毕' when '9' then '接收中' when 'U' then '' else '异常状态' end as state_desc ";
		//str += "from gms_device_coll_outsubadd cos ";
		//str += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
		//str += "where cof.device_outinfo_id='"+mixId+"' and device_mif_subid is null) ";
		//str += "union ";
		//str += "(select '3' as type,eq.asset_coding,eq.dev_plan_start_date,eq.dev_plan_end_date,eq.self_num,eq.dev_sign,eq.license_num,'补充出库' as showtype,acc.dev_name,acc.dev_model, 1 as out_num,";
		//str += "eq.state as receive_state,case eq.state when '1' then '接收中' ";
		//str += "when '9' then '接收完毕' else '未接收' end as state_desc ";
		//str += "from gms_device_equ_outdetail_added eq left join gms_device_account acc ";
		//str += "on eq.dev_acc_id=acc.dev_acc_id ";
		//str += "where eq.device_outinfo_id='"+mixId+"')";
		if(v_dev_name!=undefined && v_dev_name!=''){
			str += "and da.dev_name like '%"+v_dev_name+"%' ";
		}
		if(v_dev_model!=undefined && v_dev_model!=''){
			str += "and da.dev_model like '"+v_dev_model+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
    function loadDataDetail(shuaId){
    	var retObj;
    	var str = "select dt.*,acc.dev_name,acc.dev_model,acc.dev_unit,acc.usage_org_name,acc.dev_position,dui.actual_in_time,"+
			"case dt.state when '0' then '未接收' when '9' then '已接收'  else '未接收' end as state_desc, "+
			"teamid.coding_name as team_name "+
			"from gms_device_equ_outdetail_added dt "+
			"left join gms_device_account_dui dui on dui.fk_device_appmix_id=dt.device_oif_detid left join gms_device_account acc on acc.dev_acc_id=dt.dev_acc_id "+
			"left join comm_coding_sort_detail teamid on dt.team=teamid.coding_code_id "+
			"where dt.device_oif_detid='"+shuaId+"'";
    	var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = proqueryRet.datas;
		
		document.getElementById("dev_dev_name").value =retObj[0].dev_name;
		document.getElementById("dev_dev_model").value =retObj[0].dev_model;
		document.getElementById("dev_dev_unit").value =retObj[0].dev_unit;
		document.getElementById("dev_self_num").value =retObj[0].self_num;
		document.getElementById("dev_license_num").value =retObj[0].license_num;
		document.getElementById("dev_dev_sign").value =retObj[0].dev_sign;
		document.getElementById("dev_usage_org_name").value =retObj[0].usage_org_name;
		document.getElementById("dev_team").value =retObj[0].team_name;
		document.getElementById("dev_purpose").value =retObj[0].purpose;
		document.getElementById("dev_plan_start_date").value =retObj[0].actual_in_time;
		document.getElementById("dev_plan_end_date").value =retObj[0].dev_plan_end_date;
		document.getElementById("receive_state").value =retObj[0].state_desc;
		devaccId = retObj[0].dev_acc_id;
		//取消其他选中的
		//$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_oif_detid+"']").removeAttr("checked");
		//$("#selectedbox_"+retObj[0].device_oif_detid).attr("checked",'true');
		//选中这一条checkbox
//		var checkstr = "selectedbox_"+retObj[0].device_oif_detid;
//		var selectedboxes = document.getElementsByName("selectedbox");
//		for(var index=0;index<selectedboxes.length;index++){
//			if(selectedboxes[index].id != checkstr){
//				selectedboxes[index].checked = false;
//			}else{
//				selectedboxes[index].checked = true;
//			}
//		}
		//作业标签－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
		var querySql = "select p6.* from gms_device_account_dui dui left join gms_device_receive_process dp on dui.dev_acc_id=dp.dev_acc_id left join bgp_p6_activity p6 on dp.task_id=p6.object_id where dui.fk_device_appmix_id='"+retObj[0].device_oif_detid+"'";
		
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);		
		var datas = queryRet.datas;
		deleteTableTr("planDetailList");
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
			
				var tr = document.getElementById("planDetailList").insertRow();		
				
	          	if(i % 2 == 1){  
	          		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].planned_start_date;
	
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].planned_finish_date;

				var td = tr.insertCell(4);
				td.innerHTML = datas[i].planned_duration;
			}
		}
    }
    function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	 var devaccId;
	 //打开新增界面
	 function toAdd(){ 
		ids = getSelIds('selectedbox');  
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
	    //单位
	    var dev_unit =document.getElementById("dev_dev_unit").value;
	    dev_unit =encodeURI(dev_unit);
	    dev_unit = encodeURI(dev_unit);
	    //自编号
	    var self_num =document.getElementById("dev_self_num").value;
	    self_num =encodeURI(self_num);
	    self_num = encodeURI(self_num);
	    //牌照号
	    var license_num =document.getElementById("dev_license_num").value;
	    license_num =encodeURI(license_num);
	    license_num = encodeURI(license_num);
	    //实物标识号
	    var dev_sign =document.getElementById("dev_dev_sign").value;
	    dev_sign =encodeURI(dev_sign);
	    dev_sign = encodeURI(dev_sign);
	    //存放地
	    var usage_org_name =document.getElementById("dev_usage_org_name").value;
	    usage_org_name =encodeURI(usage_org_name);
	    usage_org_name = encodeURI(usage_org_name);
	    //班组
	    var team =document.getElementById("dev_team").value;
	    team =encodeURI(team);
	    team = encodeURI(team);
	       
		selId = ids.split(','); 
		if(document.getElementById("receive_state").value=="已接收"){
			alert("该设备已接收！");
			return;
		}
		editUrl2 = "<%=contextPath%>/rm/dm/EqDevReceiveAdded/devRecieveSubmit.jsp?id={id}&mixId="+mixId+"&mixTypeId="+mixTypeId;
		editUrl2 = editUrl2.replace('{id}',selId); 
		popWindow(editUrl2,'900:680'); 
	 } 
	 function dbclickRow(ids){
		 if(sonFlag_tmp == 'Y'){
				return;
		}
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
	    //单位
	    var dev_unit =document.getElementById("dev_dev_unit").value;
	    dev_unit =encodeURI(dev_unit);
	    dev_unit = encodeURI(dev_unit);
	    //自编号
	    var self_num =document.getElementById("dev_self_num").value;
	    self_num =encodeURI(self_num);
	    self_num = encodeURI(self_num);
	    //牌照号
	    var license_num =document.getElementById("dev_license_num").value;
	    license_num =encodeURI(license_num);
	    license_num = encodeURI(license_num);
	    //实物标识号
	    var dev_sign =document.getElementById("dev_dev_sign").value;
	    dev_sign =encodeURI(dev_sign);
	    dev_sign = encodeURI(dev_sign);
	    //存放地
	    var usage_org_name =document.getElementById("dev_usage_org_name").value;
	    usage_org_name =encodeURI(usage_org_name);
	    usage_org_name = encodeURI(usage_org_name);
	    //班组
	    var team =document.getElementById("dev_team").value;
	    team =encodeURI(team);
	    team = encodeURI(team);
	       
		selId = ids.split(','); 
		if(document.getElementById("receive_state").value=="已接收"){
			alert("该设备已接收！");
			return;
		}
		editUrl2 = "<%=contextPath%>/rm/dm/EqDevReceiveAdded/devRecieveSubmit.jsp?id={id}&mixId="+mixId+"&mixTypeId="+mixTypeId;
		editUrl2 = editUrl2.replace('{id}',selId); 
		popWindow(editUrl2,'900:680'); 
	 }
	 function toBack(){
	 	window.location.href='EqDevReceiveList.jsp';
	 }
</script>
</html>