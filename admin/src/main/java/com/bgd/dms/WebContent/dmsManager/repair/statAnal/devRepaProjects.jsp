<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubId = user.getSubOrgIDofAffordOrg();
 
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
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title" style="text-indent:0px;">
						    	<span>&nbsp;</span>
						    	<span>年份：</span>
								<input id="start_date" name="start_date" type="text" class="easyui-datebox tongyong_box_title_input" data-options="required:true,formatter:yearFormatter,parser:yearParser" editable="false"/>
					    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toQuery1()"/>
					    		<span>&nbsp;</span>
					    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toClear()"/>
								<div class="tongyong_box_content_left" id="chartContainer1" style="height: 220px;"></div>
							</div>
						</div>
					</td>
				</tr>
				
			</table>
	</body>
	<script type="text/javascript">
		var orgsubId='<%=orgsubId%>';
		//调整页面宽度
		function frameSize() {
			var height=$(window).height()-$("#tongyong_box_title").height()-50;
			$("#chartContainer1").css("height", height);
		}
		$(function() {
			frameSize();
			$(window).resize(function() {
				frameSize();
			});
		});
		//获取图表w
		function getFusionChart(){
			//初始化日期
			var iDate = new Date();
			var iStartDate = iDate.getFullYear()+"-01-01";
			$("#start_date").datebox("setValue",iStartDate);
			//利用率图表
			getAmountWhlFusionChart();
		}
		//获取闲置情况
		function getAmountWhlFusionChart(){
		    var startDate= $("#start_date").datebox("getValue");
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "95%", "95%", "0", "0" );    
			if(orgsubId=='C105'){
				chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDevReoaProjects.srq?startDate="+startDate);
			}else{
				chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDevReoaProjectsWUTAN.srq?startDate="+startDate);
			}
			chart1.render("chartContainer1");
			parent.mainRightframe.location.href = "<%=contextPath%>/repair/statAnal/devRepaProjects.jsp";
		
		}
		//查询
		function toQuery1(){
			var startDate= $("#start_date").datebox("getValue");
			var chartReference1 = FusionCharts("chart1"); 
			if(orgsubId=='C105'){
			chartReference1.setXMLUrl("<%=contextPath%>/rm/dm/getDevReoaProjects.srq?startDate="+startDate);
			}else{
			chartReference1.setXMLUrl("<%=contextPath%>/rm/dm/getDevReoaProjectsWUTAN.srq?startDate="+startDate);
			}
			parent.mainRightframe.location.href = "<%=contextPath%>/repair/statAnal/devRepaProjects.jsp";
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
		function popDevList(project_id){
		 var startDate=$('#start_date').datebox('getValue')+'-01-01';
		 var endDate=$('#start_date').datebox('getValue')+'-12-30';
		popWindow('<%=contextPath%>/dmsManager/repair/statAnal/repairTypeAnalProject.jsp?project_id='+project_id+'&startDate='+startDate+'&endDate='+endDate,'1000:672');
		
		}
		  /**
		 * 选择设备类型树
		 */
		 
		function showDevTypeTreePage(){
			var returnValue={
				fkValue:"",
				value:""
			}
			window.showModalDialog("<%=contextPath%>/rm/dm/deviceXZAccount/selectDevTypeSub.jsp",returnValue,"");
			var  innerHtml="";
			$("#dev_type_name").html("");
			 var selectedProjects=returnValue.value;
				var typename = selectedProjects.split(",");
			 for(var i=0;i<typename.length;i++ ){
			
			    innerHtml+="<option>"+typename[i]+"</option>";
			 }
			$("#dev_type_name").append(innerHtml);
			//var orgId = strs[1].split(":");
			document.getElementById("dev_type_id").value = returnValue.fkValue;
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

