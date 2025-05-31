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
								<span>设备利用率&nbsp;</span>
								<span>&nbsp;设备类型：</span>
								<input id="ajglyldbdev_type" name="ajglyldbdev_type" type="text"  readonly/>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevTypeTreePage()"  />
								<input id="ajglyldbdev_type_id" name="ajglyldbdev_type_id" class="" type="hidden" />
						    	<span>&nbsp;开始时间：</span>
								<input  id="ajglyldbdate_1_1" name="start_date" type="text" class="input" readonly="readonly"/>
							    <img width="18" height="16" id="ajglyldbcal_button_1_1" style="cursor: hand;" 
					    		onmouseover="calDateSelector(ajglyldbdate_1_1,ajglyldbcal_button_1_1);" src="<%=contextPath%>/images/calendar.gif" />
					    		<span>&nbsp;结束时间：</span>
								<input  id="ajglyldbdate_1_2" name="end_date" type="text" class="input" readonly="readonly"/>
							    <img width="18" height="16" id="ajglyldbcal_button_1_2" style="cursor: hand;" 
					    		onmouseover="calDateSelector(ajglyldbdate_1_2,ajglyldbcal_button_1_2);" src="<%=contextPath%>/images/calendar.gif" />
					    		<span>&nbsp;</span>
					    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="ajglyldbtoQuery1()"/>
					    		<span>&nbsp;</span>
					    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="ajglyldbtoClear()"/>
							</div>
							<div class="tongyong_box_content_left" id="ajglyldbchartContainer" style="height: 280px;"></div>
						</div>
					</td>
				</tr>
				
			</table>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	$('#ajglyldbdate_1_1') .val(new Date().getFullYear()+"-01-01");
	$('#ajglyldbdate_1_2') .val(getCurrentDate());
	getAJGLYLDBFusionChart();
	function getAJGLYLDBFusionChart(){
		var ajglyldbchart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "ajglyldbcId", "95%", "280", "0", "0" );    
		ajglyldbchart1.setXMLUrl("<%=contextPath%>/dms/device/getUseRateForOrg.srq");
		ajglyldbchart1.render("ajglyldbchartContainer");
	}
	//查询
	function ajglyldbtoQuery1(){
		var dev_type_id = $('#ajglyldbdev_type_id') .val();
		var startDate= $('#ajglyldbdate_1_1') .val();
		var endDate= $('#ajglyldbdate_1_2') .val();
		var chartReference1 = FusionCharts("ajglyldbcId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getUseRateForOrg.srq?dev_type_id="+dev_type_id+"&startDate="+startDate+"&endDate="+endDate);
	}
	//清除
	function ajglyldbtoClear(){
		$('#ajglyldbdev_type_id') .val('');
		$('#ajglyldbdev_type') .val('');
		$('#ajglyldbdate_1_1') .val('');
		$('#ajglyldbdate_1_2') .val('');
		var chartReference1 = FusionCharts("ajglyldbcId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getUseRateForOrg.srq");
	}
	//弹出子层级利用率
	function popNextLevelUseRate(level,devTreeId,orgSubId,country,startDate,endDate){
		popWindow('<%=contextPath%>/dmsManager/device/secondLevelUseRate.jsp?level='+level+'&devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&startDate='+startDate+'&endDate='+endDate,'800:572');
	}
	//弹出设备信息
	function popDevList(devTreeId,orgSubId,country,startDate,endDate){
		popWindow('<%=contextPath%>/dmsManager/device/devList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&startDate='+startDate+'&endDate='+endDate+'&flag=userate','800:572');
	}
	
	  /**
	 * 选择设备类型树
	 */
	 
	function showDevTypeTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/dmsManager/use/devOrgUseRate/selectDevTypeSub.jsp",returnValue,"");
		document.getElementById("ajglyldbdev_type").value = returnValue.value;
		
		//var orgId = strs[1].split(":");
		document.getElementById("ajglyldbdev_type_id").value = returnValue.fkValue;
	}
</script>

