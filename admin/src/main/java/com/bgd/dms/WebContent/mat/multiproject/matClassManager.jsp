<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="GBK"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String root= "8ad889f13759d014013759d3de520003";
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>费用模板管理</title>
<style type="text/css">
    .task {
        background-image: url(<%=contextPath%>/shared/icons/fam/cog.gif) !important;
    }
    .task-folder {
        background-image: url(<%=contextPath%>/shared/icons/fam/folder_go.gif) !important;
    }
</style>
<script type="text/javascript" language="javascript">

var selectParentIdData="";
var selectUpIdData="";
var selectText = "";
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
            {name : 'codeName',type: 'string'},
            {name : 'codingCodeId',type: 'string'},
            {name : 'parentCode',type: 'string'},
            {name : 'description',type: 'string'},
            {name : 'note',type: 'string'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: true,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/mat/multiproject/matquery.srq?root=<%=root%>',
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
        height:document.body.clientHeight*0.4, 
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
            text: '物资分类',
            hideable:false,
            flex: 1,
            sortable: true,
            dataIndex: 'codeName'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '物资分类码',
            flex: 1,
            sortable: true,
            dataIndex: 'codingCodeId',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '备注',
            flex: 1,
            sortable: true,
            dataIndex: 'note',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '属性2',
            flex: 1,
            sortable: true,
            dataIndex: 'cost1',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '属性3',
            flex: 1,
            sortable: true,
            dataIndex: 'cost1',
            align: 'center'
        },{
            //we must use the templateheader component so we can use a custom tpl
            //xtype: 'templatecolumn',
            text: '属性4',
            flex: 1,
            sortable: true,
            dataIndex: 'cost1',
            align: 'center'
        }]
    });
    grid.addListener('cellclick', cellclick);

    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        //var record = grid.getStore().getAt(1);   //Get the Record rowIndex.sourceIndex
        selectParentIdData= rowdata.data.codingCodeId;
        selectUpIdData = rowdata.data.parentCode;
        selectText = rowdata.data.codeName;
    }
});

</script>
</head>
<body  style="background:#fff">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td>&nbsp;</td>
					     
					    <td><auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton></td>
					    <td><auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton></td>
					    <td><auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton></td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">标签1</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">标签1</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">标签1</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">标签1</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">标签1</a></li>
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
			
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				</div>
		</div>
	</div>
</body>
<script type="text/javascript">

$(document).ready(function() {
	var oLine = $("#line")[0];
	oLine.onmousedown = function(e) {
		var disY = (e || event).clientY;
		oLine.top = oLine.offsetTop;
		document.onmousemove = function(e) {
			var iT = oLine.top + ((e || event).clientY - disY)-70;
			$("#table_box").css("height",iT);
			//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-27);
			setTabBoxHeight();
		};
		document.onmouseup = function() {
			document.onmousemove = null;
			document.onmouseup = null;
			oLine.releaseCapture && oLine.releaseCapture()
		};
		oLine.setCapture && oLine.setCapture();
		return false
	}
}
)


function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})

function toAdd(){
	if(selectParentIdData=="" ){
		alert("请选择物资类别");
		}
	else{
		alert(selectParentIdData);
	popWindow(cruConfig.contextPath+"/mat/multiproject/matTemplateManagerEdit.upmd?pagerAction=edit2Add&parentCode="+selectParentIdData)
	}
}
function toModify(){
	if(selectParentIdData=="" ){
		alert("请选择物资类别");
		}
	else{
	popWindow(cruConfig.contextPath+"/mat/multiproject/matTemplateManagerEdit.upmd?pagerAction=edit2Edit&parentCode="+selectUpIdData+"&id="+selectParentIdData)
	}
}
function toDelete(){
	if(selectUpIdData=='root'){
		alert("模板类型节点不允许在此删除");
	}else{
		if(confirm("确定删除?"))
			{
		var sql="update gms_mat_coding_code set bsflag = '1' where coding_code_id='"+selectParentIdData+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids=";
		var retObject = syncRequest('Post',path,params);
		if(retObject.returnCode!=0) alert(retObject.returnMsg);
		refreshTree();
		}
	}
}

function refreshTreeSaveExpand(){
	var tree=Ext.getCmp('gridId')
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
</script>
</html>