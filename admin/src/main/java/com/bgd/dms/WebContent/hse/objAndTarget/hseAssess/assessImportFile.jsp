<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	if(respMsg != null){
		message = respMsg.getValue("message");
	}
	String projectId ="";
	if(respMsg != null){
		projectId = request.getParameter("project");
	}
		
 
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>

<style type="text/css">
.tab_line_height {
	width:100%;
	line-height:30px;
	height:30px;
	color:#000;
}
.tab_line_height td {
	line-height:30px;
	height:30px;
	white-space:nowrap;
	word-break:keep-all;
}


.inquire_item6 {
	text-align:right;
	width:10%;
	padding:0 5px;
}
.inquire_form6 {
	text-align:left;
	width:23.3%;
	padding:0 5px;
}
.input_width {
	width:80%;
	height:20px;
	line-height:20px;
	border:1px solid #a4b2c0;
	float:left;
}
</style>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
var message = "<%=message%>";
debugger;
if(message != "" && message != 'null'){
	if(message=="导入成功!"){ 
		alert(message);
		top.frames('list').refreshData();
		newClose();
	}else{
		alert(message);		
	}
	
}
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
 		debugger;
		if(filename == ""){
			alert("请选择上传附件!");
			return;
		}

		var project='<%=request.getParameter("project")%>';
		if(check(filename)){
			document.getElementById("confirmButton").disabled="disabled";	
			document.getElementById("fileForm").action = "<%=contextPath%>/hse/assess/importExcelMessage.srq?project="+project;
			document.getElementById("fileForm").submit();
		}
			
	}
	function alertError(str){		
		alert(str);
	}

	function check(filename){
		var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
		type=type.toUpperCase();
		if(type=="XLS" || type=="XLSX"){
		   return true;
		}
		else{
		   alert("上传类型有误，请上传EXCLE文件！");
		   return false;
		}
	}
	
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanLabor/download.jsp?path=hse/objAndTarget/hseAssess/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	function queryOrg(id){
		var org_subjection_id = "";
		if(id!=null&&id!=""){
			var checkSql="select e.employee_id,os.org_subjection_id from comm_human_employee e join comm_org_subjection os on e.org_id=os.org_id and os.bsflag='0' where e.bsflag='0' and e.employee_id='"+id+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;	
			if(datas!=null&&datas!=""){
				var org_subjection_id = datas[0].org_subjection_id;	
			}
		}
		retObj = jcdpCallService("HseSrv", "queryOrg", "org_subjection_id="+org_subjection_id);
		if(retObj.flag=="true"){
			var len = retObj.list.length;
			if(len>0){
				document.getElementById("second_org").value=retObj.list[0].orgSubId;
				document.getElementById("second_org2").value=retObj.list[0].orgAbbreviation;
			}
			if(len>1){
				document.getElementById("third_org").value=retObj.list[1].orgSubId;
				document.getElementById("third_org2").value=retObj.list[1].orgAbbreviation;
			}
			if(len>2){
				document.getElementById("fourth_org").value=retObj.list[2].orgSubId;
				document.getElementById("fourth_org2").value=retObj.list[2].orgAbbreviation;
			}
		}
	}
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}

	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
				}
	   
	}

	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
			        document.getElementById("fourth_org2").value = teamInfo.value;
				}
	}
			
</script>
<title>选择要导入的文件</title>
</head>
<body onload="queryOrg()">
<form action="" id="fileForm" method="post" enctype="multipart/form-data">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
	  <tr>
     	<td class="inquire_item6" style="font-size: 13px;">单位：</td>
      	<td class="inquire_form6">
      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
      	<%} %>
      	</td>
     	<td class="inquire_item6" style="font-size: 13px;">基层单位：</td>
      	<td class="inquire_form6">
      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
      	<%} %>
      	</td>
      	<td class="inquire_item6" style="font-size: 13px;">下属单位：</td>
      	<td class="inquire_form6">
      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
      	<%}%>
      	</td>
     </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="even">
		<td class="rtCRUFdName">选择文件：</td>
		<td class="rtCRUFdValue">
		<input type="file"  id="fileName" name="fileName" class="input_width">
		</td>
	</tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		<td>
		<a href="javascript:downloadModel('assessHse','HSE绩效考核模板')"><font color=red>下载导入模板</font></a>
<!-- 		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="uploadFile()" value="确定" />
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="newClose()" value="关闭" />
-->
		<span class="bc_btn"><a id="confirmButton" href="#" onclick="uploadFile()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
</table>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
</html>