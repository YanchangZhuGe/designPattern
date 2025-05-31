<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String backUrl="";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null){
		project_info_no="";
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
var obj = window.dialogArguments;
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
var note = '';
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'id',type: 'string'},
            {name : 'name', type : 'String'},
            {name : 'is_employee', type : 'String'},
            {name : 'org_hr_id', type : 'String'},
            {name : 'sub_id', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
             url: '<%=contextPath%>/hse/staffEvaluation/getEmployeeTree.srq', 
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
        title: '任务',
        width: 300,//document.body.clientWidth*0.8,
        height: document.body.clientHeight, 
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: false,
        useArrows: false,
        rootVisible: false,
        store: store,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn',
            text: '名称',
            flex: 1,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        }]
    });
    //debugger;
    //grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var taskId = rowdata.data.TaskId;
        var name = rowdata.data.Name;
        var startDate = rowdata.data.StartDate;
        var endDate = rowdata.data.EndDate;
        var plannedStartDate = rowdata.data.PlannedStartDate;
        var plannedEndDate = rowdata.data.PlannedEndDate;
        var data = rowdata.data.TaskId;
        var objectId = rowdata.parentNode.data.Name;
        if(rowdata.data.isWbs == 'false'){
        	parent.menuFrame.refreshCodeData(taskId, name,objectId);
        }
    }
    grid.addListener('celldblclick', celldblclick);
    function celldblclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var id = rowdata.data.id;
        var name = rowdata.data.name;
        var is_employee = rowdata.data.is_employee;
        var org_hr_id = rowdata.data.org_hr_id;
        var sub_id = rowdata.data.sub_id;
       	obj.fkValue = id;
       	obj.value = name;
       	obj.is_employee = is_employee;
       	window.close();
        	//parent.menuFrame.refreshCodeData(taskId, name,objectId);
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