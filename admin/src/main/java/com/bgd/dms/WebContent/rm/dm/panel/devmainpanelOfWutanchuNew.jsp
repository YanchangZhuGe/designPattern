<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getCodeAffordOrgID();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	
	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);
	
	 if(user.getSubOrgIDofAffordOrg().equals("C105")){
			request.getRequestDispatcher("devmainpanelOfGongsi.jsp").forward(request,response);
	 }

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.messager.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3">
								<div class="tongyong_box">
								<div class="tongyong_box_title"><span class="kb"><a
									href="#"></a></span><a href="#">主要设备基本情况统计表</a><span class="gd"><a
									href="#"></a></span>
									<span class="dc" style="float:right;margin-top:-4px;">
										<a href="#" onclick="exportDataDoc('zysbjbqktjb')" title="导出excel"></a>
									</span>	
								</div>
								<div class="tongyong_box_content_left" id="chartContainer1" style="height: 230px;">
					 				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="device_content2">
										<tr class="trHeader">
										  	<td class="bt_info_odd" rowspan="2">设备类别</td> 
										  	<td class="bt_info_even" rowspan="2">单位</td>
										  	<td class="bt_info_odd" rowspan="2">国内/国外</td>
										  	<td class="bt_info_even" rowspan="2">总量</td>
										  	<td class="bt_info_odd" colspan="2">完好</td>
										  	<td class="bt_info_even" rowspan="2">在修</td> 
										  	<td class="bt_info_odd" rowspan="2">待修</td>
										  	<td class="bt_info_even" rowspan="2">待报废</td>
										</tr>
										<tr class="trHeader">
										  	<td class="bt_info_odd">在用</td>
										  	<td class="bt_info_even">闲置</td> 
										</tr>
									</table>
								</div>
								</div>
						</td>
					</tr>
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">主要设备新度系数</a>
							<select name='s_org_id11' onchange="changeOrg11()">
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
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
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('zysbxdxs')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer11" style="height: 250px;">
			 				
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="<%=contextPath %>/rm/dm/panel/xiazua/devwanhaoliyonglv.jsp" target="_blank">主要设备完好率、利用率</a>
							<select id="yearinfo" name="yearinfo" style="select_width" onchange="changeYear()">
								<%
									for(int j=0;j<3;j++){
										int showinfo = yearinfo-j;
								%>
								<option value="<%=showinfo%>"><%=showinfo%>年</option>
								<%
									}
								%>
							</select>
							<span class="gd"><a href="#"></a></span>
							<select name='s_org_id2' onchange="changeOrg2()">
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
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
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">

						</div>
						</div>
						</td>
					</tr>
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">各项目主要设备投入统计</a>
							<select id="s_pro_year3" name="s_pro_year3" style="select_width" onchange="changeOrg3()">
							</select>
							<span class="gd"><a href="#"></a></span>
							<select name='s_org_id3' onchange="changeOrg3()">
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
							<%
								}
								if("C105".equals(orgId)){
								for(int i=0;i<DevUtil.proorgNameList.size();i++){
									String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
								}
								}else{
									for(int i=0;i<DevUtil.proorgNameList.size();i++){
										if(DevUtil.proorgNameList.get(i).indexOf(orgId)>=0){
											String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
										}
									}
								}
							%>
							</select>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('gxmzysbtrtj')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer3" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">各项目采集设备分布</a>
							<select id="s_pro_year4" name="s_pro_year4" style="select_width" onchange="changeOrg4()">
							</select>
							<span class="gd"><a href="#"></a></span>
							<select name='s_org_id4' onchange="changeOrg4()">
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
							<%
								}
								if("C105".equals(orgId)){
								for(int i=0;i<DevUtil.proorgNameList.size();i++){
									String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
								}
								}else{
									for(int i=0;i<DevUtil.proorgNameList.size();i++){
										if(DevUtil.proorgNameList.get(i).indexOf(orgId)>=0){
											String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
										}
									}
								}
							%>
							</select>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('gxmcjsbfb')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;">

						</div>
						</div>
						</td>
					</tr>
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">各项目费用分析</a>
							<select id="s_pro_year5" name="s_pro_year5" style="select_width" onchange="changeOrg5()">
							</select>
							<span class="gd"><a href="#"></a></span>
							<select name='s_org_id5' onchange="changeOrg5()">
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
							<%
								}
								if("C105".equals(orgId)){
								for(int i=0;i<DevUtil.proorgNameList.size();i++){
									String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
								}
								}else{
									for(int i=0;i<DevUtil.proorgNameList.size();i++){
										if(DevUtil.proorgNameList.get(i).indexOf(orgId)>=0){
											String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
										}
									}
								}
							%>
							</select>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('gxmfyfx')" title="导出excel"></a>
							</span>
							</div>
						<div class="tongyong_box_content_left"  id="chartContainer5" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">各项目主要设备完好率、利用率</a>
							<select id="s_pro_year6" name="s_pro_year6" style="select_width" onchange="changeOrg6()">
							</select>
							<span class="gd"><a href="#"></a></span>
							<select name='s_org_id6' onchange="changeOrg6()">
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
							<%
								}
								if("C105".equals(orgId)){
								for(int i=0;i<DevUtil.proorgNameList.size();i++){
									String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
								}
								}else{
									for(int i=0;i<DevUtil.proorgNameList.size();i++){
										if(DevUtil.proorgNameList.get(i).indexOf(orgId)>=0){
											String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
										}
									}
								}
							%>
							</select>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('gxmzysbwhllyl')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer6" style="height: 250px;">

						</div>
						</div>
						</td>
					</tr>
					<tr>
						<td width="49%" colspan="3">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="<%=contextPath %>/rm/dm/panel/xiazua/devxianchangweixiu.jsp" target="_blank">现场维修费用统计</a>
							<select id="s_pro_year7" name="s_pro_year7" style="select_width" onchange="changeOrg7()">
							</select>
							<span class="gd"><a href="#"></a></span>
							<select name='s_org_id7' onchange="changeOrg7()">
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
							<%
								}
								if("C105".equals(orgId)){
								for(int i=0;i<DevUtil.proorgNameList.size();i++){
									String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
								}
								}else{
									for(int i=0;i<DevUtil.proorgNameList.size();i++){
										if(DevUtil.proorgNameList.get(i).indexOf(orgId)>=0){
											String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
										}
									}
								}
							%>
							</select>
							 <span class="dc" style="float:right;margin-top:-3px;">
							 	<a href="#" onclick="exportDataDoc('xcwxfytjwutanchu')" title="导出excel"></a>
							 </span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer7" style="height: 250px;">
			 
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
</div>
</body>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript">
	 cruConfig.contextPath="<%=contextPath%>";
	 function getFusionChart(){
		 $$('idBoxOpen2').click();//加载时显示设备返还提醒
		 /*
		//主要设备动态统计表，用自定义的FLASH做的
		var swfVersionStr = "10.0.0";
	    <!-- To use express install, set to playerProductInstall.swf, otherwise the empty string. -->
	    var xiSwfUrlStr = "charts/playerProductInstall.swf";
	    var params = {};
	    params.quality = "high";
	    params.bgcolor = "#ffffff";
	    params.allowscriptaccess = "sameDomain";
	    params.allowfullscreen = "true";
	    params.wmode = "transparent";
		<!-- JavaScript enabled so display the flashContent div in case it is not replaced with a swf object. -->
	     //加载columnChart    
	    var attributes = {};
	    attributes.id = "columnChart";
	    attributes.name = "columnChart";
	    attributes.align = "middle";
	    flashvars = {};
		swfobject.embedSWF(
	        "charts/deviceStat.swf", "chartContainer1", 
	        "100%", "250", 
	        swfVersionStr, xiSwfUrlStr, 
	        flashvars, params, attributes);
	    */
	    
	    //主要设备完好率、利用率(物探处级) -- 先时时统计台账，出这个图
	    var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "250", "0", "0" );
	    var s_org_id2 = document.getElementsByName("s_org_id2")[0].value;    
		myChart2.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompDevRatioChartWTNew.srq?orgstrId=<%=orgstrId%>&drilllevel=1"+"&orgsubId="+s_org_id2);
		myChart2.render("chartContainer2"); 
	   	//各项目主要设备投入统计
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" );
		var s_org_id3 = document.getElementsByName("s_org_id3")[0].value;
		var s_pro_year3 = document.getElementsByName("s_pro_year3")[0].value;
		var retObj3 = jcdpCallServiceCache("DevCommInfoSrv","getWutanTeamProDevInfosBase","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id3+"&proYear="+s_pro_year3);
		var xmldata3 = retObj3.xmldata;
		var startindex3 = xmldata3.indexOf("<chart");
		xmldata3 = xmldata3.substr(startindex3);
		myChart3.setXMLData(xmldata3);
		myChart3.render("chartContainer3");
		//各项目采集设备投入统计
		var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId4", "100%", "250", "0", "0" ); 
		var s_org_id4 = document.getElementsByName("s_org_id4")[0].value;
		var s_pro_year4 = document.getElementsByName("s_pro_year4")[0].value;
		var retObj4 = jcdpCallServiceCache("DevCommInfoSrv","getWutanTeamCaijiDevInfosBase","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id4+"&proYear="+s_pro_year4);
		var xmldata4 = retObj4.xmldata;
		var startindex4 = xmldata4.indexOf("<chart");
		xmldata4 = xmldata4.substr(startindex4);
		myChart4.setXMLData(xmldata4);
		myChart4.render("chartContainer4");
		//各项目主要设备主要费用统计
		var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId5", "100%", "250", "0", "0" );   
		var s_org_id5 = document.getElementsByName("s_org_id5")[0].value; 
		var s_pro_year5 = document.getElementsByName("s_pro_year5")[0].value;
		var retObj5 = jcdpCallServiceCache("DevCommInfoSrv","getWutanTeamCostInfosBase","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id5+"&proYear="+s_pro_year5);
		var xmldata5 = retObj5.xmldata;
		var startindex5 = xmldata5.indexOf("<chart");
		xmldata5 = xmldata5.substr(startindex5);
		myChart5.setXMLData(xmldata5);
		myChart5.render("chartContainer5");
		//各项目主要设备利用率、完好率统计
		var myChart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId6", "100%", "250", "0", "0" );
		var s_org_id6 = document.getElementsByName("s_org_id6")[0].value;  
		var s_pro_year6 = document.getElementsByName("s_pro_year6")[0].value;
		var retObj6 = jcdpCallServiceCache("DevCommInfoSrv","getWutanTeamLiyongWanhaoInfosBase","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id6+"&proYear="+s_pro_year6);
		var xmldata6 = retObj6.xmldata;
		var startindex6 = xmldata6.indexOf("<chart");
		xmldata6 = xmldata6.substr(startindex6);
		myChart6.setXMLData(xmldata6);
		myChart6.render("chartContainer6");
		//各主要设备的新度系数
		var s_org_id11 = document.getElementsByName("s_org_id11")[0].value;
		var myChart11 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId11", "100%", "250", "0", "0" );    
		myChart11.setXMLUrl("<%=contextPath%>/cache/rm/dm/getComXindu.srq?orgstrId=<%=orgstrId%>&drillLevel=1"+"&orgsubId="+s_org_id11);
		myChart11.render("chartContainer11");
		//现场维修数据统计
		var s_org_id7 = document.getElementsByName("s_org_id7")[0].value;  
		var s_pro_year7 = document.getElementsByName("s_pro_year7")[0].value;
		var retObj7 = jcdpCallServiceCache("DevCommInfoSrv","getWxCostDataForWutan","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id7+"&proYear="+s_pro_year7);
		var dataXml7 = retObj7.dataXML;
		var myChart7 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId7", "100%", "250", "0", "0" );    
		myChart7.setXMLData(dataXml7);
		myChart7.render("chartContainer7");
		
		getwtcDatas();
		//showDialog();//增加设备返还提示框显示 by wangzheqin 
	}
	function getwtcDatas(suborg){
		var wutanorg = '';
		if(suborg!=undefined && suborg!=''){
			wutanorg = suborg;
		}else{
			wutanorg = '<%=orgsubId%>';
		}
		var retObj = jcdpCallService("DevInsSrv", "getTableChartData","wutanorg="+wutanorg);
	
		if(retObj!=null && retObj.returnCode=='0'){
			var device_content2 = document.getElementById("device_content2");
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var map = retObj.datas[i];
				if(map!=null){
					with(map){
						var tr = device_content2.insertRow(i*2-(-2));
						var td = tr.insertCell(0);
						td.rowSpan = 2;
						td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','','','2')><font color='blue'>"+device_name+"</font></a>";					
						td = tr.insertCell(1);
						td.rowSpan = 2;
						td.innerHTML = unit ;
						td = tr.insertCell(2);
						td.innerHTML = "国内" ;
						td = tr.insertCell(3);
						td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','sum','2')><font color='blue'>"+sum_num_in+"</font></a>";
						td = tr.insertCell(4);
						td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','use','2')><font color='blue'>"+use_num_in+"</font></a>";
						td = tr.insertCell(5);
						td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','idle','2')><font color='blue'>"+idle_num_in+"</font></a>";
						td = tr.insertCell(6);
						td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','repairing','2')><font color='blue'>"+repairing_num_in+"</font></a>";
						td = tr.insertCell(7);
						td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','wait_repair','2')><font color='blue'>"+wait_repair_num_in+"</font></a>";
						td = tr.insertCell(8);
						td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','in','wait_scrap','2')><font color='blue'>"+wait_scrap_num_in+"</font></a>";
						
						var tr = device_content2.insertRow(i*2-(-3));
			            td = tr.insertCell(0);
			            td.innerHTML = "国外";
			            td = tr.insertCell(1);
			            td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','sum','2')><font color='blue'>"+sum_num_out+"</font></a>";
			            td = tr.insertCell(2);
			            td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','use','2')><font color='blue'>"+use_num_out+"</font></a>";
			            td = tr.insertCell(3);
			            td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','idle','2')><font color='blue'>"+idle_num_out+"</font></a>";
			            td = tr.insertCell(4);
			            td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','repairing','2')><font color='blue'>"+repairing_num_out+"</font></a>";
			            td = tr.insertCell(5);
			            td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','wait_repair','2')><font color='blue'>"+wait_repair_num_out+"</font></a>";
			            td = tr.insertCell(6);
			            td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','out','wait_scrap','2')><font color='blue'>"+wait_scrap_num_out+"</font></a>";
					}	
				}
			}
			changeTable('device_content2',2);
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
	function changeOrg11(){
		 var chartReference = FusionCharts("myChartId11");
	     var s_org_id = document.getElementsByName("s_org_id11")[0].value;
	     chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getComXindu.srq?orgstrId=<%=orgstrId%>&orgsubId="+s_org_id+"&drillLevel=1");
	}
 	function changeOrg2(){
	     var chartReference = FusionCharts("myChartId2");
	     var yearinfo = document.getElementsByName("yearinfo")[0].value;
	     var s_org_id = document.getElementsByName("s_org_id2")[0].value;
	     var orgstrId='<%=orgstrId%>';
	     chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWTNew.srq?yearinfo="+yearinfo+"&orgstrId="+orgstrId+"&orgsubId="+s_org_id+"&drilllevel=1");
	}
	function changeYear(){
	    var chartReference = FusionCharts("myChartId2");     
	    var yearinfo = document.getElementsByName("yearinfo")[0].value;
	    var s_org_id = document.getElementsByName("s_org_id2")[0].value;
	    var orgstrId='<%=orgstrId%>';
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWTNew.srq?yearinfo="+yearinfo+"&orgstrId="+orgstrId+"&orgsubId="+s_org_id+"&drilllevel=1");
	}

	function changeOrg3(){
	     var chartReference = FusionCharts("myChartId3");
	     var s_org_id = document.getElementsByName("s_org_id3")[0].value;
	     var s_pro_year3 = document.getElementsByName("s_pro_year3")[0].value;
		 var retObj3 = jcdpCallService("DevCommInfoSrv","getWutanTeamProDevInfosBase","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id+"&proYear="+s_pro_year3);
		 var xmldata3 = retObj3.xmldata;
		 var startindex3 = xmldata3.indexOf("<chart");
		 xmldata3 = xmldata3.substr(startindex3);
		 chartReference.setXMLData(xmldata3);
	}
	function changeOrg4(){
	     var chartReference = FusionCharts("myChartId4");
	     var s_org_id = document.getElementsByName("s_org_id4")[0].value;
	     var s_pro_year4 = document.getElementsByName("s_pro_year4")[0].value;
	     var retObj4 = jcdpCallService("DevCommInfoSrv","getWutanTeamCaijiDevInfosBase","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id+"&proYear="+s_pro_year4);
		 var xmldata4 = retObj4.xmldata;
		 var startindex4 = xmldata4.indexOf("<chart");
		 xmldata4 = xmldata4.substr(startindex4);
		 chartReference.setXMLData(xmldata4);
	}
	function changeOrg5(){
	     var chartReference = FusionCharts("myChartId5");
	     var s_org_id = document.getElementsByName("s_org_id5")[0].value;
	     var s_pro_year5 = document.getElementsByName("s_pro_year5")[0].value;
	     var retObj5 = jcdpCallService("DevCommInfoSrv","getWutanTeamCostInfosBase","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id+"&proYear="+s_pro_year5);
		 var xmldata5 = retObj5.xmldata;
		 var startindex5 = xmldata5.indexOf("<chart");
		 xmldata5 = xmldata5.substr(startindex5);
		 chartReference.setXMLData(xmldata5);
	}
	function changeOrg6(){
	     var chartReference = FusionCharts("myChartId6");
	     var s_org_id = document.getElementsByName("s_org_id6")[0].value;
	     var s_pro_year6 = document.getElementsByName("s_pro_year6")[0].value;
	     var retObj6 = jcdpCallService("DevCommInfoSrv","getWutanTeamLiyongWanhaoInfosBase","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id+"&proYear="+s_pro_year6);
		 var xmldata6 = retObj6.xmldata;
		 var startindex6 = xmldata6.indexOf("<chart");
		 xmldata6 = xmldata6.substr(startindex6);
		 chartReference.setXMLData(xmldata6);
	}
	function changeOrg7(){
	     var chartReference = FusionCharts("myChartId7");
	     var s_org_id = document.getElementsByName("s_org_id7")[0].value;
	     var s_pro_year7 = document.getElementsByName("s_pro_year7")[0].value;
		 var retObj7 = jcdpCallService("DevCommInfoSrv","getWxCostDataForWutan","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id+"&proYear="+s_pro_year7);
		 var dataXml7 = retObj7.dataXML;
		 chartReference.setXMLData(dataXml7);
	}
	function popWutanWanhaoForMonth(obj){
		var s_org_id = document.getElementsByName("s_org_id2")[0].value;
		var obj = obj+"~"+s_org_id;
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanMonthWanhaoLiyongDrill.jsp?obj='+obj,'800:600');
	}
	function popWutanWHLYInfos(obj){
		var param6 = obj.split("~",-1);
		 var s_org_id = document.getElementsByName("s_org_id6")[0].value;
		 popWindow('<%=contextPath %>/rm/dm/panel/popWutanWHLYInfosDrill.jsp?code='+param6[0]+'&orgsubId='+s_org_id+'&proYear='+param6[1],'1200:600');
	}
	function popWutanxinduDisdrill(obj){
		var s_org_id = document.getElementsByName("s_org_id11")[0].value;
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanXinduDisDrill.jsp?code='+obj+'&orgsubId='+s_org_id,'800:600');
	}
	function popWutanTeamProDevInfos(obj){
		var param3 = obj.split("~",-1);
		var s_org_id = document.getElementsByName("s_org_id3")[0].value;
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanTeamProDevInfos.jsp?code='+param3[0]+'&orgsubId='+s_org_id+'&proYear='+param3[1],'800:600');
	}
	function popWutanTeamProCaijiDevInfos(obj){
		var param4 = obj.split("~",-1);
		var s_org_id = document.getElementsByName("s_org_id4")[0].value;
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanTeamProCaijiDevInfos.jsp?code='+param4[0]+'&orgsubId='+s_org_id+'&proYear='+param4[1],'800:600');
	}
	function popWutanTeamCostInfos(obj){
		var param5 = obj.split("~",-1);
		var s_org_id = document.getElementsByName("s_org_id5")[0].value;
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanTeamCLCostInfos.jsp?code='+param5[0]+'&orgsubId='+s_org_id+'&proYear='+param5[1],'1200:600');
	}
	function drillwx(obj){
		var param71 = obj.split("~",-1);
		var s_org_id = document.getElementsByName("s_org_id7")[0].value;
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDWXCostInfosForWutan.jsp?code='+param71[0]+'&orgsubId='+s_org_id+'&proYear='+param71[1],'950:600');
	}
	function drillxiaoyoupin(obj){
		var param72 = obj.split("~",-1);
		var s_org_id = document.getElementsByName("s_org_id7")[0].value;
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDXYPInfosForWutan.jsp?code='+param72[0]+'&orgsubId='+s_org_id+'&proYear='+param72[1],'950:600');
	}
	function getRootData(){
	   	var userid = '<%=orgId%>';
	   	var str = "<chart>";
	    //推土机
	    var retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=21&seqinfo=0");
    	str += retObj.xmldata;
    	//车装钻机
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=22&seqinfo=1");
    	str += retObj.xmldata;
    	//人抬化钻机
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=23&seqinfo=2");
    	str += retObj.xmldata;
    	//运输设备
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=24&seqinfo=3");
    	str += retObj.xmldata;
    	//发电机组
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=25&seqinfo=4");
    	str += retObj.xmldata;
    	//检波器
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=26&seqinfo=5");
    	str += retObj.xmldata;
    	
    	str +="</chart>";
    	
    	return str;
   }      
   function getLeafData(code){
	   var userid = '<%=orgId%>';
	   var str = "";
	   //推土机
	   var retObj = jcdpCallService("DevCommInfoSrv", "getDevLeafStatData", "userid="+userid+"&code="+code);
	   str = retObj.xmldata;
	   return str;
   }
   function getYunShuData(code,len){
	   var userid = '<%=orgId%>';
	   var str = "";
	   //推土机
	   var retObj = jcdpCallService("DevCommInfoSrv", "getYunShuStatData", "userid="+userid+"&code="+code+"&len="+len);
	   str = retObj.xmldata;
	   return str;
   }
   function getTouRuData(){
	   var userid = '<%=orgId%>';
	   var str = "<chart>";
	   //推土机
	   var retObj = jcdpCallService("DevCommInfoSrv", "getTouRuData", "userid="+userid);
	   str += retObj.xmldata;
	   str +="</chart>";
	   return str;
   }
 //弹出表格
   function alertTable(obj){
   	   
   	popWindow('<%=contextPath %>/rm/dm/panel/poptableOfWutanchu.jsp','800:600');
   }
 
   //第三级钻取
   function getThirdData(code,owninorgid){
   	   var userid = '<%=orgId%>';
   	   var str = "";
   	   //
   	   var retObj = jcdpCallService("DevCommInfoSrv", "getCompThirdDataForWutan", "userid="+userid+"&code="+code+"&owninorgid="+owninorgid);
   	   str = retObj.xmldata;
   	   return str;
   }
   function exportDataDoc(exportFlag){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		//主要设备基本情况统计表
		if("zysbjbqktjb"==exportFlag){
			submitStr="orgsubId=<%=orgsubId%>&exportFlag="+exportFlag;
		}
		//现场维修费用统计-物探处
		if("xcwxfytjwutanchu"==exportFlag){
			var s_org_id7 = document.getElementsByName("s_org_id7")[0].value;
			if(""==s_org_id7){
				s_org_id7="C105";//东方公司
			}
			var s_pro_year7 = document.getElementsByName("s_pro_year7")[0].value;
			submitStr="orgsubId="+s_org_id7+"&proYear="+s_pro_year7+"&exportFlag="+exportFlag;
		}
		//主要设备新度系数
		if("zysbxdxs"==exportFlag){
			var s_org_id11 = document.getElementsByName("s_org_id11")[0].value;
			submitStr="orgstrId=<%=orgstrId%>&drillLevel=1&orgsubId="+s_org_id11+"&exportFlag="+exportFlag;
		}
		//各项目主要设备投入统计
		if("gxmzysbtrtj"==exportFlag){
			var s_org_id3 = document.getElementsByName("s_org_id3")[0].value;
			var s_pro_year3 = document.getElementsByName("s_pro_year3")[0].value;
			submitStr="orgstrId=<%=orgstrId%>&orgsubId="+s_org_id3+"&proYear="+s_pro_year3+"&exportFlag="+exportFlag;
		}
		//各项目采集设备分布  
		if("gxmcjsbfb"==exportFlag){
			var s_org_id4 = document.getElementsByName("s_org_id4")[0].value;
			var s_pro_year4 = document.getElementsByName("s_pro_year4")[0].value;
			submitStr="orgstrId=<%=orgstrId%>&orgsubId="+s_org_id4+"&proYear="+s_pro_year4+"&exportFlag="+exportFlag;
		}
		//各项目费用分析
		if("gxmfyfx"==exportFlag){
			var s_org_id5 = document.getElementsByName("s_org_id5")[0].value;
			var s_pro_year5 = document.getElementsByName("s_pro_year5")[0].value;
			submitStr="orgstrId=<%=orgstrId%>&orgsubId="+s_org_id5+"&proYear="+s_pro_year5+"&exportFlag="+exportFlag;
		}
		//各项目主要设备完好率、利用率   
		if("gxmzysbwhllyl"==exportFlag){
			var s_org_id6 = document.getElementsByName("s_org_id6")[0].value;
			var s_pro_year6 = document.getElementsByName("s_pro_year6")[0].value;
			submitStr="orgstrId=<%=orgstrId%>&orgsubId="+s_org_id6+"&proYear="+s_pro_year6+"&exportFlag="+exportFlag;
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
   
   function showDialog(){
	   $.messager.show({
			title:'My Title',
			msg:'Message will be closed after 5 seconds.',
			timeout:5000,
			showType:'slide'
		});
   }
</script>  

<!-- 右下角弹窗 -->
<style>
.lightbox{width:300px;background:#FFFFFF;border:5px solid #ccc;line-height:20px;display:none; margin:0;}
.lightbox dt{background:#f4f4f4;padding:5px;}
.lightbox dd{ padding:20px; margin:0;}
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

<input type="button" value="右下角弹窗效果 " id="idBoxOpen2"  style="display:none;"/>
	<dl id="idBox2" class="lightbox">
	<dt><b>工作提醒消息</b><input align="right" type="button" value="关闭" id="idBoxClose2" /></dt>
	<dd>
		<a href="<%=contextPath %>/rm/dm/panel/devcieHireList.jsp" /><div id = "showCount"></div></a>
		<a href="<%=contextPath %>/rm/dm/deviceAccount/devAccSyncIndex.jsp" /><div id = "showAddCount"></div></a>
	</dd>
</dl>
<script>
(function(){
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
}
$$("idBoxOpen2").onclick = function(){ 
    var obj = jcdpCallService("DevInsSrv", "getDeviceHireProjectCount","orgSubId=<%=orgsubId %>");
    var str = "";
    str=obj.procount;
    if(str !="0" && str !=""){
    	document.getElementById("showCount").innerText="还有"+str+"个项目未进行返还,请尽快进行返还!";
    	ab.show();
    }
    var dataEntity = jcdpCallService("DevInsSrv", "getDeviceSynsCount","orgSubId=<%=orgsubId %>");
    var  count =dataEntity.count;
    if(count !="0" && count !=""){ 
    	document.getElementById("showAddCount").innerText="存在已转资但未同步设备"+count+"台!";
    	ab.show();

    }
	 }
})()
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
		//获取项目年度
		var proYearRetObj = jcdpCallService("DevInsSrv", "getProjectYear","");
		var proYearData = proYearRetObj.data;
		//获取当前年度
		var curYear='<%=yearinfo%>';
		if(null!=proYearData && proYearData.length>0){
			for(var i=0;i<proYearData.length;i++){
				//判断项目年度是否包含当前年度(项目年度倒序排列，只判断第一个值即可)
				if(i==0){
					if(proYearData[0].project_yea != curYear){
						// 给 各项目主要设备投入统计，各项目采集设备分布，各项目费用分析，各项目主要设备完好率、利用率，现场维修费用统计 赋值
						for(var j=3;j<=7;j++){
							$("#s_pro_year"+j).append("<option value='"+curYear+"'>"+curYear+"年</option>");
						}
					}else{
						for(var j1=3;j1<=7;j1++){
							$("#s_pro_year"+j1).append("<option value='"+proYearData[0].project_year+"'>"+proYearData[0].project_year+"年</option>");	
						}
					}
				}else{
					for(var j2=3;j2<=7;j2++){
						$("#s_pro_year"+j2).append("<option value='"+proYearData[i].project_year+"'>"+proYearData[i].project_year+"年</option>");	
					}
				}
			}
		}
	})
</script>
</html>

