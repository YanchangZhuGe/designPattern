<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	//申请单id
	String applyId = request.getParameter("applyId");
	//申请年度
	String applyYear = request.getParameter("applyYear");
	//判断审批是否结束
  	String isDone = request.getParameter("isDone");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/dmsManager/plan/yearPlan/panel.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>非安装设备年度投资建议计划表</title>
</head>

<body style="background:#cdddef"  scroll="no">
	<div id="inq_tool_box">
	<%
		if(isDone == null || !isDone.equals("1")){
	%>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="保存"></auth:ListButton>
						</tr>
					</table>
				</td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			</tr>
		</table>
	<%
		}
	%>
	</div>
	<div id="title_box_0" class="tongyong_box_title">
			<span id="list_div_0_span" style="display:block;text-align:center;">年非安装设备年度投资建议计划表</span>
		</div>
	<form name="form" id="form" method="post" target="hiddenIframe" action="<%=contextPath%>/dms/plan/yearPlan/saveOrUpdateAppNonInfo.srq">
		<!--申请id -->
		<input name="apply_id" id="apply_id" type="hidden"/>
		<div id="table_box_0" style="overflow-x:scroll;overflow-y:auto;">
			<table  style="table-layout:fixed" width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id=queryRetTable_0>
				<tr>
					<td width="30px" class="bt_info_odd">序号</td>
					<td width="100px" class="bt_info_even">设备名称</td>
					<td width="100px" class="bt_info_odd">购置性质</td>
					<td width="100px" class="bt_info_even">规格型号</td>
					<td width="100px" class="bt_info_odd">购置数量</td>
					<td width="100px" class="bt_info_even">审批数量</td>
					<td width="100px" class="bt_info_odd">订货时间</td>
					<td width="100px" class="bt_info_even">到货时间</td>
					<td width="100px" class="bt_info_odd">总投资</td>
					<td width="100px" class="bt_info_even">审批总投资</td>
					<td id="queryRetTable_0_td11" width="100px" class="bt_info_odd">年计划</td>
					<td width="100px" class="bt_info_even">备注</td>
				</tr>
				<tr>
					<td></td>
					<td>合计：</td>
					<td></td>
					<td></td>
					<td id="total_purchase_num" style="color:#F00;">0</td>
					<td id="total_approve_num" style="color:#F00;">0</td>
					<td></td>
					<td></td>
					<td id="ttotal_invest" style="color:#F00;">0</td>
					<td id="total_approve_invest" style="color:#F00;">0</td>
					<td></td>
					<td></td>
				</tr>
			</table>
		</div>
	</form>
	<iframe name="hiddenIframe" style="display:none;"></iframe>
</body>
<script type="text/javascript">
	//设置表格高度
	function frameSize(){
		$("#table_box_0").css("height",$(window).height()-$("#inq_tool_box").height()-$("#title_box_0").height());
	}
	//页面初始化信息
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		//申请单id
		var applyId="<%=applyId%>";
		$("#apply_id").val(applyId);
		//加载表头信息
		loadTableHeaderInfo();
		//加载需求报表信息
		loadUpdateFormData(applyId);
	});
	
	//加载表头信息
	function loadTableHeaderInfo(){
		var curYear="<%=applyYear%>";
		$("#list_div_0_span").text(curYear+"年非安装设备年度投资建议计划表");
		$("queryRetTable_0_td11").text(curYear+"年计划");
	}
	//加载修改表单数据
	function loadUpdateFormData(applyId){
		var tc0_0=0;//非安装设备 购置数量
		var tc0_1=0;//非安装设备 总投资
		var tc0_2=0;//非安装设备 审批购置数量
		var tc0_3=0;//非安装设备 审批总投资
		var retObj = jcdpCallService("YearPlanSrv", "getNoninstallData","applyId="+applyId);
		var data = retObj.datas;
		for(var i=0;i<data.length;i++){
			var ts=insertNonTr("old");
			var tData=data[i];
			//遍历data[i]数据，给长期待摊费用表赋值
			$.each(tData, function(i, n){
				if(null!=n && ""!=n){
					if("apply_id"!=i){
						$("#queryRetTable_0 #"+i+"_"+ts).val(n);
					}
					if("1"=="<%=isDone%>"){
						if("noninstall_id"!=i && "apply_id"!=i){
							$("#queryRetTable_0 #"+i+"_"+ts).parent().append(n);
						}
					}else{
						if("noninstall_id"!=i && "apply_id"!=i && "approve_num"!=i &&"approve_total_invest"!=i){
							$("#queryRetTable_0 #"+i+"_"+ts).parent().append(n);
						}
					}
					//累计购置数量
					if("purchase_num"==i){
						tc0_0=parseInt(tc0_0)+parseInt(n);
					}
					//累计审批购置数量
					if("approve_num"==i){
						tc0_2=parseInt(tc0_2)+parseInt(n);
					}
					//累计总投资
					if("total_invest"==i){
						tc0_1=Math.round((parseFloat(tc0_1)+parseFloat(n))*100)/100;
					}
					//累计审批总投资
					if("approve_total_invest"==i){
						tc0_3=Math.round((parseFloat(tc0_3)+parseFloat(n))*100)/100;
					}
				}
			});
		}
		$("#total_purchase_num").text(tc0_0);//购置数量
		$("#total_approve_num").text(tc0_2);//审批购置数量
		$("#ttotal_invest").text(tc0_1);//总投资
		$("#total_approve_invest").text(tc0_3);//审批购置数量
	}
	
	//计算总计
	function countTotal(item,columnName,isFlag){
		//校验整数
		if("0"==isFlag){
			var re = /^\+?[1-9][0-9]*$/;
			//检查所有的数量字段 
			if(!re.test(item.value)){
				alert("输入必须为整数!");
				item.value = "";
			}
		}
		//校验实数
		if("1"==isFlag){
			var re =/^-?\d+\.?\d{0,2}$/;
			//检查所有的数量字段 
			if(!re.test(item.value)){
				alert("最多请输入两位小数!");
				item.value = "";
			}
		}
		//审批数量
		if("approve_num"==columnName){
			var total_approve_num=0;
			var approve_nums=$("#queryRetTable_0 input[name^='approve_num']");
			if(approve_nums && approve_nums.length>0){
				approve_nums.each(function(i){        
					if(""!=$(this).val()){
						total_approve_num=parseInt(total_approve_num)+parseInt($(this).val());
					}
				});
				$("#total_approve_num").text(total_approve_num);
			}
		}
		//表0总投资
		if("approve_total_invest"==columnName){
			var total_approve_invest=0;
			var approve_total_invests=$("#queryRetTable_0 input[name^='approve_total_invest']");
			if(approve_total_invests && approve_total_invests.length>0){
				approve_total_invests.each(function(i){        
					if(""!=$(this).val()){
						total_approve_invest=Math.round((parseFloat(total_approve_invest)+parseFloat($(this).val()))*100)/100;
					}
				});
				$("#total_approve_invest").text(total_approve_invest);
			}
		}
	}
	//非安装设备年度投资建议计划表序号
	var order = 0;
	//添加非安装设备年度投资建议计划表行
	function insertNonTr(old){
		order++;
		var timestamp=new Date().getTime();//获取时间戳
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+order+"' class='old' tempindex='"+timestamp+"'>";
		}else{
			temp +="<tr id='tr_"+order+"' class='new' tempindex='"+timestamp+"'>";
		}
		if("1"=="<%=isDone%>"){
			temp =temp + ("<td><input name='noninstall_id_"+timestamp+"' id='noninstall_id_"+timestamp+"' type='hidden'/>"+order+"</td> "+
			"<td><input name='dev_name_"+timestamp+"' id='dev_name_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='purchase_property_"+timestamp+"' id='purchase_property_"+timestamp+"'  type='hidden'/></td>"+
			"<td><input name='dev_model_"+timestamp+"' id='dev_model_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='purchase_num_"+timestamp+"' id='purchase_num_"+timestamp+"' type='hidden'/></input></td>"+
			"<td><input name='approve_num_"+timestamp+"' id='approve_num_"+timestamp+"' type='hidden'></input></td>"+
			"<td><input name='order_time_"+timestamp+"' id='order_time_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='arrival_time_"+timestamp+"' id='arrival_time_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='total_invest_"+timestamp+"' id='total_invest_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='approve_total_invest_"+timestamp+"' id='approve_total_invest_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='current_year_plan_"+timestamp+"'  id='current_year_plan_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='remark_"+timestamp+"' id='remark_"+timestamp+"' type='hidden'/></td>"+
			"</tr>");
		}else{
			temp =temp + ("<td><input name='noninstall_id_"+timestamp+"' id='noninstall_id_"+timestamp+"' type='hidden'/>"+order+"</td> "+
			"<td><input name='dev_name_"+timestamp+"' id='dev_name_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='purchase_property_"+timestamp+"' id='purchase_property_"+timestamp+"'  type='hidden'/></td>"+
			"<td><input name='dev_model_"+timestamp+"' id='dev_model_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='purchase_num_"+timestamp+"' id='purchase_num_"+timestamp+"' type='hidden'/></input></td>"+
			"<td><input name='approve_num_"+timestamp+"' id='approve_num_"+timestamp+"' type='text' onkeyup='countTotal(this,\"approve_num\",\"0\")' style='height:18px;width:95%;'></input></td>"+
			"<td><input name='order_time_"+timestamp+"' id='order_time_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='arrival_time_"+timestamp+"' id='arrival_time_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='total_invest_"+timestamp+"' id='total_invest_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='approve_total_invest_"+timestamp+"' id='approve_total_invest_"+timestamp+"' onkeyup='countTotal(this,\"approve_total_invest\",\"1\")' type='text' style='height:18px;width:95%;'/></td>"+
			"<td><input name='current_year_plan_"+timestamp+"'  id='current_year_plan_"+timestamp+"' type='hidden'/></td>"+
			"<td><input name='remark_"+timestamp+"' id='remark_"+timestamp+"' type='hidden'/></td>"+
			"</tr>");
		}
		$("#queryRetTable_0").append(temp);
		return timestamp; 
	}
	//提交方法
	function toSubmit(){
		var subForm = $("#form");
		subForm.submit();
	}
</script>
</html>

