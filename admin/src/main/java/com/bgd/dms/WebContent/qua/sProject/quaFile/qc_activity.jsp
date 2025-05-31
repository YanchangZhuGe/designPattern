<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
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
	String projectInfoNo = user.getProjectInfoNo();
	if(projectInfoNo==null || projectInfoNo.trim().equals("")){
		projectInfoNo = "";
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
	}
	
	function view_doc(){
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
<body style="background:#fff" >

	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">QC活动主题</td>
						    <td class="ali_cdn_input"><input type="text" id="name" name="name" class="input_width"/></td>
						    <auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
				    		<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_QC_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_QC_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_QC_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						    <%-- <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton> --%>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			   <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{qc_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{qc_title}">QC活动主题</td>
			  <td class="bt_info_even" exp="{start_date}">活动开始日期</td>
			  <td class="bt_info_odd" exp="{end_date}">活动完成单位</td>
			  <td class="bt_info_even" exp="{org_name}">开展活动单位</td>
			  <td class="bt_info_odd" exp="{pro_status}">审批情况</td>
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
	<div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">常用</a></li>
        <li><a href="#" onclick="getTab(this,2)">流程</a></li>
        <li><a href="#" onclick="getTab(this,3)">活动注册</a></li>
        <li><a href="#" onclick="getTab(this,4)">活动记录</a></li>
        <li><a href="#" onclick="getTab(this,5)">活动成果</a></li>
        <!-- <li><a href="#" onclick="getTab(this,6)" >备注</a></li>
        <li><a href="#" onclick="getTab(this,7)" >分类码</a></li> -->
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <%-- <auth:ListButton functionId="" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton> --%>
			  </tr>
			</table>
			<form action="" id="form0" name="form0" method="post" target="record">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<input type="hidden" name="qc_id" id="qc_id" value="" class="input_width" />
					<tr>
					    <td class="inquire_item4">项目名称:</td>
					    <td class="inquire_form4" ><input type="text" name="projectName" id="projectName" value="<%=projectName %>" class="input_width" disabled="disabled"/></td>
					    <td class="inquire_item4"><font color="red">*</font>举办单位:</td>
					   	<td class="inquire_form4"><input type="hidden" name="org_id" id="org_id" value="<%=orgId %>" class="input_width" />
					    	<input name="org_name" id="org_name" type="text" class="input_width" value="<%=orgName %>" disabled="disabled"/></td> 
					</tr>
					<tr>
						<td class="inquire_item4"><font color="red">*</font>QC活动主题:</td>
					   	<td class="inquire_form4" colspan="3"><textarea name="qc_title" id="qc_title" cols="4" rows="50" class="textarea"  ></textarea></td>
				  		
					</tr>
				</table>
			</form> 
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;"> 
			<wf:startProcessInfo   title=""/><!-- buttonFunctionId="F_QUA_QC_EDIT" -->
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;"> 
			<iframe width="100%" height="100%" src="" name="apply" id="apply" frameborder="0"  marginheight="0" marginwidth="0" >
			</iframe>
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="" name="record" id="record" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content5" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="" name="result" id="result" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content6" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				  <tr>
				    <td class="inquire_item4">备注:</td>
				    <td class="inquire_form4">
						<textarea rows="4" cols="10" id="notes" name="notes" class="textarea"></textarea></td>
				  </tr>
			</table>
		</div>
		<div id="tab_box_content7" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getQCList";
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (var i=1;i<rowNum;i++){
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	function refreshData(){
		var qc_title = document.getElementById("name").value;
		cruConfig.submitStr = "qc_title="+qc_title;	
		setTabBoxHeight();
		queryData(1);
	}
	refreshData();
	function loadBusinessInfoStatus(){  //用来刷新整个页面
		refreshData();
	}
	/* 输入的是否是数字 */
	function checkIfNum(){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
	/* 详细信息 */
	function loadDataDetail(qc_id){
		var obj = event.srcElement; 
		var rowIndex = event.srcElement.parentNode.rowIndex;
    	if(obj.tagName.toLowerCase() == "td"){   
    		var tr = obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	}
    	document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=7&relationId="+qc_id;
    	var file_id = '';
		var ucm_id = '';
    	var retObj = jcdpCallService("QualityItemsSrv","getFileDetail", "qc_id=" + qc_id);
		if(retObj.returnCode =='0'){
			var map = retObj.fileDetail;
			if(map!=null){
				file_id = map.file_id;
				ucm_id = map.ucm_id;
			}
		}
		var ids = '';
		if(file_id!=null && file_id!='' && ucm_id!=null && ucm_id!=''){
			ids = file_id + ':' + ucm_id;
		}
		document.getElementById("apply").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+qc_id;
		document.getElementById("record").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId=record:"+file_id;
		document.getElementById("result").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId=result:"+file_id;
		retObj = jcdpCallService("QualityItemsSrv","getQCDetail", "qc_id=" + qc_id);
		if(retObj.returnCode =='0'){
			var map = retObj.qcDetail;
			if(map!=null){
				document.getElementById("qc_id").value = qc_id;
				document.getElementById("org_id").value = map.org_id;
				document.getElementById("org_name").value = map.org_name;
				document.getElementById("qc_title").value = map.qc_title;
				/* document.getElementById("start_date").value = map.start_date;
				document.getElementById("end_date").value = map.end_date;
				document.getElementById("qc_master").value = map.qc_master;
				document.getElementById("master_name").value = map.master_name;
				document.getElementById("qc_num").value = map.qc_num; */
				document.getElementById("notes").value = map.notes;
			}
		}
		var fileExtension = '';
    	if(ids != ""){
			retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			fileExtension= retObj.docInfoMap.dWebExtension;
		}else{
	    	alert("该条记录没有文档,请上传文档申请注册");
	    	return;
		} 
    	processNecessaryInfo={
    			businessTableName:"bgp_qua_qc",	
    			businessType:"5110000004100000002", 
    			businessId: qc_id,
    			businessInfo:"发起了QC活动注册",
    			applicantDate: '<%=appDate%>'
   		};
    	
   		processAppendInfo = {
   				qc_id: qc_id,
   				ucmId: ucm_id,
   				fileExt: fileExtension
   		};
   		deleteTableTr('processInfoTab');
   		loadProcessHistoryInfo();
   		var tr = document.getElementById("queryRetTable").rows[rowIndex];
   		tr.cells[0].firstChild.checked = true;
   		for(var i=0;i<tr.cells.length;i++){
   			tr.cells[i].style.background="#ffc580";
		}
	}
	/* 修改 */
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var obj = document.getElementById("qc_id").value;
		var submitStr = "qc_id="+obj;
		obj = document.getElementById("org_id").value;
		submitStr = submitStr + "&org_id=" + obj;
		obj = document.getElementById("qc_title").value;
		submitStr = submitStr + "&qc_title=" + obj;
		obj = document.getElementById("start_date").value;
		submitStr = submitStr + "&start_date=" + obj;
		obj = document.getElementById("end_date").value;
		submitStr = submitStr + "&end_date=" + obj;
		obj = document.getElementById("qc_master").value;
		submitStr = submitStr + "&qc_master=" + obj;
		obj = document.getElementById("qc_num").value;
		submitStr = submitStr + "&qc_num=" + obj;
		obj = document.getElementById("notes").value;
		submitStr = submitStr + "&notes=" + obj;
		var retObj = jcdpCallService("QualityItemsSrv","saveQC", submitStr);
		refreshData();
	}
	function checkValue(){
		var obj = document.getElementById("qc_title");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("QC活动主题不能为空!");
			return false;
		}
		obj = document.getElementById("start_date");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("活动开始日期不能为空!");
			return false;
		}
		obj = document.getElementById("end_date");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("活动完成日期不能为空!");
			return false;
		}
		obj = document.getElementById("org_id");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("开展活动单位不能为空!");
			return false;
		}
	}
	function toAdd() {
		popWindow("<%=contextPath%>/qua/sProject/QC/qc_edit.jsp");
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
		var qc_id = '';
		for (var i = objLen-2 ;i > 0;i--){   
			if (obj [i].checked==true) { 
				qc_id=obj [i].value;
				var text = '你确定要删除第'+i+'行吗?';
				if(window.confirm(text)){
			    	 var retObj = jcdpCallService("QualityItemsSrv","deleteQC", "qc_id="+qc_id);
				}
			}   
		} 
		refreshData();
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
		setTabBoxHeight();
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
