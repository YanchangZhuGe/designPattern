<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cache/json2.js"></script>
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
	
    .x-grid-tree-node-expanded .x-tree-icon-parent {
		background-image:
			url('../../../images/images/tree_03.png')
	}
	.x-tree-icon-parent {
		width: 16px;
		background-image:
			url('../../../images/images/tree_03.png')
	}
</style>
<script type="text/javascript" language="javascript">
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var _path = '<%=contextPath%>';
var ns = new Object();
ns.windowParentName = "list";
ns.parentRightFrame = "mainRightframe";
ns.parentLeftFrame = "mainleftframe";
var rightMenu = null;
var default_image_url = '<%=contextPath%>/images/images/tree_03.png';
var idinfo = null;
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        
        fields: [
            {name : 'name', type : 'String'},
      		{name : 'code', type : 'String'},
    		{name : 'is_leaf' , type : 'String'},
    		{name : 'node_level' , type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/rm/dm/collectTree/getColldzyqDeviceTreeAjax.srq',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
        title: '批量设备编码树',//树的标题
        width: 600,//document.body.clientWidth*0.8,
        height: document.body.clientHeight, 
        autoHeight: true,//自动高度
        lines: true,
        renderTo: 'menuTree',//绘制的区域
        collapsible: true,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        //the 'columns' property is now 'headers'
        columns: [{
            //we must use the templateheader component so we can use a custom tpl
            xtype: 'treecolumn',
            text: '名字',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'code',
            text: '代码',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'code',
            align: 'left'
        }]
    });
     //debugger;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid, colspan, colIndex, rowdata, rowspan, rowIndex, e) {
        var record = grid.getStore().getAt(1);   //Get the Record rowIndex.sourceIndex
        var name = rowdata.data.name;
        var is_leaf = rowdata.data.is_leaf;
        var node_level = rowdata.data.node_level;
        var code = rowdata.data.code;
  		parent.mainRightframe.location.href = "<%= contextPath%>/rm/dm/devAssets/collectdzyqDeviceAccList.jsp?is_leaf="+is_leaf+"&node_level="+node_level+"&code="+code;
    }
});

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