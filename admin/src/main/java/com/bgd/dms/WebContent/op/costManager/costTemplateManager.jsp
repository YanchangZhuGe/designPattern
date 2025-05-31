<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@ page import="com.bgp.mcs.service.common.CodeSelectOptionsUtil"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	List list=CodeSelectOptionsUtil.getOptionByName("costTemplateType");
	String costType="";
	if (list != null && list.size() > 0) {
		Map mapCode = (Map) list.get(0);
		if (mapCode != null) {
			costType = (String) mapCode.get("value");
		}
	}
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
<title>费用模板管理</title>
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
        background-image: url(<%=contextPath%>/images/images/tree_10.png) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/images/images/tree_10.png) !important;
    }
</style>
<script type="text/javascript" language="javascript">

cruConfig.contextPath = "<%=contextPath%>";
//var costType="<%=costType%>";
var costType="01";
var selectedTagIndex = 0;

var selectParentIdData="";
var selectUpIdData="";
var selectLeafOrParent="";
var template_id = "";
var parent_id = "";
var nodeGet=null;
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
            {name : 'costName',type: 'string'},
            {name : 'costDesc', type : 'String'},
            {name : 'templateId', type : 'String'},
            {name : 'zip', type : 'String'},
            {name : 'orderCode', type : 'String'},
            {name : 'formulaType', type : 'String'},
            {name : 'formulaTypeName', type : 'String'},
            {name : 'formulaContent', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
		root: {
			id:'root',
			templateId:'01',
			parentId:'root',
			costName:'东方地球物理公司',
			costDesc:'',
			zip:'root',
            expanded: true
        },
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OpCostSrv/getCostTemplate.srq?costType='+costType,
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
        enableDD: true, 
        viewConfig: {
            plugins: {
                ptype: 'treeviewdragdrop',
                appendOnly:false,
                allowParentInsert:false
            },
            listeners: { 
                beforedrop: function (node,data,overModel,dropPosition,dropHandler ,eOpts ) {
                	var sourceNode=data.records[0].data;
                	var targetNode=overModel.data;
                	var beforeOrAfter=dropPosition;
                	if(sourceNode.zip!=targetNode.zip){
                		dropHandler.cancelDrop();
                	}else{
                		Ext.Ajax.request({  
                			url:'<%=contextPath%>/op/OpCostSrv/saveCostTemplateOrder.srq',
                			params:{  
                				sourceNodeZip:sourceNode.zip,
                				sourceNodeIndex:sourceNode.orderCode,
                				sourceNodeId:sourceNode.templateId,
                				targetNodeZip:targetNode.zip,
                				targetNodeIndex:targetNode.orderCode,
                				targetNodeId:targetNode.templateId,
                				beforeOrAfter:beforeOrAfter
                    			}  
                    		});  
                	}
            	} 
            } 
        },
        renderTo: 'menuTree',
        collapsible: false,
        useArrows: false,
        rootVisible: true,
        store: store,
        multiSelect: false,
        folderSort:false,
        singleExpand: false,
        EnableDD:true,
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
            text: '维护类型',
            flex: 1,
            sortable: true,
            width:20,
            dataIndex: 'formulaTypeName',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '公式内容',
            flex: 4,
            sortable: true,
            dataIndex: 'formulaContent',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectParentIdData= rowdata.data.templateId;
        selectUpIdData= rowdata.data.zip;
        selectLeafOrParent=rowdata.data.leaf;
        loadDataDetail();
        template_id = rowdata.data.id;
        parent_id = rowdata.parentNode.data.id;
    });
    
   // grid.addListener('load', load);
    function load(treeStore,node,records,sucess){
    	ifFind=false;
    	getChildBySpecial(records);
    	if(nodeGet!=null&&nodeGet!=undefined){
    		grid.selectPath(nodeGet.getPath("templateId"),"templateId");
    	}
    }
    
    
    function getChildBySpecial(records){
    	for(var i=0;i<records.length;i++){
    		var data=records[i].data;
    		if(data.templateId==selectParentIdData){
    			nodeGet= records[i];	
    		}else{
    			getChildBySpecial(records[i].childNodes);
    		}
    	}
    }
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
					    <td>&nbsp;</td>
					    <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    		<auth:ListButton css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			    		<auth:ListButton css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">公式维护</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">文档</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">流程</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
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
										<tr align="right">
											<td>&nbsp;</td>
											<auth:ListButton css="bc" event="onclick='saveCostFormula()'" title="JCDP_btn_save"></auth:ListButton>
											<auth:ListButton css="sc" event="onclick='deleteCostFormula()'" title="JCDP_btn_delete"></auth:ListButton>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item4">维护类型：</td>
							<td class="inquire_form4">
							<code:codeSelect   name='formula_type' option="opFormulaType" selectedValue=""  addAll="true"/> 
							<input name="template_id" id="template_id" class="input_width" value="" type="hidden" />
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="inquire_item4">计划公式内容：</td>
							<td class="inquire_form4">
							<textarea  name="formula_content" id="formula_content" value=""   class="textarea" ></textarea>
							<span class='jl' style="float: right "><a href='#' onclick='toOpenFormulaTree("formula_content")'  title='打开公式树'></a></span>
							</td>
							<td class="inquire_item4">实际公式内容(若与计划公式相同可不填写)：</td>
							<td class="inquire_form4">
							<textarea  name="formula_content_a" id="formula_content_a" value=""   class="textarea" ></textarea>
							<span class='jl' style="float: right "><a href='#' onclick='toOpenFormulaTree("formula_content_a")'  title='打开公式树'></a></span>
							</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">

				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
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
	if(selectParentIdData==null||selectParentIdData==""){
		selectParentIdData=costType;
	}
	var spare1 = "5000100004000000001";
	var spare5 = "1";
	if(template_id == "5000100004000000009"){
		alert("该节点不允许添加!");
	}else if(template_id.indexOf("5000100004000000009:")!=-1){
		spare1 = template_id.split(":")[0];
		spare5 = template_id.split(":")[1];
		popWindow(cruConfig.contextPath+"/op/costManager/costTemplateManagerEdit.upmd?pagerAction=edit2Add&parentId="+selectParentIdData+"&costType="+costType+"&spare1="+spare1+"&spare5="+spare5);
	}else if(template_id.indexOf("5000100004")==0){
		spare1 = template_id;
		spare5 = "1";
		popWindow(cruConfig.contextPath+"/op/costManager/costTemplateManagerEdit.upmd?pagerAction=edit2Add&parentId="+selectParentIdData+"&costType="+costType+"&spare1="+spare1+"&spare5="+spare5);
	}else{
		spare5 = template_id.split(":")[0];
		spare1 = template_id.split(":")[2];
		popWindow(cruConfig.contextPath+"/op/costManager/costTemplateManagerEdit.upmd?pagerAction=edit2Add&parentId="+selectParentIdData+"&costType="+costType+"&spare1="+spare1+"&spare5="+spare5);
	}
}
function toModify(){
	if(selectParentIdData==null||selectParentIdData==""){
		alert("该节点不允许修改!");
		selectParentIdData=costType;
	}else{
		spare5 = template_id.split(":")[0];
		spare1 = template_id.split(":")[2];
		popWindow(cruConfig.contextPath+"/op/costManager/costTemplateManagerEdit.upmd?pagerAction=edit2Edit&parentId="+selectUpIdData+"&id="+selectParentIdData+"&costType="+costType+"&spare1="+spare1+"&spare5="+spare5);
	}
}
function toDelete(){
	if(selectUpIdData=='root'){
		alert("模板类型节点不允许在此删除");
	}else{
		var sql="update bgp_op_cost_template set bsflag = '1' where template_id in (select template_id from bgp_op_cost_template "+
				" start with parent_id = '"+selectParentIdData+"'  connect by prior template_id = parent_id   union  select '"+selectParentIdData+"' from dual)";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids=";
		var retObject = syncRequest('Post',path,params);
		if(retObject.returnCode!=0) alert(retObject.returnMsg);
		refreshTree();
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

function refreshTreeStore(){
	var node = Ext.getCmp('gridId').getStore().getNodeById(parent_id);
	var options ={node:node};
	Ext.getCmp('gridId').getStore().load(options);
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

function loadDataDetail(){
	//载入公式信息
	var querySql = "select * from BGP_OP_COST_TEMPLATE where template_id ='"+selectParentIdData+"'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		document.getElementById("template_id").value=datas[0].template_id;
		setSelectedValue("formula_type",datas[0].formula_type);
		document.getElementById("formula_content").value=datas[0].formula_content;
		document.getElementById("formula_content_a").value=datas[0].formula_content_a;
	}else{
		document.getElementById("template_id").value='';
		setSelectedValue("formula_type",'');
		document.getElementById("formula_content").value='';
		document.getElementById("formula_content_a").value='';
	}
}

function saveCostFormula(){
	if(selectLeafOrParent==false){
		alert("非叶子节点无法维护公式信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var template_id=document.getElementById("template_id").value;
		var formula_type=document.getElementById("formula_type").value;
		var formula_content=document.getElementById("formula_content").value;
		var formula_content_a=document.getElementById("formula_content_a").value;
		
		var myregexpLeft =  /(^"*)/g;
		var myregexpRight =  /("*$)/g;
		var subject=formula_content;
		var result = subject.replace(myregexpLeft, "");
		result = result.replace(myregexpRight, "");
		formula_content=result;
		 
		
		formula_content_a=formula_content_a.replace(myregexpLeft, "").replace(myregexpRight, "");
		
		formula_content=encodeURI(formula_content);
		formula_content=encodeURI(formula_content);
		
		formula_content_a=encodeURI(formula_content_a);
		formula_content_a=encodeURI(formula_content_a);
		
		var tableId=''
		if(template_id!=null&&template_id!=''){
			tableId='&JCDP_TABLE_ID='+template_id;
		}
		var submitStr='JCDP_TABLE_NAME=BGP_OP_COST_TEMPLATE'+tableId+'&formula_type='+formula_type+'&formula_content='+formula_content+'&bsflag=0&formula_content_a='+formula_content_a;
		var path = cruConfig.contextPath+'/rad/addOrUpdateEntity.srq';
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		loadDataDetail();
		refreshTreeStore();
	}
}
function deleteCostFormula(){
	if(selectLeafOrParent==false){
		alert("非叶子节点无法维护公式信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var id=document.getElementById("template_id").value;
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update BGP_OP_COST_TEMPLATE t set t.formula_type= null,t.formula_content = null where t.template_id ='"+id+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+id;
		syncRequest('Post',path,params);
		loadDataDetail();
		refreshTreeStore();
	}	
}
function setSelectedValue(id,value){
	var selectObj=document.getElementById(id);
	for(var i=0;i<selectObj.options.length;i++ ){
	  if(selectObj.options[i].value==value){
	 	 selectObj.options[i].selected=true;
	 	 return false;
	  }
	}
}

function  toOpenFormulaTree(a){
	 var returnValue=window.showModalDialog(cruConfig.contextPath+"/op/costFormulaManager/costFormulaSelect.jsp");
	appendCostFormula(returnValue,a);
}

function appendCostFormula(someStr,a){
	if(someStr!=null&&someStr!=''&&someStr!=undefined){
		var value=document.getElementById(a).value;
		document.getElementById(a).value=value+someStr;
	}
}
</script>
</html>