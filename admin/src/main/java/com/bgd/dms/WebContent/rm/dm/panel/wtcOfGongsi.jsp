<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String device_name = request.getParameter("device_name");
	device_name = new String(device_name.getBytes("GBK"),"UTF-8");
	device_name = new String(device_name.getBytes("GBK"),"UTF-8");
	if(device_name==null || device_name.trim().equals("")){
		device_name = "";
	}
	String parent_id = request.getParameter("parent_id");
	if(parent_id==null || parent_id.trim().equals("")){
		parent_id = "";
	}
	String num_type = request.getParameter("num_type");
	if(num_type==null || num_type.trim().equals("")){
		num_type = "";
	}
	
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body style="overflow-y: scroll; overflow-x: hidden;">
<div ><!-- style="overflow-y: auto; overflow-x: hidden;" -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="middle">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div class="tongyong_box" >
								<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#"><%=device_name %>基本情况统计表</a></div>
								<div class="tongyong_box_content_left" style="height: 380px;">
									<div id="chartContainer1"></div>
								</div>
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
		var table = document.getElementById("first");
		for(var i=table.rows.length-1 ;i>=0 ;i--){
			table.deleteRow(i);
		}
	}
	function refreshData(){
		var device_name = '<%=device_name%>';
		var parent_id = '<%=parent_id%>';
		var num_type = '<%=num_type%>';
		var myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId", "100%", "300", "0", "1");
	 	var substr = "device_name="+device_name+"&parent_id="+parent_id+"&num_type="+num_type;
	 	var retObj = jcdpCallService("DevCommInfoSrv", "wtcLevel", substr);
	 	var first ="<chart caption='地震仪器基本情况统计' XAxisName='Month' palette='2' animation='1' formatNumberScale='0' numberPrefix='$' showValues='0' numDivLines='4' legendPosition='BOTTOM'><categories><category label='ARIES' /><category label='428' /><category label='408' /><category label='SCORPION' /><category label='FIERFLY' /><category label='UNITE' /><category label='GSR' /><category label='G3I' /><category label='数字400系列' /><category label='ES109' /><category label='其他' /></categories><dataset seriesName='总量'><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/></dataset><dataset seriesName='在用'><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/></dataset><dataset seriesName='闲置(<1个月)'><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/></dataset><dataset seriesName='单位(>1个月)'><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/></dataset><dataset seriesName='在修/待修'><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/></dataset><dataset seriesName='待报废'><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/><set value='0'/></dataset> <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' /><style type='font' name='SubCaptionFont' bold='0' /></definition> <application><apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>";
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			first = retObj.Str;
	 		}
	 	}
	 	/* alert(decodeURI(first,"UTF-8")); */
	 	myChart.setDataXML(decodeURI(first,"UTF-8"));
	 	//myChart.setXMLUrl("<%=contextPath%>/MSCol3D1.xml"); 
	 	myChart.render("chartContainer1");
	}
	refreshData();
	//var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
	function fusionChart(device_name,org_subjection_id,num_type,parent_id){
		if(num_type==null || num_type==undefined || num_type==""){
			num_type = "";
		}
		var obj = {};
		device_name = decodeURI(device_name)
		window.showModalDialog('<%=contextPath %>/rm/dm/panel/teamOfGongsi.jsp?parent_id='+parent_id+'&num_type='+num_type+'&device_name='+device_name+'&org_subjection_id='+org_subjection_id,obj,'dialogWidth:1024px;dialogHeight:600px');
		//window.open('<%=contextPath %>/rm/dm/panel/teamOfGongsi.jsp?parent_id='+parent_id+'&num_type='+num_type+'&device_name='+device_name+'&org_subjection_id='+org_subjection_id);
		//window.open('<%=contextPath %>/rm/dm/panel/wtcOfGongsi.jsp?parent_id='+parent_id+'&num_type='+num_type+'&device_name='+device_name+'&org_subjection_id='+org_subjection_id);
	}
	function projectFirst(org_subjection_id,org_name){
		org_name = decodeURI(decodeURI(org_name));
		window.open('<%=contextPath%>/qua/mProject/analysis/wtc/first_project.jsp?org_subjection_id='+org_subjection_id+'&org_name='+encodeURI(org_name));
	}
	</script>
    </body>
</html>