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

	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
	String folder_id = request.getParameter("folder_id");

	


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
function clearQueryText(){
	$("#s_project_name").val("");
	$("#s_filename").val("");
}


function chooseOne(cb){   
    var obj = document.getElementsByName("rdo_entity_id");   
    for (i=0; i<obj.length; i++){   
        if (obj[i]!=cb) obj[i].checked = false;   
        else obj[i].checked = true;   
    }   
}   

function refreshData(v_project_name, v_filename){
	var str="select f.FILE_ID,f.FILE_NAME,f.UCM_ID,f.MODIFI_DATE,f.CREATE_DATE,f.PARENT_FILE_ID,u.USER_NAME,p.PROJECT_NAME,p.PROJECT_INFO_NO  "
		+" from BGP_DOC_GMS_FILE f "
		+" left join p_auth_user u on u.USER_ID=f.CREATOR_ID and u.BSFLAG='0' "
       	+"  left join GP_TASK_PROJECT p on p.PROJECT_INFO_NO=f.PROJECT_INFO_NO and p.BSFLAG='0' "
		+" left join BGP_DOC_GMS_FILE f3 on f3.file_id=f.parent_file_id and f3.BSFLAG='0' and f3.IS_FILE<>'1' "
		+" where f.IS_FILE='1' and f.BSFLAG='0' and f3.FILE_ABBR='<%=folder_id%>'  ";
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and p.project_name like '%"+v_project_name+"%' ";
		}
		if(v_filename!=undefined && v_filename!=''){
			str += "and f.file_name like '%"+v_filename+"%' ";
		}
		str += "order by  f.create_date desc ";
	cruConfig.queryStr = str;
	queryData(cruConfig.currentPage);
}


function loadDataDetail(file_id){

}

function searchDevData(){
	var v_project_name = document.getElementById("s_project_name").value;
	var v_filename = document.getElementById("s_filename").value;
	refreshData(v_project_name, v_filename);
}

function toDownload(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 3){
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
				<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text" class="input_width" /> </td>
			    <td class="ali_cdn_name">文档名称</td>
			    <td class="ali_cdn_input"><input id="s_filename" name="s_filename" type="text" class="input_width" /> 
			    </td>
			    <td class="ali_query"><span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span></td>
			    <td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span></td>
						 	<td>&nbsp;</td>
						 	<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>	
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

<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{file_id}:{ucm_id}:{project_info_no}' id='chk_entity_id' onclick='chooseOne(this)'/>" >选择</td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	<td class="bt_info_odd" exp="<a onclick=view_doc('{file_id}')><font color='blue'>{file_name}</font></a>">文档名称</td>
			  	<td class="bt_info_even" exp="{project_name}">项目名称</td>
			  	<td class="bt_info_even" exp="{create_date}">创建时间</td>
			  	<td class="bt_info_even" exp="{user_name}">创建人</td>
			  	
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
