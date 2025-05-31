<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="java.util.Random"%>

<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	Random  r=new Random();
	double  change =r.nextDouble();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
function toChoseSelfNum(){
	var obj = new Object();
	var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/selectZySelfNum.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
	if(vReturnValue!=undefined){
		document.getElementById("s_dev_coding").value = vReturnValue;
		}
}

</script>

<title>无标题文档</title>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';

function getFusionChart(){
	//设置默认时间
	  var today=new Date();
	  var year=today.getYear();
	  var month=today.getMonth()+1;
	  var date=today.getDate();
	  var end_date;
	  if(month<10){
		  month="0"+month; 
	  }
	  if(date<10){
		  end_date=year+"-"+month+"-"+"0"+date;
	  }else{
		  end_date=year+"-"+month+"-"+date;
	  }
	 
	  var begin_date=year+"-"+month+"-"+"01";
	  $("#start_date").val(begin_date);
	  $("#end_date").val(end_date);
	var retObj1 = jcdpCallServiceCache("EarthquakeTeamStatistics","getZyStatistics","projectInfoNo=<%=projectInfoNo%>");
	var dataXml1 = retObj1.dataXML;
	var myChart1 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId1", "100%", "250", "0", "0" );    
	myChart1.setXMLData(dataXml1);
	myChart1.render("chartContainer1");
}
function simpleSearch(){
	
	var startDate = document.getElementById("start_date").value;
	var endDate = document.getElementById("end_date").value;
	var dev_coding = document.getElementById("s_dev_coding").value;
	var project_info_id = document.getElementById("project_info_id").value;
	var retObj1 = jcdpCallServiceCache("EarthquakeTeamStatistics","getZyStatistics","startDate="+startDate+"&endDate="+endDate+"&dev_coding="+dev_coding+"&project_info_id="+project_info_id+"&projectInfoNo=<%=projectInfoNo%>&change=<%=change%>");
	var dataXml1 = retObj1.dataXML;
	var myChart1 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId1", "100%", "250", "0", "0" );    
	myChart1.setXMLData(dataXml1);
	myChart1.render("chartContainer1");
	}
function toChoseProject(){
	var obj = new Object();
	var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/selectProject.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
	if(vReturnValue!=undefined){
		var  innerHtml="";
		var project_info_ids="";
		$("#dev_project_name").html("");
		 var selectedProjects=vReturnValue.split(",");
		 for(var i=0;i<selectedProjects.length-1;i++ ){
			var ids = selectedProjects[i].split("-");
			var id= ids[0];
		    var project_name = ids[5];
		    innerHtml+="<option  value='"+id+"'>"+project_name+"</option>";
		    project_info_ids+=id+",";
			 
		 }
		$("#dev_project_name").append(innerHtml);
		$("#project_info_id").val(project_info_ids);
		}
}
function clearQueryText(){
	
	document.getElementById("start_date").value="";
	document.getElementById("end_date").value="";
	document.getElementById("s_dev_coding").value="";
	$("#dev_project_name").html("");
	getFusionChart();

}
function exportDataDoc(exportFlag){
	//调用导出方法
	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
	var submitStr="";
	var startDate=$("#start_date").val();
	var endDate=$("#end_date").val();
    var dev_coding=$("#s_dev_coding").val();
    var project_info_id = document.getElementById("project_info_id").value;
    submitStr = "exportFlag="+exportFlag+"&startDate="+startDate+"&endDate="+endDate+"&dev_coding="+dev_coding+"&project_info_id="+project_info_id+"&projectInfoNo=<%=projectInfoNo%>";
	var retObj = syncRequest("post", path, submitStr);
	var filename=retObj.excelName;
	filename = encodeURI(filename);
	filename = encodeURI(filename);
	var showname=retObj.showName;
	showname = encodeURI(showname);
	showname = encodeURI(showname);
	window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
}

</script>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
						<td width="100%" colspan="3">
						<div class="tongyong_box">
						<div class="tongyong_box_title">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							  <td class="ali_cdn_name">开始时间:</td>
							    <td class="ali_cdn_input" align="right"><input id="start_date" name="start_date" class="input_width" type="text" readonly/> </td>
							    <td style="width: 10px;" align="left">
						 	    <img src='<%=contextPath%>/images/calendar.gif' id='tributton_start_date' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(start_date,tributton_start_date);'/>
						 	    </td>
							    <td class="ali_cdn_name">结束时间:</td>
							    <td class="ali_cdn_input" align="right"><input id="end_date" name="end_date" class="input_width" type="text" readonly/></td>
							     <td style="width: 10px;" align="left">
						 	    <img src='<%=contextPath%>/images/calendar.gif'id='tributton_end_date' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(end_date,tributton_end_date);'/>
						 	    </td>
							  <td class="ali_cdn_name">震源编号</td>
			                  <td >
			                  <table>
			                  <tr> <td><input id="s_dev_coding" name="s_dev_coding" type="text" readonly="readonly"/></td>
			                  <td><img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="toChoseSelfNum()"/></td></tr>
			                  </table>
			                 </td>
			                  <td class="ali_cdn_name">项目名称</td>
			                  <td  align="right">
			                  <select id="dev_project_name" name="dev_project_name"  style="width:200px">
			                  <option value=""  ></option>
			                  </select>
			     
			                  <input  type="hidden" id="project_info_id"/>
			                  </td>
			                   <td align="left"> <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="toChoseProject()"/></td>
      			              <td class="ali_query">
				              <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			                  </td>
			                  <td class="ali_query">
				              <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				              
			    </td>
			    </tr>
							</table>
							</div>			
						</div>
						</td>
					</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">震源备件消耗数量统计</a><span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('TORPC')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 400px;">
			 
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
</html>