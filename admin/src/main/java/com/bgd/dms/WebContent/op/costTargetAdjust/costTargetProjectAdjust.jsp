<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
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
	String org_id = user.getOrgId();
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	String user_id = user.getUserId();
	Map map = new HashMap();
	map.put("org_id",org_id);
	map.put("org_subjection_id",org_subjection_id);
	map.put("user_id",user_id);
	map.put("tartget_basic_id",targetBasicId);
	String status = OPCommonUtil.getPermit(projectId,map,"adjust");
	boolean proc_status = OPCommonUtil.getProcessStatus2("BGP_OP_TARGET_PROJECT_INFO","gp_target_project_id","5110000004100000099",projectId);
	String exploration_method = OPCommonUtil.getExplorationMethod(projectId);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
	String is_single = request.getParameter("is_single");//is_single表示是不是单项目
	String spare5 = "1";
	if(project_type !=null && project_type.trim().equals("5000100004000000009")){//综合物化探的单项目需要屏蔽操作的按钮
		spare5= "2";
		if(is_single!=null && is_single.trim().equals("true")){
			proc_status = false;
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"></link>
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
	var status = '<%=status%>';
	if(status!='3'){
		alert('审批未通过，不允许查看!');
		return;
	}
	//获取当前项目的费用管理信息
	var submitStr="projectInfoNo="+'<%=projectId%>';
	var retObject=jcdpCallService('OPCostSrv','getProjectCostTargetType',submitStr);
	costType=retObject.costType;
	
	processNecessaryInfo={
		businessTableName:"BGP_OP_TARGET_PROJECT_INFO",
		businessType:"5110000004100000099",
		businessId:'<%=projectId%>',
		businessInfo:"<%=project_name%>发起项目目标成本预算调整审批",
		applicantDate:"<%=now %>"
	};
	
	processAppendInfo={
		projectInfoNo:'<%=projectId%>',
		projectName:'<%=project_name %>',
		projectType:'<%=project_type%>'
	};
	
	
	loadProcessHistoryInfo();
	//refreshTargetBasicInfo();
	var exploration_method = '<%=exploration_method%>';
	if(exploration_method==null || exploration_method==''){
		alert("该项目既不是二维也不是三维!");
	}else if(exploration_method!=null && exploration_method=='0300100012000000002'){
		document.getElementById("second1").style.display = 'none';
		document.getElementById("second2").style.display = 'none';
		document.getElementById("second3").style.display = 'none';
	}else if(exploration_method!=null && exploration_method=='0300100012000000003'){
		document.getElementById("second1").style.display = 'block';
		document.getElementById("second2").style.display = 'block';
		document.getElementById("second3").style.display = 'block';
	}
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
	var status = '<%=status%>';
	if(status!='3'){
		return;
	}
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
            {name : 'costPlusMoney', type : 'String'},
            {name : 'costChangeDesc', type : 'String'},
            {name : 'costChangeMoney', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OpCostSrv/getCostTargetChangeProject.srq?projectInfoNo=<%=projectId%>&project_type=<%=project_type%>&costType='+costType,
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
            height: 22,
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'costName'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '调整前金额（元）',
            height: 22,
            flex: 1,
            sortable: true,
            dataIndex: 'costDetailMoney',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '调整金额（元）',
            height: 22,
            flex: 1,
            sortable: true,
            dataIndex: 'costPlusMoney',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '调整后金额（元）',
            height: 22,
            flex: 1,
            sortable: true,
            dataIndex: 'costChangeMoney',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '调整依据',
            height: 22,
            flex: 3,
            sortable: true,
            dataIndex: 'costChangeDesc',
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
	<%if(status.equals("3")){ %>
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
					    	<%if(!project_type.trim().equals("5000100004000000009")){ %>
					     		<auth:ListButton functionId="OP_ADJUST_PLAN_EDIT,OP_ADJUST_EDIT,OP_ADJUST_EDIT" css="hz" event="onclick='toRefreshPlanData()'" title=""></auth:ListButton>
					    	<%} %>
					    <%} %>
					    <%if(!project_type.trim().equals("5000100004000000009")){ %>
					    <auth:ListButton functionId="OP_ADJUST_PLAN_EDIT,OP_ADJUST_EDIT,OP_ADJUST_EDIT" css="xq" event="onclick='showProjectInformation()'" title="项目基本情况"></auth:ListButton>
					  	<%} %>
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
		<div id="fenye_box" style="height: 0px">
			</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">目标预算调整</a></li>
			    <!-- <li id="tag3_1"><a href="#" onclick="getTab3(1)">技术指标变更</a></li> -->
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">流程</a></li>
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
											<auth:ListButton functionId="OP_ADJUST_PLAN_EDIT,OP_ADJUST_EDIT" css="zj" event="onclick='toAddMoneyChange()'" title="JCDP_btn_add"></auth:ListButton>
											<auth:ListButton functionId="OP_ADJUST_PLAN_EDIT,OP_ADJUST_EDIT" css="xg" event="onclick='toModifyMoneyChange()'" title="JCDP_btn_edit"></auth:ListButton>
											<auth:ListButton functionId="OP_ADJUST_PLAN_EDIT,OP_ADJUST_EDIT" css="sc" event="onclick='toDeleteMoneyChange()'" title="JCDP_btn_delete"></auth:ListButton>
											<%} %>
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
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<%if(proc_status){ %>
											<auth:ListButton functionId="OP_ADJUST_PLAN_EDIT,OP_ADJUST_EDIT" css="bc" event="onclick='saveTargetIndicatorInfo()'" title="JCDP_btn_save"></auth:ListButton>
											<auth:ListButton functionId="OP_ADJUST_PLAN_EDIT,OP_ADJUST_EDIT" css="dr" event="onclick='importTargetIndicatorInfo()'" title="JCDP_btn_import"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<input name="indicator_change_id" id="indicator_change_id" class="input_width" value="" type="hidden" />
					<input name="spare5" id="spare5" value="" class="input_width" type="hidden" />
					<input name="tech_020" id="tech_020" value="" class="input_width" type="hidden" />
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item8">观测系统类型：</td>
							<td class="inquire_form8"> <input name="tech_001" id="tech_001" class="input_width" value="" type="text"  /></td>
							<td class="inquire_item8">设计线束：</td>
							<td class="inquire_form8"> <input name="tech_002" id="tech_002" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8"><font color="red">*</font>满覆盖工作量<input type="radio" name="workload" id="workload1" value="1" checked="checked"/></td>
							<td class="inquire_form8"> <input name="tech_005" id="tech_005" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8"><font color="red">*</font>实物工作量<input type="radio" name="workload" id="workload2" value="2"/></td>
							<td class="inquire_form8"> <input name="tech_006" id="tech_006" value="" class="input_width" type="text"  /> </td>
						</tr>
						<tr>
							<td class="inquire_item8">井炮生产炮数：</td>
							<td class="inquire_form8"> <input name="tech_022" id="tech_022" value="" class="input_width" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
							<td class="inquire_item8">震源生产炮数：</td>
							<td class="inquire_form8"> <input name="tech_021" id="tech_021" value="" class="input_width" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
							<td class="inquire_item8">气枪生产炮数：</td>
							<td class="inquire_form8"> <input name="tech_023" id="tech_023" class="input_width" value="" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
							<td class="inquire_item8"><font color="red">*</font>总生产炮数：</td>
							<td class="inquire_form8"> <input name="tech_004" id="tech_004" class="input_width" value="" type="text" disabled="disabled"/> </td>
						</tr>
						<tr>
							<td class="inquire_item8">微测井：</td>
							<td class="inquire_form8"> <input name="tech_018" id="tech_018" class="input_width" value="" type="text"  /> </td>
							<td class="inquire_item8">小折射：</td>
							<td class="inquire_form8"> <input name="tech_003" id="tech_003" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8"><font color="red">*</font>接收道数：</td>
							<td class="inquire_form8"> <input name="tech_008" id="tech_008" value="" class="input_width" type="text"  onkeydown="javascript:return checkIfNum(event);"/> </td>
							<td class="inquire_item8"><font color="red">*</font>检波器串数：</td>
							<td class="inquire_form8"> <input name="tech_019" id="tech_019" value="" class="input_width" type="text"  onkeydown="javascript:return checkIfNum(event);"/> </td>
						</tr>
						<tr>
							<td class="inquire_item8">覆盖次数：</td>
							<td class="inquire_form8"> <input name="tech_007" id="tech_007" class="input_width" value="" type="text"  /> </td>
							<td class="inquire_item8">道间距：</td>
							<td class="inquire_form8"> <input name="tech_009" id="tech_009" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8">炮点距：</td>
							<td class="inquire_form8"> <input name="tech_010" id="tech_010" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8" id="second1">接收线距：</td>
							<td class="inquire_form8" id="second2"> <input name="tech_011" id="tech_011" value="" class="input_width" type="text"  /> </td>
						</tr>
						<tr id="second3">
							<td class="inquire_item8">炮线距：</td>
							<td class="inquire_form8"> <input name="tech_012" id="tech_012" class="input_width" value="" type="text"  /> </td>
							<td class="inquire_item8">单线道数：</td>
							<td class="inquire_form8"> <input name="tech_013" id="tech_013" class="input_width" value="" type="text"  /> </td>
							<td class="inquire_item8">滚动接收线数：</td>
							<td class="inquire_form8"> <input name="tech_014" id="tech_014" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8">面元：</td>
							<td class="inquire_form8"> <input name="tech_015" id="tech_015" value="" class="input_width" type="text"  /> </td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<%if(is_single!=null && is_single.trim().equals("true") && project_type.trim().equals("5000100004000000009")){ %>
					<wf:startProcessInfo buttonFunctionId="true" />
				<%}else{ %>
					<wf:startProcessInfo />
				<%} %>		
				</div>
		</div>
	</div>
	<%} %>
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

var schemaInfoOfSet = {
	tech_001:'',
	tech_002:'',
	
	spare5:'',
	tech_005:'',
	tech_006:'',
	tech_020:'',
	
	tech_022:'',
	tech_021:'',
	tech_023:'',
	tech_004:'',
	
	tech_018:'',
	tech_003:'',
	tech_008:'',
	tech_019:'',
	
	tech_007:'',
	tech_009:'',
	tech_010:'',
	
	tech_011:'',
	tech_012:'',
	tech_013:'',
	tech_014:'',
	tech_015:''
};


function refreshTree(){
	Ext.getCmp('gridId').getStore().load();
}

function refreshTreeStore(){
	initPage();
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostTargetChangeProject.srq?projectInfoNo=<%=projectId%>&project_type=<%=project_type%>&costType='+costType,
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
}

function loadDataDetail(){
	//载入费用详细信息
	var querySql = "select rownum,t.* from bgp_op_target_project_change t where t.bsflag='0' and t.gp_target_project_id='"+selectParentIdData+"' order by COST_CHANGE_DATE desc";
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
	ids = ids.replace(/\,/g,"','");
	var sql = "update bgp_op_target_project_change t set t.bsflag='1' where t.target_change_id in('"+ids+"')";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	Ext.getCmp('gridId').getStore().load();
	loadDataDetail();
}

function refreshTargetBasicInfo(){
	//初始化技术指标信息
	var retObject = jcdpCallService("OPCostSrv", "initIndicatoChange", "tartget_basic_id="+targetBasicId);
	//载入技术指标信息
	var querySql="select * from bgp_op_target_indicato_change where bsflag='0' and tartget_basic_id='"+targetBasicId+"'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		setOneDataInfo(schemaInfoOfSet,datas[0],'indicator_change_id');
	}
	var spare5 = document.getElementById("spare5").value;
	if(spare5==2 || spare5 =='2'){
		document.getElementById("workload2").checked = true;
	}
}
function saveTargetIndicatorInfo(){
	var tech_008 = document.getElementById('tech_008').value;
	if(tech_008 ==null || tech_008==''){
		alert("接收道数不能空!");
		return;
	}
	var tech_019 = document.getElementById('tech_019').value;
	if(tech_019 ==null || tech_019==''){
		alert("检波器串数不能空!");
		return;
	}
	var tech_021 = document.getElementById('tech_021').value;
	if(tech_021==null ||tech_021==''){
		tech_021 = 0;
	}
	var tech_022 = document.getElementById('tech_022').value;
	if(tech_022==null ||tech_022==''){
		tech_022 = 0;
	}
	var tech_023 = document.getElementById('tech_023').value;
	if(tech_023==null ||tech_023==''){
		tech_023 = 0;
	}
	var tech_004 = document.getElementById('tech_004').value;
	if(tech_004==null ||tech_004==''){
		tech_004 = 0;
	}
	if(tech_004!=(tech_021-(-tech_022)-(-tech_023))){
		alert("炮数不等于震源生产数量、井炮生产数量、气枪生产数量之和，请确认!")
		return;
	}
	document.getElementById("spare5").value = 1;
	document.getElementById("tech_020").value = document.getElementById("tech_005").value;
	var checked = document.getElementById("workload2").checked;
	if(checked=='true' || checked ==true){
		document.getElementById("spare5").value = 2;
		document.getElementById("tech_020").value = document.getElementById("tech_006").value;
	}
	var retObj = saveSingleTableInfoByData(schemaInfoOfSet,'bgp_op_target_indicato_change','indicator_change_id','tartget_basic_id='+targetBasicId);
	if(retObj!=null && retObj.returnCode=='0'){
		alert('保存成功!');
	}
}

function importTargetIndicatorInfo(){
	retObj = jcdpCallService("OPCostSrv", "importTargetIndicatorInfo", "projectInfoNo=<%=projectId%>&targetBasicId="+targetBasicId+"&adjustOrNot=adjust");
	if(retObj!=null && retObj.returnCode=='0'){
		alert("保存成功!");
		//refreshTargetBasicInfo();
		var tech_001 = document.getElementById('tech_001').value;
		tech_001 = tech_001.replace(/L/g,'*');
		tech_001 = tech_001.replace(/S/g,'*');
		tech_001 = tech_001.replace(/R/g,'*');
		tech_001 = tech_001.replace(/P/g,'*');
		tech_001 = tech_001.replace(/T/g,'*');
		tech_001 = tech_001.replace(/\-/g,'*');
		tech_001 = tech_001.replace(/\(/g,'*');
		tech_001 = tech_001.replace(/\)/g,'*');
		tech_001 = tech_001.replace(/[^*\d]/g,'');
		var tech_013 = tech_001.split("*")[2];
		if(tech_013==null){
			tech_013 = "";
		}
		document.getElementById('tech_013').value = tech_013;
		var sql = "update bgp_op_target_indicato_change t set t.tech_013 = '"+tech_013+"' where t.tartget_basic_id ='"+targetBasicId+"'";
		jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+sql);
	}
	
}

function toExportTargetInfo(){
	popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetProjectInfo.jsp?targetBasicId="+targetBasicId);
}

function toRefreshPlanData(){
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
		return;
	}else{
		planned_start_date = retObj.datas[0].planned_start_date;
		planned_finish_date = retObj.datas[0].planned_finish_date;
	}
	if(planned_start_date==null || planned_start_date==''){
		alert("工区踏勘工序的计划开始时间为空");
		return;
	}
	if(planned_finish_date==null || planned_finish_date==''){
		alert("资源遣散工序的计划开始时间为空");
		return;
	}
	retObj = jcdpCallService("OPCostSrv", "hzCostPlanChangeByFormula", "projectInfoNo=<%=projectId%>");
	if(retObj!=null && retObj.returnCode =='0'){
		alert("汇总成功!");
		refreshTreeStore();
	}else{
		alert("汇总失败!");
	}
}
/* 输入的是否是数字 */
function checkIfNum(event){
	var element = event.srcElement;
	if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
		element.value = '';
	}
	if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
		return true;
	}
	else{
		return false;
	}
}
function showProjectInformation(){//项目基本信息
	var project_type ='<%=project_type%>';
	if(project_type !=null && project_type=='5000100004000000009'){
		<%-- popWindow(cruConfig.contextPath+"/op/mProject/project_information.jsp?tartget_basic_id=<%=targetBasicId%>&status=<%=status%>"); 
		window.open(cruConfig.contextPath+"/op/mProject/project_information.jsp?tartget_basic_id=<%=targetBasicId%>&status=<%=proc_status%>");--%>
	}else{
		<%-- popWindow(cruConfig.contextPath+"/op/costTargetManager/project_information.jsp?tartget_basic_id=<%=targetBasicId%>&status=<%=status%>"); --%>
		window.open(cruConfig.contextPath+"/op/costTargetAdjust/project_information.jsp?tartget_basic_id=<%=targetBasicId%>&status=<%=proc_status%>");
	}
}
</script>
</html>