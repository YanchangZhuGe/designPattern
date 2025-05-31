<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String userId = user.getEmpId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
		IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);
	String startDate = new SimpleDateFormat("yyyy").format(new Date())
	+ "-01-01"; 
	String endDate = new SimpleDateFormat("yyyy-MM-dd")
	.format(new Date());
	String bywx_date_begin=request.getParameter("bywx_date_begin");
	if(null==bywx_date_begin||"".equals(bywx_date_begin)){
		 bywx_date_begin=startDate;
	}
	
	String bywx_date_end=request.getParameter("bywx_date_end");
	if(null==bywx_date_end||"".equals(bywx_date_end)){
		 bywx_date_end=endDate;
	}
	String zcj_type="5110000187000000001,5110000187000000003,5110000187000000005,5110000187000000006,5110000187000000008,5110000187000000010,5110000187000000011,5110000187000000013,5110000187000000002,5110000187000000007,5110000187000000012,5110000187000000004,5110000187000000009,5110000187000000014,5110000187000000015,0";
	String self_num=request.getParameter("self_num");
	if(null==self_num||"".equals(self_num)){
		self_num="";
		String sql1="select self_num   from gms_device_account t where   t.dev_type  like 'S06230101%' and t.bsflag='0' and t.self_num is not null ";
		List<Map>  list=pureJdbcDao.queryRecords(sql1);
		
		for(int i = 0; i < list.size(); i++) {
	    Map s = list.get(i);
	   self_num += s.get("self_num").toString()+ ",";
		}
		self_num = self_num.substring(0, self_num.lastIndexOf(","));
	}else{
		if(self_num.indexOf(",")>0){
	self_num=self_num+self_num;
	self_num = self_num.substring(0, self_num.lastIndexOf(","));
		}else{
	String sql1="select self_num   from gms_device_account t where   t.dev_type  like 'S06230101%' and t.bsflag='0' and t.self_num like '%"+self_num+"%' ";
	List<Map>  list=pureJdbcDao.queryRecords(sql1);
	
	for(int i = 0; i < list.size(); i++) {
		    Map s = list.get(i);
		   self_num += s.get("self_num").toString()+ ",";
	}
		}	
	}
	StringBuffer str = new StringBuffer();
	str.append(";bywx_date_begin=")
	.append(bywx_date_begin).append(";self_num=").append(self_num).append(";bywx_date_end=").append(bywx_date_end).append(";zcj_type=").append(zcj_type);
	String country=request.getParameter("country");
	if(null==country||"".equals(country)){
		 country="国内";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet" type="text/css" />
 <%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/easyuiresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.messager.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>

<title>公司级仪表盘</title>
</head>
<body style="background: #cdddef; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
					<td colspan="3">
						<div class=" ">
							<div class="">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					<td class="ali_cdn_name">国内/国外：</td>
								  <td class="ali_cdn_input"><select id="country" name="country" class="select">
									<option value="">--全部--</option>
									<option value="1" selected>国内</option>
									<option value="2">国外</option>
						    	</select> </td> 
					<td class="ali_cdn_name">开始时间：</td>
			 	    <td class="ali_cdn_input">
			 	    	<input name="start_date" id="start_date" class="input_width easyui-datebox" type="text"  style="width:268px" editable="false" required/>
			 	    </td> 
			 	    <td class="ali_cdn_name">结束时间：</td>
			 	    <td class="ali_cdn_input">
			 	    	<input name="end_date" id="end_date" class="input_width easyui-datebox" type="text"  style="width:268px" editable="false" required/>
			 	    </td> 
					<td class="ali_query">
					   <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
				    </td>
				    <td>&nbsp;</td>
				</tr>
				
			  </table>
							</div>
						</div>
					</td>
				</tr>
			<tr>
				<td colspan="3">
			 
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="####"></a></span><a href="####">主要设备基本情况统计表</a><span class="gd"><a
							href="####"></a></span>
							<select name='s_org_id_wutan'>
								 <option value="C105006">装备服务处</option>
								</select>
									资产状况: <select id='account_stat' onchange="changeAccount_stat()">
									<option value="">全部</option>
									<option value="<%=DevConstants.DEV_ACCOUNT_ZAIZHANG%>">在账</option>
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
		  <!--利用率 -->
			<tr>
			<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="49%">
						<div class="tongyong_box">
							<div class="tongyong_box_title">
								 分类利用率
							</div>
							<div class="tongyong_box_content_left" id="chartContainer2" style="height: 300px;"></div>
						</div>
					</td>
						<td width="1%"></td>
				<!--资源池-->
				<td>
					<div class="tongyong_box">
							<div class="tongyong_box_title">
						  	装备资源池
						  	</div>
								<div class="tongyong_box_content_left" id="chartContainer3" style="height: 300px;"></div>
							</div>
						</div>
					</td>
				</tr>
				<tr>
				</table>
				</td>
				</tr>
				
				<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				<!-- 可控震源数量分析-->
				<td width="49%" >
				<div class="tongyong_box">
							<div class="tongyong_box_title">
							 可控震源数量分析
							</div>
							<div class="tongyong_box_content_left" id="chartContainer5" style="height: 300px;">
							 
							 <div>
						</div>
				</td>
				<td width="1%"></td>
				<td >
				<div class="tongyong_box">
				<div class="tongyong_box_title">
													<span class="kb"><a href="#"></a></span><a href="#">公司地震仪器动态情况</a><span
														class="gd"><a href="#"></a></span> <span class="dc"
														style="float: right; margin-top: -4px;">  
													</span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer4"
													style="height: 300px;"></div>
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
	  getFusionChart5();
	  //公司地震仪器动态情况
	    var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "myChartId1", "100%", "300", "0", "0" );
		myChart2.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompEqChart.srq");    
		myChart2.render("chartContainer4"); 
	 
	
	}
	
		function popzaiyongdrill(obj){
			//popWindow('<%=contextPath %>/rm/dm/panel/popChartOfEqZaiyongChartDrill.jsp?code='+obj,'800:600');
			//window.open("<%=contextPath %>/rm/dm/panel/popChartOfEqZaiyongChartDrill.jsp?code="+obj,"","height=350,width=800,top=120,location=no");
			window.showModalDialog("<%=contextPath%>/rm/dm/panel/popChartOfEqZaiyongChartDrill.jsp?code="+obj,"","dialogWidth=800px;dialogHeight=350px");
		}
		function popxianzhidrill(obj){
			//popWindow('<%=contextPath %>/rm/dm/panel/popChartOfEqXianzhiChartDrill.jsp?code='+obj,'800:600');
			//window.open("<%=contextPath %>/rm/dm/panel/popChartOfEqXianzhiChartDrill.jsp?code="+obj,"","height=350,width=800,top=120,location=no");
			window.showModalDialog("<%=contextPath%>/rm/dm/panel/popChartOfEqXianzhiChartDrill.jsp?code="+obj,"","dialogWidth=800px;dialogHeight=350px");
		}
	//获取利用率
		function getAmountWhlFusionChart(){
			var iDate = new Date();
			var iStartDate = iDate.getFullYear()+"-01-01";
			var iEndDate=getCurrentDate();
			$('#date_1_1') .val(iStartDate);
			$('#date_1_2') .val(iEndDate);
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "300", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/rm/dm/getUseRate.srq?country=<%=country%>&orgSubId=<%=userSubid.substring(0,7)%>");
			chart1.render("chartContainer2");
		}
		//获取震源小时利用率
		function getHourUseFusionChart(){
	 
			var iStartDate =$('#kkzy_start_date').datebox('getValue');
			var iEndDate =$('#kkzy_end_date').datebox('getValue')
			var type=$('#kkzy_type').val();
		 
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "chart1", "95%", "300", "0", "0" );    
			if(type=='1'){
				chart1.setXMLUrl("<%=contextPath%>/rm/dm/getUseRate.srq?level=2&devTreeId=hour_use&hour_use=hour_use&startDate="+iStartDate+"&endDate="+iEndDate);
			}
			else{
				chart1.setXMLUrl("<%=contextPath%>/rm/dm/getUseRate.srq?level=2&devTreeId=D002&orgSubId=&country=&startDate="+iStartDate+"&endDate="+iEndDate+"&ifproduction=5110000186000000001");
			}
			chart1.render("chartContainer6");
		}
		//获取闲置情况
		function getAmountXZFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "95%", "300", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDeviceLieOne_coll.srq?country=<%=country%>");
			chart1.render("chartContainer3");
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
						if(sum_num_in=='0'&&sum_num_out=='0'){}
						else {//如果国外国内总数为0 不显示
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
						 
						var   index1=trindex*2-(-3);	 
					 
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
						 trindex=trindex+1;
						 }
						}	
				}
			}
			changeTable('device_content',2);
			$$('idBoxOpen2').click();
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
	function popzaiyongdrill(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popChartOfEqZaiyongChartDrill.jsp?code='+obj,'800:520','-钻取信息显示');
	}
	function popxianzhidrill(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popChartOfEqXianzhiChartDrill.jsp?code='+obj,'800:520','-钻取信息显示');
	}
	function popComxinduDisdrill(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popComXinduDisDrill.jsp?code='+obj,'800:520','-钻取信息显示');
	}
	//function popCompLVDrill(obj){
	//	popWindow('<%=contextPath %>/rm/dm/panel/popCompLVDrill.jsp?code='+obj,'800:520','-钻取信息显示');
	//}
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
	function getDiZhenData(code,len){
	   var userid = '<%=orgId%>';
	   var str = "";
	   //地震仪器
	   var retObj = jcdpCallService("DevCommInfoSrv", "getDiZhenData", "userid="+userid+"&code="+code);
	   str = retObj.xmldata;
	   return str;
	}
	//弹出表格
	function alertTable(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/poptableOfGongsi1.jsp','800:520','-钻取信息显示');
	}
	//第三级钻取
	function getThirdData(code,owninorgid){
	   var userid = '<%=orgId%>';
	   var str = "";
	   //
	   var retObj = jcdpCallService("DevCommInfoSrv", "getCompThirdData", "userid="+userid+"&code="+code+"&owninorgid="+owninorgid);
	   str = retObj.xmldata;
	   return str;
	} 
	//地震仪器第三级钻取
	function getDiZhenThirdData(code,usageorgid){
	   var userid = '<%=orgId%>';
	   var str = "";
	   //地震仪器
	   var retObj = jcdpCallService("DevCommInfoSrv", "getDiZhenThirdData", "userid="+userid+"&code="+code+"&usageorgid="+usageorgid);
	   str = retObj.xmldata;
	   return str;
	}
	//可控震源三级弹出钻取
	function getPopData(devname,zsnum,code,usageorgid){
		popWindow("<%=contextPath%>/rm/dm/panel/popOfCompThirdData.jsp?devname="+devname+"&zsnum="+zsnum+"&code="+code+"&usageorgid="+usageorgid,'650:580','-钻取信息显示');
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
		 
	 
	});
</script>
<!-- 右下角弹窗 -->
<style>
.lightbox{width:330px;background:#FFFFFF;border:#FFCC00 3px solid;line-height:20px;display:none; margin:0;}
.lightbox dt{background:#FFCC00;padding:5px;}
.lightbox dd{padding:30px; margin:0;}
</style>
<!-- 右下角弹窗 -->

<script type="text/javascript">
	function showWindowSize(){
		var img = document.getElementsByName('imgId');
		for(var i=0;i<5;i++){
		img[i].width=document.body.clientWidth;
		alert(document.body.clientWidth+"+"+document.body.clientHeight);
		img[i].height=document.body.clientHeight;
		}
	}

	function setEarthFrame(){
		$("earthFrame").height=document.body.clientHeight-60;
	}
	
	
</script>
<input type="button" value=" 右下角弹窗效果 " id="idBoxOpen2" style="display:none;"/>
	<dl id="idBox2" class="lightbox">
	<dt><b>工作提醒消息</b><input align="right" type="button" value="关闭" id="idBoxClose2" />
	</dt>
	<dd>
		<a href="####" onclick='remind(0)' />
			<font id="font" color=red><u><div id = "showCount" ></div></u></font></a>
		<a href="####" onclick='remind(1)' />
			<font id="font4" color=red><u><div id = "showRecvCount" ></div></u></font></a>
		<a href="<%=contextPath %>/rm/dm/deviceAccount/devAccSyncIndex.jsp" />
			<font id="font1" color=red><u><div id = "showAddCount" ></div></u></font></a>
		<a href="<%=contextPath %>/rm/dm/EqDevOutForm/EqDevOutBaseInfoList.jsp?opr_state=0" />
			<font id="font2" color=red><u><div id = "showMixCount" ></div></u></font></a>
		<a href="<%=contextPath %>/rm/dm/collDevOutForm/collDevOutBaseInfoList.jsp?opr_state=0" />
			<font id="font3" color=red><u><div id = "showCollCount" ></div></u></font></a>
		<a href="####" onclick='remind(3)'/>
			<font id="font6" color=red><u><div id = "showYzjlOutTimeCount" ></div></u></font></a>
	</dd>	
	</dl>
<script>
(function(){
	//消息闪烁提醒
	var SLEEP = 500;
	font.INTERVAL = setInterval (function (){
		(typeof font.index) === 'undefined' ? font.index = 0 : font.index++;
			  font.color = [
			            'red', 'black'
			  ][font.index % 2];
		    }, SLEEP);
	font1.INTERVAL = setInterval (function (){
		(typeof font1.index) === 'undefined' ? font1.index = 0 : font1.index++;
			  font1.color = [
			            'red', 'black'
			  ][font1.index % 2];
		    }, SLEEP);
	font2.INTERVAL = setInterval (function (){
		(typeof font2.index) === 'undefined' ? font2.index = 0 : font2.index++;
			  font2.color = [
			            'red', 'black'
			  ][font2.index % 2];
		    }, SLEEP);
	font3.INTERVAL = setInterval (function (){
		(typeof font3.index) === 'undefined' ? font3.index = 0 : font3.index++;
			  font3.color = [
			            'red', 'black'
			  ][font3.index % 2];
		    }, SLEEP);
	font4.INTERVAL = setInterval (function (){
		(typeof font4.index) === 'undefined' ? font4.index = 0 : font4.index++;
			  font4.color = [
			            'red', 'black'
			  ][font4.index % 2];
		    }, SLEEP);
	font6.INTERVAL = setInterval (function (){
		(typeof font6.index) === 'undefined' ? font6.index = 0 : font6.index++;
			  font6.color = [
			            'red', 'black'
			  ][font6.index % 2];
		    }, SLEEP);
	//右下角消息框
	var timer, target, current,
		ab = new AlertBox( "idBox2", { fixed: true,
			onShow: function(){
				clearTimeout(timer); this.box.style.bottom = this.box.style.right = 0;
			},
			onClose: function(){ clearTimeout(timer); }
		});

	function hide(){
		ab.box.style.bottom = --current + "px";
		if( current <= target ){
			ab.close();
		} else {
			timer = setTimeout( hide, 10 );
		}
	}

	$$("idBoxClose2").onclick = function(){
		target = -ab.box.offsetHeight; current = 0; hide();
	};
	$$("idBoxOpen2").onclick = function(){ 
	    var obj = jcdpCallService("DevCommRemind", "getDeviceHireProjectCount","orgSubId=<%=orgsubId %>");
	    var str = obj.procount;
	    if(str !="0" && str !=""){
	    	document.getElementById("showCount").innerText="您有（"+str+"）个项目未进行返还!";
	    	ab.show();
	    }
	    var noRecvObj = jcdpCallService("DevCommRemind", "getDevNoRecvProjectCount","orgSubId=<%=orgsubId %>");
	    var recvcount = noRecvObj.procount;
	    if(recvcount !="0" && recvcount !=""){
	    	document.getElementById("showRecvCount").innerText="您有（"+recvcount+"）个项目存在未接收的设备!";
	    	ab.show();
	    }
	    var dataEntity = jcdpCallService("DevCommRemind", "getDeviceSynsCount","orgSubId=<%=orgsubId %>");
	    var count = dataEntity.count;
	    if(count !="0" && count !=""){
	    	document.getElementById("showAddCount").innerText="您有（"+count+"）台已转资但未同步设备!";
	    	ab.show();
	    }
	    var dataUnCount = jcdpCallService("DevCommRemind", "getZBDevOutUntreCount","orgSubId=<%=orgsubId %>");
	    var mixcount = dataUnCount.mixcount;
	    if(mixcount !="0" && mixcount !=""){
	    	document.getElementById("showMixCount").innerText="您有（"+mixcount+"）条设备出库(装备按台)单据未处理!";
	    	ab.show();
	    }
	    var dataCollCount = jcdpCallService("DevCommRemind", "getZBCollOutUntreCount","orgSubId=<%=orgsubId %>");
	    var mixcollcount = dataCollCount.mixcollcount;
	    if(mixcollcount !="0" && mixcollcount !=""){
	    	document.getElementById("showCollCount").innerText="您有（"+mixcollcount+"）条设备出库(装备按量)单据未处理!";
	    	ab.show();
	    }
	  //可控震源运转记录超3天未做提醒仅仅授权李志明
	  if('<%=userId%>'=='8AEDD21723F8BBA0E0430A58F821BBA0'){
	    var yzjlOutTime = jcdpCallService("DevCommRemind", "getYzjlOutTimeCount","orgSubId=<%=orgsubId %>");
	    var yzjlOuttimecount = yzjlOutTime.outtimecount;
	    if(yzjlOuttimecount !="0" && yzjlOuttimecount !=""){
	    	document.getElementById("showYzjlOutTimeCount").innerText="您有（"+yzjlOuttimecount+"）台可控震源最近三天没有状态监测数据!";
	    	ab.show();
	    }
	  }
	};
})()
function remind(str){
	if(str == '0'){
		popWindow('<%=contextPath%>/rm/dm/panel/devcieHireList.jsp','980:520','-设备未返还项目列表');
	}else if(str == '3'){//运转记录查询
		popWindow('<%=contextPath %>/rm/dm/panel/devYzjlOutTimeInfo.jsp','980:520','-运转记录超期三天列表');
	}else{
		popWindow('<%=contextPath%>/rm/dm/panel/devcieRecvList.jsp','980:520','-设备未接收项目列表');
	}
}
function kkzy_simpleSearch(){
	
}
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
		window.location="<%=contextPath%>/rm/dm/panel/devmainpanelOfGongsiZB.jsp?bywx_date_begin="+bywx_date_begin+"&bywx_date_end="+bywx_date_end+"&country="+$("#country").val();
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
	var submitStr="";
    submitStr = "exportFlag="+exportFlag;
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
</script>


</html>

