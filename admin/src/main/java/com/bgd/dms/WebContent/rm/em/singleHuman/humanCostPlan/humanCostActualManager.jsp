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
	
	String projectInfoNo = user.getProjectInfoNo();
	String orgId = user.getOrgId();
	//1为物探处0为专业化单位
	String costState = "1";
	String orgSubjectionId = user.getOrgSubjectionId();
	
	if(orgSubjectionId!=null && orgSubjectionId.length()>7 && orgSubjectionId.substring(0, 7).startsWith("C105006")){
		costState = "0";
	}
	String orgAffordId = user.getSubOrgIDofAffordOrg();
	String message="";
	if(respMsg != null){
		costState = respMsg.getValue("costState"); 
		message = respMsg.getValue("message");
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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

var selectedTagIndex = 0;
var selectParentIdData="";
var selectUpIdData="";
var codeTypeObjectId="";
var fs="";
var codingCode="";
var codingCodeId="";
var codingShowOrder="";
var codingSortId="0000000002";
var sumHumanCost="";


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
            {name : 'sumHumanCost', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Team',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/rm/em/getCostActCodes.srq?projectInfoNo='+projectInfoNo+'&orgSubjectionId='+orgAffordId+'&costState='+costState,
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
            text: '计划总额（万元）',
            flex: 1,
            sortable: true,
            dataIndex: 'sumHumanCost',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', function(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        fs=rowdata.data.fs;
        codingShowOrder=rowdata.data.codingShowOrder;
        codingCodeId=rowdata.data.codingCodeId;
        
		var querySql = "select rownum,t.* from bgp_comm_human_cost_act_deta t where t.project_info_no='"+projectInfoNo+"' and t.subject_id='"+codingCodeId+"' and t.bsflag='0'  and t.org_subjection_id like '"+orgAffordId+"' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		deleteTableTr("lineTable");
		
		for (var i = 0; i<datas.length; i++) {
						
			var tr = document.getElementById("lineTable").insertRow();	
			
         	if(i % 2 == 1){  
         		tr.className = "even";
			}else{ 
				tr.className = "odd";
			}
         	
	        var td = tr.insertCell(0);
			td.innerHTML ='<INPUT id="fy'+i+'checkbox" name="rdo_entity_id"  value='+datas[i].actual_deta_id+' type=checkbox />';
			
			var td = tr.insertCell(1);
			td.innerHTML = datas[i].rownum;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].app_date.substring(0,7);
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].sum_human_cost;
			
			var td = tr.insertCell(4);
			td.innerHTML = datas[i].cont_cost;
			
			var td = tr.insertCell(5);
			td.innerHTML = datas[i].mark_cost;
		
			var td = tr.insertCell(6);
			td.innerHTML = datas[i].temp_cost;
			
			var td = tr.insertCell(7);
			td.innerHTML = datas[i].reem_cost;
			
			var td = tr.insertCell(8);
			td.innerHTML = datas[i].serv_cost;
						
		}
        

        
                   
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content" >
				<div id="inq_tool_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
							<td background="<%=contextPath%>/images/list_15.png">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr align="right">
										<td>&nbsp;</td>
										<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_filter"></auth:ListButton>
										<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						 
									</tr>
								</table></td>
							<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
						</tr>
					</table>
				</div>
			 	<table width="99%" id="lineTable" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    	<tr>
			  	      <td class="bt_info_odd">选择</td>
			  	      <td class="bt_info_even">序号</td>
			  	      <td class="bt_info_odd">日期</td>
			  	      <td class="bt_info_even">本月人工成本发生总额</td>
			  	      <td class="bt_info_odd">合同化员工</td>
			          <td class="bt_info_even">市场化用工</td>
			          <td class="bt_info_odd">临时季节工</td>		
			          <td class="bt_info_even">再就业人员</td>
			          <td class="bt_info_odd">劳务派遣</td>			
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


if(message != "" && message != 'null'){
	alert(message);
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

function deleteTableTr(tableID){
	var tb = document.getElementById(tableID);
     var rowNum=tb.rows.length;
     for (i=1;i<rowNum;i++)
     {
         tb.deleteRow(i);
         rowNum=rowNum-1;
         i=i-1;
     }
}

function toAdd(){
	//fs为空增加班组 为1增加岗位
	

	popWindow("<%=contextPath%>/rm/em/singleHuman/humanCostPlan/add_humanCostActualModify.jsp?codingCodeId="+codingCodeId+"&costState=<%=costState%>");


}
function toEdit(){
	
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	popWindow("<%=contextPath%>/rm/em/singleHuman/humanCostPlan/add_humanCostActualModify.jsp?id="+ids);

}

function toDownload(){
	var elemIF = document.createElement("iframe");  
	
	var iName ="人工成本实际发放情况";  
	iName = encodeURI(iName);
	iName = encodeURI(iName);
	
	elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanCostPlan/humanCostActualTemplate.xls&filename="+iName+".xls";
	elemIF.style.display = "none";  
	document.body.appendChild(elemIF);  
}

function importData(){
	popWindow('<%=contextPath%>/rm/em/singleHuman/humanCostPlan/humanCostActualImportFile.jsp?costState=<%=costState%>','700:600');
	
}
</script>
</html>