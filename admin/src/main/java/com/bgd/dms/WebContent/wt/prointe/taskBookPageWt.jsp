<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no == null){
		project_info_no = "";
	}
	String project_name = user.getProjectName();
	if(project_name == null){
		project_name = "";
	}
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

<style type="text/css" >
</style>
<script type="text/javascript" >
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}else{
			checked = true;
		}
	}
	

	
	function refreshData(){
		var str="SELECT tb.TASKBOOK_ID, tb.PROJECT_INFO_NO, tb.FILE_NAME, tb.UCM_ID, to_char(tb.CREATE_DATE,'yyyy-MM-dd') as CREATE_DATE, tb.UPDATATOR, tb.BSFLAG, tb.ISSUER, tb.INVESTMENT_UNIT, tb.PROINTE_HEAD,"
		+"p.PROJECT_NAME "
		+"FROM GP_OPS_PROINTE_TASKBOOK_WT tb left join GP_TASK_PROJECT p on tb.PROJECT_INFO_NO=p.PROJECT_INFO_NO and p.BSFLAG='0' "
		+"where tb.BSFLAG='0'";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff" onload="refreshData();">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="xz" event="onclick='toDownload()'" title="JCDP_btn_down"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input id='chk_entity_id{taskbook_id}' type='checkbox' name='chk_entity_id' value='{taskbook_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			  <td class="bt_info_even" exp="<a onclick=view_doc('{ucm_id}','{file_name}')><font color='blue'>{file_name}</font></a>">处理解释任务书</td>
			  <td class="bt_info_odd" exp="{issuer}">下达人</td>
			  <td class="bt_info_even" exp="{create_date}">下达日期</td>
			  <td class="bt_info_odd" exp="<input id='ucm{taskbook_id}' type='hidden' name='ucm' value='{ucm_id}' />" ></td>
			  
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
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			  </tr>
			</table>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		    		<tr>
				    	<td class="inquire_item4">项目名称:</td>
				    	<td class="inquire_form4"><input name="project_name" id="project_name" type="text" class="input_width" value="" readonly="readonly"/></td>
				    	<td class="inquire_item4">下达人:</td>
				    	<td class="inquire_form4"><input name="issuer" id="issuer" type="text" class="input_width" value="" readonly="readonly"/></td>
				    </tr>
				    <tr>
				    	<td class="inquire_item4">投资单位:</td>  
				    	<td class="inquire_form4"><input name="investment_unit" id="investment_unit" type="text" class="input_width" value="" readonly="readonly"/></td>
				    	<td class="inquire_item4">处理解释负责人:</td>
				    	<td class="inquire_form4"><input name="prointe_head" id="prointe_head" type="text" class="input_width" value="" readonly="readonly"/></td>
				    </tr>
				</table>
		</div>

	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";

	/* 详细信息 */
	function loadDataDetail(ids){
		var querySql="SELECT tb.TASKBOOK_ID, tb.PROJECT_INFO_NO, tb.FILE_NAME, tb.UCM_ID, tb.CREATE_DATE, tb.UPDATATOR, tb.BSFLAG, tb.ISSUER, tb.INVESTMENT_UNIT, tb.PROINTE_HEAD,"
			+"p.PROJECT_NAME "
			+"FROM GP_OPS_PROINTE_TASKBOOK_WT tb left join GP_TASK_PROJECT p on tb.PROJECT_INFO_NO=p.PROJECT_INFO_NO and p.BSFLAG='0' "
			+"where tb.BSFLAG='0' and tb.TASKBOOK_ID='"+ids+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null){
			$("#project_name").val(datas[0].project_name);
			$("#issuer").val(datas[0].issuer);
			$("#investment_unit").val(datas[0].investment_unit);
			$("#prointe_head").val(datas[0].prointe_head);
		}
		$("input[type='checkbox'][name='chk_entity_id'][id!='chk_entity_id"+ids+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='chk_entity_id'][id='chk_entity_id"+ids+"']").attr("checked",'true');
	}

	function view_doc(ucmId,fileName){
		var info=ucmId+":"+fileName;
		   creatReq(info);
	}
	function toDownload(){
	    ids = getSelIds('chk_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	 		return;
		}	
	    if(ids.split("~").length > 1){
	    	alert("请只选中一条记录");
	    	return;
	    }
	    var ucm_id = $("#ucm"+ids).val();

	    if(ucm_id != ""){
	    	window.location = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucm_id;
	    }else{
	    	alert("该条记录没有文档");
	    	return;
	    }
	}

	var selectedTag=document.getElementsByTagName("li")[0];
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

	function toAdd() { 
		popWindow("<%=contextPath%>/wt/prointe/taskBookEditWt.jsp?taskbookId=");
	}
	
	function toEdit() {
		ids = getSelIds('chk_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var params = ids.split('~');
	    if(params.length>1){
	        alert("请选择一条记录!");
	    	return;
	    }
		popWindow("<%=contextPath%>/wt/prointe/taskBookEditWt.jsp?taskbookId="+ids);
	    
	}
	function toDel() {
		ids = getSelIds('chk_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		if(window.confirm("你确定要删除?")){
			var retObj = jcdpCallService("WtProinteSrv","deleteTaskBookWt", "taskbooks="+ids);
			if(retObj!=null && retObj.returnCode =='0'){
				alert("删除成功!");
			}
		}
		refreshData();
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
function creatReq(info){ // 创建xmlhttprequest,ajax开始
	var url = getContextPath()+ 
	"/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=ucmSrv&JCDP_OP_NAME=getFilePathByUcmFileName&info="+info;//要请求的服务端地址
		if (window.XMLHttpRequest) {
		    req = new XMLHttpRequest();
		} else if (window.ActiveXObject) {	
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

		if (req) { //成功创建xmlhttprequest
		    req.open("GET", url, true); //与服务端建立连接(请求方式post或get，地址,true表示异步)
		    req.onreadystatechange = callback; //指定回调函数
		    req.send(null); //发送请求
		}
}

function callback() {//回调函数，对服务端的响应处理，监视response状态
		if (req.readyState == 4) {//请求状态为4表示成功
		    if (req.status == 200) {//http状态200表示OK
			 Dispaly();//所有状态成功，执行此函数，显示数据
		    } else{ //http返回状态失败
				alert("服务端返回状态" + req.statusText);
		    }
		} else{ //请求状态还没有成功，页面等待
		    showBlock();
		}
}

function Dispaly() {//接受服务端返回的数据，对其进行显示

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
