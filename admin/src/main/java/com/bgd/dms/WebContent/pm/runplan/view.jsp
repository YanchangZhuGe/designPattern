<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//String projectInfoNo = user.getProjectInfoNo();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = user.getProjectName();
	
	//添加项目类型
	String projectType = request.getParameter("projectType");
	if(projectType == null){
		projectType = "";
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
<title>项目运行计划</title>
<script type="text/javascript">

debugger;


var projectInfoNo = "<%=projectInfoNo%>";
var selectedIndex = 0;

var querySql = "select  distinct t.file_id,concat(concat(f.file_id ,':'),f.ucm_id) ids ,f.file_name ,f.ucm_id ," +
" decode(wf.proc_status,'1','待审核','3','审核通过','4','审核不通过','5','退回','未上报') pro_status ," +
" r.examine_start_date create_date ,substr(r.examine_end_date,0,10) modifi_date ,p.project_name " +
" from bgp_qua_control t" +
" join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag ='0'" +
" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'" +
" left join common_busi_wf_middle wf on t.file_id = wf.business_id and wf.bsflag='0'" +
" left join wf_r_examineinst r on wf.proc_inst_id = r.procinst_id " +
" where t.bsflag = '0' and t.project_info_no ='"+projectInfoNo+"'";
var submitStr =  "currentPage=1&pageSize=10";
submitStr += "&querySql="+querySql;

submitStr = encodeURI(submitStr);
submitStr = encodeURI(submitStr);

var path = "<%=contextPath%>"+appConfig.queryListAction;
debugger;
retObject = syncRequest('Post',path,submitStr);
var file_id = "";
var url5="";
var url6="";
if(retObject.datas != null){
	file_id = retObject.datas[0].file_id;
	var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
	var fileExtension = retObj.docInfoMap.dWebExtension;
	url5 = '<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension;
}

querySql = "select * from bgp_doc_gms_file f where f.bsflag='0' and is_file='0' and f.project_info_no='"+projectInfoNo+"' and f.file_abbr='HSEZYJHS' ";

var submitStr =  "currentPage=1&pageSize=10";
submitStr += "&querySql="+querySql;
var parent_file_id = "";
submitStr = encodeURI(submitStr);
submitStr = encodeURI(submitStr);
retObject = syncRequest('Post',path,submitStr);
if(retObject.datas != null){
	parent_file_id = retObject.datas[0].file_id;
}

querySql = "select t.file_id, "+
 "   t.file_name, "+
 "   t.ucm_id, "+
 "   to_char(t.create_date, 'yyyy-MM-dd') create_date, "+
 "   e.user_name "+
" from bgp_doc_gms_file t "+
" left join p_auth_user e "+
"  on t.creator_id = e.user_id "+
" and e.bsflag = '0' "+
" where t.bsflag = '0' "+
" and t.is_file = '1' "+
" and t.project_info_no = '"+projectInfoNo+"' "+
" and t.parent_file_id = '"+parent_file_id+"' "+
" order by t.modifi_date desc ";

submitStr =  "currentPage=1&pageSize=10";
submitStr += "&querySql="+querySql;

submitStr = encodeURI(submitStr);
submitStr = encodeURI(submitStr);

retObject = syncRequest('Post',path,submitStr);


if(retObject.datas != null){
	file_id = retObject.datas[0].file_id;
	var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
	var fileExtension = retObj.docInfoMap.dWebExtension;
	url6 = '<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension;
}

function loadPanel(index){
	if(index > 6){
		return;
	}
	var urls = new Array(7);
	//urls[0] = "<%=contextPath %>/pm/plan/view.jsp?projectInfoNo="+projectInfoNo;
	
	debugger;
	//综合物化探处
	if("5000100004000000009"=="<%=projectType%>"){
		urls[0] = "<%=contextPath %>/wt/pm/planManager/multiProject/progress/viewlastplan.jsp?projectInfoNo="+projectInfoNo+"&action=view";
	}	//深海
	if("5000100004000000006"=="<%=projectType%>"){
		urls[0] = "<%=contextPath %>/pm/plan/planchangelist/sh/multiProject/viewlastplan.jsp?projectInfoNo="+projectInfoNo+"&action=view";
	}else{
		urls[0] = "<%=contextPath %>/pm/plan/viewlastplan.jsp?projectInfoNo="+projectInfoNo;
	}
	
	
 
	urls[1] = "<%=contextPath %>/rm/dm/devPlan/projectDevicePlanList.jsp?projectInfoNo="+projectInfoNo;
	urls[2] = "<%=contextPath %>/mat/common/useItemList.jsp?projectInfoNo="+projectInfoNo;
	urls[3] = "<%=contextPath %>/rm/em/singleHuman/humanPlan/projectHumanPlanList.jsp?projectInfoNo="+projectInfoNo;
	urls[4] = "<%=contextPath %>/op/costTargetManager/costTargetProjectManagerForSC.jsp?projectInfoNo="+projectInfoNo;
	urls[5] = url5;
	urls[6] = url6;
	selectTab(selectedIndex, index);
	document.getElementById("iframe_" + index).src = urls[index];
}

function selectTab(oldIndex, newIndex) {  
	var selectedTag = document.getElementById("tag3_"+oldIndex);
	var selectedTabBox = document.getElementById("tab_box_content"+oldIndex)
	selectedTag.className ="";
	selectedTabBox.style.display="none";

	selectedIndex = newIndex;
	
	selectedTag = document.getElementById("tag3_"+newIndex);
	selectedTabBox = document.getElementById("tab_box_content"+newIndex)
	selectedTag.className ="selectTag";
	selectedTabBox.style.display="block";
}

</script>
</head>
<body style="background:#fff" onload="loadPanel(0);">
<div id="tag-container_3">
	<ul id="tags" class="tags">
		<li class="selectTag" id="tag3_0"><a href="#" onclick="loadPanel(0)">项目进度计划</a></li>
		<li id="tag3_1"><a href="#" onclick="loadPanel(1)">设备配置计划</a></li>
		<li id="tag3_2"><a href="#" onclick="loadPanel(2)">物资配置计划</a></li>
		<li id="tag3_3"><a href="#" onclick="loadPanel(3)">人员配置计划</a></li>
		<li id="tag3_4"><a href="#" onclick="loadPanel(4)">成本控制计划</a></li>
		<li id="tag3_5"><a href="#" onclick="loadPanel(5)">质量控制计划</a></li>
		<li id="tag3_6"><a href="#" onclick="loadPanel(6)">HSE作业计划</a></li>
	</ul>
</div>
<div id="tab_box" class="tab_box" style="height:500px;">
	<div id="tab_box_content0" class="tab_box_content" style="height:100%;">
		<iframe width="100%" height="100%" id="iframe_0" frameborder="0" src="" marginheight="0" marginwidth="0">
		</iframe>
	</div>
	<div id="tab_box_content1" class="tab_box_content" style="height:100%;display: none;">
		<iframe width="100%" height="100%" id="iframe_1" frameborder="0" src="" marginheight="0" marginwidth="0">
		</iframe>
	</div>
	<div id="tab_box_content2" class="tab_box_content" style="height:100%;display: none;">
		<iframe width="100%" height="100%" id="iframe_2" frameborder="0" src="" marginheight="0" marginwidth="0">
		</iframe>
	</div>
	<div id="tab_box_content3" class="tab_box_content" style="height:100%;display: none;">
		<iframe width="100%" height="100%" id="iframe_3" frameborder="0" src="" marginheight="0" marginwidth="0">
		</iframe>
	</div>
	<div id="tab_box_content4" class="tab_box_content" style="height:100%;display: none;">
		<iframe width="100%" height="100%" id="iframe_4" frameborder="0" src="" marginheight="0" marginwidth="0">
		</iframe>
	</div>
	<div id="tab_box_content5" class="tab_box_content" style="height:100%;display: none;">
		<iframe width="100%" height="100%" id="iframe_5" frameborder="0" src="" marginheight="0" marginwidth="0">
		</iframe>
	</div>
	<div id="tab_box_content6" class="tab_box_content" style="height:100%;display: none;">
		<iframe width="100%" height="100%" id="iframe_6" frameborder="0" src="" marginheight="0" marginwidth="0">
		</iframe>
	</div>
</div>
</body>
<script type="text/javascript">
debugger;
document.getElementById("tab_box").style.height=document.body.scrollHeight;
</script>
</html>
