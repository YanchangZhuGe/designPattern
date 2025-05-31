<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
	String org_name=user.getOrgName();

	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar
			.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar
			.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);
	String apply_id=request.getParameter("apply_id");
	String employee_id=request.getParameter("employee_id_code_no");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<style type="text/css">
btn {
	background-image: url("../images/images/gl.png");
}
body { font-family: Arial， Helvetica， sans-serif; font-size:16px; }
</style>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
<title>操作证用户详细页面-打印</title>
</head>
 <body style="background: #cdddef; overflow-y: auto;"  onload="loadEmployeeInfo()"> 
	<form name="form" id="form" method="post" enctype="multipart/form-data" action="<%=contextPath%>/dmsManager/opcard/saveOrUdateOp_cardApply.srq?flag=add">
	<div id="list_content">
	<table id="printcontent" width="100%" border="0" cellspacing="0" cellpadding="0">
	<div id="bottomnav0" style="display:none; position:fixed; top:100;right:0;left:0"><img src="<%=contextPath%>/images/shuiyin.png"></img></div>
			<tr>
				<td valign="top" id="td0">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="center"   >
								<table width="50%" border="0" cellspacing="0" cellpadding="0" id="table0" >
									<tr>
										<td width="50%" >
											<div class="tongyong_box">
												<div class="tongyong_box_title" align="center">
													<span class="kb"><a href="####"></a></span>东方地球物理公司设备操作证<span class="gd"><a href="####"></a></span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer1"  
													style="overflow-x: hidden;font:26px bold">
													<table width="50%" border="0" cellspacing="0"
														cellpadding="0" class="tab_info" style="height:350px;">
														<tr class="trHeader">
														<td class="bt_info_odd">姓名：<span id="employee_name" readonly="readonly"></span></td>
														<td class="bt_info_odd" id="employee_img" rowspan="4">   </td>
														</tr>
														<tr class="trHeader">
														<td class="bt_info_even">性别：<span id="employee_gender" readonly="readonly"></span></td>
														</tr>
														<tr class="trHeader">
														<td class="bt_info_even">员工编号：<span id="employee_cd" readonly="readonly"></span></td>
														</tr>
														<tr>
														<td class="bt_info_odd">身份证：<span id="employee_id" readonly="readonly"></span></td>
														</tr>
													 	<tr>
													 	<td class="bt_info_odd"  >发证时间：<span readonly="readonly" id="modifi_date"></span></td>
													 	<td class="bt_info_even"  id="status_date"> </td>
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
			</tr>
			<tr>
			<td id="temp" align="center">
		   	<table width="50%" border="0" cellspacing="0" cellpadding="0" id='table1' >
									<tr>
										<td width="70%" >
											<div class="tongyong_box">
												<div class="tongyong_box_title" align="center">
													<span class="kb"><a href="####"></a></span>东方地球物理公司设备操作证副证<span class="gd"><a href="####"></a></span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer1"
													style="overflow-x: hidden;">
													<table width="30%" border="0" cellspacing="0"
														cellpadding="0" class="tab_info" style="height:350px;" >
														<tr class="trHeader">
															<td class="bt_info_odd">准许类别<span id="employee_name" readonly="readonly"></span></td>
															<td class="bt_info_even">准许型号<span id="employee_name" readonly="readonly"></span></td>
															<td class="bt_info_odd">审验日期<span id="employee_name" readonly="readonly"></span></td>
															<td class="bt_info_even">审验人<span id="employee_name" readonly="readonly"></span></td>
														</tr>
														<tbody id="trdata">
														</tbody>													 	 
													</table>
												</div>
											</div>
										</td>
									</tr>
			 </table>
			</td>
			</tr>
			<tbody id="table111"></tbody>
			<tr>			 
			<td  align="center"> 
			<span class="dy_btn"><a href="####" onclick="printme()"></a></span> 
        	<span class="gb_btn"><a href="####" onclick="toClose()"></a></span></td>
			</tr>
		</table>
		
	</div>
	</form>
	
</body>
<script type="text/javascript">
var typecount=0;
 	  function printme()
 	{
 		// WebBrowser.ExecWB(7,1); 
 		document.body.innerHTML=document.getElementById('printcontent').innerHTML;
 		window.print();
 		}
	//根据身份证号查询员工信息
	function loadEmployeeInfo(){
		
		var baseData = jcdpCallService("DevCardSrv", "getApplyInfoByEmployee_idFY", "employee_id=<%=employee_id%>");
		debugger;
		if (typeof baseData.datas != "undefined"&&baseData.datas.length!=0){
	 		var map=baseData.datas[0];
 	 		var d = new Date(map.modifi_date.replace('-','/').replace('-','/'));
			  d.setFullYear(d.getFullYear() + 2);
			  d.setMonth(d.getMonth() + 1) ;
 
		 	$("#modifi_date").html(map.modifi_date);
		 	for(var i=0;i<baseData.datas.length;i++){
		 		if(typecount%5==0&&baseData.datas.length>5&&typecount!=0){
			 		 
		 			$("#table111").append('<tr><td align="center">'
		 				   	+' <table border="0" cellpadding="0" id="table'+(i+1)+'" cellspacing="0" width="50%">'
		 				   +'<tbody><tr>'
		 				  +'<td width="30%">'
		 				 +'<div class="tongyong_box">'
		 				+'	<div class="tongyong_box_title" align="center">'
		 				+'			<span class="kb"><a href="####"></a></span>东方地球物理公司设备操作证副证<span class="gd"><a href="####"></a></span>'
		 				+'			</div>'
		 				+'				<div class="tongyong_box_content_left" id="chartContainer1" style="overflow-x: hidden;">'
		 				+'					<table class="tab_info" border="0" cellpadding="0" cellspacing="0" style="height:350px;" width="30%">'
		 				+'						<tbody><tr class="trHeader">'
		 				+'							<td class="bt_info_odd">准许类别<span id="employee_name" readonly="readonly"></span></td>'
		 				+'							<td class="bt_info_even">准许型号<span id="employee_name" readonly="readonly"></span></td>'
		 				+'							<td class="bt_info_odd">审验日期<span id="employee_name" readonly="readonly"></span></td>'
		 				+'							<td class="bt_info_even">审验人<span id="employee_name" readonly="readonly"></span></td>'
		 				+'						</tr>'
		 				+'						</tbody>'
		 				+'					<tbody id="trdata">'
		 				+'						</tbody>'
		 				+'					</table>'
		 				+'				</div>'
		 				+'			</div>'
		 				+'		</td>'
		 				+'	</tr>'
		 				+'</tbody></table>'
						+' </td></tr>');		 			
		 		}
		 		var map=baseData.datas[i];
		 		var html="<tr>";
			 		html=html+"<td>"+map.type+"</td>";
			 		html=html+"<td>"+map.name+"</td>";
		 			html=html+"<td>"+map.examine_end_date+"</td>";
		 			html=html+"<td>"+map.examine_user_name+"</td>";
		 		 
			 		if(map.curstate=='审核通过'){
			 			 var index=$('[id=trdata]').length-1;
			 			$( $("[id='trdata']")[index]).append(html+"</tr>");
			 			typecount=typecount+1;
			 		}
		 		  		
		 	}
		}
		 
				var retObj1 = jcdpCallService("DevCardSrv", "loadEmployeeInfoByApplID", "employee_id=<%=employee_id%>");
				if (typeof retObj1.datas != "undefined"&&retObj1.datas.length!=0){
	 				var map=retObj1.datas[0];
	 				 $("#employee_name").html(map.employee_name);
	 				 $("#employee_gender").html(map.employee_gender);
	 				 $("#employee_id").html(map.employee_id_code_no);
	 				 $("#employee_cd").html(map.employee_cd);
	 				 $("#work_date").html(map.work_date);
	 				 
				 var html='';
					if(map.employee_cd==''){
					html=html+"<img style='width: 85px; height: 120px' src='<%=contextPath%>/doc/downloadDoc.srq?docId="+map.file_id+"' />";
					}else{
					html=html+" <img style='width: 85px; height: 120px' src='http://10.88.2.241:8080/hr_photo/"+map.employee_cd.substr(0,5)+"/"+map.employee_cd+".JPG' /> ";
					}
					$("#employee_img").append(html);
				 	
				}	
				 $("TD").css('font-size','16px');
	 	//为每个表格加上水印
		 var  shuiyi11 = new Array('0');
		 for(var key in shuiyi11){
			if(typeof $('#table'+shuiyi11[key]) != "undefined"){ 			   		
			var X = $('#table'+shuiyi11[key]).offset().top; 
			var Y = $('#table'+shuiyi11[key]).offset().left;
				$("#bottomnav"+shuiyi11[key]).show();
				$("#bottomnav"+shuiyi11[key]).css({position: "absolute",'top':X+180,'left':Y+300,'z-index':999});  
			}
	     }    
		 
		
	}
	
	function toClose(){
		newClose();
	}	   
</script>
</html>

