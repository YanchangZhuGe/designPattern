<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"></link>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<script type="text/javascript" language="javascript">
cruConfig.contextPath =  "<%=contextPath%>";
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
Ext.onReady(function() {
  Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'id',type: 'string'},
            {name : 'name', type : 'String'}
        ]
    });
    
    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/common/portlet/tree.json',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        title: '',
        width: 310,
        height: document.body.clientHeight, 
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: true,
        animate : false, 
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        //resizable:true,
        //tbar: tbar,
        columns: [{
            xtype: 'treecolumn',
            text:'portlet分类',
            flex: 2,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        }]
    });
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var id = rowdata.data.id;
        var name = rowdata.data.name;
        parent.menuFrame.refreshData(id, name);
    }
    var category_id = "";
    var category_name = "";
    var parent_category_id = "";
	var parent_category_name = "";
    var rightClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [
	    		{
	    			text:"新增编码",
	    			handler:function(grid ,e){
	    				popWindow(cruConfig.contextPath+"/common/portlet/categoryEdit.jsp?parent_category_id="+category_id+"&parent_category_name="+category_name,'','新增');
	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"编辑编码",
	    			handler:function(grid, e){
	    				popWindow(cruConfig.contextPath+"/common/portlet/categoryEdit.jsp?parent_category_id="+parent_category_id+"&parent_category_name="+parent_category_name+"&category_id="+category_id,'','修改');
	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"删除编码",
	    			handler:function(grid,e){
	    				var sql = "delete from bgp_comm_portlet_category_dms t where t.category_id='"+category_id+"';";
	    				var retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+sql);
	    				if(retObj!=null && retObj.returnCode=='0'){
	    					alert("删除成功!")
	    					refreshTree(parent_category_id);
	    					
	    				}
	    			}
	    		}
	    	]
    });
    var rootClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [
	    		{
	    			text:"新增编码",
	    			handler:function(grid ,e){
	    				popWindow(cruConfig.contextPath+"/common/portlet/categoryEdit.jsp?parent_category_id="+category_id+"&parent_category_name="+category_name,'','新增');
	    			}
	    		}
	    	]
    });
    //grid.addListener('itemcontextmenu', rightClickFn);//右键菜单代码关键部分
    function rightClickFn(grid,rowdate, item, rowindex, e) {
    	category_id = rowdate.data.id;
    	category_name = rowdate.data.name;
    	parent_category_id = rowdate.parentNode.data.id;
    	parent_category_name = rowdate.parentNode.data.name;
    	e.preventDefault();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		e.stopEvent();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		if(category_id !=null && category_id =='ROOT'){
			rootClick.showAt(e.getXY());//显示位置 或者rightClick.show();//显示位置 
		}else{
			rightClick.showAt(e.getXY());//显示位置 或者rightClick.show();//显示位置 
		}
    }
});
function refreshTree(category_id){
	var node = Ext.getCmp('gridId').getStore().getNodeById(category_id);
	var options ={node:node};
	Ext.getCmp('gridId').getStore().load(options);
}
</script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
		</td>
	</tr>
</table>

</body>