<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userId = user.getSubOrgIDofAffordOrg();
ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String codeId = "";
	codeId = request.getParameter("codeId");
	String bussId = request.getParameter("bussId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>无标题文档</title>
</head>

<body   onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
		 	    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td></td>
<!-- 		    <td><span class="tj"><a href="#" onclick="toAdd()" title="JCDP_btn_submit"></a></span></td>
			    <td><span class="sc"><a href="#" onclick="toDelete()" title="JCDP_btn_delete"></a></span></td>
-->			    <td><span><font id="target" color="red"></font></span></td>
			    <auth:ListButton id="addButton" functionId="" css="tj" event="onclick='toAdd()'" title="JCDP_btn_submit"></auth:ListButton>
			    <auth:ListButton id="deleteButton" functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{wz_name}">物资名称</td>
			      <td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
			      <td class="bt_info_even" exp="{wz_price}">参考单价</td>
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
		  <form name="form" id="form" method="post" action="">
		  	<input type="hidden" id="laborId" name="laborId" value=""></input>
		  	<div id="dialog-modal" title="正在执行" style="display:none;">
				请不要关闭
			</div>
		  </form>
</body>
<script type="text/javascript">
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }

function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

//$(document).ready(lashen);
</script>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "getMatLeafWTC";
	var userId = '<%=userId%>';
	var rootId = "8ad889f13759d014013759d3de520003";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var codeId = getQueryString("codeId");
	function refreshData(){
		cruConfig.submitStr ="bussId=<%=bussId%>&codeId="+codeId;
		queryData(1);
	}
	function toDelete(){
		 ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				del(ids);
				}
	}
	
	function del(ids) {
	    var tab=document.getElementById("queryRetTable");//最好给table指定个id
	   // for(var i=0;i<tab.rows.length;i++) {
	    	var obj=document.getElementsByName("rdo_entity_id");
	    	if(obj!=null ){
	    		for(var j =obj.length-1; j>=0 ;j--){
			    	var rdo = obj[j];
			    	if(rdo!=null && rdo.checked==true) {//你没说需求我就直接将第一行中有checkbox且为true的删除
			            tab.deleteRow(j+1);
		            }
		    	}
	    	}
	    tab=document.getElementById("queryRetTable");//最好给table指定个id
	    for(var i=1;i<tab.rows.length;i++){
		    var td = tab.rows[i];
		    var cell = td.cells[1];
		    cell.innerHTML = i;
	    }
	}
	
	  function toAdd(){ 
		  ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
//				 document.getElementById("addButton").outerHTML = "<A id=addButton title=提交 onclick= href=\"#\" event></A>";
//				 document.getElementById("deleteButton").outerHTML = "<A id=addButton title=删除 onclick= href=\"#\" event></A>";
//				 document.getElementById("target").innerHTML = "数据量过大,请等待……";	
				 document.getElementById("laborId").value = ids;
				 openMask();
				 document.getElementById("form").action="<%=contextPath%>/mat/multiproject/matLedger/saveMatLedgerWTC.srq?mat_menu_id=<%=bussId%>";
			  	 document.getElementById("form").submit();
			//	 window.location.href="<%=contextPath%>/mat/multiproject/matLedger/saveMatLedgerWTC.srq?mat_menu_id=<%=bussId%>&laborId="+ids;
				}
			
	 }  
	  
	  function openMask(){
			$( "#dialog-modal" ).dialog({
				height: 140,
				modal: true,
				draggable: false
			});
		}
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
       
--></script>

</html>

