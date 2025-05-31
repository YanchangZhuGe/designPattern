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
	String org_subjection_id = request.getParameter("org_subjection_id");
	if(org_subjection_id==null || org_subjection_id.trim().equals("")){
		org_subjection_id = user.getSubOrgIDofAffordOrg();
	}
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
<body style="overflow-y: scroll; overflow-x: hidden;">
<div style="overflow-y: hidden; overflow-x: hidden;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="middle">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div class="tongyong_box" >
								<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">合格品率</a></div>
								<div class="tongyong_box_content_left" style="height: 300px;">
									<div id="chartContainer1"></div> 
								</div>
								<div id="content"></div> 
							</div>
						</td>
					</tr>
				</table>
			</td> 
		</tr>
	</table>
</div>
	<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function cleanTable(){
		var table = document.getElementById("qualified");
		for(var i=table.rows.length-1 ;i>=0 ;i--){
			table.deleteRow(i);
		}
	}
	function refreshData(){
		var myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "myChartId", "100%", "300", "0", "1");
	 	var substr = "name=qualified&project_info_no=";
	 	var retObj = jcdpCallService("QualityChartSrv", "wellChartByOrg", substr);
	 	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='98' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='98' maxValue='99' code='FF654F'/> <color minValue='99' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='98' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	 	myChart.render("chartContainer1");
	 	getTotal();
	}
	refreshData();
	function getTotal(){  //and p.project_status='3'  正在施工
		var querySql = " select tt.eps_id ,tt.eps_name ,tt.org_id ,tt.org_subjection_id ,case when tt.waster is null then 0 else tt.waster end waster ,"+
			" case when tt.miss is null then 0 else tt.miss end miss,case when tt.qualified is null then 0 else tt.qualified end qualified ,"+
			" case when tt.total is null then 0 else tt.total end total,round((case when tt.total is null then 0 else tt.qualified/tt.total*100 end),2) qualified_percent from( "+
			" select t.eps_id ,t.eps_name ,t.org_id , sub.org_subjection_id ,sum(r.collect_waster_num) waster ,sum(r.collect_miss_num) miss ," +
			" decode(sum(r.daily_acquire_qualified_num),'0',sum(r.daily_acquire_firstlevel_num)-(-sum(r.collect_2_class)),sum(r.daily_acquire_qualified_num)) qualified ," +
			" decode(sum(r.daily_acquire_qualified_num),'0',sum(r.daily_acquire_firstlevel_num)-(-sum(r.collect_2_class)),sum(r.daily_acquire_qualified_num))-(-sum(r.collect_waster_num)) total" +
			" from bgp_eps_code t left join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag='0'" +
			" left join gp_ops_daily_report r on r.org_subjection_id like concat(sub.org_subjection_id,'%') and r.bsflag='0'" +
			" left join gp_task_project p on r.project_info_no = p.project_info_no and p.bsflag='0'" +
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and p.exploration_method = d.exploration_method and d.bsflag='0'" +
			" where t.bsflag='0' and t.parent_object_id =(select c.object_id from bgp_eps_code c where c.org_id ='C6000000000001')" +
			" group by t.eps_id ,t.eps_name ,t.org_id , sub.org_subjection_id )tt" ;
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql))+'&pageSize='+cruConfig.pageSizeMax);
		var p ="<p class='small' >";
		if(retObj!=null && retObj.returnCode==''){
			if(retObj.datas != null && retObj.datas.length>0){
				for(var i =0 ;i<retObj.datas.length ;i++){
					var data = retObj.datas[i];
					var qualified_percent = data.qualified_percent;
					var qualified = data.qualified;
					var total = data.total;
					var eps_name = data.eps_name;
					p = p +"<font color='blue'>"+ eps_name + "</font>(合格品指标≥<span >"+qualified_percent+"</span>%;&nbsp;累计完成炮数:<span >"+total+"</span>;&nbsp;累计完成合格品炮数:<span >"+qualified+"</span>);";
					if(i!=0 && i%2 ==1){
						p = p+"</p><p class='small' >";
					}
				}
			}else{
				querySql = "select t.eps_id ,t.eps_name ,t.org_id , sub.org_subjection_id ,'0' qualified, '0' total ,'0' qualified_percent from bgp_eps_code t "+
				" join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag='0' "+
				" where t.bsflag='0' and t.parent_object_id =(select c.object_id from bgp_eps_code c where c.org_id ='C6000000000001')"
				retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
				if(retObj.datas != null && retObj.datas.length>0){
					for(var i =0 ;i<retObj.datas.length ;i++){
						var data = retObj.datas[i];
						var qualified_percent = data.qualified_percent;
						var qualified = data.qualified;
						var total = data.total;
						var eps_name = data.eps_name;
						p = p +"<font color='blue'>"+ eps_name + "</font>(合格品指标≥<span >"+qualified_percent+"</span>%;&nbsp;累计完成炮数:<span >"+total+"</span>;&nbsp;累计完成合格品炮数:<span >"+qualified+"</span>);";
						if(i!=0 && i%2 ==1){
							p = p+"</p><p class='small' >";
						}
					}
				}
			}
		}else{
			querySql = "select t.eps_id ,t.eps_name ,t.org_id , sub.org_subjection_id ,'0' qualified, '0' total ,'0' qualified_percent from bgp_eps_code t "+
			" join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag='0' "+
			" where t.bsflag='0' and t.parent_object_id =(select c.object_id from bgp_eps_code c where c.org_id ='C6000000000001')"
			retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(retObj.datas != null && retObj.datas.length>0){
				for(var i =0 ;i<retObj.datas.length ;i++){
					var data = retObj.datas[i];
					var qualified_percent = data.qualified_percent;
					var qualified = data.qualified;
					var total = data.total;
					var eps_name = data.eps_name;
					p = p +"<font color='blue'>"+ eps_name + "</font>(合格品指标≥<span >"+qualified_percent+"</span>%;&nbsp;累计完成炮数:<span >"+total+"</span>;&nbsp;累计完成合格品炮数:<span >"+qualified+"</span>);";
					if(i!=0 && i%2 ==1){
						p = p+"</p><p class='small' >";
					}
				}
			}
		}
		p = p + "</p>";
		document.getElementById("content").innerHTML = p;
	}
	function projectQualified(org_subjection_id ,org_name){
		org_name = decodeURI(decodeURI(org_name));
		window.open('<%=contextPath%>/qua/mProject/analysis/qualified.jsp?org_subjection_id='+org_subjection_id+'&org_name='+encodeURI(org_name));
	}
	</script>
    </body>
</html>