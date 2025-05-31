<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
  String contextPath = request.getContextPath();
  String extPath = contextPath + "/js/extjs";
  UserToken user = OMSMVCUtil.getUserToken(request);
  String orgId = request.getParameter("orgId");
  if(orgId==null || orgId.equals("")) orgId = user.getCodeAffordOrgID();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var rootMenuId = "";
var rootMenuName = "";
/**������������*/
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "select t1.org_hr_id, t1.org_hr_short_name as org_name, t2.org_gms_id, t3.org_subjection_id as org_gms_sub_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2  on t1.org_hr_id=t2.org_hr_id join comm_org_subjection t3 on t3.org_id=t2.org_gms_id and t3.bsflag='0' where t2.org_gms_id='<%=orgId%>'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
rootMenuId = queryOrgRet.datas[0].org_hr_id + ',' + queryOrgRet.datas[0].org_gms_id + ',' + queryOrgRet.datas[0].org_gms_sub_id; 
rootMenuName = queryOrgRet.datas[0].org_name; 

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
default_image_url = "<%=contextPath%>/images/images/tree_12.png";

jcdpTreeCfg.rightClickEvent = false;
jcdpTreeCfg.moveEvent = true;
jcdpTreeCfg.dbClickEvent = false;

var treeCfg = {
  region : 'west',// �趨��ʾ����Ϊ����,ͣ�����������
  split : true,// �����϶���
  bodyStyle:"padding:2px",
  collapseMode : 'mini',// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
  width : 530,// ��ʼ���
  minSize : 210,// �϶���С���
  maxSize : 300,// �϶������
  collapsible : true,// ��������
  title : "ѡ����֯����",// ��ʾ����Ϊ��
  lines : true,// ���ֽڵ������
  autoScroll : true,// �Զ����ֹ�����
  frame : false,
  enableDD:true  
};
 
function clickNode(node){
  fkValue = node.id.split(',')[2];
  parent.mainFrame.refreshData(fkValue);
}
/**
  ��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {

	
  if(parentNode.firstChild.text!='loading') return;

  var info = parentNode.id.split(',');
  
  Ext.Ajax.request({
    url : "<%=contextPath%>"+appConfig.queryListAction,
    params : {
      currentPage:"1",
      pageSize:"10000",
      querySql:"select t1.org_hr_id, t1.org_hr_short_name as org_name, t2.org_gms_id, t3.org_subjection_id as org_gms_sub_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id=t2.org_hr_id join comm_org_subjection t3 on t3.org_id=t2.org_gms_id and t3.bsflag='0' where t1.org_hr_parent_id='" + info[0] + "'  order by  t1.order_num   "
    },
    method : 'Post',
    success : function(resp){
      var myData = eval("("+resp.responseText+")");
      var nodes = myData.datas;
      //addSubNodes(parentNode,nodes);
      
      for (var i = 0; i < nodes.length; i++) {
        
        var treeNode = getTreeNode(nodes[i]);
        appendEvent(treeNode);
        treeNode.on("beforemove",beforeMoveMenu);
        parentNode.appendChild(treeNode);

      }
      parentNode.firstChild.remove();// ɾ����ǰ�ڵ��һ�����ӽڵ�(loading�ڵ�)
      parentNode.ui.addClass("x-tree-node-collapsed");//������ʽΪ�ļ��У���ֹû���ӻ������ı���ʽ
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
      id : nodeData.org_hr_id+','+nodeData.org_gms_id+','+nodeData.org_gms_sub_id,
      text : nodeData.org_name,// ��ʾ����                  
      leaf : true,  
      icon : default_image_url,
      //allowDrop : false,
      singleClickExpand:true,
      children: [{// ���loading�ӽڵ�
        text : 'loading',
        icon : loadingIcon,
        leaf : true
      }]
  });  
  
  return treeNode;
}

function moveMenu(tree,node,oldParent,newParent,index){
  if(index<0){
    index=0;
  }
  var retuObj = jcdpCallService("CommonRemarkSrv", "moveTreeNodePosition","pkValue="+node.id.split(',')[0]+"&index="+index+"&oldParentId="+oldParent.id.split(',')[0]);
}
function beforeMoveMenu(tree,node,oldParent,newParent,index){

	if(oldParent.id!=newParent.id) return false;
	else return true;
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