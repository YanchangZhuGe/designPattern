<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
		<title>资产创收</title>
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
		<div id="list_content">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr id="tr_1">
					<td colspan="3" align="center" >
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								<span>资产创收&nbsp;</span>
								<span>年份：</span>
								<input  id="year" name="year" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
							    <img width="18" height="16" id="cal_button_1_1" style="cursor: hand;" 
					    		onmouseover="yearSelector(year,cal_button_1_1);" src="<%=contextPath%>/images/calendar.gif" />
								<span>&nbsp;物探处：</span>
								<select id="org_sub_id_1" name="org_sub_id" class="select" onchange="viewProject(this)">
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
<!-- 						    		<option value="C105006">装备服务处</option> -->
						    	</select>
						    	<span>&nbsp;项目名称：</span>
								<select id="project" name="project" class="select">
									<option value="">全部</option>
						    	</select>
					    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="toQuery1()"/>
					    		<span>&nbsp;</span>
					    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="toClear()"/>
							</div>
							<div class="tongyong_box_content_left" id="chartContainer1" style="height: 400px;"></div>
						</div>
					</td>
				</tr>
				
			</table>
		</div>
	</body>
	<script type="text/javascript">
		//获取图表
		function getFusionChart(){
			//资产创收图表
			getAmountWhlFusionChart();
			var iDate = new Date();
			var year = iDate.getFullYear();
			$('#year') .val(year);
		}
		//获取资产创收
		function getAmountWhlFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "400", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/use/getAssetsBenefitData.srq");
			chart1.render("chartContainer1");
		}
		//查询
		function toQuery1(){
			var orgSubId = $('#org_sub_id_1') .val();
			var projectInfoNo = $('#project') .val();
			var year = $('#year') .val();
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/use/getAssetsBenefitData.srq?orgSubId="+orgSubId+"&projectInfoNo="+projectInfoNo+"&year="+year);
		}
		//清除
		function toClear(){
			$('#org_sub_id_1') .val('');
			$('#project') .val('');
			$('#year') .val('');
			var chartReference1 = FusionCharts("chart1"); 
			chartReference1.setXMLUrl("<%=contextPath%>/dms/use/getAssetsBenefitData.srq");
		}
		//弹出子层级资产创收
		function popNextLevelAI(){
			popWindow('<%=contextPath%>/dmsManager/use/assetsIncome/secondLevelAssetsBenefit.jsp','800:572');
		}
		//选择年份
		function yearSelector(inputField,tributton)
		{    
		    Calendar.setup({
		        inputField     :    inputField,   // id of the input field
		        ifFormat       :    "%Y",       // format of the input field
		        align          :    "Br",
				button         :    tributton,
		        onUpdate       :    null,
		        weekNumbers    :    false,
				singleClick    :    true,
				step	       :	1
		    });
		}
		//根据物探处显示项目,实现级联加载
		function viewProject(obj){
			//alert(obj.value);
			var reObj = jcdpCallService("AssetsIncomeSrv","getProjectListByOrgSubId","orgSubId="+obj.value);
			var proList = document.getElementById("project");
			proList.length=1;
			if(reObj.list !=null){
				for(var i = 0 ; i<reObj.list.length;i++){
					var option = document.createElement("option");
					option.text = reObj.list[i].project_name;
					option.value = reObj.list[i].project_info_no;
					try{
						proList.add(option,null);
					}catch(ex){
						proList.add(option);
					}
					
				}
			}
		}
	</script>
</html>

