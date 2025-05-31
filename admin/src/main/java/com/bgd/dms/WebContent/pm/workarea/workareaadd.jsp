<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新增工区管理信息</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script>
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
function loadData()
{
	var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");
	var retCrop = jcdpCallService("WorkAreaSrv", "getCropreaType", "");
	var selectTag = document.getElementById("surface_type");
	var selectTag2 = document.getElementById("second_surface_type");
	var selectTag3 = document.getElementById("crop_area_type");
	if(retObj.surfaceType != null){
		for(var i=0;i<retObj.surfaceType.length;i++){
			var record = retObj.surfaceType[i];
			var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
			var item2 = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
			selectTag.add(item);
			selectTag2.add(item2);
		}
	}
	if(retCrop.cropAreaType != null){
		for(var i=0;i<retCrop.cropAreaType.length;i++){
			var record = retCrop.cropAreaType[i];
			var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
			selectTag3.add(item);
		}
	}
}

function refreshSecondStruct(){
	var firstStructUnitNo=document.getElementById("structUnitFirst").value;
	if(firstStructUnitNo!=""){
		var retObj = jcdpCallService("StuctureUnitInfoSrv", "queryChildStructUnit", "pStructUnitNo="+firstStructUnitNo);
		var selectTag = document.getElementById("structUnitSecond");
		deleteSelect(selectTag);
		var item0 = new Option("请选择","0");
		selectTag.add(item0);
		if(retObj.strparentInfos != null){
			for(var i=0;i<retObj.strparentInfos.length;i++){
				var record = retObj.strparentInfos[i];
				var item = new Option(record.struct_unit_name.replace(/\-/g," "),record.struct_unit_no);
				selectTag.add(item);
			}
		}
	}
}

function deleteSelect(obj){
	var o = obj.options;
	
	while(o.length != 0){
		obj.remove(0);
	}
}
function forward()
	{
	//window.location.href="index.html"
	}
</script>
<script type="text/javascript">
function checkForm() {
	 	
        if (!isTextPropertyNotNull("workarea", "工区名称")) {
		
			document.form1.workarea.focus();
			return false;	
		}
        if (!isLimitB100("workarea", "工区名称")) {
		
			document.form1.workarea.focus();
			return false;	
		}
        if (!isWordsNumber31("workareaId", "工区编号")) {
		
			document.form1.workareaId.focus();
			return false;	
		}
        if (!isLimitB100("basin", "盆地")) {
		
			document.form1.basin.focus();
			return false;	
		}
		if (!isTextPropertyNotNull("block", "区块（矿权）")) {
		
			document.form1.block.focus();
			return false;	
		}
        if (!isLimitB32("block", "区块（矿权）")) {
		
			document.form1.block.focus();
			return false;	
		}
        if (!isTextPropertyNotNull("regionName", "所属行政区")){
		
			document.form1.regionName.focus();
			return false;	
		}
        if (!isLimitB200("regionName", "所属行政区")) {
		
			document.form1.regionName.focus();
			return false;	
		}
        if (!isLimitB500("surfaceCondition", "工区地表条件")){
		
			document.form1.surfaceCondition.focus();
			return false;	
		}
        if(!isRatio180("focusX", "工区中心经度")){
		
			document.form1.focusX.focus();
			return false;	
		}
        if(!isValidFloatProperty12_9("focusX", "工区中心经度")) {
		
			document.form1.focusX.focus();
			return false;	
		}
		if (!isTextPropertyNotNull("focusX", "工区中心经度")) {
		
			document.form1.focusX.focus();
			return false;	
		}
        if(!isRatio180("focusY", "工区中心纬度")) {
		
			document.form1.focusY.focus();
			return false;	
		}
        if(!isValidFloatProperty12_9("focusY", "工区中心纬度")) {
		
			document.form1.focusY.focus();
			return false;	
		}
		if (!isTextPropertyNotNull("focusY", "工区中心纬度")) {
		
			document.form1.focusY.focus();
			return false;	
		}
		if (!isLimitB100("oilRegion", "油区")) {
		
			document.form1.oilRegion.focus();
			return false;	
		}
		if (!isLimitB255("notes", "备注")) {
		
			document.form1.notes.focus();
			return false;	
		}
		
		if (!isTextPropertyNotNull("startYear", "年度")) {
			document.form1.startYear.focus();
			return false;
		}
	    if(!isValidYearProperty("startYear","年度")) {
	    	document.form1.startYear.focus();
	    	return false;
	    }
	    if (!isTextPropertyNotNull("country", "国家")){
		
			return false;	
		}

		return true;
	}
	
	function insertWorkArea(){
		if (!checkForm()) return;
		var form = document.forms[0];
		form.action="<%=contextPath%>/gpe/insertWorkArea.srq";
		form.submit();
	}
		
	function cancle(){
	}
		
	function selectCoding(codingSortId,objId,objName){
		var obj = new Object();
		obj.fkValue="";
		obj.value="";
		var resObj = window.showModalDialog('<%=contextPath%>/pm/workarea/selectcode.jsp?codeSort='+codingSortId,window);
		if(objId!=""){
			document.getElementById(objId).value = resObj.fkValue;
		}
		document.getElementById(objName).value = resObj.value;
	}
	//选择一级构造单元
	function selectStructUnit(){
		var obj = new Object();
		obj.fkValue="";
		obj.value="";
		var resObj = window.showModalDialog('<%=contextPath%>/pm/structureUnit/sUnitParentSelect.jsp?sulevel=1',window);
		document.getElementById("structUnitFirst").value = resObj.fkValue;
		document.getElementById("structUnitName").value = resObj.value;
		refreshSecondStruct();
	}
	
</script>
<link href="table.css" rel="stylesheet" type="text/css" />
</head>

<body onload="loadData()">
<form id="CheckForm" name="form1" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;工区名称：</td>
   <td class="inquire_form4"><input name="workarea" type="text" value="" class="input_width" />
   
   </td>
   <td class="inquire_item4">工区编号：</td>
   <td class="inquire_form4"><input name="workareaId" type="text" value="" class="input_width" />
   
   </td>
  </tr>
  <tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;年度：</td>
   <td class="inquire_form4">
   <select name="startYear" class="select_width">
	    <%
	    Date date = new Date();
	    int years = date.getYear()+ 1900 - 10;
	    int year = date.getYear()+1900;
	    for(int i=0; i<20; i++){
	    %>
	    <option value="<%=years %>" <%	if(years == year) {  %> selected="selected" <% } %> > <%=years %> </option>
	    <%
	    years++;
	    }
	     %>
	    	
   </select>
   
   </td>

    <td class="inquire_item4">盆地：</td>
    <td class="inquire_form4"><input name="basin" type="text" value=""class="input_width"/>    
    </td>
  </tr>
  <tr>
  	<td class="inquire_item4"><font color="red">*</font>&nbsp;区块（矿权）：</td>
    <td class="inquire_form4">
    <input name="block" id="block" value="" type="hidden" class="input_width" />
    <input name="spare2" id="spare2" value="" type="text" class="input_width" readonly="readonly"/> 
	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0300100011','block','spare2');" />

	</td>
	     <td class="inquire_item4"><font color="red">*</font>&nbsp;所属行政区：</td>
	 <td class="inquire_form4"><input name="regionName" type="text" value="" class="input_width" />
	 
	 </td>
  </tr>
  <tr>
    <td class="inquire_item4">主要地表类型：</td>
    <td class="inquire_form4"><select id="surface_type" name="surface_type"></select></td>
     <td class="inquire_item4">次要地表类型：</td>
	 <td class="inquire_form4"><select id="second_surface_type" name="second_surface_type"></select></td>
  </tr>
  <tr>
   	<td class="inquire_item4">一级构造单元：</td>
   	<td class="inquire_form4">
   	<input type="hidden" id="structUnitFirst" name="structUnitFirst" value="<%=request.getParameter("structUnitFirst") == null ? "" : request.getParameter("structUnitFirst")%>"/>
    <input type="text" id="structUnitName" name="structUnitName" value="<%=request.getParameter("structUnitName") == null ? "" : request.getParameter("structUnitName")%>" class="input_width" readonly/>
    <img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectStructUnit();" />
    </td>
 
  	<td class="inquire_item4">二级构造单元：</td>
   	<td class="inquire_form4">
    <select name="structUnitSecond" id="structUnitSecond" class="select_width">
    <option value="0">请选择</option>
    </select>
    </td> 
  </tr>
  <tr> 
    <td class="inquire_item4"><font color="red">*</font>&nbsp;工区中心经度：</td>
	<td class="inquire_form4"><input name="focusX" type="text" value=""class="input_width" />
	</td>
    <td class="inquire_item4"><font color="red">*</font>&nbsp;工区中心纬度：</td>
   	<td class="inquire_form4"><input name="focusY" type="text" value=""class="input_width" />
   	</td>
  </tr>
    <tr>
    <td class="inquire_item4">工区地表条件：</td>
    <td class="inquire_form4"><input name="surfaceCondition" type="text" value="" class="input_width" /></td>
    <td class="inquire_item4">油区：</td>
    <td class="inquire_form4"><input name="oilRegion" type="text" value="" class="input_width" /></td>
  </tr>
  <tr>
    <td class="inquire_item4">作物区类型：</td>
    <td class="inquire_form4"><select id="crop_area_type" name="crop_area_type"></select></td>
    <td class="inquire_item4"><font color="red">*</font>&nbsp;国家：</td>
    <td class="inquire_form4">
    	<input type="hidden" id="country" name="country" value=""/>
    	<input type="text" id="countryName" name="countryName" value="" readonly/>
    	&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0200100001','country','countryName');" />
    </td>
  </tr>
   <tr>
    <td class="inquire_item4">备注：</td>
    <td class="inquire_form4" colspan="3"><textarea name="notes" class="textarea" ></textarea></td>    
  </tr>
</table>
  </div>
  <div id="oper_div">
   	<span class="tj_btn"><a href="#" onclick="insertWorkArea()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
</body>
</html>