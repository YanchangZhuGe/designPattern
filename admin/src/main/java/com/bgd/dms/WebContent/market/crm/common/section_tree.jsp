<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String key_id = request.getParameter("key_id");
	if(key_id==null){
		key_id = "";
	}
%>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"></link>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<style type="text/css">
    .x-tree-search {
		background-color: #c3daf9;
	}
	
</style>
<script type="text/javascript" language="javascript">
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var object_id = ''; // 工序ID
var object_name = ''; //工序名称
var rightMenu = null;
var obj = window.dialogArguments;
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
                {name : 'id',type: 'String'},
				{name : 'name', type : 'String'},
				{name : 'short_name', type : 'String'}
             ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        root: {
        	id:'root',
        	name:'油公司类别',
        	short_name:'油公司类别',
            expanded: false
        }, 
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/crm/common/getCompanyTypeTree.srq?divisory_type=2&key_id=<%=key_id%>',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    var tbar = Ext.create("Ext.Toolbar", {
    	width   : 300,
        items: [{
			id:"name",
		    xtype: "textfield",
		    width: 250,
		    emptyText: 'enter search term'
		},
        //{xtype:"tbfill"}, //加上这句，后面的就显示到右边去了 
        {
        	id:"submit",
            xtype: "button",
            text: "搜索",
            width: 40,
       		handler: function (bar,e) {
       			var name = Ext.getCmp('name').value;
       			if(name!=null && name!=''){
       				var ids = search(name);
       				var id = ids.split(';');
       				for(var i=0;i<id.length;i++){
       					var path = id[i];
       					if(path!=null && path!='' && path.lastIndexOf('/')!=-1){
       						var type_id = path.substr(path.lastIndexOf('/')-(-1));
       						var expandPath = path.substring(0,path.lastIndexOf('/'));
       						//Ext.getCmp('gridId').expandPath(expandPath);
           					Ext.getCmp('gridId').expandPath(expandPath,'id','/',function (flag, lastNode){
       							for(var i=0;lastNode.childNodes!=null && i<lastNode.childNodes.length;i++){
       								var child = lastNode.childNodes[i];
       								if(child.data.name.indexOf(name)!=-1 || child.data.short_name.indexOf(name)!=-1){
       									child.expand(false);
       									child.collapse(false);
       									child.data.cls = 'x-tree-search';
       								}
       							}
       						}); 
           					//Ext.getCmp('gridId').selectPath(path,'id','/',function (flag, lastNode){}); 
       					}
       				}
       			}
            }
        }]
    });
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id: 'gridId',
        title: '',
        width: 298,//document.body.clientWidth*0.8,
        height: document.body.clientHeight, 
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: true,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        //tbar: tbar,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn',
            text: '油公司类别',
            flex: 1,
            sortable: true,
            dataIndex: 'short_name',
            align: 'left'
        }]
    });
    //grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var type_id = rowdata.data.id;
        var type_name = rowdata.data.name;
        var type_short_name = rowdata.data.short_name;
        if(type_id!=null && type_id!=''){
        	parent.menuFrame.refreshData(type_id, type_short_name );
        }
    }
    grid.addListener('celldblclick', celldblclick);
    function celldblclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
		var type_id = rowdata.data.id;
		var type_name = rowdata.data.name;
		var type_short_name = rowdata.data.short_name;
       	obj.fkValue = type_id;
       	obj.name = type_name;
       	obj.short_name = type_short_name;
       	window.close();
    }
});

function refreshTree(type_id){
	var node = Ext.getCmp('gridId').getStore().getNodeById(type_id);
	var options ={node:node};
	Ext.getCmp('gridId').getStore().load(options);
}
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
function search(name){
	var retObj = jcdpCallService("ClientRelationSrv","search", "name="+name);
	if(retObj.returnCode =='0'){
		var ids = retObj.ids;
		return ids;
	}
}
</script>
</head>
<body style="overflow-x:hidden;">
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%" style="width:100%;height:100%;overflow:hidden;">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:hidden;"></div>
		</td>
	</tr>
</table>

</body>
</html>