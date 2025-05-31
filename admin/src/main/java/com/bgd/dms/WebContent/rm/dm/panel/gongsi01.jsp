<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
    <%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
%>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet" type="text/css" />
<div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div class="tongyong_box">
					<div class="tongyong_box_title">
						<span class="kb"></span>
						<select name="rdpgs_org_id_wutan" onchange="rdpgsChangeWuTanOrg()">
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
					</div>
					<div class="tongyong_box_content_left" style="height: 230px;">
						<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="tab_info" id="rdpgs_device_content">
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
</div>
<script type="text/javascript">

cruConfig.contextPath='<%=contextPath%>';
rdpgsGetFusionChart();

function rdpgsGetFusionChart(suborg){
	var wutanorg = '';
	if(suborg!=undefined && suborg!=''){
		wutanorg = suborg;
	}else{
		wutanorg = '<%=orgsubId%>';
	}
	var retObj = jcdpCallService("DevInsSrv", "getTableChartData","wutanorg="+wutanorg);

	if(retObj!=null && retObj.returnCode=='0'){
		var rdpgs_device_content = document.getElementById("rdpgs_device_content");
		for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
			var map = retObj.datas[i];
			if(map!=null){
				with(map){
					var tr = rdpgs_device_content.insertRow(i*2-(-2));
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
					
					var tr = rdpgs_device_content.insertRow(i*2-(-3));
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
		rdpgsChangeTable('rdpgs_device_content',2);
	}	
}
//parentCode：父编码，wutanorg：单位，ifCountry：国内/国外，analType：统计类型，level：编码级别
function fusionChart(parentCode,wutanorg,ifCountry,analType,level){
	popWindow('<%=contextPath %>/rm/dm/panel/poptableOfGongsi.jsp?parentCode='+parentCode+'&wutanorg='+wutanorg+'&ifCountry='+ifCountry+'&analType='+analType+'&level='+level,'1024:720');
}
function rdpgsChangeTable(table_name,rowIndex){
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

function rdpgsChangeWuTanOrg(){
	$("#rdpgs_device_content tr[class!='trHeader']").empty();
     var s_org_id = document.getElementsByName("rdpgs_org_id_wutan")[0].value;
    //加载主要设备基本情况统计表
	rdpgsGetFusionChart(s_org_id);
}

</script>
</html>