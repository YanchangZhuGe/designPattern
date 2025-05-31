<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="GBK"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>

<%

	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}

	String extPath = contextPath + "/js/ext-min";
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String todayDate = df.format(new Date());
%>
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

<style type="text/css">
.help a {
	height:24px;
	width:24px;
	background:url(../../images/img/header_btn_help.png) no-repeat;
	display:inline;
	float:left;
	margin-top:2px;
}
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
background-image:url(<%=extPath%>/resources/themes/images/default/tree/folder.gif); WIDTH: 16px

}

.x-tree-icon-parent {
background-image:url(<%=extPath%>/resources/themes/images/default/tree/folder.gif); WIDTH: 16px

}

.x-grid-tree-node-expanded .x-tree-icon-parent {
background-image:url(<%=extPath%>/resources/themes/images/default/tree/folder.gif); WIDTH: 16px

}
</style>
<style type="text/css">
    .task {
        background-image: url(<%=contextPath%>/images/images/tree_10.png) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/images/images/tree_10.png) !important;
    }
</style>
<script type="text/javascript" language="javascript">
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
var nodeGet=null;
var selectParentIdData="";
var selectedTagIndex = 0;
var isOpen=""
var right_click_name = null;
var right_click_object_id = null;
var right_click_parent_object_id = null;

Ext.onReady(function() {
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'code',type: 'string'},
            {name : 'name', type : 'String'},
            {name : 'wbsobjectid', type : 'String'},
            {name : 'pwbsobjectid', type : 'String'},
            {name : 'orderCode',type:'String'},
            {name : 'wbshead',type:'String'},
            {name : 'clndrId',type:'String'},
            {name : 'clndrName',type:'String'},
    		{name : 'objectId',type:'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/p6/resourceAssignment/getWbsTreeFroPlan.srq?projectInfoNo=<%=projectInfoNo%>',
            reader: {
                type : 'json'
            }
        },
        folderSort: false
    });

    
 
    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel 
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'grid',
       //title: 'WBS�ƻ�',//���ı���
        width: document.body.clientWidth*0.99,
        height: document.body.clientHeight, 
        autoHeight:true,//�Զ��߶�
        lines: false,
        renderTo: 'menuTree',//���Ƶ�����
        collapsible: false,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        folderSort:false,
        
     //   autoScroll:true,
    	//animate:false,
        singleExpand: false,
        enableDD : true,
        tbar:[{  
            text:'չ��',  
            handler:function(){  
        	grid.expandAll();  
            }  
        },'-',{  
            text:'�۵�',  
            handler:function(){  
        	grid.collapseAll();  
        	//grid.root.expand();  
            }  
        }],

        viewConfig: {
            plugins: {
                ptype: 'treeviewdragdrop',
                	appendOnly:false
            },
            listeners: {
                beforedrop: function (node,data,overModel,dropPosition,eOpts ) {
                	var sourceNode=data.records[0].data;
                	var targetNode=overModel.data;
                	var beforeOrAfter=dropPosition;
                	
	                	Ext.Ajax.request({
	            			url:'<%=contextPath%>/p6/resourceAssignment/saveP6ProjectWbsOrder.srq?projectInfoNo=<%=projectInfoNo%>',      
	            			 			
	            			params:{

                				targetWbsObjectId:targetNode.wbsobjectid,
                				targetPwbsObjectId:targetNode.pwbsobjectid,
                				targetOrdercode:targetNode.orderCode,

                				sourceWbsObjectId:sourceNode.wbsobjectid,
                				sourcePwbsObjectId:sourceNode.pwbsobjectid,
                				sourceOrdercode:sourceNode.orderCode,
                				beforeOrAfter:beforeOrAfter
		            			
	                			}
	                		});

	                
                }
            }
        },


        //the 'columns' property is now 'headers'
        columns: [
		{
		    //we must use the templateheader component so we can use a custom tpl
		    //xtype: 'templatecolumn',
		    xtype: 'treecolumn',
		    text: '���',
		    hidden:false,
		    flex: 1,
		    sortable: true,
		    dataIndex: 'code',
		    align: 'left'
		},{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '����',
            flex: 1,
            hideable:false,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: 'id',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'wbsobjectid',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '������',
            hidden:false,
            flex: 1,
            sortable: true,
            dataIndex: 'wbshead',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '��id',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'pwbsobjectid',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '����',
            hidden:true,
            flex: 1,
            sortable: true,
            dataIndex: 'orderCode',
            align: 'center'
        }]
    });

    //debugger;
    grid.addListener('itemcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ�����

    grid.addListener('cellclick', cellclick);
    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        var record = grid.getStore().getAt(1);   //Get the Record rowIndex.sourceIndex
        right_click_name=rowdata.data.name;
        right_click_object_id=rowdata.data.wbsobjectid;
        right_click_parent_object_id=rowdata.data.pwbsobjectid;
        
        selectParentIdData= rowdata.data.wbsobjectid;
        var code = rowdata.data.code;
        var name = rowdata.data.name;
        var wbshead = rowdata.data.wbshead;
        var wbsObjectId = rowdata.data.wbsobjectid;
        var clndrId = rowdata.data.clndrId;
        var probjectId = rowdata.data.objectId;

        
        
        
        if("root"==right_click_parent_object_id){
            $("#wbsCodeC").html("��Ŀ��ţ�");
            $("#wbsNameC").html("��Ŀ���ƣ�");  
            $("#clndrNameC").html("������");  
            $("#clndrName").val(clndrId); 
            $("#clndrName").show();  
             
                     
        }else{
            $("#wbsCodeC").html("WBSCode��");
            $("#wbsNameC").html("WBS���ƣ�");
            $("#clndrNameC").html("");  
            $("#clndrName").hide();  
            
            
        }
        $("#wbs_pobject_id").val(right_click_parent_object_id);
        $("#probjectId").val(probjectId);
        $("#wbs_object_id").val(wbsObjectId);
        $("#wbs_code").val(code);
        $("#wbs_name").val(name);
        $("#wbs_head").val(wbshead);
        
        
    }


    
    grid.addListener('load', load);
    function load(treeStore,node,records,sucess){
    	ifFind=false;
    	getChildBySpecial(records);
    	if(nodeGet!=null&&nodeGet!=undefined){
    		grid.selectPath(nodeGet.getPath("wbsobjectid"),"wbsobjectid");
    		if(isOpen=="1"){
        		nodeGet.expand();
        	}    		
    	}
    }

    function getChildBySpecial(records){
    	for(var i=0;i<records.length;i++){
    		var data=records[i].data;
    		if(data.wbsobjectid==selectParentIdData){
    			nodeGet= records[i];	
    		}else{
    			getChildBySpecial(records[i].childNodes);
    		}
    	}
    }

    //var right_click_ = null;

    var rightClick = new Ext.menu.Menu({
    	id:'rightClickCont', 
	    items: [
	    		{
	    			text:"����WBS",
	    			handler:function(grid,rowdata, item, rowIndex, e){
	    			//alert(right_click_object_id);
		  					popWindow("<%=contextPath%>/p6/editProjectPlan/addWBS.jsp?parentWbsObjectId="+right_click_object_id+"&parentWbsName="+encodeURI(encodeURI(right_click_name,'UTF-8'),'UTF-8')+"&projectInfoNo=<%=projectInfoNo%>",500);
							//window.showModalDialog("<%=contextPath%>/p6/editProjectPlan/addWBS.jsp?parentWbsObjectId="+right_click_id+"&parentWbsName="+encodeURI(encodeURI(right_click_name,'UTF-8'),'UTF-8')+"&projectInfoNo=<%=projectInfoNo%>",window,"dialogWidth=800px;dialogHeight=600px")

	    			}
	    		}
	    		,"-"
	    		,{
	    			text:"ɾ��WBS",
	    			handler:function(grid,rowdata, item, rowIndex, e){
	    				
	    				var str = "wbsObjectId="+right_click_object_id;
	    				if(confirm('ȷ��Ҫɾ����?����ɾ�������������ҵ')){
		    				var obj = jcdpCallService("P6ProjectPlanSrv", "deleteWBS", str);
		    				if(obj != null && obj.message == "success") {
		    					alert("ɾ���ɹ�");
		    					refreshTree(right_click_parent_object_id);		    					
		    				} else {
		    					alert("ɾ��ʧ��");
		    				}
	    				}
	    			}
	    		}
	    	]
    });

    grid.addListener('itemcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ�����
    
    function rightClickFn(grid,rowdata, item, rowindex, e) {

    	
      //  right_click_id = rowdata.data.id;
        right_click_name = rowdata.data.name;
        right_click_object_id = rowdata.data.wbsobjectid;
        right_click_parent_object_id= rowdata.data.pwbsobjectid;
        selectParentIdData= rowdata.data.wbsobjectid;
        
    	e.preventDefault();//��ֹĬ����Ϊ���磺��ֹ�ű����л�����ֹ�¼���������ִ��
		e.stopEvent();//��ֹĬ����Ϊ���磺��ֹ�ű����л�����ֹ�¼���������ִ��
	    rightClick.show();//��ʾλ�� ����rightClick.showAt();//��ʾλ�� 
    	rightClick.showBy(item);

		
    }

});
	

function refreshTreeStore(){
		Ext.getCmp('grid').getStore().setProxy({
				type : 'ajax',
		        method: 'get',
	            url: '<%=contextPath%>/p6/resourceAssignment/getWbsTreeFroPlan.srq?projectInfoNo=<%=projectInfoNo%>',
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
            url: '<%=contextPath%>/p6/resourceAssignment/getWbsTreeFroPlan.srq?projectInfoNo=<%=projectInfoNo%>',
	        reader: {
	            type : 'json'
	        }
	        });
	
		selectParentIdData=par;
		isOpen="1";
		Ext.getCmp('grid').getStore().load(); 
}


</script>
</head>
<body style="background:#cdddef">

	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				    <td background="<%=contextPath%>/images/list_15.png">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					  		<tr>
							    <td>&nbsp;</td>
					    <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    		<auth:ListButton css="sc" event="onclick='deleteTasks()'" title="JCDP_btn_delete"></auth:ListButton><!--
			    		<auth:ListButton css="help" event="onclick='tohelp()'" title="����"></auth:ListButton>
			    		
					 		 --></tr>
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
	    <li class="selectTag" style="padding-right: 12px;" id="tag3_0"><a href="#" onclick="getTab3(0)">����</a></li>
	  </ul>
	</div>
	    
	<div id="tab_box" class="tab_box" >
		<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr align="right">
		           <td>&nbsp;</td>
		           <td width="30" id="buttonDis1" ><span class="bc"  onclick="updateWBS()"><a href="#"></a></span></td>
		           <td width="5"></td>
		       </tr>
		    </table>
		    		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			   
			   		<input type="hidden" name="wbs_pobject_id" id="wbs_pobject_id" value=""/>
			   		<input type="hidden" name="probjectId" id="probjectId" value=""/>
			   
			      <td class="inquire_item4"><span id="wbsNameC">WBS���ƣ�<span/></td>
			      <td class="inquire_form4">
			      	<input name="wbs_name" id="wbs_name" class="input_width" type="text" value=""/>
					<input type="hidden" name="wbs_object_id" id="wbs_object_id" value=""/>
					
				  </td>
			      <td class="inquire_item4"><span id="wbsCodeC">WBSCode��</span></td>
			      <td class="inquire_form4"><input name="wbs_code" id="wbs_code" class="input_width" type="text" value="" readonly="readonly"/></td>
			   </tr>
			   <tr>
			      <td class="inquire_item4">�����ˣ�</td>
			      <td class="inquire_form4">
			      	<input name="wbs_head" id="wbs_head" class="input_width" type="text" value=""/>
					<input type="hidden" name="wbs_object_id" id="wbs_object_id" value=""/>
				  </td>
			      <td class="inquire_item4"><span id="clndrNameC"></span></td>
			      <td class="inquire_form4">
			      	<select name="clndrName" id="clndrName">
			      	</select>
			      </td>
			   </tr>



			</table>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
var proSql = "select OBJECT_ID,NAME from BGP_P6_CALENDAR ";
var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql+'&pageSize=1000');
retObj = proqueryRet.datas;		
for(var c=0;c<retObj.length;c++){
	$("#clndrName").append('<option value="'+retObj[c].object_id+'">'+retObj[c].name+'</option>');
	$("#clndrName").hide();
}

function tohelp(){
	popWindow("<%=contextPath%>/p6/editProjectPlan/help.jsp");

}
function frameSize(){
	//$("#line").css("top",300);
	
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height());
	setTabBoxHeight();
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

function toAdd(){
		popWindow("<%=contextPath%>/p6/editProjectPlan/addWBS.jsp?parentWbsObjectId="+right_click_object_id+"&parentWbsName="+encodeURI(encodeURI(right_click_name,'UTF-8'),'UTF-8')+"&projectInfoNo=<%=projectInfoNo%>",500);
		
}

function deleteTasks(){
	var str = "wbsObjectId="+right_click_object_id;
	if(confirm('ȷ��Ҫɾ����?����ɾ�������������ҵ')){
		var obj = jcdpCallService("P6ProjectPlanSrv", "deleteWBS", str);
		if(obj != null && obj.message == "success") {
			alert("ɾ���ɹ�");
			refreshTree(right_click_parent_object_id);		    					
		} else {
			alert("ɾ��ʧ��");
		}
	}
	
}


function updateWBS(){
	var bf = $("#wbs_pobject_id").val();
	if(bf=='root'){
		var probjectId = $("#probjectId").val();
		var clndrName = $("#clndrName").val();
		var str = "probjectId="+probjectId+"&clndrName="+clndrName;
			var obj = jcdpCallService("P6ProjectPlanSrv", "updateCALENDAR", str);
		if(obj != null && obj.message == "success") {
			alert("�޸ĳɹ�");
			refreshTreeStore();
		} else {
			alert("�޸�ʧ��");
			
		}

	}else{
		var str = "wbs_name="+document.getElementById("wbs_name").value;
		str += "&wbs_object_id="+encodeURI(encodeURI(document.getElementById("wbs_object_id").value));
		var wbscode = document.getElementById("wbs_code").value;
		wbscode=wbscode.substring(wbscode.lastIndexOf(".")+1,wbscode.length);
		str += "&wbs_code="+wbscode;
		str += "&wbs_head="+document.getElementById("wbs_head").value;

		var obj = jcdpCallService("P6ProjectPlanSrv", "updateWBS", str);
		
		if(obj != null && obj.message == "success") {
			alert("�޸ĳɹ�");
			refreshTreeStore();
		} else {
			alert("�޸�ʧ��");
			
		}
	}

}


$(document).ready(lashen);
$("#table_box").css("height",290);

</script>



</html>