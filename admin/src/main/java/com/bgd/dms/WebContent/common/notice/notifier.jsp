<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = "";
	if(user!=null) userId = user.getUserId();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**公共变量定义*/
var rootMenuId = "root,3.2";
var rootMenuName = "常用联系人"; 
</script>

<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 

<script language="javascript" type="text/javascript">
var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

jcdpTreeCfg.rightClickEvent = false;
jcdpTreeCfg.moveEvent = false;
jcdpTreeCfg.dbClickEvent = true;

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 530,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "常用联系人维护",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function dbClickNode(node){

}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	//if(nodeInfo[1]!=='3.2') return;
	selectedNode=parentNode;
	nodeInfo = selectedNode.id.split(",");
	
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select t.entity_id,t.object_type,t.object_id,(case t.object_type when '3.1' then (select e.employee_name from comm_human_employee e where t.object_id=e.employee_id and e.bsflag='0') else spare1 end) as object_name from ic_user_favorite_dms t  where t.object_type in ('3.1','3.2','3.3') and t.user_id='<%=userId%>' and t.spare2='"+nodeInfo[0]+"' and t.bsflag='0' order by object_name"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; nodes!=null && i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
			if(parentNode.id.split(",")[1]=="3.2"){
				parentNode.ui.addClass("x-tree-node-collapsed");
			}
		},
		failure : function(){// 失败
							}			
	});//eof Ext.Ajax.request
}


/**
	根据服务器查询到的nodeData构造ext树节点
*/
function getTreeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.entity_id+','+nodeData.object_type+','+nodeData.object_id,
			text : nodeData.object_name,// 显示内容									
			leaf : false,								
			singleClickExpand:true,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	if(nodeData.object_type=="3.1" || nodeData.object_type=="3.3"){//叶子节点
		treeNode.leaf = true;
		treeNode.singleClickExpand = false;
	}

	return treeNode;
}

var nodeInfo = rootMenuId.split(",");
//selectedNode = rctTree.getRootNode();
/**
单击
*/
function clickNode(node){
	//alert(node);
	selectedNode=node;
	nodeInfo = selectedNode.id.split(",");
	//alert(nodeInfo[1]);
	var buttons = document.getElementsByName("button1");
	buttons[0].disabled=false;
	buttons[1].disabled=false;
	buttons[2].disabled=false;
	buttons[3].disabled=false;
	
	if(nodeInfo[1]=="3.1"){
		buttons[0].disabled=true;
		buttons[1].disabled=true;
		buttons[2].disabled=true;
		buttons[3].disabled=true;
	}else if(nodeInfo[1]=="3.3"){
		buttons[1].disabled=true;
		buttons[2].disabled=true;
	}
	
}
cruConfig.contextPath = "<%=contextPath%>";

function selectNotifier(){
	debugger;
	if(selectedNode==undefined)selectedNode=rctTree.getRootNode();
	var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectEmployeeMulti.jsp?noPersonalTab=true',teamInfo,"dialogHeight:600px,dialogWidth:800px");
	    debugger;
	    if(teamInfo.fkValue!=""&&teamInfo.value!=""){
		    var notifier = teamInfo.fkValue;
	    	var result = jcdpCallService('NoticeSrv','savePersonalNotifier','notifier='+notifier+'&parentId='+nodeInfo[0]); 
  			if(result.returnCode=="0"){
  				selectedNode.reload();;
  			}else{
  				alert("操作失败");
  			}
	    }
}
function addNotifierGroup(objectType){
	if(selectedNode==undefined)selectedNode=rctTree.getRootNode();
	document.getElementById("iframe1").src="editNotifierGroup.upmd?pagerAction=edit2Add&lineRange=1&noCloseButton=true&objectType="+objectType+"&parentId="+nodeInfo[0];
}
function editNotifierGroup(){
	if(selectedNode==undefined)selectedNode=rctTree.getRootNode();
	if(nodeInfo[0]=="root"){
		alert("根节点不能修改");
		return;
	}
	document.getElementById("iframe1").src="editNotifierGroup.upmd?pagerAction=edit2Edit&lineRange=1&noCloseButton=true&id="+nodeInfo[0];
}

function deleteNotifier(){
	if(selectedNode==undefined){
		selectedNode=rctTree.getRootNode();
	}
	
	if(nodeInfo[0]=="root"){
		alert("根节点不能删除");
		return;
	}
	var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	var submitStr = 'JCDP_TABLE_NAME=ic_user_favorite_dms&JCDP_TABLE_ID=&entity_id='+nodeInfo[0]+'&bsflag=1';
	var retObject = syncRequest('Post',path,submitStr);
	if (retObject.returnCode != "0") alert("删除联系人失败!");
	selectedNode.remove() ;//.parentNode.reload();
}
</script>      

</head>
<body>
<table width="100%" height="100%">
	<tr>
		<td width="40%" style="vertical-align:top " >
			<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
				<tr >
					<td align="left" style="padding-left:10px;padding-top:5px;padding-bottom:5px;">
						<input type="button" name="button1" value="添加联系人" onclick="selectNotifier()" class="iButton2"/>
						<input type="button" name="button1" value="添加文件夹" onclick="addNotifierGroup('3.2')" class="iButton2"/>
						<input type="button" name="button1" value="添加联系人组" onclick="addNotifierGroup('3.3')" class="iButton2" style="display:none"/>
						<input type="button" name="button1" value="修改" onclick="editNotifierGroup()" class="iButton2"/>						
						<input type="button" name="button1" value="删除" onclick="deleteNotifier()" class="iButton2"/>
					</td>
				</tr>
				<tr>
					<td align="left">
						<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
					</td>
				</tr>
			</table>
		</td>
		<td width="60%">
			<iframe id="iframe1" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="auto" style="margin-top:30px;"
				src="">
			</iframe>
		</td>
	</tr>
</table>

</body>