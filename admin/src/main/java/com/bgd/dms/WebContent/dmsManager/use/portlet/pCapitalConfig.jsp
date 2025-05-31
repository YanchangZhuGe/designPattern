<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>

<%
	String contextPath = request.getContextPath();
%>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div class="tongyong_box">
					<div class="tongyong_box_title">
						<span>设备资产配置情况&nbsp;&nbsp;</span>
					</div>
					<div class="tongyong_box_content_left" id="pCCChartContainer1" style="height:260px;"></div>
				</div>
			</td>
		</tr>
	
	</table>
	<table id="pCCLineTable" border="1" width="100%">
	</table>
	<script type="text/javascript">
		getPCCFusionChart();
		getPCCList();
		//野外采集单位资产占比
		function getPCCFusionChart(){
			var pCapConfigId = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "pCapConfigId", "97%", "260", "0", "0" );    
			pCapConfigId.setXMLUrl("<%=contextPath%>/dms/plan/devDistribute/getDeviceCapitalConfig.srq");
			pCapConfigId.render("pCCChartContainer1");
		}
		
		function getPCCList(){	
			$.ajax({
		        type:"post",
		        dataType:"xml",
		        url:"<%=contextPath%>/dms/plan/devDistribute/getDeviceCapitalConfig.srq",//xml文件路径
		        error:function(){ alert("加载文件失败！"); },
		        success: function(data){	
		            var set = $(data).find("set");     
		            var j=0;
		            var t = document.getElementById('pCCLineTable');
		            for(var i=0;i<set.length/2;i++){
		            	var value1 = set.eq(j).attr("displayValue");
		            	var value2 = set.eq(j+1).attr("displayValue");
		            	
	                    var arr1 = value1.split(",");
	                    var arr2 = null;
						if(value2 != null && value2 !="undefinded"){
						   arr2 = value2.split(",");		               
		            	}
	                   
						var tr = t.insertRow(i);
						var td = tr.insertCell(0);
						td.innerHTML = arr1[0];
					    td = tr.insertCell(1);
						td.innerHTML = set.eq(j).attr("toolText");
						td = tr.insertCell(2);
						td.innerHTML = arr2[0];
						td = tr.insertCell(3);
						td.innerHTML = set.eq(j+1).attr("toolText");
						
						j=j+2; 
		            }
		        }
		        	
		    });
		}

		
	</script>
</html>

