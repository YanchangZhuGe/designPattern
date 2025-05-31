<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = request.getParameter("project_info_no");
	if(project_info_no==null ){
		project_info_no = user.getProjectInfoNo();
	}
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	if(org_subjection_id==null ){
		org_subjection_id = "";
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
</head>
<body style="overflow-y: scroll; overflow-x: hidden;">
<div id="table_box" style="overflow-y: hidden; overflow-x: hidden;">
	<div id="company" style="display: none;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td valign="middle">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="50%">
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">合格品率</a></div>
												<div class="tongyong_box_content_left" style="height: 100%;width: 100%;" >
													<div id="company_1" ></div> 
													<p class="small">合格品指标≥<span id="quality_percent_1">99.6</span>%;&nbsp;&nbsp;累计完成炮数:<span id="total_1">0</span>;</p>
													<p class="small">累计完成合格品炮数:<span id="quality_1">0</span></p>
												</div>
											</div>
										</td>
										<td >
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">一级品率</a></div>
												<div class="tongyong_box_content_left" style="height: 200px;">
													<div id="company_4" ></div> 
													<p class="small">一级品指标≥<span id="first_percent_4">80</span>%;&nbsp;&nbsp;累计完成炮数:<span id="total_4">0</span>;</p>
													<p class="small">累计完成一级炮数:<span id="first_4">0</span></p>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<td width="50%">
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">内审计划</a></div>
												<div class="tongyong_box_content_left" style="height: 200px;width: 100%">
													<div>
														<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="company_2">
															<tr>
																<td class="bt_info_odd" >序号</td> 
															    <td class="bt_info_even">物探处名称</td>
															</tr>
														</table>
													</div>
												</div>
											</div>
										</td>
										<td width="50%">
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">质量事故上报</a></div>
												<div class="tongyong_box_content_left" style="height: 200px;width: 100%">
													<div>	
														<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="company_3">
															<tr>
																<td class="bt_info_odd" >序号</td> 
															    <td class="bt_info_even">物探处名称</td>
															</tr>
														</table>
													</div>	
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">质量通报</a></div>
												<div class="tongyong_box_content_left" style="height: 200px;">
													<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="company_5">
														<tr>
														  	<td class="bt_info_odd"  >序号</td> 
														  	<td class="bt_info_even" >质量通报文件</td>
														  	<td class="bt_info_odd"  >下发单位</td>
														  	<td class="bt_info_even" >下发时间</td>
														</tr>
													</table>
												</div>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td> 
			</tr>
		</table>
	</div>
	<div id="wtc" style="display: none;">
		<select id="project" name="project" onchange="wtc();" class="select_width" style="width: 350px">
		</select>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td valign="middle">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">合格品指标</a></div>
												<div class="tongyong_box_content_left" style="height: 195px;">
													<div ondblclick="alert()"><div id="chartContainer1" ></div></div>
													<p class="small">合格品指标≥<span id="first1">0</span>%;&nbsp;&nbsp;累计完成炮数:<span id="total1">0</span>;</p>
													<p class="small">累计完成合格品炮数:<span id="first2">0</span></p>
												</div>
											</div>
										</td>
										<td>
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">废炮率</a></div>
												<div class="tongyong_box_content_left" style="height: 195px;">
													<div id="chartContainer2"></div>   
													<p class="small">废炮率≤<span id="waster1">0</span>%;&nbsp;&nbsp;累计完成炮数:<span id="total2">0</span>;</p>
													<p class="small">累计完成废炮数:<span id="waster2">0</span></p>
												</div>
											</div>
										</td>
										<td>
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">空炮率</a></div>
												<div class="tongyong_box_content_left" style="height: 195px;">
													<div id="chartContainer3"></div>   
													<p class="small">空炮率≤<span id="miss1">0</span>%;&nbsp;&nbsp;累计完成炮数:<span id="total3">0</span>;</p>
													<p class="small">累计完成空炮:<span id="miss2">0</span></p>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">二级品原因汇总</a></div>
												<div class="tongyong_box_content_left" style="height: 195px;">
													<div id="chartContainer4"></div>   
												</div>
											</div>
										</td>
										<td colspan="2">
											<div class="tongyong_box" >
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">质量通报</a></div>
												<div class="tongyong_box_content_left" style="height: 195px;">
													<div id="chartContainer5">
														<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="company_6">
															<tr>
															  	<td class="bt_info_odd"  >序号</td> 
															  	<td class="bt_info_even" >质量通报文件</td>
															  	<td class="bt_info_odd"  >下发单位</td>
															  	<td class="bt_info_even" >下发时间</td>
															</tr>
														</table>
													</div>   
												</div>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td> 
			</tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function cleanTable(table_name){
		var table = document.getElementById(table_name);
		for(var i=table.rows.length-1 ;i>=1 ;i--){
			table.deleteRow(i);
		}
	}
	function refreshData(){
		var org_subjection_id = '<%=org_subjection_id%>';
		if(org_subjection_id!=null && org_subjection_id=='C105'){
			document.getElementById("company").style.display = 'block';
			document.getElementById("wtc").style.display = 'none';
			company();
			company_1();
			company_4();
		}else if(org_subjection_id!=null && org_subjection_id !='C105'){
			document.getElementById("company").style.display = 'none';
			document.getElementById("wtc").style.display = 'block';
			getProject(org_subjection_id); 
			wtc();
		}else{
			document.getElementById("company").style.display = 'none';
			document.getElementById("wtc").style.display = 'none';
		}
	}
	refreshData();
	function company_1(){
		var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "0");
	 	var org_subjection_id = '<%=org_subjection_id%>';
		var substr = "name=qualified&org_subjection_id="+org_subjection_id+"&middle=99.6&lowerLimit=99";
	 	var retObj = jcdpCallService("QualityChartSrv", "chartByOrg", substr);
	 	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='99' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='99' maxValue='99.6' code='FF654F'/> <color minValue='99.6' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='99' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	 	myChart.render("company_1");
	 	var querySql = "select decode(sum(t.daily_acquire_qualified_num),'0',sum(t.daily_acquire_firstlevel_num)-(-sum(t.collect_2_class)),sum(t.daily_acquire_qualified_num)) qualified ,sum(t.collect_waster_num) waster ,"+
		" sum(t.collect_miss_num) miss ,decode(sum(t.daily_acquire_qualified_num),'0',sum(t.daily_acquire_firstlevel_num)-(-sum(t.collect_2_class)),sum(t.daily_acquire_qualified_num))-(-sum(t.collect_waster_num)) total ,"+
		" sum(t.daily_acquire_firstlevel_num) first from gp_ops_daily_report t "+
		" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0' "+
		" join gp_task_project_dynamic d on p.project_info_no = d.project_info_no "+
		" and p.exploration_method = d.exploration_method and d.bsflag='0' "+
		" where t.bsflag='0'  and t.org_subjection_id like 'C105%'" ; //and p.project_status='3'  正在施工
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode==''){
			if(retObj.datas[0] != null){
				data = retObj.datas[0];
				if(data.qualified!=null && data.qualified !=0){
					document.getElementById("quality_1").innerHTML = data.qualified;
				}else{
					document.getElementById("quality_1").innerHTML ="0";
				}
				if(data.total!=null && data.total !=0){
					document.getElementById("total_1").innerHTML = data.total;
				}else{
					document.getElementById("total_1").innerHTML = "0";
				}
				
			}
		}
	}
	function company_4(){
		var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "0");
	 	var org_subjection_id = '<%=org_subjection_id%>';
		var substr = "name=first&org_subjection_id="+org_subjection_id+"&middle=80&lowerLimit=60";
	 	var retObj = jcdpCallService("QualityChartSrv", "chartByOrg", substr);
	 	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='60' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='60' maxValue='80' code='FF654F'/> <color minValue='80' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='80' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	 	myChart.render("company_4");
	 	var querySql = "select decode(sum(t.daily_acquire_qualified_num),'0',sum(t.daily_acquire_firstlevel_num)-(-sum(t.collect_2_class)),sum(t.daily_acquire_qualified_num)) qualified ,sum(t.collect_waster_num) waster ,"+
		" sum(t.collect_miss_num) miss ,decode(sum(t.daily_acquire_qualified_num),'0',sum(t.daily_acquire_firstlevel_num)-(-sum(t.collect_2_class)),sum(t.daily_acquire_qualified_num))-(-sum(t.collect_waster_num)) total ,"+
		" sum(t.daily_acquire_firstlevel_num) first from gp_ops_daily_report t "+
		" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0' "+
		" join gp_task_project_dynamic d on p.project_info_no = d.project_info_no "+
		" and p.exploration_method = d.exploration_method and d.bsflag='0' "+
		" where t.bsflag='0'  and t.org_subjection_id like 'C105%'" ; //and p.project_status='3'  正在施工
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode==''){
			if(retObj.datas[0] != null){
				data = retObj.datas[0];
				if(data.qualified!=null && data.qualified !=0){
					document.getElementById("first_4").innerHTML = data.first;
				}else{
					document.getElementById("first_4").innerHTML ="0";
				}
				if(data.total!=null && data.total !=0){
					document.getElementById("total_4").innerHTML = data.total;
				}else{
					document.getElementById("total_4").innerHTML = "0";
				}
				
			}
		}
	}
	function company(){
		var sql = " select eps.eps_name org_name ,eps.org_id ,os.org_subjection_id from bgp_eps_code eps"+
		" join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0'"+
		" where eps.bsflag ='0' and eps.parent_object_id =( select t.object_id"+
		" from bgp_eps_code t where t.bsflag ='0' and t.org_id='C6000000000001') order by eps.order_num";
		var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+'&pageSize='+cruConfig.pageSizeMax);
		if(retObj!=null && retObj.returnCode=='0'){
			var company_2 = document.getElementById("company_2");
			var company_3 = document.getElementById("company_3");
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var data = retObj.datas[i];
				var org_id = data.org_id;
				var org_name = data.org_name;
				var org_subjection_id = data.org_subjection_id;
				
				var tr_2 = company_2.insertRow(i-(-1));
				var td_2 = tr_2.insertCell(0);
				td_2.innerHTML = i-(-1) + "<input type='hidden' name='org_subjection_id' value='"+org_subjection_id+"'/>";;
				td_2 = tr_2.insertCell(1);
				td_2.innerHTML = "<a href='#' onclick=getDetail('company_2','"+org_subjection_id+"')><font color='blue'>"+org_name+"</font></a>" ;
				
				var tr_3 = company_3.insertRow(i-(-1));
				var td_3 = tr_3.insertCell(0);
				td_3.innerHTML = i-(-1) + "<input type='hidden' name='org_subjection_id' value='"+org_subjection_id+"'/>";;
				td_3 = tr_3.insertCell(1);
				td_3.innerHTML = "<a href='#' onclick=getDetail('company_3','"+org_subjection_id+"')><font color='blue'>"+org_name+"</font></a>" ;
				changeTable("company_2");
				changeTable("company_3");
			}
		}
		var org_subjection_id = '<%=org_subjection_id%>';
		/* var sql = "select concat(concat(t.file_id,':'),t.ucm_id) ids ,t.file_name ,t.org_subjection_id,inf.org_abbreviation org_name,to_char(t.create_date,'yyyy-MM-dd') create_date"+
		    " from bgp_doc_gms_file t join comm_org_information inf on t.org_id = inf.org_id and inf.bsflag='0' "+
		    " join comm_org_subjection sub on inf.org_id = sub.org_id and sub.bsflag='0'" +
		    " where t.bsflag='0' and t.is_file='1' and t.relation_id like 'management:"+org_subjection_id+"%' order  by t.create_date desc"; 
		company_4_5('company_4',sql);
		changeTable('company_4'); */
		var sql = "select concat(concat(t.file_id,':'),t.ucm_id) ids ,t.file_name ,t.org_subjection_id,inf.org_abbreviation org_name,to_char(t.create_date,'yyyy-MM-dd') create_date"+
	    " from bgp_doc_gms_file t join comm_org_information inf on t.org_id = inf.org_id and inf.bsflag='0' "+
	    " join comm_org_subjection sub on inf.org_id = sub.org_id and sub.bsflag='0'" +
	    " where t.bsflag='0' and t.is_file='1' and t.relation_id like 'notice:"+org_subjection_id+"%' order  by t.create_date desc"; 
		company_4_5('company_5',sql);
		changeTable('company_5');
	}
	function company_4_5(comany_id,sql){
		var org_subjection_id = '<%=org_subjection_id%>';
		var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+'&pageSize='+cruConfig.pageSizeMax);
		if(retObj!=null && retObj.returnCode=='0'){
			var company = document.getElementById(comany_id);
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var data = retObj.datas[i];
				var ids = data.ids;
				var file_name = data.file_name;
				var org_name = data.org_name;
				var org_subjection_id = data.org_subjection_id;
				var create_date = data.create_date;
				var tr = company.insertRow(i-(-1));
				var td = tr.insertCell(0);
				td.innerHTML = i-(-1) + "<input type='hidden' name='org_subjection_id' value='"+org_subjection_id+"'/>";;
				td = tr.insertCell(1);
				td.innerHTML = "<a href='#' onclick=viewFile('"+ids+"')><font color='blue'>"+file_name+"</font></a>" ;
				td = tr.insertCell(2);
				td.innerHTML = org_name;
				td = tr.insertCell(3);
				td.innerHTML = create_date;
			}
		}	
	}
	function changeTable(table_name){
		var table = document.getElementById(table_name);
		for(var i =1 ;i<table.rows.length;i++){
			var tr = table.rows[i];
			for(var j =0 ;j< tr.cells.length;j++){
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
	function viewFile(ids){
		var ucm_id = ids.split(":")[0];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+ucm_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
	}
	function getDetail(company ,org_subjection_id){
		if(company!=null && company =='company_1'){
			window.open(cruConfig.contextPath + "/qua/mProject/analysis/qualified.jsp?org_subjection_id="+org_subjection_id);
		}else if(company!=null && company =='company_2'){
			window.open(cruConfig.contextPath + "/qua/mProject/audit/audit.jsp?org_subjection_id="+org_subjection_id);
		}else if(company!=null && company =='company_3'){
			window.open(cruConfig.contextPath + "/qua/mProject/accident/accident.jsp?org_subjection_id="+org_subjection_id);
		}
	}
	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='0' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='0' maxValue='0.0' code='FF654F'/> <color minValue='0.0' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='0.0' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	var waster ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='0' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='0' maxValue='0.0' code='8BBA00'/> <color minValue='0.0' maxValue='100' code='FF654F'/></colorRange> <dials><dial value='0.0' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	var miss ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='0' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='0' maxValue='0.0' code='8BBA00'/> <color minValue='0.0' maxValue='100' code='FF654F'/></colorRange> <dials><dial value='0.0' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	function wtc(){
		cleanTable("company_6");
		var project_info_no = document.getElementById("project").value;
		var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "280", "155", "0", "1");
	 	var substr = "name=first&project_info_no="+project_info_no;
	 	var retObj = jcdpCallService("QualityChartSrv", "qualityChart", substr);
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	    myChart.render("chartContainer1");
	    myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "280", "155", "0", "1");
	    substr = "name=waster&project_info_no="+project_info_no;
	 	retObj = jcdpCallService("QualityChartSrv", "qualityChart", substr);
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			waster = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(waster);
	    myChart.render("chartContainer2");
	    myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "280", "155", "0", "1");
	    substr = "name=miss&project_info_no="+project_info_no;
	 	retObj = jcdpCallService("QualityChartSrv", "qualityChart", substr);
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			miss = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(miss);
	    myChart.render("chartContainer3");
	    
	    myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "280", "155", "0", "1");
	    myChart.setXMLUrl("<%=contextPath%>/qua/common/shotChart.srq?project_info_no="+project_info_no);
	    myChart.render("chartContainer4"); 
	    getTotal(project_info_no);
	    
	    sql = "select concat(concat(t.file_id,':'),t.ucm_id) ids ,t.file_name ,t.org_subjection_id,inf.org_abbreviation org_name,to_char(t.create_date,'yyyy-MM-dd') create_date"+
	    " from bgp_doc_gms_file t join comm_org_information inf on t.org_id = inf.org_id and inf.bsflag='0' "+
	    " join comm_org_subjection sub on inf.org_id = sub.org_id and sub.bsflag='0'" +
	    " where t.bsflag='0' and t.is_file='1' and t.relation_id like 'notice:<%=org_subjection_id%>%' order  by t.create_date desc"; 
		company_4_5('company_6',sql);
		changeTable('company_6');
	}
	function getProject(org_subjection_id){
		var index = document.getElementById("project").options.length;
	    for(var j =index-1 ;j>=0;j--){
	    	document.getElementById("project").options.remove(j);
	    }
	    var sql = "select distinct t.project_name name ,d.org_id ,d.org_subjection_id ,t.project_info_no project "+
	    " from gp_task_project t join gp_task_project_dynamic d on t.project_info_no = d.project_info_no "+
	    " and d.bsflag ='0' and t.exploration_method = d.exploration_method "+
	    " join comm_org_subjection o on d.org_id = o.org_id and o.bsflag ='0'"+
	    " join comm_coding_sort_detail s on t.manage_org = s.coding_code_id and s.bsflag = '0'"+
	    " where t.bsflag ='0' and d.org_subjection_id like '<%=org_subjection_id%>%'";
	    var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+"&pageSize="+cruConfig.pageSizeMax);
	    if(retObj!=null && retObj.returnCode=='0'){
	    	debugger;
	    	if(retObj.datas!=null ){
	    		for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
	    			var data = retObj.datas[i];
	    			var project = data.project;
	    			var project_name = data.name;
	    			var select = document.getElementById("project");
	    			select.options.add(new Option(project_name,project));
	    		}
	    	}
	    }
	}
	function getTotal(project_info_no){
		var querySql = " select t.qualified_radio first,t.waster_radio waster ,t.all_miss_radio miss"+
		" from bgp_pm_quality_index t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"'"
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode=='0'){
			if(retObj.datas[0] != null){
				data = retObj.datas[0];
				if(data.first!=null && data.first !=0){
					document.getElementById("first1").innerHTML = data.first;
				}else{
					document.getElementById("first1").innerHTML ="0";
				}
				if(data.waster!=null && data.waster !=0){
					document.getElementById("waster1").innerHTML = data.waster;
				}else{
					document.getElementById("waster1").innerHTML ="0";
				}
				if(data.miss!=null && data.miss !=0){
					document.getElementById("miss1").innerHTML = data.miss;
				}else{
					document.getElementById("miss1").innerHTML ="0";
				}
			}else{
				document.getElementById("first1").innerHTML ="0";
				document.getElementById("waster1").innerHTML ="0";
				document.getElementById("miss1").innerHTML ="0";
			}
		}else{
			document.getElementById("first1").innerHTML ="0";
			document.getElementById("waster1").innerHTML ="0";
			document.getElementById("miss1").innerHTML ="0";
		}
		querySql = " select decode(sum(t.daily_acquire_qualified_num),'0',sum(t.daily_acquire_firstlevel_num)-(-sum(t.collect_2_class)),sum(t.daily_acquire_qualified_num)) first ,"+
		" sum(t.collect_waster_num) waster ,sum(t.collect_miss_num) miss ,sum(t.daily_acquire_firstlevel_num)-(-sum(t.collect_2_class))-(-sum(t.collect_waster_num)) total"+
		" from gp_ops_daily_report t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"'"
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode=='0'){
			if(retObj.datas[0] != null){
				data = retObj.datas[0];
				if(data.first!=null && data.first !=0){
					document.getElementById("first2").innerHTML = data.first;
				}else{
					document.getElementById("first2").innerHTML ="0";
				}
				if(data.waster!=null && data.waster !=0){
					document.getElementById("waster2").innerHTML = data.waster;
				}else{
					document.getElementById("waster2").innerHTML ="0";
				}
				if(data.miss!=null && data.miss !=0){
					document.getElementById("miss2").innerHTML = data.miss;
				}else{
					document.getElementById("miss2").innerHTML ="0";
				}
				if(data.total!=null && data.total !=0){
					document.getElementById("total1").innerHTML = data.total;
					document.getElementById("total2").innerHTML = data.total;
					document.getElementById("total3").innerHTML = data.total;
				}else{
					document.getElementById("total1").innerHTML = "0";
					document.getElementById("total2").innerHTML = "0";
					document.getElementById("total3").innerHTML = "0";
				}
			}else{
				document.getElementById("first2").innerHTML ="0";
				document.getElementById("waster2").innerHTML ="0";
				document.getElementById("miss2").innerHTML ="0";
				document.getElementById("total1").innerHTML = "0";
				document.getElementById("total2").innerHTML = "0";
				document.getElementById("total3").innerHTML = "0";
			}
		}else{
			document.getElementById("first2").innerHTML ="0";
			document.getElementById("waster2").innerHTML ="0";
			document.getElementById("miss2").innerHTML ="0";
			document.getElementById("total1").innerHTML = "0";
			document.getElementById("total2").innerHTML = "0";
			document.getElementById("total3").innerHTML = "0";
		}
	}
	function orgDetail(name){
		if(name!=null && name=='1'){
			window.open(cruConfig.contextPath + "/qua/mProject/analysis/qualified_org.jsp");
		}else if(name!=null && name=='2'){
			window.open(cruConfig.contextPath + "/qua/mProject/analysis/first_org.jsp");
		}
		
	}
	</script>
    </body>
</html>