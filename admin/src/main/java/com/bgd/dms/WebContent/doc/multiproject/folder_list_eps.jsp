<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	//String rootMenuId = "8ad889f13759d014013759d3de520003";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
cruConfig.contextPath = "<%=contextPath%>";

/**公共变量定义*/
var queryRootIdSql = "select f.file_id from bgp_doc_gms_file f where f.bsflag = '0' and f.parent_file_id is null and f.project_info_no is null and f.is_file = '0' and f.is_template is null";
var queryRootRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+queryRootIdSql);
var rootMenuId = queryRootRet.datas[0].file_id;

var querySql = "Select b.file_id,b.file_name,b.file_abbr FROM bgp_doc_gms_file b WHERE b.file_id = '"+rootMenuId+"' and b.bsflag='0' and b.is_file='0' and b.parent_file_id is null and b.ucm_id is null";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].file_name; 

var treeDivId = "folderTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
var default_image_url = "<%=contextPath%>/images/images/tree_15.png";

jcdpTreeCfg.clickEvent=true;
jcdpTreeCfg.moveEvent = true;
var treeCfg = {
	split : true,// 出现拖动条
	border : false,
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : "99%",// 初始宽度
	minSize : "90%",// 拖动最小宽度
	maxSize : "99%",// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "公共目录维护",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true
};

var needReload = "";
var rootNode = "";
Ext.onReady(function() {	
	needReload = rctTree.getRootNode();	
	rootNode = rctTree.getRootNode();
});

var selectedNodeId;
var selectedNodeText;
var myNode;
/**
	设置右键菜单
*/
function setRightMenu()
{
	
}

function beforeMoveMenu(tree,node,oldParent,newParent,index){
	if(oldParent.id!=newParent.id) return false;
	else return true;
}

/**
	移动菜单节点
*/
function moveMenu(tree,node,oldParent,newParent,index){
	  if(newParent.id != oldParent.id){
		    if (!window.confirm("确认要移动["+node.text+"]及其子菜单吗?")) {
				return;
			}
	  }
	  if(index<0){
		    index=0;
		  }
	  var retuObj = jcdpCallService("ucmSrv","moveTreeNodePositionMulti","pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id+"&newParentId="+newParent.id);
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		
	Ext.Ajax.request({
		url : "<%=contextPath%>/rad/asyncQueryList.srq",
		params : {
			currentPage:"1",
			pageSize:"100",
			querySql:"Select file_id,file_name,file_abbr FROM BGP_DOC_GMS_FILE WHERE PARENT_FILE_ID='"+parentNode.id+"' and bsflag='0' and is_file='0' and project_info_no is null ORDER BY order_num"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
				
			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
			parentNode.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
		},
		failure : function(){// 失败
							}			
	});//eof Ext.Ajax.request
}


/**
	根据服务器查询到的nodeData构造ext树节点
*/
function getTreeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.file_id,
			text : nodeData.file_abbr+"-"+nodeData.file_name,// 显示内容	
			icon : default_image_url,
			leaf : false,								
			singleClickExpand:false,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	//叶子节点
	if(nodeData.is_leaf=="1"){
		treeNode.leaf = true;
		treeNode.singleClickExpand = false;
	}
	
	return treeNode;
}

function clickNode(selectedNode){
	myNode = selectedNode;
	needReload=selectedNode;
	selectedNodeId = selectedNode.id;
	selectedNodeText = selectedNode.text;
	var fileAbbr = "";
	var numberFormat = "";
	if(selectedNode.id != undefined && selectedNode.id != ""){
		var querySql = "Select b.file_abbr,n.file_number_name FROM bgp_doc_gms_file b left outer join bgp_doc_file_number n on b.file_number_format = n.bgp_doc_file_number_id  WHERE b.file_id = '"+selectedNode.id+"' and b.bsflag='0' and b.is_file='0' and b.ucm_id is null";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas.length != 0){
			fileAbbr = queryOrgRet.datas[0].file_abbr; 
			numberFormat = queryOrgRet.datas[0].file_number_name; 
		}
	}
	if(selectedNode.text.split("-").length != 2){
		document.getElementById("folder_name").value=selectedNode.text;
	}else{
		document.getElementById("folder_name").value=selectedNode.text.split("-")[1];
	}
	
	document.getElementById("folder_abbr").value=fileAbbr;
	document.getElementById("number_format").value=numberFormat;
    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+selectedNode.id;
}
/**
	新增目录
*/
function toAdd(){
	if(selectedNodeId == undefined){
		selectedNodeId = rootMenuId;
	}
	var addParentText = needReload.text;
	var addParentTextEncode = encodeURI(encodeURI(addParentText));
	//新增刷新当前目录即可  	
	popWindow('<%=contextPath %>/doc/multiproject/add_folder_eps.jsp?pagerAction=edit2Add&id='+selectedNodeId+'&parentfoldertext='+addParentTextEncode); 

}
/**
	编辑目录
*/
function toModify(){
	if(selectedNodeId == undefined){
		//selectedNodeId = rootMenuId;
		alert("请选中一条记录");
		return false;
	}
 	if(selectedNodeId == rootMenuId){
 		alert("根节点不能编辑!");
 		return false;
 	}
	var modifyParentText = needReload.parentNode.text;
	var modifyParentTextEncode = encodeURI(encodeURI(modifyParentText));
	popWindow('<%=contextPath %>/doc/multiproject/edit_folder_eps.jsp?pagerAction=edit2Edit&id='+selectedNodeId+'&modifyfoldertext='+modifyParentTextEncode); 
}
/**
	删除目录
*/
function toDelete(){
	
	if(selectedNodeId == undefined){
		alert("请选中一条记录");
		return false;
	}
	
	if (selectedNodeId == rootMenuId) {
		alert("根节点不能被删除!");
		return;
	}	
	//如果目录中有文档则提示不能删除
	var querySql = "select bf.file_id from bgp_doc_gms_file bf where bf.is_file = '1' and bf.bsflag = '0' and bf.parent_file_id='"+selectedNodeId+"'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
	if(queryRet.datas != ""){
		alert("此目录不为空，不能删除");
		return;
	}
	
	if (!window.confirm("确认要删除["+selectedNodeText+"]及其子菜单吗?")) {
			return;
	}
	
	var sql = "update BGP_DOC_GMS_FILE set bsflag='1' where file_id ='{id}'";//selectedNodeId替换{id}
	var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
	var params = "sql="+sql;
	params += "&ids="+selectedNodeId;
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
	}else{		
		myNode.remove();
		selectedNodeId = undefined;
	}	
}

//导入结构模板...
function importTemplate(){
	popWindow('<%=contextPath%>/doc/foldertemplate/folder_template_list.jsp?action=selecttemplate&rootId='+rootMenuId,'1024:768');
}

//重新加载选中节点
function reloadNeed(){

    if(needReload == ""){
    	alert("请选中一个节点");//needReload = "根节点"; 刷新加载根节点
    	return false;
    }
	needReload.reload();
	
}

//重新加载根节点
function reloadRootNode(){
	rootNode.reload();	
}

//重新加载选中节点的父节点
function reloadParentNode(){

	needReload.parentNode.reload();
	selectedNodeId = undefined;
}

function selectFormat(){
	popWindow('<%=contextPath%>/doc/filenumber/file_number_list.jsp?action=selectnumberformat&folderid='+selectedNodeId,'1024:768');
	
}
</script>      

<title>无标题文档</title>
</head>

<body style="background:#fff">
      	<div id="list_table">
      	
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					  	<td width="90%">&nbsp;</td>					    
			    			<auth:ListButton functionId="F_DOC_013" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    			<auth:ListButton functionId="F_DOC_014" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			    			<auth:ListButton functionId="F_DOC_015" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>	
					  </tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		
			<div id="table_box">
				<div id="folderTree" style="width:100%;height:500;overflow:auto;z-index: 0"></div>
			</div>

			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">

				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">目录名称：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="folder_name" name="folder_name" class="input_width" readonly="readonly"/></td>			
					    <td class="inquire_item6">目录缩写：</td>
					    <td class="inquire_form6" id="item0_0"><input type="text" id="folder_abbr" name="folder_abbr" class="input_width" readonly="readonly"/></td>		  
					    <td class="inquire_item6">编号规则：</td>
					    <td class="inquire_form6" id="item0_0">
					    <input type="text" id="number_format" name="number_format" class="input_width" readonly="readonly"/>
					    <img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectFormat()" />	
					    </td>		  
					  </tr>				    
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
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
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
</script>

</html>

