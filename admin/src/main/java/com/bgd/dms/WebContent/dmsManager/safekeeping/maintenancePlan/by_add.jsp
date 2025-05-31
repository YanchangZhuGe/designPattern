<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_appdet_id = request.getParameter("ids");
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String devAccId=request.getParameter("devAccId");
	if(null==devAccId){
		devAccId="";
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
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
				<input id="dev_name" name="dev_name" class="easyui-validatebox main"  type="text" readonly/>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevAccountPage()"  />
				<input id="fk_dev_acc_id" name="fk_dev_acc_id" type ="hidden" class ="main" />
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="easyui-validatebox main" type="text" readonly/></td>
		  </tr>
		  <tr>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="easyui-validatebox main" type="text" readonly/>
			</td>
			<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="easyui-validatebox main" type="text" readonly /></td>
		  </tr>
		   <tr>
		   	<td class="inquire_item6">实物标识号</td>
			<td class="inquire_form6"><input name="dev_sign" id="dev_sign"  class="easyui-validatebox main" type="text" readonly /></td>
			<td class="inquire_item6">ERP设备编号</td>
			<td class="inquire_form6">
				<input id="dev_coding" name="dev_coding"  class="easyui-validatebox main" type="text" readonly/>
			</td>
		  </tr>
		  </table>
		  </fieldset>
		  <fieldset><legend>运转记录</legend>
		  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
		 	 <td class="inquire_item6">上次保养时间</td>
			<td class="inquire_form6">
				<input id="last_date" name="last_date"  class="easyui-validatebox main" type="text" readonly/></td>
			<td class="inquire_item6">累计里程(公里)</td>
			<td class="inquire_form6">
				<input id="mileage" name="mileage"  class="easyui-validatebox main" type="text" readonly/></td>
			<td class="inquire_item6">累计钻井进尺(米)</td>
			<td class="inquire_form6">
				<input id="drilling_footage" name="drilling_footage"  class="easyui-validatebox main" type="text" readonly/>	
			</td>
		  </tr>
		  <tr>
		  	<td class="inquire_item6">累计工作小时(小时)</td>
			<td class="inquire_form6"><input id="work_hour" name="work_hour"  class="easyui-validatebox main" type="text" readonly/></td>
		  </tr>
		  
	  </table>
	  </fieldset>
	  <fieldset style="margin:2px;padding:2px;"><legend>保养时间</legend>
        <table style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable">
			<tr>
			  <td width="10%" class="ali_btn">
				<span class="zj"><a href="javascript:void(0);" onclick="insertTr()" title="添加"></a></span>
			  </td>
			  <td width="10%">序号</td>
			  <td width="30%">保养时间</td>
			  <td width="30%">累计里程(公里)</td>
			  <td width="30%">累计工作小时(小时)</td>
			</tr>
		</table>
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
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form1';
	var flag = "<%=flag%>";
	var devAccId = "<%=devAccId%>";

	//页面初始化调用方法
	$(function(){
		if("update"==flag){
			var retObj = jcdpCallService("DevMaintainList", "getMaintainInfo", "devAccId="+devAccId);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
				});
			}
			if(typeof retObj.datas!="undefined"){
				var datas = retObj.datas;
				for(var i=0;i<datas.length;i++){
					var ts=insertTr("old");
					var data=datas[i];
					$.each(data, function(k, v){
						if(null!=v && ""!=v){
							$("#itemTable #"+k+"_"+ts).val(v);
						}
						if(k=='plan_date'){
							$("#itemTable #"+k+"_"+ts).datebox("setValue", v);
						}
					});
				}
			}
		}
	});

	//提交保存
	function submitInfo(){
		//保留的行信息
		var dev_name = $.trim($("#dev_name").val());
		var fk_dev_acc_id = $.trim($("#fk_dev_acc_id").val());
		if(dev_name.length<=0){
			$.messager.alert("提示","请选择设备!","warning");
			return;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
	        	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
				$("#submitButton").attr({"disabled":"disabled"});
				document.getElementById("form1").action = "<%=contextPath%>/dmsManager/safekeeping/saveDeviceAccMaintenancePlan.srq";
				document.getElementById("form1").submit();
	        }
	    });
	}

	//设备树
	function showDevAccountPage(){
		var returnValue = window.showModalDialog("<%=contextPath%>/dmsManager/safekeeping/selectBYAccount.jsp","","dialogWidth=1200px;dialogHeight=480px");			
		var strs= new Array(); //定义一数组
		debugger;
		if(!returnValue){
			return;
		}
		strs = returnValue.split("@"); //字符分割
		document.getElementById("fk_dev_acc_id").value = strs[0];
		var retObj = jcdpCallService("DevInfoConf", "getKeepingDev","dev_acc_id="+strs[0]);
		document.getElementById("license_num").value = retObj.data.license_num;
		document.getElementById("self_num").value = retObj.data.self_num;
		document.getElementById("dev_name").value = retObj.data.dev_name;
		document.getElementById("dev_model").value = retObj.data.dev_model;
		document.getElementById("dev_sign").value = retObj.data.dev_sign;
		document.getElementById("dev_coding").value = retObj.data.dev_coding;
		
		if(returnValue!=undefined){
			loadDataDetail(strs[0]);
		}
		
	}
	
	function loadDataDetail(devAccId){
		var retObj = jcdpCallService("DevMaintainList", "getMaintainInfo", "devAccId="+devAccId);
		if(typeof retObj.data!="undefined"){
			var data = retObj.data;
			$(".main").each(function(){
				var temp = this.id;
				$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
			});
		}

		if(typeof retObj.datas!="undefined"){
			var datas = retObj.datas;
			for(var i=0;i<datas.length;i++){
				var ts=insertTr("old");
				var data=datas[i];
				$.each(data, function(k, v){
					if(null!=v && ""!=v){
						$("#itemTable #"+k+"_"+ts).val(v);
					}
					if(k=='plan_date'){
						$("#itemTable #"+k+"_"+ts).datebox("setValue", v);
					}
				});
			}
		}
	}
	
	//指标项序号
	var order = 0;
	//添加指标项行
	function insertTr(old){
		var dev_name = $.trim($("#dev_name").val());
		if(dev_name.length<=0){
			$.messager.alert("提示","请选择设备!","warning");
			return;
		}
		order++;
		var timestamp=new Date().getTime();//获取时间戳
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+order+"' class='old' tempindex='"+timestamp+"'>";
		}else{
			temp +="<tr id='tr_"+order+"' class='new' tempindex='"+timestamp+"'>";
		}
		temp =temp + ("<td><input name='maintenance_id_"+timestamp+"' id='maintenance_id_"+timestamp+"' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this)'/></td>" +
		"<td>"+order+"</td> "+
		"<td><input name='plan_date_"+timestamp+"' id='plan_date_"+timestamp+"' type='text' style='height:20px;width:150%;' class='easyui-datebox' editable='false' required/></td>"+
		"<td><input name='mileage_"+timestamp+"' id='mileage_"+timestamp+"' type='text' style='height:20px;width:90%;'  maxlength='50' /></td>"+
		"<td><input name='work_hour_"+timestamp+"' id='work_hour_"+timestamp+"' type='text' style='height:20px;width:90%;'  maxlength='50'/></td>"+
		"</tr>");
		var targetObj = $(temp);
	    $.parser.parse(targetObj);
	    $("#itemTable").append(targetObj);
		return timestamp; 
	}
	//删除指标项行
	function deleteTr(item){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var itemId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr_"+tts+"' value='"+itemId+"'/>");
		}
		//获取行id
		var temp = $(item).parent().parent().attr("id");
		//删除行
		$(item).parent().parent().remove();
		//序号重新排序
		var _index = parseInt(temp.split("_")[1]);
		for(var j=_index;j<order;j++){
			//给隐藏域序号赋值
			$("#tr_"+(j+1)).children().eq(0).children().eq(1).val(j);
			//给序号赋值
			var order_td = $("#tr_"+(j+1)).children().eq(1);
			order_td.html(j);
			//给tr 属性 赋值
			$("#tr_"+(j+1)).attr("id","tr_"+j);
		}
		//索引减一
		order=order-1;
	}
	
</script>
</html>
 