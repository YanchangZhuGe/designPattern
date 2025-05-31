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
	String control_id = request.getParameter("control_id");
	if(control_id==null){
		control_id = "";
	}
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
 </head> 
 <body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" >  
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
	    	<td class="inquire_item4">项目名称：</td>
	    	<td class="inquire_form4"><span id="project_name" name="project_name"></span>
	    		<input name="ucm_id" id="ucm_id" type="hidden" class="input_width" value="" />
		    	<input name="ids" id="ids" type="hidden" class="input_width" value="" />
		    	<input name="file_id" id="file_id" type="hidden" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">质量控制计划文件:</td>
		   	<td class="inquire_form4"><span ><a href="#" onclick="view_doc()"><font id="file_name" name="file_name" color="blue"></font></a></span></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4">备注</td>
	    	<td colspan="3" class="inquire_form4">
	    		<textarea name="note" id="note" cols="45" rows="5" class="textarea"> </textarea>
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
		var control_id = '<%=control_id%>';
		var sql = "select t.control_id ,t.file_name ,t.note ,t.project_info_no ,p.project_name ,f.file_id ,f.ucm_id ,concat(concat(f.file_id ,':'),f.ucm_id) ids "+
		" from bgp_qua_control t"+
		" left join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag='0'"+
		" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0'"+
		" where t.bsflag ='0' and t.control_id ='"+control_id+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj.datas != null && retObj.datas.length > 0){
			var data = retObj.datas[0];
			var control_id = data.control_id;
			var file_name = data.file_name;
			var project_name = data.project_name;
			var project_info_no = data.project_info_no;
			var file_id = data.file_id;
			var ucm_id = data.ucm_id;
			var ids = data.ids;
			var note = data.note;
			document.getElementById("file_name").innerHTML = file_name;
			document.getElementById("project_name").innerHTML = project_name;
			document.getElementById("ids").value = ids;
			document.getElementById("file_id").value = file_id;
			document.getElementById("note").value = note;
		}
	}
	refreshData();
	function view_doc(){
		var file_id = document.getElementById("file_id").value;
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
</body>
</html>