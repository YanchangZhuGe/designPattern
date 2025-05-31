<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.*" contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib uri="code" prefix="code"%> 
<%
    String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String extPath = contextPath + "/js/extjs";
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = request.getParameter("projectName");

	String orgName = request.getParameter("orgName");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		
		projectInfoNo = user.getProjectInfoNo();
		projectName = user.getProjectName();
		orgName = user.getOrgName();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup-new.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<style type="text/css">
 .myButton {
	BORDER: #deddde 1px solid;
	font-size: 12px;
	background:#2C83C1;
	CURSOR:  hand;
	COLOR: #FFFFFF;
	padding-top: 2px;
	padding-left: 2px;
	padding-right: 2px;
	height:22px;
}
</style>
</head>

<script type="text/javascript">

	function g(o){
		return document.getElementById(o);
	}

	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	var exploration_method="";
	
	var flag = "";
	var edit_flag = "no";
	
	function validate(){
                debugger;
		var produce_date = document.getElementById("produce_date").value;
		var project_info_no = document.getElementById("project_info_no").value;
		var retObj = jcdpCallService("WtDailyReportSrv", "getDailyReportDate", "projectInfoNo=<%=projectInfoNo %>&produceDate="+produce_date);
		debugger;
		
	
		
		if(retObj == null || retObj.build == null || retObj.build.dailyNoWt== null){

			//日报未录入
			cleanTheBlank();
			g('edit_button').style.display="none";
			g('zj_button').style.display="inline";
			g('message').innerHTML="日报没有录入！";
			g('flag').value = "notSaved";
		
			
				document.getElementById("daily_no_wt").value="";
				  document.getElementById("td1").style.display="none";
           	   document.getElementById("td2").style.display="none";
           	document.getElementById("pause_button").style.display="none";
   
          	document.getElementById("pause_button").disabled=false;
        
          
		} else if(retObj.build.auditStatus=="0"){
			
			var dailyNoWt=retObj.build.dailyNoWt;
			var if_build=retObj.build.ifBuild;
			var audit_status=retObj.build.auditStatus;
            if(if_build=="11"){
            	var stop_reason=retObj.build.stopReason;
            	document.getElementById("stop_reason").value=stop_reason;
            	 document.getElementById("td1").style.display="inline";
            	  document.getElementById("td2").style.display="none";
            		document.getElementById("pause_button").style.display="none";
        			document.getElementById("next_button").style.display="inline";
            }else if(if_build=="12"){
            	debugger;
            	var pause_reason=retObj.build.pauseReason;
            	  document.getElementById("td1").style.display="none";
           	    document.getElementById("td2").style.display="inline";
           		document.getElementById("pause_button").style.display="inline";
           		document.getElementById("pause_button").disabled=true;
    			document.getElementById("next_button").style.display="none";
            }else{
            	   document.getElementById("td1").style.display="none";
            	   document.getElementById("td2").style.display="none";
            		document.getElementById("pause_button").style.display="none";
        			document.getElementById("next_button").style.display="inline";
            }
			document.getElementById("audit_status").value=audit_status;
		document.getElementById("daily_no_wt").value=dailyNoWt;
		document.getElementById("if_build").value=if_build;
	
			//debugger;

			fillTheBlank(retObj.build);
			disableTheBlank();
			g('message').innerHTML="日报未提交！";
			g('edit_button').style.display="inline";
			g('zj_button').style.display="inline";
			g('flag').value = "notSubmited";
		
		} else if(retObj.build.auditStatus=="1"){//已提交，待审核
			var dailyNoWt=retObj.build.dailyNoWt;
			var if_build=retObj.build.ifBuild;
			var audit_status=retObj.build.auditStatus;

			document.getElementById("audit_status").value=audit_status;
		document.getElementById("daily_no_wt").value=dailyNoWt;
		document.getElementById("if_build").value=if_build;
	    if(if_build=="11"){
        	var stop_reason=retObj.build.stopReason;
        	document.getElementById("stop_reason").value=stop_reason;
        	 document.getElementById("td1").style.display="inline";
        	  document.getElementById("td2").style.display="none";
        		document.getElementById("pause_button").style.display="none";
    			document.getElementById("next_button").style.display="inline";
        }else if(if_build=="12"){
        	var pause_reason=retObj.build.pauseReason;
        	  document.getElementById("td1").style.display="none";
       	    document.getElementById("td2").style.display="inline";
       		document.getElementById("pause_button").style.display="inline";
			document.getElementById("next_button").style.display="none";
        }else{
        	   document.getElementById("td1").style.display="none";
        	   document.getElementById("td2").style.display="none";
        		document.getElementById("pause_button").style.display="none";
    			document.getElementById("next_button").style.display="inline";
        }
		 

			debugger;
			//日报已经提交
			fillTheBlank(retObj.build);
			disableTheBlank();
			//forEdit();
			g('message').innerHTML="日报已经提交!";		
			g('edit_button').style.display="none";
			g('zj_button').style.display="inline";
		 
			g('flag').value = "Submited";
		} else if(retObj.build.auditStatus=="2"){
			var dailyNoWt=retObj.build.dailyNoWt;
			var if_build=retObj.build.ifBuild;
			var audit_status=retObj.build.auditStatus;

			document.getElementById("audit_status").value=audit_status;
		document.getElementById("daily_no_wt").value=dailyNoWt;
		document.getElementById("if_build").value=if_build;
	    if(if_build=="11"){
        	var stop_reason=retObj.build.stopReason;
        	document.getElementById("stop_reason").value=stop_reason;
        	 document.getElementById("td1").style.display="inline";
        	  document.getElementById("td2").style.display="none";
        		document.getElementById("pause_button").style.display="none";
    			document.getElementById("next_button").style.display="inline";
        }else if(if_build=="12"){
        	var pause_reason=retObj.build.pauseReason;
        	  document.getElementById("td1").style.display="none";
       	    document.getElementById("td2").style.display="inline";
       		document.getElementById("pause_button").style.display="inline";
			document.getElementById("next_button").style.display="none";
        }else{
        	   document.getElementById("td1").style.display="none";
        	   document.getElementById("td2").style.display="none";
        		document.getElementById("pause_button").style.display="none";
    			document.getElementById("next_button").style.display="inline";
        }
			//debugger;

			fillTheBlank(retObj.build);
			disableTheBlank();
			g('message').innerHTML="日报已经录入但已经提交，审核中，请点确定继续反馈工作量或者返回！";
			g('edit_button').style.display="inline";
			g('zj_button').style.display="inline";
			g('flag').value = "notSubmited";
		} else if(retObj.build.auditStatus=="3"){
			var dailyNoWt=retObj.build.dailyNoWt;
			var if_build=retObj.build.ifBuild;
			var audit_status=retObj.build.auditStatus;
	
			document.getElementById("audit_status").value=audit_status;
		document.getElementById("daily_no_wt").value=dailyNoWt;
		document.getElementById("if_build").value=if_build;
	    if(if_build=="11"){
        	var stop_reason=retObj.build.stopReason;
        	document.getElementById("stop_reason").value=stop_reason;
        	 document.getElementById("td1").style.display="inline";
        	  document.getElementById("td2").style.display="none";
        		document.getElementById("pause_button").style.display="none";
    			document.getElementById("next_button").style.display="inline";
        }else if(if_build=="12"){
        	var pause_reason=retObj.build.pauseReason;
        	  document.getElementById("td1").style.display="none";
       	    document.getElementById("td2").style.display="inline";
       		document.getElementById("pause_button").style.display="inline";
			document.getElementById("next_button").style.display="none";
        }else{
        	   document.getElementById("td1").style.display="none";
        	   document.getElementById("td2").style.display="none";
        		document.getElementById("pause_button").style.display="none";
    			document.getElementById("next_button").style.display="inline";
        }
		 
			//日报审批通过
			fillTheBlank(retObj.build);
			disableTheBlank();
			g('message').innerHTML="日报审批通过，请点确定查看反馈工作量或者返回！";		
			g('edit_button').style.display="none";
			g('zj_button').style.display="none";
			g('flag').value = "Passed";
		} else if(retObj.build.auditStatus=="4"){
			var dailyNoWt=retObj.build.dailyNoWt;
			var if_build=retObj.build.ifBuild;
			var audit_status=retObj.build.auditStatus;

			document.getElementById("audit_status").value=audit_status;
		document.getElementById("daily_no_wt").value=dailyNoWt;
		document.getElementById("if_build").value=if_build;
	    if(if_build=="11"){
        	var stop_reason=retObj.build.stopReason;
        	document.getElementById("stop_reason").value=stop_reason;
        	 document.getElementById("td1").style.display="inline";
        	  document.getElementById("td2").style.display="none";
        		document.getElementById("pause_button").style.display="none";
    			document.getElementById("next_button").style.display="inline";
        }else if(if_build=="12"){
        	var pause_reason=retObj.build.pauseReason;
        	  document.getElementById("td1").style.display="none";
       	    document.getElementById("td2").style.display="inline";
       		document.getElementById("pause_button").style.display="inline";
			document.getElementById("next_button").style.display="none";
        }else{
        	   document.getElementById("td1").style.display="none";
        	   document.getElementById("td2").style.display="none";
        		document.getElementById("pause_button").style.display="none";
    			document.getElementById("next_button").style.display="inline";
        }
		 
			//日报审批未通过
			fillTheBlank(retObj.build);
			disableTheBlank();
			
			g('message').innerHTML="日报审批未通过，请点确定继续反馈工作量或者返回！";		
			g('edit_button').style.display="inline";
			g('zj_button').style.display="inline";
			g('flag').value = "notPassed";
		} 
		
		//debugger;
		retObj = jcdpCallService("WtDailyReportSrv", "queryDailyQuestion", "projectInfoNo=<%=projectInfoNo %>&produceDate="+produce_date);
	    var lineNum = 0;
	    if(retObj != null && retObj.questionList != null){
	      lineNum = retObj.questionList.length;
	    }
	    
	    var table = document.getElementById("table");
		if(table.rows.length != 1){
			//清掉已增加的列
			for(var i=1; i < table.rows.length;i++){
				table.deleteRow(1);
			}
		}
	    
	    document.getElementById("rowNum").value = lineNum;
	    
	    for(var i = 0; i < lineNum; i++){
	      var tr = document.getElementById("table").insertRow();
	      if ( i % 2 == 0) {
	        tr.className = "even";
	      } else {
	        tr.className = "odd";
	      }
	      
	      var rowNum = i;
	      var lineId = "row_" + rowNum + "_";
	      tr.id=lineId;
	      
	      var obj = retObj.questionList[i];
	      
	      //序号
	      tr.insertCell().innerHTML = (i+1);
	      
	      //问题分类bugCode
	      tr.insertCell().innerHTML = '<input type="hidden" name="question_id_'+rowNum+'" id="question_id_'+rowNum+'" value="'+obj.question_id+'"/><select name="bug_code_'+rowNum+'" id="bug_code_'+rowNum+'" class="select_width"> '+
										    		'<option value="">--请选择--</option>'+
										    		'<option value="5000100005000000001">人员</option>'+
										    		'<option value="5000100005000000002">物资</option>'+
										    		'<option value="5000100005000000003">设备</option>'+
										    		'<option value="5000100005000000004">HSE</option>'+
										    		'<option value="5000100005000000005">后勤</option>'+
										    		'<option value="5000100005000000006">工农、社区关系</option>'+
										    		'<option value="5000100005000000007">技术</option>'+
										    		'<option value="5000100005000000008">生产</option>'+
										    		'<option value="5000100005000000009">甲方信息</option>'+
										    		'<option value="5000100005000000010">自然因素</option>'+
										    		'<option value="5000100005000000011">质量</option>'+
										    		'<option value="5000100005000000012">财务经营</option>'+
										    		'<option value="5000100005000000013">其它</option>'+
										    	'</select>';
										    	
		  document.getElementsByName("bug_code_"+rowNum)[0].value = obj.bug_code;
	      
	      //问题描述
	      tr.insertCell().innerHTML = '<textarea name="q_description_'+rowNum+'" id="q_description_'+rowNum+'" class="textarea" >'+obj.q_description+'</textarea>';
	      
	      //解决方案
	      tr.insertCell().innerHTML = '<textarea name="resolvent_'+rowNum+'" id="resovlent_'+rowNum+'" class="textarea" >'+obj.resolvent+'</textarea>';
	      
	      //删除
	      tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
	    }
	    
	}
	function disableTheBlank(){
		document.getElementsByName("if_build")[0].disabled = true;
		document.getElementsByName("weather")[0].disabled = true;
		document.getElementsByName("stop_reason")[0].disabled = true;
		document.getElementsByName("pause_reason")[0].disabled = true;
		//document.getElementsByName("button2")[0].disabled = true;
		//document.getElementsByName("day_check_time")[0].disabled = true;
		//document.getElementsByName("workman_num")[0].disabled = true;
		//document.getElementsByName("out_employee_num")[0].disabled = true;
		//document.getElementsByName("season_employee_num")[0].disabled = true;
	}
	function forEdit(){
		
		document.getElementById("edit_button").disabled=false;
		document.getElementById("edit_flag").value="yes";
		edit_flag="yes";
		document.getElementsByName("if_build")[0].disabled = true;
		document.getElementsByName("weather")[0].disabled = true;
	 	document.getElementsByName("stop_reason")[0].disabled = true;
		 document.getElementsByName("pause_reason")[0].disabled = true;
		 document.getElementsByName("pause_button")[0].disabled = true;
		 
	}
	function forBji(){
		document.getElementById("edit_button").disabled=true;
		document.getElementById("edit_flag").value="yes";
		edit_flag="yes";
		document.getElementsByName("if_build")[0].disabled = false;
		document.getElementsByName("weather")[0].disabled = false;
	 	document.getElementsByName("stop_reason")[0].disabled = false;
		 document.getElementsByName("pause_reason")[0].disabled = false;
		 document.getElementsByName("pause_button")[0].disabled = false;
		 
	}
	function fillTheBlank(build){
		//debugger;
		document.getElementsByName("if_build")[0].value = build.ifBuild;
		document.getElementsByName("weather")[0].value = build.weather;
		document.getElementsByName("stop_reason")[0].value = build.stopReason;
		document.getElementsByName("pause_reason")[0].value = build.pauseReason;
	//	document.getElementsByName("work_time")[0].value = build.workTime==0?"":build.workTime;
	//	document.getElementsByName("collect_time")[0].value = build.collectTime==0?"":build.collectTime;
		//document.getElementsByName("day_check_time")[0].value =  build.dayCheckTime==0?"":build.dayCheckTime;
		//document.getElementsByName("workman_num")[0].value = dailyMap.WORKMAN_NUM==0?"":dailyMap.WORKMAN_NUM;
		//document.getElementsByName("out_employee_num")[0].value = dailyMap.OUT_EMPLOYEE_NUM==0?"":dailyMap.OUT_EMPLOYEE_NUM;
		//document.getElementsByName("season_employee_num")[0].value = dailyMap.SEASON_EMPLOYEE_NUM==0?"":dailyMap.SEASON_EMPLOYEE_NUM;
	
	}
	function cleanTheBlank(){
		document.getElementsByName("if_build")[0].value = "";
		document.getElementsByName("weather")[0].value = "";
		document.getElementsByName("stop_reason")[0].value = "";
		document.getElementsByName("pause_reason")[0].value = "";
		//document.getElementsByName("collect_time")[0].value = "";
		//document.getElementsByName("day_check_time")[0].value = "";
		//document.getElementsByName("workman_num")[0].value = "";
		//document.getElementsByName("out_employee_num")[0].value = "";
		//document.getElementsByName("season_employee_num")[0].value = "";
		
		document.getElementsByName("if_build")[0].disabled = false;
		document.getElementsByName("weather")[0].disabled = false;
		document.getElementsByName("stop_reason")[0].disabled = false;
		document.getElementsByName("pause_reason")[0].disabled = false;
		//document.getElementsByName("collect_time")[0].disabled = false;
		//document.getElementsByName("day_check_time")[0].disabled = false;
		//document.getElementsByName("workman_num")[0].disabled = false;
		//document.getElementsByName("out_employee_num")[0].disabled = false;
		//document.getElementsByName("season_employee_num")[0].disabled = false;
	}
	
	function goNext(){
	
		debugger;
		
		
		
		var produce_date = document.getElementById("produce_date");
		if(produce_date == null || produce_date.value == ""){
			alert("生产日期不能为空!");
			return false;
		}
		
		var if_build = document.getElementById("if_build");
		if(if_build == null || if_build.value == ""){
			alert("项目状态不能为空!");
			return false;
		}else if(document.getElementById("if_build").value=="11"){
		   if(document.getElementById("stop_reason").value==""){
		      alert("停工原因不能为空");
		      return false;
		   }
		}else if(document.getElementById("if_build").value=="12"){
			if(document.getElementById("pause_reason").value==""){
			  alert("暂停原因不能为空");
			  return false;
			}
		}
		
		var weather = document.getElementById("weather");
		if(weather == null || weather.value == ""){
			alert("天气不能为空!");
			return false;
		}
	 
		debugger;
		
		var retObj = jcdpCallService("WtDailyReportSrv", "getMessage", "projectInfoNo=<%=projectInfoNo %>");
		debugger;
	  if(retObj.daily_map!=null){
		  document.form1.submit();
	}else{
		  alert("分配工作量之前请勿操作");
	  }
		
	}
	
	function toAdd(){
		var rowNum = Number(document.getElementById("rowNum").value);
		var lineId = "row_" + rowNum + "_";
		
		var tr = document.getElementById("table").insertRow();
		tr.id=lineId;	
		if ( rowNum % 2 == 0) {
			tr.className = "even";
		} else {
			tr.className = "odd";
		}
		
		//序号
	      tr.insertCell().innerHTML = (rowNum+1);
	      
	      //问题分类bugCode
	      tr.insertCell().innerHTML = '<input type="hidden" name="question_id_'+rowNum+'" id="question_id_'+rowNum+'"/><select name="bug_code_'+rowNum+'" id="bug_code_'+rowNum+'" class="select_width"> '+
										    		'<option value="">--请选择--</option>'+
										    		'<option value="5000100005000000001">人员</option>'+
										    		'<option value="5000100005000000002">物资</option>'+
										    		'<option value="5000100005000000003">设备</option>'+
										    		'<option value="5000100005000000004">HSE</option>'+
										    		'<option value="5000100005000000005">后勤</option>'+
										    		'<option value="5000100005000000006">工农、社区关系</option>'+
										    		'<option value="5000100005000000007">技术</option>'+
										    		'<option value="5000100005000000008">生产</option>'+
										    		'<option value="5000100005000000009">甲方信息</option>'+
										    		'<option value="5000100005000000010">自然因素</option>'+
										    		'<option value="5000100005000000011">质量</option>'+
										    		'<option value="5000100005000000012">财务经营</option>'+
										    		'<option value="5000100005000000013">其它</option>'+
										    	'</select>';
	      
	      //问题描述
	      tr.insertCell().innerHTML = '<textarea name="q_description_'+rowNum+'" class="textarea"></textarea>';
	      
	      //解决方案
	      tr.insertCell().innerHTML = '<textarea name="resolvent_'+rowNum+'" class="textarea"></textarea>';
	      
	      //删除
	      tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
	      
	     document.getElementById("rowNum").value = rowNum+1;
	}
	
	function toDelete(lineId){
		var rowNum = lineId.split('_')[1];
		var line = document.getElementById(lineId);	
		
		var lineNum = Number(document.getElementById("rowNum").value);
		
		var question_id = document.getElementById('question_id_'+rowNum);
		
		if(question_id != null){
			//删除数据库中现有记录
			document.getElementById('deleteId').value = document.getElementById('deleteId').value + "," +question_id.value;
		}
		
		line.parentNode.removeChild(line);
		
		lineNum--;
		document.getElementById("rowNum").value = lineNum;
	}
	function change(){
		debugger;
		if(document.getElementsByName("if_build")[0].value == "11"){
			g('td1').style.display="inline";
			g('td2').style.display="none";
			document.getElementById("pause_button").style.display="none";
			document.getElementById("next_button").style.display="inline";
		} else if(document.getElementsByName("if_build")[0].value == "12"){
			g('td1').style.display="none";
			g('td2').style.display="inline";
			document.getElementById("pause_button").style.display="inline";
			document.getElementById("next_button").style.display="none";
		} else{
			g('td1').style.display="none";
			g('td2').style.display="none";
			document.getElementById("pause_button").style.display="none";
			document.getElementById("next_button").style.display="inline";
		}
	}
	debugger;
	function nextTi(){
		
		var produce_date = document.getElementById("produce_date");
		if(produce_date == null || produce_date.value == ""){
			alert("生产日期不能为空!");
			return false;
		}
		
		var if_build = document.getElementById("if_build");
		if(if_build == null || if_build.value == ""){
			alert("项目状态不能为空!");
			return false;
		}else if(document.getElementById("if_build").value=="11"){
		   if(document.getElementById("stop_reason").value==""){
		      alert("停工原因不能为空");
		      return false;
		   }
		}else if(document.getElementById("if_build").value=="12"){
			if(document.getElementById("pause_reason").value==""){
			  alert("暂停原因不能为空");
			  return false;
			}
		}
		
		var weather = document.getElementById("weather");
		if(weather == null || weather.value == ""){
			alert("天气不能为空!");
			return false;
		}
	 
		debugger;
		
		var retObj = jcdpCallService("WtDailyReportSrv", "getMessage", "projectInfoNo=<%=projectInfoNo %>");
		debugger;
	  if(retObj.daily_map!=null){
		  document.form1.action="<%=contextPath%>/pm/dailyReport/singleProject/wt/saveOrUpdateWtIndex.srq";
			document.form1.submit();
	}else{
		  alert("分配工作量之前请勿操作");
	  }
		
	}
	function exportDataAS(){
		debugger;
		$tip = $("<div id='exportArea' style='position:absolute; left:" + (event.clientX-90) + "px; top:" + (event.clientY+10) + "px; width:75px; height:60px; padding: 5px; border:1px solid; text-align: center; background: white; '></div>");
		$tip.bind('mouseover', exportAreaMouseover);
		$tip.bind('mouseout', exportAreaMouseout);
		
		$curpage = $("<div style='position:relative; border: 1px solid; padding-top: 3px; margin-bottom: 5px; height: 22px; cursor: pointer;' onclick='importDailyInfoFromDm()'>导入数据</div>");
		$tip.append($curpage);
		
		$allpage = $("<div style='position:relative; border: 1px solid; padding-top: 3px; margin-bottom: 5px; height: 22px; cursor: pointer; ' onclick='toAddDailyUploadFile()'>导入施工图</div>");
		$tip.append($allpage);

		$(document.body).append($tip);
		
		hideExportAreaTimer = setTimeout(hideExportArea,1000);
	}
	
	function importDailyInfoFromDm(){
		popWindow(cruConfig.contextPath+"/pm/comm/ExcelImport.jsp?path=/pm/dailyReport/importDaily.srq");
	}
	function toAddDailyUploadFile(){
	      	popWindow('<%=contextPath%>/pm/dailyReport/singleProject/wt/add_file.jsp');
	}
</script>

<body style="background:#fff">

<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">  
	<tr class="tongyong_box_title">
		<td colspan="6" align="left"><span>&nbsp;&nbsp;<font size="2">日报基本信息</font></span><td>
	</tr>
  	<tr class="even">
	    <td class="inquire_item6">施工队伍：</td>
	    <td class="inquire_form6" id="td_team_name"></td>
    	<td class="inquire_item6">项目信息：</td>
		<td class="inquire_form6"><%=projectName %></td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6" >
			<input id="edit_button" type="button" name="button2" value="编辑" onClick="forBji()" class="myButton" style="display: none;"/>&nbsp;&nbsp;&nbsp;
			<input type="button" id="next_button" name="button2" value="下一步"  class="myButton"  onclick="goNext()"/>
			<input type="button" name="pause_button" id="pause_button"  style="display: none"  value="保存" class="myButton" onclick="nextTi()"/>
		</td>
					<auth:ListButton functionId="" css="dr" event="onclick='exportDataAS()'"   title="JCDP_btn_import"></auth:ListButton>		
		
	</tr> 
</table>
<form name="form1" action="<%=contextPath%>/pm/dailyReport/singleProject/wt/saveOrUpdateWtDailyReport.srq" method="post">

<input id="project_info_no" name="project_info_no" value="<%=projectInfoNo %>" type="hidden" />
<input id="daily_no_wt" name="daily_no_wt" value="" type="hidden"/>
<input id="audit_status" name="audit_status" value="" type="hidden"/>
<input id="edit_flag" name="edit_flag" value="no" type="hidden"/>
<input id="flag" name="flag" value="" type="hidden"/>


<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
<tr class="odd">
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;生产日期:</td>
		<td class="inquire_form6"><input type="text" name='produce_date' id='produce_date' value=''  onchange="validate()" readonly>&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1"  name="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector('produce_date',tributton1);" /></td>
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;项目状态:</td>
		<td class="inquire_form6">
			<select name="if_build" id="if_build" class="select_width" onchange="change()" >
				<option value="">请选择</option>
				<option value="1">动迁</option>
				<option value="2">踏勘</option>
				<option value="3">建网</option>
				<option value="4">培训</option>
				<option value="5">试验</option>	 
				<option value="6">采集</option>
				<option value="7">整理</option>
				<option value="8">验收</option>
				<option value="9">遣散</option>	 
				<option value="10">归档</option>
				<option value="11">停工</option>
				<option value="12">暂停</option>
				<option value="13">结束</option>
				
			</select>
		</td>
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;天气情况：</td>
		<td class="inquire_form6">
			<select name="weather" id="weather" class="select_width">
				<option value="">请选择</option>
				<option value="1">晴</option>
				<option value="2">阴</option>
				<option value="3">多云</option>
				<option value="4">雨</option>
				<option value="5">雾</option>
				<option value="17">大风</option>
				<option value="6">霾</option>
				<option value="7">霜冻</option>
				<option value="8">暴风</option>
				<option value="9">台风</option>
				<option value="10">暴风雪</option>
				<option value="11">雪</option>
				<option value="12">雨夹雪</option>
				<option value="13">冰雹</option>
				<option value="14">浮尘</option>
				<option value="15">扬沙</option>
				<option value="16">其它</option>
			</select>
		</td>
	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
	<tr class="even" id="td1" style="display: none;">
		<td class="inquire_item6"><span class="red_star">*</span>停工原因:</td>
		<td class="inquire_form6">
			<select name="stop_reason" id="stop_reason" class="select_width">
  
				<option value="">请选择</option>
				<option value="1">仪器因素</option>
				<option value="2">人员因素</option>
				<option value="3">气候因素</option>
				<option value="4">工农协调因素</option>
			 	<option value="5">油公司因素</option>
			 		<option value="6">其它</option>
 
		 
 
			</select>
		</td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6">&nbsp;</td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6">&nbsp;</td>
	</tr>
	
	<tr class="even" id="td2" style="display: none;">
		<td class="inquire_item6"><span class="red_star">*</span>暂停原因:</td>
		<td class="inquire_form6">
			<select name="pause_reason" id="pause_reason" class="select_width">
				<option value="">请选择</option>
 
				<option value="1">仪器因素</option>
				<option value="2">人员因素</option>
				<option value="3">气候因素</option>
				<option value="4">工农协调因素</option>
			 	<option value="5">油公司因素</option>
			 	<option value="6">其它</option>
 
 
 
			</select>
		</td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6">&nbsp;</td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6">&nbsp;</td>
	</tr>
	<!-- 
	<tr class="even" id="td2">
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;施工时长(小时):</td>
		<td class="inquire_form6" ><input name="work_time" type="text" class="input_width" /></td>
		<td class="inquire_item6">采集时间(小时):</td>
		<td class="inquire_form6"><input name="collect_time" type="text" class="input_width"/></td>
		<td class="inquire_item6">日检时间(小时):</td>
		<td class="inquire_form6"><input name="day_check_time" type="text" class="input_width"/></td>
	</tr>
	 -->
	<!-- 
	<tr>
		<td class="inquire_item6">合同化用工:</td>
		<td class="inquire_form6"><input name="workman_num" type="text" value="" class="input_width"/></td>
		<td class="inquire_item6">市场化用工:</td>
		<td class="inquire_form6"><input name="out_employee_num" type="text" value="" class="input_width"/></td>
		<td class="inquire_item6">季节性用工:</td>
		<td class="inquire_form6"><input name="season_employee_num" type="text" value="" class="input_width"/></td>
	</tr>
	 -->
	<tr>
		<td colspan="6" class="inquire_item6">
			<span id="message" style="color:red">&nbsp;</span>			
		</td>
	</tr>
</table>  	

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	<tr class="tongyong_box_title">
		<td colspan="3" align="left"><span>&nbsp;&nbsp;<font size="2">日问题信息</font></span></td>
		<span id="zj_button" ><auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton></span>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="table" style="overflow: scroll;">
	<tr class="bt_info">
		<td class="bt_info_odd" width="5%">序号<input type="hidden" value="0" id="rowNum" name="rowNum"/><input type="hidden" value="" id="deleteId" name="deleteId"/></td>
		<td class="bt_info_even" width="20%">问题分类</td>
		<td class="bt_info_odd" width="35%">问题描述</td>
		<td class="bt_info_even" width="35%">解决方案</td>
		<td class="bt_info_odd" width="5%">删除</td>
	</tr>
</table>
<script type="text/javascript">

//获取施工队伍名称

getProjectTeam();

function getProjectTeam(){
	var retObj = jcdpCallService("WtDailyReportSrv", "getProjectTeamName", "projectInfoNo=<%=projectInfoNo %>");
	if(retObj != null && retObj.teamName != null){
		$("#td_team_name").html(retObj.teamName);
	}
}
</script>
</form>
</body>
</html>