<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
   // String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
	String fileId = request.getParameter("fileId");
	String projectInfoNo = request.getParameter("projectInfoNo");

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

function refreshData(){
	var str="select p.PROJECT_NAME,f.FILE_ID,f.FILE_NAME,f.CREATE_DATE,f.MODIFI_DATE,f.PARENT_FILE_ID,f.UCM_ID,f.PROJECT_INFO_NO,u.user_name,f3.FILE_NAME as folder_name"
	+" from BGP_DOC_GMS_FILE f left join GP_TASK_PROJECT p on p.PROJECT_INFO_NO=f.PROJECT_INFO_NO and p.BSFLAG='0' "
	+" left join p_auth_user u on u.USER_ID=f.CREATOR_ID and u.BSFLAG='0' "
	+" left join ( select f2.FILE_ID,f2.FILE_NAME from BGP_DOC_GMS_FILE f2 where f2.BSFLAG='0' and f2.IS_FILE<>'1' and f2.PROJECT_INFO_NO='<%=projectInfoNo%>') f3 on f3.file_id=f.PARENT_FILE_ID "
	+" where f.BSFLAG='0' and f.IS_FILE='1' and f.FILE_ID='<%=fileId%>'";

	var  detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');

	var retObj = detailRet.datas;
	$("#creatorName").val(retObj[0].user_name);
	$("#projectName").val(retObj[0].project_name);
	$("#folder_name").val(retObj[0].folder_name);
	$("#UCM_ID").val(retObj[0].ucm_id);
	$("#downfile").html("<a onclick=\"view_doc('"+retObj[0].file_id+"')\"><font color='blue'>"+retObj[0].file_name+"</font></a>");	
	$("#fileUrl").html("<input onclick=\"window.location ='<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj[0].ucm_id+"';\" type=\"button\" value=\"下载\" />");		  

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
									<td class="inquire_item4">项目名称：</td>
									<td class="inquire_form4"><input type="text" id="projectName" name="projectName" value="" class="input_width" readonly="readonly"/></td>
									<td class="inquire_item4">创建人：</td>
									<td class="inquire_form4"><input type="text" id="creatorName" name="creatorName" value="" class="input_width" readonly="readonly"/></td>
								</tr>
								<tr>
									<td class="inquire_form4">文档目录：</td>
									<td class="inquire_form4"><input type="text" id="folder_name" name="folder_name" value="" class="input_width" readonly="readonly"/></td>
									<td class="inquire_item4">文档名称：</td>
									<td class="inquire_form4">
										<input id="UCM_ID" name="UCM_ID" value="" type="hidden"/>
					    				<span id="downfile"></span> <span id="fileUrl"></span>        
									</td>

								</tr>
								 
							</table>
						</div>
					</div>

				</div>
	</form>
</body>
</html>
