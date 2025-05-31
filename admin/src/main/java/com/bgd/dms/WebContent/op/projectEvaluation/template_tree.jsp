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
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<script type="text/javascript" language="javascript">
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
			/* {name : 'BaselineStartDate', type : 'date', dateFormat : 'Y-m-d' },*/
            {name : 'id',type: 'string'},
            {name : 'evaluate_name', type : 'String'},
      		{name : 'evaluate_weight', type : 'String'},
      		{name : 'evaluate_standard', type : 'String'},
      		{name : 'formula_content', type : 'String'},
      		{name : 'is_leaf', type : 'String'}
        ]
    });
    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        root: {
			id:'root',
			evaluate_name:'评价指标汇总',
			evaluate_weight:'100',
			evaluate_standard:'',
			formula_content:'',
            expanded: true
        }, 
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/evaluation/getTemplateTree.srq',
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
        title: '',
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
            text: '指标名称',
            flex: 6,
            sortable: true,
            dataIndex: 'evaluate_name',
            align: 'left'
        },{
            text: '权重',
            flex: 1,
            sortable: true,
            dataIndex: 'evaluate_weight',
            align: 'center'
        },{
            text: '评价标准',
            flex: 8,
            dataIndex: 'evaluate_standard',
            sortable: true,
            align: 'left'
        },{
            text: '计算公式',
            flex: 10,
            sortable: true,
            dataIndex: 'formula_content',
            align: 'left'
        }]
    });
    var rowNum = 0;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
    	var evaluate_template_id = rowdata.data.id;
    	var is_leaf = rowdata.data.is_leaf;
    	if(is_leaf!=null && is_leaf=='1'){
    		parent.menuFrame.refreshData(evaluate_template_id);
    	}
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
			<div id="menuTree" style="width:100%;height:100%;"></div>
		</td>
	</tr>
</table>

</body>