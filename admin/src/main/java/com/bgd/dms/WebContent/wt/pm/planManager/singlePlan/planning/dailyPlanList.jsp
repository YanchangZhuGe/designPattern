<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>

<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = request.getParameter("projectName");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	
	if(projectName == null || "".equals(projectName)){
		projectName = user.getProjectName();
	}
	
	WorkMethodSrv wm = new WorkMethodSrv();
	String 	buildMethod = wm.getProjectExcitationMode(projectInfoNo);
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css">

.input_width {
	width:80%;
	height: 18px;
	line-height: 18px;
	border: #a4b2c0 1px solid;
}
.tab_line_height {
	width:100%;
	line-height:30px;
	height:30px;
	color:#000;
}
.tab_line_height td {
	line-height:30px;
	height:30px;
	white-space:nowrap;
	word-break:keep-all;
}

</style>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>无标题文档</title>
</head>

<body style="background:#fff;overflow: scroll;" onload="initData()">
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0">
				 		 <tr>
				   			<td>&nbsp;<span style="color: red" id="tishi">已提交</span></td>
				   			 <auth:ListButton functionId="" css="sx" event="onclick='toRefresh()'" title="重新读取计划日效"></auth:ListButton>
				   			 
				   			 <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
				   			 <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				   			 <auth:ListButton functionId="" css="fz" event="onclick='copyselecttr()'" title="以当前选择行为准,将以下行数据修改为当前选择行数据"></auth:ListButton> 
				  		
				  		</tr>  
				</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
<form id="form1" name="form1" action="" method="post">
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height"  id="table">
<thead>
<tr class="bt_info" align="center">
<td colspan="7">
<%=projectName %>&nbsp;&nbsp; <span id="saveflag"></span>
<input type="hidden" value="" id="deleteId" name="deleteId"/>
</td>
</tr>
</thead>
<tbody>
<tr id="tableTrId">
</tr>

</tbody>
</table>
</form>
</body>
<script type="text/javascript">

function initData(){
	
	var  result=jcdpCallService("WtDailyReportSrv", "getAustaus", "projectInfoNo=<%=projectInfoNo%>");
	if(result.auditMap!=null&&result.auditMap!=""){
		document.getElementById("tishi").innerHTML="已提交";
		}else{
			document.getElementById("tishi").innerHTML="未提交";
		}
	
}

function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

//$(document).ready(lashen);

//定义简单Map  
function getMap() {//初始化map_,给map_对象增加方法，使map_像Map    
         var map_ = new Object();    
         map_.put = function(key, value) {  
           
             map_[key+'_'] = value;    
         };    
         map_.get = function(key) {    
             return map_[key+'_'];    
         };    
         map_.remove = function(key) {    
             delete map_[key+'_'];    
         };    
         map_.keyset = function() {    
             var ret = "";    
             for(var p in map_) {    
                 if(typeof p == 'string' && p.substring(p.length-1) == "_") {    
                     ret += ",";    
                     ret += p.substring(0,p.length-1);    
                 }    
             }    
             if(ret == "") {    
                 return ret.split(",");    
             } else {    
                 return ret.substring(1).split(",");    
             }    
         };    
         return map_;    
}    
/**
测量 G6601 (不统计)
G660101 GPS控制点 
G660102  物理点 

 重力 
G660201 工作量 
G660203 物理点  
	
	
磁力 
G660301 工作量
G660303 物理点  
 

 人工场源电法
G660401 工作量
G660402 物理点  
  

天然场源电法
G660501  工作量 
G660502  物理点  
 

化学勘探
G660601 工作量  
G660602  物理点  


工程
G660705  物理点  
G660701  工作量  
**/
//初始化工作量类型对应的要算日效的工作量编码  
var workloadMap = getMap();  

workloadMap.put("G6601","01,02");//测量
workloadMap.put("G6602","01,05");//重力  
workloadMap.put("G6603","01,05");//磁力  
workloadMap.put("G6604","01,04");//人工场源电法
workloadMap.put("G6605","01,05");//天然场源电法
workloadMap.put("G6606","01,04");//化学勘探
workloadMap.put("G6607","01,07");//工程

var nameMap = getMap();
nameMap.put("G6601","测量");//测量
nameMap.put("G6602","重力");//重力  
nameMap.put("G6603","磁力");//磁力  
nameMap.put("G6604","人工场源电法");//人工场源电法
nameMap.put("G6605","天然场源电法");//天然场源电法
nameMap.put("G6606","化学勘探");//化学勘探
nameMap.put("G6607","工程");//工程




//alert(map.get("G6601"));//
//记录 数据 的总行数
var selecttrnum = 0;
// 点击当前行
var selectedtrid = 0;

//点击当前行  复制数据用
function selecttr(obj) {
	//selecttrnum
	var tempselecttrid = obj.id;//所选行的id
	//alert(tempselecttrid);
	var selecttrid = tempselecttrid.split('_');
	selectedtrid = selecttrid[1];
	
	
	var trs = document.getElementsByTagName("tr");
	for(var i = 0;i<trs.length;i++){
	trs[i].style.backgroundColor = "";
	}
	obj.style.backgroundColor = "yellow";
}
//复制数据
function copyselecttr() {

	if(selectedtrid==0){
		alert("请选择需要复制数据的日期行");
		return;
	}
	//alert(selecttrnum);
	//alert(selectedtrid);

	//取tr 中d_开始的input内容
	var trvalue = new Array();
	$("#selecttrid_"+selectedtrid).find("input[name^='d_']").each(function(){
		//alert($(this).val());
		//保存当前选择的行的值
		trvalue.push($(this).val());
 	});

	for(var i=0;(Number(i)+Number(selectedtrid))<=Number(selecttrnum);i++){
		$("#selecttrid_"+(Number(i)+Number(selectedtrid))).find("input[name^='d_']").each(function(index){
				//alert(index);
				$(this).val(trvalue[index]);
			
	 	});		
	}	



	//重新计算总数
	refreshSum();
	
}


</script>

<script type="text/javascript">

	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	var buildMethod = "<%=buildMethod%>";
	
	//取得计划日效      gp_proj_product_plan存在计划日效则显示  ，不存在则查 bgp_p6_workload 取默认的计划日效
	var retObj = jcdpCallService("WsDailyReportPlanSrv","queryWtDailyPlan","projectInfoNo=<%=projectInfoNo %>");

	

	//新增日期用到
	var addRowName = "";//记录新增行每一列的标示 如 mid_11_G6601_01,mid_11_G6601_02
	var oldDay = "";//记录已经存在的日期 新增时需要判断
	
	//msg.setValue("allMission", rsMap.get("allMission"));
	//msg.setValue("allWorkloadType", rsMap.get("allWorkloadType"));
	//msg.setValue("dayWorkload", rsMap.get("dayWorkload"));

	//msg.setValue("allList", rsMap.get("allList"));
	var thMission = "";//头 任务
	var thWorkloadType = "";//头 工作量类型
	var thWorkload = "";//头 工作量
	var tablehtml = "";//记录内容
	var tabletotal = "";//总计项


	var totalMap = getMap();//总计map //为了实现 实时统计总数 
	
	if(retObj != null && retObj.allList != null){

		
		//总记录数 天数
		selecttrnum = retObj.allList.length;
		
		//var totalMap = getMap();//总计map //移到全局变量
		
		for(var i = 0; i < retObj.allList.length; i++){
			//一天
			var oneday = retObj.allList[i].record_month;
			oldDay+=oneday+",";//记录日期 新增用
			

			var sc;
			if ( (i+1) % 2 != 0) {
				sc = "class='odd'";
			} else {
				sc = "class='even'";
			}
			
			tablehtml += "<tr "+sc+" id='selecttrid_"+(i+1)+"' onclick='selecttr(this)'  align='center'><td>"+(i+1)+"</td>";//@@@@@@@@@@@@@@@内容table 序号
			tablehtml += "<td>"+oneday+"</td>";//@@@@@@@@@@@@@@@内容table 日期
			
			

			if(i==0){
				thMission += "<td rowspan='3'>序号</td>";//@@@@@@@@@@@@@@@头table 序号
				thMission += "<td align='center' rowspan='3'>日期</td>";//@@@@@@@@@@@@@@@头table 日期
			}
			
			//循环这一行任务
			for(var a=0;a<retObj.allMission.length;a++){
				var onemissionid = retObj.allMission[a].id;
				//通过任务id 取工作量类型 可能包含多个
				var oneMissionWorkloadTypes = retObj.allWorkloadType["mid_"+onemissionid];
				//分解工作量类型
				oneMissionWorkloadTypes = oneMissionWorkloadTypes.split(',');
				
				if(i==0){
			
					thMission += "<td colspan='"+oneMissionWorkloadTypes.length*2+"'>"+retObj.allMission[a].name+"</td>";//@@@@@@@@@@@@@@@头table 任务
					
					}
				

				//循环工作量类型
				for(var b=0;b<oneMissionWorkloadTypes.length;b++){
					//取一个工作量类型
					var oneWorkloadType = oneMissionWorkloadTypes[b];

					if(i==0){
						thWorkloadType += "<td colspan='2'>"+nameMap.get(oneWorkloadType)+"</td>";//@@@@@@@@@@@@@@@头table 类型 
					}
					
					//取类型对应的工作量
					var workloads = workloadMap.get(oneWorkloadType);
					workloads = workloads.split(',');
				
					
					for(var c=0;c<workloads.length;c++){
						//根据 日期  任务id 工作量类型  取工作量值
						//dayWorkload.put("d_2013-01-01_mid_11_G6601_02", "3");
						var workloadvalueName = "d_"+oneday+"_mid_"+onemissionid+"_"+oneWorkloadType+"_"+workloads[c];
					 
						var workloadvalue = retObj.dayWorkload[workloadvalueName];
					 
						
						if(workloadvalue==null){
							workloadvalue='';
						}

						//总计数量
						var tempa = totalMap.get("_mid_"+onemissionid+"_"+oneWorkloadType+"_"+workloads[c]);
						if (typeof(tempa) == "undefined")
						{	
							var t = 0;
							if(workloadvalue!=null&&workloadvalue!=''&&workloadvalue!=""){
								t = workloadvalue;
							}
							totalMap.put("_mid_"+onemissionid+"_"+oneWorkloadType+"_"+workloads[c],t);
						}else{
							var t = 0;
							if(workloadvalue!=null&&workloadvalue!=''&&workloadvalue!=""){
								t = workloadvalue;
							}

							//////添加判断 为工作量时 为小数  否则为整数////
							var workloadcode = oneWorkloadType+workloads[c];
							var workloadcodevalue ;
							if(workloadcode=="G660201"||workloadcode=="G660301"||workloadcode=="G660401"||workloadcode=="G660501"||workloadcode=="G660601"||workloadcode=="G660701"){
								//工作量 为小数
								workloadcodevalue = (Number(tempa)+Number(t)).toFixed(2);
							}else{
								//不是工作量 为整数
								workloadcodevalue = parseInt(tempa)+parseInt(t);
							}
							///////////////////////////////////////////////
							
							
							
							totalMap.put("_mid_"+onemissionid+"_"+oneWorkloadType+"_"+workloads[c],workloadcodevalue);
						}
						//////////////
						
						//tablehtml += "<td ><input class='input_width' type='text' name='"+workloadvalueName+"' value='"+workloadvalue+"'/></td>";//@@@@@@@@@@@@@@@
						//添加onkeyup 用来重新计算总数
						//tablehtml += "<td ><input   maxlength='10' onkeyup='refreshSum();' onkeypress='return on_key_press_int(this)' class='input_width type='text' name='"+workloadvalueName+"' value='"+workloadvalue+"'/></td>";//@@@@@@@@@@@@@@@
						tablehtml += "<td ><input   maxlength='10' onkeyup='on_key_press_int(this);refreshSum();'  class='input_width type='text' name='"+workloadvalueName+"' value='"+workloadvalue+"'/></td>";//@@@@@@@@@@@@@@@

												
						if(i==0){
							//工作量单位
							var unitrs ='';
						//alert(onemissionid);
							if(typeof retObj.workloadUnit != "undefined"){
								//alert(retObj.workloadUnit[_131089]);
								var unit = retObj.workloadUnit["_"+onemissionid];
								
								if(unit!=null){
									if(unit==1){
										unitrs=" m";
									}else if(unit==2){
										unitrs=" km";
									}else if(unit==3){
										unitrs=" m&sup2";
									}else if(unit==4){
										unitrs=" km&sup2";
									}
								}
								
							}

							thWorkload += "<td>"+ (workloads[c]=="01"?"工作量"+unitrs:"物理点(个)")+"</td>";//@@@@@@@@@@@@@@@头table 物理点 or 工作量
							addRowName+="_mid_"+onemissionid+"_"+oneWorkloadType+"_"+workloads[c]+",";
						}
						
						
					}
				}

				//循环这一任务结束
				


				
			}
			
			//备注
			if(retObj.dremarkMap != null){
				
				tablehtml+= "<td><input onkeyup='onkey()' name='b_"+oneday+"' type='text' value='"+retObj.dremarkMap['b_'+oneday]+"' />";
			}else{
				tablehtml+= "<td><input onkeyup='onkey()' name='b_"+oneday+"' type='text'/>";
			}
			
			tablehtml+="<td><img  onclick=\"toDelete(this)\"  src=\""+cruConfig.contextPath+"/images/delete.png\"  width=\"16\" height=\"16\" style=\"cursor:hand;\"  />";//删除
			tablehtml += "</tr>";//@@@@@@@@@@@@@@@
			
		}

		//总计数量
		tabletotal += "<tr class='odd'><td ></td><td align='center'>总计:</td>";
		var addRowNames = addRowName.split(",");//
		for(var a=0;a<addRowNames.length-1;a++){
			
			var wnt = totalMap.get(addRowNames[a]);
			
			tabletotal+="<td id='"+addRowNames[a]+"_td' align='left'>"+wnt+"</td>";
		}
		
		tabletotal+="<td></td><td></td></tr>";
		//////////////


		
		
	}
	
	

	thMission += "<td rowspan='3'>备注</td><td rowspan='3'>删除</td>";//@@@@@@@@@@@@@@@头table 日期;//@@@@@@@@@@@@@@@头table  备注 删除
	
	var finalTableHeader = "<table id='workloadTableId' width='100%' border='1' cellspacing='1' cellpadding='0' class='tab_line_height'  ><tr align='center'>"+thMission+"</tr><tr align='center'>"+thWorkloadType+"</tr><tr align='center'>"+thWorkload+"</tr>"+tablehtml+tabletotal+"</table>";
	var tr = document.getElementById("table").insertRow();
	tr.insertCell().innerHTML =finalTableHeader;
	//var tr = document.getElementById("tableTrId");
	//tr.insertCell().innerHTML =finalTableHeader;

	
	
	//if(retObj.hasSaved == "0"){
		//$("#saveflag").html("<font color='red'>计划日效未保存</font>");
	//}

	var editFlag = false;



	<%----------------------------------------------------------------------------------------------------%>
	function onkey(){
		debugger;
		$("#tishi").html("未提交");
	}
	//只能输入数字
	function on_key_press_int(obj)
	{
		debugger;
		$("#tishi").html("未提交");
		if(obj.value!=""){

			if (obj.value=="."){
				obj.value="";
			}
		
					if(obj.name.charAt(obj.name.length-1)=="1"){
						   //工作量 为小数
						
						if(obj.value.match(/^\d{1,8}$/) || /\.\d{0,2}$/.test(obj.value)){
							
						}else{
							alert("请输入整数或两位小数");
							obj.value=obj.defaultValue;
						
						}
						 
					}else{
						//非工作量 为整数
						
						if(obj.value.match(/^\d+$/) ){
							
						}else{
							alert("请输入整数");
							obj.value=obj.defaultValue;
						
						}
					}
					
		}
	}

	//更新总计数量
	function refreshSum(){
		
		debugger;
		//总计数量
		var mkeyset = totalMap.keyset();


		//循环工作量类型
		for(var b=0;b<mkeyset.length;b++){
			var inputName = mkeyset[b];
			//取页面上所有name 包含inputName 的值 求总和
			var namekey = "input[name$='"+inputName+"']";
			
			var totalsum = 0;
			 $(namekey).each(function(){  
				 totalsum+=Number($(this).val());
			 });

			 
			if(inputName.charAt(inputName.length-1)=="1"){
				   //工作量 为小数
				
				 
				 totalsum = totalsum.toFixed(2);
			}else{
				//非工作量 为整数
				
				totalsum = totalsum.toFixed(0);
			}
			
			
			
			 var totaltdid = "#"+inputName+"_td";  
			 $(totaltdid).html(totalsum);
		}

		
		
	}
	
	
	function toAdd(){
		if(editFlag){
			alert('请先提交当前修改!');
			return;
		}
		editFlag = true;
		popWindow('<%=contextPath%>/pm/dailyPlan/selectDate.jsp?projectInfoNo=<%=projectInfoNo %>');
	}

	//删除一行
	function toDelete(obj){
		$("#tishi").html("未提交");
		//obj.parentNode.parentNode.deleteRow(obj.parentNode.rowIndex);
		obj.parentNode.parentNode.parentNode.deleteRow(obj.parentNode.parentNode.rowIndex);

		//重新计算总数
		refreshSum();
	}

	//重新加载
	function toRefresh(){

		
		//if(document.getElementById("rowNum").value == 0){
			//alert("尚未分配工作量!");
			//return;
		//}
		
		//先把之前的数据从页面删除
		//$("#table > tbody tr").remove();
		
		
		//先删除之前的计划日效，然后重新读取
		//var retObj = jcdpCallService("WsDailyReportPlanSrv","refreshDailyPlanWt","projectInfoNo=<%=projectInfoNo%>");


		var form = document.form1;
		form.action="<%=contextPath%>/wt/pm/dailyPlan/refreshDailyPlanWt.srq?projectInfoNo=<%=projectInfoNo%>";
		form.submit();
		
		
		var editFlag = false;

		
		if(retObj.hasSaved == "0"){
			$("#saveflag").html("<font color='red'>计划日效未保存</font>");
		}
	}
	
	function toSubmit(){
		var form = document.form1;
		form.action="<%=contextPath%>/wt/pm/dailyPlan/saveOrUpdateWtDailyPlan.srq";
		form.submit();
	}


	//添加日期调用
	function getMessage(dates){
		$("#tishi").html("未提交");
		if(addRowName.length==0){
			alert("尚未给任务分配工作量,无法计算日效,请分配工作量!");
			return;
		}
		
		var start_date = dates[0];
		var end_date = dates[1];
		var sArr = start_date.split("-");
		sArr[1] = parseFloat(sArr[1])-1;
		var sDate = new Date(sArr[0],sArr[1],sArr[2]);
		
		var eArr = end_date.split("-");
		eArr[1] = parseFloat(eArr[1])-1;
		var eDate = new Date(eArr[0],eArr[1],eArr[2]);


		var addLineNum = (eDate-sDate)/(1000*3600*24)+1;//需要添加的行数 默认为两日期之差

		addRowName = addRowName.substring(0,addRowName.length-1);//一行需要新增的项
		var addRowNames = addRowName.split(",");//
		
		for(var i=0; i<addLineNum; i++){
			var add = sDate.getTime()+(1000*3600*24*i);
			var temp = convertDate(new Date(add));
			
			
			//判断该行是否新增
		    if(oldDay.indexOf(temp)<0){
			   // 不存在 添加
				var tr = document.getElementById("workloadTableId").insertRow(3);


				if ( (i+1) % 2 != 0) {
					tr.className = "odd";
				} else {
					tr.className = "even";
				}
				

				tr.insertCell().innerHTML =  "新增行";
				tr.insertCell().innerHTML =  temp;

				
				for(var a=0;a<addRowNames.length;a++){
					var wnt = "d_"+temp+addRowNames[a];
					//tr.insertCell().innerHTML =  "<input class='input_width' type='text' name='"+wnt+"' value=''/>";
					tr.insertCell().innerHTML =  "<input maxlength='10' onkeyup='on_key_press_int(this);refreshSum();'  class='input_width type='text' name='"+wnt+"' value=''/>";
					
				}
				tr.insertCell().innerHTML = "<input  name='b_"+temp+"' type='text'/>";//备注
				tr.insertCell().innerHTML ="<img onclick=\"toDelete(this)\" src=\""+cruConfig.contextPath+"/images/delete.png\"  width=\"16\" height=\"16\" style=\"cursor:hand;\"  />";//删除

		    }
			
		
		}
		
	}
	
	
	function convertDate(date){
		var year = date.getFullYear();
		var month = date.getMonth()+1;
		var m;
		if(month < 10){
			m = '0' + month;
		} else {
			m = month;
		}
		var day = date.getDate();
		var d;
		if(day < 10){
			d = '0' + day;
		} else {
			d = day;
		}
		var s = year + '-' +m+'-'+d;
		return s;
	}
	
</script>

</html>

