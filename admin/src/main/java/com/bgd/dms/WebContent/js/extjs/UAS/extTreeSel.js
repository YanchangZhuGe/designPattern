UASTreeLoader = function(config) {
	UASTreeLoader.superclass.constructor.call(this, config);
}
//��дtreeloader��ǰ��̨�ڵ�����ת���ڴ���ɡ�
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
		var tree = new Ext.tree.TreePanel({
			renderTo : renderToDiv,
			root : new Ext.tree.AsyncTreeNode({
						id : rootID,
						text : "���ڵ����ƣ�Ĭ�ϲ���ʾ",
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
					})
		});
		//�Զ�չ�����нڵ�
		//tree.expandAll();
		tree.on('dblclick', function(node) {
			orgId=node.id;
			orgName=node.attributes.text;
			doSelect();
		});
	}
	);
}
