UASTreeLoader = function(config) {
	UASTreeLoader.superclass.constructor.call(this, config);
}
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
						// 已经拥有的权限的应用系统组织机构节hint点置1.否则为0,同时传给node.
						attr.UASchecked = json.nodes[i].hint;
						attr.iconCls = 'nodeIcon';
						if (json.nodes[i].isLeaf == '1') {
							attr.leaf = true;
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
		tree = new Ext.tree.TreePanel({
			renderTo : renderToDiv,
			root : new Ext.tree.AsyncTreeNode({
						id : rootID,
						text : "根节点名称，默认不显示",
						expanded : true
					}),
			rootVisible : false,
			autoScroll:true,
			height : document.body.clientHeight - 80,
			loader : new UASTreeLoader({
						url : url,
						listeners : {
							"beforeload" : function(treeLoader, node) {
								treeLoader.baseParams.parentId = node.attributes.id;
							}
						}
					})
		});

		// 在该处监听节点展开方法，将需要复选的节点更换图标。
		tree.on('expandnode', function(node) {
			if (node.attributes.UASchecked == '1') {
				try {
					node.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check2.gif";
				} catch (e) {
				}
			}
		});
		tree.expandAll();
		tree.on('click', function(node) {
			if (node.attributes.UASchecked == '2') {
				node.attributes.UASchecked = '0';
			} else {
				node.attributes.UASchecked = '2';
			}
			if (node.attributes.UASchecked == '2') {
				try {
					node.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check2.gif";
				} catch (e) {
				}
			} else {
				try {
					node.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check0.gif";
				} catch (e) {
				}
			}
			childFunc(node);
			parentFunc(node.parentNode);
			function parentFunc(node) {
				// 开始判断该节点的父节点，若因本节点的选中状态改变造成的父节点全选或半选，更改父节点图标
				var bool = 0;
				for (var i = 0; i < node.childNodes.length; i++) {
					if (node.childNodes[i].attributes.UASchecked == '2') {
						bool++;
					} else if (node.childNodes[i].attributes.UASchecked == '1') {
						// 若下级节点有半选的话，bool自增0.5
						bool = bool + 0.5;
					}
				}
				// bool为0，此时说明同级节点都未选
				if (bool == 0) {
					// 去掉父节点选中标志,并将UASchecked置0.
					try {
						node.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check0.gif";
					} catch (e) {
					}
					node.attributes.UASchecked = '0';
					// bool为同级节点数量，此时说明同级节点均选
				} else if (bool == node.childNodes.length) {
					// 选上父节点选中标志,并将UASchecked置2.
					try {
						node.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check2.gif";
					} catch (e) {
					}
					node.attributes.UASchecked = '2';

				} else {
					// bool为不足同级节点数量，此时说明父节点半选
					node.attributes.UASchecked = '1';
					// 将UASchecked置1.
					try {
						node.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check2.gif";
					} catch (e) {
					}
				}
				if (node.parentNode != null) {
					parentFunc(node.parentNode);
				}

			}
			function childFunc(node) {
				node.eachChild(function(child) {
					var checked = child.parentNode.attributes.UASchecked;
					child.attributes.UASchecked = checked;
					childFunc(child);
					if (checked == 2) {
						try {
							child.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check2.gif";
						} catch (e) {
						}

					} else {
						try {
							child.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check0.gif";
						} catch (e) {
						}

					}
				});
			}
		});

	}

	);
}