<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.bgp.mcs.service.common.CodeSelectOptionsUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String projectInfoNo = user.getProjectInfoNo();
	String projectType = user.getProjectType();
	String businessType_s="5110000004100000048";
	if(projectType.equals("5000100004000000008")){
		businessType_s="5110000004100001050";
	}
	String orgId = user.getOrgId();
	String orgSubjectionId = user.getOrgSubjectionId();
	String orgAffordId = user.getSubOrgIDofAffordOrg();
	String message="";
	//菜单传过来的标志位，1为物探处0为专业化单位
	String costState = request.getParameter("costState");
	if(respMsg != null){
		costState = respMsg.getValue("costState"); 
		message = respMsg.getValue("message");
	}
	

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
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
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title></title>
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
		url('<%=contextPath%>/images/images/tree_06.png')
}

.x-tree-icon-parent {
	width: 16px;
	background-image:
		url('<%=contextPath%>/images/images/tree_06.png')
}

.x-grid-tree-node-expanded .x-tree-icon-parent {
	background-image:
		url('<%=contextPath%>/images/images/tree_06.png')
}
</style>
<style type="text/css">
    .task {
        background-image: url(<%=contextPath%>/images/images/tree_06.png) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/images/images/tree_06.png) !important;
    }
</style>
<script type="text/javascript" language="javascript">

cruConfig.contextPath = "<%=contextPath%>";
var projectInfoNo = "<%=projectInfoNo%>";
var costState = "<%=costState%>";
var orgId = "<%=orgId%>";
var orgSubjectionId = "<%=orgSubjectionId%>";
var orgAffordId = "<%=orgAffordId%>";

var str = "1-0110000019000000001-合同化员工,2-0110000019000000002-市场化用工,3-0110000059000000001-再就业,4-0110000059000000005-临时季节性用工,5-0110000059000000003-劳务派遣";


var selectedTagIndex = 0;
var selectParentIdData="";
var selectUpIdData="";
var codeTypeObjectId="";
var fs="";
var codingCode="";
var codingCodeId="";
var codingShowOrder="";
var codingSortId="0000000002";
var planSalaId="";
var sumHumanCost="";
var contCost="";
var markCost="";
var tempCost="";
var reemCost="";
var servCost="";
var notes1="";



Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Team', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'codingCodeId',type: 'string'},
            {name : 'codingCode', type : 'String'},
            {name : 'codingName', type : 'String'},
            {name : 'codingShowOrder', type : 'String'},
            {name : 'fs', type : 'String'},
            {name : 'planSalaId', type : 'String'},
            {name : 'sumHumanCost', type : 'String'},
            {name : 'contCost', type : 'String'},
            {name : 'markCost', type : 'String'},
            {name : 'tempCost', type : 'String'},
            {name : 'reemCost', type : 'String'},
            {name : 'servCost', type : 'String'},
            {name : 'notes1', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Team',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/rm/em/getCostPlanCodes.srq?projectInfoNo='+projectInfoNo+'&orgSubjectionId='+orgAffordId+'&costState='+costState,
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        width: document.body.clientWidth,
        height:document.body.clientHeight*0.8, 
        autoHeight: true,  
        lines: true,
        enableDD: false, 
        renderTo: 'menuTree',
        collapsible: false,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        EnableDD:true,
        //the 'columns' property is now 'headers'
        columns: [{
            xtype: 'treecolumn', //this is so we know which column will show the tree
            text: '名称',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'codingName'
        },{
            text: '总计（万元）',
            flex: 1,
            sortable: true,
            dataIndex: 'sumHumanCost',
            align: 'center'
        },{
            text: '合同化员工',
            flex: 1,
            sortable: true,
            dataIndex: 'contCost',
            align: 'center'
        },{
            text: '市场化用工',
            flex: 1,
            sortable: true,
            dataIndex: 'markCost',
            align: 'center'
        },{
            text: '临时季节工',
            flex: 1,
            sortable: true,
            dataIndex: 'tempCost',
            align: 'center'
        },{
            text: '再就业人员',
            flex: 1,
            sortable: true,
            dataIndex: 'reemCost',
            align: 'center'
        },{
            text: '劳务派遣',
            flex: 1,
            sortable: true,
            dataIndex: 'servCost',
            align: 'center'
        },{
            text: '备注',
            flex: 1,
            sortable: true,
            hidden:true,
            dataIndex: 'notes1',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        fs=rowdata.data.fs;
        codingShowOrder=rowdata.data.codingShowOrder;
        codingCodeId=rowdata.data.codingCodeId;
        codingCode=rowdata.data.codingCode;
        
        planSalaId=rowdata.data.planSalaId;
        sumHumanCost=rowdata.data.sumHumanCost;
        contCost=rowdata.data.contCost;
        markCost=rowdata.data.markCost;
        tempCost=rowdata.data.tempCost;
        reemCost=rowdata.data.reemCost;
        servCost=rowdata.data.servCost;
        notes1=rowdata.data.notes1;
      
    	document.getElementById("btnShow").value=fs;
     
    	if(fs != null && fs!=''){
    		 var teA = document.getElementById('btnShowTr');
        	 var parA = teA.parentNode.parentNode;
        	 parA.style.display='block'; 
    	}else{
    		 var teA = document.getElementById('btnShowTr');
        	 var parA = teA.parentNode.parentNode;
        	 parA.style.display='none'; 
    		
    	} 
    	if(codingCode.length <=2){
    		 var teA = document.getElementById('btnShowTr');
        	 var parA = teA.parentNode.parentNode;
        	 parA.style.display='none'; 
    
        	 if(codingCode =='12' ){
        		 parA.style.display='block'; 
        	 }
        	 if(codingCode =='10' ){
        		 parA.style.display='block'; 
        	 }
        	 if(codingCode =='06' ){
        		 parA.style.display='block'; 
        	 }
        	 if(codingCode =='05' ){
        		 parA.style.display='block'; 
        	 }
        	 
    	}else{
    		 var teA = document.getElementById('btnShowTr');
        	 var parA = teA.parentNode.parentNode;
        	 parA.style.display='block'; 
    		
    	}
    	document.getElementById("plan_sala_id").value=planSalaId;
		document.getElementById("subject_id").value=codingCodeId;
		document.getElementById("coding_code").value=codingCode;
		document.getElementById("sum_human_cost").value=sumHumanCost;
		
		document.getElementById("cont_cost").value=contCost;
		document.getElementById("mark_cost").value=markCost;
		document.getElementById("temp_cost").value=tempCost;
		
		document.getElementById("reem_cost").value=reemCost;
		document.getElementById("serv_cost").value=servCost;
		document.getElementById("notes").value=notes1;
        
                   
    });
});

</script>
</head>
<body  style="background:#fff" onload="page_init();">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					  	<td width="80%">&nbsp;</td>
					  	<td>
					  	    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
							<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_downloadTemplate"></auth:ListButton>
							<auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="JCDP_btn_importTemplate"></auth:ListButton>							
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">费用</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">定员定额</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">待遇标准</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">审批流程</a></li>
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
										<tr align="right" style="display:none;">
											<td>&nbsp; 
											<input name="btnShowTr" id="btnShowTr" class="input_width" value="" type="hidden" /> 
											<auth:ListButton css="bc" event="onclick='saveCostPlanDetail()'" title="JCDP_btn_save"></auth:ListButton>
											</td>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item6">总计（万元）：</td>
							<td class="inquire_form6">
							<input name="project_info_no" id="project_info_no" class="input_width" value="" type="hidden"  />
							<input name="plan_sala_id" id="plan_sala_id" class="input_width" value="" type="hidden"  />
							<input name="subject_id" id="subject_id" class="input_width" value="" type="hidden"  />
							<input name="sum_human_cost" id="sum_human_cost" class="input_width" value="" type="text" />
							<input name="coding_code" id="coding_code" class="input_width" value="" type="hidden" />
							<input name="btnShow" id="btnShow" class="input_width" value="" type="hidden" />
							</td>
							<td class="inquire_item6">合同化员工：</td>
							<td class="inquire_form6">
							<input name="cont_cost" id="cont_cost" value="" onblur="calculateCost()" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">市场化用工：</td>
							<td class="inquire_form6">
							<input name="mark_cost" id="mark_cost" value="" onblur="calculateCost()" class="input_width" type="text"  />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">临时季节工：</td>
							<td class="inquire_form6">
							<input name="temp_cost" id="temp_cost" value="" onblur="calculateCost()" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">再就业人员：</td>
							<td class="inquire_form6">
							<input name="reem_cost" id="reem_cost" value="" onblur="calculateCost()" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">劳务派遣：</td>
							<td class="inquire_form6">
							<input name="serv_cost" id="serv_cost" value="" onblur="calculateCost()" class="input_width" type="text"  />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">备注：</td>
							<td class="inquire_form6" colspan="5">
								<textarea id="notes" name="notes" onpropertychange="if(value.length>1000) value=value.substr(0,1000)" class='textarea'></textarea>
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
											<auth:ListButton css="bc" event="onclick='saveCostPlan()'" title="JCDP_btn_save"></auth:ListButton>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
				 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				 	<tr>
				         <td class="inquire_item6">项目名称：</td>
				         <td class="inquire_form6"><input name="project_name" id="project_name" class="input_width" value="" type="text" readonly="readonly"/></td>
				         <td class="inquire_item6">施工单位：</td>
				         <td class="inquire_form6"><input name="org_name" id="org_name" class="input_width" value="" type="text" readonly="readonly"/></td>
				         <td class="inquire_item6">申请单号：</td>
				         <td class="inquire_form6"><input name="plan_no" id="plan_no" value="" class="input_width" type="text" readonly="readonly"/></td>	                                   
				       </tr>
				 	 <tr>
				         <td class="inquire_item6">工作量（炮数）：</td>
				         <td class="inquire_form6">
				         <input name="cost_plan_id" id="cost_plan_id" class="input_width" value="" type="hidden" />
				         <input name="work_load" id="work_load" class="input_width" value="" type="text" />
				         </td>
				         <td class="inquire_item6">定员:</td>
				         <td class="inquire_form6"><input name="fix_num" id="fix_num" class="input_width" value="" type="text" /></td>
				         <td class="inquire_item6">日效（定额）:</td>
				         <td class="inquire_form6"><input name="daily_acti" id="daily_acti" class="input_width" value="" type="text" /></td>
				       </tr>
				       <tr>
				         <td class="inquire_item6">定额施工月：</td>
				         <td class="inquire_form6"><input name="const_month" id="const_month"  value="" class="input_width" type="text" /></td>
				         <td class="inquire_item6">准结期：</td>
				         <td class="inquire_form6"><input name="nodal_period" id="nodal_period" value="" class="input_width" type="text" /></td>
				         <td class="inquire_item6">承包期（月）：</td>
				         <td class="inquire_form6"><input name="const_period" id="const_period"   value="" class="input_width" type="text" /></td>	                                   
				       </tr>
				       <tr>
				         <td class="inquire_item6">休假期(月）：</td>
				         <td class="inquire_form6"><input name="holoday_season"  id="holoday_season"   value="" class="input_width" type="text" /></td>
				         <td class="inquire_item6">工资月（含休假期）:</td>
				         <td class="inquire_form6"><input name="wages_month"  id="wages_month"   value="" class="input_width" type="text" /></td>
				         <td class="inquire_item6">实际工作月（计划）:</td>
				         <td class="inquire_form6"><input name="acti_work_mon"  id="acti_work_mon"   value="" class="input_width" type="text" /></td>
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
											<auth:ListButton css="bc" event="onclick='saveCostPlanDetaDetail()'" title="JCDP_btn_save"></auth:ListButton>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
				 	<table width="99%" id="lineTable" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				    	<tr>
				  	      <td class="bt_info_odd">员工类型</td>
				  	      <td class="bt_info_even">人数</td>
				          <td class="bt_info_odd">制度工资（元）/劳务费</td>
				          <td class="bt_info_even">上岗津贴（元/日）</td>		
				          <td class="bt_info_odd">地区津贴（元/月）</td>
				          <td class="bt_info_even">月奖金（元）</td>			
				          <td class="bt_info_odd">误餐费（元/日）</td>           
				          <td class="bt_info_even">伙食费（元/月）
				          <input type="hidden" id="lineNum" name="lineNum" value="0"/>
				          </td> 
				        </tr>
					</table>	
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>	
				</div>
		</div>
	</div>
</body>
<script type="text/javascript">
$(document).ready(readyForSetHeight);

frameSize();

$(document).ready(lashen);

cruConfig.contextPath =  "<%=contextPath%>";
var message =  "<%=message%>";
 
var selectedTagIndex = 0;
var showTabBox = document.getElementById("tab_box_content0");

var planIds = "";
 
	if(message != "" && message != 'null'){
		alert(message);
	}
 
	var procStatusWt="";
function page_init(){

	var planId = jcdpCallService("HumanCommInfoSrv","saveHumanPlanCost","projectInfoNo=<%=projectInfoNo%>&costState=<%=costState%>");	
	
	planIds = planId.planId;
	
	var sqlWt="select proc_status, business_id  from common_busi_wf_middle where business_id='"+planIds+"' and bsflag='0' ";
	var queryRetWt = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sqlWt);
	var datasWt = queryRetWt.datas; 
	if(datasWt != null && datasWt != ""){	
		procStatusWt=datasWt[0].proc_status;
	}	
	
	
    processNecessaryInfo={         
    		businessTableName:"bgp_comm_human_plan_cost",    //置入流程管控的业务表的主表表明
    		businessType:'<%=businessType_s%>',        //业务类型 即为之前设置的业务大类
    		businessId:planIds,         //业务主表主键值
    		businessInfo:"单项目人工成本计划流程",        //用于待审批界面展示业务信息
    		applicantDate:'<%=curDate%>'       //流程发起时间
    	}; 
    	processAppendInfo={ 
    			id: planIds,
    			projectInfoNo:'<%=projectInfoNo%>',
    			buttonView:"false",
    			projectName:'<%=user.getProjectName()%>' 
    	};    	
	loadProcessHistoryInfo();
	
    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+planIds;		    
	document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+planIds;   
	
			
	if(projectInfoNo!='null'){
		var querySql = "select p.project_name, (select wmsys.wm_concat(i.org_abbreviation) from  gp_task_project_dynamic d  left join  comm_org_information i on d.org_id=i.org_id and i.bsflag='0' where p.project_info_no=d.project_info_no  and d.bsflag='0'  )  org_name,nvl(c.plan_no,'申请提交后系统自动生成') plan_no from gp_task_project p  left join bgp_comm_human_plan_cost c on p.project_info_no=c.project_info_no and c.cost_state='<%=costState%>' and c.bsflag='0'  and c.spare5 is null   where p.bsflag='0' and p.project_info_no='"+projectInfoNo+"'";		
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null){			
			document.getElementById("project_name").value=datas[0].project_name;
			document.getElementById("org_name").value=datas[0].org_name;
			document.getElementById("plan_no").value=datas[0].plan_no;
		}			
	}
	
	if(projectInfoNo!='null'){
		var querySql = "select t.cost_plan_id,t.work_load,t.fix_num,t.daily_acti,t.const_month,t.nodal_period,t.const_period,t.holoday_season,t.wages_month,t.acti_work_mon from bgp_comm_human_cost_plan t left join bgp_comm_human_plan_cost c on t.plan_id=c.plan_id and c.cost_state='<%=costState%>' and c.bsflag='0' and c.spare5 is null  where  t.spare5 is null  and    c.plan_id='"+planIds+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null && datas.length>0){
			document.getElementById("cost_plan_id").value=datas[0].cost_plan_id;
			document.getElementById("work_load").value=datas[0].work_load;
			document.getElementById("fix_num").value=datas[0].fix_num;
			document.getElementById("daily_acti").value=datas[0].daily_acti;
			
			document.getElementById("const_month").value=datas[0].const_month;
			document.getElementById("nodal_period").value=datas[0].nodal_period;
			document.getElementById("const_period").value=datas[0].const_period;
			
			document.getElementById("holoday_season").value=datas[0].holoday_season;
			document.getElementById("wages_month").value=datas[0].wages_month;
			document.getElementById("acti_work_mon").value=datas[0].acti_work_mon;
			
		}			
	}
	

	if(projectInfoNo!='null'){
		var querySql = "select t.*,d.coding_name employee_gz_name from bgp_comm_human_cost_plan_deta t left join comm_coding_sort_detail d on t.employee_gz=d.coding_code_id left join bgp_comm_human_plan_cost c on t.plan_id=c.plan_id and c.cost_state='<%=costState%>' and c.bsflag='0' and c.spare5 is null  where t.spare5 is null and  c.plan_id='"+planIds+"' order by t.show_order  ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas != null && datas.length>0){
			for (var i = 0; datas && queryRet.datas.length; i++) {
				
				addLine( datas[i].plan_deta_id, datas[i].project_info_no, datas[i].employee_gz, datas[i].gz_num,datas[i].sys_wage, datas[i].post_allow, datas[i].area_allow, datas[i].month_allow, datas[i].lunch_wage,datas[i].food_wage,datas[i].show_order,datas[i].employee_gz_name);								
			}	
		}else{
			var strTemp = str.split(",");
			for(var i=0;i<strTemp.length;i++){
				addLine( "", projectInfoNo, strTemp[i].split("-")[1], "","","","","","","",strTemp[i].split("-")[0],strTemp[i].split("-")[2]);
			}
			
		}
		
	}


}


function toSubmit(){
	var plan_noS=document.getElementById("plan_no").value; 
	if(procStatusWt != ''){
		if(procStatusWt =='3'){
			alert('计划审批通过,不能重复提交!');
			return;
		}
		if(procStatusWt =='1'){
			alert('计划待审批,不能重复提交!');
			return;
		}
		
	}
	popWindow('<%=contextPath%>/rm/em/singleHuman/humanCostPlan/add_costPlanModify.jsp?buttonView=true&planId='+planIds,'900:700');
}

function checkForm(){
	
    if(fs == ''){
	   alert("请选择一项");
	   return false;
	}
	
//	if(!checkNum("sum_human_cost")){
//		return false;
//	}
//	if(!checkNum("cont_cost")){
//		return false;
//	}
//	if(!checkNum("mark_cost")){
//		return false;
//	}
//	if(!checkNum("temp_cost")){
//		return false;
//	}
//	if(!checkNum("reem_cost")){
//		return false;
//	}
//	if(!checkNum("serv_cost")){
//		return false;
//	}

	return true;
}

function saveCostPlanDetail(){
	var plan_noS=document.getElementById("plan_no").value;   
	
	if(procStatusWt != ''){
		if(procStatusWt =='3'){
			alert('计划审批通过,不能重复提交!');
			return;
		}
		if(procStatusWt =='1'){
			alert('计划待审批,不能重复提交!');
			return;
		}
		
	}
	if(checkForm()){
		
	var coding_code = document.getElementById("coding_code").value;
	
	var plan_sala_id = document.getElementById("plan_sala_id").value;
	var project_info_no = '<%=projectInfoNo%>';
	
	var subject_id = document.getElementById("subject_id").value;
	var sum_human_cost = document.getElementById("sum_human_cost").value;
	
	var cont_cost = document.getElementById("cont_cost").value;	
	var mark_cost = document.getElementById("mark_cost").value;
	var temp_cost = document.getElementById("temp_cost").value;
	var reem_cost = document.getElementById("reem_cost").value;	
	var serv_cost = document.getElementById("serv_cost").value;
	var notes = document.getElementById("notes").value;


		var rowParams = new Array();
		var rowParam = {};
		
		rowParam['plan_sala_id'] = plan_sala_id;		
		rowParam['project_info_no'] = project_info_no;			
		rowParam['plan_id'] = planIds;			
		rowParam['subject_id'] = subject_id;
		
		rowParam['sum_human_cost'] = sum_human_cost;		
		rowParam['cont_cost'] = cont_cost;		
		rowParam['mark_cost'] = mark_cost;
		rowParam['temp_cost'] = temp_cost;
		rowParam['reem_cost'] = reem_cost;		
		rowParam['serv_cost'] = serv_cost;
		
		rowParam['notes'] =  encodeURI(encodeURI(notes));

		rowParam['cost_state'] = '<%=costState%>';
		rowParam['create_date'] = '<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';
		rowParam['org_id'] = '<%=orgId%>';
		rowParam['org_subjection_id'] = '<%=orgSubjectionId%>';
		rowParam['bsflag'] = '0';

		rowParams[rowParams.length] = rowParam;
		var rows=JSON.stringify(rowParams);

		saveFunc("bgp_comm_human_cost_plan_sala",rows);	
		
		if(coding_code.length != 2){
			var str="projectInfoNo="+project_info_no+"&codingCode="+coding_code+"&planId="+planIds;		
			jcdpCallService("HumanCommInfoSrv","saveCostPlanCodes",str);	
		}
				
		refreshTree();
	}
}

function saveCostPlan(){
	var plan_noS=document.getElementById("plan_no").value; 
	if(procStatusWt != ''){
		if(procStatusWt =='3'){
			alert('计划审批通过,不能重复提交!');
			return;
		}
		if(procStatusWt =='1'){
			alert('计划待审批,不能重复提交!');
			return;
		}
		
	}
		var cost_plan_id = document.getElementById("cost_plan_id").value;
		var project_info_no = '<%=projectInfoNo%>';
		
		var work_load = document.getElementById("work_load").value;
		var fix_num = document.getElementById("fix_num").value;
		var daily_acti = document.getElementById("daily_acti").value;
		
		var const_month = document.getElementById("const_month").value;
		var nodal_period = document.getElementById("nodal_period").value;
		var const_period = document.getElementById("const_period").value;
		
		var holoday_season = document.getElementById("holoday_season").value;
		var wages_month = document.getElementById("wages_month").value;
		var acti_work_mon = document.getElementById("acti_work_mon").value;

			
			var rowParams = new Array();
			var rowParam = {};
			rowParam['cost_plan_id'] = cost_plan_id;		
			rowParam['project_info_no'] = project_info_no;
			rowParam['plan_id'] = planIds;
			
			rowParam['work_load'] = work_load;
			rowParam['fix_num'] = fix_num;
			rowParam['daily_acti'] = daily_acti;
			
			rowParam['const_month'] = const_month;
			rowParam['nodal_period'] = nodal_period;
			rowParam['const_period'] = const_period;
			
			rowParam['holoday_season'] = holoday_season;
			rowParam['wages_month'] = wages_month;
			rowParam['acti_work_mon'] = acti_work_mon;

			rowParam['create_date'] = '<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';
			rowParam['org_id'] = '<%=orgId%>';
			rowParam['org_subjection_id'] = '<%=orgSubjectionId%>';
			rowParam['bsflag'] = '0';

			rowParams[rowParams.length] = rowParam;
			var rows=JSON.stringify(rowParams);

			saveFunc("bgp_comm_human_cost_plan",rows);	


}

function saveCostPlanDetaDetail(){
	var plan_noS=document.getElementById("plan_no").value; 
	if(procStatusWt != ''){
		if(procStatusWt =='3'){
			alert('计划审批通过,不能重复提交!');
			return;
		}
		if(procStatusWt =='1'){
			alert('计划待审批,不能重复提交!');
			return;
		}
		
	}
	var rowNum = document.getElementById("lineNum").value;	
	
	var rowParams = new Array();
	
	for(var i=0;i<rowNum;i++){
		var rowParam = {};
		
		var plan_deta_id = document.getElementsByName("plan_deta_id_"+i)[0].value;			
		var project_info_no = '<%=projectInfoNo%>';		
		var employee_gz = document.getElementsByName("employee_gz_"+i)[0].value;			
		var gz_num = document.getElementsByName("gz_num_"+i)[0].value;			
		var sys_wage = document.getElementsByName("sys_wage_"+i)[0].value;			
		var post_allow = document.getElementsByName("post_allow_"+i)[0].value;			
		var area_allow = document.getElementsByName("area_allow_"+i)[0].value;			
		var month_allow = document.getElementsByName("month_allow_"+i)[0].value;			
		var lunch_wage = document.getElementsByName("lunch_wage_"+i)[0].value;			
		var food_wage = document.getElementsByName("food_wage_"+i)[0].value;			
		var show_order = document.getElementsByName("show_order_"+i)[0].value;			

		
		rowParam['plan_deta_id'] = plan_deta_id;		
		rowParam['project_info_no'] = project_info_no;
		rowParam['plan_id'] = planIds;
		rowParam['employee_gz'] = employee_gz;
		rowParam['gz_num'] = gz_num;
		rowParam['sys_wage'] = sys_wage;
		rowParam['post_allow'] = post_allow;
		rowParam['area_allow'] = area_allow;
		rowParam['month_allow'] = month_allow;
		rowParam['lunch_wage'] = lunch_wage;
		rowParam['food_wage'] = food_wage;
		rowParam['show_order'] = show_order;

		rowParam['bsflag'] = '0';
		rowParam['create_date'] = '<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';
		rowParam['org_id'] = '<%=orgId%>';
		rowParam['org_subjection_id'] = '<%=orgSubjectionId%>';

		rowParams[rowParams.length] = rowParam;
	}
	
	var rows=JSON.stringify(rowParams);

	saveFunc("bgp_comm_human_cost_plan_deta",rows);	


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

function checkNum(numids){

	 var pattern =/^[0-9]+([.]\d{1,4})?$/;
	 var str = document.getElementById(numids).value;

	 if(str!=""){
		 if(!pattern.test(str)){
		     alert("请输入数字(例:0.0000),最高保留4位小数");
		     document.getElementById(numids).value="";
		     return false;
		 }else{
			 return true;
		 }
	  }else{
		  return true;
	  }
}

function calculateCost(){
	
	var sumTotalCharge=0;

	var cont_cost = document.getElementById("cont_cost").value;
	var mark_cost = document.getElementById("mark_cost").value;
	var temp_cost = document.getElementById("temp_cost").value;
	var reem_cost = document.getElementById("reem_cost").value;
	var serv_cost = document.getElementById("serv_cost").value;
	var testCost=cont_cost.substring(0,1); 
	
//	if(cont_cost != '' && checkNum("cont_cost")){
//		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(cont_cost);
//	}
//
//	if(mark_cost != '' && checkNum("mark_cost")){
//		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(mark_cost);
//	}
//
//	if(temp_cost != '' && checkNum("temp_cost")){
//		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(temp_cost);
//	}
//	if(reem_cost != '' && checkNum("reem_cost")){
//		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(reem_cost);
//	}
//	if(serv_cost != '' && checkNum("serv_cost")){
//		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(serv_cost);
//	}
	
	if(cont_cost != '' ){
		var testCost=cont_cost.substring(0,1); 
		if(testCost=='-'){ 
			//var  fuk=parseFloat(cont_cost.split("-")[1]);
			//alert(fuk);
			sumTotalCharge = parseFloat(sumTotalCharge)-parseFloat(cont_cost.split("-")[1]);
			
		}else{
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(cont_cost);
		}
	}

	if(mark_cost != '' ){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(mark_cost);
	}

	if(temp_cost != '' ){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(temp_cost);
	}
	if(reem_cost != ''){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(reem_cost);
	}
	if(serv_cost != '' ){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(serv_cost);
	}

	
	

	document.getElementById("sum_human_cost").value=substrin(sumTotalCharge);
		
}

function substrin(str)
{ 
	str = Math.round(str * 10000) / 10000;
	return(str); 
 }
 


function addLine( plan_deta_ids, project_info_nos, employee_gzs, gz_nums,sys_wages, post_allows, area_allows, month_allows, lunch_wages,food_wages,show_orders,employee_gz_names){
	
	var plan_deta_id = "";
	var project_info_no = "";
	var employee_gz = "";
	var gz_num = "";
	var sys_wage = "";
	var post_allow = "";
	var area_allow = "";
	var month_allow = "";
	var lunch_wage = "";
	var food_wage = "";
	var show_order = "";
	var employee_gz_name = "";

	if(plan_deta_ids != null && plan_deta_ids != ""){
		plan_deta_id=plan_deta_ids;
	}
	if(project_info_nos != null && project_info_nos != ""){
		project_info_no=project_info_nos;
	}
	if(employee_gzs != null && employee_gzs != ""){
		employee_gz=employee_gzs;
	}
	if(gz_nums != null && gz_nums != ""){
		gz_num=gz_nums;
	}
	if(sys_wages != null && sys_wages != ""){
		sys_wage=sys_wages;
	}
	if(post_allows != null && post_allows != ""){
		post_allow=post_allows;
	}
	if(area_allows != null && area_allows != ""){
		area_allow=area_allows;
	}
	if(month_allows != null && month_allows != ""){
		month_allow=month_allows;
	}	
	if(lunch_wages != null && lunch_wages != ""){
		lunch_wage=lunch_wages;
	}
	if(food_wages != null && food_wages != ""){
		food_wage=food_wages;
	}	
	if(show_orders != null && show_orders != ""){
		show_order=show_orders;
	}
	if(employee_gz_names != null && employee_gz_names != ""){
		employee_gz_name=employee_gz_names;
	}
	
	var rowNum = document.getElementById("lineNum").value;	

	var tr = document.getElementById("lineTable").insertRow();
	
	tr.align="center";		

	tr.id = "row_" + rowNum + "_";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}

	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="plan_deta_id' + '_' + rowNum + '" id="plan_deta_id' + '_' + rowNum + '" value="'+plan_deta_id+'"/>'+ '<input type="hidden" class="input_width" id="employee_gz' + '_' + rowNum + '" name="employee_gz' + '_' + rowNum + '" value="'+employee_gz+'" />'+ '<input type="hidden" class="input_width" id="project_info_no' + '_' + rowNum + '" name="project_info_no' + '_' + rowNum + '" value="'+projectInfoNo+'" />'+ '<input type="text" class="input_width" id="employee_gz_name' + '_' + rowNum + '" name="employee_gz_name' + '_' + rowNum + '" value="'+employee_gz_name+'" readonly="readonly"/>';
				
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width" id="gz_num' + '_' + rowNum + '" name="gz_num' + '_' + rowNum + '" value="'+gz_num+'" />';
	
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" class="input_width" id="sys_wage' + '_' + rowNum + '" name="sys_wage' + '_' + rowNum + '" value="'+sys_wage+'" />';
	
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width" id="post_allow' + '_' + rowNum + '" name="post_allow' + '_' + rowNum + '" value="'+post_allow+'" />';
	
	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" class="input_width" id="area_allow' + '_' + rowNum + '" name="area_allow' + '_' + rowNum + '" value="'+area_allow+'" />';
	
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width" id="month_allow' + '_' + rowNum + '" name="month_allow' + '_' + rowNum + '" value="'+month_allow+'" />';

	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" class="input_width" id="lunch_wage' + '_' + rowNum + '" name="lunch_wage' + '_' + rowNum + '" value="'+lunch_wage+'" />';

	var td = tr.insertCell(7);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width" id="food_wage' + '_' + rowNum + '" name="food_wage' + '_' + rowNum + '" value="'+food_wage+'" />'+'<input type="hidden" class="input_width" id="show_order' + '_' + rowNum + '" name="show_order' + '_' + rowNum + '" value="'+show_order+'" />';

	document.getElementById("lineNum").value = (parseInt(rowNum) + 1);

}

function toDownload(){
	var elemIF = document.createElement("iframe");  
	var iName ="人工成本计划";  
	iName = encodeURI(iName);
	iName = encodeURI(iName);
	
	elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanCostPlan/humanCostPlanTemplate.xls&filename="+iName+".xls";
	elemIF.style.display = "none";  
	document.body.appendChild(elemIF);  
}

function importData(){
	var plan_noS=document.getElementById("plan_no").value; 
	if(procStatusWt != ''){
		if(procStatusWt =='3'){
			alert('计划审批通过,不能重复提交!');
			return;
		}
		if(procStatusWt =='1'){
			alert('计划待审批,不能重复提交!');
			return;
		}
		
	}
	popWindow('<%=contextPath%>/rm/em/singleHuman/humanCostPlan/humanCostPlanImportFile.jsp?costState=<%=costState%>','700:600');
	
}
</script>
</html>