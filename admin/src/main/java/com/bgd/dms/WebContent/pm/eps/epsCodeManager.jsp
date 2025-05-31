<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String owner = request.getParameter("owner");
	String flag = "true";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title></title>
<style type="text/css">
.x-grid-row .x-grid-cell {
	color: null;
	font: normal 13px tahoma, arial, verdana, sans-serif;
	border-color: #ededed;
	border-style: solid;
	border-width: 1px 0;
	border-top-color: #fafafa
}

.x-column-header {
	padding: 0;
	position: absolute;
	overflow: hidden;
	border-right: 1px solid #c5c5c5;
	border-left: 0 none;
	border-top: 0 none;
	border-bottom: 0 none;
	text-shadow: 0 1px 0 rgba(255, 255, 255, 0.3);
	font: normal 11px/15px tahoma, arial, verdana, sans-serif;
	color: null;
	font: normal 13px tahoma, arial, verdana, sans-serif;
	background-image: none;
	background-color: #c5c5c5;
	background-image: -webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #f9f9f9),
		color-stop(100%, #e3e4e6) );
	background-image: -moz-linear-gradient(top, #f9f9f9, #e3e4e6);
	background-image: linear-gradient(top, #f9f9f9, #e3e4e6)
}

.x-tree-icon-leaf {
	width: 16px;
	background-image:
		url('<%=contextPath%>/images/images/tree_06.png')
}

.x-tree-icon-parent {
	width: 16px;
	background-image:
		url('<%=contextPath%>/images/images/tree_06.png')
}

.x-grid-tree-node-expanded .x-tree-icon-parent {
	background-image:
		url('<%=contextPath%>/images/images/tree_06.png')
}
</style>
<style type="text/css">
    .task {
        background-image: url(<%=contextPath%>/images/images/tree_06.png) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/images/images/tree_06.png) !important;
    }
</style>
<script type="text/javascript" language="javascript">

cruConfig.contextPath = "<%=contextPath%>";

var selectedTagIndex = 0;

var selectParentIdData="";
var selectIdData="";
var epsid="";
var epsname="";
var orgid="";
var orgname="";

var codeTypeObjectId="";

Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'epsid',type: 'string'},
            {name : 'nodeid',type: 'string'},
            {name : 'parentid', type : 'String'},
            {name : 'epsname', type : 'String'},
            {name : 'orgname', type : 'String'},
            {name : 'orgid', type : 'String'},
            {name : 'root', type : 'String'},
            {name : 'ordernum', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/pm/eps/queryAllEpsCode.srq',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        width: document.body.clientWidth,
        height:document.body.clientHeight*0.8, 
        autoHeight: true,  
        lines: true,
        enableDD: true, 
        viewConfig: {
            plugins: {
                ptype: 'treeviewdragdrop',
                appendOnly:false
            },
            listeners: { 
                beforedrop: function (node,data,overModel,dropPosition,eOpts ) {
                	var sourceNode=data.records[0].data;
                	var targetNode=overModel.data;
                	var beforeOrAfter=dropPosition;
                	if(targetNode.parentId == "0"){
                		alert("不允许拖拽到此处!");
                	} else {
                	Ext.Ajax.request({  
            			url:'<%=contextPath%>/pm/eps/saveEpsCodeOrder.srq',
            			params:{  
            				sourceNodeId:sourceNode.nodeid,
            				targetNodePId:targetNode.parentid,
            				targetNodeIndex:targetNode.ordernum,
            				targetNodeId:targetNode.nodeid,
            				beforeOrAfter:beforeOrAfter
                			}  
                		});  
                	}
            	} 
            } 
        },
        renderTo: 'menuTree',
        collapsible: false,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        EnableDD:true,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn', //this is so we know which column will show the tree
            text: 'EPSID',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'epsid'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: 'EPS名称',
            flex: 1,
            sortable: true,
            dataIndex: 'epsname',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '责任人',
            flex: 1,
            sortable: true,
            dataIndex: 'orgname',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectIdData=rowdata.data.nodeid;
        selectParentIdData= rowdata.data.parentid;
        epsid = rowdata.data.epsid;
        epsname= rowdata.data.epsname;
        orgid = rowdata.data.orgid;
        orgname = rowdata.data.orgname;
        
        codeTypeObjectId = rowdata.data.root;
    });
});

</script>
</head>
<body  style="background:#fff" >
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  
			  <tr>
			    <td class="ali_cdn_name"></td>
			    <td class="ali_cdn_input"></td>
			    <td class="ali_query"></td>
			    <td class="ali_query"></td>
			    <td></td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
			  </tr>
			</table>
		</div>
		<div id="table_box" style="height: 580px">
					<div id="menuTree" style="width:100%;height:auto;overflow:auto;z-index: 0"></div>
		</div>
	</div>
</body>
<script type="text/javascript">

function toAdd(){
	if(selectParentIdData==null||selectParentIdData==""){
		popWindow("<%=contextPath%>/pm/eps/epsCodeAdd.jsp?parentid=0");
	}else{
		popWindow("<%=contextPath%>/pm/eps/epsCodeAdd.jsp?parentid="+selectIdData);
	}
}
function toEdit(){
	if(selectParentIdData==null||selectParentIdData==""){
		//selectParentIdData=costType;
	}else{
		//popWindow(cruConfig.contextPath+"/op/costManager/costTemplateManagerEdit.upmd?pagerAction=edit2Edit&parentId="+selectUpIdData+"&id="+selectParentIdData+"&costType="+costType);
		popWindow("<%=contextPath%>/pm/eps/epsCodeModify.jsp?&nodeid="+selectIdData);
	}
}
function toDelete(){
	if(confirm('确定要删除吗?')){
			var sql="update bgp_eps_code set bsflag = '1' where object_id in( select object_id from bgp_eps_code "+
					" start with parent_object_id = '"+selectIdData+"'  connect by prior object_id = parent_object_id   union  select '"+selectIdData+"' from dual)";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			if(retObject.returnCode!=0) alert(retObject.returnMsg);
			refreshTree();
	}
}

function refreshTreeSaveExpand(){
	var tree=Ext.getCmp('gridId');
	var path = tree.getSelectionModel()
	.getSelectedNode().getPath('id');
	//重载数据,并在回调函数里面选择上一次的节点 
	tree.getStore().load(tree.getRootNode(),function(treeNode) {
				//展开路径,并在回调函数里面选择该节点 
			tree.expandPath(path,'id', function(bSucess,oLastNode) {
								tree.getSelectionModel().select(oLastNode);
							});
		}, this);
}

function refreshTree(){
	Ext.getCmp('gridId').getStore().load(); 
}

function changeOwner(){
	owner=document.getElementById("owner").value;
	
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/pm/eps/queryAllEpsCode.srq',
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
}
</script>
</html>
