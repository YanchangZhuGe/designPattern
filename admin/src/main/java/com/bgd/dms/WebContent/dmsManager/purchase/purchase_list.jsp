<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String order_num=request.getParameter("order_num");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<title>采购信息列表</title>
</head>

<body style="background:#cdddef">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
					  			
					  			<td class="ali_cdn_name">采购订单：</td>
					  			<td class="ali_cdn_input">
					   				<select id="q_cg_order_type" name="cg_order_type" class="input_select">
										<option value="">请选择</option>
										<option value="Zdb1">设备采购订单</option>
										<option value="Zdb2">设备费用定单</option>
						    		</select>
					  			</td>
								<td class="ali_cdn_name">供应商名称：</td>
				  				<td class="ali_cdn_input">
							   		<input id="q_supplier_name" name="supplier_name" type="text" class="input_width" />
							   	</td>
							  	<td class="ali_cdn_name">采购方式：</td>
					  			<td class="ali_cdn_input">
					   				<select id="q_buy_way" name="buy_way" class="input_select">
										<option value="">请选择</option>
										<option value="FS01">公开招标采购</option>
										<option value="FS02">邀请招标采购</option>
										<option value="FS03">询价采购</option>
										<option value="FS04">竞争性谈判采购</option>
										<option value="FS05">单一来源采购</option>
										<option value="FS06">反向拍卖</option>
										<option value="FS07">目录采购自动匹配</option>
										<option value="FS08">目录采购手工点选</option>
										<option value="FS09">参照目录式采购</option>
										<option value="FS10">框架采购</option>
						    		</select>
					  			</td>
				  				<td class="ali_query">
				   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td style="width:40px;" class="bt_info_odd" exp="<input type='radio' name='rdo_entity_id' value='{cg_apply_id}_{cg_order_num}' id='rdo_entity_id_{cg_apply_id}'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{cg_order_num}">采购订单编号</td>
					<td class="bt_info_even" exp="{cg_order_type_name}">采购订单类型</td>
					<td class="bt_info_odd" exp="{contract_num}">合同号</td>
					<td class="bt_info_even" exp="{batch_plan_num}">批次计划号</td>
					<td class="bt_info_odd" exp="{supplier_num}">供应商编号</td>
					<td class="bt_info_even" exp="{supplier_name}">供应商名称</td>
					<td class="bt_info_odd" exp="{buy_way_name}">采购方式</td>
					<td class="bt_info_even" exp="{isdevice_name}">单据类型</td>
					<td class="bt_info_odd" exp="{emp_name}">创建人</td>
					<td class="bt_info_even" exp="{create_date}">创建日期</td>
					<td class="bt_info_odd" exp="{org_name}">所属单位</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 
						<label>
							<input type="text" name="textfield" id="textfield" style="width:20px;" />
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="####" onclick="getTab(0)">基本信息</a></li>
				<li id="tag3_1"><a href="####" onclick="getTab(1)">单据明细</a></li>
				<li id="tag3_2"><a href="####" onclick="getTab(2)">分配明细</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item6">采购订单编号：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="cg_order_num" name="cg_order_num" class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">采购订单类型：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="cg_order_type_name" name="cg_order_type_name"  class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">合同号：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="contract_num" name="contract_num"  class="input_width main" readonly="readonly"/>
					  	</td>
					</tr>
					<tr>
						<td class="inquire_item6">批次计划号：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="batch_plan_num" name="batch_plan_num" class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">供应商编号：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="supplier_num" name="supplier_num"  class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">供应商名称：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="supplier_name" name="supplier_name"  class="input_width main" readonly="readonly"/>
					  	</td>
					</tr>
					<tr>
						<td class="inquire_item6">采购方式：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="buy_way_name" name="buy_way_name"  class="input_width main" readonly="readonly"/>
					  	</td>
						<td class="inquire_item6">项数：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="item_num" name="item_num" class="input_width main" readonly="readonly"/>
					  	</td>
					  	
					  	<td class="inquire_item6">币种：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="currency" name="currency"  class="input_width main" readonly="readonly"/>
					  	</td>
					</tr>
					<tr>
						<td class="inquire_item6">数量：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="amount" name="amount"  class="input_width main" readonly="readonly"/>
					  	</td>
						<td class="inquire_item6">单据金额：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="bill_money" name="bill_money" class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">单据类型：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="isdevice_name" name="isdevice_name"  class="input_width main" readonly="readonly"/>
					  	</td>
					</tr>
					<tr>
						<td class="inquire_item6">创建人：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="emp_name" name="emp_name" class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">创建日期：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="create_date" name="create_date"  class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">所属单位：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="org_name" name="org_name"  class="input_width main" readonly="readonly"/>
					  	</td>
					</tr>										    				    
				</table>	
			</div>
			<div id="tab_box_content1" class="tab_box_content">
				<iframe width="100%" height="100%" name="list" id="d_list" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
			</div>
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="list" id="a_list" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var order_num=<%=order_num%>
	//流程类型
	var businessType="";
	//流程信息
	var businessInfo="";
	function frameSize(){
		setTabBoxHeight();
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	});
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "PurchaseSrv";
	cruConfig.queryOp = "queryCgApplyList";
	var path = "<%=contextPath%>";
	// 复杂查询
	function refreshData(order_num1,cg_order_type,supplier_name,buy_way){
		var temp = "";
		if(  order_num1!="" && order_num1 !=null){
			temp += "&order_num="+order_num1;
		}
		if(typeof cg_order_type!="undefined" && cg_order_type!=""){
			temp += "&cgOrderType="+cg_order_type;
		}
		if(typeof supplier_name!="undefined" && supplier_name!=""){
			temp += "&supplierName="+supplier_name;
		}
		if(typeof buy_way!="undefined" && buy_way!=""){
			temp += "&buyWay="+buy_way;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	 
	if(order_num!=null && order_num!=""){
	refreshData(order_num,"","","");
	}else{
	refreshData("","","","");
	}
	
	
	//简单查询
	function simpleSearch(){
	 	var q_cg_order_type = $("#q_cg_order_type").val(); 
	    var q_supplier_name = $("#q_supplier_name").val();
		var q_buy_way = $("#q_buy_way").val(); 
		refreshData(q_cg_order_type,q_supplier_name,q_buy_way);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_cg_order_type").value = "";
		document.getElementById("q_supplier_name").value = "";
		document.getElementById("q_buy_way").value = "";
		refreshData("","","");
	}
	
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	
	//点击tab页
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	var selected_id = "";//加载数据时，选中记录id
	var tab_index =0;//tab页索引
	//点击tab,显示具体tab
	function getTab(index){
		tab_index=index;
		getTab3(index);
		$(".tab_box_content").hide();
		$("#tab_box_content"+index).show();
		loadDataDetail(selected_id);
	}
	//加载单条记录的详细信息
	function loadDataDetail(ids){
		selected_id=ids;
		if(0==tab_index){
			var retObj = jcdpCallService("PurchaseSrv", "getCgApplyInfo", "cgApplyId="+ids.split("_")[0]);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
				});
			}
		}
		if(1==tab_index){
			$("#d_list").attr("src","<%=contextPath%>/dmsManager/purchase/purchase_detail_list.jsp?cpApplyId="+ids.split("_")[0]);
		}
		if(2==tab_index){
			$("#a_list").attr("src","<%=contextPath%>/dmsManager/purchase/assign_detail_list.jsp?cpApplyId="+ids.split("_")[1]);
		}
	}
</script>
</html>

