<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String month_no = request.getParameter("month_no");
	String org_sub_id = request.getParameter("org_sub_id");
	String record_id = request.getParameter("record_id");
	String action = request.getParameter("action"); 
	String org_name = request.getParameter("org_name");
    String subflag= request.getParameter("subflag");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
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
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'Name', type : 'String'},
            {name : 'url',type: 'string'},
    		{name : 'leaf'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: 'menu_tree.json',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
        title: '菜单',//树的标题
        width: 240,//document.body.clientWidth*0.8,
        height: document.body.clientHeight, 
        autoHeight: true,//自动高度
        lines: true,
        renderTo: 'menuTree',//绘制的区域
        collapsible: true,
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
            text: '名字',
            flex: 1,
            hideable:false,
            dataIndex: 'Name',
            align: 'left'
        }]
    });
    //debugger;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var leaf = rowdata.data.leaf;
        var url = rowdata.data.url;
        if(leaf == true){
        	debugger;
         
        	parent.mainRightframe.location.href = "<%= contextPath%>/hse/hseOptionPage/hseMonthlyReport/"+url+"?month_no=<%=month_no %>&org_sub_id=<%=org_sub_id %>&record_id=<%=record_id %>&action=<%=action%>&org_name=<%=org_name%>&subflag=<%=subflag%>";
  		 
        }
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