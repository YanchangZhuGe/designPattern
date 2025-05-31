<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.bgp.mcs.service.common.CodeSelectOptionsUtil"%>
<%@page import="java.util.*"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>评价基础</title>
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
var selectParentNameData = "";
var selectDataId = "";
var selectDataText = "";
var selectDataDesc = "";
var selectDataType = "";
var selectDataLevel = "";

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
            {name : 'riskName',type: 'String'},
            {name : 'riskDesc', type : 'String'},
            {name : 'riskId', type : 'String'},
            {name : 'parentRiskId', type : 'String'},
            {name : 'orderNum', type : 'String'},
            {name : 'riskLevel', type : 'String'},
            {name : 'riskTypeName', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/risk/getRiskBasics.srq',
            reader: {
                type : 'json'
            }
        },
        folderSort: false
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        width: document.body.clientWidth,
        height:document.body.clientHeight*0.45, 
        autoHeight: true,  
        lines: false,
        enableDD: false, 
        renderTo: 'menuTree',
        collapsible: false,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        folderSort:false,
        singleExpand: false,
        enableDD: false, 
        viewConfig: {
            plugins: {
                ptype: 'treeviewdragdrop',
                appendOnly:false,
                allowParentInsert:false
            } 
        },
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn', //this is so we know which column will show the tree
            text: '风险名称',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'riskName'
        },{
            //xtype: 'treecolumn', //this is so we know which column will show the tree
            text: '风险级别',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'riskLevel'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'treecolumn',
            text: '风险类型',
            flex: 1,
            sortable: true,
            dataIndex: 'riskTypeName',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectParentIdData= rowdata.data.parentRiskId;//父节点
        selectUpIdData= rowdata.data.riskId;//当前记录id
        loadDataDetail();
        getRiskInfo(selectUpIdData);
    });
    grid.addListener('celldblclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
		selectDataId= rowdata.data.riskId;//当前记录id
		selectDataText = rowdata.data.riskName;//当前记录text
		selectDataDesc = rowdata.data.riskDesc;
		selectDataType = rowdata.data.riskTypeName;
		selectDataLevel = rowdata.data.riskLevel;
				
		window.opener.setRiskIdentify(selectDataId,selectDataText,selectDataLevel,selectDataType,selectDataDesc);
				
		window.close();
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
					   <td width="20%" class="ali1">&nbsp;</td>
					  </tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
					<div id="menuTree" style="width:100%;height:auto;overflow:auto;z-index: 0"></div>
		</div>
		<div id="fenye_box" style="height: 0px"></div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">标签2</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">文档</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">流程</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">标签5</a></li>
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable" class="tab_line_height">
					  <tr>
					    <td class="inquire_item4">名称：</td>
					    <td class="inquire_form4" id="item0_0"><input type="text" id="risk_name" name="risk_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">类型：</td>
					    <td class="inquire_form4" id="item0_1"><input type="text" id="risk_type" name="risk_type" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item4">创建时间：</td>
					    <td class="inquire_form4" id="item0_2"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">创建人：</td>
					    <td class="inquire_form4" id="item0_3"><input type="text" id="creator_name" name="create_date" class="input_width" readonly="readonly"/></td>
					  </tr>		
					  <tr>
					    <td class="inquire_item4">评级：</td>
					    <td class="inquire_form4" id="item0_4"><input type="text" id="risk_level" name="risk_level" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">排序编号：</td>
					    <td class="inquire_form4" id="item0_5"><input type="text" id="order_num" name="order_num" class="input_width" readonly="readonly"/></td>
					  </tr>		
					  <tr>
					    <td class="inquire_item4">描述：</td>
					    <td class="inquire_form4" id="item0_6">
					    <textarea cols="58" rows="3" id="risk_desc" name="risk_desc" readonly="readonly"></textarea>	
					    </td>
					    <td class="inquire_item4">&nbsp;</td>
					    <td class="inquire_form4">&nbsp;</td>
					  </tr>				  
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
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

$(document).ready(function() {
	var oLine = $("#line")[0];
	oLine.onmousedown = function(e) {
		var disY = (e || event).clientY;
		oLine.top = oLine.offsetTop;
		document.onmousemove = function(e) {
			var iT = oLine.top + ((e || event).clientY - disY)-70;
			$("#table_box").css("height",iT);
			//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-27);
			setTabBoxHeight();
		};
		document.onmouseup = function() {
			document.onmousemove = null;
			document.onmouseup = null;
			oLine.releaseCapture && oLine.releaseCapture();
		};
		oLine.setCapture && oLine.setCapture();
		return false;
	};
}
);


function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});


function toAdd(){
	if(selectUpIdData==null||selectUpIdData==""){
		//如果没选节点，默认是根节点
		selectUpIdData="root";
	}
	//popWindow(cruConfig.contextPath+"/risk/multiproject/edit_evaluatebase.upmd?pagerAction=edit2Add&parentId="+selectParentIdData);
	if(selectParentIdData!=null||selectParentIdData!=""){
		//popWindow(cruConfig.contextPath+"/risk/multiproject/edit_evaluatebase.upmd?pagerAction=edit2Add&parentId="+selectUpIdData);
		popWindow(cruConfig.contextPath+"/risk/multiproject/edit_evaluatebase.jsp?pageAction=Add&parentId="+selectUpIdData);
	}
}
function toModify(){
	if(selectUpIdData=='root'){
		alert("不能编辑根节点");
		return;
	}
	if(selectParentIdData==null||selectParentIdData==""){
		alert("请选择一条数据");
	}else{
		popWindow(cruConfig.contextPath+"/risk/multiproject/edit_evaluatebase.jsp?pageAction=Edit&parentId="+selectParentIdData+"&id="+selectUpIdData);
	}
	clearInfo();
}
function toDelete(){
	alert("toDelete");
	if(selectUpIdData=='root'){
		alert("模板类型节点不允许在此删除");
	}else{
		var sql="update bgp_risk_evaluate_base set bsflag = '1' where risk_id in (select risk_id from bgp_risk_evaluate_base "+
				" start with parent_risk_id = '"+selectUpIdData+"'  connect by prior risk_id = parent_risk_id   union  select '"+selectUpIdData+"' from dual)";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids=";
		var retObject = syncRequest('Post',path,params);
		if(retObject.returnCode!=0) alert(retObject.returnMsg);
		refreshTree();
	}
	clearInfo();
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

function changeCostType(){
	costType=document.getElementById("codeTemplateType").value;
	
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostTemplate.srq?costType='+costType,
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
}

var selectedTagIndex = 0;
var showTabBox = document.getElementById("tab_box_content0");

function loadDataDetail(){
	document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+selectParentIdData;
}
function getRiskInfo(id){
	var retObj = jcdpCallService("riskSrv", "getRiskInfo", "riskID="+id);
	document.getElementById("risk_name").value= retObj.riskInfoMap.risk_name != undefined ? retObj.riskInfoMap.risk_name:"";
	document.getElementById("risk_desc").innerHTML= retObj.riskInfoMap.risk_desc != undefined ? retObj.riskInfoMap.risk_desc:"";
	document.getElementById("create_date").value= retObj.riskInfoMap.create_date != undefined ? retObj.riskInfoMap.create_date:"";
	document.getElementById("creator_name").value= retObj.riskInfoMap.creator_name != undefined ? retObj.riskInfoMap.creator_name:"";
	document.getElementById("risk_type").value= retObj.riskInfoMap.risk_type != undefined ? retObj.riskInfoMap.risk_type:"";
	document.getElementById("risk_level").value = retObj.riskInfoMap.risk_level != undefined ? retObj.riskInfoMap.risk_level:"";
	document.getElementById("order_num").value = retObj.riskInfoMap.order_num != undefined ? retObj.riskInfoMap.order_num:"";
}
function clearInfo(){
	var qTable = getObj('commonInfoTable');
	for (var i=0;i<qTable.all.length; i++) {
		var obj = qTable.all[i];
		if(obj.name==undefined || obj.name=='') continue;
		
		if (obj.tagName == "INPUT") {
			if(obj.type == "text") 	obj.value = "";		
		}
	}
	document.getElementById("risk_desc").innerHTML = "";
	document.getElementById("attachement").src = "";
}
</script>
</html>