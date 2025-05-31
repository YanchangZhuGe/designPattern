<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="wf" prefix="wf"%> 
<%@ taglib uri="auth" prefix="auth"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);

	MsgElement data=resultMsg.getMsgElement("data");
	System.out.println(data.toMap());
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />

<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>

<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/prototype_1.5.1.1.js"></script>
<script type="text/javascript">

	var selectedTagIndex=0;
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


	function pass(){
			var form = document.getElementById("CheckForm");
			document.getElementById("isPass").value="pass";
			form.action = "<%=contextPath%>/bpm/common/toDoProcessInfo.srq";
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
			form.action = "<%=contextPath%>/bpm/common/toDoProcessInfo.srq";
			Ext.MessageBox.wait('请等待','处理中');
			form.submit();
		}
	}

	function getTab3(index) {  
		var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
		selectedTag.className ="";
		selectedTabBox.style.display="none";

		selectedTagIndex = index;
		
		selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
		selectedTag.className ="selectTag";
		selectedTabBox.style.display="block";
	}
	
	function save(){
		document.getElementById("isPass").value="pass";//or notPass
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/pm/op/bpm/toDoExamineInfo.srq";
		form.submit();
	}
</script>
<title>流程审核</title>
</head>
<body>
<iframe id="hidderIframe" name="hidderIframe" style="display: none"></iframe>
<form id="CheckForm" name="Form0" action="" method="post">
<div>
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批</a></li>
	    <li id="tag3_1"><a href="#" onclick="getTab3(1)">业务信息</a></li>
	  </ul>
</div>

<div id="tab_box_content0" class="tab_box_content">
			<wf:getProcessInfo />
</div>
<div id="tab_box_content1" class="tab_box_content" style="display:none;height: 600px" >
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" />
					</td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr align="right">
								<td>&nbsp;</td>
								<auth:ListButton functionId="F_OP_002" css="bc" event="onclick='save()'" title="JCDP_save"></auth:ListButton>
							</tr>
						</table>
					</td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" />
					</td>
				</tr>
			</table>
		</div>
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
					<td>
				<tr>
					<td class="inquire_item6">方案名称</td>
					<td class="inquire_form6"><input id="schemaName" name="" value="<%=data.getValue("schemaName")%>" class="input_width" type="text" />
					</td>
					<td class="inquire_item6">方案描述</td>
					<td class="inquire_form6"><input id="schemaDesc" name="" value="<%=data.getValue("schemaDesc")%>" class="input_width" type="text" />
					</td>
				</tr>
				</td>
				</tr>
			</table>

	</div>
			</form>
</body>
</html>