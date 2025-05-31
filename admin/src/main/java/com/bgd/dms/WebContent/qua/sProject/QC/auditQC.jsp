<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String qc_id = request.getParameter("qc_id");
	if(qc_id==null){
		qc_id = "";
	}
	

	String swfFile = contextPath + "/WebContent/SWFTools/"+ user.getUserId() +"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head> 
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/jquery.blockUI.js"></script>
 </head> 
 <body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" >  
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
	    	<td class="inquire_item4">QC活动注册文件:</td>
		   	<td class="inquire_form4"><span ><a href="#" onclick="view_doc()"><font id="file_name" name="file_name" color="blue"></font></a></span></td> 
	    </tr>
     	<tr>
	    	<td class="inquire_item4">QC课题：</td>
	    	<td class="inquire_form4" colspan="3"><textarea name="qc_title" id="qc_title" cols="45" rows="5" class="textarea"></textarea>
	    		<input name="ucm_id" id="ucm_id" type="hidden" class="input_width" value="" />
	    		<input name="file_id" id="file_id" type="hidden" class="input_width" value="" />
		    	<input name="ids" id="ids" type="hidden" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">备注</td>
	    	<td colspan="3" class="inquire_form4"> <textarea name="note" id="note" cols="45" rows="5" class="textarea"> </textarea>
	    	</td>
	    </tr>
    </table> 
  </div> 
  </div> 
  </div>
</form> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
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
	function refreshData(){
		var qc_id = '<%=qc_id%>';
		var sql = "select t.qc_title ,t.notes ,f.file_id ,f.ucm_id , f.file_name ,concat(concat(f.file_id ,':'),f.ucm_id) ids "+
		" from bgp_qua_qc t"+
		" left join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag='0'"+
		" where t.bsflag ='0' and t.qc_id ='"+qc_id+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj.datas != null && retObj.datas.length > 0){
			var data = retObj.datas[0];
			var qc_id = data.qc_id;
			var file_name = data.file_name;
			var file_id = data.file_id;
			var ucm_id = data.ucm_id;
			var ids = data.ids;
			var qc_title = data.qc_title;
			var note = data.notes;
			document.getElementById("file_name").innerHTML = file_name;
			document.getElementById("qc_title").innerHTML = qc_title;
			document.getElementById("ids").value = ids;
			document.getElementById("file_id").value = file_id;
			document.getElementById("ucm_id").value = ucm_id;
			document.getElementById("note").value = note;
		}
	}
	refreshData();
	function view_doc(){
		var file_id = document.getElementById("file_id").value;
		var ucm_id = document.getElementById("ucm_id").value;
		if(file_id != ""){
			 
			creatReq(file_id+":"+ucm_id);
	<%-- 		var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension); --%>
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