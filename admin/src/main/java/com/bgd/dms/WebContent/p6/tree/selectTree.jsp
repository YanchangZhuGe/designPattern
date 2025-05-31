<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="GBK"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String projectInfoNo = request.getParameter("projectInfoNo");

	String wbsBackUrl = request.getParameter("wbsBackUrl");
	String taskBackUrl = request.getParameter("taskBackUrl");
	String rootBackUrl = request.getParameter("rootBackUrl");

	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");

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
            url: '<%=contextPath%>/p6/resourceAssignment/getTasksWithoutWbsDate.srq?checked=true&projectInfoNo=<%=projectInfoNo%>',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    
 
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'grid',
        title: '����',//���ı���
        width: 700,//document.body.clientWidth*0.8,
        height: document.body.clientHeight, 
       // autoHeight: true,//�Զ��߶�
        lines: true,
        renderTo: 'menuTree',//���Ƶ�����
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
            text: '����',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'Name',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '��ʼ����',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'StartDate',
            align: 'center'
        },{
            text: '��������',
            hidden:false,
            flex: 1,
            dataIndex: 'EndDate',
            sortable: true,
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '�ƻ���ʼ����',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'PlannedStartDate',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '�ƻ���������',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'PlannedEndDate',
            align: 'center'
        }]
    });
    //debugger;
 //   grid.addListener('cellclick', cellclick);
    function (grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
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
  				parent.mainRightframe.location.href = "<%= contextPath%><%=rootBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+taskName;
  			} else {
  				//wbs
  			parent.mainRightframe.location.href = "<%= contextPath%><%=wbsBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+taskName;
  			}
  		} else {
  			//����
  			parent.mainRightframe.location.href = "<%= contextPath%><%=taskBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+taskName;
  		}
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
 //   	e.preventDefault();//��ֹĬ����Ϊ���磺��ֹ�ű����л�����ֹ�¼���������ִ��
//		e.stopEvent();//��ֹĬ����Ϊ���磺��ֹ�ű����л�����ֹ�¼���������ִ��
	    rightClick.show();//��ʾλ�� ����rightClick.showAt();//��ʾλ�� 
    }
});

	function getSel(){
		var check = Ext.getCmp('grid').getChecked();

		if(check == null){
			alert(��ѡ��һ����¼);
			return;
		}
	    var checkTaskIds = "";
	    var checkNames = "";
	    var checkStartDates = "";
	    var checkEndDates = "";
	    var checkOther1s = "";
	    
		for(var i=0;i<check.length;i++){
			checkTaskIds += "," + check[i].data.TaskId;
			checkNames += "," +check[i].data.Name;
			checkStartDates += "," +check[i].data.StartDate;
			checkEndDates += "," +check[i].data.EndDate;
			checkOther1s += "," +check[i].data.other1;
		}
	    
	    var obj = window.dialogArguments;
		obj.TaskIds = checkTaskIds =="" ? "" : checkTaskIds.substr(1);
		obj.Names = checkNames =="" ? "" : checkNames.substr(1);
		obj.StartDates = checkStartDates =="" ? "" : checkStartDates.substr(1);
		obj.EndDates = checkEndDates =="" ? "" : checkEndDates.substr(1);
		obj.CheckOther1s = checkOther1s =="" ? "" : checkOther1s.substr(1);
		window.close();
	}
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
			    <td> <input type="button" value="����" class="tj" onclick="getSel()"/></td>			    
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