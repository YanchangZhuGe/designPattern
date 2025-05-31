<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="ExtTab" prefix="eRed"%> 
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = "";
	if(user!=null) userId = user.getUserId();
	String orgId = user.getOrgId();
	if(orgId==null || orgId.equals("")) orgId = "C6000000000001";//user.getCodeAffordOrgID();
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
debugger;
var querySql = "select t1.org_hr_id, t1.org_hr_short_name as org_name, t2.org_gms_id, t3.org_subjection_id as org_gms_sub_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id=t2.org_hr_id join comm_org_subjection t3 on t3.org_id=t2.org_gms_id and t3.bsflag='0' where t2.org_gms_id='<%=orgId%>'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
rootMenuId = queryOrgRet.datas[0].org_hr_id + ',' + queryOrgRet.datas[0].org_gms_id + ',' + queryOrgRet.datas[0].org_gms_sub_id; 
rootMenuName = queryOrgRet.datas[0].org_name; 


</script>

<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 

<script language="javascript" type="text/javascript">
var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

var rightMenu = null;
var selectedNode;
var jcdpTreeCfg={
	moveNodeAction:'/tcg/moveTreeNodePosition.srq',
	clickEvent:false,
	dbClickEvent:false,
	moveEvent:false,
	rightClickEvent:false
};
var rctTree_common;
Ext.onReady(function() {
	<%if("true".equals(request.getParameter("noPersonalTab"))){ %>
	return;
	<%} %>
	Ext.BLANK_IMAGE_URL = blank_image_url;
	var rootNode_common = new Ext.tree.AsyncTreeNode({
				id:'root,3.0',
				text:'������ϵ��',
				singleClickExpand:true,
				children : [{// �ӽڵ�
					text : 'loading',// ��ʾ����Ϊloading
					icon : loadingIcon,// ʹ��ͼ��Ϊloading
					leaf : true					
				}]
	});
	var treeLoader_common = new Ext.tree.TreeLoader();// ָ��һ���յ�TreeLoader
	
	 rctTree_common = new Ext.tree.TreePanel({// ����һ��TreePanel��ʾtree
		id : 'common',// idΪtree
		region : 'west',// �趨��ʾ����Ϊ����,ͣ�����������
		split : true,// �����϶���
		bodyStyle:"padding:2px",
		collapseMode : 'mini',// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
		width : 480,// ��ʼ���
		minSize : 210,// �϶���С���
		maxSize : 300,// �϶������
		collapsible : true,// ��������
		lines : true,// ���ֽڵ������
		autoScroll : true,// �Զ����ֹ�����
		frame : false,
		enableDD:true,
		loader : treeLoader_common,// ָ�����������loader����,���ڶ���Ϊ��	
		root : rootNode_common
	});

	 
	rctTree_common.render("menuTree1"); // ��Ⱦ����
	
	appendEvent_common(rootNode_common);
	rctTree_common.getRootNode().toggle();	
});
var rctTree;
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = blank_image_url;
	var rootNode = new Ext.tree.AsyncTreeNode({
				id:rootMenuId,
				text:rootMenuName,
				singleClickExpand:true,
				children : [{// �ӽڵ�
					text : 'loading',// ��ʾ����Ϊloading
					icon : loadingIcon,// ʹ��ͼ��Ϊloading
					leaf : true					
				}]
	});
	var treeLoader = new Ext.tree.TreeLoader();// ָ��һ���յ�TreeLoader
	
	 rctTree = new Ext.tree.TreePanel({// ����һ��TreePanel��ʾtree
		id : 'tree',// idΪtree
		region : 'west',// �趨��ʾ����Ϊ����,ͣ�����������
		split : true,// �����϶���
		bodyStyle:"padding:2px",
		collapseMode : 'mini',// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
		width : 480,// ��ʼ���
		minSize : 210,// �϶���С���
		maxSize : 300,// �϶������
		collapsible : false,// ��������
		lines : true,// ���ֽڵ������
		autoScroll : true,// �Զ����ֹ�����
		frame : false,
		enableDD:true,
		loader : treeLoader,// ָ�����������loader����,���ڶ���Ϊ��	
		root : rootNode
	});

	rctTree.render("menuTree2"); // ��Ⱦ����
	
	appendEvent(rootNode);
	rctTree.getRootNode().toggle();	
});
/**
	���ڵ�������Ӧ�¼�
*/
function appendEvent(treeNode){
	treeNode.on('expand', getSubNodes);// ���嵱ǰ�ڵ�չ��ʱ����getSubNodes,�ٴ��첽��ȡ�ӽڵ�
	
}	
/**
	���ڵ�������Ӧ�¼�
*/
function appendEvent_common(treeNode){
	treeNode.on('expand', getSubNodes_common);// ���嵱ǰ�ڵ�չ��ʱ����getSubNodes,�ٴ��첽��ȡ�ӽڵ�
	
}	
/**
��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
if(parentNode.firstChild.text!='loading') return;

var info = parentNode.id.split(',');

// ������Ա
Ext.Ajax.request({
	url : "<%=contextPath%>"+appConfig.queryListAction,
	params : {
		currentPage:"1",
		pageSize:"10000",
		querySql:"Select e.employee_id,e.employee_name FROM comm_human_employee e WHERE e.bsflag='0' and e.org_id='"+info[1]+"'"
	},
	method : 'Post',
	success : function(resp){
		var myData = eval("("+resp.responseText+")");
		var nodes = myData.datas;
		
		for (var i = 0; i < nodes.length; i++) {
			var treeNode = getEmployeeNode(nodes[i]);
			
			appendEvent(treeNode);
			parentNode.appendChild(treeNode);
		}

		getSubOrgNodes(parentNode,1);
	}
});


}

//�����¼�����
function getSubOrgNodes(parentNode,dbClickFlag){
	var info = parentNode.id.split(',');
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select t1.org_hr_id, t1.org_hr_short_name as org_name, t2.org_gms_id, t3.org_subjection_id as org_gms_sub_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id=t2.org_hr_id join comm_org_subjection t3 on t3.org_id=t2.org_gms_id and t3.bsflag='0' where t1.org_hr_parent_id='" + info[0] + "'"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			//addSubNodes(parentNode,nodes);
			
			for (var i = 0; i < nodes.length; i++) {
				
				var treeNode = getOrgNode(nodes[i]);
				appendEvent(treeNode);
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
��ȡparentNode���ӽڵ�
*/
function getSubNodes_common(parentNode) {
if(parentNode.firstChild.text!='loading') return;

var info = parentNode.id.split(',');

// ������Ա
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select t.entity_id,t.object_type,t.object_id,(case t.object_type when '3.1' then (select e.employee_name from comm_human_employee e where t.object_id=e.employee_id and e.bsflag='0') else spare1 end) as object_name from ic_user_favorite_dms t  where t.object_type in ('3.1','3.2','3.3') and t.user_id='<%=userId%>' and t.spare2='"+info[0]+"' and t.bsflag='0' order by object_name"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getPersonalNode(nodes[i]);
				
				appendEvent_common(treeNode);
				parentNode.appendChild(treeNode);
				treeNode.toggle();	
			}
			parentNode.firstChild.remove();// ɾ����ǰ�ڵ��һ�����ӽڵ�(loading�ڵ�)
			if(info[1]=="3.2"){
				parentNode.ui.addClass("x-tree-node-collapsed");
			}
		},
		failure : function(){// ʧ��
							}			
	});//eof Ext.Ajax.request


}

/**
���ݷ�������ѯ����nodeData����ext���ڵ�
*/
function getPersonalNode(nodeData){
	var treeNode;
	if(nodeData.object_type=="3.2"){
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.entity_id+','+nodeData.object_type+','+nodeData.object_id,
			text : nodeData.object_name,// ��ʾ����									
			leaf : false,	
			checked:false,
			singleClickExpand:true,
			checkChange:function(){
				alert();
			},
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
		
		treeNode.on('checkchange', function(node, checked) {   
			node.expand();   
			node.attributes.checked = checked;   
			node.eachChild(function(child) {   
				child.ui.toggleCheck(checked);   
				child.attributes.checked = checked;   
			});   
		}, treeNode); 
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.object_id,
			text : nodeData.object_name,// ��ʾ����									
			leaf : true,								
			checked : false,
			singleClickExpand : false,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}
	
	

	return treeNode;
}

/**
���ݷ�������ѯ����nodeData����ext���ڵ�
*/
function getEmployeeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.employee_id,
			text : nodeData.employee_name,// ��ʾ����									
			leaf : true,		
			checked:false,						
			singleClickExpand : false
	});	
	
	return treeNode;
}

/**
���ݷ�������ѯ����nodeData����ext���ڵ�
*/
function getOrgNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
		id : nodeData.org_hr_id+','+nodeData.org_gms_id+','+nodeData.org_gms_sub_id,
		text : nodeData.org_name,// ��ʾ����									
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

function confirmchoose() {   
    var nodes = rctTree.getChecked();
    var saveId = "";// ���ѡ��id
    var saveValue = "";
    for (var i = 0; i < nodes.length; i++) {   
    	if(saveId==""){
			saveId+=nodes[i].id;
		}else{
			saveId+=","+nodes[i].id;
		}
		if(saveValue==""){
			saveValue+=nodes[i].text;
		}else{
			saveValue+=","+nodes[i].text;
		}
    } 
    <%if(!"true".equals(request.getParameter("noPersonalTab"))){ %>	
    var nodesCommon=rctTree_common.getChecked();
    for(var i = 0; i < nodesCommon.length; i++) {   
    	if(nodesCommon[i].leaf!=false){
	    	if(saveId==""){
	    		saveId+=nodesCommon[i].id;
	    	}else{
	    		if(saveId.indexOf(nodesCommon[i].id) <0 )  {
	    			saveId+=","+nodesCommon[i].id;
	    		}
	    	}
	    	if(saveValue==""){
				saveValue+=nodesCommon[i].text;
			}else{
				if(saveValue.indexOf(nodesCommon[i].text)< 0 )  {
				saveValue+=","+nodesCommon[i].text;
				}
			}
   		}
    }
	<%} %>
    var obj = window.dialogArguments;
	obj.fkValue=saveId;
	obj.value = saveValue;
	debugger;
	window.close();
}   
</script>      
</head>
<body style="overflow-x:hidden;overflow-y:hidden">
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%" height="100%">
	<tr>
		<td align="left" valign="top">
			<eRed:tabs tabsId="tabs" activeTab="0" width="500" height="540" autoScroll="true">
  				<%if(!"true".equals(request.getParameter("noPersonalTab"))){ %>
  				<eRed:tab tabId="table1" title="������ϵ��">
     			 <div id="menuTree1" style="width:100%;height:100%;overflow:auto;"></div>
	 			</eRed:tab>
	 			<%} %>
	  			<eRed:tab tabId="table2" title="������Ա">
	    			<div id="menuTree2" style="width:100%;height:100%;overflow:auto;"></div>
	  			</eRed:tab>
			</eRed:tabs>
		</td>
	</tr>
</table>
</body>