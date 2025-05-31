<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String extPath = contextPath + "/js/extjs";
	String project_info_no = user.getProjectInfoNo();
	System.out.println("The project_info_no is:"+project_info_no);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=extPath %>/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<title>无标题文档</title>
<script language="javascript" type="text/javascript"> 
var extPath = "<%=extPath%>";
cruConfig.contextPath = "<%=contextPath%>";

/**公共变量定义*/

var project_info_no = "<%=project_info_no%>";
var querySql = "Select b.file_id,b.file_name FROM bgp_doc_gms_file b WHERE b.project_info_no = '"+project_info_no+"' and b.bsflag='0' and b.is_file='0' and b.parent_file_id is null and b.ucm_id is null";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].file_name; 
var rootMenuId = queryOrgRet.datas[0].file_id; 

var rctTree;
var rightMenu = null;
var selectedNode;


var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
var default_image_url = "<%=contextPath%>/images/images/tree_15.png";

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	border : false,
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : "99%",// 初始宽度
	minSize : "90%",// 拖动最小宽度
	maxSize : "99%",// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "选择目录",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};
var jcdpTreeCfg={
	moveNodeAction:'/tcg/moveTreeNodePosition.srq',
	clickEvent:true,
	dbClickEvent:false,
	moveEvent:false,
	rightClickEvent:false,
	checkchangeEvent:true
}

Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = blank_image_url;
	var rootNode = new Ext.tree.AsyncTreeNode({
				id:rootMenuId,
				text:rootMenuName,
				icon:default_image_url,
				singleClickExpand:false,
				checked:false,
				children : [{// 子节点
					text : 'loading',// 显示文字为loading
					icon : loadingIcon,// 使用图标为loading
					leaf : true					
				}]
	});
	var treeLoader = new Ext.tree.TreeLoader();// 指定一个空的TreeLoader
	
	rctTree = new Ext.tree.TreePanel({// 声明一个TreePanel显示tree
		id : 'tree',// id为tree
		region : treeCfg.region,// 设定显示区域为东边,停靠在容器左边
		split : treeCfg.split,// 出现拖动条
		bodyStyle:treeCfg.bodyStyle,
		collapseMode : treeCfg.collapseMode,// 拖动条显示类型为mini,可出现拖动条中间的尖头
		width : treeCfg.width,// 初始宽度
		minSize : treeCfg.minSize,// 拖动最小宽度
		maxSize : treeCfg.maxSize,// 拖动最大宽度
		collapsible : treeCfg.collapsible,// 允许隐藏
		title : treeCfg.title,// 显示标题为树
		lines : treeCfg.lines,// 出现节点间虚线
		autoScroll : treeCfg.autoScroll,// 自动出现滚动条
		frame : treeCfg.frame,
		border : treeCfg.border==undefined?true:treeCfg.border,
		enableDD:treeCfg.enableDD,
		tbar : treeCfg.tbar,
		loader : treeLoader,// 指定数据载入的loader对象,现在定义为空	
		root : rootNode
	});

	if(jcdpTreeCfg.rightClickEvent)setRightMenu();
	
	rctTree.render(treeDivId); // 渲染到层
	
	appendEvent(rootNode);
	rctTree.getRootNode().toggle();	
});


/**
	给节点增加响应事件
*/
function appendEvent(treeNode){



	treeNode.on('expand', getSubNodes);// 定义当前节点展开时调用getSubNodes,再次异步读取子节点
	
	
	//添加右键菜单
	if(rightMenu!=null){
		treeNode.on("contextmenu",showMenu);	
	}
	
	//当节点移动时触发事件
	if(jcdpTreeCfg.moveEvent)treeNode.on("move",moveMenu);
	
	if(jcdpTreeCfg.clickEvent) treeNode.on("click",clickNode);
	if(jcdpTreeCfg.dbClickEvent) treeNode.on("dblclick",dbClickNode);

	// 复选框事件
	if(jcdpTreeCfg.checkchangeEvent){
		treeNode.on("checkchange",checkchangeNode);
		treeNode.on("checkchange",checkParentNode);
	}
	
	
}	

/**
单击
*/
function clickNode(node){

	selectedNode=node;
}

function getNodeInfo(){
	var nodeID = selectedNode.id;
	var nodeText = selectedNode.text;
}

/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"Select f.file_id,f.file_name FROM BGP_DOC_GMS_FILE f join bgp_doc_gms_file b1 on f.parent_file_id = b1.file_abbr where b1.file_id = '"+parentNode.id+"' and f.bsflag='0' and f.is_file='0' and f.project_info_no = '"+project_info_no+"' and f.is_template is null ORDER BY f.order_num"	
			//querySql:"Select f.file_id,f.file_name,m.folder_id,m.folder_name,m.module_id FROM BGP_DOC_GMS_FILE f left join bgp_doc_folder_module m on f.file_id=m.folder_id where f.PARENT_FILE_ID='"+parentNode.id+"' and f.bsflag='0' and f.is_file='0' ORDER BY order_num desc"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;

			if(nodes!=null && nodes.length>0){
				for (var i = 0; i < nodes.length; i++) {
					nodes[i].checked = parentNode.attributes.checked;
					
					var treeNode = getTreeNode(nodes[i]);
					appendEvent(treeNode);
					//treeNode.on("checkchange",checkchangeNode);
					parentNode.appendChild(treeNode);
					
				}
			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
		},
		failure : function(){// 失败
							}			
	});//eof Ext.Ajax.request
}


/**
	根据服务器查询到的nodeData构造ext树节点
*/
function getTreeNode(nodeData){
	var treeNode;
	var module_id;

	if(clickNodeId != undefined){
		if(nodeData.file_id != undefined){
			module_id = getModuleByFolder(nodeData.file_id);
		}	
		if(module_id == clickNodeId){
			nodeData.checked = true;
		}else{
			nodeData.checked = false;
		}
	}


	
	
// 	if(nodeData.module_id == clickNodeId){
// 		nodeData.checked = true;
// 	}else{
// 		nodeData.checked = false;
// 	}

	if(nodeData.is_leaf=="1"){//叶子节点
		treeNode = new Ext.tree.TreeNode({
			id : nodeData.file_id,
			text : nodeData.file_name,// 显示内容	
			icon : default_image_url,
			leaf : true,								
			singleClickExpand: false,
			checked : nodeData.checked,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.file_id,
			text : nodeData.file_name,// 显示内容		
			icon : default_image_url,
			leaf : true,								
			singleClickExpand: false,
			checked : nodeData.checked,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}
	
	return treeNode;
}


 function getCheckedNodeId() {   
    var nodes = rctTree.getChecked();
    var checkIds = "";// 存放选中id
    for (var i = 0; i < nodes.length; i++) {   
    	var node_id = nodes[i].id;
//     	var querySql = "Select b.file_id,b.file_name FROM bgp_doc_gms_file b WHERE b.parent_file_id = '"+node_id+"' and b.bsflag='0' and b.is_file='0' and b.ucm_id is null";
//     	var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
//     	var dataResult = queryOrgRet.datas;
//     	if(dataResult != undefined){
//      		for(var j=0;j<dataResult.length;j++){
//      				checkIds += ","+dataResult[j].file_id;    			
//      		}
//     	}    	
    	checkIds += "," + nodes[i].id;
    	
    } 
    return checkIds.substr(1);
}   
 
 
 function getCheckedNodeText() {   
	var nodes = rctTree.getChecked();
	var checkTexts = "";// 存放选中text
	for (var i = 0; i < nodes.length; i++) {   
	    checkTexts += "," + nodes[i].text;	    	
	} 
	return checkTexts.substr(1);
}   


// scope=1获取所有选中的节点，scope=0获取顶级选中的节点
function getCheckedNode(scope) {   
    var nodes = rctTree.getChecked();
    
    var checkLeafIds = "";// 存放选中的叶子节点的id
    var checkLeafTexts = "";// 存放选中的叶子节点的text
    
    var checkNonLeafIds = "";// 存放选中的非叶子节点的id
    var checkNonLeafTexts = "";// 存放选中的非叶子节点的text
    
    for (var i = 0; i < nodes.length; i++) {   
        var node = nodes[i];
        if(scope=="0"){
			var parentNode =  node.parentNode;
			if(parentNode!=null && parentNode.attributes.checked){
            	continue;
			}
        }
        
        if(nodes[i].isLeaf()){
        	checkLeafIds += "," + nodes[i].id;
        	checkLeafTexts += "," + nodes[i].text;
        }else{
        	checkNonLeafIds += "," + nodes[i].id;
        	checkNonLeafTexts += "," + nodes[i].text;
        }
    } 
    
    checkLeafIds = checkLeafIds=="" ? "" : checkLeafIds.substr(1);
    checkLeafTexts = checkLeafTexts=="" ? "" : checkLeafTexts.substr(1);

    checkNonLeafIds = checkNonLeafIds=="" ? "" : checkNonLeafIds.substr(1);
    checkNonLeafTexts = checkNonLeafTexts=="" ? "" : checkNonLeafTexts.substr(1);

	alert("选择的叶子节点id：" + checkLeafIds);
	alert("选择的非叶子节点id：" + checkNonLeafIds);
    
    alert("选择的叶子节点text：" + checkLeafTexts);
	alert("选择的非叶子节点text：" + checkNonLeafTexts);
}   

function checkchangeNode(node, checked){
	//node.expand();
	node.attributes.checked = checked;
	// 设置子节点的选中状态
	node.eachChild(function(child) {   
		child.ui.toggleCheck(checked);   
		child.attributes.checked = checked;   
	});

}

function checkParentNode(node, checked){
	
	// 设置父节点的选中状态
	var parentNode = node.parentNode;
	if(parentNode==null)return;
	
	// 取消父节点监听checkchange事件，防止向下传递
	parentNode.removeListener('checkchange',checkchangeNode);
	
	if(!checked){ // 未选中，设置父节点为未选中
		parentNode.ui.toggleCheck(false);   
		parentNode.attributes.checked = false;
	}else{ // 已选中，检查所有兄弟节点，如果都是选中，设置父节点为选中
		var siblings = parentNode.childNodes;
		var parentChecked = true;
		for(var i=0;i<siblings.length;i++){
			if(!siblings[i].attributes.checked){
				parentChecked = false;
				break;
			}
		}
		if(parentChecked){
			parentNode.ui.toggleCheck(true);   
			parentNode.attributes.checked=true;
		}
	}
	// 设置父节点监听checkchange事件
	parentNode.on("checkchange",checkchangeNode);
}
</script>      
</head>

<body style="background:#fff">
      	<div id="list_table">

			<div id="menuTree" style="width:100%;height:100%;overflow:auto;">
		
			</div>

			
			<div id="tab_box" class="tab_box">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6">
							<auth:ListButton functionId="" css="tj_btn" event="onclick='getModuleFolderInfo()'"></auth:ListButton>
						</td>
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

function getModuleByFolder(folderId){
		var moduleID;
		var querySql = "Select * FROM bgp_doc_folder_module b WHERE b.folder_id = '"+folderId+"' and b.bsflag='0'";
		if(clickNodeId != undefined){
			querySql += " and b.module_id=+'"+clickNodeId+"'";
		}
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas.length != 0){
			moduleID = queryOrgRet.datas[0].module_id;
		}
		return moduleID;
}

	
var cttt = top.frames['list'];
var clickNodeId = cttt.frames[0].selectedModuleId.id;
	
function getModuleFolderInfo(){
	var ctt = top.frames['list'];	
	if(clickNodeId != undefined){
		var querySql = "Select * FROM bgp_doc_folder_module b WHERE b.module_id = '"+clickNodeId+"' and b.bsflag='0'";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas.length != 0){
			//执行修改操作
			if(ctt.frames.length != 0){
				var module_id = ctt.frames[0].getNodeId();
				var module_text = ctt.frames[0].getNodeText();
	 			if(module_id != undefined){
	 				var folder_ids = ctt.frames[1].getCheckedNodeId().split(",");		
	 				var folder_texts = ctt.frames[1].getCheckedNodeText().split(",");
	 				if(folder_ids == ""){//
	 					if(confirm("确定取消文件夹?")){
	 						var retObj = jcdpCallService("ucmSrv", "deleteModuleAndFolder", "moduleId="+module_id);
	 						var operation_flag = retObj.operationflag;
	 		 				if(operation_flag == "success"){
	 		 					alert("操作成功");
	 		 				}else{
	 		 					alert("操作失败");
	 		 				} 
	 					}else{
							return;
	 					}
	 					
	 				}else{//不是空的话，先删除之前的模块和目录关系，再建立新的模块和目录关系
	 					var retObj = jcdpCallService("ucmSrv", "setNewMenuFolder", "moduleId="+module_id+"&folderids="+folder_ids+"&moduleText="+module_text+"&folderTexts="+folder_texts);
		 				var operation_flag = retObj.operationflag;
		 				if(operation_flag == "success"){
		 					alert("操作成功");
		 				}else{
		 					alert("操作失败");
		 				} 
	 				}
	 			}

			}
		}else{
			//执行增加操作
			if(ctt.frames.length != 0){
				var module_id = ctt.frames[0].getNodeId();
				var module_text = ctt.frames[0].getNodeText();
				if(module_id != undefined){
					var folder_ids = ctt.frames[1].getCheckedNodeId().split(",");
					var folder_texts = ctt.frames[1].getCheckedNodeText().split(",");
		 			if(folder_ids != ""){
		 				var retObj = jcdpCallService("ucmSrv", "setMenuFolder", "moduleId="+module_id+"&folderids="+folder_ids+"&moduleText="+module_text+"&folderTexts="+folder_texts);
		 				var operation_flag = retObj.operationflag;
		 				if(operation_flag == "success"){
		 					alert("操作成功");
		 				}else{
		 					alert("操作失败");
		 				} 
		 			}else{
		 				alert("请选择目录");
		 			}

				}else{
					alert("请选择一个模块");
					return;
				}

			}
		}
	}


}

</script>

</html>

