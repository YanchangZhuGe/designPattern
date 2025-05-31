<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.bgp.mcs.service.common.CodeSelectOptionsUtil"%>
<%@page import="java.util.*"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo= user.getProjectInfoNo();
	String project_name = user.getProjectName();
	String cdate=OPCommonUtil.getCostPricePrjDate(projectInfoNo);
	
	boolean proc_status = OPCommonUtil.getProcessStatus("BGP_OP_TARGET_PROJECT_BASIC","tartget_basic_id","5110000004100000009",projectInfoNo);
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
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<title>单价库模板管理</title>
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
var costType='01';
var selectedTagIndex = 0;
var selectParentIdData="";
var selectUpIdData="";
var nodeGet=null;
var select_node = null;
var price_project_id = null;
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
            {name : 'priceName',type: 'string'},
            {name : 'priceUnit', type : 'String'},
            {name : 'priceType', type : 'String'}//,
            //{name : 'leaf', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	root:{
    		id:'root',
    		priceName:'<%=project_name%>',
    		priceUnit:'',
    		expanded:true
    	},
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OPCostSrv/getPriceTree.srq?price_type=if_change&projectInfoNo=<%=projectInfoNo%>',
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
            text: '名称',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'priceName'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '价格(元)',
            flex: 1,
            sortable: true,
            dataIndex: 'priceUnit',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
    	select_node = rowdata.parentNode;
    	price_project_id = rowdata.data.id;
		selectParentIdData= rowdata.data.id;
		
        selectUpIdData= rowdata.data.zip;
		selectLeafOrParent=rowdata.data.leaf;
        var price_type = rowdata.data.priceType;
        document.getElementById("price_type").options[price_type].selected = true;
        loadDataDetail();
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
					    <td>&nbsp;<span style="color: red">
					    <%if(cdate!=null&&!"".equals(cdate)&&!"null".equals(cdate)){%>
					    	当前单价库导入时间：<%=cdate%>
					    <%}%>
					    </span>
					    </td>
					    
			    		<%-- <auth:ListButton css="dr" event="onclick='toImport()'" title="重新导入"></auth:ListButton> --%>
			    		<%if(proc_status){ %>
			    		<auth:ListButton functionId="OP_PRICE_EDIT" css="qr" event="onclick='toImportChange()'" title="导入单价库"></auth:ListButton>
					  	<auth:ListButton functionId="OP_PRICE_EDIT" css="dc" event="onclick='exportExcel()'" title="JCDP_btn_export"></auth:ListButton>
						<auth:ListButton functionId="OP_PRICE_EDIT" css="dr" event="onclick='importExcel()'" title="JCDP_btn_import"></auth:ListButton>
					  	<%} %>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">单价信息</a></li>
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
											<%if(proc_status){ %>
											<auth:ListButton css="bc" event="onclick='saveCostMondyDetail()'" title="JCDP_save"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item6">名称：</td>
							<td class="inquire_form6">
							<input name="price_name" id="price_name" class="input_width" value="" type="text"  />
							<input name="price_project_id" id="price_project_id"  class="input_width" value="" type="hidden" />
							</td>
							<td class="inquire_item6">单价：</td>
							<td class="inquire_form6">
							<input name="price_unit" id="price_unit" value="" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6" style="display: none;">单价类型：</td>
							<td class="inquire_form6" style="display: none;">
							<select id="price_type" name="price_type" class="select_width">
								<option value="0">手动</option>
								<option value="1">物资</option>
							</select>
							</td>
						</tr>
						<!-- <tr>
							
							<td class="inquire_item6">物资编码：</td>
							<td class="inquire_form6">
							<input name="mat_id" id="mat_id" value="" class="input_width" type="text"  />
							</td>
						</tr> -->
					</table>
				</div>
		</div>
	</div>
</body>
<script type="text/javascript">
$(document).ready(readyForSetHeight);

frameSize();

$(document).ready(lashen);

cruConfig.contextPath =  "<%=contextPath%>";

function toAdd(){
	if(selectParentIdData==null||selectParentIdData==""){
		selectParentIdData=costType;
	}
	popWindow(cruConfig.contextPath+"/op/costPriceBank/costPriceTemplateEdit.upmd?pagerAction=edit2Add&parentId="+selectParentIdData+"&costType="+costType);
}
function toModify(){
	if(selectParentIdData==null||selectParentIdData==""){
		selectParentIdData=costType;
	}else{
		popWindow(cruConfig.contextPath+"/op/costPriceBank/costPriceTemplateEdit.upmd?pagerAction=edit2Edit&parentId="+selectUpIdData+"&id="+selectParentIdData+"&costType="+costType);
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
	var path = tree.getSelectionModel().getSelectedNode().getPath('id');
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

var schDetDataOfSet={
			price_project_id:'',
			price_name:'',
			price_unit:''//,
			//mat_id:''
};
function loadDataDetail(ids){
	//载入费用详细信息
	var querySql = "select * from bgp_op_price_project_info where bsflag='0' and PRICE_PROJECT_ID='"+selectParentIdData+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		setOneDataInfo(schDetDataOfSet,datas[0]);
	}else{
		setOneDataInfo(schDetDataOfSet,null);
	}
}

var costDetailDataOfSet={
			price_name:'',
			price_unit:''
}


function saveCostMondyDetail(){
	//var select_node = tree.getSelectionModel().lastSelected;
	if(selectLeafOrParent==false){
		alert("非根节点无法维护单价信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某单价");
	}else{
		var gpTargetProjectId=selectParentIdData;
		saveSingleTableInfoByData(costDetailDataOfSet,'bgp_op_price_project_info','price_project_id');
		var node = Ext.getCmp('gridId').getStore().getNodeById(price_project_id);
		var path = node.getPath();
		Ext.getCmp('gridId').getStore().load({node:select_node});
		
		loadDataDetail();
	}
}

function toImport(){
		var costType='01';
		var submitStr="projectInfoNo=<%=projectInfoNo%>&costType="+costType;
		if(confirm("导入单价信息将附带掉现有的单价库，继续导入点击是，否则点击否")){
			var retObject=jcdpCallService('OPCostSrv','saveCostPricePrjByTemplate',submitStr)
		refreshTree();
		}
}

function toImportChange(){
		var costType='01';
		var submitStr="projectInfoNo=<%=projectInfoNo%>&costType="+costType;
		if(confirm("导入单价信息将附带掉现有的单价库，继续导入点击是，否则点击否")){
			var retObject=jcdpCallService('OPCostSrv','saveCostPricePrjByTemplateChange',submitStr)
			refreshTree();
		}
}
function exportExcel(){
	window.open("<%=contextPath%>/op/OPCostSrv/exportPrice.srq");
}

function importExcel(){
	popWindow("<%=contextPath%>/op/costPriceBank/import_excel.jsp");
}
</script>
</html>