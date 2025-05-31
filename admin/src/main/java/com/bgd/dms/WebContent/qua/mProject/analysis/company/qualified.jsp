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
	}
	function refreshData(){
		cleanTable();
		var sql = "select distinct t.project_name ,t.project_info_no "+
		    " from gp_task_project t join gp_task_project_dynamic d on t.project_info_no = d.project_info_no "+
		    " and d.bsflag ='0' and t.exploration_method = d.exploration_method "+
		    " join comm_org_subjection o on d.org_id = o.org_id and o.bsflag ='0'"+
		    " join comm_coding_sort_detail s on t.manage_org = s.coding_code_id and s.bsflag = '0'"+
		    " where t.bsflag ='0' and d.org_subjection_id like '<%=org_subjection_id%>%' order by t.project_name ";
	    var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+"&pageSize="+cruConfig.pageSizeMax);
	    if(retObj!=null && retObj.returnCode=='0'){
	    	if(retObj.datas!=null ){
	    		var table = document.getElementById("qualified");
    			var j =0;
   				var tr = table.insertRow(j);
   				for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
   	    			var data = retObj.datas[i];
   	    			var project_info_no = data.project_info_no;
   	    			var project_name = data.project_name;
    				var index = i%3;
    				if(i!=0 && index==0){
    					j++;
    					tr = table.insertRow(j);
    				}
    				var td = tr.insertCell(index);
    				td.innerHTML = "<div class='tongyong_box'><div class='tongyong_box_title'><span class='kb'><a href='#'></a></span><a href='#' title='"+project_name+"'>"+project_name.substring(0,25)+ "..."+"</a></div>"+
    				"<div class='tongyong_box_content_left' style='height: 195px;'><div id='chartContainer_"+i+"'></div>"  +
    				"<p class='small'>合格品指标≥<span id='quality_percent_"+i+"'>0</span>%;累计完成炮数:<span id='total_"+i+"'>0</span>;</p>"+
    				"累计完成合格品炮数:<span id='quality_"+i+"'>0</span></p></div></div>" ;
    				chart(i,project_info_no);
    				getTotal(i,project_info_no);
   				}
	    	}
	    } 
	    //getTotal(project_info_no);
	}
	refreshData();
	function chart(index , project_info_no){
		var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "280", "155", "0", "1");
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
		querySql = "select decode(sum(t.daily_acquire_qualified_num),'0',sum(t.daily_acquire_firstlevel_num)-(-sum(t.collect_2_class)),sum(t.daily_acquire_qualified_num)) qualified ,"+
		" sum(t.collect_waster_num) waster ,sum(t.collect_miss_num) miss ,sum(t.daily_acquire_firstlevel_num)-(-sum(t.collect_2_class))-(-sum(t.collect_waster_num)) total"+
		" from gp_ops_daily_report t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"'"
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
	</script>
    </body>
</html>