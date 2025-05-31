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
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	if(org_subjection_id==null || org_subjection_id.trim().equals("")){
		org_subjection_id = "";
	}
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
var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;
var note ='';
var rightMenu = null;
Ext.onReady(function() {
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'org_id',type: 'string'},
            {name : 'project', type : 'String'},
            {name : 'name', type : 'String'},
            {name : 'eps', type : 'String'},
            {name : 'org_subjection_id', type : 'String'}
        ]
    });
    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        root: {
			id:'C6000000000001',
			name:'中石油东方地球物理勘探公司',
			org_subjection_id:'<%=org_subjection_id%>',
			eps:true,
            expanded: true
        }, 
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/qua/common/getProjectTreeEps.srq',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        title: 'EPS树',
        width: 300,
        height: document.body.clientHeight, 
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: true,
        useArrows: false,
        rootVisible: true,
        store: store,
        multiSelect: false,
        singleExpand: false,
        resizable:true,
        columns: [{
            xtype: 'treecolumn',
            text: 'EPS名称',
            flex: 2,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        }]
    });
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var org_id = rowdata.data.org_id;
        var name = rowdata.data.name;
        var eps = rowdata.data.eps;
        var org_subjection_id = rowdata.data.org_subjection_id;
        var project = rowdata.data.project;
        if(eps=='false'){
        	 parent.menuFrame.refreshData(project);
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
