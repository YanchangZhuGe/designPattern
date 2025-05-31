<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #C0E2FB; overflow-y: auto" >
	<table width="100%" cellspacing="0" cellpadding="0" class="tab_info" >
		<tr class="bt_info">
			<td colspan="3">职业病危害作业场所</td>
			<td colspan="2">职业健康体检率</td>
			<td colspan="2">职业病危害作业场所检测率</td>
			
		</tr>
		<tr class="bt_info">
			<td>总数</td>
			<td>固定场所</td>
			<td>接害人员</td>
			<td width="14%">集团指标</td>
			<td width="14%">当前值</td>
			<td width="14%">集团指标</td>
			<td width="14%">当前值</td>
		</tr>
		<tr class="even">
			<td>0</td>
			<td>0</td>
			<td>0</td>
			<td>100%</td>
			<td>-</td>
			<td>-</td>
			<td>-</td>
		</tr>
	</table>
</body>
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

