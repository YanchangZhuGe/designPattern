<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	//预测及分布表id
	String marketId = request.getParameter("marketId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/dmsManager/plan/yearPlan/panel.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<%-- <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script> --%>
	<title>设备信息</title>
</head>

<body style="background:#cdddef">
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/plan/yearPlan/saveOrUpdateMarketDeviceInfo.srq">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="保存"></auth:ListButton>
								<auth:ListButton functionId="" css="gb" event="onclick='toClose()'" title="关闭"></auth:ListButton>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
      	<div id="list_div_0" style="overflow-x:hidden;overflow-y:auto;">
			<div class="tongyong_box_title">
				<span id="list_div_0_span" style="display:block;text-align:center;">物探市场预测及分布表设备需求</span>
			</div>
			<div id="table_box_0">
				<table  style="table-layout:fixed" width="100%" border="0" cellspacing="0" cellpadding="0"
					class="tab_info" id=queryRetTable_0>
					<tr>
						<td width="10%" class="bt_info_odd"><span class='zj'><a href='javascript:void(0);' onclick='insertDevTr("<%=marketId%>")'  title='添加'></a></span></td>
						<td width="30%" class="bt_info_even">设备类别</td>
						<td width="30%" class="bt_info_odd">规格型号</td>
						<td width="30%" class="bt_info_even">数量</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">
	//设置表格高度
	function frameSize(){
		$("#list_div_0").css("height",$(window).height()-$("#inq_tool_box").height());
	}
	//页面初始化信息
	$(function(){
		frameSize();
		//$(window).resize(function(){
	  		//frameSize();
		//});
		//预测及分布表id
		var marketId="<%=marketId%>";
		//加载表单数据
		loadFormData(marketId);
	});
	//加载表单数据
	function loadFormData(marketId){
		var retObj = jcdpCallService("YearPlanSrv", "getMarketDeviceData","marketId="+marketId);
		if(typeof retObj.datas!="undefined"){
			var data = retObj.datas;
			for(var i=0;i<data.length;i++){
				var ts=insertDevTr(marketId,"old");
				var tData=data[i];
				//遍历data[i]数据，给长期待摊费用表赋值
				$.each(tData, function(i, n){
					if(null!=n && ""!=n){
						$("#queryRetTable_0 #"+i+"_"+ts).val(n);
					}
				});
			}
		}
	}
	//校验数值
	function checkNumber(item){
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(!re.test(item.value)){
			alert("输入必须为整数!");
			item.value = "";
		}
	}
	//添加设备信息行
	function insertDevTr(marketId,old){
		var timestamp=new Date().getTime();//获取时间戳
		var temp = "";
		if(old=="old"){
			temp +="<tr class='old'>";
		}else{
			temp +="<tr class='new'>";
		}
		temp =temp + ("<td><input name='device_id_"+timestamp+"' id='device_id_"+timestamp+"' type='hidden'/>"+
				"<input name='market_id_"+timestamp+"' id='market_id_"+timestamp+"' type='hidden' value='"+marketId+"'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteDevTr(this,"+timestamp+")'/></td>" +
		"<td><input name='dev_ct_code_"+timestamp+"' id='dev_ct_code_"+timestamp+"' type='text' style='height:18px;width:95%;'/></td>"+
		"<td><input name='dev_model_"+timestamp+"' id='dev_model_"+timestamp+"'  type='text' style='height:18px;width:95%;' /></td>"+
		"<td><input name='dev_num_"+timestamp+"' id='dev_num_"+timestamp+"' type='text' onkeyup='checkNumber(this)' style='height:18px;width:95%;'></input></td>"+
		"</tr>");
		$("#queryRetTable_0").append(temp);
		return timestamp; 
	}
	
	//删除设备行行
	function deleteDevTr(item,timestamp){
		//已有的数据
		if($(item).parent().parent().attr("class")=="old"){
			var deviceId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_dev_"+tts+"' value='"+deviceId+"'/>");
		}
		//删除行
		$(item).parent().parent().remove();
	}
	//关闭操作
	function toClose(){
		newClose();
	}
	//提交方法
	function toSubmit(){
		var subForm = $("#form");
		subForm.submit();
	}
</script>
</html>

