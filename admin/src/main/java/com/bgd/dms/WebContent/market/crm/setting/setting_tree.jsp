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
	if(project_info_no==null){
		project_info_no="";
	}
%>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"></link>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
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
                {name : 'id',type: 'String'},
				{name : 'name', type : 'String'},
				{name : 'short_name', type : 'String'}
             ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        root: {
        	id:'root',
        	name:'地区',
        	short_name:'地区',
            expanded: false
        }, 
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/crm/common/getCompanyTypeTree.srq?divisory_type=2',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    var states = Ext.create('Ext.data.Store', {
        fields: ['value', 'name'],
        data : [
            /* {"value":"1" ,"name":"油公司"}, */
            {"value":"2" ,"name":"国家区域"}
        ]
    });
    var tbar = Ext.create("Ext.Toolbar", {
    	width   : 300,
        items: [new Ext.form.ComboBox({
        	id:"type",
		    width: 100,
		    isFormField:false,
		    editable:false,
		    //readOnly:true,
		    //disabled:true,
		    value:'2',
		    store: states,
		    queryMode: 'local',
		    displayField: 'name',
		    valueField: 'value',
		    listeners:{
		    	change:function (field, newValue, oldValue, eOpts){
		    		Ext.getCmp('gridId').store.getProxy().url = '<%=contextPath%>/crm/common/getCompanyTypeTree.srq?divisory_type='+newValue;
		    		Ext.getCmp('gridId').getStore().load();
		    	}
		    }
		}),
        {xtype:"tbfill"}, //加上这句，后面的就显示到右边去了 
        {
            xtype: "button",
            width: 0
        }]
    });
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id: 'gridId',
        title: '',
        width: 300,//document.body.clientWidth*0.8,
        height: document.body.clientHeight, 
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: true,
        useArrows: false,
        rootVisible: true,
        store: store,
        multiSelect: false,
        singleExpand: false,
        tbar: tbar,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn',
            text: '油公司类别',
            flex: 1,
            sortable: true,
            dataIndex: 'short_name',
            align: 'left'
        }]
    });
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var type_id = rowdata.data.id;
        var type_name = rowdata.data.name;
        var type_short_name = rowdata.data.short_name;
        if(type_id!=null && type_id!=''){
        	var divisory_type = Ext.getCmp("type").value;
        	parent.menuFrame.refreshData(type_id, type_short_name ,divisory_type);
        }
    }
});

function refreshTree(type_id){
	var node = Ext.getCmp('gridId').getStore().getNodeById(type_id);
	var options ={node:node};
	Ext.getCmp('gridId').getStore().load(options);
}
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
function search(name){
	var retObj = jcdpCallService("ClientRelationSrv","search", "name="+name);
	if(retObj.returnCode =='0'){
		var ids = retObj.ids;
		return ids;
	}
}
</script>
</head>
<body style="overflow-x:hidden;">
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%" style="width:100%;height:100%;overflow:hidden;">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:hidden;"></div>
		</td>
	</tr>
</table>

</body>
</html>