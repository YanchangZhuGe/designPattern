<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String version_fileId = request.getParameter("theFileId").toString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>文档版本</title>
</head>
<body style="background:#fff">
      	<div id="list_table">
      		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
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
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}:{version_ucm_id}' id='rdo_entity_id_{file_id}' onclick=doCheck(this)/>" >选择</td>			      
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{file_name}">文件标题</td>
			      <td class="bt_info_odd" exp="{file_version}">文件版本</td>			      
			      <td class="bt_info_odd" exp="{user_name}">操作人</td>
			      <td class="bt_info_even" exp="{create_date}">操作时间</td>
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
		  </div>
</body>
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
</script>

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ucmSrv";
	cruConfig.queryOp = "getDeletedDocVersionList";
	cruConfig.submitStr = "theFileVersionId=<%=version_fileId%>";	
	queryData(1);
	
	function viewDoc(ids){
		var file_id = ids.split(":")[0];
		var ucm_id = ids.split(":")[1];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&isdeleted=deletedfile&fileExt='+fileExtension);	
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
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
	    	window.location = "<%=contextPath%>/doc/downloadDeletedDocByUcmId.srq?docId="+ucm_id+"&isdeleted=deletedfile";
	    }else{
	    	alert("该条记录没有文档");
	    	return;
	    }	    
	    
	}
</script>
</html>