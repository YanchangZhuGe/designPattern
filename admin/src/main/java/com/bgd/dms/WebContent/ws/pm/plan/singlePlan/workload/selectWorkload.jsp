<%@ page language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String codingSortId = "7000";
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**������������*/
var rootMenuId = "<%=codingSortId%>";//"INIT_AUTH_ORG_012345678900000";

cruConfig.contextPath = "<%=contextPath%>";
var querySql = "select * from bgp_p6_resource_workload WHERE object_id = '"+rootMenuId+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].name; 

</script>

<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 

<script language="javascript" type="text/javascript">
var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

jcdpTreeCfg.rightClickEvent = false;
jcdpTreeCfg.moveEvent = false;
jcdpTreeCfg.dbClickEvent = true;

var treeCfg = {
	region : 'west',// �趨��ʾ����Ϊ����,ͣ�����������
	split : true,// �����϶���
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
	width : 530,// ��ʼ���
	minSize : 210,// �϶���С���
	maxSize : 300,// �϶������
	collapsible : true,// ��������
	title : "ѡ������<input type='button' value='ȷ��' onclick='fun()'>",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
		//var obj = window.dialogArguments;
		//obj.fkValue = node.id;
		//obj.value = node.text;
 
		//window.close();
}

function fun(){
	debugger;
	//alert(1);
	var nodes = rctTree.getChecked();
	var checkIds = "";// ���ѡ�еĽڵ��id
    var checkTexts = "";// ���ѡ�еĽڵ��text
   
    for (var i = 0; i < nodes.length; i++) {   
 		var node = nodes[i];
      	checkIds += "," + node.id;
      	checkTexts += "," + node.text;
 	} 
	checkIds = checkIds=="" ? "" : checkIds.substr(1);
	checkTexts = checkTexts=="" ? "" : checkTexts.substr(1);
	
	var obj = window.dialogArguments;
	obj.fkValue = checkIds;
	obj.value = checkTexts;
	window.close();
}


/**
	��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;

	
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select * from bgp_p6_resource_workload WHERE bsflag = '0' and parent_object_id = '"+parentNode.id+"'"
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
			id : nodeData.object_id,
			text : nodeData.id+'_'+nodeData.name,// ��ʾ����									
			leaf : false,
			singleClickExpand:true,
			checked : false,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	//debugger;
	//if(nodeData.if_check == 'false') {
	//treeNode.checked = true;	
	//}
	treeNode.leaf = false;
	treeNode.singleClickExpand = false;
	
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