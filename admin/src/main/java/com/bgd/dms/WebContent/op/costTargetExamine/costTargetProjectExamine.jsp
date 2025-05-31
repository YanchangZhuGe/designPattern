<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectId = request.getParameter("projectInfoNo");
	String project_name = request.getParameter("projectName");
	String project_type = request.getParameter("projectType");
	if(projectId==null||"".equals(projectId)){
		projectId= user.getProjectInfoNo();
		project_name = user.getProjectName();
		project_type = user.getProjectType();
	}
	project_name = URLDecoder.decode(project_name,"UTF-8"); 
	String targetBasicId=OPCommonUtil.getTargetProjectBasicId(projectId);
	boolean proc_status = OPCommonUtil.getProcessStatus2("BGP_OP_TARGET_PROJECT_INFO","gp_target_project_id","5110000004100000032",projectId);
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

var costType="";

var targetBasicId="<%=targetBasicId%>";
function initPage(){
	//获取当前项目的费用管理信息
	var submitStr="projectInfoNo="+'<%=projectId%>';
	var retObject=jcdpCallService('OPCostSrv','getProjectCostTargetType',submitStr);
	costType=retObject.costType;
	
	//载入文档信息
	document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId=<%=projectId%>";
	
	refreshTargetBasicInfo();
	
	processNecessaryInfo={
		businessTableName:"BGP_OP_TARGET_PROJECT_INFO",
		businessType:"5110000004100000004",
		businessId:'<%=projectId%>01',
		businessInfo:"<%=project_name%>发起了考核兑现审批",
		applicantDate:"2012-10-11"
	};

	processAppendInfo={
		projectInfoNo:'<%=projectId%>',
		projectName:'<%=project_name %>',
		projectType:'<%=project_type%>'
	};

	loadProcessHistoryInfo();
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
            {name : 'costDetailMoneyPlan', type : 'String'},
            {name : 'costDetailDesc', type : 'String'},
            {name : 'costDetailMoneyPlus', type : 'String'},
            {name : 'formulaContent', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OpCostSrv/getCostActualProject.srq?projectInfoNo=<%=projectId%>&costType='+costType,
            reader: {
                type : 'json'
            }
        },
        folderSort: false
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel
    var width = 800-6;
    var height = 600*0.45;
    if(document.body.clientWidth!=null && document.body.clientWidth!=0){
    	width = document.body.clientWidth-6;
        height = document.body.clientHeight*0.45;
    }
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
    	width: width,
        height: height,
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
            height: 22,
            hideable:false,
            flex: 2,
            sortable: true,
            dataIndex: 'costName'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '计划金额（元）',
            height: 22,
            flex: 1,
            sortable: true,
            dataIndex: 'costDetailMoneyPlan',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '实际金额（元）',
            height: 22,
            flex: 1,
            sortable: true,
            dataIndex: 'costDetailMoney',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '差额（元）',
            height: 22,
            flex: 4,
            sortable: true,
            dataIndex: 'costDetailMoneyPlus',
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
					    <td>&nbsp;</td>
					    <td>&nbsp;</td>
					    <td>&nbsp;</td>
					  </tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		<div id="table_box" style="overflow: hidden;">
			<div id="menuTree" style="width:100%;height:auto;overflow:auto;z-index: 0;"></div>
		</div>
		<div id="fenye_box" style="height: 0px"></div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">文档</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">流程</a></li>
			    <!-- <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li> -->
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<%if(!proc_status){ %>
						<wf:startProcessInfo  title=""/>
					<%} %>
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
function frameSize(){
	if(lashened==0){
		if($(window).height()==0){
			$("#table_box").css("height",596*0.46);
		}else{
			$("#table_box").css("height",$(window).height()*0.46);
		}
	}
	$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-10);
	$("#tab_box .tab_box_content").each(function(){
		if($(this).children('iframe').length > 0){
			$(this).css('overflow-y','hidden');
		}
	});
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
$(document).ready(lashen);

var selectedTagIndex = 0;

function refreshTree(){
	Ext.getCmp('gridId').getStore().load();
}

function refreshTreeStore(){
	initPage();
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostActualProject.srq?projectInfoNo=<%=projectId%>&costType='+costType,
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
}

function loadDataDetail(){
	
	//载入备注信息
	document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+selectParentIdData;
	//载入分类吗信息
	document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=4&relationId="+selectParentIdData
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

function refreshTargetBasicInfo(){
}

</script>
</html>