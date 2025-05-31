<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String projectId= "8a9588b63618fc0d01361a93e0bf0018";
	String backUrl="";
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
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
            {name : 'id',type: 'string'},
            {name : 'name', type : 'String'},
            {name : 'parent_id',type: 'string'},
            {name : 'evaluate_weight', type : 'String'},
            {name : 'evaluate_standard',type: 'string'},
            {name : 'ordering',type: 'string'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        root: {
			id:'root',
			name:'考核项目',
			evaluate_weight:100,
			evaluate_standard:'',
			<%-- icon:'<%=contextPath%>/images/d01.gif', --%>
            expanded: true
        },
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/pm/setting/getEvaluateTemplate.srq',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        title: '双击修改模板',//质量检查项
        width: document.body.clientWidth,//document.body.clientWidth*0.8,
        height: document.body.clientHeight,
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: true,
        useArrows: false,
        rootVisible: true,
        store: store,
        resizable:true,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn',
            text: '考核内容',
            flex: 2,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        },{
            text: '标准分值',
            flex: 1,
            sortable: true,
            dataIndex: 'evaluate_weight',
            align: 'center'
        },{
            text: '评分标准',
            flex: 6,
            dataIndex: 'evaluate_standard',
            sortable: true,
            align: 'center'
        }]
		    
    });
    
    grid.addListener('celldblclick', celldblclick);
    function celldblclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
    	
		var id = rowdata.data.id;
		var name = rowdata.data.name;
		var evaluate_weight = rowdata.data.evaluate_weight;
		var evaluate_standard = rowdata.data.evaluate_standard;
		var ordering = rowdata.data.ordering;
		popWindow("<%=contextPath%>/pm/projectEvaluation/template_edit.jsp?id="+id+"&name="+name+"&evaluate_weight="+evaluate_weight+"&evaluate_standard="+evaluate_standard+"&ordering="+ordering);
    	//parent.menuFrame.refreshCodeData(id, name);
    }
    var rightClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [
	    		{
	    			text:"新增目录",
	    			handler:function(grid,rowdate, item, rowindex, e){
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
	    		}
	    	]
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
function refreshTree(id){
	var node = Ext.getCmp('gridId').getStore().getNodeById(id);
	debugger;
	var parent_node = node.parentNode;
	var options ={node:parent_node};
	Ext.getCmp('gridId').getStore().load(options);
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