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
		popWindow("<%=contextPath %>/qua/mProject/notice/notice_menu.jsp",'1300:680');
		
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
							<auth:ListButton functionId="" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_NOTICE_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_NOTICE_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_NOTICE_001" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_NOTICE_001" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
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
				<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{file_id}:{ucm_id}:{file_del}:{notice_id}' id='chk_entity_id'/>" >
					<input type='checkbox' name='chk_entity_id' value=':' id='chk_entity_id' onclick='check(this)'/></td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_odd" exp="<a href='#' onclick=dbclickRow('{file_id}:{ucm_id}')> <font color='blue'>{file_name}</font></a>">文件标题</td>
				<td class="bt_info_even" exp="{file_from}">下发单位</td>
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
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var org_subjection_id = '<%=subjection_id%>';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	
	// 复杂查询
	function refreshData(){
		var subjection_id = '<%=subjection_id%>';
		document.getElementById("org_subjection_id").value = subjection_id;
		var file_name = document.getElementById("file_name").value;
		cruConfig.queryStr = " select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.ucm_id,t.file_name,'物探处' file_from,'doc' file_del ,"+
		" '' notice_id ,to_char(t.create_date,'yyyy-MM-dd') as create_date from bgp_doc_gms_file t " +
		" where t.bsflag='0' and t.is_file='1' and t.relation_id ='notice:"+org_subjection_id+"' and t.file_name like '%"+file_name+"%' union" +
		" select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.ucm_id,t.file_name,'东方' file_from, 'notice' file_del ,n.notice_id ," +
		" to_char(t.create_date,'yyyy-MM-dd') as create_date from bgp_qua_notice n " +
		" join bgp_doc_gms_file t on n.file_id = t.file_id and t.bsflag ='0'" +
		" where n.bsflag='0' and n.org_subjection_id ='"+org_subjection_id+"' and t.file_name like '%"+file_name+"%' and n.PROJECT_INFO_NO is  null";
		if(subjection_id!=null && subjection_id =='C105'){
			cruConfig.queryStr = " select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.ucm_id,t.file_name,'东方' file_from, 'doc' file_del ," +
			" '' notice_id ,to_char(t.create_date,'yyyy-MM-dd') as create_date from bgp_doc_gms_file t " +
			" where t.bsflag='0' and t.is_file='1' and t.relation_id ='notice:"+org_subjection_id+"' and t.file_name like '%"+file_name+"%' ";
		}
		
		queryData(1);
	}
	refreshData();
	function loadDataDetail(id){
		var obj = event.srcElement;
		if(obj.tagName.toLowerCase() =='td'){
			obj.parentNode.cells[0].firstChild.checked = 'checked';
		}
	}

	function clearQueryText(){
		document.getElementById("file_name").value = "";
		refreshData();
	}
	
	function toAdd(){
		var subjection_id = '<%=subjection_id%>';
		var relation_id = 'notice:'+subjection_id;
		
	  	popWindow('<%=contextPath%>/qua/common/upload_file.jsp?relationId='+relation_id+'&path=company&index=&file_abbr=tb');
	}

	function toDelete(){
		
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var sql = '';
		if(window.confirm("您确定要删除?")){
			for (var i = objLen-2;i >= 1 ;i--){
		       if (obj [i].checked==true) { 
		    	   var value = obj[i].value.split(":")[2];
		    	   if(value!=null && value=='doc'){
		    		   var file_id = obj[i].value.split(":")[0];
		    		   sql = sql + "update bgp_doc_gms_file t set t.bsflag='1' where t.file_id='"+file_id+"';";
		    		   sql = sql + "update bgp_qua_notice t set t.bsflag='1' where t.file_id='"+file_id+"';";
		    	   }else if(value!=null && value=='notice'){
		    		   var notice_id = obj[i].value.split(":")[3];
		    		   sql = sql + "update bgp_qua_notice t set t.bsflag='1' where t.notice_id='"+notice_id+"';";
		    	   }
		       } 
			}  
			if(sql!=null && sql!=''){
				var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
				if(retObj!=null && retObj.returnCode =='0'){
					alert("删除成功!");
					refreshData();
				}
			}
		}
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
		var file_id = ids.split(":")[0];
		var ucm_id = ids.split(":")[1];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
	}
	
	//修改文档
	function toEdit(){
	    ids = getSelIds('chk_entity_id');
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
		ids = getSelIds('chk_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
     		return;
    	}	
	    if(ids.split(":").length > 4){
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