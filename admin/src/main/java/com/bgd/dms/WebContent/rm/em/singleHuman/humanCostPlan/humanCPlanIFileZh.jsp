<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%

	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//菜单传过来的标志位，1为物探处0为专业化单位
	String costState = request.getParameter("costState");
	String projectInfoNo = request.getParameter("projectInfoNo");
	String planId = request.getParameter("planId");
	String projectType = request.getParameter("projectType");
	String projectName = request.getParameter("projectName");
	projectName=new String(projectName.getBytes("ISO-8859-1"),"utf-8");	
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	String projectInfoNoA  = "";
	String projectTypeA = "";
	String projectNameA  = "";
	String planIdD  = "";
	if(respMsg != null){
		message = respMsg.getValue("message");
		  projectInfoNoA = respMsg.getValue("projectInfoNo");
		  projectTypeA = respMsg.getValue("projectType");
		  projectNameA = respMsg.getValue("projectName");
		  planIdD = respMsg.getValue("planIdD");
		
	}
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
 
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>'; 
var message = "<%=message%>";
 
if(message != "" && message != 'null'){
	if(message=="1"){  
		var str="projectInfoNo=<%=projectInfoNoA%>&superiorCodeId=0000000003000000802&planId=<%=planIdD%>";		
		jcdpCallService("HumanCommInfoSrv","saveCostPlanListCodes",str);	
		alert("导入成功"); 
		frames('list').frames.location();
	   // top.frames('list').frames[1].importCostPlan('<%=projectInfoNoA%>','<%=projectTypeA%>','<%=projectNameA%>');
		newClose();
	}else{
		alert(message);		
	}
	
}


	var content="";
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
		if(filename == ""){
			alert("请选择上传附件!");
			return;
		}

		if(check(filename)){	
			document.getElementById("fileForm").submit();
		}
		newClose();
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
			
</script>
<title>选择要导入的文件</title>
</head>
<body>
<form action="<%=contextPath%>/rm/em/saveHumanCostExcleZh.srq" id="fileForm" method="post" enctype="multipart/form-data" target="list">
<table width="96%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	<tr>
		<td class="inquire_item4">选择文件：<input type="hidden" id="costState" name="costState" value="<%=costState%>" class="input_width">
		<input type="hidden" id="projectInfoNo" name="projectInfoNo" value="<%=projectInfoNo%>" class="input_width">
		<input type="hidden" id="planId" name="planId" value="<%=planId%>" class="input_width">
		<input type="hidden" id="projectType" name="projectType" value="<%=projectType%>" class="input_width">
		<input type="hidden" id="projectName" name="projectName" value="<%=projectName%>" class="input_width">
		</td>
		<td class="inquire_form4"><input type="file" id="fileName" name="fileName" class="input_width">
	</tr>
</table>

    <div id="oper_div">
        <input name="Submit" type="button"  id="confirmButton"  onClick="uploadFile()" value="确定" />
		<input name="Submit" type="button"  id="confirmButton"  onClick="newClose()" value="取消" />
    </div>
</form>
</body>
</html>