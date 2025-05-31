<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.bgp.mcs.service.common.CodeSelectOptionsUtil"%>
<%@page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	List list=CodeSelectOptionsUtil.getOptionByName("owner");
	String owner = request.getParameter("owner");
	String flag = "true";
	if (owner == null || "".equals(owner)){
		flag = "false";
		if (list != null && list.size() > 0) {
			Map mapCode = (Map) list.get(0);
			if (mapCode != null) {
				owner = (String) mapCode.get("value");
			}
		}
	}
	String relationId = (String) request.getParameter("relationId");
	String action = request.getParameter("action");
	if (action == "" || "".equals(action) || action == null) {
		action = "edit";
	}
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
var owner="<%=owner%>";
var relationId = "<%=relationId %>";
var selectedTagIndex = 0;
var action = "<%=action %>";

var selectParentIdData="";
var selectUpIdData="";
var codeTypeObjectId="";

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
            {name : 'nodeName',type: 'string'},
            {name : 'nodeDesc', type : 'String'},
            {name : 'nodeId', type : 'String'},
            {name : 'zip', type : 'String'},
            {name : 'root', type : 'String'},
            {name : 'orderCode', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/pm/projectCode/getProjectCode.srq?owner='+owner,
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
        enableDD: true, 
        viewConfig: {
            plugins: {
                ptype: 'treeviewdragdrop',
                appendOnly:false
            },
            listeners: { 
                beforedrop: function (node,data,overModel,dropPosition,eOpts ) {
                	var sourceNode=data.records[0].data;
                	var targetNode=overModel.data;
                	var beforeOrAfter=dropPosition;
                	if(action == "edit" || "edit".equals(action)){
	                	if(targetNode.parentId == "root"){
	                		alert("不允许拖拽到此处!");
	                	} else {
	                	Ext.Ajax.request({  
	            			url:'<%=contextPath%>/pm/projectCode/saveProjectCodeOrder.srq',
	            			params:{  
	            				sourceNodeZip:sourceNode.zip,
	            				sourceNodeIndex:sourceNode.orderCode,
	            				sourceNodeId:sourceNode.nodeId,
	            				targetNodeZip:targetNode.zip,
	            				targetNodeIndex:targetNode.orderCode,
	            				targetNodeId:targetNode.nodeId,
	            				beforeOrAfter:beforeOrAfter
	                			}  
	                		});  
	                	}
                	}
            	} 
            } 
        },
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
            text: '分类码名称',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'nodeName'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '分类码说明',
            flex: 1,
            sortable: true,
            dataIndex: 'nodeDesc',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectParentIdData= rowdata.data.nodeId;
        selectUpIdData= rowdata.data.zip;
        codeTypeObjectId = rowdata.data.root;
    });
    grid.addListener('celldblclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
    	if(rowdata.data.parentId == "root"){
    		//双击分类码大类
    	} else {
    		location.href="<%=contextPath %>/pm/projectCode/saveProjectCodeAssignment.srq?codeObjectId="+rowdata.data.nodeId+"&relationId="+relationId;
    		//debugger;
    		top.frames('list').frames[1].document.getElementById('codeManager').src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner="+owner+"&relationId="+relationId;;
    		//window.close();
    		newClose();
    	}
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
					    <td width="10%" class="ali3">
						  所属系统：
						 </td>
						 <td width="20%" class="ali1">
						<code:codeSelect onchange="changeOwner()" cssClass=""   name='owner' option="owner" selectedValue="<%=owner %>"  addAll="false"  disabled="<%=flag %>" /> 
						</td>
					    <td  width="60%">&nbsp;</td>
					    <td>&nbsp;</td>
					    <%if(action == "edit" || "edit".equals(action)){ %>
					    <td><span class="zj"><a href="#" onclick="toAdd()" title="JCDP_btn_add"></a></span></td>
					    <td><span class="xg"><a href="#" onclick="toModify()" title="JCDP_btn_edit"></a></span></td>
					    <td><span class="sc"><a href="#" onclick="toDelete()" title="JCDP_btn_delete"></a></span></td>
					    <%} %>
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
	if(selectParentIdData==null||selectParentIdData==""){
		//添加分类
		popWindow("<%=contextPath%>/pm/projectCode/projectCodeTypeManagerEdit.upmd?pagerAction=edit2Add&owner="+owner);
	} else {
		//添加分类下具体分类码
		popWindow("<%=contextPath%>/pm/projectCode/projectCodeManagerEdit.upmd?pagerAction=edit2Add&parentId="+selectParentIdData+"&owner="+owner+"&codeTypeObjectId="+codeTypeObjectId);
	}
}
function toModify(){
	if(selectParentIdData==null||selectParentIdData==""){
		//selectParentIdData=costType;
	}else{
		//popWindow(cruConfig.contextPath+"/op/costManager/costTemplateManagerEdit.upmd?pagerAction=edit2Edit&parentId="+selectUpIdData+"&id="+selectParentIdData+"&costType="+costType);
		popWindow("<%=contextPath%>/pm/projectCode/projectCodeManagerEdit.upmd?pagerAction=edit2Edit&parentId="+selectUpIdData+"&owner="+owner+"&codeTypeObjectId="+codeTypeObjectId+"&id="+selectParentIdData);
	}
}
function toDelete(){
	if(confirm('确定要删除吗?')){
		if(selectUpIdData=='root'){
			var sql="update bgp_p6_code set bsflag = '1' where object_id in( select object_id from bgp_p6_code "+
					" start with parent_object_id = '"+selectParentIdData+"'  connect by prior object_id = parent_object_id   union  select '"+selectParentIdData+"' from dual)";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			if(retObject.returnCode!=0) alert(retObject.returnMsg);
			
			sql="update bgp_p6_code_type set bsflag = '1' where object_id = '"+selectParentIdData+"'";
			path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			params = "deleteSql="+sql;
			params += "&ids=";
			retObject = syncRequest('Post',path,params);
			if(retObject.returnCode!=0) alert(retObject.returnMsg);
			refreshTree();
		}else{
			var sql="update bgp_p6_code set bsflag = '1' where object_id in( select object_id from bgp_p6_code "+
					" start with parent_object_id = '"+selectParentIdData+"'  connect by prior object_id = parent_object_id   union  select '"+selectParentIdData+"' from dual)";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			if(retObject.returnCode!=0) alert(retObject.returnMsg);
			refreshTree();
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

function changeOwner(){
	owner=document.getElementById("owner").value;
	
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/pm/projectCode/getProjectCode.srq?owner='+owner,
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
}
</script>
</html>