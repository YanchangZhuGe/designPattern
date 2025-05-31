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
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	if(org_subjection_id==null || org_subjection_id.trim().equals("")){
		org_subjection_id = "";
	}
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.blockUI.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
	var checked = false;
	function check(val){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			 
			if(chk[i].value != val.value){  
				chk[i].checked = false; 
			} 
		} 
		
	}
	function clearQueryText(){
		document.getElementById("name").value = '';
		refreshData('');
	}
	
	function view_doc(file_id){
		if(file_id != ""){
			//alert(file_id);
		 creatReq(file_id);
		<%-- 	var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension); --%>
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
	}
	function yymmSelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
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
						    <td class="ali_cdn_input"><input type="text" id="name" name="name" class="input_width"/>
						   		<input type="hidden" id="org_subjection_id" name="org_subjection_id" class="input_width" value="<%=org_subjection_id%>"/></td>
						    <td class="ali_cdn_name">注册时间</td>
							<td class="ali_cdn_input"><input id="year" name="year" type="text" class="input_width" disabled="disabled"/></td>
							<td class='ali_btn'><img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="yymmSelector(year,cal_button7);"  src="<%=contextPath %>/images/calendar.gif" /></td>
							<auth:ListButton functionId="" css="cx" event="onclick=refreshData('')" title="JCDP_btn_submit"></auth:ListButton>
							<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
						 	<td>&nbsp;</td>
						    <%-- <auth:ListButton functionId="F_QUA_QC_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_QC_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_QC_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton> --%>
						    <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton> 
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			   <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{id}:{file_id}' onclick='check(this)'/>" >
			  </td>
			  <td class="bt_info_even" exp="{auto}">序号</td> 
			  <td class="bt_info_odd" exp="{qc_code}">QC活动编号</td>
			  <td class="bt_info_even" exp="{qc_title}">QC活动课题</td>
			  <td class="bt_info_odd" exp="<a href='#' onclick=view_doc('{file_id}:{ucm_id}')><font color='blue'>{name}</font></a>">注册文件</td>
			  <td class="bt_info_even" exp="{pro_status}">审批情况</td>
			  <td class="bt_info_odd" exp="{org_name}">实施单位</td>
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
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">活动记录</a></li>
        <li><a href="#" onclick="getTab(this,2)">活动成果</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" >
		<div id="tab_box_content1" class="tab_box_content" >
			<iframe width="100%" height="100%" src="" name="record" id="record" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="" name="result" id="result" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
	</div>	
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
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
	function refreshData(org_subjection_id){
		
		var qc_title = document.getElementById("name").value;
		var year = document.getElementById("year").value;
		var subjection = document.getElementById("org_subjection_id").value;
		if(subjection!=null && subjection!=''&& (org_subjection_id==null || org_subjection_id=='')){
			org_subjection_id = subjection;
		}
		if(org_subjection_id ==null || org_subjection_id==''){
			org_subjection_id = '<%=org_subjection_id %>';
		}else{
			document.getElementById("org_subjection_id").value = org_subjection_id;
		}
		cruConfig.submitStr = "org_subjection_id="+org_subjection_id+"&qc_title="+qc_title+"&pro_status=3&year="+year;
		setTabBoxHeight();
		queryData(1);
	}
	refreshData('');
	/* 详细信息 */
	function loadDataDetail(qc_id){
		qc_id = qc_id.split(":")[0];
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	}
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
		document.getElementById("record").src = "<%=contextPath%>/qua/common/file_list_view.jsp?relationId=record:"+qc_id;
		document.getElementById("result").src = "<%=contextPath%>/qua/common/file_list_view.jsp?relationId=result:"+qc_id;
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
		//$("#table_box").css("height",$(window).height()*0.98-$("#inq_tool_box").height()-$("#fenye_box").height());
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	
	$(document).ready(lashen);
	function exportData2(curPage, pageSize){
		if(curPage==undefined) curPage=cruConfig.currentPage;
		if(pageSize==undefined) pageSize=cruConfig.pageSize;
		var titleRow = getObj('queryRetTable').rows[0];
		var columnExp="";
		var columnTitle="";
		for(var j=0;j<titleRow.cells.length;j++){
			var tCell = titleRow.cells[j];
			if(tCell.exp==null || tCell.exp=="null" || tCell.exp.indexOf("{")>0 || tCell.isExport=="Hide") continue;
			columnExp += tCell.exp.substring(1,tCell.exp.length-1) + ",";
			columnTitle += tCell.innerHTML + ",";
		}
		var org_subjection_id = document.getElementById("org_subjection_id").value;
		var querySql = "select rownum auto,d.* from (select t.qc_id id ,f.file_id ,t.qc_code ,t.qc_title ,f.file_name name , t.qc_code relation , "+
		     " decode(wf.proc_status,'1','待审核','3','审核通过','4','审核不通过','未上报') pro_status ,i.org_abbreviation org_name ,"+
		     " concat(concat(t.qc_id ,':'),wf.proc_status) id_proc from bgp_qua_qc t "+
		     " join comm_org_information i on t.org_id = i.org_id and i.bsflag ='0'"+
		     " left join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag='0'"+
		     " left join common_busi_wf_middle wf on t.qc_id = wf.business_id and wf.bsflag='0'"+
			 " where t.bsflag='0' and wf.proc_status like'3' and t.org_subjection_id like '"+org_subjection_id+"%' order by t.qc_code ) d";
		
		var path = cruConfig.contextPath+"/common/excel/listToExcel.srq";
		var excel_name = top.frames["fourthMenuFrame"].selectedTag.childNodes[0].innerHTML;
		var submitStr = "querySql="+querySql+"&currentPage="+curPage+"&pageSize="+pageSize;
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		submitStr = submitStr +"&JCDP_SRV_NAME=RADCommCRUD&JCDP_OP_NAME=queryRecords&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+excel_name;
		var retObj = syncRequest("post", path, submitStr);
		
		window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+excel_name+".xls";
		
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
	    var file_id = ids.split(":")[1];
	    if(file_id != ""){
	    	window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+file_id;
	    }else{
	    	alert("该条记录没有文档");
	    	return;
	    }
	}
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
