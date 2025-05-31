<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName=user.getEmpId();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

  <title>项目费用方案管理</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>&nbsp;</td>
			    <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{nstruct_report_id}' id='rdo_entity_id_{nstruct_report_id}'   />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="<a href='#' onclick=openFile('{ucm_id}')><font color='blue'>{report_name}</font></a>">文件名称</td>
			      <td class="bt_info_even" exp="{report_date}">上传时间</td>
			      <td class="bt_info_odd" exp="{report_type_name}">文件类型</td>
			      <td class="bt_info_even" exp="{employee_name}">上传人</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">标签1</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(3)">文档</a></li>
				    <li id="tag3_2"><a href="#" onclick="getTab3(4)">备注</a></li>
				    <li id="tag3_3"><a href="#" onclick="getTab3(5)">分类码</a></li>
				  </ul>
			</div>
			<div id="tab_box" class="tab_box" style="overflow:hidden;">
				    <div id="tab_box_content0" class="tab_box_content">
				    </div>
				    <div id="tab_box_content1" class="tab_box_content">
				    <iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				    </iframe>
				    </div>
				    <div id="tab_box_content2" class="tab_box_content">
				    	<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				    </div>
				    <div id="tab_box_content3" class="tab_box_content">
				    	<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				    </div>
			</div>
</body>

<script type="text/javascript">


	$(document).ready(readyForSetHeight);

	frameSize();
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			refreshData();
		}
	}
	function refreshData(){
		cruConfig.queryStr = "select t.*,'经营情况汇总表(公司)' report_type_name,he.employee_name from BGP_OP_NSTRUCT_REPORT t  left outer join comm_human_employee he on t.creator=he.employee_id where t.bsflag='0' and report_type='5'";
		cruConfig.currentPageUrl = "/op/costStructReport/costNStructReportList.jsp";
		queryData(1);
	}
	function toView(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costStructReport/costNStrutReportHighEdit.upmd?pagerAction=edit2View&id='+ids);
	}
	function toAdd(){
		popWindow('<%=contextPath%>/op/costStructReport/costNStrutReportHighEdit.upmd?pagerAction=edit2Add&userName=<%=userName%>');
	}

	
	function toEdit() {
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costStructReport/costNStrutReportHighEdit.upmd?pagerAction=edit2Edit&userName=<%=userName%>&id='+ids);
	}
	function toDelete(){

		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update bgp_op_cost_project_schema t set t.bsflag='1' where t.cost_project_schema_id ='"+ids+"'";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		syncRequest('Post',path,params);
		refreshData();
	}

	function loadDataDetail(ids){
		//载入文档信息
		document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
		//载入备注信息
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		//载入分类吗信息
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=4&relationId="+ids
	}
	
	function openFile(ids){
		var ucm_id = ids;
		if(ucm_id != ""){
			window.open('<%=contextPath%>/doc/downloadDocByUcmId.srq?docId='+ucm_id);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
	}
</script>
</html>