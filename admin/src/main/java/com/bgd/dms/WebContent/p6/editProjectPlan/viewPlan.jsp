<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="GBK"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat" %>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectObjectId = request.getParameter("project_object_id");
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String todayDate = df.format(new Date());
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
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
      		/* {name : 'BaselineStartDate', type : 'date', dateFormat : 'Y-m-d' },
      		{name : 'BaselineEndDate', type : 'date', dateFormat : 'Y-m-d' } */
      		{name : 'StartDate', type : 'String'},
      		{name : 'EndDate', type : 'String' },
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
          //  url: '<%=contextPath%>/p6/resourceAssignment/getTasksWithoutWbsDate.srq?checked=true&projectInfoNo=<%=projectInfoNo%>&projectObjectId=<%=projectObjectId%>',
            url: '<%=contextPath%>/p6/resourceAssignment/getTaskTreeForPlan.srq?checked=true&project_object_id=<%=projectObjectId%>',

              reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    
 
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'grid',
        title: '任务',//树的标题
        width: document.body.clientWidth*0.99,
        height: document.body.clientHeight, 
       // autoHeight: true,//自动高度
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
            //xtype: 'templatecolumn',
            xtype: 'treecolumn',
            text: '名字',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'Name',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '编号',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'TaskId',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '状态',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'status',
            align: 'center'
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
    //debugger;
    //grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var record = grid.getStore().getAt(1);   //Get the Record rowIndex.sourceIndex
        var isWbs = rowdata.data.isWbs;
        var taskObjectId = rowdata.data.other1;
        var isRoot = rowdata.data.isRoot;
        var taskId = rowdata.data.TaskId;
        var taskName = rowdata.data.Name;
        var plannedStartDate = rowdata.data.plannedStartDate;
        var plannedEndDate = rowdata.data.plannedEndDate;
        if(isWbs == "true"){
  			parent.mainDownframe.location.href = "<%=contextPath %>/p6/editProjectPlan/editWBSInfo.jsp?wbsName="+encodeURI(encodeURI(taskName,'UTF-8'),'UTF-8')+"&taskObjectId="+taskObjectId+"&wbsCode="+taskId+"&projectInfoNo=<%=projectInfoNo%>";
  		} else {
  			//任务
  			parent.mainDownframe.location.href = "<%=contextPath %>/p6/editProjectPlan/editActivityInfo.jsp?taskName="+encodeURI(encodeURI(taskName,'UTF-8'),'UTF-8')+"&taskId="+taskId+"&plannedStartDate="+plannedStartDate+"&plannedEndDate="+plannedEndDate+"&taskObjectId="+taskObjectId+"&projectInfoNo=<%=projectInfoNo%>";
  		}
    }
    
    var right_click_id = null;
    var right_click_name = null;
    var right_click_is_wbs = null;
    var right_click_object_id = null;
    
    var rightClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [
	    		{
	    			text:"新增WBS",
	    			handler:function(grid,rowdata, item, rowIndex, e){
	  					popWindow("<%=contextPath%>/p6/editProjectPlan/addWBS.jsp?parentWbsObjectId="+right_click_object_id+"&parentWbsName="+encodeURI(encodeURI(right_click_name,'UTF-8'),'UTF-8')+"&projectInfoNo=<%=projectInfoNo%>");
	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"新增作业",
	    			handler:function(grid,rowdata, item, rowIndex, e){
		    			popWindow("<%=contextPath%>/p6/editProjectPlan/addActivity.jsp?parentWbsObjectId="+right_click_object_id+"&parentWbsName="+encodeURI(encodeURI(right_click_name,'UTF-8'),'UTF-8')+"&projectInfoNo=<%=projectInfoNo%>");
	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"删除WBS",
	    			handler:function(grid,rowdata, item, rowIndex, e){
	    				
	    				var str = "wbsObjectId="+right_click_object_id;
	    				if(confirm('确定要删除吗?将会删除下面的所有作业')){
		    				var obj = jcdpCallService("P6ProjectPlanSrv", "deleteWBS", str);
		    				if(obj != null && obj.message == "success") {
		    					alert("修改成功");
		    				} else {
		    					alert("修改失败");
		    				}
	    				}
	    			}
	    		}
	    	]
    });
    
    //grid.addListener('itemcontextmenu', rightClickFn);//右键菜单代码关键部分
    
    function rightClickFn(grid,rowdata, item, rowindex, e) {
    	
        right_click_id = rowdata.data.id;
        right_click_name = rowdata.data.Name;
        right_click_is_wbs = rowdata.data.isWbs;
        right_click_object_id = rowdata.data.other1;
    	e.preventDefault();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		e.stopEvent();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		if(right_click_is_wbs == "true"){
    		rightClick.showBy(item);
		}
    }
});
	
</script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
<tr><td>
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>			 
			    <td> 
			    	 &nbsp;
			   	</td>	    
			   	<td align="right">
			   	</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
	</td></tr>

	<tr>	   
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
		</td>
	</tr>
</table>

</body>