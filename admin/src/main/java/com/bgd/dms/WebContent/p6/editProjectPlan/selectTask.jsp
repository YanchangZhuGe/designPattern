<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="GBK"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String projectInfoNo = request.getParameter("project_info_no");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>选择作业</title>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
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
            {name : 'TaskId',type: 'string'},
            {name : 'Name', type : 'String'},
            {name : 'status', type : 'String'},
      		{name : 'StartDate', type : 'String'},
      		{name : 'EndDate', type : 'String' },
      		{name : 'projectId', type : 'String' },
      		{name : 'wbsName', type : 'String' },
      		{name : 'plannedStartDate', type : 'String' },
      		{name : 'plannedEndDate', type : 'String'},
      		{name : 'other1'},
    		{name : 'isWbs'},
    		{name : 'isRoot'},
    		{name : 'PlannedDuration'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
          //  url: '<%=contextPath%>/p6/resourceAssignment/getTasksWithoutWbsDate.srq?checked=true&projectInfoNo=<%=projectInfoNo%>',
            url: '<%=contextPath%>/p6/resourceAssignment/getTaskTreeForPlan.srq?checked=true&projectInfoNo=<%=projectInfoNo%>',
            
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    
 
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'grid',
        title: '作业',//树的标题
        width:document.body.clientWidth*0.95,
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
        columns: [
        {
            //we must use the templateheader component so we can use a custom tpl
            xtype: 'treecolumn',
            text: '编号',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'TaskId',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '名字',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'Name',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: 'WBS名称',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'wbsName',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '计划开始日期',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'plannedStartDate',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '计划结束日期',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'plannedEndDate',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '预定工期',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'PlannedDuration',
            align: 'center'
        }]
    });
    
    grid.addListener('load', load);

    function load(){
        grid.getRootNode().expand(true,true);
    }
    
});

	function getSel(){
		var check = Ext.getCmp('grid').getChecked();

		if(check == "" || check == null){
			alert("请选择一条记录");
			return;
		}
	    var checkTaskIds = "";
	    var checkNames = "";
	    var checkOther1s = "";
	    var checkProjectIds = "";
	    var checkwbsNames = "";
	    
		for(var i=0;i<check.length;i++){
			checkTaskIds += "," + check[i].data.TaskId;
			checkNames += "," +check[i].data.Name;
			checkOther1s += "," +check[i].data.other1;
			checkProjectIds += "," +check[i].data.projectId;
			checkwbsNames+=","+check[i].data.wbsName;
			
		}
				
	    var taskInfo = window.dialogArguments;
	    taskInfo.fkValue = checkOther1s =="" ? "" : checkOther1s.substr(1);
	    taskInfo.value = checkNames =="" ? "" : checkNames.substr(1);
	    taskInfo.id = checkTaskIds =="" ? "" : checkTaskIds.substr(1);
	    taskInfo.projectId = checkProjectIds =="" ? "" : checkProjectIds.substr(1);
	    taskInfo.wbsName = checkwbsNames =="" ? "" : checkwbsNames.substr(1);

	    checkwbsNames
		window.close();
	}
	
</script>
</head>


<body style="background:#cdddef" >
	
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer" >
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						 <td>&nbsp;
						 	<input type="button" value="确定" class="tj" onclick="getSel()"/>	
						 </td>
					  </tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
				<div id="menuTree" style="width:100%;height:auto;overflow:auto;z-index: 0"></div>		
		</div>

</body>
</html>


