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

<title>设备折旧费测算表</title>
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
			    		<td class="bt_info_odd"><INPUT id="checkbox" name="checkbox" onclick="checkAllNodes()" name=rdo_entity_id  type=checkbox></td>
			    	    <td  class="bt_info_even">序号</td>
			            <td class="bt_info_odd">设备及物资名称</td>
			            <td  class="bt_info_even">起运地点</td>
			            <td class="bt_info_odd">到达地点</td>
			            <td class="bt_info_even">吨位</td>		
			             <td class="bt_info_odd">数量</td>	
			             <td class="bt_info_even">运输里程(Km)</td>		
			             <td class="bt_info_odd">交还地点</td>	
			             <td class="bt_info_even">运输里程(Km)</td>		
			             <td class="bt_info_odd">运输单价(元/Km)</td>
			             <td class="bt_info_even">运费(元)</td>			
			        </tr>            
			   </table>
			</div>
			<div id="fenye_box" style="height: 0px"></div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">标签1</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">标签2</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">标签3</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">标签4</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">标签5</a></li>
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">

				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				</div>
		</div>
  </div>
</body>
<script type="text/javascript">

var selectedTagIndex = 0;
$(document).ready(function() {
	var oLine = $("#line")[0];
	oLine.onmousedown = function(e) {
		var disY = (e || event).clientY;
		oLine.top = oLine.offsetTop;
		document.onmousemove = function(e) {
			var iT = oLine.top + ((e || event).clientY - disY)-70;
			$("#table_box").css("height",iT);
			//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-27);
			setTabBoxHeight();
		};
		document.onmouseup = function() {
			document.onmousemove = null;
			document.onmouseup = null;
			oLine.releaseCapture && oLine.releaseCapture();
		};
		oLine.setCapture && oLine.setCapture();
		return false;
	};
}
);


function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});


cruConfig.contextPath =  "<%=contextPath%>";
var rowsCount=0;
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getTransportActualInfo&projectInfoNo=<%=projectInfoNo%>";

function refreshData(ids){
	var querySql = "";
	appConfig.queryListAction = queryListAction;
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
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
    		td.innerHTML ='<INPUT id="fy'+i+'checkbox" name="rdo_entity_id"  value='+datas[i].costTransportId+' type=checkbox>';
    		
    		var td = tr.insertCell();
			td.innerHTML = datas[i].rownum;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].transport_name;
			
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].start_loc;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].end_loc;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].tonnage;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].transport_count;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].start_meter;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].back_loc;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].back_meter;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].transport_unit;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].sum_transport;

		}
	}
	var tbObj=document.getElementById("editionList");
	changeTrBackground(tbObj);
}
 
function toAdd(){
	popWindow(cruConfig.contextPath+"/op/costActualManager/costTargetActualTransportEdit.upmd?pagerAction=edit2Add&projectInfoNo=<%=projectInfoNo%>");
}
function toModify(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
		popWindow(cruConfig.contextPath+"/op/costActualManager/costTargetActualTransportEdit.upmd?pagerAction=edit2Edit&id="+ids+"&projectInfoNo=<%=projectInfoNo%>");
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
	var sql = "update bgp_op_cost_tartet_transport t set t.bsflag='1' where t.cost_transport_id ='"+ids+"'";

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	syncRequest('Post',path,params);
	refreshData();
}

 
 dataInfoForSum={
		 sum_transport:"运输费用（元）"
 };
 

 function toShare(){
	popWindow(cruConfig.contextPath+"/op/costTargetShare/costTargetProjectDoShare.jsp?moneyInfo="+getCheckDataForSum());
 }
 
 
 function loadDataDetail(clickId){
	 
		
 }
</script>

</html>

