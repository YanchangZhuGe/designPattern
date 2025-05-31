<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%> 
<%
	String contextPath=request.getContextPath();
%>
		<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
							<span>闲置设备调剂池&nbsp;&nbsp;</span>
								<label for="pDzcDDorg_sub_id">物探处：</label>
								<select id="pDzcDDorg_sub_id" name="pDzcDDorg_sub_id" class="select">
									<option value="">--全部--</option>
									<option value="C105002">国际勘探事业部</option>
									<option value="C105005004">长庆物探处</option>
									<option value="C105001005">塔里木物探处</option>
						    		<option value="C105001002">新疆物探处</option>
						    		<option value="C105001003">吐哈物探处</option>
						    		<option value="C105001004">青海物探处</option>
						    		<option value="C105007">大港物探处</option>
						    		<option value="C105063">辽河物探处</option>
						    		<option value="C105005000">华北物探处</option>
						    		<option value="C105005001">新兴物探开发处</option>
						    		<option value="C105086">深海物探处</option>
						    		<option value="C105006">装备服务处</option>
						    	</select>
						    	<span>&nbsp;</span>
						    	<label for="pDzcDDcountry_1">国内/国外：</label>
								<select id="pDzcDDcountry_1" name="pDzcDDcountry_1" class="select">
									<option value="">--全部--</option>
									<option value="1">国内</option>
									<option value="2">国外</option>
						    	</select>
						    	<span>&nbsp;</span>
						    
					    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="pDzcDDtoQuery1()"/>
					    		<span>&nbsp;</span>
					    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="pDzcDDtoClear()"/>
							</div>
							<div class="tongyong_box_content_left" id="pDzcDDchartContainer1" style="height: 280px;"></div>
						</div>
					</td>
				</tr>
				
			</table>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	var pDzcDDchart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "pDzcDDchartId", "95%", "280", "0", "0" );    
	pDzcDDchart1.setXMLUrl("<%=contextPath%>/dms/device/getDeviceLie.srq");
	pDzcDDchart1.render("pDzcDDchartContainer1");
	//查询
	function pDzcDDtoQuery1(){
		var orgSubId = $('#pDzcDDorg_sub_id') .val();
		var country = $('#pDzcDDcountry_1') .val();
		country= encodeURI(encodeURI(country));
		var chartReference1 = FusionCharts("pDzcDDchartId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getDeviceLie.srq?orgSubId="+orgSubId+"&country="+country);
	}
	//清除
	function pDzcDDtoClear(){
		$('#pDzcDDorg_sub_id') .val('');
		$('#pDzcDDcountry_1') .val('');
		var chartReference1 = FusionCharts("pDzcDDchartId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getDeviceLie.srq");
	}
	//弹出子层级设备闲置情况
	function popNextLevelLie(level,devTreeId,orgSubId,country){
		popWindow('<%=contextPath%>/dmsManager/use/deviceLie/secondLevelLie.jsp?level='+level+'&devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country,'800:572');
	}
	
	
	//弹出子层级检波器设备闲置情况
	function popNextLevelJBQLie(orgSubId,country){
		popWindow('<%=contextPath%>/dmsManager/use/deviceLie/secondLevelJBQLie.jsp?orgSubId='+orgSubId+'&country='+country,'800:572');
	}
	
	//弹出设备信息
	function popDevList(devTreeId,orgSubId,country){
		popWindow('<%=contextPath%>/dmsManager/use/deviceLie/devList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'','800:572','推土机闲置情况');
	}
</script>

