<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath(); 
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String eq_id="";
	if(request.getParameter("eq_id") != null){
		eq_id=request.getParameter("eq_id"); 
	}
	String dev_acc_id="";
	if(request.getParameter("dev_acc_id") != null){
		dev_acc_id=request.getParameter("dev_acc_id"); 
	}
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设备设施台账2</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>
<body  onload="getEquipmentOne();listInfo();exitSelect();" >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>						   
						  <td class="inquire_item6">单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="dev_acc_id" name="dev_acc_id" value="" />
					       	<input type="hidden" id="eq_id" name="eq_id" value="" /> 
					    	<input type="hidden" id="cc" name="cc" value="" />
					       	<input type="hidden" id="dd" name="dd" value="" />  
				      	<input type="text" id="org_sub_ids" name="org_sub_ids" class="input_width"  readonly="readonly" style="color:gray" />	 
				      	</td>
				        	<td class="inquire_item6">基层单位：</td>
				      	<td class="inquire_form6">
				      	 <input type="text" id="second_orgs" name="second_orgs" class="input_width"   readonly="readonly" style="color:gray" /> 
				      	</td>    	  
					  </tr>					  
					  <tr>	 
						    <td class="inquire_item6">设备设施名称：</td>
						    <td class="inquire_form6">
						    <input type="text" id="shebeiname" name="shebeiname" class="input_width"   readonly="readonly" style="color:gray"  />   
						    </td>
						    <td class="inquire_item6">牌照号：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="paihao" name="paihao" class="input_width"   readonly="readonly" style="color:gray" />    		
						    </td>
						</tr>						
					  <tr>	
					    <td class="inquire_item6">规格型号：</td>
					    <td class="inquire_form6">
					    <input type="text" id="guigexing" name="guigexing" class="input_width"    readonly="readonly" style="color:gray" /></td>					 
					    <td class="inquire_item6">使用状况：</td> 					   
					    <td class="inquire_form6"  align="center" >  
						<input type="text" id="shiyong" name="shiyong" class="input_width"   readonly="readonly" style="color:gray"  />
					    </td>  
					   </tr>	
					   <tr> 
						    <td class="inquire_item6">技术状况：</td>
						    <td class="inquire_form6">   
							<input type="text" id="jishu" name="jishu" class="input_width"   readonly="readonly" style="color:gray"  />
						    </td>
						    <td class="inquire_item6">出厂日期：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <input type="text" id="riqi" name="riqi" class="input_width"    readonly="readonly" style="color:gray" /> 
						    </td>
						  </tr>	
					   <tr>  
						    <td class="inquire_item6"><font color="red">*</font>设备设施类别一：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="equipment_one" name="equipment_one" class="select_width" onchange="getEquipmentTwo()" ></select> 	
						    </td> 
						    <td class="inquire_item6"><font color="red">*</font>设备设施类别二：</td>
						    <td class="inquire_form6"> 
						    <select id="equipment_two" name="equipment_two" class="select_width" >
							</select> 			
						    </td>
					  </tr>	 
				   </table>
									 
	 </div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
 var eq_id='<%=eq_id%>'; 
 var ids='<%=dev_acc_id%>';  
 function checkJudge1(){
	 
		var equipment_one = document.getElementsByName("equipment_one")[0].value;		
		var equipment_two = document.getElementsByName("equipment_two")[0].value;	

		if(equipment_one==""){
			alert("设备设施类别一不能为空，请选择！");
			return true;
		}
		if(equipment_two==""){
			alert("设备设施类别二不能为空，请填写！");
			return true;
		}

		return false;
	}
	
 
function submitButton(){  
	if(checkJudge1()){
		return;
	}
	var rowParams = new Array(); 
		var rowParam = {};	 
		var equipment_one = document.getElementsByName("equipment_one")[0].value;		
		var equipment_two = document.getElementsByName("equipment_two")[0].value;	  
		if(ids ==""){
			rowParam['dev_acc_id'] = encodeURI(encodeURI(ids));
			rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));		 		
			rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two));  
		}else{ 
			rowParam['dev_acc_id'] = encodeURI(encodeURI(ids));
			rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));		 		
			rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two)); 
		    rowParam['eq_id'] = eq_id; 
		}
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("GMS_DEVICE_ACCOUNT_EQUIPMENT",rows);	 
		top.frames('list').refreshData();	
		newClose();
	
}
 
//得到所有
 
function getEquipmentOne(){
	var selectObj = document.getElementById("equipment_one"); 
	document.getElementById("equipment_one").innerHTML="";
	selectObj.add(new Option('请选择',""),0); 
	var queryEquipmentOne=jcdpCallService("HseOperationSrv","queryeQuipmentOne","");	 
	for(var i=0;i<queryEquipmentOne.detailInfo.length;i++){
		var templateMap = queryEquipmentOne.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	var selectObj1 = document.getElementById("equipment_two");
	document.getElementById("equipment_two").innerHTML="";
	selectObj1.add(new Option('请选择',""),0);
}

function getEquipmentTwo(){
    var EquipmentOne = "equipmentOne="+document.getElementById("equipment_one").value;   
	var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);	 
	var selectObj = document.getElementById("equipment_two");
	document.getElementById("equipment_two").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(EquipmentTwo.detailInfo!=null){
		for(var i=0;i<EquipmentTwo.detailInfo.length;i++){
			var templateMap = EquipmentTwo.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}
	}
}

  
 function exitSelect(){ 
		var selectObj = document.getElementById("equipment_one");  
		var aa = document.getElementById("cc").value; 
		var bb = document.getElementById("dd").value;  
	    for(var i = 0; i<selectObj.length; i++){ 
	        if(selectObj.options[i].value == aa){ 
	        	selectObj.options[i].selected = 'selected';     
	        } 
	       }  
	    var EquipmentOne = "equipmentOne="+ document.getElementById("cc").value;
	    var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);		 
		var selectObj2 = document.getElementById("equipment_two");
		document.getElementById("equipment_two").innerHTML="";
		selectObj2.add(new Option('请选择',""),0);

		if(EquipmentTwo.detailInfo!=null){ 
			for(var t=0;t<EquipmentTwo.detailInfo.length;t++){
				var templateMap = EquipmentTwo.detailInfo[t];
				selectObj2.add(new Option(templateMap.label,templateMap.value),t+1);
			}
		}
 
	    for(var j = 0; j<selectObj2.length; j++){ 
	        if(selectObj2.options[j].value == bb){  	
	        	selectObj2.options[j].selected = 'selected';     
	        } 
	       }  
	     
 }
 function  listInfo(){
	if(ids !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;	 
		querySql = "   select t.dev_acc_id,  et.equipment_one,  et.equipment_two, et.eq_id,(select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name, (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as org_name ,t.dev_name as facilities_name,t.dev_model as specifications, (select coding_name  from comm_coding_sort_detail c  where t.using_stat = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.producting_date as release_date,t.license_num as paizhaohao  from GMS_DEVICE_ACCOUNT t left join gms_device_account_equipment et on t.dev_acc_id=et.dev_acc_id  where t.bsflag = '0'   and t.dev_acc_id='"+ ids +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){	  
				 document.getElementsByName("dev_acc_id")[0].value=datas[0].dev_acc_id; 
	    		 document.getElementsByName("eq_id")[0].value=datas[0].eq_id;
	    		 document.getElementsByName("org_sub_ids")[0].value=datas[0].org_name;  
	    		 document.getElementsByName("second_orgs")[0].value=datas[0].second_org_name;	 
    		     document.getElementsByName("equipment_one")[0].value=datas[0].equipment_one;		
    		     document.getElementsByName("cc")[0].value=datas[0].equipment_one;	    		    
    			 document.getElementsByName("equipment_two")[0].value=datas[0].equipment_two;	
    			 document.getElementsByName("dd")[0].value=datas[0].equipment_two;	 
    			 document.getElementsByName("shebeiname")[0].value=datas[0].facilities_name;
    			 document.getElementsByName("guigexing")[0].value=datas[0].specifications;		
    		 	 document.getElementsByName("jishu")[0].value=datas[0].tech_stat_desc;	 
    			 document.getElementsByName("shiyong")[0].value=datas[0].using_stat_desc;	 
    			 document.getElementsByName("riqi")[0].value=datas[0].release_date;
    			 document.getElementsByName("paihao")[0].value=datas[0].paizhaohao;		
	    		      
			  }					
		
	    	}
	}
 }
</script>
</html>