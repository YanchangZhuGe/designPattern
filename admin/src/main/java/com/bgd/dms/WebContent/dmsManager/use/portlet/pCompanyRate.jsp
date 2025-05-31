<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>

<%
	String contextPath = request.getContextPath();
%>

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>公司设备占比&nbsp;&nbsp;</span>
							</div>
							<div class="tongyong_box_content_left" id="pCRChartContainer1" style="height:260px;"></div>
						</div>
					</td>
				</tr>

			</table>
			<table id="pCRLineTable" border="1" width="100%" >
			</table>

	<script type="text/javascript">
		//野外采集单位资产占比
		getPCRFusionChart();
		getPCRList();
		//野外采集单位资产占比
		function getPCRFusionChart(){
			var comRateId = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "comRateId", "97%", "260", "0", "0" );    
			comRateId.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDeviceCompanyRate.srq");
			comRateId.render("pCRChartContainer1");
		}
		
		function getPCRList(){	
			$.ajax({
		        type:"post",
		        dataType:"xml",
		        url:"<%=contextPath%>/dms/plan/devDistribute/getDeviceCompanyRate.srq",//xml文件路径
		        error:function(){ alert("加载文件失败！"); },
		        success: function(data){	
		            var set = $(data).find("set");     
		            var t = document.getElementById('pCRLineTable');
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
		
	</script>
</html>

