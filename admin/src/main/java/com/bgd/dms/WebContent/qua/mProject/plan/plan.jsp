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
	String projectInfoNo = user.getProjectInfoNo();
	if(projectInfoNo==null || projectInfoNo.trim().equals("")){
		projectInfoNo = "";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
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
<style type="text/css" >
</style>
<script type="text/javascript" >
	var file_id = '';
	var ucm_id = '';
	var checked = false;
	function check(val){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			 
			if(chk[i].value != val.value){ 
				chk[i].checked = false; 
			} 
		} 
		
	}
<%-- 	function view_doc(){
		var ids = file_id + ":" + ucm_id;
		if(ids != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+ucm_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
	} --%>
</script>
<title>列表页面</title>
</head>
<body  scroll="no" ><!-- style="background:#fff" onload="refreshData()" -->

	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;<input type="hidden" id="org_subjection_id" name="org_subjection_id" class="input_width" value="<%=org_subjection_id%>"/></td>
						 	
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
			   	<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{control_id}:{file_id}:{org_subjection_id}:{note}:{project_info_no}' onclick='check(this)'/>" >
			  		 </td>
			  	<td class="bt_info_even" exp="{num}">序号</td> 
			  	<td class="bt_info_odd" exp="<input type='hidden' id ='file_name' value='{file_name}'/>{project_name}">项目名称</td>
			  	<td class="bt_info_even" exp="{pro_status}">审批情况</td>
			  	<td class="bt_info_odd" exp="{create_date}">提交时间</td>
			  	<td class="bt_info_even" exp="{modifi_date}">审批时间</td>
			  	<td class="bt_info_odd" exp="{org_name}">实施单位</td>
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
        <li><a href="#" onclick="getTab(this,2)" >计划文档</a></li>
        <li><a href="#" onclick="getTab(this,3)" >备注</a></li>
        <!-- <li><a href="#" onclick="getTab(this,4)" >分类码</a></li> -->
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<wf:startProcessInfo  buttonFunctionId="F_QUA_SINGLE_001" title=""/>
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;"> 
			<iframe width="100%" height="100%" src="" name="attachement" id="attachement" frameborder="0"  marginheight="0" marginwidth="0" >
			</iframe>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		     	<tr>
			    	<td class="inquire_item4">备注:</td>
			    	<td class="inquire_form4"><textarea id="note" name="note" cols="" rows="" class="textarea"></textarea></td>
			    </tr>
		    </table> 
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	var file_name = '';
	function refreshData(org_subjection_id){
		if(org_subjection_id==null || org_subjection_id==''){
			org_subjection_id = '<%=org_subjection_id%>';
		}
		cruConfig.queryStr = "select rownum num ,dd.* from(select distinct t.control_id ,t.file_id,concat(concat(f.file_id ,':'),f.ucm_id) ids ,f.file_name ,f.ucm_id ," +
		" decode(wf.proc_status,'1','待审核','3','审核通过','4','审核不通过','5','退回','未上报') pro_status ,s.org_subjection_id , t.note ," +
		" max(r.examine_start_date) create_date ,max(substr(r.examine_end_date,0,10)) modifi_date ,p.project_name ,i.org_abbreviation org_name ," +
		" p.project_info_no from bgp_qua_control t join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag ='0'" +
		" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'" +
		" left join common_busi_wf_middle wf on t.file_id = wf.business_id and wf.bsflag='0'" +
		" left join wf_r_examineinst r on wf.proc_inst_id = r.procinst_id " +
		" join comm_org_subjection s on t.org_subjection_id = s.org_subjection_id and s.bsflag = '0'"+
		" join comm_org_information i on s.org_id = i.org_id and i.bsflag = '0'"+
		" where t.bsflag = '0' "
		  +" and wf.proc_status ='3' "
		+" and f.relation_id like'control:"+org_subjection_id+"%' "+
		" group by t.control_id ,t.file_id,concat(concat(f.file_id ,':'),f.ucm_id) ,f.file_name ,f.ucm_id , "+
	    " decode(wf.proc_status,'1','待审核','3','审核通过','4','审核不通过','5','退回','未上报')  ,s.org_subjection_id , t.note ,"+
	    " p.project_name ,i.org_abbreviation , p.project_info_no)dd";
		queryData(1);
		frameSize();
		resizeNewTitleTable();
	}
	refreshData('');
	/* 输入的是否是数字 */
	function checkIfNum(event){
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8){
			return true;
		}
		else{
			return false;
		}
	}
	/* 详细信息 */
	function loadDataDetail(ids){
		var control_id = ids.split(":")[0];
		var file_id = ids.split(":")[1];
		var org_subjection_id = ids.split(":")[2];
		var note = ids.split(":")[3];
		var project_info_no = ids.split(":")[4];
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
    	processNecessaryInfo={
   			businessTableName:"BGP_DOC_GMS_FILE",	
   			businessType:"5110000004100000019", //5110000004100000014
   			businessId: file_id,
   			businessInfo:file_name+"发起了质量控制计划申请",
   			applicantDate: '<%=appDate%>'
   		}; 
   		
   		processAppendInfo = {
   			control_id: control_id
   		};
   		loadProcessHistoryInfo();
   		var relationId ="control:"+org_subjection_id;
   		document.getElementById("attachement").src='<%=contextPath%>/qua/mProject/plan/file_list.jsp?relationId='+relationId+'&project_info_no='+project_info_no;
   		document.getElementById("note").value = note;
	}
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
	
		for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
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
	function exportData2(curPage, pageSize){
		if(curPage==undefined) curPage=cruConfig.currentPage;
		if(pageSize==undefined) pageSize=cruConfig.pageSize;
		var titleRow = getObj('queryRetTable').rows[0];
		var columnExp="";
		var columnTitle="";
		for(var j=0;j<titleRow.cells.length;j++){
			var tCell = titleRow.cells[j];
			if(tCell.exp==null || tCell.exp=="null" || tCell.exp.indexOf("{")>0 || tCell.isExport=="Hide") continue;
			columnExp += tCell.exp.substring(1,tCell.exp.length-1) + ",";
			columnTitle += tCell.innerHTML + ",";
		}
		var org_subjection_id = document.getElementById("org_subjection_id").value;
		var querySql = "select rownum num ,dd.* from(select distinct t.control_id ,t.file_id,concat(concat(f.file_id ,':'),f.ucm_id) ids ,f.file_name ,f.ucm_id ," +
		" decode(wf.proc_status,'1','待审核','3','审核通过','4','审核不通过','5','退回','未上报') pro_status ,s.org_subjection_id , t.note ," +
		" r.examine_start_date create_date ,substr(r.examine_end_date,0,10) modifi_date ,p.project_name ,i.org_abbreviation org_name ," +
		" p.project_info_no from bgp_qua_control t join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag ='0'" +
		" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'" +
		" left join common_busi_wf_middle wf on t.file_id = wf.business_id and wf.bsflag='0'" +
		" left join wf_r_examineinst r on wf.proc_inst_id = r.procinst_id " +
		" join comm_org_subjection s on t.org_subjection_id = s.org_subjection_id and s.bsflag = '0'"+
		" join comm_org_information i on s.org_id = i.org_id and i.bsflag = '0'"+
		" where t.bsflag = '0' and wf.proc_status ='3'  and f.relation_id like'control:"+org_subjection_id+"%')dd";
		
		var path = cruConfig.contextPath+"/common/excel/listToExcel.srq";
		var excel_name = top.frames["fourthMenuFrame"].selectedTag.childNodes[0].innerHTML;
		var submitStr = "querySql="+querySql+"&currentPage="+curPage+"&pageSize="+pageSize;
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		submitStr = submitStr +"&JCDP_SRV_NAME=RADCommCRUD&JCDP_OP_NAME=queryRecords&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+excel_name;
		var retObj = syncRequest("post", path, submitStr);
		
		window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+excel_name+".xls";
		
	}
	function toDownload(){
	    var ids = "";
	    var chk = document.getElementsByName("chk_entity_id");
	    for(var i =0;i<chk.length;i++){
	    	if(!chk[i].checked)continue;
	    	ids = chk[i].value +";"+ids;
	    }
	    debugger;
	    if(ids.split(";").length > 2){
	    	alert("请只选中一条记录");
	    	return;
	    }
	    var file_id = ids.split(":")[1];
	    if(file_id != ""){
	    	window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+file_id;
	    }else{
	    	alert("该条记录没有文档");
	    	return;
	    }
	}
</script>

</body>
</html>
