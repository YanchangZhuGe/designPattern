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
	String business_type = request.getParameter("business_type");
	String business_info = request.getParameter("business_info");
	if(folder_id==null||"".equals(folder_id)){
		folder_id=resultMsg.getValue("folder_id");
	}
	if(business_type==null||"".equals(business_type)){
		business_type=resultMsg.getValue("business_type");
	}
	if(business_info==null||"".equals(business_info)){
		business_info=resultMsg.getValue("business_info");
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
  	popWindow('<%=contextPath%>/common/commonFile/commonAddOrModifyFile.jsp?business_info='+encodeURI(encodeURI("<%=business_info%>","UTF-8"),"UTF-8")+'&business_type=<%=business_type%>&folder_id=<%=folder_id%>&file_id=""');
}
function toEdit(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 4){
    	alert("请只选中一条记录");
    	return;
    }
   
    var file_id = ids.split(":")[0];
    var pro = ids.split(":")[2];
    if(pro=='待审批'||pro=='审批通过'){
		alert("已提交流程不可修改！");
    }else{
      	popWindow('<%=contextPath%>/common/commonFile/commonAddOrModifyFile.jsp?business_info='+encodeURI(encodeURI("<%=business_info%>","UTF-8"),"UTF-8")+'&business_type=<%=business_type%>&folder_id=<%=folder_id%>&file_id='+file_id);         
    }
}


function refreshData(){
   var project_common;
   var  sql = " select project_common from gp_task_project where project_info_no ='<%=project_info_no%>' and bsflag='0' " ;
   var  queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=6000&querySql='+encodeURI(encodeURI(sql)));
   if(queryRet.returnCode=='0'){
	 var  datas = queryRet.datas;	 
	 project_common=datas[0].project_common;
   }
	
	var str;
	if(project_common!=1){
		str="  select '0' as flag, f.FILE_ID,f.FILE_NAME,f.UCM_ID,f.MODIFI_DATE,f.CREATE_DATE,f.PARENT_FILE_ID,u.USER_NAME, case wf.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as proc_status" 
			+" from BGP_DOC_GMS_FILE f left join COMMON_BUSI_WF_MIDDLE wf on wf.BUSINESS_ID=f.FILE_ID and wf.BSFLAG='0' "
			+" left join p_auth_user u on u.USER_ID=f.CREATOR_ID and u.BSFLAG='0' "
			+" left join (select f2.FILE_ID,f2.FILE_NAME,f2.PARENT_FILE_ID,f2.FILE_ABBR from BGP_DOC_GMS_FILE f2 where f2.BSFLAG='0' and f2.IS_FILE<>'1' and f2.PROJECT_INFO_NO='<%=project_info_no%>') f3 on f3.file_id=f.parent_file_id "
			+" where f.IS_FILE='1' and f.BSFLAG='0' and f3.FILE_ABBR='<%=folder_id%>' and PROJECT_INFO_NO='<%=project_info_no%>' order by f.MODIFI_DATE desc";
	}else{
		str="  select '0' as flag,  f.FILE_ID,f.FILE_NAME,f.UCM_ID,f.MODIFI_DATE,f.CREATE_DATE,f.PARENT_FILE_ID,u.USER_NAME, case wf.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as proc_status" 
			+" from BGP_DOC_GMS_FILE f left join COMMON_BUSI_WF_MIDDLE wf on wf.BUSINESS_ID=f.FILE_ID and wf.BSFLAG='0' "
			+" left join p_auth_user u on u.USER_ID=f.CREATOR_ID and u.BSFLAG='0' "
			+" left join (select f2.FILE_ID,f2.FILE_NAME,f2.PARENT_FILE_ID,f2.FILE_ABBR from BGP_DOC_GMS_FILE f2 where f2.BSFLAG='0' and f2.IS_FILE<>'1' and f2.PROJECT_INFO_NO='<%=project_info_no%>') f3 on f3.file_id=f.parent_file_id "
			+" where f.IS_FILE='1' and f.BSFLAG='0' and f3.FILE_ABBR='<%=folder_id%>' and PROJECT_INFO_NO='<%=project_info_no%>' "
			+" union all "
			+ " select '1' as flag, f.FILE_ID,f.FILE_NAME,f.UCM_ID,f.MODIFI_DATE,f.CREATE_DATE,f.PARENT_FILE_ID,u.USER_NAME, case wf.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as proc_status" 
			+" from BGP_DOC_GMS_FILE f left join COMMON_BUSI_WF_MIDDLE wf on wf.BUSINESS_ID=f.FILE_ID and wf.BSFLAG='0' "
			+" left join p_auth_user u on u.USER_ID=f.CREATOR_ID and u.BSFLAG='0' "
			+" left join (select f2.FILE_ID,f2.FILE_NAME,f2.PARENT_FILE_ID,f2.FILE_ABBR from BGP_DOC_GMS_FILE f2 where f2.BSFLAG='0' and f2.IS_FILE<>'1' and f2.PROJECT_INFO_NO=(select project_father_no from gp_task_project where project_info_no='<%=project_info_no%>')) f3 on f3.file_id=f.parent_file_id "
			+" where f.IS_FILE='1' and f.BSFLAG='0' and f3.FILE_ABBR='<%=folder_id%>' and PROJECT_INFO_NO=(select project_father_no from gp_task_project where project_info_no='<%=project_info_no%>') "
	}
	
	cruConfig.queryStr = str;
	queryData(cruConfig.currentPage);
}


function tosubmit(){
    ids = getSelIds('chk_entity_id');
    
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 4){
    	alert("请只选中一条记录");
    	return;
    }	
	if (!window.confirm("确认要提交吗?")) {
		return;
	}		
	submitProcessInfo();
	refreshData();
}
function loadDataDetail(file_id){	
	processNecessaryInfo={        							//流程引擎关键信息
		businessTableName:"BGP_DOC_GMS_FILE",    				//置入流程管控的业务表的主表表明
		businessType:'<%=business_type%>',    					//业务类型 即为之前设置的业务大类 
		businessId:file_id.split(":")[0],           				//业务主表主键值
		businessInfo:'<%=business_info%>',
		applicantDate:'<%=appDate%>'       						//流程发起时间
	};
	processAppendInfo={
		projectName:'<%=projectName%>',			 	
		projectInfoNo:'<%=project_info_no%>',
		fileId:file_id.split(":")[0]
	};
	loadProcessHistoryInfo();
}

function toDownload(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 4){
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
    var flag = ids.split(":")[3];//是否可以删除标志 0-可删除 1- 不可删除
    if(flag==1){
    	alert("该文档为年度项目文档不能删除");
    	return;
    }
    
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 4){
    	alert("请只选中一条记录");
    	return;
    }
    var param = ids.split(":")[0];
    
    

    var pro = ids.split(":")[2];
    if(pro=='待审批'||pro=='审批通过'){
		alert("已提交流程不可修改！");
    }else{
    	
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
							<auth:ListButton functionId="" css="tj" event="onclick='tosubmit()'" title="JCDP_btn_submit"></auth:ListButton>
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

<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{file_id}:{ucm_id}:{proc_status}:{flag}' id='chk_entity_id' onclick='chooseOne(this)'/>" >选择</td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	<td class="bt_info_odd" exp="<a onclick=view_doc('{file_id}')><font color='blue'>{file_name}</font></a>">文档名称</td>
			  	<td class="bt_info_even" exp="{user_name}">创建人</td>
			  	<td class="bt_info_even" exp="{create_date}">创建时间</td>
			  	<td class="bt_info_even" exp="{proc_status}">状态</td>
			  	
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
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">流程</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow-y:auto;">
		<div id="tab_box_content1" class="tab_box_content" >
				<wf:startProcessInfo  buttonFunctionId="F_OP_001" title=""/>		
		</div>
	</div>
				
<script type="text/javascript">


	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	$(document).ready(lashen);

	/*
	var obj = document.getElementsByName("chk_entity_id");
	var objLen= obj.length-1; 
	var param="";
	if(window.confirm("您确定要删除?")){
		for (var i=0; i<=objLen ;i++){   
	       if (obj [i].checked==true) { 
	    	var value = obj[i].value.split(":")[0];
		   // param = param + value+",";
	    		param=value;
			}   
	     } 
		//param = param.substr(0,param.length-1);

		if(param!=null && param!=''){
			var retObj = jcdpCallService("QualitySrv","deleteCheckPlanWs", "param="+param);
			if(retObj!=null && retObj.returnCode =='0'){
				alert("删除成功!");
				refreshData();
			}
		}

	}
	*/
	
</script>

</body>
</html>
