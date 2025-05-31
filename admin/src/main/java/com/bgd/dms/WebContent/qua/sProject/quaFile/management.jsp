<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String subjection_id = user.getSubOrgIDofAffordOrg();
	if(subjection_id ==null){
		subjection_id = "";
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
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="ali_cdn_name">文件类型</td>
				    	<td class="ali_cdn_input">
					    <select id="file_type" name="file_type" onchange="refreshData()" class="select_width">
					    	<option value="0">请选择</option>
					    	<option value="1">公司</option>
					    	<option value="2">物探处</option>
					    </select></td>
						<td class="ali_cdn_name">文件名称</td>
						<td class="ali_cdn_input"><input id="file_name" name="file_name" type="text" class="input_width"/></td>
						<auth:ListButton functionId="" css="cx" event="onclick='simpleSearchCommon()'" title="JCDP_btn_submit"></auth:ListButton>
						<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
						<td>&nbsp;</td>
						<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
						<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
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
				<td class="bt_info_even" exp="<a href='#' onclick=dbclickRow('{file_id}:{ucm_id}')> <font color='blue'>{file_name}</font></a>">文件标题</td>
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
</div>
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
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-10);
	var org_subjection_id = "";
	var file_name="";	
	// 复杂查询
	function refreshData(q_file_name,subjection_id){
		var subjection_id = "<%=subjection_id%>";
		var file_name = document.getElementById("file_name").value;
		var sql = "select * from(select t.eps_id ,t.eps_name ,t.org_id , sub.org_subjection_id ,'"+subjection_id+"' subjection_id"+
			" from bgp_eps_code t join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag='0'"+
			" where t.bsflag='0' and t.parent_object_id =(select c.object_id"+
			" from bgp_eps_code c where c.org_id ='C6000000000001')) org "+
			" where org.subjection_id like concat(org.org_subjection_id,'%')";
		var retObj = syncRequest('Post',cruConfig.contextPath + appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode=='0'){
			if(retObj.datas!=null && retObj.datas[0]!=null){
				subjection_id = retObj.datas[0].org_subjection_id; 
			}
		}
		var file_type = document.getElementById("file_type").value;
		if(file_type==null || file_type=='0'){
			cruConfig.queryStr = "select t.file_id,t.file_name,t.file_type,to_char(t.create_date,'yyyy-MM-dd') as create_date,t.ucm_id  "+
			" from bgp_doc_gms_file t where t.bsflag='0' and t.is_file='1' and t.file_name like '%"+file_name+"%'" +
			" and (t.relation_id like 'management:"+subjection_id+"%' or t.relation_id = 'management:C105') order by t.create_date desc";
			
		}else if(file_type!=null && file_type=='1'){
			cruConfig.queryStr = "select t.file_id,t.file_name,t.file_type,to_char(t.create_date,'yyyy-MM-dd') as create_date,t.ucm_id  "+
			" from bgp_doc_gms_file t where t.bsflag='0' and t.is_file='1' and t.file_name like '%"+file_name+"%'" +
			" and t.relation_id = 'management:C105' order by t.create_date desc";
		}else{
			cruConfig.queryStr = "select t.file_id,t.file_name,t.file_type,to_char(t.create_date,'yyyy-MM-dd') as create_date,t.ucm_id  "+
			" from bgp_doc_gms_file t where t.bsflag='0' and t.is_file='1' and t.file_name like '%"+file_name+"%'" +
			" and t.relation_id like 'management:"+subjection_id+"%' order by t.create_date desc";
		}
		<%-- if(subjection_id == null){
			subjection_id = '<%=subjection_id%>';
			org_subjection_id = subjection_id;
			document.getElementById("org_subjection_id").value = subjection_id;
		}else{
			document.getElementById("org_subjection_id").value = subjection_id;
			org_subjection_id = subjection_id;
		} --%>
		
		queryData(1);
	}
	refreshData('','');
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
		var relation_id = 'management:'+org_subjection_id;
		var subjection_id = '<%=subjection_id%>';
		if(subjection_id !=null && subjection_id =='C105'){
			relation_id = 'management:C105';
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
		var relation_id = 'management:'+org_subjection_id;
		var subjection_id = '<%=subjection_id%>';
		if(subjection_id !=null && subjection_id =='105'){
			relation_id = 'management:C105';
		}
		popWindow('<%=contextPath%>/doc/common/common_doc_search.jsp?relationId='+relation_id);
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