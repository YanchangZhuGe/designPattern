var tree;

UASTreeLoader = function(config) {
	UASTreeLoader.superclass.constructor.call(this, config);
}
// ��дtreeloader��ǰ��̨�ڵ�����ת���ڴ���ɡ�
Ext.extend(UASTreeLoader, Ext.tree.TreeLoader, {
			processResponse : function(response, node, callback) {
				var json = Ext.util.JSON.decode(response.responseText);
				try {
					node.beginUpdate();
					for (var i = 0, len = json.datas.length; i < len; i++) {
						var attr = new Object();
						
						attr.id = json.datas[i].node_id;
						attr.text = json.datas[i].node_name;
						attr.parentId = node.attributes.id;
						attr.hint = json.datas[i].node_type;
						attr.menuLeaf = json.datas[i].is_leaf;
						//attr.url = json.datas[i].url;
						attr.iconCls = 'nodeIcon';
						if (json.datas[i].node_type == '1') {
							attr.leaf = true;
							attr.iconCls = 'fNodeIcon';
						} else if (json.datas[i].node_type == '0' && json.datas[i].is_leaf == '1') {
						    attr.leaf = false;
						    attr.iconCls = 'menuLeafNodeIcon';
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
					text : "���Ӳ˵�"
				};
		var mdelete = {
					id : 'mdelete',
					iconCls : "mdelIcon",
					text : "ɾ���˵�"
				};
		var mmodify = {
					id : 'mmodify',
					iconCls : "meditIcon",
					text : "�޸Ĳ˵�"
				};
		var fadd = {
					id : 'fadd',
					iconCls : "faddIcon",
					text : "���ӹ���"
				};
		var fmodify = {
					id : 'fmodify',
					iconCls : "feditIcon",
					text : "�޸Ĺ���"
				};
		var fdelete = {
					id : 'fdelete',
					iconCls : "fdelIcon",
					text : "ɾ������"
				};
				
		tree = new Ext.tree.TreePanel({
			enableDD: true,
			renderTo : renderToDiv,
			autoScroll:true,
			root : new Ext.tree.AsyncTreeNode({
						id : rootID,
						text : "�˵���",
						menuLeaf : "0",
						leaf : false,
						expanded : true
					}),
			rootVisible : true,
			height : document.body.clientHeight,
			loader : new UASTreeLoader({
						url : url,
						listeners : {
							"beforeload" : function(treeLoader, node) {
								//treeLoader.baseParams.parentId = node.attributes.id;
								treeLoader.baseParams.currentPage = "1";
								treeLoader.baseParams.pageSize = "100";
								if (node.attributes.hint == '0' && node.attributes.menuLeaf == '1') {
									treeLoader.baseParams.querySql = "select f.func_id as node_id,f.func_c_name as node_name,1 as is_leaf,1 as node_type from p_auth_function_dms f,p_auth_menu_func_dms mf where f.func_id = mf.func_id and menu_id ='"+node.attributes.id+"'";
								} else {
								    treeLoader.baseParams.querySql = "Select m.menu_id as node_id,m.menu_c_name as node_name,m.is_leaf,0 as node_type FROM P_AUTH_MENU_DMS m WHERE parent_menu_id='"+node.attributes.id+"' ORDER BY order_num desc";
								}
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
										if (n.parentNode || n.attributes.id=="INIT_AUTH_MENU_012345678900000") {
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
					name = node.attributes.text;
					level = node.attributes.menuLeaf;
					hint = node.attributes.hint;
					if(mId !="INIT_AUTH_MENU_012345678900000"){
					parentId = node.parentNode.attributes.id;}
					node.select();
					var c = node.getOwnerTree().contextMenu;
					//������оɵĲ˵��ͬʱ���ݽڵ�������������µĲ˵���
					c.removeAll();
					c.contextNode = node;
				
					if ((!node.isLeaf()) && level == '0'&& node.attributes.id!="INIT_AUTH_MENU_012345678900000") {
						c.add(madd,mmodify);
					} 
					if (node.attributes.id=="INIT_AUTH_MENU_012345678900000") {
						c.add(madd);
					}
					if ((!node.isLeaf()) && level == '1') {
						c.add(fadd,mdelete,mmodify);
					}
					if (node.isLeaf()) {
						c.add(fdelete,fmodify);
					} 

					c.showAt(e.getXY());
				}
				,
				movenode  : function(tree, node, oldParent, newParent, index ) {
					var retuObj = jcdpCallService("IBPLoginAndMenuTree", "moveTreeNodePosition","pkValue="+node.id+"&index="+index+"&newParentId="+newParent.id);
				}
			}
		});
		// �Զ�չ�����нڵ�
		//tree.expandAll();
	});
}
