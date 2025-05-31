<%@ page language="java" contentType="text/html;charset=utf-8"
	pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<html>
<head>

<title>菜单管理</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta http-equiv="expires" content="0" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/js/extjs/UAS/css/patch.css" />
<style type="text/css">
	.save {
		background: url(<%=contextPath%>/js/extjs/resources/images/menu/save.png) no-repeat !important;
	}
	.refresh {
		background: url(<%=contextPath%>/js/extjs/resources/images/menu/refresh.png) no-repeat !important;
	}
</style>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript">
	var _path="<%=contextPath%>";
	
	
	Ext.ns("ibp.menu");
	ibp.menu.MenuTreeLoader = Ext.extend(Ext.tree.TreeLoader, {
				checkVisible : undefined,
				processResponse : function(response, node, callback) {
					var json = response.responseText;
					try {
						var o = eval("(" + json + ")").nodes || eval("(" + json + ")") || [];
						if( !o || o["returnCode"] == -9){
							Ext.Msg.alert("提示",o["returnMsg"],function(){
								top.location.href = _path+"/login.jsp";
							});
						}
						node.beginUpdate();
						for (var i = 0, len = o.length; i < len; i++) {
							var n = this.createNode(o[i]);
							if (n) {
								this._buildChildNodes(n);
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
				},
				_buildChildNodes : function(node){
					if(node.attributes.children.length > 0){
						for(var i = 0 , cn = node.attributes.children ,len = cn.length ; i < len ; i++){
							var childNode = this.createNode(cn[i]);
							node.appendChild(childNode);
							if(cn[i].children && cn[i].children.length > 0){
								this._buildChildNodes(childNode);
							}
						}
					}
					node.loaded = true; 	
				},
				
				createNode : function(attr) {
					this._addNodeIcon(attr);
					if (this.checkVisible === true) {
						if(attr.checked === null){
							attr.checked = undefined;
						}else if(attr.checked == undefined){
							attr.checked = false;
						}
					} else if (this.checkVisible === false) {
						attr.checked = undefined;
					} else {
						if (attr.checked === null){
							attr.checked = undefined;
						}else if(attr.checked === undefined){
							attr.checked = false;
						}
					}
					if(this.hideCheck == "true"){
						if(attr.checked == true || attr.id == "root"){
							attr.checked = undefined;
						}else if(attr.id != "root"){
							attr.hidden = true;
						}
					}
					var node =  ibp.menu.MenuTreeLoader.superclass.createNode.call(this,attr);
					return node;
				},
				_addNodeIcon : function(attr){
					if(attr.type == "2"){
						attr.icon = _path+"/js/extjs/UAS/images/func.png";
					}else if(attr.type == "1"){
						if(attr.data.IS_LEAF == "1"){
							attr.icon = _path+"/js/extjs/UAS/images/menu_leaf.gif";
						}else{
							attr.icon = _path+"/js/extjs/UAS/images/leaf.gif";
						}
					}
				}
			});
	ibp.menu.treePanel = Ext.extend(Ext.tree.TreePanel, {
		autoScroll : true,
		animate : true,
		containerScroll : true,
		constructor : function(config){
			Ext.applyIf(config,{
				type : '3',//3-user
				id : 'INIT_AUTH_ORG_012345678900000',//机构的默认值
				url : _path+"/ibp/auth2/getCollMenuTreeData.srq"
			});
			ibp.menu.treePanel.superclass.constructor.call(this,config);
		},
		initComponent : function() { 
			var scope = this;
			this.root = {
				id : 'root',
				text : '菜单树',
				nodeType : 'async',
				expanded : true
			};
			if(this.checkVisible == "false"){
				this.checkVisible = false;	
			}
			if(this.edit == "true" || this.edit == null){
				this.tbar = ['->',{
				xtype : 'button',
				id : 'refresh',
				iconCls : 'refresh'
				,handler : function(b,e){
								scope.getLoader().load(scope.getRootNode(),function(loader,node){
									node.expand(false,true);
								});
						   }
				},'-',{
					xtype : 'button',
					iconCls : 'save',
					id : 'save'
					,listeners : { 
						'click' : function(b,e){
							var updateNodes = this._getUpdateNode(this.getRootNode());
							Ext.getBody().mask("保存中,请等待...","x-mask-loading");
							Ext.Ajax.request({
								url : _path+"/ibp/auth2/saveCollMenuTreeData.srq",
								params : Ext.urlEncode({
									type : this.type,
									id : this.id,
									nodes : Ext.util.JSON.encode(updateNodes)
								}),
								success : function(){
									Ext.getBody().unmask();
									parent.menuFrame.location.reload();
									window.location.reload();
									
								},
								failure : function(){
									
								}
							});
						},
						scope : this
					}
				}];
			}				
			this.loader = new ibp.menu.MenuTreeLoader({
						checkVisible : this.checkVisible,
						hideCheck : this.hideCheck,
						baseAttrs : {nodeType : 'node'}
						,url : this.url
					});
			ibp.menu.treePanel.superclass.initComponent.call(this);
			this.loader.on('load',this._afterload,this);
			this.on("expandnode",function(node){
				this._initTreeUI(node);
				if(node.isRoot){
					var flag = true;
					node.eachChild(function(node){
						if(node.hidden == false){
							flag = false;
							return false;
						}
					});
					if(flag){
						node.getUI().hide();
					}
				}
			},this);
			this.on("contextmenu",this._contextmenu,this);
			this.on("click",function(node,e){e.stopEvent();},this);
			this.loader.on('beforeload',this._beforeload,this);
		},
		_contextmenu : function(node,e){
			e.preventDefault(); 
			node.select();
		},
		_getUpdateNode : function(node,arr){
			var arr = arr || [];			
			for(var i = 0 , cn = node.childNodes , len = cn.length ; i < len ; i++){
					this._getUpdateNode(cn[i],arr);
			}
			if(node.attributes.orgChecked !== undefined && (node.attributes.orgChecked ^ node.attributes.checked) && node.parentNode){
				arr.push({id : node.id,checked : node.attributes.checked,type : node.attributes.type,parentid : node.parentNode.id});
			}
			return arr;
		},
		_beforeload : function(treeloader,node){
			treeloader.baseParams.type = this.type;
			treeloader.baseParams.id = this.id;
		},
		_afterload : function(loader,node,response) {
			this._initTreeUI(node);
			this.on("checkchange", this._checkchange, this);
			if(node.hidden == true && this.type == "1"){
				Ext.Msg.alert("注意","此机构没有机构功能集");
			}
		},
		_initTreeUI : function(node) {
			var leafChildNodes = this._getAllLeafChildNodes(node);
			for(var i = 0 , arr = leafChildNodes ;i < arr.length ; i++){
				this._bubble(arr[i],arr[i].attributes.checked);
			}
		},
		_getAllLeafChildNodes : function(node,arr){
			var arr = arr || [];
			for(var i = 0,cs = node.childNodes,len = cs.length;i < len ; i++){
					this._getAllLeafChildNodes(cs[i],arr);
			}
			if(node.isLeaf()){
				node.attributes.orgChecked = node.attributes.checked;
				arr.push(node);
			}
			return arr;
		},
		_checkchange : function(node, checked) {
			this._cascade(node,checked);
			this._bubble(node,checked);
		},
		_cascade : function(n,checked){
			if(n.ui.checkbox){
				n.ui.checkbox.indeterminate = false;
				n.ui.checkbox.checked = checked;
			}
			n.attributes.checked = checked;
			n.attributes.checkState = checked ? "2" : "0";
			if(n.childNodes.length > 0){
				var cs = n.childNodes;
				for(var i = 0 , len = cs.length ; i < len ; i++){
					this._cascade(cs[i],checked);
				}
			}
		},
		_bubble : function(node,checked){
			var n = node.parentNode;
			while(n){
				var nodes = n.childNodes,
					len = nodes.length;
					ch = true;
				for(var i = 0 ;i < len ; i++){
					if(nodes[i].ui.hidden){
						continue;
					}
					if((nodes[i].attributes.checked !== undefined && nodes[i].attributes.checked != checked) || (nodes[i].ui.checkbox && nodes[i].ui.checkbox.indeterminate)){
						ch = false;
						break;
					}
				}
				if(n.attributes.checked !== undefined){
					if(n.ui.checkbox){
						if(ch){
							n.ui.checkbox.checked = checked;
							n.ui.checkbox.indeterminate = false;
						}else{
							n.ui.checkbox.indeterminate = true;
							n.ui.checkbox.checked = true;
						}					
					}
					if(ch){
						n.attributes.checked = checked;
						n.attributes.checkState = checked ? "2" : "0";
					}else{
						n.attributes.checkState = "1";
						n.attributes.checked = true;	
					}
				}
				n.attributes.orgChecked !== undefined || (n.attributes.orgChecked = n.attributes.checked);
				n = n.parentNode; 
			}
		}
	});
Ext.reg("ibp.menu.treepanel",ibp.menu.treePanel);
	function createTree(url, renderToDiv, rootID) {
		var treeConfig = Ext.urlDecode(location.search.substring(1));
		//treeConfig 可以写上自定义的属性，覆盖treepanel的默认属性
		var menuTree = new ibp.menu.treePanel(treeConfig);
		new Ext.Viewport({
			items : [menuTree],
			layout : 'fit'
		});
	}
	
	createTree('',"menuTree","INIT_AUTH_MENU_012345678900000");//
	
	   
	</script>
<script type="text/javascript">
function addColl(){
	if(collNoteId==undefined){
		alert("请选择叶子节点");
	}else {
		alert("test collId="+collNoteId+"==name="+collNoteName);
		path='<%=contextPath%>/ibp/auth2/insertCollection.srq?menu_id='+collNoteId;
		parent.menuFrame.location.href = path;
	}
}
</script>
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0" id="FilterLayer"
	width="100%">
	<tr>
		<td align="left">
		<div id="menuTree" style="width: 100%; height: 100%; overflow: auto;"></div>
		</td>
		
	</tr>
</table>
</body>
</html>