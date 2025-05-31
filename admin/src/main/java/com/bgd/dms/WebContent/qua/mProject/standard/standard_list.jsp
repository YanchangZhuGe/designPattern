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
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
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
	function newSubmit() {
		
		
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
							<auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
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
				<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{ids}' id='chk_entity_id_{file_id}' onclick=doCheck(this) {checked}/>" >
					<input type='checkbox' name='chk_entity_id' value=':' id='chk_entity_id_{file_id}' onclick='check(this)'/></td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="<a href='#' onclick=dbclickRow('{ids}')> <font color='blue'>{file_name}</font></a>">文件标题</td>
				<!-- <td class="bt_info_odd" exp="{create_date}">上传时间</td> -->
			</tr>
		</table>
	</div>
	<div id="fenye_box" style="height: 0px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table" style="height: 0px">
		</table>
	</div>
</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var org_subjection_id = '<%=subjection_id%>';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	var file_name="";	
	var file_ids = '';
	// 复杂查询
	function refreshData(){
		var name = document.getElementById("file_name").value;
		cruConfig.queryStr = "select t.file_id ,f.ucm_id , f.file_name , f.creator_id , u.user_name, f.create_date , "+
		" concat(concat(t.file_id,':'),f.ucm_id) ids from bgp_qua_files t  "+
		" join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag ='0' "+
		" join p_auth_user u on f.creator_id = u.user_id and u.bsflag ='0' "+
		" where t.bsflag = '0' and u.bsflag = '0' and f.bsflag='0' "+
		" and t.project_info_no is null and t.org_subjection_id = '"+org_subjection_id+"' "+
		" and f.file_name like '%"+name+"%' order by f.modifi_date desc";
		cruConfig.pageSize = cruConfig.pageSizeMax;
		queryData(1);
	}
	refreshData();
	function checked(project_info_no){
		var subjection = '<%=subjection_id%>';
		var name = document.getElementById("file_name").value;
		cruConfig.queryStr = " select distinct t.file_id ,f.ucm_id , f.file_name , f.creator_id , u.user_name, f.create_date ," +
		" concat(concat(t.file_id,':'),f.ucm_id) ids , case when d.file_id is not null then 'checked=true' else '' end checked"+
		" from bgp_qua_files t " +
		" join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag ='0' "+
		" join p_auth_user u on f.creator_id = u.user_id and u.bsflag ='0' "+
		" left join(select s.file_id from bgp_qua_files s where s.bsflag ='0' and (s.project_info_no in("+project_info_no+") or s.org_subjection_id in("+project_info_no+"))) d on 1=1 and t.file_id = d.file_id "+
		" where t.bsflag = '0' and u.bsflag = '0' and f.bsflag='0' "+
		" and t.project_info_no is null and t.org_subjection_id = '"+subjection+"' "+
		" and f.file_name like '%"+name+"%' ";
		cruConfig.pageSize = cruConfig.pageSizeMax;
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

	}

	function clearQueryText(){
		document.getElementById("file_name").value = "";
		refreshData();
	}
	
	function dbclickRow(ids){
		var file_id = ids.split(":")[0];
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