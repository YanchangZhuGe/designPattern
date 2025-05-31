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
	String projectId=request.getParameter("projectInfoNo");
	if(projectId==null||"".equals(projectId)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		 projectId= user.getProjectInfoNo();
	}
	
	String targetBasicId=OPCommonUtil.getTargetProjectBasicId(projectId);
	
	UserToken user = OMSMVCUtil.getUserToken(request);	
	String projectType = user.getProjectType();//项目类型
	
	if("5000100004000000008".equals(projectType)){
		//井中项目   
		request.getRequestDispatcher("/op/costTargetManager/costTargetProjectManagerForSCWs.jsp").forward(request,response);
		//response.sendRedirect(contextPath+"/ws/pm/plan/singlePlan/workload/dailyPlanList.jsp");
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

//流程提交前配置流程关键信息
function configProecessInfo(){
	processNecessaryInfo={
			businessTableName:"BGP_OP_TARGET_PROJECT_BASIC",
			businessType:"5110000004100000009",
			businessId:targetBasicId,
			businessInfo:"目标成本计划审批",
			applicantDate:"2012-7-11"
	};
	processAppendInfo={
			projectInfoNo:'<%=projectId%>',
			targetId:targetBasicId
	};
}
	
function initPage(){
	//获取当前项目的费用管理信息
	var submitStr="projectInfoNo="+'<%=projectId%>';
	var retObject=jcdpCallService('OPCostSrv','getProjectCostTargetType',submitStr);
	costType=retObject.costType;
	
	configProecessInfo();
	loadProcessHistoryInfo();
	refreshTargetBasicInfo();
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
            {name : 'costDetailDesc', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OpCostSrv/getCostTargetProject.srq?projectInfoNo=<%=projectId%>&costType='+costType,
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
            flex: 3,
            sortable: true,
            dataIndex: 'costDetailDesc',
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">项目基本信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">技术指标</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">之前版本</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">文档</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">备注</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">分类码</a></li>
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
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item4">费用金额：</td>
							<td class="inquire_form4">
							<input name="cost_detail_money" id="cost_detail_money" class="input_width" value="" type="text"  />
							<input name="target_project_detail_id" id="target_project_detail_id" class="input_width" value="" type="hidden" />
							<span class='jd'><a href='#' onclick='getTheMoney()'  title='计算'></a></span>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="inquire_item4">描述依据：</td>
							<td class="inquire_form4">
							<textarea  name="cost_detail_desc" id="cost_detail_desc" value=""   class="textarea" ></textarea>
							</td>
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
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item4">工作量：</td>
							<td class="inquire_form4">
							<input name="tartget_basic_id" id="tartget_basic_id" class="input_width" value="<%=targetBasicId%>"   type="hidden"/>
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
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item6">观测系统类型：</td>
							<td class="inquire_form6">
							<input name="tech_001" id="tech_001" class="input_width" value="" type="text"  />
							<input name="target_indicator_id" id="target_indicator_id" class="input_width" value="" type="hidden" />
							</td>
							<td class="inquire_item6">设计线束：</td>
							<td class="inquire_form6">
							<input name="tech_002" id="tech_002" value="" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">配置道数：</td>
							<td class="inquire_form6">
							<input name="tech_003" id="tech_003" value="" class="input_width" type="text"  />
							</td>
						</tr>
						
						<tr>
							<td class="inquire_item6">炮数：</td>
							<td class="inquire_form6">
							<input name="tech_004" id="tech_004" class="input_width" value="" type="text"  />
							</td>
							<td class="inquire_item6">面元：</td>
							<td class="inquire_form6">
							<input name="tech_005" id="tech_005" value="" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">横向覆盖次数：</td>
							<td class="inquire_form6">
							<input name="tech_006" id="tech_006" value="" class="input_width" type="text"  />
							</td>
						</tr>
						
						<tr>
							<td class="inquire_item6">纵向覆盖次数：</td>
							<td class="inquire_form6">
							<input name="tech_007" id="tech_007" class="input_width" value="" type="text"  />
							</td>
							<td class="inquire_item6">接收道数：</td>
							<td class="inquire_form6">
							<input name="tech_008" id="tech_008" value="" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">道间距：</td>
							<td class="inquire_form6">
							<input name="tech_009" id="tech_009" value="" class="input_width" type="text"  />
							</td>
						</tr>
						
						<tr>
							<td class="inquire_item6">炮点距：</td>
							<td class="inquire_form6">
							<input name="tech_010" id="tech_010" class="input_width" value="" type="text"  />
							</td>
							<td class="inquire_item6">总覆盖次数：</td>
							<td class="inquire_form6">
							<input name="tech_011" id="tech_011" value="" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">接收线距：</td>
							<td class="inquire_form6">
							<input name="tech_012" id="tech_012" value="" class="input_width" type="text"  />
							</td>
						</tr>
						
						<tr>
							<td class="inquire_item6">炮线距：</td>
							<td class="inquire_form6">
							<input name="tech_013" id="tech_013" class="input_width" value="" type="text"  />
							</td>
							<td class="inquire_item6">滚动接收线数：</td>
							<td class="inquire_form6">
							<input name="tech_014" id="tech_014" value="" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">单线道数：</td>
							<td class="inquire_form6">
							<input name="tech_015" id="tech_015" value="" class="input_width" type="text"  />
							</td>
						</tr>
						
						<tr>
							<td class="inquire_item6">排列总道数：</td>
							<td class="inquire_form6">
							<input name="tech_016" id="tech_016" class="input_width" value="" type="text"  />
							</td>
							<td class="inquire_item6">滚动距离：</td>
							<td class="inquire_form6">
							<input name="tech_017" id="tech_017" value="" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">微测井个数：</td>
							<td class="inquire_form6">
							<input name="tech_018" id="tech_018" value="" class="input_width" type="text"  />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">检波器串数：</td>
							<td class="inquire_form6">
							<input name="tech_019" id="tech_019" class="input_width" value="" type="text"  />
							</td>
							<td class="inquire_item6">偏前满覆盖工作量（km2）：</td>
							<td class="inquire_form6">
							<input name="tech_020" id="tech_020" class="input_width" value="" type="text"  />
							</td>
							<td class="inquire_item6">&nbsp;</td>
							<td class="inquire_form6">&nbsp;</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="editionList">		
			     		<tr>
					      <td class="bt_info_even">版本</td>
					      <td class="bt_info_odd">产生时间</td>	
					      <td class="bt_info_odd">内容 </td>	
			    	    </tr> 			        
			  		</table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
			 	<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>

				</div>
		</div>
	</div>
</body>
<script type="text/javascript">
$(document).ready(readyForSetHeight);

frameSize();

	$(document).ready(lashen);
var schemaInfoOfSet = {
			tech_001:'',
			tech_002:'',
			tech_003:'',
			tech_004:'',
			tech_005:'',
			tech_006:'',
			tech_007:'',
			tech_008:'',
			tech_009:'',
			tech_010:'',
			tech_011:'',
			tech_012:'',
			tech_013:'',
			tech_014:'',
			tech_015:'',
			tech_016:'',
			tech_017:'',
			tech_018:'',
			tech_019:'',
			tech_020:''
};

var schDetDataOfSet={
			work_load:'',
			work_situation:'',
			work_factor:'',
			work_reason:'',
			work_device:'',
			work_person:''
};
var costDetailDataOfSet={
		cost_detail_money:'',
		cost_detail_desc:''
}
	
function toAdd(){
	if(selectParentIdData==null||selectParentIdData==""){
		selectParentIdData=costType;
	}
	popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetManagerEdit.upmd?pagerAction=edit2Add&parentId="+selectParentIdData+"&costType="+costType+"&projectInfoNo=<%=projectId%>");
}
function toModify(){
	if(selectParentIdData==null||selectParentIdData==""){
		selectParentIdData=costType;
	}else{
		popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetManagerEdit.upmd?pagerAction=edit2Edit&parentId="+selectUpIdData+"&id="+selectParentIdData+"&costType="+costType+"&projectInfoNo=<%=projectId%>");
	}
}
function toDelete(){
	if(selectUpIdData=='root'){
		alert("模板类型节点不允许在此删除");
	}else{
		var sql="delete from  bgp_op_target_project_info where gp_target_project_id in (select gp_target_project_id from bgp_op_target_project_info "+
				" start with parent_id = '"+selectParentIdData+"'  connect by prior gp_target_project_id = parent_id   union  select '"+selectParentIdData+"' from dual)";
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
	if(confirm("将导入最新的费用科目模板，若当前已维护了费用科目，则将会被覆盖，确定导入请点击确定，否则点击取消")){
		var submitStr="projectInfoNo="+'<%=projectId%>'+"&costType=01";
		var retObject=jcdpCallService('OPCostSrv','saveProjectCostTargetByTemplate',submitStr)
		refreshTreeStore();
	}
	
}

function refreshTreeStore(){
	initPage();
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostTargetProject.srq?projectInfoNo=<%=projectId%>&costType='+costType,
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
}

function loadDataDetail(){
	
	//载入费用详细信息
	var querySql = "select * from bgp_op_target_project_detail where bsflag='0' and gp_target_project_id ='"+selectParentIdData+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		setOneDataInfo(costDetailDataOfSet,datas[0],'target_project_detail_id');
	}else{
		setOneDataInfo(costDetailDataOfSet,null,'target_project_detail_id');
	}
	
	//载入公式信息
	var querySql = "select * from BGP_OP_TARGET_PROJECT_INFO where GP_TARGET_PROJECT_ID ='"+selectParentIdData+"'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		document.getElementById("gp_target_project_id").value=datas[0].gp_target_project_id;
		setSelectedValue("formula_type",datas[0].formula_type);
		document.getElementById("formula_content").value=datas[0].formula_content;
		document.getElementById("formula_content_a").value=datas[0].formula_content_a;
	}else{
		document.getElementById("gp_target_project_id").value='';
		setSelectedValue("formula_type",'');
		document.getElementById("formula_content").value='';
		document.getElementById("formula_content_a").value='';
	}
	
	
	//载入文档信息
	document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+selectParentIdData;
	//载入备注信息
	document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+selectParentIdData;
	//载入分类吗信息
	document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=4&relationId="+selectParentIdData
}
function toEditCost(){
	if(selectLeafOrParent==false){
		alert("根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var targetProjectDetailId=document.getElementById("target_project_detail_id").value;
		if(targetProjectDetailId==null||targetProjectDetailId==""){
			popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetProjectManagerEdit.upmd?pagerAction=edit2Add&gpTargetProjectId="+selectParentIdData);
		}else{
			popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetProjectManagerEdit.upmd?pagerAction=edit2Edit&gpTargetProjectId="+selectParentIdData+"&id="+targetProjectDetailId);
		}
	}
}
function saveCostMondyDetail(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var gpTargetProjectId=selectParentIdData;
		saveSingleTableInfoByData(costDetailDataOfSet,'bgp_op_target_project_detail','target_project_detail_id','gp_target_project_id='+gpTargetProjectId);
		refreshTreeStore();
		loadDataDetail();
	}
}
function deleteCostMondyDetail(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var id=document.getElementById("target_project_detail_id").value;
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update bgp_op_target_project_detail t set t.bsflag='1' where t.target_project_detail_id ='"+id+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+id;
		syncRequest('Post',path,params);
		refreshTreeStore();
		loadDataDetail();
	}
}
function refreshTargetBasicInfo(){
	//载入项目基本信息
	var querySql = "select * from bgp_op_target_project_basic where bsflag='0' and  tartget_basic_id ='"+targetBasicId+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		setOneDataInfo(schDetDataOfSet,datas[0]);
	}
	//载入技术指标信息
	var querySql="select * from bgp_op_target_project_indicato where bsflag='0' and tartget_basic_id='"+targetBasicId+"'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		setOneDataInfo(schemaInfoOfSet,datas[0],'target_indicator_id');
	}
	refreshTargetVersionInfo();
}

function refreshTargetVersionInfo(){
	//载入旧有版本信息
	var querySql = "select distinct t.gather_version,t.create_date from bgp_op_target_gather_info t where t.project_info_no = '<%=projectId%>'";
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
			var td = tr.insertCell();
			td.innerHTML = datas[i].gather_version;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].create_date;
			
			var td = tr.insertCell();
			td.innerHTML = "<a onclick=openTargetDetailWin('"+datas[i].gather_version+"')>查看</a>";
			
		}
	}
}
function saveTargetBasicInfo(){
	saveSingleTableInfoByData(schDetDataOfSet,'bgp_op_target_project_basic','tartget_basic_id');
}
function saveTargetIndicatorInfo(){
	saveSingleTableInfoByData(schemaInfoOfSet,'bgp_op_target_project_indicato','target_indicator_id','tartget_basic_id='+targetBasicId);
}
function toExportTargetInfo(){
	popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetProjectInfo.jsp?targetBasicId="+targetBasicId);
}
function toRefreshPlanData(){
	retObj = jcdpCallService("OPCostSrv", "hzCostPlanByFormula", "projectInfoNo=<%=projectId%>");
	refreshTreeStore();
}
function getTheMoney(){
		var value=convertCalcuFromDesc(document.getElementById("cost_detail_desc").value)
		document.getElementById("cost_detail_money").value=value;
}


function saveCostFormula(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护公式信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var gp_target_project_id=document.getElementById("gp_target_project_id").value;
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
		if(gp_target_project_id!=null&&gp_target_project_id!=''){
			tableId='&JCDP_TABLE_ID='+gp_target_project_id;
		}
		var submitStr='JCDP_TABLE_NAME=BGP_OP_TARGET_PROJECT_INFO'+tableId+'&formula_type='+formula_type+'&formula_content='+formula_content+'&bsflag=0&formula_content_a='+formula_content_a;
		var path = cruConfig.contextPath+'/rad/addOrUpdateEntity.srq';
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		loadDataDetail();
	}
}
function deleteCostFormula(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护公式信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var id=document.getElementById("gp_target_project_id").value;
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update gp_target_project_id t set t.formula_type= null,t.formula_content = null where t.gp_target_project_id ='"+id+"'";
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

function toVersionData(){
	retObj = jcdpCallService("OPCostSrv", "toGenerateVersionData", "projectInfoNo=<%=projectId%>");
	alert("生成版本成功");
	refreshTargetVersionInfo();
	getTab3(4);
}

function importTargetIndicatorInfo(){
	retObj = jcdpCallService("OPCostSrv", "importTargetIndicatorInfo", "projectInfoNo=<%=projectId%>&targetBasicId="+targetBasicId);
	refreshTargetBasicInfo();
}

function  openTargetDetailWin(versionId){
		popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetVersionDetail.jsp?projectInfoNoo=<%=projectId%>&versionId="+versionId);
}
</script>
</html>