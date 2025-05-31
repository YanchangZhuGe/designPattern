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
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	if(org_subjection_id==null ){
		org_subjection_id = "";
	}
	if(org_subjection_id!=null && org_subjection_id.startsWith("C105008")){
		//response.sendRedirect("/qua/mProject/analysis/wht_menu.jsp");
		request.getRequestDispatcher("/qua/mProject/analysis/wht_menu.jsp").forward(request,response);
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
<body style="background: #fff; overflow-y: auto" >
<div id="list_content">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td valign="top" id="td0">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="49%">
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">合格品率</a></div>
											<div class="tongyong_box_content_left" style="height: 230px;width: 100%;" >
												<div id="company_1" ></div> 
												<p class="small">合格品指标≥<span id="quality_percent_1">99.6</span>%;&nbsp;&nbsp;累计完成炮数:<span id="total_1">0</span>;</p>
												<p class="small">累计完成合格品炮数:<span id="quality_1">0</span></p>
											</div>
										</div>
									</td>
									<td width="1%"></td>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">一级品率</a></div>
											<div class="tongyong_box_content_left" style="height: 230px;">
												<div id="company_4" ></div> 
												<p class="small">一级品指标≥<span id="first_percent_4">80</span>%;&nbsp;&nbsp;累计完成炮数:<span id="total_4">0</span>;</p>
												<p class="small">累计完成一级炮数:<span id="first_4">0</span></p>
											</div>
										</div>
									</td>
									<td width="1%"></td>
								</tr>
								<tr>
									<td colspan="3">
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">质量通报</a></div>
											<div class="tongyong_box_content_left" style="height: 230px;">
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
	<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function refreshData(){
		var org_subjection_id = '<%=org_subjection_id%>';
		company_1();
		company_4();
		var org_subjection_id = '<%=org_subjection_id%>';
		var sql = "select concat(concat(t.file_id,':'),t.ucm_id) ids ,t.file_name ,t.org_subjection_id,inf.org_abbreviation org_name,"+
		" to_char(t.create_date,'yyyy-MM-dd') create_date from bgp_doc_gms_file t " +
		" join comm_org_information inf on t.org_id = inf.org_id and inf.bsflag='0' "+
	    " join comm_org_subjection sub on inf.org_id = sub.org_id and sub.bsflag='0'" +
		" where t.bsflag='0' and t.is_file='1' and t.relation_id ='notice:"+org_subjection_id+"' union" +
		" select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_name,'C105' org_subjection_id,'东方物探公司' org_name," +
		" to_char(t.create_date,'yyyy-MM-dd') as create_date from bgp_qua_notice n " +
		" join bgp_doc_gms_file t on n.file_id = t.file_id and t.bsflag ='0'" +
		" where n.bsflag='0' and n.org_subjection_id ='"+org_subjection_id+"' order  by create_date desc";
		company_5('company_5',sql);
		changeTable('company_5');
	}
	refreshData();
	function company_1(){
		var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
	 	var org_subjection_id = '<%=org_subjection_id%>';
		var substr = "name=qualified&org_subjection_id="+org_subjection_id+"&middle=99.6&lowerLimit=99&wtc=wtc";
	 	var retObj = jcdpCallServiceCache("QualityChartSrv", "chartByOrg", substr);
	 	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='99' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='99' maxValue='99.6' code='FF654F'/> <color minValue='99.6' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='99' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	 	myChart.render("company_1");
	 	var querySql = "select sum(nvl(t.daily_acquire_sp_num,0)-(-nvl(t.daily_jp_acquire_shot_num,0))-(-nvl(t.daily_qq_acquire_shot_num,0)))total ,sum(nvl(t.daily_acquire_firstlevel_num,0)) first , "+
		" decode(sum(nvl(t.daily_acquire_qualified_num,0)),0,sum(nvl(t.daily_acquire_firstlevel_num,0))-(-sum(nvl(t.collect_2_class,0))),sum(nvl(t.daily_acquire_qualified_num,0))) qualified , "+
		" sum(nvl(t.collect_waster_num,0)) waster ,sum(nvl(t.collect_miss_num,0)) miss from gp_ops_daily_report t "+
		" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0' "+
		" join gp_task_project_dynamic d on p.project_info_no = d.project_info_no "+
		" and p.exploration_method = d.exploration_method and d.bsflag='0' "+
		" where t.bsflag='0' and t.audit_status ='3' and t.org_subjection_id like '"+org_subjection_id+"%'" ; //and p.project_status='3'  正在施工
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
		var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
	 	var org_subjection_id = '<%=org_subjection_id%>';
		var substr = "name=first&org_subjection_id="+org_subjection_id+"&middle=80&lowerLimit=60&wtc=wtc";
	 	var retObj = jcdpCallServiceCache("QualityChartSrv", "chartByOrg", substr);
	 	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='60' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='60' maxValue='80' code='FF654F'/> <color minValue='80' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='80' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	 	myChart.render("company_4");
	 	var querySql = "select sum(nvl(t.daily_acquire_firstlevel_num,0)-(-nvl(t.collect_2_class,0))-(-nvl(t.collect_waster_num,0))-(nvl(t.collect_miss_num,0)))total ,sum(nvl(t.daily_acquire_firstlevel_num,0)) first , "+
		" decode(sum(nvl(t.daily_acquire_qualified_num,0)),0,sum(nvl(t.daily_acquire_firstlevel_num,0))-(-sum(nvl(t.collect_2_class,0))),sum(nvl(t.daily_acquire_qualified_num,0))) qualified , "+
		" sum(nvl(t.collect_waster_num,0)) waster ,sum(nvl(t.collect_miss_num,0)) miss from gp_ops_daily_report t "+
		" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0' "+
		" join gp_task_project_dynamic d on p.project_info_no = d.project_info_no "+
		" and p.exploration_method = d.exploration_method and d.bsflag='0' "+
		" where t.bsflag='0' and t.audit_status ='3' and t.org_subjection_id like '"+org_subjection_id+"%'" ; //and p.project_status='3'  正在施工
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
	function company_5(comany_id,sql){
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
			window.open(cruConfig.contextPath + "/qua/mProject/analysis/wtc/qualified.jsp?org_subjection_id="+org_subjection_id);
		}else if(company!=null && company =='company_2'){
			window.open(cruConfig.contextPath + "/qua/mProject/audit/audit.jsp?org_subjection_id="+org_subjection_id);
		}else if(company!=null && company =='company_3'){
			window.open(cruConfig.contextPath + "/qua/mProject/accident/accident.jsp?org_subjection_id="+org_subjection_id);
		}
	}
	function wtcDetail(name){
		if(name!=null && name=='1'){
			window.open("<%=contextPath%>/qua/mProject/analysis/wtc/qualified_project.jsp");
		}else if(name!=null && name=='2'){
			window.open("<%=contextPath%>/qua/mProject/analysis/wtc/first_project.jsp");
		}
	}
	</script>
    </body>
</html>