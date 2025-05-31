<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
	String quaCheckPlanid = request.getParameter("quaCheckPlanid");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<!--Remark JavaScript定义-->
<script language="javaScript">

	
cruConfig.contextPath =  "<%=contextPath%>";

function save(){
//	if (!checkForm()) return;
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/qua/saveCheckPlanWs.srq?project_info_no='<%=projectInfoNo%>'";
	form.submit();
	newClose();
}

function checkForm(){
	if (!isTextPropertyNotNull("title", "标题")) return false;	
	if (!isLimitB100("title","标题")) return false;  
	if (!isLimitB20("writer","参加人员")) return false; 
	if (!isLimitB20("leader","负责人")) return false;
	return true;
}
function refreshData(){
	var str="select plan.*,doc.UCM_ID as ucmid from BGP_QUA_CHECK_PLAN_WS plan left join BGP_DOC_GMS_FILE doc on doc.FILE_ID=plan.FILE_ID and doc.BSFLAG='0' where plan.QUA_PLAN_ID='<%=quaCheckPlanid%>' and plan.bsflag='0'"
	//alert(str);
//	cruConfig.queryStr = str;
	var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');

	var retObj = detailRet.datas;
	$("#responsibility").val(retObj[0].responsibility);
	$("#checkPerson").val(retObj[0].checkperson);
	$("#planEndDate").val(retObj[0].planenddate);
	$("#planStartDate").val(retObj[0].planstartdate);
	$("#UCM_ID").val(retObj[0].ucmid);
	
	//$("#downfile").html(retObj[0].filename);
	//var retObjFile = jcdpCallService("QualitySrv", "getFileinfo", "ucmdocid="+retObj[0].ucmdocid);		$("#downfile").html(retObj[0].filename);
	$("#downfile").html("<a onclick=\"view_doc('"+retObj[0].file_id+"')\"><font color='blue'>"+retObj[0].filename+"</font></a>");
	
	
	//alert(retObjFile.filePath);
	//$("#fileUrl").href=retObjFile.filePath;
	//// $("#imgFileName").html("<span title=\"查看\" style=\"cursor: pointer;\" onclick=\"viewPicture('"+retObj.imagePath+"')\">"+retObj.fileName+"</span><input id=\"imageD\" onclick=\"deleteImage()\" value=\"删除\" type=\"button\"/> "
	$("#fileUrl").html("<input onclick=\"window.location ='<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj[0].ucmid+"';\" type=\"button\" value=\"下载\" />");		  

}

function view_doc(file_id){
	if(file_id != ""){
		var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
		var fileExtension = retObj.docInfoMap.dWebExtension;
		window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension);
	}else{
    	alert("该条记录没有文档");
    	return;
	}
		
}

</script>
</head>
<body onload="refreshData();">
	<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
							<table  id="tableDoc"  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">

								<tr>
									<td class="inquire_item4">计划开始时间：</td>
									<td class="inquire_form4">
										<input type="text" id="planStartDate" name="planStartDate" value="" class="input_width" readonly="readonly"/>
									</td>
									<td class="inquire_item4">计划结束时间：</td>
									<td class="inquire_form4">
										<input type="text" id="planEndDate" name="planEndDate" value="" class="input_width" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">责任人：</td>
									<td class="inquire_form4"><input type="text" id="responsibility" name="responsibility" value="" class="input_width" readonly="readonly"/></td>
									<td class="inquire_item4">检查人：</td>
									<td class="inquire_form4"><input type="text" id="checkPerson" name="checkPerson" value="" class="input_width" readonly="readonly"/></td>

								</tr>
								<tr>
									<td class="inquire_item4">上传文档：</td>
									<td colspan="2">
										<input id="UCM_ID" name="UCM_ID" value="" type="hidden"/>
					    				<span id="downfile"></span> <span id="fileUrl"></span>        
									</td>
									<td class="inquire_form4"></td>
								</tr>
								 
							</table>
						</div>
					</div>

				</div>
	</form>
</body>
</html>
