<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="com.bgp.mcs.service.qua.service.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	String project_type = user.getProjectType();
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
	List<Map> list = QualityUtil.getExplorationMethod(project_info_no);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
	function clearQueryText(){
		document.getElementById("name").value = '';
		document.getElementById("pro_status").options[0].selected = true;
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
<title>列表页面</title>
</head>
<body style="background:#fff" >

	<%-- <div id="inq_tool_box" style="display: none;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">QC活动课题:</td>
						    <td class="ali_cdn_input"><input type="text" id="name" name="name" class="input_width"/></td>
						    <td class="ali_cdn_name">审批情况:</td>
						    <td class="ali_cdn_input"><select id="pro_status" name="pro_status" class="select_width">
						    	<option value="">请选择</option>
						    	<option value="0">未上报</option>
						    	<option value="1">待审核</option>
						    	<option value="3">审核通过</option>
						    	<option value="4">审核不通过</option>
						    	</select></td>
						    <auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
				    		<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_QC_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton> 
						    <auth:ListButton functionId="F_QUA_QC_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_QC_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" style="display: none;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			   <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" exp="{auto}">序号</td> 
			  <td class="bt_info_odd" exp="{qc_code}">QC活动编号</td>
			  <td class="bt_info_even" exp="{qc_title}">QC活动课题</td>
			  <td class="bt_info_odd" exp="<a href='#' onclick=view_doc('{file_id}')><font color='blue'>{name}</font></a>">注册文件</td>
			  <td class="bt_info_even" exp="{pro_status}">审批情况
			  
			  </td>
			</tr>
		</table>
	</div> 
	<div id="fenye_box" style="display: none;">
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
	<div class="lashen" id="line"></div> --%>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
      <%if(project_type!=null && project_type.trim().equals("5000100004000000009") && list!=null && list.size()>0){ //综合物化探业务,按照项目的勘探方法 ,list.size()>0才创建行
		int i =1;
		for(Map map : list){
			String coding_sort_id = map==null || map.get("coding_sort_id")==null?"":(String)map.get("coding_sort_id");
			String coding_name = map==null || map.get("coding_name")==null?"":(String)map.get("coding_name");%>
		<li <%if(i==1){ %>class="selectTag" <%} %>><a href="#" onclick="getTab(this,<%=i++ %>)"><%=coding_name %></a></li>
		<%} }%>	
        <!-- <li class="selectTag"><a href="#" onclick="getTab(this,1)">活动注册</a></li>
        <li><a href="#" onclick="getTab(this,2)">活动记录</a></li>
        <li><a href="#" onclick="getTab(this,3)">活动成果</a></li>
        <li><a href="#" onclick="getTab(this,4)">流程</a></li> -->
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
	<%if(project_type!=null && project_type.trim().equals("5000100004000000009") && list!=null && list.size()>0){ //综合物化探业务,按照项目的勘探方法 ,list.size()>0才创建行
		int i =1;
		for(Map map : list){
			String coding_sort_id = map==null || map.get("coding_sort_id")==null?"":(String)map.get("coding_sort_id");
			String coding_name = map==null || map.get("coding_name")==null?"":(String)map.get("coding_name");
			coding_name = URLEncoder.encode(coding_name,"GBK");
			coding_name = URLEncoder.encode(coding_name,"GBK");
			%>
		<div id="tab_box_content<%=i++ %>" class="tab_box_content" >
			<iframe width="100%" height="100%" src="<%=contextPath %>/qua/sProject/report.jsp?wbs_name=<%=coding_name %>&project_type=<%=project_type %>&project_info_no=<%=project_info_no %>" name="report" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
	<%} }%>	
		<%-- <div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="<%=contextPath %>/qua/sProject/QC/record_file.jsp" name="record" id="record" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="<%=contextPath %>/qua/sProject/QC/result_file.jsp" name="result" id="result" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="<%=contextPath %>/qua/sProject/QC/result_file.jsp" name="result" id="result" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" src="<%=contextPath %>/qua/sProject/QC/result_file.jsp" name="result" id="result" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
		</div> --%>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getQCList";
	$("#table_box").css("height",$(window).height()*0.46);
	var selectedTag = document.getElementsByTagName("li")[0]; 
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
</script>

</body>
</html>
