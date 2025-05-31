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
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<title>单价库模板管理</title>
<style type="text/css">

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
            {name : 'priceType', type : 'String'}
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
            url: '<%=contextPath%>/op/OPCostSrv/getPriceTree.srq?price_type=if_delete_change&projectInfoNo=<%=projectInfoNo%>',
            <%-- url: '<%=contextPath%>/op/OpCostSrv/getCostPricePrjAdjustTemplate.srq?costType=01&projectInfoNo=<%=projectInfoNo%>', --%>
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
											<auth:ListButton functionId="OP_ADJUST_PRICE_EDIT" css="bc" event="onclick='saveCostMondyDetail()'" title="JCDP_save"></auth:ListButton>
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
							<input name="price_name" id="price_name" readonly="readonly" class="input_width" value="" type="text"  />
							<input name="price_project_id" id="price_project_id"  class="input_width" value="" type="hidden" />
							<input name="price_template_id" id="price_template_id"  class="input_width" value="" type="hidden" />
							<input name="project_info_no" id="project_info_no"  class="input_width" value="" type="hidden" />
							<input name="node_code" id="node_code"  class="input_width" value="" type="hidden" />
							<input name="order_code" id="order_code"  class="input_width" value="" type="hidden" />
							<input name="parent_id" id="parent_id"  class="input_width" value="" type="hidden" />
							<input name="if_change" id="if_change"  class="input_width" value="" type="hidden" />
							</td>
							<td class="inquire_item6">单价：</td>
							<td class="inquire_form6">
							<input name="price_unit" id="price_unit" value="" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">&nbsp;</td>
							<td class="inquire_form6">&nbsp;
							</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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

var schDetDataOfSet={
			price_project_id:'',
			price_name:'',
			price_template_id:'',
			project_info_no:'',
			node_code:'',
			order_code:'',
			parent_id:'',
			price_unit:'',
			if_change:''
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
			price_unit:'',
			price_template_id:'',
			project_info_no:'',
			node_code:'',
			order_code:'',
			parent_id:'',
			if_change:''
}


function saveCostMondyDetail(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护单价信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某单价");
	}else{
		var gpTargetProjectId=selectParentIdData;
		var ifChange=document.getElementById("if_change").value;
		if(ifChange==null||ifChange==""||ifChange=="undefined"){
			var pricId=document.getElementById("price_project_id").value;
			
			var sql="update bgp_op_price_project_info set if_delete_change = '1' where price_project_id='"+pricId+"'";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
		
			document.getElementById("price_project_id").value="";
			document.getElementById("if_change").value="1";
		}
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
		if(confirm("导入单价信息将覆盖掉现有的单价库，继续导入点击是，否则点击否")){
			var retObject=jcdpCallService('OPCostSrv','saveCostPricePrjByTemplate',submitStr)
		refreshTree();
		}
}
</script>
</html>