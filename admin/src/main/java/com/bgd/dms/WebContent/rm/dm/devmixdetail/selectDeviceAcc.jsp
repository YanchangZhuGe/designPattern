<%@ page language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String dev_ci_code = request.getParameter("dev_ci_code");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>�豸̨��ѡ�����</title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
	var extPath = "<%=extPath%>";
	/**������������*/
	var rootMenuId = "<%=dev_ci_code%>";
	cruConfig.contextPath = "<%=contextPath%>";
	var querySql = "select dev_ci_name,dev_ci_model from gms_device_codeinfo where dev_ci_code='"+rootMenuId+"'";
	var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
	var rootMenuName = queryOrgRet.datas[0].dev_ci_name+"("+queryOrgRet.datas[0].dev_ci_model+")"; 
</script>
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
	title : "ѡ���豸̨��",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	if(node.id!=rootMenuId){
		window.returnValue =  node.id;
		window.close();
	}
}


/**
	��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;

	var parentCondition = " dev_type='"+parentNode.id+"'";
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select dev_acc_id,asset_coding,dev_name,dev_model,self_num,dev_sign,license_num,dev_type,'1' as is_leaf FROM gms_device_account where "+parentCondition+" order by dev_coding"
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
			id : nodeData.dev_acc_id+"~"+nodeData.asset_coding+"~"+nodeData.dev_name+"~"+nodeData.dev_model+"~"+nodeData.self_num+"~"+nodeData.dev_sign+"~"+nodeData.license_num,
			text : nodeData.asset_coding+":"+nodeData.dev_name+"("+nodeData.dev_model+")",// ��ʾ����									
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