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
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String	projectInfoNo=request.getParameter("projectInfoNo")==null?user.getProjectInfoNo():request.getParameter("projectInfoNo");
	String	projectType=request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String	projectName= request.getParameter("projectName")==null?user.getProjectName():java.net.URLDecoder.decode(request.getParameter("projectName"),"utf-8");
	String signle = request.getParameter("signle")==null?"":request.getParameter("signle");
 
	String orgId = user.getOrgId();
	String user_id = user.getUserId();
	String message="";
	//1为物探处0为专业化单位
	String costState = "1";
	if(respMsg != null){
		message = respMsg.getValue("message");
	}
	
	String codeId="0000000005";//树编码  select * from comm_human_coding_sort s where s.coding_sort_id = '0000000005'
	
 
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
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
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
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
var codeId="<%=codeId%>"
var selectedTagIndex = 0;
var codingCodeId="";
var codingShowOrder="";
var planSalaId="";
var sumHumanCost="";
var contCost="";
var markCost="";
var reemCost="";
var workerCost="";
var recruitCost="";
var notes1="";
var codingLever=0;
var parentId="";


Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
Ext.onReady(function() {
    Ext.define('Team', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'codingCodeId',type: 'string'},
            {name : 'codingName', type : 'String'},
            {name : 'codingShowOrder', type : 'String'},
            {name : 'codingLever', type : 'String'},
            {name : 'planSalaId', type : 'String'},
            {name : 'sumHumanCost', type : 'String'},
            {name : 'contCost', type : 'String'},
            {name : 'markCost', type : 'String'},
            {name : 'reemCost', type : 'String'},
            {name : 'workerCost', type : 'String'},
            {name : 'recruitCost', type : 'String'},
            {name : 'notes1', type : 'String'},
            {name : 'superiorCodeId',type:'String'},
            {name : 'parentP',type:'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Team',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/rm/em/getHumanCodingSortDetailZh.srq?projectType=<%=projectType%>&codeId='+codeId+'&projectInfoNo='+projectInfoNo,
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

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
        viewConfig : { forceFit: true },
        columns: [{
            xtype: 'treecolumn',
            text: '名称',
            hideable:false,
            //flex: 1,
            width:200,
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
            text: '再就业人员',
            flex: 1,
            sortable: true,
            dataIndex: 'reemCost',
            align: 'center'
        },{
            text: '招聘骨干',
            flex: 1,
            sortable: true,
            dataIndex: 'recruitCost',
            align: 'center'
        },{
            text: '外雇工',
            flex: 1,
            sortable: true,
            dataIndex: 'workerCost',
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
        codingLever=rowdata.data.codingLever;
        codingShowOrder=rowdata.data.codingShowOrder;
        codingCodeId=rowdata.data.codingCodeId;
        planSalaId=rowdata.data.planSalaId;
        sumHumanCost=rowdata.data.sumHumanCost;
        contCost=rowdata.data.contCost;
        markCost=rowdata.data.markCost;
        reemCost=rowdata.data.reemCost;
        recruitCost=rowdata.data.recruitCost;
        workerCost=rowdata.data.workerCost;
        notes1=rowdata.data.notes1;
    	document.getElementById("btnShow").value=codingLever;
    	document.getElementById("subject_id").value=codingCodeId;
    	document.getElementById("superior_code_id").value=rowdata.data.superiorCodeId;
    	
    	  parentId=rowdata.data.parentP; 
    	
    	
    	
    	if("0"!=codingLever){ 
    		if(""==signle){//是否单项目
	    		var teA = document.getElementById('btnShowTr');
	        	var parA = teA.parentNode.parentNode;
	        	parA.style.display='block'; 
	        	
	        	if( parentId == "s"){
	        		var teA = document.getElementById('btnShowTr');
	            	var parA = teA.parentNode.parentNode;
	            	parA.style.display='none';  
	        	}else{
	        		var teA = document.getElementById('btnShowTr');
	            	var parA = teA.parentNode.parentNode;
	            	parA.style.display='block';  
	        		
	        	}
	        	
    		}
    	}else{
    		var teA = document.getElementById('btnShowTr');
        	var parA = teA.parentNode.parentNode;
        	parA.style.display='none'; 
    		
    	} 
    	document.getElementById("plan_sala_id").value=planSalaId;
		document.getElementById("sum_human_cost").value=sumHumanCost;
		document.getElementById("cont_cost").value=contCost;
		document.getElementById("mark_cost").value=markCost;
		document.getElementById("reem_cost").value=reemCost;
		document.getElementById("worker_cost").value=workerCost;
		document.getElementById("recruit_cost").value=recruitCost;
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
					  	<td width="80%">&nbsp;&nbsp;<b><label id="labelName" name="labelName" ></label></b></td>
					  	<td>
					  	<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="下载模板"></auth:ListButton>
						<auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="导入"></auth:ListButton>							
				
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
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">备注</a></li>
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
											<auth:ListButton css="bc" event="onclick='saveCostPlanDetail()'" title="保存"></auth:ListButton>
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
							<input name="sum_human_cost" id="sum_human_cost" class="input_width" value="" type="text" />
							<input name="subject_id" id="subject_id" class="input_width" value="" type="hidden"  />
							<input name="btnShow" id="btnShow" class="input_width" value="" type="hidden" />
							<input name="superior_code_id" id="superior_code_id" class="input_width" value="" type="hidden" />
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
							<td class="inquire_item6">再就业人员：</td>
							<td class="inquire_form6">
								<input name="reem_cost" id="reem_cost" value="" onblur="calculateCost()" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">招聘骨干：</td>
							<td class="inquire_form6">
								<input name="recruit_cost" id="recruit_cost" value="" onblur="calculateCost()" class="input_width" type="text"  />
							</td>
							<td class="inquire_item6">外雇工：</td>
							<td class="inquire_form6">
								<input name="worker_cost" id="worker_cost" value="" onblur="calculateCost()" class="input_width" type="text"  />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">备注：</td>
							<td class="inquire_form6" colspan="5">
								<textarea id="notes" name="notes" onpropertychange="if(value.length>200) value=value.substr(0,200)" class='textarea'></textarea>
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
var signle="<%=signle%>";

var querySqlON = "    select project_name  from gp_task_project where project_info_no='"+projectInfoNo+"' and bsflag='0' ";
var queryRetON = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+querySqlON);		
var datas = queryRetON.datas;
if(datas != null && datas != ''){
	document.getElementById("labelName").innerText=datas[0].project_name; 
}
if(""!=message&&'null'!=message){
	if(message=="1"){

		alert("导入成功!");
	}

}

function page_init(){
	var planId = jcdpCallService("HumanCommInfoSrv","saveHumanPlanCost","projectInfoNo=<%=projectInfoNo%>&costState=<%=costState%>");	
	planIds = planId.planId;
    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+planIds;		    
	document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+planIds;   
}

function checkForm(){
	if (!isValidFloatProperty13_3("sum_human_cost","总计（万元）")) return false;  
	if (!isValidFloatProperty13_3("cont_cost","合同化员工")) return false;  
	if (!isValidFloatProperty13_3("mark_cost","市场化用工")) return false;  
	if (!isValidFloatProperty13_3("reem_cost","再就业人员")) return false;  
	if (!isValidFloatProperty13_3("recruit_cost","招聘骨干")) return false;  
	if (!isValidFloatProperty13_3("worker_cost","外雇工")) return false;  
	return true;
}

function saveCostPlanDetail(){
	if(checkForm()){
		var plan_sala_id = document.getElementById("plan_sala_id").value;
		var project_info_no = '<%=projectInfoNo%>';
		var sum_human_cost = document.getElementById("sum_human_cost").value;
		var cont_cost = document.getElementById("cont_cost").value;	
		var mark_cost = document.getElementById("mark_cost").value;
		var reem_cost = document.getElementById("reem_cost").value;	
		var recruit_cost = document.getElementById("recruit_cost").value;
		var worker_cost = document.getElementById("worker_cost").value;	
		var notes = document.getElementById("notes").value;
		var subject_id = document.getElementById("subject_id").value;
		var rowParams = new Array();
		var rowParam = {};
		rowParam['plan_sala_id'] = plan_sala_id;		
		rowParam['project_info_no'] = project_info_no;			
		rowParam['plan_id'] = planIds;			
		rowParam['sum_human_cost'] = sum_human_cost;		
		rowParam['cont_cost'] = cont_cost;		
		rowParam['mark_cost'] = mark_cost;
		rowParam['reem_cost'] = reem_cost;		
		rowParam['recruit_cost'] = recruit_cost;
		rowParam['worker_cost'] = worker_cost;
		rowParam['notes'] =  encodeURI(encodeURI(notes));
		rowParam['cost_state'] = '<%=costState%>';
		rowParam['create_date'] = '<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';
		rowParam['org_id'] = '<%=orgId%>';
		rowParam['bsflag'] = '0';
		rowParam['subject_id'] = subject_id;
		
		rowParams[rowParams.length] = rowParam;
		var rows=JSON.stringify(rowParams);
		saveFunc("bgp_comm_human_cost_plan_sala",rows);	

		var superior_code_id = document.getElementById("superior_code_id").value;
		var str="projectInfoNo="+project_info_no+"&superiorCodeId="+superior_code_id+"&planId="+planIds;		
		jcdpCallService("HumanCommInfoSrv","saveCostPlanListCodes",str);	
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

function calculateCost(){
	var sumTotalCharge=0;
	var cont_cost = document.getElementById("cont_cost").value;
	var mark_cost = document.getElementById("mark_cost").value;
	var reem_cost = document.getElementById("reem_cost").value;
	var recruit_cost = document.getElementById("recruit_cost").value;
	var worker_cost = document.getElementById("worker_cost").value;
	if(""!=cont_cost){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(cont_cost);
	}
	if(""!=mark_cost){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(mark_cost);
	}
	if(reem_cost != ''){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(reem_cost);
	}
	if(""!=recruit_cost){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(recruit_cost);
	}
	if(""!=worker_cost){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(worker_cost);
	}
	document.getElementById("sum_human_cost").value=substrin(sumTotalCharge);
}

function substrin(str){ 
	str = Math.round(str * 10000) / 10000;
	return(str); 
}

 
function toDownload(){
	var elemIF = document.createElement("iframe");  
	var iName ="综合人工成本计划";  
	iName = encodeURI(iName);
	iName = encodeURI(iName);
	
	elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanCostPlan/hcostPlan.xlsx&filename="+iName+".xlsx";
	elemIF.style.display = "none";  
	document.body.appendChild(elemIF);  
}

function importData(){ 
	popWindow('<%=contextPath%>/rm/em/singleHuman/humanCostPlan/humanCPlanIFileZh.jsp?costState=1&projectType=<%=projectType%>&projectInfoNo=<%=projectInfoNo%>&projectName=<%=projectName%>&planId='+planIds,'700:600');
	
}

 
</script>
</html>