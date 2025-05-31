<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<title>备件库存占比</title>
		<style type="text/css">
			.input {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:150px;
				height:18px;
				line-height:18px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
			.select {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:120px;
				height:22px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
		</style>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div>
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>所属单位：</span>
								<input id="org_name" name="org_name" type="text" class="input" readonly="readonly"/>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
								<input id="org_sub_id" name="org_sub_id" class="" type="hidden" />
								<span>数据来源：</span>
								<select id="data_source" name="data_source" class="select">
									<option value="">全部</option>
									<option value="SAP">ERP</option>
									<option value="XMGL">项目管理系统</option>
						    	</select>
						    	<input type="button" value="查询" class="input" style="width:45px;height:25px;" onclick="toQuery()"/>
					    		<input type="button" value="清除" class="input" style="width:45px;height:25px;" onclick="toClear()"/>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1" style="height: 260px;"></div>
						</div>
					</td>
				</tr>
				
			</table>
		</div>
	</body>
	<script type="text/javascript">
		//获取图表
		function getFusionChart(){
			//备件库存占比
			getSpareStockFusionChart();
		}
		//获取备件库存占比
		function getSpareStockFusionChart(){
			 
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "97%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareStockChartData.srq?flag=Y");
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery(){
			var orgSubId=$('#org_sub_id').val();
			var dataSource=$('#data_source').val();
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareStockChartData.srq?flag=Y&orgSubId="+orgSubId+"&dataSource="+dataSource);
			parent.bottomframe.refreshData(orgSubId,"",dataSource);//调用buttonframe的查询列表函数
		}
		//清除
		function toClear(){
			$('#org_sub_id').val('');
			$('#org_name').val('');
			$('#data_source').val('');
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareStockChartData.srq?flag=Y");
		}
		//弹出设备信息
		function popSpareStockList(matType,orgSubId,dataSource){
			//popWindow('<%=contextPath%>/dmsManager/device/devList.jsp?matType='+matType+'&orgSubId='+orgSubId+'&dataSource='+dataSource,'800:572');
			parent.bottomframe.location.href = "<%=contextPath%>/dmsManager/repair/spare/spare_stock_list.jsp?matType="+matType+"&orgSubId="+orgSubId+"&dataSource="+dataSource;
		}
		//选择组织机构树
		function showOrgTreePage(){
			var returnValue={
				fkValue:"",
				value:""
			};
			window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
			document.getElementById("org_name").value = returnValue.value;
			document.getElementById("org_sub_id").value = returnValue.fkValue;
		}
	</script>
</html>

