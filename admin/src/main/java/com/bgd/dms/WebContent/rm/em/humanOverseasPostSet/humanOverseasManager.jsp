<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.bgp.mcs.service.common.CodeSelectOptionsUtil"%>
<%@page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title></title>
<style type="text/css">
.x-grid-row .x-grid-cell {
	color: null;
	font: normal 13px tahoma, arial, verdana, sans-serif;
	border-color: #ededed;
	border-style: solid;
	border-width: 1px 0;
	border-top-color: #fafafa
}

.x-column-header {
	padding: 0;
	position: absolute;
	overflow: hidden;
	border-right: 1px solid #c5c5c5;
	border-left: 0 none;
	border-top: 0 none;
	border-bottom: 0 none;
	text-shadow: 0 1px 0 rgba(255, 255, 255, 0.3);
	font: normal 11px/15px tahoma, arial, verdana, sans-serif;
	color: null;
	font: normal 13px tahoma, arial, verdana, sans-serif;
	background-image: none;
	background-color: #c5c5c5;
	background-image: -webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #f9f9f9),
		color-stop(100%, #e3e4e6) );
	background-image: -moz-linear-gradient(top, #f9f9f9, #e3e4e6);
	background-image: linear-gradient(top, #f9f9f9, #e3e4e6)
}

.x-tree-icon-leaf {
	width: 16px;
	background-image:
		url('<%=contextPath%>/images/images/tree_06.png')
}

.x-tree-icon-parent {
	width: 16px;
	background-image:
		url('<%=contextPath%>/images/images/tree_06.png')
}

.x-grid-tree-node-expanded .x-tree-icon-parent {
	background-image:
		url('<%=contextPath%>/images/images/tree_06.png')
}
</style>
<style type="text/css">
    .task {
        background-image: url(<%=contextPath%>/images/images/tree_06.png) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/images/images/tree_06.png) !important;
    }
</style>
<script type="text/javascript" language="javascript">

cruConfig.contextPath = "<%=contextPath%>";
var selectedTagIndex = 0;

var selectParentIdData="";
var selectUpIdData="";
var codeTypeObjectId="";
var fs="";
var codingCode="";
var codingCodeId="";
var codingShowId="";
var codingSortId="0110000001";
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Team', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'codingCodeId',type: 'string'},
            {name : 'codingSortId', type : 'String'},
            {name : 'codingCode', type : 'String'},
            {name : 'codingName', type : 'String'},
            {name : 'codingShowId', type : 'String'},
            {name : 'orderCode', type : 'String'},
            {name : 'fs', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Team',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/rm/em/queryOverseasCode.srq',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        width: document.body.clientWidth,
        height:document.body.clientHeight*0.8, 
        autoHeight: true,  
        lines: true,
        enableDD: false, 
        renderTo: 'menuTree',
        collapsible: false,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        EnableDD:true,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn', //this is so we know which column will show the tree
            text: '名称',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'codingName'
        }]
    });
    grid.addListener('cellclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        fs=rowdata.data.fs;
        codingCode=rowdata.data.codingCode;
        codingShowId=rowdata.data.codingShowId;
        codingCodeId=rowdata.data.codingCodeId;
               
    });
});

</script>
</head>
<body  style="background:#fff" >
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					  	<td width="80%">&nbsp;</td>
					  	<td>
						<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_filter"></auth:ListButton>
						<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
						<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
						</td>
					  </tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		<div id="table_box" style="height: 580px">
					<div id="menuTree" style="width:100%;height:auto;overflow:auto;z-index: 0"></div>
		</div>
	</div>
</body>
<script type="text/javascript">

function toAdd(){
	//fs为空增加班组 为1增加岗位
	
	if(fs!='2'){
		popWindow("<%=contextPath%>/rm/em/humanOverseasPostSet/add_humanOverseasModify.jsp?codingCode="+codingCode+"&action=add");
	}

}
function toEdit(){
	
	if(fs!=''){
		popWindow("<%=contextPath%>/rm/em/humanOverseasPostSet/add_humanOverseasModify.jsp?codingCodeId="+codingCodeId+"&action=edit");
	}
	
}
function toDelete(){
	if(confirm('确定要删除吗?')){
		
		if(fs!=''){
			if(fs=='2'){
				var sql="update comm_human_coding_sort t set t.bsflag='1',t.modifi_date=sysdate where t.coding_code_id='"+codingCodeId+"'";
				
				var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
				var params = "deleteSql="+sql;
				params += "&ids=";
				var retObject = syncRequest('Post',path,params);
				if(retObject.returnCode!=0) alert(retObject.returnMsg);
				refreshTree();
			}else{
				var sql="update comm_human_coding_sort t set t.bsflag='1',t.modifi_date=sysdate where t.coding_code like '"+codingCode+"%25'";
				
				var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
				var params = "deleteSql="+sql;
				params += "&ids=";
				var retObject = syncRequest('Post',path,params);
				if(retObject.returnCode!=0) alert(retObject.returnMsg);
				refreshTree();
			}
		}
		
	}
}

function refreshTreeSaveExpand(){
	var tree=Ext.getCmp('gridId');
	var path = tree.getSelectionModel()
	.getSelectedNode().getPath('id');
	//重载数据,并在回调函数里面选择上一次的节点 
	tree.getStore().load(tree.getRootNode(),function(treeNode) {
				//展开路径,并在回调函数里面选择该节点 
			tree.expandPath(path,'id', function(bSucess,oLastNode) {
								tree.getSelectionModel().select(oLastNode);
							});
		}, this);
}

function refreshTree(){
	Ext.getCmp('gridId').getStore().load(); 
}


</script>
</html>