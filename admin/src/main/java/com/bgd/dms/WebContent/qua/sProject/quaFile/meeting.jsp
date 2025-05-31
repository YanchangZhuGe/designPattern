<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
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
<script charset="UTF-8" type="text/javascript" src="<%=contextPath%>/qua/sProject/quaFile/meeting.js"></script>


<style type="text/css" >
</style>
<script type="text/javascript" >
	
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
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_FILE_006" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_FILE_006" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_FILE_006" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
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
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{report_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{report_num}">编号</td>
			  <td class="bt_info_even" exp="{report_date}">时间</td>
			  <td class="bt_info_odd" exp="<a onclick=view_doc('{ucm_id}','{upload_file_name}')><font color='blue'>{upload_file_name}</font></a>">文档名称</td>
			  <!--<td class="bt_info_odd" exp="<a href='#' onclick=reportShow('{report_id}')><font color='blue'>报表</font></a>">报表</td>-->
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
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">质量分析报告</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" > 
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<input type="hidden" name="report_id" id="report_id" value="" class="input_width" />
				<tr>
				    <td class="inquire_item8">质量分析报告:</td>
				    <td class="inquire_form8" ><input type="text" name="" id="" value="质量分析报告" class="input_width" disabled="disabled" /></td>
				   	<td class="inquire_item8">报告序列号:</td>
				    <td class="inquire_form8" ><input type="text" name="report_code" id="report_code" value="BGP/Q/JL8.2.4-5" class="input_width"/></td>
				   	<td class="inquire_item8"><font color="red">*</font>编号:</td>
				   	<td class="inquire_form8"><input type="text" name="report_num" id="report_num" value="" class="input_width" /></td>
				    <td class="inquire_item8"><font color="red">*</font>时间:</td>
				    <td class="inquire_form8" ><input type="text" name="report_date" id="report_date" value="" class="input_width" disabled="disabled"/>
				    <img width="16" height="16" id="cal_button6" style="cursor: hand;" 
    					onmouseover="calDateSelector(report_date,cal_button6);" src="<%=contextPath %>/images/calendar.gif" /></td>
    			</tr>
				<tr>
					<td class="inquire_item8">施工工区:</td>
				   	<td class="inquire_form8"><input type="text" name="work_area" id="work_area" value="" class="input_width" /></td>
					<td class="inquire_item8">线束号:</td>
				   	<td class="inquire_form8"><input type="text" name="line_num" id="line_num" value="" class="input_width" /></td>
			  		<td class="inquire_item8">主持人:</td>
				    <td class="inquire_form8" ><input type="text" name="master_id" id="master_id" value="" class="input_width" /></td> 
					<td class="inquire_item8">记录人:</td>
				    <td class="inquire_form8" ><input type="text" name="record_id" id="record_id" value="" class="input_width" /></td> 
				</tr>
				<tr>
					<td class="inquire_item8">设计工作量:</td>
				   	<td class="inquire_form8"><input type="text" name="design_work" id="design_work" value="" class="input_width" 
				   		onkeydown="javascript:return checkIfNum(event);"/></td>
				   	<td class="inquire_item8">实际完成工作量:</td>
				   	<td class="inquire_form8"><input type="text" name="complete_work" id="complete_work" value="" class="input_width" 
				   		onkeydown="javascript:return checkIfNum(event);"/></td>
				   		
				   	<td class="inquire_item8"><font color="red"></font>会议文档:</td>
				   	<td class="inquire_form8" colspan="3">
					<span id="downfile"></span> <span id="fileUrl"></span>
					</td> 	
				</tr>
				<tr>
					<td class="inquire_item8">表层调查:</td>
					<td class="inquire_form8" colspan=3"><textarea cols="" rows="" id="surface" name="surface" class="textarea"></textarea></td>
				   	<td class="inquire_item8">激发因素:</td>
				   	<td class="inquire_form8" colspan=3"><textarea cols="" rows="" id="stimulate" name="stimulate" class="textarea"></textarea></td>
				</tr>
				<tr>	
					<td class="inquire_item8">技术措施:</td>
				   	<td class="inquire_form8" colspan=3"><textarea cols="" rows="" id="technology" name="technology" class="textarea"></textarea></td>
				   	<td class="inquire_item8"><div>质量管</div>理措施:</td>
				   	<td class="inquire_form8" colspan=3"><textarea cols="" rows="" id="manage_step" name="manage_step" class="textarea"></textarea></td>
				</tr>
				<tr>	
					<td class="inquire_item8">原始资料点评:</td>
				   	<td class="inquire_form8" colspan=3"><textarea cols="" rows="" id="original_data" name="original_data" class="textarea"></textarea></td>
				   	<td class="inquire_item8"><div>现场处理&nbsp;</div>剖面评价:</td>
				   	<td class="inquire_form8"colspan=3" ><textarea cols="" rows="" id="sections" name="sections" class="textarea"></textarea></td>
				</tr>
				<tr>	
					<td class="inquire_item8">存在问题:</td>
				   	<td class="inquire_form8" colspan=3"><textarea cols="" rows="" id="proplem" name="proplem" class="textarea"></textarea></td>
				   	<td class="inquire_item8"><div>下一步解决</div> <div>问题的措施:</div></td>
				   	<td class="inquire_form8" colspan=3"><textarea cols="" rows="" id="next_step" name="next_step" class="textarea"></textarea></td>
				</tr>
				<tr>
					<td class="inquire_item8">质量监督员:</td>
				   	<td class="inquire_form8" colspan=3"><textarea cols="" rows="" id="supervise" name="supervise" class="textarea"></textarea></td>
					 <td class="inquire_item8">备注:</td>
				    <td class="inquire_form8" colspan=3"><textarea rows="4" cols="10" id="note" name="note" class="textarea"></textarea></td>
				</tr>
			</table>
		</div>
		<div id="tab_box_content2" class="tab_box_content" > 
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				
			</table>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	var project = '<%=projectInfoNo%>';
	
	function view_doc(ucmId,fileName){
		var info=ucmId+":"+fileName;
		   creatReq(info);
	}

	
	function refreshData(){
		if(project ==null || project=='null' || project ==''){
			alert("请选择项目");
			return;
		}
		cruConfig.queryStr = "select t.report_id ,t.report_num ,t.report_date,t.upload_file_name,t.ucm_id from bgp_qua_meeting_report t where t.bsflag='0' and t.project_info_no ='"+project+"'";
		setTabBoxHeight();
		queryData(1);
	}
	refreshData();
	/* 详细信息 */
	function loadDataDetail(report_id){
		var obj = event.srcElement;
		if(obj.tagName.toLowerCase()=='td'){
			var tr = obj.parentNode;
			tr.cells[0].firstChild.checked =true;
		}
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

	
	function reportShow(report_id){
		popWindow('<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=QUA_ANALYSIS&noLogin=admin&tokenId=admin&KeyId='+report_id,'780:720');
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
