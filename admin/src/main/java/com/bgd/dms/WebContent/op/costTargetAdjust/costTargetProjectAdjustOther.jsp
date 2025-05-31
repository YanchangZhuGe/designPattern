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
	String targetBasicId=OPCommonUtil.getTargetProjectBasicId(projectId);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
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
		businessType:"5110000004100000014",
		businessId:'<%=projectId%>',
		businessInfo:"测试项目发起了目标成本计划申请",
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
            {name : 'costChangeMoney', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OpCostSrv/getCostTargetNFormulaChangeProject.srq?projectInfoNo=<%=projectId%>&costType='+costType,
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
            flex: 1,
            sortable: true,
            dataIndex: 'costDetailDesc',
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
    grid.addListener('cellclick', cellclick);

    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectParentIdData= rowdata.data.gpCostTempId;
        selectUpIdData= rowdata.data.zip;
        selectLeafOrParent=rowdata.data.leaf;
        loadDataDetail();
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
					     <auth:ListButton functionId="OP_ADJUST_OTHER_EDIT" css="hz" event="onclick='toRefreshPlanData()'" title=""></auth:ListButton>
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
		<div id="fenye_box" style="height: 0px">
			</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">目标预算调整</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">文档</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">流程</a></li>
			     <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">分类码</a></li>
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
											<auth:ListButton functionId="OP_ADJUST_OTHER_EDIT" css="zj" event="onclick='toAddMoneyChange()'" title="JCDP_btn_add"></auth:ListButton>
											<auth:ListButton functionId="OP_ADJUST_OTHER_EDIT" css="xg" event="onclick='toModifyMoneyChange()'" title="JCDP_btn_edit"></auth:ListButton>
											<auth:ListButton functionId="OP_ADJUST_OTHER_EDIT" css="sc" event="onclick='toDeleteMoneyChange()'" title="JCDP_btn_delete"></auth:ListButton>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="editionList">		
			     		<tr>
					      <td class="bt_info_odd">选择</td>
					      <td class="bt_info_even" >序号</td>
					      <td class="bt_info_even">发生金额</td>
					      <td class="bt_info_odd">计算依据</td>
					      <td class="bt_info_even">变更时间</td>			     
					      <td class="bt_info_odd">变更原因</td>
			    	    </tr> 			        
			  		</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  title=""/>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		</div>
	</div>
</body>
<script type="text/javascript">
$(document).ready(readyForSetHeight);

frameSize();

$(document).ready(lashen);

function refreshTree(){
	Ext.getCmp('gridId').getStore().load();
}

function refreshTreeStore(){
	initPage();
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostTargetNFormulaChangeProject.srq?projectInfoNo=<%=projectId%>&costType='+costType,
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
}

function loadDataDetail(){
	//载入费用详细信息
	var querySql = "select rownum,t.* from BGP_OP_TARGET_PROJECT_CHANGE t where t.bsflag='0' and t.gp_target_project_id='"+selectParentIdData+"' order by COST_CHANGE_DATE desc";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
	var datas = queryRet.datas;
	
	deleteTableTr("editionList");
	if(datas != null){
		rowsCount=datas.length;
		for (var i = 0; i< queryRet.datas.length; i++) {
			var tr = document.getElementById("editionList").insertRow();		
             	if(i % 2 == 1){  
             		tr.className = "even";
			}else{ 
				tr.className = "odd";
			}
            var td = tr.insertCell(0);
    		td.innerHTML ='<INPUT id="fy'+i+'checkbox" name="rdo_entity_id"  value='+datas[i].target_change_id+' type=checkbox>';
    		
    		var td = tr.insertCell(1);
			td.innerHTML = datas[i].rownum;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].cost_detail_money;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].cost_detail_desc;
			
			var td = tr.insertCell(4);
			td.innerHTML = datas[i].cost_change_date;
			
			var td = tr.insertCell(5);
			td.innerHTML = datas[i].cost_change_reason;
			
		}
	}
	
	//载入文档信息
	document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+selectParentIdData;
	//载入备注信息
	document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+selectParentIdData;
	//载入分类吗信息
	document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=4&relationId="+selectParentIdData
}

function toAddMoneyChange(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		popWindow(cruConfig.contextPath+"/op/costTargetAdjust/costTargetProjectAdjustEdit.upmd?pagerAction=edit2Add&gpTargetProjectId="+selectParentIdData);
	}
}
function toModifyMoneyChange(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
		popWindow(cruConfig.contextPath+"/op/costTargetAdjust/costTargetProjectAdjustEdit.upmd?pagerAction=edit2Edit&id="+ids+"&gpTargetProjectId="+selectParentIdData);
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
	var sql = "update bgp_op_target_project_change t set t.bsflag='1' where t.target_change_id ='"+ids+"'";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	loadDataDetail();
}



function toExportTargetInfo(){
	popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetProjectInfo.jsp?targetBasicId="+targetBasicId);
}

function toRefreshPlanData(){
	retObj = jcdpCallService("OPCostSrv", "hzCostPlanChangeByFormula", "projectInfoNo=<%=projectId%>");
	refreshTreeStore();
}


</script>
</html>