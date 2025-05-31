<%@page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
 
	String projectName = user.getProjectName();	
	String projectInfoNo="";
	if(request.getParameter("projectInfoNo")==null&&"".equals(request.getParameter("projectInfoNo"))){
		projectInfoNo =user.getProjectInfoNo();
	}else{
		projectInfoNo=request.getParameter("projectInfoNo");
	}

 
	String contextPath = request.getContextPath();
	String  message="";
	if(resultMsg != null){
		message = resultMsg.getValue("message");
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());

%>
<html>
<head>
<title>项目情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

<style type="text/css">
#lineTable td{
	border: solid 1px block;
	align: center;
}
</style>
<script type="text/javascript">
var message = "<%=message%>";
if(message != "" && message != 'null'){
	alert(message);
 
}

var exportRows = null;
var vtlist;

cruConfig.contextPath='<%=contextPath%>';


function  obsVoid(){
	   debugger;
		var  retMessage=jcdpCallService("WsDailyReportSrv", "getAuditStatus", "projectInfoNo=<%=projectInfoNo%>");
		if(retMessage.message!=null){//判断周报表是否已经保存数据 如果么有 直接从项目信息读取相关信息 显示在页面上
			vtlist = retMessage.message;		 
		}else{
			var retObj  = jcdpCallService("WsDailyReportSrv", "getViewType", "projectInfoNo=<%=projectInfoNo%>");
			vtlist = retObj.dataList; 
		}
		for(var i=0;i<vtlist.length;i++){
			var obs=document.getElementById("obsPoint_"+i).value;
			var quPoint=document.getElementById("qualityPoints_"+i).value;
			var pass=document.getElementById("passPoint_"+i).value;
			var waste=document.getElementById("wastePoint_"+i).value;

			if(obs!=null&&obs!=""&&quPoint!=null&&quPoint!=""){
				document.getElementById("qualityRate_"+i).value=(quPoint/obs).toFixed(2)*100;
			}
			if(pass!=null&&pass!=""&&obs!=null&&obs!=""){
				document.getElementById("passRate_"+i).value=(pass/obs).toFixed(2)*100;
			}
			if(waste!=null&&waste!=""&&obs!=null&&obs!=""){
				document.getElementById("wasteRate_"+i).value=(waste/obs).toFixed(2)*100;
			}
			 
		}

	 
}
function initData(){
	exportRows=new Array();
	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"bgp_ws_daily_report",    			//置入流程管控的业务表的主表表明   对应的业务表
			businessType:"5110000004100000218",    //业务类型 即为之前设置的业务大类   
			businessId:'<%=projectInfoNo%>',           				//业务主表主键值   业务表主键 
			businessInfo:"井中周报审批",							//显示的流程名称
			applicantDate:'<%=appDate%>'       						//流程发起时间
		};


	processAppendInfo={ 
		projectName:'<%=projectName%>',								//流程引擎附加临时变量信息  项目名称
		projectInfoNo:'<%=projectInfoNo%>',                    //项目编号
		deviceallappid:'<%=projectInfoNo%>'                                //业务主表主键值   业务表主键 
	};
	loadProcessHistoryInfo();
	 
	
	var  result=jcdpCallService("WsDailyReportSrv", "getAustaus", "projectInfoNo=<%=projectInfoNo%>");
 	debugger;
	 
	var  retMessage=jcdpCallService("WsDailyReportSrv", "getAuditStatus", "projectInfoNo=<%=projectInfoNo%>");
	if(retMessage.message!=null){//判断周报表是否已经保存数据 如果么有 直接从项目信息读取相关信息 显示在页面上
		vtlist = retMessage.message;
			showDown();
	}else{
		var retObj  = jcdpCallService("WsDailyReportSrv", "getViewType", "projectInfoNo=<%=projectInfoNo%>");
		vtlist = retObj.dataList;
		showDown();
	}
	
	
	for (var t = 0; t <vtlist.length; t++) {
	
		
		debugger;
		var exportRow = {};
		exportRow["1"] = document.getElementById("orgName").value;
		exportRow["2"] = document.getElementById("basin").value;
		exportRow["3"] = document.getElementById("wellNumber").value;
		exportRow["4"] = document.getElementById("codingName").value;
		exportRow["5"] = document.getElementById("contractsSigned").value;
		exportRow["6"] = document.getElementById("projectIncome").value;
		exportRow["7"] = document.getElementById("completeValue").value;
		exportRow["8"] = document.getElementById("viewType_"+t).value;
		exportRow["9"] = document.getElementById("viewWell_"+t).value;
		exportRow["10"] = document.getElementById("viewPoint_"+t).value;
		exportRow["11"] = document.getElementById("buildMethod_"+t).value;
		exportRow["12"] = document.getElementById("acquireLevel_"+t).value;
		
		exportRow["13"] = document.getElementById("lineNumber_"+t).value;
		exportRow["14"] = document.getElementById("daoJu_"+t).value;
		exportRow["15"] = document.getElementById("zongDao_"+t).value;
		
		exportRow["16"] = document.getElementById("shotNumber_"+t).value;
		exportRow["17"] = document.getElementById("testRecord_"+t).value;
		exportRow["18"] = document.getElementById("obsPoint_"+t).value;
		exportRow["19"] = document.getElementById("qualityPoints_"+t).value;
		exportRow["20"] = document.getElementById("qualityRate_"+t).value;
		exportRow["21"] = document.getElementById("passPoint_"+t).value;
		exportRow["22"] = document.getElementById("passRate_"+t).value;
		exportRow["23"] = document.getElementById("wastePoint_"+t).value;
		exportRow["24"] = document.getElementById("wasteRate_"+t).value;
		
		exportRow["25"] = document.getElementById("refPoints_"+t).value;
		exportRow["26"] = document.getElementById("micLogging_"+t).value;
		
		exportRow["27"] = document.getElementById("open_date").value;
		exportRow["28"] = document.getElementById("close_date").value;
		
		exportRow["29"] = document.getElementById("projectStatus").value;
		exportRow["30"] = document.getElementById("handleExplainStatus").value;
		exportRow["31"] = document.getElementById("pass_date").value;
		exportRow["32"] = document.getElementById("remarks").value;

		exportRows[exportRows.length] = exportRow;
		 
	}
	
	
 
		
	}


   function showDown(){
		debugger;
		$("#lineTable tr:gt(0):not(:eq(0))").remove();

		var retObj = jcdpCallService("WsDailyReportSrv", "getReport", "projectInfoNo=<%=projectInfoNo%>");
		var retType= jcdpCallService("WsDailyReportSrv", "getViewType", "projectInfoNo=<%=projectInfoNo%>");
				var obj = jcdpCallService("WsDailyReportSrv", "refreshReport","projectInfoNo=<%=projectInfoNo%>");

		if(retObj !=null && retObj.returnCode =='0' && retObj.datas !=null){
			var lineTable = document.getElementById("lineTable");
				var list=null;
			if(obj.dataList!=null) {
				list=obj.dataList;
			}else{
				list=retType.dataList;
			}
			 
				var column ="orgName,basin,wellNumber,codingName,contractsSigned,projectIncome,completeValue,"+
				"viewType,viewWell,viewPoint,buildMethod,acquireLevel,viewWell,viewPoint,acquireLevel,shotNumber,testRecord,obsPoint,qualityPoints,qualityRate,passPoint,"+
				"passRate,wastePoint,wasteRate,refPoints,micLogging,startDate,endDate,projectStatus,handleExplainStatus,passDate,remarks";
				var columns = column.split(",");
				var row = lineTable.insertRow(2);	
				var td = row.insertCell(0);
				td.rowSpan=list.length+1;
				td.innerHTML ="1";
				var q=0;

				//TODO
				var tmpSeq = 0;
				var tmpSeqno = 0;
				for(var k=0;k<columns.length;k++){
					
					  td = row.insertCell(k+1);
					
				 	if(columns[k]!="viewType"&&columns[k]!="viewWell"&&columns[k]!="viewPoint"&&
				 			columns[k]!="buildMethod"&&columns[k]!="acquireLevel"&&columns[k]!="shotNumber"&&
				 			columns[k]!="testRecord"&&columns[k]!="obsPoint"&& columns[k]!="qualityPoints"&&columns[k]!="qualityRate"&&columns[k]!="passPoint"&&columns[k]!="passRate"&&
				 			columns[k]!="wastePoint"&&columns[k]!="wasteRate"&& columns[k]!="refPoints"&&columns[k]!="micLogging"){
				 		 td.rowSpan=list.length+1;
				 		 if(retObj.datas[columns[k]]!=null&& retObj.datas[columns[k]]!=""){
				 			 
				 			 if(columns[k]=="startDate"){
					 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='open_date' readonly='readonly'  value ='"+retObj.datas[columns[k]]+"'/>  <img width='16' height='16' id='cal_button8' style='cursor: hand;' onmouseover='calDateSelector(open_date,cal_button8);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="endDate"){
					 				td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='close_date' readonly='readonly'  value ='"+retObj.datas[columns[k]]+"'/>  <img width='16' height='16' id='cal_button9' style='cursor: hand;' onmouseover='calDateSelector(close_date,cal_button9);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="passDate"){
					 				td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='pass_date' readonly='readonly'  value ='"+retObj.datas[columns[k]]+"'/>  <img width='16' height='16' id='cal_button1' style='cursor: hand;' onmouseover='calDateSelector(pass_date,cal_button1);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="contractsSigned"){
					 				td.innerHTML = "<input readOnly='true' type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='"+retObj.datas[columns[k]]+"'/>";
					 			 }else  if(columns[k]=="completeValue"){
						 				td.innerHTML = "<input readOnly='true' type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='"+retObj.datas[columns[k]]+"'/>";
						 		 }else  if( columns[k]=="projectStatus"){
						 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='采集结束' readonly='readonly' /> ";
					 			 }else{
					 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='"+retObj.datas[columns[k]]+"'/>"; 
					 			 }
				 		 }else{
				 			 
				 			 if(columns[k]=="startDate"){
					 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='open_date' readonly='readonly'  value =''/>  <img width='16' height='16' id='cal_button8' style='cursor: hand;' onmouseover='calDateSelector(open_date,cal_button8);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="endDate"){
					 				td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='close_date' readonly='readonly'  value =''/>  <img width='16' height='16' id='cal_button9' style='cursor: hand;' onmouseover='calDateSelector(close_date,cal_button9);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="passDate"){
					 				 if(obj.dataList!=null){
							 				td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='pass_date' readonly='readonly'  value ='"+obj.dataList[0][columns[k]]+"'/>  <img width='16' height='16' id='cal_button1' style='cursor: hand;' onmouseover='calDateSelector(pass_date,cal_button1);' src='<%=contextPath%>/images/calendar.gif' />";
					 				 }else{
							 				td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='pass_date' readonly='readonly'  value =''/>  <img width='16' height='16' id='cal_button1' style='cursor: hand;' onmouseover='calDateSelector(pass_date,cal_button1);' src='<%=contextPath%>/images/calendar.gif' />";

					 				 }
					 			 }else if(columns[k]=="contractsSigned"){
				 			    	td.innerHTML = "<input readOnly='true' type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value =''/>";
				 			     }else if(columns[k]=="completeValue"){
					 				td.innerHTML = "<input readOnly='true' type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value =''/>";
					 		     }else  if( columns[k]=="projectStatus"){
						 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='采集结束' readonly='readonly' /> ";
					 			 }else if(obj.dataList!=null){
					 			    	td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='"+obj.dataList[0][columns[k]]+"'/>  ";
				 			    }else{
				 			    	td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value =''/>  ";
				 			    }
				 		
				 		
				 		 }
						
				 	}else if(columns[k]=="viewType"){
		                     for (var t = 0; t <list.length; t++) {
		                    	var map=list[t];
		             
					        var seq = Number(map.seSeqno); 
					        var seqno = Number(map.seqno); 
					        if(seq>1 && seq == tmpSeq && seqno == tmpSeqno){ 
							var tr = lineTable.insertRow( 4);
							var td = tr.insertCell(0); 
							td.rowSpan=1; 
								  
									 if(map.viewTypeCode=="5110000053000000007"||map.viewTypeCode=="5110000053000000008"){
									    
												// td = tr.insertCell(1);
												 td.innerHTML = "<input type='hidden' name='buildMethod' size='15'  id='viewWell_"+t+"' value =''/>";
												 td=tr.insertCell(1);
												 td.innerHTML ="<input type='hidden' name='viewPoint' size='15' id='viewPoint_"+t+"' value =''/>";
											 
										  
											 td = tr.insertCell(2);
											 var bm=retObj.datas['buildMethod'];
											 var bms=bm.split(",");
											 var bs="";
											 for(var p=0;p<bms.length;p++){
												 if(bms[p]=="5000100003000000001"){
													 bs="井炮 ";
												 }else if(bms[p]=="5000100003000000002"){
													 bs=bs+"震源 ";
												 }else if(bms[p]=="5000100003000000003"){
													 bs=bs+"气枪 ";
												 }else if(bms[p]=="5000100003000000010"){
													 bs=bs+"井下扫描源 ";
												 }else if(bms[p]=="5000100003000000011"){
													 bs=bs+"井下脉冲源 ";
												 }
											 }
											bs= bs.substring(0,bs.length-1);
											 
											 td.innerHTML = "<input type='text' name='buildMethod' size='15' id='buildMethod_"+t+"' value ='"+bs+"'/>";
										
									 
											 td = tr.insertCell(3);
											 td.innerHTML ="<input type='hidden' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value =''/>";
										 
										 td = tr.insertCell(4);
										 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+map.viewTypeCode+"'/><input type='text' name='lineNumber' size='10' id='lineNumber_"+t+"' value ='"+map.viewWell+"'/>";
										 td = tr.insertCell(5);
										 td.innerHTML = "<input type='text' name='daoJu' size='10' id='daoJu_"+t+"' value ='"+map.viewPoint+"'/>";
										 td = tr.insertCell(6);
										 td.innerHTML = "<input type='text' name='zongDao' size='10' id='zongDao_"+t+"' value ='"+map.acquireLevel+"'/>";
										}else{
											if (map.viewWell!=null&&map.viewPoint!=null) {
												
											 	 //td = tr.insertCell(1);
												 td.innerHTML = "<input type='text' name='viewWell' size='15' id='viewWell_"+t+"' value ='"+map.viewWell+"'/>";
												 td=tr.insertCell(1);
												 td.innerHTML = "<input type='text' name='viewPoint' size='15' id='viewPoint_"+t+"' value ='"+map.viewPoint+"'/>";
											} else{
												// td = tr.insertCell(1);
												 td.innerHTML = "<input type='text' name='viewWell' size='15' id='viewWell_"+t+"' value =''/>";
												 td=tr.insertCell(1);
												 td.innerHTML = "<input type='text' name='viewPoint' size='15' id='viewPoint_"+t+"' value =''/>";
											}
										  
											 td = tr.insertCell(2);
											 var bm=retObj.datas['buildMethod'];
											 var bms=bm.split(",");
											 var bs="";
											 for(var p=0;p<bms.length;p++){
												 if(bms[p]=="5000100003000000001"){
													 bs="井炮 ";
												 }else if(bms[p]=="5000100003000000002"){
													 bs=bs+"震源 ";
												 }else if(bms[p]=="5000100003000000003"){
													 bs=bs+"气枪 ";
												 }else if(bms[p]=="5000100003000000010"){
													 bs=bs+"井下扫描源 ";
												 }else if(bms[p]=="5000100003000000011"){
													 bs=bs+"井下脉冲源 ";
												 }
											 }
											bs= bs.substring(0,bs.length-1);
											 
											 td.innerHTML = "<input type='text' name='buildMethod' size='15' id='buildMethod_"+t+"' value ='"+bs+"'/>";
										
											 if(map.acquireLevel!=null){
												 td = tr.insertCell(3);
												 td.innerHTML = "<input type='text' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value ='"+map.acquireLevel+"'/>";
											 }else{
												 td = tr.insertCell(3);
												 td.innerHTML = "<input type='text' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value =''/>";
											 }
											 if(map.shotNumber!=null){
												 td = tr.insertCell(4);
												 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+map.viewTypeCode+"'/><input type='hidden' name='shotNumber' size='10' id='lineNumber_"+t+"' value ='"+map.shotNumber+"'/>";
											 }else{
												 td = tr.insertCell(4);
												 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+map.viewTypeCode+"'/><input type='hidden' name='shotNumber' size='10' id='lineNumber_"+t+"' value =''/>";
 
											 }
		         							 td = tr.insertCell(5);
											 td.innerHTML = "<input type='hidden' name='daoJu' size='10' id='daoJu_"+t+"' value =''/>";
											 td = tr.insertCell(6);
											 td.innerHTML = "<input type='hidden' name='zongDao' size='10' id='zongDao_"+t+"' value =''/>";
										}
									 if(map.shotNumber!=null){
										 td = tr.insertCell(7);
										 td.innerHTML = "<input type='text' name='shotNumber' size='10' id='shotNumber_"+t+"' value ='"+map.shotNumber+"'/>";
									 }else{
										 td = tr.insertCell(7);
										 td.innerHTML = "<input type='text' name='shotNumber' size='10' id='shotNumber_"+t+"' value =''/>";
									 }
									 if(map.testRecord!=null){
										  td = tr.insertCell(8);
									      td.innerHTML = "<input type='text' name='testRecord' size='10' id='testRecord_"+t+"' value ='"+map.testRecord+"'/>";
									 }  else{
										 td = tr.insertCell(8);
									      td.innerHTML = "<input type='text' name='testRecord' size='10' id='testRecord_"+t+"' value =''/>";
						
									 }
									 if(map.obsPoint!=null){
										  td = tr.insertCell(9);
									      td.innerHTML = "<input type='text' name='obsPoint' size='10' id='obsPoint_"+t+"' value ='"+map.obsPoint+"' onblur='obsVoid()'/>";
									 }  else{
										 td = tr.insertCell(9);
									      td.innerHTML = "<input type='text' name='obsPoint' size='10' id='obsPoint_"+t+"' value =''/>";
						
									 }
								   
									 if(map.qualityPoints!=null){
										 td = tr.insertCell(10);
										 td.innerHTML = "<input type='text' name='qualityPoints' size='10' id='qualityPoints_"+t+"' value ='"+map.qualityPoints+"'  onblur='obsVoid()'/>";
							
									 }else{
										 td = tr.insertCell(10);
										 td.innerHTML = "<input type='text' name='qualityPoints' size='10' id='qualityPoints_"+t+"' value =''  onblur='obsVoid()'/>";
									 }
								 
									 if(map.qualityRate!=null){
										 td = tr.insertCell(11);
										 td.innerHTML = "<input type='text' name='qualityRate' size='10' id='qualityRate_"+t+"' value ='"+map.qualityRate+"'  readonly='readonly'/>";

									 }else{
										 td = tr.insertCell(11);
										 td.innerHTML = "<input type='text' name='qualityRate' size='10' id='qualityRate_"+t+"' value =''  readonly='readonly'/>";

									 }
									 if(map.passPoint!=null){
										   td = tr.insertCell(12);
											 td.innerHTML = "<input type='text' name='passPoint' size='10' id='passPoint_"+t+"' value ='"+map.passPoint+"'  onblur='obsVoid()'/>";
									 }else{
										   td = tr.insertCell(12);
											 td.innerHTML = "<input type='text' name='passPoint' size='10' id='passPoint_"+t+"' value =''  onblur='obsVoid()'/>";

									 }
									 if(map.passRate!=null){
									 	 td = tr.insertCell(13);
										 td.innerHTML = "<input type='text' name='passRate' size='10' id='passRate_"+t+"' value ='"+map.passRate+"' readonly='readonly'/>";
						
									 }else{
									 	 td = tr.insertCell(13);
										 td.innerHTML = "<input type='text' name='passRate' size='10' id='passRate_"+t+"' value ='' readonly='readonly'/>";
						
									 }
									 if(map.wastePoint!=null){
						  				 td = tr.insertCell(14);
										 td.innerHTML = "<input type='text' name='wastePoint' size='10' id='wastePoint_"+t+"' value ='"+map.wastePoint+"' onblur='obsVoid()'/>";
									 }else{
						  				 td = tr.insertCell(14);
										 td.innerHTML = "<input type='text' name='wastePoint' size='10' id='wastePoint_"+t+"' value ='' onblur='obsVoid()'/>";
									 }
									 if(map.wasteRate!=null){
										 td = tr.insertCell(15);
										 td.innerHTML = "<input type='text' name='wasteRate' size='10' id='wasteRate_"+t+"' value ='"+map.wasteRate+"'/>";
									
									 }else{
										 td = tr.insertCell(15);
										 td.innerHTML = "<input type='text' name='wasteRate' size='10' id='wasteRate_"+t+"' value =''/>";
									
									 }
									 if(map.refPoints){
										 td = tr.insertCell(16);
										 td.innerHTML = "<input type='text' name='refPoints' size='10' id='refPoints_"+t+"' value ='"+map.refPoints+"'/>";
						
									 }else{
										 td = tr.insertCell(16);
										 td.innerHTML = "<input type='text' name='refPoints' size='10' id='refPoints_"+t+"' value =''/>";
						
									 }
									 if(map.micLogging!=null){
										 td = tr.insertCell(17);
										 td.innerHTML = "<input type='text' name='micLogging' size='10' id='micLogging_"+t+"' value ='"+map.micLogging+"'/>";
									 		
									 }else{
										 td = tr.insertCell(17);
										 td.innerHTML = "<input type='text' name='micLogging' size='10' id='micLogging_"+t+"' value =''/>";
									 		
									 }
									 
                                			

							} else {
		 
									var tr = lineTable.insertRow( 3);
									var td = tr.insertCell(0); 
									 td.rowSpan=map.seSeqno;
							 
									if (map.viewTypeCode=="5110000053000000000") {
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='零偏横波VSP'/>";
									} else if (map.viewTypeCode=="5110000053000000001") {
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='零偏纵波VSP'/>";
									}else if(map.viewTypeCode=="5110000053000000002"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='非零偏VSP'/>";
									}else if(map.viewTypeCode=="5110000053000000003"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='Walkaway-VSP'/>";
									} else if(map.viewTypeCode=="5110000053000000004"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='Walkaround-VSP'/>";
									}else if(map.viewTypeCode=="5110000053000000005"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='3D-VSP'/>";
									}else if(map.viewTypeCode=="5110000053000000006"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='微地震井中监测'/>";
									}else if(map.viewTypeCode=="5110000053000000007"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='微地震地面监测'/>";
									}else if(map.viewTypeCode=="5110000053000000008"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='随钻地震'/>";
									}else if(map.viewTypeCode=="5110000053000000009"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='井间地震'/>";
									}else if(map.viewTypeCode=="5110000053000000010"){
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='井地联合勘探'/>";
									}else{ 
										td.innerHTML = "<input type='hidden' id='seqno_"+t+"' value='"+map.seqno+"'/><input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='"+map.viewType+"'/>";
									}
								   
									 if(map.viewTypeCode=="5110000053000000007"||map.viewTypeCode=="5110000053000000008"){
										 
												 td = tr.insertCell(1);
												 td.innerHTML = "<input type='hidden' name='buildMethod' size='15'  id='viewWell_"+t+"' value =''/>";
												 td=tr.insertCell(2);
												 td.innerHTML ="<input type='hidden' name='viewPoint' size='15' id='viewPoint_"+t+"' value =''/>";
											 
										  
											 td = tr.insertCell(3);
											 var bm=retObj.datas['buildMethod'];
											 var bms=bm.split(",");
											 var bs="";
											 for(var p=0;p<bms.length;p++){
												 if(bms[p]=="5000100003000000001"){
													 bs="井炮 ";
												 }else if(bms[p]=="5000100003000000002"){
													 bs=bs+"震源 ";
												 }else if(bms[p]=="5000100003000000003"){
													 bs=bs+"气枪 ";
												 }else if(bms[p]=="5000100003000000010"){
													 bs=bs+"井下扫描源 ";	
												 }else if(bms[p]=="5000100003000000011"){
													 bs=bs+"井下脉冲源 ";
												 }
											 }
											bs= bs.substring(0,bs.length-1);
											 
											 td.innerHTML = "<input type='text' name='buildMethod' size='15' id='buildMethod_"+t+"' value ='"+bs+"'/>";
										
									 
											 td = tr.insertCell(4);
											 td.innerHTML ="<input type='hidden' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value =''/>";
										 
										 td = tr.insertCell(5);
										 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+map.viewTypeCode+"'/><input type='text' name='lineNumber' size='10' id='lineNumber_"+t+"' value ='"+map.viewWell+"'/>";
										 td = tr.insertCell(6);
										 td.innerHTML = "<input type='text' name='daoJu' size='10' id='daoJu_"+t+"' value ='"+map.viewPoint+"'/>";
										 td = tr.insertCell(7);
										 td.innerHTML = "<input type='text' name='zongDao' size='10' id='zongDao_"+t+"' value ='"+map.acquireLevel+"'/>";
										}else{
											if (map.viewWell!=""&&map.viewPoint!="") {
												
											 	 td = tr.insertCell(1);
												 td.innerHTML = "<input type='text' name='viewWell' size='15' id='viewWell_"+t+"' value ='"+map.viewWell+"'/>";
												 td=tr.insertCell(2);
												 td.innerHTML = "<input type='text' name='viewPoint' size='15' id='viewPoint_"+t+"' value ='"+map.viewPoint+"'/>";
											} else{
												 td = tr.insertCell(1);
												 td.innerHTML = "<input type='text' name='viewWell' size='15' id='viewWell_"+t+"' value =''/>";
												 td=tr.insertCell(2);
												 td.innerHTML = "<input type='text' name='viewPoint' size='15' id='viewPoint_"+t+"' value =''/>";
											}
										  
											 td = tr.insertCell(3);
											 var bm=retObj.datas['buildMethod'];
											 var bms=bm.split(",");
											 var bs="";
											 for(var p=0;p<bms.length;p++){
												 if(bms[p]=="5000100003000000001"){
													 bs="井炮 ";
												 }else if(bms[p]=="5000100003000000002"){
													 bs=bs+"震源 ";
												 }else if(bms[p]=="5000100003000000003"){
													 bs=bs+"气枪 ";
												 }else if(bms[p]=="5000100003000000010"){
													 bs=bs+"井下扫描源 ";
												 }else if(bms[p]=="5000100003000000011"){
													 bs=bs+"井下脉冲源 ";
												 }
											 }
											bs= bs.substring(0,bs.length-1);
											 
											 td.innerHTML = "<input type='text' name='buildMethod' size='15' id='buildMethod_"+t+"' value ='"+bs+"'/>";
										
											 if(map.acquireLevel!=null){
												 td = tr.insertCell(4);
												 td.innerHTML = "<input type='text' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value ='"+map.acquireLevel+"'/>";
											 }else{
												 td = tr.insertCell(4);
												 td.innerHTML = "<input type='text' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value =''/>";
											 }
											 if(map.shotNumber!=null){
												 td = tr.insertCell(5);
												 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+map.viewTypeCode+"'/><input type='hidden' name='shotNumber' size='10' id='lineNumber_"+t+"' value ='"+map.shotNumber+"'/>";
								
											 }else{
												 td = tr.insertCell(5);
												 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+map.viewTypeCode+"'/><input type='hidden' name='shotNumber' size='10' id='lineNumber_"+t+"' value =''/>";
								
											 }
														 td = tr.insertCell(6);
											 td.innerHTML = "<input type='hidden' name='daoJu' size='10' id='daoJu_"+t+"' value =''/>";
											 td = tr.insertCell(7);
											 td.innerHTML = "<input type='hidden' name='zongDao' size='10' id='zongDao_"+t+"' value =''/>";
										}
									 if(map.shotNumber!=null){
										 td = tr.insertCell(8);
										 td.innerHTML = "<input type='text' name='shotNumber' size='10' id='shotNumber_"+t+"' value ='"+map.shotNumber+"'/>";
						
									 }else{
										 td = tr.insertCell(8);
										 td.innerHTML = "<input type='text' name='shotNumber' size='10' id='shotNumber_"+t+"' value =''/>";
						
									 }
									 if(map.testRecord!=null){
										  td = tr.insertCell(9);
									      td.innerHTML = "<input type='text' name='testRecord' size='10' id='testRecord_"+t+"' value ='"+map.testRecord+"'/>";
									 }  else{
										 td = tr.insertCell(9);
									      td.innerHTML = "<input type='text' name='testRecord' size='10' id='testRecord_"+t+"' value =''/>";
						
									 }
								 
									 if(map.obsPoint!=null){
										  td = tr.insertCell(10);
									      td.innerHTML = "<input type='text' name='obsPoint' size='10' id='obsPoint_"+t+"' value ='"+map.obsPoint+"' onblur='obsVoid()'/>";
									 }  else{
										 td = tr.insertCell(10);
									      td.innerHTML = "<input type='text' name='obsPoint' size='10' id='obsPoint_"+t+"' value =''/>";
						
									 }
									 
									 if(map.qualityPoints!=null){
										 td = tr.insertCell(11);
										 td.innerHTML = "<input type='text' name='qualityPoints' size='10' id='qualityPoints_"+t+"' value ='"+map.qualityPoints+"'  onblur='obsVoid()'/>";
							
									 }else{
										 td = tr.insertCell(11);
										 td.innerHTML = "<input type='text' name='qualityPoints' size='10' id='qualityPoints_"+t+"' value =''  onblur='obsVoid()'/>";
									 }
									 
									 
									 
									 

									 if(map.qualityRate!=null){
										 td = tr.insertCell(12);
										 td.innerHTML = "<input type='text' name='qualityRate' size='10' id='qualityRate_"+t+"' value ='"+map.qualityRate+"'  readonly='readonly'/>";

									 }else{
										 td = tr.insertCell(12);
										 td.innerHTML = "<input type='text' name='qualityRate' size='10' id='qualityRate_"+t+"' value =''  readonly='readonly'/>";

									 }
									 if(map.passPoint!=null){
										   td = tr.insertCell(13);
											 td.innerHTML = "<input type='text' name='passPoint' size='10' id='passPoint_"+t+"' value ='"+map.passPoint+"'  onblur='obsVoid()'/>";
									 }else{
										   td = tr.insertCell(13);
											 td.innerHTML = "<input type='text' name='passPoint' size='10' id='passPoint_"+t+"' value =''  onblur='obsVoid()'/>";

									 }
									 if(map.passRate!=null){
									 	 td = tr.insertCell(14);
										 td.innerHTML = "<input type='text' name='passRate' size='10' id='passRate_"+t+"' value ='"+map.passRate+"' readonly='readonly'/>";
						
									 }else{
									 	 td = tr.insertCell(14);
										 td.innerHTML = "<input type='text' name='passRate' size='10' id='passRate_"+t+"' value ='' readonly='readonly'/>";
						
									 }
									 if(map.wastePoint!=null){
						  				 td = tr.insertCell(15);
										 td.innerHTML = "<input type='text' name='wastePoint' size='10' id='wastePoint_"+t+"' value ='"+map.wastePoint+"' onblur='obsVoid()'/>";
									 }else{
						  				 td = tr.insertCell(15);
										 td.innerHTML = "<input type='text' name='wastePoint' size='10' id='wastePoint_"+t+"' value ='' onblur='obsVoid()'/>";
									 }
									 if(map.wasteRate!=null){
										 td = tr.insertCell(16);
										 td.innerHTML = "<input type='text' name='wasteRate' size='10' id='wasteRate_"+t+"' value ='"+map.wasteRate+"'/>";
									
									 }else{
										 td = tr.insertCell(16);
										 td.innerHTML = "<input type='text' name='wasteRate' size='10' id='wasteRate_"+t+"' value =''/>";
									
									 }
									 if(map.refPoints){
										 td = tr.insertCell(17);
										 td.innerHTML = "<input type='text' name='refPoints' size='10' id='refPoints_"+t+"' value ='"+map.refPoints+"'/>";
						
									 }else{
										 td = tr.insertCell(17);
										 td.innerHTML = "<input type='text' name='refPoints' size='10' id='refPoints_"+t+"' value =''/>";
						
									 }
									 if(map.micLogging!=null){
										 td = tr.insertCell(18);
										 td.innerHTML = "<input type='text' name='micLogging' size='10' id='micLogging_"+t+"' value ='"+map.micLogging+"'/>";
									 		
									 }else{
										 td = tr.insertCell(18);
										 td.innerHTML = "<input type='text' name='micLogging' size='10' id='micLogging_"+t+"' value =''/>";
									 		
									 }
									 
									 
									/*  td = tr.insertCell(12);
									 td.innerHTML = "<input type='text' name='qualityRate' size='10' id='qualityRate_"+t+"' value =''  readonly='readonly'/>";
									 td = tr.insertCell(13);
									 td.innerHTML = "<input type='text' name='passPoint' size='10' id='passPoint_"+t+"' value =''  onblur='obsVoid()'/>";
									 td = tr.insertCell(14);
									 td.innerHTML = "<input type='text' name='passRate' size='10' id='passRate_"+t+"' value ='' readonly='readonly'/>";
									 td = tr.insertCell(15);
									 td.innerHTML = "<input type='text' name='wastePoint' size='10' id='wastePoint_"+t+"' value ='' onblur='obsVoid()'/>";
									 td = tr.insertCell(16);
									 td.innerHTML = "<input type='text' name='wasteRate' size='10' id='wasteRate_"+t+"' value =''/>";
									 td = tr.insertCell(17);
									 td.innerHTML = "<input type='text' name='refPoints' size='10' id='refPoints_"+t+"' value =''/>";
									 td = tr.insertCell(18);
									 td.innerHTML = "<input type='text' name='micLogging' size='10' id='micLogging_"+t+"' value =''/>"; */
								 		
									 
								}	 
					        tmpSeqno = Number(map.seqno);
					        tmpSeq =seq;
		                     }

						} 
					 
		 

				}
			}
   }
  
	function toSave() {
		debugger;
		var msg=document.getElementById("mage").innerHTML;
		
		if(msg=="未保存"||msg=="已保存"||msg=="审批不通过"){
			 var updateSql="update bgp_ws_daily_report   set  bsflag='1'  where project_info_no ='<%=projectInfoNo%>'";
				var retObj0 = jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+updateSql);
			var org_n=document.getElementById("orgName").value;//施工队号  
			var bsi=document.getElementById("basin").value;             //地区盆地
			var well_n=document.getElementById("wellNumber").value;     //施工井号(无)
			var coding_n=document.getElementById("codingName").value;  // 甲方名称
			var contracts_s =document.getElementById("contractsSigned").value; //已签订合同金额（无）
			var contract_a =document.getElementById("projectIncome").value;//预测价值工作量
			var complete_v=document.getElementById("completeValue").value;//完成价值工作量(无)
			var start_t=document.getElementById("open_date").value//开工时间
			var end_t=document.getElementById("close_date").value//完工时间
	 
		    var  project_s =document.getElementById("projectStatus").value//运行状态
		    var  handle_s =document.getElementById("handleExplainStatus").value//处理、解释状态
		    var  pass_d =document.getElementById("pass_date").value//甲方验收日期
		    var  remark  =document.getElementById("remarks").value//备注
		 
		    var viType = document.getElementsByName("viewType"); debugger;
			var dataType= jcdpCallService("WsDailyReportSrv", "getViewType", "projectInfoNo=<%=projectInfoNo%>");
			 var list=dataType.dataList;
			 var view_tT = null;
			 var view_t=null;
			 var seq_1=null;
			 var seq=null;
			
			for (var i = 0; i < list.length; i++) {
			  
			 if(document.getElementById("viewType_"+i)!=null){
 				    view_t=document.getElementById("viewType_"+i).value;//观测方法
 				}
 				if(document.getElementById("seqno_"+i)!=null){
 					seq=document.getElementById("seqno_"+i).value;  
 				}
			   if(seq==null) 
				   seq=seq_1;
			   seq_1=seq;
			   

			    if(view_t == null)
			    	view_t = view_tT;
			    view_tT = view_t;
			    var build_m=document.getElementById("buildMethod_"+i).value;//激发方式
			    //微地震地面监测
			    var  line_v=document.getElementById("line_value_"+i).value;  
                if(line_v!="5110000053000000007"&&line_v!="5110000053000000008"){
                	    var view_w=document.getElementById("viewWell_"+i).value;//观测井段 
					    var view_p=document.getElementById("viewPoint_"+i).value;//观测点距
					    var collection_s=document.getElementById("acquireLevel_"+i).value;//采集级数
                   
			    }else{
			    	   var view_w=document.getElementById("lineNumber_"+i).value;//接收线数                              
	      			    var view_p=document.getElementById("daoJu_"+i).value;//道距
	      			    var collection_s=document.getElementById("zongDao_"+i).value;//总接收道数
			    }
			  
			    
			    var shot_n=document.getElementById("shotNumber_"+i).value;//炮数
			    var test_r=document.getElementById("testRecord_"+i).value;//实验
			    var obs_p=document.getElementById("obsPoint_"+i).value;//观测点数
			    var quality_p=document.getElementById("qualityPoints_"+i).value;//优极品点数
			    var quality_r=document.getElementById("qualityRate_"+i).value;//优级品率
			    var pass_p=document.getElementById("passPoint_"+i).value; //合格品点数
			    var pass_r=document.getElementById("passRate_"+i).value; //合格品率
			    var waste_p=document.getElementById("wastePoint_"+i).value; //废品点数
			    var waste_r=document.getElementById("wasteRate_"+i).value; //废品点数
			    
			    var ref_p=document.getElementById("refPoints_"+i).value; //小折射点数
			    var mic_l=document.getElementById("micLogging_"+i).value; //微测井 
	
			

				var str="org_name="+org_n +"&basin="+bsi+"&well_number="+well_n+"&coding_name="+coding_n
			
				+"&contracts_signed="+contracts_s+"&project_income="+contract_a+"&complete_value="+complete_v
				
				+"&view_type="+view_t+"&view_well="+view_w+"&view_point="+view_p+"&build_method="+build_m
				
				+"&acquire_level="+collection_s+"&shot_number="+shot_n+"&test_record="+test_r
				
				+"&obs_point="+obs_p+"&quality_points="+quality_p+"&quality_rate="+quality_r+"&pass_point="+pass_p+"&pass_rate="+pass_r
				
				+"&waste_point="+waste_p+"&waste_rate="+waste_r+"&ref_points="+ref_p+"&mic_logging="+mic_l+"&start_date="+start_t

				+"&end_date="+end_t+"&project_status="+project_s+"&handle_explain_status="+handle_s+"&pass_date="+pass_d+"&remarks="+remark+"&view_type_code="+line_v+"&seqno="+seq;
		 		var obj = jcdpCallService("WsDailyReportSrv","addReport",str);
		 	
			}
			if(obj.bcStuts=="ok"){
	 			alert("保存成功");
	 		}
	 		
		}else{
			alert(msg+"，不能保存");
		}
		initData();
	}
	function toSubmit(){
		debugger;
		if(confirm('确定要提交吗?')){  

			  var  mage=document.getElementById("mage").innerHTML;
			  if(mage=="已保存"||mage=="审批不通过"){
					var retObj = jcdpCallService("WsDailyReportSrv", "submitWeekReport", "projectInfoNo=<%=projectInfoNo%>");
					submitProcessInfo();

			  }else if(mage=="未保存"){
				alert("未保存不能提交");
			  }
		}
		if(typeof(retObj)!="undefined"){
			if(retObj.action_status=='ok'){
				alert("提交操作成功!");
				initData();
			}
			
		}
	}
	function downloadTemplate(){
		window.location.href="<%=contextPath%>/pm/dailyReport/singleProject/download.jsp?path=/pm/lineConstruction/2dLineConsructionTemp.xls&filename=2dLineConsruction_template.xls";
	}
	function refreshData() {
		$("#lineTable tr:gt(0):not(:eq(0))").remove();
 debugger;
		var obj = jcdpCallService("WsDailyReportSrv", "refreshReport","projectInfoNo=<%=projectInfoNo%>");
	 
			
		
		 var lineTable = document.getElementById("lineTable");
	     var vt=obj.datas.viewType;
	     var tc=obj.datas.typeCode;
	     var vw=obj.datas.viewWell;
	     
	     var vp=obj.datas.viewPoint;
	     var vm=obj.datas.buildMethod;
	     var vc=obj.datas.acquireLevel;
	     var vs=obj.datas.shotNumber;
	     var vd=obj.datas.testRecord;
	     var vo=obj.datas.obsPoint;
	     var rpp=obj.datas.passPoint;
	     var rpa=obj.datas.passRate;
	     var qp=obj.datas.qualityPoints;
	     var qr=obj.datas.qualityRate;
	     var wp=obj.datas.wastePoint;
	     var wr=obj.datas.wasteRate;
	     var fp=obj.datas.refPoints;
	     var ml=obj.datas.micLogging;
	     var mls=ml.split(",");
	     var fps="";
	     var vcs="";
	     var tcs="";
	     if(tc!=""&&tc!=null){
	    	 tcs=tc.split(",");
	     }
	     if(fp!=""&&fp!=null){
	    	fps=fp.split(",");
	     }
	   if(vc!=""&&vc!=null){
		  vcs =vc.split(",");
	   }
	   var wrs="";
	   if(wr!=""&&wr!=null){
		   wrs=wr.split(",");
	   }
	     var wps="";
	     if(wp!=null&&wp!=""){
	    	 wps=wp.split(",");
	     }
	     var  qrs="";
	     if(qr!=""&&qr!=null){
	    	 qrs=qr.split(",");
	     }
	     var  qps="";
	     if(qp!=""&&qp!=null){
	    	 qps=qp.split(",");
	     }
	     var vts="";
	     if(vt!=null&&vt!=""){
	    	 vts=vt.split(",");
	     }
	     var vws="";
	     if(vw!=""&&vw!=""){
	    	 vws=vw.split(","); 
	     }
	     var vps="";
	     if(vp!=""&&vp!=null){
	    	 vps=vp.split(",");
	    	 
	     }
	     var vms="";
	     if(vm!=null&&vm!=""){
	    	 vms=vm.split(",");
	     }
	     var vss="";
	     if(vs!=""&&vs!=null){
	    	 vss=vs.split(",");
	     }

	     var vds="";
	     if(vd!=null&&vd!=""){
	    	 vds=vd.split(",");
	    	 
	     }
	     var vos="";
	     if(vo!=""&&vo!=null){
	    	 vos=vo.split(",");
	     }
	    
	     var rps="";
	     if(rpp!=""&&rpp!=null){
	    	 rps=rpp.split(",");
	    	 
	     }
	     var rpas="";
	     if(rpa!=null&&rpa!=""){
	    	 
	    	 rpas=rpa.split(",");
	     }
	     var vts="";
	     if(vt!=null&&vt!=""){
	    	 vts=vt.split(",");
	     }
	    
	  
			var column ="orgName,basin,wellNumber,codingName,contractsSigned,projectIncome,completeValue,"+
			"viewType,viewWell,viewPoint,buildMethod,acquireLevel,viewWell,viewPoint,acquireLevel,shotNumber,testRecord,obsPoint,qualityPoints,qualityRate,passPoint,"+
			"passRate,wastePoint,wasteRate,refPoints,micLogging,startDate,endDate,projectStatus,handleExplainStatus,passDate,remarks";
			var columns = column.split(",");
			var row = lineTable.insertRow(2);	
			var td = row.insertCell(0);
			td.rowSpan=vts.length+1;
			td.innerHTML ="1";
			var q=0;
			for(var k=0;k<columns.length;k++){
				  td = row.insertCell(k+1);
				 	if(columns[k]!="viewType"&&columns[k]!="viewWell"&&columns[k]!="viewPoint"&&
				 			columns[k]!="buildMethod"&&columns[k]!="acquireLevel"&&columns[k]!="shotNumber"&&
				 			columns[k]!="testRecord"&&columns[k]!="obsPoint"&& columns[k]!="qualityPoints"&&columns[k]!="qualityRate"&&columns[k]!="passPoint"&&columns[k]!="passRate"&&
				 			columns[k]!="wastePoint"&&columns[k]!="wasteRate"&& columns[k]!="refPoints"&&columns[k]!="micLogging"){
				 		 td.rowSpan=vts.length+1;
				 		 if(obj.datas[columns[k]]!=null&& obj.datas[columns[k]]!=""){
				 			 if( columns[k]=="projectStatus"){
				 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='采集结束'  readonly='readonly'  />";
				 			 } 
				 			 
				 			 if(columns[k]=="startDate"){
					 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='open_date' readonly='readonly'  value ='"+obj.datas[columns[k]]+"'/>  <img width='16' height='16' id='cal_button8' style='cursor: hand;' onmouseover='calDateSelector(open_date,cal_button8);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="endDate"){
					 				td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='close_date' readonly='readonly'  value ='"+obj.datas[columns[k]]+"'/>  <img width='16' height='16' id='cal_button9' style='cursor: hand;' onmouseover='calDateSelector(close_date,cal_button9);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="passDate"){
					 				td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='pass_date' readonly='readonly'  value ='"+obj.datas[columns[k]]+"'/>  <img width='16' height='16' id='cal_button1' style='cursor: hand;' onmouseover='calDateSelector(pass_date,cal_button1);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="contractsSigned"){
					 				td.innerHTML = "<input readOnly='true' type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='"+obj.datas[columns[k]]+"'/>";
					 			 }else if(columns[k]=="completeValue"){
						 				td.innerHTML = "<input readOnly='true' type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='"+obj.datas[columns[k]]+"'/>";
						 		 }else{
					 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='"+obj.datas[columns[k]]+"'/>"; 
					 			 }
				 		 }else{
				 			 if( columns[k]=="projectStatus"){
					 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value ='采集结束'  readonly='readonly'  />";
					 			 } 
				 			 if(columns[k]=="startDate"){
					 				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='open_date' readonly='readonly'  value =''/>  <img width='16' height='16' id='cal_button8' style='cursor: hand;' onmouseover='calDateSelector(open_date,cal_button8);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="endDate"){
					 				td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='close_date' readonly='readonly'  value =''/>  <img width='16' height='16' id='cal_button9' style='cursor: hand;' onmouseover='calDateSelector(close_date,cal_button9);' src='<%=contextPath%>/images/calendar.gif' />";
					 			 }else if(columns[k]=="passDate"){
				 			    	td.innerHTML = "  <input type='text' name='"+columns[k]+"' size='10' id='pass_date' readonly='readonly'  value =''/>  <img width='16' height='16' id='cal_button1' style='cursor: hand;' onmouseover='calDateSelector(pass_date,cal_button1);' src='<%=contextPath%>/images/calendar.gif' />";
				 			     }else if(columns[k]=="contractsSigned"){
				 			    	td.innerHTML = "<input readOnly='true' type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value =''/>";
				 			     }else if(columns[k]=="completeValue"){
					 				td.innerHTML = "<input readOnly='true' type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value =''/>";
					 		     }else{
				 			    	td.innerHTML = "<input type='text' name='"+columns[k]+"' size='10' id='"+columns[k]+"' value =''/>  ";
				 			    }
				 		
				 		
				 		 }
						
						
				 	}else if(columns[k]=="viewType"){
		                     for (var t = 0; t <vts.length; t++) {
		                     
								var tr = lineTable.insertRow(t + 3);
								var td = tr.insertCell(0);
								if (vts[t]!=""&&vts[t]!=null) {
									td.innerHTML = "<input type='text' name='"+columns[k]+"' size='25' id='"+columns[k]+"_"+t+"' value ='"+vts[t]+"'/>";
								}
							
						
							
								// debugger;
	                             if(vts[t]=="微地震地面监测"||vts[t]=="随钻地震"){
	                          
										 td = tr.insertCell(1);
										 td.innerHTML = "<input type='hidden' name='viewWell' size='15' id='viewWell_"+t+"' value =''/>";
										 td=tr.insertCell(2);
										 td.innerHTML = "<input type='hidden' name='viewPoint' size='15' id='viewPoint_"+t+"' value =''/>";

									 td = tr.insertCell(3);
									 td.innerHTML = "<input type='text' name='buildMethod' size='15' id='buildMethod_"+t+"' value ='"+vms[t]+"'/>";
	                            	 td = tr.insertCell(4);
								 
										 td.innerHTML = "<input type='hidden' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value =''/>";
								 
	                            		if (vws[t]!=""&&vps[t]!="") {
	   								 	 td = tr.insertCell(5);
	   									 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+tcs[t]+"'/><input type='text' name='viewWell' size='15' id='lineNumber_"+t+"' value ='"+vws[t]+"'/>";
	   									 td=tr.insertCell(6);
	   									 td.innerHTML = "<input type='text' name='viewPoint' size='15' id='daoJu_"+t+"' value ='"+vps[t]+"'/>";
	   									 td=tr.insertCell(7);
	   									 td.innerHTML = "<input type='text' name='viewPoint' size='15' id='zongDao_"+t+"' value ='"+vcs[t]+"'/>";
	   								} else{
	   								
	   								 td = tr.insertCell(5);
   									 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+tcs[t]+"'/><input type='hidden' name='viewWell' size='15' id='lineNumber_"+t+"' value =''/>";
   									 td=tr.insertCell(6);
   									 td.innerHTML = "<input type='hidden' name='viewPoint' size='15' id='daoJu_"+t+"' value =''/>";
   									 td=tr.insertCell(7);
   									 td.innerHTML = "<input type='hidden' name='viewPoint' size='15' id='zongDao_"+t+"' value =''/>";
	   								}
								  }else{
										if (vws[t]!="" ) {
										 	 td = tr.insertCell(1);
											 td.innerHTML = "<input type='text' name='viewWell' size='15' id='viewWell_"+t+"' value ='"+vws[t]+"'/>";
										}else{
											 td = tr.insertCell(1);
											 td.innerHTML = "<input type='text' name='viewWell' size='15' id='viewWell_"+t+"' value =''/>";
										}
										if( vps[t]!=""){
											 td=tr.insertCell(2);
											 td.innerHTML = "<input type='text' name='viewPoint' size='15' id='viewPoint_"+t+"' value ='"+vps[t]+"'/>";
										}else{ 
											 td=tr.insertCell(2);
											 td.innerHTML = "<input type='text' name='viewPoint' size='15' id='viewPoint_"+t+"' value =''/>";
										}
									  
										 td = tr.insertCell(3);
								 
										 td.innerHTML = "<input type='text' name='buildMethod' size='15' id='buildMethod_"+t+"' value ='"+vms[t]+"'/>";
									  td = tr.insertCell(4);
										 if(vcs[t]!=""&&vcs[t]!=null){
											 td.innerHTML = "<input type='text' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value ='"+vcs[t]+"'/>";
										 }else{
											 td.innerHTML = "<input type='text' name='acquireLevel' size='12' id='acquireLevel_"+t+"' value =''/>";
										 }
										 td = tr.insertCell(5);
	   									 td.innerHTML = "<input type='hidden' id='line_value_"+t+"' value='"+tcs[t]+"'/><input type='hidden' name='viewWell' size='15' id='lineNumber_"+t+"' value =''/>";
	   									 td=tr.insertCell(6);
	   									 td.innerHTML = "<input type='hidden' name='viewPoint' size='15' id='daoJu_"+t+"' value =''/>";
	   									 td=tr.insertCell(7);
	   									 td.innerHTML = "<input type='hidden' name='viewPoint' size='15' id='zongDao_"+t+"' value =''/>";
								  }
							
	                        	 td = tr.insertCell(8);
								 if(vss[t]!=""&&vss[t]!=null){
									 td.innerHTML = "<input type='text' name='shotNumber' size='10' id='shotNumber_"+t+"' value ='"+vss[t]+"'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='shotNumber' size='10' id='shotNumber_"+t+"' value =''/>";
								 }
								 td = tr.insertCell(9);
								 if(vds[t]!=""&&vds[t]!=null){
									 td.innerHTML = "<input type='text' name='testRecord' size='10' id='testRecord_"+t+"' value ='"+vds[t]+"'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='testRecord' size='10' id='testRecord_"+t+"' value =''/>";
								 }
								 td = tr.insertCell(10);
								if(vos[t]!=""&&vos[t]!=null){
									 td.innerHTML = "<input type='text' name='obsPoint' size='10' id='obsPoint_"+t+"' value ='"+vos[t]+"' onblur='obsVoid()'/>";
								}else{
									 td.innerHTML = "<input type='text' name='obsPoint' size='10' id='obsPoint_"+t+"' value ='' onblur='obsVoid()'/>";
								}
								
							
								 td = tr.insertCell(11);
								 if(qps[t]!=""&&qps[t]!=null){
									 td.innerHTML = "<input type='text' name='qualityPoints' size='10' id='qualityPoints_"+t+"' value ='"+qps[t]+"'onblur='obsVoid()'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='qualityPoints' size='10' id='qualityPoints_"+t+"' value ='' onblur='obsVoid()'/ >";
								 }
								
								 td = tr.insertCell(12);
								 if(qrs[t]!=""&&qrs[t]!=null){
									 td.innerHTML = "<input type='text' name='qualityRate' size='10' id='qualityRate_"+t+"' value ='"+qrs[t]+"' readonly='readonly'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='qualityRate' size='10' id='qualityRate_"+t+"' value ='' readonly='readonly'/>";
								 }
								 
							
								 td = tr.insertCell(13);
								 if(rps[t]!=""&&rps[t]!=null){
									 td.innerHTML = "<input type='text' name='passPoint' size='10' id='passPoint_"+t+"' value ='"+rps[t]+"' onblur='obsVoid()'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='passPoint' size='10' id='passPoint_"+t+"' value ='' onblur='obsVoid()'/>";
								 }
								
								 td = tr.insertCell(14);
								 if(rpas[t]!=""&&rpas[t]!=null){
									 td.innerHTML = "<input type='text' name='passRate' size='10' id='passRate_"+t+"' value ='"+rpas[t]+"' readonly='readonly'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='passRate' size='10' id='passRate_"+t+"' value ='' readonly='readonly'/>";
								 }
								
								 td = tr.insertCell(15);
								 if(wps[t]!=""&&wps[t]!=null){
									 td.innerHTML = "<input type='text' name='wastePoint' size='10' id='wastePoint_"+t+"' value ='"+wps[t]+"' onblur='obsVoid()'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='wastePoint' size='10' id='wastePoint_"+t+"' value ='' onblur='obsVoid()'/>";
								 }
								 
								
								 td = tr.insertCell(16);
								 if(wrs[t]!=""&&wrs[t]!=null){
									 td.innerHTML = "<input type='text' name='wasteRate' size='10' id='wasteRate_"+t+"' value ='"+wrs[t]+"'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='wasteRate' size='10' id='wasteRate_"+t+"' value =''/>";
								 }
								
								 td = tr.insertCell(17);
								 if(fps[t]!=""&&fps[t]!=null){
									 td.innerHTML = "<input type='text' name='refPoints' size='10' id='refPoints_"+t+"' value ='"+fps[t]+"'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='refPoints' size='10' id='refPoints_"+t+"' value =''/>";
								 }
							
								 td = tr.insertCell(18);
								 if(mls[t]!=""&&mls[t]!=null){
									 td.innerHTML = "<input type='text' name='micLogging' size='10' id='micLogging_"+t+"' value ='"+mls[t]+"'/>";
								 }else{
									 td.innerHTML = "<input type='text' name='micLogging' size='10' id='micLogging_"+t+"' value =''/>";
								 }
							
							 		
								 
								 
								
							}

						} 
					 
		 
			}
	 
	}
	
	
	function exportExcel(){
		debugger;
		var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
		var rows=JSON.stringify(exportRows);
		var fromPage = "wsReport";
		var submitStr = "fromPage=" + fromPage + "&projectName=<%=projectName%>&dataRows="+rows;
		var retObj = syncRequest("post", path, submitStr);
		window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
	}
	
	
	function importData(){
		var filename = document.getElementById("fileName").value;
		var result = document.getElementById("mage").innerHTML;
		if(filename == ""){
			alert("请选择导入文件!");
			return;
		}
		if(result!="未保存"&&result!="已保存"&&result!="审批不通过"){
			alert(result+"，不能导入");
			return;
		}
		if(checkFile(filename)){
			document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importWeekRerport.srq?projectInfoNo=<%=projectInfoNo%>";
			document.getElementById("fileForm").submit();
		}
	}

	function checkFile(filename){
		var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
		type=type.toUpperCase();
		if(type=="XLS" || type=="XLSX"){
		   return true;
		}
		else{
		   alert("上传类型有误，请上传EXCLE文件！");
		   return false;
		}
	}
</script>
</head>
<body  onload="initData()">

 
	 <div id="table_box" >
			<table id="lineTable" width="100%" border="0" cellspacing="0" align="center" cellpadding="0" class="scrolltable">
			<tr align="center" >
				<td colspan="8" class="bt_info_odd"><font color="red" size="2">此列参数须一致</font></td>
			
				<td colspan="8" class="bt_info_odd">采集参数</td>
				<td colspan="11" class="bt_info_odd" >完成工作量及质量</td>
				<td colspan="6" class="bt_info_odd"><font color="red" size="2">此列参数须一致</font></td>
			
			</tr>
			<tr align="center" >
				<td  class="bt_info_odd" align ='center'>序号</td>
				<td  class="bt_info_odd">施工队伍</td>
				<td  class="bt_info_odd">地区(盆地)</td>
				<td  class="bt_info_odd">施工井号</td>
				<td  class="bt_info_odd">甲方名称</td>
				<td  class="bt_info_odd">已签订合同额(万 元)</td>
				<td  class="bt_info_odd">预测价值工作量(万 元)</td>
				<td  class="bt_info_odd">完成价值工作量(万 元)</td>
				<td class="bt_info_odd">观测方式</td>
				<td class="bt_info_odd">观测井段（米）</td>
				<td class="bt_info_odd">观测点距（米）</td>
				<td class="bt_info_odd">激发方式</td>
				<td class="bt_info_odd">采集级数（级）</td>
				<td class="bt_info_odd">接收线数（线）</td>
				<td class="bt_info_odd">道距（米）</td>
				<td class="bt_info_odd">总接收道数（道）</td>
				
		
				<td class="bt_info_odd">炮数</td>
				<td class="bt_info_odd">合格试验记录</td>
				<td class="bt_info_odd">总观测点数</td>
				<td class="bt_info_odd">优级品点数</td>
				<td class="bt_info_odd">优级品率（%）</td>
				<td class="bt_info_odd">合格品点数</td>
				<td class="bt_info_odd">合格品率（%）</td>
				<td class="bt_info_odd">废品点数</td>
				<td class="bt_info_odd">废品率（%）</td>
				<td class="bt_info_odd">小折射点数</td>
				<td class="bt_info_odd">微测井(口)</td>	
				<td  class="bt_info_odd">开工时间</td>
				<td  class="bt_info_odd">单井采集完成时间</td>
				<td  class="bt_info_odd">运行状态</td>
				<td  class="bt_info_odd">处理、解释状态</td>
				<td  class="bt_info_odd">甲方验收日期</td>
				<td  class="bt_info_odd">备注</td>
			</tr>
		</table>
	</div> 
	<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			   <ul id="tags" class="tags">
			
			   <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批流程</a></li>
		 
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">		 
				<div id="tab_box_content0" class="tab_box_content"  >
				 <wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>  
				</div>
			  
		  </div>
 </div>
<script type="text/javascript">
function frameSize(){
	 //$("#tab_box").css("height",$(window).height()-$("#table_box").height()-60);
	setTabBoxHeight();
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);

	function jsSelectOption(objName, objItemValue) {
		var objSelect = document.getElementById(objName);
		for (var i = 0; i < objSelect.options.length; i++) { 
			if (objSelect.options[i].value == objItemValue) {
				objSelect.options[i].selected = "selected";
				break;
			}
		}
	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
 
</script>
</body>
</html>