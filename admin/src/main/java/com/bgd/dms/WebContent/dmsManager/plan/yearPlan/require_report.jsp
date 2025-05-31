<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	//添加修改标志,默认添加
	String flag = request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	//申请单id
	String applyId = request.getParameter("applyId");
	//申请年度
	String applyYear = request.getParameter("applyYear");
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
	<title>需求报表</title>
</head>

<body style="background:#cdddef"  scroll="no">
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/plan/yearPlan/saveOrUpdateRequireReportInfo.srq?flag=<%=flag%>">
		<!--申请id -->
		<input name="apply_id" id="apply_id" type="hidden"/>
		<!--申请年度 -->
		<input name="apply_year" id="apply_year" type="hidden"/>
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
		<div id="title_box_0" class="tongyong_box_title">
			<span id="list_div_0_span" style="display:block;text-align:center;">年非安装设备年度投资建议计划表</span>
		</div>
		<div id="table_box_0" style="overflow-x:hidden;overflow-y:auto;">
			<table  style="table-layout:fixed" width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id=queryRetTable_0>
				<tr>
					<td width="3%" class="bt_info_odd"></td>
					<td width="3%" class="bt_info_even">序号</td>
					<td width="12%" class="bt_info_odd">设备名称</td>
					<td width="10%" class="bt_info_even">购置性质</td>
					<td width="10%" class="bt_info_odd">规格型号</td>
					<td width="10%" class="bt_info_even">购置数量</td>
					<td width="11%" class="bt_info_odd">订货时间</td>
					<td width="11%" class="bt_info_even">到货时间</td>
					<td width="10%" class="bt_info_odd">总投资</td>
					<td id="queryRetTable_0_td10" width="10%" class="bt_info_even">年计划</td>
					<td width="10%" class="bt_info_odd">备注</td>
				</tr>
				<tr>
					<td class='ali_btn'><span class='zj'><a href='javascript:void(0);' onclick='insertNonTr()'  title='添加'></a></span></td>
					<td></td>
					<td>合计：</td>
					<td></td>
					<td></td>
					<td id="total_purchase_num" style="color:#F00;">0</td>
					<td></td>
					<td></td>
					<td id="ttotal_invest" style="color:#F00;">0</td>
					<td></td>
					<td></td>
				</tr>
			</table>
		</div>
		<div id="title_box_1" class="tongyong_box_title" style="margin-top:5px;">
			<span id="list_div_1_span" style="display:block;text-align:center;">年长期待摊费用表</span>
		</div>
		<div id="table_box_1" style="overflow-x:hidden;overflow-y:auto;">
			<table  style="table-layout:fixed" width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id=queryRetTable_1>
				<tr>
					<td width="5%" class="bt_info_odd" rowspan="2">序号</td>
					<td width="15%" class="bt_info_even" rowspan="2">设备名称</td>
					<td id="queryRetTable_1_td3" width="20%" class="bt_info_odd" colspan="2">年实际</td>
					<td id="queryRetTable_1_td4" width="20%" class="bt_info_even" colspan="2">年预计</td>
					<td id="queryRetTable_1_td5" width="20%" class="bt_info_odd" colspan="2">年预算</td>
					<td width="20%" class="bt_info_even" rowspan="2">备注</td>
				</tr>
				<tr>
					<td class="bt_info_odd">数量</td>
					<td class="bt_info_even">金额</td>
					<td class="bt_info_odd">数量</td>
					<td class="bt_info_even">金额</td>
					<td class="bt_info_odd">数量</td>
					<td class="bt_info_even">金额</td>
				</tr>
				<tr>
					<td></td>
					<td>合计：</td>
					<td id="total_last_year_num" style="color:#F00;">0</td>
					<td id="total_last_year_money" style="color:#F00;">0</td>
					<td id="total_this_year_num" style="color:#F00;">0</td>
					<td id="total_this_year_money" style="color:#F00;">0</td>
					<td id="total_next_year_num" style="color:#F00;">0</td>
					<td id="total_next_year_money" style="color:#F00;">0</td>
					<td></td>
				</tr>
			</table>
		</div>
	</form>
</body>
<script type="text/javascript">
	//设置表格高度
	function frameSize(){
		$("#table_box_0,#table_box_1").css("height",($(window).height()-$("#inq_tool_box").height()-$("#title_box_0").height()-$("#title_box_1").height())/2-8);
	}
	//页面初始化信息
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		//增加修改标志
		var flag="<%=flag%>";
		//申请单id
		var applyId="<%=applyId%>";
		var applyYear="<%=applyYear%>";
		//加载表格标题和表头信息
		loadTableTitleAndHeaderInfo(flag);
		//表单修改时加载需求报表信息
		if("update"==flag){
			$("#apply_id").val(applyId);
			$("#apply_year").val(applyYear);
			loadUpdateFormData(applyId);
		}
		//表单新增时加载长期待摊费用表信息
		if("add"==flag){
			loadAddFormData();
		}
	});
	
	//加载表格标题和表头信息
	function loadTableTitleAndHeaderInfo(flag){
		var curYear="";
		if("add"==flag){
			//获取当前年
			var curDate=new Date(); 
			curYear=curDate.getFullYear(); 
		}else{
			curYear="<%=applyYear%>";
		}
		$("#list_div_0_span").text(curYear+"年非安装设备年度投资建议计划表");
		$("#queryRetTable_0_td10").text(curYear+"年计划");
		$("#list_div_1_span").text(curYear+"年长期待摊费用表");
		$("#queryRetTable_1_td3").text(parseInt(curYear)-1+"年实际");
		$("#queryRetTable_1_td4").text(curYear+"年预计");
		$("#queryRetTable_1_td5").text(parseInt(curYear)+1+"年预算");
		
	}
	//加载修改表单数据
	function loadUpdateFormData(applyId){
		var tc0_0=0;//非安装设备 购置数量
		var tc0_1=0;//非安装设备 总投资
		var tc1_0=0;//长期待摊 实际数量
		var tc1_1=0;//长期待摊 实际金额
		var tc1_2=0;//长期待摊 预计数量
		var tc1_3=0;//长期待摊 预计金额
		var tc1_4=0;//长期待摊 预算数量
		var tc1_5=0;//长期待摊 预算金额
		var retObj = jcdpCallService("YearPlanSrv", "getRequireReportData","applyId="+applyId);
		if(typeof retObj.datas!="undefined"){
			var data = retObj.datas;
			for(var i=0;i<data.length;i++){
				//非安装设备年度投资建议计划表
				if(data[i].noninstal=="true"){
					var ts=insertNonTr("old");
					var tData=data[i];
					//遍历data[i]数据，给长期待摊费用表赋值
					$.each(tData, function(i, n){
						//移除数据标志位
						if("noninstal"!=i){
							if(null!=n && ""!=n){
								$("#queryRetTable_0 #"+i+"_"+ts).val(n);
								//累计购置数量
								if("purchase_num"==i){
									tc0_0=parseInt(tc0_0)+parseInt(n);
								}
								//累计总投资
								if("total_invest"==i){
									tc0_1=Math.round((parseFloat(tc0_1)+parseFloat(n))*100)/100;
								}
							}
						} 
					});
				}
				//长期待摊费用表
				if(data[i].longterm=="true"){
					var ts=insertLonTr();
					var tData=data[i];
					//遍历data[i]数据，给长期待摊费用表赋值
					$.each(tData, function(i, n){
						//移除数据标志位
						if("longterm"!=i){
							if(null!=n && ""!=n){
								//设备名称
								if("dev_name"==i){
									$("#queryRetTable_1 #"+i+"_"+ts).val(n);
									$("#queryRetTable_1 #"+i+"_"+ts).parent().prev().text(n);
								}else{
									$("#queryRetTable_1 #"+i+"_"+ts).val(n);
								}
								//累计上年实际数量
								if("last_year_num"==i){
									tc1_0=parseInt(tc1_0)+parseInt(n);
								}
								//累计上年实际金额
								if("last_year_money"==i){
									tc1_1=Math.round((parseFloat(tc1_1)+parseFloat(n))*100)/100;
								}
								//累计本年预计数量
								if("this_year_num"==i){
									tc1_2=parseInt(tc1_2)+parseInt(n);
								}
								//累计本年预计金额
								if("this_year_money"==i){
									tc1_3=Math.round((parseFloat(tc1_3)+parseFloat(n))*100)/100;
								}
								//累计下年预算数量
								if("next_year_num"==i){
									tc1_4=parseInt(tc1_4)+parseInt(n);
								}
								//累计下年预算金额
								if("next_year_money"==i){
									tc1_5=Math.round((parseFloat(tc1_5)+parseFloat(n))*100)/100;
								}
							}
						} 
					});
				}
			}
			$("#total_purchase_num").text(tc0_0);//表0购置数量
			$("#ttotal_invest").text(tc0_1);//表0总投资
			$("#total_last_year_num").text(tc1_0);//表1实际数量
			$("#total_last_year_money").text(tc1_1);//表1实际金额
			$("#total_this_year_num").text(tc1_2);//表1预计数量
			$("#total_this_year_money").text(tc1_3);//表1预计金额
			$("#total_next_year_num").text(tc1_4);//表1预算数量
			$("#total_next_year_money").text(tc1_5);//表1预算金额
		}
	}
	//加载新增表单数据
	function loadAddFormData(){
		//var data=[{"dev_name":"物探电缆"},{"dev_name":"检波器"},{"dev_name":"交叉线"},{"dev_name":"活动板房"},{"dev_name":"帐篷"},{"dev_name":"其他"}];
		//获取新增长期待摊费用表数据
		var retObj = jcdpCallService("YearPlanSrv", "getAddLongtermData","");
		if(typeof retObj.datas!="undefined"){
			var data = retObj.datas;
			for(var i=0;i<data.length;i++){
				//插入数据,并返回时间戳
				var ts=insertLonTr();
				$("#queryRetTable_1 #dev_name_"+ts).val(data[i]["dev_name"]);
				$("#queryRetTable_1 #dev_name_"+ts).parent().prev().text(data[i]["dev_name"]);
			}
		}	
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
		//表0购置数量
		if("purchase_num"==columnName){
			var total_purchase_num=0;
			var purchase_nums=$("#queryRetTable_0 input[name^='purchase_num']");
			if(purchase_nums && purchase_nums.length>0){
				purchase_nums.each(function(i){        
					if(""!=$(this).val()){
						total_purchase_num=parseInt(total_purchase_num)+parseInt($(this).val());
					}
				});
				$("#total_purchase_num").text(total_purchase_num);
			}
		}
		//表0总投资
		if("total_invest"==columnName){
			var ttotal_invest=0;
			var total_invests=$("#queryRetTable_0 input[name^='total_invest']");
			if(total_invests && total_invests.length>0){
				total_invests.each(function(i){        
					if(""!=$(this).val()){
						ttotal_invest=Math.round((parseFloat(ttotal_invest)+parseFloat($(this).val()))*100)/100;
					}
				});
				$("#ttotal_invest").text(ttotal_invest);
			}
		}
		//表1实际数量
		if("last_year_num"==columnName){
			var total_last_year_num=0;
			var last_year_nums=$("#queryRetTable_1 input[name^='last_year_num']");
			if(last_year_nums && last_year_nums.length>0){
				last_year_nums.each(function(i){        
					if(""!=$(this).val()){
						total_last_year_num=parseInt(total_last_year_num)+parseInt($(this).val());
					}
				});
				$("#total_last_year_num").text(total_last_year_num);
			}
		}
		//表1实际金额
		if("last_year_money"==columnName){
			var total_last_year_money=0;
			var last_year_moneys=$("#queryRetTable_1 input[name^='last_year_money']");
			if(last_year_moneys && last_year_moneys.length>0){
				last_year_moneys.each(function(i){        
					if(""!=$(this).val()){
						total_last_year_money=Math.round((parseFloat(total_last_year_money)+parseFloat($(this).val()))*100)/100;
					}
				});
				$("#total_last_year_money").text(total_last_year_money);
			}
		}
		//表1预计数量
		if("this_year_num"==columnName){
			var total_this_year_num=0;
			var this_year_nums=$("#queryRetTable_1 input[name^='this_year_num']");
			if(this_year_nums && this_year_nums.length>0){
				this_year_nums.each(function(i){        
					if(""!=$(this).val()){
						total_this_year_num=parseInt(total_this_year_num)+parseInt($(this).val());
					}
				});
				$("#total_this_year_num").text(total_this_year_num);
			}
		}
		//表1预计金额
		if("this_year_money"==columnName){
			var total_this_year_money=0;
			var this_year_moneys=$("#queryRetTable_1 input[name^='this_year_money']");
			if(this_year_moneys && this_year_moneys.length>0){
				this_year_moneys.each(function(i){        
					if(""!=$(this).val()){
						total_this_year_money=Math.round((parseFloat(total_this_year_money)+parseFloat($(this).val()))*100)/100;
					}
				});
				$("#total_this_year_money").text(total_this_year_money);
			}
		}
		//表1预算数量
		if("next_year_num"==columnName){
			var total_next_year_num=0;
			var next_year_nums=$("#queryRetTable_1 input[name^='next_year_num']");
			if(next_year_nums && next_year_nums.length>0){
				next_year_nums.each(function(i){        
					if(""!=$(this).val()){
						total_next_year_num=parseInt(total_next_year_num)+parseInt($(this).val());
					}
				});
				$("#total_next_year_num").text(total_next_year_num);
			}
		}
		//表1预算金额
		if("next_year_money"==columnName){
			var total_next_year_money=0;
			var next_year_moneys=$("#queryRetTable_1 input[name^='next_year_money']");
			if(next_year_moneys && next_year_moneys.length>0){
				next_year_moneys.each(function(i){        
					if(""!=$(this).val()){
						total_next_year_money=Math.round((parseFloat(total_next_year_money)+parseFloat($(this).val()))*100)/100;
					}
				});
				$("#total_next_year_money").text(total_next_year_money);
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
		temp =temp + ("<td><input name='noninstall_id_"+timestamp+"' id='noninstall_id_"+timestamp+"' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteNonTr(this,"+timestamp+")'/></td>" +
		"<td>"+order+"</td> "+
		"<td><input name='dev_name_"+timestamp+"' id='dev_name_"+timestamp+"' type='text' style='height:18px;width:95%;'/></td>"+
		"<td><input name='purchase_property_"+timestamp+"' id='purchase_property_"+timestamp+"'  type='text' style='height:18px;width:95%;' /></td>"+
		"<td><input name='dev_model_"+timestamp+"' id='dev_model_"+timestamp+"' type='text' style='height:18px;width:95%;'/></td>"+
		"<td><input name='purchase_num_"+timestamp+"' id='purchase_num_"+timestamp+"' type='text' onkeyup='countTotal(this,\"purchase_num\",\"0\")' style='height:18px;width:95%;'></input></td>"+
		"<td><input name='order_time_"+timestamp+"' id='order_time_"+timestamp+"' type='text' style='height:18px;width:80%;' readonly />"+
			"<img src='<%=contextPath%>/images/calendar.gif' id='date1_"+timestamp+"' width='18' height='18px' style='cursor: hand;' onmouseover='calDateSelector(\"order_time_"+timestamp+"\",\"date1_"+timestamp+"\");'/>"+
		"</td>"+
		"<td><input name='arrival_time_"+timestamp+"' id='arrival_time_"+timestamp+"' type='text' style='height:18px;width:80%;' readonly/>"+
			"<img src='<%=contextPath%>/images/calendar.gif' id='date2_"+timestamp+"' width='18' height='18px' style='cursor: hand;' onmouseover='calDateSelector(\"arrival_time_"+timestamp+"\",\"date2_"+timestamp+"\");'/>"+
		"</td>"+
		"<td><input name='total_invest_"+timestamp+"' id='total_invest_"+timestamp+"' onkeyup='countTotal(this,\"total_invest\",\"1\")' type='text' style='height:18px;width:95%;' /></td>"+
		"<td><input name='current_year_plan_"+timestamp+"'  id='current_year_plan_"+timestamp+"' type='text' style='height:18px;width:95%;'/></td>"+
		"<td><input name='remark_"+timestamp+"' id='remark_"+timestamp+"' type='text' style='height:18px;width:95%;'/></td>"+
		"</tr>");
		$("#queryRetTable_0").append(temp);
		
		/* var sss="<tr><td></td><td></td><td>合计：</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>";
		$("#queryRetTable_0").append(sss); */
		return timestamp; 
	}
	//长期待摊费用表序号
	var lorder=0;
	//添加长期待摊费用表行
	function insertLonTr(){
		var ts=new Date().getTime();//获取时间戳
		var tr_info = "<tr><td>"+(lorder+1)+"</td> "+
		"<td></td>"+
		"<td><input name='longtermp_id_"+ts+"' id='longtermp_id_"+ts+"' type='hidden'/><input name='dev_name_"+ts+"' id='dev_name_"+ts+"' type='hidden'/>"+
		"<input name='last_year_num_"+ts+"' id='last_year_num_"+ts+"' type='text' style='height:18px;width:95%;'  onkeyup='countTotal(this,\"last_year_num\",\"0\")' /></td>"+
		"<td><input name='last_year_money_"+ts+"' id='last_year_money_"+ts+"' type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"last_year_money\",\"1\")' /></td>"+
		"<td><input name='this_year_num_"+ts+"' id='this_year_num_"+ts+"' type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"this_year_num\",\"0\")' /></td>"+
		"<td><input name='this_year_money_"+ts+"' id='this_year_money_"+ts+"' type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"this_year_money\",\"1\")' /></td>"+
		"<td><input name='next_year_num_"+ts+"' id='next_year_num_"+ts+"' type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"next_year_num\",\"0\")' /></td>"+
		"<td><input name='next_year_money_"+ts+"' id='next_year_money_"+ts+"' type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"next_year_money\",\"1\") '/></td>"+
		"<td><input name='remark_"+ts+"' id='remark_"+ts+"' type='text' style='height:18px;width:95%;' /></td>"+
		"</tr>";
		$("#queryRetTable_1").append(tr_info);
		lorder++;
		return ts;
	}
	//删除非安装设备年度投资建议计划表行
	function deleteNonTr(item,timestamp){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var noninstallId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_non_"+tts+"' value='"+noninstallId+"'/>");
		}
		//计算购置数量总量
		var total_purchase_num=$("#total_purchase_num").text();
		var purchase_num_val=$("#purchase_num_"+timestamp).val();
		
		if(""!=purchase_num_val){
			if(null!=total_purchase_num && ""!=total_purchase_num){
				total_purchase_num=parseInt(total_purchase_num)-parseInt(purchase_num_val);
				$("#total_purchase_num").text(total_purchase_num);
			}
		}
		//计算总投资总量
		var ttotal_invest=$("#ttotal_invest").text();
		var total_invest_val=$("#total_invest_"+timestamp).val();
		if(""!=total_invest_val){
			if(null!=ttotal_invest && ""!=ttotal_invest){
				ttotal_invest=Math.round((parseFloat(ttotal_invest)-parseFloat(total_invest_val))*100)/100;
				$("#ttotal_invest").text(ttotal_invest);
			}
		}
		//获取行id
		var temp = $(item).parent().parent().attr("id");
		//删除行
		$(item).parent().parent().remove();
		//序号重新排序
		var _index = parseInt(temp.split("_")[1]);
		for(var j=_index;j<order;j++){
			var order_td = $("#tr_"+(j+1)).children().eq(1);
			order_td.html(j);
			$("#tr_"+(j+1)).attr("id","tr_"+j);
		}
		//索引减一
		order=order-1;
	}
	//关闭操作
	function toClose(){
		window.location.href='<%=contextPath %>/dmsManager/plan/yearPlan/apply_list.jsp';	
	}
	//提交方法
	function toSubmit(){
		var subForm = $("#form");
		subForm.submit();
	}
</script>
</html>

