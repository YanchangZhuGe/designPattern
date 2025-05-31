<%@ page contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String matType = request.getParameter("matType");
	String matCode = request.getParameter("matCode");
	String orgSubId = request.getParameter("orgSubId");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	String flag = request.getParameter("flag");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>备件消耗统计列表信息</title>
</head>

<body style="background:#cdddef">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							<td>	<span class="dc" style="float:right;margin-top:-4px;">
								<a href="####" onclick="exportDataDoc()" title="导出excel"></a>	
								</span>
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
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{mat_code}">物资编码</td>
					<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
					<td class="bt_info_even" exp="{mat_name}">物资名称</td>
					<td class="bt_info_odd" exp="{total_mat_money}">消耗金额</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()- $("#fenye_box").height()-2);
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	});
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "RepairStatAnalSrv";
	//cruConfig.queryOp = "querySpareConsStatList";
	cruConfig.pageSize="30";
	var matType="<%=matType%>";
	var matCode="<%=matCode%>";
	var orgSubId="<%=orgSubId%>";
	var startDate="<%=startDate%>";
	var endDate="<%=endDate%>";
	var flag="<%=flag%>";
	if("list"==flag){
		cruConfig.queryOp = "querySpareConsStatList";
	}
	if("clist"==flag){
		cruConfig.queryOp = "queryCSpareConsStatList";
	}
	// 复杂查询
	function refreshData(){
		var temp ;
		if("list"==flag){
			temp = "matType="+matType+"&orgSubId="+orgSubId+"&startDate="+startDate+"&endDate="+endDate;
		}
		if("clist"==flag){
			temp = "matCode="+matCode+"&orgSubId="+orgSubId+"&startDate="+startDate+"&endDate="+endDate;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData();
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	function exportDataDoc(){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		submitStr = "matCode="+matCode+"&orgSubId="+orgSubId+"&startDate="+startDate+"&endDate="+endDate+"&exportFlag=bjxhtj";
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

