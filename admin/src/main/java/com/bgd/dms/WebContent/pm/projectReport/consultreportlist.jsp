<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	System.out.print(projectName);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>请示报告</title>
</head>
<body style="background:#fff" onload="refreshData('');">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">			 
			  <tr>
			    <td class="ali_cdn_name">报告名称</td>
			    <td class="ali_cdn_input">
				    <input id="reportName" name="reportName" type="text" class="input_width"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
	      <auth:ListButton tdid="gb" functionId="" css="gb" event="onclick='toNoApproval()'" title="JCDP_btn_audit"></auth:ListButton>
		   <auth:ListButton tdid="tj" functionId="" css="tj" event="onclick='toApproval()'" title="JCDP_btn_audit"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">			   			    
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{object_id}:{ucm_id}' id='rdo_entity_id_{object_id}' onclick=doCheck(this) />" >选择</td>
			      <td class="bt_info_even" exp="{report_name}">报告名称</td>
			      <td class="bt_info_odd" exp="{create_date}">创建日期</td>
			      <td class="bt_info_even" exp="{submit_flag}">提交</td>
			      <td class="bt_info_even" exp="{approval_status}">审批状态</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
				<div id="tag-container_3">
				  <ul id="tags" class="tags">
				    <li id="tag3_10"><a href="#" onclick="getTab3(10)">审批流程</a></li>
				    </ul>
				    </div>
			  	<div id="tab_box_content10" class="tab_box_content" >
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
				</div>
			
		 
		  </div>
			<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0">
				</iframe>
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
			</div>
		  </div>
		
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.queryStr = "";
	cruConfig.cdtType = 'form';
//  cruConfig.queryRetTable_id = "";
	var orgSubId = "<%=orgSubId%>";	
	var projectNo = "<%=projectInfoNo%>";
	var ucmid = "noselect";
	
	function clearQueryText(){
		document.getElementById("reportName").value = "";
		document.getElementById("reportName").focus();
	}
	
	// 简单查询
	function simpleRefreshData(){
		var reportName = document.getElementById("reportName").value;
		var s_filter=" workarea like'%"+reportName+"%'";
		refreshData(s_filter);
	}
	
	function refreshData(filter){
		var s_filter="";
		if(filter!="" && filter!=undefined){
			s_filter = " and " + filter;
		}
		cruConfig.queryStr = "select object_id , report_name , to_char(create_date,'yyyy-MM-dd') as create_date , case submit_flag  when '0' THEN   '未提交'   when '1' then   '已提交'  else "+
		" '已提交' end as submit_flag,"+
		"   case approval_status  when '1' THEN  '审批通过'  when '2'then  '审批不通过'   else '未审批 '  end as approval_status,"+
		"  ucm_id from bgp_consult_report where bsflag='0'and submit_flag!='0' and project_id='"+projectNo+"'" + s_filter;
		queryData(1);
	}

	function loadDataDetail(ids){
	 
		debugger;
		var object_id = ids.split(":")[0];
		var ucm_id = ids.split(":")[1];
		ucmid = ucm_id;
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    processNecessaryInfo={
	    	
	  
   	    		businessTableName:"bgp_consult_report",    //置入流程管控的业务表的主表表明
   	    		businessType:"5110000004100000058",        //业务类型 即为之前设置的业务大类
   	    		businessId:object_id,         //业务主表主键值
   	    		businessInfo:"<%=projectName %>请示报告审批",        //用于待审批界面展示业务信息
   	    		applicantDate:'<%=appDate%>'       //流程发起时间
   	    }; 
   	    processAppendInfo={ 
   	    			objectId: object_id  	    			 
   	    };
   	    loadProcessHistoryInfo();
	    // 加载当前行附件
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+object_id;
		// 加载当前行备注
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+object_id;
	}
	
	function jsSelectOption(objName, objItemValue) {
		var objSelect = document.getElementById(objName);
		for (var i = 0; i < objSelect.options.length; i++) { 
			if (objSelect.options[i].value == objItemValue) {
				objSelect.options[i].selected = "selected";
				break;
			}
		}
	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content10");

	function toSearch(){
		popWindow('<%=contextPath%>/pm/consult/counsultsearch.jsp');
	}
	
	function toEdit() {	    
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		var object_id = ids.split(":")[0];
		popWindow('<%=contextPath%>/pm/consult/consultModify.jsp?objectId='+object_id);
	}
	
	function toSave(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
	}
 
	function toApproval(){
		debugger;
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
		    var object_id = ids.split(":")[0];
			if(confirm('确定要提交吗?')){  
				var retObj = jcdpCallService("ConsultReportSrv", "approvalConsultReport", "objectId="+object_id);
				queryData(cruConfig.currentPage);
			}
			if(retObj.actionStatus=='ok'){
				alert("提交操作成功!");
			}
	}
	function toNoApproval(){
		debugger;
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
		    var object_id = ids.split(":")[0];
			if(confirm('确定要提交吗?')){  
				var retObj = jcdpCallService("ConsultReportSrv", "noApprovalConsultReport", "objectId="+object_id);
				queryData(cruConfig.currentPage);
			}
			if(retObj.actionStatus=='ok'){
				alert("提交操作成功!");
			}
	}
	function toSubmit(){
		   ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
		    var object_id = ids.split(":")[0];
			if(confirm('确定要提交吗?')){  
				var retObj = jcdpCallService("ConsultReportSrv", "submitConsultReport", "objectId="+object_id);
				queryData(cruConfig.currentPage);
			}
			if(retObj.actionStatus=='ok'){
				alert("提交操作成功!");
			}
		}
	function toAdd(){
		popWindow('<%=contextPath%>/pm/consult/consultAdd.jsp');
	}
	
	function toDelete(){ 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
	    var object_id = ids.split(":")[0];
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ConsultReportSrv", "deleteConsultReport", "objectId="+object_id);
			queryData(cruConfig.currentPage);
		}
		if(retObj.actionStatus=='ok'){
			alert("删除操作成功!");
		}
	}
	
	function dbclickRow(ids){
		var object_id = ids.split(":")[0];
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    popWindow('<%=contextPath%>/pm/consult/consultModify.jsp?action=view&objectId='+object_id);
		
		
//		var ucm_id = ids.split(":")[1];
//		if(ucm_id != ""){
//			var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=bgp_doc_gms_file&option=ucm_id='"+ucm_id+"'");
//			debugger;
//			var file_id = "";
//			if(retObj.datas != null){
//				var record = retObj.datas[0];
//				file_id = record.file_id;
//			}
//			var fileidAndUcmid = file_id + ":" + ucm_id;
//			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+fileidAndUcmid);
//			var fileExtension = retObj.docInfoMap.dWebExtension;
//			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension);
//		}else{
//	    	alert("该条记录没有文档");
//	    	return;
//		}
		
	}
	
	function toDownload(){
		if(ucmid == "noselect"){
			alert("请选择一条记录!");
			return;
		}
		if(ucmid == ""){
			alert("该条记录没有文档");
			return;
		}
		window.location.href="<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmid+"&emflag=0";
	}
	$(document).ready(lashen);
</script>
</html>