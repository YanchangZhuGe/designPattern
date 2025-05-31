<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null || project_info_no.trim().equals("")){
		project_info_no = "";
	}
	String projectName = user.getProjectName();
	if(projectName==null || projectName.trim().equals("")){
		projectName = "";
	}
	String orgId = user.getOrgId();
	if(orgId==null || orgId.trim().equals("")){
		orgId = "";
	}
	String orgName = user.getOrgName();
	if(orgName==null || orgName.trim().equals("")){
		orgName = "";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH24:mm:ss");
	String appDate = df.format(new Date());
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
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
	function clearQueryText(){
		document.getElementById("name").value = '';
		document.getElementById("pro_status").options[0].selected = true;
	}
	
	function view_doc(file_id){
		if(file_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff ;overflow-y: auto" >

	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						    <td class="ali_cdn_name">QC活动编号:</td>
						    <td class="ali_cdn_input"><select id="qc_code" name="qc_code" onchange="refreshData();" class="select_width">
						    	</select></td>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_QC_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <%-- <auth:ListButton functionId="F_QUA_QC_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> --%>
						    <auth:ListButton functionId="F_QUA_QC_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_QC_001" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			   <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{file_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="<a href='#' onclick=view_doc('{file_id}')><font color='blue'>{file_name}</font></a>">活动成果文件</td>
			  <td class="bt_info_even" exp="{create_date}">文件创建时间</td>
			</tr>
		</table>
	</div> 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var relation_id = "";
	function changeCode(){
		var project_info_no = '<%=project_info_no%>';
		if(project_info_no ==null || project_info_no ==''){
			alert("请选择项目");
			return;
		}
		var sql = "select concat(concat(t.qc_id,':'),t.qc_code) id ,t.qc_code from bgp_qua_qc t where t.bsflag='0' and t.qc_code is not null and t.project_info_no ='"+project_info_no+"' order by t.qc_code asc";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode=='0'){
			if(retObj.datas!=null && retObj.datas.length>0){
				var select = document.getElementById("qc_code");
				for(var i =select.options.length-1 ;i>=0 ;i--){
					select.options.remove(i);
				}
				for(var i =0;i< retObj.datas.length;i++){
					var data = retObj.datas[i];
					if(data!=null){
						var id = data.id;
						var qc_code = data.qc_code;
						select.options.add(new Option(qc_code,id));
					}
				}
			}
		}
		refreshData();
	}
	function refreshData(){
		var select = document.getElementById("qc_code");
		var value = select.value;
		var qc_id = value.substring(0,value.indexOf(':'));
		relation_id = 'result:'+qc_id;
		cruConfig.queryStr ="select t.file_id ,t.file_name ,t.ucm_id ,to_char(t.create_date,'yyyy-MM-dd') create_date from bgp_doc_gms_file t where t.bsflag ='0' and t.relation_id ='"+relation_id+"'";
		cruConfig.pageSize = cruConfig.pageSizeMax;
		queryData(1);
	}
	changeCode();
	
	function renderNaviTable(){
		
	}
	function toAdd() {
		var qc_code = document.getElementById("qc_code").value;
		if(qc_code==null || qc_code=="")return;
		popWindow("<%=contextPath%>/qua/common/upload_file.jsp?relationId="+relation_id+"&index=1");
	}
	function toEdit() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var qc_id = '';
		for (var i = 0;i< objLen ;i++){   
		    if (obj [i].checked==true) { 
		    	qc_id=obj [i].value;
		      	var text = '你确定要修改第'+i+'行吗?';
				if(window.confirm(text) ){
					popWindow("<%=contextPath%>/qua/sProject/QC/qc_edit.jsp?qc_id="+qc_id);
					return;
				}
		  	}   
		} 
		alert("请选择修改的记录!")
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var file_id = '';
		if(window.confirm("你确定要删除吗?")){
			var sql = "";
			for (var i = objLen-1 ;i > 0;i--){   
				if (obj [i].checked==true) { 
					file_id = obj [i].value;
					sql = sql + "update bgp_doc_gms_file t set t.bsflag='1' where t.file_id='"+file_id+"';";
				}   
			} 
			if(sql!=null && sql!='')
	    	var retObj = jcdpCallService("QualitySrv","saveQualityBySql", "sql="+sql);
		}
		refreshData();
		var ctt = top.frames('list');
		ctt.refreshData();
	}
	function toDownload(){
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var file_id = '';
		var sql = "";
		for (var i = objLen-1 ;i > 0;i--){   
			if (obj [i].checked==true) { 
				file_id = obj [i].value;
				window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+file_id;
				return;
			}   
		} 
		
	}

	var selectedTag = document.getElementsByTagName("li")[0]; 
	function getTab(obj,index) {
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
		for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function frameSize(){
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	
	$(document).ready(lashen);
</script>

</body>
</html>
