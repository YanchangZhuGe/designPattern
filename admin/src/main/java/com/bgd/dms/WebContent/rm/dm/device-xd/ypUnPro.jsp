<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String oil_info_id=request.getParameter("oil_info_id");
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
  <title>油水记录</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" >
  <div id="new_table_box_content">
    <div id="new_table_box_bg" >
      <fieldset><legend>油水记录</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="PROJECT_NAME" name="PROJECT_NAME"  class="input_width" type="text" readonly/>
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input id="oil_info_id" name="oil_info_id" type ="hidden" value="<%=oil_info_id%>"/>
				
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
			</td>
		  </tr>
		  <tr>
		 	
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
		    <td class="inquire_item6">加注日期</td>
			<td class="inquire_form6">
				<input id="FILL_DATE" name="FILL_DATE"  class="input_width" type="text" readonly/>
				<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(FILL_DATE,tributton3);"/>
			</td>
		  </tr>
		  <tr>
			<td class="inquire_item6">油水名称</td>
			<td class="inquire_form6">
				<code:codeSelect cssClass="select_width"   name='OIL_NAME' option="OIL_NAME" selectedValue=""  addAll="true" onchange="getOILMODEL(this)"/>
			</td>
			<td class="inquire_item6">油水型号</td>
			<td class="inquire_form6">
				<select id="OIL_MODEL" name="OIL_MODEL" class="select_width">
					<option value="">--请选择--</option>
				</select>
			</td>
		  </tr>
		  <tr>
		  	<td class="inquire_item6">单位</td>
		  	<td class="inquire_form6">
<%-- 			<code:codeSelect  cssClass="select_width"   name='OIL_UNIT' option="OIL_UNIT" selectedValue=""  addAll="true" /> --%>
				<select name='OIL_UNIT' id='OIL_UNIT' class="select_width" type="text">
					
				</select>
			</td>
			<td class="inquire_item6">数量</td>
			<td class="inquire_form6">
				<input id="OIL_QUANTITY" name="OIL_QUANTITY" value="0"  class="input_width" type="text" onkeyup="techAutoCal(this)"/>
				<input id="killo_oil_quantity" name="killo_oil_quantity" value="0"  class="input_width" type="hidden"/>
			</td>
		  </tr>
		  <tr>
		  	<td class="inquire_item6">单价</td>
			<td class="inquire_form6">
			<input name="OIL_UNIT_PRICE" id="OIL_UNIT_PRICE" value="0"  class="input_width" type="text" onkeyup="techAutoCal(this)" />
			</td>
			<td class="inquire_item6">金额</td>
			<td class="inquire_form6">
			<input name="OIL_TOTAL" id="OIL_TOTAL" value="0"  class="input_width" type="text"  />
			</td>
			
		  </tr>
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
	var oil_info_id='<%=oil_info_id%>';
	var oiltype="";
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	
	function submitInfo(){
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/bgpCommDeviceOilInfo.srq?state=9&ids="+dev_appdet_id+"&oiltype="+oiltype;
			document.getElementById("form1").submit();
		}
	}

	function loadDataDetail(){
		
		if(oil_info_id=="null"){
			var querySql="select dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,tech_stat,asset_value,net_value,case account_stat when '0' then '账内' when '1' then '账外' else '外租' end as stat_desc from gms_device_account_unpro b  where dev_acc_id='"+dev_appdet_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
		
		}else{
			var querySql="select a.*,b.dev_name,b.dev_model,b.self_num,b.license_num,b.owning_org_name,b.usage_org_name,b.tech_stat from BGP_COMM_DEVICE_OIL_INFO a left join gms_device_account_unpro b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id   where a.oil_info_id='"+oil_info_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#FILL_DATE")[0].value=basedatas[0].fill_date;
			$("#OIL_NAME")[0].value=basedatas[0].oil_name;
			getOILMODEL($("#OIL_NAME")[0]);
			$("#OIL_MODEL")[0].value=basedatas[0].oil_model;
			$("#OIL_UNIT")[0].value=basedatas[0].oil_unit;
			$("#OIL_QUANTITY")[0].value=basedatas[0].oil_quantity;
			$("#OIL_UNIT_PRICE")[0].value=basedatas[0].oil_unit_price;
			$("#OIL_TOTAL")[0].value=basedatas[0].oil_total;
		}
			
	}
	function  getOILMODEL(obj){
		var obj1=$("#OIL_MODEL");
		var obj2=$("#OIL_UNIT");
		obj2[0].options.length=0;
		if(obj.value=="0110000043000000001"||obj.value=="0110000043000000002"){
			obj2[0].options.add(new Option("升","升"));
		}
		else{
			obj2[0].options.add(new Option("公斤","公斤"));
		}
		if(obj.value=="0110000043000000001"){
			oiltype=obj.value;
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400025' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--",""));  
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
			
		}else if(obj.value=="0110000043000000002" ){
			oiltype=obj.value;
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400026' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--","")); 
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
			
		}else{
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400040' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--",""));  
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
		}
	}
	function techAutoCal(obj){
		
		valimation(obj);
		document.getElementById("OIL_TOTAL").value =  parseFloat(document.getElementById("OIL_QUANTITY").value)*parseFloat(document.getElementById("OIL_UNIT_PRICE").value);
		var obj1=$("#OIL_NAME");
		if(obj1[0].value=="0110000043000000001"){
			
		
			document.getElementById("killo_oil_quantity").value =  parseFloat(document.getElementById("OIL_QUANTITY").value)*0.75;
		}
		else if(obj1[0].value=="0110000043000000002"){
			document.getElementById("killo_oil_quantity").value =  parseFloat(document.getElementById("OIL_QUANTITY").value)*0.85;
		}
	}
	function valimation(obj){
// 		var value = obj.value;
// 		var re = /^\+?[0-9][0-9]*$/;
// 		if(value=="")
// 			return;
// 		if(!re.test(value)){
// 			alert("数量必须为数字!");
// 			obj.value = "0";
//         	return false;
// 		}
		
		var value = obj.value;
		if(value==""){
			value=0;
		}
		if(!(/[\d.]/.test(value))){
			alert("数量必须为数字!");
			obj.value = "0";
        	return false;
		}

		if (isNaN(value)) 
		{alert("不法字符！"); 
		obj.value="0";
		}
	}
</script>
</html>
 