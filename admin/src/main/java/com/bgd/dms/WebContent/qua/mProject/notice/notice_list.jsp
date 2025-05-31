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
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript">
	var file_ids = '';
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 1; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}else{
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
							<auth:ListButton functionId="F_QUA_NOTICE_001" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
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
				<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{ids}' {checked}/>" >
					<input type='checkbox' name='chk_entity_id' value='' id='chk_entity_id' onclick='check(this)'/></td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="<a href='#' onclick=dbclickRow('{file_id}:{ucm_id}')> <font color='blue'>{file_name}</font></a>">文件标题</td>
				<!-- <td class="bt_info_odd" exp="{create_date}">上传时间</td> -->
			</tr>
		</table>
	</div>
	<div id="fenye_box" style="height: 0px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		</table> 
	</div> 
</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var org_subjection_id = '<%=subjection_id%>';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	resizeNewTitleTable();
	var file_name="";	
	var org_subjection_id = "";
	var file_name="";	
	
	// 复杂查询
	function refreshData(q_file_name,subjection_id){
		if(q_file_name==null){
			q_file_name = file_name;
		}
		file_name = q_file_name;
		if(subjection_id == null){
			subjection_id = '<%=subjection_id%>';
			org_subjection_id = subjection_id;
			document.getElementById("org_subjection_id").value = subjection_id;
		}else{
			document.getElementById("org_subjection_id").value = subjection_id;
			org_subjection_id = subjection_id;
		}
		document.getElementById("file_name").value = file_name;
		cruConfig.queryStr = " select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.file_name,'物探处' file_from," +
		" to_char(t.create_date,'yyyy-MM-dd') as create_date from bgp_doc_gms_file t " +
		" where t.bsflag='0' and t.is_file='1' and t.relation_id ='notice:"+org_subjection_id+"' union" +
		" select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.file_name,'东方' file_from," +
		" to_char(t.create_date,'yyyy-MM-dd') as create_date from bgp_qua_notice n " +
		" join bgp_doc_gms_file t on n.file_id = t.file_id and t.bsflag ='0'" +
		" where n.bsflag='0' and n.org_subjection_id ='"+org_subjection_id+"' and n.PROJECT_INFO_NO is  null";
		cruConfig.pageSize = cruConfig.pageSizeMax;
		queryData(1);
	}
	refreshData();
	function checked(project_info_no ,subjection_id){
		var subjection = '<%=subjection_id%>';
		cruConfig.queryStr = " select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.file_name,'物探处' file_from," +
		" to_char(t.create_date,'yyyy-MM-dd') create_date ,case when d.file_id is not null then 'checked=true' else '' end checked "+
		" from bgp_doc_gms_file t " +
		" left join (select * from bgp_qua_notice n where n.bsflag ='0' and (n.project_info_no in("+project_info_no+") or n.org_subjection_id in("+subjection_id+"))) d on 1=1 and t.file_id = d.file_id "+
		" where t.bsflag='0' and t.is_file='1' and t.relation_id ='notice:"+subjection+"' union" +
		" select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.file_name,'东方' file_from," +
		" to_char(t.create_date,'yyyy-MM-dd') create_date ,case when d.file_id is not null then 'checked=true' else '' end checked " +
		" from bgp_qua_notice n join bgp_doc_gms_file t on n.file_id = t.file_id and t.bsflag ='0'" +
		" left join (select * from bgp_qua_notice n where n.bsflag ='0' and (n.project_info_no in("+project_info_no+") or n.org_subjection_id in("+subjection_id+"))) d on 1=1 and n.file_id = d.file_id "+
		" where n.bsflag='0' and n.org_subjection_id ='"+subjection+"'";
		queryData(1);
	}
	function getAllChecked(){
		var file_ids = "";
		var check = document.getElementsByName("chk_entity_id");
		for(var i =0;i<check.length;i++){
			if(check[i].checked){
				var file_id = check[i].value.split(":")[0];
				if(file_id==null || file_id==''){
					continue;
				}
				if(file_ids==null || file_ids==''){
					file_ids = file_id;
				}else{
					file_ids = file_id +","+file_ids;
				}
			}
		}
		return file_ids;
	}
	function loadDataDetail(id){
		var obj = event.srcElement;
		if(obj.tagName.toLowerCase() =='input'){
			var tr = obj.parentNode.parentNode;
			var file_id = tr.cells[0].firstChild.value.split(':');
			file_id = file_id[0];
			if(tr.cells[0].firstChild.checked ){
				file_ids = file_id + ',' + file_ids;
			}else{
				file_ids = file_ids.replace(file_id + ',' ,'');
			}
		}
		//parent.file(file_ids);
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
	
	function toSearch(){
		var relation_id = 'notice:'+org_subjection_id;
		var subjection_id = '<%=subjection_id%>';
		if(subjection_id !=null && subjection_id =='105'){
			relation_id = 'notice:C105';
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
	
	function toDownload(){
		ids = getSelIds('chk_entity_id');
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