<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectId= user.getProjectInfoNo();
	String project_name = user.getProjectName();
	String targetBasicId=OPCommonUtil.getTargetProjectBasicId(projectId);
	boolean proc_status = OPCommonUtil.getProcessStatus2("BGP_OP_TARGET_PROJECT_INFO","gp_target_project_id","5110000004100000032",projectId);
	String project_type = user.getProjectType();
	String spare5 = "1";
	if(project_type.trim().equals("5000100004000000009")){
		spare5= "2";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />

<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<title>项目目标费用管理</title>
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
<script type="text/javascript" language="javascript">

cruConfig.contextPath='<%=contextPath%>';
cruConfig.cdtType = 'form';

var costType="";
var targetBasicId="<%=targetBasicId%>";

function initPage(){
	//获取当前项目的费用管理信息
	var submitStr="projectInfoNo="+'<%=projectId%>';
	var retObject=jcdpCallService('OPCostSrv','getProjectCostTargetType',submitStr);
	costType=retObject.costType;
	
	processNecessaryInfo={
		businessTableName:"BGP_OP_TARGET_PROJECT_INFO",
		businessType:"5110000004100000032",
		businessId:'<%=projectId%>',
		businessInfo:"<%=project_name%>发起项目目标实际成本审批",
		applicantDate:"2012-7-11"
	};
	
	processAppendInfo={
		projectInfoNo:'<%=projectId%>'
	};
	
	
	loadProcessHistoryInfo();
}

var selectParentIdData="";
var selectUpIdData="";
var selectLeafOrParent="";
var nodeGet=null;
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
            {name : 'costDetailDesc', type : 'String'},
            {name : 'formula', type : 'String'},
            {name : 'costChangeMoney', type : 'String'},
            {name : 'costDetailMoneyPlan', type : 'String'},
            {name : 'costDetailMoneyPlus', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OpCostSrv/getCostActualProject.srq?projectInfoNo=<%=projectId%>&costType='+costType+'&project_type=<%=project_type%>',
            reader: {
                type : 'json'
            }
        },
        folderSort: false
    });
	if('<%=project_type%>'=='5000100004000000009'){
		var grid = Ext.create('Ext.tree.Panel', {
	    	id:'gridId',
	        width: document.body.clientWidth,
	        height:document.body.clientHeight*0.45,
	        autoHeight: true,
	        lines: true,
	        renderTo: 'menuTree',
	        enableDD: false,
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
	            text: '发生金额',
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costDetailMoney',
	            align: 'center'
	        },{
	            //we must use the templateheader component so we can use a custom tpl
	            //xtype: 'templatecolumn',
	            text: '投资预算金额',
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costDetailMoneyPlan',
	            align: 'center'
	        },{
	            //we must use the templateheader component so we can use a custom tpl
	            //xtype: 'templatecolumn',
	            text: '剩余金额',
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costDetailMoneyPlus',
	            align: 'center'
	        }]
	    });
	}else{
		var grid = Ext.create('Ext.tree.Panel', {
	    	id:'gridId',
	        width: document.body.clientWidth,
	        height:document.body.clientHeight*0.45,
	        autoHeight: true,
	        lines: true,
	        renderTo: 'menuTree',
	        enableDD: false,
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
	            text: '发生金额',
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costDetailMoney',
	            align: 'center'
	        },{
	            //we must use the templateheader component so we can use a custom tpl
	            //xtype: 'templatecolumn',
	            text: '计算依据',
	            flex: 3,
	            sortable: true,
	            dataIndex: 'formula',
	            align: 'center'
	        },{
	            //we must use the templateheader component so we can use a custom tpl
	            //xtype: 'templatecolumn',
	            text: '变更后金额',
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costChangeMoney',
	            align: 'center'
	        }]
	    });
	}
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel
    
    grid.addListener('cellclick', cellclick);

    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectParentIdData= rowdata.data.gpCostTempId;
        selectUpIdData= rowdata.data.zip;
        selectLeafOrParent=rowdata.data.leaf;
        loadDataDetail(1);
    }
    
    
    grid.addListener('load', load);
    function load(treeStore,node,records,sucess){
    	ifFind=false;
    	getChildBySpecial(records);
    	if(nodeGet!=null&&nodeGet!=undefined){
    		grid.selectPath(nodeGet.getPath("gpCostTempId"),"gpCostTempId");
    	}
    }
    
    
    function getChildBySpecial(records){
    	for(var i=0;i<records.length;i++){
    		var data=records[i].data;
    		if(data.gpCostTempId==selectParentIdData){
    			nodeGet= records[i];	
    		}else{
    			getChildBySpecial(records[i].childNodes);
    		}
    	}
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
					    <td>&nbsp;</td>
					    <%if(proc_status){ %>
					     <auth:ListButton functionId="OP_ACTUAL_PLAN_EDIT" css="hz" event="onclick='toRefreshPlanData()'" title=""></auth:ListButton>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">实际成本记录</a></li>
			     <li id="tag3_1"><a href="#" onclick="getTab3(1)">班组费用分摊</a></li>
			     <li id="tag3_2"><a href="#" onclick="getTab3(2)">文档</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">流程</a></li>
			     <li id="tag3_4"><a href="#" onclick="getTab3(4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">分类码</a></li>
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
											<auth:ListButton functionId="OP_ACTUAL_PLAN_EDIT" css="zj" event="onclick='toAddMoneyChange()'" title="JCDP_btn_add"></auth:ListButton>
											<auth:ListButton functionId="OP_ACTUAL_PLAN_EDIT" css="xg" event="onclick='toModifyMoneyChange()'" title="JCDP_btn_edit"></auth:ListButton>
											<auth:ListButton functionId="OP_ACTUAL_PLAN_EDIT" css="sc" event="onclick='toDeleteMoneyChange()'" title="JCDP_btn_delete"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
				<div id="table_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
						<tr>
							<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{actual_detail_id}' id='rdo_entity_id_{actual_detail_id}'   />">选择</td>
							<td class="bt_info_even" autoOrder="1">序号</td>
							<td class="bt_info_even" exp="{cost_detail_money}">发生金额</td>
							<td class="bt_info_odd" exp="{cost_detail_desc}">计算依据</td>
							<td class="bt_info_even" exp="{occur_date}">产生时间</td>
						</tr>
					</table>
				</div>
				<div id="fenye_box" style="display:block">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
						<tr>
							<td align="right">第1/1页，共0条记录</td>
							<td width="10">&nbsp;</td>
							<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" />
							</td>
							<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" />
							</td>
							<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" />
							</td>
							<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" />
							</td>
							<td width="50">到 <label> <input type="text" name="textfield" id="textfield" style="width:20px;" /> </label>
							</td>
							<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" />
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<div id="tab_box_content1" class="tab_box_content"  style="display:none;">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<%if(proc_status){ %>
											<auth:ListButton functionId="OP_ACTUAL_PLAN_EDIT" css="zj" event="onclick='toAddBalanceChange()'" title="JCDP_btn_add"></auth:ListButton>
											<auth:ListButton functionId="OP_ACTUAL_PLAN_EDIT" css="xg" event="onclick='toModifyBalanceChange()'" title="JCDP_btn_edit"></auth:ListButton>
											<auth:ListButton functionId="OP_ACTUAL_PLAN_EDIT" css="sc" event="onclick='toDeleteBalanceChange()'" title="JCDP_btn_delete"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
				<div id="table_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable1">
						<tr>
							<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id1' value='{actual_balance_id}' id='rdo_entity_id_{actual_balance_id}'   />">选择</td>
							<td class="bt_info_even" autoOrder="1">序号</td>
							<td class="bt_info_even" exp="{team_name}">班组</td>
							<td class="bt_info_odd" exp="{cost_detail_money}">金额</td>
							<td class="bt_info_even" exp="{cost_detail_desc}">备注</td>
						</tr>
					</table>
				</div>
				<div id="fenye_box" style="display:block">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table1">
						<tr>
							<td align="right">第1/1页，共0条记录</td>
							<td width="10">&nbsp;</td>
							<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" />
							</td>
							<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" />
							</td>
							<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" />
							</td>
							<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" />
							</td>
							<td width="50">到 <label> <input type="text" name="textfield" id="textfield" style="width:20px;" /> </label>
							</td>
							<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" />
							</td>
						</tr>
					</table>
				</div>
			</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo buttonFunctionId="OP_ACTUAL_PLAN_EDIT" title=""/>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		</div>
	</div>
</body>
<script type="text/javascript">
$(document).ready(readyForSetHeight);

frameSize();

window.showNewTitle=false;
$(document).ready(lashen);


function refreshTree(){
	Ext.getCmp('gridId').getStore().load();
}

function refreshTreeStore(){
	initPage();
	<%-- Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostActualProject.srq?projectInfoNo=<%=projectId%>&costType='+costType+'&project_type=<%=project_type%>',
        reader: {
            type : 'json'
        }
        }); --%>
	Ext.getCmp('gridId').getStore().load();
}

function refreshData(num){
	 if(selectedTagIndex==0){
		 cruConfig.queryStr = "select rownum,t.* from (select t.* from bgp_op_actual_project_detail t where t.bsflag='0' and t.gp_target_project_id='"+selectParentIdData+"' order by OCCUR_DATE desc) t ";
		 cruConfig.currentPageUrl = "/op/costActualManager/costActualProjectManager.jsp";
		 queryData(num);
	 }else{
		$('#queryRetTable').attr('id','queryRetTable2');
		$('#fenye_box_table').attr('id','fenye_box_table2');
		$('#queryRetTable1').attr('id','queryRetTable');
		$('#fenye_box_table1').attr('id','fenye_box_table');
		cruConfig.queryStr = "select rownum,t.* from (select  t.*,sd.coding_name team_name from bgp_op_actual_prj_balance t left outer join comm_coding_sort_detail sd on t.team_id= sd.coding_code_id where t.bsflag='0' and t.gp_target_project_id='"+selectParentIdData+"' ) t ";
		queryData(num);
		$('#queryRetTable').attr('id','queryRetTable1');
		$('#fenye_box_table').attr('id','fenye_box_table1');
		$('#queryRetTable2').attr('id','queryRetTable');
		$('#fenye_box_table2').attr('id','fenye_box_table');
		cruConfig.queryStr = "select rownum,t.* from (select t.* from bgp_op_actual_project_detail t where t.bsflag='0' and t.gp_target_project_id='"+selectParentIdData+"' order by OCCUR_DATE desc) t ";
	 }
}
function loadDataDetail(id){
	if(id==1){
	cruConfig.queryStr = "select rownum,t.* from (select t.* from bgp_op_actual_project_detail t where t.bsflag='0' and t.gp_target_project_id='"+selectParentIdData+"' order by OCCUR_DATE desc) t ";
	cruConfig.currentPageUrl = "/op/costActualManager/costActualProjectManager.jsp";
	queryData(1);
	
	$('#queryRetTable').attr('id','queryRetTable2');
	$('#fenye_box_table').attr('id','fenye_box_table2');
	$('#queryRetTable1').attr('id','queryRetTable');
	$('#fenye_box_table1').attr('id','fenye_box_table');
	cruConfig.queryStr = "select rownum,t.* from (select  t.*,sd.coding_name team_name from bgp_op_actual_prj_balance t left outer join comm_coding_sort_detail sd on t.team_id= sd.coding_code_id where t.bsflag='0' and t.gp_target_project_id='"+selectParentIdData+"' ) t ";
	queryData(1);
	$('#queryRetTable').attr('id','queryRetTable1');
	$('#fenye_box_table').attr('id','fenye_box_table1');
	$('#queryRetTable2').attr('id','queryRetTable');
	$('#fenye_box_table2').attr('id','fenye_box_table');
	cruConfig.queryStr = "select rownum,t.* from (select t.* from bgp_op_actual_project_detail t where t.bsflag='0' and t.gp_target_project_id='"+selectParentIdData+"' order by OCCUR_DATE desc) t ";
	//载入文档信息
	//document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+selectParentIdData;
	//载入备注信息
	//document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+selectParentIdData;
	//载入分类吗信息
	//document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=4&relationId="+selectParentIdData
	}
}

function toAddMoneyChange(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		popWindow(cruConfig.contextPath+"/op/costActualManager/costActualProjectManagerEdit.upmd?pagerAction=edit2Add&gpTargetProjectId="+selectParentIdData);
	}
}
function toModifyMoneyChange(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
		popWindow(cruConfig.contextPath+"/op/costActualManager/costActualProjectManagerEdit.upmd?pagerAction=edit2Edit&id="+ids+"&gpTargetProjectId="+selectParentIdData);
}
function toDeleteMoneyChange(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	if (!window.confirm("确认要删除吗?")) {
		return;
	}
	var sql = "update bgp_op_actual_project_detail t set t.bsflag='1' where t.actual_detail_id ='"+ids+"'";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	refreshTree();
	loadDataDetail(1);
}


function toAddBalanceChange(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var project_type = '<%=project_type%>';
		if(project_type=='5000100004000000008'){
			project_type = '5000100004000000001';
		}
		popWindow(cruConfig.contextPath+"/op/costActualManager/costActualProjectBalanceEdit.upmd?pagerAction=edit2Add&gpTargetProjectId="+selectParentIdData+"&project_type="+project_type);
	}
}
function toModifyBalanceChange(){
	ids = getSelIds('rdo_entity_id1');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	var project_type = '<%=project_type%>';
	if(project_type=='5000100004000000008'){
		project_type = '5000100004000000001';
	}
	popWindow(cruConfig.contextPath+"/op/costActualManager/costActualProjectBalanceEdit.upmd?pagerAction=edit2Edit&id="+ids+"&gpTargetProjectId="+selectParentIdData+"&project_type="+project_type);
}
function toDeleteBalanceChange(){
	ids = getSelIds('rdo_entity_id1');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	if (!window.confirm("确认要删除吗?")) {
		return;
	}
	var sql = "update BGP_OP_ACTUAL_PRJ_BALANCE t set t.bsflag='1' where t.ACTUAL_BALANCE_ID ='"+ids+"'";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	loadDataDetail(1);
}

function toRefreshPlanData(){
	var project_type = '<%=project_type%>';
	if(project_type!='5000100004000000009'){
		var sql = "select s.planned_start_date,e.planned_finish_date "+
		" from (select nvl(min(t3.actual_start_date),min(t3.planned_start_date)) planned_start_date from  bgp_p6_project t1 "+
		" inner join bgp_p6_project_wbs t2 on t1.object_id=t2.project_object_id "+
		" left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id "+
		" where t1.project_info_no = '<%=projectId%>' "+
		" start with t2.name ='工区踏勘' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID )s"+
		" left join (select nvl(max(t3.actual_finish_date),max(t3.planned_finish_date)) planned_finish_date from  bgp_p6_project t1 "+
		" inner join bgp_p6_project_wbs t2 on t1.object_id=t2.project_object_id "+
		" left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id "+
		" where t1.project_info_no = '<%=projectId%>' "+
		" start with t2.name ='资源遣散' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID)e on 1=1";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		var planned_start_date = "";
		var planned_finish_date = "";
		if(retObj==null || retObj.returnCode !='0'){
			alert("工区踏勘、资源遣散工序的计划开始时间为空");
			//return;
		}else{
			planned_start_date = retObj.datas[0].planned_start_date;
			planned_finish_date = retObj.datas[0].planned_finish_date;
		}
		if(planned_start_date==null || planned_start_date==''){
			alert("工区踏勘工序的计划开始时间为空");
			//return;
		}
		if(planned_finish_date==null || planned_finish_date==''){
			alert("资源遣散工序的计划开始时间为空");
			//return;
		}
	}
	
	retObj = jcdpCallService("OPCostSrv", "hzCostActualByFormula", "projectInfoNo=<%=projectId%>&project_type=<%=project_type%>");
	if(retObj!=null && retObj.returnCode =='0'){
		alert("汇总成功!");
		refreshTreeStore();
	}else{
		alert("汇总失败!");
	}
}


</script>
</html>