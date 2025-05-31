<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String orgSubId = request.getParameter("orgSubId");
	String proNo = request.getParameter("proNo");
	String deviceType = request.getParameter("deviceType");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>设备出勤率列表信息</title>
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
								<td>
								<span>自编号：</span>
								<input id="slef_num" name="slef_num" type="text"  />
								<span>牌照号：</span>
								<input id="li_num" name="li_num" type="text"  />
								
								<input type="button" value="查询" class="tongyong_box_title_button" onclick="refreshData()"/>
								<input type="button" value="清除" class="tongyong_box_title_button" onclick="cleanQuery()"/>
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
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">设备类别</td>
					<td class="bt_info_odd" exp="{dev_coding}">设备编号</td>
					<td class="bt_info_even" exp="{actual_in_time}">设备进队日期</td>
					<td class="bt_info_odd" exp="{act_out_time}">设备离队日期</td>
					<td class="bt_info_even" exp="{tcq}">设备在队时间（天数）</td>
					<td class="bt_info_odd" exp="<a href=javascript:popProDevActAtteList('{dev_acc_id}','{actual_in_time}','{act_out_time}');>{sjcq}</a>">设备出勤时间（天数）</td>
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
	cruConfig.queryService = "DeviceAtteSrv";
	cruConfig.queryOp = "queryDevAtteInfoList";
	cruConfig.pageSize="30";
	var path = "<%=contextPath%>";
	var orgSubId="<%=orgSubId%>";
	var proNo="<%=proNo%>";
	var deviceType="<%=deviceType%>";
	var startDate="<%=startDate%>";
	var endDate="<%=endDate%>";
	// 复杂查询
	function refreshData(){
		var temp = "orgSubId="+orgSubId+"&proNo="+proNo+"&deviceType="+deviceType+"&startDate="+startDate+"&endDate="+endDate+"&li_num="+$("#li_num").val()+"&slef_num="+$("#slef_num").val();
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData();
	
	
	function cleanQuery(){
	$("#slef_num").val('');
	$("#li_num").val('');
	refreshData();
	}
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	//钻取项目设备实际出勤
	function popProDevActAtteList(devAccId,startDate,endDate){
		popWindow('<%=contextPath%>/dmsManager/device/proDevActAtteList.jsp?devAccId='+devAccId+'&startDate='+startDate+'&endDate='+endDate,'800:572');
	}
</script>
</html>

