<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String extPath = contextPath + "/js/extjs";
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

cruConfig.contextPath = "<%=contextPath%>";
var querySql = "select t.risk_type_id,t.risk_type_name from bgp_risk_type t where t.bsflag = '0' and t.parent_id is null";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuId = queryOrgRet.datas[0].risk_type_id;
var rootMenuName = queryOrgRet.datas[0].risk_type_name; 

var treeDivId = "folderTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
var default_image_url = "<%=contextPath%>/images/images/tree_15.png";

jcdpTreeCfg.clickEvent=true;
jcdpTreeCfg.moveEvent = true;
jcdpTreeCfg.rightClickEvent = false;

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

var myNode;
/**
	设置右键菜单
*/
function setRightMenu()
{
	
}

/**
	移动菜单节点
*/
function moveMenu(tree,node,oldParent,newParent,index){
  if(index<0){
    index=0;
  }
  var retuObj = jcdpCallService("riskSrv", "moveTreeNodePosition","pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id);
}

function beforeMoveMenu(tree,node,oldParent,newParent,index){

	if(oldParent.id!=newParent.id) return false;
	else return true;
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
			querySql:"Select * FROM bgp_risk_type WHERE PARENT_ID='"+parentNode.id+"' and bsflag='0' ORDER BY order_num"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				appendEvent(treeNode);
				treeNode.on("beforemove",beforeMoveMenu);
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
			id : nodeData.risk_type_id,
			text : nodeData.risk_type_name,// 显示内容	
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
var clickedNode;

function clickNode(selectedNode){
	clickedNode = selectedNode;
	myNode = selectedNode;
	var riskTypeId = "";
	var riskTypeName = "";
	var riskTypeDesc = "";
	var userName = "";
	var createDate = "";
	if(selectedNode.id != undefined && selectedNode.id != ""){
		var querySql = "Select b.risk_type_id,n.user_name,b.risk_type_name,b.risk_type_desc,b.create_date FROM bgp_risk_type b left outer join p_auth_user n on b.creator_id = n.user_id  WHERE b.risk_type_id = '"+selectedNode.id+"' and b.bsflag='0'";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas.length != 0){
			riskTypeId = queryOrgRet.datas[0].risk_type_id; 
			riskTypeName = queryOrgRet.datas[0].risk_type_name; 
			riskTypeDesc = queryOrgRet.datas[0].risk_type_desc; 
			userName = queryOrgRet.datas[0].user_name; 
			createDate = queryOrgRet.datas[0].create_date; 
		}
	}
	
	document.getElementById("risk_type_name").value=riskTypeName;
	document.getElementById("risk_type_desc").value=riskTypeDesc;
	document.getElementById("user_name").value=userName;
	document.getElementById("create_date").value=createDate;
	document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+selectedNode.id;
}

/**
	新增目录
*/
function toAdd(){
	
	if(clickedNode == undefined){
		//selectedNode.id = rootMenuId;
		needReload = rootNode;
		popWindow('<%=contextPath %>/risk/setting/riskTypeMng/risk_type_edit.upmd?pagerAction=edit2Add&id='+rootMenuId); 
	}else{
		needReload = clickedNode;
		popWindow('<%=contextPath %>/risk/setting/riskTypeMng/risk_type_edit.upmd?pagerAction=edit2Add&id='+clickedNode.id); 		
	}
	//新增刷新当前目录即可  	

}
/**
	编辑目录
*/
function toModify(){
	needReload = clickedNode.parentNode;
	if(clickedNode.id == undefined){
		//selectedNodeId = rootMenuId;
		alert("请选中一条记录");
		return false;
	}
	popWindow('<%=contextPath %>/risk/setting/riskTypeMng/risk_type_edit.upmd?pagerAction=edit2Edit&id='+clickedNode.id); 
}
/**
	删除目录
*/
function toDelete(){
	
	if(clickedNode.id == undefined){
		alert("请选中一条记录");
		return false;
	}
	
	if (clickedNode.id == rootMenuId) {
		alert("根节点不能被删除!");
		return;
	}	
	if (!window.confirm("确认要删除["+clickedNode.text+"]及其子菜单吗?")) {
		return;
	}
	
	var sql = "update bgp_risk_type set bsflag='1' where risk_type_id ='{id}'";//selectedNodeId替换{id}
	var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
	var params = "sql="+sql;
	params += "&ids="+clickedNode.id;
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
	}else{		
		myNode.remove();
		clearFolderInfo();
		clickedNode = "";
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
					    <td class="inquire_item8">分类名称：</td>
					    <td class="inquire_form8" id="item0_1"><input type="text" id="risk_type_name" name="risk_type_name" class="input_width" readonly="readonly"/></td>			
					    <td class="inquire_item8">分类描述：</td>
					    <td class="inquire_form8" id="item0_0"><input type="text" id="risk_type_desc" name="risk_type_desc" class="input_width" readonly="readonly"/></td>		  	  
					  </tr>		
					  <tr>
					    <td class="inquire_item8">创建人：</td>
					    <td class="inquire_form8" id="item1_0"><input type="text" id="user_name" name="user_name" class="input_width" readonly="readonly"/></td>		  	
					    <td class="inquire_item8">创建时间：</td>
					    <td class="inquire_form8" id="item1_1"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/></td>		  
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

