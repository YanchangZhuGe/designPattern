<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>项目列表</title>
<script language="javaScript">

function frameSize(){
	$("#table_box").css("height",$(window).height()*0.85);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})
var projectInfoNo = "<%=projectInfoNo%>";
cruConfig.contextPath =  "<%=contextPath%>";
function refreshData(){
	var start_date = document.getElementById("start_date").value;
	var end_date   = document.getElementById("end_date").value;
	var s_license_num = document.getElementById("s_license_num").value;
	var sql ='';
	debugger;
		sql +="select * from (select a.dev_acc_id,a.dev_name,a.dev_type,a.actual_in_time,a.dev_model,a.self_num,a.dev_sign,a.license_num,a.oilnum,a.mileage,a.drillingfootage,a.workhour,sum(a.daigongnum) daigongnum,sum(a.jianxiunum) jianxiunum,sum(a.kaoqin) chuqinnum,";
		sql +=" case when a.dev_type is null then 0 when (substr(a.dev_type,0,3)='S08' and a.mileage!=0) then trunc((a.oilnum/a.mileage*100),3) when (substr(a.dev_type,0,5)='S0622' and a.mileage!=0) then trunc((a.oilnum/a.mileage*100),3) when (substr(a.dev_type,0,5)='S0601' and a.drillingfootage !=0) then trunc((a.oilnum/a.drillingfootage),3) when (substr(a.dev_type,0,5)='S0623' and a.workhour !=0) then trunc((a.oilnum/a.workhour),3) when (substr(a.dev_type,0,5)='S0901' and a.workhour !=0) then trunc((a.oilnum/a.workhour),3) else 0 end dwyh"; 
		sql +=" from (";
		sql +=" select  b.dev_acc_id, b.dev_type, b.dev_name,b.actual_in_time, b.dev_model, b.self_num, b.dev_sign, b.license_num,b.mileage,b.drillingfootage,b.workhour,b.daigongnum,b.jianxiunum,b.kaoqin, (case when sum(doi.oil_quantity) is null then 0 else sum(doi.oil_quantity) end + case when sum(oil.oil_num) is null then 0 else sum(oil.oil_num) end) oilnum from (select dui.dev_acc_id,dui.dev_type,dui.dev_name,dui.actual_in_time,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num,"; 
		sql +=" case when sum(gdo.mileage) is null then 0 else sum(gdo.mileage) end mileage,";
		sql +=" case when sum(gdo.drilling_footage) is null then 0 else sum(gdo.drilling_footage) end drillingfootage,";
		sql +=" case when sum(gdo.work_hour) is null then 0 else sum(gdo.work_hour) end workhour,";
		sql +=" decode(sd.coding_name,'待工',sumnum,0) as daigongnum,";
		sql +=" decode(sd.coding_name,'检修',sumnum,0) as jianxiunum,decode(sd.coding_name, '出勤', sumnum, 0) as kaoqin"; 
		sql +=" from (select device_account_id,timesheet_symbol ,count(1) as sumnum ";
		sql +=" from bgp_comm_device_timesheet where bsflag = '0' ";
		if(start_date!=""){
			sql +=" and timesheet_date>=to_date('"+start_date+"','yyyy-mm-dd')";
		}
		if(end_date!=""){
			sql +=" and timesheet_date<=to_date('"+end_date+"','yyyy-mm-dd')";
		}
		sql +=" group by device_account_id,timesheet_symbol ) tmp"; 
		sql +=" join comm_coding_sort_detail sd on tmp.timesheet_symbol=sd.coding_code_id  ";
		sql +=" join gms_device_account_dui dui on tmp.device_account_id=dui.dev_acc_id  ";
		sql +=" left join GMS_DEVICE_OPERATION_INFO gdo on tmp.device_account_id = gdo.dev_acc_id"; 
		sql +=" where dui.project_info_id='"+projectInfoNo+"' and dui.bsflag = '0' ";
		if(s_license_num!=""){
			sql +=" and dui.license_num='"+s_license_num+"' ";
		}
		sql +=" group by dui.dev_acc_id,sd.coding_name,sumnum,sd.coding_name,sumnum,dui.dev_name,dui.dev_type,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num,dui.actual_in_time )b"; 
		sql +=" left join bgp_comm_device_oil_info doi on b.dev_acc_id = doi.device_account_id ";
		sql +=" left join (select tod.dev_acc_id ,case when sum(tod.oil_num) is null then 0 else sum(tod.oil_num) end oil_num"; 
		sql +=" from gms_mat_teammat_out mto left join GMS_MAT_TEAMMAT_OUT_DETAIL tod on mto.teammat_out_id= tod.teammat_out_id and tod.bsflag='0'"; 
		sql +=" where mto.bsflag='0' and mto.out_type='3' group by tod.dev_acc_id ) oil on b.dev_acc_id = oil.dev_acc_id ";
		sql +=" group by b.dev_acc_id, b.dev_type, b.dev_name,b.actual_in_time, b.dev_model, b.self_num, b.dev_sign, b.license_num,b.mileage,b.drillingfootage,b.workhour,b.daigongnum,b.jianxiunum,b.kaoqin"; 
		sql +=" )a ";
		sql +=" group by a.dev_acc_id,a.dev_name,a.dev_type,a.dev_model,a.self_num,a.dev_sign,a.actual_in_time ,a.license_num,a.oilnum,a.mileage,a.drillingfootage,a.workhour)bb order by bb.dev_type,bb.actual_in_time desc";
		
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/panel/wtcwycz.jsp";
	queryData(1);
}

function exportDataDoc(exportFlag){
	//调用导出方法
	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
	var start_date=$("#start_date").val();
	var end_date=$("#end_date").val();
	var s_license_num=$("#s_license_num").val();
	var submitStr = "projectInfoNo=<%=projectInfoNo%>&exportFlag="+exportFlag+"&start_date="+start_date+"&end_date="+end_date+"&s_license_num="+s_license_num;
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
</head>
<body onload="refreshData()" style="background:#cdddef">
		<div id="list_table">
			<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<input type="hidden" id="hse_danger_id" name="hse_danger_id"></input>
					<tr>
						<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
						<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						<td class="ali_cdn_name">开始时间</td>
						<td class="ali_cdn_input"><input id="start_date" name="start_date" type="text" /></td>
						<td class="ali_cdn_name">结束时间</td>
						<td class="ali_cdn_input"><input id="end_date" name="end_date" type="text" /></td>
						<td class="ali_cdn_name">牌照号</td>
						<td class="ali_cdn_input"><input id="s_license_num" name="s_license_num" type="text" /></td>
						<td class="ali_query">
						<span class="cx"><a href="#" onclick="refreshData()" title="JCDP_btn_query"></a></span>
						</td>
						<td class="ali_query">
						<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
						</td>
						
						<td>&nbsp;</td>
						<td class="ali_btn">
						    <span class="dc"><a href="#" onclick="exportDataDoc('dzdjxsbkqjyhtj')" title="导出excel"></a></span>
					    </td>
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
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{dev_name}">设备名称</td>
			      <td class="bt_info_odd" exp="{dev_model}" >规格型号</td>
			      <td class="bt_info_even" exp="{self_num}" >自编号</td>
			      <td class="bt_info_odd" exp="{dev_sign}" >实物标识号</td>
			      <td class="bt_info_even" exp="{license_num}" >牌照号</td>
			      <td class="bt_info_odd" exp="{chuqinnum}" >出勤天数</td>
			      <td class="bt_info_even" exp="{daigongnum}" >待工天数</td>
			      <td class="bt_info_odd" exp="{jianxiunum}" >检修天数</td>
			      <td class="bt_info_even" exp="{oilnum}" >油耗累计(升)</td>
			      <td class="bt_info_odd" exp="{workhour}" >工作小时累计</td>
			      <td class="bt_info_even" exp="{drillingfootage}" >钻井进尺累计</td>
			      <td class="bt_info_odd" exp="{mileage}" >行驶里程累计</td>
			      <td class="bt_info_even" exp="{dwyh}" >单位油耗</td>
			      
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
			<div id="tab_box" class="tab_box"></div>
</div>
</body>
</html>