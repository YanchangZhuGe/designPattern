<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String codingSortId = "0100100014"; //甲方单位是0100100014
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css" />

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 

<title>无标题文档</title>

<!-- 甲方树 -->
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**公共变量定义*/
var rootMenuId = "<%=codingSortId%>";//"INIT_AUTH_ORG_012345678900000";

cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select * FROM comm_coding_sort WHERE coding_sort_id='"+rootMenuId+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].coding_sort_name; 

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
	title : "选择编码",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	if(node.id!=rootMenuId){
		var obj = window.dialogArguments;
		obj.fkValue = node.id;
		obj.value =node.parentNode.text+"/"+node.text;
		window.close();
	}
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;

	var parentCondition = " SUPERIOR_CODE_ID ";
	if (rootMenuId==parentNode.id) {
		parentCondition += "in ('0','1')";
	}else{
		parentCondition += "='"+parentNode.id+"'";
	}
	
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"Select t.coding_code_id,t.coding_name,case (select count(ccsd.coding_code_id) from comm_coding_sort_detail ccsd where ccsd.SUPERIOR_CODE_ID=t.coding_code_id and ccsd.bsflag='0') when 0 then '1' else '0' end as is_leaf FROM comm_coding_sort_detail t WHERE t.coding_sort_id='"+rootMenuId+"' and t.bsflag='0' and "+parentCondition+" order by t.CODING_SHOW_ID"
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
			id : nodeData.coding_code_id,
			text : nodeData.coding_name,// 显示内容									
			leaf : false,								
			singleClickExpand:true,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	if(nodeData.is_leaf=="1"){//叶子节点
		treeNode.leaf = true;
		treeNode.singleClickExpand = false;
	}
	
	return treeNode;
}
</script> 

</head>
<body>
			<div id="new_table_box_bg" style="overflow:auto;width:560px">
				<div id="tag-container_3">
				  <ul id="tags" class="tags">
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">甲方单位树</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(1)">甲方单位查询</a></li>
				  </ul>
				</div>
				<div id="tab_box" class="tab_box" style="overflow: hidden;">
					<div id="tab_box_content0" class = "">
						<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
							<tr>
								<td align="left">
									<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
								</td>
							</tr>
						</table>
					</div>
					<div id="tab_box_content1" style="width:99%; border:1px #aebccb solid;display:none;">
									
								 <div id="list_table">
									<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
									    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
									    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
									    <td class="ali_cdn_name">甲方单位:</td>
									    <td class="ali_cdn_input">
										    <input id="manageOrgName" name="manageOrgName" type="text" class="input_width" />
									    </td>
									    <td class="ali_query">
										    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
									    </td>
									    <td class="ali_query">
										    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
									    </td>
									    <td>&nbsp;</td>
									  </tr>
									  
									</table>
									</td>
									    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
									  </tr>
									</table>
									</div>
									<div id="table_box">
									  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
									    <tr>
									      <td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{orgId}:{orgName}' id='rdo_entity_id_{orgId}'/>" >选择</td>
									      <td class="bt_info_odd" autoOrder="1">序号</td>
									      <td class="bt_info_even" exp="{orgName}" >甲方名称</td>
									      <td class="bt_info_odd" exp="{parentOrgName}" >上级</td>
									    </tr>
									  </table>
									</div>
									<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
									  <tr>
									    <td align="right">第1/1页，共0条记录</td>
									    <td width="10">&nbsp;</td>
									    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
									    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
									    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
									    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
									    <td width="50">到 
									      <label>
									        <input type="text" name="textfield" id="textfield" style="width:20px;" />
									      </label></td>
									    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
									  </tr>
									</table>
									</div>
								  </div>
									
					</div>
				</div>
			</div>
	

	
</body>
<script type="text/javascript">
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ProjectSrv";
	cruConfig.queryOp = "getManageOrgName";
	
	// 查询
	function refreshData(q_manageOrgName){
		debugger;
		document.getElementById("manageOrgName").value = q_manageOrgName;
		cruConfig.submitStr = "manageOrgName="+q_manageOrgName;
		queryData(1);	
	}
	
	refreshData("");

	// 简单查询
	function simpleRefreshData(){
		var q_manageOrgName = document.getElementById("manageOrgName").value;
		refreshData(q_manageOrgName);
	}
	
	function dbclickRow(ids){
		var org_id = ids.split(":")[0];
		var org_name = ids.split(":")[1];
		var obj = window.dialogArguments;
		obj.fkValue = org_id;
		obj.value = org_name;
		window.close();
	}
	
	function clearQueryText(){
		document.getElementById("manageOrgName").value = "";
	}

</script>
</html>