<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	String dateinfo=request.getParameter("dateinfo")==null?"":request.getParameter("dateinfo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>无标题文档</title> 
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart1()">
<div id="list_content" >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<!--
					<tr>
						<td width="100%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">机械设备强制保养计划运行表</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 460px;">
							<div style="width: 95%">
						      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								  	<tr align="left">
								  		<td >查询日期</td>
								  		<td >
								  			<select  name='querydate' id="querydate" value=""  onchange="datechange()">
												
											</select>
										</td>
									</tr>
								  </table>
							  </div>
			 					<table id="byMap" width="250%" border="2" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
								  <tr id="titletr" >  
									  <td class="bt_info_even" >序号</td>
									  <td class="bt_info_odd" >设备名称</td>
									  <td class="bt_info_even" >设备型号</td>
									  <td class="bt_info_odd">牌照号</td>
									  <td class="bt_info_even" >自编号</td>
									  <td class="bt_info_odd">实物标识号</td>
									  <td class="bt_info_even" >操作手</td>
								  </tr>
								  <tbody id="assign_body"></tbody>
							  </table>
						</div>
						</div>
						</td>
					</tr>
					-->
					<tr>
						<td width="100%">
						<div class="tongyong_box">
						<div class="tongyong_box_title" ><span class="kb"><a
							href="#"></a></span><a href="#">机械设备强制保养计划运行表</a><span class="gd"><a
							href="#"></a></span></div>
						<div align="left" class="tongyong_box_content_left" style="padding-top:5px;padding-bottom:5px;">
							&nbsp;图例：&nbsp;
							<span style="background:#00E050;">&nbsp;&nbsp;计划日期&nbsp;&nbsp;</span>
							<span style="background:#FF0000;">&nbsp;&nbsp;实际保养日期&nbsp;&nbsp;</span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer2" style="height: 450px;">
			 					
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
function datechange(){
	var dateinfo=document.getElementById("querydate").value;
    window.location.href = "qzbyPanel.jsp?dateinfo="+dateinfo;
}
var dateinfo='<%=dateinfo%>';
function init(){
	var projectInfoNo='<%=projectInfoNo%>';
	//查询日期
	var dateSql=" select min(dui.planning_in_time) as mindate,max(dui.planning_out_time) as maxdate "+
                "from gms_device_account_dui dui "+
                "where dui.project_info_id='"+projectInfoNo+"'";
	var dateRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+dateSql);
	var dateObj = dateRet.datas;
	var regEx = new RegExp("\\-","gi");
    var mindaystr=dateObj[0].mindate.replace(regEx,"/");
	minday = new Date(mindaystr);
	var maxdaystr=dateObj[0].maxdate.replace(regEx,"/");
	maxday = new Date(maxdaystr);
	var startDay = dateObj[0].mindate.replace(regEx,"/");
	startDay = new Date("2012/04/01");
	
	if(minday.getFullYear()==maxday.getFullYear()){
		
		for(var i=0;i<=(maxday.getMonth()-minday.getMonth());i++){
			
			document.getElementById("querydate").options.add(new Option(minday.getFullYear()+"-"+(minday.getMonth()+i+1),minday.getFullYear()+"/"+(minday.getMonth()+i+1)+"/"+1));
		}
	}
	else{//修改
		for(var i=0;i<=(maxday.getFullYear()-minday.getFullYear())*12-minday.getMonth()+1+maxday.getMonth();i++ ){
			if((minday.getMonth()+i+1))
			document.getElementById("querydate").options.add(new Option(minday.getFullYear()+"-"+(minday.getMonth()+i+1),minday.getFullYear()+"/"+(minday.getMonth()+i+1)+"/"+1));
		}
	}
	var index=document.getElementById("querydate").selectedIndex; //序号，取当前选中选项的序号
 
    var val = document.getElementById("querydate").options[index].value;
	if(dateinfo==""){
		dateinfo=val;
		
	}
	else{
		document.getElementById("querydate").value=dateinfo;
	}
	
		getFusionChart(dateinfo);
}
function getFusionChart(val){
	var projectInfoNo='<%=projectInfoNo%>';
	//查询台账
	var querySql="select  t1.dev_acc_id,t1.dev_name,t1.dev_model,t1.license_num,t1.dev_type,t1.self_num,t1.dev_sign from "+
			"(select dui.dev_acc_id,dui.dev_name,dui.dev_model,dui.license_num,dui.dev_type,dui.self_num,dui.dev_sign,oprtbl.alloprinfo "+
			"from gms_device_account_dui dui "+
			"where (substr(dui.dev_type,2,6)='070301' or substr(dui.dev_type,2,2) ='08' or substr(dev_type,2,4) ='0901'  or substr(dui.dev_type,2,4)='0601') "+
			"and dui.bsflag='0' and dui.project_info_id='"+projectInfoNo+"') t1 "+
			"left join (select device_account_id,wmsys.wm_concat(operator_name) "+
			"over(partition by device_account_id order by operator_name) as alloprinfo "+
			"from gms_device_equipment_operator) oprtbl on t1.dev_acc_id = oprtbl.device_account_id "+
			"left join "+
			"(select plan1.dev_acc_id,plan1.plan_date from gms_device_maintenance_plan plan1 "+
			"where plan1.plan_date=(select min(plan2.plan_date) from gms_device_maintenance_plan plan2 where plan2.dev_acc_id=plan1.dev_acc_id) "+
			")t2 on t2.dev_acc_id=t1.dev_acc_id "+
			"order by t1.dev_type,t2.plan_date";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
	var retObj = queryRet.datas;
	//查询日期
	/*var dateSql=" select min(dui.planning_in_time) as mindate,max(dui.planning_out_time) as maxdate "+
                "from gms_device_account_dui dui "+
                "where dui.project_info_id='"+projectInfoNo+"'";
	var dateRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+dateSql);
	var dateObj = dateRet.datas;*/
	var regEx = new RegExp("\\-","gi");
    //var mindaystr=dateObj[0].mindate.replace(regEx,"/");
	minday = new Date(val);
	//var maxday=dateObj[0].maxdate.replace(regEx,"/");
	maxday = new Date(val);
	//var startDay = dateObj[0].mindate.replace(regEx,"/");
	startDay = new Date("2012/04/01");
	
	var datetdstr = "";
	//动态生成表头
	var datelen=0;
	for(var d=minday;d.getMonth()==maxday.getMonth();d.setDate(d.getDate()+1)){
		var learntd1 = document.createElement('td');
		learntd1.className = "odd_odd";
		if((d.getMonth()+1)<10)
		  var monstr = '0'+(d.getMonth()+1);
		else 
		  monstr =  (d.getMonth()+1);
		if(d.getDate()<10)
		  var daystr = '0'+d.getDate();
		else 
		  daystr =  d.getDate();
		learntd1.innerText = monstr+"-"+daystr;
		datetdstr += "<td dateinfo='"+d.getFullYear()+"-"+learntd1.innerText+"'></td>";
	    $("#titletr").append(learntd1);
		
	}	
	var size = $("#assign_body", "#chartContainer1").children("tr").size();
	if (size > 0) {
				$("#assign_body", "#chartContainer1").children("tr").remove();
	}
	var jh_body1 = $("#assign_body", "#chartContainer1")[0];
	if (retObj != undefined) {
	 
	for (var i = 0; i < retObj.length; i++) {
		
			var newTr=jh_body1.insertRow();
			newTr.id=retObj[i].dev_acc_id;
			newTr.insertCell().innerText=i+1;
			newTr.insertCell().innerText=retObj[i].dev_name; 
			newTr.insertCell().innerText=retObj[i].dev_model;	
			newTr.insertCell().innerText=retObj[i].license_num;
			newTr.insertCell().innerText=retObj[i].self_num;	
			newTr.insertCell().innerText=retObj[i].dev_sign;
			//newTr.insertCell().innerText="";
			//操作手 2012-11-1 换成直接查询操作手了
			newTr.insertCell().innerText=retObj[i].alloprinfo;
			
			newTr.cells[0].baseinfo = "true";
			newTr.cells[1].baseinfo = "true";
			newTr.cells[2].baseinfo = "true";
			newTr.cells[3].baseinfo = "true";
			newTr.cells[4].baseinfo = "true";
			newTr.cells[5].baseinfo = "true";
			newTr.cells[6].baseinfo = "true";
			/*for (var j = 0; j < 10; j++) {
				var newTd2 = newTr.insertCell();
				startDay.setDate(startDay.getDate() + i)
				newTd2.id = retObj[i].dev_acc_id + startDay.getFullYear() + "-" + (startDay.getMonth() + 1) + "-" + startDay.getDate();
				newTd2.dateinfo = startDay.getFullYear() + "-0" + (startDay.getMonth() + 1) + "-" + startDay.getDate();
				//newTd2.innerText =newTd2.id;
			}*/
			$(newTr).append(datetdstr);
			$(newTr).children("td").attr("devaccid",retObj[i].dev_acc_id);	
			 			
	  }
	}
	
		//保养日期
		var dateSql="select t.device_account_id,t.repair_start_date  as dateinfo from bgp_comm_device_repair_info t "+
		"left join gms_device_account_dui dui on dui.dev_acc_id=t.device_account_id "+
		"where dui.project_info_id='"+projectInfoNo+"' and t.repair_type='0110000037000000002' ";
		var dateRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+dateSql);
		dateObj = dateRet.datas;
		for (var j= 0; j<dateObj.length; j++) {
			/*
			var repday = new Date(dateObj[j].dateinfo.replace(regEx,"/"));
	        var col = Math.ceil((repday-startDay)/(24*60*60*1000))+5;
			
			if(document.getElementById(dateObj[j].device_account_id).cells[col]!=undefined){
				
				document.getElementById(dateObj[j].device_account_id).cells[col].innerText="eeeee";
				//alert(document.getElementById(dateObj[j].device_account_id).cells[col].innerText)
			}*/
			$("td[devaccid='"+dateObj[j].device_account_id+"'][dateinfo='"+dateObj[j].dateinfo+"']").css({background:"#00E050"});
		}
	   //计划日期
		var planSql="select t.dev_acc_id,t.plan_date as dateinfo from gms_device_maintenance_plan t "+
		"left join gms_device_account_dui dui on dui.dev_acc_id=t.dev_acc_id "+
		"where dui.project_info_id='"+projectInfoNo+"'";
		var planRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+planSql);
		planObj = planRet.datas;
		for (var j= 0; j<planObj.length; j++) {
			$("td[devaccid='"+planObj[j].dev_acc_id+"'][dateinfo='"+planObj[j].dateinfo+"']").css({background:"#E00000"});
		}
		$("#assign_body>tr:odd>td[baseinfo='true']",'#chartContainer1').addClass("odd_odd");
		$("#assign_body>tr:even>td[baseinfo='true']",'#chartContainer1').addClass("even_even");
		//alert(document.getElementById('titletr').cells[3].innerText)
		//document.getElementById('8ad8914039d3fb100139d435722e0040').cells[6].innerText='dddddddddd'
		//alert(Math.ceil((maxday-minday)/(24*60*60*1000)));
		//alert(document.getElementById('educationMap').rows[3].cells[3].innerText)
}



function getFusionChart1(){
	
		
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
        "charts/qzbyTable.swf", "chartContainer2", 
        "100%", "500", 
        swfVersionStr, xiSwfUrlStr, 
        flashvars, params, attributes);
   cruConfig.contextPath="<%=contextPath%>";
	
	 
}
function getAccData(){
	   var projectInfoNo='<%=projectInfoNo%>';
	   var str = "<chart>";
	   
	    var retObj = jcdpCallService("DevCommInfoSrv", "getAccData", "projectInfoNo="+projectInfoNo);
    	str += retObj.xmldata;
    	str +="</chart>";
		
    	return str;
   }
   function getDateData(){
   		var projectInfoNo='<%=projectInfoNo%>';
		var retObj = jcdpCallService("DevCommInfoSrv", "getDateData", "projectInfoNo="+projectInfoNo);
		var dateStr = retObj.dateStr;
		return dateStr;
   }
   function getByDateData(){
   		var projectInfoNo='<%=projectInfoNo%>';
		var retObj = jcdpCallService("DevCommInfoSrv", "getByDateData", "projectInfoNo="+projectInfoNo);
		var dateStr = retObj.dateStr;
		return dateStr;
   }
   
   function getPlanDateData(){
   		var projectInfoNo='<%=projectInfoNo%>';
		var retObj = jcdpCallService("DevCommInfoSrv", "getPlanDateData", "projectInfoNo="+projectInfoNo);
		var dateStr = retObj.dateStr;
		//alert(projectInfoNo)
		return dateStr;
		
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
</html>

