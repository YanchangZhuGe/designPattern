<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String relation_id = request.getParameter("relationId").toString();
	String project_info_no = request.getParameter("project_info_no").toString();
	if(project_info_no==null){
		project_info_no = "";
	}
	String root_folderid = user.getProjectInfoNo();

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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.blockUI.js"></script>
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
						<td class="ali_cdn_name">文件名称</td>
						<td class="ali_cdn_input"><input id="file_name" name="file_name" type="text" class="input_width"/></td>
						<auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
						<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
						<td>&nbsp;</td>
						<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</div>
	<div id="table_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id'   id='chk_entity_id'   id='rdo_entity_id_{file_id}'  value='{file_id}:{ucm_id}' id='chk_entity_id' onclick=doCheck(this)/>" > 
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="<a onclick=view_doc('{file_id}:{ucm_id}')><font color='blue'>{file_name}</font></a>">文件标题</td>
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
	function frameSize(){
		$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	
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
</script>

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	// 复杂查询
	function refreshData(){
		var project_info_no = '<%=project_info_no%>';
		cruConfig.queryStr = "select t.file_id ,t.ucm_id ,t.file_name ,t.project_info_no ,to_char(t.create_date,'yyyy-MM-dd') create_date "+
			" from bgp_doc_gms_file t "+
			" where t.bsflag ='0' and t.project_info_no='"+project_info_no+"' and t.relation_id like 'control:%'";
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
	  	popWindow('<%=contextPath%>/qua/common/upload_file.jsp?relationId=<%=relation_id%>&index=0');
	}

	function toDelete(){
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var sql = '';
		if(window.confirm("您确定要删除?")){
			for (var i = objLen-1;i >= 1 ;i--){   
		       if (obj [i].checked==true) { 
		    	   var value = obj[i].value.split(":")[0];
		    	   sql = sql + "update bgp_doc_gms_file t set t.bsflag='1' where t.file_id='"+value+"';";
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
		popWindow('<%=contextPath%>/doc/common/common_doc_search.jsp?relationId=<%=relation_id%>');
	}
	
<%-- 	function dbclickRow(ids){
		var ucm_id = ids.split(":")[0];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+ucm_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
	} --%>
	
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



<script type="text/javascript"  >
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