<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String relation_id = request.getParameter("relationId").toString();
	if(relation_id ==null){
		relation_id = "";
	}
	String root_folderid = user.getProjectInfoNo();
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
<title>无标题文档</title>
</head>
<body style="background:#fff">
<div id="list_table" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>&nbsp;</td>
							<%-- <auth:ListButton functionId="" css="cx" event="onclick='simpleSearchCommon()'" title="JCDP_btn_submit"></auth:ListButton>
							<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton> --%>
							<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" style="overflow-y: scroll;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}:{ucm_id}' id='rdo_entity_id_{file_id}' onclick=doCheck(this)/>" >选择</td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="{file_name}">文件标题</td>
				<td class="bt_info_odd" exp="{create_date}">上传时间</td>
			</tr>
		</table>
	</div>
	<div id="fenye_box" style="display: none;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			<tr>
				<td align="right">第1/1页，共0条记录</td>
				<td width="10">&nbsp;</td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				<td width="50">到 <label> <input type="text" name="textfield" id="textfield" style="width:20px;"/></label></td>
				<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			</tr>
		</table>
	</div>
</div>
		  
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ucmSrv";
	cruConfig.queryOp = "getAttachmentList";
	var file_name="";	
	// 复杂查询
	function refreshData(q_file_name){
		if(q_file_name==undefined) q_file_name = file_name;
		file_name = q_file_name;
		cruConfig.submitStr = "relationId=<%=relation_id%>&file_name="+q_file_name+"&pageSize="+cruConfig.pageSizeMax;	
		queryData(1);
	}
	refreshData('');
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
			refreshData(q_file_name);
		}
	}
	function simpleSearchCommon(){
		var q_file_name = document.getElementById("file_name").value;
		refreshData(q_file_name);
	}
	
	function clearQueryText(){
		document.getElementById("file_name").value = "";
	}
	
	function dbclickRow(ids){
		var ucm_id = ids.split(":")[0];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+ucm_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
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
	    var ucm_id = ids.split(":")[0];
	    if(ucm_id != ""){
	    	window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+ucm_id;
	    }else{
	    	alert("该条记录没有文档");
	    	return;
	    }
	}
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-8);
	}
	frameSize();
	
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	
</script>	  
</body>

</html>