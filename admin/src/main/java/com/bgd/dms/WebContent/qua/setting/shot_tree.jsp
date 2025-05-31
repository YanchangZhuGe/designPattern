<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_type = user.getProjectType();
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
	String name = "单炮二级品";
	if(project_type!=null && project_type.trim().equals("5000100004000000009")){
		name = "资料评价";
	}
	String extPath = contextPath + "/js/ext-min";
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
var rightMenu = null;
var note = '';
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'id',type: 'string'},
            {name : 'name', type : 'String'},
            {name : 'note', type : 'String'},
            {name : 'notes', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        root: {
			id:'5000100100',
			name:'<%=name %>',
            expanded: true
        },
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/qua/setting/getSingleShot.srq?project_type=<%=project_type%>',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        title: '',
        width: 298,//document.body.clientWidth*0.8,
        height: document.body.clientHeight, 
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: true,
        useArrows: false,
        rootVisible: true,
        resizable:true,
        store: store,
        //the 'columns' property is now 'headers'
        columns: [/*  {
        	//xtype: 'treecolumn', this is so we know which column will show the tree
            text: 'ID',
            hideable:true,
            flex: 3,
            sortable: true,
            dataIndex: 'id'
        }, */{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            xtype: 'treecolumn',
            text: '<%=name %>',
            flex: 2,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        }]	    
    });
    
    var row = 100;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
		var id = rowdata.data.id;
		var name = rowdata.data.name;
		if(id.length > 10){
			return;
		}
		
    	parent.menuFrame.refreshCodeData(id, '');
    }
    var rightClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [{
	    			text:"新增目录",
	    			handler:function(grid,rowdate, item, rowindex, e){
	    				//alert(id+"***"+name);
	    				alert('<%=contextPath %>/qua/setting/codeEdit.jsp?sortId='+id );
	    				parent.menuFrame.location.href = '<%=contextPath %>/qua/setting/codeEdit.jsp?sortId='+id ;
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
	    		}]
    });
    //grid.addListener('itemcontextmenu', rightClickFn);//右键菜单代码关键部分
   
    function rightClickFn(grid,rowdate, item, rowindex, e) {//点击第一次的时候右键菜单显示有点慢（待解决）
    	id = rowdate.data.id;
    	name = rowdate.data.name;
    	e.preventDefault();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		//e.stopEvent();//阻止默认行为，如：阻止脚本运行或者阻止事件处理函数的执行
		var x = e.getX();
		var y = e.getY();
		rightClick.setPosition(x,y,false);//true动画效果
		//debugger;
		if(id.length<=10)
	    rightClick.show();//显示 
	    //rightClick.showAt();//显示showAt() 在点击第一次的右键菜单的位置时候有问题
    }
});
function refreshTree(){
	//alert("refreshTree");
	Ext.getCmp('gridId').getStore().load(); 
}
function saveNote(id){
	if(event.keyCode==13)
    {
        if(window.confirm('你确定保存所修改的内容吗?')){
	        alert(id+"***"+note.firstChild.value);
        }
    }
} 
</script>
</head>
<body ><!-- scroll="no" -->
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
		</td>
	</tr>
</table>


</body>
</html>