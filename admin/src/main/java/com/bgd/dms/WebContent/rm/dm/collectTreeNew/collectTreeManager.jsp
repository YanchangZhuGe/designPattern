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
            url: '<%=contextPath%>/rm/dm/collectTree/getCollDeviceTreeAjax.srq',
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
    var rightMenu = new Ext.menu.Menu({
        items : [{
					text : '新增',
					id : 'add',
					handler : _addNode				
				}, {
					text : '修改',
					id : 'modify',
					handler : _modifyNode
				}, {
					text : '删除',
					id : 'delete',
					handler : _deleteNode
				},{
					text : '增加映射',
					id : 'addMap',
					handler : _addMap
				}]
    });
    function _addMap(item, e, node) {
		if (idinfo == null){
			parent.Ext.Msg.alert("注意", "请先选择节点");
		} else {
			//device_id~dev_code~node_level~is_leaf
    		var idinfos = idinfo.substr(idinfo.indexOf("-")+1).split("~");
			var href = _path
					+ "/rm/dm/collectTreeNew/collectDeviceMapping.jsp?&device_id="+idinfos[0]+"&dev_code="+idinfos[1]+"&node_level="+idinfos[2];
			parent[ns.parentRightFrame].location.href = href;
		}
	};
	function _addNode(item, e, node) {
		if (idinfo == null) {
			parent.Ext.Msg.alert("注意", "请先选择节点");
		} else {
			//device_id~dev_code~node_level~is_leaf
    		var idinfos = idinfo.substr(idinfo.indexOf("-")+1).split("~");
			var href = _path
					+ "/rm/dm/collectTreeNew/collectDeviceNew.jsp?pageAction=add&parent_device_id="+idinfos[0]+"&parent_dev_code="+idinfos[1]+"&parent_node_level="+idinfos[2];
			parent[ns.parentRightFrame].location.href = href; 
		}
	};
	function _modifyNode(item, e, node) {
		if (idinfo == null) {
			parent.Ext.Msg.alert("注意", "请先选择节点");
		} else {
			//device_id~dev_code~node_level~is_leaf
    		var idinfos = idinfo.substr(idinfo.indexOf("-")+1).split("~");
			var href = _path
					+ "/rm/dm/collectTreeNew/collectDeviceModify.jsp?pageAction=modify&device_id="
					+idinfos[0]+ "&node_level="+idinfos[2]+"&dev_code="+idinfos[1];
			parent[ns.parentRightFrame].location.href = href;
		}
	};
	function _deleteNode(item, e, node) {
		var t = [];
		if(node.attributes["is_delete"] === "false"){
			t.push(node.text);
		}
		if(t.length > 0 ){
			parent.Ext.Msg.alert("注意","<font color='red'>"+t.join(",")+"</font>有台账信息,无法删除");
			return;
		}
		var msg = '确定要删除<font color="red">' + node.text + "</font>吗?";
		if (!node.isLeaf()) {
			msg += "<font color='red'>该类型下的所有设备都会删除</font>";
		}
		parent.Ext.Msg.confirm("注意", msg, function(btn) {			
			if(btn == 'yes'){
				parent.Ext.getBody().mask("操作中,请等待...", "x-mask-loading");
				var sql = "delete from GMS_DEVICE_COLLECTINFO where device_id = '"
							+ node.id + "'";
				switch (node.attributes.node_level) {
					case '1' :
						sql += " or dev_code like '"
								+ node.attributes.dev_code + "_%'";
						break;
				}
				var path = _path + "/rad/asyncDelete.srq";
				var params =  encodeURI("deleteSql=" + sql + "&ids=");
				var retObject = syncRequest('post', path,params);
				parent.Ext.getBody().unmask();
				if (retObject["returnCode"] != 0) {
					parent.Ext.Msg.alert("错误", "操作失败,<font color='red'>"
									+ retObject["returnMsg"] + "</font>");
				}else{
					window.location.reload();
				}
			}
		}, this);
	};
    grid.on("itemcontextmenu", function (view, record, item, index, e, eOpts) {
    	var record = view.getStore().getAt(index);
    	idinfo = record.id;
    	//device_id~dev_code~node_level~is_leaf
    	var idinfos = idinfo.substr(idinfo.indexOf("-")+1).split("~");
    	rightMenu.items.each(function(item, index, length) {
			item.enable();
		});
    	if (idinfos[0]=="") {
			rightMenu.items.each(function(item, index, length) {
				if (item.id != 'add') {
					item.disable();
				}
			});
		} else if (idinfos[3]=="1") {
			rightMenu.items.get('add').disable();
		} else {
			rightMenu.items.get('addMap').disable();
		}
        e.preventDefault();   
        rightMenu.showAt(e.getXY());
    });
    
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