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
	String project_info_no = user.getProjectInfoNo();
	String project_type = user.getProjectType();
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
								<%if(project_type!=null && project_type.trim().equals("5000100004000000001")){//陆地 %>
									<tr>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#"><span id="name">合格品率</span></a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id = "qualified">
														<div id="chartContainer1"></div>   
														<p class="small">合格品指标≥<span id="qualified1"></span>%;累计完成炮数:<span id="total_qualified">0</span>;</p>
														<p class="small">累计完成合格品炮数:<span id="qualified2">0</span></p>
													</div>
													<div id = "first">
														<div id="chartContainer" ></div>   
														<p class="small">一级品指标≥<span id="first1"></span>%;累计完成炮数:<span id="total_first">0</span>;</p>
														<p class="small">累计完成一级品炮数:<span id="first2">0</span></p>
													</div>
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">废炮率</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="chartContainer2"></div>   
													<p class="small">废炮指标≤<span id="waster1"></span>%;累计完成炮数:<span id="total2">0</span>;</p>
													<p class="small">累计完成废炮数:<span id="waster2">0</span></p>
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">空炮率</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="chartContainer3"></div>   
													<p class="small">空炮指标≤<span id="miss1"></span>%;累计完成炮数:<span id="total3">0</span>;</p>
													<p class="small">累计完成空炮:<span id="miss2">0</span></p>
												</div>
											</div>
										</td>
										<td width="1%"></td>
									</tr>
									<tr>
										<td >
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">钻井检查结果分析</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="chartContainer4"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td>
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">放线检查结果分析</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="chartContainer5"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td >
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb" ><a href="#"></a></span><a href="#">测量检查结果分析<!-- 二级品原因汇总 --></a></div>
												<div class="tongyong_box_content_left" style="height: 230px;" >
													<div id="chartContainer6"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
									</tr>
								<%}else if(project_type!=null && project_type.trim().equals("5000100004000000008") ){//井中业务 %>
									<tr>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#"><span id="name">合格品率</span></a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id = "qualified">
														<div id="chartContainer1"></div>   
														<p class="small">合格品指标≥<span id="qualified1"></span>%;累计完成炮数:<span id="total_qualified">0</span>;</p>
														<p class="small">累计完成合格品炮数:<span id="qualified2">0</span></p>
													</div>
													<div id = "first">
														<div id="chartContainer" ></div>   
														<p class="small">一级品指标≥<span id="first1"></span>%;累计完成炮数:<span id="total_first">0</span>;</p>
														<p class="small">累计完成一级品炮数:<span id="first2">0</span></p>
													</div>
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">废炮率</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="chartContainer2"></div>   
													<p class="small">废炮指标≤<span id="waster1"></span>%;累计完成炮数:<span id="total2">0</span>;</p>
													<p class="small">累计完成废炮数:<span id="waster2">0</span></p>
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">空炮率</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="chartContainer3"></div>   
													<p class="small">空炮指标≤<span id="miss1"></span>%;累计完成炮数:<span id="total3">0</span>;</p>
													<p class="small">累计完成空炮:<span id="miss2">0</span></p>
												</div>
											</div>
										</td>
										<td width="1%"></td>
									</tr>
									<tr>
										<td >
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb" ><a href="#"></a></span><a href="#">测量检查结果分析<!-- 二级品原因汇总 --></a></div>
												<div class="tongyong_box_content_left" style="height: 230px;" ><input name="jz" value="5000100115:测量:6" type="hidden"/>
													<div id="chartContainer6"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td >
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">表层调查检查结果分析</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;"><input name="jz" value="5000100116:表层调查:7" type="hidden"/>
													<div id="chartContainer7"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td>
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">采集检查结果分析</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;"><input name="jz" value="5000100119:采集:8" type="hidden"/>
													<div id="chartContainer8"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
									</tr>
									<tr>
										<td>
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">放线检查结果分析</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;"><input name="jz" value="5000100121:放线:5" type="hidden"/>
													<div id="chartContainer5"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td colspan="3">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">钻井检查结果分析</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;"><input name="jz" value="5000100117:钻井:4" type="hidden"/>
													<div id="chartContainer4"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
									</tr>
								<%}else if(project_type!=null && project_type.trim().equals("5000100004000000009")){ //综合物化探业务,按照项目的勘探方法 ,list.size()>0才创建行%>
									<%for(int i =0;list!=null && list.size()>0 && i<list.size();i++){ 
										Map map = (Map)list.get(i);
										String coding_code_id = map==null || map.get("coding_code_id")==null?"":(String)map.get("coding_code_id");
										String coding_name = map==null || map.get("coding_name")==null?"":(String)map.get("coding_name");%>
										<tr>
											<td width="32.3%">
												<div class="tongyong_box">
													<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#"><span id="name"><%=coding_name %>（合格品率）</span></a></div>
													<div class="tongyong_box_content_left" style="height: 230px;">
														<div id="qualifiedChart<%=coding_code_id%>"></div>   
														<p class="small">合格品指标≥<span id="qualifiedIndex<%=coding_code_id%>"></span>%;累计完成:<span id="qualifiedTotal<%=coding_code_id%>">0</span>;</p>
														<p class="small">累计完成合格品:<span id="qualified<%=coding_code_id%>">0</span></p>
													</div>
												</div>
											</td>
											<td width="1%"></td>
											<td width="32.3%">
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
											<td width="32.3%">
												<div class="tongyong_box">
													<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#"><%=coding_name %></a></div>
													<div class="tongyong_box_content_left" style="height: 230px;"><input name="zhwht" value="<%=coding_code_id %>:<%=coding_name %>" type="hidden"/>
														<div id="chartContainer<%=coding_code_id%>" ></div>
													</div>
												</div>
											</td>
											<td width="1%"></td>
										</tr>	
									<%} %>
								<%}else if(project_type!=null && project_type.trim().equals("5000100004000000010")){ //滩浅海业务%>
									<tr>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#"><span id="name">合格品率</span></a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id = "qualified">
														<div id="chartContainer1"></div>   
														<p class="small">合格品指标≥<span id="qualified1"></span>%;累计完成炮数:<span id="total_qualified">0</span>;</p>
														<p class="small">累计完成合格品炮数:<span id="qualified2">0</span></p>
													</div>
													<div id = "first">
														<div id="chartContainer" ></div>   
														<p class="small">一级品指标≥<span id="first1"></span>%;累计完成炮数:<span id="total_first">0</span>;</p>
														<p class="small">累计完成一级品炮数:<span id="first2">0</span></p>
													</div>
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">废炮率</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="chartContainer2"></div>   
													<p class="small">废炮指标≤<span id="waster1"></span>%;累计完成炮数:<span id="total2">0</span>;</p>
													<p class="small">累计完成废炮数:<span id="waster2">0</span></p>
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td width="32.3%">
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">空炮率</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;">
													<div id="chartContainer3"></div>   
													<p class="small">空炮指标≤<span id="miss1"></span>%;累计完成炮数:<span id="total3">0</span>;</p>
													<p class="small">累计完成空炮:<span id="miss2">0</span></p>
												</div>
											</div>
										</td>
										<td width="1%"></td>
									</tr>
									<tr>
										<td >
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">气枪检查结果分析</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;"><input name="tqh" value="5000100129:气枪:4" type="hidden"/>
													<div id="chartContainer4"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td>
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">放线检查结果分析</a></div>
												<div class="tongyong_box_content_left" style="height: 230px;"><input name="tqh" value="5000100128:放线:5" type="hidden"/>
													<div id="chartContainer5"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
										<td >
											<div class="tongyong_box">
												<div class="tongyong_box_title"><span class="kb" ><a href="#"></a></span><a href="#">采集检查结果分析<!-- 二级品原因汇总 --></a></div>
												<div class="tongyong_box_content_left" style="height: 230px;" ><input name="tqh" value="5000100126:采集:6" type="hidden"/>
													<div id="chartContainer6"></div>   
												</div>
											</div>
										</td>
										<td width="1%"></td>
									</tr>
								<%}%>
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
				var object_name = zhwht[i].value.split(':')[1];
				object_name = encodeURI(encodeURI(object_name));
				var myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "230", "0", "1");
				var retObj = jcdpCallService("QualityChartSrv", "zhwhtChart", "project_info_no="+project_info_no+"&coding_code_id="+coding_code_id);
			 	if(retObj!=null && retObj.returnCode=='0'){
			 		if(retObj.Str!=null){
			 			var str = retObj.Str;
			 			str = decodeURI(decodeURI(str));
			 			myChart.setDataXML(str);
			 		}
			 	}
			 	myChart.render("chartContainer"+coding_code_id);
			 	
			 	whtChart(project_info_no,coding_code_id);
			}
		}else if(project_type!=null && project_type=='5000100004000000008'){//井中业务
			radioChart(project_info_no);
			getTotal(project_info_no);
			var jz = document.getElementsByName("jz");
			for(var i =0;jz!=null && i<jz.length;i++){
				var coding_code_id = jz[i].value.split(':')[0];
				var object_name = jz[i].value.split(':')[1];
				var id = jz[i].value.split(':')[2];
				object_name = encodeURI(encodeURI(object_name));
				debugger;
				var myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "100%", "0", "1");
				var retObj = jcdpCallService("QualityChartSrv", "jzChart", "project_info_no="+project_info_no+"&coding_code_id="+coding_code_id+"&object_name="+object_name);
			 	if(retObj!=null && retObj.returnCode=='0'){
			 		if(retObj.Str!=null){
			 			var str = retObj.Str;
			 			str = decodeURI(decodeURI(str));
			 			myChart.setDataXML(str);
			 		}
			 	}
			 	
			 	myChart.render("chartContainer"+id);
			}
		}else if(project_type!=null && project_type=='5000100004000000010'){//滩浅海业务
			radioChart(project_info_no);
			getTotal(project_info_no);
			var tqh = document.getElementsByName("tqh");
			for(var i =0;tqh!=null && i<tqh.length;i++){
				var coding_code_id = tqh[i].value.split(':')[0];
				var object_name = tqh[i].value.split(':')[1];
				var id = tqh[i].value.split(':')[2];
				object_name = encodeURI(encodeURI(object_name));
				debugger;
				var myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "100%", "0", "1");
				var retObj = jcdpCallService("QualityChartSrv", "tqhChart", "project_info_no="+project_info_no+"&coding_code_id="+coding_code_id+"&object_name="+object_name);
			 	if(retObj!=null && retObj.returnCode=='0'){
			 		if(retObj.Str!=null){
			 			var str = retObj.Str;
			 			str = decodeURI(decodeURI(str));
			 			myChart.setDataXML(str);
			 		}
			 	}
			 	myChart.render("chartContainer"+id);
			}
		}else if(project_type!=null && project_type=='5000100004000000001'){//陆地
			radioChart(project_info_no);
			getTotal(project_info_no);
			landChart(project_info_no);
		}
	}
	refreshData();
	function radioChart(project_info_no){
		<%-- var sql = "select * from bgp_pm_quality_index t where t.bsflag ='0' and t.qualified_radio is not null and t.project_info_no ='<%=project_info_no%>' and rownum =1"; --%>
		var sql = "select * from bgp_pm_quality_index t where t.bsflag ='0' and t.firstlevel_radio is not null and t.project_info_no ='<%=project_info_no%>' and rownum =1";
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode=='0' && retObj.datas.length <=0){//生产设置的是“合格品率”或者“一级品率”
			document.getElementById("name").innerHTML ='合格品率';
			document.getElementById("qualified").style.display ='block';
			document.getElementById("first").style.display ='none';
			var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
		 	var substr = "name=qualified&project_info_no="+project_info_no;
		 	var retObj = jcdpCallService("QualityChartSrv", "qualityChart", substr);
		 	if(retObj!=null && retObj.returnCode=='0'){
		 		if(retObj.Str!=null){
		 			first = retObj.Str;
		 		}
		 	}
		 	myChart.setDataXML(first);
		    myChart.render("chartContainer1");
		}else{//一级品率
			document.getElementById("name").innerHTML ='一级品率';
			document.getElementById("qualified").style.display ='none';
			document.getElementById("first").style.display ='block';
			var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
		 	var substr = "name=first&project_info_no="+project_info_no;
		 	var retObj = jcdpCallService("QualityChartSrv", "qualityChart", substr);
		 	if(retObj!=null && retObj.returnCode=='0'){
		 		if(retObj.Str!=null){
		 			first = retObj.Str;
		 		}
		 	}
		 	myChart.setDataXML(first);
		    myChart.render("chartContainer");
		}
		//空炮率
	    myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
	    substr = "name=waster&project_info_no="+project_info_no;
	 	retObj = jcdpCallService("QualityChartSrv", "qualityChart", substr);
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			waster = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(waster);
	    myChart.render("chartContainer2");
	    //废炮率
	    myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
	    substr = "name=miss&project_info_no="+project_info_no;
	 	retObj = jcdpCallService("QualityChartSrv", "qualityChart", substr);
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			miss = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(miss);
	    myChart.render("chartContainer3");
	}
	function landChart(project_info_no){
	    var myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "100%", "0", "1");
	    myChart.setXMLUrl("<%=contextPath%>/qua/common/wellChart.srq?project_info_no="+project_info_no);
	    myChart.render("chartContainer4");
	    myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "100%", "0", "1");
	    myChart.setXMLUrl("<%=contextPath%>/qua/common/lineChart.srq?project_info_no="+project_info_no);
	    myChart.render("chartContainer5");
	    myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "100%", "0", "1");
	    myChart.setXMLUrl("<%=contextPath%>/qua/common/shotChart.srq?project_info_no="+project_info_no);
	    myChart.render("chartContainer6"); 
	}
	function getTotal(project_info_no){
		var querySql = " select t.qualified_radio qualified ,t.firstlevel_radio first ,t.waster_radio waster ,t.all_miss_radio miss "+
		" from bgp_pm_quality_index t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"'"
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode==''){
			if(retObj.datas[0] != null){
				data = retObj.datas[0];
				if(data.qualified!=null && data.qualified !=0){
					document.getElementById("qualified1").innerHTML = data.qualified;
				}else{
					document.getElementById("qualified1").innerHTML ="0";
				}
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
			}
		}
		querySql = "select sum(nvl(t.daily_acquire_sp_num,0)-(-nvl(t.daily_jp_acquire_shot_num,0))-(-nvl(t.daily_qq_acquire_shot_num,0)))total ,sum(nvl(t.daily_acquire_firstlevel_num,0)) first , "+
		" decode(sum(nvl(t.daily_acquire_qualified_num,0)),0,sum(nvl(t.daily_acquire_firstlevel_num,0))-(-sum(nvl(t.collect_2_class,0))),sum(nvl(t.daily_acquire_qualified_num,0))) qualified , "+
		" sum(nvl(t.collect_waster_num,0)) waster ,sum(nvl(t.collect_miss_num,0)) miss from gp_ops_daily_report t where t.bsflag='0' and t.audit_status ='3' and t.project_info_no ='"+project_info_no+"'"
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode==''){
			if(retObj.datas[0] != null){
				data = retObj.datas[0];
				if(data.qualified!=null && data.qualified !=0){
					document.getElementById("qualified2").innerHTML = data.qualified;
				}else{
					document.getElementById("qualified2").innerHTML ="0";
				}
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
					document.getElementById("total_qualified").innerHTML = data.total;
					document.getElementById("total_first").innerHTML = data.total;
					document.getElementById("total2").innerHTML = data.total;
					document.getElementById("total3").innerHTML = data.total;
				}else{
					document.getElementById("total_qualified").innerHTML = "0";
					document.getElementById("total_first").innerHTML = "0";
					document.getElementById("total2").innerHTML = "0";
					document.getElementById("total3").innerHTML = "0";
				}
			}
		}
	}
	
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