<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String contextPath = request.getContextPath();
	String startDate = new java.text.SimpleDateFormat("yyyy").format(new Date())+"-01-01";
	String endDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		
		<link href="/DMS/js/easyui/themes/metro-blue/easyui.css" rel="stylesheet" type="text/css" />
		<link href="/DMS/js/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
		<link href="/DMS/js/easyui/themes/font/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
		<link href="/DMS/js/easyui/themes/metro-blue/validatebox.css" rel="stylesheet" type="text/css" media="screen"/>
		<script type="text/javascript" src="/DMS/js/easyui/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="/DMS/js/easyui/locale/easyui-lang-zh_CN.js"></script>
		<script type="text/javascript" src="/DMS/js/easyui/common_util.js"></script>
		<title>备件消耗占比</title>
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
								<span>物探处：</span>
								<select id="org_sub_id_1" name="org_sub_id" class="tongyong_box_title_select">
								<%
									if("C105".equals(orgId)){
								%>
									<option value="">全部</option>
								<%
									}
									if("C105".equals(orgId)){
										for(int i=0;i<DevUtil.orgNameList.size();i++){
											String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
								%>
											<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
								<%
										}
									}else{
										for(int i=0;i<DevUtil.orgNameList.size();i++){
											if(DevUtil.orgNameList.get(i).indexOf(orgId)>=0){
												String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
								%>
									<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
								<%
											}
										}
									}
								%>
						    	</select>
								<span>数据来源：</span>
								<select id="data_source" name="data_source" class="select">
									<option value="">全部</option>
									<option value="SAP">ERP</option>
									<option value="XMGL">项目管理系统</option>
						    	</select>
						    	<span>消耗时间：</span>
 							    <input type="text" name="start_date" id="start_date" value="<%=startDate%>" class="easyui-datebox input" editable="false"/>
 							    -
 							    <input type="text" name="end_date" id="end_date" value="<%=endDate%>" class="easyui-datebox input" editable="false"/>
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
			getSpareConsumeFusionChart();
		}
		//获取备件库存占比
		function getSpareConsumeFusionChart(){
			var startDate = $('#start_date').datebox('getValue');
			var endDate = $('#end_date').datebox('getValue');
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "97%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareConsumeChartData.srq?flag=Y&startDate="+startDate+"&endDate="+endDate+"&orgSubId="+$("#org_sub_id_1").val());
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery(){
			var orgSubId=$('#org_sub_id').val();
			var dataSource=$('#data_source').val();
			var startDate = $('#start_date').datebox('getValue');
			var endDate = $('#end_date').datebox('getValue');
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareConsumeChartData.srq?flag=Y&orgSubId="+orgSubId+"&dataSource="+dataSource+"&startDate="+startDate+"&endDate="+endDate+"&orgSubId="+$("#org_sub_id_1").val());
			parent.bottomframe.refreshData(orgSubId,"",dataSource,startDate,endDate);//调用buttonframe的查询列表函数
		}
		//清除
		function toClear(){
			$('#org_sub_id').val('');
			$('#org_name').val('');
			$('#data_source').val('');
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareConsumeChartData.srq?flag=Y");
		}
		//弹出设备信息
		function popSpareConsumeList(matType,orgSubId,dataSource,startDate,endDate){
			parent.bottomframe.location.href = "<%=contextPath%>/dmsManager/repair/spare/spare_consume_list.jsp?matType="+matType+"&orgSubId="+orgSubId+"&dataSource="+dataSource+"&startDate="+startDate+"&endDate="+endDate;
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

