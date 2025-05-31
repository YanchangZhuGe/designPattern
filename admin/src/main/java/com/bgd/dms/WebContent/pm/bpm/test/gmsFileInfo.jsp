<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);

	//处理审批信息

	Map map =null;
	List nodeList=null;
	String isFirstApplyNode="";
	boolean isFirst=true;
	boolean isCanPass=false;

    if(resultMsg.getValue("isFirstApplyNode")!=null){
		 isFirstApplyNode =resultMsg.getValue("isFirstApplyNode");
		 if(isFirstApplyNode.equals("false"))
		 {
		  isFirst=false;
		 }
	}
	if(resultMsg.getMsgElements("examineinInfo")!=null){
		List listAuditInfo=ActionUtils.listWithMap(resultMsg.getMsgElements("examineinInfo"));
		map=(Map)listAuditInfo.get(0);
	}
	if(resultMsg.getMsgElements("nodeList")!=null){
		 nodeList =ActionUtils.listWithMap(resultMsg.getMsgElements("nodeList"));
	}
	 if(resultMsg.getValue("isCanPass")!=null){
		 String pass=resultMsg.getValue("isCanPass");
		 if(pass.equals("true"))
		 {
		  isCanPass=true;
		 }
	}

	List<MsgElement> examineInfoList=resultMsg.getMsgElements("examineInfoList");


	//参数说明
	//tableName:发起流程实例的业务表名,大写
	String tableName=resultMsg.getValue("tableName");
	//tableKeyName：发起流程实例的业务表主键名称
	String tableKeyName=resultMsg.getValue("tableKeyName");

	//tableKeyValue：发起流程实例的业务表主键值
	String tableKeyValue=resultMsg.getValue("tableKeyValue");

	String taskinstId = request.getParameter("taskinstId");

	String banStr=resultMsg.getValue("banStr");

	String fileName =resultMsg.getValue("fileName");

	String ucmId =resultMsg.getValue("ucmId");
%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">




<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>

<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>


<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_page.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/prototype_1.5.1.1.js"></script>
<style type="text/css">
.input_width_date_short {
	width:65%;
}
</style>
<script type="text/javascript">

	cruConfig.contextPath = "<%= request.getContextPath()%>";

	function toQueryString(head,ob){
		var str="";
		for(var i in ob){
			str=str+(head+i+"="+ob[i]+"&");
		}
		return str;
	}
	function getSubmitStr(){
		var submitStr="";
		for(var i=0;i<deviceCount;i++){
			if(!isDelete(i)){
				if(document.getElementById("fy"+i+"checkbox").checked==true){
					for(j in deviceDetailObject){
						deviceDetailObject[j]=$('fy'+i+j).value;
					}
					submitStr+=toQueryString("fy"+i,deviceDetailObject);
				}
			}
		}
		return submitStr;
	}

	function sucess() {
		var form = document.getElementById("CheckForm");
		form.target="hidderIframe";
		form.action = "<%=contextPath%>/rm/dm/toSaveLeaderAuditEdit.srq?applyType=common&audit=true";
		form.submit();
		var editUrl = "/rm/dm/common/equipAuditCommon.jsp?a=1";
    	window.location='<%=contextPath%>'+editUrl;
	}


	var isFirst='<%=isFirst%>';
	function pass(){
			var form = document.getElementById("CheckForm");
			document.getElementById("isPass").value="pass";
			form.action = "<%=contextPath%>/pm/bpm/toDoExamineInfo.srq";
			Ext.MessageBox.wait('请等待','处理中');
			form.submit();
	}
	function notpass(){
		if(isFirst=="true"){
			document.getElementById("isPass").value="back1";
		}else{
			document.getElementById("isPass").value="back";
		}
		if(checkForm()){
			var form = document.getElementById("CheckForm");
			form.action = "<%=contextPath%>/pm/bpm/toDoExamineInfo.srq";
			Ext.MessageBox.wait('请等待','处理中');
			form.submit();
		}
	}

</script>
<title>文档审核</title>
</head>
<body>
<iframe id="hidderIframe" name="hidderIframe" style="display: none"></iframe>
<form id="CheckForm" name="Form0" action="" method="post">
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="even">
		<td class="rtCRUFdName">文件名称</td>
		<td class="rtCRUFdValue">
			<a href="<%=contextPath%>/p6/ucm/downloadDoc.srq?docId=<%=ucmId%>"><%=fileName %></a>
		</td>
		<td class="rtCRUFdName">&nbsp;</td>
		<td class="rtCRUFdValue">&nbsp;
		</td>
	</tr>
</table>
<table id="examine" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr>
		<td class="rtCRUFdName" colspan="1">&nbsp;审批意见：</td>
		<td class="rtCRUFdValue" colspan="3"><textarea name="examineInfo"></textarea></td>
	</tr>
	<tr>
		<td class="rtCRUFdName" colspan="1">&nbsp;下一步：</td>
		<td align="left" colspan="1" class="rtCRUFdValue">
		<input type="hidden" id="isPass" name="isPass" value="">
		 <input type="hidden" id="procinstID" name="procinstID" value="<%=map.get("procinstId")%>">
		 <input type="hidden" id="examineinstID" name="examineinstID" value="<%=map.get("examineinstId")%>">
		  <input type="hidden" id="tableName" name="tableName" value="<%=tableName%>">
		  <input type="hidden" id="tableKeyName" name="tableKeyName" value="<%=tableKeyName%>">
		  <input type="hidden" id="tableKeyValue" name="tableKeyValue" value="<%=tableKeyValue%>">
		  <input type="hidden" id="taskinstId" name="taskinstId" value="<%=taskinstId%>">
		<select name="nextNodeID" class="select_width">
			<%if(nodeList!=null){
				  for(int j=0;j<nodeList.size();j++){
				  	Map node=(Map)nodeList.get(j);
			%>
			<option value="<%=node.get("entityId") %>"><%=node.get("nodeName") %></option>
			<%		}
			}else{
				 %>
			<option value="999">无下级节点</option>
			<%} %>
		</select>
		</td>
		<td class="rtCRUFdName" colspan="1">&nbsp;</td>
		<td align="left" colspan="1" class="rtCRUFdValue">&nbsp;</td>
	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr  class="bt_info">
		<td class="tableHeader">业务环节</td>
		<td class="tableHeader">审批情况</td>
		<td class="tableHeader">审批意见</td>
		<td class="tableHeader">审批人</td>
		<td class="tableHeader">审批时间</td>
	</tr>
	<%
		for(int i=0;examineInfoList!=null&&i<examineInfoList.size();i++){
			Map mapExa = examineInfoList.get(i).toMap();
			String className1="";
			if (i % 2 == 0) {
				className1 = "even";
			} else {
				className1 = "odd";
			}
	%>
		<tr  class="<%=className1%>">
		<td ><%=mapExa.get("node_name")==null?" ":mapExa.get("node_name").toString() %>&nbsp;</td>
		<td ><%=mapExa.get("curstate")==null?" ":mapExa.get("curstate").toString() %>&nbsp;</td>
		<td ><%=mapExa.get("examine_info")==null?" ":mapExa.get("examine_info").toString() %>&nbsp;</td>
		<td ><%=mapExa.get("examine_user_name")==null?" ":mapExa.get("examine_user_name").toString() %>&nbsp;</td>
		<td ><%=mapExa.get("examine_end_date")==null?" ":mapExa.get("examine_end_date").toString() %>&nbsp;</td>
		</tr>
	<%
		}
	%>
</table>

<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		<td>
			<input name="Submit" type="button" class="iButton2" onClick="pass();" value="通过" />
			<input name="Submit" type="button" class="iButton2" onClick="notpass();" value="退回" />
			<input name="Submit" type="button" class="iButton2" onClick="window.history.back();" value="返回" />
		</td>
	</tr>
</table>
</form>
</body>
</html>