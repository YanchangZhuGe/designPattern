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
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
	
	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.messager.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>公司级仪表盘</title>
</head>
<body style="background: #cdddef; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">主要设备基本情况统计表</a><span class="gd"><a
							href="#"></a></span>
							<select name='s_org_id_wutan' onchange="changeWuTanOrg()">
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
								<a href="#" onclick="exportDataDoc('zysbjbqktjb')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer1" style="overflow-x:hidden;height: 230px;">
			 				<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="tab_info" id="device_content">
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
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
							<div class="tongyong_box">
								<div class="tongyong_box_title"><span class="kb"><a
									href="#"></a></span><a href="#" onclick="alertTable()">地震仪器动态情况</a><span class="gd"><a
									href="#"></a></span>
									<span class="dc" style="float:right;margin-top:-4px;">
										<a href="#" onclick="exportDataDoc('dzyqdtqk')" title="导出excel"></a>
									</span>
								</div>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;"></div>
							</div>
						</td>
						<td width="1%"></td>
						<td>
							<div class="tongyong_box">
							<div class="tongyong_box_title"><span class="kb"><a
								href="#"></a></span><a href="#">地震仪器损失情况</a><span class="gd"><a
								href="#"></a></span>
								<select name='s_org_id_lost' onchange="changeOrgForLost()">
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
									<a href="#" onclick="exportDataDoc('dzyqssqk')" title="导出excel"></a>
								</span>	
							</div>
							<div class="tongyong_box_content_left" id="chartContainer22" style="height: 250px;">
			
							</div>
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
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">主要设备新度系数</a><span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('zysbxdxs')" title="导出excel"></a>
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
								href="#"></a></span><a href="#">主要设备完好率、利用率统计</a>
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
							</div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;">

						</div>
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
		//加载主要设备基本情况统计表
		loadTable();
		//地震仪器
		var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "myChartId2", "100%", "250", "0", "0" );    
		myChart2.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompEqChart.srq");      
		myChart2.render("chartContainer2"); 
		
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" );    
		var retObj3 = jcdpCallServiceCache("DevCommInfoSrv","getComXindu","code=<%=orgstrId%>");
		var xmldata = retObj3.xmldata;
		var startindex = xmldata.indexOf("<chart");
		xmldata = xmldata.substr(startindex);
		myChart3.setXMLData(xmldata);
		myChart3.render("chartContainer3"); 
		
		var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId4", "100%", "250", "0", "0" );    
		myChart4.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompDevRatioChartWTNew.srq?orgstrId=<%=orgstrId%>&drilllevel=0");
		myChart4.render("chartContainer4");
		//地震仪器损失情况 chartContainer22
		var retObj22  = jcdpCallServiceCache("DevCommInfoSrv", "getCompEqDestroy", "");
		var dataXml22 = retObj22.dataXML;
		$("#chartContainer22").append(dataXml22);
	}
	//加载主要设备基本情况统计表
	function loadTable(suborg){
		var wutanorg = '';
		if(suborg!=undefined && suborg!=''){
			wutanorg = suborg;
		}else{
			wutanorg = '<%=orgsubId%>';
		}
		var retObj = jcdpCallService("DevInsSrv", "getTableChartData","wutanorg="+wutanorg);
	
		if(retObj!=null && retObj.returnCode=='0'){
			var device_content = document.getElementById("device_content");
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var map = retObj.datas[i];
				if(map!=null){
					with(map){
						var tr = device_content.insertRow(i*2-(-2));
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
						
						var tr = device_content.insertRow(i*2-(-3));
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
		popWindow('<%=contextPath %>/rm/dm/panel/poptableOfGongsi.jsp?parentCode='+parentCode+'&wutanorg='+wutanorg+'&ifCountry='+ifCountry+'&analType='+analType+'&level='+level,'1024:720');
	}
	function popzaiyongdrill(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popChartOfEqZaiyongChartDrill.jsp?code='+obj,'800:600');
	}
	function popxianzhidrill(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popChartOfEqXianzhiChartDrill.jsp?code='+obj,'800:600');
	}
	function popComxinduDisdrill(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popComXinduDisDrill.jsp?code='+obj,'800:600');
	}
	//function popCompLVDrill(obj){
	//	popWindow('<%=contextPath %>/rm/dm/panel/popCompLVDrill.jsp?code='+obj,'800:600');
	//}
	function changeYear(){
	    var chartReference = FusionCharts("myChartId4");     
	    var yearinfo = document.getElementsByName("yearinfo")[0].value;
	    var orgstrId='<%=orgstrId%>';
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWTNew.srq?yearinfo="+yearinfo+"&orgstrId="+orgstrId+"&drilllevel=0");
	}
	function popComWanhaoForMonth(obj){
	    popWindow('<%=contextPath %>/rm/dm/panel/popComMonthWanhaoLiyongDrill.jsp?monthinfo='+obj , '800:600');
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
		popWindow('<%=contextPath %>/rm/dm/panel/poptableOfGongsi1.jsp','800:600');
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
		popWindow("<%=contextPath%>/rm/dm/panel/popOfCompThirdData.jsp?devname="+devname+"&zsnum="+zsnum+"&code="+code+"&usageorgid="+usageorgid,'650:680');
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
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
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
<input type="button" value=" 右下角弹窗效果 " id="idBoxOpen2" style="display:none;"/>
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
</html>

