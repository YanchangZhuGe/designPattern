<%@ page language="java" pageEncoding="GBK"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" >
<title></title>
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css" media="screen" />
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**������������*/
var rootMenuId = "1,C6000000000001,C105,C6000000000001,0200100005000000002";
var rootMenuName = "������������̽���޹�˾";

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

jcdpTreeCfg.clickEvent=true;

var treeCfg = {
	region : 'west',// �趨��ʾ����Ϊ����,ͣ�����������
	split : true,// �����϶���
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
	//width : 300,// ��ʼ���
	minSize : 210,// �϶���С���
	maxSize : 300,// �϶������
	collapsible : true,// ��������
	title : "��֯������",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true	
};

function clickNode(node){
	editNode(node);
}

/**
	�����Ҽ��˵�
*/
function setRightMenu()
{
	var menuItems = [
		{
			text:"��������",
			handler:function(){
				addNode(selectedNode);
			}
		}
		,"-"
		,{
			text:"��������",
			handler:function(){
				addTeam(selectedNode);
			}
		}
		,"-"
		,{
			text:"�༭",
			handler:function(){
				editNode(selectedNode);
			}
		}
		,"-"
		,{
			text:"ɾ��",
			handler:function(){
				deleteNode(selectedNode);
			}
		}
	];
	
	rightMenu = new Ext.menu.Menu({
		items:menuItems
	});
}

/**
ɾ���˵�
*/
function deleteNode(selectedNode)
{
	var info = selectedNode.id.split(",");
	if (selectedNode.id == null) {
		alert("����ѡ��һ���ڵ�!");
		return;
	}
	
	if (selectedNode.id == rootMenuId) {
		alert("���ڵ㲻�ܱ�ɾ��!");
		return;
	}	
	
	if (!window.confirm("ȷ��Ҫɾ��["+selectedNode.text+"]�����¼��ڵ���?")) {
			return;
	}
	
	
	/*var submitStr = "org_id="+selectedNode.id;
	var ret = syncRequest('post',"<%=contextPath%>/ibp/auth/deleteOrg.srq",submitStr);
	if(ret.returnCode!='0'){
		alert(ret.returnMsg);
		return;
	}*/
	var sql = "update comm_org_information set bsflag='1' where org_id ='{id}';"
		+ "update comm_org_subjection set bsflag='1' where org_id ='{id}';"
	var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
	var params = "sql="+sql;
	params += "&ids="+info[1];
	
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
	}else{
	
		var selectedParentNode = selectedNode.parentNode;
	
		selectedNode.remove();
	
		// ���û�к��ӣ�����ͼ����ʽ
		if(!selectedParentNode.firstChild){
			selectedParentNode.ui.addClass("x-tree-node-collapsed");
		}
	}
}

var needReload;
/**
	�����˵�
*/
function addNode(selectedNode)
{

	if (selectedNode.id == null) {
		alert("����ѡ��һ���ڵ�!");
		return;
	}
	needReload=selectedNode;
	parent.menuFrame.location.href = "orgA7.upmd?pagerAction=edit2Add&lineRange=2&noCloseButton=true&parentId="+selectedNode.id;	
}
/**
��������
*/
function addTeam(selectedNode)
{

	if (selectedNode.id == null) {
		alert("����ѡ��һ���ڵ�!");
		return;
	}
	needReload=selectedNode;
	parent.menuFrame.location.href = "teamA7.upmd?pagerAction=edit2Add&lineRange=2&noCloseButton=true&parentId="+selectedNode.id;	
}

/**
	�޸Ĳ˵�
*/
function editNode(selectedNode)
{
	var info = selectedNode.id.split(",");
	if (selectedNode.id == null) {
		alert("����ѡ��һ���ڵ�!");
		return;
	}
	needReload=selectedNode;
	var orgLevel=info[4];
	if(orgLevel=='0200100005000000008'){
		parent.menuFrame.location.href = "teamA7.upmd?pagerAction=edit2Edit&lineRange=2&noCloseButton=true&id="+info[1]+"&parentId="+((selectedNode.id!=rootMenuId)?(selectedNode.parentNode.id):'0');		
	}else{
		parent.menuFrame.location.href = "orgA7.upmd?pagerAction=edit2Edit&lineRange=2&noCloseButton=true&id="+info[1]+"&parentId="+((selectedNode.id!=rootMenuId)?(selectedNode.parentNode.id):'0');
	}

}

/**
	�ƶ��ڵ�
*/
function moveMenu(tree,node,oldParent,newParent,index){
	/*var actionUrl = "<%=contextPath%>"+jcdpTreeCfg.moveNodeAction;
	var submitStr = "tableName=p_auth_org&pkName=org_id&fkName=parent_id&orderName=order_num&leafFlagName=is_leaf";
	submitStr += "&pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id+"&newParentId="+newParent.id;
	var ret = syncRequest('post',actionUrl,submitStr);
	if(ret.returnCode!='0'){
		alert(ret.returnMsg);
		return;
	}*/
}


/**
	��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	var info = parentNode.id.split(',');
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			//,case (select count(os3.org_id) from comm_org_subjection os3 where os3.father_org_id=os.org_subjection_id and os3.bsflag='0') when 0 then '1' else '0' end as is_leaf
			querySql:"Select (case os.code_afford_org_id when os.org_id then '1' else '0' end) as afford_if, oi.org_abbreviation,os.org_subjection_id,oi.org_id,os.code_afford_org_id,oi.org_level FROM comm_org_information oi,comm_org_subjection os WHERE oi.org_id=os.org_id and oi.bsflag='0' and os.bsflag='0' and os.father_org_id='"+info[2]+"' ORDER  BY coding_show_id"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			addSubNodes(parentNode,nodes);
		},
		failure : function(){// ʧ��
							}			
	});//eof Ext.Ajax.request
}


function addSubNodes(parentNode,nodes){

	if(nodes.length>0){
		var info = parentNode.id.split(',');
	
		var parentNode1;
		var parentNode2;
		
		if(info[0]=='1'){//
			parentNode1 = new Ext.tree.AsyncTreeNode({
				id : 'jiguan'+info[1],
				text : '���ز���',// ��ʾ����									
				leaf : false,								
				singleClickExpand:true,
				children: [{// ���loading�ӽڵ�
					text : 'loading',
					icon : loadingIcon,
					leaf : false
				}]
			});	
			parentNode2 = new Ext.tree.AsyncTreeNode({
				id : 'zhishu'+info[1],
				text : 'ֱ����λ',// ��ʾ����									
				leaf : false,								
				singleClickExpand:true,
				children: [{// ���loading�ӽڵ�
					text : 'loading',
					icon : loadingIcon,
					leaf : false
				}]
			});	
			parentNode.appendChild(parentNode1);
			parentNode1.expand();
			parentNode.appendChild(parentNode2);
			parentNode2.expand();
			
			for (var i = 0; i < nodes.length; i++) {
				
				var treeNode = getTreeNode(nodes[i]);
				appendEvent(treeNode);
				if(nodes[i].afford_if=='1'){
					parentNode2.appendChild(treeNode);//alert("���һ��ֱ����λ");
				}else{
					parentNode1.appendChild(treeNode);//alert("���һ�����ص�λ");
				}
				//treeNode.ensureVisible();
			}
			parentNode1.firstChild.remove();// ɾ����ǰ�ڵ��һ�����ӽڵ�(loading�ڵ�)
			parentNode1.ui.addClass("x-tree-node-collapsed");//������ʽΪ�ļ��У���ֹû���ӻ������ı���ʽ
			parentNode2.firstChild.remove();// ɾ����ǰ�ڵ��һ�����ӽڵ�(loading�ڵ�)
			parentNode2.ui.addClass("x-tree-node-collapsed");//������ʽΪ�ļ��У���ֹû���ӻ������ı���ʽ
			
		}else{
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
			}
		}
	}
	parentNode.firstChild.remove();//�Ƴ�loading�ڵ�
	parentNode.ui.addClass("x-tree-node-collapsed");//������ʽΪ�ļ��У���ֹû���ӻ������ı���ʽ
}


/**
	���ݷ�������ѯ����nodeData����ext���ڵ�
*/
function getTreeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.afford_if+','+nodeData.org_id+','+nodeData.org_subjection_id+','+nodeData.code_afford_org_id+','+nodeData.org_level,
			text : nodeData.org_abbreviation,// ��ʾ����									
			leaf : false,								
			singleClickExpand:true,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	return treeNode;
}


//���¼���ѡ�нڵ�
function reloadNeed(){
	needReload.reload();
}

</script>      
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
		</td>
	</tr>
</table>



</body>