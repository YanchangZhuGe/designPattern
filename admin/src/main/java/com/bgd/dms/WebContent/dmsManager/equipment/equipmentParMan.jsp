<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String equipment_id  = request.getParameter("equipment_id");
	String id = request.getParameter("id");
	String pid = request.getParameter("pid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>主要勘探设备名录</title>
<style>

td {
    white-space:nowrap;overflow:hidden;text-overflow: ellipsis;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();loadDataDetail(<%=equipment_id%>);">
<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		          <td class="ali_cdn_name">&nbsp;设备名称:</td>
		          <td class="ali_cdn_input">
		          	<input name="parameter_name" id="parameter_name" class="input_width" type="text"/>
		          </td>
					 <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
				    </td>
				    <td class="ali_query">
					    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
				    </td>
				    
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
					<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="修改"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
				    <auth:ListButton functionId="" css="zk" event="onclick='showAddContrast()'" title="加入对比"></auth:ListButton>
			 </tr>
	       </table>
	      </td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
      </table>
     </div>
     <div id="table_box">
			  <table style="width:100%;table-layout: fixed;" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{equipment_id}' id='selectedbox_{equipment_id}' onclick='uncheckAll(<%=equipment_id %>)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1" >序号</td> 
					<td class="bt_info_even"  width="10%" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{equipment_code}">设备编码</td>
					<td class="bt_info_odd" width="16%" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{current_device_type}">设备类别</td>
					<td class="bt_info_even" width="16%" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{equipment_name}">设备名称</td>
					<td class="bt_info_odd" width="16%" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{equipment_model}">设备型号</td>
					<td class="bt_info_even" width="16%" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{manufacturer}">生产厂家</td>
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
 </div> 



</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "queryRetTable";
	cruConfig.queryService = "ModelApply";
	cruConfig.queryOp = "queryExplorationList";
	var id = '<%=id%>';
	var pid ='<%=pid%>';
	
	$().ready(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
	});
	
	// 查询
	function searchDevData(){
		var parameter_name = document.getElementById("parameter_name").value;
		refreshData(parameter_name);
	}
	function refreshData(parameter_name){
      	var temp = "";
		if(typeof parameter_name!="undefined" && parameter_name!=""){
			temp += "&parameter_name="+parameter_name;
		}
		if(id!="null" && id!=""){
			temp += "&id="+id;
		}
		cruConfig.submitStr = temp;
		queryData(1);

	}
	
	/* function loadDataDetail(equipment_id){
		var retObj;
		var flag_public =0;
		if(equipment_id != null){
		retObj = jcdpCallService("EquipmentParMan", "getExplorationList", "equipment_id="+equipment_id);
		//选中这一条checkbox
		/* var e =$("#selectedbox_"+retObj.deviceappMap.equipment_id);
		e.attr("checked","true"); 
		//再次点击时取消选中
		/* if($("#selectedbox_"+retObj.deviceappMap.equipment_id).attr('checked')==undefined){
			$("#selectedbox_"+retObj.deviceappMap.equipment_id).attr("checked",'');
		} */
		/* $("#selectedbox_"+retObj.deviceappMap.equipment_id).removeAttr("checked","checked"); 
		//取消其他选中的
		 //$("input[type='checkbox'][name='selectedbox'][id !='selectedbox_"+retObj.deviceappMap.equipment_id+"']").removeAttr("checked"); 
		}
		baseData = jcdpCallService("EquipmentParMan", "getExplorationType", "equipment_id="+equipment_id); 
		if(baseData.fdataPublic!=null){ 
			// 有附件不显示设备详情而是显示附件
			for (var tr_id = 1; tr_id<=baseData.fdataPublic.length; tr_id++) {
				if(baseData.fdataPublic[tr_id-1].file_type =="skill_parameter"){
					var filtermapid = "#file_skill_tablePublic";
					$(filtermapid).empty();
					insertFilePublicSkill(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
			}
		}
	} */
	//取消选中
	function uncheckAll(equipment_id){ 
	retObj = jcdpCallService("EquipmentParMan", "getExplorationList", "equipment_id="+equipment_id);
		var e =$("#selectedbox_"+retObj.deviceappMap.equipment_id);
		e.attr("checked","true");
		if(e.type=='checkbox'){
		   if(e.checked=true){
		    e.checked=false;
		   }
		 }
	} 
	//显示已插入的附件
	function insertFilePublicSkill(name,id){
		$("#file_skill_tablePublic").append(
			"<tr>"+
     			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
			"</tr>"
		);
	}
	
	// 清空
	function clearQueryText(){
		document.getElementById("parameter_name").value = "";
		refreshData("");
		refreshData()
	}
	
	// 增加
	function toAdd(){
		 if(id==''|| id =="null" || id.length<=2){ 
		    $.messager.alert("提示","请先选中一个子集的设备类型菜单项!");
	  		return;
		    }
		 popWindowAuto('<%=contextPath%>/dmsManager/equipment/equipmentParManAdd.jsp?id='+id+'&pid='+pid,'840:650','勘探名录增加');
	}
	// 修改
	function toEdit(){
		var ids = getSelIds('selectedbox');
	    if(ids.length !=32 || ids== ""){ 
	    	$.messager.alert("提示","请先选中一个设备类型!","warning");
     		return;
	    }																			
		var retObj = jcdpCallService("EquipmentParMan", "getEquipmentTypeId", "equipment_id="+ids);
		var equipment_ids =retObj.str.equipment_ids;
		popWindowAuto('<%=contextPath%>/dmsManager/equipment/equipmentParManAdd.jsp?flag=update&equipment_id='+ids+'&equipment_ids='+equipment_ids,'840:650','勘探名录修改');
	}
	// 删除
	function toDelete(){
		var baseData;
		var ids = getSelIds('selectedbox');
	    if(ids.length !=32 || ids== ""){ 
	    	$.messager.alert("提示","请先选中一条记录!","warning");
     		return;	
	    } 
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("EquipmentParMan", "todeleteEquList", "updateids="+ids);
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						queryData(cruConfig.currentPage);
					}
				}
			}
		}
	}
	
	// 加入对比
	function showAddContrast(){
	var baseData;
	var ids = getSelIds('selectedbox');
		if(ids.length !=65 || ids== ""){
	    	$.messager.alert("提示","请先选中两条记录!","warning");
     		return;	
	    } 
		var retObj = jcdpCallService("EquipmentParMan", "queryParContrastName", "ids="+ids);
		var dOperationFlag=retObj.operationFlag;
		if("failed"==dOperationFlag){
			alert("请选择两个相同的设备类别！");
		}	
		if("success"==dOperationFlag){
			popWindow("<%=contextPath%>/dmsManager/equipment/equipmentParAddContrast.jsp?ids="+ids);
		}
	}
	
</script>
</html>

