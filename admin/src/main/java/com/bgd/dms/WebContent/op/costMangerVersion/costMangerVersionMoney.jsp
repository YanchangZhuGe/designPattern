<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>

<%
	String projectId=null;
	String contextPath = request.getContextPath();
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String extPath = contextPath + "/js/ext-min";
	 projectId= request.getParameter("projectInfoNo");
	
	 if(projectId==null||"".equals(projectId)){
		Cookie[] cookies=request.getCookies();
		for(Cookie i : cookies){
			if("costProjectInfoNo".equals(i.getName())){
				projectId=i.getValue();
			}
		}	
	}
	String org_subjection_id= user.getSubOrgIDofAffordOrg();
	List<Map> listProjectInfo=OPCommonUtil.getVirtualProjectInfoData(org_subjection_id);
	for(Map map:listProjectInfo){
		if(projectId==null||"".equals(projectId)){
			projectId=(String)map.get("projectInfoNo");
		}
	}
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
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
	
}

var selectParentIdData="";
var selectUpIdData="";
var selectLeafOrParent="";
var costProjectSchemaId='<%=costProjectSchemaId%>';
var nodeGet=null;
var projectInfoNo='<%=projectId%>';

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
            {name : 'gpCostProjectId',type: 'string'},
            {name : 'parentId',type: 'string'},
            {name : 'costName',type: 'string'},
            {name : 'costDetailMoney', type : 'String'},
            {name : 'costDetailDesc', type : 'String'},
            {name : 'leaf', type : 'String'}
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
        enableDD: false,
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
            text: '金额',
            flex: 1,
            sortable: true,
            dataIndex: 'costDetailMoney',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '计算依据',
            flex: 1,
            sortable: true,
            dataIndex: 'costDetailDesc',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', cellclick);
     

    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectParentIdData= rowdata.data.gpCostProjectId;
        selectUpIdData= rowdata.data.parentId;
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
					  	<td width="5%" class="ali3">项目:</td>
					    <td width="5%" class="ali1">
							 <SELECT id="projectInfoNo" onchange=changeProjectInfoNo()  name=projectInfoNo>
						    	<%for(Map map:listProjectInfo) {
						    	%>
						    		<OPTION  value=<%=map.get("projectInfoNo")%> <%=projectId.equals(map.get("projectInfoNo"))?"selected='selected'":""%>><%=map.get("projectName")%></OPTION>
						    	<%} %>
							</SELECT>
						</td>
						
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
					    <!--
					    <auth:ListButton css="zr" event="onclick='toImportFromTemplate()'" title="JCDP_btn_import"></auth:ListButton>
					    -->
					    <auth:ListButton css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton>
					    <auth:ListButton functionId="OP_COST_PLAN_EDIT" css="dc" event="onclick='toExportExcel()'" title="JCDP_btn_export"></auth:ListButton>
					    <auth:ListButton functionId="OP_COST_PLAN_EDIT" css="dr" event="onclick='toImportFromExcel()'" title="JCDP_btn_import"></auth:ListButton>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">方案项目基本信息</a></li>
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
											<auth:ListButton css="sc" event="onclick='deleteCostMondyDetail()'" title="JCDP_save"></auth:ListButton>
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
							<td class="inquire_item4">金额：</td>
							<td class="inquire_form4">
							<input name="cost_detail_money" id="cost_detail_money" class="input_width" value="" type="text"  />
							<input name="cost_project_detail_id" id="cost_project_detail_id" class="input_width" value="" type="hidden" />
							<span class='jd'><a href='#' onclick='getTheMoney()'  title='计算'></a></span>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="inquire_item4">计算依据：</td>
							<td class="inquire_form4">
							<textarea  name="cost_detail_desc" id="cost_detail_desc" value=""   class="textarea" >
							</textarea>
							</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display: none">
				    <div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<auth:ListButton css="bc" event="onclick='saveSchemaDetailInfo()'" title="JCDP_save"></auth:ListButton>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item4">工作量：</td>
							<td class="inquire_form4">
							<input name="cost_schema_detail_id" id="cost_schema_detail_id" class="input_width" value=""   type="hidden"/>
							<input name="cost_project_schema_id" id="cost_project_schema_id" class="input_width" value=""   type="hidden"/>
							<textarea  name="work_load" id="work_load" value=""   class="textarea" ></textarea>
							</td>
							<td class="inquire_item4">地表条件：</td>
							<td class="inquire_form4">
							<textarea  name="work_situation" id="work_situation" value=""   class="textarea" ></textarea>
							</td>
						</tr>
						<tr>
							<td class="inquire_item4">施工因素：</td>
							<td class="inquire_form4">
							<textarea  name="work_factor" id="work_factor" value=""   class="textarea" ></textarea>
							</td>
							<td class="inquire_item4">影响施工效率的主要因素：</td>
							<td class="inquire_form4">
							<textarea  name="work_reason" id="work_reason" value=""   class="textarea" ></textarea>
							</td>
						</tr>
						<tr>
							<td class="inquire_item4">用工人数及工期：</td>
							<td class="inquire_form4">
							<textarea  name="work_person" id="work_person" value=""   class="textarea" ></textarea>
							</td>
							<td class="inquire_item4">设备投入情况：</td>
							<td class="inquire_form4">
							<textarea  name="work_device" id="work_device" value=""   class="textarea" ></textarea>
							</td>
						</tr>
					</table>
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

var schDetDataOfSet={
		cost_schema_detail_id:'',
		work_load:'',
		work_situation:'',
		work_factor:'',
		work_reason:'',
		work_device:'',
		work_person:''
};

var cost_project_schema_id = document.getElementById("costProjectSchemaId").value;
var querySql = "select * from bgp_op_cost_project_sch_det where bsflag ='0' and cost_project_schema_id ='"+cost_project_schema_id+"' ";
var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
var datas = queryRet.datas;
debugger;
if(datas != null&&datas.length>0){
	setOneDataInfo(schDetDataOfSet,datas[0]);
}else{
	setOneDataInfo(schDetDataOfSet,null);
}

function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});

function refreshTree(){
	Ext.getCmp('gridId').getStore().load();
	
}

function toImportFromTemplate(){
	if(isAudit())return ;
	popWindow(cruConfig.contextPath+"/op/costManager/costProjectImportTemplate.jsp?projectInfoNo=<%=projectId%>&costProjectSchemaId="+costProjectSchemaId);
}
function refreshData(){
	var project_info_no = document.getElementById("projectInfoNo").value;
	var cost_project_schema_id = document.getElementById("costProjectSchemaId").value;
	var retObject=jcdpCallService('OPCostSrv','refrashCostSchema','project_info_no='+project_info_no+'&cost_project_schema_id='+cost_project_schema_id);
	refreshTreeStore();
	var cost_project_schema_id = document.getElementById("costProjectSchemaId").value;
	var querySql = "select * from bgp_op_cost_project_sch_det where bsflag ='0' and cost_project_schema_id ='"+cost_project_schema_id+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	debugger;
	if(datas != null&&datas.length>0){
		setOneDataInfo(schDetDataOfSet,datas[0]);
	}else{
		setOneDataInfo(schDetDataOfSet,null);
	}
}
function toExportEdition(){
	popWindow(cruConfig.contextPath+"/op/costManager/costProjectEditionDetalEdit.upmd?pagerAction=edit2Add&projectInfoNo="+'<%=projectId%>'+"&costType="+costType+"&costProjectSchemaId="+costProjectSchemaId);
}

function refreshTreeStore(){
	initPage();
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostProject.srq?projectInfoNo='+projectInfoNo+'&costType='+costType+'&costProjectSchemaId='+costProjectSchemaId,
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
}
function toEditCost(){
	if(isAudit())return ;
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

function changeCostVersion(){
	var project_info_no = document.getElementById("projectInfoNo").value;
	var cost_project_schema_id = document.getElementById("costProjectSchemaId").value;
	var retObject=jcdpCallService('OPCostSrv','refrashCostSchema','project_info_no='+project_info_no+'&cost_project_schema_id='+cost_project_schema_id);
	costProjectSchemaId=document.getElementById("costProjectSchemaId").value;
	var cost_project_schema_id = document.getElementById("costProjectSchemaId").value;
	var querySql = "select * from bgp_op_cost_project_sch_det where bsflag ='0' and cost_project_schema_id ='"+cost_project_schema_id+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	debugger;
	if(datas != null&&datas.length>0){
		setOneDataInfo(schDetDataOfSet,datas[0]);
	}else{
		setOneDataInfo(schDetDataOfSet,null);
	}
	
	refreshTreeStore();
}

function deleteCostMondyDetail(){
	if(isAudit())return ;
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var cost_project_detail_id=document.getElementById("cost_project_detail_id").value;
		var cost_detail_money="0"
		var cost_detail_desc="";
		var gpCostProjectId=selectParentIdData;
		
		var tableId=''
		if(cost_project_detail_id!=null&&cost_project_detail_id!=''){
			tableId='&JCDP_TABLE_ID='+cost_project_detail_id;
		}
		var submitStr='JCDP_TABLE_NAME=bgp_op_cost_project_detail'+tableId+'&cost_project_detail_id='+cost_project_detail_id+'&gp_cost_project_id='+gpCostProjectId+'&cost_project_schema_id='+costProjectSchemaId+'&bsflag=0&cost_detail_money='+cost_detail_money+'&cost_detail_desc='+cost_detail_desc;
		var path = cruConfig.contextPath+'/rad/addOrUpdateEntity.srq';
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		if(retObject!=null && retObject.returnCode=='0'){
			alert("保存成功!");
		}
		refreshTreeStore();
		loadDataDetail();
	}
}
function saveCostMondyDetail(){
	if(isAudit())return ;
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var cost_project_detail_id=document.getElementById("cost_project_detail_id").value;
		var cost_detail_money=document.getElementById("cost_detail_money").value;
		var cost_detail_desc=document.getElementById("cost_detail_desc").value;
		cost_detail_desc=encodeURI(cost_detail_desc);
		cost_detail_desc=encodeURI(cost_detail_desc);
		var gpCostProjectId=selectParentIdData;
		
		var tableId=''
		if(cost_project_detail_id!=null&&cost_project_detail_id!=''){
			tableId='&JCDP_TABLE_ID='+cost_project_detail_id;
		}
		var submitStr='JCDP_TABLE_NAME=bgp_op_cost_project_detail'+tableId+'&cost_project_detail_id='+cost_project_detail_id+'&gp_cost_project_id='+gpCostProjectId+'&cost_project_schema_id='+costProjectSchemaId+'&bsflag=0&cost_detail_money='+cost_detail_money+'&cost_detail_desc='+cost_detail_desc;
		var path = cruConfig.contextPath+'/rad/addOrUpdateEntity.srq';
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		if(retObject!=null && retObject.returnCode=='0'){
			alert("保存成功!");
		}
		refreshTreeStore();
		loadDataDetail();
	}
}

function changeProjectInfoNo(){
	window.location="<%=contextPath%>/op/costMangerVersion/costMangerVersionMoney.jsp?projectInfoNo="+document.getElementById("projectInfoNo").value;
}

function convertCalcuFromDesc(desc){
	var m = /^[\u4e00-\u9faf]+$/;
	var n=/^[A-Za-z]+$/;
	var endChar="";
	var lastChar="";
	if(desc!=null&&desc!=undefined){
		var length=desc.length;
		for(var i=0;i<length;i++){
			var tempChar=desc.charAt(i);	
			var flag = m.test(tempChar);
			var flagM=n.test(tempChar);
			if(!flag&&!flagM){
				endChar+=tempChar;	
			}else{
				if(lastChar=='/'){
					endChar=endChar.substr(0, endChar.length-1)
					lastChar="";
				}
			}
			lastChar=tempChar;
		}
	}
	endChar=endChar.replace("%","/100");
	endChar=endChar.replace("％","/100");
	endChar=endChar.replace("×","*");
	endChar=endChar.replace("（","(");
	endChar=endChar.replace("）",")");
	endChar=endChar.replace("、","");
	endChar=endChar.replace("：","");
	endChar=endChar.replace(":","");
	return eval(endChar);
}

function changeProject(projectInfoNo){
	var querySql = "select * from bgp_op_cost_project_schema where project_info_no ='"+projectInfoNo+"' and  bsflag='0'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	$("#costProjectSchemaId").empty();
	if(datas!=null){
		for(var i=0;i<datas.length;i++){
			$("#costProjectSchemaId").append("<option value='"+datas[i].cost_project_schema_id+"'>"+datas[i].schema_name+"</option>")
		}
	}
}
function getTheMoney(){
		var value=convertCalcuFromDesc(document.getElementById("cost_detail_desc").value)
		document.getElementById("cost_detail_money").value=value;
}

function toImportFromExcel(){
	if(isAudit())return ;
	popWindow(cruConfig.contextPath+"/op/costMangerVersion/costManagerImportExcel.jsp?projectInfoNo=<%=projectId%>&costProjectSchemaId="+costProjectSchemaId);
}
function toExportExcel(){
	var project_info_no = document.getElementById("projectInfoNo").value;
	var cost_project_schema_id = document.getElementById("costProjectSchemaId").value;
	var retObject=jcdpCallService('OPCostSrv','refrashCostSchema','project_info_no='+project_info_no+'&cost_project_schema_id='+cost_project_schema_id);
	if(retObject!=null && retObject.returnCode =='0'){
		refreshTree();
	}
	window.open("<%=contextPath%>/op/OPCostSrv/exportCostSchema.srq?project_info_no="+project_info_no+"&cost_project_schema_id="+cost_project_schema_id);
	<%-- window.location="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/op/costMangerVersion/costTemplateTree.xls&filename=costMoney.xls" --%>
}
function toSerach(){
    	var obj=new Object();
    	window.showModalDialog("<%=contextPath%>/op/costProjectManager/costProjectManagerVersionChoose.jsp",obj,"dialogWidth=800px;dialogHeight=600px");
    	document.getElementById("projectInfoNo").value=obj.value.split(',')[0];
    	document.getElementById("costProjectSchemaId").value=obj.value.split(',')[1];
    	projectInfoNo=obj.value.split(',')[0];
    	changeProject(obj.value.split(',')[0]);
    	changeCostVersion();
    }
 function toExportExcel1(){
	 window.location.href="<%=contextPath%>/op/OpCostSrv/exportCostVersionInfo.srq?costProjectSchemaId="+costProjectSchemaId;
 }
 
 function isAudit(){
 		submitStr="projectInfoNo="+document.getElementById("projectInfoNo").value;
		var retObject=jcdpCallService('OPCostSrv','getInformationOfAuditVersion',submitStr)
		var audit=retObject.audit;
		if(audit==true||audit=="true"){
			alert("当前项目已提交一体化论证方案审批，无法对方案进行调整");
			return true;
		}else{
			return false;
		}
 }
 function saveSchemaDetailInfo(){
		var work_load=document.getElementById("work_load").value;
		var work_situation=document.getElementById("work_situation").value;
		var work_factor=document.getElementById("work_factor").value;
		var work_reason=document.getElementById("work_reason").value;
		var work_person=document.getElementById("work_person").value;
		var work_device=document.getElementById("work_device").value;
		var cost_project_schema_id=document.getElementById("costProjectSchemaId").value;
		var cost_schema_detail_id=document.getElementById("cost_schema_detail_id").value;
		
		var tableId=''
		if(cost_schema_detail_id!=null&&cost_schema_detail_id!=''){
			tableId='&JCDP_TABLE_ID=cost_schema_detail_id';
		}
		
		var submitStr='JCDP_TABLE_NAME=bgp_op_cost_project_sch_det'+tableId+'&cost_schema_detail_id='+cost_schema_detail_id;
		
		submitStr+='&work_load='+work_load+'&work_situation='+work_situation+'&work_factor='+work_factor;
		submitStr+='&work_reason='+work_reason+'&work_person='+work_person+'&work_device='+work_device;
		submitStr+='&bsflag=0&cost_project_schema_id='+cost_project_schema_id;
		
		var path = cruConfig.contextPath+'/rad/addOrUpdateEntity.srq';
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		if(retObject!=null && retObject.returnCode =='0'){
			alert("保存成功!");
		}
	}
</script>
</html>