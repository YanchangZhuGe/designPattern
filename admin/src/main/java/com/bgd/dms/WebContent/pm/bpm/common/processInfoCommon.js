var processNecessaryInfo=new Object();

var processAppendInfo=new Object();

var wfPublicProcinstId = '';
var processStatusInfo={
	procStatus:''
};
function submitProcessInfo(){
	
	if('configProecessInfo' in window){
		configProecessInfo();
	}
	if('submitOrNot' in window){
		if(!submitOrNot()){
			return;
		}
	}
	//查询流程是否已提交
	var submitStr='businessTableName='+processNecessaryInfo.businessTableName+'&businessType='+processNecessaryInfo.businessType+'&businessId='+processNecessaryInfo.businessId;
	var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
	var procStatus=retObject.procStatus;
	processStatusInfo.procStatus=procStatus;
	
	if(processStatusInfo.procStatus=='3'||processStatusInfo.procStatus=='1'){
		alert("该单据已提交流程，无法再次提交");
		return ;
	}
	var submitStr="startProcess=true";
	for(i in processNecessaryInfo){
		submitStr+="&"+i+"="+processNecessaryInfo[i];
		if(processNecessaryInfo[i]==null||processNecessaryInfo[i]==""||processNecessaryInfo[i]==undefined){
			alert(i+"未设置值,请设置后再进行提交");
			return false;
		}
	}
	for(j in processAppendInfo){
		submitStr+="&wfVar_"+j+"="+processAppendInfo[j];
		//alert(submitStr);
	}
	
	submitStr = encodeURI(submitStr);
	submitStr = encodeURI(submitStr);

	retObject = jcdpCallService('WFCommonSrv','startWFProcess',submitStr)
	wfPublicProcinstId = retObject.procinstId;
	loadProcessHistoryInfo();
}
function viewProcDoc(){
	var submitStr='businessTableName='+processNecessaryInfo.businessTableName+'&businessType='+processNecessaryInfo.businessType+'&businessId='+processNecessaryInfo.businessId;
	var retObject=jcdpCallService('WFCommonSrv','getWfProcessDocInfo',submitStr)
	var ucmId=retObject.ucmId;
	if(ucmId==null|ucmId==""||ucmId=="null"){
		alert("当前流程为设置文档");
	}else{
		window.open(cruConfig.contextPath+'/doc/downloadDocByUcmId.srq?docId='+ucmId);
	}
}
function loadProcessHistoryInfo(){
	if(document.getElementById("processInfoTab")!=undefined){
		var submitStr='businessTableName='+processNecessaryInfo.businessTableName+'&businessType='+processNecessaryInfo.businessType+'&businessId='+processNecessaryInfo.businessId;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var datas = retObject.datas;
		deleteTableTr("processInfoTab");
		if(datas != null&&datas.length>0){
			
			for(var i=0;i<datas.length;i++){
				var tr = document.getElementById("processInfoTab").insertRow();		
	             	if(i % 2 == 1){  
	             		tr.className = "even";
				}else{ 
					tr.className = "odd";
				}
				var td = tr.insertCell(0);
				td.innerHTML = datas[i].node_name;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].curstate;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].examine_info;
				
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].examine_user_name;

				var td = tr.insertCell(4);
				td.innerHTML = datas[i].examine_end_date;
			}
		}
		var procStatus=retObject.procStatus;
		processStatusInfo.procStatus=procStatus;
	}
	if('loadBusinessInfoStatus'  in window ){
		loadBusinessInfoStatus();
	}
	
}

function deleteTableTr(tableID){
	var tb = document.getElementById(tableID);
     var rowNum=tb.rows.length;
     for (var i=1;i<rowNum;i++)
     {
         tb.deleteRow(i);
         rowNum=rowNum-1;
         i=i-1;
     }
}
function viewProcessInfo(){
	var submitStr='businessTableName='+processNecessaryInfo.businessTableName+'&businessType='+processNecessaryInfo.businessType+'&businessId='+processNecessaryInfo.businessId;
	var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
	var procInstId=retObject.procInstId;
	if(procInstId==null||procInstId==undefined||procInstId==''){
		alert("未找到流程信息，请确认是否已提交流程");
	}else{
		popWindow(cruConfig.contextPath+"/BPM/viewProcinst.jsp?procinstId="+procInstId);
	}
}

function getCurrentTime(){
	  var now = new Date();
	  var nowTime = now.toLocaleString();
	  var date = nowTime.substring(0,10);//截取日期
	  return date;
}