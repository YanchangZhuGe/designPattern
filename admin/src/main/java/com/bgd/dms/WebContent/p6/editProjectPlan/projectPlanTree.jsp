<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="GBK"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat" %>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String projectInfoNo = request.getParameter("projectInfoNo");
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String todayDate = df.format(new Date());
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<style type="text/css">
    .task {
        background-image: url(<%=contextPath%>/shared/icons/fam/cog.gif) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/shared/icons/fam/folder_go.gif) !important;
    }
</style>
<script type="text/javascript" language="javascript">
var right_click_id = null;
var right_click_name = null;
var right_click_is_wbs = null;
var right_click_object_id = null;
var right_click_is_root = null;
var right_click_head=null;

Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
var nodeGet=null;
var selectParentIdData="";
var isOpen=""
var isOpenAll="";
Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'TaskId',type: 'string'},
            {name : 'Name', type : 'String'},
            {name : 'typevalue', type : 'String'},
            {name : 'typename', type : 'String'},
            {name : 'status', type : 'String'},
      		{name : 'baselineStartDate', type : 'String' },
      		{name : 'baselineFinishDate', type : 'String'},
      		/*
      		{name : 'StartDate', type : 'String'},
      		{name : 'EndDate', type : 'String' },
      		*/
      		{name : 'plannedStartDate', type : 'String' },
      		{name : 'plannedEndDate', type : 'String'},
      		{name : 'other1'},
    		{name : 'isWbs'},
    		{name : 'isRoot'},
    		{name : 'plannedDuration'},
    		{name : 'head'}
    		
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
          //  url: '<%=contextPath%>/p6/resourceAssignment/getTasksWithoutWbsDate.srq?checked=true&projectInfoNo=<%=projectInfoNo%>',
            url: '<%=contextPath%>/p6/resourceAssignment/getTaskTreeForPlan.srq?checked=true&projectInfoNo=<%=projectInfoNo%>',
            
            
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });

    
 
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'grid',
      //  title: '任务',//树的标题
        width: document.body.clientWidth*0.99,
        height: document.body.clientHeight, 
        autoHeight: true,//自动高度
        lines: false,
        renderTo: 'menuTree',//绘制的区域
        collapsible: false,
        useArrows: true,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
     //   expandAll:true,
        tbar:[{  
            text:'展开',  
            handler:function(){  
        	grid.expandAll();  
            }  
        },'-',{  
            text:'折叠',  
            handler:function(){  
        	grid.collapseAll();  
        	//grid.root.expand();  
            }  
        }],

        //the 'columns' property is now 'headers'
        columns: [
		{
		    //we must use the templateheader component so we can use a custom tpl
		    xtype: 'treecolumn',
		    text: '作业编号',
		    hidden:false,
		    flex: 1,
		    sortable: true,
		    dataIndex: 'TaskId',
		    align: 'left'
		},{
          //  xtype: 'treecolumn',
            text: '作业名字',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'Name',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '作业类型',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'typename',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '原定工期',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'plannedDuration',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '计划开始日期',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'plannedStartDate',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '计划结束日期',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'plannedEndDate',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '目标开始日期',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'baselineStartDate',
            align: 'center'
        },{
            text: '目标结束日期',
            hidden:true,
            flex: 1,
            dataIndex: 'baselineFinishDate',
            sortable: true,
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '责任人',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'head',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '状态',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'status',
            align: 'center'
        }]
    });

    
    grid.addListener('load', load);
    
    function load(treeStore,node,records,sucess){
    	ifFind=false;
    	getChildBySpecial(records);
    	if(nodeGet!=null&&nodeGet!=undefined){
    		grid.selectPath(nodeGet.getPath("other1"),"other1");
    		if(isOpen=="1"){
        		nodeGet.expand();	
        	}
    	}
    }
    function getChildBySpecial(records){
    	for(var i=0;i<records.length;i++){
    		var data=records[i].data;
    		if(data.other1==selectParentIdData){
    			nodeGet= records[i];	
    		}else{
    			getChildBySpecial(records[i].childNodes);	
    		}
    	}
    }
 
    //debugger;
    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var record = grid.getStore().getAt(1);   //Get the Record rowIndex.sourceIndex
        right_click_id = rowdata.data.id;
        right_click_name = rowdata.data.Name;
        right_click_is_wbs = rowdata.data.isWbs;
        right_click_object_id = rowdata.data.other1;
        right_click_is_root = rowdata.data.isRoot;
        right_click_head = rowdata.data.head;

        selectParentIdData=rowdata.data.other1;
     
        var isWbs = rowdata.data.isWbs;
        var taskObjectId = rowdata.data.other1;
        var isRoot = rowdata.data.isRoot;
        var taskId = rowdata.data.TaskId;
        var taskName = rowdata.data.Name;
        var head = rowdata.data.head;
        var typevalue = rowdata.data.typevalue;
        var plannedDuration = rowdata.data.plannedDuration;

        var plannedStartDate = rowdata.data.plannedStartDate;
        var plannedEndDate = rowdata.data.plannedEndDate;
        if(isWbs == "true"){
            if(right_click_is_root=="true"){
  			parent.mainDownframe.location.href = "<%=contextPath %>/p6/editProjectPlan/editProjectInfo.jsp?projectInfoNo=<%=projectInfoNo%>";
            }
  		} else {
  			//任务
  			parent.mainDownframe.location.href = "<%=contextPath %>/p6/editProjectPlan/editActivityInfo.jsp?taskName="+encodeURI(encodeURI(taskName,'UTF-8'),'UTF-8')+"&taskId="+taskId+"&typevalue="+typevalue+"&head="+encodeURI(encodeURI(head,'UTF-8'),'UTF-8')+"&plannedStartDate="+plannedStartDate+"&plannedEndDate="+plannedEndDate+"&plannedDuration="+plannedDuration+"&taskObjectId="+taskObjectId+"&projectInfoNo=<%=projectInfoNo%>";
  		}
    }
    
});


function refreshTreeStore(){
	Ext.getCmp('grid').getStore().setProxy({
			type : 'ajax',
	        method: 'get',
           // url: '<%=contextPath%>/p6/resourceAssignment/getTasksWithoutWbsDate.srq?checked=true&projectInfoNo=<%=projectInfoNo%>', 
            url: '<%=contextPath%>/p6/resourceAssignment/getTaskTreeForPlan.srq?checked=true&projectInfoNo=<%=projectInfoNo%>',
	        reader: {
	            type : 'json'
	        }
	        });
		Ext.getCmp('grid').getStore().load();
}

function refreshTree(par){
	Ext.getCmp('grid').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/p6/resourceAssignment/getTaskTreeForPlan.srq?checked=true&projectInfoNo=<%=projectInfoNo%>',
        reader: {
            type : 'json'
        }
        });
	selectParentIdData=par;
	isOpen="1";
	Ext.getCmp('grid').getStore().load(); 
}

function reload(){
	var ctt = top.frames['list'];
	if(ctt != "" && ctt != undefined){
		ctt.location.reload();
	}
}

	
</script>
</head>

<body  style="background:#cdddef" >
	<div id="list_table" >

		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>

					 <td>&nbsp;
					 <input type="button" value="进度计算" class="tj" onclick="scheduleProject()"/>	
			   		 <input type="button" value="模板列表" class="tj" onclick="templateList()"/>
			   		 <!-- 
			   		 <input type="button" value="目标计划" class="tj" onclick="JcdpButton0OnClick()"/>
			   		 <input type="button" value="删除计划" class="tj" onclick="deletePlan()"/>
			   		  -->
			   		 </td>
					    <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    		<auth:ListButton css="sc" event="onclick='deleteTasks()'" title="JCDP_btn_delete"></auth:ListButton>
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
		

</div>
</body>
<script type="text/javascript">
function toAdd(){	
	if(right_click_is_wbs=='true'){		
		if(right_click_is_root=="true"){
			popWindow("<%=contextPath%>/p6/editProjectPlan/addActivity.jsp?parentWbsObjectId="+right_click_object_id+"&parentWbsName="+encodeURI(encodeURI(right_click_name,'UTF-8'),'UTF-8')+"&projectInfoNo=<%=projectInfoNo%>");
		}else{
			popWindow("<%=contextPath%>/p6/editProjectPlan/addActivity.jsp?parentWbsObjectId="+right_click_object_id+"&parentWbsName="+encodeURI(encodeURI(right_click_name,'UTF-8'),'UTF-8')+"&head="+encodeURI(encodeURI(right_click_head,'UTF-8'),'UTF-8')+"&projectInfoNo=<%=projectInfoNo%>");
		}
	}
}
function deleteTasks(){
	var check = Ext.getCmp('grid').getChecked();

	if(check == "" || check == null){
		alert("请选择一条记录");
		return;
	}
    var checkOther1s = "";
    var checkOther2s = "";
    var parentId="";
	for(var i=0;i<check.length;i++){
		parentId = check[i].data.parentId;
		checkOther1s += "," +check[i].data.other1;
		checkOther2s += ",'" +check[i].data.other1+"'";
	}
	
	var p6_object_ids = checkOther1s =="" ? "" : checkOther1s.substr(1);
	var gms_object_ids = checkOther2s =="" ? "" : checkOther2s.substr(1);
	var str = "p6_object_ids="+p6_object_ids+"&gms_object_ids="+gms_object_ids;
	
	if(confirm('确定要删除吗?')){
		var obj = jcdpCallService("P6ProjectPlanSrv", "deleteTask", str);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
			refreshTree(parentId);
		} else {
			alert("修改失败");
		}
	}

}


function scheduleProject(){
	popWindow('<%=contextPath%>/p6/editProjectPlan/scheduleProject.jsp?project_info_no=<%=projectInfoNo%>',400);
}

function templateList(){
	popWindow('<%=contextPath%>/p6/editProjectPlan/templateList.jsp?project_info_no=<%=projectInfoNo%>');
}

function deletePlan(){
	if(confirm('确定要删除整个计划吗?')){
		var str = "project_info_no=<%=projectInfoNo%>";
		var obj = jcdpCallService("P6ProjectPlanSrv", "delPlan", str);
		if(obj != null && obj.message == "success") {
			alert("删除成功");
			reload();
		} else {
			alert("删除失败");
		}
	}
}

function JcdpButton0OnClick(){
	var str="select OBJECT_ID,WBS_OBJECT_ID from bgp_p6_project where PROJECT_INFO_NO='<%=projectInfoNo%>'";
	var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
	var retObj = unitRet.datas;
    var isSingle = true;
    parent.location.href = "<%=contextPath%>/p6/queryBaselineProjectP6.srq?isSingle="+isSingle+"&projectObjectId="+retObj[0].object_id+"&wbsObjectId="+retObj[0].wbs_object_id; 
}
</script>
</html>