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
	String file_id = request.getParameter("file_id");
	if(file_id==null){
		file_id = "";
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
	    	<td class="inquire_item4">单位名称：</td>
	    	<td class="inquire_form4"><span id="project_name" name="project_name"></span>
		    	<input name="file_id" id="file_id" type="hidden" class="input_width" value="" /></td>
		    	<input name="ucm_id" id="ucm_id" type="hidden" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">文档名称:</td>
		   	<td class="inquire_form4"><span ><a id="douHref" href="#" onclick="view_doc()"><font id="file_name" name="file_name" color="blue"></font></a></span></td> 
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
	function refreshData(){
		var sql = "select oi.org_name,t.file_name,t.ucm_id,r.notes from bgp_doc_gms_file t left join comm_org_information oi on t.org_id=oi.org_id and oi.bsflag='0' left join bgp_comm_remark r on t.file_id=r.foreign_key_id and r.bsflag='0' where t.bsflag='0' and t.file_id='<%=file_id%>'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj.datas != null && retObj.datas.length > 0){
			var data = retObj.datas[0];
			document.getElementById("file_name").innerHTML = data.file_name;
			document.getElementById("project_name").innerHTML = data.org_name;
			document.getElementById("file_id").value = data.file_id;
			document.getElementById("ucm_id").value = data.ucm_id;
			document.getElementById("note").value = data.notes;
		}
	}
	refreshData();
	function view_doc(){
		var ucm_id = document.getElementById("ucm_id").value;
		if(ucm_id != ""){
			document.getElementById("douHref").href = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucm_id+"&emflag=0";
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
	}
</script>
</body>
</html>