<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String projectInfoNo = request.getParameter("projectInfoNo");

	String wbsBackUrl = request.getParameter("wbsBackUrl");
	String taskBackUrl = request.getParameter("taskBackUrl");
	String rootBackUrl = request.getParameter("rootBackUrl");
	
	String customKey = "";
	String customValue = "";
	
	if(request.getParameter("customKey") != null && !"".equals(request.getParameter("customKey"))){
		customKey = request.getParameter("customKey");
	}
	if(request.getParameter("customValue") != null && !"".equals(request.getParameter("customValue"))){
		customValue = request.getParameter("customValue");
	}

	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");
	
	String checked = request.getParameter("checked");
	String wbsOnly = request.getParameter("wbsOnly");
	String expMethods = request.getParameter("explorationMethod") != null ? request.getParameter("explorationMethod") : "";

	String[] temp = customKey.split(",");
	String[] temp1 = customValue.split(",");

	int i =0;

	String customString = "";

	for(;i<temp.length && i <temp1.length; i++) {
		customString += "&"+temp[i]+"="+temp1[i];
	}
	
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
    .x-grid-cell-inner {
	overflow: hidden;
	-o-text-overflow: ellipsis;
	text-overflow: ellipsis;
	padding: 2px 6px 3px;
	white-space: nowrap;
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
      		/* {name : 'BaselineStartDate', type : 'date', dateFormat : 'Y-m-d' },
      		{name : 'BaselineEndDate', type : 'date', dateFormat : 'Y-m-d' } */
      		{name : 'StartDate', type : 'String'},
      		{name : 'EndDate', type : 'String' },
      		{name : 'PlannedStartDate', type : 'String' },
      		{name : 'PlannedEndDate', type : 'String'},
      		{name : 'other1'},
    		{name : 'isWbs'},
    		{name : 'isRoot'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/p6/resourceAssignment/getTasks.srq?wbsOnly=<%=wbsOnly %>&checked=<%=checked %>&projectInfoNo=<%=projectInfoNo%>',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'grid',
    	<%
    	if(checked == "true" || "true".equals(checked)){
    	%>
        title: '任务<input type="button" value="确定" onclick="fun()"/>',//树的标题
    	<%
    	} else {
    	%>
    	 title: '任务',//树的标题
    	<%
    	}
    	%>
        width: document.body.clientWidth,
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
            text: '任务名',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'Name',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '开始日期',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'StartDate',
            align: 'center'
        },{
            text: '结束日期',
            hidden:true,
            flex: 1,
            dataIndex: 'EndDate',
            sortable: true,
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '计划开始日期',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'PlannedStartDate',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '计划结束日期',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'PlannedEndDate',
            align: 'center'
        }]
    });
    //debugger;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var record = grid.getStore().getAt(1);   //Get the Record rowIndex.sourceIndex
        var isWbs = rowdata.data.isWbs;
        var taskObjectId = rowdata.data.other1;
        var isRoot = rowdata.data.isRoot;
        var taskId = rowdata.data.TaskId;
        var taskName = rowdata.data.Name;

        if(isWbs == "true"){
  			//wbs or root
  			if(isRoot == "true"){
  				//root
  				if('<%=rootBackUrl %>'=='null'){
  					
  				} else { 		
  					//parent.mainRightframe.location.href = "<%= contextPath%><%=rootBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+encodeURI(encodeURI(taskName,'UTF-8'),'UTF-8')+"<%=customString %>";
  					parent.mainRightframe.location.href = "<%= contextPath%><%=taskBackUrl %>?&taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+encodeURI(encodeURI(taskName,'UTF-8'),'UTF-8')+"<%=customString %>";
  				}
  			} else {
  				//wbs
				if('<%=wbsBackUrl %>'=='null'){
  					
  				} else {
  					parent.mainRightframe.location.href = "<%= contextPath%><%=wbsBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+encodeURI(encodeURI(taskName,'UTF-8'),'UTF-8')+"<%=customString %>";
  				}
  			}
  		} else {
  			//任务
  			if('<%=taskBackUrl %>'=='null'){
					
			} else {
  				parent.mainRightframe.location.href = "<%= contextPath%><%=taskBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+encodeURI(encodeURI(taskName,'UTF-8'),'UTF-8')+"<%=customString %>&expMethod=<%=expMethods%>";
			}
  		}
    }
    var rightClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [
	    		{
	    			text:"新增目录",
	    			handler:function(grid,rowdate, item, rowindex, e){
	    				alert(id+"***"+name+"***"+id_name);
	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"编辑目录",
	    			handler:function(grid,rowdate, item, rowindex, e){
	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"删除目录",
	    			handler:function(grid,rowdate, item, rowindex, e){
	    			}
	    		}
	    	]
    });
    //grid.addListener('itemcontextmenu', rightClickFn);//右键菜单代码关键部分
    var id = null;
    var name = null;
    var id_name = null;
    function rightClickFn(grid,rowdate, item, rowindex, e) {
    	id = rowdate.data.id;
    	name = rowdate.data.name;
    	id_name =rowdate.data.id_name;
    	e.preventDefault();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		e.stopEvent();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
	    rightClick.show();//显示位置 或者rightClick.showAt();//显示位置 
    }
});

function fun(){
	//debugger;
	var check = Ext.getCmp('grid').getChecked();
	
	if(check == ""){
		alert("请选择一条记录");
		return;
	}
	
	var checkTaskIds = "";
    var checkNames = "";
    var checkOther1s = "";
    
    
	for(var i=0;i<check.length;i++){
		checkTaskIds += "," + check[i].data.TaskId;
		checkNames += "," +check[i].data.Name;
		checkOther1s += "," +check[i].data.other1;
	}
	
	var TaskIds = checkTaskIds =="" ? "" : checkTaskIds.substr(1);
	var Names = checkNames =="" ? "" : checkNames.substr(1);
	if(Names != ""){
		Names = encodeURI(encodeURI(Names,'UTF-8'),'UTF-8')
	}
	var CheckOther1s = checkOther1s =="" ? "" : checkOther1s.substr(1);
	parent.mainRightframe.location.href = "<%= contextPath%><%=taskBackUrl %>?taskObjectId="+CheckOther1s+"&taskId="+TaskIds+"&projectInfoNo=<%=projectInfoNo %>&taskName="+Names+"<%=customString %>&expMethod=<%=expMethods%>";
	
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