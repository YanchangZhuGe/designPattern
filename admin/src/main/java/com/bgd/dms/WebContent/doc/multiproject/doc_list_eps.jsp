<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String nowDate = df.format(new Date());
	String contextPath = request.getContextPath();
	 UserToken user = OMSMVCUtil.getUserToken(request);
	String swfFile = contextPath + "/WebContent/SWFTools/"+ user.getUserId() +"/";
	String folderId = "";
	
	if(request.getParameter("folderid") != null){
		folderId = request.getParameter("folderid");
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
<script type="text/javascript" src="<%=contextPath%>/js/jquery.blockUI.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#cdddef">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>			    		    
			    <td class="ali_cdn_name">文件名称</td>
			    <td class="ali_cdn_input">
				    <input id="file_name" name="file_name" type="text" class="input_width"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearchEps()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_DOC_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_DOC_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_DOC_003" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>			    			   		    
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}:{ucm_id}' id='rdo_entity_id_{file_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{file_name}">文件标题</td>
			      <td class="bt_info_even" exp="{create_date}">上传时间</td>
<!-- 			      <td class="bt_info_odd" exp="{user_name}">责任人</td> -->
<!-- 			      <td class="bt_info_even" exp="{proc_status}">审批状态</td> -->
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">日志</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">版本</a></li>
<!-- 			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">流程处理</a></li> -->
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">分类码</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">UCM编号：</td>
					    <td class="inquire_form6" id="item0_0"><input type="text" id="ucm_id" name="ucm_id" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">原始文件名称：</td>
					    <td class="inquire_form6" id="item0_1">&nbsp;</td>
					    <td class="inquire_item6">关键字：</td>
					    <td class="inquire_form6" id="item0_2"><input type="text" id="ucm_keyword" name="ucm_keyword" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">文件类型：</td>
					    <td class="inquire_form6" id="item0_3"><input type="text" id="ucm_fileType" name="ucm_fileType" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">文件大小：</td>
					    <td class="inquire_form6" id="item0_4"><input type="text" id="ucm_fileSize" name="ucm_fileSize" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">创建时间：</td>
					    <td class="inquire_form6" id="item0_5"><input type="text" id="ucm_createDate" name="ucm_createDate" class="input_width" readonly="readonly"/></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">文件摘要：</td>
					    <td class="inquire_form6" id="item0_6"><input type="text" id="ucm_filebrief" name="ucm_filebrief" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">文件类型：</td>
					    <td class="inquire_form6" id="item0_7"><input type="text" id="ucm_filedoctype" name="ucm_filedoctype" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">分数：</td>
					    <td class="inquire_form6" id="item0_8"><input type="text" id="ucm_filescore" name="ucm_filescore" class="input_width" readonly="readonly"/></td>
					  </tr>					    
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="doclog" id="doclog" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="docversion" id="docversion" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>			
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
						<wf:startProcessInfo title=""/>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>			
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>				
			</div>
		  </div>
		  
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
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

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ucmSrv";
	cruConfig.queryOp = "getDocsInFolder";
	//cruConfig.queryRetTable_id = "";
	var folderid= parent.mainTopframe.rootMenuId;	
	
	var file_name="";
	var ucm_id="";
	var procinstId="";
	var fileId="";
	
	var doc_type = "";
	var doc_keyword = "";
	var doc_importance = "";
	var create_date = "";
	
	// 复杂查询
	function refreshData(q_folderid, q_file_name,q_doc_type,q_doc_keyword,q_doc_importance,q_create_date){
		if(q_folderid==undefined) q_folderid = folderid;
		folderid = q_folderid;

		if(q_file_name==undefined) q_file_name = file_name;
		file_name = q_file_name;
		document.getElementById("file_name").value = q_file_name;
		
		if(q_doc_type==undefined) q_doc_type = doc_type;
		doc_type = q_doc_type;
		
		if(q_doc_keyword==undefined) q_doc_keyword = doc_keyword;
		doc_keyword = q_doc_keyword;
		
		if(q_doc_importance==undefined) q_doc_importance = doc_importance;
		doc_importance = q_doc_importance;		
		
		if(q_create_date==undefined) q_create_date = create_date;
		create_date = q_create_date;
		
		cruConfig.submitStr = "folderid="+q_folderid+"&file_name="+q_file_name+"&doc_type="+q_doc_type+"&doc_keyword="+q_doc_keyword+"&doc_importance="+q_doc_importance+"&create_date="+q_create_date;	
		queryData(1);
	}

	refreshData(undefined, undefined);
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var q_file_name = document.getElementById("file_name").value;
			refreshData(undefined, q_file_name);
		}
	}
	
	function simpleSearchEps(){
		var q_file_name = document.getElementById("file_name").value;
		refreshData(undefined, q_file_name);		
	}
	
	function clearQueryText(){
		document.getElementById("file_name").value = "";
	}
	
	function dbclickRow(ids){
        var file_id = ids.split(":")[0];
		var ucm_id = ids.split(":")[1];  
		if(ucm_id != ""){   
			creatReq(ids);
		}else{
	    	alert("该条记录没有文档");
	    	return;			
		}
		
	}
	
	
	function loadDataDetail(ids){
		var theFileID = ids.split(":")[0];
		
 	    processNecessaryInfo={         
  	    		businessTableName:"bgp_doc_gms_file",    //置入流程管控的业务表的主表表明
  	    		businessType:"5110000004100000042",        //业务类型 即为之前设置的业务大类
  	    		businessId:theFileID,         //业务主表主键值
  	    		businessInfo:"多项目文档审批",        //用于待审批界面展示业务信息
  	    		applicantDate:'<%=nowDate%>'       //流程发起时间
  	    	}; 
  	    processAppendInfo={ 
  	    			fileId: theFileID   	    			 
  	    	};   
  	    loadProcessHistoryInfo();
		document.getElementById("attachement").src = "<%=contextPath%>/doc/multiproject/common_doc_list_eps.jsp?relationId="+theFileID+"&rootFolderId="+folderid;
		document.getElementById("doclog").src = "<%=contextPath%>/doc/log/doc_log.jsp?theFileId="+theFileID;
		document.getElementById("docversion").src = "<%=contextPath%>/doc/version/doc_version.jsp?theFileId="+theFileID;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=10&relationId="+theFileID;
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+theFileID;

		var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
		//file_name=retObj.docInfoMap.dDocTitle;
		fileId=retObj.fileId;
		ucm_id=retObj.docInfoMap.dID;
		procinstId=retObj.procInstId;
		document.getElementById("ucm_id").value= retObj.docInfoMap.dID != undefined ? retObj.docInfoMap.dID:"";
		if(retObj.docInfoMap.dID == undefined){
			document.getElementById("item0_1").innerHTML = "未上传文档";
		}else{
			document.getElementById("item0_1").innerHTML = "<a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+retObj.docInfoMap.file_id+"'>"+retObj.docInfoMap.dOriginalName+"</a>";

		}		
		document.getElementById("ucm_keyword").value= retObj.docInfoMap.doc_keyword != undefined ? retObj.docInfoMap.doc_keyword:"";
		document.getElementById("ucm_fileType").value= retObj.docInfoMap.dWebExtension != undefined ? retObj.docInfoMap.dWebExtension:"";
		document.getElementById("ucm_fileSize").value= retObj.docInfoMap.doc_size != undefined ? retObj.docInfoMap.doc_size:"";
		document.getElementById("ucm_createDate").value= retObj.docInfoMap.dCreateDate.substring(0,10);

		document.getElementById("ucm_filebrief").value= retObj.docInfoMap.doc_brief != undefined ? retObj.docInfoMap.doc_brief:"";
		document.getElementById("ucm_filedoctype").value= retObj.docInfoMap.doc_type != undefined ? retObj.docInfoMap.doc_type:"";
		if(retObj.docInfoMap.doc_score == "0"){
			document.getElementById("ucm_filescore").value = "";
		}else{
			document.getElementById("ucm_filescore").value= retObj.docInfoMap.doc_score != undefined ? retObj.docInfoMap.doc_score:"";
		}
		
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath%>/doc/multiproject/upload_file_eps.jsp?id='+folderid);
	}

	function toDelete(){
		var fileIds = "";
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }		    
	    var params = ids.split(',');
	    for(var i=0;i<params.length;i++){
	    	fileIds = fileIds+","+params[i].split(":")[0];
	    }
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ucmSrv", "deleteFile", "docId="+fileIds.substr(1));
			queryData(cruConfig.currentPage);
			clearCommonInfo();
		}
	}

	function toSearch(){
		popWindow('<%=contextPath%>/doc/multiproject/doc_search_eps.jsp');
	}
	
	//用的使这个在线查看文档
	function toView(){
		
	    ids = getSelIds('rdo_entity_id');

	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    if(ids.split(":").length > 2){
	    	alert("只能查看一条记录");
	    	return;
	    }
	    
		var file_id = ids.split(":")[0];
		var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
		var fileExtension = retObj.docInfoMap.dWebExtension;
		//var retObj = jcdpCallService("ucmSrv", "getDocUrl", "ucmId="+ucm_id);
		//var ucm_url = retObj.ucmUrl;
		window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension);
	}
	
	//修改文档，文档版本
	
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
		popWindow('<%=contextPath%>/doc/multiproject/edit_file_eps.jsp?id='+folderid+'&fileId='+file_id);

	}
	
	function toDownload(){
		
	    ids = getSelIds('rdo_entity_id');

	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    if(ids.split(":").length > 2){
	    	alert("只能下载一条记录");
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
	
	function clearCommonInfo(){
		var qTable = getObj('commonInfoTable');
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
			}
		}
		document.getElementById("item0_1").innerHTML = "";
		document.getElementById("attachement").src = "";
		document.getElementById("doclog").src = "";
		document.getElementById("docversion").src = "";
		document.getElementById("codeManager").src = "";
	}

	function syncRequest(method,action,content){
		var objXMLHttp; 
		if (window.XMLHttpRequest){ 
			objXMLHttp = new XMLHttpRequest(); 
		} 
		else  { 
			var MSXML=['MSXML2.XMLHTTP.6.0','MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0', 'MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP']; 
			for(var n = 0; n < MSXML.length; n ++) { 
				try { 
					objXMLHttp = new ActiveXObject(MSXML[n]); break; 
				} catch(e){
				} 
			} 
		}
		
		content=content.replace(/\+/g,"%2B");
		if("GET"==method.toUpperCase() && content!=""){
			if(action.indexOf("?")>0){
				action += "&";
			}else{
				action += "?";
			}
			action +=  content;;
			content = "";
		}
	  objXMLHttp.open(method,action,false);//指定要请求的方式和页面
	  objXMLHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");	
	  objXMLHttp.setRequestHeader("rtCallTyper","rtAsync");	
	
	  objXMLHttp.send(content);
	  
	  //alert(objXMLHttp.responseText);
	  var returnObj = eval('(' + objXMLHttp.responseText + ')');
	  if(returnObj.returnCode==-9){
	  	alert(returnObj.returnMsg);
	  	if(window.opener != null){
	  		window.close();
	  	}
	  	if(top.GB_CURRENT != null){
				top.GB_hide();
		}
		top.location = cruConfig.contextPath + '/login.jsp';
	  	returnObj = null;
	  	return;
	  }
	  return returnObj;
	}
 
</script>
<script type="text/javascript">
function showBlock(){  
    jQuery.blockUI({ message:"<image src='<%=contextPath%>/images/jiazai1.gif'></image>",css: {  border: 'none',width:"20px", top:"20%" ,left:"20%"   }});  
   // setTimeout('hideBlock()',2000);//2000毫秒后调用hideBlock()  
}  
function hideBlock(){  
    jQuery.unblockUI();  
}  
</script>  


<script type="text/javascript" language="javascript">
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
 
</html>

