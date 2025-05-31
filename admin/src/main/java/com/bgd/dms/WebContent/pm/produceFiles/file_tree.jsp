<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectId = user.getProjectInfoNo();
	if(projectId==null || projectId.trim().equals("")){
		projectId = "";
	}
	String projectName = user.getProjectName();
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
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var module_id = top.frames["topFrame"].menu_id_tree;
var note ='';
var rightMenu = null;
Ext.onReady(function() {
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'id',type: 'string'},
            {name : 'name', type : 'String'},
            {name : 'isfile', type : 'String'}
        ]
    });
    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        root: {
			id:'<%=projectId%>',
			name:'<%=projectName%>',
            expanded: true
        }, 
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/pm/gpe/produceFiles/getFileTree.srq?module_id='+module_id+'&project_info_no=<%=projectId%>',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        title: '',
        width: 300,
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
        columns: [{
            xtype: 'treecolumn',
            text: '文档名称',
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
		parent.menuFrame.refreshData(id);
		parent.menuFrame.clearCommonInfo();
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
