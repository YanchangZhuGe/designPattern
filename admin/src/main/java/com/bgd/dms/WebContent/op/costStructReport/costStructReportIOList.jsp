<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String projectInfoNo= user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<title>物探处支出收入录入</title>
</head>

<body style="background:#fff" onload="refreshData()">
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td>&nbsp;</td>
			   <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			   <auth:ListButton css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			   <auth:ListButton css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table id="editionList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr class="bt_info">
			    		<td width="5%" class="bt_info_odd"><INPUT id="checkbox" name="checkbox" onclick="checkAllNodes()" name=rdo_entity_id  type=checkbox></td>
			    	    <td width="5%"   class="bt_info_even">序号</td>
			            <td width="15%"  class="bt_info_odd">名称</td>
			            <td width="5%"  class="bt_info_even">类型</td>
			            <td width="15%"   class="bt_info_odd">金额</td>
			            <td width="40%"  class="bt_info_even">说明</td>
			            <td width="15%"  class="bt_info_odd">时间</td>
			            
			        </tr>            
			   </table>
			</div>
			<div id="fenye_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			 	<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		</div>
  </div>
</body>
<script type="text/javascript">

$(document).ready(readyForSetHeight);

frameSize();

$(document).ready(lashen);


cruConfig.contextPath =  "<%=contextPath%>";
var rowsCount=0;
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getReportInoutInfo";

function refreshData(ids){
	if(ids==undefined||ids==""||ids==null) ids=cruConfig.currentPage;
	var submitStr = "currentPage="+ids+"&pageSize="+cruConfig.pageSize;
	
	appConfig.queryListAction = queryListAction;
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,submitStr);
	
	renderNaviTable(tbObj,queryRet);
	
	var datas = queryRet.datas;
	
	deleteTableTr("editionList");
	if(datas != null){
		rowsCount=datas.length;
		for (var i = 0; i< queryRet.datas.length; i++) {
			var tr = document.getElementById("editionList").insertRow();		
             	if(i % 2 == 1){  
             		tr.className = "even";
			}else{ 
				tr.className = "odd";
			}
            
            var td = tr.insertCell();
    		td.innerHTML ='<input type="hidden" id="fy'+i+'sum_price" name="fy'+i+'sum_price" value="'+datas[i].sumPrice+'" class="input_width"/>'+
    		'<INPUT id="fy'+i+'checkbox" name="rdo_entity_id"  value='+datas[i].inoutInfoId+' type=checkbox>';
    		
    		var td = tr.insertCell();
			td.innerHTML = datas[i].rownum;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].costName;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].costTypeName;
			
		
			var td = tr.insertCell();
			td.innerHTML = datas[i].costMoney;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].costDesc;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].costDate;
			
			
			
		}
	}
	var tbObj=document.getElementById("editionList");
	changeTrBackground(tbObj);
}
 
function toAdd(){
	popWindow(cruConfig.contextPath+"/op/costStructReport/costStructReportIOEdit.upmd?pagerAction=edit2Add&projectInfoNo=<%=projectInfoNo%>");
}
function toModify(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
		popWindow(cruConfig.contextPath+"/op/costStructReport/costStructReportIOEdit.upmd?pagerAction=edit2Edit&id="+ids+"&projectInfoNo=<%=projectInfoNo%>");
}
function toDelete(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	if (!window.confirm("确认要删除吗?")) {
		return;
	}
	var sql = "update BGP_OP_REPORT_INOUT_INFO t set t.bsflag='1' where t.INOUT_INFO_ID ='"+ids+"'";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	refreshData();
}

 
 dataInfoForSum={
		 sum_price:"合计租赁费用（元）"
 };

 function toShare(){
	popWindow(cruConfig.contextPath+"/op/costTargetShare/costTargetProjectDoShare.jsp?moneyInfo="+getCheckDataForSum());
 }
 
 function loadDataDetail(clickId){
	 //载入文档信息
	document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+clickId;
	//载入备注信息
	document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+clickId;
	//载入分类吗信息
	document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=4&relationId="+clickId
 }
 
 
 function importDatas(){
	popWindow(cruConfig.contextPath+"/common/ExcelImportFile.jsp?modelName=OpTargetDeviceMataxi&redirectUrl=/common/close_page.jsp");
}
</script>

</html>

