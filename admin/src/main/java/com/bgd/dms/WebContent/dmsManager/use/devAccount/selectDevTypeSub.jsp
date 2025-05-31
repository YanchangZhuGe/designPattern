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
/**公共变量定义*/
cruConfig.contextPath = "<%=contextPath%>";
//var querySql = "select t1.dev_ct_id id,t1.dev_ct_code code, t1.dev_ct_name name,t1.is_leaf_node from gms_device_codetype t1 where  t1.dev_ct_id='822447DB8B69FCF51813390621786851'";
//var querySql = "select e.dev_tree_id id,e.device_name name,e.father_id code,e.device_code,e.device_type from dms_device_tree e where e.dev_tree_id='D' ";
//var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
//rootMenuId = queryOrgRet.datas[0].id+','+queryOrgRet.datas[0].code; 
//rootMenuName = queryOrgRet.datas[0].name; 
rootMenuId = ","; 
rootMenuName = "设备类型"; 

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
jcdpTreeCfg.rightClickEvent = false;
jcdpTreeCfg.moveEvent = false;
jcdpTreeCfg.dbClickEvent = true;

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 530,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : false,// 允许隐藏
	title : "请选择",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true,
	tbar : new Ext.Toolbar({
		items:[
			{
				xtype:'button',
				text:'确定',
				handler:button_ok
			}
			,
			{
				xtype:'button',
				text:'取消',
				handler:button_cancel
			}
		]
	})
};

function button_ok(){
var nodes = rctTree.getChecked();
    
    var checkIds = "";// 存放选中的节点的id
    var checkTexts = "";// 存放选中的节点的text
    
    for (var i = 0; i < nodes.length; i++) {   
        var node = nodes[i];
        checkIds += "," + node.id.split(',')[0];
       	checkTexts += "," + nodes[i].text;
    } 
   
    checkIds = checkIds=="" ? "" : checkIds.substr(1);
    checkTexts = checkTexts=="" ? "" : checkTexts.substr(1);

    var obj = window.dialogArguments;
	obj.fkValue = checkIds;
	obj.value = checkTexts;
	
	window.close();
}
function button_cancel(){
	var obj = window.dialogArguments;
	obj.fkValue = "";
	obj.value = "";
	window.close();
}

function dbClickNode(node){
	
}


/**
	获取parentNode的子节点
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

// 加载下级节点
function getSubOrgNodes(parentNode,dbClickFlag){
	var info = parentNode.id.split(',');
	var querysql;
	if(info == ','){
		querysql="select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,t1.father_id code,t1.device_code,t1.device_type from dms_device_tree t1 where t1.father_id  is null and t1.dev_tree_id in('D003','D004','D006') order by t1.code_order ";
	}else{
		querysql="select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,t1.father_id code,t1.device_code,t1.device_type from dms_device_tree t1 where t1.father_id='"+info[0]+"' order by t1.code_order ";
	}
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:querysql
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
					treeNode.removeListener('dblclick',dbClickNode);
				}
				parentNode.appendChild(treeNode);

			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)
			parentNode.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
		},
		failure : function(){// 失败
							}			
	});//eof Ext.Ajax.request
}
/**
	构造设备类型节点
*/
function getEqTypeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			//id : nodeData.id + "," + nodeData.code,
			id : nodeData.id,
			text : nodeData.name,// 显示内容							
			leaf : false,	
			checked : false,
			singleClickExpand:true,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	return treeNode;
}

/**
构造设备信息节点
*/
function getEqInfoNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.id,
			text : nodeData.name+"("+nodeData.model+")",// 显示内容
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