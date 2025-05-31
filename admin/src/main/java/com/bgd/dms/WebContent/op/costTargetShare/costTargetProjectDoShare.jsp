<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8" %>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>

<%
	String contextPath = request.getContextPath();

	String moneyInfo=request.getParameter("moneyInfo");
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectId= user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>项目目标费用管理</title>
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
		url('<%=contextPath%>/images/images/tree_10.png')
}

.x-tree-icon-parent {
	width: 16px;
	background-image:
		url('<%=contextPath%>/images/images/tree_10.png')
}

.x-grid-tree-node-expanded .x-tree-icon-parent {
	background-image:
		url('<%=contextPath%>/images/images/tree_10.png')
}


</style>
<style type="text/css">
    .task {
        background-image: url(<%=contextPath%>/shared/icons/fam/cog.gif) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/shared/icons/fam/folder_go.gif) !important;
    }
</style>
<script type="text/javascript" language="javascript">

var costType="";

function initPage(){
	//获取当前项目的费用管理信息
	var submitStr="projectInfoNo="+'<%=projectId%>';
	var retObject=jcdpCallService('OPCostSrv','getProjectCostTargetType',submitStr);
	costType=retObject.costType;
}

var selectParentIdData="";
var selectUpIdData="";
var selectLeafOrParent="";
cruConfig.contextPath = "<%=contextPath%>";
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
            {name : 'costName',type: 'string'},
            {name : 'costDesc', type : 'String'},
            {name : 'gpCostTempId', type : 'String'},
            {name : 'zip', type : 'String'},
            {name : 'orderCode', type : 'String'},
            {name : 'costDetailMoney', type : 'String'},
            {name : 'costDetailDesc', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OpCostSrv/getCostTargetProject.srq?projectInfoNo=<%=projectId%>&costType='+costType+'&ifcheck=true',
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        width: document.body.clientWidth*0.95,
        height:document.body.clientHeight*0.62,
        autoHeight: true,
        lines: true,
        renderTo: 'menuTree',
        enableDD: true,
        viewConfig: {
            plugins: {
                ptype: 'treeviewdragdrop'
            },
            listeners: {
                beforedrop: function (node,data,overModel,dropPosition,eOpts ) {
                	var sourceNode=data.records[0].data;
                	var targetNode=overModel.data;
                	var beforeOrAfter=dropPosition;
                	Ext.Ajax.request({
            			url:'<%=contextPath%>/op/OpCostSrv/saveCostTargetProjectOrder.srq',
            			params:{
            				sourceNodeZip:sourceNode.zip,
            				sourceNodeIndex:sourceNode.orderCode,
            				sourceNodeId:sourceNode.gpCostTempId,
            				targetNodeZip:targetNode.zip,
            				targetNodeIndex:targetNode.orderCode,
            				targetNodeId:targetNode.gpCostTempId,
            				beforeOrAfter:beforeOrAfter
                			}
                		});
            	}
            }
        },

        collapsible: false,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn', //this is so we know which column will show the tree
            text: '费用名称',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'costName'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '费用描述',
            flex: 1,
            sortable: true,
            dataIndex: 'costDesc',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', cellclick);
    grid.addListener('checkchange', checkchange);
    function checkchange(node,checked,eOpts ){
    	if(checked){
    		insertRow(node.data.gpCostTempId,node.data.costName);
    	}else{
    		deleteRow(node.data.gpCostTempId);
    	}
    }
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
    	
    }
});

</script>
</head>
<body  style="background:#fff" onload="initPage()">
	<div id="list_table">
		<div id="table_box" style="height: 190px">
					<div id="menuTree"></div>
		</div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">费用金额</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">标签2</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">文档</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">流程</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">标签5</a></li>
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="left">
											<td width="90%"><%=moneyInfo %>&nbsp;</td>
											<td><span class="tj"><a href="#" onclick="toSaveShare()"></a></span></td>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table id="editionList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
			                <td class="bt_info_odd">费用科目</td>
			                <td  class="bt_info_even">费用金额</td>
			                <td class="bt_info_odd">费用描述</td>		
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">

				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var selectedTagIndex = 0;
var count=0;
function toSaveShare(){
	var retObj = jcdpCallService("OPCostSrv", "saveDeviceShareInfoToTarget", getSubmitStr());
	 if(retObj.success=="true"){
		 alert("保存成功");
	 }
}

function insertRow(id,name){
	i=count;
	var tr = document.getElementById("editionList").insertRow();
	tr.id=id;
	var td = tr.insertCell(0);
	td.innerHTML = name+'<input type="hidden" id="fy'+i+'gp_target_project_id" name="fy'+i+'gp_target_project_id" value="'+id+'" class="input_width"/>';
	var td = tr.insertCell(1);
	td.innerHTML = '<input type="text" id="fy'+i+'cost_detail_money" name="fy'+i+'cost_detail_money" value="" class="input_width"/>';
	var td = tr.insertCell(2);
	td.innerHTML = '<input type="text" id="fy'+i+'cost_detail_desc" name="fy'+i+'cost_detail_desc" value="" class="input_width"/>';
	count++;
}
function deleteRow(id){
	var tr=document.getElementById(id);
	tr.parentNode.removeChild(tr);
}

function getSubmitStr(){
	var submitStr="count="+count;
	for(var i=0;i<count;i++){
		if(document.getElementById("fy"+i+"gp_target_project_id")!=null){
			submitStr+="&fy"+i+"gp_target_project_id="+document.getElementById("fy"+i+"gp_target_project_id").value;
			submitStr+="&fy"+i+"cost_detail_money="+document.getElementById("fy"+i+"cost_detail_money").value;
			submitStr+="&fy"+i+"cost_detail_desc="+document.getElementById("fy"+i+"cost_detail_desc").value;
		}
	}
	return submitStr;
}
</script>
</html>