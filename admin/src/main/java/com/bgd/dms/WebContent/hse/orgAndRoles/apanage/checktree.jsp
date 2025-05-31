<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = request.getParameter("orgId");
	if(orgId==null || orgId.equals("")) orgId = user.getOrgSubjectionId();
	
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
var apanage_flag = "";
debugger;
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "select t.org_sub_id,os.org_id,oi.org_abbreviation,t.apanage_flag from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' start with t.org_sub_id = '"+rootMenuId+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var datas = queryOrgRet.datas;
if(datas.length>1){
	rootMenuName = queryOrgRet.datas[1].org_abbreviation; 
	rootMenuId  = queryOrgRet.datas[1].org_sub_id;
	apanage_flag = queryOrgRet.datas[1].apanage_flag;
}else if(datas.length=="1"){
	rootMenuName = queryOrgRet.datas[0].org_abbreviation; 
	rootMenuId  = queryOrgRet.datas[0].org_sub_id; 
	apanage_flag = queryOrgRet.datas[0].apanage_flag;
}

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
	title : "ѡ��",// ��ʾ����Ϊ��
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
	if(apanage_flag=="1"){
		rootNode.attributes.checked = true ;
	}
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
	//	treeNode.on("checkchange",checkParentNode);
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
	debugger;
//	alert(parentNode.id.substring(15));
	if(parentNode.firstChild.text!='loading') return;
		
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select ho.org_sub_id,ho.father_org_sub_id,ho.apanage_flag,os.org_id,oi.org_abbreviation, case when (select father_org_sub_id from bgp_hse_org where org_sub_id='"+parentNode.id+"') in (select org_sub_id from bgp_hse_org where father_org_sub_id='C105') then '1' else '' end is_leaf  from bgp_hse_org ho left join comm_org_subjection os on ho.org_sub_id=os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where ho.father_org_sub_id='"+parentNode.id+"' "
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;

			if(nodes!=null && nodes.length>0){
				for (var i = 0; i < nodes.length; i++) {
					nodes[i].checked = false;
					
					var treeNode = getTreeNode(nodes[i]);
					appendEvent(treeNode);
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
	if(nodeData.is_leaf=="1"){//Ҷ�ӽڵ�
		treeNode = new Ext.tree.TreeNode({
			id : nodeData.org_sub_id,
			text : nodeData.org_abbreviation,// ��ʾ����									
			leaf : true,
			singleClickExpand: false,
			checked : nodeData.checked,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});
	if(nodeData.apanage_flag=="1"){
		treeNode.attributes.checked = true;
	}
//	if(nodeData.father_org_sub_id=="C105080"){
//		treeNode.attributes.checked = "disabled";
//	}
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.org_sub_id,
			text : nodeData.org_abbreviation,// ��ʾ����									
			leaf : false,
			expanded: true,
			singleClickExpand:true,
			checked : nodeData.checked,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
		if(nodeData.apanage_flag=="1"){
			treeNode.attributes.checked = true;
		}
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

	alert("ѡ���Ҷ�ӽڵ㣺" + checkLeafTexts);
	alert("ѡ��ķ�Ҷ�ӽڵ㣺" + checkNonLeafTexts);
}  


function getCheckedNode123() {   
    var nodes = rctTree.getChecked();
    
    var checkIds = ""
    var checkTexts = "";// ���ѡ�е�Ҷ�ӽڵ��text
    
    for (var i = 0; i < nodes.length; i++) {   
        var node = nodes[i];
        checkIds += "," + nodes[i].id;
        checkTexts += "," + nodes[i].text;
    } 
    
    checkIds = checkIds=="" ? "" : checkIds.substr(1);
    checkTexts = checkTexts=="" ? "" : checkTexts.substr(1);
    if(checkIds==""){
    	alert("��ѡ��λ!");
    	return;
    }
    jcdpCallService("HseOperationSrv", "setApanageFlag", "ids="+checkIds+"&rootMenuId="+rootMenuId);
    window.close();
}  

function checkchangeNode(node, checked){
	//node.expand();
	node.attributes.checked = checked;
	// �����ӽڵ��ѡ��״̬
//	node.eachChild(function(child) {   
//		child.ui.toggleCheck(checked);   
//		child.attributes.checked = checked;   
//	});

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
		<td align="left" style="padding-left:400px;padding-top:5px;padding-bottom:5px;">
			<!-- <input type="button" value="�������ѡ�нڵ�" onclick="getCheckedNode('1')" class="iButton2"/>
			<input type="button" value="��ö���ѡ�нڵ�" onclick="getCheckedNode('0')" class="iButton2"/> -->
			<input type="button" value="����" onclick="getCheckedNode123()" class="iButton2"/>
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