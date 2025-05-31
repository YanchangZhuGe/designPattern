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
.maddIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/add.png) !important;
}

.mdelIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/del.png) !important;
}

.meditIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/edit.png) !important;
}

.faddIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/plugin_add.png) !important;
}

.fdelIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/plugin_delete.png) !important
		;
}

.feditIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/plugin_edit.png) !important;
}

.nodeIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/leaf.gif) !important;
}

.menuLeafNodeIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/menu_leaf.gif) !important;
}

.fNodeIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/func.png) !important;
}
</style>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript">
	var mId;
	var name;
	var level;
	var hint;
	var parentId="";
	function doInsert() {
		if (mId == null) {
			alert("请先选中一个节点");
			return;g
		}
		if(level==0){

			path = "<%=contextPath%>/ibp/auth2/menu/menu.upmd?pagerAction=edit2Add&lineRange=1&noCloseButton=true&parent_menu_id="+mId;
		}else{
			path = "<%=contextPath%>/ibp/auth2/func/func.upmd?pagerAction=edit2Add&lineRange=1&noCloseButton=true&menu_id="+mId+"&menu_name="+name;
		}
		parent.menuFrame.location.href = path;
	}
	
	function doUpdate() {
		if (mId == null) {
			alert("请先选中一个节点");
			return;
		}
		if(hint== 0){
			path = "<%=contextPath%>/ibp/auth2/menu/menu.upmd?pagerAction=edit2Edit&lineRange=1&noCloseButton=true&id="+mId;
		}else{
		
			path = "<%=contextPath%>/ibp/auth2/func/func.upmd?pagerAction=edit2Edit&lineRange=1&noCloseButton=true&id="+mId+"&menu_id="+parentId;
		}
		parent.menuFrame.location.href = path;
	}
	
	function doDelete() {
	if (mId == null) {
		alert("请先选中一个节点");
		return;
	}
	if(!window.confirm("确认要删除")){
		return;
	}
	var u;
	if(hint == 0){
		u = '<%=contextPath%>/ibp/auth2/deleteMenu.srq?menuId='+mId;
	}else{
		u = '<%=contextPath%>/ibp/auth2/deleteFunc.srq?funcId='+mId;
	}
	Ext.Ajax.request({
	   url: u,
	   success: function(oResponse){
	   var retObject = eval('(' + oResponse.responseText + ')');
					if (retObject.returnCode == "0") { 
		         		alert("提交成功");
		         	} else {
		         		alert("提交失败");
		         	}
		         	//var path = "/ea/module/addModule.jsp";
		         	//parent.treeFrame.location.href = path; 
					//chosedOrgName="";
	   },
	   failure: function(){},
	   params: { moduleId: mId }
	});
		return true;
	}

	function referesh() {
		location.href="<%=contextPath%>/ibp/auth2/menu/menu.jsp?treePage=1";
		
	}
	
	createTree('<%=contextPath%>/rad/asyncQueryList.srq',"menuTree","INIT_AUTH_MENU_012345678900000");//


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
						text : "增加菜单"
					};
			var mdelete = {
						id : 'mdelete',
						iconCls : "mdelIcon",
						text : "删除菜单"
					};
			var mmodify = {
						id : 'mmodify',
						iconCls : "meditIcon",
						text : "修改菜单"
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
				 tbar:[' ',  
			                    new Ext.form.TextField({  
			                        width:150,  
			                        emptyText:'快速检索',  
			                        enableKeyEvents: true,  
			                        listeners:{  
			                            keyup:function(node, event) {  
			                                findByKeyWordFiler(node, event);  
			                            },  
			                            scope: this  
			                        }  
			                    })  
			                ],  
				root : new Ext.tree.AsyncTreeNode({
							id : rootID,
							text : "菜单树",
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
						//清除所有旧的菜单项，同时根据节点相关属性增加新的菜单项
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

			   var treeFilter = new Ext.tree.TreeFilter(tree, {  
		                clearBlank : true,  
		                autoClear : true  
		            });  
			var timeOutId = null;  
			// 保存上次隐藏的空节点  
		        var hiddenPkgs = [];  
		        var findByKeyWordFiler = function(node, event) {  
		            clearTimeout(timeOutId);// 清除timeOutId  
		            tree.expandAll();// 展开树节点  
		            // 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup  
		            timeOutId = setTimeout(function() {  
		                // 获取输入框的值  
		                var text = node.getValue();  
		                // 根据输入制作一个正则表达式，'i'代表不区分大小写  
		                var re = new RegExp(Ext.escapeRe(text), 'i');  
		                // 先要显示上次隐藏掉的节点  
		                Ext.each(hiddenPkgs, function(n) {  
		                    n.ui.show();  
		                });  
		                hiddenPkgs = [];  
		                if (text != "") {  
		                    treeFilter.filterBy(function(n) {  
		                        // 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示  
		                        return !n.isLeaf() || re.test(n.text);  
		                    });  
		                    // 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉  
		                    tree.root.cascade(function(n) {  
		                        if(n.id!='0'){  
		                            if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){  
		                                hiddenPkgs.push(n);  
		                                n.ui.hide();  
		                            }  
		                        }  
		                    });  
		                } else {  
		                    treeFilter.clear();  
		                    return;  
		                }  
		            }, 500);  
		        }  
		        // 过滤不匹配的非叶子节点或者是叶子节点  
		        var judge =function(n,re){  
		            var str=false;  
		            n.cascade(function(n1){  
		                if(n1.isLeaf()){  
		                    if(re.test(n1.text)){ str=true;return; }  
		                } else {  
		                    if(re.test(n1.text)){ str=true;return; }  
		                }  
		            });  
		            return str;  
		        };  
			// 自动展开所有节点
			//tree.expandAll();
		});
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