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
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var object_id = ''; // ����ID
var object_name = ''; //��������
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
           		{name : 'EndDate', type : 'String'},
           		{name : 'PlannedStartDate', type : 'String'},
           		{name : 'PlannedEndDate', type : 'String' },
           		{name : 'isWbs', type : 'String' },
           		{name : 'note', type : 'String' }
             ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/p6/resourceAssignment/getTasksWithoutWbsDate.srq?projectInfoNo=<%=project_info_no%>&checked=true',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    var tbar = Ext.create("Ext.Toolbar", {
        items: [
        {xtype:"tbfill"}, //������䣬����ľ���ʾ���ұ�ȥ�� 
        {
        	id:"submit",
            xtype: "button",
            text: "ȷ��",
       		handler: function (bar,e) {
       			var rootNode = Ext.getCmp('gridId').getStore().getRootNode().firstChild;
       			var node = Ext.getCmp('gridId').getChecked();
       			var task_id = '';
       			var task_name = '';
       			parent.menuFrame.cleanTables();
       			for(var i =0;node[i]!=null ;i++){
       				var isWbs = node[i].data.isWbs;
       				if(isWbs!='true'){
       					var taskId = node[i].data.TaskId;
       					var name = node[i].data.Name;
       					if(task_id==''){
       						task_id = taskId;
       						task_name = name;
       					}
       					else{
       						task_id = task_id + "\',\'" + taskId;
           					task_name = task_name + "," + name;
       					}
       				}
       			}
       			parent.menuFrame.showSummaryTable(object_id , object_name , task_id , task_name);
            }
        }]
    });
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id: 'gridId',
        title: '����',
        width: 298,//document.body.clientWidth*0.8,
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
        resizable:true,
        tbar: tbar,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn',
            text: '��ҵ����',
            flex: 1,
            sortable: true,
            dataIndex: 'Name',
            align: 'left'
        },{
            text: 'ʵ�ʿ�ʼʱ��',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'StartDate',
            align: 'center'
        },{
            text: 'ʵ�ʽ���ʱ��',
            hidden:true,
            flex: 1,
            dataIndex: 'EndDate',
            sortable: true,
            align: 'center'
        },{
            text: '�ƻ���ʼʱ��',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'PlannedStartDate',
            align: 'center'
        },{
            text: '�ƻ�����ʱ��',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'PlannedEndDate',
            align: 'center'
        }]
    });
    var row = 0;
    grid.addListener('checkchange', checkchange);
    function checkchange(rowdata,checked,e) {
    	var isWbs = rowdata.data.isWbs;
    	if(isWbs == 'true'){
    		var childNodes = rowdata.childNodes;
        	if(childNodes!=null && childNodes[0].data.isWbs=='false'){
        		if(checked == true){
        			if(object_id == ''){
    	    			object_id = rowdata.data.TaskId;
    	    			object_name = rowdata.data.Name;
    	    		}else if(object_id != rowdata.data.TaskId){
   	    				setChildChecked(Ext.getCmp('gridId').getStore().getRootNode().firstChild);
   	    				object_id = rowdata.data.TaskId;
       	    			object_name = rowdata.data.Name;
       	    			rowdata.set("checked",true);
    	    		}
        		}else{
        			object_id = '';
        			object_name = '';
        		}
        		getChildNodes(rowdata,checked);
        	}
        	else{
        		rowdata.set("checked",false);
        	}
    	}else{
    		if(checked == true){
	    		if(object_id == ''){
	    			object_id = rowdata.parentNode.data.TaskId;
	    			object_name = rowdata.parentNode.data.Name;
	    		}else if(object_id != rowdata.parentNode.data.TaskId){
    				setChildChecked(Ext.getCmp('gridId').getStore().getRootNode().firstChild);
    				object_id = rowdata.parentNode.data.TaskId;
	    			object_name = rowdata.parentNode.data.Name;
   	    			rowdata.set("checked",true);
	    		}
    		}
    		else{
    			if(!existChecked(rowdata.parentNode)){
    				object_id = '';
    				object_name = '';
    			}
    		}
    		getParentNode(rowdata);
    	}
    }
    //grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var taskId = rowdata.data.TaskId;
        var name = rowdata.data.Name;
        var startDate = rowdata.data.StartDate;
        var endDate = rowdata.data.EndDate;
        var plannedStartDate = rowdata.data.PlannedStartDate;
        var plannedEndDate = rowdata.data.PlannedEndDate;
        var data = rowdata.data.TaskId;
        parent.menuFrame.refreshCodeData(taskId, name);
    }
    var rightClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [
	    		{
	    			text:"����Ŀ¼",
	    			handler:function(grid,rowdate, item, rowindex, e){
	    				alert(id+"***"+name+"***"+id_name);
	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"�༭Ŀ¼",
	    			handler:function(grid,rowdate, item, rowindex, e){
	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"ɾ��Ŀ¼",
	    			handler:function(grid,rowdate, item, rowindex, e){
	    			}
	    		}
	    	]
    });
    //grid.addListener('itemcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ�����
    var id = null;
    var name = null;
    var id_name = null;
    function rightClickFn(grid,rowdate, item, rowindex, e) {
    	id = rowdate.data.id;
    	name = rowdate.data.name;
    	id_name =rowdate.data.id_name;
    	e.preventDefault();//��ֹĬ����Ϊ���磺��ֹ�ű����л�����ֹ�¼���������ִ��
		e.stopEvent();//��ֹĬ����Ϊ���磺��ֹ�ű����л�����ֹ�¼���������ִ��
	    rightClick.show();//��ʾλ�� ����rightClick.showAt();//��ʾλ�� 
    }
});
//�õ��ڵ���¼��ڵ㣬�������¼��ڵ�checkbox��checked����true or false
function getChildNodes(rowdata,checked) {
	rowdata.eachChild(function (child) {   
		child.set('checked', checked);
	}); 
	/* var parentNode = rowdata.parentNode;
	for(var i =0;i<rowdata.childNodes.length;i++){
		var childNode = rowdata.childNodes[i];
		if(childNode!=null && childNode.childNodes!=null && childNode.childNodes.length>0){
			getChildNodes(childNode,checked);
		}
	} */
}
//�õ��ڵ���ϼ����ڵ㣬����ϼ��ڵ���¼��ڵ�checkbox��ȫΪchecked==true�����ϼ��ڵ��checkb=true
function getParentNode(rowdata) {
	var parentNode = rowdata.parentNode;
	if(parentNode!=null){
		var check = childNodesAllChecked(parentNode);
		if(check == true){
			parentNode.set('checked', true);//
			getParentNode(parentNode);
		}else{
			parentNode.set('checked', false);
			//getParentNode(parentNode);
		}
	}
}
//�õ��ڵ���ϼ����ڵ㣬�ж��ϼ��ڵ���¼��ڵ�checkbox���Ƿ�ȫΪchecked==true
function childNodesAllChecked(rowdata) {
	for(var i =0;i<rowdata.childNodes.length;i++){
		var childNode = rowdata.childNodes[i];
		if(childNode.data.checked != true){
			return false;
		}
	}
	return true;
}
//�жϽڵ���¼��ڵ�checkbox���Ƿ����checked==true
function existChecked(rowdata) {
	for(var i =0;i<rowdata.childNodes.length;i++){
		var childNode = rowdata.childNodes[i];
		if(childNode.data.checked == true){
			return true;
		}
	}
	return false;
}
function setChildChecked(rowdata) {
	if(rowdata!=null){
		rowdata.eachChild(function (child) {   
			child.set('checked', false);
		}); 
		for(var i=0;i<rowdata.childNodes.length;i++){
			setChildChecked(rowdata.childNodes[i]); 
		}
	}
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