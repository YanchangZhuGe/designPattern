<%@ page language="java" pageEncoding="GBK"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**������������*/
var rootMenuId = "40288a8138dfbe030138dfc0159a0002";
var rootMenuName = "�Ǳ���";

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

jcdpTreeCfg.dbClickEvent = true;
jcdpTreeCfg.moveEvent = false;
jcdpTreeCfg.rightClickEvent = false;

var treeCfg = {
	region : 'west',// �趨��ʾ����Ϊ����,ͣ�����������
	split : true,// �����϶���
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
	width : 250,// ��ʼ���
	minSize : 210,// �϶���С���
	maxSize : 300,// �϶������
	collapsible : true,// ��������
	title : "�˵���",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	if(node.leaf){
		var obj = window.dialogArguments;
		obj.id=node.id;
		obj.name=node.text;
		obj.url = node.attributes.url;
		window.close();
	}
}
/**
	��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		
	Ext.Ajax.request({
		url : "<%=contextPath%>/rad/asyncQueryList.srq",
		params : {
			currentPage:"1",
			pageSize:"100",
			querySql:"Select * FROM P_AUTH_MENU_DMS WHERE parent_menu_id='"+parentNode.id+"' ORDER BY order_num desc"
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
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.menu_id,
			text : nodeData.menu_c_name,// ��ʾ����		
			url : nodeData.menu_url,							
			leaf : false,								
			singleClickExpand:true,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	if(nodeData.is_leaf=="1"){//Ҷ�ӽڵ�
		treeNode.leaf = true;
		treeNode.singleClickExpand = false;
	}
	
	return treeNode;
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