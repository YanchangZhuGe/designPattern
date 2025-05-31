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
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo= user.getProjectInfoNo();
	boolean proc_status = OPCommonUtil.getProcessStatus("BGP_OP_TARGET_PROJECT_BASIC","tartget_basic_id","5110000004100000009",projectInfoNo);
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

<title>人员动迁费测算</title>
</head>

<body style="background:#fff" onload="refreshData()">
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td>&nbsp;</td>
			  <td align="right" style="padding-right: 20px;"><font color="red"><span id="sum_value"></span></font></td>
			  <%if(proc_status){ %>
			   <auth:ListButton functionId="OP_TARGET_PE_EDIT" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			   <auth:ListButton functionId="OP_TARGET_PE_EDIT" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			   <auth:ListButton functionId="OP_TARGET_PE_EDIT" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			   <%} %>
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
			            <td class="bt_info_odd">人数</td>
			            <td class="bt_info_even">班组</td>
			            <td  class="bt_info_odd">起始地点</td>
			            <td class="bt_info_even">到达地点</td>
			             <td class="bt_info_odd">单价（元）</td>		
			             <td class="bt_info_even">其他费用（元）</td>	
			             <td class="bt_info_odd" onclick="getSum()">总计(元)</td>			
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
  </div>
</body>
<script type="text/javascript">

var selectedTagIndex = 0;
function setTabBoxHeight(){
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
}

cruConfig.contextPath =  "<%=contextPath%>";
var rowsCount=0;
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getDeviceHShareInfo&projectInfoNo=<%=projectInfoNo%>";

function refreshData(ids){
	if(ids==undefined||ids==""||ids==null) ids=cruConfig.currentPage;
	if(ids==0)ids=1;
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
            
            var td = tr.insertCell(0);
    		td.innerHTML ='<input type="hidden" id="fy'+i+'sum_transport" name="fy'+i+'sum_transport" value="'+datas[i].sumTransport+'" class="input_width"/>'+
    		'<INPUT id="fy'+i+'checkbox" name="rdo_entity_id"  value='+datas[i].costHumanId+' type=checkbox>';
    		
    		var td = tr.insertCell(1);
			td.innerHTML = datas[i].rownum;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].personNum;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].applyTeam;
			
			var td = tr.insertCell(4);
			td.innerHTML = datas[i].startLoc;
			
			var td = tr.insertCell(5);
			td.innerHTML = datas[i].endLoc;
			
			var td = tr.insertCell(6);
			td.innerHTML = datas[i].personMoney;
			
			var td = tr.insertCell(7);
			td.innerHTML = datas[i].money;
			
			var td = tr.insertCell(8);
			td.innerHTML = datas[i].sumTransport;

		}
	}
	var tbObj=document.getElementById("editionList");
	changeTrBackground(tbObj);
}
 
function toAdd(){
	popWindow(cruConfig.contextPath+"/op/costTargetShare/costTargetShareDeviceHEdit.upmd?pagerAction=edit2Add&projectInfoNo=<%=projectInfoNo%>");
}
function toModify(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
		popWindow(cruConfig.contextPath+"/op/costTargetShare/costTargetShareDeviceHEdit.upmd?pagerAction=edit2Edit&id="+ids+"&projectInfoNo=<%=projectInfoNo%>");
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
	ids = ids.replace(/\,/g,"','");
	var sql = "update BGP_OP_TARGET_DEVICE_HUM t set t.bsflag='1' where t.COST_HUMAN_ID in('"+ids+"')";

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
  function getSum(){
		var project_info_no = '<%=projectInfoNo%>';
		var querySql = "select sum(nvl(to_char(nvl(t.person_num,0)*nvl(t.person_money,0)-(-nvl(other_money,0)),'9999999999999999.00'),0)) sum_value"+
			" from bgp_op_target_device_hum t where t.project_info_no='<%=projectInfoNo%>' and t.if_change ='0' and t.bsflag='0'";
		var retObj = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
		if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
			debugger;
			var sum_value = retObj.datas[0].sum_value;
			document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
		}	
	}
</script>

</html>

