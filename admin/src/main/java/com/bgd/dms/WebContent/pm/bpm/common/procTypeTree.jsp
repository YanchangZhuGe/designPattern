<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<style type="text/css">
    .task {
        background-image: url(<%=contextPath%>/shared/icons/fam/cog.gif) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/shared/icons/fam/folder_go.gif) !important;
    }
</style>
<script type="text/javascript" language="javascript">
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;

var businessType="";
var configId="";

Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'codingCodeId',type: 'string'},
            {name : 'codingName', type : 'String'},
            {name : 'parentId', type : 'String'},
            {name : 'zip', type : 'String'},
            {name : 'configId', type : 'String'}
            
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/bpm/common/getProcTypeTree.srq',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
        width: document.body.clientWidth,
        height: document.body.clientHeight, 
        autoHeight: true,//自动高度
        lines: true,
        renderTo: 'menuTree',//绘制的区域
        useArrows: true,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        //the 'columns' property is now 'headers'
        columns: [{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            xtype: 'treecolumn',
            text: '类型',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'codingName',
            align: 'left'
        }]
    });
    //debugger;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var record = grid.getStore().getAt(1);   //Get the Record rowIndex.sourceIndex
        var codingCodeId = rowdata.data.codingCodeId;
        parent.mainRightframe.location.href = "<%= contextPath%>/pm/bpm/common/procTypeList.jsp?businessType="+codingCodeId;
    }
    var rightClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [
	    		{
	    			text:"维护流程类型附属信息",
	    			handler:function(){
	    				if(configId==null||configId==undefined||configId==''){
	    					popWindow('<%=contextPath%>/pm/bpm/common/businessWFConfig.upmd?pagerAction=edit2Add&businessType='+businessType);
	    				}else{
	    					popWindow('<%=contextPath%>/pm/bpm/common/businessWFConfig.upmd?pagerAction=edit2Edit&businessType='+businessType+'&id='+configId);
	    				}
	    			}
	    		}
	    	]
    });
    grid.addListener('itemcontextmenu', rightClickFn);//右键菜单代码关键部分
    var id = null;
    var name = null;
    var id_name = null;
    function rightClickFn(grid,rowdate, item, rowindex, e) {
    	businessType = rowdate.data.codingCodeId;
    	configId = rowdate.data.configId;
    	e.preventDefault();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		e.stopEvent();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		rightClick.showBy(item);
    }
});

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