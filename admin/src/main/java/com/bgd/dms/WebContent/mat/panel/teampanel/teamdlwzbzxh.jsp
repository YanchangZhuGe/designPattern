<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	String date = request.getParameter("date");
	String lable = request.getParameter("lable");
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

window.gudingbiaotou='true';
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	$("#table_box").css("height",$(window).height()*0.85);
	//setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
function refreshData(){
	getTeamName();
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "getTeambzList";
	cruConfig.submitStr ="value=<%=date%>&projectInfoNo=<%=projectInfoNo%>";
	queryData(1);
	
}
function getTotalMoney(){
	var num= 0;
	var tab = document.getElementById("queryRetTable");
	var rows = tab.rows;
	for(var i=1;i<rows.length;i++){
		cells = rows[i].cells;
		var planMoney = 0;
		if(cells[6].innerHTML !='&nbsp;'){
			planMoney = cells[6].innerHTML;
		}
		num -=(-planMoney);
	}
	document.getElementById("total_money").value=Math.round((num)*1000)/1000;
	}

/**
 * 获得班组名称,赋值给标题
 */
function getTeamName(){
	var ret = jcdpCallService("MatItemSrv", "getCodeName", "codeId=<%=date%>");
	if(ret!=null){
	 	document.getElementById("team_title").innerText=ret.code_name+"物资消耗情况"
	}
}

function exportDataDoc(exportFlag){
	//调用导出方法
	var path = cruConfig.contextPath+"/mat/common/MatToExcel.srq";
	var submitStr="";
	//各班组物资消耗情况
	if("gbzwzxh"==exportFlag){
		submitStr="teamId=<%=date%>&projectInfoNo=<%=projectInfoNo%>&matFlag="+exportFlag;
	}
	
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
<body onload="refreshData();getTotalMoney()" style="background:#fff">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"
									width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>&nbsp;</td>
										<td class="ali_cdn_name">合计金额(元):</td>
								 	    <td class="ali_cdn_input"><input class="input_width" id="total_money" name="total_money" type="text" readonly/></td>
									</tr>
								</table>
								</td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png"
									width="4" height="36" /></td>
							</tr>
						</table>
						</div>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a id="team_title" href="#">各班组物资消耗情况 </a>
							<span class="dc" style="float:right;margin-top:-4px;">
										<a href="#" onclick="exportDataDoc('gbzwzxh')" title="导出excel"></a>
							</span>	
						</div>
<!-- 						<div class="tongyong_box_content_left" style="height: 365px;"> -->
							<div id="list_table">
										<div id="table_box">
										  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
										    <tr>
										      <td class="bt_info_odd" exp="{coding_code_id}" >物料组</td>
										      <td class="bt_info_even" exp="{wz_id}">物料编码</td>
										      <td class="bt_info_odd" exp="{wz_name}" >物料描述</td>
										      <td class="bt_info_even" exp="{wz_prickie}" >计量单位</td>
										      <td class="bt_info_odd" exp="{actual_price}" >单价</td>
										      <td class="bt_info_even" exp="{mat_num}" >数量</td>
										      <td class="bt_info_odd" exp="{total_money}" >金额(元)</td>
										      <td class="bt_info_even" exp="{outmat_date}" >发放日期</td>
										    </tr>
										  </table>
										</div>
										<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
										 
										</table>
										</div>
							</div>
						</div>
<!-- 						</div> -->
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>
</body>
</html>