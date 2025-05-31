<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%> 
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
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
  <title>强制保养</title> 
 </head>
<body style="background:#cdddef">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset><legend>强制保养记录</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>					    
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input  type ="hidden" id="repair_info" name="repair_info" value="<%=repair_info%>"/>
				<input id="dev_name" name="dev_name" class="input_width easyui-validatebox"  type="text" data-options="tipPosition:'top'" readonly required/>
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
			<td class="inquire_item6" ><font color=red>*</font>&nbsp;开始日期</td>
			<td class="inquire_form6"><input name="REPAIR_START_DATE" id="REPAIR_START_DATE" class="input_width easyui-datebox" type="text" style="width:137px" editable="false" required />
			</td>
			<td class="inquire_item6" ><font color=red>*</font>&nbsp;结束日期</td>
			<td class="inquire_form6"><input id="REPAIR_END_DATE" name="REPAIR_END_DATE" class="input_width easyui-datebox" type="text" style="width:137px" editable="false" required />
			</td>
		  </tr>					 	
	   	  <tr>		   
		    <td class="inquire_item6" >&nbsp;工时</td>
			<td class="inquire_form6"><input name="WORK_HOUR" id="WORK_HOUR" class="input_width easyui-validatebox" validType='intOrFloat' data-options=tipPosition:'bottom' type="text" required/></td>	
			<td class="inquire_item6" >工时费</td>
			<td class="inquire_form6"><input name="HUMAN_COST" id="HUMAN_COST" class="input_width easyui-validatebox" validType='intOrFloat' data-options=tipPosition:'bottom' type="text"  /></td>	
			<td class="inquire_item6" >本次保养行驶里程(公里)</td>
			<td class="inquire_form6"><input id="MILEAGE_TOTAL" name="MILEAGE_TOTAL" class="input_width easyui-validatebox" validType='intOrFloat' data-options=tipPosition:'bottom' type="text"  /></td>
		  </tr>
		   <tr>
			<td class="inquire_item6" >钻井进尺(米)</td>
			<td class="inquire_form6"><input name="DRILLING_FOOTAGE_TOTAL" id="DRILLING_FOOTAGE_TOTAL" class="input_width easyui-validatebox" validType='intOrFloat' data-options=tipPosition:'bottom' type="text"  /></td>
			<td class="inquire_item6" >工作小时(小时)</td>
			<td class="inquire_form6"><input id="WORK_HOUR_TOTAL" name="WORK_HOUR_TOTAL" class="input_width easyui-validatebox" validType='intOrFloat' data-options=tipPosition:'bottom' type="text" /></td>			
			<td class="inquire_item6" >材料费</td>
			<td class="inquire_form6"><input id="MATERIAL_COST" name="MATERIAL_COST" class="input_width easyui-validatebox" validType='intOrFloat' data-options=tipPosition:'bottom' type="text"  /></td>
		  </tr>
		   <tr>		 
			<td class="inquire_item6" >&nbsp;保养人</td>
			<td class="inquire_form6"><input name="REPAIRER" id="REPAIRER" class="input_width easyui-validatebox" type="text"  required/></td>
			  <td class="inquire_item6" >&nbsp;验收人</td>
			<td class="inquire_form6"><input id="ACCEPTER" name="ACCEPTER" class="input_width easyui-validatebox" type="text" required/></td>
		  </tr>	  
		   <tr>
		   <td class="inquire_item6" >保养内容</td>
			<td class="inquire_form6" colspan="3">
				<textarea id="REPAIR_DETAIL" name="REPAIR_DETAIL" rows="3" cols="60" class="textarea easyui-validatebox" required></textarea>
			</td>
			<select class="select_width"   name='repairType' id="repairType" value="" style="display:none;" >
					<option value="0110000037000000002">保养</option>
				</select>
				<select class="select_width"   name='repairItem' id="repairItem" value=""  style="display:none;">
					<option value="0110000038000000015">强制保养项目</option>
				</select>
		  </tr>
	  </table>  
	  </fieldset>	  
	  <fieldset><legend>保养项目</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  <input type="hidden" id="qzby_value" name="qzby_value"></input>
	  	<%
			String sql = " select d.coding_sort_id,d.coding_code_id,d.coding_name from COMM_CODING_SORT_DETAIL d where d.CODING_SORT_ID = '5110000159' and d.bsflag = '0' order by d.coding_code_id";
			
			 List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql); 
			 for (int i = 0; i < list.size(); i=i+3) {
				
				String codingName = "";
				String codingCodeId = "";
				String codingName2 = "";
				String codingCodeId2 = "";
				String codingName3 = "";
				String codingCodeId3 = "";				
		%>
		  <tr >
			<%if(i<list.size()){
				Map map = (Map)list.get(i);
				codingName = (String)map.get("codingName");
				codingCodeId = (String)map.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox"    id="qzby<%=codingCodeId%>"   name="qzby"    value="<%=codingCodeId%>"/> 
				<span id="nqzby<%=codingCodeId%>"> <%=codingName%> </span>  </br>
			</td>
			<%} 
			if(i+1<list.size()){
				Map map2 = (Map)list.get(i+1);
				codingName2 = (String)map2.get("codingName");
				codingCodeId2 = (String)map2.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox"    id="qzby<%=codingCodeId2%>"   name="qzby"    value="<%=codingCodeId2%>"/> 
				<span id="nqzby<%=codingCodeId2%>"> <%=codingName2%> </span>  </br>
			</td>
			<%} 
			if(i+2<list.size()){
				Map map3 = (Map)list.get(i+2);
				codingName3 = (String)map3.get("codingName");
				codingCodeId3 = (String)map3.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox"    id="qzby<%=codingCodeId3%>"   name="qzby"    value="<%=codingCodeId3%>"/> 
				<span id="nqzby<%=codingCodeId3%>"> <%=codingName3%> </span>  </br>
			</td>
			<%} %>
		  </tr>
		  <%} %>
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
		    	<auth:ListButton id="zj0" functionId="" css="zj" event="onclick='add(0)'" title="选择物资"></auth:ListButton>
		    	<auth:ListButton id="zj1" functionId="" css="zj" event="onclick='add(1)'" title="手工录入"></auth:ListButton>
		    	<auth:ListButton functionId="" css="sc" event="onclick='removrow()'" title="删除"></auth:ListButton>
			</tr>
		  </table>
	  </div>
	  <fieldset><legend>材料消耗明细</legend>
	  	<div style="height:105px;overflow:auto">
	  	<table id="educationMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
			  <tr style="display:block" id="maintain">  
			  	  <td class="bt_info_odd">选择</td>
				  <td class="bt_info_even">序号</td>
				  <td class="bt_info_even">材料名称</td>
				  <td class="bt_info_odd">材料编号</td>
				  <td class="bt_info_even">计量单位</td>
				  <td class="bt_info_odd">单价</td>
				  <td class="bt_info_odd">消耗数量</td>
				  <td class="bt_info_even">总价</td>				  
			  </tr>
			   <tr style="display:none" id="out_maintain">  
			  	  <td class="bt_info_odd" width="5%">选择</td>
				  <td class="bt_info_even" width="5%">序号</td>
				  <td class="bt_info_even" width="25%">材料名称</td>
				  <td class="bt_info_even" width="20%">单价</td>
				  <td class="bt_info_even" width="20%">消耗数量</td>
				  <td class="bt_info_odd" width="25%">总价</td>
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
	$().ready(function(){
		checkDate();
		//为必填项添加红星
		$("#form1").renderRequiredLabel();
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
		loadDataDet();
	});
	var dev_appdet_id='<%=dev_appdet_id%>';
	var repair_info='<%=repair_info%>';
	//提交
	function submitInfo(){
		if(formVilidate($("#form1"))){
			if(!checks()){	
				return false;
			}
			$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
		        if (data) {
		            $.messager.progress({title:'请稍后',msg:'数据保存中....'});
		    		$("#submitButton").attr({"disabled":"disabled"});
		    		//调配数量提交				
					var qzby_value = "";
					var qzby = document.getElementsByName("qzby");
						
					for(var j=0;j<qzby.length;j++){
						if(qzby[j].checked==true){
							if(qzby_value!=""){
								qzby_value += ",";
							}
							qzby_value += qzby[j].value;
						}
				 	}
		    		document.getElementById("qzby_value").value=qzby_value;
					document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveNewDeviceAccountRepairInfo.srq?state=9&ids="+dev_appdet_id;
					document.getElementById("form1").submit();
		         }
		    });
		}
	}
	//提交判断
	function checks(){
		var reg = new RegExp("^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$");
		if($("#DRILLING_FOOTAGE_TOTAL")[0].value==""&&$("#WORK_HOUR_TOTAL")[0].value==""&&$("#MILEAGE_TOTAL")[0].value==""){
			$.messager.alert("提示","行驶里程(公里)、钻井进尺(米)、工作小时(小时)三项中必须得有一项填写!","warning");
			$("#MILEAGE_TOTAL")[0].focus();
			return false;
		}
		var objssss=document.getElementsByName("rows");
		if(objssss.length>0){
			var temprow;
			for(var i=0;i<objssss.length;i++){
				temprow=document.getElementById("asign_num"+objssss[i].value);
				if(temprow.value==""){
					temprow.focus();
					$.messager.alert("提示","消耗数量不能为空!","warning");
					return false;
				}				
			}
		}
		return true;
	}
	function add(str){
		$("#maintain").css("display","none");
		$("#out_maintain").css("display","none");
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
			newTr.insertCell().innerHTML="<td><font color=red>*</font>&nbsp;<input type='text' id=wz_name"+rownum+" name=wz_name"+rownum+" value=''></td>";//材料名称
			newTr.insertCell().innerHTML="<td>&nbsp;<input type='text' id=wz_id"+rownum+" name=wz_id"+rownum+" value=''></td>";//材料编号
 			newTr.insertCell().innerHTML="<td>&nbsp;<input type='text' id=wz_prickie"+rownum+" name=wz_prickie"+rownum+" value=''></td>";//计量单位
			newTr.insertCell().innerHTML="<td><font color=red>*</font>&nbsp;<input type='text' id=wz_price"+rownum+" name=wz_price"+rownum+" value='0'></td>";//单价
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
			var sql="select d.coding_code_id from comm_coding_sort_detail d where d.coding_name='设备保养'";
			var devRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+"&pageSize=1000");
			var devdatas = devRet.datas;
			var devType = devdatas[0].coding_code_id;
			param.pageselectedstr = pageselectedstr;
			param.dev_acc_id = '<%=dev_appdet_id%>';
			var vReturnValue = window.showModalDialog('<%=contextPath%>/dmsManager/safekeeping/dev_work/selectQzbyMatList.jsp?devType='+devType,param,"dialogWidth=980px;dialogHeight=520px");
			if(vReturnValue != undefined){
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
					newTr.insertCell().innerHTML="<td>"+basedatas[i].wz_name+"<input type=hidden id=wz_name"+rownum+" name=wz_name"+rownum+" value='"+basedatas[i].wz_name+"'></td>";//材料名称
					newTr.insertCell().innerHTML="<td>"+basedatas[i].wz_id+"<input type=hidden id=wz_id"+rownum+" name=wz_id"+rownum+" value='"+basedatas[i].wz_id+"'></td>";//材料编号
					newTr.insertCell().innerHTML="<td>"+basedatas[i].wz_prickie+"<input type=hidden id=wz_prickie"+rownum+" name=wz_prickie"+rownum+" value='"+basedatas[i].wz_prickie+"'></td>";//计量单位
					newTr.insertCell().innerHTML="<td>"+basedatas[i].wz_price+"<input type=hidden id=wz_price"+rownum+" name=wz_price"+rownum+" value='"+basedatas[i].wz_price+"'></td>";//单价
					newTr.insertCell().innerHTML="<font color=red>*</font>&nbsp;<input type=text id=asign_num"+rownum+" name=asign_num"+rownum+" out_num="+basedatas[i].use_num+" value='' onkeyup='AutoCal(this,"+rownum+")'>";//消耗数量
					newTr.insertCell().innerHTML="<td><input  type='text' readonly='readonly' id='total_charge"+rownum+"' name='total_charge"+rownum+"' value=''></td>";//总价
					$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
					$("#assign_body>tr:odd>td:even").addClass("odd_even");
					$("#assign_body>tr:even>td:odd").addClass("even_odd");
					$("#assign_body>tr:even>td:even").addClass("even_even");
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
	//计算总价
	function recountTotalCharge(){		
		var totalcharge = 0;
		$("input[type='text'][id^='total_charge']").each(function(i){
			totalcharge += parseFloat(this.value);
		});
		$("#MATERIAL_COST").val(totalcharge);
	}
	//页面加载刷新
	function loadDataDet(){
		if(repair_info=="null"){
			if(dev_appdet_id!="null"){
				var querySql="select dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num Gms_Device_Account where dev_acc_id='"+dev_appdet_id+"'" ;
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
				basedatas = queryRet.datas;
				$("#dev_name")[0].value=basedatas[0].dev_name;
				$("#dev_model")[0].value=basedatas[0].dev_model;
				$("#self_num")[0].value=basedatas[0].self_num;
				$("#license_num")[0].value=basedatas[0].license_num;
			}
		}else{
			var querySql="select a.*,b.dev_name,b.dev_model,b.self_num,b.license_num from BGP_COMM_DEVICE_REPAIR_INFO a left join Gms_Device_Account b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id  where a.repair_info='"+repair_info+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			$("#WORK_HOUR")[0].value=basedatas[0].work_hour;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#REPAIR_START_DATE").datebox("setValue",basedatas[0].repair_start_date);
			$("#REPAIR_END_DATE").datebox("setValue",basedatas[0].repair_end_date);
			$("#HUMAN_COST")[0].value=basedatas[0].human_cost;
			$("#MILEAGE_TOTAL")[0].value=basedatas[0].mileage_total;
			$("#DRILLING_FOOTAGE_TOTAL")[0].value=basedatas[0].drilling_footage_total;
			$("#WORK_HOUR_TOTAL")[0].value=basedatas[0].work_hour_total;
			$("#MATERIAL_COST")[0].value=basedatas[0].material_cost;
			$("#REPAIRER")[0].value=basedatas[0].repairer;
			$("#ACCEPTER")[0].value=basedatas[0].accepter;
			$("#REPAIR_DETAIL")[0].value=basedatas[0].repair_detail;
			var querySql="select * from BGP_COMM_DEVICE_REPAIR_DETAIL d left join gms_mat_infomation i on d.material_coding=i.wz_id  where d.repair_info ='"+repair_info+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			
			edit(basedatas);
			searchRepairItem();
		}		
	}		
	function searchRepairItem(){
		var queryRet = null;
		var datas =null;		
		//手持机传的数据，是没有选中的选项存在表中
		querySql = "select * from BGP_COMM_DEVICE_REPAIR_TYPE t where t.repair_info='"+repair_info+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+encodeURI(encodeURI(querySql)));
 
		datas = queryRet.datas;
		if(datas != null&&datas!=""){		 
			var qzby = document.getElementsByName("qzby");
			for(var j=0;j<qzby.length;j++){
				for(var i=0;i<datas.length;i++){
		  			if(qzby[j].value == datas[i].type_id){	
		  				qzby[j].checked=true;
		  			}
			 	}
			}	    		 
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
			
			newTr.insertCell().innerHTML="<input type=checkbox><input type=hidden name=rows id=rows"+rownum+" value="+rownum+">";
			newTr.insertCell().innerHTML="<td>"+(rownum+1)+"</td>";//序号
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_name+"<input type=hidden id=wz_name"+rownum+" name=wz_name"+rownum+" value='"+basedatas[i].material_name+"'></td>";//材料名称
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_coding+"<input type=hidden id=wz_id"+rownum+" name=wz_id"+rownum+" value='"+basedatas[i].material_coding+"'></td>";//材料编号
			newTr.insertCell().innerHTML="<td>"+basedatas[i].material_unit+"<input type=hidden id=wz_prickie"+rownum+" name=wz_prickie"+rownum+" value='"+basedatas[i].material_unit+"'></td>";//计量单位
			newTr.insertCell().innerHTML="<td>"+basedatas[i].unit_price+"<input type=hidden id=wz_price"+rownum+" name=wz_price"+rownum+" value='"+basedatas[i].unit_price+"'></td>";//单价
			newTr.insertCell().innerHTML="<font color=red>*</font>&nbsp;<input type=text id=asign_num"+rownum+" name=asign_num"+rownum+"  value='"+basedatas[i].material_amout+"' onkeyup='AutoCal(this,"+rownum+")'>";//消耗数量
			newTr.insertCell().innerHTML="<input type='text' readonly='readonly' id='total_charge"+rownum+"' value='"+basedatas[i].total_charge+"' name='total_charge"+rownum+"'>";//总价
			$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
			$("#assign_body>tr:odd>td:even").addClass("odd_even");
			$("#assign_body>tr:even>td:odd").addClass("even_odd");
			$("#assign_body>tr:even>td:even").addClass("even_even");
		}
	}
	//判断数据有效性
	function AutoCal(obj,rownum){
		var value = obj.value;
		var re = /^\+?[0-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			$.messager.alert("提示","数量必须为数字!","warning");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(value,10)>parseInt(obj.out_num)){
				$.messager.alert("提示","消耗数量必须小于等于出库数量!","warning");
				obj.value = "";
				document.getElementById("total_charge"+rownum).value= "";
				return false;
			}
		}
		var wz_str = document.getElementById("wz_price"+rownum).value;
		if(wz_str == ""){
			document.getElementById("wz_price"+rownum).value = 0;
		}
		document.getElementById("total_charge"+rownum).value= parseFloat(document.getElementById("wz_price"+rownum).value)*parseFloat(document.getElementById("asign_num"+rownum).value);
		recountTotalCharge();
	}
	//选择保养设备
	function showDevAccountPage(){
		var returnValue = window.showModalDialog("<%=contextPath%>/dmsManager/safekeeping/dev_work/selectQzbyAccount.jsp","","dialogWidth=1200px;dialogHeight=480px");	
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("@"); //字符分割
		//document.getElementById("dev_num").value = strs[6];
		//document.getElementById("dev_type").value = strs[7];
		var retObj = jcdpCallService("DevInfoConf", "getKeepingDev","dev_acc_id="+strs[0]);
		document.getElementById("dev_appdet_id").value=retObj.data.dev_acc_id;
		document.getElementById("dev_name").value=retObj.data.dev_name;
		document.getElementById("dev_model").value=retObj.data.dev_model;
		document.getElementById("self_num").value=retObj.data.self_num;
		document.getElementById("license_num").value=retObj.data.license_num;
	}
	//日期判断
	function checkDate(){
		//检查时间
		$(".easyui-datebox").datebox({
			onSelect: function(){
				var	startTime = $("#REPAIR_START_DATE").datebox('getValue');
				var	endTime = $("#REPAIR_END_DATE").datebox('getValue');
				if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
					var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
					if(days<0){
						$.messager.alert("提示","竣工日期应大于送修日期!","warning");
						$("#REPAIR_END_DATE").datebox("setValue","");
					}			
				}
			}
		});
		//禁止日期框手动输入
		$(".datebox :text").attr("readonly","readonly");
	}
</script>
</html>
 