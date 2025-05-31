UASTreeLoader = function(config) {
	UASTreeLoader.superclass.constructor.call(this, config);
}
// 重写treeloader，前后台节点数据转换在此完成。
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
						attr.hint = json.nodes[i].hint;
						attr.url = json.nodes[i].url;
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
function createTree(url, renderToDiv, rootID) {
	Ext.onReady(function() {
		var madd = {
					id : 'madd',
					iconCls : "maddIcon",
					text : '增加模块'
				};
		var mdelete = {
					id : 'mdelete',
					iconCls : "mdelIcon",
					text : '删除模块'
				};
		var mmodify = {
					id : 'mmodify',
					iconCls : "meditIcon",
					text : '修改模块'
				};
		var fadd = {
					id : 'fadd',
					iconCls : "faddIcon",
					text : '增加功能'
				};
		var fmodify = {
					id : 'fmodify',
					iconCls : "feditIcon",
					text : '修改功能'
				};
		var fdelete = {
					id : 'fdelete',
					iconCls : "fdelIcon",
					text : '删除功能'
				};
				
		var tree = new Ext.tree.TreePanel({
			renderTo : renderToDiv,
			autoScroll:true,
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
			contextMenu : new Ext.menu.Menu({
						items : [],
						listeners : {
							itemclick : function(item) {
								switch (item.id) {
									case 'mdelete' :
										var n = item.parentMenu.contextNode;
										if (n.parentNode && doDelete()) {
											n.remove();
										}
										break;
									case 'madd' :
										var n = item.parentMenu.contextNode;
										if (n.parentNode) {
											doInsert();
										}
										break;
									case 'mmodify' :
										var n = item.parentMenu.contextNode;
										if (n.parentNode) {
											doUpdate();
										}
										break;
									case 'fdelete' :
										var n = item.parentMenu.contextNode;
										if (n.parentNode && doDelete()) {
											n.remove();
										}
										break;
									case 'fadd' :
										var n = item.parentMenu.contextNode;
										if (n.parentNode) {
											doInsert();
										}
										break;
									case 'fmodify' :
										var n = item.parentMenu.contextNode;
										if (n.parentNode) {
											doUpdate();
										}
										break;
								}
							}

						}
					}),
			listeners : {
				contextmenu : function(node, e) {
					mId = node.attributes.id;
					level = node.attributes.hint;
					node.select();
					var c = node.getOwnerTree().contextMenu;
					//清除所有旧的菜单项，同时根据节点相关属性增加新的菜单项
					c.removeAll();
					c.contextNode = node;				
					if ((!node.isLeaf()) && level == '0') {
						c.add(madd,mmodify);
					}
					if ((!node.isLeaf()) && level == '1') {
						c.add(fadd,mdelete,mmodify);
					}
					if (node.isLeaf()) {
						c.add(fdelete,fmodify);
					}
					c.showAt(e.getXY());
				}
			}
		});
		// 自动展开所有节点
		//tree.expandAll();
	});
}
