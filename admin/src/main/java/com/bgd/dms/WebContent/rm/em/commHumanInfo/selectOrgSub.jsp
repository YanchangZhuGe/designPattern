<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getSubOrgIDofAffordOrg();
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
//"INIT_AUTH_ORG_012345678900000";

cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select oi.org_abbreviation ,(case os.code_afford_org_id when os.org_id then '1' else '0' end) as afford_if FROM comm_org_information oi,comm_org_subjection os WHERE oi.org_id=os.org_id and os.org_subjection_id='<%=orgSubId%>'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].org_abbreviation; 
var rootMenuId = queryOrgRet.datas[0].afford_if+',<%=orgSubId%>';
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
default_image_url = "<%=contextPath%>/images/images/tree_12.png";

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
	fkValue = node.id.split(',')[1];
	parent.mainFrame.refreshData(fkValue);
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
			//case (select count(os3.org_id) from comm_org_subjection os3 where os3.father_org_id=os.org_subjection_id and os3.bsflag='0') when 0 then '1' else '0' end as is_leaf
			querySql:"Select os.org_subjection_id,oi.org_abbreviation,oi.org_id, (case os.code_afford_org_id when os.org_id then '1' else '0' end) as afford_if FROM comm_org_information oi,comm_org_subjection os,comm_org_subjection os2,comm_org_information oi2 WHERE oi.bsflag='0' and os.bsflag='0' and oi2.bsflag='0' and os2.bsflag='0' and oi.org_id=os.org_id and os.father_org_id=os2.org_subjection_id and os2.org_id=oi2.org_id and os2.org_subjection_id='"+info[1]+"' order by os.coding_show_id"
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
				icon : default_image_url,					
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
				icon : default_image_url,							
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
			id : nodeData.afford_if+','+nodeData.org_subjection_id,
			text : nodeData.org_abbreviation,// ��ʾ����			
			icon : default_image_url,						
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