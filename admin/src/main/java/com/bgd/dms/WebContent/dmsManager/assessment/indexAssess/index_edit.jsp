<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String index_info_id=request.getParameter("index_info_id");
	if(null==index_info_id){
		index_info_id="";
	}
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
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>指标上报编辑信息</title>
</head>

<body style="background:#cdddef"  scroll="no">
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/assess/indexAssess/saveOrUpdateIndexAssessInfo.srq?flag=<%=flag%>" >
		<!--指标信息ID -->
		<input name="index_info_id" id="index_info_id" type="hidden"/>
		<!--所属单位 -->
		<input name="org_id" id="org_id" type="hidden"/>
		<!--所属机构隶属单位 -->
		<input name="org_subjection_id" id="org_subjection_id" type="hidden"/>
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">单位：</td>
				  				<td class="ali_cdn_input">
							   		<input id="org_name" name="org_name" type="text" class="input_width" style="width:300px;" readonly="readonly"/>
							  	</td>
							  	<td class="ali_cdn_name">上报日期：</td>
				  				<td class="ali_cdn_input">
							   		<input id="assess_date" name="assess_date" type="text" class="input_width"  style="width:120px;" readonly="readonly" />
					   				<img width="20px" height="20px" id="cal_button" style="cursor: hand;" onmouseover="ymSelector(assess_date,cal_button);" src="<%=contextPath%>/images/calendar.gif" />
							  	</td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="上报"></auth:ListButton>
								<auth:ListButton functionId="" css="gb" event="onclick='toClose()'" title="关闭"></auth:ListButton>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box_0" style="overflow-x:hidden;overflow-y:auto;">
			<table  style="table-layout:fixed" width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id=queryRetTable_0>
				<tr>
					<td width="5%" class="bt_info_odd">序号</td>
					<td width="35%" class="bt_info_even">指标名称</td>
					<td width="20%" class="bt_info_odd">去年实际完成值</td>
					<td width="20%" class="bt_info_even">今年当月累计完成值</td>
					<td width="20%" class="bt_info_odd">今年估算完成值</td>
				</tr>
			</table>
		</div>
	</form>
</body>
<script type="text/javascript">
	//新增修改标志
	var flag="<%=flag%>"; 
	//获取年月
	function getCurrentDate() {
		var dt = new Date();
		var s = dt.getFullYear() + "-";
		var m = dt.getMonth() + 1;
		if (m < 10)
			s += "0" + m;
		else
			s += m;
		return s;
	}
	//设置表格高度
	function frameSize(){
		$("#table_box_0").css("height",$(window).height()-$("#inq_tool_box").height()-$("#title_box_0").height()-5);
	}
	//页面初始化信息
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		//加载数据
		loadDate();
	});
	//加载数据
	function loadDate(){
		var retObj ;
		if("add"==flag){
			//上报日期
			$("#assess_date").val(getCurrentDate());
			retObj = jcdpCallService("IndexAssessSrv", "getAddData","");
		}
		if("update"==flag){
			//隐藏选择日期按钮
			$("#cal_button").hide();
			retObj = jcdpCallService("IndexAssessSrv", "getEditData","index_info_id=<%=index_info_id%>");
		}
		// 新增时 给所属单位 所属机构隶属单位 单位名称 赋值，修改时 给指标信息ID 所属单位 所属机构隶属单位 单位名称 上报日期 赋值
		if(typeof retObj.map!="undefined"){
			var map = retObj.map;
			$.each(map, function(k, v){
				if(null!=v && ""!=v){
					$("#"+k).val(v);
				}
			});
		}	
		//初始化编辑表格并赋值
		if(typeof retObj.datas!="undefined"){
			var datas = retObj.datas;
			for(var i=0;i<datas.length;i++){
				//插入数据,并返回时间戳
				var ts=insertTr();
				var data=datas[i];
				$.each(data, function(k, v){
					if(null!=v && ""!=v){
						$("#queryRetTable_0 #"+k+"_"+ts).val(v);
						//指标名称
						if("index_item_name"==k){
							$("#queryRetTable_0 #"+k+"_"+ts).parent().prev().text(v);
						}
					}
				});
			}
			//修改样式
			changeTable("queryRetTable_0",1,1);
		}	
	}
	
	//指标考核表序号
	var order=1;
	//添加指标考核表行
	function insertTr(){
		var ts=new Date().getTime();//获取时间戳
		var tr_info = "<tr>"+
		"<td>"+order+"</td>"+
		"<td></td>"+
		"<td><input name='index_detail_id_"+ts+"' id='index_detail_id_"+ts+"' type='hidden'/>"+
			"<input name='index_item_name_"+ts+"' id='index_item_name_"+ts+"' type='hidden'/>"+
			"<input name='item_order_"+ts+"' id='item_order_"+ts+"' type='hidden'/>"+
			"<input name='last_year_comp_value_"+ts+"' id='last_year_comp_value_"+ts+"' type='text' style='height:18px;width:95%;' onkeyup='checkNumber(this)' />"+
		"</td>"+
		"<td><input name='curr_month_cumu_value_"+ts+"' id='curr_month_cumu_value_"+ts+"' type='text' style='height:18px;width:95%;' onkeyup='checkNumber(this)' /></td>"+
		"<td><input name='this_year_esti_value_"+ts+"' id='this_year_esti_value_"+ts+"' type='text' style='height:18px;width:95%;' onkeyup='checkNumber(this)' /></td>"+
		"</tr>";
		$("#queryRetTable_0").append(tr_info);
		order++;
		return ts;
	}
	//校验
	function checkNumber(item){
		var re =/^-?\d+\.?\d{0,3}$/;
		//检查所有的数量字段 
		if(!re.test(item.value)){
			alert("最多请输入三位小数!");
			item.value = "";
		}
	}
	//修改表格样式
	function changeTable(id,rowIndex,colIndex){
		var table = document.getElementById(id);
		for(var i =rowIndex ;i<table.rows.length;i++){
			var tr = table.rows[i];
			for(var j =0 ;j<= colIndex;j++){
				tr.cells[j].align ='center';
				tr.cells[j].style.background ='#e3e3e3';
			}
		}
	}
	//提交方法
	function toSubmit(){
		if("add"==flag){
			//获取是否添加数据
			var assess_date=$("#assess_date").val();
			var retObj = jcdpCallService("IndexAssessSrv", "getIsAddData","assess_date="+assess_date);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				if(data.iflag=='0'){
					var subForm = $("#form");
					subForm.submit();
				}else{
					alert("该单位当前年月数据已上报！");
				}
			}
		}else{
			var subForm = $("#form");
			subForm.submit();
		}
		
	}
	//关闭操作
	function toClose(){
		window.location.href='<%=contextPath %>/dmsManager/assessment/indexAssess/index_list.jsp';	
	}
	//选择年月
	function ymSelector(inputField,tributton){    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
	}
</script>
</html>

