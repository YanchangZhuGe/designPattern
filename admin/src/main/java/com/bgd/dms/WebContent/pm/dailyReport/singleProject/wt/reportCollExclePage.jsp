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
	String org_id = (String)user.getOrgId();
	String org_subjection_id = (String)user.getSubOrgIDofAffordOrg();
	String user_id = (String)user.getUserId();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo=user.getProjectInfoNo();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String swfFile = contextPath + "/WebContent/SWFTools/"+ user.getUserId() +"/";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.blockUI.js"></script>
 

<script type="text/javascript" >
cruConfig.contextPath =  "<%=contextPath%>";

function refreshData(exploration_method,proc_status){
		var str = "select f.FILE_ID,f.FILE_NAME,f.UCM_ID,f.PROJECT_INFO_NO,f.CREATE_DATE,e.EMPLOYEE_NAME "
			 	+"from  bgp_doc_gms_file f left join COMM_HUMAN_EMPLOYEE e on f.CREATOR_ID=e.EMPLOYEE_ID and e.BSFLAG='0'"
				+" where f.relation_id='WTRBDR' and f.PROJECT_INFO_NO='<%=projectInfoNo%>' and f.BSFLAG='0'";
		cruConfig.queryStr = str+" order by f.CREATE_DATE desc";
		queryData(cruConfig.currentPage);
		
}

function loadDataDetail(ids){

}

function view_doc(file_id){
	if(file_id != ""){
	 creatReq(file_id);
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
    if(ids.split(",").length > 1){
    	alert("请只选中一条记录");
    	return;
    }
   window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+ids;
}
	

function searchDevData(){

	refreshData(exploration_method,proc_status);
}
                                                                                                                                             
</script>
<title>列表页面</title>
</head>
<body style="background:#fff"  onload="refreshData()" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				<!-- 
				<td class="ali_cdn_name">时间</td>
				<td class="ali_cdn_input"><input id="year" name="year" type="text" class="input_width" readonly="readonly"/></td>
				<td class='ali_btn'>
				<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="yymmSelector(year,cal_button7);"  src="<%=contextPath %>/images/calendar.gif" />
				</td>
				 -->		
			 	    <td>&nbsp;</td>
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
			<tr id="dailyTr">
				<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{file_id}' id='chk_entity_id' />" >选择</td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	 <td class="bt_info_odd" exp="<a href='#' onclick=view_doc('{file_id}:{ucm_id}')><font color='blue'>{file_name}</font></a>">文件名称</td>
			  	<td class="bt_info_odd" exp="{create_date}">上传时间</td>
			  	<td class="bt_info_odd" exp="{employee_name}">上传人</td>
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
</div>	
<script type="text/javascript">

function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
	$("#table_box").css("height",$(window).height()*0.85);
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
