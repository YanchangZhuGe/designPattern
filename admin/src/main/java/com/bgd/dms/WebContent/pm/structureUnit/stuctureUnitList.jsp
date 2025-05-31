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
<title>构造单元列表</title> 
</head> 
<body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			 <tr>
			    <td class="ali_cdn_name">构造单元名称</td>
			    <td class="ali_cdn_input">
				    <input id="s_stuctureUnit_name" name="s_stuctureUnit_name" type="text" class="input_width"/>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{struct_unit_no}' id='rdo_entity_id_{struct_unit_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" exp="{struct_unit_name}">构造单元名称</td>
			      <td class="bt_info_odd" exp="{struct_unit_level}">构造单元级别</td>
			      <td class="bt_info_even" exp="{struct_unit_parent}">上级构造单元</td>
			      <td class="bt_info_even" exp="{basin}">盆地</td>
			      <td class="bt_info_odd" exp="{divide_date}">划分年度</td>
			      <td class="bt_info_even" exp="{region_name}">行政区划</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			      <td class="inquire_item8">构造单元名称：</td>
			      <td class="inquire_form8" >
			      <input id="struct_unit_no" class="input_width" type="hidden" />
			      <input id="struct_unit_name" class="input_width" type="text" /></td>
			      <td class="inquire_item8">&nbsp;构造单元级别：</td>
			      <td class="inquire_form8" ><select id="struct_unit_level" class="select_width">
                             <option value="1">一级</option>
						     <option value="2">二级</option>
						     <option value="3">三级</option>
						     <option value="4">四级</option>
                        </select></td>			      
			      <td class="inquire_item8">上级构造单元：</td>
			      <td class="inquire_form8" ><input id="struct_unit_parent" class="input_width" type="text" />
			     	<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="toSelectP();" />
			      <input type="hidden" id="struct_unit_parent_no"/>
			      </td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">盆地：</td>
			      <td class="inquire_form8" ><input id="basin" class="input_width" type="text"/></td>
			      <td class="inquire_item8">划分年度：</td>
			      <td class="inquire_form8" >
			      <select id="divide_date" class="select_width">
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
	    	
	    </select></td>
			      <td class="inquire_item8">行政区划：</td>
			      <td class="inquire_form8" ><input id="region_name" class="input_width" type="text"/> </td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">构造单元代码：</td>
			      <td class="inquire_form8" ><input id="struct_unit_id" class="input_width" type="text"/></td>
			      <td class="inquire_item8">构造单元面积：</td>
			      <td class="inquire_form8" ><input id="struct_unit_area" class="input_width" type="text"/></td>
			      <td class="inquire_item8">划分单位：</td>
			      <td class="inquire_form8" ><input id="divide_unit" class="input_width" type="text"/></td>
			      </tr>
			</table>
					 <div id="oper_div"><span class="bc_btn"><a href="#" onclick="toSave()"></a></span></div>
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
		document.getElementById("s_stuctureUnit_name").value = "";
		document.getElementById("s_stuctureUnit_name").focus();
	}
	// 简单查询
	function simpleRefreshData(){
		var stuctureName = document.getElementById("s_stuctureUnit_name").value;
		var s_filter="a.struct_unit_name like'%"+stuctureName+"%'";
		refreshData(s_filter);
	}
	
	function refreshData(filter){
		var s_filter="";
		if(filter!=""){
			s_filter = " and " + filter;
		}

		cruConfig.queryStr = "select a.struct_unit_no,a.struct_unit_name,case a.struct_unit_level when '1' then '一级' when '2' then '二级'  when '3' then '三级' when '4' then '四级' else '' end as struct_unit_level ,(select b.struct_unit_name from gp_structure_unit b where b.struct_unit_no = a.struct_unit_parent) as struct_unit_parent,a.basin , a.divide_date,a.region_name from gp_structure_unit a where a.bsflag='0' " + s_filter;
	//	cruConfig.currentPageUrl = "/pm/structureUnit/stuctureUnitList.lpmd";
		queryData(1);
	}


	function loadDataDetail(ids){
		//var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }

		var retObj = jcdpCallService("StuctureUnitInfoSrv", "getStuctureUnit", "stuctureUnitNo="+ids);
		document.getElementById("struct_unit_no").value = ids;		
		document.getElementById("struct_unit_name").value = retObj.stuctureUnit.struct_unit_name;
		//document.getElementById("struct_unit_level").value = retObj.stuctureUnit.struct_unit_level;
		jsSelectOption("struct_unit_level",retObj.stuctureUnit.struct_unit_level);
		document.getElementById("struct_unit_parent").value = retObj.stuctureUnit.struct_unit_parent;
		document.getElementById("struct_unit_parent_no").value = retObj.stuctureUnit.struct_unit_parent_no;
		document.getElementById("basin").value = retObj.stuctureUnit.basin;
		
		//document.getElementById("divide_date").value = retObj.stuctureUnit.divide_date;
		jsSelectOption("divide_date",retObj.stuctureUnit.divide_date);
		document.getElementById("region_name").value = retObj.stuctureUnit.region_name;
		document.getElementById("notes").value = retObj.stuctureUnit.notes;
		document.getElementById("struct_unit_id").value = retObj.stuctureUnit.struct_unit_id;
		document.getElementById("struct_unit_area").value = retObj.stuctureUnit.struct_unit_area;
		document.getElementById("divide_unit").value = retObj.stuctureUnit.divide_unit;
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
		popWindow('<%=contextPath%>/pm/structureUnit/stuctureUnitSearch.jsp');
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
	
	function toEdit() {
	    
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
	}
	
	function toSave(){
		ids = document.getElementById("struct_unit_no").value;
		
		if (ids == '') {
			return;
		}
		
		var struct_unit_name = document.getElementById("struct_unit_name").value;
		var struct_unit_level = document.getElementById("struct_unit_level").value;
		var struct_unit_parent = document.getElementById("struct_unit_parent_no").value;
		var sp_no = document.getElementById("struct_unit_parent_no").value;
		var basin = document.getElementById("basin").value;
		var divide_date = document.getElementById("divide_date").value;
		var region_name = document.getElementById("region_name").value;
		var struct_unit_id = document.getElementById("struct_unit_id").value;
		var struct_unit_area = document.getElementById("struct_unit_area").value;
		var divide_unit= document.getElementById("divide_unit").value;		
		
		var notes = document.getElementById("notes").value;
		//alert("stuctureUnitNo="+ids+"&struct_unit_name="+struct_unit_name+"&struct_unit_level="+struct_unit_level+"&struct_unit_parent_no="+struct_unit_parent+"&basin="+basin+"&divide_date="+divide_date+"&region_name="+region_name+"&notes="+notes);
		var retObj = jcdpCallService("StuctureUnitInfoSrv", "updateStuctureUnit","stuctureUnitNo="+ids+"&structUnitName="+struct_unit_name+"&structUnitLevel="+struct_unit_level+"&structUnitNo1="+struct_unit_parent+"&basin="+basin+"&divideDate="+divide_date+"&regionName="+region_name+"&structUnitId="+struct_unit_id+"&structUnitArea="+struct_unit_area+"&divideUnit="+divide_unit);
		if(retObj.actionStatus=='ok'){
			alert("保存操作成功!");
		}
	}
	function toSelectP(){
		var structUnitLevel = document.getElementById("struct_unit_level").value - 1;
		var obj = new Object();
		obj.fkValue="";
		obj.value="";
		var resObj = window.showModalDialog('<%=contextPath%>/pm/structureUnit/sUnitParentSelect.jsp?sulevel='+structUnitLevel,window);
　　
		document.getElementById("struct_unit_parent_no").value = resObj.fkValue;	
		document.getElementById("struct_unit_parent").value = resObj.value;
	}
	
	function toAdd(){
		popWindow('<%=contextPath%>/pm/structureUnit/structureunitinsert.jsp');
		//popWindow('<%=contextPath%>/doc/singleproject/close_page.jsp');
		//window.open('<%=contextPath%>/structureUnit/structureunitinsert.jsp','select paren','width=640,height=480');
	}
	
	function toDelete(){ 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("StuctureUnitInfoSrv", "deleteStuctureUnit", "stuctureUnitNo="+ids);
			queryData(cruConfig.currentPage);
		}
		if(retObj.actionStatus=='ok'){
			alert("删除操作成功!");
		}
	}
	$(document).ready(lashen);
</script>
</html>