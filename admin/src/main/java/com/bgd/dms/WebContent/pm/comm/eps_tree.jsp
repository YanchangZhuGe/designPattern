<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.project.ProjectSrv"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	//String rootMenuId = request.getParameter("project_info_no");
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = "C105";
	String orgId = "C6000000000001";
	if(user != null){
		orgSubId = user.getSubOrgIDofAffordOrg();
		orgId = user.getCodeAffordOrgID();
	}
	
	String backUrl = request.getParameter("backUrl");
	String action = request.getParameter("action");
	if("".equals(action) || action == null){
		action = "edit";
	}
	
	String flag = request.getParameter("select");
	if("".equals(flag) || flag == null){
		flag = "false";
	} else {
		flag = "true";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title></title>
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var orgSubId = "<%=orgSubId%>";
var orgId = "<%=orgId%>";

/**公共变量定义*/
cruConfig.contextPath = "<%=contextPath%>";

if(orgSubId != "C105"){
	querySql = "select eps.eps_name as name,eps.object_id,eps.object_id || ',' || eps.org_id || ',' || os.org_subjection_id as id from bgp_eps_code eps " +
	  		   " join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0'"+           
	  		   " join bgp_eps_code eps1 on eps.parent_object_id = eps1.object_id and eps1.bsflag = '0'  and eps1.org_id = 'C6000000000001'"+                                                          
	 		   " where eps.bsflag ='0' and eps.org_id = '"+orgId+"' order by eps.order_num";
}else{
	querySql = "select eps_name as name,object_id||','||eps.org_id||','||os.org_subjection_id as id from bgp_eps_code eps join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0' where eps.bsflag ='0' and eps.org_id = '<%=orgId%>' order by order_num";
}

var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
if(queryOrgRet.datas.length!=0){
	var rootMenuName = queryOrgRet.datas[0].name; 
	var rootMenuId = queryOrgRet.datas[0].id;
}



var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

jcdpTreeCfg.clickEvent=true;
jcdpTreeCfg.rightClickEvent = false;
jcdpTreeCfg.moveEvent = false;
jcdpTreeCfg.dbClickEvent = <%=flag%>;
var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	border : false,
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 300,// 初始宽度
	minSize : 250,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "EPS树",// 显示标题
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:false
};



//设置右键菜单
function setRightMenu()
{

}

function clickNode(selectedNode){
	var projectType="";
	var ids = selectedNode.id;
	var idss = ids.split(",");
	if("国际勘探事业部"==selectedNode.text){
		projectType="5000100004000000006"; 
	} else 
	if("井中地震"==selectedNode.text){
		projectType="5000100004000000008";
	} else 
	if("综合物化探处"==selectedNode.text){
		projectType="5000100004000000009";
	} else 
	if("陆地地震"==selectedNode.text  && "新兴物探开发处"==selectedNode.parentNode.text ){
		projectType="5000100004000000002";
	} else if("大港物探处"==selectedNode.text||"C105007"==idss[2]){
		projectType="5000100004000000001,5000100004000000002,5000100004000000010";
	}  else {//原来三期地震项目
	    projectType="5000100004000000001";
	}
	if(""!=projectType){
		parent.mainRightframe.location.href = "<%=contextPath %><%=backUrl %>?projectType="+projectType+"&action=<%=action %>&orgSubjectionId="+idss[2]+"&orgId="+idss[1]+"&epsObjectId="+idss[0]+"&clickNode=1&forwardJsp=/rm/dm/devdis/disMainInfoList.jsp";
	}
}

function dbClickNode(selectedNode){
	/*var obj = window.dialogArguments;
	obj.fkValue = node.id;
	obj.value = node.text;

	window.close();
	*/
}

/**
	移动菜单节点
*/
function moveMenu(tree,node,oldParent,newParent,index){
	var actionUrl = "<%=contextPath%>/tcg/moveTreeNodePosition.srq";
	var submitStr = "tableName=p_auth_menu_dms&pkName=menu_id&fkName=parent_menu_id&orderName=order_num&leafFlagName=is_leaf";
	submitStr += "&pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id+"&newParentId="+newParent.id;
	var ret = syncRequest('post',actionUrl,submitStr);
	if(ret.returnCode!='0'){
		alert(ret.returnMsg);
		return;
	}
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		
	var ids = parentNode.id;
	var idss = ids.split(",");
	Ext.Ajax.request({
		url : "<%=contextPath%>/rad/asyncQueryList.srq",
		params : {
			currentPage:"1",
			pageSize:"100",
			querySql:"select eps_name as name,eps.object_id||','||os.org_id||','||os.org_subjection_id as id from bgp_eps_code eps join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0' where eps.bsflag ='0' and eps.parent_object_id = '"+idss[0]+"' order by order_num"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
				
			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
			parentNode.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
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
			id : nodeData.id,
			text : nodeData.name,// 显示内容									
			leaf : false,								
			singleClickExpand:true,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	//叶子节点
	if(nodeData.is_leaf=="1"){
		treeNode.leaf = true;
		treeNode.singleClickExpand = false;
	}
	
	return treeNode;
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