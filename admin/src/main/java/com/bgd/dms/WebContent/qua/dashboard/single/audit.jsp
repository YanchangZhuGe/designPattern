<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	if(org_subjection_id ==null){
		org_subjection_id = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript">
	var checked = false;
	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">文件名称</td>
							<td class="ali_cdn_input"><input id="file_name" name="file_name" type="text" class="input_width"/></td>
							<auth:ListButton functionId="" css="cx" event="onclick='simpleSearchCommon()'" title="JCDP_btn_submit"></auth:ListButton>
							<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
							<td>&nbsp;</td>
							<%-- <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton> --%>
							<auth:ListButton functionId="F_QUA_AUDIT_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_AUDIT_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_AUDIT_001" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton> 
							<auth:ListButton functionId="F_QUA_AUDIT_001" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_AUDIT_001" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box">
		<input id="org_subjection_id" name="org_subjection_id" type="hidden" class="input_width"/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}:{ucm_id}' id='rdo_entity_id_{file_id}' onclick=doCheck(this)/>" >
					<input type='checkbox' name='rdo_entity_id' value='{file_id}:{ucm_id}' id='rdo_entity_id_{file_id}' onclick='check(this)'/></td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="{file_name}">文件标题</td>
				<td class="bt_info_odd" exp="{create_date}">上传时间</td>
			</tr>
		</table>
	</div>
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			<tr>
				<td align="right">第1/1页，共0条记录</td>
				<td width="10">&nbsp;</td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				<td width="50">到 <label><input type="text" name="textfield" id="textfield" style="width:20px;" /></label></td>
				<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			</tr>
		</table>
	</div>
	<!-- <div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">流程</a></li>
        <li><a href="#" onclick="getTab(this,2)" >计划文档</a></li>
        <li><a href="#" onclick="getTab(this,3)" >备注</a></li>
        <li><a href="#" onclick="getTab(this,4)" >分类码</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<wf:startProcessInfo   title=""/>buttonFunctionId="F_QUA_SINGLE_001"
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;"> 
			<iframe width="100%" height="100%" src="" name="attachement" id="attachement" frameborder="0"  marginheight="0" marginwidth="0" >
			</iframe>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
		
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
		</div>
	</div> -->
</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getAuditList";
	cruConfig.submitStr = "file_name=&subjection_id="+'<%=org_subjection_id%>';
	queryData(1);
	$("#table_box").css("height",$(window).height()-80);
	var org_subjection_id = "";
	var file_name="";	
	// 复杂查询
	function refreshData(q_file_name){
		if(q_file_name==null){
			q_file_name = file_name;
		}
		file_name = q_file_name;
		org_subjection_id = '<%=org_subjection_id%>';
		document.getElementById("file_name").value = file_name;
		cruConfig.submitStr = "file_name="+file_name+"&subjection_id="+org_subjection_id;
		queryData(1);
	}
	function loadDataDetail(id){
		var obj = event.srcElement;
		if(obj.tagName.toLowerCase() =='td'){
			obj.parentNode.cells[0].firstChild.checked = 'checked';
		}
	}
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var q_file_name = document.getElementById("file_name").value;
			refreshData(q_file_name ,org_subjection_id);
		}
	}
	
	function simpleSearchCommon(){
		var q_file_name = document.getElementById("file_name").value;
		refreshData(q_file_name);
	}

	function clearQueryText(){
		document.getElementById("file_name").value = "";
	}
	
	function toAdd(){
		var relation_id = 'audit:'+org_subjection_id;
		var subjection_id = '<%=org_subjection_id%>';
		if(subjection_id !=null && subjection_id =='C105'){
			relation_id = 'audit:C105';
		}
	  	popWindow('<%=contextPath%>/doc/common/upload_file_common.jsp?relationId='+relation_id+'&rootFolderId=');
	}

	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ucmSrv", "deleteFile", "docId="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		var relation_id = 'audit:'+org_subjection_id;
		var subjection_id = '<%=org_subjection_id%>';
		if(subjection_id !=null && subjection_id =='105'){
			relation_id = 'audit:C105';
		}
		popWindow('<%=contextPath%>/doc/common/common_doc_search.jsp?relationId='+relation_id);
	}
	
	function dbclickRow(ids){
		var ucm_id = ids.split(":")[1];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+ucm_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
	}
	
	//修改文档
	function toEdit(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    if(ids.split(":").length > 2){
	    	alert("只能编辑一条记录");
	    	return;
	    }
	    var file_id = ids.split(":")[0];
		var ucm_id = ids.split(":")[1];
		popWindow('<%=contextPath%>/doc/singleproject/edit_file.jsp?fileId='+file_id);
	}
	
	function toDownload(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
     		return;
    	}	
	    if(ids.split(":").length > 2){
	    	alert("请只选中一条记录");
	    	return;
	    }
	    var file_id = ids.split(":")[0];
	    var ucm_id = ids.split(":")[1];
	    if(ucm_id != ""){
	    	window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+file_id;
	    }else{
	    	alert("该条记录没有文档");
	    	return;
	    }
	}
</script>
</body>
</html>