<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String company_id=request.getParameter("company_id");
	if(null==company_id){
		company_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<style type="text/css">
</style>
<title>企业基本信息</title>
</head>

<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
     <fieldset style="margin:2px;padding:2px;"><legend>企业基本信息</legend>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	  <tr style="text-align: left">
		  <td class="inquire_item4" width="10%" style="text-align: center;">&nbsp;企业名称:</td>
		  <td width="30%" ><input name="enterprise_name" id="enterprise_name" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
		  <td class="inquire_item4" width="10%" style="text-align: center;">&nbsp;法定代表人:</td>
		  <td><input name="legal_person" id="legal_person" class="input_width easyui-validatebox main" type="text"  data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	  </tr>
	  <tr>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;通讯地址:</td>
		  <td><input name="company_address" id="company_address" class="input_width easyui-validatebox main" type="text" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;邮编:</td>
		  <td><input name="postalcode" id="postalcode" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,6]'" maxlength="6" required onkeyup="javascript:RepNumber(this)"/></td>
	  </tr>
	  <tr>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;企业类型:</td>
		  <td><input name="company_type" id="company_type" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;注册资本(万元):</td>
		  <td><input name="registered_capital" id="registered_capital"  type="text" value="" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" required  onkeyup="javascript:RepNumber(this)" /></td>
	  </tr>
	  <tr>
		  <td class="inquire_item4" style="text-align: center;" >&nbsp;生产能力:</td>
		  <td><input name="production_capactity" id="production_capactity"  class="input_width easyui-validatebox main" data-options="validType:'length[0,50]'" maxlength="50" type="text" value="" required onkeyup="javascript:RepNumber(this)"/></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;职工总数(人):</td>
		  <td><input name="work_force" id="work_force" class="input_width easyui-validatebox main" data-options="validType:'length[0,50]'" maxlength="50" required onkeyup="javascript:RepNumber(this)"/></td>
	  </tr>
	  <tr>
		 <td class="inquire_item4" style="text-align: center;">&nbsp;上年总产值(万元):</td>
		  <td><input name="lastyear_total_value" id="lastyear_total_value" class="input_width easyui-validatebox main" data-options="validType:'length[0,50]'" maxlength="50" required /></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;固定资产:</td>
		  <td><input name="fixed_assets" id="fixed_assets" class="input_width easyui-validatebox main" data-options="validType:'length[0,50]'" maxlength="50" required onkeyup="javascript:RepNumber(this)"/></td>
	  </tr>
	  <tr>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;联系人:</td>
		  <td><input name="linkman" id="linkman" class="input_width easyui-validatebox main" data-options="validType:'length[0,30]'" maxlength="30" required /></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;联系电话:</td>
		  <td><input name="linkman_phone" id="linkman_phone" class="input_width easyui-validatebox main" data-options="validType:'length[0,11]'" maxlength="11" required onkeyup="javascript:RepNumber(this)"/></td>
	  </tr>
	  <tr>
		  <td class="inquire_item4" style="text-align: center;" >&nbsp;供应商编码:</td>
		  <td><input name="companycode" id="companycode" class="input_width easyui-validatebox main"    required onkeyup="javascript:RepNumber(this)"/></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;体系管理认证标准、时间:</td>
		  <td><input type="text" name="sgs_date" id="sgs_date" value="<%=appDate %>" class="input_width easyui-datebox main" style="width:258px" required/></td>
	  </tr>
	   <tr>
		  <td class="inquire_item4" style="text-align: center;" >&nbsp;手机:</td>
		  <td><input name="cellphone" id="cellphone" class="input_width easyui-validatebox main" data-options="validType:'length[0,11]'" maxlength="11" required onkeyup="javascript:RepNumber(this)"/></td>
		 
	  </tr>
	  <tr>
   		<td class="inquire_item4" width="5%" style="text-align: center;">&nbsp;企业简介:</td>
   		<td colspan="2" class="inquire_form4"><textarea id="enterprise_info" name="enterprise_info"  class="input_width easyui-textarea easyui-validatebox main" style="width:100%;height:40px" data-options="validType:'length[0,250]'" maxlength="250" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
	  </tr>
	  </table>
	  
	   <fieldset style="margin:2px;padding:2px;">
	   <h5 align="center"><font size="15px" style="text-align: center; font-size: 15px">主要人员情况</font></h5>
    	 <table  style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable">
			<tr>
				<td width="10%" class="ali_btn" style="position: center;">
					<span class="zj"><a href="javascript:void(0);" onclick="insertTr()" title="添加"></a></span>
				</td>
				<td width="2%">序号</td>
				<td width="14%">姓名</td>
				<td width="14%">性别</td>
				<td width="14%">年龄</td>
				<td width="14%">职务职称</td>
				<td width="14%">学历</td>
				<td width="14%">所学专业</td>
				<td width="14%">固定/聘用</td>
			</tr>
		</table>
      </fieldset>
       
	  <div id="oper_div" style="text-align: right;">
     	<span class="bc_btn"><a href="####" id="submitButton" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
   	  </div>
</div>
</div>
</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
 	cruConfig.queryStr = ""; 
	cruConfig.queryService = "ModelApply";
	var flag="<%=flag%>";
	var company_id= "<%=company_id%>";
	$().ready(function(){
		//禁止日期框手动输入
		$("#sgs_date").datebox({
			editable: false
        });
	});
	
	function RepNumber(obj) {
        var reg = /^[\d]+$/g;
         if (!reg.test(obj.value)) {
             var txt = obj.value;
             txt.replace(/[^0-9]+/, function (char, index, val) {//匹配第一次非数字字符
                obj.value = val.replace(/\D/g, "");//将非数字字符替换成""
                var rtextRange = null;
                if (obj.setSelectionRange) {
                    obj.setSelectionRange(index, index);
                } else {//支持ie
                    rtextRange = obj.createTextRange();
                    rtextRange.moveStart('character', index);
                    rtextRange.collapse(true);
                    rtextRange.select();
                }
            })
         }
     }
	function checkLength(obj,maxlength){
	    if(obj.value.length > maxlength){
	        obj.value = obj.value.substring(0,maxlength);
	    }
	}
	
	$(function(){
		if("update"==flag){
			var retObj = jcdpCallService("EquipmentSelectionApply", "getEnterpriseInfo", "company_id="+company_id);
			if(typeof retObj.str!="undefined"){
				var data = retObj.str;
				$("#enterprise_name").val(data.enterprise_name);
				$("#legal_person").val(data.legal_person);
				$("#company_address").val(data.company_address);
				$("#postalcode").val(data.postalcode);
				$("#company_type").val(data.company_type);
				$("#registered_capital").val(data.registered_capital); 
				$("#production_capactity").val(data.production_capactity);
				$("#work_force").val(data.work_force);
				$("#lastyear_total_value").val(data.lastyear_total_value);
				$("#fixed_assets").val(data.fixed_assets);
				$("#linkman").val(data.linkman);
				$("#linkman_phone").val(data.linkman_phone);
				$("#cellphone").val(data.cellphone);	
				$("#sgs_date").datebox("setValue", data.sgs_date);
				$("#enterprise_info").val(data.enterprise_info);
				$("#companycode").val(data.company_code);
			}
			if(typeof retObj.deviceappMap!="undefined"){
				var datas = retObj.deviceappMap;
				for(var i=0;i<datas.length;i++){
					var ts=insertTr("old");
					var data=datas[i];
					$.each(data, function(k, v){
						if(null!=v && ""!=v){
							$("#itemTable #"+k+"_"+ts).val(v);
						}
					});
				}
				orader=datas.length;
			}
			if(typeof retObj.strMap!="undefined"){
				var datass = retObj.strMap;
				for(var i=0;i<datass.length;i++){
					var ts=insertTr2("old");
					var data=datass[i];
					$.each(data, function(k, v){
						if(null!=v && ""!=v){
							$("#itemTable2 #"+k+"_"+ts).val(v);
						}
					});
				}
				oraders=datass.length;
			}
		}
	});

	
	
	//指标项序号
	var order = new Date().getTime();
	var orderss = 0;
	var orders = 0;
	//添加指标项行
	function insertTr(old){
		orderss++;
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr1_"+orderss+"' class='old' tempindex='"+orderss+"'>";
		}else{
			temp +="<tr id='tr1_"+orderss+"' class='new' tempindex='"+orderss+"'>";
		}
		temp =temp + ("<td><input name='company_personnel_id_"+order+"' id='company_personnel_id_"+order+"' value='000' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this)'/></td>" +
		"<td>"+orderss+"</td> "+
		"<td><input name='name_"+order+"' id='name_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,10]'\" size='10' maxlength='10' required/></td>"+
		"<td><select  class='easyui-combobox' name='sex_"+order+"' id='sex_"+order+"' style='width:80px;'>"+
			 " <option value ='0' >男</option>"+
			 " <option value ='1' >女</option>"+
			"</select>"+
		"</td>"+
		"<td><input name='age_"+order+"' id='age_"+order+"' type='text' style='height:20px;width:90%;' type='text' value='' class='input easyui-validatebox main'  data-options=\"validType:'length[0,4]'\" onkeyup=\"javascript:RepNumber(this)\" size='4' maxlength='4' required /></td>"+
		"<td><input name='job_title_"+order+"' id='job_title_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30' required/></td>"+
		"<td><select  class='easyui-combobox' name='education_"+order+"' id='education_"+order+"' style='width:80px;'>"+
			 " <option value ='0'>初中</option>"+
			 " <option value ='1'>高中</option>"+
			 " <option value ='2'>专科</option>"+
			 " <option value ='3'>本科</option>"+
			 " <option value ='4'>硕士</option>"+
			 " <option value ='5'>博士</option>"+
			"</select>"+
		"</td>"+
		
		"<td><input name='major_"+order+"' id='major_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30' required /></td>"+
		"<td><select  class='easyui-combobox' name='job_type_"+order+"' id='job_type_"+order+"' style='width:80px;'>"+
			 " <option value ='0' >固定</option>"+
			 " <option value='1' >聘用</option>"+
			"</select>"+
		"</td>"+
		"</tr>");
		
		$("#itemTable").append(temp);
		return order++; 
	}
	
	function insertTr2(old){
		orders++;
		var temps = "";
		if(old=="old"){
			temps +="<tr id='tr_"+orders+"' class='old' tempindex='"+orders+"'>";
		}else{
			temps +="<tr id='tr_"+orders+"' class='new' tempindex='"+orders+"'>";
		}																	   
		temps =temps + ("<td><input name='enterprise_equipment_id_"+order+"' id='enterprise_equipment_id_"+order+"'  value='000' type='hidden'/><input name='item_order_"+order+"' id='item_order_"+order+"' value='222' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr2(this)'/></td>" +
		"<td>"+orders+"</td> "+
		"<td><input name='device_name_"+order+"' id='device_name_"+order+"' type='text' value='' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50' required/></td>"+
		"<td><input name='model_"+order+"' id='model_"+order+"' type='text' value='' style='height:20px;width:80%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50' required/>"+
  		"<td><input name='vender_"+order+"' id='vender_"+order+"' type='text' value='' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50' required/></td>"+
  		"<td><input name='running_state_"+order+"' id='running_state_"+order+"' type='text' value='' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50' required/></td>"+
		"</tr>");
		$("#itemTable2").append(temps);
		return order++; 
	}
	//删除指标项行
	function deleteTr(item){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var itemId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr_"+tts+"' value='"+itemId+"'/>");
		}
		 if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("EquipmentSelectionApply", "deleteUpdatePeople", "company_personnel_id="+itemId);				
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						//删除行
						//$(item).parent().parent().remove();
						//获取行id
						var temp = $(item).parent().parent().attr("id");
						//删除行
						$(item).parent().parent().remove();
						//序号重新排序
						var _index = parseInt(temp.split("_")[1]);
						for(var j=_index;j<orderss;j++){
							//给隐藏域序号赋值
							$("#tr1_"+(j+1)).children().eq(0).children().eq(1).val(j);
							//给序号赋值
							var order_td = $("#tr1_"+(j+1)).children().eq(1);
							order_td.html(j);
							//给tr 属性 赋值
							$("#tr1_"+(j+1)).attr("id","tr1_"+j);
						}
						//索引减一
						orderss=orderss-1;
						queryData(cruConfig.currentPage);
					}
				}
			} 
		}
		
	}
	
	//删除指标项行
	function deleteTr2(item2){
		//页面修改时要处理的操作
		if($(item2).parent().parent().attr("class")=="old"){
			var itemId = $(item2).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr2_"+tts+"' value='"+itemId+"'/>");
		}
		 if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("EquipmentSelectionApply", "deleteUpdateEquipment", "enterprise_equipment_id="+itemId);				
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						//删除行
						//$(item2).parent().parent().remove();
						//索引减一
						//orders=orders-1;
						//获取行id
						var temps = $(item2).parent().parent().attr("id");
						//删除行
						$(item2).parent().parent().remove();
						//序号重新排序
						var _index = parseInt(temps.split("_")[1]);
						for(var j=_index;j<orders;j++){
							//给隐藏域序号赋值
							$("#tr_"+(j+1)).children().eq(0).children().eq(1).val(j);
							//给序号赋值
							var order_td = $("#tr_"+(j+1)).children().eq(1);
							order_td.html(j);
							//给tr 属性 赋值
							$("#tr_"+(j+1)).attr("id","tr_"+j);
						}
						//索引减一
						orders=orders-1;
						queryData(cruConfig.currentPage);
					}
				}
			}
		}
		
	}
	
	
	// 保存
	function saveInfo(){
		var enterprise_name = $.trim($("#enterprise_name").val());
		if(enterprise_name.length<=0){
			$.messager.alert("提示","企业名称不能为空!");
			return;
		}	  
		var legal_person = $.trim($("#legal_person").val());
		if(legal_person.length<=0){
			$.messager.alert("提示","法定代表人不能为空!");
			return;
		}	  
		var company_address = $.trim($("#company_address").val());
		if(company_address.length<=0){
			$.messager.alert("提示","通讯地址不能为空!");
			return;
		}
		var postalcode = $.trim($("#postalcode").val());
		if(postalcode.length<=0){
			$.messager.alert("提示","邮编不能为空!");
			return;
		}
		var company_type = $.trim($("#company_type").val());
		if(company_type.length<=0){
			$.messager.alert("提示","企业类型不能为空!");
			return;
		}
		var registered_capital = $.trim($("#registered_capital").val());
		if(registered_capital.length=0){
			$.messager.alert("提示","注册资本不能为空!");
			return;
		}
		var production_capactity = $.trim($("#production_capactity").val());
		if(production_capactity.length<=0){
			$.messager.alert("提示","生产能力不能为空!");
			return;
		}
		var work_force = $.trim($("#work_force").val());
		if(work_force.length<=0){
			$.messager.alert("提示","职工总数不能为空!");
			return;
		}
		var lastyear_total_value = $.trim($("#lastyear_total_value").val());
		if(lastyear_total_value.length<=0){
			$.messager.alert("提示","上年总产值不能为空!");
			return;
		}
		var fixed_assets = $.trim($("#fixed_assets").val());
		if(fixed_assets.length<=0){
			$.messager.alert("提示","固定资产不能为空!");
			return;
		}
		var postalcode = $.trim($("#postalcode").val());
		if(postalcode.length<=0){
			$.messager.alert("提示","邮编不能为空!");
			return;
		}
		var linkman = $.trim($("#linkman").val());
		if(linkman.length<=0){
			$.messager.alert("提示","联系人不能为空!");
			return;
		}
		var linkman_phone = $.trim($("#linkman_phone").val());
		if(linkman_phone.length<=0){
			$.messager.alert("提示","联系电话不能为空!");
			return;
		}
		var cellphone = $.trim($("#cellphone").val());
		if(cellphone.length<=0){
			$.messager.alert("提示","手机不能为空!");
			return;
		}
		var sgs_date = $.trim($("#sgs_date").val());
		if(sgs_date.length<=0){
			$.messager.alert("提示","体系管理认证标准、时间不能为空!");
			return;
		}
		var enterprise_info = $.trim($("#enterprise_info").val());
		if(enterprise_info.length<=0){
			$.messager.alert("提示","企业简介不能为空!");
			return;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/equipmentInfo.srq?flag="+flag+"&company_id="+company_id;
    			document.getElementById("form1").submit();
            }
        });
	}
</script>
</html>

