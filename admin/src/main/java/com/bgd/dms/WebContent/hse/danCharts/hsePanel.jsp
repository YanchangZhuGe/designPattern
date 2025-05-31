<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/hse/danCharts/panel.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>

</head>
<body style="background: #fff; overflow-y: auto" onload="">
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
							<div class="tongyong_box">
							<div class="tongyong_box_title"><span class="kb"> </span><a href="#">职业健康状况</a></div>
							<div class="tongyong_box_content_left">
							<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="tab_info">
								<tr>
									<th rowspan="2">职业健康体检率</th>
									<th colspan="3">职业病危害作业场所</th>
									<th colspan="2">职业病危害作业场所检测率</th>
									
								</tr>
								<tr>
									<th>总数</th>
									<th>固定场所</th>
									<th>接害人员</th>
									<th>集团指标</th>
									<th>当前值</th>
								</tr>
								<tr class="odd_panel">
									<td>3</td>
									<td>4</td>
									<td>5</td>
									<td>6</td>
									<td>7</td>
									<td>8</td>
								</tr>
								<tr class="even_panel">
									<td>3</td>
									<td>4</td>
									<td>5</td>
									<td>6</td>
									<td>7</td>
									<td>8</td>
								</tr>
							</table>
						</div>
						</div>
						</td>
						</tr>
						<tr>
							<td height="10px"></td>
						</tr>
						<tr>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"> </span><a href="#">预警情况</a></div>
						<div class="tongyong_box_content_left" style="height: auto;">
							<table width="100%" border="1" bordercolor="black" cellspacing="0" cellpadding="0"class="tab_info"  style="background: #a4c7ff;">
								<tr>
									<th>事件等级</th>
									<th>死亡事故</th>
									<th>重伤事故</th>
									<th>轻伤事故</th>
									<th>工作受限</th>
									<th>医疗处置</th>
									<th>急救事件</th>
									<th>未遂事件</th>
									<th>财产损失事故</th>
								</tr>
								<tr class="odd_panel">
									<td>数量</td>
									<td>11</td>
									<td>22</td>
									<td>33</td>
									<td>44</td>
									<td>55</td>
									<td>66</td>
									<td>77</td>
									<td>88</td>
								</tr>
							</table>	   
						</div>
						</div>
						</td>
						
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td height="10px"></td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"> </span><a href="#">百万工时统计</a></div>
						<div class="tongyong_box_content_left" style="height: auto;">
							<table width="100%" border="1" bordercolor="black" cellspacing="0" cellpadding="0"class="tab_info"  style="background: #a4c7ff;">
								<tr>
									<th colspan="2">FTLR(百万工时死亡率)</th>
									<th colspan="2">LTIF(百万工时损工伤亡发生率)</th>
									<th colspan="2">TRCF(百万工时可记录事件人数发生率)</th>
								</tr>
								<tr>
									<th>集团指标</th>
									<th>实际</th>
									<th>集团指标</th>
									<th>实际</th>
									<th>集团指标</th>
									<th>实际</th>
								</tr>
								<tr class="odd_panel">
									<td>0.024</td>
									<td></td>
									<td>015</td>
									<td></td>
									<td>1.1</td>
									<td></td>
								</tr>
							</table>	   
						</div>
						</div>
						</td>
						</tr>
						<tr>
							<td height="10px"></td>
						</tr>
						<tr>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"> </span><a href="#">环境</a></div>
						<div class="tongyong_box_content_left" style="height: auto;">
							<table width="100%" border="1" bordercolor="black" cellspacing="0" cellpadding="0"class="tab_info"  style="background: #a4c7ff;">
								<tr>
									<th rowspan="2">生活源排污口</th>
									<th rowspan="2">工业源排污口</th>
									<th colspan="2">工业源COD</th>
									<th rowspan="2">水处理设施总数(台)</th>
									<th colspan="4">锅炉烟气处理设施</th>
								</tr>
								<tr>
									<th>集团指标</th>
									<th>当前值</th>
									<th>总数</th>
									<th>燃煤锅炉(个)</th>
									<th>燃气锅炉(个)</th>
									<th>运行情况</th>
								</tr>
								<tr class="odd_panel">
									<td>1</td>
									<td>2</td>
									<td>3</td>
									<td>4</td>
									<td>5</td>
									<td>6</td>
									<td>7</td>
									<td>8</td>
									<td>9</td>
								</tr>
							</table>	   
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
		<td width="1%"></td>
	</tr>
</table>
</div>
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

