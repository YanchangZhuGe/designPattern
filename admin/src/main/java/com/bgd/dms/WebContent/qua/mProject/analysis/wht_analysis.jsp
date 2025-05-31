<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="com.bgp.mcs.service.qua.service.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = request.getParameter("project_info_no");
	String project_type = request.getParameter("project_type");
	if(project_info_no == null || project_info_no.trim().equals("")){
		project_info_no = user.getProjectInfoNo();
		project_type = user.getProjectType();
	}
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
	List list = QualityUtil.getExplorationMethod(project_info_no);
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
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
								<%for(int i =0;list!=null && list.size()>0 && i<list.size();i++){ 
									Map map = (Map)list.get(i);
									String coding_code_id = map==null || map.get("coding_code_id")==null?"":(String)map.get("coding_code_id");
									String coding_name = map==null || map.get("coding_name")==null?"":(String)map.get("coding_name");%>
									<tr>
										<td width="49%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#"><span id="name"><%=coding_name %>（合格品率）</span></a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="qualifiedChart<%=coding_code_id%>"></div>   
													<p class="small">合格品指标≥<span id="qualifiedIndex<%=coding_code_id%>"></span>%;累计完成:<span id="qualifiedTotal<%=coding_code_id%>">0</span>;</p>
													<p class="small">累计完成合格品:<span id="qualified<%=coding_code_id%>">0</span></p>
												</div>
											</div>
										</td>
										<td width="1%"><input name="zhwht" value="<%=coding_code_id %>:<%=coding_name %>" type="hidden"/></td>
										<td width="49%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#"><%=coding_name %>（一级品率）</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="firstChart<%=coding_code_id%>"></div>
													<p class="small">一级品指标≥<span id="firstIndex<%=coding_code_id%>"></span>%;累计完成:<span id="firstTotal<%=coding_code_id%>">0</span>;</p>
													<p class="small"><span id="firstShow<%=coding_code_id%>">累计完成一级品:<span id="first<%=coding_code_id%>">0</span></span></p>
												</div>
											</div>
										</td>
										<td width="1%"></td>
									</tr>	
								<%} %>
							</table>
						</td>
					</tr>
				</table>
			</td> 
		</tr>
	</table>
</div>
	<script type="text/javascript">
	////////////////////////////////////jcdpCallServiceCache()
	cruConfig.contextPath = '<%=contextPath%>';
	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='0' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='0' maxValue='0.0' code='FF654F'/> <color minValue='0.0' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='0.0' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	var waster ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='0' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='0' maxValue='0.0' code='8BBA00'/> <color minValue='0.0' maxValue='100' code='FF654F'/></colorRange> <dials><dial value='0.0' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	var miss ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='0' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='0' maxValue='0.0' code='8BBA00'/> <color minValue='0.0' maxValue='100' code='FF654F'/></colorRange> <dials><dial value='0.0' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	function refreshData(projectId){
		var project_info_no = '<%=project_info_no%>';
		var project_type = '<%=project_type%>';
		if(project_type!=null && project_type=='5000100004000000009'){//综合物化探业务
			var zhwht = document.getElementsByName("zhwht");
			for(var i =0;zhwht!=null && i<zhwht.length;i++){
				var coding_code_id = zhwht[i].value.split(':')[0];
			 	
			 	whtChart(project_info_no,coding_code_id);
			}
		}
	}
	refreshData();
	
	function whtChart(project_info_no,coding_code_id){//综合物化探只有合格品率、一级品率
		var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
	 	var substr = "type=qualified&project_info_no="+project_info_no+"&coding_code_id="+coding_code_id;
	 	var retObj = jcdpCallService("QualityChartSrv", "whtChart", substr);
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	    myChart.render("qualifiedChart"+coding_code_id);
	    
	    var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
	 	var substr = "type=first&project_info_no="+project_info_no+"&coding_code_id="+coding_code_id;
	 	var retObj = jcdpCallService("QualityChartSrv", "whtChart", substr);
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	    myChart.render("firstChart"+coding_code_id);
	    //合格品指标、一级品指标
		var querySql = " select t.qualified_radio qualified ,t.firstlevel_radio first ,t.waster_radio waster ,t.miss_radio miss "+
		" from bgp_pm_quality_index t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"' and t.exploration_method='"+coding_code_id+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode==''){
			if(retObj.datas[0] != null){
				data = retObj.datas[0];
				if(data.qualified!=null && data.qualified !=0){
					document.getElementById("qualifiedIndex"+coding_code_id).innerHTML = data.qualified;
				}else{
					document.getElementById("qualifiedIndex"+coding_code_id).innerHTML = '0';
				}
				if(data.first!=null && data.first !=0){
					document.getElementById("firstIndex"+coding_code_id).innerHTML = data.first;
				}else{
					document.getElementById("firstIndex"+coding_code_id).innerHTML ="0";
				}
			}
		}
		querySql = "select decode(d.superior_code_id,'0',d.coding_code_id,d.superior_code_id) coding_code_id from comm_coding_sort_detail d "+
		" where d.bsflag ='0' and d.coding_sort_id ='5110000056' and d.coding_code_id ='"+coding_code_id+"'";
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode==''){
			var code_id = retObj.datas[0]==null || retObj.datas[0].coding_code_id==null ?"":retObj.datas[0].coding_code_id;
			if(code_id!=null && code_id!=''){
				querySql = "with daily_report as(select * from gp_ops_daily_report_wt t join gp_ops_daily_report_zb zb on t.daily_no_wt = zb.daily_no_wt and zb.bsflag ='0'"+
				" where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and zb.exploration_method ='"+coding_code_id+"'  "+ //and t.audit_status ='3'
				" order by zb.produce_date desc)select nvl(sum(dr.daily_first_grade),0) first,nvl(sum(dr.daily_conforming_products),0) qualified,"+
				" nvl(sum(dr.daily_coordinate_point),0) coordinate_point ,nvl(sum(dr.daily_check_point),0) check_point ,"+
				" nvl(max((select r.daily_first_ratio from daily_report r where r.daily_first_ratio is not null and rownum =1)),0)first_ratio from daily_report dr";
				retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
				if(retObj!=null && retObj.returnCode==''){
					if(retObj.datas[0] != null){
						if(code_id!=null &&(code_id=='5110000056000000001' || code_id=='5110000056000000002' || code_id=='5110000056000000005')){
							with(retObj.datas[0]){
								document.getElementById("qualifiedTotal"+coding_code_id).innerHTML = coordinate_point;
								document.getElementById("qualified"+coding_code_id).innerHTML = qualified;
								document.getElementById("firstTotal"+coding_code_id).innerHTML = check_point;
								document.getElementById("first"+coding_code_id).innerHTML = first;
							}
						}else if(code_id!=null &&(code_id=='5110000056000000003' || code_id=='5110000056000000004' )){
							with(retObj.datas[0]){
								document.getElementById("qualifiedTotal"+coding_code_id).innerHTML = coordinate_point;
								document.getElementById("qualified"+coding_code_id).innerHTML = qualified;
								document.getElementById("firstTotal"+coding_code_id).innerHTML = coordinate_point;
								document.getElementById("first"+coding_code_id).innerHTML = first;
							}
						}else if(code_id!=null && code_id=='5110000056000000006'){
							debugger;
							document.getElementById("firstIndex"+coding_code_id).nextSibling.nodeValue = "%";
							document.getElementById("firstTotal"+coding_code_id).style.display = "none";
							document.getElementById("firstShow"+coding_code_id).style.display = "none";
							with(retObj.datas[0]){
								document.getElementById("qualifiedTotal"+coding_code_id).innerHTML = coordinate_point;
								document.getElementById("qualified"+coding_code_id).innerHTML = qualified;
							}
						}
					}
				}	
			}
		}	
	}
	</script>
    </body>
</html>