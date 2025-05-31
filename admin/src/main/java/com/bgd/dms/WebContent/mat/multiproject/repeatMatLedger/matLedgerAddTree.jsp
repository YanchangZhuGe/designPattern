<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = request.getParameter("orgId");
	if(orgId==null || orgId.equals("")) orgId = user.getCodeAffordOrgID();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 

<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**������������*/
var rootMenuId = "<%=orgId%>";
var rootMenuName = "";
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select oi.org_id,oi.org_abbreviation,os.org_subjection_id FROM comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id WHERE oi.bsflag='0' and oi.org_id='"+rootMenuId+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
rootMenuName = "���ʷ���"; 
rootMenuId += ",C105"; 

var rctTree;
var rightMenu = null;
var selectedNode;

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

var treeCfg = {
	region : 'west',// �趨��ʾ����Ϊ����,ͣ�����������
	split : true,// �����϶���
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
	width : 500,// ��ʼ���
	minSize : 210,// �϶���С���
	maxSize : 300,// �϶������
	collapsible : true,// ��������
	title : "���ʷ���",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
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
				singleClickExpand:false,
				checked:false,
				children : [{// �ӽڵ�
					text : 'loading',// ��ʾ����Ϊloading
					icon : loadingIcon,// ʹ��ͼ��Ϊloading
					leaf : true					
				}]
	});
	var treeLoader = new Ext.tree.TreeLoader();// ָ��һ���յ�TreeLoader
	
	rctTree = new Ext.tree.TreePanel({// ����һ��TreePanel��ʾtree
		id : 'tree',// idΪtree
		region : treeCfg.region,// �趨��ʾ����Ϊ����,ͣ�����������
		split : treeCfg.split,// �����϶���
		bodyStyle:treeCfg.bodyStyle,
		collapseMode : treeCfg.collapseMode,// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
		width : treeCfg.width,// ��ʼ���
		minSize : treeCfg.minSize,// �϶���С���
		maxSize : treeCfg.maxSize,// �϶������
		collapsible : treeCfg.collapsible,// ��������
		title : treeCfg.title,// ��ʾ����Ϊ��
		lines : treeCfg.lines,// ���ֽڵ������
		autoScroll : treeCfg.autoScroll,// �Զ����ֹ�����
		frame : treeCfg.frame,
		border : treeCfg.border==undefined?true:treeCfg.border,
		enableDD:treeCfg.enableDD,
		tbar : treeCfg.tbar,
		loader : treeLoader,// ָ�����������loader����,���ڶ���Ϊ��	
		root : rootNode
	});

	if(jcdpTreeCfg.rightClickEvent)setRightMenu();
	
	rctTree.render(treeDivId); // ��Ⱦ����
	
	appendEvent(rootNode);
	rctTree.getRootNode().toggle();	
});


/**
	���ڵ�������Ӧ�¼�
*/
function appendEvent(treeNode){
	treeNode.on('expand', getSubNodes);// ���嵱ǰ�ڵ�չ��ʱ����getSubNodes,�ٴ��첽��ȡ�ӽڵ�
	
	
	//����Ҽ��˵�
	if(rightMenu!=null){
		treeNode.on("contextmenu",showMenu);	
	}
	
	//���ڵ��ƶ�ʱ�����¼�
	if(jcdpTreeCfg.moveEvent)treeNode.on("move",moveMenu);
	
	if(jcdpTreeCfg.clickEvent) treeNode.on("click",clickNode);
	if(jcdpTreeCfg.dbClickEvent) treeNode.on("dblclick",dbClickNode);

	// ��ѡ���¼�
	if(jcdpTreeCfg.checkchangeEvent){
		treeNode.on("checkchange",checkchangeNode);
		treeNode.on("checkchange",checkParentNode);
	}
}	

/**
����
*/
function clickNode(node){
	selectedNode=node;
}

/**
	��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		var ids = parentNode.id.split(",");
		var id = "";
		if(ids.length>1){
			id=ids[1];
			}
		else{
			id = ids[0];
				}
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select t.*,length(t.coding_code_id) as is_leaf from GMS_MAT_CODING_CODE t where t.parent_code = '"+id+"'"
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
			parentNode.firstChild.remove();// ɾ����ǰ�ڵ��һ�����ӽڵ�(loading�ڵ�)	
		},
		failure : function(){// ʧ��
							}			
	});//eof Ext.Ajax.request
}


/**
	���ݷ�������ѯ����nodeData����ext���ڵ�
*/
function getTreeNode(nodeData){
	var treeNode;
	
	if(nodeData.is_leaf=="8"){//Ҷ�ӽڵ�
		treeNode = new Ext.tree.TreeNode({
			id : nodeData.coding_code_id,
			text : nodeData.code_name,// ��ʾ����									
			leaf : true,								
			singleClickExpand: false,
			checked : nodeData.checked,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.coding_code_id,
			text : nodeData.code_name,// ��ʾ����									
			leaf : false,								
			singleClickExpand:true,
			checked : nodeData.checked,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}
	
	return treeNode;
}

// scope=1��ȡ����ѡ�еĽڵ㣬scope=0��ȡ����ѡ�еĽڵ�
function getCheckedNode(scope) {   
    var nodes = rctTree.getChecked();
    
    var checkLeafIds = "";// ���ѡ�е�Ҷ�ӽڵ��id
    var checkLeafTexts = "";// ���ѡ�е�Ҷ�ӽڵ��text
    
    var checkNonLeafIds = "";// ���ѡ�еķ�Ҷ�ӽڵ��id
    var checkNonLeafTexts = "";// ���ѡ�еķ�Ҷ�ӽڵ��text
    
    for (var i = 0; i < nodes.length; i++) {   
        var node = nodes[i];
        if(scope=="0"){
			var parentNode =  node.parentNode;
			if(parentNode!=null && parentNode.attributes.checked){
            	continue;
			}
        }
        
        if(nodes[i].isLeaf()){
        	checkLeafIds += "," + nodes[i].id.substr(0,14);
        	checkLeafTexts += "," + nodes[i].text;
        }else{
        	checkNonLeafIds += "," + nodes[i].id.substr(0,14);
        	checkNonLeafTexts += "," + nodes[i].text;
        }
    } 
    
    checkLeafIds = checkLeafIds=="" ? "" : checkLeafIds.substr(1);
    checkLeafTexts = checkLeafTexts=="" ? "" : checkLeafTexts.substr(1);

    checkNonLeafIds = checkNonLeafIds=="" ? "" : checkNonLeafIds.substr(1);
    checkNonLeafTexts = checkNonLeafTexts=="" ? "" : checkNonLeafTexts.substr(1);

	var checkAllIds = checkLeafIds +","+ checkNonLeafIds;
	parent.menuFrame.location = "<%=contextPath%>/mat/multiproject/repeatMatLedger/matAddItemList.jsp?codeId="+checkAllIds
}   

function checkchangeNode(node, checked){
	//node.expand();
	node.attributes.checked = checked;
	// �����ӽڵ��ѡ��״̬
	node.eachChild(function(child) {   
		child.ui.toggleCheck(checked);   
		child.attributes.checked = checked;   
	});

}

function checkParentNode(node, checked){
	
	// ���ø��ڵ��ѡ��״̬
	var parentNode = node.parentNode;
	if(parentNode==null)return;
	
	// ȡ�����ڵ����checkchange�¼�����ֹ���´���
	parentNode.removeListener('checkchange',checkchangeNode);
	
	if(!checked){ // δѡ�У����ø��ڵ�Ϊδѡ��
		parentNode.ui.toggleCheck(false);   
		parentNode.attributes.checked = false;
	}else{ // ��ѡ�У���������ֵܽڵ㣬�������ѡ�У����ø��ڵ�Ϊѡ��
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
	// ���ø��ڵ����checkchange�¼�
	parentNode.on("checkchange",checkchangeNode);
}
</script>      

</head>
<body>

<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<input type="button" value="ȷ��" onclick="getCheckedNode('0')" class="iButton2"/>
		</td>
	</tr>
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;">
			</div>
		</td>
	</tr>
</table>



</body>