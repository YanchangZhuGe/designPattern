<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	String org_id = user.getOrgId();
	String user_id = user.getUserId();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"></link>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<script type="text/javascript" language="javascript">
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var sql = "";
var rightMenu = null;
Ext.onReady(function() {
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'id',type: 'string'},
            {name : 'name', type : 'String'},
            {name : 'isfile', type : 'String'}
        ]
    });
    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/qua/sProject/quaFiles/getFileTree.srq?module_id='+module_id+"&file_abbr=PZ",
            reader: {
                type : 'json'
            }
        },
        folderSort: true
    });
    var tbar = Ext.create("Ext.Toolbar", {
        items: [
        //{xtype:"tbfill"}, //加上这句，后面的就显示到右边去了 
        {
        	id:"submit",
            xtype: "button",
            text: "确定",
       		handler: function (bar,e) {
       			var rootNode = Ext.getCmp('gridId').getStore().getRootNode().firstChild;
       			sql = "";
       			getRootChildren(rootNode);
       			
       			if(sql!=null && sql!=''){
       				var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
       				if(retObj!=null && retObj.returnCode =='0'){
       					alert("保存成功");
       					parent.menuFrame.refreshData();
       				}
       			}else{
       				alert("文件在物探处已存在!");
       			}
            }
        }]
    });
    var grid = Ext.create('Ext.tree.Panel', {
    	id:'gridId',
        title: '标准规范文档',
        width: 600,
        height: document.body.clientHeight, 
        autoHeight: true,  
        lines: true,
        renderTo: 'menuTree',
        collapsible: true,
        useArrows: false,
        rootVisible: false,
        store: store,
        multiSelect: false,
        singleExpand: false,
        resizable:true,
        tbar: tbar,
        columns: [{
            xtype: 'treecolumn',
            text: '文档名称',
            flex: 2,
            sortable: true,
            dataIndex: 'name',
            align: 'left'
        }]
    });
    var row = 0;
    grid.addListener('checkchange', checkchange);
    function checkchange(rowdata,checked) {
    	var childNodes = rowdata.childNodes;
    	if(childNodes!=null && childNodes.length>0){
    		getChildNodes(rowdata,checked);
    		getParentNode(rowdata);
    	}
    	else{
    		getParentNode(rowdata);
    	} 
    }
});
//得到根节点的所有下级节点，并得到下级节点checkbox的checked属性
function getRootChildren(rootNode) {
	for(var i =0;i<rootNode.childNodes.length;i++){
		var childNode = rootNode.childNodes[i];
		var check = childNode.data.checked;
		var isfile = childNode.data.isfile;
		if(check == true && isfile=='1'){
			var id = childNode.data.id;
			var org_subjection_id ="<%=org_subjection_id%>";
			var org_id ="<%=org_id%>";
			var user_id ="<%=user_id%>";
			if(!checkIfExist(id)){
				sql = sql + "insert into bgp_qua_files(qua_file_id ,file_id,org_id,org_subjection_id,"+
				" bsflag,creator_id,create_date,updator_id,modifi_date)"+
				" values((select lower(sys_guid()) from dual),'"+id+"' ,'"+org_id+"' ,'"+org_subjection_id+"' ," +
				" '0' ,'"+user_id+"',sysdate,'"+user_id+"' ,sysdate );";
			}
		}
		if(childNode!=null && childNode.childNodes!=null && childNode.childNodes.length>0){
			getRootChildren(childNode);
		}
	}
}
function checkIfExist(value){
	var org_subjection_id ="<%=org_subjection_id%>";
	var org_id ="<%=org_id%>";
	debugger;
	var querySql = "select t.* from bgp_qua_files t where t.bsflag='0' and t.file_id ='"+value+"' and t.org_subjection_id='"+org_subjection_id+"'";
	var retObj = syncRequest("Post" ,cruConfig.contextPath + appConfig.queryListAction ,"querySql="+encodeURI(encodeURI(querySql)));
	if(retObj!=null && retObj.returnCode=='0'){
		if(retObj.datas!=null && retObj.datas.length>0){
			return true;
		}else{
			return false;
		}
	}
	return true;
}
//得到节点的下级节点，并设置下级节点checkbox的checked属性true or false
function getChildNodes(rowdata,checked) {
	rowdata.eachChild(function (child) {   
		child.set('checked', checked);
	}); 
	var parentNode = rowdata.parentNode;
	for(var i =0;i<rowdata.childNodes.length;i++){
		var childNode = rowdata.childNodes[i];
		if(childNode!=null && childNode.childNodes!=null && childNode.childNodes.length>0){
			getChildNodes(childNode,checked);
		}
	}
}
//得到节点的上级级节点，如果上级节点的下级节点checkbox的全为checked==true，这上级节点的checkb=true
function getParentNode(rowdata) {
	var parentNode = rowdata.parentNode;
	if(parentNode!=null){
		var check = childNodesAllChecked(parentNode);
		if(check == true){
			parentNode.set('checked', true);//
			getParentNode(parentNode);
		}
		else{
			parentNode.set('checked', false);
			getParentNode(parentNode);
		}
	}
}
//得到节点的上级级节点，判断上级节点的下级节点checkbox的是否全为checked==true
function childNodesAllChecked(rowdata) {
	for(var i =0;i<rowdata.childNodes.length;i++){
		var childNode = rowdata.childNodes[i];
		if(childNode.data.checked != true){
			return false;
		}
	}
	return true;
}
</script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
		</td>
	</tr>
</table>

</body>
