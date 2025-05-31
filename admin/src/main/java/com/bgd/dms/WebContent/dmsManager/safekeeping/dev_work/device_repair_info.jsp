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
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>维修保养</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width: 100%">
    <div id="new_table_box_bg" style="width: 95%">
      <fieldset><legend>设备维修记录</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>					    
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input  type ="hidden" id="repair_info" name="repair_info" value="<%=repair_info%>"/>
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevAccountPage()"  />
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
			   <td class="inquire_item6" ><font color=red>*</font>&nbsp;送修日期</td>
			<td class="inquire_form6">
				<input type="text" name="REPAIR_START_DATE" id="REPAIR_START_DATE" class="input_width easyui-datebox" style="width:150px" editable="false" required/>
			</td>
			<td class="inquire_item6" ><font color=red>*</font>&nbsp;承修人</td>
			<td class="inquire_form6"><input name="REPAIRER" id="REPAIRER" class="input_width" type="text"  /></td>
		  </tr>					 	
	   	  <tr>
		 <td class="inquire_item6"><font color=red>*</font>&nbsp;修理类别</td>
			<td class="inquire_form6">
			<select cssClass="select_width"  onchange="clearRepairList(this.value)" name='repairType' id="repairType" value="" >
				<option value="0100400027000000001">内修</option>
				<option value="100400027000000003">自修</option>
				<option value="0100400027000000002">外修</option>
			</select>				
			</td>
			<td class="inquire_item6" ><font color=red>*</font>&nbsp;修理项目</td>
			<td class="inquire_form6">
<%-- 			<code:codeSelect  cssClass="select_width"   name='repairItem' option="repairItem" selectedValue=""  addAll="true" /> --%>
			<select cssClass="select_width"   name='repairItem' id="repairItem" value=""  />
			</td>
					<td class="inquire_item6"><font color=red>*</font>&nbsp;修理级别</td>
			<td class="inquire_form6">
			<select cssClass="select_width"   name='repairLevel' id="repairLevel" value="" >
				<option value="5110000197000000001">项修</option>
				<option value="5110000197000000002">二级保养</option>
				<option value="5110000197000000003">三级保养</option>
				<option value="5110000197000000004">总成大修</option>
			</select>
		</td>
		  </tr>
		   <tr>	
		   <td class="inquire_item6" >工时费</td>
			<td class="inquire_form6"><input name="HUMAN_COST" id="HUMAN_COST" class="input_width" type="text" value="0" /></td>		
			<td class="inquire_item6" >材料费</td>
			<td class="inquire_form6"><input id="MATERIAL_COST" name="MATERIAL_COST" class="input_width" type="text" value="0" readonly/></td>
				<td class="inquire_item6" >&nbsp;修复验收日期</td>
			<td class="inquire_form6">
				<input type="text" id="REPAIR_END_DATE" name="REPAIR_END_DATE" class="input_width easyui-datebox" style="width:145px" editable="false" required/>
			</td>
			
		  </tr>		
		  	   <tr>		
		  	   <td class="inquire_item6" ><font color=red>*</font>&nbsp;修复验收人</td>
			<td class="inquire_form6"><input id="ACCEPTER" name="ACCEPTER" class="input_width" type="text" /></td>	
			<td class="inquire_item6" >维修状态</td>
			<td class="inquire_form6">
		<select class="select_width"  name='record_status' id="record_status"   onchange="selectChange()" >
				<option value="0">维修中</option>
				<option selected value="1">维修完</option>
			</select>				
			</td>
				<td class="inquire_item6" >技术状况</td>
			<td class="inquire_form6">
		<select class="select_width"  name='tech_stat' id="tech_stat" value="" >
			<option value="0110000006000000007">在修</option>
				<option selected value="0110000006000000001">完好</option>
				<option  value="0110000006000000005">待报废</option>
			</select>				
			</td>
		
		  </tr>   
		   <tr>
		   <td class="inquire_item6" ><font color=red>*</font>&nbsp;检修内容</td>
			<td class="inquire_form6" colspan="5">
				<textarea id="REPAIR_DETAIL" name="REPAIR_DETAIL" rows="2" cols="80" ></textarea>
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
		    	<auth:ListButton id="zj1" functionId="" css="zj" event="onclick='add(1)'" title="手工录入"></auth:ListButton>
		    	<auth:ListButton functionId="" css="sc" event="onclick='removrow()'" title="删除"></auth:ListButton>
			</tr>
		  </table>
	  </div>
	  <fieldset><legend>材料消耗明细</legend>
	  	<div style="height:135px;overflow:auto">
	  	<table id="educationMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
			  <tr style="display:block" id="maintain">  
			  	  <td class="bt_info_odd" width="4%">选择</td>
				  <td class="bt_info_even" width="4%">序号</td>
<!-- 				  <td class="bt_info_odd" width="14%">计划单号</td> -->
				  <td class="bt_info_even" width="16%">材料名称</td>
				  <td class="bt_info_odd" width="12%">材料编号</td>
				  <td class="bt_info_even">计量单位</td>
				  <td class="bt_info_even" width="13%">单价</td>
<!-- 				  <td class="bt_info_odd" width="12%">出库数量</td> -->
				  <td class="bt_info_even" width="13%">消耗数量</td>
				  <td class="bt_info_odd" width="12%">总价</td>
			  </tr>
			  <tbody id="assign_body"></tbody>
		  </table>
		 </div>
	</fieldset>	
	</div>	  	
	<div id="oper_div" style="margin-bottom:5px">
		<span class="tj_btn"><a id="submitButton" href="####" onclick="submitInfo()"></a></span>
		<span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
	</div>		
  </div>	   
</div>
</form>
</body>
<script type="text/javascript"> 
	var dev_appdet_id='<%=dev_appdet_id%>';
	var repair_info='<%=repair_info%>';
	
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	$().ready(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
	})
	
	function submitInfo(){
		if(!checks()){	
			return false;
		}
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交			
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveDeviceAccountRepairInfo.srq?state=9&ids="+dev_appdet_id;
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
			//var ctt = parent.frames('list').frames;	  
			//ctt.loadDataDetail(dev_appdet_id);
		}
	}
	function checks(){
		start = $("#REPAIR_START_DATE").datebox("getValue");
		end = $("#REPAIR_END_DATE").datebox("getValue");
		var reg = new RegExp("^(0|([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$");
		if($("#dev_appdet_id")[0].value=="null"){
			$.messager.alert("提示","请选择设备","warning");
			$("#repairType")[0].focus();
			return false;
		}	
		if($("#repairType")[0].value==""){
			$.messager.alert("提示","修理类别不能为空","warning");
			$("#repairType")[0].focus();
			return false;
		}
		if(	$("#repairItem")[0].value==""){
			$.messager.alert("提示","修理项目不能为空","warning");
			$("#repairItem")[0].focus();
			return false;
		}
		
		if($("#HUMAN_COST")[0].value!=''&&!reg.test($("#HUMAN_COST")[0].value)){
			$.messager.alert("提示","工时费的格式不正确","warning");
			$("#HUMAN_COST")[0].value="";
			$("#HUMAN_COST")[0].focus();
			return false;
		}		

		if($("#MATERIAL_COST")[0].value!=''&&!reg.test($("#MATERIAL_COST")[0].value)){
			$.messager.alert("提示","材料费的格式不正确！","warning");
			$("#MATERIAL_COST")[0].value="";
			$("#MATERIAL_COST")[0].focus();
			return false;
		}
		
		if($("#REPAIRER")[0].value==""){
			if($("#record_status")[0].value=="1"){
				$.messager.alert("提示","承修人不能为空","warning");
				$("#REPAIRER")[0].focus();
				return false;
			}
		}
		if($("#ACCEPTER")[0].value==""){
			if($("#record_status")[0].value=="1"){
				$.messager.alert("提示","修复验收人不能为空","warning");
				$("#ACCEPTER")[0].focus();
				return false;
			}
		}
		if($.trim($("#REPAIR_DETAIL")[0].value).length<=0){
			$.messager.alert("提示","检修内容不能为空","warning");
			$("#ACCEPTER")[0].focus();
			return false;
		}
		if(end < start){
			$.messager.alert("提示","复检日期不能早于送修日期","warning");
			return false;
		}
		
		
		var objssss=document.getElementsByName("rows");
		
		if(objssss.length>0){
			var wz_name_row;//材料名称
			var wz_price_row;//单价
			var asign_num_row;//消耗数量
			for(var i=0;i<objssss.length;i++){

				wz_name_row=document.getElementById("wz_name"+objssss[i].value);
				if(wz_name_row.value==""){
					wz_name_row.focus();
					$.messager.alert("提示","材料名称不能为空!","warning");
					return false;
				}

				//wz_price_row=document.getElementById("wz_price"+objssss[i].value);
				//if(wz_price_row.value==""){
				//	wz_price_row.focus();
				//	alert("单价不能为空!");
				//	return false;
			//	}

				asign_num_row=document.getElementById("asign_num"+objssss[i].value);
				if(asign_num_row.value==""){
					asign_num_row.focus();
					$.messager.alert("提示","消耗数量不能为空!","warning");
					return false;
				}	
			}
		}else{
		}
		return true;
	}
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
			if(dev_appdet_id!="null")
			{
			var querySql="select dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num from gms_device_account where dev_acc_id='"+dev_appdet_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			}
		}else{
			var querySql="select a.*,b.dev_name,b.tech_stat,b.dev_model,b.self_num,b.license_num from BGP_COMM_DEVICE_REPAIR_INFO a left join gms_device_account b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id  where a.repair_info='"+repair_info+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#repairType")[0].value=basedatas[0].repair_type;
			$("#repairItem")[0].value=basedatas[0].repair_item;
			$("#REPAIR_START_DATE").datebox("setValue",basedatas[0].repair_start_date);
			$("#REPAIR_END_DATE").datebox("setValue",basedatas[0].repair_end_date);
			$("#HUMAN_COST")[0].value=basedatas[0].human_cost;
			$("#MATERIAL_COST")[0].value=basedatas[0].material_cost;
			$("#REPAIRER")[0].value=basedatas[0].repairer;
			$("#ACCEPTER")[0].value=basedatas[0].accepter;
			$("#REPAIR_DETAIL")[0].value=basedatas[0].repair_detail;
			$("#record_status")[0].value=basedatas[0].record_status;
			$("#repairLevel")[0].value=basedatas[0].repair_level;
			document.getElementById("tech_stat").options.length=0;
			if(document.getElementById("record_status").value=='0')
			{
				document.getElementById("tech_stat").options.add(new Option("在修","0110000006000000007"));
			}
			else{
				document.getElementById("tech_stat").options.add(new Option("完好","0110000006000000001"));
				document.getElementById("tech_stat").options.add(new Option("在修","0110000006000000007"));
				document.getElementById("tech_stat").options.add(new Option("待报废","0110000006000000005"));
				$("#tech_stat")[0].value=basedatas[0].tech_stat;
			}
			
			var querySql="select * from bgp_comm_device_repair_detail  where repair_info='"+repair_info+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
				edit(basedatas);
		}
	}
	function add(str){
		$("#maintain").css("display","none");
		$("#out_maintain").css("display","none");
		var repair_type = document.getElementById("repairType").value;
		if(repair_type == '0110000037000000003'){//委外维修
			$("#out_maintain").css("display","block");
			var rindex;
			$("tr","#assign_body").each(function(i){
				rindex = i+1;
			});
			if(rindex==undefined)rindex=0;
			rownum = rindex;
			//alert(rownum);
			//动态新增表格
			var newTr=assign_body.insertRow();
				newTr.insertCell().innerHTML="<input type=checkbox checked><input type=hidden name=rows id=rows"+rownum+" value="+rownum+">";
				newTr.insertCell().innerHTML="<td>"+(rownum+1)+"</td>";//序号
				newTr.insertCell().innerHTML="<td><font color=red>*</font>&nbsp;<input type=text id=wz_name"+rownum+" name=wz_name"+rownum+" value='' size='25'></td>";//材料名称
				newTr.insertCell().innerHTML="<td><font color=red>*</font>&nbsp;<input type=text id=wz_price"+rownum+" name=wz_price"+rownum+" value='0' size='16' onBlur='AutoCal(this,"+rownum+")'></td>";//单价
				newTr.insertCell().innerHTML="<td><font color=red>*</font>&nbsp;<input type='text' id='asign_num"+rownum+"' name='asign_num"+rownum+"' out_num='' value='0' size='16' onkeyup='AutoCal(this,"+rownum+")'></td>";//消耗数量
				newTr.insertCell().innerHTML="<td><input type='text' id='total_charge"+rownum+"' name='total_charge"+rownum+"' value='0' size='25' readonly/></td>";//总价
				
			$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
			$("#assign_body>tr:odd>td:even").addClass("odd_even");
			$("#assign_body>tr:even>td:odd").addClass("even_odd");
			$("#assign_body>tr:even>td:even").addClass("even_even");
		}else{
			if(str == '1'){//手工录入
				$("#maintain").css("display","block");
				var rindex;
				$("tr","#assign_body").each(function(i){
					rindex = i+1;
				});
				if(rindex==undefined)rindex=0;
				rownum = rindex;
				//动态新增表格
				var newTr=assign_body.insertRow();
				newTr.insertCell().innerHTML="<input type=checkbox checked><input type=hidden name=rows id=rows"+rownum+" value="+rownum+">";
				newTr.insertCell().innerHTML="<td>"+(rownum+1)+"</td>";//序号
// 				newTr.insertCell().innerHTML="<td>&nbsp;<input type=hidden id=teammat_out_id"+rownum+" name=teammat_out_id"+rownum+" value=''><input type=hidden id=use_info_detail"+rownum+" name=use_info_detail"+rownum+" value=''></td>";//计划单号
				newTr.insertCell().innerHTML="<td><font color=red>*</font>&nbsp;<input type='text' id=wz_name"+rownum+" name=wz_name"+rownum+" value=''></td>";//材料名称
				newTr.insertCell().innerHTML="<td>&nbsp;<input type='text' id=wz_id"+rownum+" name=wz_id"+rownum+" value=''></td>";//材料编号
	 			newTr.insertCell().innerHTML="<td>&nbsp;<input type='text' id=wz_prickie"+rownum+" name=wz_prickie"+rownum+" value=''></td>";//计量单位
				newTr.insertCell().innerHTML="<td><font color=red>*</font>&nbsp;<input type='text' id=wz_price"+rownum+" name=wz_price"+rownum+" value='0'></td>";//单价
// 				newTr.insertCell().innerHTML="<td>&nbsp;<input type=hidden id=use_num"+rownum+" name=use_num"+rownum+" value=''></td>";//出库数量
				newTr.insertCell().innerHTML="<font color=red>*</font>&nbsp;<input type='text' id='asign_num"+rownum+"' name='asign_num"+rownum+"' out_num='' value='0' size='5' onkeyup='AutoCal(this,"+rownum+")'>";//消耗数量
				newTr.insertCell().innerHTML="<td><input type='text' size='5' readonly='readonly' id='total_charge"+rownum+"' name='total_charge"+rownum+"' value='0'/></td>";//总价
					
				$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
				$("#assign_body>tr:odd>td:even").addClass("odd_even");
				$("#assign_body>tr:even>td:odd").addClass("even_odd");
				$("#assign_body>tr:even>td:even").addClass("even_even");
			}else{//选择物资
				$("#maintain").css("display","block");
				var dev_acc_id='<%=dev_appdet_id%>';
				//界面中已经添加的信息，放到对象传递过去
				var param = new Object();
				var pageselectedstr = null;
				var checkstr = 0;
				$("input[name^='use_info_detail'][type='hidden']").each(function(i){
					if(this.value!=null&&this.value!=''){
						if(checkstr == 0){
							pageselectedstr = "'"+this.value;
						}else{
							pageselectedstr += "','"+this.value;
						}
						checkstr++;
					}
				});
				if(pageselectedstr!=null){
					pageselectedstr = pageselectedstr + "'";
				}
				var sql="select d.coding_code_id from comm_coding_sort_detail d where d.coding_name='设备维修'";
				var devRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+"&pageSize=1000");
				var devdatas = devRet.datas;
				var devType = devdatas[0].coding_code_id;
				param.pageselectedstr = pageselectedstr;
				param.dev_acc_id = '<%=dev_appdet_id%>';
				var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/dev_work/matItemList.jsp?devType='+devType,param,"dialogWidth=800px;dialogHeight=520px");
				if(vReturnValue != undefined){
// 					var querySql="select MAIN.PROCURE_NO as TEAMMAT_OUT_ID,BASE.WZ_NAME,sub.use_info_detail,SUB.WZ_ID,SUB.APP_NUM AS USE_NUM,base.WZ_PRICE ";
// 					querySql += "from GMS_MAT_TEAMMAT_OUT MAIN ";
// 					querySql += "LEFT JOIN GMS_MAT_DEVICE_USE_INFO_DETAIL SUB ON MAIN.TEAMMAT_OUT_ID=SUB.TEAMMAT_OUT_ID ";
// 					querySql += "LEFT JOIN gms_mat_infomation BASE ON SUB.WZ_ID=BASE.WZ_ID ";
// 					querySql += "WHERE MAIN.BSFLAG='0' AND SUB.BSFLAG='0' AND BASE.BSFLAG='0' ";
// 					querySql += "and sub.use_info_detail in "+vReturnValue;
// 					querySql += " union all select MAIN.PROCURE_NO as TEAMMAT_OUT_ID,BASE.WZ_NAME,sub.out_detail_id,SUB.WZ_ID,SUB.MAT_NUM AS USE_NUM,base.WZ_PRICE from GMS_MAT_TEAMMAT_OUT MAIN LEFT JOIN gms_mat_teammat_out_detail SUB ON MAIN.TEAMMAT_OUT_ID=SUB.TEAMMAT_OUT_ID LEFT JOIN gms_mat_infomation BASE ON SUB.WZ_ID=BASE.WZ_ID WHERE MAIN.BSFLAG='0' AND SUB.BSFLAG='0' AND BASE.BSFLAG='0' and sub.out_detail_id in "+vReturnValue+" "
					var querySql = "select * from gms_mat_infomation t where t.wz_id in "+vReturnValue;
					var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+"&pageSize=1000");
					basedatas = queryRet.datas;
					var rindex;
					$("tr","#assign_body").each(function(i){
						rindex = i+1;
					});
					if(rindex==undefined)rindex=0;
				
					for(var i=0;i<basedatas.length;i++){
						rownum=rindex+i;
						var newTr=assign_body.insertRow();
						newTr.insertCell().innerHTML="<input type=checkbox checked><input type=hidden name=rows id=rows"+rownum+" value="+rownum+">";
						newTr.insertCell().innerHTML="<td>"+(rownum+1)+"</td>";//序号
// 						newTr.insertCell().innerHTML="<td>"+basedatas[i].teammat_out_id+"<input type=hidden id=teammat_out_id"+rownum+" name=teammat_out_id"+rownum+" value='"+basedatas[i].teammat_out_id+"'><input type=hidden id=use_info_detail"+rownum+" name=use_info_detail"+rownum+" value='"+basedatas[i].use_info_detail+"'></td>";//计划单号
						newTr.insertCell().innerHTML="<td>"+basedatas[i].wz_name+"<input type=hidden id=wz_name"+rownum+" name=wz_name"+rownum+" value='"+basedatas[i].wz_name+"'></td>";//材料名称
						newTr.insertCell().innerHTML="<td>"+basedatas[i].wz_id+"<input type=hidden id=wz_id"+rownum+" name=wz_id"+rownum+" value='"+basedatas[i].wz_id+"'></td>";//材料编号
						newTr.insertCell().innerHTML="<td>"+basedatas[i].wz_prickie+"<input type=hidden id=wz_prickie"+rownum+" name=wz_prickie"+rownum+" value='"+basedatas[i].wz_prickie+"'></td>";//计量单位
						newTr.insertCell().innerHTML="<td>"+basedatas[i].wz_price+"<input type=hidden id=wz_price"+rownum+" name=wz_price"+rownum+" value='"+basedatas[i].wz_price+"'></td>";//单价
// 						newTr.insertCell().innerHTML="<td>"+basedatas[i].use_num+"<input type=hidden id=use_num"+rownum+" name=use_num"+rownum+" value='"+basedatas[i].use_num+"'></td>";//出库数量
						newTr.insertCell().innerHTML="<font color=red>*</font>&nbsp;<input type='text' id='asign_num"+rownum+"' name='asign_num"+rownum+"' out_num='"+basedatas[i].use_num+"' value='' size='5' onkeyup='AutoCal(this,"+rownum+")'>";//消耗数量
						newTr.insertCell().innerHTML="<td><input type='text' size='5' readonly='readonly' id='total_charge"+rownum+"' name='total_charge"+rownum+"' value='"+(basedatas[i].use_num*basedatas[i].wz_price)+"'/></td>";//总价
						
						$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
						$("#assign_body>tr:odd>td:even").addClass("odd_even");
						$("#assign_body>tr:even>td:odd").addClass("even_odd");
						$("#assign_body>tr:even>td:even").addClass("even_even");
					}
				}
		  }	
		}	
		recountTotalCharge();
	}
	function removrow(){
		var cks=$("#assign_body :checked")
		for(var i=0;i<cks.length;i++){
			cks[i].parentNode.parentNode.removeNode(true);
		}
		recountTotalCharge();
	}
	function recountTotalCharge(){
		//计算总价
		var totalcharge = 0;
		$("input[type='text'][id^='total_charge']").each(function(i){
			totalcharge += parseFloat(this.value);
		});
		$("#MATERIAL_COST").val(totalcharge);
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
			newTr.insertCell().innerHTML="<input type=checkbox><input type=hidden name=rows id=rows"+rownum+" value="+rownum+">";
			newTr.insertCell().innerHTML="<td>"+(rownum+1)+"</td>";//序号
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_name+"<input type='hidden' id=wz_name"+rownum+" name=wz_name"+rownum+" value='"+basedatas[i].material_name+"'></td>";//材料名称
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_coding+"<input type=hidden id=wz_id"+rownum+" name=wz_id"+rownum+" value='"+basedatas[i].material_coding+"'></td>";//材料编号
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_unit+"<input type=hidden id=wz_prickie"+rownum+" name=wz_prickie"+rownum+" value='"+basedatas[i].material_unit+"'></td>";//计量单位
			newTr.insertCell().innerHTML="<td>"+basedatas[i].unit_price+"<input type=hidden id=wz_price"+rownum+" name=wz_price"+rownum+" value='"+basedatas[i].unit_price+"'></td>";//单价
			newTr.insertCell().innerHTML="<font color=red>*</font>&nbsp;<input type='text' id='asign_num"+rownum+"' name='asign_num"+rownum+"'  size='5' value='"+basedatas[i].material_amout+"' onkeyup='AutoCal(this,"+rownum+")'>";//消耗数量
			newTr.insertCell().innerHTML="<input type='text' readonly='readonly' id='total_charge"+rownum+"' value='"+basedatas[i].total_charge+"' name='total_charge"+rownum+"' size='5'>";//总价
			
			$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
			$("#assign_body>tr:odd>td:even").addClass("odd_even");
			$("#assign_body>tr:even>td:odd").addClass("even_odd");
			$("#assign_body>tr:even>td:even").addClass("even_even");
		}
	}
	function AutoCal(obj,rownum){
		var value = obj.value;
		//alert(Number(value));
		var re = new RegExp("^(0|([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$");
		if(value=="")
			return;
		if(!re.test(value)){
			alert("必须为有效数字!");
			obj.value = "";
        	return false;
		}else{
			var repair_type = document.getElementById("repairType").value;
			if(repair_type != '0110000037000000003'){//委外维修没有出库数量
				if(parseInt(value,10)>parseInt(obj.out_num)){
					alert("消耗数量必须小于等于出库数量!");
					obj.value = "";
					document.getElementById("total_charge"+rownum).value= "";
					return false;
				}
			}
		}
		var wz_str = document.getElementById("wz_price"+rownum).value;
		if(wz_str == ""){
			document.getElementById("wz_price"+rownum).value = 0;
		}
		document.getElementById("total_charge"+rownum).value= parseFloat(document.getElementById("wz_price"+rownum).value)*parseFloat(document.getElementById("asign_num"+rownum).value);
		recountTotalCharge();
	}
	function clearRepairList(index){
		var repair_type = document.getElementById("repairType").value;
		if(repair_type == '0100400027000000002'){//委外维修
			$("#zj0").hide();
			$("#zj1").show()
			$("#maintain").css("display","none");
			$("#out_maintain").css("display","block");
		}else{
			$("#zj0").show();
			$("#zj1").show()
			$("#maintain").css("display","block");
			$("#out_maintain").css("display","none");
		}
		$("tr","#assign_body").each(function(i){
			$(this).remove();
		});
	}
	function showDevAccountPage(){
		var returnValue = window.showModalDialog("<%=contextPath%>/dmsManager/safekeeping/selectBYAccount.jsp","","dialogWidth=1200px;dialogHeight=480px");			
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("@");
		var retObj = jcdpCallService("DevInfoConf", "getKeepingDev","dev_acc_id="+strs[0]);
			document.getElementById("dev_appdet_id").value=strs[0];
			document.getElementById("dev_name").value=retObj.data.dev_name;
			document.getElementById("dev_model").value=retObj.data.dev_model;
			document.getElementById("self_num").value=retObj.data.self_num;
			document.getElementById("license_num").value=retObj.data.license_num;
		
	}
	/**
	 * 使用情况下拉框变化事件，技术状况跟使用情况有关联
	 */
	function selectChange(){
		document.getElementById("tech_stat").options.length=0;
		if(document.getElementById("record_status").value=='0')
		{
			document.getElementById("tech_stat").options.add(new Option("在修","0110000006000000007"));
		}
		else{
			document.getElementById("tech_stat").options.add(new Option("完好","0110000006000000001"));
			document.getElementById("tech_stat").options.add(new Option("在修","0110000006000000007"));
			document.getElementById("tech_stat").options.add(new Option("待报废","0110000006000000005"));
		}
	}


</script>
</html>
 