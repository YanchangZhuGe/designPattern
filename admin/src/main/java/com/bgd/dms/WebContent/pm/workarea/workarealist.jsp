<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>工区信息</title> 
</head> 
<body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">			 
			  <tr>
			    <td class="ali_cdn_name">工区名称</td>
			    <td class="ali_cdn_input">
				    <input id="workarea" name="workarea" type="text" class="input_width"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">			   			    
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{workarea_no}' id='rdo_entity_id_{workarea_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" exp="{workarea}">工区名称</td>
			      <td class="bt_info_odd" exp="{workarea_id}">工区编号</td>
			      <td class="bt_info_even" exp="{start_year}">年度</td>
			      <td class="bt_info_even" exp="{oil_region}">油区</td>
			      <td class="bt_info_even" exp="{basin}">盆地</td>
			      <td class="bt_info_even" exp="{region_name}">所属行政区</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">工区信息</a></li>
			    <li class="selectTag" id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			      <td class="inquire_item8">工区名称：</td>
			      <td class="inquire_form8" ><input id="t_workarea_name" class="input_width" type="text" /></td>
			      <td class="inquire_item8">工区编号</td>
			      <td class="inquire_form8" ><input id="t_workarea_id" class="input_width" type="text" /></td>
			      <td class="inquire_item8">年度：</td>
			      <td class="inquire_form8" ><input id="t_start_year" class="input_width" type="text" /></td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">盆地：</td>
			      <td class="inquire_form8" ><input id="t_basin" class="input_width" type="text" /></td>
			      </td>
			      <td class="inquire_item8">区块（矿权）：</td>
			      <td class="inquire_form8" ><input id="t_spare2" class="input_width" type="text" /></td>
			      <td class="inquire_item8">所属行政区:</td>
			      <td class="inquire_form8"><input id="t_regionName" class="input_width" type="text" /></td>
			     </tr>
			     <tr>
			      <td class="inquire_item8">主要地表类型：</td>
			      <td class="inquire_form8" ><input id="t_surfacetype" class="input_width" type="text" /></td>
			      <td class="inquire_item8">次要地表类型:</td>
			      <td class="inquire_form8"><input id="t_surfacetype2" class="input_width" type="text" /></td>
			      <td class="inquire_item8">一级构造单元：</td>
			      <td class="inquire_form8" ><input id="t_structUnitFirst" class="input_width" type="text" /></td>
			     </tr>
			     <tr>
			     <td class="inquire_item8">二级构造单元:</td>
			      <td class="inquire_form8" ><input id="t_structUnitSecond" class="input_width" type="text" /></td>
			      <td class="inquire_item8">工区中心经度：</td>
			      <td class="inquire_form8" ><input id="t_focusX" class="input_width" type="text" /></td>
			      <td class="inquire_item8">工区中心维度:</td>
			      <td class="inquire_form8" ><input id="t_focusY" class="input_width" type="text" /></td>
			     </tr>
			     <tr>
			      <td class="inquire_item8">工区地表条件：</td>
			      <td class="inquire_form8" ><input id="t_surfaceCondition" class="input_width" type="text" /></td>
			      <td class="inquire_item8">油区:</td>
			      <td class="inquire_form8" ><input id="t_oilRegion" class="input_width" type="text" /></td>
			      <td class="inquire_item8">作物区类型：</td>
			      <td class="inquire_form8" ><input id="t_cropAreaType" class="input_width" type="text" /></td>
			     </tr>
			     <tr>
			      <td class="inquire_item8">国家:</td>
			      <td class="inquire_form8"><input id="t_countryName" class="input_width" type="text" /></td>
			      <td class="inquire_item8"></td>
			      <td class="inquire_form8"></td>
			      <td class="inquire_item8"></td>
			      <td class="inquire_form8"></td>			      
			     </tr>
			</table>
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="recordMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr>
			    	    <td class="inquire_item8">备注</td>
			            <td class="inquire_form8" ><textarea id="notes" name="notes"  class="textarea" readonly></textarea></td>
			            <td class="inquire_item8"></td>
			            <td class="inquire_form8"></td>
			            <td class="inquire_item8"></td>
			            <td class="inquire_form8"></td>
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
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";

	cruConfig.queryStr = "";
	cruConfig.cdtType = 'form';
//  cruConfig.queryRetTable_id = "";
	var orgSubId = "<%=orgSubId%>";	
	
	function clearQueryText(){
		document.getElementById("workarea").value = "";
		document.getElementById("workarea").focus();
	}
	
	// 简单查询
	function simpleRefreshData(){
		var workarea = document.getElementById("workarea").value;
		var s_filter=" workarea like'%"+workarea+"%'";
		refreshData(s_filter);
	}
	
	function refreshData(filter){
		var s_filter="";
		if(filter!="" && filter!=undefined){
			s_filter = " and " + filter;
		}
		cruConfig.queryStr = "select workarea_no,workarea,workarea_id,start_year,oil_region,basin,region_name from gp_workarea_diviede where bsflag='0' " + s_filter;
		queryData(1);
	}


	function loadDataDetail(ids){
		//var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		// 加载当前行信息
		var retObj = jcdpCallService("WorkAreaSrv", "getWorkArea", "workareaNo="+ids);
		document.getElementById("t_workarea_name").value = retObj.workarea.workarea;
		document.getElementById("t_workarea_id").value = retObj.workarea.workarea_id;
		document.getElementById("t_start_year").value = retObj.workarea.start_year;
		document.getElementById("t_basin").value = retObj.workarea.basin;
		document.getElementById("t_spare2").value = retObj.workarea.spare2;
		document.getElementById("t_regionName").value = retObj.workarea.region_name;
		document.getElementById("t_surfacetype").value = retObj.workarea.surface_type;
		document.getElementById("t_surfacetype2").value = retObj.workarea.second_surface_type;
		document.getElementById("t_structUnitFirst").value = retObj.workarea.struct_unit_first_name;
		document.getElementById("t_structUnitSecond").value = retObj.workarea.struct_unit_second_name;
		document.getElementById("t_focusX").value = retObj.workarea.focus_x;
		document.getElementById("t_focusY").value = retObj.workarea.focus_y;
		
		document.getElementById("t_surfaceCondition").value = retObj.workarea.surface_condition;
		document.getElementById("t_oilRegion").value = retObj.workarea.oil_region;
		document.getElementById("t_cropAreaType").value = retObj.workarea.crop_area_type;
		document.getElementById("t_countryName").value = retObj.workarea.country_name;
		document.getElementById("notes").value = retObj.workarea.notes
	}
	
	function jsSelectOption(objName, objItemValue) {
		var objSelect = document.getElementById(objName);
		for (var i = 0; i < objSelect.options.length; i++) { 
			if (objSelect.options[i].value == objItemValue) {
				objSelect.options[i].selected = "selected";
				break;
			}
		}
	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/pm/workarea/workareasearch.jsp');
	}
	
	function toEdit() {	    
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/pm/workarea/workareamodify.jsp?workareaNo='+ids);
	}
	
	function toSave(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
	}
	function toSelectP(){

	}
	
	function toAdd(){
		popWindow('<%=contextPath%>/pm/workarea/workareaadd.jsp');
	}
	
	function toDelete(){ 		
	  ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WorkAreaSrv", "deleteWorkArea", "workareaNo="+ids);
			queryData(cruConfig.currentPage);
		}
		if(retObj.actionStatus=='ok'){
			alert("删除操作成功!");
		}
	}
	
	$(document).ready(lashen);
</script>
</html>