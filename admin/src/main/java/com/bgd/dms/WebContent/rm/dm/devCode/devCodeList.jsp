<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
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
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备编码查询列表</title>
</head>
<body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_device_name" name="s_device_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="singleQuery()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_app_id_{dev_ci_id}' name='dev_ci_id' idinfo='{dev_ci_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_ci_id}' id='selectedbox_{dev_ci_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_ci_code}">设备编码</td>
					<td class="bt_info_even" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_even" exp="{main_per_value}年">折旧年限</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">折旧年限</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">设备编码：</td>
				      <td  class="inquire_form6" ><input id="dev_ci_code" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">设备名称：</td>
				      <td  class="inquire_form6"><input id="dev_ci_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;规格型号：</td>
				      <td  class="inquire_form6"  ><input id="dev_ci_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="tj"  onclick="toSave()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		            </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
				    	  <td  class="inquire_item6">折旧年限：</td>
				      	  <td  class="inquire_form6" >
				      	  	<input id="dev_ci_id" type="hidden"/>
				      	  	<input id="main_per_value" class="input_width" style="margin-top:4px;" type="text" value="" onkeypress="return on_key_press_int(this)"/>年&nbsp;</td>
				      	  <td  class="inquire_item6"></td>
				      	  <td  class="inquire_form6"></td>
				      	  <td  class="inquire_item6"></td>
				      	  <td  class="inquire_form6"></td>
				    	</tr>
				        <tbody id="detailList" name="detailList" >
				        </tbody>
			        </table>
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					
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

	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = " select device_name,device_model,detail.coding_name as unit_name,device_slot_num,remark ";
				str += " from gms_device_collmodel_sub sub "
				str += " left join comm_coding_sort_detail detail on sub.unit_id=detail.coding_code_id ";
				str += " where model_mainid='"+currentid+"' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
	
function singleQuery(){
	var v_device_name =	document.getElementById("s_device_name").value;
	refreshData(v_device_name);
}

function clearQueryText(){
	document.getElementById("s_device_name").value = "";
}
	
function refreshData(v_device_name){
	var str = "select * from gms_device_codeinfo ";
	
	if(v_device_name!=undefined && v_device_name!=''){
		str += " where dev_ci_name like '%"+v_device_name+"%' ";
	}
	cruConfig.queryStr = str;
	queryData(cruConfig.currentPage);
}
    function loadDataDetail(device_id){
		var retObj;
		var basedatas;
		//查询基本信息
		var str = " select * from gms_device_codeinfo where dev_ci_id = '" + device_id + "'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		basedatas = queryRet.datas;
		//回填基本信息
		
		//选中这一条checkbox
		$("#selectedbox_"+basedatas[0].dev_ci_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+basedatas[0].dev_ci_id+"']").removeAttr("checked");
		//给数据回填
		document.getElementById("dev_ci_id").value = basedatas[0].dev_ci_id;
		document.getElementById("dev_ci_code").value = basedatas[0].dev_ci_code;
		document.getElementById("dev_ci_name").value = basedatas[0].dev_ci_name;
		document.getElementById("dev_ci_model").value = basedatas[0].dev_ci_model;
		document.getElementById("main_per_value").value = basedatas[0].main_per_value;
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	
 function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
 }
 
function on_key_press_int(obj)
{
	var keycode = event.keyCode;
	if(keycode > 57 || keycode < 46 || keycode==47)
	{
		return false;
	}else{
		return true;
	}
}

function toSave(){
	var dev_ci_id = document.getElementById("dev_ci_id").value;
	var main_per_value = document.getElementById("main_per_value").value;
	
	if(dev_ci_id == ""){
		alert("请选择行!");
		return;
	}
	if(main_per_value == ""){
		alert("折旧年限为空,请输入!");
		return;
	}
	var dataParams = new Array();
	var dataRow = {};
	dataRow['dev_ci_id'] = dev_ci_id;
	dataRow['main_per_value'] = main_per_value;
	dataParams[dataParams.length] = dataRow;
	
	var rows=JSON.stringify(dataParams);
	var path = getContextPath()+"/rad/addOrUpdateEntities.srq";
	submitStr = "tableName=gms_device_codeinfo&"+"rowParams="+rows;
	
	var retObject1 = syncRequest('Post',path,submitStr);
	if(retObject1.returnCode != "0"){
		alert("保存失败!");
	}else{
		alert("保存成功!");
	};
}
</script>
</html>