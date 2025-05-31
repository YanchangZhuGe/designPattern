<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	
	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);
	String startDate = new SimpleDateFormat("yyyy").format(new Date()) + "-01-01"; 
	String endDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	
	String bywx_date_begin=request.getParameter("bywx_date_begin");
	if(null!=bywx_date_begin&&!"".equals(bywx_date_begin)){
		 startDate=bywx_date_begin;
	}
	
	String bywx_date_end=request.getParameter("bywx_date_end");
	if(null!=bywx_date_end&&!"".equals(bywx_date_end)){
		endDate= bywx_date_end;
	}	 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet" type="text/css" />
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/echartsresource.jsp"%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>公司级仪表盘</title>
</head>
<body style="overflow-y:scroll">
<div id="list_content"  >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="3">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">开始时间：</td>
					 	    <td class="ali_cdn_input">
					 	    	<input name="start_date" id="start_date" class="input_width easyui-datebox" type="text"  style="width:128px" editable="false" required/>
					 	    </td> 
					 	    <td class="ali_cdn_name">结束时间：</td>
					 	    <td class="ali_cdn_input">
					 	    	<input name="end_date" id="end_date" class="input_width easyui-datebox" type="text"  style="width:128px" editable="false" required/>
					 	    </td> 
							<td class="ali_query">
							   <span class="cx"><a href="####" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
						    </td>
						    <td>&nbsp;</td>
						</tr>				
			 		 </table>
				</td>
			</tr>
			<tr>
				<td colspan="3">			 
					<div class="tongyong_box">
						<div class="tongyong_box_title">
							<span class="kb"><a href="####"></a></span>
							<a href="####">主要设备基本情况统计表</a><span class="gd">
							<a href="####"></a></span>
								<select name='s_org_id_wutan'>
								 	<option value="C105006">装备服务处</option>
								</select>
								资产状况: <select id='account_stat' onchange="changeAccount_stat()">
											<option value="">全部</option>
											<option value="0110000013000000003">在账</option>
										</select>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="####" onclick="exportDataDoc('zysbjbqktjb')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer1" style="overflow-x:hidden;height: 230px;">
			 				<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="tab_info" id="device_content">
								<tr class="trHeader">
								  	<td class="bt_info_odd" rowspan="2">设备类别</td> 
								  	<td class="bt_info_even" rowspan="2">单位</td>
								  	<td class="bt_info_odd" rowspan="2">国内/国外</td>
								  	<td class="bt_info_even" rowspan="2">总量</td>
								  	<td class="bt_info_odd" colspan="3">完好</td>
								  	<td class="bt_info_even" rowspan="2">在修</td> 
								  	<td class="bt_info_odd" rowspan="2">待修</td>
								  	<td class="bt_info_even" rowspan="2">待报废</td>
								  	<td class="bt_info_odd" rowspan="2">在途</td>
								</tr>
								<tr class="trHeader">
								  	<td class="bt_info_odd">在用（非报废）</td>
								  	<td class="bt_info_even">在用（报废）</td>
								  	<td class="bt_info_odd">闲置</td> 
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
		  	<!--地震仪器利用率 -->
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="49%">
								<div class="tongyong_box">
									<div class="tongyong_box_title">地震仪器利用率</div>
									<div class="tongyong_box_content_left" id="chartContainer2" style="height: 300px;"></div>
								</div>
							</td>
							<td width="1%"></td>
							<!--可控震源利用率-->
							<td>
								<div class="tongyong_box">
									<div class="tongyong_box_title">可控震源利用率</div>
									<div class="tongyong_box_content_left" id="chartContainer3" style="height: 300px;"></div>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>				
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						<!-- 地震仪器完好率-->
						<td width="49%" >
							<div class="tongyong_box">
								<div class="tongyong_box_title">地震仪器完好率</div>
								<div class="tongyong_box_content_left" id="chartContainer5" style="height: 300px;"></div>
							</div>
						</td>
						<td width="1%"></td>
						<td>
							<div class="tongyong_box">
								<div class="tongyong_box_title">
									<span class="kb"><a href="####"></a></span>
									<a href="####">可控震源完好率</a>
									<span class="gd"><a href="####"></a></span>
									<span class="dc" style="float: right; margin-top: -4px;"></span>
								</div>
								<div class="tongyong_box_content_left" id="chartContainer4" style="height: 300px;"></div>
							</div>
						</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="49%">
								<div class="tongyong_box">
									<div class="tongyong_box_title">地震仪器分布</div>
									<div class="tongyong_box_content_left" id="chartContainer6" style="height: 300px;"></div>
								</div>
							</td>
							<td width="1%"></td>
							<!--可控震源分布-->
							<td>
								<div class="tongyong_box">
									<div class="tongyong_box_title">可控震源分布</div>
									<div class="tongyong_box_content_left" id="chartContainer7" style="height: 300px;"></div>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>			  
		</table>
		</td>
		<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript"> 	
	cruConfig.contextPath='<%=contextPath%>';	
	function getFusionChart(){
		$('#start_date').datebox('setValue','<%=startDate%>');
		$('#end_date').datebox('setValue','<%=endDate%>');	 
		//加载主要设备基本情况统计表
		$("#device_content tr[class!='trHeader']").remove();
	    var s_org_id = document.getElementsByName("s_org_id_wutan")[0].value;
		loadTable(s_org_id,'');
	 	getAmountWhlFusionChart();
	  	getAmountXZFusionChart();
	  	getFBFusionChart();  
	}	 
	//获取利用率
	function getAmountWhlFusionChart(){			
		//地震仪器
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "chart1", "95%", "300", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/dms/device/getUseRate.srq?level=2&devTreeId=D001&orgSubId=<%=orgId%>&country=1&startDate=<%=startDate%>&endDate=<%=endDate%>&ifproduction=5110000186000000001");
			chart1.render("chartContainer2");
		//可控震源
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "chart1", "95%", "300", "0", "0" );    
			chart2.setXMLUrl("<%=contextPath%>/dms/device/getUseRate.srq?level=2&devTreeId=D002&orgSubId=<%=orgId%>&country=1&startDate=<%=startDate%>&endDate=<%=endDate%>&ifproduction=5110000186000000001");
			chart2.render("chartContainer3");
	}		 
	//获取完好率情况
	function getAmountXZFusionChart(){			 
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "chart1", "95%", "95%", "0", "0" ); 
			chart1.setXMLUrl("<%=contextPath%>/dms/device/getAmountWhlChartData.srq?level=2&devTreeId=D001&orgSubId=<%=orgId%>&country=1&startDate=<%=startDate%>&endDate=<%=endDate%>&ifproduction=5110000186000000001");
			chart1.render("chartContainer5");
			
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "chart1", "95%", "95%", "0", "0" ); 
			chart2.setXMLUrl("<%=contextPath%>/dms/device/getAmountWhlChartData.srq?level=2&devTreeId=D002&orgSubId=<%=orgId%>&country=1&startDate=<%=startDate%>&endDate=<%=endDate%>&ifproduction=5110000186000000001");
			chart2.render("chartContainer4");		 
	}
	//分布在项目上
	function getFBFusionChart(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "98%", "480", "0", "0" ); 
		chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDevOrgChartData.srq?parentCode=D001&ifCountry=in&analType=use&wutanorg=C105006&account_stat=0110000013000000003");
		chart1.render("chartContainer6");
		
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "98%", "480", "0", "0" ); 
		chart2.setXMLUrl("<%=contextPath%>/rm/dm/getDevOrgChartData.srq?parentCode=D002&ifCountry=in&analType=use&wutanorg=C105006&account_stat=0110000013000000003");
		chart2.render("chartContainer7");
	}
	//加载主要设备基本情况统计表
	function loadTable(suborg,account_stat){
		var wutanorg = '';
		if(suborg!=undefined && suborg!=''){
			wutanorg = suborg;
		}else{
			wutanorg = '<%=orgsubId%>';
		}
		var retObj = jcdpCallService("DevInsSrv", "getTableChartData","wutanorg="+wutanorg+'&account_stat='+account_stat);
	
		if(retObj!=null && retObj.returnCode=='0'){
			var device_content = document.getElementById("device_content");
			var trindex=0;
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var map = retObj.datas[i];
				if(map!=null){
					with(map){
						if(sum_num_in=='0'&&sum_num_out=='0'){							
						}else {//如果国外国内总数为0 不显示
							var   index1=trindex*2-(-2);
							var tr = device_content.insertRow(index1);
							var td = tr.insertCell(0);
								td.rowSpan = 2;
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','','','2')><font color='blue'>"+device_name+"</font></a>";					
								td = tr.insertCell(1);
								td.rowSpan = 2;
								td.innerHTML = unit ;
								td = tr.insertCell(2);
								td.innerHTML = "国内" ;
								td = tr.insertCell(3);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','sum','2')><font color='blue'>"+sum_num_in+"</font></a>";
								td = tr.insertCell(4);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','use','2')><font color='blue'>"+use_num_in+"</font></a>";
								td = tr.insertCell(5);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','scrap','2')><font color='blue'>"+scrap_num_in+"</font></a>";
								td = tr.insertCell(6);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','idle','2')><font color='blue'>"+idle_num_in+"</font></a>";
								td = tr.insertCell(7);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','repairing','2')><font color='blue'>"+repairing_num_in+"</font></a>";
								td = tr.insertCell(8);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','wait_repair','2')><font color='blue'>"+wait_repair_num_in+"</font></a>";
								td = tr.insertCell(9);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','wait_scrap','2')><font color='blue'>"+wait_scrap_num_in+"</font></a>";
								td = tr.insertCell(10);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','onway','2')><font color='blue'>"+onway_num_in+"</font></a>";
							 
							var index1 = trindex*2-(-3);	 						 
							var tr = device_content.insertRow(index1);
					            td = tr.insertCell(0);
					            td.innerHTML = "国外";
					            td = tr.insertCell(1);
					            td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','sum','2')><font color='blue'>"+sum_num_out+"</font></a>";
					            td = tr.insertCell(2);
					            td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','use','2')><font color='blue'>"+use_num_out+"</font></a>";
					            td = tr.insertCell(3);
								td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','scrap','2')><font color='blue'>"+scrap_num_out+"</font></a>";
					            td = tr.insertCell(4);
					            td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','idle','2')><font color='blue'>"+idle_num_out+"</font></a>";
					            td = tr.insertCell(5);
					            td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','repairing','2')><font color='blue'>"+repairing_num_out+"</font></a>";
					            td = tr.insertCell(6);
					            td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','wait_repair','2')><font color='blue'>"+wait_repair_num_out+"</font></a>";
					            td = tr.insertCell(7);
					            td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','wait_scrap','2')><font color='blue'>"+wait_scrap_num_out+"</font></a>";
					            td = tr.insertCell(8);
					            td.innerHTML = "<a href='####' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','onway','2')><font color='blue'>"+onway_num_out+"</font></a>";
								trindex = trindex+1;
						 	}
						}	
					}
			}
			changeTable('device_content',2);		 
		}	
	}
	function changeTable(table_name,rowIndex){
		var table = document.getElementById(table_name);
		for(var i =rowIndex ;i<table.rows.length;i++){
			var tr = table.rows[i];
			for(var j =0 ;j< tr.cells.length;j++){
				tr.cells[j].align ='center';
				if(i%2==0){
					if(j%2==1) tr.cells[j].style.background = "#FFFFFF";
					else tr.cells[j].style.background = "#f6f6f6";
				}else{
					if(j%2==1) tr.cells[j].style.background = "#ebebeb";
					else tr.cells[j].style.background = "#e3e3e3";
				}
			}
		}
	}
	//parentCode：父编码，wutanorg：单位，ifCountry：国内/国外，analType：统计类型，level：编码级别
	function fusionChart(parentCode,wutanorg,ifCountry,analType,level){
		var account_stat=$('#account_stat').val();//资产状态
		popWindow('<%=contextPath %>/rm/dm/panel/poptableOfGongsi.jsp?parentCode='+parentCode+'&wutanorg='+wutanorg+'&ifCountry='+ifCountry+'&analType='+analType+'&level='+level+"&account_stat="+account_stat,'1024:580','-钻取信息显示');
	}	 
	function changeYear(){
	    var chartReference = FusionCharts("myChartId4");     
	    var yearinfo = document.getElementsByName("yearinfo")[0].value;
	    var orgstrId='<%=orgstrId%>';
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWTNew.srq?yearinfo="+yearinfo+"&orgstrId="+orgstrId+"&drilllevel=0");
	}
	function popComWanhaoForMonth(obj){
	    popWindow('<%=contextPath %>/rm/dm/panel/popComMonthWanhaoLiyongDrill.jsp?monthinfo='+obj , '800:520','-钻取信息显示');
	}
	function changeOrgForLost(){
		 $("#chartContainer22").empty();
	     var s_org_id = document.getElementsByName("s_org_id_lost")[0].value;
	     var retObj22  = jcdpCallService("DevCommInfoSrv", "getCompEqDestroy", "orgsubid="+s_org_id);
		 var dataXml22 = retObj22.dataXML;;
		 $("#chartContainer22").append(dataXml22);
	}
	function changeWuTanOrg(){
		$("#device_content tr[class!='trHeader']").remove();
	     var s_org_id = document.getElementsByName("s_org_id_wutan")[0].value;
	     //getFusionChart(s_org_id);
	    //加载主要设备基本情况统计表
		loadTable(s_org_id);
	}
	function getRootData(){
		var userid = '<%=orgId%>';
		var str = "<chart>";	   
	    var retObj = jcdpCallService("DevCommInfoSrv", "getCompDevStatData", "code=060101");
    		str += retObj.xmldata;
    		str +="</chart>";
    	return str;
	}
	function getLeafData(code){
	   var userid = '<%=orgId%>';
	   var str = "";
	   var retObj = jcdpCallService("DevCommInfoSrv", "getCompLeafData", "userid="+userid+"&code="+code);
	   str = retObj.xmldata;
	   return str;
	}	
	function exportDataDoc(exportFlag){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		//主要设备基本情况统计表
		if("zysbjbqktjb"==exportFlag){
			var s_org_id_wutan = document.getElementsByName("s_org_id_wutan")[0].value;
			if(""==s_org_id_wutan){
				s_org_id_wutan="C105";//东方公司
			}
			submitStr="orgsubId="+s_org_id_wutan+"&exportFlag="+exportFlag;
		}
		//地震仪器损失情况
		if("dzyqssqk"==exportFlag){
			var _orgId=document.getElementsByName("s_org_id_lost")[0].value;
			submitStr="orgsubId="+_orgId+"&exportFlag="+exportFlag;
		}
		//地震仪器动态情况  
		if("dzyqdtqk"==exportFlag){
			submitStr="exportFlag="+exportFlag;
		}
		//主要设备新度系数 
		if("zysbxdxs"==exportFlag){
			submitStr="exportFlag="+exportFlag;
		}
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
	
</script>  
<script type="text/javascript">
	function frameSize() {
		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
		checkDate();
		getFusionChart();	 
	});
 
	function simpleSearch(){
		var bywx_date_begin=$("#start_date").datebox('getValue');
		var bywx_date_end=$("#end_date").datebox('getValue');
		 
		if(!bywx_date_begin){
			alert('请选择开始时间');
			return;
		}
		if(!bywx_date_end){
			alert('请选择结束时间');
			return;
		}
		if(bywx_date_begin>bywx_date_end){
			alert("开始时间不能大于结束时间!");
			return;
		}
		window.location="<%=contextPath%>/dms_info/assess_tagZB.jsp?bywx_date_begin="+bywx_date_begin+"&bywx_date_end="+bywx_date_end+"&country="+$("#country").val();
	}
	function popDevList(dev_name,org_name){
		dev_name = encodeURI(dev_name);
		dev_name = encodeURI(dev_name);
		org_name = encodeURI(org_name);
		org_name = encodeURI(org_name);
		popWindow('<%=contextPath%>/rm/dm/panel/DevAccListUnUse_coll.jsp?dev_name='+dev_name+'&org_name='+org_name,'980:520','-闲置设备列表');
	}
	//各个项目组震源数量导出
	function exportDataDoc4(exportFlag){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="exportFlag="+exportFlag;
		var retObj = syncRequest("post", path, submitStr);
		var filename = retObj.excelName;
			filename = encodeURI(filename);
			filename = encodeURI(filename);
		var showname = retObj.showName;
			showname = encodeURI(showname);
			showname = encodeURI(showname);
		window.location = cruConfig.contextPath
				+ "/rm/dm/common/download_temp.jsp?filename=" + filename
				+ "&showname=" + showname;
	}
	function popDevArchiveBaseInfoList(project_info_id){
		popWindow('<%=contextPath %>/rm/dm/kkzy/zytj/popDevArchiveBaseInfoList.jsp?project_info_id='+project_info_id,'1200:600');
	}
	//选择资产状况
    function changeAccount_stat(){
		$("#device_content tr[class!='trHeader']").remove();
	    var s_org_id = document.getElementsByName("s_org_id_wutan")[0].value;
  		var account_stat = $("#account_stat").val();
	    //加载主要设备基本情况统计表
		loadTable(s_org_id,account_stat);
	}
	//地震仪器数量获取图标
	function getFusionChart5(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "100%", "300", "0", "0" );    
		chart1.setXMLUrl("<%=contextPath%>/rm/dm/kkzy/getKkzyAmountAnal.srq");
		chart1.render("chartContainer5");
	}
	// 弹出子级可控震源数量统计分析信息
	function popSecondKkzyAmountAnal(useStat){
		popWindow('<%=contextPath%>/rm/dm/kkzy/zytj/secondKkzyAmountAnal.jsp?useStat='+useStat,'800:572');
	}
	// 弹出其他震源信息
	function popOtherKkzyList(useStat){
		popWindow('<%=contextPath%>/rm/dm/kkzy/zytj/otherKkzyList.jsp?useStat='+useStat,'800:572');
	}
	//日期判断
	function checkDate(){
		//检查时间
		$(".easyui-datebox").datebox({
			onSelect: function(){
				var	startTime = $("#start_date").datebox('getValue');
				var	endTime = $("#end_date").datebox('getValue');
				if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
					var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
					if(days<0){
						$.messager.alert("提示","结束日期应大于开始日期!","warning");
						$("#end_date").datebox("setValue","");
					}			
				}
			}
		});
		//禁止日期框手动输入
		$(".datebox :text").attr("readonly","readonly");
	} 
</script>
</html>
