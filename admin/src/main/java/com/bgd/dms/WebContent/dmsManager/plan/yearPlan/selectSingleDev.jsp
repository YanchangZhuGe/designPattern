<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html>
<head><meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"> 
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var rootMenuId = "";
var rootMenuName = "";
/**������������*/
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "select t1.dev_ct_id id,t1.dev_ct_code code, t1.dev_ct_name name,t1.is_leaf_node from gms_device_codetype t1 where  t1.dev_ct_id='822447DB8B69FCF51813390621786851'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
rootMenuId = queryOrgRet.datas[0].id+','+queryOrgRet.datas[0].code; 
rootMenuName = queryOrgRet.datas[0].name; 

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
	collapsible : false,// ��������
	title : "��ѡ��",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true,
	tbar : new Ext.Toolbar({
		items:[
			{
				xtype:'button',
				text:'ȷ��',
				handler:button_ok
			}
			,
			{
				xtype:'button',
				text:'ȡ��',
				handler:button_cancel
			}
		]
	})
};

function button_ok(){
	var nodes = rctTree.getChecked();
	if(null!=nodes &&  nodes.length>0){
		var checkIds = "";// ���ѡ�еĽڵ��id
		for (var i = 0; i < nodes.length; i++) {   
			checkIds += ",'" + nodes[i].id+"'";
		} 
		checkIds = checkIds=="" ? "" : checkIds.substr(1);
		window.returnValue = checkIds;
		window.close();
	}else{
		alert("��ѡ���豸");
	}
}
function button_cancel(){
	window.close();
}

function dbClickNode(node){
	
}


/**
	��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	var info = parentNode.id.split(',');
	var obj = window.dialogArguments;
	var querySql="select t1.dev_ci_code id, t1.dev_ci_name name,t1.dev_ci_model model from gms_device_codeinfo t1 where t1.dev_ct_code='" + info[1] + "'";
	if(typeof obj.checkedCodes!="undefined"){
		//alert(obj.checkedCodes);
		querySql+=" and t1.dev_ci_code not in ("+obj.checkedCodes+")";
	}
	querySql+="  order by t1.type_seq"
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:querySql
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getEqInfoNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
			}
			getSubOrgNodes(parentNode,1);
		}
	});
}

// �����¼��ڵ�
function getSubOrgNodes(parentNode,dbClickFlag){
	var info = parentNode.id.split(',');
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select t1.dev_ct_id id, t1.dev_ct_code code,t1.dev_ct_name name,t1.is_leaf_node from gms_device_codetype t1 where  t1.parent_dev_ct_id='"+info[0]+"' order by t1.seq "
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			//addSubNodes(parentNode,nodes);
			
			for (var i = 0; i < nodes.length; i++) {
				
				var treeNode = getEqTypeNode(nodes[i]);
				appendEvent(treeNode);
				if(dbClickFlag==1){
					// ��Ҫѡ����ʱ���Ƴ�˫���¼�
					treeNode.removeListener('dblclick',dbClickNode);
				}
				parentNode.appendChild(treeNode);

			}
			parentNode.firstChild.remove();// ɾ����ǰ�ڵ��һ�����ӽڵ�(loading�ڵ�)
			parentNode.ui.addClass("x-tree-node-collapsed");//������ʽΪ�ļ��У���ֹû���ӻ������ı���ʽ
		},
		failure : function(){// ʧ��
							}			
	});//eof Ext.Ajax.request
}
/**
	�����豸���ͽڵ�
*/
function getEqTypeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.id + "," + nodeData.code,
			text : nodeData.name,// ��ʾ����									
			leaf : false,	
			//checked : false,
			singleClickExpand:true,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	return treeNode;
}

/**
�����豸��Ϣ�ڵ�
*/
function getEqInfoNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.id,
			text : nodeData.name+"("+nodeData.model+")",// ��ʾ����
			checked : false,						
			leaf : true,								
			singleClickExpand : false
	});	
	
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