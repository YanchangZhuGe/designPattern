<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
	String parent_id = request.getParameter("parent_id");
    String paraid = request.getParameter("id");
	String userOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />

<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>页面</title>
</head>

<body style="background: #fff" onload="refreshData();">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">配件分类名称</td>
								<td class="ali_cdn_input"><input
									id="s_device_part_name" name="s_device_part_name"
									type="text" class="input_width" /></td>
								<td class="ali_cdn_name">生产厂家</td>
								<td class="ali_cdn_input"><input
									id="s_device_factoryname" name="s_device_factoryname"
									type="text" class="input_width" /></td>
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="查询"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="清除"></a></span></td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="zj"
									event="onclick='toAddPartPage()'" title="新增"></auth:ListButton>
								<auth:ListButton functionId="" css="xg"
									event="onclick='toModifyPartPage()'" title="修改"></auth:ListButton>
								<auth:ListButton functionId="" css="sc"
									event="onclick='toDelPartPage()'" title="删除"></auth:ListButton>
							</tr>
						</table>
					</td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box"  style="height:380px;">
			<table style="width: 98.5%"   border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					 <td class="bt_info_odd"
						exp="<input type='checkbox' name='rdo_entity_id' value='{id}' id='rdo_entity_id_{id}' onclick='chooseOne(this);' />">选择</td>
					<td class="bt_info_even" exp="{part_name}">配件分类名称</td>
					<td class="bt_info_even" exp="{item_name}">配件名称</td>
					<td class="bt_info_odd" exp="{orderno}">批次号</td>
					<td class="bt_info_odd" exp="{brand}">品牌</td>
					<td class="bt_info_odd" exp="{part_model}">规格</td>
					<td class="bt_info_odd" exp="{supplyname}">供应商名称</td>
					<td class="bt_info_odd" exp="{factoryname}">生产厂家</td>
					<td class="bt_info_odd" exp="{currency_name}">币种</td>
					<td class="bt_info_even" exp="{unit}">计量单位</td>
					<td class="bt_info_odd" exp="{perprice}">单价</td>
					<td class="bt_info_odd" exp="{usedesc}">已用标识</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
						width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text"
							name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img
						src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
<div class="lashen" id="line"></div>
	</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});
function submitInfo(){
	var length = 0;
	var selectedids = "";
	$("input[type='checkbox'][name='rdo_entity_id']").each(function(i){
		if(this.checked == true){
			if(length != 0){
				selectedids += "|"
			}
			selectedids += this.value;
			length = length+1;
		}
	});
	if(length == 0){
		alert("请选择记录!");
		return;
	}
	window.returnValue = selectedids;
	window.close();
};
$(document).ready(lashen);
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	function searchDevData(){
		var v_device_part_name = document.getElementById("s_device_part_name").value;
		var v_device_factoryname = document.getElementById("s_device_factoryname").value;
		refreshData(v_device_part_name, v_device_factoryname);
	}
	//点击树节点查询
	var parentId = '<%=paraid%>';
	//code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(v_device_part_name, v_device_factoryname){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		/*******  liug
		存在问题   递归有问题
		var tmp =  
			"SELECT I.*,e.id as eid,e.parent_id ,E.PART_NAME\n" +
			"  FROM GMS_DEVICE_PART_ITEM I, GMS_DEVICE_PART_TREE E\n" + 
			" WHERE I.TREE_ID = E.ID(+)\n" + 
			"   AND I.BSFLAG = '0'\n" + 
			"   AND E.BSFLAG = '0' ";
		var str = "SELECT * \n" + 
			"  FROM (SELECT T.*, CONNECT_BY_ISLEAF AS IS_LEAF, LEVEL AS NODE_LEVEL\n" + 
			"          FROM ("+tmp+") T\n" + 
			"         START WITH PARENT_ID = '"+parentId+"'\n" + 
			"        CONNECT BY PARENT_ID = PRIOR EID) A\n" + 
			" WHERE 1 = 1" ;
		*************/
		var tmp = "SELECT '"+parentId+"' AS TREEID from dual union \n" + 
		"SELECT ID AS TREEID \n" + 
		"  FROM (SELECT T.*, CONNECT_BY_ISLEAF AS IS_LEAF, LEVEL AS NODE_LEVEL\n" + 
		"          FROM GMS_DEVICE_PART_TREE T WHERE T.BSFLAG = '0' \n" + 
		"         START WITH PARENT_ID = '"+parentId+"'\n" + 
		"        CONNECT BY PARENT_ID = PRIOR ID) A\n";
		var str =  "SELECT I.*,DECODE(I.CURRERY, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_CURRENCY)%>) AS CURRENCY_NAME,e.id as eid,e.parent_id ,E.PART_NAME\n" +
			"  ,DECODE(I.useflag, 0, '未使用', 1, '已使用','未使用') AS usedesc " +
			"  FROM GMS_DEVICE_PART_ITEM I, GMS_DEVICE_PART_TREE E\n" + 
			" WHERE I.TREE_ID = E.ID(+)\n" + 
			"   AND I.BSFLAG = '0'\n" + 
			"   AND E.BSFLAG = '0' " + 
			"   AND I.TREE_ID IN ("+tmp+") ";
		if(v_device_part_name!=undefined && v_device_part_name!=''){//根据送修单号查询
			str += " AND part_name like '%"+v_device_part_name+"%' ";
		}
		if(v_device_factoryname!=undefined && v_device_factoryname!=''){//根据送修单名称查询
			str += " and factoryname like '%"+v_device_factoryname+"%' ";
		}
		//编写sql语句
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	function clearQueryText(){
		document.getElementById("s_device_part_name").value = "";
		document.getElementById("s_device_factoryname").value = "";
	}
	function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}
		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = "newTitleTable";
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable)-4;
		newTitleTable.style.top=y+"px";
		
		
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd";
			}else{
				tr.cells[i].className="bt_info_even";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}
		
		document.getElementById("table_box").onscroll = resetNewTitleTablePos;
	};
	function chooseOne(cb) {
		var obj = document.getElementsByName("rdo_entity_id");
		for (i = 0; i < obj.length; i++) {
			if (obj[i] != cb)
				obj[i].checked = false;
			else
				obj[i].checked = true;
		}
	};
	function toAddPartPage(){
		popWindow('<%=contextPath%>/rm/dm/devRepair/repairPartDetailNew.jsp?paraid=' + parentId);
	};
	function toModifyPartPage(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='rdo_entity_id']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}else if(length != 1 ){
			alert("请选择一条记录!");
			return;
		}
		//判断状态
		var querySql = 
			"SELECT T.useflag FROM GMS_DEVICE_PART_ITEM T\n" +
			"WHERE T.ID IN ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].useflag == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'已使用'的配件,不能修改!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		var id ;
		$("input[type='checkbox'][name='rdo_entity_id']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
		popWindow('<%=contextPath%>/rm/dm/devRepair/repairPartDetailModify.jsp?id='+id);
	};
	function toDelPartPage(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='rdo_entity_id']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//判断状态
		var querySql = 
			"SELECT T.useflag FROM GMS_DEVICE_PART_ITEM T\n" +
			"WHERE T.ID IN ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].useflag == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'已使用'的配件,不能删除!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update GMS_DEVICE_PART_ITEM set bsflag='1' where id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
</script>
</html>