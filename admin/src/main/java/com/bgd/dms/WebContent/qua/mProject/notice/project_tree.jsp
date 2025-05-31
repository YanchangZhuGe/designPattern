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
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"></link>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<script type="text/javascript" language="javascript">
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;
var org_array = new Array();
/* {
	org_ids :'',
	org_subjection_ids :'',
	project_info_nos :''	
} */
var org_ids = '';
var org_subjection_ids = '';
var project_info_nos = '';
var rightMenu = null;
Ext.onReady(function() {
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'id',type: 'string'},
            {name : 'name', type : 'String'},
            {name : 'org_id', type : 'String'},
            {name : 'project_info_no', type : 'String'},
            {name : 'eps', type : 'String'}
        ]
    });
    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        root: {
			id:'C105',
			name:'中石油东方地球物理勘探公司',
			org_id:'C6000000000001',
			eps:true,
            expanded: true
        }, 
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/qua/common/getProjectTreeEps.srq?checked=true&leaf=true',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    var tbar = Ext.create("Ext.Toolbar", {
        items: [
        //{xtype:"tbfill"}, //加上这句，后面的就显示到右边去了 
        {
        	id:"submit",
            xtype: "button",
            text: "确定",
       		handler: function (bar,e) {
       			var rootNode = Ext.getCmp('gridId').getStore().getRootNode().firstChild;
       			getRootChildren(rootNode);
            }
        }]
    });
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        title: '',
        width: 600,
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
        //resizable:true,
        //tbar: tbar,
        columns: [{
            xtype: 'treecolumn',
            text: '',
            flex: 2,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        }]
    });
    //grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var org_id = rowdata.data.org_id;
        var name = rowdata.data.name;
        var eps = rowdata.data.eps;
        var org_subjection_id = rowdata.data.id;
        //var objectId = rowdata.parentNode.data.name;
        parent.menuFrame.refreshData('',org_subjection_id);
    }
    var row = 0;
    grid.addListener('checkchange', checkchange);
    function checkchange(rowdata,checked) {
    	var nodes = Ext.getCmp('gridId').getChecked();
    	var project_info_no = "";
    	var org_subjection_id = "";
    	for(var i=0;i<nodes.length;i++){
    		var rowdata = nodes[i];
    		var eps = rowdata.data.eps;
    		if(eps!=null && (eps=='true' || eps==true)){
    			if(org_subjection_id==null || org_subjection_id ==''){
    				org_subjection_id = "'"+ rowdata.data.id +"'";
    			}else{
    				org_subjection_id = org_subjection_id +",'"+ rowdata.data.id +"'";
    			}
    		}else{
            	if(project_info_no==null || project_info_no ==''){
            		project_info_no = "'"+ rowdata.data.id +"'";
    			}else{
    				project_info_no = project_info_no +",'"+ rowdata.data.id +"'";
    			}
            }
    	}
    	if(project_info_no==null || project_info_no==""){
    		project_info_no ="''";
    	}
    	if(org_subjection_id==null || org_subjection_id==""){
    		org_subjection_id ="''";
    	}
        parent.menuFrame.checked(project_info_no,org_subjection_id);
    }
});
function getAllChecked(){
	var nodes = Ext.getCmp('gridId').getChecked();
	for(var i=0;i<nodes.length;i++){
		var rowdata = nodes[i];
		var eps = rowdata.data.eps;
		if(eps!=null && (eps=='true' || eps==true)){
        	var org_id = rowdata.data.org_id;
        	var org_subjection_id = rowdata.data.id;
        	var project_info_no = '';
        	var values = {
       			org_id :org_id,
       			org_subjection_id :org_subjection_id,
       			project_info_no :project_info_no	
        	}
        	org_array.splice(0,0,values);
        }else{
        	var org_id = rowdata.data.org_id;
        	var org_subjection_id = rowdata.data.project_info_no;
        	var project_info_no = rowdata.data.id;
        	var values = {
       			org_id :org_id,
       			org_subjection_id :org_subjection_id,
       			project_info_no :project_info_no
           	}
           	org_array.splice(0,0,values);
        }
	}
	return org_array;
}
//得到根节点的所有下级节点，并得到下级节点checkbox的checked属性
function getRootChildren(rootNode) {
	for(var i =0;i<rootNode.childNodes.length;i++){
		var childNode = rootNode.childNodes[i];
		var check = childNode.data.checked;
		var isfile = childNode.data.isfile;
		if(check == true && isfile=='1'){
			var id = childNode.data.id;
			parent.menuFrame.newSubmit(id);
		}
		if(childNode!=null && childNode.childNodes!=null && childNode.childNodes.length>0){
			getRootChildren(childNode)
		}
	}
}
//得到节点的下级节点，并设置下级节点checkbox的checked属性true or false
function getChildNodes(rowdata,checked) {
	rowdata.eachChild(function (child){   
		child.set('checked', checked);
	}); 
	var parentNode = rowdata.parentNode;
	for(var i =0;i<rowdata.childNodes.length;i++){
		var childNode = rowdata.childNodes[i];
		if(childNode!=null && childNode.childNodes!=null && childNode.childNodes.length>0){
			getChildNodes(childNode,checked);
		}
	}
}
//得到节点的上级级节点，如果上级节点的下级节点checkbox的全为checked==true，这上级节点的checkb=true
function getParentNode(rowdata) {
	var parentNode = rowdata.parentNode;
	if(parentNode!=null){
		var check = childNodesAllChecked(parentNode);
		if(check == true){
			parentNode.set('checked', true);//
			getParentNode(parentNode);
		}
		else{
			parentNode.set('checked', false);
			getParentNode(parentNode);
		}
	}
}
//得到节点的上级级节点，判断上级节点的下级节点checkbox的是否全为checked==true
function childNodesAllChecked(rowdata) {
	for(var i =0;i<rowdata.childNodes.length;i++){
		var childNode = rowdata.childNodes[i];
		if(childNode.data.checked != true){
			return false;
		}
	}
	return true;
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
