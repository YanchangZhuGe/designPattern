<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_appdet_id = request.getParameter("ids");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>运转记录</title> 
 </head>
<body style="background:#fff">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" >
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset><legend>设备信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  <tr>
					    
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevAccountPage()"  />
				<input id="fk_dev_acc_id" name="fk_dev_acc_id" type ="hidden" />
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
		  </tr>
		  <tr>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
			
			</td>
			<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
		  </tr>
		   <tr>
			<td class="inquire_item6">ERP设备编号</td>
			<td class="inquire_form6">
				<input id="dev_coding" name="dev_coding"  class="input_width" type="text" readonly/>
			</td>
		  </tr>
		  </table>
		  </fieldset>
		  <fieldset><legend>运转记录</legend>
		  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
		 	 <td class="inquire_item6">上次保养时间</td>
			<td class="inquire_form6">
				<input id="LastByTime" name="LastByTime"  class="input_width" type="text" readonly/></td>
			<td class="inquire_item6">累计里程(公里)</td>
			<td class="inquire_form6">
				<input id="mileage" name="mileage"  class="input_width" type="text" readonly/></td>
			<td class="inquire_item6">累计钻井进尺(米)</td>
			<td class="inquire_form6">
				<input id="drilling_footage" name="drilling_footage"  class="input_width" type="text" readonly/>	
			</td>
		  </tr>
		  <tr>
		 	
		  	<td class="inquire_item6">累计工作小时(小时)</td>
			<td class="inquire_form6"><input id="work_hour" name="work_hour"  class="input_width" type="text" readonly/></td>
			<!-- <td class="inquire_item6">填报时间</td>
				<td class="inquire_form6">
					<input type="text" name="modify_date" id="modify_date" value="" readonly="readonly" class="input_width"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(modify_date,tributton1);" />
				</td> -->
			
		  </tr>
		  
	  </table>
	  </fieldset>
	  <div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="right">
		  		<td class="ali_cdn_name" ></td>
		  		<td class="ali_cdn_input" ></td>
		  		<td class="ali_cdn_name" ></td>
		  		<td class="ali_cdn_input" ></td>
		  		<td>&nbsp;</td>
		    	<auth:ListButton functionId="" css="zj" event="onclick='addrow()'" title="增加"></auth:ListButton>
		    	<auth:ListButton functionId="" css="sc" event="onclick='removrow()'" title="删除"></auth:ListButton>
			</tr>
		  </table>
	  </div>
	  <fieldset><legend>保养时间</legend>
	  	<table width="120%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="OPERATOR_body">
		  		<tr>
			  		<td class="inquire_item6">第1次保养时间</td>
					<td class="inquire_form6">
						<input type="text" name="by_date1" id="by_date1" value="" readonly="readonly" class="input_width"/>
						<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(by_date1,tributton1);" />
						<input id="maintenance_id1" name="maintenance_id1" type ="hidden" />
					</td>
			<td class="inquire_item6">累计里程(公里)</td>
			<td class="inquire_form6">
				<input id="mileage1" name="mileage1"     class="input_width" type="text" /></td>
			
		  	<td class="inquire_item6">累计工作小时(小时)</td>
			<td class="inquire_form6"><input id="work_hour1" name="work_hour1"   class="input_width" type="text" /></td>
				</tr>
			</tbody>
	  	</table>
	  </fieldset>
	</div>
	<div id="oper_div" style="margin-bottom:5px">
			 	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
			    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	</div>	
	</div>
		  
    </div>
</form>
</body>
<script type="text/javascript"> 
	var optnum=1;
	var count = 0;
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	
	function submitInfo(){
		var by_date = document.getElementById("by_date1");
		var dev_name = document.getElementById("dev_name");
		
		if(dev_name.value ==""){
			alert("请选择设备信息！");
			return;
		}
		if(by_date.value ==""){
			
			alert("请填写保养日期！");
			return;
		}
	
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveDeviceAccMaintenancePlan.srq?count="+optnum;
			document.getElementById("form1").submit();
		}
	}

	function loadDataDetail(devAccId){
		
	   var querySql ="select acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_coding,max(info.repair_end_date) last_date, "
				+"nvl(max(oper.mileage_total),0) as mileage ,nvl(max(oper.drilling_footage_total),0) as footage ,nvl(max(oper.work_hour_total),0) as work_hour "
				+"from GMS_DEVICE_ACCOUNT acc left join BGP_COMM_DEVICE_REPAIR_INFO info on acc.dev_acc_id = info.device_account_id "
				+"left join GMS_DEVICE_OPERATION_INFO oper on acc.dev_acc_id = oper.dev_acc_id "
				+"where acc.bsflag='0' and acc.dev_acc_id='"+devAccId+"' "
				+"group by acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_coding";
		
	    //alert(querySql);
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
// 			$("#mileage")[0].value=basedatas[0].mileage;
// 			$("#drilling_footage")[0].value=basedatas[0].drilling_footage;
// 			$("#work_hour")[0].value=basedatas[0].work_hour;
// 			$("#modify_date")[0].value=basedatas[0].modify_date;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#dev_coding")[0].value=basedatas[0].dev_coding;
			$("#LastByTime")[0].value=basedatas[0].last_date;
			$("#mileage")[0].value=basedatas[0].mileage;
			$("#drilling_footage")[0].value=basedatas[0].footage;
			$("#work_hour")[0].value=basedatas[0].work_hour;
			$("#fk_dev_acc_id")[0].value=devAccId;
			
			//var querySql2 = "select t.maintenance_id,t.plan_date from gms_device_maintenance_plan t where t.dev_acc_id='"+dev_appdet_id+"' order by t.plan_num";

			//var queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql2);
			//var basedatas2 = queryRet2.datas;
			//alert(basedatas2.length)
			//count = basedatas2.length;
			//if(basedatas2!=null){
			//	$("#by_date1")[0].value=basedatas2[0].plan_date;
			//	$("#maintenance_id1")[0].value=basedatas2[0].maintenance_id;
			//	$("#tributton1").hide();
				
			//	for(var i = 1 ; i < basedatas2.length ; i++){
			//		var arrayObj = {"maintenance_id":basedatas2[i].maintenance_id,"value":basedatas2[i].plan_date}; 
			//		addrow(arrayObj);
			//	}	
			//}
			
	}
	
	
	function addrow(obj){
		
		optnum++;
		
		var newTr=OPERATOR_body.insertRow();
		var newTd=newTr.insertCell();
		newTd.className="inquire_item6";
		newTd.innerHTML="第"+optnum+"次保养时间";
		var newTd=newTr.insertCell();
		newTd.className="inquire_form6";
		if(obj==undefined){
			newTd.innerHTML="<input type='text' name='by_date"+optnum+"' id='by_date"+optnum+"' value='' readonly class='input_width' /><img src='<%=contextPath%>/images/calendar.gif' id='tributton"+optnum+"' width='16' height='16' style=cursor: hand ; onmouseover='calDateSelector(by_date"+optnum+",tributton"+optnum+")'; />";
		}else{
			newTd.innerHTML="<input name=maintenance_id"+optnum+" id=maintenance_id"+optnum+"  class=input_width type=hidden value="+obj.maintenance_id+"  /><input type='text' name='by_date"+optnum+"' id='by_date"+optnum+"' value='"+obj.value+"' readonly class='input_width' />";
		}
		var newTd=newTr.insertCell();
		newTd.className="inquire_item6";
		newTd.innerHTML="累计里程(公里)";
		var newTd=newTr.insertCell();
		newTd.className="inquire_form6";
		newTd.innerHTML=" <input type='text' name='mileage"+optnum+"' id='mileage"+optnum+"' value='' class='input_width' />";
		var newTd=newTr.insertCell();
		newTd.className="inquire_item6";
		newTd.innerHTML="累计工作小时(小时)";
		var newTd=newTr.insertCell();
		newTd.className="inquire_form6";
		newTd.innerHTML=" <input type='text' name='work_hour"+optnum+"' id='work_hour"+optnum+"' value='' class='input_width' />";
	}
	
	function removrow(){
		//
		if(optnum>0 && optnum >count){
			$("#OPERATOR_body  tr:last").remove(); 
			optnum--;
		}
		
	}
	
	function showDevAccountPage(){
		var obj = new Object();
		var dialogurl = "<%=contextPath%>/rm/dm/devRun/comm/selectAllAccount.jsp";
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=520px");
		if(vReturnValue!=undefined){
			loadDataDetail(vReturnValue);
		}
	}
	
</script>
</html>
 