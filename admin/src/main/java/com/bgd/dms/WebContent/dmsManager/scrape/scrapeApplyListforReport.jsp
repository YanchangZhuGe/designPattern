<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//String relation_id = "8ad8890337c506d10137c511104a0005";
	String relation_id = request.getParameter("relationId").toString();
	relation_id = relation_id==""?"1":relation_id;
	String root_folderid = user.getProjectInfoNo();
	String quality_control = "";
	if(request.getParameter("qualityControl")!=""&&request.getParameter("qualityControl")!=null){
		quality_control = request.getParameter("qualityControl");
	}
	//String sonFlag = request.getParameter("sonFlag");
	//String folderId = "";
	//if(request.getParameter("folderid") != null){
	//	folderId = request.getParameter("folderid");
	//}
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
<title>关联汇总报废申请单查询</title>
</head>
<body style="background:#fff; overflow-y: auto;" onload="refreshData()">
	<div id="list_table">
		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td>&nbsp;</td>
		    <auth:ListButton functionId="" css="xz" event="onclick='exportDevData()'" title="导出该申请单设备"></auth:ListButton>
		  </tr>
		  
		</table>
		</td>
		    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		  </tr>
		</table>
		</div>
		<div id="table_box">
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
		      <%-- <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}:{ucm_id}' id='rdo_entity_id_{file_id}' onclick=doCheck(this)/>" >选择</td>
		      <td class="bt_info_even" autoOrder="1">序号</td>
		      <td class="bt_info_odd" exp="{file_name}">文件标题</td>
		      <td class="bt_info_even" exp="{create_date}">上传时间</td> --%>
		      	<tr id='scrape_apply_id_{scrape_apply_id}' name='scrape_apply_id'  idinfo='{scrape_apply_id}'>
		      	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{scrape_apply_id}' id='rdo_entity_name_{scrape_apply_id}' {selectflag}/>" >选择</td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp={scrape_apply_name}>报废申请单名称</td>
				<td class="bt_info_odd" exp={scrape_apply_no}>报废申请单号</td>
				<td class="bt_info_odd" exp={employee_name}>申请人</td>
				<td class="bt_info_even" exp={org_name}>申请单位</td>
				<td class="bt_info_odd" exp={apply_date}>申请时间</td>
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
	  </div>
</body>
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrv";
	cruConfig.queryOp = "queryScrapeApplyList";
	function refreshData(){
		cruConfig.submitStr = "scrape_report_id=<%=relation_id%>";
		queryData(1);
	}
	function exportDevData(){
		var ids = getSelIds('selectedbox');
		if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		
		ids = "'"+ids.replace(new RegExp(/(,)/g),"','")+"'";
		var exportFlag = 'bfsqcx';
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="scrape_apply_id="+ids+"&exportFlag="+exportFlag;
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
</script>
</html>