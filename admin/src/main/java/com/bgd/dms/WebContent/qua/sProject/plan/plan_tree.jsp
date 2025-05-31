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
	String project_info_no = user.getProjectInfoNo();
	String project_type = user.getProjectType();
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<script type="text/javascript"  >
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
var data = null;
var notes = null;
var saved = true;
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'task_id',type: 'string'},
            {name : 'name', type : 'String'},
      		/* {name : 'BaselineStartDate', type : 'date', dateFormat : 'Y-m-d' },
      		{name : 'BaselineEndDate', type : 'date', dateFormat : 'Y-m-d' } */
      		{name : 'start_date', type : 'String'},
      		{name : 'end_date', type : 'String'},
      		{name : 'planned_start_date', type : 'String'},
      		{name : 'planned_end_date', type : 'String' },
      		{name : 'is_wbs', type : 'String' },
      		{name : 'duty_name', type : 'String' },
      		{name : 'check_person', type : 'String' },
      		{name : 'note', type : 'String' },
      		{name : 'wbs_name', type : 'String' }
        ]
    });
    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/qua/common/getProjectWbsOnly.srq?project_info_no=<%=project_info_no%>&wbsOnly=true&project_type=<%=project_type%>',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    var tbar = Ext.create("Ext.Toolbar", {
        items: [
        {xtype:"tbfill"}, //加上这句，后面的就显示到右边去了 
        {
        	id:"submit",
            xtype: "button",
            text: "保存",
       		handler: function (bar,e) {
       			if(window.confirm("确定保存?")){
       				data.set('note', notes.value);
       				parent.menuFrame.savePlan(notes.value);
       				saved = true;
       			}
            }
        }]
    });
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        title: '工序检查计划',
        width: document.body.clientWidth,
        height: 280, 
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: true,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        //tbar: tbar,
        //the 'columns' property is now 'headers'
        columns: [{
        	xtype: 'treecolumn',
            text: '作业名称',
            flex: 2,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        },/* {
            text: '实际开始',
            flex: 1,
            sortable: true,
            dataIndex: 'StartDate',
            align: 'center'
        },{
            text: '实际结束',
            flex: 1,
            sortable: true,
            dataIndex: 'EndDate',
            align: 'center'
        }, */{
            text: '计划开始',
            flex: 1,
            sortable: true,
            dataIndex: 'planned_start_date',
            align: 'center'
        },{
            text: '计划结束',
            flex: 1,
            dataIndex: 'planned_end_date',
            sortable: true,
            align: 'center'
        },{
            text: '责任人',
            flex: 1,
            sortable: true,
            dataIndex: 'duty_name',
            align: 'left'
        },{
            text: '检查人',
            flex: 1,
            sortable: true,
            dataIndex: 'check_person',
            align: 'left'
        } ]
    });
    var rowNum = 0;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
    	var taskId = rowdata.data.task_id;
    	var name = rowdata.data.name;
    	var StartDate = rowdata.data.start_date;
    	var EndDate = rowdata.data.end_date;
    	var PlannedStartDate = rowdata.data.planned_start_date;
    	var PlannedEndDate = rowdata.data.planned_end_date;
    	if(rowdata.data.is_wbs == 'true'){
    		debugger;
    		parent.menuFrame.refreshCodeData(taskId ,name ,StartDate ,EndDate ,PlannedStartDate ,PlannedEndDate);
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
function refreshTree(){
	Ext.getCmp('gridId').getStore().load(); 
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