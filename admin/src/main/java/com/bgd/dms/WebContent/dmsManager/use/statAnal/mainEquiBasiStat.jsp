<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="${pageContext.request.contextPath}/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<title>主要设备基本情况统计表</title>
	</head>
<body style="background: #cdddef; overflow-y: auto">
	<table width="99%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div class="tongyong_box">
					<div class="tongyong_box_title">
						<span>主要设备基本情况统计表</span>
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
				    	<span>是否生产设备：</span>
						<select id="ifproduction" name="ifproduction" class="tongyong_box_title_select">
							<option value="5110000186000000001">生产设备</option>
							<option value="">全部</option>
				    	</select>
 
				    	<span>&nbsp;</span>
				    	<span>&nbsp;是否在账：</span>
								<select id="account_stat" name="account_stat" class="select">
									<option value="0110000013000000003">在账</option>
									<option value="">全部</option>
						    	</select>
						 <span>&nbsp;</span>
 						<input type="button" value="查询" class="tongyong_box_title_button" onclick="toQuery()"/>
			    		<input type="button" value="清除" class="tongyong_box_title_button" onclick="toClear()"/>
				    	
 
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
</body>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	function frameSize(){
		$("#chartContainer1").css("height",$(window).height()-$(".tongyong_box_title").height()-10);
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		getFusionChart();
	});
	function getFusionChart(){
		//加载主要设备基本情况统计表
		loadTable('','5110000186000000001','');
	}
	//加载主要设备基本情况统计表
	function loadTable(suborg,ifproduction,account_stat){
		var wutanorg = '';
		if(suborg!=undefined && suborg!=''){
			wutanorg = suborg;
		}else{
			wutanorg = '<%=orgsubId%>';
		}
		if("undefined"== typeof ifproduction){
			ifproduction='';
		}
		var retObj = jcdpCallService("MainEquiBasiStatSrv", "getTableChartData","wutanorg="+wutanorg+"&ifproduction="+ifproduction+"&account_stat="+account_stat);
		if(retObj!=null && retObj.returnCode=='0'){
			var device_content = document.getElementById("device_content");
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var map = retObj.datas[i];
				if(map!=null){
					with(map){
						var tr = device_content.insertRow(i*2-(-2));
						var td = tr.insertCell(0);
						td.rowSpan = 2;
						td.innerHTML = "<a href='#' onclick=fusionChart('"+device_code+"','"+wutanorg+"','2','"+ifproduction+"')><font color='blue'>"+device_name+"</font></a>";					
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
	function fusionChart(parentCode,wutanorg,level,ifproduction){
		popWindow('<%=contextPath %>/dmsManager/use/statAnal/nextLevelMainEquiBasiStat.jsp?parentCode='+parentCode+'&wutanorg='+wutanorg+'&level='+level+'&ifproduction='+ifproduction,'850:550');
	}
	function toQuery(){
		$("#device_content tr[class!='trHeader']").remove();
	    var s_org_id = document.getElementById("org_sub_id").value;
	    var ifproduction = document.getElementById("ifproduction").value;
	    var account_stat=document.getElementById("account_stat").value;
	    //加载主要设备基本情况统计表
		loadTable(s_org_id,ifproduction,account_stat);
	}
	function toClear(){
		$("#device_content tr[class!='trHeader']").remove();
	    $("#org_sub_id").val('');
	     $("#account_stat").val('');
	    $("#ifproduction").val('5110000186000000001');
	    //加载主要设备基本情况统计表
	    loadTable('','5110000186000000001','');
	}
</script>
</html>

