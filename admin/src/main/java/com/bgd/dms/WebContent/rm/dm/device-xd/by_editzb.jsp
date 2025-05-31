
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
<body style="background:#fff" onload="loadDataDetail()">
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
		    <td class="inquire_item6">实物表示号</td>
			<td class="inquire_form6">
				<input id="dev_sign" name="dev_sign"  class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">ERP设备编号</td>
			<td class="inquire_form6">
				<input id="dev_coding" name="dev_coding"  class="input_width" type="text" readonly/>
			</td>
		  </tr>
		  </table>
		  </fieldset>
		  <fieldset><legend>历史记录</legend>
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
				<input id="fk_dev_acc_id" name="fk_dev_acc_id" type ="hidden" />	
				<input id="repair_info" name="repair_info" type ="hidden" />
			</td>
		  </tr>
		  <tr>
		 	
		  	<td class="inquire_item6">累计工作小时(小时)</td>
			<td class="inquire_form6"><input id="work_hour" name="work_hour"  class="input_width" type="text" readonly/>
<%-- 			<auth:ListButton functionId="" css="jh" event="onclick='viewBY()'" title="查看详细"></auth:ListButton> --%>
			</td>
			<td align="left"><a  style="color: blue" href="javascript:viewBY()" />查看明细</td>
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
	  <fieldset><legend>计划保养时间</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="OPERATOR_body">
		  		<tr>
			  		<td class="inquire_item6">第1次</td>
					<td class="inquire_form6">
						<input    onchange='changeValue(this)'  type="text" name="by_date1" id="by_date1" value="" readonly="readonly" class="input_width"/>
												<input      type='hidden' name='by_date_hidden_1' id='by_date_hidden_1'  value=''/>
						<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(by_date1,tributton1);" />
						<input id="maintenance_id1" name="maintenance_id1" type ="hidden" />
					</td>
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
	var dev_appdet_id='<%=dev_appdet_id%>';
	var optnum=1;
	var count = 0;
	
	function submitInfo(){
		var noticeMsg="";
		var count=0;
	   $("input[type='text'][name^='by_date']").each(function (i){
		  
		   if($(this).val()==""||$(this).val()==null){
			   if(count==0){
				   noticeMsg=$(this).attr("name").replace("by_date",""); 
			   }else{
				   noticeMsg=noticeMsg+","+$(this).attr("name").replace("by_date","");
			   }
			   count++;
		   }
	   });
	   if(noticeMsg!=""){
		   alert("请填写第"+noticeMsg+"次的计划保养日期");
		   noticeMsg="";
		   count="0";
		   return ;
	   }else{
		   var a=0;
		   $("input[type='text'][name^='by_date']").each(function (i){
				 var currentDate=$("#by_date"+(Number(i)+1)).val(); 
				 var compDate=$("#by_date"+(Number(i)+2)).val(); 
				 if(compDate<=currentDate){
					 if(a==0){
						 noticeMsg=(Number($(this).attr("name").replace("by_date",""))+1); 
					 }else{
						 noticeMsg=noticeMsg+","+(Number($(this).attr("name").replace("by_date",""))+1);
					 }
					 a++;
				 }
				
			  
		   });
		   if(noticeMsg!=""){
			   alert("请核对第"+noticeMsg+"次的计划保养日期后重新提交");
			   noticeMsg="";
			   a=0;
			   return ;
		   }
	   }
		if(confirm("确认提交？")){
			//调配数量提交
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/updateDeviceAccMaintenancePlan.srq?ids="+dev_appdet_id+"&count="+optnum;
			document.getElementById("form1").submit();
		}
	}
	
	function viewBY(){
		var repair_info = $("#repair_info").val();
		popWindow("<%=contextPath%>/rm/dm/device-xd/qzbydetail.jsp?ids="+dev_appdet_id+"&repair_info="+repair_info,'950:680');
	}

	function loadDataDetail(){
		
		var querySql ="select dui.dev_name,dui.dev_sign,dui.fk_dev_acc_id,dui.dev_model,dui.self_num,dui.license_num,dui.dev_coding from GMS_DEVICE_ACCOUNT_DUI dui  "
			+" where dui.bsflag='0' and dui.dev_acc_id='"+dev_appdet_id+"' ";
	
 
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
			
		var querySql2 = "select * from (select t.* from BGP_COMM_DEVICE_REPAIR_INFO t where t.device_account_id='"+dev_appdet_id+"' order by t.repair_start_date desc) where rownum=1 ";
		var queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql2);
		var basedatas2 = queryRet2.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#dev_coding")[0].value=basedatas[0].dev_coding;
			$("#fk_dev_acc_id")[0].value=basedatas[0].fk_dev_acc_id;
			$("#dev_sign")[0].value=basedatas[0].dev_sign;
			if(basedatas2 != null && basedatas2 != ""){
				$("#LastByTime")[0].value=basedatas2[0].repair_end_date;
				$("#mileage")[0].value=basedatas2[0].mileage_total;
				$("#drilling_footage")[0].value=basedatas2[0].drilling_footage_total;
				$("#work_hour")[0].value=basedatas2[0].work_hour_total;
				$("#repair_info")[0].value=basedatas2[0].repair_info;
			}
			
						
			var querySql3 = "select t.maintenance_id,t.plan_date from gms_device_maintenance_plan t where t.dev_acc_id='"+dev_appdet_id+"' order by t.plan_num";
	
			var queryRet3 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql3);
			var basedatas3 = queryRet3.datas;
			//alert(basedatas2.length)
			count = basedatas3.length;
			if(basedatas3!=null){
				$("#by_date1")[0].value=basedatas3[0].plan_date;
				$("#by_date_hidden_1")[0].value=basedatas3[0].plan_date;
				
				$("#maintenance_id1")[0].value=basedatas3[0].maintenance_id;
				
				for(var i = 1 ; i < basedatas3.length ; i++){
					var arrayObj = {"maintenance_id":basedatas3[i].maintenance_id,"value":basedatas3[i].plan_date}; 
					addrow(arrayObj);
				}	
			}		  
	}
	
	
	function addrow(obj){
		
		optnum++;
		
		var newTr=OPERATOR_body.insertRow();
		var newTd=newTr.insertCell();
		newTd.className="inquire_item6";
		newTd.innerHTML="第"+optnum+"次";
		var newTd=newTr.insertCell();
		newTd.className="inquire_form6";
		if(obj==undefined){
			newTd.innerHTML="<input     onchange='changeValue(this)'   type='text' name='by_date"+optnum+"' id='by_date"+optnum+"' value='' readonly class='input_width' /><img src='<%=contextPath%>/images/calendar.gif' id='tributton"+optnum+"' width='16' height='16' style=cursor: hand ; onmouseover='calDateSelector(by_date"+optnum+",tributton"+optnum+")'; />";
		}else{
			newTd.innerHTML="<input      type='hidden' name='by_date_hidden_'"+optnum+" id='by_date_hidden_'"+optnum+"  value='"+obj.value+"'/><input name=maintenance_id"+optnum+" id=maintenance_id"+optnum+"  class=input_width type=hidden value="+obj.maintenance_id+"  /><input type='text' name='by_date"+optnum+"'    onchange='changeValue(this)'  id='by_date"+optnum+"' value='"+obj.value+"' readonly class='input_width' /><img src='<%=contextPath%>/images/calendar.gif' id='tributton"+optnum+"' width='16' height='16' style=cursor: hand ; onmouseover='calDateSelector(by_date"+optnum+",tributton"+optnum+")'; />";
		}
		
	}
	
	function removrow(){
		//
		if(optnum>0 ){
			$("#OPERATOR_body  tr:last").remove(); 
			optnum--;
		}
		
	}
	function changeValue(cb){
		  var dateValue=cb.value;
		  initDate=dateValue
		  var nameValue=$(cb).attr("name");
		  var orderNum= nameValue.replace("by_date","");
		  var size=optnum;
		  if(orderNum<optnum){
			  size=orderNum;
		  }
		  if(dateValue!=""){
			  var beforeDataValue=$("#by_date"+(size-1)).val();
			  var afterDataValue=$("#by_date"+(Number(size)+1)).val();
		  if(size>1){
				  if((beforeDataValue!=""&&beforeDataValue!=undefined)&&(afterDataValue!=""&&afterDataValue!=undefined)){
					  if(beforeDataValue>=dateValue){
						  alert("您所修改的第"+size+"次计划保养日期应大于之前的计划保养日期");
						  return;
					  }   
					  if(afterDataValue<=dateValue){
						  alert("您所修改的第"+size+"次计划保养日期应小于之后的计划保养日期");
						  return;
					  } 
				  }
				  if((beforeDataValue!=""&&beforeDataValue!=undefined)&&(afterDataValue==""||afterDataValue==undefined)){
					  if(beforeDataValue>=dateValue){
						  alert("您所修改的第"+size+"次计划保养日期应大于之前的计划保养日期");
						  return;
					  }   
					   
				  }
				  if((beforeDataValue==""&&beforeDataValue==undefined)&&(afterDataValue!=""&&afterDataValue!=undefined)){ 
					  if(beforeDataValue>=dateValue){
						  alert("您所修改的第"+size+"次计划保养日期应小于之后的计划保养日期");
						  return;
					  } 
				  }
		 
			  }else  if(size==1){
				 
				  if((beforeDataValue==""||beforeDataValue==undefined)&&(afterDataValue!=""&&afterDataValue!=undefined)){ 
					  if(optnum!=size){
					  if(afterDataValue<=dateValue){
						  alert("您所修改的第"+size+"次计划保养日期应小于之后的计划保养日期");
						  return;
					  } 
					  }
				  } 
			  }
		   }
		  
		}
</script>
</html>
 