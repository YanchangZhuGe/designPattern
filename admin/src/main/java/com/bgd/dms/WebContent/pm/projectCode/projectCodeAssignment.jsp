<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String relation_id = request.getParameter("relationId").toString();
	String owner = request.getParameter("owner").toString();
	String sonFlag = request.getParameter("sonFlag");
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
<title>分类码(公用)</title>
</head>
<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3">分类码名</td>
			    <td class="ali1"><input id="code_name" name="code_name" type="text" onkeyup="simpleRefreshData()"/></td>
			    <td>&nbsp;</td>
			    <td><span class="gl"><a href="#" onclick="toSearch()" ></a></span></td>
			    <td><span class="zj"><a href="#" onclick="toAdd()"></a></span></td>
			    <td><span class="sc"><a href="#" onclick="toDelete()"></a></span></td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{object_id}' id='rdo_entity_id_{object_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{foreign_code_name}">分类码名</td>
			      <td class="bt_info_odd" exp="{foreign_code_type_name}">分类码所属大类</td>
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
	cruConfig.queryService = "ProjectCodeSrv";
	cruConfig.queryOp = "getCodeAssignment";
	cruConfig.submitStr = "relationId=<%=relation_id %>&owner=<%=owner %>";	
	var sonFlag_tmp="<%=sonFlag%>";

	$().ready(function(){
		if(sonFlag_tmp == 'Y'){
			$(".zj").hide();
			$(".sc").hide();
		}
	});
	queryData(1);
	
	// 复杂查询
	function refreshData(q_code_name,q_code_type_name){
		
		document.getElementById("code_name").value = q_code_name;
		
		cruConfig.submitStr = "owner=<%=owner %>&relationId=<%=relation_id %>&code_name="+q_code_name+"&code_type_name="+q_code_type_name;	
		queryData(1);
	}
	// 简单查询
	function simpleRefreshData(){
		var q_name = document.getElementById("code_name").value;
		refreshData(q_name,"");
	}

	function toAdd(){
		
	  	popWindow('<%=contextPath%>/pm/projectCode/projectCodeManager.jsp?action=view&relationId=<%=relation_id%>&owner=<%=owner %>');

	}

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    //var params = ids.split(',');
	   // alert("The params is:"+params);
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ProjectCodeSrv", "deleteCodeAssignment", "objectId="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow('<%=contextPath%>/pm/projectCode/projectCodeAssignmentSearch.jsp?relationId=<%=relation_id%>&owner=<%=owner %>');
	}
	
	function dbclickRow(ids){
			
	}
	
</script>
</html>