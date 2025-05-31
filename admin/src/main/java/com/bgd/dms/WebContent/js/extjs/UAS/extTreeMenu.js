UASTreeLoader = function(config) {
	UASTreeLoader.superclass.constructor.call(this, config);
}
//重写treeloader，前后台节点数据转换在此完成。
Ext.extend(UASTreeLoader, Ext.tree.TreeLoader, {
			processResponse : function(response, node, callback) {
				var json = Ext.util.JSON.decode(response.responseText);
				try {
					node.beginUpdate();
					for (var i = 0, len = json.nodes.length; i < len; i++) {
						var attr = new Object();
						attr.id = json.nodes[i].id;
						attr.text = json.nodes[i].name;
						attr.parentId = node.attributes.id;
						attr.iconCls = 'nodeIcon';
						if (json.nodes[i].isLeaf == '1') {
							attr.leaf = true;
							attr.iconCls = 'leafnodeIcon';
						} else {
							attr.leaf = false;
						}
						var n = this.createNode(attr);
						if (n) {
							node.appendChild(n);
						}
					}
					node.endUpdate();
					if (typeof callback == "function") {
						callback(this, node);
					}
				} catch (e) {
					this.handleFailure(response);
				}
			}
		});

function createTree(url, renderToDiv, rootID,items) {
	Ext.onReady(function() {
		var tree = new Ext.tree.TreePanel({
			renderTo : renderToDiv,
			root : new Ext.tree.AsyncTreeNode({
						id : rootID,
						text : "根节点名称，默认不显示",
						expanded : true
					}),
			rootVisible : false,
			height : document.body.clientHeight,
			loader : new UASTreeLoader({
						url : url,
						listeners : {
							"beforeload" : function(treeLoader, node) {
								treeLoader.baseParams.parentId = node.attributes.id;
							}
						}
					}),
			//从该处开始，实现相关右键菜单功能。
			contextMenu : new Ext.menu.Menu({
						//开始列出右键菜单项
						items : items,
						listeners : {
							itemclick : contextmenuFun

						}
					}),
			listeners : {
				contextmenu : function(node, e) {
					node.select();
					var c = node.getOwnerTree().contextMenu;
					c.contextNode = node;
					c.showAt(e.getXY());
					if(!node.isLeaf()){
           				 c.items.get('delete').setDisabled(true);
           				 c.items.get('function').setDisabled(true);
           				  c.items.get('add').setDisabled(false);
        			}
        			if(node.isLeaf()){
          			 	 c.items.get('delete').setDisabled(false);
          			 	 c.items.get('function').setDisabled(false);
          			 	 c.items.get('add').setDisabled(true);
        			}
				}
			}
		});
		//自动展开所有节点
		//tree.expandAll();
	}
	);
}
