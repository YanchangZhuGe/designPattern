<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	String parentCode = request.getParameter("parentCode");
	String wutanorg = request.getParameter("wutanorg");
	String level = request.getParameter("level");
	String ifproduction = request.getParameter("ifproduction");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="${pageContext.request.contextPath}/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<title>主要设备基本情况统计表</title>
	</head>
<body style="background: #cdddef; overflow-y: auto"  onload="getFusionChart()">
	<div id="list_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div class="tongyong_box">
						<div class="tongyong_box_title">
							<span>主要设备基本情况统计表&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<input type="button" value="返回上级" class="tongyong_box_title_button" style="width:70px;" onclick="toBack()"/>
						</div>
						<div class="tongyong_box_content_left" style="overflow-x:hidden;" id="chartContainer1">
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
								  	<td class="bt_info_odd">在用（不含报废）</td>
								  	<td class="bt_info_even">在用（含报废）</td>
								  	<td class="bt_info_odd">闲置</td> 
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>
</body>
<script type="text/javascript">


	function frameSize(){
		$("#chartContainer1").css("height",$(window).height()-$(".tongyong_box_title").height()-20);
	}
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	});
	cruConfig.contextPath='<%=contextPath%>';
	var iparentCode='<%=parentCode%>';
	var iwutanorg='<%=wutanorg%>';
	var ilevel='<%=level%>';
	var _ifproduction='<%=ifproduction%>';
	function getFusionChart(){
		//加载主要设备基本情况统计表
		loadTable(iparentCode,iwutanorg,ilevel,_ifproduction);
	}
	//加载主要设备基本情况统计表
	function loadTable(parentCode,wutanorg,level,ifproduction){
		var nlevel=parseInt(level)+1;
		var retObj = jcdpCallService("MainEquiBasiStatSrv", "getTableChartData","parentCode="+parentCode+"&wutanorg="+wutanorg+"&level="+level+"&ifproduction="+ifproduction);
		if(retObj!=null && retObj.returnCode=='0'){
			var device_content = document.getElementById("device_content");
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var map = retObj.datas[i];
				if(map!=null){
					with(map){
						var tr = device_content.insertRow(i*2-(-2));
						var td = tr.insertCell(0);
						td.rowSpan = 2;
						//地震仪器子类型只钻取到一级
						if(device_code.indexOf("D001")!=-1){
							td.innerHTML = device_name;	
						}
						//检波器子类型只钻取到二级
						if(device_code.indexOf("D005")!=-1){
							// 检波器 井下检波器不进行钻取
							if(device_code.indexOf("D005003")!=-1){
								td.innerHTML = device_name;	
							}else{
								if(level<3){
									td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+nlevel+"')><font color='blue'>"+device_name+"</font></a>";					
								}else{
									td.innerHTML = device_name;		
								}
							}
						}
						//可控震源,钻机,运输设备,最后显示详细信息
						if(device_code.indexOf("D002")!=-1||device_code.indexOf("D003")!=-1||device_code.indexOf("D004")!=-1){
							// 运输设备 爆破器材运输车,直接展现列表数据
							if(device_code.indexOf("D004003")!=-1){
								td.innerHTML = device_name;		
							}else{
								if(level<3){
									td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+nlevel+"')><font color='blue'>"+device_name+"</font></a>";					
								}else{
									td.innerHTML = device_name;		
								}
							}
						}
						//推土机子类型只钻取到一级
						if(device_code.indexOf("D006")!=-1){
							td.innerHTML = device_name;	
						}
						td = tr.insertCell(1);
						td.rowSpan = 2;
						td.innerHTML = unit ;
						td = tr.insertCell(2);
						td.innerHTML = "国内" ;
						td = tr.insertCell(3);
						td.innerHTML = sum_num_in;
						td = tr.insertCell(4);
						td.innerHTML = use_num_in;
						td = tr.insertCell(5);
						td.innerHTML = scrap_num_in;
						td = tr.insertCell(6);
						td.innerHTML = idle_num_in;
						td = tr.insertCell(7);
						td.innerHTML = repairing_num_in;
						td = tr.insertCell(8);
						td.innerHTML = wait_repair_num_in;
						td = tr.insertCell(9);
						td.innerHTML = wait_scrap_num_in;
						td = tr.insertCell(10);
						td.innerHTML = onway_num_in;
						
						var tr = device_content.insertRow(i*2-(-3));
			            td = tr.insertCell(0);
			            td.innerHTML = "国外";
			            td = tr.insertCell(1);
			            td.innerHTML = sum_num_out;
			            td = tr.insertCell(2);
			            td.innerHTML = use_num_out;
			            td = tr.insertCell(3);
			            td.innerHTML = scrap_num_out;
			            td = tr.insertCell(4);
			            td.innerHTML = idle_num_out;
			            td = tr.insertCell(5);
			            td.innerHTML = repairing_num_out;
			            td = tr.insertCell(6);
			            td.innerHTML = wait_repair_num_out;
			            td = tr.insertCell(7);
			            td.innerHTML = wait_scrap_num_out;
			            td = tr.insertCell(8);
			            td.innerHTML = onway_num_out;
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
	function fusionChart(parentCode,level){
		$("#device_content tr[class!='trHeader']").remove();
		iparentCode=parentCode;
		ilevel=level;
		//加载主要设备基本情况统计表
		loadTable(iparentCode,iwutanorg,ilevel,_ifproduction);
	}
	function toBack(){
		if(ilevel>2){
			$("#device_content tr[class!='trHeader']").remove();
			//上级级别
			ilevel=parseInt(ilevel)-1;
			//上级编码
			iparentCode=iparentCode.substr(0,(ilevel-1)*3+1);
			loadTable(iparentCode,iwutanorg,ilevel,_ifproduction);
		}else{
			newClose();
		}
	}
</script>
</html>

