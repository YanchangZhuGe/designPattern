<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr id="tr_1">
		<td colspan="3" align="center" >
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span>新度系数&nbsp;</span>
					<span>&nbsp;物探处：</span>
					<select id="pdne_org_sub_id" name="org_sub_id" class="select">
						<option value="">全部</option>
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
			    	<span>&nbsp;国内/国外：</span>
					<select id="pdne_country" name="country" class="select">
						<option value="">全部</option>
						<option value="1">国内</option>
						<option value="2">国外</option>
			    	</select>
		    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toPDNEQuery()"/>
		    		<span>&nbsp;</span>
		    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toPDNEClear()"/>
				</div>
				<div class="tongyong_box_content_left" id="pdneChartContainer" style="height: 400px;"></div>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	getPDNEFusionChart();
	function getPDNEFusionChart(){
		var pdneChartId = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "pdneId", "95%", "400", "0", "0" );    
		pdneChartId.setXMLUrl("<%=contextPath%>/dms/device/getNewExtent.srq");
		pdneChartId.render("pdneChartContainer");
	}
	//查询
	function toPDNEQuery(){
		var orgSubId = $('#pdne_org_sub_id') .val();
		var country = $('#pdne_country') .val();
		var chartReference1 = FusionCharts("pdneId"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getNewExtent.srq?orgSubId="+orgSubId+"&country="+country);
	}
	//清除
	function toPDNEClear(){
		$('#pdne_org_sub_id') .val('');
		$('#pdne_country') .val('');
		var chartReference1 = FusionCharts("chart1"); 
		chartReference1.setXMLUrl("<%=contextPath%>/dms/device/getNewExtent.srq");
	}
	//弹出子层级新度系数
	function popNextLevelNewExtent(level,devTreeId,orgSubId,country){
		popWindow('<%=contextPath%>/dmsManager/device/secondLevelNewExtent.jsp?level='+level+'&devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country,'800:572');
	}
	//弹出设备信息
	function popDevList(devTreeId,orgSubId,country){
		popWindow('<%=contextPath%>/dmsManager/device/devList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&flag=newrate','800:572');
	}
</script>
</html>

