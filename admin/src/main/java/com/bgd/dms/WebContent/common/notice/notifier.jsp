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

/**������������*/
var rootMenuId = "root,3.2";
var rootMenuName = "������ϵ��"; 
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
	region : 'west',// �趨��ʾ����Ϊ����,ͣ�����������
	split : true,// �����϶���
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
	width : 530,// ��ʼ���
	minSize : 210,// �϶���С���
	maxSize : 300,// �϶������
	collapsible : true,// ��������
	title : "������ϵ��ά��",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true	
};

function dbClickNode(node){

}


/**
	��ȡparentNode���ӽڵ�
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
			parentNode.firstChild.remove();// ɾ����ǰ�ڵ��һ�����ӽڵ�(loading�ڵ�)	
			if(parentNode.id.split(",")[1]=="3.2"){
				parentNode.ui.addClass("x-tree-node-collapsed");
			}
		},
		failure : function(){// ʧ��
							}			
	});//eof Ext.Ajax.request
}


/**
	���ݷ�������ѯ����nodeData����ext���ڵ�
*/
function getTreeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.entity_id+','+nodeData.object_type+','+nodeData.object_id,
			text : nodeData.object_name,// ��ʾ����									
			leaf : false,								
			singleClickExpand:true,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	if(nodeData.object_type=="3.1" || nodeData.object_type=="3.3"){//Ҷ�ӽڵ�
		treeNode.leaf = true;
		treeNode.singleClickExpand = false;
	}

	return treeNode;
}

var nodeInfo = rootMenuId.split(",");
//selectedNode = rctTree.getRootNode();
/**
����
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
  				alert("����ʧ��");
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
		alert("���ڵ㲻���޸�");
		return;
	}
	document.getElementById("iframe1").src="editNotifierGroup.upmd?pagerAction=edit2Edit&lineRange=1&noCloseButton=true&id="+nodeInfo[0];
}

function deleteNotifier(){
	if(selectedNode==undefined){
		selectedNode=rctTree.getRootNode();
	}
	
	if(nodeInfo[0]=="root"){
		alert("���ڵ㲻��ɾ��");
		return;
	}
	var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	var submitStr = 'JCDP_TABLE_NAME=ic_user_favorite_dms&JCDP_TABLE_ID=&entity_id='+nodeInfo[0]+'&bsflag=1';
	var retObject = syncRequest('Post',path,submitStr);
	if (retObject.returnCode != "0") alert("ɾ����ϵ��ʧ��!");
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
						<input type="button" name="button1" value="�����ϵ��" onclick="selectNotifier()" class="iButton2"/>
						<input type="button" name="button1" value="����ļ���" onclick="addNotifierGroup('3.2')" class="iButton2"/>
						<input type="button" name="button1" value="�����ϵ����" onclick="addNotifierGroup('3.3')" class="iButton2" style="display:none"/>
						<input type="button" name="button1" value="�޸�" onclick="editNotifierGroup()" class="iButton2"/>						
						<input type="button" name="button1" value="ɾ��" onclick="deleteNotifier()" class="iButton2"/>
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