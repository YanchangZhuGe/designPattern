<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_appdet_id = request.getParameter("ids");
	String repair_info=request.getParameter("repair_info");
	
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
  <title>维修保养</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset><legend>维修保养记录</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>					    
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input  type ="hidden" id="repair_info" name="repair_info" value="<%=repair_info%>"/>
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
			</td>
		  </tr>
		  <tr>			
			<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
			<td class="inquire_item6"><font color=red>*</font>&nbsp;修理类别</td>
			<td class="inquire_form6">
			<select cssClass="select_width"   name='repairType' id="repairType" value=""  disabled="disabled">
				<option value="0110000037000000001">维修</option>
				<option value="0110000037000000003">委外处理</option>
			</select>				
			</td>
			<td class="inquire_item6" ><font color=red>*</font>&nbsp;修理项目</td>
			<td class="inquire_form6">
			<select cssClass="select_width"   name='repairItem' id="repairItem" value=""  disabled="disabled"/>
			</td>
		  </tr>
	   	  <tr>
		    <td class="inquire_item6" ><font color=red>*</font>&nbsp;送修日期</td>
			<td class="inquire_form6"><input name="REPAIR_START_DATE" id="REPAIR_START_DATE" class="input_width" type="text" readonly />
			</td>
			<td class="inquire_item6" ><font color=red>*</font>&nbsp;竣工日期</td>
			<td class="inquire_form6"><input id="REPAIR_END_DATE" name="REPAIR_END_DATE" class="input_width" type="text" readonly />
			</td>
			<td class="inquire_item6" >工时费</td>
			<td class="inquire_form6"><input name="HUMAN_COST" id="HUMAN_COST" class="input_width" type="text"  readonly/></td>
		  </tr>
		   <tr>
		    <td class="inquire_item6" >工时数(小时)</td>
			<td class="inquire_form6"><input name="WORK_HOUR" id="WORK_HOUR" class="input_width" type="text" value="0" readonly/></td>
			<td class="inquire_item6" >材料费</td>
			<td class="inquire_form6"><input id="MATERIAL_COST" name="MATERIAL_COST" class="input_width" type="text"  readonly/></td>
			<td class="inquire_item6" ><font color=red>*</font>&nbsp;承修人</td>
			<td class="inquire_form6"><input name="REPAIRER" id="REPAIRER" class="input_width" type="text"  readonly/></td>
		  </tr>
		  <tr>
		  	<td class="inquire_item6" ><font color=red>*</font>&nbsp;验收人</td>
			<td class="inquire_form6"><input id="ACCEPTER" name="ACCEPTER" class="input_width" type="text" readonly/></td></tr>	   
		  <tr>
		   <td class="inquire_item6" >修理详情</td>
			<td class="inquire_form6" colspan="5">
				<textarea id="REPAIR_DETAIL" name="REPAIR_DETAIL" rows="2" cols="80" readonly></textarea>
			</td>
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
			</tr>
		  </table>
	  </div>
	  <fieldset><legend>维修保养明细</legend>
	  	<div style="height:130px;overflow:auto">
	  	<table id="educationMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
			  <tr>  
			  	  <td class="bt_info_odd">选择</td>
				  <td class="bt_info_even">序号</td>
				  <td class="bt_info_odd">计划单号</td>
				  <td class="bt_info_even">材料名称</td>
				  <td class="bt_info_odd">材料编号</td>
				  <td class="bt_info_even">单价</td>
				  <td class="bt_info_odd">出库数量</td>
				  <td class="bt_info_even">消耗数量</td>
				  <td class="bt_info_odd">总价</td>
			  </tr>
			  <tbody id="assign_body"></tbody>
		  </table>
		 </div>
	 </fieldset>	
	</div>
	<div id="oper_div" style="margin-bottom:5px">
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	</div>		
  </div>	   
</div>
</form>
</body>
<script type="text/javascript"> 
	var dev_appdet_id='<%=dev_appdet_id%>';
	var repair_info='<%=repair_info%>';
	
	function loadDataDetail(){
		//通过查询结果动态填充使用情况select;
		var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000024' and bsflag='0'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		usingdatas = queryRet.datas;
		if(usingdatas != null){
			for (var i = 0; i< usingdatas.length; i++) {
				document.getElementById("repairItem").options.add(new Option(usingdatas[i].coding_name,usingdatas[i].coding_code_id)); 
			}
		}
		
		if(repair_info=="null"){
			var querySql="select dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,using_stat,tech_stat,asset_value,net_value,case account_stat when '0' then '账内' when '1' then '账外' else '外租' end as stat_desc from GMS_DEVICE_ACCOUNT_DUI where dev_acc_id='"+dev_appdet_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
		}else{
			var querySql="select a.*,b.dev_name,b.dev_model,b.self_num,b.license_num from BGP_COMM_DEVICE_REPAIR_INFO a left join GMS_DEVICE_ACCOUNT_DUI b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id  where a.repair_info='"+repair_info+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#repairType")[0].value=basedatas[0].repair_type;
			$("#repairItem")[0].value=basedatas[0].repair_item;
			$("#REPAIR_START_DATE")[0].value=basedatas[0].repair_start_date;
			$("#REPAIR_END_DATE")[0].value=basedatas[0].repair_end_date;
			$("#WORK_HOUR")[0].value=basedatas[0].work_hour;
			$("#HUMAN_COST")[0].value=basedatas[0].human_cost;
			$("#MATERIAL_COST")[0].value=basedatas[0].material_cost;
			$("#REPAIRER")[0].value=basedatas[0].repairer;
			$("#ACCEPTER")[0].value=basedatas[0].accepter;
			$("#REPAIR_DETAIL")[0].value=basedatas[0].repair_detail;
			var querySql="select * from bgp_comm_device_repair_detail  where repair_info='"+repair_info+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			edit(basedatas);
		}
	}

	function edit(basedatas){
		var rindex;
		$("tr","#assign_body").each(function(i){
			rindex = i+1;
		});
		if(rindex==undefined)rindex=0;
		for(var i=0;i<basedatas.length;i++){
			rownum=rindex+i;
			var newTr=assign_body.insertRow();
			newTr.insertCell().innerHTML="<input type=checkbox disabled>";
			newTr.insertCell().innerHTML="<td>"+(rownum+1)+"</td>";//序号
			newTr.insertCell().innerHTML="<td>"+basedatas[i].teammat_out_id+"</td>";//计划单号
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_name+"</td>";//材料名称
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_coding+"</td>";//材料编号
			newTr.insertCell().innerHTML="<td>"+basedatas[i].unit_price+"</td>";//单价
			newTr.insertCell().innerHTML="<td>"+basedatas[i].out_num+"</td>";//出库数量
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_amout+"</td>";//消耗数量
			newTr.insertCell().innerHTML="<td>"+basedatas[i].total_charge+"</td>";//总价
			
			$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
			$("#assign_body>tr:odd>td:even").addClass("odd_even");
			$("#assign_body>tr:even>td:odd").addClass("even_odd");
			$("#assign_body>tr:even>td:even").addClass("even_even");
		}
	}
</script>
</html>
 