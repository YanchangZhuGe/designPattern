<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String extPath = contextPath + "/js/extjs";
	String rootMenuId = user.getProjectInfoNo();
	System.out.println("The rootMenuId is:"+rootMenuId);
	String action = request.getParameter("action");
	System.out.println("The action is:"+action);
	String folder_id = request.getParameter("folderid");
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
			    <td class="ali_cdn_name">编号名称</td>
			    <td class="ali_cdn_input">
				    <input id="query_number_name" name="query_number_name" type="text" class="input_width"/>
			    </td>
			    
			    <td class="ali_cdn_name">编号内容</td>
			    <td class="ali_cdn_input">
				    <input id="query_number_value" name="query_number_value" type="text" class="input_width"/>
			    </td>
			    
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <%if(action==null){ %>
				    <auth:ListButton functionId="F_DOC_016" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="F_DOC_017" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				    <auth:ListButton functionId="F_DOC_018" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <%}%>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{bgp_doc_file_number_id}' id='rdo_entity_id_{bgp_doc_file_number_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{file_number_name}<input type='hidden' id='numberName_{bgp_doc_file_number_id}' value='{file_number_name}'/>">规则名称</td>
			      <td class="bt_info_even" exp="{file_number_value}">规则内容</td>
			      <td class="bt_info_odd" exp="{create_date}">创建时间</td>
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">分类码</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
				</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable" class="tab_line_height">
					  <tr>
					    <td class="inquire_item8">规则名称：</td>
					    <td class="inquire_form8" id="item0_0"><input type="text" id="number_name" name="number_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item8">规则内容：</td>
					    <td class="inquire_form8" id="item0_1"><input type="text" id="number_value" name="number_value" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item8">创建时间：</td>
					    <td class="inquire_form8" id="item0_3"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/></td>
					  	<td class="inquire_item8">创建人：</td>
					    <td class="inquire_form8" id="item0_4"><input type="text" id="creator_name" name="creator_name" class="input_width" readonly="readonly"/></td>					  	
					  </tr>				    
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>	
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>	
				</div>
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
	cruConfig.queryStr = "";
	cruConfig.queryService = "ucmSrv";
	cruConfig.queryOp = "getFileNumber";
	var folderid= "";
	var file_name="";
	var ucm_id="";
	var procinstId="";
	var fileId="";
	
	var doc_type = "";
	var doc_keyword = "";
	var doc_importance = "";
	var create_date = "";
	
	var file_number_name = "";
	var file_number_value = "";
	
	// 复杂查询
	function refreshData(q_file_number_name, q_file_number_value){
		if(q_file_number_name==undefined) q_file_number_name = file_number_name;
		file_number_name = q_file_number_name;

		if(q_file_number_value==undefined) q_file_number_value = file_number_value;
		file_number_value = q_file_number_value;

		cruConfig.submitStr = "number_name="+q_file_number_name+"&number_value="+q_file_number_value;	
		queryData(1);
	}

	refreshData(undefined, undefined);
	
	function simpleSearch(){
			var q_file_number_name = document.getElementById("query_number_name").value;
			var q_file_number_value = document.getElementById("query_number_value").value;
			refreshData(q_file_number_name, q_file_number_value);
	}
	
	function clearQueryText(){
		document.getElementById("query_number_name").value = "";
		document.getElementById("query_number_value").value = "";
	}
	
	function dbclickRow(ids){
		
		<%if(action!=null&&action.equals("selectnumberformat")){ %>
		location.href="<%=contextPath %>/doc/setNewNumberFormat.srq?formatId="+ids+"&folderId=<%=folder_id%>";
		var name = document.getElementById("numberName"+ids).value;
		parent.window.opener.document.getElementById('number_format').value = name;
		parent.window.close();
		<%}else{%>
		alert("selectnumberformat值有问题");
		<%}%>
	}
	
	
	function loadDataDetail(ids){
		var retObj = jcdpCallService("ucmSrv", "getFileNumberInfo", "fileNumberId="+ids);
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=10&relationId="+ids;
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		
		document.getElementById("number_name").value= retObj.fileNumberMap.fileNumberName != undefined ? retObj.fileNumberMap.fileNumberName:"";
		document.getElementById("number_value").value= retObj.fileNumberMap.fileNumberValue != undefined ? retObj.fileNumberMap.fileNumberValue:"";
		document.getElementById("create_date").value= retObj.fileNumberMap.createDate != undefined ? retObj.fileNumberMap.createDate:"";
		document.getElementById("creator_name").value= retObj.fileNumberMap.creatorName != undefined ? retObj.fileNumberMap.creatorName:"";
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=10&relationId="+ids;
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath %>/doc/filenumber/add_file_number.jsp');
		
	}

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ucmSrv", "deleteFileNumber", "fileNumberId="+ids);
			queryData(cruConfig.currentPage);
			clearCommonInfo();
		}
	}
	
	//修改文档，文档版本
	
	function toEdit(){

	    ids = getSelIds('rdo_entity_id');

	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    if(ids.split(",").length > 1){
	    	alert("只能编辑一条记录");
	    	return;
	    }
	    
		popWindow('<%=contextPath%>/doc/filenumber/edit_file_number.jsp?file_number_id='+ids);

	}
	

</script>

</html>

