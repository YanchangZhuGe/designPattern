var tree;
UASTreeLoader = function(config) {
	UASTreeLoader.superclass.constructor.call(this, config);
}
// 重写treeloader，前后台节点数据转换在此完成。
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
					text : "增加配件类别"
				};
		var mdelete = {
					id : 'mdelete',
					iconCls : "mdelIcon",
					text : "删除配件类别"
				};
		var mmodify = {
					id : 'mmodify',
					iconCls : "meditIcon",
					text : "修改配件类别"
				};
		var fadd = {
					id : 'fadd',
					iconCls : "faddIcon",
					text : "增加功能"
				};
		var fmodify = {
					id : 'fmodify',
					iconCls : "feditIcon",
					text : "修改功能"
				};
		var fdelete = {
					id : 'fdelete',
					iconCls : "fdelIcon",
					text : "删除功能"
				};
				
		tree = new Ext.tree.TreePanel({
			enableDD: true,
			renderTo : renderToDiv,
			autoScroll:true,
			root : new Ext.tree.AsyncTreeNode({
						id : rootID,
						text : "配件类别树",
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
								treeLoader.baseParams.currentPage = "1";
								treeLoader.baseParams.pageSize = "100";
								    var sql = 
								    	"select t.id              as node_id,\n" +
								    	"       t.part_name       as node_name,\n" + 
								    	"       CONNECT_BY_ISLEAF as is_leaf,\n" + 
								    	"       0                 as node_type\n" + 
								    	"  from GMS_DEVICE_PART_TREE t \n" +  
								    	"WHERE t.bsflag ='0' and T.PARENT_ID = '"+node.attributes.id+"'" +
								    	" start with parent_id = '"+node.attributes.id+"'\n" + 
								    	"connect by parent_id = prior id "; 
								    treeLoader.baseParams.querySql = sql; 
								    //}
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
										if (n.parentNode || n.attributes.id=="INIT_REPAIR_012345678900000") {
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
					if(mId !="INIT_REPAIR_012345678900000"){
					parentId = node.parentNode.attributes.id;}
					node.select();
					var c = node.getOwnerTree().contextMenu;
					//清除所有旧的菜单项，同时根据节点相关属性增加新的菜单项
					c.removeAll();
					c.contextNode = node;
				
					if ((!node.isLeaf()) && level == '0'&& node.attributes.id!="INIT_REPAIR_012345678900000") {
						//c.add(madd,mdelete,mmodify);
						c.add(madd,mdelete,mmodify);
					} 
					if (node.attributes.id=="INIT_REPAIR_012345678900000") {
						c.add(madd);
					}
					if ((!node.isLeaf()) && level == '1') {
						//c.add(fadd,mdelete,mmodify);
						c.add(madd,mdelete,mmodify);
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
		tree.addListener('click', leafClick);
		 
		// 自动展开所有节点
		//tree.expandAll();
	});
}
