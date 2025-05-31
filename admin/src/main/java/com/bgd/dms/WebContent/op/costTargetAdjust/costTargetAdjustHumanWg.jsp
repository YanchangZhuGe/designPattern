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

<title>人员投入表</title>
</head>

<body style="background:#fff" onload="loadDataDetail()">
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td>&nbsp;</td>
			    <auth:ListButton css="bc" event="onclick='saveDatas()'" title="JCDP_save"></auth:ListButton>
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
			            <td class="bt_info_odd">姓名</td>
			            <td  class="bt_info_even">班组</td>
			            <td class="bt_info_odd">类型</td>		
			            <td  class="bt_info_even">预计进队时间</td>
			            <td class="bt_info_odd">预计离开时间</td>
			            <td  class="bt_info_even">预计使用时间</td>
			            <td class="bt_info_odd">平均工资</td>
			            <td class="bt_info_odd">该项目人员投入成本(元)</td>
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
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
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
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getHumanShareInfo&projectInfoNo=<%=projectInfoNo%>";

function loadDataDetail(ids){
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
             	
            var td = tr.insertCell(0);
    		td.innerHTML = '<INPUT id="fy'+i+'checkbox" name="fy'+i+'checkbox"  value='+datas[i].costDeviceId+' type=checkbox>'+
    		'<input type="hidden" id="fy'+i+'cost_human_id" name="fy'+i+'cost_human_id" value="'+datas[i].costHumanId+'" class="input_width"/>'+
    		'<input type="hidden" id="fy'+i+'sum_wage" name="fy'+i+'sum_wage" value="'+datas[i].sumWage+'" class="input_width"/>';
    		
    		var td = tr.insertCell(1);
			td.innerHTML = datas[i].rownum;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].employeeName;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].teamName;
			
			var td = tr.insertCell(4);
			td.innerHTML = datas[i].employeeGzName;

			var td = tr.insertCell(5);
			td.innerHTML = datas[i].planStartDate;

			var td = tr.insertCell(6);
			td.innerHTML = datas[i].planEndDate;
			
			var td = tr.insertCell(7);
			td.innerHTML = datas[i].dateNum;
			
			var td = tr.insertCell(8);
			td.innerHTML =  '<input type="text" id="fy'+i+'actual_wage" name="fy'+i+'actual_wage" value="'+datas[i].actualWage+'" class="input_width"/>' ;
			
			var td = tr.insertCell(9);
			td.innerHTML = datas[i].sumWage;
			
		}
	}	
}
 dataInfo={
		 actual_wage:"",
		 cost_human_id:""
 };
 
 dataInfoForSum={
		 sum_wage:"该项目人员投入成本(元)"
 };
 
 function saveDatas(){
	 var submitStr=getCheckTrInfo();
	 var retObj = jcdpCallService("OPCostSrv", "saveHumanShareInfo", submitStr);
	 if(retObj.success=="true"){
		 alert("保存成功");
	 }
	 loadDataDetail();
 }
 function toShare(){
	popWindow(cruConfig.contextPath+"/op/costTargetShare/costTargetProjectDoShare.jsp?moneyInfo="+getCheckDataForSum());
 }
</script>

</html>

