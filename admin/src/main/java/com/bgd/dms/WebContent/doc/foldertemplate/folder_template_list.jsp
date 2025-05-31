<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String folderId = "";
	if(request.getParameter("folderid") != null){
		folderId = request.getParameter("folderid");
	}
	String action = request.getParameter("action");
	System.out.println("The action is:"+action);
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
<title>文档模板列表</title>
</head>

<body style="background:#cdddef">
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">模板名称</td>
			    <td class="ali_cdn_input">
				    <input id="query_template_name" name="query_template_name" type="text" class="input_width"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <%if(action == null){ %>
				    <auth:ListButton functionId="F_DOC_019" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="F_DOC_020" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				    <auth:ListButton functionId="F_DOC_021" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <%} %>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}-{is_template}-{file_abbr}' id='rdo_entity_id_{file_id}' onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{file_name}">模板名称</td>
			      <td class="bt_info_even" exp="{create_date}">创建时间</td>
			      <td class="bt_info_odd" exp="{user_name}">创建人</td>
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
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">模板名称：</td>
					    <td class="inquire_form6" id="item0_0"><input type="text" id="template_name" name="template_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">创建时间：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">创建人：</td>
					    <td class="inquire_form6" id="item0_2"><input type="text" id="creator_name" name="creator_name" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">是否被使用：</td>
					    <td class="inquire_form6" id="item0_3"><input type="text" id="is_used" name="is_used" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">模板缩写</td>
					    <td class="inquire_form6" id="item0_4"><input type="text" id="template_abbr" name="template_abbr" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6" id="item0_5">&nbsp;</td>
					  </tr>					    
					</table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>	
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
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
	cruConfig.queryOp = "getFolderTemplate";
	//cruConfig.queryRetTable_id = "";
	var template_name="";
	
	// 复杂查询
	function refreshData(q_template_name){
		if(q_template_name==undefined) q_template_name = template_name;
		template_name = q_template_name;

		cruConfig.submitStr = "template_name="+q_template_name;	
		queryData(1);
	}

	refreshData(undefined);
	
	function simpleSearch(){
			var q_template_name = document.getElementById("query_template_name").value;
			refreshData(template_name);
	}
	
	function clearQueryText(){
		document.getElementById("query_template_name").value = "";
	}
	
	function dbclickRow(ids){	
		var id_s = ids.split('-')[0];  
		var if_s = ids.split('-')[1];  
		
		<%if(action!=null&&action.equals("selecttemplate")){ %>
		alert("设置模板");
		var root_id = '<%=request.getParameter("rootId")%>';
		location.href="<%=contextPath %>/doc/setTemplate.srq?templateId="+id_s+"&rootId="+root_id;
		//var name = document.getElementById("nuberName"+ids).value;
		//parent.window.opener.document.getElementById('number_format').value = name;
		//parent.window.close();
		<%}else{%>
			if(id_s != "" && id_s != undefined){
				window.location.href = "<%=contextPath %>/doc/foldertemplate/edit_template.jsp?templateID="+id_s+"&if_s="+if_s;
			}else{
		    	alert("该条记录有问题");
		    	return;
			}
		<%}%>
		}
	
	   function chooseOne(cb){   
	          var obj = document.getElementsByName("rdo_entity_id");   
	          for (i=0; i<obj.length; i++){   
	              if (obj[i]!=cb) obj[i].checked = false;   
	              else obj[i].checked = true;   
	          }   
	      }   
	   
	function loadDataDetail(ids){
		var id_s = ids.split('-')[0];  
	 
		var retObj = jcdpCallService("ucmSrv", "getTemplateInfo", "templateID="+id_s);
		document.getElementById("template_name").value= retObj.docInfoMap.template_name != undefined ? retObj.docInfoMap.template_name:"";
		document.getElementById("create_date").value= retObj.docInfoMap.create_date != undefined ? retObj.docInfoMap.create_date:"";
		document.getElementById("creator_name").value= retObj.docInfoMap.user_name != undefined ? retObj.docInfoMap.user_name:"";
		document.getElementById("is_used").value= retObj.docInfoMap.is_template_used != undefined ? retObj.docInfoMap.is_template_used:"";
		document.getElementById("template_abbr").value= retObj.docInfoMap.template_abbr != undefined ? retObj.docInfoMap.template_abbr:"";
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=10&relationId="+id_s;
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+id_s;
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath %>/doc/foldertemplate/add_template.jsp');		
	}

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		var id_s = ids.split('-')[0];  
		var if_s = ids.split('-')[1];  
		var f_abbr = ids.split('-')[2];  
	 
		if(confirm('确定要删除吗?')){  
			
			//处理删除父目录下的子级
			 var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	      
			 var querySql3 = " select file_id FROM BGP_DOC_GMS_FILE  where TEMPLATE_NAME='"+f_abbr+"'  and bsflag='0'    and is_template='"+if_s+"'   ";
		//	var querySql3 = " select file_id   FROM BGP_DOC_GMS_FILE    WHERE PARENT_FILE_ID =      (select g.file_abbr  from bgp_doc_gms_file g            where g.file_id = '"id_s"'  and g.is_template='"+if_s+"'      and g.bsflag = '0')     and bsflag = '0'  and is_template='"+if_s+"'         and project_info_no is null  ";
			var queryRet3 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql3);
			var datas3 = queryRet3.datas;
			if(datas3 != null){	 
			     for (var k = 0; k< queryRet3.datas.length; k++) {    
			    	 var file_ids=datas3[k].file_id; 
			    	  
			 		 var submitStrs = 'JCDP_TABLE_NAME=BGP_DOC_GMS_FILE&JCDP_TABLE_ID='+file_ids +'&bsflag=1';
				     syncRequest('Post',paths,encodeURI(encodeURI(submitStrs)));   
				 
			     } 
			}
		   
			
			var retObj = jcdpCallService("ucmSrv", "deleteTemplate", "templateID="+id_s);
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
		var id_s = ids.split('-')[0];  
		var if_s = ids.split('-')[1];  
		
	    if(id_s.split(",").length > 1){
	    	alert("只能编辑一条记录");
	    	return;
	    }
	    
		popWindow('<%=contextPath%>/doc/foldertemplate/edit_template_info.jsp?id='+id_s+'&if_s='+if_s);

	}
	
	function clearCommonInfo(){
		var qTable = getObj('commonInfoTable');
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
			}
		}

	}
</script>

</html>

