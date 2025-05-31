<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String parameter_ids = request.getParameter("parameter_ids");
	String leafBackUrl = request.getParameter("leafBackUrl");
	String forderBackUrl = request.getParameter("forderBackUrl");
	String rootBackUrl = request.getParameter("rootBackUrl");
	String id = request.getParameter("id");
	String whole = request.getParameter("whole");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<link rel="stylesheet" href="ztree/css/zTreeStyle/zTreeStyle.css" type="text/css" />  
<script type="text/javascript" src="ztree/js/jquery.ztree.all-3.5.min.js"></script>  
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备类型参数管理</title>
<style>

td {
    white-space:nowrap;overflow:hidden;text-overflow: ellipsis;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();loadDataDetail(<%=parameter_ids%>);">
<div id="tree"></div>
<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		          <td class="ali_cdn_name">&nbsp;参数名称:</td>
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
				    <td><img src="<%=contextPath%>/images/up.png" width="24" height="24" style="cursor:hand;" title="上移" onclick="toUp()"  />
				    <img src="<%=contextPath%>/images/down.png" width="24" height="24" style="cursor:hand;" title="下移" onclick="toDown()"/></td>
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
					<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="修改"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
			 </tr>
	       </table>
	      </td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
      </table>
     </div>
     <div id="table_box">
			  <table style="width:98.5%;table-layout: fixed;" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{parameter_ids}' id='selectedbox_{parameter_ids}'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1" >序号</td> 
					<td class="bt_info_odd" width="60%" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{parameter_name}">参数名称</td>
					<!-- <td class="bt_info_even" exp="{parameter_id}">排序</td> -->
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
	cruConfig.queryOp = "queryEquipmentPar";
	var id = "<%=id%>";
	var whole ="<%=whole%>";
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	
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
		if(typeof id!="undefined" && id!="" && id!="null"){
			temp += "&id="+id;
		}
		cruConfig.submitStr = temp;	
		queryData(1);

	}
	function loadDataDetail(parameter_ids){ 
		var retObj;
		var flag_public =0;
		if(parameter_ids != null){
		retObj = jcdpCallService("EquipmentParMan", "getEquipmentInfo", "parameter_ids="+parameter_ids);
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.parameter_ids).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.opi_id+"']").removeAttr("checked");
		}
	}
	// 清空
	function clearQueryText(){
		document.getElementById("parameter_name").value = "";
		refreshData("");
		refreshData()
	}
	
	// 增加
	function toAdd(){// 应从左侧的树上拿值
	    if(id==''|| id =="null" || id.length<=2){ 
	    	$.messager.alert("提示","请先选中一个子集的设备类型菜单项!");
     		return;
	    }
	    popWindowAuto('<%=contextPath%>/dmsManager/equipment/equipmentParAdd.jsp?whole='+whole+'&id='+id,'840:650','设备参数增加');
	
	}
	// 修改
	function toEdit(){
		var ids = getSelIds('selectedbox');
	    if(ids==''){ 
	    	$.messager.alert("提示","请先选中一个参数名称!");
     		return;
	    }
		popWindowAuto('<%=contextPath%>/dmsManager/equipment/equipmentParAdd.jsp?parameter_ids='+ids,'840:650','设备参数修改');
	}
	// 删除
	function toDelete(){

		var baseData;
		var ids = getSelIds('selectedbox');
		
	    if(ids==''){ 
	    	$.messager.alert("提示","请先选中一参数名称!");
     		return;
	    } 
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("EquipmentParMan", "todeleteEquPar", "updateids="+ids);
			if(retObj.operationFlag!="undefined"){
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
	// 上移
	function toUp(){
		var baseData;
		var ids = getSelIds('selectedbox');
		
	    if(ids==''){ 
	    	$.messager.alert("提示","请先选中一参数名称!");
     		return;
	    } 
	    
	    jcdpCallService("EquipmentParMan", "toUp", "up="+ids);
	    searchDevData();
	}
	// 下移
	function toDown(){
		var baseData;
		var ids = getSelIds('selectedbox');
		
	    if(ids==''){ 
	    	$.messager.alert("提示","请先选中一参数名称!");
     		return;
	    } 
	    
	   jcdpCallService("EquipmentParMan", "toDown", "down="+ids);
	   searchDevData();
	}
</script>
</html>

