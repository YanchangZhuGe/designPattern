<%@ page language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String codingSortId = request.getParameter("codingSortId");
	String selectIds = request.getParameter("selectIds");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<META HTTP-EQUIV="pragma" CONTENT="no-cache"> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate"> 
<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**������������*/
var rootMenuId = "<%=codingSortId%>";//"INIT_AUTH_ORG_012345678900000";
var selectIds="<%=selectIds%>"

cruConfig.contextPath = "<%=contextPath%>";
var rootMenuName="������˾";
</script>

<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js?number=<%=Math.random()%>"></script> 

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
	title : "ѡ�����",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
}

/**
	��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	var parentCondition = " SUPERIOR_CODE_ID ";
	if (rootMenuId==parentNode.id) {
		parentCondition += "is null";
	}else{
		parentCondition += "='"+parentNode.id+"'";
	}
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			//querySql:"Select t.coding_code_id,t.coding_name,case (select count(ccsd.coding_code_id) from comm_coding_sort_detail ccsd where ccsd.SUPERIOR_CODE_ID=t.coding_code_id and ccsd.bsflag='0') when 0 then '1' else '0' end as is_leaf FROM comm_coding_sort_detail t WHERE t.coding_sort_id='"+rootMenuId+"' and t.bsflag='0' and "+parentCondition+" order by t.CODING_SHOW_ID"
			querySql:"select t.coding_code_id,t.coding_name,t.superior_code_id,case (select count(ccsd.coding_code_id) from comm_human_coding_sort ccsd where ccsd.SUPERIOR_CODE_ID = t.coding_code_id and ccsd.bsflag = '0') when 0 then  '1' else  '0' end as is_leaf from comm_human_coding_sort t where t.coding_sort_id = '"+rootMenuId+"' and t.bsflag = '0' and "+parentCondition
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
	});
}

/**
���ݷ�������ѯ����nodeData����ext���ڵ�
*/
function getTreeNode(nodeData){
var treeNode;
if(nodeData.is_leaf=="1"){//Ҷ�ӽڵ�
	treeNode = new Ext.tree.TreeNode({
		id : nodeData.coding_code_id,
		text : nodeData.coding_name,// ��ʾ����	
		leaf : true,								
		singleClickExpand: false,
		children: [{// ���loading�ӽڵ�
			text : 'loading',
			icon : loadingIcon,
			leaf : true
		}]
	});	
}else{
	var checkState=false;
	var ids=selectIds.split(",");
	if(""!=ids){
		for(var i=0;i<ids.length;i++){
			//Ĭ��checkbox��ѡ��
			if(ids[i]==nodeData.coding_code_id)
				checkState=true;
		}
	}
	treeNode = new Ext.tree.AsyncTreeNode({
		id : nodeData.coding_code_id,
		text : nodeData.coding_name,// ��ʾ����								
		leaf : false,								
		singleClickExpand:true,
		checked : checkState,
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
    for (var i = 0; i < nodes.length; i++) {   
        if(i==(nodes.length)-1){
        	checkIds +=nodes[i].id;
        	checkTexts +=nodes[i].text;
        }else{
	    	checkIds +=nodes[i].id+"," ;
	    	checkTexts +=nodes[i].text+",";
        }
    } 
	//alert(checkIds);
	//alert(checkTexts);
    
    var obj = window.dialogArguments;
	obj.fkValue = checkIds=="" ? "" :checkIds;
	obj.value = checkTexts=="" ? "" :checkTexts;
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