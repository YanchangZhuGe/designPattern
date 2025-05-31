<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
	
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = request.getParameter("orgSubId");
	String startDate = request.getParameter("startDate");
	if(StringUtils.isBlank(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
	}
	if(StringUtils.isBlank(startDate)){
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		startDate= year.toString();
	}
	
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/css/style.css" rel="stylesheet" type="text/css" />
		<link href="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/css/prettify.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
	 	<%@include file="/common/include/quotesresource.jsp"%>
		<title>各单位设备维修动态</title>
		<style type="text/css">
			.select {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:100px;
				height:20px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
			.input {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:85px;
				height:18px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
			.tongyong_box_title {
				width:100%;
				height:auto;
				text-align:left;
				text-indent:12px;
				font-weight:bold;
				font-size:14px;
				color:#0f6ab2;
				line-height:22px;
			}
		</style>
	</head>
	<body style="background: #cdddef; overflow-y: auto" onload="getFusionChart()">
			<table id="div_table" width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1" height="50%">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title" style="text-indent:0px;">
							  <span>&nbsp;&nbsp;</span>
								<span>物探处：</span>
								<select id="org_sub_id" name="org_sub_id" class="tongyong_box_title_select">
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
						    	<span>&nbsp;</span>
						    	<span>年份：</span>
								<input id="start_date" name="start_date" type="text" class="easyui-datebox tongyong_box_title_input" data-options="required:true,formatter:yearFormatter,parser:yearParser" editable="false"/>
					    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toQuery1()"/>
					    		<span>&nbsp;</span>
					    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toClear()"/>
								<div class="tongyong_box_content_left" id="chartContainer1" style="height: 420px;"></div>
							</div>
						</div>
					</td>
				</tr>
				<tr height="50%">
				<td>
				<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
					<td class="bt_info_even" exp="{mat_name}">物资名称</td>
					<td class="bt_info_odd" exp="{total_mat_money}">消耗金额</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 
						<label>
							<input type="text" name="textfield" id="textfield" style="width:20px;" />
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
				</td>
				</tr>
			</table>
	</body>
	<script type="text/javascript">
		 
		//调整页面宽度
		function frameSize() {
			var width = $(window).width() - 256;
			$("#tongyong_box_content_left_1").css("width", width);
		}
		$(function() {
			$(window).resize(function() {
				frameSize();
			});
		});
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "RepairStatAnalSrv";
	//cruConfig.queryOp = "querySpareConsStatList";
	cruConfig.pageSize="30";
	cruConfig.queryOp = "querySpareConsStatList";
	 // 复杂查询
	function refreshData(matType){
			var temp ;
		    var startDate= $("#start_date").datebox("getValue");
			var endDate= endDate=startDate+"-12-31";
			startDate=startDate+"-01-01";
			temp = "matType="+matType+"&orgSubId="+$('#org_sub_id').val()+"&startDate="+startDate+"&endDate="+endDate+"&token="+new Date();
		 
		cruConfig.submitStr = temp;	
		queryData(1);
	}
		//获取图表w
		function getFusionChart(){
			//初始化日期
			var iDate = new Date();
			var iStartDate = iDate.getFullYear()+"-01-01";
			var iEndDate=getCurrentDate();
			$("#start_date").datebox("setValue",iStartDate);
			//利用率图表
			getAmountWhlFusionChart();
		}
		//获取闲置情况
		function getAmountWhlFusionChart(){
			var dev_type = $('#dev_type').val();
		
		   var startDate= $("#start_date").datebox("getValue");
			var endDate= endDate=startDate+"-12-31";
			startDate=startDate+"-01-01";
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "chart1", "95%", "400", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareConsStatChartDataYear.srq?startDate="+startDate+"&endDate="+endDate+"&orgSubId="+$('#org_sub_id') .val());
			chart1.render("chartContainer1");
		
		}
		//查询
		function toQuery1(){
			 
		  	var startDate= $("#start_date").datebox("getValue");
			var endDate= endDate=startDate+"-12-31";
			startDate=startDate+"-01-01";
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/repair/getSpareConsStatChartDataYear.srq?startDate="+startDate+"&endDate="+endDate+"&orgSubId="+$('#org_sub_id') .val());
			chart1.render("chartContainer1");
			//parent.mainRightframe.location.href = "<%=contextPath%>/repair/statAnal/spareConsStatAnalYear.jsp?startDate="+startDate+"&endDate="+endDate+"&orgSubId="+$('#org_sub_id') .val();
		}
		//清除
		function toClear(){
			//初始化日期
			var iDate = new Date();
			var iStartDate = iDate.getFullYear()+"-01-01";
			var iEndDate=getCurrentDate();
			$("#start_date").datebox("setValue",iStartDate);
			$("#end_date").datebox("setValue",iEndDate);
			$('#dev_type').val('');
			//利用率图表
			getAmountWhlFusionChart();
			}
		//弹出设备信息
		function popDevList(dev_name,org_name){
		dev_name = encodeURI(dev_name);
		dev_name = encodeURI(dev_name);
		org_name = encodeURI(org_name);
		org_name = encodeURI(org_name);
			parent.mainRightframe.location.href = "<%=contextPath%>/rm/dm/deviceXZAccount/DevAccListUnUse_coll.jsp?dev_name="+dev_name+"&org_name="+org_name;
			//window.location.href='<%=contextPath%>/dmsManager/use/devAccount/devList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&flag=ttj';
			//popWindow('<%=contextPath%>/dmsManager/use/deviceLie/devList.jsp?devTreeId='+devTreeId+'&orgSubId='+orgSubId+'&country='+country+'&flag=ttj','800:572','装备闲置情况');
		}
		  
		  
	function yearFormatter(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    return y;  
	};  
  
	function yearParser(s){  
    if (!s) return new Date();  
    var y = s;  
    var date;  
    if (!isNaN(y)){  
        return new Date(y,0,1);  
    } else {  
        return new Date();  
    }  
};  
	</script>
</html>

