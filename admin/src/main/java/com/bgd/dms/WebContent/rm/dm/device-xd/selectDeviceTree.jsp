<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
    
	String rootuuid = "822447DB8B69FCF51813390621786851";
	
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
            {name : 'DeviceId',type: 'string'},
            {name : 'name', type : 'String'},
      		{name : 'Code', type : 'String'},
    		{name : 'isDeviceCode'},
    		{name : 'isRoot'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/rm/dm/tree/getDeviceTreeInfo.srq',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
        title: '设备编码树',//树的标题
        width: 300,//document.body.clientWidth*0.8,
        height: document.body.clientHeight, 
        autoHeight: true,//自动高度
        lines: true,
        renderTo: 'menuTree',//绘制的区域
        collapsible: true,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        //the 'columns' property is now 'headers'
        columns: [{
            //we must use the templateheader component so we can use a custom tpl
            xtype: 'treecolumn',
            text: '名字',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'code',
            text: '代码',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'Code',
            align: 'center'
        }]
    });
    //debugger;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid, colspan, colIndex, rowdata, rowspan, rowIndex, e) {
        var record = grid.getStore().getAt(1);   //Get the Record rowIndex.sourceIndex
        var isDeviceCode = rowdata.data.isDeviceCode;
        var name = rowdata.data.name;
        var code = rowdata.data.Code;
        var strs= new Array(); //定义一数组
 
		strs=name.split("("); //字符分割
		if(strs[1].length>0){
			var strs2 = new Array();
			strs2 = strs[1].split(")");
		}
        if(isDeviceCode=='N'){
         var obj = window.dialogArguments;
            //alert(obj);
	        obj.fkValue = name;
			obj.value = strs[0];
			window.dialogArguments.document.getElementById("dev_model").value = strs2[0];
			
        	//window.returnValue =  'name:'+name+'~code:'+code+'~isDeviceCode:'+isDeviceCode;
        	window.close();
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