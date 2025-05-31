<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="${pageContext.request.contextPath}/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<title>设备分布分析</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
		<div id="list_content">
			<table id="div_table" width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>公司设备占比</span>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1"></div>
						</div>
					</td>
				</tr>
			</table>
			<table id="lineTable" border="1" align="center" width="100%" class="tab_info">
			</table>
		</div>
	</body>
	<script type="text/javascript">
		//调整页面高度
		function frameSize() {
			var height=$(window).height()-$("#tongyong_box_title").height()-$("#lineTable").height()-100;
			$("#chartContainer1").css("height", height);
		}
		$(function() {
			frameSize();
			$(window).resize(function() {
				frameSize();
			});
		});
		//获取图表
		function getFusionChart(){
			//野外采集单位资产占比
			getFieldCaptialFusionChart();
			getData();
			
		}
		//野外采集单位资产占比
		function getFieldCaptialFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDeviceCompanyRate.srq");
			chart1.render("chartContainer1");
		}
		
		function getData(){
			$.ajax({
		        type:"post",
		        dataType:"xml",
		        url:"<%=contextPath%>/dms/plan/devDistribute/getDeviceCompanyRate.srq",//xml文件路径
		        error:function(){ alert("加载文件失败！"); },
		        success: function(data){	
		            var set = $(data).find("set");     
		            var t = document.getElementById('lineTable');
		            for(var i=0;i<set.length;i++){
		            	var value1 = set.eq(i).attr("displayValue");
	                    var arr1 = value1.split(",");	                       
	                    var tr = t.insertRow(i);
						var td = tr.insertCell(0);
						td.innerHTML = arr1[0];
					    td = tr.insertCell(1);
						td.innerHTML = set.eq(i).attr("toolText");
						td = tr.insertCell(2);
		            }
		        }
		    });
		}
		
		function getList(){	
			var retObj = jcdpCallService("DeviceDistributeSrv","getDeviceCompanyRate","");
			var t = document.getElementById('lineTable');
			if(retObj.list != null){	
				for(var i=0;i<retObj.list.length;i++){
					var tr = t.insertRow(i);
					var td = tr.insertCell(0);
					td.innerHTML = retObj.list[i].label;
				    td = tr.insertCell(1);
					td.innerHTML = retObj.list[i].asset_value;
				}    
			}
		}
		
	</script>
</html>

