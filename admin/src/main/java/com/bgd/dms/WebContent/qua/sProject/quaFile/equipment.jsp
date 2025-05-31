<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="java.text.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgId();
	if(org_id == null || org_id.trim().equals("")){
		org_id = "";
	}
	String org_name = user.getOrgName();
	if(org_name == null || org_name.trim().equals("")){
		org_name = "";
	}
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no == null || project_info_no.trim().equals("")){
		project_info_no = "";
	}
	String project_name = user.getProjectName();
	if(project_name == null || project_name.trim().equals("")){
		project_name = "";
	}
	String history_id = request.getParameter("history_id");
	if(history_id == null){
		history_id = "";
	}
	Date sysdate=new Date();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String nowDate = df.format(sysdate);
%>
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
<script charset="UTF-8" type="text/javascript" src="<%=contextPath%>/qua/sProject/quaFile/quaFile.js"></script>
<script type="text/javascript" >
	function clearQueryText(){
		document.getElementById("equip_name").value = '';
	}
	
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td class="ali_cdn_name">名称</td>
				    <td class="ali_cdn_input">
				    	<input type="text" id="equip_name" name="equip_name" class="input_width"/></td>
				    <auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
				    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="F_QUA_FILE_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="F_QUA_FILE_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
					<auth:ListButton functionId="F_QUA_FILE_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	</div>
	<div id="table_box" > 
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    	<tr>
	    		<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{monitor_id}' onclick=check(this)/>">
      				<input type='checkbox' name='chk_entity_id' value='' onclick='check()'/></td>
	    	    <td class="bt_info_even" autoOrder="1">序号</td>
	            <td class="bt_info_odd" exp="{sort_id}"> 分类代码</td>
	            <td class="bt_info_even" exp="{unite_code}">统一编号</td>
	            <td class="bt_info_odd" exp="{sort_code}"> 分类编号</td>
	            <td class="bt_info_even" exp="{equip_name}">名称</td>
	            <td class="bt_info_odd" exp="{model_code}"> 型号</td>
	            <td class="bt_info_even" exp="{measure}">测量范围</td>
	            <td class="bt_info_odd" exp="{accurate}"> 精准度</td>
	            <td class="bt_info_even" exp="{producor}">生产厂家</td>
	            <td class="bt_info_odd" exp="{ident_code}"> 出厂编号</td>
	            <td class="bt_info_even" exp="{depart_name}">使用部门</td>
	            <td class="bt_info_odd" exp="{facilities}"> 配套设备</td>
	            <td class="bt_info_even" exp="{status}">管理状况</td>
	            <td class="bt_info_odd" exp="{detect_name}"> 检定部门</td>
	            <td class="bt_info_even" exp="{detect_cycle}">检定周期</td>
	            <td class="bt_info_odd" exp="{detect_date}"> 检定日期</td>
	            <td class="bt_info_even" exp="{valid_date}">有效日期</td>
	            <td class="bt_info_odd" exp="{detect_result}"> 检定结果</td>
	            <td class="bt_info_even" exp="{abc}">abc</td>
	            <td class="bt_info_odd" exp="{spare1}">到队日期</td>
	            <td class="bt_info_even" exp="{notes}"> 备注</td>
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
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">常用</a></li>
        <li ><a href="#" onclick="getTab(this,2)">excel批量导入</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">

		<div id="tab_box_content1" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="F_QUA_FILE_002" css="tj" event="onclick='historySubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			<form action="" id="form0" name="form0" method="post" >
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<input type="hidden" name="project_info_no" id="project_info_no" value="<%=project_info_no %>" />
					<input type="hidden" name="history_id" id="history_id" value="<%=history_id %>" />
					<tr>
						<td class="inquire_item6">项目名称:</td>
						<td class="inquire_form6" ><input type="text" name="project_name" id="project_name" value="<%=project_name %>" disabled="disabled" class="input_width"/></td>
						<td class="inquire_item6">单位名称:</td>
					    <td class="inquire_form6" ><input name="org_id" id="org_id" type="hidden" class="input_width" value="<%=org_id %>" />
				    		<input name="org_name" id="org_name" type="text" class="input_width" value="<%=org_name %>" readonly="readonly"/>
							<img onclick="selectOrgHR('orgId','org_id','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td>
					    <td class="inquire_item6"><font color="red">*</font>填报标题:</td>
						<td class="inquire_form6" ><input type="text" name="report_title" id="report_title" value="监视和测量设备台账"  class="input_width" /></td>
					</tr>
					<tr>
						<td class="inquire_item6"><font color="red">*</font>填报日期:</td>
						<td class="inquire_form6"><input name="report_date" id="report_date" type="text" class="input_width" value="<%=nowDate %>" readonly="readonly"/>
				    		<!--<img width="16" height="16" id="cal_button6" style="cursor: hand;" 
				    		onmouseover="calDateSelector(report_date,cal_button6);" 
				    		src="<%=contextPath %>/images/calendar.gif" />-->
				    	</td>
						<td class="inquire_item6"><font color="red">*</font>填报编号:</td>
						<td class="inquire_form6" ><input type="text" name="report_code" id="report_code" value="BGP/Q/JL7.6-1" class="input_width" /></td>
						<td class="inquire_item6"><font color="red">*</font>填写人:</td>
					    <td class="inquire_form6" ><input type="text" name="report_maker" id="report_maker" value="" class="input_width"/></td> 
					</tr>
				</table>
			</form>
		</div>
		<div id="tab_box_content2" class="tab_box_content" >
			<iframe src="<%=contextPath %>/qua/sProject/quaFile/excel.jsp" width="100%" height="100%" name="excel" id="excel" frameborder="0"  marginheight="0" marginwidth="0" ></iframe>
			
			<%-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			    <td>&nbsp;<a href="<%=contextPath%>/qua/sProject/quaFile/equipment.xls"><font color="red">导入模板下载</font></a>&nbsp;&nbsp;</td>
			    <auth:ListButton functionId="F_QUA_FILE_003" css="tj" event="onclick='importExcel()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			<form action="<%=contextPath %>/qua/equipment/excelImport.srq" id="form1" name="form1" method="post" enctype="multipart/form-data" >
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
					    <td class="inquire_item4">请选择导入文件:</td>
					    <td class="inquire_form4" colspan="3"><input type="file" name="import_file" id="import_file" value="" class="input_width" />
					    <input type="hidden" id="file_name" name="file_name" value=""/></td>
					</tr>
				</table>
			</form> --%>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getEquipmentList"; 
	var project_info_no = '<%=project_info_no%>';
	function refreshData(){
		var project_id = '<%=project_info_no%>';
		if(project_id==''){
			alert("请选择项目");
			return ;
		}
		var equip_name = document.getElementById("equip_name").value;
		if(equip_name==null){
			equip_name = '';
		}
		var history_id = document.getElementById("history_id").value;
		cruConfig.submitStr = "history_id="+history_id+"&equip_name="+equip_name;
		setTabBoxHeight();
		queryData(1);
		if(history_id!=null && history_id!=''){
			historyDetail(history_id);
		}
	}
	refreshData();
	function historySubmit() { //保存历史记录
		if(checkValue() == false){
			return ;
		}
		var obj = document.getElementById("report_title").value;
		var submitStr = "report_title="+obj;
		obj = document.getElementById("report_date").value;
		submitStr = submitStr + "&report_date=" + obj;
		obj = document.getElementById("report_code").value;
		submitStr = submitStr + "&report_code=" + obj;
		obj = document.getElementById("report_maker").value;
		submitStr = submitStr + "&report_maker=" + obj;
		obj = document.getElementById("history_id").value;
		submitStr = submitStr + "&history_id=" + obj;
		obj = document.getElementById("org_id").value;
		submitStr = submitStr + "&org_id=" + obj;
		var retObj = jcdpCallService("QualityItemsSrv","saveEquipHistory", submitStr);
		var sql = "";
		if(retObj!=null && retObj.returnCode =='0'){
			if(retObj.history_id!=null){
				var history_id = retObj.history_id;
				sql = "update bgp_qua_monitor_equipment t set t.history_id='"+history_id+"' where t.bsflag = '0' and t.history_id is null and t.project_info_no = '"+project_info_no+"'";
				retObj = jcdpCallService("QualityItemsSrv","saveQuality", 'sql='+sql);
				if(retObj!=null && retObj.returnCode=='0'){
					alert("保存成功!");
					refresh();
				}
			}
			
		}
	}
	
	/* 计算详细标签的大小，并可以改变大小 */
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

