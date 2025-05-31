<%@ page contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String orgSubId = request.getParameter("orgSubId");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>项目设备维修费用列表信息</title>
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
								<td>&nbsp;</td>
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
					<td class="bt_info_odd" exp="{org_abbreviation}">单位</td>
					<td class="bt_info_even" exp="{project_name}">项目</td>
					<td class="bt_info_odd" exp="<a href=javascript:popDevRepaCostList('{project_info_no}','{sub_id}')><font color='blue'>{repair_cost}</font></a>">费用(元)</td>
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
	cruConfig.queryOp = "queryProjRepaCostList";
	cruConfig.pageSize="30";
	var orgSubId="<%=orgSubId%>";
	var startDate="<%=startDate%>";
	var endDate="<%=endDate%>";
	// 复杂查询
	function refreshData(){
		var temp = "orgSubId="+orgSubId+"&startDate="+startDate+"&endDate="+endDate;
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData();
	//双击事件
	function dbclickRow(ids){	
	}
	function popDevRepaCostList(proNo,subId){
		popWindow('<%=contextPath%>/dmsManager/repair/statAnal/devRepaCostList.jsp?proNo='+proNo+'&subId='+subId+'&startDate='+startDate+'&endDate='+endDate,'800:572');
	}
</script>
</html>

