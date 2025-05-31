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
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH24:mm:ss");
	String appDate = df.format(new Date());
	 
	String swfFile = contextPath + "/WebContent/SWFTools/"+ user.getUserId() +"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
 
<script type="text/javascript" src="<%=contextPath%>/js/jquery.blockUI.js"></script>


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
	var id ;

	function do_check(val){ 
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			 alert(chk[i].value );
			if(chk[i].value == val.value){  
				chk[i].checked = true; 
			} 
		} 
		
	}
 
	function clearQueryText(){
		document.getElementById("name").value = '';
		document.getElementById("pro_status").options[0].selected = true;
	}
	
	function view_doc(file_id){
		 
		if(file_id != ""){
		   creatReq(file_id);
		<%-- 	var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension); --%>
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#cdddef" >

	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">QC活动课题:</td>
						    <td class="ali_cdn_input"><input type="text" id="name" name="name" class="input_width"/></td>
						    <td class="ali_cdn_name">审批情况:</td>
						    <td class="ali_cdn_input"><select id="pro_status" name="pro_status" class="select_width">
						    	<option value="">请选择</option>
						    	<option value="0">未上报</option>
						    	<option value="1">待审核</option>
						    	<option value="3">审核通过</option>
						    	<option value="4">审核不通过</option>
						    	</select></td>
						    <auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
				    		<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
						 	<td>&nbsp;</td>
						    <%-- <auth:ListButton functionId="F_QUA_QC_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton> 
						    <auth:ListButton functionId="F_QUA_QC_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> --%>
						    <!--<auth:ListButton functionId="F_QUA_QC_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>-->
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
			   <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{id}'   />" >
			  	 </td>
			  <td class="bt_info_even" exp="{auto}">序号</td> 
			  <td class="bt_info_odd" exp="{qc_code}">QC活动编号</td>
			  <td class="bt_info_even" exp="{qc_title}">QC活动课题</td>
			  <td class="bt_info_odd" exp="<a href='#' onclick=view_doc('{file_id}:{ucm_id}')><font color='blue'>{name}</font></a>">注册文件</td>
			  <td class="bt_info_even" exp="{pro_status}">审批情况
			  
			  </td>
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
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">活动注册</a></li>
        <li><a href="#" onclick="getTab(this,2)">活动记录</a></li>
        <li><a href="#" onclick="getTab(this,3)">活动成果</a></li>
        <li><a href="#" onclick="getTab(this,4)">流程</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <auth:ListButton functionId="F_QUA_QC_001" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			<form id="form0" name="form0" method="post" enctype="multipart/form-data" action="<%=contextPath%>/qua/uploadFile.srq">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
					    <td class="inquire_item4"><font color="red">*</font>活动注册文件:</td>
					    <td class="inquire_form4" colspan="3"><input type="file" name="apply_file" id="apply_file" value="" class="input_width" />
					    <input type="hidden" id="file_name" name="file_name" value=""/></td>
					</tr>
					<tr>
						<td class="inquire_item4"><font color="red">*</font>QC课题:</td>
					   	<td class="inquire_form4" colspan="3"><textarea name="qc_title" id="qc_title" cols="4" rows="50" class="textarea"  ></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item4">备注:</td>
					   	<td class="inquire_form4" colspan="3"><textarea name="note" id="note" cols="4" rows="50" class="textarea"  ></textarea></td>
					</tr>
				</table>
			</form> 
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="<%=contextPath %>/qua/sProject/QC/record_file.jsp" name="record" id="record" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="<%=contextPath %>/qua/sProject/QC/result_file.jsp" name="result" id="result" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<wf:startProcessInfo   title=""/><!-- buttonFunctionId="F_QUA_SINGLE_001" -->
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
		var project = '<%=projectInfoNo%>';
		if(project ==null || project ==''){
			alert("请选择项目");
			return;
		}
		var qc_title = document.getElementById("name").value;
		var pro_status = document.getElementById("pro_status").value;
		var org_subjection_id = '<%=org_subjection_id %>';
		cruConfig.submitStr = "org_subjection_id="+org_subjection_id+"&qc_title="+qc_title+"&pro_status="+pro_status+"&project_info_no="+project+"&qc_id="+id;
		cruConfig.queryStr ="";
		setTabBoxHeight();
		queryData(1);
	}
	refreshData();
	function loadBusinessInfoStatus(){  //用来刷新整个页面
		//refreshData();
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

    	processNecessaryInfo={
  			businessTableName:"bgp_qua_qc",	
  			businessType:"5110000004100000002", 
  			businessId: qc_id,
  			businessInfo:"QC活动注册",
  			applicantDate: '<%=appDate%>'
  		}; 
  		processAppendInfo = {
  				qc_id: qc_id
  		};
  		loadProcessHistoryInfo(); 
  		
	}
	/* 修改 */
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		document.getElementById("form0").submit();
	}
	function checkValue(){
		var obj = document.getElementById("apply_file");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("活动注册文件不能为空!");
			return false;
		}else{
			var start = value.lastIndexOf('\\');
			var end = value.lastIndexOf('.');
			value = value.substring(start+1,end);
			document.getElementById("file_name").value = value;
		}
		obj = document.getElementById("qc_title");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("QC课题不能为空!");
			obj.focus();
			return false;
		}
	}
	function toAdd() {
		totalRows = cruConfig.totalRows-(-1);
		popWindow("<%=contextPath%>/qua/sProject/QC/qc_edit.jsp?totalRows="+totalRows);
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
		if(window.confirm("你确定要删除?")){
			for (var i = objLen-2 ;i > 0;i--){
				if (obj [i].checked==true) { 
					qc_id=obj [i].value;
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

<script type="text/javascript" language="javascript">
 
function showBlock(){  
    jQuery.blockUI({ message:"<image src='<%=contextPath%>/images/jiazai1.gif'></image>",css: {  border: 'none',width:"20px", top:"20%" ,left:"20%"   }});  
   // setTimeout('hideBlock()',2000);//2000毫秒后调用hideBlock()  
}  
function hideBlock(){  
    jQuery.unblockUI();  
}  

    var req; //定义变量，用来创建xmlhttprequest对象
    function creatReq(ucmid) // 创建xmlhttprequest,ajax开始
    {

	var url = getContextPath()
		+ "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=ucmSrv&JCDP_OP_NAME=getFilePath&ucmid="+ucmid;//要请求的服务端地址
	if (window.XMLHttpRequest) //非IE浏览器及IE7(7.0及以上版本)，用xmlhttprequest对象创建
	{
	    req = new XMLHttpRequest();
	} else if (window.ActiveXObject) //IE(6.0及以下版本)浏览器用activexobject对象创建,如果用户浏览器禁用了ActiveX,可能会失败.
	{
	    var MSXML = [ 'MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0',
		    'MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP' ];
	    for ( var n = 0; n < MSXML.length; n++) {
		try {
		    req = new ActiveXObject(MSXML[n]);
		    break;
		} catch (e) {
		}
	    }
	}

	if (req) //成功创建xmlhttprequest
	{
	    req.open("GET", url, true); //与服务端建立连接(请求方式post或get，地址,true表示异步)
	    req.onreadystatechange = callback; //指定回调函数
	    req.send(null); //发送请求
	}
    }

    function callback() //回调函数，对服务端的响应处理，监视response状态
    {
 
	if (req.readyState == 4) //请求状态为4表示成功
	{
	    if (req.status == 200) //http状态200表示OK
	    {
		 Dispaly();//所有状态成功，执行此函数，显示数据
	    } else //http返回状态失败
	    {
		alert("服务端返回状态" + req.statusText);
	    }
	} else //请求状态还没有成功，页面等待
	{
	    showBlock();
	}
    }

    function Dispaly() //接受服务端返回的数据，对其进行显示
    {
	   hideBlock();
	   var data = eval("("+req.responseText+")");
	   var message = data.message;
	   //判断是否出现异常，message不为空为异常
	   if(message == null ){
		   var fileSwf = "<%=swfFile %>"+data.fileSWF; 
		   fileSwf = encodeURIComponent(fileSwf);
		   fileSwf = encodeURIComponent(fileSwf);
		   
		   window.open('<%=contextPath %>/SWFTools/pdf2swf.jsp?fileSwf='+fileSwf);
	   } else {
		   alert(message);
	   }

    }
</script>
 
</body>
</html>
