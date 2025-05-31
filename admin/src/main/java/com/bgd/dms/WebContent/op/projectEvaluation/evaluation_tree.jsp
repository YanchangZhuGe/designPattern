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
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
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
      		{name : 'formula_content', type : 'String'},
      		{name : 'base_value', type : 'String'},
      		{name : 'actual_value', type : 'String'},
      		{name : 'evaluate_score', type : 'String'},
      		{name : 'is_leaf', type : 'String'}
        ]
    });
    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        /* root: {
			id:'root',
			evaluate_name:'项目评价结果',
			evaluate_weight:'100',
			evaluate_standard:'',
			formula_content:'',
            expanded: false
        }, */
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/evaluation/getProjectTemplateTree.srq?project_info_no=<%=project_info_no%>',
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
        title: '项目评价结果',
        width: document.body.clientWidth,
        height: document.body.clientHeight*0.92, 
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
            flex: 5,
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
            text: '计算公式',
            flex: 10,
            sortable: true,
            dataIndex: 'formula_content',
            align: 'left'
        },{
            text: '基准值',
            flex: 2,
            dataIndex: 'base_value',
            sortable: true,
            align: 'center'
        },{
            text: '实际值',
            flex: 2,
            dataIndex: 'actual_value',
            sortable: true,
            align: 'center'
        },{
            text: '实际得分',
            flex: 2,
            dataIndex: 'evaluate_score',
            sortable: true,
            align: 'center'
        }]
    });
    var rowNum = 0;
    //grid.addListener('cellclick', cellclick);
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
function calculate(){
	var retObj = jcdpCallService("ProjectEvaluationSrv" , "getProjectValue", "");
	if(retObj.returnCode =='0'){
		refreshTree();
	}
}
</script>
</head>
<body>
<div id="inq_tool_box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
						<auth:ListButton functionId="OP_EVALUATION_EDIT" css="tj" event="onclick='calculate()'" title="JCDP_btn_submit"></auth:ListButton>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;"></div>
		</td>
	</tr>
</table>

</body>