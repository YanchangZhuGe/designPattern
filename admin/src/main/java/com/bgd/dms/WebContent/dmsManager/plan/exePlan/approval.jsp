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

	String procinstId=(String)map.get("procinstId");
	//System.out.println("*******************"+contextPath + "/BPM/viewProcinst.jsp?procinstId='"+procinstId+"'");
	//参数说明
	String businessId=resultMsg.getValue("businessId");
	String taskinstId = request.getParameter("taskinstId");
	String nodeLink=resultMsg.getValue("nodeLink");
	//获取nodeLink的参数
	String linkParaStr=nodeLink.substring(nodeLink.indexOf('?'));
	System.out.println("____________--------------------------------_____________"+businessId);

	//add by bianshen
	
	String businessType=resultMsg.getValue("businessType");
	
	//判断审批是否结束
	String isDone = request.getParameter("isDone");
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />

<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>

<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/prototype_1.5.1.1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript">
var businessType = '<%=businessType%>';
var allappType="";
var allappID='<%=businessId%>';
if(allappID!=null&&allappID!=" "){
	var retObjDG = jcdpCallService("DevCommInfoSrv", "getDGallappType", "device_allapp_id="+allappID);
	if(retObjDG!=null){
		if(retObjDG.allappObj!=null){
			allappType=retObjDG.allappObj.allapp_type
		}
	}
}

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


	var isFirst='<%=isFirst%>';
	

	function pass(){
			var form = document.getElementById("CheckForm");
			document.getElementById("isPass").value="pass";
			form.action = "<%=contextPath%>/bpm/common/toDoProcessInfo.srq";
			//Ext.MessageBox.wait('请等待','处理中');
			if(confirm("是否确定审批通过?")){
				form.submit();	 
				window.close();
				window.opener.location.reload();	
			} 
	}
	function closeHere(){
		window.close();
	}
	function notpass(){
		if(isFirst=="true"){
			document.getElementById("isPass").value="back1";
		}else{
			document.getElementById("isPass").value="back";
		}
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/bpm/common/toDoProcessInfo.srq";
		//Ext.MessageBox.wait('请等待','处理中');
		if(confirm("是否确定审批不通过?")){
			form.submit();
			window.close();

			window.opener.location.reload();
		
		} 
	}

	function getTab3(index) {  
		var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex);
		selectedTag.className ="";
		selectedTabBox.style.display="none";

		selectedTagIndex = index;
		
		selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex);
		selectedTag.className ="selectTag";
		selectedTabBox.style.display="block";
		if(index==2){
			document.getElementById("businessIframe1").contentWindow.getTab(0);
		}
	}
	

	function frameSize(){
		$("#tab_div_1 .tab_box_content").css("height",$(window).height()-$("#tab_div_0").height()-3);
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	});
</script>
<title>流程审核</title>
</head>
<body>
<iframe id="hidderIframe" name="hidderIframe" style="display: none"></iframe>

<div id="tab_div_0">
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批</a></li>
	    <li id="tag3_1"><a href="#" onclick="getTab3(1)">需求报表</a></li>
	    <li id="tag3_2"><a href="#" onclick="getTab3(2)">辅助资料</a></li>
	    <li id="tag3_3"><a href="#" onclick="getTab3(3)">流程轨迹</a></li>
	  </ul>
</div>
<div id="tab_div_1">
<div id="tab_box_content0" class="tab_box_content">
		<form id="CheckForm" name="Form0" action="" method="post" target="hidderIframe">
			<input type="hidden" name="businessType" id="businessType" value="<%=businessType%>" />
			<wf:getProcessInfo />
		<%
			if(isDone == null || !isDone.equals("1")){
		%>
			<div id="oper_div">
				<span class='pass_btn'><a href='#' onclick='pass()' ></a></span>
				<span class='nopass_btn'><a href='#' onclick='notpass()' ></a></span>
			</div>
		<%
			}
		%>
		</form>
</div>
<div id="tab_box_content1" class="tab_box_content" style="display:none;">
	<iframe id="businessIframe0" name="businessIframe0" width="100%" height="100%" style="display: block" src='<%=contextPath%>/dmsManager/plan/exePlan/require_report_approval.jsp<%=linkParaStr%>&isDone=<%=isDone%>'> </iframe>
</div>
<div id="tab_box_content2" class="tab_box_content" style="display:none;">
	<iframe id="businessIframe1" name="businessIframe1" width="100%" height="100%" style="display: block" src='<%=contextPath%>/dmsManager/plan/exePlan/supp_data_approval.jsp<%=linkParaStr%>'> </iframe>
</div>
<div id="tab_box_content3" class="tab_box_content" style="display:none;">
	<iframe id="processIframe" name="processIframe" width="100%" height="100%" style="display: block" src='<%=contextPath + "/BPM/viewProcinst.jsp?procinstId="+procinstId%>'> </iframe>
</div>
</div>
</body>
</html>