<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String extPath = contextPath + "/js/ext-min";
	String projectId= user.getProjectInfoNo();
	List<Map> list=OPCommonUtil.getCostVersionData(projectId);
	String costProjectSchemaId=null;
	for(Map map:list){
		if(costProjectSchemaId==null){
			costProjectSchemaId=(String)map.get("costProjectSchemaId");
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
<title>项目费用管理</title>
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

cruConfig.contextPath='<%=contextPath%>';


var costType="";

function initPage(){
	//获取当前项目的费用管理信息
	var submitStr="projectInfoNo="+'<%=projectId%>';
	var retObject=jcdpCallService('OPCostSrv','getProjectCostType',submitStr);
	costType=retObject.costType;
	
	loadCostEditionData();
}

var selectParentIdData="";
var selectUpIdData="";
var selectLeafOrParent="";
var costProjectSchemaId='<%=costProjectSchemaId%>';
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
            url: '<%=contextPath%>/op/OpCostSrv/getCostProject.srq?projectInfoNo=<%=projectId%>&costType='+costType+'&costProjectSchemaId='+costProjectSchemaId,
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
            			url:'<%=contextPath%>/op/OpCostSrv/saveCostProjectOrder.srq',
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
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '金额',
            flex: 1,
            sortable: true,
            dataIndex: 'costDetailMoney',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '描述',
            flex: 1,
            sortable: true,
            dataIndex: 'costDetailDesc',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '属性3',
            flex: 1,
            sortable: true,
            dataIndex: 'cost1',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '属性4',
            flex: 1,
            sortable: true,
            dataIndex: 'cost1',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', cellclick);

    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectParentIdData= rowdata.data.gpCostTempId;
        selectUpIdData= rowdata.data.zip;
        selectLeafOrParent=rowdata.data.leaf;
        loadDataDetail();
    }
});

</script>
</head>
<body  style="background:#fff" onload="initPage()">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="5%" class="ali3">方案:</td>
					    <td width="5%" class="ali1">
							 <SELECT id=costProjectSchemaId onchange=changeCostVersion()  name=codeProjectVersion>
						    	<%for(Map map:list) {
						    	%>
						    		<OPTION value=<%=map.get("costProjectSchemaId")%>><%=map.get("schemaName")%></OPTION>
						    	<%} %>
							</SELECT>
						</td>
					    <td>&nbsp;</td>
					    <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
					    <auth:ListButton css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
					    <auth:ListButton css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
					    <auth:ListButton css="dr" event="onclick='toImportFromTemplate()'" title="JCDP_btn_import"></auth:ListButton>
					    <auth:ListButton css="hz" event="onclick='toExportEdition()'" title="JCDP_btn_export"></auth:ListButton>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">费用金额</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">版本</a></li>
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
										<tr align="right">
											<td>&nbsp;</td>
											<auth:ListButton css="bc" event="onclick='saveCostMondyDetail()'" title="JCDP_save"></auth:ListButton>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item6">费用金额：</td>
							<td class="inquire_form6">
							<input name="cost_detail_money" id="cost_detail_money" class="input_width" value="" type="text"  />
							<input name="cost_project_detail_id" id="cost_project_detail_id" class="input_width" value="" type="hidden" />
							</td>
							<td class="inquire_item6">描述依据：</td>
							<td class="inquire_form6">
							<input name="cost_detail_desc" id="cost_detail_desc" value="" class="input_width" type="text"  />
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table id="editionList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>版本号</td>
				            <td>版本描述</td>		
				            <td>起草人</td>
				            <td>起草时间</td>
				        </tr>            
			        </table>
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
var selectedTagIndex = 0;

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
	popWindow(cruConfig.contextPath+"/op/costManager/costProjectManagerEdit.upmd?pagerAction=edit2Add&parentId="+selectParentIdData+"&costType="+costType+"&projectInfoNo=<%=projectId%>");
}
function toModify(){
	if(selectParentIdData==null||selectParentIdData==""){
		selectParentIdData=costType;
	}else{
		popWindow(cruConfig.contextPath+"/op/costManager/costProjectManagerEdit.upmd?pagerAction=edit2Edit&parentId="+selectUpIdData+"&id="+selectParentIdData+"&costType="+costType+"&projectInfoNo=<%=projectId%>");
	}
}
function toDelete(){
	if(selectUpIdData=='root'){
		alert("模板类型节点不允许在此删除");
	}else{
		var sql="delete from  bgp_op_cost_project_info where gp_cost_project_id in (select gp_cost_project_id from bgp_op_cost_project_info "+
				" start with parent_id = '"+selectParentIdData+"'  connect by prior gp_cost_project_id = parent_id   union  select '"+selectParentIdData+"' from dual)";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids=";
		var retObject = syncRequest('Post',path,params);
		if(retObject.returnCode!=0) alert(retObject.returnMsg);
		refreshTree();
	}
}

function refreshTree(){
	Ext.getCmp('gridId').getStore().load();
}

function toImportFromTemplate(){
	popWindow(cruConfig.contextPath+"/op/costManager/costProjectImportTemplate.jsp?projectInfoNo="+'<%=projectId%>');
}


function toExportEdition(){
	popWindow(cruConfig.contextPath+"/op/costManager/costProjectEditionDetalEdit.upmd?pagerAction=edit2Add&projectInfoNo="+'<%=projectId%>'+"&costType="+costType+"&costProjectSchemaId="+costProjectSchemaId);
}

function refreshTreeStore(){
	initPage();
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostProject.srq?projectInfoNo=<%=projectId%>&costType='+costType+'&costProjectSchemaId='+costProjectSchemaId,
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
}

function loadDataDetail(){
	
	//载入费用详细信息
	var querySql = "select * from bgp_op_cost_project_detail where gp_cost_project_id ='"+selectParentIdData+"' and cost_project_schema_id = '"+costProjectSchemaId+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		document.getElementById("cost_project_detail_id").value=datas[0].cost_project_detail_id;
		document.getElementById("cost_detail_money").value=datas[0].cost_detail_money;
		document.getElementById("cost_detail_desc").value=datas[0].cost_detail_desc;
	}else{
		document.getElementById("cost_project_detail_id").value='';
		document.getElementById("cost_detail_money").value='';
		document.getElementById("cost_detail_desc").value='';
	}
	//载入文档信息
	document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+selectParentIdData;
}
function toEditCost(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var costProjectDetailId=document.getElementById("cost_project_detail_id").value;
		if(costProjectDetailId==null||costProjectDetailId==""){
			popWindow(cruConfig.contextPath+"/op/costManager/costProjectManagerDetalEdit.upmd?pagerAction=edit2Add&gpCostProjectId="+selectParentIdData+"&costProjectSchemaId="+costProjectSchemaId);
		}else{
			popWindow(cruConfig.contextPath+"/op/costManager/costProjectManagerDetalEdit.upmd?pagerAction=edit2Edit&gpCostProjectId="+selectParentIdData+"&id="+costProjectDetailId+"&costProjectSchemaId="+costProjectSchemaId);
		}
	}
}


function deleteTableTr(tableID){
	var tb = document.getElementById(tableID);
     var rowNum=tb.rows.length;
     for (var i=1;i<rowNum;i++)
     {
         tb.deleteRow(i);
         rowNum=rowNum-1;
         i=i-1;
     }
}

//载入当前项目版本信息
function loadCostEditionData(){
	var queryEditionSql = "select rownum, p.* from (select * from bgp_op_cost_project_edition t where t.cost_project_schema_id='"+costProjectSchemaId+"' and t.project_info_no='"+'<%=projectId%>'+"' and t.bsflag='0' ) p";
	var queryEditionRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+queryEditionSql);
	var editionDatas = queryEditionRet.datas;
	
	deleteTableTr("editionList");
	
	if(editionDatas != null){
		for (var i = 0; i< editionDatas.length; i++) {
			var tr = document.getElementById("editionList").insertRow();		
          	if(i % 2 == 1){  
          		tr.className = "odd";
			}else{ 
				tr.className = "even";
			}
			var td = tr.insertCell(0);
			td.innerHTML = editionDatas[i].rownum;
			var td = tr.insertCell(1);
			td.innerHTML = editionDatas[i].edition_no;
			var td = tr.insertCell(2);
			td.innerHTML = editionDatas[i].title;
			var td = tr.insertCell(3);
			td.innerHTML = editionDatas[i].creator;
			var td = tr.insertCell(4);
			td.innerHTML = editionDatas[i].create_date;
		}
	}	
}
function changeCostVersion(){
	costProjectSchemaId=document.getElementById("costProjectSchemaId").value;
	refreshTreeStore();
	loadCostEditionData();
}

function saveCostMondyDetail(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var cost_project_detail_id=document.getElementById("cost_project_detail_id").value;
		var cost_detail_money=document.getElementById("cost_detail_money").value;
		var cost_detail_desc=document.getElementById("cost_detail_desc").value;
		var gpCostProjectId=selectParentIdData;
		
		var tableId=''
		if(cost_project_detail_id!=null&&cost_project_detail_id!=''){
			tableId='&JCDP_TABLE_ID='+cost_project_detail_id;
		}
		var submitStr='JCDP_TABLE_NAME=bgp_op_cost_project_detail'+tableId+'&cost_project_detail_id='+cost_project_detail_id+'&gp_cost_project_id='+gpCostProjectId+'&cost_project_schema_id='+costProjectSchemaId+'&bsflag=0&cost_detail_money='+cost_detail_money+'&cost_detail_desc='+cost_detail_desc;
		var path = cruConfig.contextPath+'/rad/addOrUpdateEntity.srq';
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		refreshTreeStore();
		loadDataDetail();
	}
}
</script>
</html>