<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = request.getParameter("orgId");
	if(orgId==null || orgId.equals("")) orgId = user.getCodeAffordOrgID();
	
	String select = request.getParameter("select");
	if(select==null || select.equals("")) select = "orgid";
	select = select.toLowerCase();
	if("orgid,orgsubid,orghrid,employeeid,userid".indexOf(select)<0) select = "orgid";
	
	int index = 1;
		
	if(select.equals("orghrid")){
		index=0;
	}else if(select.equals("orgid")){
		index=1;
	}else if(select.equals("orgsubid")){
		index=2;
	}else if(select.equals("employeeid")){
		index=0;
	}else if(select.equals("userid")){
		index=0;
	}

	String multi = request.getParameter("multi");
	if(multi==null || multi.equals("")) multi = "false";
	multi = multi.toLowerCase();
	if(!multi.equals("true")) multi = "false";
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
/**公共变量定义*/
cruConfig.contextPath = "<%=contextPath%>";
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
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 

<script language="javascript" type="text/javascript">

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
	title : "选择送修单号",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true
	<% if(multi.equals("true")){%>
	,tbar : new Ext.Toolbar({
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
	<%}%>
};

function button_ok(){
	var nodes = rctTree.getChecked();
    
    var checkIds = "";// 存放选中的节点的id
    var checkTexts = "";// 存放选中的节点的text
    
    for (var i = 0; i < nodes.length; i++) {   
        var node = nodes[i];
       	checkIds += "," + node.id.split(',')[<%=index%>];
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

	<%if(multi.equals("false")){%>
	var idarray = node.id.split(',');
	var fkValue = idarray[<%=index%>];

	//var obj = window.dialogArguments;
	//obj.fkValue = fkValue;
	//obj.value = node.text;
	window.returnValue =  'name:'+node.text+'~id:'+fkValue;
	window.close();
	<%}%>
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {

	if(parentNode.firstChild.text!='loading') return;

	var info = parentNode.id.split(',');
	// 加载人员或者用户
	if("<%=select%>"=="repairForm" || "<%=select%>"=="repairForm"){
		var querySql="SELECT T.REPAIR_FORM_CODE AS NAME, T.ID AS ID FROM GMS_DEVICE_COLL_REPAIRFORM T ";
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
					var treeNode = getEmployeeNode(nodes[i]);
					
					appendEvent(treeNode);
					parentNode.appendChild(treeNode);
				}
				getSubOrgNodes(parentNode,1);
			}
		});
	}else{
		getSubOrgNodes(parentNode,0);
	}
}

// 加载下级机构
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
				
				var treeNode = getTreeNode(nodes[i]);
				appendEvent(treeNode);
				if(dbClickFlag==1){
					// 需要选择人时，移除双击事件
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
	构造组织机构节点
*/
function getTreeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.org_hr_id+','+nodeData.org_gms_id+','+nodeData.org_gms_sub_id,
			text : nodeData.org_name,// 显示内容									
			leaf : true,	
			<% if(multi.equals("true") && "orgid,orgsubid,orghrid".indexOf(select)>=0){%>checked : false,<%}%>
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
构造人员节点
*/
function getEmployeeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.id,
			text : nodeData.name,// 显示内容		
			<% if(multi.equals("true") && "userid,employeeid".indexOf(select)>=0){%>checked : false,<%}%>							
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