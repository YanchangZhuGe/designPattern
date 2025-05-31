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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>传输用户管理</title> 
</head>  
<body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">用户名</td>
			    <td class="ali_cdn_input">
				    <input id="s_trans_user_name" name="s_trans_user_name" type="text" class="input_width"/>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{trans_user_no}' id='rdo_entity_id_{trans_user_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" exp="{trans_user_name}">传输用户</td>
			      <td class="bt_info_odd" exp="{prj_name}">项目名称</td>
			      <td class="bt_info_even" exp="{org_name}">队伍</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">用户信息</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			      <td class="inquire_item6">用户名：</td>
			      <td class="inquire_form6" ><input id="t_trans_user_name" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">密码：</td>
			      <td class="inquire_form6" ><input id="t_trans_user_password" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">确认密码：</td>
			      <td class="inquire_form6" ><input id="t_trans_user_confim_password" class="input_width_no_color" type="text" /></td>
			      </td>
			     </tr>
			     <tr>
			      <td class="inquire_item6">队伍：</td>
			      <td class="inquire_form6" ><input id="t_trans_user_org" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">项目名称：</td>
			      <td class="inquire_form6" ><input id="t_trans_user_prj" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6" ></td>
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
		document.getElementById("s_trans_user_name").value = "";
		document.getElementById("s_trans_user_name").focus();
	}
	
	// 简单查询
	function simpleRefreshData(){
		var transUserName = document.getElementById("s_trans_user_name").value;
		var s_filter="t.trans_user_name like'%"+transUserName+"%'";
		refreshData(s_filter);
	}
	
	function refreshData(filter){
		var s_filter="";
		if(filter!="" && filter!=undefined){
			s_filter = " where " + filter;
		}

		cruConfig.queryStr = "select * from (select u.trans_user_no , u.trans_user_name ,(select WMSYS.WM_CONCAT(org_abbreviation) from comm_org_information a INNER join gp_base_transmit_org b on a.org_id = b.org_id where b.trans_user_no = u.trans_user_no and b.bsflag='0') as org_name,(select WMSYS.WM_CONCAT(project_name) from gp_task_project a INNER join gp_base_user_project b on a.project_info_no = b.project_info_no where b.trans_user_no = u.trans_user_no and b.bsflag='0') as prj_name from gp_base_transmit_user u where u.bsflag='0') t " + s_filter;
		queryData(1);
	}


	function loadDataDetail(ids){
		//var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		// 加载当前行信息
		var retObj = jcdpCallService("TransferUserInfoSrv", "getTransferUser", "transUserNo="+ids);
		document.getElementById("t_trans_user_name").value = retObj.transferUser.trans_user_name;
		document.getElementById("t_trans_user_org").value = retObj.transferUser.org_name;
		document.getElementById("t_trans_user_prj").value = retObj.transferUser.prj_name;
		
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
		popWindow('<%=contextPath%>/pm/transferuser/transferuserSearch.jsp');
	}
	
	function toEdit() {
	    
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/pm/transferuser/transferusermodify.jsp?transUserNo='+ids);
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
		popWindow('<%=contextPath%>/pm/transferuser/transferuseradd.jsp');
		//popWindow('<%=contextPath%>/doc/singleproject/close_page.jsp');
		//window.open('<%=contextPath%>/structureUnit/structureunitinsert.jsp','select paren','width=640,height=480');
	}
	
	function toDelete(){ 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("TransferUserInfoSrv", "deleteTransUser", "transUserNo="+ids);
			queryData(cruConfig.currentPage);
		}
		if(retObj.actionStatus=='ok'){
			alert("删除操作成功!");
		}
	}
	
	$(document).ready(lashen);
</script>
</html>