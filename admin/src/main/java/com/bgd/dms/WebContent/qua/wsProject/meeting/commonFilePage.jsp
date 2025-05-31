<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = (String)user.getOrgId();
	String org_subjection_id = (String)user.getSubOrgIDofAffordOrg();
	String user_id = (String)user.getUserId();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null || project_info_no.trim().equals("")){
		project_info_no = "";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectName =  user.getProjectName();
	//必须参数
	String folder_id = request.getParameter("folder_id");
	if(folder_id==null||"".equals(folder_id)){
		folder_id=resultMsg.getValue("folder_id");
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

<script type="text/javascript" >
cruConfig.contextPath =  "<%=contextPath%>";

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



function chooseOne(cb){   
    var obj = document.getElementsByName("rdo_entity_id");   
    for (i=0; i<obj.length; i++){   
        if (obj[i]!=cb) obj[i].checked = false;   
        else obj[i].checked = true;   
    }   
}   
function toadd(){
  	popWindow('<%=contextPath%>/qua/wsProject/meeting/commonAddOrModifyFile.jsp?folder_id=<%=folder_id%>&file_id=""');
}
function toEdit(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 2){
    	alert("请只选中一条记录");
    	return;
    }
   
    var file_id = ids.split(":")[0];
    popWindow('<%=contextPath%>/qua/wsProject/meeting/commonAddOrModifyFile.jsp?folder_id=<%=folder_id%>&file_id='+file_id);         
    
}


function refreshData(){
	var str="select f.FILE_ID,f.FILE_NAME,f.UCM_ID,f.MODIFI_DATE,f.CREATE_DATE,f.PARENT_FILE_ID,u.USER_NAME " 
		+" from BGP_DOC_GMS_FILE f  "
		+" left join p_auth_user u on u.USER_ID=f.CREATOR_ID and u.BSFLAG='0' "
		+" left join (select f2.FILE_ID,f2.FILE_NAME,f2.PARENT_FILE_ID,f2.FILE_ABBR from BGP_DOC_GMS_FILE f2 where f2.BSFLAG='0' and f2.IS_FILE<>'1' and f2.PROJECT_INFO_NO='<%=project_info_no%>') f3 on f3.file_id=f.parent_file_id "
		+"where f.IS_FILE='1' and f.BSFLAG='0' and f3.FILE_ABBR='<%=folder_id%>' and PROJECT_INFO_NO='<%=project_info_no%>' order by f.MODIFI_DATE desc";
	cruConfig.queryStr = str;
	queryData(cruConfig.currentPage);
}



function loadDataDetail(file_id){	

}

function toDownload(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 2){
    	alert("请只选中一条记录");
    	return;
    }
    var ucm_id = ids.split(":")[1];
    if(ucm_id != ""){
    	window.location = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucm_id;
    }else{
    	alert("该条记录没有文档");
    	return;
    }
}

function toDelete(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 2){
    	alert("请只选中一条记录");
    	return;
    }
    var param = ids.split(":")[0];
	if(window.confirm("您确定要删除?")){
			if(param!=null && param!=''){
				var retObj = jcdpCallService("ucmSrvNew","commonDeleteFile", "param="+param);
				if(retObj!=null && retObj.returnCode =='0'){
					alert("删除成功!");
					refreshData();
				}
			}
	}

}

</script>
<title>列表页面</title>
</head>
<body onload="refreshData()" >

	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						 	<auth:ListButton functionId="" css="zj" event="onclick='toadd()'" title="JCDP_btn_add"></auth:ListButton>
						 	<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
						 	<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
						 	
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>

<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{file_id}:{ucm_id}' id='chk_entity_id' onclick='chooseOne(this)'/>" >选择</td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	<td class="bt_info_odd" exp="<a onclick=view_doc('{file_id}')><font color='blue'>{file_name}</font></a>">文档名称</td>
			  	<td class="bt_info_even" exp="{user_name}">创建人</td>
			  	<td class="bt_info_even" exp="{create_date}">创建时间</td>
			  	
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
	<div class="lashen" id="line"></div>

				
<script type="text/javascript">
$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-10);


</script>

</body>
</html>
