<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String type=request.getParameter("type");//����֤��Ҫ��ӵ������� ���������ж�
%>
<html>
<head><meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"> 
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var rootMenuId = "";
var rootMenuName = "";
/**������������*/
cruConfig.contextPath = "<%=contextPath%>";
rootMenuId = ","; 
rootMenuName = "�豸����"; 

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
	collapsible : false,// ��������
	title : "��ѡ��",// ��ʾ����Ϊ��
	lines : true,// ���ֽڵ������
	autoScroll : true,// �Զ����ֹ�����
	frame : false,
	enableDD:true,
	tbar : new Ext.Toolbar({
		items:[
			{
				xtype:'button',
				text:'ȷ��',
				handler:button_ok
			}
			,
			{
				xtype:'button',
				text:'ȡ��',
				handler:button_cancel
			}
		]
	})
};

function button_ok(){
var nodes = rctTree.getChecked();
    
    var checkIds = "";// ���ѡ�еĽڵ��id
    var checkTexts = "";// ���ѡ�еĽڵ��text
    var qita=0;//ѡ���������͸���
    for (var i = 0; i < nodes.length; i++) {   
        var node = nodes[i];
        
        var id=node.id.split(',')[0];
        var name=node.text.split(',')[0];
        if(name=='����'){
        	qita=qita+1;
        }
        checkIds += "," + node.id.split(',')[0];
       var fathernode= rctTree.getNodeById(id.substr(0,id.length-3));	
       	checkTexts += "," + fathernode.text;
    } 
   
    checkIds = checkIds=="" ? "" : checkIds.substr(1);
    checkTexts = checkTexts=="" ? "" : checkTexts.substr(1);
	
    var obj = window.dialogArguments;
    if(qita>1){
    	alert('��������ֻ��ѡ��һ������');
    	return ;
    } 
	obj.fkValue = checkIds;
	obj.value = filterRepeatStr(checkTexts);
    
	//alert(filterRepeatStr(checkTexts));
	window.close();
}
function button_cancel(){
	var obj = window.dialogArguments;
	obj.fkValue = "";
	obj.value = "";
	window.close();
}
  //ȥ���ַ����ظ��ֶ�
    function filterRepeatStr(str){ 
		var ar2 = str.split(","); 
		var array = new Array(); 
		var j=0; 
		for(var i=0;i<ar2.length;i++){ 
		if((array == "" || array.toString().match(new RegExp(ar2[i],"g")) == null)&&ar2[i]!=""){ 
			array[j] =ar2[i]; 
			array.sort(); 
			j++; 
			} 
		} 
		return array.toString(); 
	}
function dbClickNode(node){
	
}


/**
	��ȡparentNode���ӽڵ�
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	var info = parentNode.id.split(',');
	var obj = window.dialogArguments;
	var querySql="select t1.dev_ci_code id, t1.dev_ci_name name,t1.dev_ci_model model from gms_device_codeinfo t1 where t1.dev_ct_code='" + info[1] + "'";
	if(typeof obj.checkedCodes!="undefined"){
		//alert(obj.checkedCodes);
		querySql+=" and t1.dev_ci_code not in ("+obj.checkedCodes+")";
	}
	querySql+="  order by t1.type_seq"
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:querySql
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getEqInfoNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
			}
			getSubOrgNodes(parentNode,1);
		}
	});
}

// �����¼��ڵ�
function getSubOrgNodes(parentNode,dbClickFlag){
	var info = parentNode.id.split(',');
	var querysql;
	if(info == ','){
		if('CZZ'=='<%=type%>'){//�ж��Ƿ��ǲ���֤ѡ�� ѡ�����Ͷ����������
		querysql="select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,t1.father_id code,t1.device_code,t1.device_type from dms_device_tree_opcard t1 where t1.father_id  is null and t1.dev_tree_id in('D002','D003','D004','D005','D001') order by t1.code_order ";
		}else{
		querysql="select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,t1.father_id code,t1.device_code,t1.device_type from dms_device_tree_opcard t1 where t1.father_id  is null and t1.dev_tree_id in('D002','D003','D004','D006') order by t1.code_order ";
		
		}
	}else{
		querysql="select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,t1.father_id code,t1.device_code,t1.device_type from dms_device_tree_opcard t1 where t1.father_id='"+info[0]+"' order by t1.code_order ";
	}
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:querysql
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			//addSubNodes(parentNode,nodes);
			
			for (var i = 0; i < nodes.length; i++) {
				
				var treeNode = getEqTypeNode(nodes[i]);
				appendEvent(treeNode);
				if(dbClickFlag==1){
					treeNode.removeListener('dblclick',dbClickNode);
				}
				
			 
				
			 
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
	�����豸���ͽڵ�
*/
function getEqTypeNode(nodeData){
	var treeNode;
	if(nodeData.id.length!=10){
		  
	  treeNode = new Ext.tree.AsyncTreeNode({
			//id : nodeData.id + "," + nodeData.code,
			id : nodeData.id,
			text : nodeData.name,// ��ʾ����							
			leaf : false,	
			singleClickExpand:true,
			children: [{// ���loading�ӽڵ�
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	}else {
		  treeNode = new Ext.tree.AsyncTreeNode({
				//id : nodeData.id + "," + nodeData.code,
				id : nodeData.id,
				text : nodeData.name,// ��ʾ����							
				leaf : false,	
				checked : false,
				singleClickExpand:true,
				children: [{// ���loading�ӽڵ�
					text : 'loading',
					icon : loadingIcon,
					leaf : true
				}]
		});	
		
	}
	return treeNode;
}

/**
�����豸��Ϣ�ڵ�
*/
function getEqInfoNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.id,
			text : nodeData.name+"("+nodeData.model+")",// ��ʾ����
			checked : false,						
			leaf : true,								
			singleClickExpand : false
	});	
	
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