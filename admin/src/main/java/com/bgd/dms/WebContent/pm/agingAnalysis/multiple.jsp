<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId =  user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	WorkMethodSrv wm = new WorkMethodSrv();
	String	workmethod = wm.getProjectWorkMethod(projectInfoNo);
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
%>
<html>
<head>
<title>时效分析</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/setday.js"></script>
<style type="text/css">
body,table, td {font-size:12px;font-weight:normal;}
/* 重点：固定行头样式*/  
.scrollRowThead{BACKGROUND-COLOR: #AEC2E6;position: relative; left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);z-index:0;}  
/* 重点：固定表头样式*/  
.scrollColThead {position: relative;top: expression(this.parentElement.parentElement.parentElement.scrollTop);z-index:2;}  
/* 行列交叉的地方*/  
.scrollCR{ z-index:3;}
/*div 外框*/  
.scrollDiv {height:90%;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%;}  
/* 行头居中*/  
.scrollColThead td,.scrollColThead th{ text-align: center ;}  
/* 行头列头背景*/  
.scrollRowThead,.scrollColThead td,.scrollColThead th{background-color:#94B6E6;background-repeat:repeat;}  
/* 表格的线*/  
.scrolltable{border-bottom:1px solid #CCCCCC; border-right:1px solid #8EC2E6;}  
/* 单元格的线等*/  
.scrolltable td,.scrollTable th{border-left: 1px solid #CCCCCC; border-top: 1px solid #CCCCCC; padding: 1px;}
.scrollTable thead th{background-color:#94B6E6;position:relative;}
.td_head {
	FONT-SIZE: 12px;
	COLOR: #296184;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	text-align: center;
	vertical-align: middle;
	height:20px;
	line-height: 20px;
	background:#CCCCCC;
}
</style>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var projectInfoNo = "<%=projectInfoNo%>";
var projectName = "<%=projectName%>";
var exportRows = new Array();

var workmethod = "<%=workmethod%>";
var bActive = false;
var team_name = "";

function initData(){
	//获取队号
	//var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	//if(retPrj.project != null){
	//	team_name = retPrj.project.team_name;
	//}
	//加载数据
	var retObj = jcdpCallService("AgingAnalysisSrv","multipleReadDailyReport","");
	//alert(retObj.resultList.length);
	if(retObj.reportStartDate!=null){
		var td = document.getElementById("tdProjectDate");
		td.innerHTML = retObj.reportStartDate;	
	}
	if(retObj.resultList != null){
		var thHtml ="";
		for(var i=0;i<retObj.resultList.length;i++){
			if(i%2==0){
				trclass="odd";
			}else{	
				trclass = "even"
			}
			var lineUnit = "";
			if(retObj.resultList[i].lineUnit==1){
				lineUnit="m"
			}else if(retObj.resultList[i].lineUnit==2){
				lineUnit="km"
			}else if(retObj.resultList[i].lineUnit==3){
				lineUnit="m&sup2"
			}else if(retObj.resultList[i].lineUnit==4){
				lineUnit="km&sup2"
			}
			thHtml+="<tr class='"+trclass+"'>"
			+"<td>"+retObj.resultList[i].exMethodName+"</td>"
			+"<td>"+retObj.resultList[i].teamName+"</td>"
			+"<td>"+retObj.resultList[i].startDate+"</td>"
			+"<td>"+retObj.resultList[i].endDate+"</td>"
			+"<td>"+retObj.resultList[i].dailyEndDate+"</td>"
			+"<td>"+retObj.resultList[i].daily_workload+lineUnit+"</td>"
			+"<td>"+retObj.resultList[i].daily_coordinate_point+"</td>"
			+"<td>"+retObj.resultList[i].daily_check_point+"</td>"
			+"<td>"+retObj.resultList[i].daily_physical_point+"</td>"
			+"<td>"+retObj.resultList[i].allDay+"</td>"
			+"<td>"+retObj.resultList[i].produceDay+"</td>"
			+"<td>"+retObj.resultList[i].stopInstrumentDay+"</td>"
			+"<td>"+retObj.resultList[i].stopPersonnelDay+"</td>"
			+"<td>"+retObj.resultList[i].stopSituationDay+"</td>"
			+"<td>"+retObj.resultList[i].stopWorkFarmerDay+"</td>"
			+"<td>"+retObj.resultList[i].stopOilDay+"</td>"
			+"<td>"+retObj.resultList[i].stopOtherDay+"</td>"
			+"<td>"+retObj.resultList[i].suspendInstrumentDay+"</td>"
			+"<td>"+retObj.resultList[i].suspendPersonnelDay+"</td>"
			+"<td>"+retObj.resultList[i].suspendSituationDay+"</td>"
			+"<td>"+retObj.resultList[i].suspendWorkFarmerDay+"</td>"
			+"<td>"+retObj.resultList[i].suspendOilDay+"</td>"
			+"<td>"+retObj.resultList[i].suspendOtherDay+"</td>"
			+"<td>"+retObj.resultList[i].teamWorkLoad+"</td>"
			+"<td>"+retObj.resultList[i].teamPhysical+"</td>"
			+"<td>"+retObj.resultList[i].singleWorkLoad+lineUnit+"</td>"
			+"<td>"+retObj.resultList[i].singlePhysical+"</td>"
			+"<td>"+retObj.resultList[i].reworkLv+"%</td>"
			+"<td>"+retObj.resultList[i].comLv+"%</td></tr>";

			var exportRow = {};
			exportRow["1"] 	= retObj.resultList[i].exMethodName;	
			exportRow["2"] = retObj.resultList[i].teamName;              
			exportRow["3"] = retObj.resultList[i].startDate;             
			exportRow["4"] = retObj.resultList[i].endDate;               
			exportRow["5"] = retObj.resultList[i].dailyEndDate;          
			exportRow["6"] = retObj.resultList[i].daily_workload;        
			exportRow["7"] = retObj.resultList[i].daily_coordinate_point;
			exportRow["8"] = retObj.resultList[i].daily_check_point;     
			exportRow["9"] = retObj.resultList[i].daily_physical_point;  
			exportRow["10"] = retObj.resultList[i].allDay;               
			exportRow["11"] = retObj.resultList[i].produceDay;           
			exportRow["12"] = retObj.resultList[i].stopInstrumentDay;   
			exportRow["13"] = retObj.resultList[i].stopPersonnelDay;     
			exportRow["14"] = retObj.resultList[i].stopSituationDay;     
			exportRow["15"] = retObj.resultList[i].stopWorkFarmerDay;    
			exportRow["16"] = retObj.resultList[i].stopOilDay;           
			exportRow["17"] = retObj.resultList[i].stopOtherDay;         
			exportRow["18"] = retObj.resultList[i].suspendInstrumentDay; 
			exportRow["19"] = retObj.resultList[i].suspendPersonnelDay;  
			exportRow["20"] = retObj.resultList[i].suspendSituationDay;  
			exportRow["21"] = retObj.resultList[i].suspendWorkFarmerDay; 
			exportRow["22"] = retObj.resultList[i].suspendOilDay;        
			exportRow["23"] = retObj.resultList[i].suspendOtherDay;      
			exportRow["24"] = retObj.resultList[i].teamWorkLoad;         
			exportRow["25"] = retObj.resultList[i].teamPhysical;         
			exportRow["26"] = retObj.resultList[i].singleWorkLoad;       
			exportRow["27"] = retObj.resultList[i].singlePhysical;       
			exportRow["28"] = retObj.resultList[i].reworkLv+"%";             
			exportRow["29"] = retObj.resultList[i].comLv+"%";  
			exportRows[exportRows.length] = exportRow;
		}
		//alert(thHtml);
		//$("#trlinesum").append(thHtml);
	$("#lineTable").append(thHtml);
	}

}


function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "multiple";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}
</script>
</head>
<body style="background:#fff;overflow-y:auto;overflow-x:auto;" onload="initData()" width="800px">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			    <td width="90%" align="center"><font size="3"><%=projectName%>项目时效分析表</font></td>
			    <td width="10%">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  		<tr>
			    		<td>&nbsp;</td>
			    		<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>
			  		</tr>
				</table>
				</td>
			   <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
</table>
<div id="scrollDiv" class="scrollDiv" >
<table id="lineTable" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable mytable">
    <thead>
    <tr class="scrollColThead td_head">
    	<td colspan="25" width="50%"></td>
    	<td colspan="1" width="50%" align="right" nowrap>项目启动日期:</td>
    	<td colspan="3" id="tdProjectDate"></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="4">项目工作量累计</td>
      <td></td>
      <td></td>
      <td colspan="6">停工天数</td>
      <td colspan="6">暂停天数</td>

      <td colspan="6">生产进度分析</td>
      
    </tr>
    <tr class="scrollColThead td_head">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
       <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="2">平均日效(队)</td>
      <td colspan="2">单台日效(仪器)</td>
      <td></td>
      <td></td>  
    </tr>
    <tr class="scrollColThead td_head">
     <td nowrap>&nbsp;&nbsp;施工方法&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;队号&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;采集开始日期&nbsp;</td>
      <td nowrap>&nbsp;采集结束日期&nbsp;</td>
      <td nowrap>&nbsp;日报截止日期&nbsp;</td>
      <td nowrap>&nbsp;工作量&nbsp;</td>
      <td nowrap>&nbsp;坐标点&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;检查点&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;物理点&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;自然天数&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;生产天数&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;仪器因素&nbsp;&nbsp;</td>
      <td nowrap>人员因素</td>
      <td nowrap>气候因素</td>
      <td nowrap>工农协调因素</td>
      <td nowrap>油公司因素</td> 
      <td nowrap>其他</td>
       <td nowrap>&nbsp;&nbsp;仪器因素&nbsp;&nbsp;</td>
      <td nowrap>人员因素</td>
      <td nowrap>气候因素</td>
      <td nowrap>工农协调因素</td>
      <td nowrap>油公司因素</td> 
      <td nowrap>其他</td>
      <td nowrap>工作量</td>
      <td nowrap>物理点</td>
      <td nowrap>工作量</td>
      <td nowrap>物理点</td>
      <td nowrap>返工率%</td>
      <td nowrap>完成率%</td>
    </tr>
 
</table>
</div>
</body>
</html>
