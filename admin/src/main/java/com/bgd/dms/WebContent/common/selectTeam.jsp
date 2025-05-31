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

/**������������*/
var rootMenuId = "<%=orgId%>";//"INIT_AUTH_ORG_012345678900000";

cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select oi.org_id,oi.org_abbreviation,os.org_subjection_id FROM comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id and os.bsflag = '0' and os.locked_if = '0' WHERE oi.bsflag='0' and oi.org_id='"+rootMenuId+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].org_abbreviation; 
rootMenuId += ","+queryOrgRet.datas[0].org_subjection_id; 
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
	width : 500,// ��ʼ���
	minSize : 210,// �϶���С���
	maxSize : 300,// �϶������
	collapsible : true,// ��������
	title : "ѡ�����",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	/*if(node.leaf){
		var obj = window.dialogArguments;
		obj.fkValue = node.id.substr(0,14);
		obj.value = node.text;
		window.close();
	}*/
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
			querySql:"select distinct org.org_subjection_id,org.org_id,case org.org_level when '0200100005000000008' then '1' else '0' end as is_leaf,org.org_abbreviation from (select oi.org_id,oi.org_name,os.org_subjection_id,os.father_org_id,os.coding_show_id,oi.org_level,oi.org_abbreviation from comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id and oi.bsflag='0' and os.bsflag='0')org where org.father_org_id='"+parentNode.id.substring(15)+"' start with org.org_id in (select org_id from comm_org_information where substr(org_id,1,4)='C600' and org_type = '0200100004000000024' and org_level='0200100005000000008' and bsflag='0') connect by prior org.father_org_id = org.org_subjection_id"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;

			if(nodes!=null && nodes.length>0){
				for (var i = 0; i < nodes.length; i++) {
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
			id : nodeData.org_id+','+nodeData.org_subjection_id,
			text : nodeData.org_abbreviation,// ��ʾ����									
			leaf : true,								
			singleClickExpand: false,
			checked : false,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.org_id+','+nodeData.org_subjection_id,
			text : nodeData.org_abbreviation,// ��ʾ����									
			leaf : false,								
			singleClickExpand:true,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}
	
	return treeNode;
}

	function getCheckedNode() {   
	    var nodes = rctTree.getChecked();
	    var checkIds = "";// ���ѡ��id
	    var checkTexts = "";// ���ѡ��id
	    if(nodes.length > 1){
	    	alert("ֻ��ѡ��һ֧����");
	    	return;
	    }
	    for (var i = 0; i < nodes.length; i++) {   
	    	checkIds += "," + nodes[i].id.substr(0,14);
	    	checkTexts += "," + nodes[i].text;
	    } 
	    
	    var obj = window.dialogArguments;
		obj.fkValue = checkIds=="" ? "" : checkIds.substr(1);
		obj.value = checkTexts=="" ? "" : checkTexts.substr(1);
		window.close();
	}   

	

</script>      

</head>
<body>

<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left" style="padding-left:400px;padding-top:5px;padding-bottom:5px;">
			<input type="button" value="ȷ��" onclick="getCheckedNode()" class="iButton2"/>
			<input type="button" value="ȡ��" onclick="window.close()" class="iButton2"/>
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