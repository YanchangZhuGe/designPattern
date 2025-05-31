<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String extPath = contextPath + "/js/extjs";
	String rootMenuId = "";
	if(request.getParameter("templateID")!=""&&request.getParameter("templateID")!=null){
		rootMenuId = request.getParameter("templateID");
	}
	String is_template = "";
	if(request.getParameter("if_s")!=""&&request.getParameter("if_s")!=null){
		is_template = request.getParameter("if_s");
	}
	
	
	System.out.println("The rootMenuId is:"+rootMenuId);
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

/**公共变量定义*/
var rootMenuId = "<%=rootMenuId%>";

cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select b.file_name,b.file_abbr FROM bgp_doc_gms_file b WHERE b.file_id = '"+rootMenuId+"' and b.bsflag='0' and b.parent_file_id is null  ";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].file_abbr+"-"+queryOrgRet.datas[0].file_name; 
var rootFileAbbr = queryOrgRet.datas[0].file_abbr;

var treeDivId = "folderTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
var default_image_url = "<%=contextPath%>/images/images/tree_15.png";

jcdpTreeCfg.clickEvent=true;
var treeCfg = {
	split : true,// 出现拖动条
	border : false,
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : "99%",// 初始宽度
	minSize : "90%",// 拖动最小宽度
	maxSize : "99%",// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "文档目录",// 显示标题为树
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
	  var retuObj = jcdpCallService("ucmSrv","moveTreeNodePositionTemplate","pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id+"&newParentId="+newParent.id);
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
			querySql:"Select file_id,file_name,file_abbr FROM BGP_DOC_GMS_FILE WHERE PARENT_FILE_ID= (select g.file_abbr from bgp_doc_gms_file g where g.file_id ='"+parentNode.id+"' and g.bsflag='0'  ) and bsflag='0'   and template_name = (select template_name from bgp_doc_gms_file g where g.file_id = '"+parentNode.id+"' and g.bsflag = '0' ) and project_info_no is null ORDER BY order_num"

			//querySql:"Select * FROM BGP_DOC_GMS_FILE WHERE PARENT_FILE_ID ='"+parentNode.id+"' and bsflag='0' and is_template='1' ORDER BY order_num desc"

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

var fileAbbr = "";

function clickNode(selectedNode){
	myNode = selectedNode;
	needReload=selectedNode;
	selectedNodeId = selectedNode.id;
	selectedNodeText = selectedNode.text;	
	var numberFormat = "";
	if(selectedNode.id != undefined && selectedNode.id != ""){
		var querySql = "Select b.file_abbr,n.file_number_name FROM bgp_doc_gms_file b left outer join bgp_doc_file_number n on b.file_number_format = n.bgp_doc_file_number_id  WHERE b.file_id = '"+selectedNode.id+"' and b.bsflag='0' and b.is_template='<%=is_template%>'";
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
	var addParentText = needReload.text;
 
	var addParentTextEncode = encodeURI(encodeURI(addParentText));   
	if(selectedNodeId == undefined){
		//selectedNodeId = rootMenuId; 
		popWindow('<%=contextPath %>/doc/foldertemplate/template_add_folder.jsp?pagerAction=edit2Add&id='+rootFileAbbr+'&parentfoldertext='+addParentTextEncode+'&templatename='+rootFileAbbr+'&is_template=<%=is_template%>'+'&selectedNodeId='+selectedNodeId+'&pf_id='+fileAbbr); 
	}else{ 
		popWindow('<%=contextPath %>/doc/foldertemplate/template_add_folder.jsp?pagerAction=edit2Add&id='+fileAbbr+'&parentfoldertext='+addParentTextEncode+'&templatename='+rootFileAbbr+'&is_template=<%=is_template%>'+'&selectedNodeId='+selectedNodeId+'&pf_id='+fileAbbr); 
	} 	
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
 	var modifyParentText = encodeURI(encodeURI(needReload.parentNode.text));  
	popWindow('<%=contextPath %>/doc/foldertemplate/template_edit_folder.jsp?pagerAction=edit2Edit&id='+selectedNodeId+'&modifyfoldertext='+modifyParentText+'&is_template=<%=is_template%>'); 
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
	
	var querySqlModule = "select t.module_id from bgp_doc_folder_module t where t.bsflag = '0' and t.folder_id ='"+selectedNodeId+"'";
	var queryRetModule = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySqlModule);
	if(queryRet.datas != ""){
		alert("此目录下有文档，无法删除");
		return;
	}
	
	if(queryRetModule.datas != ""){
		alert("此目录已被分配给模块使用，不能删除");
		return;
	}
	
	if (!window.confirm("确认要删除["+selectedNodeText+"]及其子菜单吗?")) {
			return;
	}
	//处理删除父目录下的子级
	 var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	      
	var querySql3 = " select file_id  from BGP_DOC_GMS_FILE    where  parent_file_id='"+fileAbbr+"' and  bsflag='0' and  is_template='<%=is_template%>'  ";
	var queryRet3 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql3);
	var datas3 = queryRet3.datas;
	if(datas3 != null){	 
	     for (var k = 0; k< queryRet3.datas.length; k++) {    
	    	 var file_ids=datas3[k].file_id; 
	 		 var submitStrs = 'JCDP_TABLE_NAME=BGP_DOC_GMS_FILE&JCDP_TABLE_ID='+file_ids +'&bsflag=1';
		     syncRequest('Post',paths,encodeURI(encodeURI(submitStrs)));   
		 
	     } 
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
		clearFolderInfo();
		selectedNodeId = undefined;
	}	
}



//重新加载选中节点
function reloadNeed(){
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

//清空
function clearFolderInfo(){
	var qTable = getObj('folderInfoTable');
	for (var i=0;i<qTable.all.length; i++) {
		var obj = qTable.all[i];
		if(obj.name==undefined || obj.name=='') continue;
		
		if (obj.tagName == "INPUT") {
			if(obj.type == "text") 	obj.value = "";		
		}
	}
}

function selectFormat(){
	popWindow('<%=contextPath%>/doc/filenumber/file_number_list.jsp?action=selectformat&folderid='+selectedNodeId,'1024:768');
	
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
						    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>					    
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
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="folderInfoTable" class="tab_line_height">
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

