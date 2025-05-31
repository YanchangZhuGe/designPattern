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
						// �Ѿ�ӵ�е�Ȩ�޵�Ӧ��ϵͳ��֯������hint����1.����Ϊ0,ͬʱ����node.
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
						text : "���ڵ����ƣ�Ĭ�ϲ���ʾ",
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

		// �ڸô������ڵ�չ������������Ҫ��ѡ�Ľڵ����ͼ�ꡣ
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
				// ��ʼ�жϸýڵ�ĸ��ڵ㣬���򱾽ڵ��ѡ��״̬�ı���ɵĸ��ڵ�ȫѡ���ѡ�����ĸ��ڵ�ͼ��
				var bool = 0;
				for (var i = 0; i < node.childNodes.length; i++) {
					if (node.childNodes[i].attributes.UASchecked == '2') {
						bool++;
					} else if (node.childNodes[i].attributes.UASchecked == '1') {
						// ���¼��ڵ��а�ѡ�Ļ���bool����0.5
						bool = bool + 0.5;
					}
				}
				// boolΪ0����ʱ˵��ͬ���ڵ㶼δѡ
				if (bool == 0) {
					// ȥ�����ڵ�ѡ�б�־,����UASchecked��0.
					try {
						node.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check0.gif";
					} catch (e) {
					}
					node.attributes.UASchecked = '0';
					// boolΪͬ���ڵ���������ʱ˵��ͬ���ڵ��ѡ
				} else if (bool == node.childNodes.length) {
					// ѡ�ϸ��ڵ�ѡ�б�־,����UASchecked��2.
					try {
						node.getUI().getIconEl().src = "../../js/extjs/resources/images/UAS/check2.gif";
					} catch (e) {
					}
					node.attributes.UASchecked = '2';

				} else {
					// boolΪ����ͬ���ڵ���������ʱ˵�����ڵ��ѡ
					node.attributes.UASchecked = '1';
					// ��UASchecked��1.
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