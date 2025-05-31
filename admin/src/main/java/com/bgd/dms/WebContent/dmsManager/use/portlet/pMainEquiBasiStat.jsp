<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubId = user.getSubOrgIDofAffordOrg();
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span>主要设备基本情况统计表</span>
					<select id="pmebs_org_sub_id" name="org_sub_id" class="select">
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
			    		<option value="C105006">装备服务处</option>
			    	</select>
			    	<span>&nbsp;</span>
			    	<span>是否生产设备：</span>
					<select id="pmebs_ifproduction" name="ifproduction" class="select">
						<option value="5110000186000000001">生产设备</option>
						<option value="">全部</option>
			    	</select>
			    	<span>&nbsp;</span>
			    	<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="pmebsToQuery()"/>
		    		<span>&nbsp;</span>
		    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="pmebsToClear()"/>
				</div>
				<div class="tongyong_box_content_left" style="height: 300px;overflow-x:hidden;">
					<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="tab_info" id="pmebs_device_content">
						<tr class="trHeader">
						  	<td class="bt_info_odd" rowspan="2">设备类别</td> 
						  	<td class="bt_info_even" rowspan="2">单位</td>
						  	<td class="bt_info_odd" rowspan="2">国内/国外</td>
						  	<td class="bt_info_even" rowspan="3">总量</td>
						  	<td class="bt_info_odd" colspan="2">完好</td>
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
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	pmebsLoadTable('','5110000186000000001');
	//加载主要设备基本情况统计表
	function pmebsLoadTable(suborg,ifproduction){
		var wutanorg = '';
		if(suborg!=undefined && suborg!=''){
			wutanorg = suborg;
		}else{
			wutanorg = '<%=orgsubId%>';
		}
		if("undefined"== typeof ifproduction){
			ifproduction='';
		}
		var retObj = jcdpCallService("MainEquiBasiStatSrv", "getTableChartData","wutanorg="+wutanorg+"&ifproduction="+ifproduction);
		if(retObj!=null && retObj.returnCode=='0'){
			var pmebs_device_content = document.getElementById("pmebs_device_content");
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var map = retObj.datas[i];
				if(map!=null){
					with(map){
						var tr = pmebs_device_content.insertRow(i*2-(-2));
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
						
						var tr = pmebs_device_content.insertRow(i*2-(-3));
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
			pmebsChangeTable('pmebs_device_content',2);
		}	
	}
	function pmebsChangeTable(table_name,rowIndex){
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
	function pmebsToQuery(){
		$("#pmebs_device_content tr[class!='trHeader']").remove();
	    var s_org_id = document.getElementById("pmebs_org_sub_id").value;
	    var ifproduction = document.getElementById("pmebs_ifproduction").value;
	    //加载主要设备基本情况统计表
		pmebsLoadTable(s_org_id,ifproduction);
	}
	function pmebsToClear(){
		$("#pmebs_device_content tr[class!='trHeader']").remove();
		$("#pmebs_org_sub_id").val('');
		$("#pmebs_ifproduction").val('5110000186000000001');
	    //加载主要设备基本情况统计表
	    pmebsLoadTable('','5110000186000000001');
	}
</script>

