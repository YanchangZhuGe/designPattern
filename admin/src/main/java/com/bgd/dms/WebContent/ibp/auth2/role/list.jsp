<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String nowDate = df.format(new Date());
	String contextPath = request.getContextPath();
	String folderId = "";
	if(request.getParameter("folderid") != null){
		folderId = request.getParameter("folderid");
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectNo = user.getProjectInfoNo();
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
<title>无标题文档</title>
</head>

<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">中文名称</td>
			    <td class="ali_cdn_input">
				    <input id="role_c_name" name="role_c_name" type="text" class="input_width"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				
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
			      <td class="bt_info_odd" exp="{role_c_name}">中文名称</td>
			      <td class="bt_info_even" exp="{role_e_name}">英文名称</td>
			      <td class="bt_info_odd" exp="{role_c_name}维护</a>" func="cdtConvert,/^超级管理员/,,<a href=javascript:popWindow('/<%=contextPath%>/ibp/auth2/menu/menuTree.jsp?type=2&id={role_id}')>,role_c_name">权限信息</td>
			      <td exp="{role_level}维护</a>" func="cdtConvert,/^U/,<a href='roleAndUsers.cpmd?id={role_id}'>,,role_level">用户信息</td>
      			  <td exp="{8ad878dd39de9ed00139e2eb45050269}" isshow="Hide" style="display:none">用户</td>
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
	cruConfig.queryStr = "select r.*,o.org_name from p_auth_role_dms r left join p_auth_org o on o.org_id = r.user_org_id where r.user_org_id = 'C6000000000001' order by r.role_c_name";

	var role_c_name= "";
	
	// 复杂查询
	function refreshData(q_role_c_name){
		if(q_role_c_name==undefined) q_role_c_name = role_c_name;
		role_c_name = q_role_c_name;

		cruConfig.submitStr = "role_c_name="+role_c_name;	
		queryData(1);
	}

	refreshData(undefined);
	
	function simpleSearch(){
			var q_file_name = document.getElementById("role_c_name").value;
			refreshData(q_file_name);
	}
	
	function clearQueryText(){
		document.getElementById("role_c_name").value = "";
	}
	
	function dbclickRow(ids){
		
	}
	
	function toAdd(){

		popWindow('<%=contextPath%>/doc/singleproject/upload_file.jsp?id='+folderid);
		
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
		popWindow('<%=contextPath%>/doc/singleproject/doc_search.jsp');
	}
	
	//选中一条记录在线查看文档
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
		popWindow('<%=contextPath%>/doc/singleproject/edit_file.jsp?id='+folderid+'&fileId='+file_id);

	}
	
</script>

</html>

