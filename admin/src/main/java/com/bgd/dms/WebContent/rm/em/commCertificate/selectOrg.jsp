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
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var rootMenuId = "";
var rootMenuName = "";
/**������������*/
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select oi.org_id,oi.org_abbreviation,os.org_subjection_id,(case os.code_afford_org_id when os.org_id then '1' else '0' end) as afford_if FROM comm_org_information oi,comm_org_subjection os WHERE oi.org_id='<%=orgId%>' and oi.org_id=os.org_id and oi.bsflag='0' and os.bsflag='0'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
rootMenuId = queryOrgRet.datas[0].afford_if + ',' + queryOrgRet.datas[0].org_id + ',' + queryOrgRet.datas[0].org_subjection_id; 
rootMenuName = queryOrgRet.datas[0].org_abbreviation; 

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
	title : "ѡ����֯����",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	var firstChar = node.id.charAt(0);
	if(firstChar!='0' && firstChar!='1') return;
	var obj = window.dialogArguments;
	obj.fkValue = node.id.split(',')[1];
	obj.value = node.text;
	window.close();
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
			querySql:"Select oi.org_abbreviation,oi.org_id,os.org_subjection_id,(case os.code_afford_org_id when os.org_id then '1' else '0' end) as afford_if FROM comm_org_information oi,comm_org_subjection os WHERE oi.bsflag='0' and os.bsflag='0' and oi.org_id=os.org_id and os.father_org_id='"+info[2]+"' order by os.coding_show_id"
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
			id : nodeData.afford_if+','+nodeData.org_id + ','+nodeData.org_subjection_id,
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