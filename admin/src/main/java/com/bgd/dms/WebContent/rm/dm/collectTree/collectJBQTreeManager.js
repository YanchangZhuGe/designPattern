Ext.BLANK_IMAGE_URL = _path + "/js/extjs/resources/images/default/s.gif";
Ext.ns("gms3.collectdevice.treePanel");
var ns = gms3.collectdevice.treePanel;
	ns.rootId = "root";
    ns.windowParentName = "list";
	ns.parentRightFrame = "mainRightframe";
	ns.parentLeftFrame = "mainleftframe";
gms3.collectdevice.treePanel = Ext.extend(Ext.tree.ColumnTree, {
	title : '检波器类型',
	containerScroll : true,
	animate : true,
	autoScroll : true,
	initComponent : function() {
		this.columns = [{
					header : '设备名称',
					dataIndex : 'dev_name',
					width : 276
				}, {
					header : '设备型号',
					dataIndex : 'dev_model',
					width : 75
				}];
		this.root = new Ext.tree.AsyncTreeNode({
					id : ns.rootId,
					text : '检波器类型',
					dev_name : '',
					node_level : '',
					dev_code : '',
					dev_id : '',
					is_leaf : '1',
					expanded : true
				});
		this.on('contextmenu', this._addContextMenu);
		this.on('click',this._clickHandler);
		this.loader = new Ext.tree.TreeLoader({
					dataUrl : _path	+ "/rm/dm/collectTree/collectJBQTreeManager.srq",
					baseAttrs : {
						uiProvider : 'col'
					},
					baseParams : {
						reqType : this.reqType
					},
					uiProviders : {
						'col' : Ext.tree.ColumnNodeUI
					}
				});
		gms3.collectdevice.treePanel.superclass.initComponent.call(this);
	},
	_clickHandler : function(node,e){
		if(this.ctxmenu == false ){
			if(ns.windowParentName == window.parent.name){
				parent[ns.parentRightFrame].location.href = _path+"/rm/dm/collectTree/collectDeviceAccList.jsp?device_id="+node.id;
			}else if(this.inline == true){
				if(node.attributes.leaf == true){
					window.returnValue = node.attributes;
					window.close();
//					var w = window , target = null;
//					while(w != w.parent && (target = w.callback) == null){
//						w = w.parent;
//					}
//					if(target != null){
//						target.call(this,node.attributes);
//					}
				}
			}
		}
	},
	_addContextMenu : function(node, e) {
		node.select();
		if (this.ctxmenu == true) {
			var menu = new Ext.menu.Menu({
						items : [{
									text : '新增',
									id : 'add'
								}, {
									text : '修改',
									id : 'modify'
								}, {
									text : '删除',
									id : 'delete'
								}],
						listeners : {
							itemclick : function(item) {
								var node = item.parentMenu.contextNode;
								switch (item.id) {
									case 'add' :
										this._addNode(item, e, node);
										break;
									case 'modify' :
										this._modifyNode(item, e, node);
										break;
									case 'delete' :
										this._deleteNode(item, e, node);
										break;
								}
							},
							scope : this
						}
					});
			if (node.isRoot) {
				menu.items.each(function(item, index, length) {
							if (item.id != 'add') {
								item.disable();
							}
						});
			} else if (node.isLeaf() && node.attributes.node_level >= 2) {
				menu.items.get('add').disable();
			}
			menu.contextNode = node;
			menu.showAt(e.getXY());
		}

	},
	_addNode : function(item, e, node) {
		if (node.id == null) {
			top.Ext.Msg.alert("注意", "请先选择节点");
		} else {
			var att = node.attributes;
			var href = _path
					+ "/rm/dm/collectTree/collectDevice.jsp?pageAction=add&parent_device_id="+node.id+"&parent_dev_code="+att.dev_code+"&node_level="
					+ (att.node_level-0+1);
			parent[ns.parentRightFrame].location.href = href;
		}
	},
	_modifyNode : function(item, e, node) {
		if (node.id == null) {
			top.Ext.Msg.alert("注意", "请先选择节点");
		} else {
			var att = node.attributes,parAttr = node.parentNode.attributes;
			var href = _path
					+ "/rm/dm/collectTree/collectDevice.jsp?pageAction=modify&device_id="
					+ node.id+ "&node_level="+att.node_level+"&dev_code="+att.dev_code+"&parent_dev_code="+parAttr.dev_code;
			parent[ns.parentRightFrame].location.href = href;
		}
	},
	_deleteNode : function(item, e, node) {
		var t = [];
		if(node.attributes["is_delete"] === "false"){
			t.push(node.text);
		}
		if(t.length > 0 ){
			top.Ext.Msg.alert("注意","<font color='red'>"+t.join(",")+"</font>有台账信息,无法删除");
			return;
		}
		var msg = '确定要删除<font color="red">' + node.text + "</font>吗?";
		if (!node.isLeaf()) {
			msg += "<font color='red'>该类型下的所有设备都会删除</font>";
		}
		top.Ext.Msg.confirm("注意", msg, function(btn) {			
			if(btn == 'yes'){
				top.Ext.getBody().mask("操作中,请等待...", "x-mask-loading");
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
				top.Ext.getBody().unmask();
				if (retObject["returnCode"] != 0) {
					top.Ext.Msg.alert("错误", "操作失败,<font color='red'>"
									+ retObject["returnMsg"] + "</font>");
				}else{
					window.location.reload();
				}
			}
		}, this);
	}
});
Ext.onReady(function() {
			Ext.QuickTips.init();
			
				treeConfig = Ext.urlDecode(location.search.substring(1));
			for(var i in treeConfig){
				if(treeConfig[i] === "true"){
					treeConfig[i] = true;
				}else if(treeConfig[i] === "false"){
					treeConfig[i] = false;
				}
			}
			//reqType表示异步和同步，ctxmenu表示是否显示右键菜单,inline表示页面被嵌入,当选中节点后，需要向父组件传值
			var treePanel = new gms3.collectdevice.treePanel(Ext.applyIf(
					treeConfig, {
						reqType  : 'sync',
						ctxmenu  : true,
						inline   : false
					}));
			new Ext.Viewport({
						items : [treePanel],
						layout : 'fit'
					});
		})