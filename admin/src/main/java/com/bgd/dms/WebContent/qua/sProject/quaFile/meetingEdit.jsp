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
	String projectName = user.getProjectName();
	if(projectName==null){
		projectName = "";
	}
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String report_id = request.getParameter("report_id");
	if(report_id==null){
		report_id = "";
	}
	String org_id = user.getOrgId();
	if(org_id==null || org_id.trim().equals("")){
		org_id = "";
	}
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	if(org_subjection_id==null || org_subjection_id.trim().equals("")){
		org_subjection_id = "";
	}
	String user_id = user.getUserId();
	String project_info_no = user.getProjectInfoNo();
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
<!--<form name="fileForm" id="fileForm" method="post" > target="hidden_frame" enctype="multipart/form-data" --> 
	<form id="fileForm" action="" method="post" target="list" enctype="multipart/form-data">

	<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<input type="hidden" name="report_id" id="report_id" value="<%=report_id %>" class="input_width" />
					<tr>
					    <td class="inquire_item4">质量分析报告:</td>
					    <td class="inquire_form4" ><input type="text" name="" id="" value="质量分析报告" class="input_width" disabled="disabled" /></td>
					   	<td class="inquire_item4">报告序列号:</td>
					    <td class="inquire_form4" ><input type="text" name="report_code" id="report_code" value="BGP/Q/JL8.2.4-5" class="input_width"/></td>
					</tr>
					<tr>   	
					   	<td class="inquire_item4"><font color="red">*</font>编号:</td>
					   	<td class="inquire_form4"><input type="text" name="report_num" id="report_num" value="" class="input_width" /></td>
					    <td class="inquire_item4"><font color="red">*</font>时间:</td>
					    <td class="inquire_form4" ><input type="text" name="report_date" id="report_date" value="" class="input_width" readonly="readonly"/>
					    <img width="16" height="16" id="cal_button6" style="cursor: hand;" 
	    					onmouseover="calDateSelector(report_date,cal_button6);" src="<%=contextPath %>/images/calendar.gif" /></td>
	    			</tr>
					<tr>
						<td class="inquire_item4">施工工区:</td>
					   	<td class="inquire_form4"><input type="text" name="work_area" id="work_area" value="" class="input_width" /></td>
						<td class="inquire_item4">线束号:</td>
					   	<td class="inquire_form4"><input type="text" name="line_num" id="line_num" value="" class="input_width" /></td>
				  	</tr>
					<tr>	
				  		<td class="inquire_item4">主持人:</td>
					    <td class="inquire_form4" ><input type="text" name="master_id" id="master_id" value="" class="input_width" /></td> 
						<td class="inquire_item4">记录人:</td>
					    <td class="inquire_form4" ><input type="text" name="record_id" id="record_id" value="" class="input_width" /></td> 
					</tr>
					<tr>
						<td class="inquire_item4">设计工作量:</td>
					   	<td class="inquire_form4"><input type="text" name="design_work" id="design_work" value="" class="input_width" 
					   		onkeydown="javascript:return checkIfNum(event);"/></td>
					   	<td class="inquire_item4">实际完成工作量:</td>
					   	<td class="inquire_form4"><input type="text" name="complete_work" id="complete_work" value="" class="input_width" 
					   		onkeydown="javascript:return checkIfNum(event);"/></td>
					</tr>
					<tr>	
				    	<td class="inquire_item4">上传文档:</td>
				    	<td class="inquire_form4">
				    		<input type="file" name="file" id="file" class="input_width" onchange="clearOldFileName()"/>
				    		<span id="downfile"></span> 
							<span id="fileUrl"></span> 
							<input id="UCM_ID" name="UCM_ID" value="" type="hidden"/>
							<input type="hidden" id="file_id" name="file_id" value=""/>
							<input type="hidden" id="ucmId" name="ucmId" value=""/>
							<input type="hidden" id="fileName" name="fileName" value=""/>
				    	</td>
			    	</tr>
					<tr>
						<td class="inquire_item4">表层调查:</td>
						<td class="inquire_form4" colspan=3"><textarea cols="" rows="" id="surface" name="surface" class="textarea"></textarea></td>
					</tr>
					<tr>   	
					   	<td class="inquire_item4">激发因素:</td>
					   	<td class="inquire_form4" colspan=3"><textarea cols="" rows="" id="stimulate" name="stimulate" class="textarea"></textarea></td>
					</tr>
					<tr>	
						<td class="inquire_item4">技术措施:</td>
					   	<td class="inquire_form4" colspan=3"><textarea cols="" rows="" id="technology" name="technology" class="textarea"></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item4"><div>质量管</div>理措施:</td>
					   	<td class="inquire_form4" colspan=3"><textarea cols="" rows="" id="manage_step" name="manage_step" class="textarea"></textarea></td>
					</tr>
					<tr>	
						<td class="inquire_item4">原始资料点评:</td>
					   	<td class="inquire_form4" colspan=3"><textarea cols="" rows="" id="original_data" name="original_data" class="textarea"></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item4"><div>现场处理&nbsp;</div>剖面评价:</td>
					   	<td class="inquire_form4"colspan=3" ><textarea cols="" rows="" id="sections" name="sections" class="textarea"></textarea></td>
					</tr>
					<tr>	
						<td class="inquire_item4">存在问题:</td>
					   	<td class="inquire_form4" colspan=3"><textarea cols="" rows="" id="proplem" name="proplem" class="textarea"></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item4"><div>下一步解决</div> <div>问题的措施:</div></td>
					   	<td class="inquire_form4" colspan=3"><textarea cols="" rows="" id="next_step" name="next_step" class="textarea"></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item4">质量监督员:</td>
					   	<td class="inquire_form4" colspan=3"><textarea cols="" rows="" id="supervise" name="supervise" class="textarea"></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item4">备注:</td>
					    <td class="inquire_form4" colspan=3"><textarea rows="4" cols="10" id="note" name="note" class="textarea"></textarea></td>
					</tr>
				</table>
			</div> 
			<div id="oper_div">
					<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
					<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
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

	
	function view_doc(ucmId,fileName){
		var info=ucmId+":"+fileName;
		   creatReq(info);
	}
	
	function clearOldFileName(){
		$("#downfile").html("");
		$("#fileUrl").html("");		  

	}
	function refreshData(){
		var report_id = '<%=report_id%>';
		var sql = "select t.report_id ,t.report_code ,t.report_num ,t.report_date ,t.work_area ,t.line_num ,"+
		" t.master_id ,t.record_id ,t.design_work ,t.complete_work ,t.surface ,t.stimulate ,t.technology ,"+
		" t.manage_step ,t.original_data ,t.sections ,t.proplem ,t.next_step ,t.supervise ,t.note,t.ucm_id,t.upload_file_name "+
		" from bgp_qua_meeting_report t "+
		" where t.bsflag='0' and t.report_id ='"+report_id+"'";
		
		var retObj = syncRequest('Post',cruConfig.contextPath + appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode =='0'){
			if(retObj.datas!=null && retObj.datas.length>0){
				if(retObj.datas[0]!=null){
					var map = retObj.datas[0];
					document.getElementById("report_id").value = report_id;
					document.getElementById("report_code").value = map.report_code;
					document.getElementById("report_num").value = map.report_num;
					document.getElementById("report_date").value = map.report_date;
					document.getElementById("work_area").value = map.work_area;
					document.getElementById("line_num").value = map.line_num;
					document.getElementById("master_id").value = map.master_id;
					document.getElementById("record_id").value = map.record_id;
					document.getElementById("design_work").value = map.design_work;
					document.getElementById("complete_work").value = map.complete_work;
					document.getElementById("surface").value = map.surface;
					document.getElementById("stimulate").value = map.stimulate;
					document.getElementById("technology").value = map.technology;
					document.getElementById("manage_step").value = map.manage_step;
					document.getElementById("original_data").value = map.original_data;
					document.getElementById("sections").value = map.sections;
					document.getElementById("proplem").value = map.proplem;
					document.getElementById("next_step").value = map.next_step;
					document.getElementById("supervise").value = map.supervise;
					document.getElementById("note").value = map.note;
					$("#downfile").html("<a onclick=\"view_doc('"+map.ucm_id+"','"+map.upload_file_name+"')\"><font color='blue'>"+map.upload_file_name+"</font></a>");
					$("#fileUrl").html("<input onclick=\"window.location ='<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+map.ucm_id+"';\" type=\"button\" value=\"下载\" />");		  
								
					
				}
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var form = document.getElementById("fileForm");
		form.action = "<%=contextPath%>/qua/meeting/saveOrUpdateQualityanalysisreport.srq";
		form.submit();
		//var ctt = top.frames('list');
		//ctt.refreshData();
		newClose();

	}
	function checkValue(){
		var obj = document.getElementById("report_num");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("编号不能为空!");
			return false;
		}
		obj = document.getElementById("report_date");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("时间不能为空!");
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
		+ "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=ucmSrv&JCDP_OP_NAME=getFilePathByUcmFileName&ucmid="+ucmid;//要请求的服务端地址
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