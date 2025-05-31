<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	//String rootMenuId = request.getParameter("project_info_no");
	
	UserToken user =OMSMVCUtil.getUserToken(request);
	String osid = user.getOrgSubjectionId();
	if(osid.length()>7){
		osid = osid.substring(0, 7);
	}

	String orgSubId = "C105008";
	String orgId = "C6000000000009";
	if(user != null){
		//orgSubId = user.getSubOrgIDofAffordOrg();
		//orgId = user.getCodeAffordOrgID();
	}
	String epsId = "3667";
	String obsId = "565";
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
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var wtcOsid = "<%=osid%>";

var extPath = "<%=extPath%>";

/**公共变量定义*/
cruConfig.contextPath = "<%=contextPath%>";

var querySql = "select eps_name as name,object_id||','||eps.org_id||','||os.org_subjection_id as id from bgp_eps_code eps join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0' where eps.org_id = '<%=orgId%>' order by order_num";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);


var rootMenuName = queryOrgRet.datas[0].name; 
var rootMenuId = queryOrgRet.datas[0].id;


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
	enableDD:true	
};



//设置右键菜单
function setRightMenu()
{

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
	
	//var actionUrl = "<%=contextPath%>/tcg/moveTreeNodePosition.srq";
	//var submitStr = "tableName=p_auth_menu&pkName=menu_id&fkName=parent_menu_id&orderName=order_num&leafFlagName=is_leaf";
	//submitStr += "&pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id+"&newParentId="+newParent.id;
	//var ret = syncRequest('post',actionUrl,submitStr);
	//if(ret.returnCode!='0'){
	//	alert(ret.returnMsg);
	//	return;
	//}
	
}

/**
	获取parentNode的子节点
*/

function getSubNodes(parentNode) {
	
	if(parentNode.firstChild.text!='loading') return;
		
	var ids = parentNode.id;
	var idss = ids.split(",");

	var wtcQuerySql;

	if(idss[2]=="C105"){
		if(wtcOsid=="C105"){
			wtcQuerySql="select eps_name as name,eps.object_id||','||os.org_id||','||os.org_subjection_id as id from bgp_eps_code eps join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0' where eps.parent_object_id = '"+idss[0]+"' order by order_num";
		}else{
			wtcQuerySql="select c.eps_name as name,c.object_id||','||c.org_id||','||o.org_subjection_id as id from bgp_eps_code c join comm_org_subjection o on c.org_id=o.org_id  where o.org_subjection_id = '"+wtcOsid+"'";
		}
	}else{
		//var wtcQuerySql="select 1 as is_leaf,p.project_info_no as id,p.project_name as name from gp_task_project p join gp_task_project_dynamic dy on dy.bsflag = '0'  and dy.project_info_no = p.project_info_no and dy.org_subjection_id like '"+idss[2]+"%' where 1 = 1 and p.bsflag = '0' and p.project_type like '%' and p.is_main_project like '%' and p.project_status like '%' order by p.modifi_date desc";
		wtcQuerySql="select 1 as is_leaf,p.project_info_no as id,p.project_name as name,p.project_type as projecttype from gp_task_project p join gp_task_project_dynamic dy on dy.bsflag = '0'  and dy.project_info_no = p.project_info_no and dy.org_subjection_id like '"+idss[2]+"%25"+"' where 1 = 1 and p.bsflag = '0' and p.project_info_no='<%=user.getProjectInfoNo()%>'  order by p.modifi_date desc";
	
	}


	Ext.Ajax.request({
		url : "<%=contextPath%>/rad/asyncQueryList.srq",
		params : {
			currentPage:"1",
			pageSize:"100",
			//querySql:"select p.project_info_no,p.project_name from gp_task_project p join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.org_subjection_id like 'C105001002%' where 1 = 1 and p.bsflag = '0' and p.project_type like '%' and p.is_main_project like '%' and p.project_status like '%' order by p.modifi_date desc"
			//querySql:"select eps_name as name,eps.object_id||','||os.org_id||','||os.org_subjection_id as id from bgp_eps_code eps join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0' where eps.parent_object_id = '"+idss[0]+"' order by order_num"
			querySql:wtcQuerySql
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

function clickNode(selectedNode){
	if(selectedNode.leaf){
		var ids = selectedNode.id;
		var idss = ids.split(",");
		parent.mainRightframe.location.href = "<%=contextPath %>/rm/em/singleHuman/humanPlan/zh_planningList.jsp?projectInfoNo="+idss[0]+"&projectType="+idss[1]+"&projectName="+encodeURI(encodeURI(selectedNode.text));
	}
	
}

//加载右边页面
parent.mainRightframe.location.href = "<%=contextPath %>/rm/em/singleHuman/humanPlan/zh_planningList.jsp?projectInfoNo=<%=user.getProjectInfoNo()%>&projectType=<%=user.getProjectType()%>&projectName="+encodeURI(encodeURI("<%=user.getProjectName()%>"));


/**
	根据服务器查询到的nodeData构造ext树节点
*/
function getTreeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.id+","+nodeData.projecttype,
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
</html>