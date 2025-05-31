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
	String org_name = request.getParameter("org_name");
	
	if(org_name==null || org_name.trim().equals("")){
		org_name = user.getOrgName();
	}
	org_name = java.net.URLDecoder.decode(org_name,"UTF-8");
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
							<div align="center" ><font color="blue" size="5"><span id="org_name"><%=org_name %></span>各项目合格品率</font> </div>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" id="qualified">
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
	function cleanTable(){
		var table = document.getElementById("qualified");
		for(var i=table.rows.length-1 ;i>=0 ;i--){
			table.deleteRow(i);
		}
		var sql = " select eps.org_abbreviation org_name ,eps.org_id ,os.org_subjection_id from bgp_comm_org_wtc eps"+
		" join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0'"+
		" where eps.bsflag ='0' and eps.org_subjection_id ='<%=org_subjection_id%>' order by eps.order_num ";
	    var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+"&pageSize="+cruConfig.pageSizeMax);
	    if(retObj!=null && retObj.returnCode=='0'){
	    	if(retObj.datas!=null ){
	    		var org_name = retObj.datas[0].org_name;
	    		document.getElementById("org_name").innerHTML = org_name;
	    	}
	    }
	}
	function refreshData(){
		cleanTable();
		var sql = "select distinct p.project_name ,p.project_info_no "+
	    " from gp_task_project p join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no"+
	    " and dy.exploration_method = p.exploration_method  and dy.org_subjection_id like '<%=org_subjection_id%>%' "+
	    " join comm_org_information oi on dy.org_id = oi.org_id and oi.bsflag ='0'"+
	    " join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' "+
	    " join comm_coding_sort_detail ccsd1 on p.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0'"+
	    " left join bgp_pm_sap_org sap on sap.prctr = p.prctr"+
	    " left join bgp_p6_project p6 on p6.project_info_no = p.project_info_no  and p6.bsflag = '0'"+
	    " where p.bsflag ='0' and dy.org_subjection_id like '<%=org_subjection_id%>%' and p.project_type is not null order by p.project_name ";
	    var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+"&pageSize="+cruConfig.pageSizeMax);
	    if(retObj!=null && retObj.returnCode=='0'){
	    	if(retObj.datas!=null ){
	    		var table = document.getElementById("qualified");
    			var j =0;
    			var k =0;
   				var tr = table.insertRow(j);
   				for(var i=0; retObj.datas[k]!=null;){
   	    			var data = retObj.datas[k];
   	    			var project_info_no = data.project_info_no;
   	    			var project_name = data.project_name;
    				var index = i%6;
    				if(i!=0 && index==0){
    					j++;
    					tr = table.insertRow(j);
    				}
    				var td = tr.insertCell(index);
    				td.width ='32.3%';
    				var abb = project_name;
    				if(project_name.length > 25){
    					abb =project_name.substring(0,25)+ "..."
    				}
    				td.innerHTML = "<div class='tongyong_box'><div class='tongyong_box_title'><span class='kb'><a href='#'></a></span><a href='#' title='"+project_name+"'>"+abb+"</a></div>"+
    				"<div class='tongyong_box_content_left' style='height: 230px;'><div id='chartContainer_"+i+"'></div>"  +
    				"<p class='small'>合格品指标≥<span id='quality_percent_"+i+"'>0</span>%;累计完成炮数:<span id='total_"+i+"'>0</span>;</p>"+
    				"累计完成合格品炮数:<span id='quality_"+i+"'>0</span></p></div></div>" ;
    				chart(i,project_info_no);
    				getTotal(i,project_info_no);
    				index++;
    				td = tr.insertCell(index);
    				td.width ='1%';
    				k++;
    				i = i+2;
   				}
	    	}
	    } 
	    //getTotal(project_info_no);
	}
	refreshData();
	function chart(index , project_info_no){
		var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "1");
	 	var substr = "name=first&project_info_no="+project_info_no;
	 	var retObj = jcdpCallService("QualityChartSrv", "qualityChart", substr);
	 	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='98' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='98' maxValue='99' code='FF654F'/> <color minValue='99' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='98' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(first);
	 	var id = "chartContainer_"+index;
	 	myChart.render(id);
	}
	function getTotal(index,project_info_no){
		var querySql = " select t.qualified_radio qualified,t.waster_radio waster ,t.all_miss_radio miss"+
		" from bgp_pm_quality_index t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"'"
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode==''){
			if(retObj.datas[0] != null){
				data = retObj.datas[0];
				if(data.qualified!=null && data.qualified !=0){
					document.getElementById("quality_percent_"+index).innerHTML = data.qualified;
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
					document.getElementById("quality_"+index).innerHTML = data.qualified;
				}else{
					document.getElementById("quality_"+index).innerHTML ="0";
				}
				if(data.total!=null && data.total !=0){
					document.getElementById("total_"+index).innerHTML = data.total;
				}else{
					document.getElementById("total_"+index).innerHTML = "0";
				}
				
			}
		}
	}
	$(function(){
		$(window).resize(function(){
			refresh();
		});
	})	
	var width = 0;
	var height = 0;
	function refresh() {
		if(window.screen.width!=width || window.screen.height!=height){
			width = window.screen.width;
			height = window.screen.height;
			window.location.reload();
		}
	}
	</script>
    </body>
</html>