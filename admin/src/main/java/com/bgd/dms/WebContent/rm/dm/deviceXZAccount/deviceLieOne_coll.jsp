<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/css/style.css" rel="stylesheet" type="text/css" />
		<link href="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/css/prettify.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/prettify.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/json2.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
		<title>设备资源池</title>
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
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
							<!-- <label for="org_sub_id_1">设备类型qqqqqqq：</label>
							<select style="width:120px;" id="dev_type_name"
													name="dev_type_name">
														<option value=""></option>
												</select> 
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevTypeTreePage()"  />
								<input id="dev_type_id" name="dev_type_id" class="" type="hidden" /> -->
						    	<span>&nbsp;</span>
						    	<label for="country_1">国内/国外：</label>
								<select id="country_1" name="country" class="select">
									<option value="">--全部--</option>
									<option value="1" selected>国内</option>
									<option value="2">国外</option>
						    	</select>
						    	<span>&nbsp;</span>
						    
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
		//获取图表w
		function getFusionChart(){
			//利用率图表
			getAmountWhlFusionChart();
		}
		//获取闲置情况
		function getAmountWhlFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "95%", "200", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDeviceLieOne_coll.srq");
			chart1.render("chartContainer1");
		
			parent.mainRightframe.location.href = "<%=contextPath%>/rm/dm/deviceXZAccount/DevAccListUnUse_coll.jsp";
		
		}
		//查询
		function toQuery1(){
			var devTreeId = $('#dev_type_id') .val();
			var country = $('#country_1') .val();
			var country_text=$("#country_1").find("option:selected").text();
			country_text = encodeURI(country_text);
			country_text = encodeURI(country_text);
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/rm/dm/getDeviceLieOne_coll.srq?devTreeId="+devTreeId+"&country="+country);
			parent.mainRightframe.location.href = "<%=contextPath%>/rm/dm/deviceXZAccount/DevAccListUnUse_coll.jsp?country="+country_text;
		}
		//清除
		function toClear(){
			$('#org_sub_id_1') .val('');
			$('#country_1') .val('');
			$("#dev_type_name").html("");
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/rm/dm/getDeviceLieOne.srq");
			chart1.render("chartContainer1");
			parent.mainRightframe.location.href = "<%=contextPath%>/rm/dm/deviceXZAccount/DevAccListUnUse_coll.jsp";
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
		  
		
	</script>
</html>

